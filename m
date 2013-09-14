Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932441Ab3INTsk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 15:48:40 -0400
Received: from mail.openrapids.net ([64.15.138.104]:47120 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932410Ab3INTsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 15:48:39 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH 2/7] Move PPS variables into struct timekeeper_pps
Date: Sat, 14 Sep 2013 12:47:56 -0700
Message-Id: <1379188081-15613-3-git-send-email-mathieu.desnoyers@efficios.com>
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
 include/linux/timekeeper_internal.h |   31 ++++++++
 kernel/time/ntp.c                   |  134 +++++++++++++++--------------------
 2 files changed, 87 insertions(+), 78 deletions(-)

diff --git a/include/linux/timekeeper_internal.h b/include/linux/timekeeper_internal.h
index eab26e0..02c25c0 100644
--- a/include/linux/timekeeper_internal.h
+++ b/include/linux/timekeeper_internal.h
@@ -10,6 +10,32 @@
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
+#endif /* !CONFIG_NTP_PPS */
+
 /* structure holding internal NTP timekeeping values. */
 struct timekeeper_ntp {
 	/* USER_HZ period (usecs): */
@@ -55,6 +81,11 @@ struct timekeeper_ntp {
 
 	/* constant (boot-param configurable) NTP tick adjustment (upscaled) */
 	s64			ntp_tick_adj;
+
+#ifdef CONFIG_NTP_PPS
+	/* PPS variables */
+	struct timekeeper_pps   pps;
+#endif /* CONFIG_NTP_PPS */
 };
 
 /* Structure holding internal timekeeping values. */
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 983c212..b095070 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -36,11 +36,6 @@ static struct timekeeper_ntp tk_ntp = {
 
 #ifdef CONFIG_NTP_PPS
 
-/*
- * The following variables are used when a pulse-per-second (PPS) signal
- * is available. They establish the engineering parameters of the clock
- * discipline loop when controlled by the PPS signal.
- */
 #define PPS_VALID	10	/* PPS signal watchdog max (s) */
 #define PPS_POPCORN	4	/* popcorn spike threshold (shift) */
 #define PPS_INTMIN	2	/* min freq interval (s) (shift) */
@@ -50,24 +45,6 @@ static struct timekeeper_ntp tk_ntp = {
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
@@ -84,8 +61,8 @@ static inline void pps_reset_freq_interval(void)
 {
 	/* the PPS calibration interval may end
 	   surprisingly early */
-	pps_shift = PPS_INTMIN;
-	pps_intcnt = 0;
+	tk_ntp.pps.shift = PPS_INTMIN;
+	tk_ntp.pps.intcnt = 0;
 }
 
 /**
@@ -94,11 +71,11 @@ static inline void pps_reset_freq_interval(void)
 static inline void pps_clear(void)
 {
 	pps_reset_freq_interval();
-	pps_tf[0] = 0;
-	pps_tf[1] = 0;
-	pps_tf[2] = 0;
-	pps_fbase.tv_sec = pps_fbase.tv_nsec = 0;
-	pps_freq = 0;
+	tk_ntp.pps.tf[0] = 0;
+	tk_ntp.pps.tf[1] = 0;
+	tk_ntp.pps.tf[2] = 0;
+	tk_ntp.pps.fbase.tv_sec = tk_ntp.pps.fbase.tv_nsec = 0;
+	tk_ntp.pps.freq = 0;
 }
 
 /* Decrease pps_valid to indicate that another second has passed since
@@ -107,8 +84,8 @@ static inline void pps_clear(void)
  */
 static inline void pps_dec_valid(void)
 {
-	if (pps_valid > 0)
-		pps_valid--;
+	if (tk_ntp.pps.valid > 0)
+		tk_ntp.pps.valid--;
 	else {
 		tk_ntp.time_status &= ~(STA_PPSSIGNAL | STA_PPSJITTER |
 				 STA_PPSWANDER | STA_PPSERROR);
@@ -118,7 +95,7 @@ static inline void pps_dec_valid(void)
 
 static inline void pps_set_freq(s64 freq)
 {
-	pps_freq = freq;
+	tk_ntp.pps.freq = freq;
 }
 
 static inline int is_error_status(int status)
@@ -142,17 +119,17 @@ static inline int is_error_status(int status)
 
 static inline void pps_fill_timex(struct timex *txc)
 {
-	txc->ppsfreq	   = shift_right((pps_freq >> PPM_SCALE_INV_SHIFT) *
+	txc->ppsfreq = shift_right((tk_ntp.pps.freq >> PPM_SCALE_INV_SHIFT) *
 					 PPM_SCALE_INV, NTP_SCALE_SHIFT);
-	txc->jitter	   = pps_jitter;
+	txc->jitter = tk_ntp.pps.jitter;
 	if (!(tk_ntp.time_status & STA_NANO))
 		txc->jitter /= NSEC_PER_USEC;
-	txc->shift	   = pps_shift;
-	txc->stabil	   = pps_stabil;
-	txc->jitcnt	   = pps_jitcnt;
-	txc->calcnt	   = pps_calcnt;
-	txc->errcnt	   = pps_errcnt;
-	txc->stbcnt	   = pps_stbcnt;
+	txc->shift = tk_ntp.pps.shift;
+	txc->stabil = tk_ntp.pps.stabil;
+	txc->jitcnt = tk_ntp.pps.jitcnt;
+	txc->calcnt = tk_ntp.pps.calcnt;
+	txc->errcnt = tk_ntp.pps.errcnt;
+	txc->stbcnt = tk_ntp.pps.stbcnt;
 }
 
 #else /* !CONFIG_NTP_PPS */
@@ -528,7 +505,7 @@ static inline void process_adjtimex_modes(struct timex *txc,
 		tk_ntp.time_freq = txc->freq * PPM_SCALE;
 		tk_ntp.time_freq = min(tk_ntp.time_freq, MAXFREQ_SCALED);
 		tk_ntp.time_freq = max(tk_ntp.time_freq, -MAXFREQ_SCALED);
-		/* update pps_freq */
+		/* update tk_ntp.pps.freq */
 		pps_set_freq(tk_ntp.time_freq);
 	}
 
@@ -682,20 +659,20 @@ static inline struct pps_normtime pps_normalize_ts(struct timespec ts)
 /* get current phase correction and jitter */
 static inline long pps_phase_filter_get(long *jitter)
 {
-	*jitter = pps_tf[0] - pps_tf[1];
+	*jitter = tk_ntp.pps.tf[0] - tk_ntp.pps.tf[1];
 	if (*jitter < 0)
 		*jitter = -*jitter;
 
 	/* TODO: test various filters */
-	return pps_tf[0];
+	return tk_ntp.pps.tf[0];
 }
 
 /* add the sample to the phase filter */
 static inline void pps_phase_filter_add(long err)
 {
-	pps_tf[2] = pps_tf[1];
-	pps_tf[1] = pps_tf[0];
-	pps_tf[0] = err;
+	tk_ntp.pps.tf[2] = tk_ntp.pps.tf[1];
+	tk_ntp.pps.tf[1] = tk_ntp.pps.tf[0];
+	tk_ntp.pps.tf[0] = err;
 }
 
 /* decrease frequency calibration interval length.
@@ -703,11 +680,11 @@ static inline void pps_phase_filter_add(long err)
  */
 static inline void pps_dec_freq_interval(void)
 {
-	if (--pps_intcnt <= -PPS_INTCOUNT) {
-		pps_intcnt = -PPS_INTCOUNT;
-		if (pps_shift > PPS_INTMIN) {
-			pps_shift--;
-			pps_intcnt = 0;
+	if (--tk_ntp.pps.intcnt <= -PPS_INTCOUNT) {
+		tk_ntp.pps.intcnt = -PPS_INTCOUNT;
+		if (tk_ntp.pps.shift > PPS_INTMIN) {
+			tk_ntp.pps.shift--;
+			tk_ntp.pps.intcnt = 0;
 		}
 	}
 }
@@ -717,11 +694,11 @@ static inline void pps_dec_freq_interval(void)
  */
 static inline void pps_inc_freq_interval(void)
 {
-	if (++pps_intcnt >= PPS_INTCOUNT) {
-		pps_intcnt = PPS_INTCOUNT;
-		if (pps_shift < PPS_INTMAX) {
-			pps_shift++;
-			pps_intcnt = 0;
+	if (++tk_ntp.pps.intcnt >= PPS_INTCOUNT) {
+		tk_ntp.pps.intcnt = PPS_INTCOUNT;
+		if (tk_ntp.pps.shift < PPS_INTMAX) {
+			tk_ntp.pps.shift++;
+			tk_ntp.pps.intcnt = 0;
 		}
 	}
 }
@@ -741,9 +718,9 @@ static long hardpps_update_freq(struct pps_normtime freq_norm)
 	s64 ftemp;
 
 	/* check if the frequency interval was too long */
-	if (freq_norm.sec > (2 << pps_shift)) {
+	if (freq_norm.sec > (2 << tk_ntp.pps.shift)) {
 		tk_ntp.time_status |= STA_PPSERROR;
-		pps_errcnt++;
+		tk_ntp.pps.errcnt++;
 		pps_dec_freq_interval();
 		pr_err("hardpps: PPSERROR: interval too long - %ld s\n",
 				freq_norm.sec);
@@ -756,12 +733,12 @@ static long hardpps_update_freq(struct pps_normtime freq_norm)
 	 */
 	ftemp = div_s64(((s64)(-freq_norm.nsec)) << NTP_SCALE_SHIFT,
 			freq_norm.sec);
-	delta = shift_right(ftemp - pps_freq, NTP_SCALE_SHIFT);
-	pps_freq = ftemp;
+	delta = shift_right(ftemp - tk_ntp.pps.freq, NTP_SCALE_SHIFT);
+	tk_ntp.pps.freq = ftemp;
 	if (delta > PPS_MAXWANDER || delta < -PPS_MAXWANDER) {
 		pr_warning("hardpps: PPSWANDER: change=%ld\n", delta);
 		tk_ntp.time_status |= STA_PPSWANDER;
-		pps_stbcnt++;
+		tk_ntp.pps.stbcnt++;
 		pps_dec_freq_interval();
 	} else {	/* good sample */
 		pps_inc_freq_interval();
@@ -774,14 +751,14 @@ static long hardpps_update_freq(struct pps_normtime freq_norm)
 	delta_mod = delta;
 	if (delta_mod < 0)
 		delta_mod = -delta_mod;
-	pps_stabil += (div_s64(((s64)delta_mod) <<
-				(NTP_SCALE_SHIFT - SHIFT_USEC),
-				NSEC_PER_USEC) - pps_stabil) >> PPS_INTMIN;
+	tk_ntp.pps.stabil += (div_s64(((s64)delta_mod) <<
+		(NTP_SCALE_SHIFT - SHIFT_USEC),
+		NSEC_PER_USEC) - tk_ntp.pps.stabil) >> PPS_INTMIN;
 
 	/* if enabled, the system clock frequency is updated */
 	if ((tk_ntp.time_status & STA_PPSFREQ) != 0 &&
 	    (tk_ntp.time_status & STA_FREQHOLD) == 0) {
-		tk_ntp.time_freq = pps_freq;
+		tk_ntp.time_freq = tk_ntp.pps.freq;
 		ntp_update_frequency();
 	}
 
@@ -802,11 +779,11 @@ static void hardpps_update_phase(long error)
 	 * threshold, the sample is discarded; otherwise, if so enabled,
 	 * the time offset is updated.
 	 */
-	if (jitter > (pps_jitter << PPS_POPCORN)) {
+	if (jitter > (tk_ntp.pps.jitter << PPS_POPCORN)) {
 		pr_warning("hardpps: PPSJITTER: jitter=%ld, limit=%ld\n",
-		       jitter, (pps_jitter << PPS_POPCORN));
+		       jitter, (tk_ntp.pps.jitter << PPS_POPCORN));
 		tk_ntp.time_status |= STA_PPSJITTER;
-		pps_jitcnt++;
+		tk_ntp.pps.jitcnt++;
 	} else if (tk_ntp.time_status & STA_PPSTIME) {
 		/* correct the time using the phase offset */
 		tk_ntp.time_offset =
@@ -816,7 +793,7 @@ static void hardpps_update_phase(long error)
 		tk_ntp.time_adjust = 0;
 	}
 	/* update jitter */
-	pps_jitter += (jitter - pps_jitter) >> PPS_INTMIN;
+	tk_ntp.pps.jitter += (jitter - tk_ntp.pps.jitter) >> PPS_INTMIN;
 }
 
 /*
@@ -842,17 +819,18 @@ void __hardpps(const struct timespec *phase_ts, const struct timespec *raw_ts)
 
 	/* indicate signal presence */
 	tk_ntp.time_status |= STA_PPSSIGNAL;
-	pps_valid = PPS_VALID;
+	tk_ntp.pps.valid = PPS_VALID;
 
 	/* when called for the first time,
 	 * just start the frequency interval */
-	if (unlikely(pps_fbase.tv_sec == 0)) {
-		pps_fbase = *raw_ts;
+	if (unlikely(tk_ntp.pps.fbase.tv_sec == 0)) {
+		tk_ntp.pps.fbase = *raw_ts;
 		return;
 	}
 
 	/* ok, now we have a base for frequency calculation */
-	freq_norm = pps_normalize_ts(timespec_sub(*raw_ts, pps_fbase));
+	freq_norm = pps_normalize_ts(timespec_sub(*raw_ts,
+		tk_ntp.pps.fbase));
 
 	/* check that the signal is in the range
 	 * [1s - MAXFREQ us, 1s + MAXFREQ us], otherwise reject it */
@@ -861,7 +839,7 @@ void __hardpps(const struct timespec *phase_ts, const struct timespec *raw_ts)
 			(freq_norm.nsec < -MAXFREQ * freq_norm.sec)) {
 		tk_ntp.time_status |= STA_PPSJITTER;
 		/* restart the frequency calibration interval */
-		pps_fbase = *raw_ts;
+		tk_ntp.pps.fbase = *raw_ts;
 		pr_err("hardpps: PPSJITTER: bad pulse\n");
 		return;
 	}
@@ -869,10 +847,10 @@ void __hardpps(const struct timespec *phase_ts, const struct timespec *raw_ts)
 	/* signal is ok */
 
 	/* check if the current frequency interval is finished */
-	if (freq_norm.sec >= (1 << pps_shift)) {
-		pps_calcnt++;
+	if (freq_norm.sec >= (1 << tk_ntp.pps.shift)) {
+		tk_ntp.pps.calcnt++;
 		/* restart the frequency calibration interval */
-		pps_fbase = *raw_ts;
+		tk_ntp.pps.fbase = *raw_ts;
 		hardpps_update_freq(freq_norm);
 	}
 
-- 
1.7.10.4

