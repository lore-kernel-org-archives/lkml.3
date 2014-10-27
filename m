Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343AbaJ0Frm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 01:47:42 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:54226 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261AbaJ0Frh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 01:47:37 -0400
From: "pang.xunlei" <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        "pang.xunlei" <pang.xunlei@linaro.org>
Subject: [PATCH RFC 08/12] time: Add rtc_time_to_tm() safe version(using time64_t)
Date: Mon, 27 Oct 2014 13:46:38 +0800
Message-Id: <1414388802-5866-7-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414388802-5866-1-git-send-email-pang.xunlei@linaro.org>
References: <1414388802-5866-1-git-send-email-pang.xunlei@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel uses 32-bit signed value(time_t) for seconds since 1970-01-01:00:00:00, thus it
will overflow at 2038-01-19 03:14:08 on 32-bit systems. We call this "2038 safety" issue.

As part of addressing 2038 saftey for in-kernel uses, this patch adds the safe rtc_time_to_tm()
using time64_t. After this patch, rtc_time_to_tm_unsafe() should be replaced by rtc_time_to_tm()
one by one.

Eventually, rtc_time_to_tm_unsafe() will be removed from the kernel when it has no users.

Signed-off-by: pang.xunlei <pang.xunlei@linaro.org>
---
 drivers/rtc/rtc-lib.c |   18 ++++++++++++++----
 include/linux/rtc.h   |    1 +
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-lib.c b/drivers/rtc/rtc-lib.c
index 34bcca9..cbbc9a6 100644
--- a/drivers/rtc/rtc-lib.c
+++ b/drivers/rtc/rtc-lib.c
@@ -48,12 +48,12 @@ EXPORT_SYMBOL(rtc_year_days);
 /*
  * Convert seconds since 01-01-1970 00:00:00 to Gregorian date.
  */
-void rtc_time_to_tm_unsafe(unsigned long time, struct rtc_time *tm)
+void rtc_time_to_tm(time64_t time, struct rtc_time *tm)
 {
 	unsigned int month, year;
 	int days;
 
-	days = time / 86400;
+	days = div_s64(time, 86400);
 	time -= (unsigned int) days * 86400;
 
 	/* day of the week, 1970-01-01 was a Thursday */
@@ -81,13 +81,23 @@ void rtc_time_to_tm_unsafe(unsigned long time, struct rtc_time *tm)
 	tm->tm_mon = month;
 	tm->tm_mday = days + 1;
 
-	tm->tm_hour = time / 3600;
+	tm->tm_hour = div_s64(time, 3600);
 	time -= tm->tm_hour * 3600;
-	tm->tm_min = time / 60;
+	tm->tm_min = div_s64(time, 60);
 	tm->tm_sec = time - tm->tm_min * 60;
 
 	tm->tm_isdst = 0;
 }
+EXPORT_SYMBOL(rtc_time_to_tm);
+
+/* TODO: [2038 safety] unsafe for legacy, and should be replaced by rtc_time_to_tm() */
+void rtc_time_to_tm_unsafe(unsigned long time, struct rtc_time *tm)
+{
+	time64_t time64;
+
+	time64 = (time64_t)time;
+	rtc_time_to_tm(time64, tm);
+}
 EXPORT_SYMBOL(rtc_time_to_tm_unsafe);
 
 /*
diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index d1f878c..1994399 100644
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -21,6 +21,7 @@ extern int rtc_year_days(unsigned int day, unsigned int month, unsigned int year
 extern int rtc_valid_tm(struct rtc_time *tm);
 extern int rtc_tm_to_time(struct rtc_time *tm, time64_t *time);
 extern int rtc_tm_to_time_unsafe(struct rtc_time *tm, unsigned long *time);
+extern void rtc_time_to_tm(time64_t time, struct rtc_time *tm);
 extern void rtc_time_to_tm_unsafe(unsigned long time, struct rtc_time *tm);
 ktime_t rtc_tm_to_ktime(struct rtc_time tm);
 struct rtc_time rtc_ktime_to_tm(ktime_t kt);
-- 
1.7.9.5

