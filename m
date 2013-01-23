Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348Ab3AWAEY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 19:04:24 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:32773 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756157Ab3AWAES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 19:04:18 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH 2/8] cputime: Librarize per nsecs resolution cputime definitions
Date: Wed, 23 Jan 2013 01:03:56 +0100
Message-Id: <1358899442-3110-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1358899442-3110-1-git-send-email-fweisbec@gmail.com>
References: <1358899442-3110-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The full dynticks cputime accounting that we'll soon introduce
will rely on sched_clock(). And its clock can have a per
nanosecond granularity.

To prepare for this, we need to have a cputime_t implementation
that has this precision.

ia64 virtual cputime accounting already uses that granularity
so all we need is to librarize its implementation in the asm
generic headers.

Also librarize the default per jiffy granularity cputime_t
as well so that we can easily pick either implementation
depending on the cputime accounting config we choose.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/ia64/include/asm/cputime.h       |   88 ++----------------------------
 include/asm-generic/cputime.h         |   62 +---------------------
 include/asm-generic/cputime_jiffies.h |   66 ++++++++++++++++++++++
 include/asm-generic/cputime_nsecs.h   |   96 +++++++++++++++++++++++++++++++++
 4 files changed, 167 insertions(+), 145 deletions(-)
 create mode 100644 include/asm-generic/cputime_jiffies.h
 create mode 100644 include/asm-generic/cputime_nsecs.h

diff --git a/arch/ia64/include/asm/cputime.h b/arch/ia64/include/asm/cputime.h
index 7fcf7f0..371ac96 100644
--- a/arch/ia64/include/asm/cputime.h
+++ b/arch/ia64/include/asm/cputime.h
@@ -19,91 +19,11 @@
 #define __IA64_CPUTIME_H
 
 #ifndef CONFIG_VIRT_CPU_ACCOUNTING
-#include <asm-generic/cputime.h>
+# include <asm-generic/cputime.h>
 #else
-
-#include <linux/time.h>
-#include <linux/jiffies.h>
-#include <asm/processor.h>
-
-typedef u64 __nocast cputime_t;
-typedef u64 __nocast cputime64_t;
-
-#define cputime_one_jiffy		jiffies_to_cputime(1)
-
-/*
- * Convert cputime <-> jiffies (HZ)
- */
-#define cputime_to_jiffies(__ct)	\
-	((__force u64)(__ct) / (NSEC_PER_SEC / HZ))
-#define jiffies_to_cputime(__jif)	\
-	(__force cputime_t)((__jif) * (NSEC_PER_SEC / HZ))
-#define cputime64_to_jiffies64(__ct)	\
-	((__force u64)(__ct) / (NSEC_PER_SEC / HZ))
-#define jiffies64_to_cputime64(__jif)	\
-	(__force cputime64_t)((__jif) * (NSEC_PER_SEC / HZ))
-
-/*
- * Convert cputime <-> microseconds
- */
-#define cputime_to_usecs(__ct)		\
-	((__force u64)(__ct) / NSEC_PER_USEC)
-#define usecs_to_cputime(__usecs)	\
-	(__force cputime_t)((__usecs) * NSEC_PER_USEC)
-#define usecs_to_cputime64(__usecs)	\
-	(__force cputime64_t)((__usecs) * NSEC_PER_USEC)
-
-/*
- * Convert cputime <-> seconds
- */
-#define cputime_to_secs(__ct)		\
-	((__force u64)(__ct) / NSEC_PER_SEC)
-#define secs_to_cputime(__secs)		\
-	(__force cputime_t)((__secs) * NSEC_PER_SEC)
-
-/*
- * Convert cputime <-> timespec (nsec)
- */
-static inline cputime_t timespec_to_cputime(const struct timespec *val)
-{
-	u64 ret = val->tv_sec * NSEC_PER_SEC + val->tv_nsec;
-	return (__force cputime_t) ret;
-}
-static inline void cputime_to_timespec(const cputime_t ct, struct timespec *val)
-{
-	val->tv_sec  = (__force u64) ct / NSEC_PER_SEC;
-	val->tv_nsec = (__force u64) ct % NSEC_PER_SEC;
-}
-
-/*
- * Convert cputime <-> timeval (msec)
- */
-static inline cputime_t timeval_to_cputime(struct timeval *val)
-{
-	u64 ret = val->tv_sec * NSEC_PER_SEC + val->tv_usec * NSEC_PER_USEC;
-	return (__force cputime_t) ret;
-}
-static inline void cputime_to_timeval(const cputime_t ct, struct timeval *val)
-{
-	val->tv_sec = (__force u64) ct / NSEC_PER_SEC;
-	val->tv_usec = ((__force u64) ct % NSEC_PER_SEC) / NSEC_PER_USEC;
-}
-
-/*
- * Convert cputime <-> clock (USER_HZ)
- */
-#define cputime_to_clock_t(__ct)	\
-	((__force u64)(__ct) / (NSEC_PER_SEC / USER_HZ))
-#define clock_t_to_cputime(__x)		\
-	(__force cputime_t)((__x) * (NSEC_PER_SEC / USER_HZ))
-
-/*
- * Convert cputime64 to clock.
- */
-#define cputime64_to_clock_t(__ct)	\
-	cputime_to_clock_t((__force cputime_t)__ct)
-
+# include <asm/processor.h>
+# include <asm-generic/cputime-nsecs.h>
 extern void arch_vtime_task_switch(struct task_struct *tsk);
