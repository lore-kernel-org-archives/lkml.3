Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbaABSbe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 13:31:34 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:27952 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633AbaABSbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 13:31:31 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-a0-52c5b0814baf
From: Alexey Perevalov <a.perevalov@samsung.com>
To: linux-kernel@vger.kernel.org, john.stultz@linaro.org
Cc: Anton Vorontsov <anton@enomsg.org>, kyungmin.park@samsung.com,
        akpm@linux-foundation.org,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Alexey Perevalov <a.perevalov@samsung.com>
Subject: [PATCH 1/3] kernel/time: Add new helpers to convert ktime to/from
 jiffies
Date: Thu, 02 Jan 2014 22:30:46 +0400
Message-id: <1388687448-12987-2-git-send-email-a.perevalov@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1388687448-12987-1-git-send-email-a.perevalov@samsung.com>
References: <1388687448-12987-1-git-send-email-a.perevalov@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIJMWRmVeSWpSXmKPExsVy+t/xq7qNG44GGcyaLm8x9+55Fos569ew
	WVxsvc1icXCrpsWZ37oWZ5vesFtc3jWHzYHdY0L/J0aPO9f2sHmcmPGbxaNvyypGj8+b5AJY
	o7hsUlJzMstSi/TtErgylhy+xVbQI1nRdzKwgfGlSBcjB4eEgInE5z2BXYycQKaYxIV769m6
	GLk4hASWMkq82X+XBcKZwSSx/F0LI0gDm4CBxL57tiANIgIWEnde/WcFqWEW2MUo8fX/PkaQ
	hLBAiMT2+9uZQGwWAVWJyVNXg9m8Au4S3//cYYRYrCAxZ5INSJhTwENi/ZVbzCC2EFDJ9PUd
	jBMYeRcwMqxiFE0tTS4oTkrPNdIrTswtLs1L10vOz93ECAmmrzsYlx6zOsQowMGoxMP7oe5o
	kBBrYllxZe4hRgkOZiURXv2ZQCHelMTKqtSi/Pii0pzU4kOMTBycUg2Ml2yf6x51i5NOeR4i
	ceRDzsaZfNYPbh5aIrVh064/7WtPcjvcvuNWy8VrNJ1J7CO/cFLnFt+S+OD0JdnCJjMV1XbL
	1E/a8t64deH/7P7ArFcbmtZoiW97KPZzyzbTnPJlXybvLGmf7ehxQ/xwwYdl7BJPp+xe+svb
	cdbk80eFmAUvnz/e1VkcrMRSnJFoqMVcVJwIAJOaOwoEAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Vorontsov <anton@enomsg.org>

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
index d235e88..1ba02ae 100644
--- a/include/linux/jiffies.h
+++ b/include/linux/jiffies.h
@@ -6,6 +6,7 @@
 #include <linux/types.h>
 #include <linux/time.h>
 #include <linux/timex.h>
+#include <linux/ktime.h>
 #include <asm/param.h>			/* for HZ */
 
 /*
@@ -302,7 +303,8 @@ extern void jiffies_to_timespec(const unsigned long jiffies,
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

