Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029AbaKRLUb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 06:20:31 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:33143 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169AbaKRLUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 06:20:24 -0500
From: "pang.xunlei" <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: rtc-linux@googlegroups.com, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        "pang.xunlei" <pang.xunlei@linaro.org>
Subject: [RFC PATCH v3 3/5] time: Provide y2038 safe mktime() replacement
Date: Tue, 18 Nov 2014 19:15:18 +0800
Message-Id: <1416309320-7498-4-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1416309320-7498-1-git-send-email-pang.xunlei@linaro.org>
References: <1416309320-7498-1-git-send-email-pang.xunlei@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As part of addressing "y2038 problem" for in-kernel uses, this
patch adds safe mktime64() using time64_t.

After this patch, mktime() is deprecated and all its call sites
will be fixed using mktime64(), after that it can be removed.

Signed-off-by: pang.xunlei <pang.xunlei@linaro.org>
---
 include/linux/time.h |   17 ++++++++++++++---
 kernel/time/time.c   |   20 ++++++++------------
 2 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/include/linux/time.h b/include/linux/time.h
index 8c42cf8..203c2ad 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -39,9 +39,20 @@ static inline int timeval_compare(const struct timeval *lhs, const struct timeva
 	return lhs->tv_usec - rhs->tv_usec;
 }
 
-extern unsigned long mktime(const unsigned int year, const unsigned int mon,
-			    const unsigned int day, const unsigned int hour,
-			    const unsigned int min, const unsigned int sec);
+extern time64_t mktime64(const unsigned int year, const unsigned int mon,
+			const unsigned int day, const unsigned int hour,
+			const unsigned int min, const unsigned int sec);
+
+/**
+ * Deprecated. Use mktime64().
+ */
+static inline unsigned long mktime(const unsigned int year,
+			const unsigned int mon, const unsigned int day,
+			const unsigned int hour, const unsigned int min,
+			const unsigned int sec)
+{
+	return mktime64(year, mon, day, hour, min, sec);
+}
 
 extern void set_normalized_timespec(struct timespec *ts, time_t sec, s64 nsec);
 
diff --git a/kernel/time/time.c b/kernel/time/time.c
index a9ae20f..65015ff 100644
--- a/kernel/time/time.c
+++ b/kernel/time/time.c
@@ -304,7 +304,9 @@ struct timespec timespec_trunc(struct timespec t, unsigned gran)
 }
 EXPORT_SYMBOL(timespec_trunc);
 
-/* Converts Gregorian date to seconds since 1970-01-01 00:00:00.
+/*
+ * mktime64 - Converts date to seconds.
+ * Converts Gregorian date to seconds since 1970-01-01 00:00:00.
  * Assumes input in normal date format, i.e. 1980-12-31 23:59:59
  * => year=1980, mon=12, day=31, hour=23, min=59, sec=59.
  *
@@ -314,15 +316,10 @@ EXPORT_SYMBOL(timespec_trunc);
  * -year/100+year/400 terms, and add 10.]
  *
  * This algorithm was first published by Gauss (I think).
- *
- * WARNING: this function will overflow on 2106-02-07 06:28:16 on
- * machines where long is 32-bit! (However, as time_t is signed, we
- * will already get problems at other places on 2038-01-19 03:14:08)
  */
-unsigned long
-mktime(const unsigned int year0, const unsigned int mon0,
-       const unsigned int day, const unsigned int hour,
-       const unsigned int min, const unsigned int sec)
+time64_t mktime64(const unsigned int year0, const unsigned int mon0,
+		const unsigned int day, const unsigned int hour,
+		const unsigned int min, const unsigned int sec)
 {
 	unsigned int mon = mon0, year = year0;
 
@@ -332,15 +329,14 @@ mktime(const unsigned int year0, const unsigned int mon0,
 		year -= 1;
 	}
 
-	return ((((unsigned long)
+	return ((((time64_t)
 		  (year/4 - year/100 + year/400 + 367*mon/12 + day) +
 		  year*365 - 719499
 	    )*24 + hour /* now have hours */
 	  )*60 + min /* now have minutes */
 	)*60 + sec; /* finally seconds */
 }
-
-EXPORT_SYMBOL(mktime);
+EXPORT_SYMBOL(mktime64);
 
 /**
  * set_normalized_timespec - set timespec sec and nsec parts and normalize
-- 
1.7.9.5

