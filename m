Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759421AbaJ3LRc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 07:17:32 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:33342 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759381AbaJ3LR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 07:17:29 -0400
From: "pang.xunlei" <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: rtc-linux@googlegroups.com, xen-devel@lists.xenproject.org,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "pang.xunlei" <pang.xunlei@linaro.org>
Subject: [RFC PATCH v2 07/11] time: Convert alarm_set_rtc() to use timespec64
Date: Thu, 30 Oct 2014 19:15:41 +0800
Message-Id: <1414667745-7703-8-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414667745-7703-1-git-send-email-pang.xunlei@linaro.org>
References: <1414667745-7703-1-git-send-email-pang.xunlei@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As part of addressing 2038 saftey for in-kernel uses, this patch
creates no functional change, and converts alarm_set_rtc() to use
timespec64.

Signed-off-by: pang.xunlei <pang.xunlei@linaro.org>
---
 drivers/staging/android/alarm-dev.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/android/alarm-dev.c b/drivers/staging/android/alarm-dev.c
index 01017ff..dfa24f0 100644
--- a/drivers/staging/android/alarm-dev.c
+++ b/drivers/staging/android/alarm-dev.c
@@ -152,19 +152,16 @@ static int alarm_wait(void)
 	return rv;
 }
 
-/* TODO: [2038 safety] alarm_set_rtc() uses timespec64 */
-static int alarm_set_rtc(struct timespec *ts)
+static int alarm_set_rtc(struct timespec64 *ts)
 {
-	struct timespec ts64;
 	struct rtc_time new_rtc_tm;
 	struct rtc_device *rtc_dev;
 	unsigned long flags;
 	int rv = 0;
 
-	ts64 = timespec_to_timespec64(*ts);
-	rtc_time_to_tm64(ts64.tv_sec, &new_rtc_tm);
+	rtc_time_to_tm64(ts->tv_sec, &new_rtc_tm);
 	rtc_dev = alarmtimer_get_rtcdev();
-	rv = do_settimeofday64(&ts64);
+	rv = do_settimeofday64(ts);
 	if (rv < 0)
 		return rv;
 	if (rtc_dev)
@@ -201,9 +198,14 @@ static int alarm_get_time(enum android_alarm_type alarm_type,
 	return rv;
 }
 
+/*
+* TODO: [2038 safety] alarm_do_ioctl() should be fixed to use timespec64,
+*  once timespec64 is promoted to userspace.
+*/
 static long alarm_do_ioctl(struct file *file, unsigned int cmd,
 							struct timespec *ts)
 {
+	struct timespec64 ts64;
 	int rv = 0;
 	unsigned long flags;
 	enum android_alarm_type alarm_type = ANDROID_ALARM_IOCTL_TO_TYPE(cmd);
@@ -241,7 +243,8 @@ static long alarm_do_ioctl(struct file *file, unsigned int cmd,
 		rv = alarm_wait();
 		break;
 	case ANDROID_ALARM_SET_RTC:
-		rv = alarm_set_rtc(ts);
+		ts64 = timespec_to_timespec64(*ts);
+		rv = alarm_set_rtc(&ts64);
 		break;
 	case ANDROID_ALARM_GET_TIME(0):
 		rv = alarm_get_time(alarm_type, ts);
-- 
1.7.9.5

