Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061AbbAVMC2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 07:02:28 -0500
Received: from mail-qg0-f47.google.com ([209.85.192.47]:61934 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbbAVMCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 07:02:25 -0500
From: Xunlei Pang <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: rtc-linux@googlegroups.com, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Xunlei Pang <pang.xunlei@linaro.org>
Subject: [PATCH v2 1/3] time: Don't bother to run rtc_resume() for the nonstop clocksource
Date: Thu, 22 Jan 2015 12:01:15 +0000
Message-Id: <1421928077-4698-1-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 2.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a system does not provide a persistent_clock(), the time
will be updated on resume by rtc_resume(). With the addition
of the non-stop clocksources for suspend timing, those systems
set the time on resume in timekeeping_resume(), but may not
provide a valid persistent_clock().

This results in the rtc_resume() logic thinking no one has set
the time and it then will over-write the suspend time again,
which is not necessary and only increases clock error.

So, fix this for rtc_resume().

Signed-off-by: Xunlei Pang <pang.xunlei@linaro.org>
---
v1->v2:
Modify according to Thomas' feedback.

 drivers/rtc/class.c         |  2 +-
 include/linux/timekeeping.h |  7 +++++++
 kernel/time/timekeeping.c   | 16 +++++-----------
 3 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index 472a5ad..6100af5 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -102,7 +102,7 @@ static int rtc_resume(struct device *dev)
 	struct timespec64	sleep_time;
 	int err;
 
-	if (has_persistent_clock())
+	if (timekeeping_sleeptime_injected())
 		return 0;
 
 	rtc_hctosys_ret = -ENODEV;
diff --git a/include/linux/timekeeping.h b/include/linux/timekeeping.h
index 9b63d13..2b87c64 100644
--- a/include/linux/timekeeping.h
+++ b/include/linux/timekeeping.h
@@ -238,6 +238,13 @@ extern void getnstime_raw_and_real(struct timespec *ts_raw,
  */
 extern bool persistent_clock_exist;
 extern int persistent_clock_is_local;
+extern bool timekeeping_sleeptime_inject;
+
+/* Used by rtc_resume() */
+static inline bool timekeeping_sleeptime_injected(void)
+{
+	return timekeeping_sleeptime_inject;
+}
 
 static inline bool has_persistent_clock(void)
 {
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 6a93185..732ccd0 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -65,6 +65,7 @@ int __read_mostly timekeeping_suspended;
 
 /* Flag for if there is a persistent clock on this platform */
 bool __read_mostly persistent_clock_exist = false;
+bool timekeeping_sleeptime_inject;
 
 static inline void tk_normalize_xtime(struct timekeeper *tk)
 {
@@ -1140,13 +1141,6 @@ void timekeeping_inject_sleeptime64(struct timespec64 *delta)
 	struct timekeeper *tk = &tk_core.timekeeper;
 	unsigned long flags;
 
-	/*
-	 * Make sure we don't set the clock twice, as timekeeping_resume()
-	 * already did it
-	 */
-	if (has_persistent_clock())
-		return;
-
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
 	write_seqcount_begin(&tk_core.seq);
 
@@ -1178,8 +1172,8 @@ static void timekeeping_resume(void)
 	struct timespec64 ts_new, ts_delta;
 	struct timespec tmp;
 	cycle_t cycle_now, cycle_delta;
-	bool suspendtime_found = false;
 
+	timekeeping_sleeptime_inject = false;
 	read_persistent_clock(&tmp);
 	ts_new = timespec_to_timespec64(tmp);
 
@@ -1226,13 +1220,13 @@ static void timekeeping_resume(void)
 		nsec += ((u64) cycle_delta * mult) >> shift;
 
 		ts_delta = ns_to_timespec64(nsec);
-		suspendtime_found = true;
+		timekeeping_sleeptime_inject = true;
 	} else if (timespec64_compare(&ts_new, &timekeeping_suspend_time) > 0) {
 		ts_delta = timespec64_sub(ts_new, timekeeping_suspend_time);
-		suspendtime_found = true;
+		timekeeping_sleeptime_inject = true;
 	}
 
-	if (suspendtime_found)
+	if (timekeeping_sleeptime_inject)
 		__timekeeping_inject_sleeptime(tk, &ts_delta);
 
 	/* Re-base the last cycle value */
-- 
1.9.1

