Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932496Ab3INTsq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 15:48:46 -0400
Received: from mail.openrapids.net ([64.15.138.104]:47130 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932443Ab3INTsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 15:48:42 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH 4/7] Pass struct timekeeper_ntp as parameter from timekeeper to ntp
Date: Sat, 14 Sep 2013 12:47:58 -0700
Message-Id: <1379188081-15613-5-git-send-email-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1379188081-15613-1-git-send-email-mathieu.desnoyers@efficios.com>
References: <1379188081-15613-1-git-send-email-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is in preparation for the latch synchronization scheme.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 kernel/time/ntp.c          |  472 ++++++++++++++++++++++----------------------
 kernel/time/ntp_internal.h |   16 +-
 kernel/time/timekeeping.c  |   17 +-
 3 files changed, 260 insertions(+), 245 deletions(-)

diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index d61e700..2a1b4ef 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -39,108 +39,108 @@
 /* PPS kernel consumer compensates the whole phase error immediately.
  * Otherwise, reduce the offset by a fixed factor times the time constant.
  */
-static inline s64 ntp_offset_chunk(s64 offset)
+static inline s64 ntp_offset_chunk(struct timekeeper_ntp *ntp, s64 offset)
 {
-	if (timekeeper.ntp.time_status & STA_PPSTIME
-			&& timekeeper.ntp.time_status & STA_PPSSIGNAL)
+	if (ntp->time_status & STA_PPSTIME
+			&& ntp->time_status & STA_PPSSIGNAL)
 		return offset;
 	else
-		return shift_right(offset, SHIFT_PLL + timekeeper.ntp.time_constant);
+		return shift_right(offset, SHIFT_PLL + ntp->time_constant);
 }
 
