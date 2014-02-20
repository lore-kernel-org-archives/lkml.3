Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbaBTIne (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 03:43:34 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:8948 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043AbaBTIme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 03:42:34 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-c3-5305bff8c21e
From: Alexey Perevalov <a.perevalov@samsung.com>
To: linux-kernel@vger.kernel.org, tglx@linutronix.de, john.stultz@linaro.org
Cc: Anton Vorontsov <anton@scarybugs.org>, anton@nomsg.org,
        kyungmin.park@samsung.com, cw00.choi@samsung.com,
        akpm@linux-foundation.org,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Alexey Perevalov <a.perevalov@samsung.com>
Subject: [PATCH v3 3/6] kernel/time: Add new helpers to convert ktime to/from
 jiffies
Date: Thu, 20 Feb 2014 12:40:30 +0400
Message-id: <1392885633-7787-4-git-send-email-a.perevalov@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392885633-7787-1-git-send-email-a.perevalov@samsung.com>
References: <1392885633-7787-1-git-send-email-a.perevalov@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupiluLIzCtJLcpLzFFi42I5/e/4Nd0f+1mDDb6d5LOYe/c8i8Wc9WvY
	LC623max6P/VyWrR+hhIXP/ynNXizG9di7NNb9gtLu+aw2axedNUZgcujzvX9rB5vDt3jt3j
	xIzfLB5f9uxl9ujbsorR4/Hh1SwenzfJBbBHcdmkpOZklqUW6dslcGXM3dvJVNAvWbFmhl8D
	4xuRLkZODgkBE4ljG/ezQdhiEhfurQeyuTiEBJYySizfN5sJwulhkti29DhrFyMHB5uAgcS+
	e7YgDSICPhK7Jn4Eq2EWeM4o8e3WDlaQhLBAuMSyfw9YQGwWAVWJiV/ug/XyCrhJPJunA2JK
	CChIzJlkA2JyCrhLNDyxASkWAip4sOUPywRG3gWMDKsYRVNLkwuKk9JzDfWKE3OLS/PS9ZLz
	czcxQsLvyw7GxcesDjEKcDAq8fBGXGcJFmJNLCuuzD3EKMHBrCTCy5PJGizEm5JYWZValB9f
	VJqTWnyIkYmDU6qBcfUZRZ+Q61YPZvHs/PiKVUwypLwz0aStrfrBwvePaqe+aIl6uCdc9XkU
	753HsyTfxKqECfK4bf79OL0itPjfvR1CMwV+3vqaFxEaw87M32e8MufR279mQcZpYgl1nz+c
	a5yiOmGysZmilVDhj+nLX/yIOrNh50chVWlvyYbCC0f2/uo39f/7S4mlOCPRUIu5qDgRALbR
	OAYdAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Vorontsov <anton@scarybugs.org>

Two new functions: jiffies_to_ktime() and ktime_to_jiffies(), we'll use
them for timerfd deferred timers handling.

We fully reuse the logic from timespec implementations, so the functions
are pretty straightforward.

The only tricky part is in headers: we have to include jiffies.h after
we defined ktime_t, this is because ktime.h needs some declarations from
jiffies.h (e.g. TICK_NSEC).

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
Signed-off-by: Alexey Perevalov <a.perevalov@samsung.com>
---
 include/linux/jiffies.h |    4 +++-
 include/linux/ktime.h   |    3 ++-
 kernel/time.c           |   23 +++++++++++++++++++++++
 3 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
index 1f44466..cbb15e0 100644
--- a/include/linux/jiffies.h
+++ b/include/linux/jiffies.h
@@ -6,6 +6,7 @@
 #include <linux/types.h>
 #include <linux/time.h>
 #include <linux/timex.h>
+#include <linux/ktime.h>
 #include <asm/param.h>			/* for HZ */
 
 /*
@@ -308,7 +309,8 @@ extern void jiffies_to_timespec(const unsigned long jiffies,
 extern unsigned long timeval_to_jiffies(const struct timeval *value);
 extern void jiffies_to_timeval(const unsigned long jiffies,
 			       struct timeval *value);
-
+extern unsigned long ktime_to_jiffies(ktime_t *value);
+extern void jiffies_to_ktime(const unsigned long jiffies, ktime_t *value);
 extern clock_t jiffies_to_clock_t(unsigned long x);
 static inline clock_t jiffies_delta_to_clock_t(long delta)
 {
diff --git a/include/linux/ktime.h b/include/linux/ktime.h
index 31c0cd1..e8ed619 100644
--- a/include/linux/ktime.h
+++ b/include/linux/ktime.h
@@ -22,7 +22,6 @@
 #define _LINUX_KTIME_H
 
 #include <linux/time.h>
-#include <linux/jiffies.h>
 
 /*
  * ktime_t:
@@ -58,6 +57,8 @@ union ktime {
 
 typedef union ktime ktime_t;		/* Kill this */
 
+#include <linux/jiffies.h>
+
 /*
  * ktime_t definitions when using the 64-bit scalar representation:
  */
diff --git a/kernel/time.c b/kernel/time.c
index 7c7964c..22580a0 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -29,6 +29,7 @@
 
 #include <linux/export.h>
 #include <linux/timex.h>
+#include <linux/ktime.h>
 #include <linux/capability.h>
 #include <linux/timekeeper_internal.h>
 #include <linux/errno.h>
@@ -575,6 +576,28 @@ void jiffies_to_timeval(const unsigned long jiffies, struct timeval *value)
 }
 EXPORT_SYMBOL(jiffies_to_timeval);
 
+unsigned long ktime_to_jiffies(ktime_t *value)
+{
+	struct timespec ts = ktime_to_timespec(*value);
+
+	/*
+	 * nsecs_to_jiffies(ktime_to_ns(*ktime)) is unsafe as nsecs_to_jiffies
+	 * doesn't handle MAX_JIFFY_OFFSET. So we reuse the logic from the
+	 * timespec to jiffies conversion function.
+	 */
+	return timespec_to_jiffies(&ts);
+}
+EXPORT_SYMBOL(ktime_to_jiffies);
+
+void jiffies_to_ktime(const unsigned long jiffies, ktime_t *value)
+{
+	struct timespec ts;
+
+	jiffies_to_timespec(jiffies, &ts);
+	*value = timespec_to_ktime(ts);
+}
+EXPORT_SYMBOL(jiffies_to_ktime);
+
 /*
  * Convert jiffies/jiffies_64 to clock_t and back.
  */
-- 
1.7.9.5

