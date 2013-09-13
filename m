Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644Ab3IMCxG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 22:53:06 -0400
Received: from mail.openrapids.net ([64.15.138.104]:45335 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750974Ab3IMCxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 22:53:00 -0400
Date: Thu, 12 Sep 2013 22:52:53 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, lttng-dev@lists.lttng.org
Subject: [RFC PATCH] Introduce timekeeper latch synchronization
Message-ID: <20130913025253.GA17218@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
[...]
> Yep, that's good. I suppose if there's multiple use sites we can jump
> through another few hoops to get rid of the specific struct foo
> assumptions by storing sizeof() whatever we do use and playing pointer
> math games.
> 
> But for now with the time stuff as only user this looks ok.

OK! Here is the full implementation of the idea against Linux
timekeeper, ntp, and PPS. It appears that ntp and PPS were relying on
the timekeeper seqlock too. And guess what, after booting my laptop with
this kernel there still no smoke coming out of it after a good 5 minutes
of testing. ;-)

Comments are welcome.

The patch applies on top of v3.11 + John Stultz's timekeeper fix
"timekeeping: Fix HRTICK related deadlock from ntp lock changes"

No-way-I'm-signing-this-off-without-proper-testing
---
 include/linux/timekeeper_internal.h |  161 ++++++++++
 kernel/time/ntp.c                   |  544 ++++++++++++++++--------------------
 kernel/time/ntp_internal.h          |   16 -
 kernel/time/timekeeping.c           |  359 +++++++++++++----------
 4 files changed, 621 insertions(+), 459 deletions(-)

diff --git a/include/linux/timekeeper_internal.h b/include/linux/timekeeper_internal.h
index c1825eb..0594815 100644
--- a/include/linux/timekeeper_internal.h
+++ b/include/linux/timekeeper_internal.h
@@ -10,6 +10,85 @@
 #include <linux/jiffies.h>
 #include <linux/time.h>
 
