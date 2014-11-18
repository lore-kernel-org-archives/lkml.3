Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbaKRLU6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 06:20:58 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:60709 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917AbaKRLU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 06:20:29 -0500
From: "pang.xunlei" <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: rtc-linux@googlegroups.com, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        "pang.xunlei" <pang.xunlei@linaro.org>
Subject: [RFC PATCH v3 4/5] rtc/lib: Provide y2038 safe rtc_tm_to_time()/rtc_time_to_tm() replacement
Date: Tue, 18 Nov 2014 19:15:19 +0800
Message-Id: <1416309320-7498-5-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1416309320-7498-1-git-send-email-pang.xunlei@linaro.org>
References: <1416309320-7498-1-git-send-email-pang.xunlei@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As part of addressing "y2038 problem" for in-kernel uses, this patch
adds safe rtc_tm_to_time64()/rtc_time64_to_tm() respectively using
time64_t.

After this patch, rtc_tm_to_time() is deprecated and all its call
sites will be fixed using corresponding safe versions, it can be
removed when having no users. Also change rtc_tm_to_time64() to
return time64_t directly instead of just as a parameter like
rtc_tm_to_time() does.

After this patch, rtc_time_to_tm() is deprecated and all its call
sites will be fixed using corresponding safe versions, it can be
removed when having no users.

In addition, change rtc_tm_to_ktime() and rtc_ktime_to_tm() to use
the safe version in passing.

Signed-off-by: pang.xunlei <pang.xunlei@linaro.org>
---
 drivers/rtc/rtc-lib.c |   38 ++++++++++++++++++++------------------
 include/linux/rtc.h   |   21 +++++++++++++++++++--
 2 files changed, 39 insertions(+), 20 deletions(-)

diff --git a/drivers/rtc/rtc-lib.c b/drivers/rtc/rtc-lib.c
index c4cf057..e6bfb9c 100644
--- a/drivers/rtc/rtc-lib.c
+++ b/drivers/rtc/rtc-lib.c
@@ -45,16 +45,20 @@ int rtc_year_days(unsigned int day, unsigned int month, unsigned int year)
 }
 EXPORT_SYMBOL(rtc_year_days);
 
+
 /*
+ * rtc_time_to_tm64 - Converts time64_t to rtc_time.
  * Convert seconds since 01-01-1970 00:00:00 to Gregorian date.
  */
-void rtc_time_to_tm(unsigned long time, struct rtc_time *tm)
+void rtc_time64_to_tm(time64_t time, struct rtc_time *tm)
 {
 	unsigned int month, year;
+	unsigned long secs;
 	int days;
 
-	days = time / 86400;
-	time -= (unsigned int) days * 86400;
+	/* time must be positive */
+	days = div_s64(time, 86400);
+	secs = time - (unsigned int) days * 86400;
 
 	/* day of the week, 1970-01-01 was a Thursday */
 	tm->tm_wday = (days + 4) % 7;
@@ -81,14 +85,14 @@ void rtc_time_to_tm(unsigned long time, struct rtc_time *tm)
 	tm->tm_mon = month;
 	tm->tm_mday = days + 1;
 
-	tm->tm_hour = time / 3600;
-	time -= tm->tm_hour * 3600;
-	tm->tm_min = time / 60;
-	tm->tm_sec = time - tm->tm_min * 60;
+	tm->tm_hour = secs / 3600;
+	secs -= tm->tm_hour * 3600;
+	tm->tm_min = secs / 60;
+	tm->tm_sec = secs - tm->tm_min * 60;
 
 	tm->tm_isdst = 0;
 }
-EXPORT_SYMBOL(rtc_time_to_tm);
+EXPORT_SYMBOL(rtc_time64_to_tm);
 
 /*
  * Does the rtc_time represent a valid date/time?
@@ -109,24 +113,22 @@ int rtc_valid_tm(struct rtc_time *tm)
 EXPORT_SYMBOL(rtc_valid_tm);
 
 /*
+ * rtc_tm_to_time64 - Converts rtc_time to time64_t.
  * Convert Gregorian date to seconds since 01-01-1970 00:00:00.
  */
-int rtc_tm_to_time(struct rtc_time *tm, unsigned long *time)
+time64_t rtc_tm_to_time64(struct rtc_time *tm)
 {
-	*time = mktime(tm->tm_year + 1900, tm->tm_mon + 1, tm->tm_mday,
+	return mktime64(tm->tm_year + 1900, tm->tm_mon + 1, tm->tm_mday,
 			tm->tm_hour, tm->tm_min, tm->tm_sec);
-	return 0;
 }
-EXPORT_SYMBOL(rtc_tm_to_time);
+EXPORT_SYMBOL(rtc_tm_to_time64);
 
 /*
  * Convert rtc_time to ktime
  */
 ktime_t rtc_tm_to_ktime(struct rtc_time tm)
 {
-	time_t time;
-	rtc_tm_to_time(&tm, &time);
-	return ktime_set(time, 0);
+	return ktime_set(rtc_tm_to_time64(&tm), 0);
 }
 EXPORT_SYMBOL_GPL(rtc_tm_to_ktime);
 
@@ -135,14 +137,14 @@ EXPORT_SYMBOL_GPL(rtc_tm_to_ktime);
  */
 struct rtc_time rtc_ktime_to_tm(ktime_t kt)
 {
-	struct timespec ts;
+	struct timespec64 ts;
 	struct rtc_time ret;
 
-	ts = ktime_to_timespec(kt);
+	ts = ktime_to_timespec64(kt);
 	/* Round up any ns */
 	if (ts.tv_nsec)
 		ts.tv_sec++;
-	rtc_time_to_tm(ts.tv_sec, &ret);
+	rtc_time64_to_tm(ts.tv_sec, &ret);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(rtc_ktime_to_tm);
diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index c2c2897..6d6be09 100644
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -19,11 +19,28 @@
 extern int rtc_month_days(unsigned int month, unsigned int year);
 extern int rtc_year_days(unsigned int day, unsigned int month, unsigned int year);
 extern int rtc_valid_tm(struct rtc_time *tm);
-extern int rtc_tm_to_time(struct rtc_time *tm, unsigned long *time);
-extern void rtc_time_to_tm(unsigned long time, struct rtc_time *tm);
+extern time64_t rtc_tm_to_time64(struct rtc_time *tm);
+extern void rtc_time64_to_tm(time64_t time, struct rtc_time *tm);
 ktime_t rtc_tm_to_ktime(struct rtc_time tm);
 struct rtc_time rtc_ktime_to_tm(ktime_t kt);
 
+/**
+ * Deprecated. Use rtc_time64_to_tm().
+ */
+static inline void rtc_time_to_tm(unsigned long time, struct rtc_time *tm)
+{
+	rtc_time64_to_tm(time, tm);
+}
+
+/**
+ * Deprecated. Use rtc_tm_to_time64().
+ */
+static inline int rtc_tm_to_time(struct rtc_time *tm, unsigned long *time)
+{
+	*time = rtc_tm_to_time64(tm);
+
+	return 0;
+}
 
 #include <linux/device.h>
 #include <linux/seq_file.h>
-- 
1.7.9.5

