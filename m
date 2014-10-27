Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998AbaJ0FrL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 01:47:11 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:42789 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbaJ0FrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 01:47:09 -0400
From: "pang.xunlei" <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        "pang.xunlei" <pang.xunlei@linaro.org>
Subject: [PATCH RFC 02/12] time: Add mktime() safe version(using time64_t)
Date: Mon, 27 Oct 2014 13:46:32 +0800
Message-Id: <1414388802-5866-1-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel uses 32-bit signed value(time_t) for seconds since 1970-01-01:00:00:00, thus it
will overflow at 2038-01-19 03:14:08 on 32-bit systems. We call this "2038 safety" issue.

As part of addressing 2038 saftey for in-kernel uses, this patch adds the safe mktime() using
time64_t. After this patch, mktime_unsafe() should be replaced by mktime() one by one.

Eventually, mktime_unsafe() will be removed from the kernel when it has no users.

Signed-off-by: pang.xunlei <pang.xunlei@linaro.org>
---
 include/linux/time.h |    8 ++++++--
 kernel/time/time.c   |   39 ++++++++++++++++++++++++++-------------
 2 files changed, 32 insertions(+), 15 deletions(-)

diff --git a/include/linux/time.h b/include/linux/time.h
index e49d421..08f413c 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -39,9 +39,13 @@ static inline int timeval_compare(const struct timeval *lhs, const struct timeva
 	return lhs->tv_usec - rhs->tv_usec;
 }
 
+extern time64_t mktime(const unsigned int year, const unsigned int mon,
+					const unsigned int day, const unsigned int hour,
+					const unsigned int min, const unsigned int sec);
+
 extern unsigned long mktime_unsafe(const unsigned int year, const unsigned int mon,
-                            const unsigned int day, const unsigned int hour,
-                            const unsigned int min, const unsigned int sec);
+							const unsigned int day, const unsigned int hour,
+							const unsigned int min, const unsigned int sec);
 
 extern void set_normalized_timespec(struct timespec *ts, time_t sec, s64 nsec);
 
diff --git a/kernel/time/time.c b/kernel/time/time.c
index d6a4464..f9521fa 100644
--- a/kernel/time/time.c
+++ b/kernel/time/time.c
@@ -304,7 +304,8 @@ struct timespec timespec_trunc(struct timespec t, unsigned gran)
 }
 EXPORT_SYMBOL(timespec_trunc);
 
-/* Converts Gregorian date to seconds since 1970-01-01 00:00:00.
+/*
+ * Converts Gregorian date to seconds since 1970-01-01 00:00:00.
  * Assumes input in normal date format, i.e. 1980-12-31 23:59:59
  * => year=1980, mon=12, day=31, hour=23, min=59, sec=59.
  *
@@ -314,16 +315,13 @@ EXPORT_SYMBOL(timespec_trunc);
  * -year/100+year/400 terms, and add 10.]
  *
  * This algorithm was first published by Gauss (I think).
- *
- * WARNING: this function will overflow on 2106-02-07 06:28:16 on
- * machines where long is 32-bit! (However, as time_t is signed, we
- * will already get problems at other places on 2038-01-19 03:14:08)
  */
-unsigned long
-mktime_unsafe(const unsigned int year0, const unsigned int mon0,
+time64_t
+mktime(const unsigned int year0, const unsigned int mon0,
        const unsigned int day, const unsigned int hour,
        const unsigned int min, const unsigned int sec)
 {
+	time64_t ret;
 	unsigned int mon = mon0, year = year0;
 
 	/* 1..12 -> 11,12,1..10 */
@@ -332,12 +330,27 @@ mktime_unsafe(const unsigned int year0, const unsigned int mon0,
 		year -= 1;
 	}
 
-	return ((((unsigned long)
-		  (year/4 - year/100 + year/400 + 367*mon/12 + day) +
-		  year*365 - 719499
-	    )*24 + hour /* now have hours */
-	  )*60 + min /* now have minutes */
-	)*60 + sec; /* finally seconds */
+	ret = (year/4 - year/100 + year/400 + 367*mon/12 + day) + year*365 - 719499;
+	ret = ret*24 + hour; /* now have hours */
+	ret = ret*60 + min; /* now have minutes */
+	ret = ret*60 + sec; /* finally seconds */
+
+	return ret;
+}
+
+EXPORT_SYMBOL(mktime);
+
+/*
+ * TODO: [2038 safety] 2038 unsafe for legacy, replace it by mktime().
+ * WARNING: mktime_unsafe() will overflow on 2106-02-07 06:28:16 on
+ * machines where long is 32-bit! (However, as time_t is signed, we
+ * will already get problems at other places on 2038-01-19 03:14:08)
+ */
+unsigned long mktime_unsafe(const unsigned int year0, const unsigned int mon0,
+       const unsigned int day, const unsigned int hour,
+       const unsigned int min, const unsigned int sec)
+{
+	return (unsigned long) mktime(year0, mon0, day, hour, min, sec);
 }
 
 EXPORT_SYMBOL(mktime_unsafe);
-- 
1.7.9.5

