Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267AbaKUTpc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 14:45:32 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:36090 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbaKUTor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 14:44:47 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Arnd Bergmann <arnd.bergmann@linaro.org>,
        "pang.xunlei" <pang.xunlei@linaro.org>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: [PATCH 11/12] rtc: Update suspend/resume timing to use 64bit time
Date: Fri, 21 Nov 2014 11:44:17 -0800
Message-Id: <1416599058-13836-12-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416599058-13836-1-git-send-email-john.stultz@linaro.org>
References: <1416599058-13836-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the rtc suspend/resume timing is done using
y2038 problematic timespecs. So update the code to utilize
timespec64 types.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnd Bergmann <arnd.bergmann@linaro.org>
Cc: pang.xunlei <pang.xunlei@linaro.org>
Cc: Miroslav Lichvar <mlichvar@redhat.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/rtc/class.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index 38e26be..472a5ad 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -45,14 +45,14 @@ int rtc_hctosys_ret = -ENODEV;
  * system's wall clock; restore it on resume().
  */
 
-static struct timespec old_rtc, old_system, old_delta;
+static struct timespec64 old_rtc, old_system, old_delta;
 
 
 static int rtc_suspend(struct device *dev)
 {
 	struct rtc_device	*rtc = to_rtc_device(dev);
 	struct rtc_time		tm;
-	struct timespec		delta, delta_delta;
+	struct timespec64	delta, delta_delta;
 	int err;
 
 	if (has_persistent_clock())
@@ -68,8 +68,8 @@ static int rtc_suspend(struct device *dev)
 		return 0;
 	}
 
-	getnstimeofday(&old_system);
-	rtc_tm_to_time(&tm, &old_rtc.tv_sec);
+	getnstimeofday64(&old_system);
+	old_rtc.tv_sec = rtc_tm_to_time64(&tm);
 
 
 	/*
@@ -78,8 +78,8 @@ static int rtc_suspend(struct device *dev)
 	 * try to compensate so the difference in system time
 	 * and rtc time stays close to constant.
 	 */
-	delta = timespec_sub(old_system, old_rtc);
-	delta_delta = timespec_sub(delta, old_delta);
+	delta = timespec64_sub(old_system, old_rtc);
+	delta_delta = timespec64_sub(delta, old_delta);
 	if (delta_delta.tv_sec < -2 || delta_delta.tv_sec >= 2) {
 		/*
 		 * if delta_delta is too large, assume time correction
@@ -88,7 +88,7 @@ static int rtc_suspend(struct device *dev)
 		old_delta = delta;
 	} else {
 		/* Otherwise try to adjust old_system to compensate */
-		old_system = timespec_sub(old_system, delta_delta);
+		old_system = timespec64_sub(old_system, delta_delta);
 	}
 
 	return 0;
@@ -98,8 +98,8 @@ static int rtc_resume(struct device *dev)
 {
 	struct rtc_device	*rtc = to_rtc_device(dev);
 	struct rtc_time		tm;
-	struct timespec		new_system, new_rtc;
-	struct timespec		sleep_time;
+	struct timespec64	new_system, new_rtc;
+	struct timespec64	sleep_time;
 	int err;
 
 	if (has_persistent_clock())
@@ -110,7 +110,7 @@ static int rtc_resume(struct device *dev)
 		return 0;
 
 	/* snapshot the current rtc and system time at resume */
-	getnstimeofday(&new_system);
+	getnstimeofday64(&new_system);
 	err = rtc_read_time(rtc, &tm);
 	if (err < 0) {
 		pr_debug("%s:  fail to read rtc time\n", dev_name(&rtc->dev));
@@ -121,7 +121,7 @@ static int rtc_resume(struct device *dev)
 		pr_debug("%s:  bogus resume time\n", dev_name(&rtc->dev));
 		return 0;
 	}
-	rtc_tm_to_time(&tm, &new_rtc.tv_sec);
+	new_rtc.tv_sec = rtc_tm_to_time64(&tm);
 	new_rtc.tv_nsec = 0;
 
 	if (new_rtc.tv_sec < old_rtc.tv_sec) {
@@ -130,7 +130,7 @@ static int rtc_resume(struct device *dev)
 	}
 
 	/* calculate the RTC time delta (sleep time)*/
-	sleep_time = timespec_sub(new_rtc, old_rtc);
+	sleep_time = timespec64_sub(new_rtc, old_rtc);
 
 	/*
 	 * Since these RTC suspend/resume handlers are not called
@@ -139,11 +139,11 @@ static int rtc_resume(struct device *dev)
 	 * so subtract kernel run-time between rtc_suspend to rtc_resume
 	 * to keep things accurate.
 	 */
-	sleep_time = timespec_sub(sleep_time,
-			timespec_sub(new_system, old_system));
+	sleep_time = timespec64_sub(sleep_time,
+			timespec64_sub(new_system, old_system));
 
 	if (sleep_time.tv_sec >= 0)
-		timekeeping_inject_sleeptime(&sleep_time);
+		timekeeping_inject_sleeptime64(&sleep_time);
 	rtc_hctosys_ret = 0;
 	return 0;
 }
-- 
1.9.1