-
 #endif /* CONFIG_VIRT_CPU_ACCOUNTING */
+
 #endif /* __IA64_CPUTIME_H */
diff --git a/include/asm-generic/cputime.h b/include/asm-generic/cputime.h
index 9a62937..c6eddf5 100644
--- a/include/asm-generic/cputime.h
+++ b/include/asm-generic/cputime.h
@@ -4,66 +4,6 @@
 #include <linux/time.h>
 #include <linux/jiffies.h>
 
-typedef unsigned long __nocast cputime_t;
-
-#define cputime_one_jiffy		jiffies_to_cputime(1)
-#define cputime_to_jiffies(__ct)	(__force unsigned long)(__ct)
-#define cputime_to_scaled(__ct)		(__ct)
-#define jiffies_to_cputime(__hz)	(__force cputime_t)(__hz)
-
-typedef u64 __nocast cputime64_t;
-
-#define cputime64_to_jiffies64(__ct)	(__force u64)(__ct)
-#define jiffies64_to_cputime64(__jif)	(__force cputime64_t)(__jif)
-
-#define nsecs_to_cputime64(__ct)	\
-	jiffies64_to_cputime64(nsecs_to_jiffies64(__ct))
-
-
-/*
- * Convert cputime to microseconds and back.
- */
-#define cputime_to_usecs(__ct)		\
-	jiffies_to_usecs(cputime_to_jiffies(__ct))
-#define usecs_to_cputime(__usec)	\
-	jiffies_to_cputime(usecs_to_jiffies(__usec))
-#define usecs_to_cputime64(__usec)	\
-	jiffies64_to_cputime64(nsecs_to_jiffies64((__usec) * 1000))
-
-/*
- * Convert cputime to seconds and back.
- */
-#define cputime_to_secs(jif)		(cputime_to_jiffies(jif) / HZ)
-#define secs_to_cputime(sec)		jiffies_to_cputime((sec) * HZ)
-
-/*
- * Convert cputime to timespec and back.
- */
-#define timespec_to_cputime(__val)	\
-	jiffies_to_cputime(timespec_to_jiffies(__val))
-#define cputime_to_timespec(__ct,__val)	\
-	jiffies_to_timespec(cputime_to_jiffies(__ct),__val)
-
-/*
- * Convert cputime to timeval and back.
- */
-#define timeval_to_cputime(__val)	\
-	jiffies_to_cputime(timeval_to_jiffies(__val))
-#define cputime_to_timeval(__ct,__val)	\
-	jiffies_to_timeval(cputime_to_jiffies(__ct),__val)
-
-/*
- * Convert cputime to clock and back.
- */
-#define cputime_to_clock_t(__ct)	\
-	jiffies_to_clock_t(cputime_to_jiffies(__ct))
-#define clock_t_to_cputime(__x)		\
-	jiffies_to_cputime(clock_t_to_jiffies(__x))
-
-/*
- * Convert cputime64 to clock.
- */
-#define cputime64_to_clock_t(__ct)	\
-	jiffies_64_to_clock_t(cputime64_to_jiffies64(__ct))
+#include <asm-generic/cputime_jiffies.h>
 
 #endif
