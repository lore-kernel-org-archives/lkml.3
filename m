Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932556Ab3INTtq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 15:49:46 -0400
Received: from mail.openrapids.net ([64.15.138.104]:47125 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932242Ab3INTsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 15:48:40 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH 3/7] Move ntp structure into struct timekeeper
Date: Sat, 14 Sep 2013 12:47:57 -0700
Message-Id: <1379188081-15613-4-git-send-email-mathieu.desnoyers@efficios.com>
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
 include/linux/timekeeper_internal.h |    4 +
 kernel/time/ntp.c                   |  361 +++++++++++++++++------------------
 kernel/time/timekeeping.c           |   12 +-
 3 files changed, 191 insertions(+), 186 deletions(-)

diff --git a/include/linux/timekeeper_internal.h b/include/linux/timekeeper_internal.h
index 02c25c0..6f0532d 100644
--- a/include/linux/timekeeper_internal.h
+++ b/include/linux/timekeeper_internal.h
@@ -147,8 +147,12 @@ struct timekeeper {
 	/* Offset clock monotonic -> clock tai */
 	ktime_t			offs_tai;
 
+	/* NTP variables */
+	struct timekeeper_ntp	ntp;
 };
 
+extern struct timekeeper timekeeper;
+
 static inline struct timespec tk_xtime(struct timekeeper *tk)
 {
 	struct timespec ts;
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index b095070..d61e700 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -25,15 +25,6 @@
 #define MAX_TICKADJ_SCALED \
 	(((MAX_TICKADJ * NSEC_PER_USEC) << NTP_SCALE_SHIFT) / NTP_INTERVAL_FREQ)
 
-static struct timekeeper_ntp tk_ntp = {
-	.tick_usec = TICK_USEC,
-	.time_state = TIME_OK,
-	.time_status = STA_UNSYNC,
-	.time_constant = 2,
-	.time_maxerror = NTP_PHASE_LIMIT,
-	.time_esterror = NTP_PHASE_LIMIT,
-};
-
 #ifdef CONFIG_NTP_PPS
 
 #define PPS_VALID	10	/* PPS signal watchdog max (s) */
@@ -50,19 +41,19 @@ static struct timekeeper_ntp tk_ntp = {
  */
 static inline s64 ntp_offset_chunk(s64 offset)
 {
-	if (tk_ntp.time_status & STA_PPSTIME
-			&& tk_ntp.time_status & STA_PPSSIGNAL)
+	if (timekeeper.ntp.time_status & STA_PPSTIME
+			&& timekeeper.ntp.time_status & STA_PPSSIGNAL)
 		return offset;
 	else
-		return shift_right(offset, SHIFT_PLL + tk_ntp.time_constant);
+		return shift_right(offset, SHIFT_PLL + timekeeper.ntp.time_constant);
 }
 
 static inline void pps_reset_freq_interval(void)
 {
 	/* the PPS calibration interval may end
 	   surprisingly early */
-	tk_ntp.pps.shift = PPS_INTMIN;
-	tk_ntp.pps.intcnt = 0;
+	timekeeper.ntp.pps.shift = PPS_INTMIN;
+	timekeeper.ntp.pps.intcnt = 0;
 }
 
 /**
@@ -71,11 +62,11 @@ static inline void pps_reset_freq_interval(void)
 static inline void pps_clear(void)
 {
 	pps_reset_freq_interval();
-	tk_ntp.pps.tf[0] = 0;
-	tk_ntp.pps.tf[1] = 0;
-	tk_ntp.pps.tf[2] = 0;
-	tk_ntp.pps.fbase.tv_sec = tk_ntp.pps.fbase.tv_nsec = 0;
-	tk_ntp.pps.freq = 0;
+	timekeeper.ntp.pps.tf[0] = 0;
+	timekeeper.ntp.pps.tf[1] = 0;
+	timekeeper.ntp.pps.tf[2] = 0;
+	timekeeper.ntp.pps.fbase.tv_sec = timekeeper.ntp.pps.fbase.tv_nsec = 0;
+	timekeeper.ntp.pps.freq = 0;
 }
 
 /* Decrease pps_valid to indicate that another second has passed since
@@ -84,10 +75,10 @@ static inline void pps_clear(void)
  */
 static inline void pps_dec_valid(void)
 {
-	if (tk_ntp.pps.valid > 0)
-		tk_ntp.pps.valid--;
+	if (timekeeper.ntp.pps.valid > 0)
+		timekeeper.ntp.pps.valid--;
 	else {
-		tk_ntp.time_status &= ~(STA_PPSSIGNAL | STA_PPSJITTER |
+		timekeeper.ntp.time_status &= ~(STA_PPSSIGNAL | STA_PPSJITTER |
 				 STA_PPSWANDER | STA_PPSERROR);
 		pps_clear();
 	}
@@ -95,48 +86,48 @@ static inline void pps_dec_valid(void)
 
 static inline void pps_set_freq(s64 freq)
 {
-	tk_ntp.pps.freq = freq;
+	timekeeper.ntp.pps.freq = freq;
 }
 
 static inline int is_error_status(int status)
 {
-	return (tk_ntp.time_status & (STA_UNSYNC|STA_CLOCKERR))
+	return (timekeeper.ntp.time_status & (STA_UNSYNC|STA_CLOCKERR))
 		/* PPS signal lost when either PPS time or
 		 * PPS frequency synchronization requested
 		 */
-		|| ((tk_ntp.time_status & (STA_PPSFREQ|STA_PPSTIME))
-			&& !(tk_ntp.time_status & STA_PPSSIGNAL))
+		|| ((timekeeper.ntp.time_status & (STA_PPSFREQ|STA_PPSTIME))
+			&& !(timekeeper.ntp.time_status & STA_PPSSIGNAL))
 		/* PPS jitter exceeded when
 		 * PPS time synchronization requested */
-		|| ((tk_ntp.time_status & (STA_PPSTIME|STA_PPSJITTER))
+		|| ((timekeeper.ntp.time_status & (STA_PPSTIME|STA_PPSJITTER))
 			== (STA_PPSTIME|STA_PPSJITTER))
 		/* PPS wander exceeded or calibration error when
 		 * PPS frequency synchronization requested
 		 */
-		|| ((tk_ntp.time_status & STA_PPSFREQ)
-			&& (tk_ntp.time_status & (STA_PPSWANDER|STA_PPSERROR)));
+		|| ((timekeeper.ntp.time_status & STA_PPSFREQ)
+			&& (timekeeper.ntp.time_status & (STA_PPSWANDER|STA_PPSERROR)));
 }
 
 static inline void pps_fill_timex(struct timex *txc)
 {
-	txc->ppsfreq = shift_right((tk_ntp.pps.freq >> PPM_SCALE_INV_SHIFT) *
+	txc->ppsfreq = shift_right((timekeeper.ntp.pps.freq >> PPM_SCALE_INV_SHIFT) *
 					 PPM_SCALE_INV, NTP_SCALE_SHIFT);
-	txc->jitter = tk_ntp.pps.jitter;
-	if (!(tk_ntp.time_status & STA_NANO))
+	txc->jitter = timekeeper.ntp.pps.jitter;
+	if (!(timekeeper.ntp.time_status & STA_NANO))
 		txc->jitter /= NSEC_PER_USEC;
-	txc->shift = tk_ntp.pps.shift;
-	txc->stabil = tk_ntp.pps.stabil;
-	txc->jitcnt = tk_ntp.pps.jitcnt;
-	txc->calcnt = tk_ntp.pps.calcnt;
-	txc->errcnt = tk_ntp.pps.errcnt;
-	txc->stbcnt = tk_ntp.pps.stbcnt;
+	txc->shift = timekeeper.ntp.pps.shift;
+	txc->stabil = timekeeper.ntp.pps.stabil;
+	txc->jitcnt = timekeeper.ntp.pps.jitcnt;
+	txc->calcnt = timekeeper.ntp.pps.calcnt;
+	txc->errcnt = timekeeper.ntp.pps.errcnt;
+	txc->stbcnt = timekeeper.ntp.pps.stbcnt;
 }
 
 #else /* !CONFIG_NTP_PPS */
 
 static inline s64 ntp_offset_chunk(s64 offset)
 {
-	return shift_right(offset, SHIFT_PLL + tk_ntp.time_constant);
+	return shift_right(offset, SHIFT_PLL + timekeeper.ntp.time_constant);
 }
 
 static inline void pps_reset_freq_interval(void) {}
@@ -171,7 +162,7 @@ static inline void pps_fill_timex(struct timex *txc)
  */
 static inline int ntp_synced(void)
 {
-	return !(tk_ntp.time_status & STA_UNSYNC);
+	return !(timekeeper.ntp.time_status & STA_UNSYNC);
 }
 
 
@@ -180,42 +171,42 @@ static inline int ntp_synced(void)
  */
 
 /*
- * Update (tk_ntp.tick_length, tk_ntp.tick_length_base, tk_ntp.tick_nsec),
- * based on (tk_ntp.tick_usec, tk_ntp.ntp_tick_adj, tk_ntp.time_freq):
+ * Update (timekeeper.ntp.tick_length, timekeeper.ntp.tick_length_base, timekeeper.ntp.tick_nsec),
+ * based on (timekeeper.ntp.tick_usec, timekeeper.ntp.ntp_tick_adj, timekeeper.ntp.time_freq):
  */
 static void ntp_update_frequency(void)
 {
 	u64 second_length;
 	u64 new_base;
 
-	second_length = (u64)(tk_ntp.tick_usec * NSEC_PER_USEC * USER_HZ)
+	second_length = (u64)(timekeeper.ntp.tick_usec * NSEC_PER_USEC * USER_HZ)
 						<< NTP_SCALE_SHIFT;
 
-	second_length += tk_ntp.ntp_tick_adj;
-	second_length += tk_ntp.time_freq;
+	second_length += timekeeper.ntp.ntp_tick_adj;
+	second_length += timekeeper.ntp.time_freq;
 
-	tk_ntp.tick_nsec = div_u64(second_length, HZ) >> NTP_SCALE_SHIFT;
+	timekeeper.ntp.tick_nsec = div_u64(second_length, HZ) >> NTP_SCALE_SHIFT;
 	new_base = div_u64(second_length, NTP_INTERVAL_FREQ);
 
 	/*
 	 * Don't wait for the next second_overflow, apply
 	 * the change to the tick length immediately:
 	 */
-	tk_ntp.tick_length += new_base - tk_ntp.tick_length_base;
-	tk_ntp.tick_length_base = new_base;
+	timekeeper.ntp.tick_length += new_base - timekeeper.ntp.tick_length_base;
+	timekeeper.ntp.tick_length_base = new_base;
 }
 
 static inline s64 ntp_update_offset_fll(s64 offset64, long secs)
 {
-	tk_ntp.time_status &= ~STA_MODE;
+	timekeeper.ntp.time_status &= ~STA_MODE;
 
 	if (secs < MINSEC)
 		return 0;
 
-	if (!(tk_ntp.time_status & STA_FLL) && (secs <= MAXSEC))
+	if (!(timekeeper.ntp.time_status & STA_FLL) && (secs <= MAXSEC))
 		return 0;
 
-	tk_ntp.time_status |= STA_MODE;
+	timekeeper.ntp.time_status |= STA_MODE;
 
 	return div64_long(offset64 << (NTP_SCALE_SHIFT - SHIFT_FLL), secs);
 }
@@ -226,10 +217,10 @@ static void ntp_update_offset(long offset)
 	s64 offset64;
 	long secs;
 
-	if (!(tk_ntp.time_status & STA_PLL))
+	if (!(timekeeper.ntp.time_status & STA_PLL))
 		return;
 
-	if (!(tk_ntp.time_status & STA_NANO))
+	if (!(timekeeper.ntp.time_status & STA_NANO))
 		offset *= NSEC_PER_USEC;
 
 	/*
@@ -243,11 +234,11 @@ static void ntp_update_offset(long offset)
 	 * Select how the frequency is to be controlled
 	 * and in which mode (PLL or FLL).
 	 */
-	secs = get_seconds() - tk_ntp.time_reftime;
-	if (unlikely(tk_ntp.time_status & STA_FREQHOLD))
+	secs = get_seconds() - timekeeper.ntp.time_reftime;
+	if (unlikely(timekeeper.ntp.time_status & STA_FREQHOLD))
 		secs = 0;
 
-	tk_ntp.time_reftime = get_seconds();
+	timekeeper.ntp.time_reftime = get_seconds();
 
 	offset64    = offset;
 	freq_adj    = ntp_update_offset_fll(offset64, secs);
@@ -257,17 +248,17 @@ static void ntp_update_offset(long offset)
 	 * sampling rate (e.g. intermittent network connection)
 	 * to avoid instability.
 	 */
-	if (unlikely(secs > 1 << (SHIFT_PLL + 1 + tk_ntp.time_constant)))
-		secs = 1 << (SHIFT_PLL + 1 + tk_ntp.time_constant);
+	if (unlikely(secs > 1 << (SHIFT_PLL + 1 + timekeeper.ntp.time_constant)))
+		secs = 1 << (SHIFT_PLL + 1 + timekeeper.ntp.time_constant);
 
 	freq_adj    += (offset64 * secs) <<
-		(NTP_SCALE_SHIFT - 2 * (SHIFT_PLL + 2 + tk_ntp.time_constant));
+		(NTP_SCALE_SHIFT - 2 * (SHIFT_PLL + 2 + timekeeper.ntp.time_constant));
 
-	freq_adj    = min(freq_adj + tk_ntp.time_freq, MAXFREQ_SCALED);
+	freq_adj    = min(freq_adj + timekeeper.ntp.time_freq, MAXFREQ_SCALED);
 
-	tk_ntp.time_freq   = max(freq_adj, -MAXFREQ_SCALED);
+	timekeeper.ntp.time_freq   = max(freq_adj, -MAXFREQ_SCALED);
 
-	tk_ntp.time_offset = div_s64(offset64 << NTP_SCALE_SHIFT,
+	timekeeper.ntp.time_offset = div_s64(offset64 << NTP_SCALE_SHIFT,
 		NTP_INTERVAL_FREQ);
 }
 
@@ -276,15 +267,15 @@ static void ntp_update_offset(long offset)
  */
 void ntp_clear(void)
 {
-	tk_ntp.time_adjust	= 0;		/* stop active adjtime() */
-	tk_ntp.time_status	|= STA_UNSYNC;
-	tk_ntp.time_maxerror	= NTP_PHASE_LIMIT;
-	tk_ntp.time_esterror	= NTP_PHASE_LIMIT;
+	timekeeper.ntp.time_adjust	= 0;		/* stop active adjtime() */
+	timekeeper.ntp.time_status	|= STA_UNSYNC;
+	timekeeper.ntp.time_maxerror	= NTP_PHASE_LIMIT;
+	timekeeper.ntp.time_esterror	= NTP_PHASE_LIMIT;
 
 	ntp_update_frequency();
 
-	tk_ntp.tick_length	= tk_ntp.tick_length_base;
-	tk_ntp.time_offset	= 0;
+	timekeeper.ntp.tick_length	= timekeeper.ntp.tick_length_base;
+	timekeeper.ntp.time_offset	= 0;
 
 	/* Clear PPS state variables */
 	pps_clear();
@@ -293,7 +284,7 @@ void ntp_clear(void)
 
 u64 ntp_tick_length(void)
 {
-	return tk_ntp.tick_length;
+	return timekeeper.ntp.tick_length;
 }
 
 
@@ -317,80 +308,80 @@ int second_overflow(unsigned long secs)
 	 * day, the system clock is set back one second; if in leap-delete
 	 * state, the system clock is set ahead one second.
 	 */
-	switch (tk_ntp.time_state) {
+	switch (timekeeper.ntp.time_state) {
 	case TIME_OK:
-		if (tk_ntp.time_status & STA_INS)
-			tk_ntp.time_state = TIME_INS;
-		else if (tk_ntp.time_status & STA_DEL)
-			tk_ntp.time_state = TIME_DEL;
+		if (timekeeper.ntp.time_status & STA_INS)
+			timekeeper.ntp.time_state = TIME_INS;
+		else if (timekeeper.ntp.time_status & STA_DEL)
+			timekeeper.ntp.time_state = TIME_DEL;
 		break;
 	case TIME_INS:
-		if (!(tk_ntp.time_status & STA_INS))
-			tk_ntp.time_state = TIME_OK;
+		if (!(timekeeper.ntp.time_status & STA_INS))
+			timekeeper.ntp.time_state = TIME_OK;
 		else if (secs % 86400 == 0) {
 			leap = -1;
-			tk_ntp.time_state = TIME_OOP;
+			timekeeper.ntp.time_state = TIME_OOP;
 			printk(KERN_NOTICE
 				"Clock: inserting leap second 23:59:60 UTC\n");
 		}
 		break;
 	case TIME_DEL:
-		if (!(tk_ntp.time_status & STA_DEL))
-			tk_ntp.time_state = TIME_OK;
+		if (!(timekeeper.ntp.time_status & STA_DEL))
+			timekeeper.ntp.time_state = TIME_OK;
 		else if ((secs + 1) % 86400 == 0) {
 			leap = 1;
-			tk_ntp.time_state = TIME_WAIT;
+			timekeeper.ntp.time_state = TIME_WAIT;
 			printk(KERN_NOTICE
 				"Clock: deleting leap second 23:59:59 UTC\n");
 		}
 		break;
 	case TIME_OOP:
-		tk_ntp.time_state = TIME_WAIT;
+		timekeeper.ntp.time_state = TIME_WAIT;
 		break;
 
 	case TIME_WAIT:
-		if (!(tk_ntp.time_status & (STA_INS | STA_DEL)))
-			tk_ntp.time_state = TIME_OK;
+		if (!(timekeeper.ntp.time_status & (STA_INS | STA_DEL)))
+			timekeeper.ntp.time_state = TIME_OK;
 		break;
 	}
 
 
 	/* Bump the maxerror field */
-	tk_ntp.time_maxerror += MAXFREQ / NSEC_PER_USEC;
-	if (tk_ntp.time_maxerror > NTP_PHASE_LIMIT) {
-		tk_ntp.time_maxerror = NTP_PHASE_LIMIT;
-		tk_ntp.time_status |= STA_UNSYNC;
+	timekeeper.ntp.time_maxerror += MAXFREQ / NSEC_PER_USEC;
+	if (timekeeper.ntp.time_maxerror > NTP_PHASE_LIMIT) {
+		timekeeper.ntp.time_maxerror = NTP_PHASE_LIMIT;
+		timekeeper.ntp.time_status |= STA_UNSYNC;
 	}
 
 	/* Compute the phase adjustment for the next second */
-	tk_ntp.tick_length = tk_ntp.tick_length_base;
+	timekeeper.ntp.tick_length = timekeeper.ntp.tick_length_base;
 
-	delta = ntp_offset_chunk(tk_ntp.time_offset);
-	tk_ntp.time_offset -= delta;
-	tk_ntp.tick_length += delta;
+	delta = ntp_offset_chunk(timekeeper.ntp.time_offset);
+	timekeeper.ntp.time_offset -= delta;
+	timekeeper.ntp.tick_length += delta;
 
 	/* Check PPS signal */
 	pps_dec_valid();
 
-	if (!tk_ntp.time_adjust)
+	if (!timekeeper.ntp.time_adjust)
 		goto out;
 
-	if (tk_ntp.time_adjust > MAX_TICKADJ) {
-		tk_ntp.time_adjust -= MAX_TICKADJ;
-		tk_ntp.tick_length += MAX_TICKADJ_SCALED;
+	if (timekeeper.ntp.time_adjust > MAX_TICKADJ) {
+		timekeeper.ntp.time_adjust -= MAX_TICKADJ;
+		timekeeper.ntp.tick_length += MAX_TICKADJ_SCALED;
 		goto out;
 	}
 
-	if (tk_ntp.time_adjust < -MAX_TICKADJ) {
-		tk_ntp.time_adjust += MAX_TICKADJ;
-		tk_ntp.tick_length -= MAX_TICKADJ_SCALED;
+	if (timekeeper.ntp.time_adjust < -MAX_TICKADJ) {
+		timekeeper.ntp.time_adjust += MAX_TICKADJ;
+		timekeeper.ntp.tick_length -= MAX_TICKADJ_SCALED;
 		goto out;
 	}
 
-	tk_ntp.tick_length +=
-		(s64)(tk_ntp.time_adjust * NSEC_PER_USEC / NTP_INTERVAL_FREQ)
+	timekeeper.ntp.tick_length +=
+		(s64)(timekeeper.ntp.time_adjust * NSEC_PER_USEC / NTP_INTERVAL_FREQ)
 							 << NTP_SCALE_SHIFT;
-	tk_ntp.time_adjust = 0;
+	timekeeper.ntp.time_adjust = 0;
 
 out:
 	return leap;
@@ -422,7 +413,7 @@ static void sync_cmos_clock(struct work_struct *work)
 	}
 
 	getnstimeofday(&now);
-	if (abs(now.tv_nsec - (NSEC_PER_SEC / 2)) <= tk_ntp.tick_nsec / 2) {
+	if (abs(now.tv_nsec - (NSEC_PER_SEC / 2)) <= timekeeper.ntp.tick_nsec / 2) {
 		struct timespec adjust = now;
 
 		fail = -ENODEV;
@@ -468,9 +459,9 @@ void ntp_notify_cmos_timer(void) { }
  */
 static inline void process_adj_status(struct timex *txc, struct timespec *ts)
 {
-	if ((tk_ntp.time_status & STA_PLL) && !(txc->status & STA_PLL)) {
-		tk_ntp.time_state = TIME_OK;
-		tk_ntp.time_status = STA_UNSYNC;
+	if ((timekeeper.ntp.time_status & STA_PLL) && !(txc->status & STA_PLL)) {
+		timekeeper.ntp.time_state = TIME_OK;
+		timekeeper.ntp.time_status = STA_UNSYNC;
 		/* restart PPS frequency calibration */
 		pps_reset_freq_interval();
 	}
@@ -479,12 +470,12 @@ static inline void process_adj_status(struct timex *txc, struct timespec *ts)
 	 * If we turn on PLL adjustments then reset the
 	 * reference time to current time.
 	 */
-	if (!(tk_ntp.time_status & STA_PLL) && (txc->status & STA_PLL))
-		tk_ntp.time_reftime = get_seconds();
+	if (!(timekeeper.ntp.time_status & STA_PLL) && (txc->status & STA_PLL))
+		timekeeper.ntp.time_reftime = get_seconds();
 
 	/* only set allowed bits */
-	tk_ntp.time_status &= STA_RONLY;
-	tk_ntp.time_status |= txc->status & ~STA_RONLY;
+	timekeeper.ntp.time_status &= STA_RONLY;
+	timekeeper.ntp.time_status |= txc->status & ~STA_RONLY;
 }
 
 
@@ -496,31 +487,31 @@ static inline void process_adjtimex_modes(struct timex *txc,
 		process_adj_status(txc, ts);
 
 	if (txc->modes & ADJ_NANO)
-		tk_ntp.time_status |= STA_NANO;
+		timekeeper.ntp.time_status |= STA_NANO;
 
 	if (txc->modes & ADJ_MICRO)
-		tk_ntp.time_status &= ~STA_NANO;
+		timekeeper.ntp.time_status &= ~STA_NANO;
 
 	if (txc->modes & ADJ_FREQUENCY) {
-		tk_ntp.time_freq = txc->freq * PPM_SCALE;
-		tk_ntp.time_freq = min(tk_ntp.time_freq, MAXFREQ_SCALED);
-		tk_ntp.time_freq = max(tk_ntp.time_freq, -MAXFREQ_SCALED);
-		/* update tk_ntp.pps.freq */
-		pps_set_freq(tk_ntp.time_freq);
+		timekeeper.ntp.time_freq = txc->freq * PPM_SCALE;
+		timekeeper.ntp.time_freq = min(timekeeper.ntp.time_freq, MAXFREQ_SCALED);
+		timekeeper.ntp.time_freq = max(timekeeper.ntp.time_freq, -MAXFREQ_SCALED);
+		/* update timekeeper.ntp.pps.freq */
+		pps_set_freq(timekeeper.ntp.time_freq);
 	}
 
 	if (txc->modes & ADJ_MAXERROR)
-		tk_ntp.time_maxerror = txc->maxerror;
+		timekeeper.ntp.time_maxerror = txc->maxerror;
 
 	if (txc->modes & ADJ_ESTERROR)
-		tk_ntp.time_esterror = txc->esterror;
+		timekeeper.ntp.time_esterror = txc->esterror;
 
 	if (txc->modes & ADJ_TIMECONST) {
-		tk_ntp.time_constant = txc->constant;
-		if (!(tk_ntp.time_status & STA_NANO))
-			tk_ntp.time_constant += 4;
-		tk_ntp.time_constant = min(tk_ntp.time_constant, (long)MAXTC);
-		tk_ntp.time_constant = max(tk_ntp.time_constant, 0l);
+		timekeeper.ntp.time_constant = txc->constant;
+		if (!(timekeeper.ntp.time_status & STA_NANO))
+			timekeeper.ntp.time_constant += 4;
+		timekeeper.ntp.time_constant = min(timekeeper.ntp.time_constant, (long)MAXTC);
+		timekeeper.ntp.time_constant = max(timekeeper.ntp.time_constant, 0l);
 	}
 
 	if (txc->modes & ADJ_TAI && txc->constant > 0)
@@ -530,7 +521,7 @@ static inline void process_adjtimex_modes(struct timex *txc,
 		ntp_update_offset(txc->offset);
 
 	if (txc->modes & ADJ_TICK)
-		tk_ntp.tick_usec = txc->tick;
+		timekeeper.ntp.tick_usec = txc->tick;
 
 	if (txc->modes & (ADJ_TICK|ADJ_FREQUENCY|ADJ_OFFSET))
 		ntp_update_frequency();
@@ -580,11 +571,11 @@ int __do_adjtimex(struct timex *txc, struct timespec *ts, s32 *time_tai)
 	int result;
 
 	if (txc->modes & ADJ_ADJTIME) {
-		long save_adjust = tk_ntp.time_adjust;
+		long save_adjust = timekeeper.ntp.time_adjust;
 
 		if (!(txc->modes & ADJ_OFFSET_READONLY)) {
 			/* adjtime() is independent from ntp_adjtime() */
-			tk_ntp.time_adjust = txc->offset;
+			timekeeper.ntp.time_adjust = txc->offset;
 			ntp_update_frequency();
 		}
 		txc->offset = save_adjust;
@@ -595,26 +586,26 @@ int __do_adjtimex(struct timex *txc, struct timespec *ts, s32 *time_tai)
 			process_adjtimex_modes(txc, ts, time_tai);
 
 		txc->offset =
-			shift_right(tk_ntp.time_offset * NTP_INTERVAL_FREQ,
+			shift_right(timekeeper.ntp.time_offset * NTP_INTERVAL_FREQ,
 				  NTP_SCALE_SHIFT);
-		if (!(tk_ntp.time_status & STA_NANO))
+		if (!(timekeeper.ntp.time_status & STA_NANO))
 			txc->offset /= NSEC_PER_USEC;
 	}
 
-	result = tk_ntp.time_state;	/* mostly `TIME_OK' */
+	result = timekeeper.ntp.time_state;	/* mostly `TIME_OK' */
 	/* check for errors */
-	if (is_error_status(tk_ntp.time_status))
+	if (is_error_status(timekeeper.ntp.time_status))
 		result = TIME_ERROR;
 
-	txc->freq = shift_right((tk_ntp.time_freq >> PPM_SCALE_INV_SHIFT) *
+	txc->freq = shift_right((timekeeper.ntp.time_freq >> PPM_SCALE_INV_SHIFT) *
 		PPM_SCALE_INV, NTP_SCALE_SHIFT);
-	txc->maxerror = tk_ntp.time_maxerror;
-	txc->esterror = tk_ntp.time_esterror;
-	txc->status = tk_ntp.time_status;
-	txc->constant = tk_ntp.time_constant;
+	txc->maxerror = timekeeper.ntp.time_maxerror;
+	txc->esterror = timekeeper.ntp.time_esterror;
+	txc->status = timekeeper.ntp.time_status;
+	txc->constant = timekeeper.ntp.time_constant;
 	txc->precision = 1;
 	txc->tolerance = MAXFREQ_SCALED / PPM_SCALE;
-	txc->tick = tk_ntp.tick_usec;
+	txc->tick = timekeeper.ntp.tick_usec;
 	txc->tai = *time_tai;
 
 	/* fill PPS status fields */
@@ -622,7 +613,7 @@ int __do_adjtimex(struct timex *txc, struct timespec *ts, s32 *time_tai)
 
 	txc->time.tv_sec = ts->tv_sec;
 	txc->time.tv_usec = ts->tv_nsec;
-	if (!(tk_ntp.time_status & STA_NANO))
+	if (!(timekeeper.ntp.time_status & STA_NANO))
 		txc->time.tv_usec /= NSEC_PER_USEC;
 
 	return result;
@@ -659,20 +650,20 @@ static inline struct pps_normtime pps_normalize_ts(struct timespec ts)
 /* get current phase correction and jitter */
 static inline long pps_phase_filter_get(long *jitter)
 {
-	*jitter = tk_ntp.pps.tf[0] - tk_ntp.pps.tf[1];
+	*jitter = timekeeper.ntp.pps.tf[0] - timekeeper.ntp.pps.tf[1];
 	if (*jitter < 0)
 		*jitter = -*jitter;
 
 	/* TODO: test various filters */
-	return tk_ntp.pps.tf[0];
+	return timekeeper.ntp.pps.tf[0];
 }
 
 /* add the sample to the phase filter */
 static inline void pps_phase_filter_add(long err)
 {
-	tk_ntp.pps.tf[2] = tk_ntp.pps.tf[1];
-	tk_ntp.pps.tf[1] = tk_ntp.pps.tf[0];
-	tk_ntp.pps.tf[0] = err;
+	timekeeper.ntp.pps.tf[2] = timekeeper.ntp.pps.tf[1];
+	timekeeper.ntp.pps.tf[1] = timekeeper.ntp.pps.tf[0];
+	timekeeper.ntp.pps.tf[0] = err;
 }
 
 /* decrease frequency calibration interval length.
@@ -680,11 +671,11 @@ static inline void pps_phase_filter_add(long err)
  */
 static inline void pps_dec_freq_interval(void)
 {
-	if (--tk_ntp.pps.intcnt <= -PPS_INTCOUNT) {
-		tk_ntp.pps.intcnt = -PPS_INTCOUNT;
-		if (tk_ntp.pps.shift > PPS_INTMIN) {
-			tk_ntp.pps.shift--;
-			tk_ntp.pps.intcnt = 0;
+	if (--timekeeper.ntp.pps.intcnt <= -PPS_INTCOUNT) {
+		timekeeper.ntp.pps.intcnt = -PPS_INTCOUNT;
+		if (timekeeper.ntp.pps.shift > PPS_INTMIN) {
+			timekeeper.ntp.pps.shift--;
+			timekeeper.ntp.pps.intcnt = 0;
 		}
 	}
 }
@@ -694,11 +685,11 @@ static inline void pps_dec_freq_interval(void)
  */
 static inline void pps_inc_freq_interval(void)
 {
-	if (++tk_ntp.pps.intcnt >= PPS_INTCOUNT) {
-		tk_ntp.pps.intcnt = PPS_INTCOUNT;
-		if (tk_ntp.pps.shift < PPS_INTMAX) {
-			tk_ntp.pps.shift++;
-			tk_ntp.pps.intcnt = 0;
+	if (++timekeeper.ntp.pps.intcnt >= PPS_INTCOUNT) {
+		timekeeper.ntp.pps.intcnt = PPS_INTCOUNT;
+		if (timekeeper.ntp.pps.shift < PPS_INTMAX) {
+			timekeeper.ntp.pps.shift++;
+			timekeeper.ntp.pps.intcnt = 0;
 		}
 	}
 }
@@ -718,9 +709,9 @@ static long hardpps_update_freq(struct pps_normtime freq_norm)
 	s64 ftemp;
 
 	/* check if the frequency interval was too long */
-	if (freq_norm.sec > (2 << tk_ntp.pps.shift)) {
-		tk_ntp.time_status |= STA_PPSERROR;
-		tk_ntp.pps.errcnt++;
+	if (freq_norm.sec > (2 << timekeeper.ntp.pps.shift)) {
+		timekeeper.ntp.time_status |= STA_PPSERROR;
+		timekeeper.ntp.pps.errcnt++;
 		pps_dec_freq_interval();
 		pr_err("hardpps: PPSERROR: interval too long - %ld s\n",
 				freq_norm.sec);
@@ -733,12 +724,12 @@ static long hardpps_update_freq(struct pps_normtime freq_norm)
 	 */
 	ftemp = div_s64(((s64)(-freq_norm.nsec)) << NTP_SCALE_SHIFT,
 			freq_norm.sec);
-	delta = shift_right(ftemp - tk_ntp.pps.freq, NTP_SCALE_SHIFT);
-	tk_ntp.pps.freq = ftemp;
+	delta = shift_right(ftemp - timekeeper.ntp.pps.freq, NTP_SCALE_SHIFT);
+	timekeeper.ntp.pps.freq = ftemp;
 	if (delta > PPS_MAXWANDER || delta < -PPS_MAXWANDER) {
 		pr_warning("hardpps: PPSWANDER: change=%ld\n", delta);
-		tk_ntp.time_status |= STA_PPSWANDER;
-		tk_ntp.pps.stbcnt++;
+		timekeeper.ntp.time_status |= STA_PPSWANDER;
+		timekeeper.ntp.pps.stbcnt++;
 		pps_dec_freq_interval();
 	} else {	/* good sample */
 		pps_inc_freq_interval();
@@ -751,14 +742,14 @@ static long hardpps_update_freq(struct pps_normtime freq_norm)
 	delta_mod = delta;
 	if (delta_mod < 0)
 		delta_mod = -delta_mod;
-	tk_ntp.pps.stabil += (div_s64(((s64)delta_mod) <<
+	timekeeper.ntp.pps.stabil += (div_s64(((s64)delta_mod) <<
 		(NTP_SCALE_SHIFT - SHIFT_USEC),
-		NSEC_PER_USEC) - tk_ntp.pps.stabil) >> PPS_INTMIN;
+		NSEC_PER_USEC) - timekeeper.ntp.pps.stabil) >> PPS_INTMIN;
 
 	/* if enabled, the system clock frequency is updated */
-	if ((tk_ntp.time_status & STA_PPSFREQ) != 0 &&
-	    (tk_ntp.time_status & STA_FREQHOLD) == 0) {
-		tk_ntp.time_freq = tk_ntp.pps.freq;
+	if ((timekeeper.ntp.time_status & STA_PPSFREQ) != 0 &&
+	    (timekeeper.ntp.time_status & STA_FREQHOLD) == 0) {
+		timekeeper.ntp.time_freq = timekeeper.ntp.pps.freq;
 		ntp_update_frequency();
 	}
 
@@ -779,21 +770,21 @@ static void hardpps_update_phase(long error)
 	 * threshold, the sample is discarded; otherwise, if so enabled,
 	 * the time offset is updated.
 	 */
-	if (jitter > (tk_ntp.pps.jitter << PPS_POPCORN)) {
+	if (jitter > (timekeeper.ntp.pps.jitter << PPS_POPCORN)) {
 		pr_warning("hardpps: PPSJITTER: jitter=%ld, limit=%ld\n",
-		       jitter, (tk_ntp.pps.jitter << PPS_POPCORN));
-		tk_ntp.time_status |= STA_PPSJITTER;
-		tk_ntp.pps.jitcnt++;
-	} else if (tk_ntp.time_status & STA_PPSTIME) {
+		       jitter, (timekeeper.ntp.pps.jitter << PPS_POPCORN));
+		timekeeper.ntp.time_status |= STA_PPSJITTER;
+		timekeeper.ntp.pps.jitcnt++;
+	} else if (timekeeper.ntp.time_status & STA_PPSTIME) {
 		/* correct the time using the phase offset */
-		tk_ntp.time_offset =
+		timekeeper.ntp.time_offset =
 			div_s64(((s64)correction) << NTP_SCALE_SHIFT,
 				NTP_INTERVAL_FREQ);
 		/* cancel running adjtime() */
-		tk_ntp.time_adjust = 0;
+		timekeeper.ntp.time_adjust = 0;
 	}
 	/* update jitter */
-	tk_ntp.pps.jitter += (jitter - tk_ntp.pps.jitter) >> PPS_INTMIN;
+	timekeeper.ntp.pps.jitter += (jitter - timekeeper.ntp.pps.jitter) >> PPS_INTMIN;
 }
 
 /*
@@ -815,31 +806,31 @@ void __hardpps(const struct timespec *phase_ts, const struct timespec *raw_ts)
 	pts_norm = pps_normalize_ts(*phase_ts);
 
 	/* clear the error bits, they will be set again if needed */
-	tk_ntp.time_status &= ~(STA_PPSJITTER | STA_PPSWANDER | STA_PPSERROR);
+	timekeeper.ntp.time_status &= ~(STA_PPSJITTER | STA_PPSWANDER | STA_PPSERROR);
 
 	/* indicate signal presence */
-	tk_ntp.time_status |= STA_PPSSIGNAL;
-	tk_ntp.pps.valid = PPS_VALID;
+	timekeeper.ntp.time_status |= STA_PPSSIGNAL;
+	timekeeper.ntp.pps.valid = PPS_VALID;
 
 	/* when called for the first time,
 	 * just start the frequency interval */
-	if (unlikely(tk_ntp.pps.fbase.tv_sec == 0)) {
-		tk_ntp.pps.fbase = *raw_ts;
+	if (unlikely(timekeeper.ntp.pps.fbase.tv_sec == 0)) {
+		timekeeper.ntp.pps.fbase = *raw_ts;
 		return;
 	}
 
 	/* ok, now we have a base for frequency calculation */
 	freq_norm = pps_normalize_ts(timespec_sub(*raw_ts,
-		tk_ntp.pps.fbase));
+		timekeeper.ntp.pps.fbase));
 
 	/* check that the signal is in the range
 	 * [1s - MAXFREQ us, 1s + MAXFREQ us], otherwise reject it */
 	if ((freq_norm.sec == 0) ||
 			(freq_norm.nsec > MAXFREQ * freq_norm.sec) ||
 			(freq_norm.nsec < -MAXFREQ * freq_norm.sec)) {
-		tk_ntp.time_status |= STA_PPSJITTER;
+		timekeeper.ntp.time_status |= STA_PPSJITTER;
 		/* restart the frequency calibration interval */
-		tk_ntp.pps.fbase = *raw_ts;
+		timekeeper.ntp.pps.fbase = *raw_ts;
 		pr_err("hardpps: PPSJITTER: bad pulse\n");
 		return;
 	}
@@ -847,10 +838,10 @@ void __hardpps(const struct timespec *phase_ts, const struct timespec *raw_ts)
 	/* signal is ok */
 
 	/* check if the current frequency interval is finished */
-	if (freq_norm.sec >= (1 << tk_ntp.pps.shift)) {
-		tk_ntp.pps.calcnt++;
+	if (freq_norm.sec >= (1 << timekeeper.ntp.pps.shift)) {
+		timekeeper.ntp.pps.calcnt++;
 		/* restart the frequency calibration interval */
-		tk_ntp.pps.fbase = *raw_ts;
+		timekeeper.ntp.pps.fbase = *raw_ts;
 		hardpps_update_freq(freq_norm);
 	}
 
@@ -861,8 +852,8 @@ void __hardpps(const struct timespec *phase_ts, const struct timespec *raw_ts)
 
 static int __init ntp_tick_adj_setup(char *str)
 {
-	tk_ntp.ntp_tick_adj = simple_strtol(str, NULL, 0);
-	tk_ntp.ntp_tick_adj <<= NTP_SCALE_SHIFT;
+	timekeeper.ntp.ntp_tick_adj = simple_strtol(str, NULL, 0);
+	timekeeper.ntp.ntp_tick_adj <<= NTP_SCALE_SHIFT;
 
 	return 1;
 }
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 947ba25..d1ecafb 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -31,7 +31,17 @@
 #define TK_MIRROR		(1 << 1)
 #define TK_CLOCK_WAS_SET	(1 << 2)
 
-static struct timekeeper timekeeper;
+struct timekeeper timekeeper = {
+	.ntp = {
+		.tick_usec = TICK_USEC,
+		.time_state = TIME_OK,
+		.time_status = STA_UNSYNC,
+		.time_constant = 2,
+		.time_maxerror = NTP_PHASE_LIMIT,
+		.time_esterror = NTP_PHASE_LIMIT,
+	},
+};
+
 static DEFINE_RAW_SPINLOCK(timekeeper_lock);
 static seqcount_t timekeeper_seq;
 static struct timekeeper shadow_timekeeper;
-- 
1.7.10.4