+#ifdef CONFIG_NTP_PPS
+/*
+ * The following variables are used when a pulse-per-second (PPS) signal
+ * is available. They establish the engineering parameters of the clock
+ * discipline loop when controlled by the PPS signal.
+ */
+struct timekeeper_pps {
+	int valid;		/* signal watchdog counter */
+	long tf[3];		/* phase median filter */
+	long jitter;		/* current jitter (ns) */
+	struct timespec fbase;	/* beginning of the last freq interval */
+	int shift;		/* current interval duration (s) (shift) */
+	int intcnt;		/* interval counter */
+	s64 freq;		/* frequency offset (scaled ns/s) */
+	long stabil;		/* current stability (scaled ns/s) */
+
+	/*
+	 * PPS signal quality monitors
+	 */
+	long calcnt;		/* calibration intervals */
+	long jitcnt;		/* jitter limit exceeded */
+	long stbcnt;		/* stability limit exceeded */
+	long errcnt;		/* calibration errors */
+};
+#else /* !CONFIG_NTP_PPS */
+struct timekeeper_pps {
+};
+#endif /* !CONFIG_NTP_PPS */
+
+/* structure holding internal NTP timekeeping values. */
+struct timekeeper_ntp {
+	/* USER_HZ period (usecs): */
+	unsigned long		tick_usec;
+
+	/* SHIFTED_HZ period (nsecs): */
+	unsigned long		tick_nsec;
+
+	u64			tick_length;
+	u64			tick_length_base;
+
+	/* phase-lock loop variables */
+
+	/*
+	 * clock synchronization status
+	 *
+	 * (TIME_ERROR prevents overwriting the CMOS clock)
+	 */
+	int			time_state;
+
+	/* clock status bits: */
+	int			time_status;
+
+	/* time adjustment (nsecs): */
+	s64			time_offset;
+
+	/* pll time constant: */
+	long			time_constant;
+
+	/* maximum error (usecs): */
+	long			time_maxerror;
+
+	/* estimated error (usecs): */
+	long			time_esterror;
+
+	/* frequency offset (scaled nsecs/secs): */
+	s64			time_freq;
+
+	/* time at last adjustment (secs): */
+	long			time_reftime;
+
+	long			time_adjust;
+
+	/* constant (boot-param configurable) NTP tick adjustment (upscaled) */
+	s64			ntp_tick_adj;
+
+	/* PPS variables */
+	struct timekeeper_pps	pps;
+};
+
 /* Structure holding internal timekeeping values. */
 struct timekeeper {
 	/* Current clocksource used for timekeeping. */
@@ -69,8 +148,88 @@ struct timekeeper {
 	/* Offset clock monotonic -> clock tai */
 	ktime_t			offs_tai;
 
+	/* NTP variables */
+	struct timekeeper_ntp	ntp;
 };
 
+struct latch_timekeeper {
+	unsigned long head, tail;
+	struct timekeeper data[2];
+};
+
+extern struct latch_timekeeper latch_timekeeper;
+extern raw_spinlock_t timekeeper_lock;
+
+/**
+ * timekeeper_write_begin - begin timekeeper update.
+ *
+ " @lt: struct latch_timekeeper to update.
+ * @prev: pointer to previous element (output parameter).
+ * @next: pointer to next element (output parameter).
+ *
+ * The area pointed to by "next" should be considered uninitialized.
+ * The caller needs to have exclusive update access to struct latch_timekeeper.
+ */
+static inline
+void timekeeper_write_begin(struct latch_timekeeper *lt,
+		const struct timekeeper **prev,
+		struct timekeeper **next)
+{
+	lt->head++;
+	smp_wmb();	/* Store head before storing into next entry */
+	*prev = &lt->data[lt->tail & 1];
+	*next = &lt->data[lt->head & 1];
+}
+
+/**
+ * timekeeper_write_end - end timekeeper update.
+ *
+ " @lt: struct latch_timekeeper.
+ *
+ * The caller needs to have exclusive update access to struct latch_timekeeper.
+ */
+static inline
+void timekeeper_write_end(struct latch_timekeeper *lt)
+{
+	smp_wmb();	/* Store into next entry before storing into tail */
+	lt->tail++;
+}
+
+/**
+ * timekeeper_read_begin - begin timekeeper read.
+ *
+ " @lt: struct latch_timekeeper to read.
+ * @tail: pointer to unsigned long containing tail position (output).
+ */
+static inline
+struct timekeeper *timekeeper_read_begin(struct latch_timekeeper *lt,
+		unsigned long *tail)
+{
+	unsigned long ret;
+
+	ret = ACCESS_ONCE(lt->tail);
+	smp_rmb();	/* Load tail before loading entry */
+	*tail = ret;
+	return &lt->data[ret & 1];
+}
+
+/**
+ * timekeeper_read_retry - end timekeeper read, trigger retry if needed.
+ *
+ " @lt: struct latch_timekeeper read.
+ * @tail: tail position returned as output by timekeeper_read_begin().
+ *
+ * If timekeeper_read_retry() returns nonzero, the content of the read should
+ * be considered invalid, and the read should be performed again to
+ * reattempt reading coherent data, starting with timekeeper_read_begin().
+ */
+static inline
+int timekeeper_read_retry(struct latch_timekeeper *lt, unsigned long tail)
+{
+	smp_rmb();	/* Load entry before loading head */
+	return (ACCESS_ONCE(lt->head) - tail >= 2);
+}
+
 static inline struct timespec tk_xtime(struct timekeeper *tk)
 {
 	struct timespec ts;
@@ -110,4 +269,6 @@ static inline void update_vsyscall_tz(void)
 }
 #endif
 
+extern struct timekeeper *timekeeper_get_init(void);
+
 #endif /* _LINUX_TIMEKEEPER_INTERNAL_H */
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index bb22151..7215810 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -16,74 +16,17 @@
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/rtc.h>
+#include <linux/timekeeper_internal.h>
 
 #include "tick-internal.h"
 #include "ntp_internal.h"
 
-/*
- * NTP timekeeping variables:
- *
- * Note: All of the NTP state is protected by the timekeeping locks.
- */
-
-
-/* USER_HZ period (usecs): */
-unsigned long			tick_usec = TICK_USEC;
-
-/* SHIFTED_HZ period (nsecs): */
-unsigned long			tick_nsec;
-
-static u64			tick_length;
-static u64			tick_length_base;
-
 #define MAX_TICKADJ		500LL		/* usecs */
 #define MAX_TICKADJ_SCALED \
 	(((MAX_TICKADJ * NSEC_PER_USEC) << NTP_SCALE_SHIFT) / NTP_INTERVAL_FREQ)
 
-/*
- * phase-lock loop variables
- */
-
-/*
- * clock synchronization status
- *
- * (TIME_ERROR prevents overwriting the CMOS clock)
- */
-static int			time_state = TIME_OK;
-
-/* clock status bits:							*/
-static int			time_status = STA_UNSYNC;
-
-/* time adjustment (nsecs):						*/
-static s64			time_offset;
-
-/* pll time constant:							*/
-static long			time_constant = 2;
-
-/* maximum error (usecs):						*/
-static long			time_maxerror = NTP_PHASE_LIMIT;
-
-/* estimated error (usecs):						*/
-static long			time_esterror = NTP_PHASE_LIMIT;
-
-/* frequency offset (scaled nsecs/secs):				*/
-static s64			time_freq;
-
-/* time at last adjustment (secs):					*/
-static long			time_reftime;
-
-static long			time_adjust;
-
-/* constant (boot-param configurable) NTP tick adjustment (upscaled)	*/
-static s64			ntp_tick_adj;
-
 #ifdef CONFIG_NTP_PPS
 
-/*
- * The following variables are used when a pulse-per-second (PPS) signal
- * is available. They establish the engineering parameters of the clock
- * discipline loop when controlled by the PPS signal.
- */
 #define PPS_VALID	10	/* PPS signal watchdog max (s) */
 #define PPS_POPCORN	4	/* popcorn spike threshold (shift) */
 #define PPS_INTMIN	2	/* min freq interval (s) (shift) */
@@ -93,128 +36,110 @@ static s64			ntp_tick_adj;
 				   intervals to decrease it */
 #define PPS_MAXWANDER	100000	/* max PPS freq wander (ns/s) */
 
-static int pps_valid;		/* signal watchdog counter */
-static long pps_tf[3];		/* phase median filter */
-static long pps_jitter;		/* current jitter (ns) */
-static struct timespec pps_fbase; /* beginning of the last freq interval */
-static int pps_shift;		/* current interval duration (s) (shift) */
-static int pps_intcnt;		/* interval counter */
-static s64 pps_freq;		/* frequency offset (scaled ns/s) */
-static long pps_stabil;		/* current stability (scaled ns/s) */
-
-/*
- * PPS signal quality monitors
- */
-static long pps_calcnt;		/* calibration intervals */
-static long pps_jitcnt;		/* jitter limit exceeded */
-static long pps_stbcnt;		/* stability limit exceeded */
-static long pps_errcnt;		/* calibration errors */
-
-
 /* PPS kernel consumer compensates the whole phase error immediately.
  * Otherwise, reduce the offset by a fixed factor times the time constant.
  */
-static inline s64 ntp_offset_chunk(s64 offset)
+static inline s64 ntp_offset_chunk(struct timekeeper_ntp *ntp, s64 offset)
 {
-	if (time_status & STA_PPSTIME && time_status & STA_PPSSIGNAL)
+	if (ntp->time_status & STA_PPSTIME && ntp->time_status & STA_PPSSIGNAL)
 		return offset;
 	else
-		return shift_right(offset, SHIFT_PLL + time_constant);
+		return shift_right(offset, SHIFT_PLL + ntp->time_constant);
 }
 
-static inline void pps_reset_freq_interval(void)
+static inline void pps_reset_freq_interval(struct timekeeper_ntp *ntp)
 {
 	/* the PPS calibration interval may end
 	   surprisingly early */
-	pps_shift = PPS_INTMIN;
-	pps_intcnt = 0;
+	ntp->pps.shift = PPS_INTMIN;
+	ntp->pps.intcnt = 0;
 }
 
 /**
  * pps_clear - Clears the PPS state variables
  */
-static inline void pps_clear(void)
+static inline void pps_clear(struct timekeeper_ntp *ntp)
 {
-	pps_reset_freq_interval();
-	pps_tf[0] = 0;
-	pps_tf[1] = 0;
-	pps_tf[2] = 0;
-	pps_fbase.tv_sec = pps_fbase.tv_nsec = 0;
-	pps_freq = 0;
+	pps_reset_freq_interval(ntp);
+	ntp->pps.tf[0] = 0;
+	ntp->pps.tf[1] = 0;
+	ntp->pps.tf[2] = 0;
+	ntp->pps.fbase.tv_sec = ntp->pps.fbase.tv_nsec = 0;
+	ntp->pps.freq = 0;
 }
 
 /* Decrease pps_valid to indicate that another second has passed since
  * the last PPS signal. When it reaches 0, indicate that PPS signal is
  * missing.
  */
-static inline void pps_dec_valid(void)
+static inline void pps_dec_valid(struct timekeeper_ntp *ntp)
 {
-	if (pps_valid > 0)
-		pps_valid--;
+	if (ntp->pps.valid > 0)
+		ntp->pps.valid--;
 	else {
-		time_status &= ~(STA_PPSSIGNAL | STA_PPSJITTER |
+		ntp->time_status &= ~(STA_PPSSIGNAL | STA_PPSJITTER |
 				 STA_PPSWANDER | STA_PPSERROR);
-		pps_clear();
+		pps_clear(ntp);
 	}
 }
 
-static inline void pps_set_freq(s64 freq)
+static inline void pps_set_freq(struct timekeeper_ntp *ntp, s64 freq)
 {
-	pps_freq = freq;
+	ntp->pps.freq = freq;
 }
 
-static inline int is_error_status(int status)
+static inline int is_error_status(struct timekeeper_ntp *ntp, int status)
 {
-	return (time_status & (STA_UNSYNC|STA_CLOCKERR))
+	return (ntp->time_status & (STA_UNSYNC|STA_CLOCKERR))
 		/* PPS signal lost when either PPS time or
 		 * PPS frequency synchronization requested
 		 */
-		|| ((time_status & (STA_PPSFREQ|STA_PPSTIME))
-			&& !(time_status & STA_PPSSIGNAL))
+		|| ((ntp->time_status & (STA_PPSFREQ|STA_PPSTIME))
+			&& !(ntp->time_status & STA_PPSSIGNAL))
 		/* PPS jitter exceeded when
 		 * PPS time synchronization requested */
-		|| ((time_status & (STA_PPSTIME|STA_PPSJITTER))
+		|| ((ntp->time_status & (STA_PPSTIME|STA_PPSJITTER))
 			== (STA_PPSTIME|STA_PPSJITTER))
 		/* PPS wander exceeded or calibration error when
 		 * PPS frequency synchronization requested
 		 */
-		|| ((time_status & STA_PPSFREQ)
-			&& (time_status & (STA_PPSWANDER|STA_PPSERROR)));
+		|| ((ntp->time_status & STA_PPSFREQ)
+			&& (ntp->time_status & (STA_PPSWANDER|STA_PPSERROR)));
 }
 
-static inline void pps_fill_timex(struct timex *txc)
+static inline void pps_fill_timex(struct timekeeper_ntp *ntp, struct timex *txc)
 {
-	txc->ppsfreq	   = shift_right((pps_freq >> PPM_SCALE_INV_SHIFT) *
+	txc->ppsfreq	   = shift_right((ntp->pps.freq >> PPM_SCALE_INV_SHIFT) *
 					 PPM_SCALE_INV, NTP_SCALE_SHIFT);
-	txc->jitter	   = pps_jitter;
-	if (!(time_status & STA_NANO))
+	txc->jitter	   = ntp->pps.jitter;
+	if (!(ntp->time_status & STA_NANO))
 		txc->jitter /= NSEC_PER_USEC;
-	txc->shift	   = pps_shift;
-	txc->stabil	   = pps_stabil;
-	txc->jitcnt	   = pps_jitcnt;
-	txc->calcnt	   = pps_calcnt;
-	txc->errcnt	   = pps_errcnt;
-	txc->stbcnt	   = pps_stbcnt;
+	txc->shift	   = ntp->pps.shift;
+	txc->stabil	   = ntp->pps.stabil;
+	txc->jitcnt	   = ntp->pps.jitcnt;
+	txc->calcnt	   = ntp->pps.calcnt;
+	txc->errcnt	   = ntp->pps.errcnt;
+	txc->stbcnt	   = ntp->pps.stbcnt;
 }
 
 #else /* !CONFIG_NTP_PPS */
 
-static inline s64 ntp_offset_chunk(s64 offset)
+static inline s64 ntp_offset_chunk(struct timekeeper_ntp *ntp, s64 offset)
 {
-	return shift_right(offset, SHIFT_PLL + time_constant);
+	return shift_right(offset, SHIFT_PLL + ntp->time_constant);
 }
 
-static inline void pps_reset_freq_interval(void) {}
-static inline void pps_clear(void) {}
-static inline void pps_dec_valid(void) {}
-static inline void pps_set_freq(s64 freq) {}
+static inline void pps_reset_freq_interval(struct timekeeper_ntp *ntp) {}
+static inline void pps_clear(struct timekeeper_ntp *ntp) {}
+static inline void pps_dec_valid(struct timekeeper_ntp *ntp) {}
+static inline void pps_set_freq(struct timekeeper_ntp *ntp, s64 freq) {}
 
 static inline int is_error_status(int status)
 {
 	return status & (STA_UNSYNC|STA_CLOCKERR);
 }
 
-static inline void pps_fill_timex(struct timex *txc)
+static inline void pps_fill_timex(struct timekeeper_ntp *ntp, struct timex *txc)
 {
 	/* PPS is not implemented, so these are zero */
 	txc->ppsfreq	   = 0;
@@ -234,9 +159,9 @@ static inline void pps_fill_timex(struct timex *txc)
  * ntp_synced - Returns 1 if the NTP status is not UNSYNC
  *
  */
-static inline int ntp_synced(void)
+static inline int ntp_synced(struct timekeeper_ntp *ntp)
 {
-	return !(time_status & STA_UNSYNC);
+	return !(ntp->time_status & STA_UNSYNC);
 }
 
 
@@ -248,53 +173,54 @@ static inline int ntp_synced(void)
  * Update (tick_length, tick_length_base, tick_nsec), based
  * on (tick_usec, ntp_tick_adj, time_freq):
  */
-static void ntp_update_frequency(void)
+static void ntp_update_frequency(struct timekeeper_ntp *ntp)
 {
 	u64 second_length;
 	u64 new_base;
 
-	second_length		 = (u64)(tick_usec * NSEC_PER_USEC * USER_HZ)
+	second_length		 = (u64)(ntp->tick_usec * NSEC_PER_USEC * USER_HZ)
 						<< NTP_SCALE_SHIFT;
 
-	second_length		+= ntp_tick_adj;
-	second_length		+= time_freq;
+	second_length		+= ntp->ntp_tick_adj;
+	second_length		+= ntp->time_freq;
 
-	tick_nsec		 = div_u64(second_length, HZ) >> NTP_SCALE_SHIFT;
+	ntp->tick_nsec		 = div_u64(second_length, HZ) >> NTP_SCALE_SHIFT;
 	new_base		 = div_u64(second_length, NTP_INTERVAL_FREQ);
 
 	/*
 	 * Don't wait for the next second_overflow, apply
 	 * the change to the tick length immediately:
 	 */
-	tick_length		+= new_base - tick_length_base;
-	tick_length_base	 = new_base;
+	ntp->tick_length	+= new_base - ntp->tick_length_base;
+	ntp->tick_length_base	 = new_base;
 }
 
-static inline s64 ntp_update_offset_fll(s64 offset64, long secs)
+static inline s64 ntp_update_offset_fll(struct timekeeper_ntp *ntp,
+		s64 offset64, long secs)
 {
-	time_status &= ~STA_MODE;
+	ntp->time_status &= ~STA_MODE;
 
 	if (secs < MINSEC)
 		return 0;
 
-	if (!(time_status & STA_FLL) && (secs <= MAXSEC))
+	if (!(ntp->time_status & STA_FLL) && (secs <= MAXSEC))
 		return 0;
 
-	time_status |= STA_MODE;
+	ntp->time_status |= STA_MODE;
 
 	return div64_long(offset64 << (NTP_SCALE_SHIFT - SHIFT_FLL), secs);
 }
 
-static void ntp_update_offset(long offset)
+static void ntp_update_offset(struct timekeeper_ntp *ntp, long offset)
 {
 	s64 freq_adj;
 	s64 offset64;
 	long secs;
 
-	if (!(time_status & STA_PLL))
+	if (!(ntp->time_status & STA_PLL))
 		return;
 
-	if (!(time_status & STA_NANO))
+	if (!(ntp->time_status & STA_NANO))
 		offset *= NSEC_PER_USEC;
 
 	/*
@@ -308,56 +234,56 @@ static void ntp_update_offset(long offset)
 	 * Select how the frequency is to be controlled
 	 * and in which mode (PLL or FLL).
 	 */
-	secs = get_seconds() - time_reftime;
-	if (unlikely(time_status & STA_FREQHOLD))
+	secs = get_seconds() - ntp->time_reftime;
+	if (unlikely(ntp->time_status & STA_FREQHOLD))
 		secs = 0;
 
-	time_reftime = get_seconds();
+	ntp->time_reftime = get_seconds();
 
 	offset64    = offset;
-	freq_adj    = ntp_update_offset_fll(offset64, secs);
+	freq_adj    = ntp_update_offset_fll(ntp, offset64, secs);
 
 	/*
 	 * Clamp update interval to reduce PLL gain with low
 	 * sampling rate (e.g. intermittent network connection)
 	 * to avoid instability.
 	 */
-	if (unlikely(secs > 1 << (SHIFT_PLL + 1 + time_constant)))
-		secs = 1 << (SHIFT_PLL + 1 + time_constant);
+	if (unlikely(secs > 1 << (SHIFT_PLL + 1 + ntp->time_constant)))
+		secs = 1 << (SHIFT_PLL + 1 + ntp->time_constant);
 
 	freq_adj    += (offset64 * secs) <<
-			(NTP_SCALE_SHIFT - 2 * (SHIFT_PLL + 2 + time_constant));
+			(NTP_SCALE_SHIFT - 2 * (SHIFT_PLL + 2 + ntp->time_constant));
 
-	freq_adj    = min(freq_adj + time_freq, MAXFREQ_SCALED);
+	freq_adj    = min(freq_adj + ntp->time_freq, MAXFREQ_SCALED);
 
-	time_freq   = max(freq_adj, -MAXFREQ_SCALED);
+	ntp->time_freq   = max(freq_adj, -MAXFREQ_SCALED);
 
-	time_offset = div_s64(offset64 << NTP_SCALE_SHIFT, NTP_INTERVAL_FREQ);
+	ntp->time_offset = div_s64(offset64 << NTP_SCALE_SHIFT, NTP_INTERVAL_FREQ);
 }
 
 /**
  * ntp_clear - Clears the NTP state variables
  */
-void ntp_clear(void)
+void ntp_clear(struct timekeeper_ntp *ntp)
 {
-	time_adjust	= 0;		/* stop active adjtime() */
-	time_status	|= STA_UNSYNC;
-	time_maxerror	= NTP_PHASE_LIMIT;
-	time_esterror	= NTP_PHASE_LIMIT;
+	ntp->time_adjust	= 0;		/* stop active adjtime() */
+	ntp->time_status	|= STA_UNSYNC;
+	ntp->time_maxerror	= NTP_PHASE_LIMIT;
+	ntp->time_esterror	= NTP_PHASE_LIMIT;
 
-	ntp_update_frequency();
+	ntp_update_frequency(ntp);
 
-	tick_length	= tick_length_base;
-	time_offset	= 0;
+	ntp->tick_length	= ntp->tick_length_base;
+	ntp->time_offset	= 0;
 
 	/* Clear PPS state variables */
-	pps_clear();
+	pps_clear(ntp);
 }
 
 
-u64 ntp_tick_length(void)
+u64 ntp_tick_length(struct timekeeper_ntp *ntp)
 {
-	return tick_length;
+	return ntp->tick_length;
 }
 
 
@@ -371,7 +297,7 @@ u64 ntp_tick_length(void)
  *
  * Also handles leap second processing, and returns leap offset
  */
-int second_overflow(unsigned long secs)
+int second_overflow(struct timekeeper_ntp *ntp, unsigned long secs)
 {
 	s64 delta;
 	int leap = 0;
@@ -381,79 +307,79 @@ int second_overflow(unsigned long secs)
 	 * day, the system clock is set back one second; if in leap-delete
 	 * state, the system clock is set ahead one second.
 	 */
-	switch (time_state) {
+	switch (ntp->time_state) {
 	case TIME_OK:
-		if (time_status & STA_INS)
-			time_state = TIME_INS;
-		else if (time_status & STA_DEL)
-			time_state = TIME_DEL;
+		if (ntp->time_status & STA_INS)
+			ntp->time_state = TIME_INS;
+		else if (ntp->time_status & STA_DEL)
+			ntp->time_state = TIME_DEL;
 		break;
 	case TIME_INS:
-		if (!(time_status & STA_INS))
-			time_state = TIME_OK;
+		if (!(ntp->time_status & STA_INS))
+			ntp->time_state = TIME_OK;
 		else if (secs % 86400 == 0) {
 			leap = -1;
-			time_state = TIME_OOP;
+			ntp->time_state = TIME_OOP;
 			printk(KERN_NOTICE
 				"Clock: inserting leap second 23:59:60 UTC\n");
 		}
 		break;
 	case TIME_DEL:
-		if (!(time_status & STA_DEL))
-			time_state = TIME_OK;
+		if (!(ntp->time_status & STA_DEL))
+			ntp->time_state = TIME_OK;
 		else if ((secs + 1) % 86400 == 0) {
 			leap = 1;
-			time_state = TIME_WAIT;
+			ntp->time_state = TIME_WAIT;
 			printk(KERN_NOTICE
 				"Clock: deleting leap second 23:59:59 UTC\n");
 		}
 		break;
 	case TIME_OOP:
-		time_state = TIME_WAIT;
+		ntp->time_state = TIME_WAIT;
 		break;
 
 	case TIME_WAIT:
-		if (!(time_status & (STA_INS | STA_DEL)))
-			time_state = TIME_OK;
+		if (!(ntp->time_status & (STA_INS | STA_DEL)))
+			ntp->time_state = TIME_OK;
 		break;
 	}
 
 
 	/* Bump the maxerror field */
-	time_maxerror += MAXFREQ / NSEC_PER_USEC;
-	if (time_maxerror > NTP_PHASE_LIMIT) {
-		time_maxerror = NTP_PHASE_LIMIT;
-		time_status |= STA_UNSYNC;
+	ntp->time_maxerror += MAXFREQ / NSEC_PER_USEC;
+	if (ntp->time_maxerror > NTP_PHASE_LIMIT) {
+		ntp->time_maxerror = NTP_PHASE_LIMIT;
+		ntp->time_status |= STA_UNSYNC;
 	}
 
 	/* Compute the phase adjustment for the next second */
-	tick_length	 = tick_length_base;
+	ntp->tick_length	 = ntp->tick_length_base;
 
-	delta		 = ntp_offset_chunk(time_offset);
-	time_offset	-= delta;
-	tick_length	+= delta;
+	delta			 = ntp_offset_chunk(ntp, ntp->time_offset);
+	ntp->time_offset	-= delta;
+	ntp->tick_length	+= delta;
 
 	/* Check PPS signal */
-	pps_dec_valid();
+	pps_dec_valid(ntp);
 
-	if (!time_adjust)
+	if (!ntp->time_adjust)
 		goto out;
 
-	if (time_adjust > MAX_TICKADJ) {
-		time_adjust -= MAX_TICKADJ;
-		tick_length += MAX_TICKADJ_SCALED;
+	if (ntp->time_adjust > MAX_TICKADJ) {
+		ntp->time_adjust -= MAX_TICKADJ;
+		ntp->tick_length += MAX_TICKADJ_SCALED;
 		goto out;
 	}
 
-	if (time_adjust < -MAX_TICKADJ) {
-		time_adjust += MAX_TICKADJ;
-		tick_length -= MAX_TICKADJ_SCALED;
+	if (ntp->time_adjust < -MAX_TICKADJ) {
+		ntp->time_adjust += MAX_TICKADJ;
+		ntp->tick_length -= MAX_TICKADJ_SCALED;
 		goto out;
 	}
 
-	tick_length += (s64)(time_adjust * NSEC_PER_USEC / NTP_INTERVAL_FREQ)
+	ntp->tick_length += (s64)(ntp->time_adjust * NSEC_PER_USEC / NTP_INTERVAL_FREQ)
 							 << NTP_SCALE_SHIFT;
-	time_adjust = 0;
+	ntp->time_adjust = 0;
 
 out:
 	return leap;
@@ -466,8 +392,10 @@ static DECLARE_DELAYED_WORK(sync_cmos_work, sync_cmos_clock);
 
 static void sync_cmos_clock(struct work_struct *work)
 {
+	struct timekeeper *tk;
+	unsigned long seq, local_tick_nsec;
 	struct timespec now, next;
-	int fail = 1;
+	int fail = 1, ret;
 
 	/*
 	 * If we have an externally synchronized Linux clock, then update
@@ -476,7 +404,11 @@ static void sync_cmos_clock(struct work_struct *work)
 	 * This code is run on a timer.  If the clock is set, that timer
 	 * may not expire at the correct time.  Thus, we adjust...
 	 */
-	if (!ntp_synced()) {
+	do {
+		tk = timekeeper_read_begin(&latch_timekeeper, &seq);
+		ret = ntp_synced(&tk->ntp);
+	} while (timekeeper_read_retry(&latch_timekeeper, seq));
+	if (!ret) {
 		/*
 		 * Not synced, exit, do not restart a timer (if one is
 		 * running, let it run out).
@@ -485,7 +417,11 @@ static void sync_cmos_clock(struct work_struct *work)
 	}
 
 	getnstimeofday(&now);
-	if (abs(now.tv_nsec - (NSEC_PER_SEC / 2)) <= tick_nsec / 2) {
+	do {
+		tk = timekeeper_read_begin(&latch_timekeeper, &seq);
+		local_tick_nsec = tk->ntp.tick_nsec;
+	} while (timekeeper_read_retry(&latch_timekeeper, seq));
+	if (abs(now.tv_nsec - (NSEC_PER_SEC / 2)) <= local_tick_nsec / 2) {
 		struct timespec adjust = now;
 
 		fail = -ENODEV;
@@ -513,6 +449,7 @@ static void sync_cmos_clock(struct work_struct *work)
 		next.tv_sec++;
 		next.tv_nsec -= NSEC_PER_SEC;
 	}
+
 	schedule_delayed_work(&sync_cmos_work, timespec_to_jiffies(&next));
 }
 
@@ -529,74 +466,76 @@ void ntp_notify_cmos_timer(void) { }
 /*
  * Propagate a new txc->status value into the NTP state:
  */
-static inline void process_adj_status(struct timex *txc, struct timespec *ts)
+static inline void process_adj_status(struct timekeeper_ntp *ntp,
+		struct timex *txc, struct timespec *ts)
 {
-	if ((time_status & STA_PLL) && !(txc->status & STA_PLL)) {
-		time_state = TIME_OK;
-		time_status = STA_UNSYNC;
+	if ((ntp->time_status & STA_PLL) && !(txc->status & STA_PLL)) {
+		ntp->time_state = TIME_OK;
+		ntp->time_status = STA_UNSYNC;
 		/* restart PPS frequency calibration */
-		pps_reset_freq_interval();
+		pps_reset_freq_interval(ntp);
 	}
 
 	/*
 	 * If we turn on PLL adjustments then reset the
 	 * reference time to current time.
 	 */
-	if (!(time_status & STA_PLL) && (txc->status & STA_PLL))
-		time_reftime = get_seconds();
+	if (!(ntp->time_status & STA_PLL) && (txc->status & STA_PLL))
+		ntp->time_reftime = get_seconds();
 
 	/* only set allowed bits */
-	time_status &= STA_RONLY;
-	time_status |= txc->status & ~STA_RONLY;
+	ntp->time_status &= STA_RONLY;
+	ntp->time_status |= txc->status & ~STA_RONLY;
 }
 
 
-static inline void process_adjtimex_modes(struct timex *txc,
+static inline void process_adjtimex_modes(struct timekeeper_ntp *ntp,
+						struct timex *txc,
 						struct timespec *ts,
 						s32 *time_tai)
 {
 	if (txc->modes & ADJ_STATUS)
-		process_adj_status(txc, ts);
+		process_adj_status(ntp, txc, ts);
 
 	if (txc->modes & ADJ_NANO)
-		time_status |= STA_NANO;
+		ntp->time_status |= STA_NANO;
 
 	if (txc->modes & ADJ_MICRO)
-		time_status &= ~STA_NANO;
+		ntp->time_status &= ~STA_NANO;
 
 	if (txc->modes & ADJ_FREQUENCY) {
-		time_freq = txc->freq * PPM_SCALE;
-		time_freq = min(time_freq, MAXFREQ_SCALED);
-		time_freq = max(time_freq, -MAXFREQ_SCALED);
+		ntp->time_freq = txc->freq * PPM_SCALE;
+		ntp->time_freq = min(ntp->time_freq, MAXFREQ_SCALED);
+		ntp->time_freq = max(ntp->time_freq, -MAXFREQ_SCALED);
 		/* update pps_freq */
-		pps_set_freq(time_freq);
+		pps_set_freq(ntp, ntp->time_freq);
 	}
 
 	if (txc->modes & ADJ_MAXERROR)
-		time_maxerror = txc->maxerror;
+		ntp->time_maxerror = txc->maxerror;
 
 	if (txc->modes & ADJ_ESTERROR)
-		time_esterror = txc->esterror;
+		ntp->time_esterror = txc->esterror;
 
 	if (txc->modes & ADJ_TIMECONST) {
-		time_constant = txc->constant;
-		if (!(time_status & STA_NANO))
-			time_constant += 4;
-		time_constant = min(time_constant, (long)MAXTC);
-		time_constant = max(time_constant, 0l);
+		ntp->time_constant = txc->constant;
+		if (!(ntp->time_status & STA_NANO))
+			ntp->time_constant += 4;
+		ntp->time_constant = min(ntp->time_constant, (long)MAXTC);
+		ntp->time_constant = max(ntp->time_constant, 0l);
 	}
 
 	if (txc->modes & ADJ_TAI && txc->constant > 0)
 		*time_tai = txc->constant;
 
 	if (txc->modes & ADJ_OFFSET)
-		ntp_update_offset(txc->offset);
+		ntp_update_offset(ntp, txc->offset);
 
 	if (txc->modes & ADJ_TICK)
-		tick_usec = txc->tick;
+		ntp->tick_usec = txc->tick;
 
 	if (txc->modes & (ADJ_TICK|ADJ_FREQUENCY|ADJ_OFFSET))
-		ntp_update_frequency();
+		ntp_update_frequency(ntp);
 }
 
 
@@ -638,53 +577,54 @@ int ntp_validate_timex(struct timex *txc)
  * adjtimex mainly allows reading (and writing, if superuser) of
  * kernel time-keeping variables. used by xntpd.
  */
-int __do_adjtimex(struct timex *txc, struct timespec *ts, s32 *time_tai)
+int __do_adjtimex(struct timekeeper_ntp *ntp,
+		struct timex *txc, struct timespec *ts, s32 *time_tai)
 {
 	int result;
 
 	if (txc->modes & ADJ_ADJTIME) {
-		long save_adjust = time_adjust;
+		long save_adjust = ntp->time_adjust;
 
 		if (!(txc->modes & ADJ_OFFSET_READONLY)) {
 			/* adjtime() is independent from ntp_adjtime() */
-			time_adjust = txc->offset;
-			ntp_update_frequency();
+			ntp->time_adjust = txc->offset;
+			ntp_update_frequency(ntp);
 		}
 		txc->offset = save_adjust;
 	} else {
 
 		/* If there are input parameters, then process them: */
 		if (txc->modes)
-			process_adjtimex_modes(txc, ts, time_tai);
+			process_adjtimex_modes(ntp, txc, ts, time_tai);
 
-		txc->offset = shift_right(time_offset * NTP_INTERVAL_FREQ,
+		txc->offset = shift_right(ntp->time_offset * NTP_INTERVAL_FREQ,
 				  NTP_SCALE_SHIFT);
-		if (!(time_status & STA_NANO))
+		if (!(ntp->time_status & STA_NANO))
 			txc->offset /= NSEC_PER_USEC;
 	}
 
-	result = time_state;	/* mostly `TIME_OK' */
+	result = ntp->time_state;	/* mostly `TIME_OK' */
 	/* check for errors */
-	if (is_error_status(time_status))
+	if (is_error_status(ntp->time_status))
 		result = TIME_ERROR;
 
-	txc->freq	   = shift_right((time_freq >> PPM_SCALE_INV_SHIFT) *
+	txc->freq	   = shift_right((ntp->time_freq >> PPM_SCALE_INV_SHIFT) *
 					 PPM_SCALE_INV, NTP_SCALE_SHIFT);
-	txc->maxerror	   = time_maxerror;
-	txc->esterror	   = time_esterror;
-	txc->status	   = time_status;
-	txc->constant	   = time_constant;
+	txc->maxerror	   = ntp->time_maxerror;
+	txc->esterror	   = ntp->time_esterror;
+	txc->status	   = ntp->time_status;
+	txc->constant	   = ntp->time_constant;
 	txc->precision	   = 1;
 	txc->tolerance	   = MAXFREQ_SCALED / PPM_SCALE;
-	txc->tick	   = tick_usec;
+	txc->tick	   = ntp->tick_usec;
 	txc->tai	   = *time_tai;
 
 	/* fill PPS status fields */
-	pps_fill_timex(txc);
+	pps_fill_timex(ntp, txc);
 
 	txc->time.tv_sec = ts->tv_sec;
 	txc->time.tv_usec = ts->tv_nsec;
-	if (!(time_status & STA_NANO))
+	if (!(ntp->time_status & STA_NANO))
 		txc->time.tv_usec /= NSEC_PER_USEC;
 
 	return result;
@@ -719,34 +659,35 @@ static inline struct pps_normtime pps_normalize_ts(struct timespec ts)
 }
 
 /* get current phase correction and jitter */
-static inline long pps_phase_filter_get(long *jitter)
+static inline long pps_phase_filter_get(struct timekeeper_ntp *ntp,
+		long *jitter)
 {
-	*jitter = pps_tf[0] - pps_tf[1];
+	*jitter = ntp->pps.tf[0] - ntp->pps.tf[1];
 	if (*jitter < 0)
 		*jitter = -*jitter;
 
 	/* TODO: test various filters */
-	return pps_tf[0];
+	return ntp->pps.tf[0];
 }
 
 /* add the sample to the phase filter */
-static inline void pps_phase_filter_add(long err)
+static inline void pps_phase_filter_add(struct timekeeper_ntp *ntp, long err)
 {
-	pps_tf[2] = pps_tf[1];
-	pps_tf[1] = pps_tf[0];
-	pps_tf[0] = err;
+	ntp->pps.tf[2] = ntp->pps.tf[1];
+	ntp->pps.tf[1] = ntp->pps.tf[0];
+	ntp->pps.tf[0] = err;
 }
 
 /* decrease frequency calibration interval length.
  * It is halved after four consecutive unstable intervals.
  */
-static inline void pps_dec_freq_interval(void)
+static inline void pps_dec_freq_interval(struct timekeeper_ntp *ntp)
 {
-	if (--pps_intcnt <= -PPS_INTCOUNT) {
-		pps_intcnt = -PPS_INTCOUNT;
-		if (pps_shift > PPS_INTMIN) {
-			pps_shift--;
-			pps_intcnt = 0;
+	if (--ntp->pps.intcnt <= -PPS_INTCOUNT) {
+		ntp->pps.intcnt = -PPS_INTCOUNT;
+		if (ntp->pps.shift > PPS_INTMIN) {
+			ntp->pps.shift--;
+			ntp->pps.intcnt = 0;
 		}
 	}
 }
@@ -754,13 +695,13 @@ static inline void pps_dec_freq_interval(void)
 /* increase frequency calibration interval length.
  * It is doubled after four consecutive stable intervals.
  */
-static inline void pps_inc_freq_interval(void)
+static inline void pps_inc_freq_interval(struct timekeeper_ntp *ntp)
 {
-	if (++pps_intcnt >= PPS_INTCOUNT) {
-		pps_intcnt = PPS_INTCOUNT;
-		if (pps_shift < PPS_INTMAX) {
-			pps_shift++;
-			pps_intcnt = 0;
+	if (++ntp->pps.intcnt >= PPS_INTCOUNT) {
+		ntp->pps.intcnt = PPS_INTCOUNT;
+		if (ntp->pps.shift < PPS_INTMAX) {
+			ntp->pps.shift++;
+			ntp->pps.intcnt = 0;
 		}
 	}
 }
@@ -774,16 +715,17 @@ static inline void pps_inc_freq_interval(void)
  * too long, the data are discarded.
  * Returns the difference between old and new frequency values.
  */
-static long hardpps_update_freq(struct pps_normtime freq_norm)
+static long hardpps_update_freq(struct timekeeper_ntp *ntp,
+		struct pps_normtime freq_norm)
 {
 	long delta, delta_mod;
 	s64 ftemp;
 
 	/* check if the frequency interval was too long */
-	if (freq_norm.sec > (2 << pps_shift)) {
-		time_status |= STA_PPSERROR;
-		pps_errcnt++;
-		pps_dec_freq_interval();
+	if (freq_norm.sec > (2 << ntp->pps.shift)) {
+		ntp->time_status |= STA_PPSERROR;
+		ntp->pps.errcnt++;
+		pps_dec_freq_interval(ntp);
 		pr_err("hardpps: PPSERROR: interval too long - %ld s\n",
 				freq_norm.sec);
 		return 0;
@@ -795,15 +737,15 @@ static long hardpps_update_freq(struct pps_normtime freq_norm)
 	 */
 	ftemp = div_s64(((s64)(-freq_norm.nsec)) << NTP_SCALE_SHIFT,
 			freq_norm.sec);
-	delta = shift_right(ftemp - pps_freq, NTP_SCALE_SHIFT);
-	pps_freq = ftemp;
+	delta = shift_right(ftemp - ntp->pps.freq, NTP_SCALE_SHIFT);
+	ntp->pps.freq = ftemp;
 	if (delta > PPS_MAXWANDER || delta < -PPS_MAXWANDER) {
 		pr_warning("hardpps: PPSWANDER: change=%ld\n", delta);
-		time_status |= STA_PPSWANDER;
-		pps_stbcnt++;
-		pps_dec_freq_interval();
+		ntp->time_status |= STA_PPSWANDER;
+		ntp->pps.stbcnt++;
+		pps_dec_freq_interval(ntp);
 	} else {	/* good sample */
-		pps_inc_freq_interval();
+		pps_inc_freq_interval(ntp);
 	}
 
 	/* the stability metric is calculated as the average of recent
@@ -813,48 +755,48 @@ static long hardpps_update_freq(struct pps_normtime freq_norm)
 	delta_mod = delta;
 	if (delta_mod < 0)
 		delta_mod = -delta_mod;
-	pps_stabil += (div_s64(((s64)delta_mod) <<
+	ntp->pps.stabil += (div_s64(((s64)delta_mod) <<
 				(NTP_SCALE_SHIFT - SHIFT_USEC),
-				NSEC_PER_USEC) - pps_stabil) >> PPS_INTMIN;
+				NSEC_PER_USEC) - ntp->pps.stabil) >> PPS_INTMIN;
 
 	/* if enabled, the system clock frequency is updated */
-	if ((time_status & STA_PPSFREQ) != 0 &&
-	    (time_status & STA_FREQHOLD) == 0) {
-		time_freq = pps_freq;
-		ntp_update_frequency();
+	if ((ntp->time_status & STA_PPSFREQ) != 0 &&
+	    (ntp->time_status & STA_FREQHOLD) == 0) {
+		ntp->time_freq = ntp->pps.freq;
+		ntp_update_frequency(ntp);
 	}
 
 	return delta;
 }
 
 /* correct REALTIME clock phase error against PPS signal */
-static void hardpps_update_phase(long error)
+static void hardpps_update_phase(struct timekeeper_ntp *ntp, long error)
 {
 	long correction = -error;
 	long jitter;
 
 	/* add the sample to the median filter */
-	pps_phase_filter_add(correction);
-	correction = pps_phase_filter_get(&jitter);
+	pps_phase_filter_add(ntp, correction);
+	correction = pps_phase_filter_get(ntp, &jitter);
 
 	/* Nominal jitter is due to PPS signal noise. If it exceeds the
 	 * threshold, the sample is discarded; otherwise, if so enabled,
 	 * the time offset is updated.
 	 */
-	if (jitter > (pps_jitter << PPS_POPCORN)) {
+	if (jitter > (ntp->pps.jitter << PPS_POPCORN)) {
 		pr_warning("hardpps: PPSJITTER: jitter=%ld, limit=%ld\n",
-		       jitter, (pps_jitter << PPS_POPCORN));
-		time_status |= STA_PPSJITTER;
-		pps_jitcnt++;
+		       jitter, (ntp->pps.jitter << PPS_POPCORN));
+		ntp->time_status |= STA_PPSJITTER;
+		ntp->pps.jitcnt++;
 	} else if (time_status & STA_PPSTIME) {
 		/* correct the time using the phase offset */
-		time_offset = div_s64(((s64)correction) << NTP_SCALE_SHIFT,
+		ntp->time_offset = div_s64(((s64)correction) << NTP_SCALE_SHIFT,
 				NTP_INTERVAL_FREQ);
 		/* cancel running adjtime() */
-		time_adjust = 0;
+		ntp->time_adjust = 0;
 	}
 	/* update jitter */
-	pps_jitter += (jitter - pps_jitter) >> PPS_INTMIN;
+	ntp->pps.jitter += (jitter - ntp->pps.jitter) >> PPS_INTMIN;
 }
 
 /*
@@ -869,37 +811,38 @@ static void hardpps_update_phase(long error)
  * This code is based on David Mills's reference nanokernel
  * implementation. It was mostly rewritten but keeps the same idea.
  */
-void __hardpps(const struct timespec *phase_ts, const struct timespec *raw_ts)
+void __hardpps(struct timekeeper_ntp *ntp,
+		const struct timespec *phase_ts, const struct timespec *raw_ts)
 {
 	struct pps_normtime pts_norm, freq_norm;
 
 	pts_norm = pps_normalize_ts(*phase_ts);
 
 	/* clear the error bits, they will be set again if needed */
-	time_status &= ~(STA_PPSJITTER | STA_PPSWANDER | STA_PPSERROR);
+	ntp->time_status &= ~(STA_PPSJITTER | STA_PPSWANDER | STA_PPSERROR);
 
 	/* indicate signal presence */
-	time_status |= STA_PPSSIGNAL;
-	pps_valid = PPS_VALID;
+	ntp->time_status |= STA_PPSSIGNAL;
+	ntp->pps.valid = PPS_VALID;
 
 	/* when called for the first time,
 	 * just start the frequency interval */
-	if (unlikely(pps_fbase.tv_sec == 0)) {
-		pps_fbase = *raw_ts;
+	if (unlikely(ntp->pps.fbase.tv_sec == 0)) {
+		ntp->pps.fbase = *raw_ts;
 		return;
 	}
 
 	/* ok, now we have a base for frequency calculation */
-	freq_norm = pps_normalize_ts(timespec_sub(*raw_ts, pps_fbase));
+	freq_norm = pps_normalize_ts(timespec_sub(*raw_ts, ntp->pps.fbase));
 
 	/* check that the signal is in the range
 	 * [1s - MAXFREQ us, 1s + MAXFREQ us], otherwise reject it */
 	if ((freq_norm.sec == 0) ||
 			(freq_norm.nsec > MAXFREQ * freq_norm.sec) ||
 			(freq_norm.nsec < -MAXFREQ * freq_norm.sec)) {
-		time_status |= STA_PPSJITTER;
+		ntp->time_status |= STA_PPSJITTER;
 		/* restart the frequency calibration interval */
-		pps_fbase = *raw_ts;
+		ntp->pps.fbase = *raw_ts;
 		pr_err("hardpps: PPSJITTER: bad pulse\n");
 		return;
 	}
@@ -907,10 +850,10 @@ void __hardpps(const struct timespec *phase_ts, const struct timespec *raw_ts)
 	/* signal is ok */
 
 	/* check if the current frequency interval is finished */
-	if (freq_norm.sec >= (1 << pps_shift)) {
-		pps_calcnt++;
+	if (freq_norm.sec >= (1 << ntp->pps.shift)) {
+		ntp->pps.calcnt++;
 		/* restart the frequency calibration interval */
-		pps_fbase = *raw_ts;
+		ntp->pps.fbase = *raw_ts;
 		hardpps_update_freq(freq_norm);
 	}
 
@@ -921,15 +864,18 @@ void __hardpps(const struct timespec *phase_ts, const struct timespec *raw_ts)
 
 static int __init ntp_tick_adj_setup(char *str)
 {
-	ntp_tick_adj = simple_strtol(str, NULL, 0);
-	ntp_tick_adj <<= NTP_SCALE_SHIFT;
+	struct timekeeper_ntp *ntp;
+
+	ntp = &timekeeper_get_init()->ntp;
+	ntp->ntp_tick_adj = simple_strtol(str, NULL, 0);
+	ntp->ntp_tick_adj <<= NTP_SCALE_SHIFT;
 
 	return 1;
 }
 
 __setup("ntp_tick_adj=", ntp_tick_adj_setup);
 
-void __init ntp_init(void)
+void __init ntp_init(struct timekeeper_ntp *ntp)
 {
-	ntp_clear();
+	ntp_clear(ntp);
 }
diff --git a/kernel/time/ntp_internal.h b/kernel/time/ntp_internal.h
index 1950cb4..970e260 100644
--- a/kernel/time/ntp_internal.h
+++ b/kernel/time/ntp_internal.h
@@ -1,12 +1,16 @@
 #ifndef _LINUX_NTP_INTERNAL_H
 #define _LINUX_NTP_INTERNAL_H
 
-extern void ntp_init(void);
-extern void ntp_clear(void);
+struct timekeeper_ntp;
+
+extern void ntp_init(struct timekeeper_ntp *ntp);
+extern void ntp_clear(struct timekeeper_ntp *ntp);
 /* Returns how long ticks are at present, in ns / 2^NTP_SCALE_SHIFT. */
-extern u64 ntp_tick_length(void);
-extern int second_overflow(unsigned long secs);
+extern u64 ntp_tick_length(struct timekeeper_ntp *ntp);
+extern int second_overflow(struct timekeeper_ntp *ntp, unsigned long secs);
 extern int ntp_validate_timex(struct timex *);
-extern int __do_adjtimex(struct timex *, struct timespec *, s32 *);
-extern void __hardpps(const struct timespec *, const struct timespec *);
+extern int __do_adjtimex(struct timekeeper_ntp *ntp, struct timex *,
+		struct timespec *, s32 *);
+extern void __hardpps(struct timekeeper_ntp *ntp, const struct timespec *,
+		const struct timespec *);
 #endif /* _LINUX_NTP_INTERNAL_H */
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 947ba25..54857bd 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -28,13 +28,22 @@
 #include "timekeeping_internal.h"
 
 #define TK_CLEAR_NTP		(1 << 0)
-#define TK_MIRROR		(1 << 1)
-#define TK_CLOCK_WAS_SET	(1 << 2)
+#define TK_CLOCK_WAS_SET	(1 << 1)
+
+struct latch_timekeeper latch_timekeeper = {
+	.data[0] = {
+		.ntp = {
+			.tick_usec = TICK_USEC,
+			.time_state = TIME_OK,
+			.time_status = STA_UNSYNC,
+			.time_constant = 2,
+			.time_maxerror = NTP_PHASE_LIMIT,
+			.time_esterror = NTP_PHASE_LIMIT,
+		},
+	},
+};
 
-static struct timekeeper timekeeper;
-static DEFINE_RAW_SPINLOCK(timekeeper_lock);
-static seqcount_t timekeeper_seq;
-static struct timekeeper shadow_timekeeper;
+DEFINE_RAW_SPINLOCK(timekeeper_lock);
 
 /* flag for if timekeeping is suspended */
 int __read_mostly timekeeping_suspended;
@@ -42,6 +51,16 @@ int __read_mostly timekeeping_suspended;
 /* Flag for if there is a persistent clock on this platform */
 bool __read_mostly persistent_clock_exist = false;
 
+/*
+ * timekeeper_get_init - get initial timekeeper structure (boot time init)
+ */
+struct timekeeper *timekeeper_get_init(void)
+{
+	struct latch_timekeeper *lt = &latch_timekeeper;
+
+	return &lt->data[lt->head & 1];
+}
+
 static inline void tk_normalize_xtime(struct timekeeper *tk)
 {
 	while (tk->xtime_nsec >= ((u64)NSEC_PER_SEC << tk->shift)) {
@@ -215,13 +234,17 @@ static void update_pvclock_gtod(struct timekeeper *tk, bool was_set)
  */
 int pvclock_gtod_register_notifier(struct notifier_block *nb)
 {
-	struct timekeeper *tk = &timekeeper;
+	const struct timekeeper *prev;
+	struct timekeeper *tk;
 	unsigned long flags;
 	int ret;
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
+	timekeeper_write_begin(&latch_timekeeper, &prev, &tk);
+	*tk = *prev;
 	ret = raw_notifier_chain_register(&pvclock_gtod_chain, nb);
 	update_pvclock_gtod(tk, true);
+	timekeeper_write_end(&latch_timekeeper);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
 	return ret;
@@ -250,13 +273,10 @@ static void timekeeping_update(struct timekeeper *tk, unsigned int action)
 {
 	if (action & TK_CLEAR_NTP) {
 		tk->ntp_error = 0;
-		ntp_clear();
+		ntp_clear(&tk->ntp);
 	}
 	update_vsyscall(tk);
 	update_pvclock_gtod(tk, action & TK_CLOCK_WAS_SET);
-
-	if (action & TK_MIRROR)
-		memcpy(&shadow_timekeeper, &timekeeper, sizeof(timekeeper));
 }
 
 /**
@@ -297,17 +317,15 @@ static void timekeeping_forward_now(struct timekeeper *tk)
  */
 int __getnstimeofday(struct timespec *ts)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk;
 	unsigned long seq;
 	s64 nsecs = 0;
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
-
+		tk = timekeeper_read_begin(&latch_timekeeper, &seq);
 		ts->tv_sec = tk->xtime_sec;
 		nsecs = timekeeping_get_ns(tk);
-
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (timekeeper_read_retry(&latch_timekeeper, seq));
 
 	ts->tv_nsec = 0;
 	timespec_add_ns(ts, nsecs);
@@ -336,18 +354,17 @@ EXPORT_SYMBOL(getnstimeofday);
 
 ktime_t ktime_get(void)
 {
-	struct timekeeper *tk = &timekeeper;
-	unsigned int seq;
+	struct timekeeper *tk;
+	unsigned long seq;
 	s64 secs, nsecs;
 
 	WARN_ON(timekeeping_suspended);
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
+		tk = timekeeper_read_begin(&latch_timekeeper, &seq);
 		secs = tk->xtime_sec + tk->wall_to_monotonic.tv_sec;
 		nsecs = timekeeping_get_ns(tk) + tk->wall_to_monotonic.tv_nsec;
-
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (timekeeper_read_retry(&latch_timekeeper, seq));
 	/*
 	 * Use ktime_set/ktime_add_ns to create a proper ktime on
 	 * 32-bit architectures without CONFIG_KTIME_SCALAR.
@@ -366,20 +383,19 @@ EXPORT_SYMBOL_GPL(ktime_get);
  */
 void ktime_get_ts(struct timespec *ts)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk;
 	struct timespec tomono;
 	s64 nsec;
-	unsigned int seq;
+	unsigned long seq;
 
 	WARN_ON(timekeeping_suspended);
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
+		tk = timekeeper_read_begin(&latch_timekeeper, &seq);
 		ts->tv_sec = tk->xtime_sec;
 		nsec = timekeeping_get_ns(tk);
 		tomono = tk->wall_to_monotonic;
-
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (timekeeper_read_retry(&latch_timekeeper, seq));
 
 	ts->tv_sec += tomono.tv_sec;
 	ts->tv_nsec = 0;
@@ -396,19 +412,17 @@ EXPORT_SYMBOL_GPL(ktime_get_ts);
  */
 void timekeeping_clocktai(struct timespec *ts)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk;
 	unsigned long seq;
 	u64 nsecs;
 
 	WARN_ON(timekeeping_suspended);
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
-
+		tk = timekeeper_read_begin(&latch_timekeeper, &seq);
 		ts->tv_sec = tk->xtime_sec + tk->tai_offset;
 		nsecs = timekeeping_get_ns(tk);
-
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (timekeeper_read_retry(&latch_timekeeper, seq));
 
 	ts->tv_nsec = 0;
 	timespec_add_ns(ts, nsecs);
@@ -444,14 +458,14 @@ EXPORT_SYMBOL(ktime_get_clocktai);
  */
 void getnstime_raw_and_real(struct timespec *ts_raw, struct timespec *ts_real)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk;
 	unsigned long seq;
 	s64 nsecs_raw, nsecs_real;
 
 	WARN_ON_ONCE(timekeeping_suspended);
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
+		tk = timekeeper_read_begin(&latch_timekeeper, &seq);
 
 		*ts_raw = tk->raw_time;
 		ts_real->tv_sec = tk->xtime_sec;
@@ -460,7 +474,7 @@ void getnstime_raw_and_real(struct timespec *ts_raw, struct timespec *ts_real)
 		nsecs_raw = timekeeping_get_ns_raw(tk);
 		nsecs_real = timekeeping_get_ns(tk);
 
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (timekeeper_read_retry(&latch_timekeeper, seq));
 
 	timespec_add_ns(ts_raw, nsecs_raw);
 	timespec_add_ns(ts_real, nsecs_real);
@@ -493,7 +507,8 @@ EXPORT_SYMBOL(do_gettimeofday);
  */
 int do_settimeofday(const struct timespec *tv)
 {
-	struct timekeeper *tk = &timekeeper;
+	const struct timekeeper *prev;
+	struct timekeeper *tk;
 	struct timespec ts_delta, xt;
 	unsigned long flags;
 
@@ -501,7 +516,8 @@ int do_settimeofday(const struct timespec *tv)
 		return -EINVAL;
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
-	write_seqcount_begin(&timekeeper_seq);
+	timekeeper_write_begin(&latch_timekeeper, &prev, &tk);
+	*tk = *prev;
 
 	timekeeping_forward_now(tk);
 
@@ -513,9 +529,9 @@ int do_settimeofday(const struct timespec *tv)
 
 	tk_set_xtime(tk, tv);
 
-	timekeeping_update(tk, TK_CLEAR_NTP | TK_MIRROR | TK_CLOCK_WAS_SET);
+	timekeeping_update(tk, TK_CLEAR_NTP | TK_CLOCK_WAS_SET);
 
-	write_seqcount_end(&timekeeper_seq);
+	timekeeper_write_end(&latch_timekeeper);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
 	/* signal hrtimers about time change */
@@ -533,7 +549,8 @@ EXPORT_SYMBOL(do_settimeofday);
  */
 int timekeeping_inject_offset(struct timespec *ts)
 {
-	struct timekeeper *tk = &timekeeper;
+	const struct timekeeper *prev;
+	struct timekeeper *tk;
 	unsigned long flags;
 	struct timespec tmp;
 	int ret = 0;
@@ -542,7 +559,8 @@ int timekeeping_inject_offset(struct timespec *ts)
 		return -EINVAL;
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
-	write_seqcount_begin(&timekeeper_seq);
+	timekeeper_write_begin(&latch_timekeeper, &prev, &tk);
+	*tk = *prev;
 
 	timekeeping_forward_now(tk);
 
@@ -557,9 +575,9 @@ int timekeeping_inject_offset(struct timespec *ts)
 	tk_set_wall_to_mono(tk, timespec_sub(tk->wall_to_monotonic, *ts));
 
 error: /* even if we error out, we forwarded the time, so call update */
-	timekeeping_update(tk, TK_CLEAR_NTP | TK_MIRROR | TK_CLOCK_WAS_SET);
+	timekeeping_update(tk, TK_CLEAR_NTP | TK_CLOCK_WAS_SET);
 
-	write_seqcount_end(&timekeeper_seq);
+	timekeeper_write_end(&latch_timekeeper);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
 	/* signal hrtimers about time change */
@@ -576,14 +594,14 @@ EXPORT_SYMBOL(timekeeping_inject_offset);
  */
 s32 timekeeping_get_tai_offset(void)
 {
-	struct timekeeper *tk = &timekeeper;
-	unsigned int seq;
+	struct timekeeper *tk;
+	unsigned long seq;
 	s32 ret;
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
+		tk = timekeeper_read_begin(&latch_timekeeper, &seq);
 		ret = tk->tai_offset;
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (timekeeper_read_retry(&latch_timekeeper, seq));
 
 	return ret;
 }
@@ -604,13 +622,15 @@ static void __timekeeping_set_tai_offset(struct timekeeper *tk, s32 tai_offset)
  */
 void timekeeping_set_tai_offset(s32 tai_offset)
 {
-	struct timekeeper *tk = &timekeeper;
+	const struct timekeeper *prev;
+	struct timekeeper *tk;
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
-	write_seqcount_begin(&timekeeper_seq);
+	timekeeper_write_begin(&latch_timekeeper, &prev, &tk);
+	*tk = *prev;
 	__timekeeping_set_tai_offset(tk, tai_offset);
-	write_seqcount_end(&timekeeper_seq);
+	timekeeper_write_end(&latch_timekeeper);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 	clock_was_set();
 }
@@ -622,14 +642,16 @@ void timekeeping_set_tai_offset(s32 tai_offset)
  */
 static int change_clocksource(void *data)
 {
-	struct timekeeper *tk = &timekeeper;
+	const struct timekeeper *prev;
+	struct timekeeper *tk;
 	struct clocksource *new, *old;
 	unsigned long flags;
 
 	new = (struct clocksource *) data;
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
-	write_seqcount_begin(&timekeeper_seq);
+	timekeeper_write_begin(&latch_timekeeper, &prev, &tk);
+	*tk = *prev;
 
 	timekeeping_forward_now(tk);
 	/*
@@ -647,9 +669,9 @@ static int change_clocksource(void *data)
 			module_put(new->owner);
 		}
 	}
-	timekeeping_update(tk, TK_CLEAR_NTP | TK_MIRROR | TK_CLOCK_WAS_SET);
+	timekeeping_update(tk, TK_CLEAR_NTP | TK_CLOCK_WAS_SET);
 
-	write_seqcount_end(&timekeeper_seq);
+	timekeeper_write_end(&latch_timekeeper);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
 	return 0;
@@ -664,13 +686,25 @@ static int change_clocksource(void *data)
  */
 int timekeeping_notify(struct clocksource *clock)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk;
+	struct clocksource *current_clock;
+	unsigned long seq;
 
-	if (tk->clock == clock)
+	do {
+		tk = timekeeper_read_begin(&latch_timekeeper, &seq);
+		current_clock = tk->clock;
+	} while (timekeeper_read_retry(&latch_timekeeper, seq));
+	if (current_clock == clock)
 		return 0;
+
 	stop_machine(change_clocksource, clock, NULL);
 	tick_clock_notify();
-	return tk->clock == clock ? 0 : -1;
+
+	do {
+		tk = timekeeper_read_begin(&latch_timekeeper, &seq);
+		current_clock = tk->clock;
+	} while (timekeeper_read_retry(&latch_timekeeper, seq));
+	return current_clock == clock ? 0 : -1;
 }
 
 /**
@@ -696,16 +730,15 @@ EXPORT_SYMBOL_GPL(ktime_get_real);
  */
 void getrawmonotonic(struct timespec *ts)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk;
 	unsigned long seq;
 	s64 nsecs;
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
+		tk = timekeeper_read_begin(&latch_timekeeper, &seq);
 		nsecs = timekeeping_get_ns_raw(tk);
 		*ts = tk->raw_time;
-
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (timekeeper_read_retry(&latch_timekeeper, seq));
 
 	timespec_add_ns(ts, nsecs);
 }
@@ -716,16 +749,14 @@ EXPORT_SYMBOL(getrawmonotonic);
  */
 int timekeeping_valid_for_hres(void)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk;
 	unsigned long seq;
 	int ret;
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
-
+		tk = timekeeper_read_begin(&latch_timekeeper, &seq);
 		ret = tk->clock->flags & CLOCK_SOURCE_VALID_FOR_HRES;
-
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (timekeeper_read_retry(&latch_timekeeper, seq));
 
 	return ret;
 }
@@ -735,16 +766,14 @@ int timekeeping_valid_for_hres(void)
  */
 u64 timekeeping_max_deferment(void)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk;
 	unsigned long seq;
 	u64 ret;
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
-
+		tk = timekeeper_read_begin(&latch_timekeeper, &seq);
 		ret = tk->clock->max_idle_ns;
-
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (timekeeper_read_retry(&latch_timekeeper, seq));
 
 	return ret;
 }
@@ -784,7 +813,8 @@ void __attribute__((weak)) read_boot_clock(struct timespec *ts)
  */
 void __init timekeeping_init(void)
 {
-	struct timekeeper *tk = &timekeeper;
+	const struct timekeeper *prev;
+	struct timekeeper *tk;
 	struct clocksource *clock;
 	unsigned long flags;
 	struct timespec now, boot, tmp;
@@ -808,8 +838,9 @@ void __init timekeeping_init(void)
 	}
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
-	write_seqcount_begin(&timekeeper_seq);
-	ntp_init();
+	timekeeper_write_begin(&latch_timekeeper, &prev, &tk);
+	*tk = *prev;
+	ntp_init(&tk->ntp);
 
 	clock = clocksource_default_clock();
 	if (clock->enable)
@@ -829,9 +860,7 @@ void __init timekeeping_init(void)
 	tmp.tv_nsec = 0;
 	tk_set_sleep_time(tk, tmp);
 
-	memcpy(&shadow_timekeeper, &timekeeper, sizeof(timekeeper));
-
-	write_seqcount_end(&timekeeper_seq);
+	timekeeper_write_end(&latch_timekeeper);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 }
 
@@ -871,7 +900,8 @@ static void __timekeeping_inject_sleeptime(struct timekeeper *tk,
  */
 void timekeeping_inject_sleeptime(struct timespec *delta)
 {
-	struct timekeeper *tk = &timekeeper;
+	const struct timekeeper *prev;
+	struct timekeeper *tk;
 	unsigned long flags;
 
 	/*
@@ -882,15 +912,16 @@ void timekeeping_inject_sleeptime(struct timespec *delta)
 		return;
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
-	write_seqcount_begin(&timekeeper_seq);
+	timekeeper_write_begin(&latch_timekeeper, &prev, &tk);
+	*tk = *prev;
 
 	timekeeping_forward_now(tk);
 
 	__timekeeping_inject_sleeptime(tk, delta);
 
-	timekeeping_update(tk, TK_CLEAR_NTP | TK_MIRROR | TK_CLOCK_WAS_SET);
+	timekeeping_update(tk, TK_CLEAR_NTP | TK_CLOCK_WAS_SET);
 
-	write_seqcount_end(&timekeeper_seq);
+	timekeeper_write_end(&latch_timekeeper);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
 	/* signal hrtimers about time change */
@@ -906,8 +937,9 @@ void timekeeping_inject_sleeptime(struct timespec *delta)
  */
 static void timekeeping_resume(void)
 {
-	struct timekeeper *tk = &timekeeper;
-	struct clocksource *clock = tk->clock;
+	const struct timekeeper *prev;
+	struct timekeeper *tk;
+	struct clocksource *clock;
 	unsigned long flags;
 	struct timespec ts_new, ts_delta;
 	cycle_t cycle_now, cycle_delta;
@@ -919,7 +951,9 @@ static void timekeeping_resume(void)
 	clocksource_resume();
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
-	write_seqcount_begin(&timekeeper_seq);
+	timekeeper_write_begin(&latch_timekeeper, &prev, &tk);
+	*tk = *prev;
+	clock = tk->clock;
 
 	/*
 	 * After system resumes, we need to calculate the suspended time and
@@ -970,8 +1004,8 @@ static void timekeeping_resume(void)
 	tk->cycle_last = clock->cycle_last = cycle_now;
 	tk->ntp_error = 0;
 	timekeeping_suspended = 0;
-	timekeeping_update(tk, TK_MIRROR | TK_CLOCK_WAS_SET);
-	write_seqcount_end(&timekeeper_seq);
+	timekeeping_update(tk, TK_CLOCK_WAS_SET);
+	timekeeper_write_end(&latch_timekeeper);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
 	touch_softlockup_watchdog();
@@ -984,7 +1018,8 @@ static void timekeeping_resume(void)
 
 static int timekeeping_suspend(void)
 {
-	struct timekeeper *tk = &timekeeper;
+	const struct timekeeper *prev;
+	struct timekeeper *tk;
 	unsigned long flags;
 	struct timespec		delta, delta_delta;
 	static struct timespec	old_delta;
@@ -1000,7 +1035,8 @@ static int timekeeping_suspend(void)
 		persistent_clock_exist = true;
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
-	write_seqcount_begin(&timekeeper_seq);
+	timekeeper_write_begin(&latch_timekeeper, &prev, &tk);
+	*tk = *prev;
 	timekeeping_forward_now(tk);
 	timekeeping_suspended = 1;
 
@@ -1023,7 +1059,7 @@ static int timekeeping_suspend(void)
 		timekeeping_suspend_time =
 			timespec_add(timekeeping_suspend_time, delta_delta);
 	}
-	write_seqcount_end(&timekeeper_seq);
+	timekeeper_write_end(&latch_timekeeper);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
 	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
@@ -1077,7 +1113,7 @@ static __always_inline int timekeeping_bigadjust(struct timekeeper *tk,
 	 * Now calculate the error in (1 << look_ahead) ticks, but first
 	 * remove the single look ahead already included in the error.
 	 */
-	tick_error = ntp_tick_length() >> (tk->ntp_error_shift + 1);
+	tick_error = ntp_tick_length(&tk->ntp) >> (tk->ntp_error_shift + 1);
 	tick_error -= tk->xtime_interval >> 1;
 	error = ((error - tick_error) >> look_ahead) + tick_error;
 
@@ -1264,7 +1300,7 @@ static inline unsigned int accumulate_nsecs_to_secs(struct timekeeper *tk)
 		tk->xtime_sec++;
 
 		/* Figure out if its a leap sec and apply if needed */
-		leap = second_overflow(tk->xtime_sec);
+		leap = second_overflow(&tk->ntp, tk->xtime_sec);
 		if (unlikely(leap)) {
 			struct timespec ts;
 
@@ -1321,7 +1357,7 @@ static cycle_t logarithmic_accumulation(struct timekeeper *tk, cycle_t offset,
 	tk->raw_time.tv_nsec = raw_nsecs;
 
 	/* Accumulate error between NTP and clock interval */
-	tk->ntp_error += ntp_tick_length() << shift;
+	tk->ntp_error += ntp_tick_length(&tk->ntp) << shift;
 	tk->ntp_error -= (tk->xtime_interval + tk->xtime_remainder) <<
 						(tk->ntp_error_shift + shift);
 
@@ -1362,29 +1398,31 @@ static inline void old_vsyscall_fixup(struct timekeeper *tk)
 static void update_wall_time(void)
 {
 	struct clocksource *clock;
-	struct timekeeper *real_tk = &timekeeper;
-	struct timekeeper *tk = &shadow_timekeeper;
+	const struct timekeeper *prev;
+	struct timekeeper *tk;
 	cycle_t offset;
 	int shift = 0, maxshift;
 	unsigned int action;
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
+	timekeeper_write_begin(&latch_timekeeper, &prev, &tk);
+	*tk = *prev;
 
 	/* Make sure we're fully resumed: */
 	if (unlikely(timekeeping_suspended))
 		goto out;
 
-	clock = real_tk->clock;
+	clock = tk->clock;
 
 #ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
-	offset = real_tk->cycle_interval;
+	offset = tk->cycle_interval;
 #else
 	offset = (clock->read(clock) - clock->cycle_last) & clock->mask;
 #endif
 
 	/* Check if there's really nothing to do */
-	if (offset < real_tk->cycle_interval)
+	if (offset < tk->cycle_interval)
 		goto out;
 
 	/*
@@ -1398,7 +1436,7 @@ static void update_wall_time(void)
 	shift = ilog2(offset) - ilog2(tk->cycle_interval);
 	shift = max(0, shift);
 	/* Bound shift to one less than what overflows tick_length */
-	maxshift = (64 - (ilog2(ntp_tick_length())+1)) - 1;
+	maxshift = (64 - (ilog2(ntp_tick_length(&tk->ntp))+1)) - 1;
 	shift = min(shift, maxshift);
 	while (offset >= tk->cycle_interval) {
 		offset = logarithmic_accumulation(tk, offset, shift);
@@ -1421,23 +1459,10 @@ static void update_wall_time(void)
 	 */
 	action = accumulate_nsecs_to_secs(tk);
 
-	write_seqcount_begin(&timekeeper_seq);
 	/* Update clock->cycle_last with the new value */
 	clock->cycle_last = tk->cycle_last;
-	/*
-	 * Update the real timekeeper.
-	 *
-	 * We could avoid this memcpy by switching pointers, but that
-	 * requires changes to all other timekeeper usage sites as
-	 * well, i.e. move the timekeeper pointer getter into the
-	 * spinlocked/seqcount protected sections. And we trade this
-	 * memcpy under the timekeeper_seq against one before we start
-	 * updating.
-	 */
-	memcpy(real_tk, tk, sizeof(*tk));
-	timekeeping_update(real_tk, action);
-	write_seqcount_end(&timekeeper_seq);
 out:
+	timekeeper_write_end(&latch_timekeeper);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 }
 
@@ -1454,13 +1479,17 @@ out:
  */
 void getboottime(struct timespec *ts)
 {
-	struct timekeeper *tk = &timekeeper;
-	struct timespec boottime = {
-		.tv_sec = tk->wall_to_monotonic.tv_sec +
-				tk->total_sleep_time.tv_sec,
-		.tv_nsec = tk->wall_to_monotonic.tv_nsec +
-				tk->total_sleep_time.tv_nsec
-	};
+	struct timekeeper *tk;
+	struct timespec boottime;
+	unsigned long seq;
+
+	do {
+		tk = timekeeper_read_begin(&latch_timekeeper, &seq);
+		boottime.tv_sec = tk->wall_to_monotonic.tv_sec +
+				tk->total_sleep_time.tv_sec;
+		boottime.tv_nsec = tk->wall_to_monotonic.tv_nsec +
+				tk->total_sleep_time.tv_nsec;
+	} while (timekeeper_read_retry(&latch_timekeeper, seq));
 
 	set_normalized_timespec(ts, -boottime.tv_sec, -boottime.tv_nsec);
 }
@@ -1477,21 +1506,20 @@ EXPORT_SYMBOL_GPL(getboottime);
  */
 void get_monotonic_boottime(struct timespec *ts)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk;
 	struct timespec tomono, sleep;
 	s64 nsec;
-	unsigned int seq;
+	unsigned long seq;
 
 	WARN_ON(timekeeping_suspended);
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
+		tk = timekeeper_read_begin(&latch_timekeeper, &seq);
 		ts->tv_sec = tk->xtime_sec;
 		nsec = timekeeping_get_ns(tk);
 		tomono = tk->wall_to_monotonic;
 		sleep = tk->total_sleep_time;
-
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (timekeeper_read_retry(&latch_timekeeper, seq));
 
 	ts->tv_sec += tomono.tv_sec + sleep.tv_sec;
 	ts->tv_nsec = 0;
@@ -1522,38 +1550,57 @@ EXPORT_SYMBOL_GPL(ktime_get_boottime);
  */
 void monotonic_to_bootbased(struct timespec *ts)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk;
+	struct timespec ret;
+	unsigned long seq;
+
+	do {
+		tk = timekeeper_read_begin(&latch_timekeeper, &seq);
+		ret = timespec_add(*ts, tk->total_sleep_time);
+	} while (timekeeper_read_retry(&latch_timekeeper, seq));
 
-	*ts = timespec_add(*ts, tk->total_sleep_time);
+	*ts = ret;
 }
 EXPORT_SYMBOL_GPL(monotonic_to_bootbased);
 
 unsigned long get_seconds(void)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk;
+	unsigned long seq, ret;
 
-	return tk->xtime_sec;
+	do {
+		tk = timekeeper_read_begin(&latch_timekeeper, &seq);
+		ret = tk->xtime_sec;
+	} while (timekeeper_read_retry(&latch_timekeeper, seq));
+
+	return ret;
 }
 EXPORT_SYMBOL(get_seconds);
 
 struct timespec __current_kernel_time(void)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk;
+	unsigned long seq;
+	struct timespec ret;
 
-	return tk_xtime(tk);
+	do {
+		tk = timekeeper_read_begin(&latch_timekeeper, &seq);
+		ret = tk_xtime(tk);
+	} while (timekeeper_read_retry(&latch_timekeeper, seq));
+
+	return ret;
 }
 
 struct timespec current_kernel_time(void)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk;
 	struct timespec now;
 	unsigned long seq;
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
-
+		tk = timekeeper_read_begin(&latch_timekeeper, &seq);
 		now = tk_xtime(tk);
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (timekeeper_read_retry(&latch_timekeeper, seq));
 
 	return now;
 }
@@ -1561,16 +1608,15 @@ EXPORT_SYMBOL(current_kernel_time);
 
 struct timespec get_monotonic_coarse(void)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk;
 	struct timespec now, mono;
 	unsigned long seq;
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
-
+		tk = timekeeper_read_begin(&latch_timekeeper, &seq);
 		now = tk_xtime(tk);
 		mono = tk->wall_to_monotonic;
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (timekeeper_read_retry(&latch_timekeeper, seq));
 
 	set_normalized_timespec(&now, now.tv_sec + mono.tv_sec,
 				now.tv_nsec + mono.tv_nsec);
@@ -1597,15 +1643,15 @@ void do_timer(unsigned long ticks)
 void get_xtime_and_monotonic_and_sleep_offset(struct timespec *xtim,
 				struct timespec *wtom, struct timespec *sleep)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk;
 	unsigned long seq;
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
+		tk = timekeeper_read_begin(&latch_timekeeper, &seq);
 		*xtim = tk_xtime(tk);
 		*wtom = tk->wall_to_monotonic;
 		*sleep = tk->total_sleep_time;
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (timekeeper_read_retry(&latch_timekeeper, seq));
 }
 
 #ifdef CONFIG_HIGH_RES_TIMERS
@@ -1620,13 +1666,13 @@ void get_xtime_and_monotonic_and_sleep_offset(struct timespec *xtim,
 ktime_t ktime_get_update_offsets(ktime_t *offs_real, ktime_t *offs_boot,
 							ktime_t *offs_tai)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk;
 	ktime_t now;
-	unsigned int seq;
+	unsigned long seq;
 	u64 secs, nsecs;
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
+		tk = timekeeper_read_begin(&latch_timekeeper, &seq);
 
 		secs = tk->xtime_sec;
 		nsecs = timekeeping_get_ns(tk);
@@ -1634,7 +1680,7 @@ ktime_t ktime_get_update_offsets(ktime_t *offs_real, ktime_t *offs_boot,
 		*offs_real = tk->offs_real;
 		*offs_boot = tk->offs_boot;
 		*offs_tai = tk->offs_tai;
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (timekeeper_read_retry(&latch_timekeeper, seq));
 
 	now = ktime_add_ns(ktime_set(secs, 0), nsecs);
 	now = ktime_sub(now, *offs_real);
@@ -1647,14 +1693,14 @@ ktime_t ktime_get_update_offsets(ktime_t *offs_real, ktime_t *offs_boot,
  */
 ktime_t ktime_get_monotonic_offset(void)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk;
 	unsigned long seq;
 	struct timespec wtom;
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
+		tk = timekeeper_read_begin(&latch_timekeeper, &seq);
 		wtom = tk->wall_to_monotonic;
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (timekeeper_read_retry(&latch_timekeeper, seq));
 
 	return timespec_to_ktime(wtom);
 }
@@ -1665,7 +1711,8 @@ EXPORT_SYMBOL_GPL(ktime_get_monotonic_offset);
  */
 int do_adjtimex(struct timex *txc)
 {
-	struct timekeeper *tk = &timekeeper;
+	const struct timekeeper *prev;
+	struct timekeeper *tk;
 	unsigned long flags;
 	struct timespec ts;
 	s32 orig_tai, tai;
@@ -1690,17 +1737,18 @@ int do_adjtimex(struct timex *txc)
 	getnstimeofday(&ts);
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
-	write_seqcount_begin(&timekeeper_seq);
+	timekeeper_write_begin(&latch_timekeeper, &prev, &tk);
+	*tk = *prev;
 
 	orig_tai = tai = tk->tai_offset;
-	ret = __do_adjtimex(txc, &ts, &tai);
+	ret = __do_adjtimex(&tk->ntp, txc, &ts, &tai);
 
 	if (tai != orig_tai) {
 		__timekeeping_set_tai_offset(tk, tai);
 		update_pvclock_gtod(tk, true);
 		clock_was_set_delayed();
 	}
-	write_seqcount_end(&timekeeper_seq);
+	timekeeper_write_end(&latch_timekeeper);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
 	ntp_notify_cmos_timer();
@@ -1714,14 +1762,17 @@ int do_adjtimex(struct timex *txc)
  */
 void hardpps(const struct timespec *phase_ts, const struct timespec *raw_ts)
 {
+	const struct timekeeper *prev;
+	struct timekeeper *tk;
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
-	write_seqcount_begin(&timekeeper_seq);
+	timekeeper_write_begin(&latch_timekeeper, &prev, &tk);
+	*tk = *prev;
 
-	__hardpps(phase_ts, raw_ts);
+	__hardpps(&tk->ntp, phase_ts, raw_ts);
 
-	write_seqcount_end(&timekeeper_seq);
+	timekeeper_write_end(&latch_timekeeper);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 }
 EXPORT_SYMBOL(hardpps);


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
