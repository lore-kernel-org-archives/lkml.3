Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128AbaKUTon (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 14:44:43 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:41436 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbaKUTol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 14:44:41 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: "pang.xunlei" <pang.xunlei@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 06/12] time: Provide y2038 safe mktime() replacement
Date: Fri, 21 Nov 2014 11:44:12 -0800
Message-Id: <1416599058-13836-7-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416599058-13836-1-git-send-email-john.stultz@linaro.org>
References: <1416599058-13836-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "pang.xunlei" <pang.xunlei@linaro.org>

As part of addressing "y2038 problem" for in-kernel uses, this
patch adds safe mktime64() using time64_t.

After this patch, mktime() is deprecated and all its call sites
will be fixed using mktime64(), after that it can be removed.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnd Bergmann <arnd.bergmann@linaro.org>
Cc: pang.xunlei <pang.xunlei@linaro.org>
Cc: Miroslav Lichvar <mlichvar@redhat.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: pang.xunlei <pang.xunlei@linaro.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 include/linux/time.h | 17 ++++++++++++++---
 kernel/time/time.c   | 20 ++++++++------------
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
1.9.1

