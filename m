Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759364AbaJ3LRP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 07:17:15 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:39485 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759340AbaJ3LRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 07:17:10 -0400
From: "pang.xunlei" <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: rtc-linux@googlegroups.com, xen-devel@lists.xenproject.org,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "pang.xunlei" <pang.xunlei@linaro.org>
Subject: [RFC PATCH v2 04/11] time: Add rtc_time_to_tm64() safe version(using time64_t)
Date: Thu, 30 Oct 2014 19:15:38 +0800
Message-Id: <1414667745-7703-5-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414667745-7703-1-git-send-email-pang.xunlei@linaro.org>
References: <1414667745-7703-1-git-send-email-pang.xunlei@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As part of addressing 2038 saftey for in-kernel uses, this patch
adds safe rtc_time_to_tm64() using time64_t. After this patch,
rtc_time_to_tm() should be replaced by rtc_time_to_tm64() one by
one. Eventually, rtc_time_to_tm() will be removed from the kernel
when it has no users.

Signed-off-by: pang.xunlei <pang.xunlei@linaro.org>
---
 drivers/rtc/rtc-lib.c |   20 ++++++++++++++++----
 include/linux/rtc.h   |    1 +
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-lib.c b/drivers/rtc/rtc-lib.c
index 6948cbd..e84e3a0 100644
--- a/drivers/rtc/rtc-lib.c
+++ b/drivers/rtc/rtc-lib.c
@@ -45,15 +45,17 @@ int rtc_year_days(unsigned int day, unsigned int month, unsigned int year)
 }
 EXPORT_SYMBOL(rtc_year_days);
 
+
 /*
  * Convert seconds since 01-01-1970 00:00:00 to Gregorian date.
+ * Safe version for 2038 safety.
  */
-void rtc_time_to_tm(unsigned long time, struct rtc_time *tm)
+void rtc_time_to_tm64(time64_t time, struct rtc_time *tm)
 {
 	unsigned int month, year;
 	int days;
 
-	days = time / 86400;
+	days = div_s64(time, 86400);
 	time -= (unsigned int) days * 86400;
 
 	/* day of the week, 1970-01-01 was a Thursday */
@@ -81,13 +83,23 @@ void rtc_time_to_tm(unsigned long time, struct rtc_time *tm)
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
+EXPORT_SYMBOL(rtc_time_to_tm64);
+
+/* TODO: [2038 safety] should be replaced by rtc_time_to_tm64() */
+void rtc_time_to_tm(unsigned long time, struct rtc_time *tm)
+{
+	time64_t time64;
+
+	time64 = (time64_t)time;
+	rtc_time_to_tm64(time64, tm);
+}
 EXPORT_SYMBOL(rtc_time_to_tm);
 
 /*
diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index 2a6a9ce..12bacba 100644
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -21,6 +21,7 @@ extern int rtc_year_days(unsigned int day, unsigned int month, unsigned int year
 extern int rtc_valid_tm(struct rtc_time *tm);
 extern int rtc_tm_to_time64(struct rtc_time *tm, time64_t *time);
 extern int rtc_tm_to_time(struct rtc_time *tm, unsigned long *time);
+extern void rtc_time_to_tm64(time64_t time, struct rtc_time *tm);
 extern void rtc_time_to_tm(unsigned long time, struct rtc_time *tm);
 ktime_t rtc_tm_to_ktime(struct rtc_time tm);
 struct rtc_time rtc_ktime_to_tm(ktime_t kt);
-- 
1.7.9.5

