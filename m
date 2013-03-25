Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933365Ab3CYUJl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 16:09:41 -0400
Received: from mail-da0-f47.google.com ([209.85.210.47]:41089 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933243Ab3CYUIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 16:08:31 -0400
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>
Subject: [PATCH 4/8] ntp: Rework do_adjtimex to take timespec and tai arguments
Date: Mon, 25 Mar 2013 13:08:14 -0700
Message-Id: <1364242098-5977-5-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364242098-5977-1-git-send-email-john.stultz@linaro.org>
References: <1364242098-5977-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to change the locking rules, we need to provide
the timespec and tai values rather then having the ntp
logic acquire these values itself.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/ntp.c          |   18 +++++-------------
 kernel/time/ntp_internal.h |    2 +-
 kernel/time/timekeeping.c  |   13 +++++++++++--
 3 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 2dc60c6..d17e13c 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -662,10 +662,8 @@ int ntp_validate_timex(struct timex *txc)
  * adjtimex mainly allows reading (and writing, if superuser) of
  * kernel time-keeping variables. used by xntpd.
  */
-int __do_adjtimex(struct timex *txc)
+int __do_adjtimex(struct timex *txc, struct timespec *ts, s32 *time_tai)
 {
-	struct timespec ts;
-	u32 time_tai, orig_tai;
 	int result;
 
 	if (txc->modes & ADJ_SETOFFSET) {
@@ -679,9 +677,6 @@ int __do_adjtimex(struct timex *txc)
 			return result;
 	}
 
-	getnstimeofday(&ts);
-	orig_tai = time_tai = timekeeping_get_tai_offset();
-
 	raw_spin_lock_irq(&ntp_lock);
 
 	if (txc->modes & ADJ_ADJTIME) {
@@ -697,7 +692,7 @@ int __do_adjtimex(struct timex *txc)
 
 		/* If there are input parameters, then process them: */
 		if (txc->modes)
-			process_adjtimex_modes(txc, &ts, &time_tai);
+			process_adjtimex_modes(txc, ts, time_tai);
 
 		txc->offset = shift_right(time_offset * NTP_INTERVAL_FREQ,
 				  NTP_SCALE_SHIFT);
@@ -719,18 +714,15 @@ int __do_adjtimex(struct timex *txc)
 	txc->precision	   = 1;
 	txc->tolerance	   = MAXFREQ_SCALED / PPM_SCALE;
 	txc->tick	   = tick_usec;
-	txc->tai	   = time_tai;
+	txc->tai	   = *time_tai;
 
 	/* fill PPS status fields */
 	pps_fill_timex(txc);
 
 	raw_spin_unlock_irq(&ntp_lock);
 
-	if (time_tai != orig_tai)
-		timekeeping_set_tai_offset(time_tai);
-
-	txc->time.tv_sec = ts.tv_sec;
-	txc->time.tv_usec = ts.tv_nsec;
+	txc->time.tv_sec = ts->tv_sec;
+	txc->time.tv_usec = ts->tv_nsec;
 	if (!(time_status & STA_NANO))
 		txc->time.tv_usec /= NSEC_PER_USEC;
 
diff --git a/kernel/time/ntp_internal.h b/kernel/time/ntp_internal.h
index a2a3976..1950cb4 100644
--- a/kernel/time/ntp_internal.h
+++ b/kernel/time/ntp_internal.h
@@ -7,6 +7,6 @@ extern void ntp_clear(void);
 extern u64 ntp_tick_length(void);
 extern int second_overflow(unsigned long secs);
 extern int ntp_validate_timex(struct timex *);
-extern int __do_adjtimex(struct timex *);
+extern int __do_adjtimex(struct timex *, struct timespec *, s32 *);
 extern void __hardpps(const struct timespec *, const struct timespec *);
 #endif /* _LINUX_NTP_INTERNAL_H */
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index f6c8a72..5f7a233 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1618,6 +1618,8 @@ EXPORT_SYMBOL_GPL(ktime_get_monotonic_offset);
  */
 int do_adjtimex(struct timex *txc)
 {
+	struct timespec ts;
+	s32 tai, orig_tai;
 	int ret;
 
 	/* Validate the data before disabling interrupts */
@@ -1625,9 +1627,16 @@ int do_adjtimex(struct timex *txc)
 	if (ret)
 		return ret;
 
-	return __do_adjtimex(txc);
-}
+	getnstimeofday(&ts);
+	orig_tai = tai = timekeeping_get_tai_offset();
+
+	ret = __do_adjtimex(txc, &ts, &tai);
 
+	if (tai != orig_tai)
+		timekeeping_set_tai_offset(tai);
+
+	return ret;
+}
 
 #ifdef CONFIG_NTP_PPS
 /**
-- 
1.7.10.4

