Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932413Ab3INTsi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 15:48:38 -0400
Received: from mail.openrapids.net ([64.15.138.104]:47114 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932242Ab3INTsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 15:48:37 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH 1/7] Move ntp variables into struct timekeeper_ntp
Date: Sat, 14 Sep 2013 12:47:55 -0700
Message-Id: <1379188081-15613-2-git-send-email-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1379188081-15613-1-git-send-email-mathieu.desnoyers@efficios.com>
References: <1379188081-15613-1-git-send-email-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 include/linux/timekeeper_internal.h |   47 ++++++
 kernel/time/ntp.c                   |  318 +++++++++++++++--------------------
 2 files changed, 187 insertions(+), 178 deletions(-)

diff --git a/include/linux/timekeeper_internal.h b/include/linux/timekeeper_internal.h
index c1825eb..eab26e0 100644
--- a/include/linux/timekeeper_internal.h
+++ b/include/linux/timekeeper_internal.h
@@ -10,6 +10,53 @@
 #include <linux/jiffies.h>
 #include <linux/time.h>
 
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
+};
+
 /* Structure holding internal timekeeping values. */
 struct timekeeper {
 	/* Current clocksource used for timekeeping. */
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index bb22151..983c212 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -16,66 +16,23 @@
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
+static struct timekeeper_ntp tk_ntp = {
+	.tick_usec = TICK_USEC,
+	.time_state = TIME_OK,
+	.time_status = STA_UNSYNC,
+	.time_constant = 2,
+	.time_maxerror = NTP_PHASE_LIMIT,
+	.time_esterror = NTP_PHASE_LIMIT,
+};
 
 #ifdef CONFIG_NTP_PPS
 
@@ -116,10 +73,11 @@ static long pps_errcnt;		/* calibration errors */
  */
 static inline s64 ntp_offset_chunk(s64 offset)
 {
-	if (time_status & STA_PPSTIME && time_status & STA_PPSSIGNAL)
+	if (tk_ntp.time_status & STA_PPSTIME
+			&& tk_ntp.time_status & STA_PPSSIGNAL)
 		return offset;
 	else
-		return shift_right(offset, SHIFT_PLL + time_constant);
+		return shift_right(offset, SHIFT_PLL + tk_ntp.time_constant);
 }
 
 static inline void pps_reset_freq_interval(void)
@@ -152,7 +110,7 @@ static inline void pps_dec_valid(void)
 	if (pps_valid > 0)
 		pps_valid--;
 	else {
-		time_status &= ~(STA_PPSSIGNAL | STA_PPSJITTER |
+		tk_ntp.time_status &= ~(STA_PPSSIGNAL | STA_PPSJITTER |
 				 STA_PPSWANDER | STA_PPSERROR);
 		pps_clear();
 	}
@@ -165,21 +123,21 @@ static inline void pps_set_freq(s64 freq)
 
 static inline int is_error_status(int status)
 {
-	return (time_status & (STA_UNSYNC|STA_CLOCKERR))
+	return (tk_ntp.time_status & (STA_UNSYNC|STA_CLOCKERR))
 		/* PPS signal lost when either PPS time or
 		 * PPS frequency synchronization requested
 		 */
-		|| ((time_status & (STA_PPSFREQ|STA_PPSTIME))
-			&& !(time_status & STA_PPSSIGNAL))
+		|| ((tk_ntp.time_status & (STA_PPSFREQ|STA_PPSTIME))
+			&& !(tk_ntp.time_status & STA_PPSSIGNAL))
 		/* PPS jitter exceeded when
 		 * PPS time synchronization requested */
-		|| ((time_status & (STA_PPSTIME|STA_PPSJITTER))
+		|| ((tk_ntp.time_status & (STA_PPSTIME|STA_PPSJITTER))
 			== (STA_PPSTIME|STA_PPSJITTER))
 		/* PPS wander exceeded or calibration error when
 		 * PPS frequency synchronization requested
 		 */
-		|| ((time_status & STA_PPSFREQ)
-			&& (time_status & (STA_PPSWANDER|STA_PPSERROR)));
+		|| ((tk_ntp.time_status & STA_PPSFREQ)
+			&& (tk_ntp.time_status & (STA_PPSWANDER|STA_PPSERROR)));
 }
 
 static inline void pps_fill_timex(struct timex *txc)
@@ -187,7 +145,7 @@ static inline void pps_fill_timex(struct timex *txc)
 	txc->ppsfreq	   = shift_right((pps_freq >> PPM_SCALE_INV_SHIFT) *
 					 PPM_SCALE_INV, NTP_SCALE_SHIFT);
 	txc->jitter	   = pps_jitter;
-	if (!(time_status & STA_NANO))
+	if (!(tk_ntp.time_status & STA_NANO))
 		txc->jitter /= NSEC_PER_USEC;
 	txc->shift	   = pps_shift;
 	txc->stabil	   = pps_stabil;
@@ -201,7 +159,7 @@ static inline void pps_fill_timex(struct timex *txc)
 
 static inline s64 ntp_offset_chunk(s64 offset)
 {
-	return shift_right(offset, SHIFT_PLL + time_constant);
+	return shift_right(offset, SHIFT_PLL + tk_ntp.time_constant);
 }
 
 static inline void pps_reset_freq_interval(void) {}
@@ -236,7 +194,7 @@ static inline void pps_fill_timex(struct timex *txc)
  */
 static inline int ntp_synced(void)
 {
-	return !(time_status & STA_UNSYNC);
+	return !(tk_ntp.time_status & STA_UNSYNC);
 }
 
 
@@ -245,42 +203,42 @@ static inline int ntp_synced(void)
  */
 
 /*
- * Update (tick_length, tick_length_base, tick_nsec), based
- * on (tick_usec, ntp_tick_adj, time_freq):
+ * Update (tk_ntp.tick_length, tk_ntp.tick_length_base, tk_ntp.tick_nsec),
+ * based on (tk_ntp.tick_usec, tk_ntp.ntp_tick_adj, tk_ntp.time_freq):
  */
 static void ntp_update_frequency(void)
 {
 	u64 second_length;
 	u64 new_base;
 
-	second_length		 = (u64)(tick_usec * NSEC_PER_USEC * USER_HZ)
+	second_length = (u64)(tk_ntp.tick_usec * NSEC_PER_USEC * USER_HZ)
 						<< NTP_SCALE_SHIFT;
 
-	second_length		+= ntp_tick_adj;
-	second_length		+= time_freq;
+	second_length += tk_ntp.ntp_tick_adj;
+	second_length += tk_ntp.time_freq;
 
-	tick_nsec		 = div_u64(second_length, HZ) >> NTP_SCALE_SHIFT;
-	new_base		 = div_u64(second_length, NTP_INTERVAL_FREQ);
+	tk_ntp.tick_nsec = div_u64(second_length, HZ) >> NTP_SCALE_SHIFT;
+	new_base = div_u64(second_length, NTP_INTERVAL_FREQ);
 
 	/*
 	 * Don't wait for the next second_overflow, apply
 	 * the change to the tick length immediately:
 	 */
-	tick_length		+= new_base - tick_length_base;
-	tick_length_base	 = new_base;
+	tk_ntp.tick_length += new_base - tk_ntp.tick_length_base;
+	tk_ntp.tick_length_base = new_base;
 }
 
 static inline s64 ntp_update_offset_fll(s64 offset64, long secs)
 {
-	time_status &= ~STA_MODE;
+	tk_ntp.time_status &= ~STA_MODE;
 
 	if (secs < MINSEC)
 		return 0;
 
-	if (!(time_status & STA_FLL) && (secs <= MAXSEC))
+	if (!(tk_ntp.time_status & STA_FLL) && (secs <= MAXSEC))
 		return 0;
 
-	time_status |= STA_MODE;
+	tk_ntp.time_status |= STA_MODE;
 
 	return div64_long(offset64 << (NTP_SCALE_SHIFT - SHIFT_FLL), secs);
 }
@@ -291,10 +249,10 @@ static void ntp_update_offset(long offset)
 	s64 offset64;
 	long secs;
 
-	if (!(time_status & STA_PLL))
+	if (!(tk_ntp.time_status & STA_PLL))
 		return;
 
-	if (!(time_status & STA_NANO))
+	if (!(tk_ntp.time_status & STA_NANO))
 		offset *= NSEC_PER_USEC;
 
 	/*
@@ -308,11 +266,11 @@ static void ntp_update_offset(long offset)
 	 * Select how the frequency is to be controlled
 	 * and in which mode (PLL or FLL).
 	 */
-	secs = get_seconds() - time_reftime;
-	if (unlikely(time_status & STA_FREQHOLD))
+	secs = get_seconds() - tk_ntp.time_reftime;
+	if (unlikely(tk_ntp.time_status & STA_FREQHOLD))
 		secs = 0;
 
-	time_reftime = get_seconds();
+	tk_ntp.time_reftime = get_seconds();
 
 	offset64    = offset;
 	freq_adj    = ntp_update_offset_fll(offset64, secs);
@@ -322,17 +280,18 @@ static void ntp_update_offset(long offset)
 	 * sampling rate (e.g. intermittent network connection)
 	 * to avoid instability.
 	 */
-	if (unlikely(secs > 1 << (SHIFT_PLL + 1 + time_constant)))
-		secs = 1 << (SHIFT_PLL + 1 + time_constant);
+	if (unlikely(secs > 1 << (SHIFT_PLL + 1 + tk_ntp.time_constant)))
+		secs = 1 << (SHIFT_PLL + 1 + tk_ntp.time_constant);
 
 	freq_adj    += (offset64 * secs) <<
-			(NTP_SCALE_SHIFT - 2 * (SHIFT_PLL + 2 + time_constant));
+		(NTP_SCALE_SHIFT - 2 * (SHIFT_PLL + 2 + tk_ntp.time_constant));
 
-	freq_adj    = min(freq_adj + time_freq, MAXFREQ_SCALED);
+	freq_adj    = min(freq_adj + tk_ntp.time_freq, MAXFREQ_SCALED);
 
-	time_freq   = max(freq_adj, -MAXFREQ_SCALED);
+	tk_ntp.time_freq   = max(freq_adj, -MAXFREQ_SCALED);
 
-	time_offset = div_s64(offset64 << NTP_SCALE_SHIFT, NTP_INTERVAL_FREQ);
+	tk_ntp.time_offset = div_s64(offset64 << NTP_SCALE_SHIFT,
+		NTP_INTERVAL_FREQ);
 }
 
 /**
@@ -340,15 +299,15 @@ static void ntp_update_offset(long offset)
  */
 void ntp_clear(void)
 {
-	time_adjust	= 0;		/* stop active adjtime() */
-	time_status	|= STA_UNSYNC;
-	time_maxerror	= NTP_PHASE_LIMIT;
-	time_esterror	= NTP_PHASE_LIMIT;
+	tk_ntp.time_adjust	= 0;		/* stop active adjtime() */
+	tk_ntp.time_status	|= STA_UNSYNC;
+	tk_ntp.time_maxerror	= NTP_PHASE_LIMIT;
+	tk_ntp.time_esterror	= NTP_PHASE_LIMIT;
 
 	ntp_update_frequency();
 
-	tick_length	= tick_length_base;
-	time_offset	= 0;
+	tk_ntp.tick_length	= tk_ntp.tick_length_base;
+	tk_ntp.time_offset	= 0;
 
 	/* Clear PPS state variables */
 	pps_clear();
@@ -357,7 +316,7 @@ void ntp_clear(void)
 
 u64 ntp_tick_length(void)
 {
-	return tick_length;
+	return tk_ntp.tick_length;
 }
 
 
@@ -381,79 +340,80 @@ int second_overflow(unsigned long secs)
 	 * day, the system clock is set back one second; if in leap-delete
 	 * state, the system clock is set ahead one second.
 	 */
-	switch (time_state) {
+	switch (tk_ntp.time_state) {
 	case TIME_OK:
-		if (time_status & STA_INS)
-			time_state = TIME_INS;
-		else if (time_status & STA_DEL)
-			time_state = TIME_DEL;
+		if (tk_ntp.time_status & STA_INS)
+			tk_ntp.time_state = TIME_INS;
+		else if (tk_ntp.time_status & STA_DEL)
+			tk_ntp.time_state = TIME_DEL;
 		break;
 	case TIME_INS:
-		if (!(time_status & STA_INS))
-			time_state = TIME_OK;
+		if (!(tk_ntp.time_status & STA_INS))
+			tk_ntp.time_state = TIME_OK;
 		else if (secs % 86400 == 0) {
 			leap = -1;
-			time_state = TIME_OOP;
+			tk_ntp.time_state = TIME_OOP;
 			printk(KERN_NOTICE
 				"Clock: inserting leap second 23:59:60 UTC\n");
 		}
 		break;
 	case TIME_DEL:
-		if (!(time_status & STA_DEL))
-			time_state = TIME_OK;
+		if (!(tk_ntp.time_status & STA_DEL))
+			tk_ntp.time_state = TIME_OK;
 		else if ((secs + 1) % 86400 == 0) {
 			leap = 1;
-			time_state = TIME_WAIT;
+			tk_ntp.time_state = TIME_WAIT;
 			printk(KERN_NOTICE
 				"Clock: deleting leap second 23:59:59 UTC\n");
 		}
 		break;
 	case TIME_OOP:
-		time_state = TIME_WAIT;
+		tk_ntp.time_state = TIME_WAIT;
 		break;
 
 	case TIME_WAIT:
-		if (!(time_status & (STA_INS | STA_DEL)))
-			time_state = TIME_OK;
+		if (!(tk_ntp.time_status & (STA_INS | STA_DEL)))
+			tk_ntp.time_state = TIME_OK;
 		break;
 	}
 
 
 	/* Bump the maxerror field */
-	time_maxerror += MAXFREQ / NSEC_PER_USEC;
-	if (time_maxerror > NTP_PHASE_LIMIT) {
-		time_maxerror = NTP_PHASE_LIMIT;
-		time_status |= STA_UNSYNC;
+	tk_ntp.time_maxerror += MAXFREQ / NSEC_PER_USEC;
+	if (tk_ntp.time_maxerror > NTP_PHASE_LIMIT) {
+		tk_ntp.time_maxerror = NTP_PHASE_LIMIT;
+		tk_ntp.time_status |= STA_UNSYNC;
 	}
 
 	/* Compute the phase adjustment for the next second */
-	tick_length	 = tick_length_base;
+	tk_ntp.tick_length = tk_ntp.tick_length_base;
 
-	delta		 = ntp_offset_chunk(time_offset);
-	time_offset	-= delta;
-	tick_length	+= delta;
+	delta = ntp_offset_chunk(tk_ntp.time_offset);
+	tk_ntp.time_offset -= delta;
+	tk_ntp.tick_length += delta;
 
 	/* Check PPS signal */
 	pps_dec_valid();
 
-	if (!time_adjust)
+	if (!tk_ntp.time_adjust)
 		goto out;
 
-	if (time_adjust > MAX_TICKADJ) {
-		time_adjust -= MAX_TICKADJ;
-		tick_length += MAX_TICKADJ_SCALED;
+	if (tk_ntp.time_adjust > MAX_TICKADJ) {
+		tk_ntp.time_adjust -= MAX_TICKADJ;
+		tk_ntp.tick_length += MAX_TICKADJ_SCALED;
 		goto out;
 	}
 
-	if (time_adjust < -MAX_TICKADJ) {
-		time_adjust += MAX_TICKADJ;
-		tick_length -= MAX_TICKADJ_SCALED;
+	if (tk_ntp.time_adjust < -MAX_TICKADJ) {
+		tk_ntp.time_adjust += MAX_TICKADJ;
+		tk_ntp.tick_length -= MAX_TICKADJ_SCALED;
 		goto out;
 	}
 
-	tick_length += (s64)(time_adjust * NSEC_PER_USEC / NTP_INTERVAL_FREQ)
+	tk_ntp.tick_length +=
+		(s64)(tk_ntp.time_adjust * NSEC_PER_USEC / NTP_INTERVAL_FREQ)
 							 << NTP_SCALE_SHIFT;
-	time_adjust = 0;
+	tk_ntp.time_adjust = 0;
 
 out:
 	return leap;
@@ -485,7 +445,7 @@ static void sync_cmos_clock(struct work_struct *work)
 	}
 
 	getnstimeofday(&now);
-	if (abs(now.tv_nsec - (NSEC_PER_SEC / 2)) <= tick_nsec / 2) {
+	if (abs(now.tv_nsec - (NSEC_PER_SEC / 2)) <= tk_ntp.tick_nsec / 2) {
 		struct timespec adjust = now;
 
 		fail = -ENODEV;
@@ -531,9 +491,9 @@ void ntp_notify_cmos_timer(void) { }
  */
 static inline void process_adj_status(struct timex *txc, struct timespec *ts)
 {
-	if ((time_status & STA_PLL) && !(txc->status & STA_PLL)) {
-		time_state = TIME_OK;
-		time_status = STA_UNSYNC;
+	if ((tk_ntp.time_status & STA_PLL) && !(txc->status & STA_PLL)) {
+		tk_ntp.time_state = TIME_OK;
+		tk_ntp.time_status = STA_UNSYNC;
 		/* restart PPS frequency calibration */
 		pps_reset_freq_interval();
 	}
@@ -542,12 +502,12 @@ static inline void process_adj_status(struct timex *txc, struct timespec *ts)
 	 * If we turn on PLL adjustments then reset the
 	 * reference time to current time.
 	 */
-	if (!(time_status & STA_PLL) && (txc->status & STA_PLL))
-		time_reftime = get_seconds();
+	if (!(tk_ntp.time_status & STA_PLL) && (txc->status & STA_PLL))
+		tk_ntp.time_reftime = get_seconds();
 
 	/* only set allowed bits */
-	time_status &= STA_RONLY;
-	time_status |= txc->status & ~STA_RONLY;
+	tk_ntp.time_status &= STA_RONLY;
+	tk_ntp.time_status |= txc->status & ~STA_RONLY;
 }
 
 
@@ -559,31 +519,31 @@ static inline void process_adjtimex_modes(struct timex *txc,
 		process_adj_status(txc, ts);
 
 	if (txc->modes & ADJ_NANO)
-		time_status |= STA_NANO;
+		tk_ntp.time_status |= STA_NANO;
 
 	if (txc->modes & ADJ_MICRO)
-		time_status &= ~STA_NANO;
+		tk_ntp.time_status &= ~STA_NANO;
 
 	if (txc->modes & ADJ_FREQUENCY) {
-		time_freq = txc->freq * PPM_SCALE;
-		time_freq = min(time_freq, MAXFREQ_SCALED);
-		time_freq = max(time_freq, -MAXFREQ_SCALED);
+		tk_ntp.time_freq = txc->freq * PPM_SCALE;
+		tk_ntp.time_freq = min(tk_ntp.time_freq, MAXFREQ_SCALED);
+		tk_ntp.time_freq = max(tk_ntp.time_freq, -MAXFREQ_SCALED);
 		/* update pps_freq */
-		pps_set_freq(time_freq);
+		pps_set_freq(tk_ntp.time_freq);
 	}
 
 	if (txc->modes & ADJ_MAXERROR)
-		time_maxerror = txc->maxerror;
+		tk_ntp.time_maxerror = txc->maxerror;
 
 	if (txc->modes & ADJ_ESTERROR)
-		time_esterror = txc->esterror;
+		tk_ntp.time_esterror = txc->esterror;
 
 	if (txc->modes & ADJ_TIMECONST) {
-		time_constant = txc->constant;
-		if (!(time_status & STA_NANO))
-			time_constant += 4;
-		time_constant = min(time_constant, (long)MAXTC);
-		time_constant = max(time_constant, 0l);
+		tk_ntp.time_constant = txc->constant;
+		if (!(tk_ntp.time_status & STA_NANO))
+			tk_ntp.time_constant += 4;
+		tk_ntp.time_constant = min(tk_ntp.time_constant, (long)MAXTC);
+		tk_ntp.time_constant = max(tk_ntp.time_constant, 0l);
 	}
 
 	if (txc->modes & ADJ_TAI && txc->constant > 0)
@@ -593,7 +553,7 @@ static inline void process_adjtimex_modes(struct timex *txc,
 		ntp_update_offset(txc->offset);
 
 	if (txc->modes & ADJ_TICK)
-		tick_usec = txc->tick;
+		tk_ntp.tick_usec = txc->tick;
 
 	if (txc->modes & (ADJ_TICK|ADJ_FREQUENCY|ADJ_OFFSET))
 		ntp_update_frequency();
@@ -643,11 +603,11 @@ int __do_adjtimex(struct timex *txc, struct timespec *ts, s32 *time_tai)
 	int result;
 
 	if (txc->modes & ADJ_ADJTIME) {
-		long save_adjust = time_adjust;
+		long save_adjust = tk_ntp.time_adjust;
 
 		if (!(txc->modes & ADJ_OFFSET_READONLY)) {
 			/* adjtime() is independent from ntp_adjtime() */
-			time_adjust = txc->offset;
+			tk_ntp.time_adjust = txc->offset;
 			ntp_update_frequency();
 		}
 		txc->offset = save_adjust;
@@ -657,34 +617,35 @@ int __do_adjtimex(struct timex *txc, struct timespec *ts, s32 *time_tai)
 		if (txc->modes)
 			process_adjtimex_modes(txc, ts, time_tai);
 
-		txc->offset = shift_right(time_offset * NTP_INTERVAL_FREQ,
+		txc->offset =
+			shift_right(tk_ntp.time_offset * NTP_INTERVAL_FREQ,
 				  NTP_SCALE_SHIFT);
-		if (!(time_status & STA_NANO))
+		if (!(tk_ntp.time_status & STA_NANO))
 			txc->offset /= NSEC_PER_USEC;
 	}
 
-	result = time_state;	/* mostly `TIME_OK' */
+	result = tk_ntp.time_state;	/* mostly `TIME_OK' */
 	/* check for errors */
-	if (is_error_status(time_status))
+	if (is_error_status(tk_ntp.time_status))
 		result = TIME_ERROR;
 
-	txc->freq	   = shift_right((time_freq >> PPM_SCALE_INV_SHIFT) *
-					 PPM_SCALE_INV, NTP_SCALE_SHIFT);
-	txc->maxerror	   = time_maxerror;
-	txc->esterror	   = time_esterror;
-	txc->status	   = time_status;
-	txc->constant	   = time_constant;
-	txc->precision	   = 1;
-	txc->tolerance	   = MAXFREQ_SCALED / PPM_SCALE;
-	txc->tick	   = tick_usec;
-	txc->tai	   = *time_tai;
+	txc->freq = shift_right((tk_ntp.time_freq >> PPM_SCALE_INV_SHIFT) *
+		PPM_SCALE_INV, NTP_SCALE_SHIFT);
+	txc->maxerror = tk_ntp.time_maxerror;
+	txc->esterror = tk_ntp.time_esterror;
+	txc->status = tk_ntp.time_status;
+	txc->constant = tk_ntp.time_constant;
+	txc->precision = 1;
+	txc->tolerance = MAXFREQ_SCALED / PPM_SCALE;
+	txc->tick = tk_ntp.tick_usec;
+	txc->tai = *time_tai;
 
 	/* fill PPS status fields */
 	pps_fill_timex(txc);
 
 	txc->time.tv_sec = ts->tv_sec;
 	txc->time.tv_usec = ts->tv_nsec;
-	if (!(time_status & STA_NANO))
+	if (!(tk_ntp.time_status & STA_NANO))
 		txc->time.tv_usec /= NSEC_PER_USEC;
 
 	return result;
@@ -781,7 +742,7 @@ static long hardpps_update_freq(struct pps_normtime freq_norm)
 
 	/* check if the frequency interval was too long */
 	if (freq_norm.sec > (2 << pps_shift)) {
-		time_status |= STA_PPSERROR;
+		tk_ntp.time_status |= STA_PPSERROR;
 		pps_errcnt++;
 		pps_dec_freq_interval();
 		pr_err("hardpps: PPSERROR: interval too long - %ld s\n",
@@ -799,7 +760,7 @@ static long hardpps_update_freq(struct pps_normtime freq_norm)
 	pps_freq = ftemp;
 	if (delta > PPS_MAXWANDER || delta < -PPS_MAXWANDER) {
 		pr_warning("hardpps: PPSWANDER: change=%ld\n", delta);
-		time_status |= STA_PPSWANDER;
+		tk_ntp.time_status |= STA_PPSWANDER;
 		pps_stbcnt++;
 		pps_dec_freq_interval();
 	} else {	/* good sample */
@@ -818,9 +779,9 @@ static long hardpps_update_freq(struct pps_normtime freq_norm)
 				NSEC_PER_USEC) - pps_stabil) >> PPS_INTMIN;
 
 	/* if enabled, the system clock frequency is updated */
-	if ((time_status & STA_PPSFREQ) != 0 &&
-	    (time_status & STA_FREQHOLD) == 0) {
-		time_freq = pps_freq;
+	if ((tk_ntp.time_status & STA_PPSFREQ) != 0 &&
+	    (tk_ntp.time_status & STA_FREQHOLD) == 0) {
+		tk_ntp.time_freq = pps_freq;
 		ntp_update_frequency();
 	}
 
@@ -844,14 +805,15 @@ static void hardpps_update_phase(long error)
 	if (jitter > (pps_jitter << PPS_POPCORN)) {
 		pr_warning("hardpps: PPSJITTER: jitter=%ld, limit=%ld\n",
 		       jitter, (pps_jitter << PPS_POPCORN));
-		time_status |= STA_PPSJITTER;
+		tk_ntp.time_status |= STA_PPSJITTER;
 		pps_jitcnt++;
-	} else if (time_status & STA_PPSTIME) {
+	} else if (tk_ntp.time_status & STA_PPSTIME) {
 		/* correct the time using the phase offset */
-		time_offset = div_s64(((s64)correction) << NTP_SCALE_SHIFT,
+		tk_ntp.time_offset =
+			div_s64(((s64)correction) << NTP_SCALE_SHIFT,
 				NTP_INTERVAL_FREQ);
 		/* cancel running adjtime() */
-		time_adjust = 0;
+		tk_ntp.time_adjust = 0;
 	}
 	/* update jitter */
 	pps_jitter += (jitter - pps_jitter) >> PPS_INTMIN;
@@ -876,10 +838,10 @@ void __hardpps(const struct timespec *phase_ts, const struct timespec *raw_ts)
 	pts_norm = pps_normalize_ts(*phase_ts);
 
 	/* clear the error bits, they will be set again if needed */
-	time_status &= ~(STA_PPSJITTER | STA_PPSWANDER | STA_PPSERROR);
+	tk_ntp.time_status &= ~(STA_PPSJITTER | STA_PPSWANDER | STA_PPSERROR);
 
 	/* indicate signal presence */
-	time_status |= STA_PPSSIGNAL;
+	tk_ntp.time_status |= STA_PPSSIGNAL;
 	pps_valid = PPS_VALID;
 
 	/* when called for the first time,
@@ -897,7 +859,7 @@ void __hardpps(const struct timespec *phase_ts, const struct timespec *raw_ts)
 	if ((freq_norm.sec == 0) ||
 			(freq_norm.nsec > MAXFREQ * freq_norm.sec) ||
 			(freq_norm.nsec < -MAXFREQ * freq_norm.sec)) {
-		time_status |= STA_PPSJITTER;
+		tk_ntp.time_status |= STA_PPSJITTER;
 		/* restart the frequency calibration interval */
 		pps_fbase = *raw_ts;
 		pr_err("hardpps: PPSJITTER: bad pulse\n");
@@ -921,8 +883,8 @@ void __hardpps(const struct timespec *phase_ts, const struct timespec *raw_ts)
 
 static int __init ntp_tick_adj_setup(char *str)
 {
-	ntp_tick_adj = simple_strtol(str, NULL, 0);
-	ntp_tick_adj <<= NTP_SCALE_SHIFT;
+	tk_ntp.ntp_tick_adj = simple_strtol(str, NULL, 0);
+	tk_ntp.ntp_tick_adj <<= NTP_SCALE_SHIFT;
 
 	return 1;
 }
-- 
1.7.10.4