-static inline void pps_reset_freq_interval(void)
+static inline void pps_reset_freq_interval(struct timekeeper_ntp *ntp)
 {
 	/* the PPS calibration interval may end
 	   surprisingly early */
-	timekeeper.ntp.pps.shift = PPS_INTMIN;
-	timekeeper.ntp.pps.intcnt = 0;
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
-	timekeeper.ntp.pps.tf[0] = 0;
-	timekeeper.ntp.pps.tf[1] = 0;
-	timekeeper.ntp.pps.tf[2] = 0;
-	timekeeper.ntp.pps.fbase.tv_sec = timekeeper.ntp.pps.fbase.tv_nsec = 0;
-	timekeeper.ntp.pps.freq = 0;
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
-	if (timekeeper.ntp.pps.valid > 0)
-		timekeeper.ntp.pps.valid--;
+	if (ntp->pps.valid > 0)
+		ntp->pps.valid--;
 	else {
-		timekeeper.ntp.time_status &= ~(STA_PPSSIGNAL | STA_PPSJITTER |
+		ntp->time_status &= ~(STA_PPSSIGNAL | STA_PPSJITTER |
 				 STA_PPSWANDER | STA_PPSERROR);
-		pps_clear();
+		pps_clear(ntp);
 	}
 }
 
-static inline void pps_set_freq(s64 freq)
+static inline void pps_set_freq(struct timekeeper_ntp *ntp, s64 freq)
 {
-	timekeeper.ntp.pps.freq = freq;
+	ntp->pps.freq = freq;
 }
 
-static inline int is_error_status(int status)
+static inline int is_error_status(struct timekeeper_ntp *ntp, int status)
 {
-	return (timekeeper.ntp.time_status & (STA_UNSYNC|STA_CLOCKERR))
+	return (ntp->time_status & (STA_UNSYNC|STA_CLOCKERR))
 		/* PPS signal lost when either PPS time or
 		 * PPS frequency synchronization requested
 		 */
-		|| ((timekeeper.ntp.time_status & (STA_PPSFREQ|STA_PPSTIME))
-			&& !(timekeeper.ntp.time_status & STA_PPSSIGNAL))
+		|| ((ntp->time_status & (STA_PPSFREQ|STA_PPSTIME))
+			&& !(ntp->time_status & STA_PPSSIGNAL))
 		/* PPS jitter exceeded when
 		 * PPS time synchronization requested */
-		|| ((timekeeper.ntp.time_status & (STA_PPSTIME|STA_PPSJITTER))
+		|| ((ntp->time_status & (STA_PPSTIME|STA_PPSJITTER))
 			== (STA_PPSTIME|STA_PPSJITTER))
 		/* PPS wander exceeded or calibration error when
 		 * PPS frequency synchronization requested
 		 */
-		|| ((timekeeper.ntp.time_status & STA_PPSFREQ)
-			&& (timekeeper.ntp.time_status & (STA_PPSWANDER|STA_PPSERROR)));
+		|| ((ntp->time_status & STA_PPSFREQ)
+			&& (ntp->time_status & (STA_PPSWANDER|STA_PPSERROR)));
 }
 
-static inline void pps_fill_timex(struct timex *txc)
+static inline void pps_fill_timex(struct timekeeper_ntp *ntp, struct timex *txc)
 {
-	txc->ppsfreq = shift_right((timekeeper.ntp.pps.freq >> PPM_SCALE_INV_SHIFT) *
+	txc->ppsfreq = shift_right((ntp->pps.freq >> PPM_SCALE_INV_SHIFT) *
 					 PPM_SCALE_INV, NTP_SCALE_SHIFT);
-	txc->jitter = timekeeper.ntp.pps.jitter;
-	if (!(timekeeper.ntp.time_status & STA_NANO))
+	txc->jitter = ntp->pps.jitter;
+	if (!(ntp->time_status & STA_NANO))
 		txc->jitter /= NSEC_PER_USEC;
-	txc->shift = timekeeper.ntp.pps.shift;
-	txc->stabil = timekeeper.ntp.pps.stabil;
-	txc->jitcnt = timekeeper.ntp.pps.jitcnt;
-	txc->calcnt = timekeeper.ntp.pps.calcnt;
-	txc->errcnt = timekeeper.ntp.pps.errcnt;
-	txc->stbcnt = timekeeper.ntp.pps.stbcnt;
+	txc->shift = ntp->pps.shift;
+	txc->stabil = ntp->pps.stabil;
+	txc->jitcnt = ntp->pps.jitcnt;
+	txc->calcnt = ntp->pps.calcnt;
+	txc->errcnt = ntp->pps.errcnt;
+	txc->stbcnt = ntp->pps.stbcnt;
 }
 
 #else /* !CONFIG_NTP_PPS */
 
-static inline s64 ntp_offset_chunk(s64 offset)
+static inline s64 ntp_offset_chunk(struct timekeeper_ntp *ntp, s64 offset)
 {
-	return shift_right(offset, SHIFT_PLL + timekeeper.ntp.time_constant);
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
 
-static inline int is_error_status(int status)
+static inline int is_error_status(struct timekeeper_ntp *ntp, int status)
 {
 	return status & (STA_UNSYNC|STA_CLOCKERR);
 }
 
-static inline void pps_fill_timex(struct timex *txc)
+static inline void pps_fill_timex(struct timekeeper_ntp *ntp, struct timex *txc)
 {
 	/* PPS is not implemented, so these are zero */
 	txc->ppsfreq	   = 0;
@@ -160,9 +160,9 @@ static inline void pps_fill_timex(struct timex *txc)
  * ntp_synced - Returns 1 if the NTP status is not UNSYNC
  *
  */
-static inline int ntp_synced(void)
+static inline int ntp_synced(struct timekeeper_ntp *ntp)
 {
-	return !(timekeeper.ntp.time_status & STA_UNSYNC);
+	return !(ntp->time_status & STA_UNSYNC);
 }
 
 
@@ -171,56 +171,57 @@ static inline int ntp_synced(void)
  */
 
 /*
- * Update (timekeeper.ntp.tick_length, timekeeper.ntp.tick_length_base, timekeeper.ntp.tick_nsec),
- * based on (timekeeper.ntp.tick_usec, timekeeper.ntp.ntp_tick_adj, timekeeper.ntp.time_freq):
+ * Update (ntp->tick_length, ntp->tick_length_base, ntp->tick_nsec),
+ * based on (ntp->tick_usec, ntp->ntp_tick_adj, ntp->time_freq):
  */
-static void ntp_update_frequency(void)
+static void ntp_update_frequency(struct timekeeper_ntp *ntp)
 {
 	u64 second_length;
 	u64 new_base;
 
-	second_length = (u64)(timekeeper.ntp.tick_usec * NSEC_PER_USEC * USER_HZ)
+	second_length = (u64)(ntp->tick_usec * NSEC_PER_USEC * USER_HZ)
 						<< NTP_SCALE_SHIFT;
 
-	second_length += timekeeper.ntp.ntp_tick_adj;
-	second_length += timekeeper.ntp.time_freq;
+	second_length += ntp->ntp_tick_adj;
+	second_length += ntp->time_freq;
 
-	timekeeper.ntp.tick_nsec = div_u64(second_length, HZ) >> NTP_SCALE_SHIFT;
+	ntp->tick_nsec = div_u64(second_length, HZ) >> NTP_SCALE_SHIFT;
 	new_base = div_u64(second_length, NTP_INTERVAL_FREQ);
 
 	/*
 	 * Don't wait for the next second_overflow, apply
 	 * the change to the tick length immediately:
 	 */
-	timekeeper.ntp.tick_length += new_base - timekeeper.ntp.tick_length_base;
-	timekeeper.ntp.tick_length_base = new_base;
+	ntp->tick_length += new_base - ntp->tick_length_base;
+	ntp->tick_length_base = new_base;
 }
 
-static inline s64 ntp_update_offset_fll(s64 offset64, long secs)
+static inline s64 ntp_update_offset_fll(struct timekeeper_ntp *ntp,
+		s64 offset64, long secs)
 {
-	timekeeper.ntp.time_status &= ~STA_MODE;
+	ntp->time_status &= ~STA_MODE;
 
 	if (secs < MINSEC)
 		return 0;
 
-	if (!(timekeeper.ntp.time_status & STA_FLL) && (secs <= MAXSEC))
+	if (!(ntp->time_status & STA_FLL) && (secs <= MAXSEC))
 		return 0;
 
-	timekeeper.ntp.time_status |= STA_MODE;
+	ntp->time_status |= STA_MODE;
 
 	return div64_long(offset64 << (NTP_SCALE_SHIFT - SHIFT_FLL), secs);
 }
 
-static void ntp_update_offset(long offset)
+static void ntp_update_offset(struct timekeeper_ntp *ntp, long offset)
 {
 	s64 freq_adj;
 	s64 offset64;
 	long secs;
 
-	if (!(timekeeper.ntp.time_status & STA_PLL))
+	if (!(ntp->time_status & STA_PLL))
 		return;
 
-	if (!(timekeeper.ntp.time_status & STA_NANO))
+	if (!(ntp->time_status & STA_NANO))
 		offset *= NSEC_PER_USEC;
 
 	/*
@@ -234,57 +235,57 @@ static void ntp_update_offset(long offset)
 	 * Select how the frequency is to be controlled
 	 * and in which mode (PLL or FLL).
 	 */
-	secs = get_seconds() - timekeeper.ntp.time_reftime;
-	if (unlikely(timekeeper.ntp.time_status & STA_FREQHOLD))
+	secs = get_seconds() - ntp->time_reftime;
+	if (unlikely(ntp->time_status & STA_FREQHOLD))
 		secs = 0;
 
-	timekeeper.ntp.time_reftime = get_seconds();
+	ntp->time_reftime = get_seconds();
 
 	offset64    = offset;
-	freq_adj    = ntp_update_offset_fll(offset64, secs);
+	freq_adj    = ntp_update_offset_fll(ntp, offset64, secs);
 
 	/*
 	 * Clamp update interval to reduce PLL gain with low
 	 * sampling rate (e.g. intermittent network connection)
 	 * to avoid instability.
 	 */
-	if (unlikely(secs > 1 << (SHIFT_PLL + 1 + timekeeper.ntp.time_constant)))
-		secs = 1 << (SHIFT_PLL + 1 + timekeeper.ntp.time_constant);
+	if (unlikely(secs > 1 << (SHIFT_PLL + 1 + ntp->time_constant)))
+		secs = 1 << (SHIFT_PLL + 1 + ntp->time_constant);
 
 	freq_adj    += (offset64 * secs) <<
-		(NTP_SCALE_SHIFT - 2 * (SHIFT_PLL + 2 + timekeeper.ntp.time_constant));
+		(NTP_SCALE_SHIFT - 2 * (SHIFT_PLL + 2 + ntp->time_constant));
 
-	freq_adj    = min(freq_adj + timekeeper.ntp.time_freq, MAXFREQ_SCALED);
+	freq_adj    = min(freq_adj + ntp->time_freq, MAXFREQ_SCALED);
 
-	timekeeper.ntp.time_freq   = max(freq_adj, -MAXFREQ_SCALED);
+	ntp->time_freq   = max(freq_adj, -MAXFREQ_SCALED);
 
-	timekeeper.ntp.time_offset = div_s64(offset64 << NTP_SCALE_SHIFT,
+	ntp->time_offset = div_s64(offset64 << NTP_SCALE_SHIFT,
 		NTP_INTERVAL_FREQ);
 }
 
 /**
  * ntp_clear - Clears the NTP state variables
  */
-void ntp_clear(void)
+void ntp_clear(struct timekeeper_ntp *ntp)
 {
-	timekeeper.ntp.time_adjust	= 0;		/* stop active adjtime() */
-	timekeeper.ntp.time_status	|= STA_UNSYNC;
-	timekeeper.ntp.time_maxerror	= NTP_PHASE_LIMIT;
-	timekeeper.ntp.time_esterror	= NTP_PHASE_LIMIT;
+	ntp->time_adjust	= 0;		/* stop active adjtime() */
+	ntp->time_status	|= STA_UNSYNC;
+	ntp->time_maxerror	= NTP_PHASE_LIMIT;
+	ntp->time_esterror	= NTP_PHASE_LIMIT;
 
-	ntp_update_frequency();
+	ntp_update_frequency(ntp);
 
-	timekeeper.ntp.tick_length	= timekeeper.ntp.tick_length_base;
-	timekeeper.ntp.time_offset	= 0;
+	ntp->tick_length	= ntp->tick_length_base;
+	ntp->time_offset	= 0;
 
 	/* Clear PPS state variables */
-	pps_clear();
+	pps_clear(ntp);
 }
 
 
-u64 ntp_tick_length(void)
+u64 ntp_tick_length(struct timekeeper_ntp *ntp)
 {
-	return timekeeper.ntp.tick_length;
+	return ntp->tick_length;
 }
 
 
@@ -298,7 +299,7 @@ u64 ntp_tick_length(void)
  *
  * Also handles leap second processing, and returns leap offset
  */
-int second_overflow(unsigned long secs)
+int second_overflow(struct timekeeper_ntp *ntp, unsigned long secs)
 {
 	s64 delta;
 	int leap = 0;
@@ -308,80 +309,80 @@ int second_overflow(unsigned long secs)
 	 * day, the system clock is set back one second; if in leap-delete
 	 * state, the system clock is set ahead one second.
 	 */
-	switch (timekeeper.ntp.time_state) {
+	switch (ntp->time_state) {
 	case TIME_OK:
-		if (timekeeper.ntp.time_status & STA_INS)
-			timekeeper.ntp.time_state = TIME_INS;
-		else if (timekeeper.ntp.time_status & STA_DEL)
-			timekeeper.ntp.time_state = TIME_DEL;
+		if (ntp->time_status & STA_INS)
+			ntp->time_state = TIME_INS;
+		else if (ntp->time_status & STA_DEL)
+			ntp->time_state = TIME_DEL;
 		break;
 	case TIME_INS:
-		if (!(timekeeper.ntp.time_status & STA_INS))
-			timekeeper.ntp.time_state = TIME_OK;
+		if (!(ntp->time_status & STA_INS))
+			ntp->time_state = TIME_OK;
 		else if (secs % 86400 == 0) {
 			leap = -1;
-			timekeeper.ntp.time_state = TIME_OOP;
+			ntp->time_state = TIME_OOP;
 			printk(KERN_NOTICE
 				"Clock: inserting leap second 23:59:60 UTC\n");
 		}
 		break;
 	case TIME_DEL:
-		if (!(timekeeper.ntp.time_status & STA_DEL))
-			timekeeper.ntp.time_state = TIME_OK;
+		if (!(ntp->time_status & STA_DEL))
+			ntp->time_state = TIME_OK;
 		else if ((secs + 1) % 86400 == 0) {
 			leap = 1;
-			timekeeper.ntp.time_state = TIME_WAIT;
+			ntp->time_state = TIME_WAIT;
 			printk(KERN_NOTICE
 				"Clock: deleting leap second 23:59:59 UTC\n");
 		}
 		break;
 	case TIME_OOP:
-		timekeeper.ntp.time_state = TIME_WAIT;
+		ntp->time_state = TIME_WAIT;
 		break;
 
 	case TIME_WAIT:
-		if (!(timekeeper.ntp.time_status & (STA_INS | STA_DEL)))
-			timekeeper.ntp.time_state = TIME_OK;
+		if (!(ntp->time_status & (STA_INS | STA_DEL)))
+			ntp->time_state = TIME_OK;
 		break;
 	}
 
 
 	/* Bump the maxerror field */
-	timekeeper.ntp.time_maxerror += MAXFREQ / NSEC_PER_USEC;
-	if (timekeeper.ntp.time_maxerror > NTP_PHASE_LIMIT) {
-		timekeeper.ntp.time_maxerror = NTP_PHASE_LIMIT;
-		timekeeper.ntp.time_status |= STA_UNSYNC;
+	ntp->time_maxerror += MAXFREQ / NSEC_PER_USEC;
+	if (ntp->time_maxerror > NTP_PHASE_LIMIT) {
+		ntp->time_maxerror = NTP_PHASE_LIMIT;
+		ntp->time_status |= STA_UNSYNC;
 	}
 
 	/* Compute the phase adjustment for the next second */
-	timekeeper.ntp.tick_length = timekeeper.ntp.tick_length_base;
+	ntp->tick_length = ntp->tick_length_base;
 
-	delta = ntp_offset_chunk(timekeeper.ntp.time_offset);
-	timekeeper.ntp.time_offset -= delta;
-	timekeeper.ntp.tick_length += delta;
+	delta = ntp_offset_chunk(ntp, ntp->time_offset);
+	ntp->time_offset -= delta;
+	ntp->tick_length += delta;
 
 	/* Check PPS signal */
-	pps_dec_valid();
+	pps_dec_valid(ntp);
 
-	if (!timekeeper.ntp.time_adjust)
+	if (!ntp->time_adjust)
 		goto out;
 
-	if (timekeeper.ntp.time_adjust > MAX_TICKADJ) {
-		timekeeper.ntp.time_adjust -= MAX_TICKADJ;
-		timekeeper.ntp.tick_length += MAX_TICKADJ_SCALED;
+	if (ntp->time_adjust > MAX_TICKADJ) {
+		ntp->time_adjust -= MAX_TICKADJ;
+		ntp->tick_length += MAX_TICKADJ_SCALED;
 		goto out;
 	}
 
-	if (timekeeper.ntp.time_adjust < -MAX_TICKADJ) {
-		timekeeper.ntp.time_adjust += MAX_TICKADJ;
-		timekeeper.ntp.tick_length -= MAX_TICKADJ_SCALED;
+	if (ntp->time_adjust < -MAX_TICKADJ) {
+		ntp->time_adjust += MAX_TICKADJ;
+		ntp->tick_length -= MAX_TICKADJ_SCALED;
 		goto out;
 	}
 
-	timekeeper.ntp.tick_length +=
-		(s64)(timekeeper.ntp.time_adjust * NSEC_PER_USEC / NTP_INTERVAL_FREQ)
+	ntp->tick_length +=
+		(s64)(ntp->time_adjust * NSEC_PER_USEC / NTP_INTERVAL_FREQ)
 							 << NTP_SCALE_SHIFT;
-	timekeeper.ntp.time_adjust = 0;
+	ntp->time_adjust = 0;
 
 out:
 	return leap;
@@ -394,6 +395,7 @@ static DECLARE_DELAYED_WORK(sync_cmos_work, sync_cmos_clock);
 
 static void sync_cmos_clock(struct work_struct *work)
 {
+	struct timekeeper_ntp *ntp = &timekeeper.ntp;
 	struct timespec now, next;
 	int fail = 1;
 
@@ -404,7 +406,7 @@ static void sync_cmos_clock(struct work_struct *work)
 	 * This code is run on a timer.  If the clock is set, that timer
 	 * may not expire at the correct time.  Thus, we adjust...
 	 */
-	if (!ntp_synced()) {
+	if (!ntp_synced(ntp)) {
 		/*
 		 * Not synced, exit, do not restart a timer (if one is
 		 * running, let it run out).
@@ -413,7 +415,7 @@ static void sync_cmos_clock(struct work_struct *work)
 	}
 
 	getnstimeofday(&now);
-	if (abs(now.tv_nsec - (NSEC_PER_SEC / 2)) <= timekeeper.ntp.tick_nsec / 2) {
+	if (abs(now.tv_nsec - (NSEC_PER_SEC / 2)) <= ntp->tick_nsec / 2) {
 		struct timespec adjust = now;
 
 		fail = -ENODEV;
@@ -457,74 +459,76 @@ void ntp_notify_cmos_timer(void) { }
 /*
  * Propagate a new txc->status value into the NTP state:
  */
-static inline void process_adj_status(struct timex *txc, struct timespec *ts)
+static inline void process_adj_status(struct timekeeper_ntp *ntp,
+		struct timex *txc, struct timespec *ts)
 {
-	if ((timekeeper.ntp.time_status & STA_PLL) && !(txc->status & STA_PLL)) {
-		timekeeper.ntp.time_state = TIME_OK;
-		timekeeper.ntp.time_status = STA_UNSYNC;
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
-	if (!(timekeeper.ntp.time_status & STA_PLL) && (txc->status & STA_PLL))
-		timekeeper.ntp.time_reftime = get_seconds();
+	if (!(ntp->time_status & STA_PLL) && (txc->status & STA_PLL))
+		ntp->time_reftime = get_seconds();
 
 	/* only set allowed bits */
-	timekeeper.ntp.time_status &= STA_RONLY;
-	timekeeper.ntp.time_status |= txc->status & ~STA_RONLY;
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
-		timekeeper.ntp.time_status |= STA_NANO;
+		ntp->time_status |= STA_NANO;
 
 	if (txc->modes & ADJ_MICRO)
-		timekeeper.ntp.time_status &= ~STA_NANO;
+		ntp->time_status &= ~STA_NANO;
 
 	if (txc->modes & ADJ_FREQUENCY) {
-		timekeeper.ntp.time_freq = txc->freq * PPM_SCALE;
-		timekeeper.ntp.time_freq = min(timekeeper.ntp.time_freq, MAXFREQ_SCALED);
-		timekeeper.ntp.time_freq = max(timekeeper.ntp.time_freq, -MAXFREQ_SCALED);
-		/* update timekeeper.ntp.pps.freq */
-		pps_set_freq(timekeeper.ntp.time_freq);
+		ntp->time_freq = txc->freq * PPM_SCALE;
+		ntp->time_freq = min(ntp->time_freq, MAXFREQ_SCALED);
+		ntp->time_freq = max(ntp->time_freq, -MAXFREQ_SCALED);
+		/* update ntp->pps.freq */
+		pps_set_freq(ntp, ntp->time_freq);
 	}
 
 	if (txc->modes & ADJ_MAXERROR)
-		timekeeper.ntp.time_maxerror = txc->maxerror;
+		ntp->time_maxerror = txc->maxerror;
 
 	if (txc->modes & ADJ_ESTERROR)
-		timekeeper.ntp.time_esterror = txc->esterror;
+		ntp->time_esterror = txc->esterror;
 
 	if (txc->modes & ADJ_TIMECONST) {
-		timekeeper.ntp.time_constant = txc->constant;
-		if (!(timekeeper.ntp.time_status & STA_NANO))
-			timekeeper.ntp.time_constant += 4;
-		timekeeper.ntp.time_constant = min(timekeeper.ntp.time_constant, (long)MAXTC);
-		timekeeper.ntp.time_constant = max(timekeeper.ntp.time_constant, 0l);
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
-		timekeeper.ntp.tick_usec = txc->tick;
+		ntp->tick_usec = txc->tick;
 
 	if (txc->modes & (ADJ_TICK|ADJ_FREQUENCY|ADJ_OFFSET))
-		ntp_update_frequency();
+		ntp_update_frequency(ntp);
 }
 
 
@@ -566,54 +570,55 @@ int ntp_validate_timex(struct timex *txc)
  * adjtimex mainly allows reading (and writing, if superuser) of
  * kernel time-keeping variables. used by xntpd.
  */
-int __do_adjtimex(struct timex *txc, struct timespec *ts, s32 *time_tai)
+int __do_adjtimex(struct timekeeper_ntp *ntp, struct timex *txc,
+		struct timespec *ts, s32 *time_tai)
 {
 	int result;
 
 	if (txc->modes & ADJ_ADJTIME) {
-		long save_adjust = timekeeper.ntp.time_adjust;
+		long save_adjust = ntp->time_adjust;
 
 		if (!(txc->modes & ADJ_OFFSET_READONLY)) {
 			/* adjtime() is independent from ntp_adjtime() */
-			timekeeper.ntp.time_adjust = txc->offset;
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
 
 		txc->offset =
-			shift_right(timekeeper.ntp.time_offset * NTP_INTERVAL_FREQ,
+			shift_right(ntp->time_offset * NTP_INTERVAL_FREQ,
 				  NTP_SCALE_SHIFT);
-		if (!(timekeeper.ntp.time_status & STA_NANO))
+		if (!(ntp->time_status & STA_NANO))
 			txc->offset /= NSEC_PER_USEC;
 	}
 
-	result = timekeeper.ntp.time_state;	/* mostly `TIME_OK' */
+	result = ntp->time_state;	/* mostly `TIME_OK' */
 	/* check for errors */
-	if (is_error_status(timekeeper.ntp.time_status))
+	if (is_error_status(ntp, ntp->time_status))
 		result = TIME_ERROR;
 
-	txc->freq = shift_right((timekeeper.ntp.time_freq >> PPM_SCALE_INV_SHIFT) *
+	txc->freq = shift_right((ntp->time_freq >> PPM_SCALE_INV_SHIFT) *
 		PPM_SCALE_INV, NTP_SCALE_SHIFT);
-	txc->maxerror = timekeeper.ntp.time_maxerror;
-	txc->esterror = timekeeper.ntp.time_esterror;
-	txc->status = timekeeper.ntp.time_status;
-	txc->constant = timekeeper.ntp.time_constant;
+	txc->maxerror = ntp->time_maxerror;
+	txc->esterror = ntp->time_esterror;
+	txc->status = ntp->time_status;
+	txc->constant = ntp->time_constant;
 	txc->precision = 1;
 	txc->tolerance = MAXFREQ_SCALED / PPM_SCALE;
-	txc->tick = timekeeper.ntp.tick_usec;
+	txc->tick = ntp->tick_usec;
 	txc->tai = *time_tai;
 
 	/* fill PPS status fields */
-	pps_fill_timex(txc);
+	pps_fill_timex(ntp, txc);
 
 	txc->time.tv_sec = ts->tv_sec;
 	txc->time.tv_usec = ts->tv_nsec;
-	if (!(timekeeper.ntp.time_status & STA_NANO))
+	if (!(ntp->time_status & STA_NANO))
 		txc->time.tv_usec /= NSEC_PER_USEC;
 
 	return result;
@@ -648,34 +653,35 @@ static inline struct pps_normtime pps_normalize_ts(struct timespec ts)
 }
 
 /* get current phase correction and jitter */
-static inline long pps_phase_filter_get(long *jitter)
+static inline long pps_phase_filter_get(struct timekeeper_ntp *ntp,
+		long *jitter)
 {
-	*jitter = timekeeper.ntp.pps.tf[0] - timekeeper.ntp.pps.tf[1];
+	*jitter = ntp->pps.tf[0] - ntp->pps.tf[1];
 	if (*jitter < 0)
 		*jitter = -*jitter;
 
 	/* TODO: test various filters */
-	return timekeeper.ntp.pps.tf[0];
+	return ntp->pps.tf[0];
 }
 
 /* add the sample to the phase filter */
-static inline void pps_phase_filter_add(long err)
+static inline void pps_phase_filter_add(struct timekeeper_ntp *ntp, long err)
 {
-	timekeeper.ntp.pps.tf[2] = timekeeper.ntp.pps.tf[1];
-	timekeeper.ntp.pps.tf[1] = timekeeper.ntp.pps.tf[0];
-	timekeeper.ntp.pps.tf[0] = err;
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
-	if (--timekeeper.ntp.pps.intcnt <= -PPS_INTCOUNT) {
-		timekeeper.ntp.pps.intcnt = -PPS_INTCOUNT;
-		if (timekeeper.ntp.pps.shift > PPS_INTMIN) {
-			timekeeper.ntp.pps.shift--;
-			timekeeper.ntp.pps.intcnt = 0;
+	if (--ntp->pps.intcnt <= -PPS_INTCOUNT) {
+		ntp->pps.intcnt = -PPS_INTCOUNT;
+		if (ntp->pps.shift > PPS_INTMIN) {
+			ntp->pps.shift--;
+			ntp->pps.intcnt = 0;
 		}
 	}
 }
@@ -683,13 +689,13 @@ static inline void pps_dec_freq_interval(void)
 /* increase frequency calibration interval length.
  * It is doubled after four consecutive stable intervals.
  */
-static inline void pps_inc_freq_interval(void)
+static inline void pps_inc_freq_interval(struct timekeeper_ntp *ntp)
 {
-	if (++timekeeper.ntp.pps.intcnt >= PPS_INTCOUNT) {
-		timekeeper.ntp.pps.intcnt = PPS_INTCOUNT;
-		if (timekeeper.ntp.pps.shift < PPS_INTMAX) {
-			timekeeper.ntp.pps.shift++;
-			timekeeper.ntp.pps.intcnt = 0;
+	if (++ntp->pps.intcnt >= PPS_INTCOUNT) {
+		ntp->pps.intcnt = PPS_INTCOUNT;
+		if (ntp->pps.shift < PPS_INTMAX) {
+			ntp->pps.shift++;
+			ntp->pps.intcnt = 0;
 		}
 	}
 }
@@ -703,16 +709,17 @@ static inline void pps_inc_freq_interval(void)
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
-	if (freq_norm.sec > (2 << timekeeper.ntp.pps.shift)) {
-		timekeeper.ntp.time_status |= STA_PPSERROR;
-		timekeeper.ntp.pps.errcnt++;
-		pps_dec_freq_interval();
+	if (freq_norm.sec > (2 << ntp->pps.shift)) {
+		ntp->time_status |= STA_PPSERROR;
+		ntp->pps.errcnt++;
+		pps_dec_freq_interval(ntp);
 		pr_err("hardpps: PPSERROR: interval too long - %ld s\n",
 				freq_norm.sec);
 		return 0;
@@ -724,15 +731,15 @@ static long hardpps_update_freq(struct pps_normtime freq_norm)
 	 */
 	ftemp = div_s64(((s64)(-freq_norm.nsec)) << NTP_SCALE_SHIFT,
 			freq_norm.sec);
-	delta = shift_right(ftemp - timekeeper.ntp.pps.freq, NTP_SCALE_SHIFT);
-	timekeeper.ntp.pps.freq = ftemp;
+	delta = shift_right(ftemp - ntp->pps.freq, NTP_SCALE_SHIFT);
+	ntp->pps.freq = ftemp;
 	if (delta > PPS_MAXWANDER || delta < -PPS_MAXWANDER) {
 		pr_warning("hardpps: PPSWANDER: change=%ld\n", delta);
-		timekeeper.ntp.time_status |= STA_PPSWANDER;
-		timekeeper.ntp.pps.stbcnt++;
-		pps_dec_freq_interval();
+		ntp->time_status |= STA_PPSWANDER;
+		ntp->pps.stbcnt++;
+		pps_dec_freq_interval(ntp);
 	} else {	/* good sample */
-		pps_inc_freq_interval();
+		pps_inc_freq_interval(ntp);
 	}
 
 	/* the stability metric is calculated as the average of recent
@@ -742,49 +749,49 @@ static long hardpps_update_freq(struct pps_normtime freq_norm)
 	delta_mod = delta;
 	if (delta_mod < 0)
 		delta_mod = -delta_mod;
-	timekeeper.ntp.pps.stabil += (div_s64(((s64)delta_mod) <<
+	ntp->pps.stabil += (div_s64(((s64)delta_mod) <<
 		(NTP_SCALE_SHIFT - SHIFT_USEC),
-		NSEC_PER_USEC) - timekeeper.ntp.pps.stabil) >> PPS_INTMIN;
+		NSEC_PER_USEC) - ntp->pps.stabil) >> PPS_INTMIN;
 
 	/* if enabled, the system clock frequency is updated */
-	if ((timekeeper.ntp.time_status & STA_PPSFREQ) != 0 &&
-	    (timekeeper.ntp.time_status & STA_FREQHOLD) == 0) {
-		timekeeper.ntp.time_freq = timekeeper.ntp.pps.freq;
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
-	if (jitter > (timekeeper.ntp.pps.jitter << PPS_POPCORN)) {
+	if (jitter > (ntp->pps.jitter << PPS_POPCORN)) {
 		pr_warning("hardpps: PPSJITTER: jitter=%ld, limit=%ld\n",
-		       jitter, (timekeeper.ntp.pps.jitter << PPS_POPCORN));
-		timekeeper.ntp.time_status |= STA_PPSJITTER;
-		timekeeper.ntp.pps.jitcnt++;
-	} else if (timekeeper.ntp.time_status & STA_PPSTIME) {
+		       jitter, (ntp->pps.jitter << PPS_POPCORN));
+		ntp->time_status |= STA_PPSJITTER;
+		ntp->pps.jitcnt++;
+	} else if (ntp->time_status & STA_PPSTIME) {
 		/* correct the time using the phase offset */
-		timekeeper.ntp.time_offset =
+		ntp->time_offset =
 			div_s64(((s64)correction) << NTP_SCALE_SHIFT,
 				NTP_INTERVAL_FREQ);
 		/* cancel running adjtime() */
-		timekeeper.ntp.time_adjust = 0;
+		ntp->time_adjust = 0;
 	}
 	/* update jitter */
-	timekeeper.ntp.pps.jitter += (jitter - timekeeper.ntp.pps.jitter) >> PPS_INTMIN;
+	ntp->pps.jitter += (jitter - ntp->pps.jitter) >> PPS_INTMIN;
 }
 
 /*
@@ -799,38 +806,39 @@ static void hardpps_update_phase(long error)
  * This code is based on David Mills's reference nanokernel
  * implementation. It was mostly rewritten but keeps the same idea.
  */
-void __hardpps(const struct timespec *phase_ts, const struct timespec *raw_ts)
+void __hardpps(struct timekeeper_ntp *ntp, const struct timespec *phase_ts,
+		const struct timespec *raw_ts)
 {
 	struct pps_normtime pts_norm, freq_norm;
 
 	pts_norm = pps_normalize_ts(*phase_ts);
 
 	/* clear the error bits, they will be set again if needed */
-	timekeeper.ntp.time_status &= ~(STA_PPSJITTER | STA_PPSWANDER | STA_PPSERROR);
+	ntp->time_status &= ~(STA_PPSJITTER | STA_PPSWANDER | STA_PPSERROR);
 
 	/* indicate signal presence */
-	timekeeper.ntp.time_status |= STA_PPSSIGNAL;
-	timekeeper.ntp.pps.valid = PPS_VALID;
+	ntp->time_status |= STA_PPSSIGNAL;
+	ntp->pps.valid = PPS_VALID;
 
 	/* when called for the first time,
 	 * just start the frequency interval */
-	if (unlikely(timekeeper.ntp.pps.fbase.tv_sec == 0)) {
-		timekeeper.ntp.pps.fbase = *raw_ts;
+	if (unlikely(ntp->pps.fbase.tv_sec == 0)) {
+		ntp->pps.fbase = *raw_ts;
 		return;
 	}
 
 	/* ok, now we have a base for frequency calculation */
 	freq_norm = pps_normalize_ts(timespec_sub(*raw_ts,
-		timekeeper.ntp.pps.fbase));
+		ntp->pps.fbase));
 
 	/* check that the signal is in the range
 	 * [1s - MAXFREQ us, 1s + MAXFREQ us], otherwise reject it */
 	if ((freq_norm.sec == 0) ||
 			(freq_norm.nsec > MAXFREQ * freq_norm.sec) ||
 			(freq_norm.nsec < -MAXFREQ * freq_norm.sec)) {
-		timekeeper.ntp.time_status |= STA_PPSJITTER;
+		ntp->time_status |= STA_PPSJITTER;
 		/* restart the frequency calibration interval */
-		timekeeper.ntp.pps.fbase = *raw_ts;
+		ntp->pps.fbase = *raw_ts;
 		pr_err("hardpps: PPSJITTER: bad pulse\n");
 		return;
 	}
@@ -838,29 +846,31 @@ void __hardpps(const struct timespec *phase_ts, const struct timespec *raw_ts)
 	/* signal is ok */
 
 	/* check if the current frequency interval is finished */
-	if (freq_norm.sec >= (1 << timekeeper.ntp.pps.shift)) {
-		timekeeper.ntp.pps.calcnt++;
+	if (freq_norm.sec >= (1 << ntp->pps.shift)) {
+		ntp->pps.calcnt++;
 		/* restart the frequency calibration interval */
-		timekeeper.ntp.pps.fbase = *raw_ts;
-		hardpps_update_freq(freq_norm);
+		ntp->pps.fbase = *raw_ts;
+		hardpps_update_freq(ntp, freq_norm);
 	}
 
-	hardpps_update_phase(pts_norm.nsec);
+	hardpps_update_phase(ntp, pts_norm.nsec);
 
 }
 #endif	/* CONFIG_NTP_PPS */
 
 static int __init ntp_tick_adj_setup(char *str)
 {
-	timekeeper.ntp.ntp_tick_adj = simple_strtol(str, NULL, 0);
-	timekeeper.ntp.ntp_tick_adj <<= NTP_SCALE_SHIFT;
+	struct timekeeper_ntp *ntp = &timekeeper.ntp;
+
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
index d1ecafb..2210abb 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -260,7 +260,7 @@ static void timekeeping_update(struct timekeeper *tk, unsigned int action)
 {
 	if (action & TK_CLEAR_NTP) {
 		tk->ntp_error = 0;
-		ntp_clear();
+		ntp_clear(&tk->ntp);
 	}
 	update_vsyscall(tk);
 	update_pvclock_gtod(tk, action & TK_CLOCK_WAS_SET);
@@ -819,7 +819,7 @@ void __init timekeeping_init(void)
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
 	write_seqcount_begin(&timekeeper_seq);
-	ntp_init();
+	ntp_init(&tk->ntp);
 
 	clock = clocksource_default_clock();
 	if (clock->enable)
@@ -1087,7 +1087,7 @@ static __always_inline int timekeeping_bigadjust(struct timekeeper *tk,
 	 * Now calculate the error in (1 << look_ahead) ticks, but first
 	 * remove the single look ahead already included in the error.
 	 */
-	tick_error = ntp_tick_length() >> (tk->ntp_error_shift + 1);
+	tick_error = ntp_tick_length(&tk->ntp) >> (tk->ntp_error_shift + 1);
 	tick_error -= tk->xtime_interval >> 1;
 	error = ((error - tick_error) >> look_ahead) + tick_error;
 
@@ -1274,7 +1274,7 @@ static inline unsigned int accumulate_nsecs_to_secs(struct timekeeper *tk)
 		tk->xtime_sec++;
 
 		/* Figure out if its a leap sec and apply if needed */
-		leap = second_overflow(tk->xtime_sec);
+		leap = second_overflow(&tk->ntp, tk->xtime_sec);
 		if (unlikely(leap)) {
 			struct timespec ts;
 
@@ -1331,7 +1331,7 @@ static cycle_t logarithmic_accumulation(struct timekeeper *tk, cycle_t offset,
 	tk->raw_time.tv_nsec = raw_nsecs;
 
 	/* Accumulate error between NTP and clock interval */
-	tk->ntp_error += ntp_tick_length() << shift;
+	tk->ntp_error += ntp_tick_length(&tk->ntp) << shift;
 	tk->ntp_error -= (tk->xtime_interval + tk->xtime_remainder) <<
 						(tk->ntp_error_shift + shift);
 
@@ -1408,7 +1408,7 @@ static void update_wall_time(void)
 	shift = ilog2(offset) - ilog2(tk->cycle_interval);
 	shift = max(0, shift);
 	/* Bound shift to one less than what overflows tick_length */
-	maxshift = (64 - (ilog2(ntp_tick_length())+1)) - 1;
+	maxshift = (64 - (ilog2(ntp_tick_length(&tk->ntp))+1)) - 1;
 	shift = min(shift, maxshift);
 	while (offset >= tk->cycle_interval) {
 		offset = logarithmic_accumulation(tk, offset, shift);
@@ -1703,7 +1703,7 @@ int do_adjtimex(struct timex *txc)
 	write_seqcount_begin(&timekeeper_seq);
 
 	orig_tai = tai = tk->tai_offset;
-	ret = __do_adjtimex(txc, &ts, &tai);
+	ret = __do_adjtimex(&tk->ntp, txc, &ts, &tai);
 
 	if (tai != orig_tai) {
 		__timekeeping_set_tai_offset(tk, tai);
@@ -1724,12 +1724,13 @@ int do_adjtimex(struct timex *txc)
  */
 void hardpps(const struct timespec *phase_ts, const struct timespec *raw_ts)
 {
+	struct timekeeper *tk = &timekeeper;
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
 	write_seqcount_begin(&timekeeper_seq);
 
-	__hardpps(phase_ts, raw_ts);
+	__hardpps(&tk->ntp, phase_ts, raw_ts);
 
 	write_seqcount_end(&timekeeper_seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
-- 
1.7.10.4

