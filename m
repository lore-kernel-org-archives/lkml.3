Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532AbaJ0Fsk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 01:48:40 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:65418 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbaJ0Frl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 01:47:41 -0400
From: "pang.xunlei" <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        "pang.xunlei" <pang.xunlei@linaro.org>
Subject: [PATCH RFC 09/12] time: Convert rtc_time_to_tm_unsafe() to rtc_time_to_tm() in alarm_set_rtc()
Date: Mon, 27 Oct 2014 13:46:39 +0800
Message-Id: <1414388802-5866-8-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414388802-5866-1-git-send-email-pang.xunlei@linaro.org>
References: <1414388802-5866-1-git-send-email-pang.xunlei@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel uses 32-bit signed value(time_t) for seconds since 1970-01-01:00:00:00, so it
will overflow at 2038-01-19 03:14:08 on 32-bit systems. We call this "2038 safety" issue.

As part of addressing 2038 saftey for in-kernel uses, this patch creates no functional change
in existing users, and converts rtc_time_to_tm_unsafe() to rtc_time_to_tm().

Signed-off-by: pang.xunlei <pang.xunlei@linaro.org>
---
 drivers/staging/android/alarm-dev.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/android/alarm-dev.c b/drivers/staging/android/alarm-dev.c
index 3f95f80e..e2729c8 100644
--- a/drivers/staging/android/alarm-dev.c
+++ b/drivers/staging/android/alarm-dev.c
@@ -152,16 +152,18 @@ static int alarm_wait(void)
 	return rv;
 }
 
-static int alarm_set_rtc(struct timespec *ts)
+static int alarm_set_rtc(struct timespec64 *ts)
 {
+	struct timespec ts32;
 	struct rtc_time new_rtc_tm;
 	struct rtc_device *rtc_dev;
 	unsigned long flags;
 	int rv = 0;
 
-	rtc_time_to_tm_unsafe(ts->tv_sec, &new_rtc_tm);
+	rtc_time_to_tm(ts->tv_sec, &new_rtc_tm);
 	rtc_dev = alarmtimer_get_rtcdev();
-	rv = do_settimeofday(ts);
+	ts32 = timespec64_to_timespec(*ts);
+	rv = do_settimeofday(&ts32);
 	if (rv < 0)
 		return rv;
 	if (rtc_dev)
@@ -201,6 +203,7 @@ static int alarm_get_time(enum android_alarm_type alarm_type,
 static long alarm_do_ioctl(struct file *file, unsigned int cmd,
 							struct timespec *ts)
 {
+	struct timespec64 ts64;
 	int rv = 0;
 	unsigned long flags;
 	enum android_alarm_type alarm_type = ANDROID_ALARM_IOCTL_TO_TYPE(cmd);
@@ -238,7 +241,8 @@ static long alarm_do_ioctl(struct file *file, unsigned int cmd,
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

