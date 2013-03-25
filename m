Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933379Ab3CYUIj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 16:08:39 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:37326 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933095Ab3CYUIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 16:08:36 -0400
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>
Subject: [PATCH 8/8] ntp: Remove ntp_lock, using the timekeeping locks to protect ntp state
Date: Mon, 25 Mar 2013 13:08:18 -0700
Message-Id: <1364242098-5977-9-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364242098-5977-1-git-send-email-john.stultz@linaro.org>
References: <1364242098-5977-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to properly handle the NTP state in future changes to the
timekeeping lock management, this patch moves the management of
all of the ntp state under the timekeeping locks.

This allows us to remove the ntp_lock.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/ntp.c |   41 ++++-------------------------------------
 1 file changed, 4 insertions(+), 37 deletions(-)

diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index a331ebc..12ff13a 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -22,10 +22,10 @@
 
 /*
  * NTP timekeeping variables:
+ *
+ * Note: All of the NTP state is protected by the timekeeping locks.
  */
 
-DEFINE_RAW_SPINLOCK(ntp_lock);
-
 
 /* USER_HZ period (usecs): */
 unsigned long			tick_usec = TICK_USEC;
@@ -132,8 +132,6 @@ static inline void pps_reset_freq_interval(void)
 
 /**
  * pps_clear - Clears the PPS state variables
- *
- * Must be called while holding a write on the ntp_lock
  */
 static inline void pps_clear(void)
 {
@@ -148,8 +146,6 @@ static inline void pps_clear(void)
 /* Decrease pps_valid to indicate that another second has passed since
  * the last PPS signal. When it reaches 0, indicate that PPS signal is
  * missing.
- *
- * Must be called while holding a write on the ntp_lock
  */
 static inline void pps_dec_valid(void)
 {
@@ -344,10 +340,6 @@ static void ntp_update_offset(long offset)
  */
 void ntp_clear(void)
 {
-	unsigned long flags;
-
-	raw_spin_lock_irqsave(&ntp_lock, flags);
-
 	time_adjust	= 0;		/* stop active adjtime() */
 	time_status	|= STA_UNSYNC;
 	time_maxerror	= NTP_PHASE_LIMIT;
@@ -360,20 +352,12 @@ void ntp_clear(void)
 
 	/* Clear PPS state variables */
 	pps_clear();
-	raw_spin_unlock_irqrestore(&ntp_lock, flags);
-
 }
 
 
 u64 ntp_tick_length(void)
 {
-	unsigned long flags;
-	s64 ret;
-
-	raw_spin_lock_irqsave(&ntp_lock, flags);
-	ret = tick_length;
-	raw_spin_unlock_irqrestore(&ntp_lock, flags);
-	return ret;
+	return tick_length;
 }
 
 
@@ -391,9 +375,6 @@ int second_overflow(unsigned long secs)
 {
 	s64 delta;
 	int leap = 0;
-	unsigned long flags;
-
-	raw_spin_lock_irqsave(&ntp_lock, flags);
 
 	/*
 	 * Leap second processing. If in leap-insert state at the end of the
@@ -475,8 +456,6 @@ int second_overflow(unsigned long secs)
 	time_adjust = 0;
 
 out:
-	raw_spin_unlock_irqrestore(&ntp_lock, flags);
-
 	return leap;
 }
 
@@ -571,10 +550,7 @@ static inline void process_adj_status(struct timex *txc, struct timespec *ts)
 	time_status |= txc->status & ~STA_RONLY;
 }
 
-/*
- * Called with ntp_lock held, so we can access and modify
- * all the global NTP state:
- */
+
 static inline void process_adjtimex_modes(struct timex *txc,
 						struct timespec *ts,
 						s32 *time_tai)
@@ -666,8 +642,6 @@ int __do_adjtimex(struct timex *txc, struct timespec *ts, s32 *time_tai)
 {
 	int result;
 
-	raw_spin_lock_irq(&ntp_lock);
-
 	if (txc->modes & ADJ_ADJTIME) {
 		long save_adjust = time_adjust;
 
@@ -708,8 +682,6 @@ int __do_adjtimex(struct timex *txc, struct timespec *ts, s32 *time_tai)
 	/* fill PPS status fields */
 	pps_fill_timex(txc);
 
-	raw_spin_unlock_irq(&ntp_lock);
-
 	txc->time.tv_sec = ts->tv_sec;
 	txc->time.tv_usec = ts->tv_nsec;
 	if (!(time_status & STA_NANO))
@@ -906,8 +878,6 @@ void __hardpps(const struct timespec *phase_ts, const struct timespec *raw_ts)
 
 	pts_norm = pps_normalize_ts(*phase_ts);
 
-	raw_spin_lock_irqsave(&ntp_lock, flags);
-
 	/* clear the error bits, they will be set again if needed */
 	time_status &= ~(STA_PPSJITTER | STA_PPSWANDER | STA_PPSERROR);
 
@@ -919,7 +889,6 @@ void __hardpps(const struct timespec *phase_ts, const struct timespec *raw_ts)
 	 * just start the frequency interval */
 	if (unlikely(pps_fbase.tv_sec == 0)) {
 		pps_fbase = *raw_ts;
-		raw_spin_unlock_irqrestore(&ntp_lock, flags);
 		return;
 	}
 
@@ -934,7 +903,6 @@ void __hardpps(const struct timespec *phase_ts, const struct timespec *raw_ts)
 		time_status |= STA_PPSJITTER;
 		/* restart the frequency calibration interval */
 		pps_fbase = *raw_ts;
-		raw_spin_unlock_irqrestore(&ntp_lock, flags);
 		pr_err("hardpps: PPSJITTER: bad pulse\n");
 		return;
 	}
@@ -951,7 +919,6 @@ void __hardpps(const struct timespec *phase_ts, const struct timespec *raw_ts)
 
 	hardpps_update_phase(pts_norm.nsec);
 
-	raw_spin_unlock_irqrestore(&ntp_lock, flags);
 }
 #endif	/* CONFIG_NTP_PPS */
 
-- 
1.7.10.4