diff --git a/include/asm-generic/cputime_jiffies.h b/include/asm-generic/cputime_jiffies.h
new file mode 100644
index 0000000..b747f1f
--- /dev/null
+++ b/include/asm-generic/cputime_jiffies.h
@@ -0,0 +1,66 @@
+#ifndef _ASM_GENERIC_CPUTIME_JIFFIES_H
+#define _ASM_GENERIC_CPUTIME_JIFFIES_H
+
+typedef unsigned long __nocast cputime_t;
+
+#define cputime_one_jiffy		jiffies_to_cputime(1)
+#define cputime_to_jiffies(__ct)	(__force unsigned long)(__ct)
+#define cputime_to_scaled(__ct)		(__ct)
+#define jiffies_to_cputime(__hz)	(__force cputime_t)(__hz)
+
+typedef u64 __nocast cputime64_t;
+
+#define cputime64_to_jiffies64(__ct)	(__force u64)(__ct)
+#define jiffies64_to_cputime64(__jif)	(__force cputime64_t)(__jif)
+
+#define nsecs_to_cputime64(__ct)	\
+	jiffies64_to_cputime64(nsecs_to_jiffies64(__ct))
+
+
+/*
+ * Convert cputime to microseconds and back.
+ */
+#define cputime_to_usecs(__ct)		\
+	jiffies_to_usecs(cputime_to_jiffies(__ct))
+#define usecs_to_cputime(__usec)	\
+	jiffies_to_cputime(usecs_to_jiffies(__usec))
+#define usecs_to_cputime64(__usec)	\
+	jiffies64_to_cputime64(nsecs_to_jiffies64((__usec) * 1000))
+
+/*
+ * Convert cputime to seconds and back.
+ */
+#define cputime_to_secs(jif)		(cputime_to_jiffies(jif) / HZ)
+#define secs_to_cputime(sec)		jiffies_to_cputime((sec) * HZ)
+
+/*
+ * Convert cputime to timespec and back.
+ */
+#define timespec_to_cputime(__val)	\
+	jiffies_to_cputime(timespec_to_jiffies(__val))
+#define cputime_to_timespec(__ct,__val)	\
+	jiffies_to_timespec(cputime_to_jiffies(__ct),__val)
+
+/*
+ * Convert cputime to timeval and back.
+ */
+#define timeval_to_cputime(__val)	\
+	jiffies_to_cputime(timeval_to_jiffies(__val))
+#define cputime_to_timeval(__ct,__val)	\
+	jiffies_to_timeval(cputime_to_jiffies(__ct),__val)
+
+/*
+ * Convert cputime to clock and back.
+ */
+#define cputime_to_clock_t(__ct)	\
+	jiffies_to_clock_t(cputime_to_jiffies(__ct))
+#define clock_t_to_cputime(__x)		\
+	jiffies_to_cputime(clock_t_to_jiffies(__x))
+
+/*
+ * Convert cputime64 to clock.
+ */
+#define cputime64_to_clock_t(__ct)	\
+	jiffies_64_to_clock_t(cputime64_to_jiffies64(__ct))
+
+#endif
diff --git a/include/asm-generic/cputime_nsecs.h b/include/asm-generic/cputime_nsecs.h
new file mode 100644
index 0000000..c73d182
--- /dev/null
+++ b/include/asm-generic/cputime_nsecs.h
@@ -0,0 +1,96 @@
+/*
+ * Definitions for measuring cputime in nsecs resolution.
+ *
+ * Based on <arch/ia64/include/asm/cputime.h>
+ *
+ * Copyright (C) 2007 FUJITSU LIMITED
+ * Copyright (C) 2007 Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ *
+ */
+
+#ifndef _ASM_GENERIC_CPUTIME_NSECS_H
+#define _ASM_GENERIC_CPUTIME_NSECS_H
+
+typedef u64 __nocast cputime_t;
+typedef u64 __nocast cputime64_t;
+
+#define cputime_one_jiffy		jiffies_to_cputime(1)
+
+/*
+ * Convert cputime <-> jiffies (HZ)
+ */
+#define cputime_to_jiffies(__ct)	\
+	((__force u64)(__ct) / (NSEC_PER_SEC / HZ))
+#define jiffies_to_cputime(__jif)	\
+	(__force cputime_t)((__jif) * (NSEC_PER_SEC / HZ))
+#define cputime64_to_jiffies64(__ct)	\
+	((__force u64)(__ct) / (NSEC_PER_SEC / HZ))
+#define jiffies64_to_cputime64(__jif)	\
+	(__force cputime64_t)((__jif) * (NSEC_PER_SEC / HZ))
+
+/*
+ * Convert cputime <-> microseconds
+ */
+#define cputime_to_usecs(__ct)		\
+	((__force u64)(__ct) / NSEC_PER_USEC)
+#define usecs_to_cputime(__usecs)	\
+	(__force cputime_t)((__usecs) * NSEC_PER_USEC)
+#define usecs_to_cputime64(__usecs)	\
+	(__force cputime64_t)((__usecs) * NSEC_PER_USEC)
+
+/*
+ * Convert cputime <-> seconds
+ */
+#define cputime_to_secs(__ct)		\
+	((__force u64)(__ct) / NSEC_PER_SEC)
+#define secs_to_cputime(__secs)		\
+	(__force cputime_t)((__secs) * NSEC_PER_SEC)
+
+/*
+ * Convert cputime <-> timespec (nsec)
+ */
+static inline cputime_t timespec_to_cputime(const struct timespec *val)
+{
+	u64 ret = val->tv_sec * NSEC_PER_SEC + val->tv_nsec;
+	return (__force cputime_t) ret;
+}
+static inline void cputime_to_timespec(const cputime_t ct, struct timespec *val)
+{
+	val->tv_sec  = (__force u64) ct / NSEC_PER_SEC;
+	val->tv_nsec = (__force u64) ct % NSEC_PER_SEC;
+}
+
+/*
+ * Convert cputime <-> timeval (msec)
+ */
+static inline cputime_t timeval_to_cputime(struct timeval *val)
+{
+	u64 ret = val->tv_sec * NSEC_PER_SEC + val->tv_usec * NSEC_PER_USEC;
+	return (__force cputime_t) ret;
+}
+static inline void cputime_to_timeval(const cputime_t ct, struct timeval *val)
+{
+	val->tv_sec = (__force u64) ct / NSEC_PER_SEC;
+	val->tv_usec = ((__force u64) ct % NSEC_PER_SEC) / NSEC_PER_USEC;
+}
+
+/*
+ * Convert cputime <-> clock (USER_HZ)
+ */
+#define cputime_to_clock_t(__ct)	\
+	((__force u64)(__ct) / (NSEC_PER_SEC / USER_HZ))
+#define clock_t_to_cputime(__x)		\
+	(__force cputime_t)((__x) * (NSEC_PER_SEC / USER_HZ))
+
+/*
+ * Convert cputime64 to clock.
+ */
+#define cputime64_to_clock_t(__ct)	\
+	cputime_to_clock_t((__force cputime_t)__ct)
+
+#endif
-- 
1.7.5.4

