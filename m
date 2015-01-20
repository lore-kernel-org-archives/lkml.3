Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795AbbATQlr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 11:41:47 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:56734 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380AbbATQlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 11:41:44 -0500
From: Xunlei Pang <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: rtc-linux@googlegroups.com, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Feng Tang <feng.tang@intel.com>, John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Xunlei Pang <pang.xunlei@linaro.org>
Subject: [PATCH 1/3] time: Don't bother to run rtc_resume() for nonstop clocksource
Date: Tue, 20 Jan 2015 16:41:28 +0000
Message-Id: <1421772090-13113-1-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 2.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a system does not provide a persistent_clock(), the time will be
updated on resume by rtc_resume(). With the addition of the non-stop
clocksources for suspend timing, those systems set the time on resume
in timekeeping_resume(), but may not provide a valid persistent_clock().

This results in the rtc_resume() logic thinking no one has set the time
and it then will over-write the suspend time again, which is not necessary
and only increases clock error.

So, fix this for rtc_resume().

Signed-off-by: Xunlei Pang <pang.xunlei@linaro.org>
---
 drivers/rtc/class.c         |  2 +-
 include/linux/timekeeping.h | 11 +++++++++++
 kernel/time/timekeeping.c   |  3 ++-
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index 472a5ad..c8f35a5 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -102,7 +102,7 @@ static int rtc_resume(struct device *dev)
 	struct timespec64	sleep_time;
 	int err;
 
-	if (has_persistent_clock())
+	if (rtc_resume_skip())
 		return 0;
 
 	rtc_hctosys_ret = -ENODEV;
diff --git a/include/linux/timekeeping.h b/include/linux/timekeeping.h
index 9b63d13..6f3283b 100644
--- a/include/linux/timekeeping.h
+++ b/include/linux/timekeeping.h
@@ -238,6 +238,17 @@ extern void getnstime_raw_and_real(struct timespec *ts_raw,
  */
 extern bool persistent_clock_exist;
 extern int persistent_clock_is_local;
+extern bool suspendtime_found;
+
+#ifdef CONFIG_RTC_LIB
+/* Used by rtc_resume() */
+static inline bool rtc_resume_skip(void)
+{
+	return suspendtime_found;
+}
+#else
+static inline void rtc_resume_skip(void) { }
+#endif
 
 static inline bool has_persistent_clock(void)
 {
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 6a93185..586bb5c 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -65,6 +65,7 @@ int __read_mostly timekeeping_suspended;
 
 /* Flag for if there is a persistent clock on this platform */
 bool __read_mostly persistent_clock_exist = false;
+bool suspendtime_found;
 
 static inline void tk_normalize_xtime(struct timekeeper *tk)
 {
@@ -1178,8 +1179,8 @@ static void timekeeping_resume(void)
 	struct timespec64 ts_new, ts_delta;
 	struct timespec tmp;
 	cycle_t cycle_now, cycle_delta;
-	bool suspendtime_found = false;
 
+	suspendtime_found = false;
 	read_persistent_clock(&tmp);
 	ts_new = timespec_to_timespec64(tmp);
 
-- 
1.9.1

