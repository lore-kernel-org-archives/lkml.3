Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607AbaGPVEG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:04:06 -0400
Received: from www.linutronix.de ([62.245.132.108]:59611 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbaGPVEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:04:00 -0400
Message-Id: <20140716205052.761354885@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 16 Jul 2014 21:03:58 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [patch V2 07/64] time64: Add time64.h header and define struct
 timespec64
References: <20140716205018.175419210@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=jstultz-tk-d8e0c56.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Stultz <john.stultz@linaro.org>

Define the timespec64 structure and standard helper functions.

[ tglx: Make it 32bit only. 64bit really can map timespec to timespec64 ]

Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 include/linux/time.h   |   15 ----
 include/linux/time64.h |  163 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 164 insertions(+), 14 deletions(-)

Index: tip/include/linux/time.h
===================================================================
--- tip.orig/include/linux/time.h
+++ tip/include/linux/time.h
@@ -4,25 +4,12 @@
 # include <linux/cache.h>
 # include <linux/seqlock.h>
 # include <linux/math64.h>
-#include <uapi/linux/time.h>
+# include <linux/time64.h>
 
 extern struct timezone sys_tz;
 
-/* Parameters used to convert the timespec values: */
-#define MSEC_PER_SEC	1000L
-#define USEC_PER_MSEC	1000L
-#define NSEC_PER_USEC	1000L
-#define NSEC_PER_MSEC	1000000L
-#define USEC_PER_SEC	1000000L
-#define NSEC_PER_SEC	1000000000L
-#define FSEC_PER_SEC	1000000000000000LL
-
 #define TIME_T_MAX	(time_t)((1UL << ((sizeof(time_t) << 3) - 1)) - 1)
 
-/* Located here for timespec_valid_strict */
-#define KTIME_MAX			((s64)~((u64)1 << 63))
-#define KTIME_SEC_MAX			(KTIME_MAX / NSEC_PER_SEC)
-
 static inline int timespec_equal(const struct timespec *a,
                                  const struct timespec *b)
 {
Index: tip/include/linux/time64.h
===================================================================
--- /dev/null
+++ tip/include/linux/time64.h
@@ -0,0 +1,163 @@
+#ifndef _LINUX_TIME64_H
+#define _LINUX_TIME64_H
+
+#include <uapi/linux/time.h>
+
+typedef __s64 time64_t;
+
+/*
+ * This wants to go into uapi/linux/time.h once we agreed about the
+ * userspace interfaces.
+ */
+#if __BITS_PER_LONG == 64
+# define timespec64 timespec
+#else
+struct timespec64 {
+	time64_t	tv_sec;			/* seconds */
+	long		tv_nsec;		/* nanoseconds */
+};
+#endif
+
+/* Parameters used to convert the timespec values: */
+#define MSEC_PER_SEC	1000L
+#define USEC_PER_MSEC	1000L
+#define NSEC_PER_USEC	1000L
+#define NSEC_PER_MSEC	1000000L
+#define USEC_PER_SEC	1000000L
+#define NSEC_PER_SEC	1000000000L
+#define FSEC_PER_SEC	1000000000000000LL
+
+/* Located here for timespec[64]_valid_strict */
+#define KTIME_MAX			((s64)~((u64)1 << 63))
+#define KTIME_SEC_MAX			(KTIME_MAX / NSEC_PER_SEC)
+
+#if __BITS_PER_LONG == 64
+
+# define timespec64_equal		timespec_equal
+# define timespec64_compare		timespec_compare
+# define set_normalized_timespec64	set_normalized_timespec
+# define timespec64_add_safe		timespec_add_safe
+# define timespec64_add			timespec_add
+# define timespec64_sub			timespec_sub
+# define timespec64_valid		timespec_valid
+# define timespec64_valid_strict	timespec_valid_strict
+# define timespec64_to_ns		timespec_to_ns
+# define ns_to_timespec64		ns_to_timespec
+# define timespec64_add_ns		timespec_add_ns
+
+#else
+
+static inline int timespec64_equal(const struct timespec64 *a,
+				   const struct timespec64 *b)
+{
+	return (a->tv_sec == b->tv_sec) && (a->tv_nsec == b->tv_nsec);
+}
+
+/*
+ * lhs < rhs:  return <0
+ * lhs == rhs: return 0
+ * lhs > rhs:  return >0
+ */
+static inline int timespec64_compare(const struct timespec64 *lhs, const struct timespec64 *rhs)
+{
+	if (lhs->tv_sec < rhs->tv_sec)
+		return -1;
+	if (lhs->tv_sec > rhs->tv_sec)
+		return 1;
+	return lhs->tv_nsec - rhs->tv_nsec;
+}
+
+extern void set_normalized_timespec64(struct timespec64 *ts, time64_t sec, s64 nsec);
+
+/*
+ * timespec64_add_safe assumes both values are positive and checks for
+ * overflow. It will return TIME_T_MAX if the returned value would be
+ * smaller then either of the arguments.
+ */
+extern struct timespec64 timespec64_add_safe(const struct timespec64 lhs,
+					 const struct timespec64 rhs);
+
+
+static inline struct timespec64 timespec64_add(struct timespec64 lhs,
+						struct timespec64 rhs)
+{
+	struct timespec64 ts_delta;
+	set_normalized_timespec64(&ts_delta, lhs.tv_sec + rhs.tv_sec,
+				lhs.tv_nsec + rhs.tv_nsec);
+	return ts_delta;
+}
+
+/*
+ * sub = lhs - rhs, in normalized form
+ */
+static inline struct timespec64 timespec64_sub(struct timespec64 lhs,
+						struct timespec64 rhs)
+{
+	struct timespec64 ts_delta;
+	set_normalized_timespec64(&ts_delta, lhs.tv_sec - rhs.tv_sec,
+				lhs.tv_nsec - rhs.tv_nsec);
+	return ts_delta;
+}
+
+/*
+ * Returns true if the timespec64 is norm, false if denorm:
+ */
+static inline bool timespec64_valid(const struct timespec64 *ts)
+{
+	/* Dates before 1970 are bogus */
+	if (ts->tv_sec < 0)
+		return false;
+	/* Can't have more nanoseconds then a second */
+	if ((unsigned long)ts->tv_nsec >= NSEC_PER_SEC)
+		return false;
+	return true;
+}
+
+static inline bool timespec64_valid_strict(const struct timespec64 *ts)
+{
+	if (!timespec64_valid(ts))
+		return false;
+	/* Disallow values that could overflow ktime_t */
+	if ((unsigned long long)ts->tv_sec >= KTIME_SEC_MAX)
+		return false;
+	return true;
+}
+
+/**
+ * timespec64_to_ns - Convert timespec64 to nanoseconds
+ * @ts:		pointer to the timespec64 variable to be converted
+ *
+ * Returns the scalar nanosecond representation of the timespec64
+ * parameter.
+ */
+static inline s64 timespec64_to_ns(const struct timespec64 *ts)
+{
+	return ((s64) ts->tv_sec * NSEC_PER_SEC) + ts->tv_nsec;
+}
+
+/**
+ * ns_to_timespec64 - Convert nanoseconds to timespec64
+ * @nsec:	the nanoseconds value to be converted
+ *
+ * Returns the timespec64 representation of the nsec parameter.
+ */
+extern struct timespec64 ns_to_timespec64(const s64 nsec);
+
+/**
+ * timespec64_add_ns - Adds nanoseconds to a timespec64
+ * @a:		pointer to timespec64 to be incremented
+ * @ns:		unsigned nanoseconds value to be added
+ *
+ * This must always be inlined because its used from the x86-64 vdso,
+ * which cannot call other kernel functions.
+ */
+static __always_inline void timespec64_add_ns(struct timespec64 *a, u64 ns)
+{
+	a->tv_sec += __iter_div_u64_rem(a->tv_nsec + ns, NSEC_PER_SEC, &ns);
+	a->tv_nsec = ns;
+}
+
+#endif
+
+#endif /* _LINUX_TIME64_H */
+


