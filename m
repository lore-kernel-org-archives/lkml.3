Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759326AbaJ3LRA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 07:17:00 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:55742 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759304AbaJ3LQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 07:16:58 -0400
From: "pang.xunlei" <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: rtc-linux@googlegroups.com, xen-devel@lists.xenproject.org,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "pang.xunlei" <pang.xunlei@linaro.org>
Subject: [RFC PATCH v2 02/11] time: Add mktime64() safe version(using time64_t)
Date: Thu, 30 Oct 2014 19:15:36 +0800
Message-Id: <1414667745-7703-3-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414667745-7703-1-git-send-email-pang.xunlei@linaro.org>
References: <1414667745-7703-1-git-send-email-pang.xunlei@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As part of addressing 2038 saftey for in-kernel uses, this patch
adds safe mktime64() using time64_t. After this patch, mktime()
should be replaced by mktime64() one by one. Eventually, mktime()
will be removed from the kernel when it has no users.

Signed-off-by: pang.xunlei <pang.xunlei@linaro.org>
---
 include/linux/time.h |    4 ++++
 kernel/time/time.c   |   39 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+)

diff --git a/include/linux/time.h b/include/linux/time.h
index 8c42cf8..5c2c077 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -39,6 +39,10 @@ static inline int timeval_compare(const struct timeval *lhs, const struct timeva
 	return lhs->tv_usec - rhs->tv_usec;
 }
 
+extern time64_t mktime64(const unsigned int year, const unsigned int mon,
+                const unsigned int day, const unsigned int hour,
+                const unsigned int min, const unsigned int sec);
+
 extern unsigned long mktime(const unsigned int year, const unsigned int mon,
 			    const unsigned int day, const unsigned int hour,
 			    const unsigned int min, const unsigned int sec);
diff --git a/kernel/time/time.c b/kernel/time/time.c
index a9ae20f..f44efdb 100644
--- a/kernel/time/time.c
+++ b/kernel/time/time.c
@@ -304,6 +304,44 @@ struct timespec timespec_trunc(struct timespec t, unsigned gran)
 }
 EXPORT_SYMBOL(timespec_trunc);
 
+/* 
+ * Converts Gregorian date to seconds since 1970-01-01 00:00:00.
+ * Assumes input in normal date format, i.e. 1980-12-31 23:59:59
+ * => year=1980, mon=12, day=31, hour=23, min=59, sec=59.
+ *
+ * [For the Julian calendar (which was used in Russia before 1917,
+ * Britain & colonies before 1752, anywhere else before 1582,
+ * and is still in use by some communities) leave out the
+ * -year/100+year/400 terms, and add 10.]
+ *
+ * This algorithm was first published by Gauss (I think).
+ *
+ * Safe version 2038 safety on 32-bit systems.
+ */
+time64_t
+mktime64(const unsigned int year0, const unsigned int mon0,
+       const unsigned int day, const unsigned int hour,
+       const unsigned int min, const unsigned int sec)
+{
+	time64_t ret;
+	unsigned int mon = mon0, year = year0;
+
+	 /* 1..12 -> 11,12,1..10 */
+	if (0 >= (int) (mon -= 2)) {
+		mon += 12;  /* Puts Feb last since it has leap day */
+		year -= 1;
+	}
+
+	ret = (year/4 - year/100 + year/400 + 367*mon/12 + day) + year*365 - 719499;
+	ret = ret*24 + hour; /* now have hours */
+	ret = ret*60 + min; /* now have minutes */
+	ret = ret*60 + sec; /* finally seconds */
+
+	return ret;
+}
+
+EXPORT_SYMBOL(mktime64);
+
 /* Converts Gregorian date to seconds since 1970-01-01 00:00:00.
  * Assumes input in normal date format, i.e. 1980-12-31 23:59:59
  * => year=1980, mon=12, day=31, hour=23, min=59, sec=59.
@@ -318,6 +356,7 @@ EXPORT_SYMBOL(timespec_trunc);
  * WARNING: this function will overflow on 2106-02-07 06:28:16 on
  * machines where long is 32-bit! (However, as time_t is signed, we
  * will already get problems at other places on 2038-01-19 03:14:08)
+ * TODO: [2038 safety] should be replaced by mktime64().
  */
 unsigned long
 mktime(const unsigned int year0, const unsigned int mon0,
-- 
1.7.9.5

