Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474Ab3GIBRv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 21:17:51 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:37922 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab3GIBRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 21:17:41 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH v6 01/14] spinlock: A new lockref structure for lockless update of refcount
Date: Mon,  8 Jul 2013 21:09:51 -0400
Message-Id: <1373332204-10379-2-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1373332204-10379-1-git-send-email-Waiman.Long@hp.com>
References: <1373332204-10379-1-git-send-email-Waiman.Long@hp.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a new set of spinlock_refcount.h header files to
be included by kernel codes that want to do a faster lockless update
of reference count protected by a spinlock.

The new lockref structure consists of just the spinlock and the
reference count data. Helper functions are defined in the new
<linux/spinlock_refcount.h> header file to access the content of
the new structure. There is a generic structure defined for all
architecture, but each architecture can also optionally define its
own structure and use its own helper functions.

Three new config parameters are introduced:
1. SPINLOCK_REFCOUNT
2. GENERIC_SPINLOCK_REFCOUNT
2. ARCH_SPINLOCK_REFCOUNT

The first one is defined in the kernel/Kconfig.locks which is used
to enable or disable the faster lockless reference count update
optimization. The second and third one have to be defined in each of
the architecture's Kconfig file to enable the optimization for that
architecture. Therefore, each architecture has to opt-in for this
optimization or it won't get it. This allows each architecture plenty
of time to test it out before deciding to use it or replace it with
a better architecture specific solution. The architecture should set
only GENERIC_SPINLOCK_REFCOUNT to use the generic implementation
without customization. By setting only ARCH_SPINLOCK_REFCOUNT,
the architecture will have to provide its own implementation. By
setting both, an architecture uses the generic implementation with
customized parameters.

This optimization won't work for non-SMP system or when spinlock
debugging is turned on. As a result, it is turned off each any of
them is true. It also won't work for full preempt-RT and so should
be turned off in this case.

To maximize the chance of doing lockless update in the generic version,
the inlined __lockref_add_unless() function will wait for a certain
amount of time if the lock is not free before trying to do the update.
The amount of time is controlled by the LOCKREF_WAIT_SHIFT macro.

The new code also attempts to do lockless atomic update a few
time before falling back to the old code path of acquiring a lock
before doing the update. Similarly, this is controlled by the
LOCKREF_RETRY_COUNT macro.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 include/asm-generic/spinlock_refcount.h |   46 +++++++
 include/linux/spinlock_refcount.h       |  142 ++++++++++++++++++++
 kernel/Kconfig.locks                    |   15 ++
 lib/Makefile                            |    2 +
 lib/spinlock_refcount.c                 |  218 +++++++++++++++++++++++++++++++
 5 files changed, 423 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-generic/spinlock_refcount.h
 create mode 100644 include/linux/spinlock_refcount.h
 create mode 100644 lib/spinlock_refcount.c

diff --git a/include/asm-generic/spinlock_refcount.h b/include/asm-generic/spinlock_refcount.h
new file mode 100644
index 0000000..d3a4119
--- /dev/null
+++ b/include/asm-generic/spinlock_refcount.h
@@ -0,0 +1,46 @@
+/*
+ * Spinlock with reference count combo
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * (c) Copyright 2013 Hewlett-Packard Development Company, L.P.
+ *
+ * Authors: Waiman Long <waiman.long@hp.com>
+ */
+#ifndef __ASM_GENERIC_SPINLOCK_REFCOUNT_H
+#define __ASM_GENERIC_SPINLOCK_REFCOUNT_H
+
+/*
+ * The lockref structure defines a combined spinlock with reference count
+ * data structure to be embedded in a larger structure. The combined data
+ * structure is always 8-byte aligned. So proper placement of this structure
+ * in the larger embedding data structure is needed to ensure that there is
+ * no hole in it.
+ */
+struct __aligned(sizeof(u64)) lockref {
+	union {
+		u64		lock_count;
+		struct {
+			unsigned int	refcnt;	/* Reference count */
+			spinlock_t	lock;
+		};
+	};
+};
+
+/*
+ * Struct lockref helper functions
+ */
+extern void lockref_get(struct lockref *lockcnt);
+extern int  lockref_put(struct lockref *lockcnt);
+extern int  lockref_get_not_zero(struct lockref *lockcnt);
+extern int  lockref_put_or_lock(struct lockref *lockcnt);
+
+#endif /* __ASM_GENERIC_SPINLOCK_REFCOUNT_H */
diff --git a/include/linux/spinlock_refcount.h b/include/linux/spinlock_refcount.h
new file mode 100644
index 0000000..32389a9
--- /dev/null
+++ b/include/linux/spinlock_refcount.h
@@ -0,0 +1,142 @@
+/*
+ * Spinlock with reference count combo data structure
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * (c) Copyright 2013 Hewlett-Packard Development Company, L.P.
+ *
+ * Authors: Waiman Long <waiman.long@hp.com>
+ */
+#ifndef __LINUX_SPINLOCK_REFCOUNT_H
+#define __LINUX_SPINLOCK_REFCOUNT_H
+
+#include <linux/spinlock.h>
+
+/*
+ * To enable lockless update of reference count, an architecture has to define
+ * at least one of the following two config parameters in its Kconfig file:
+ * 1. GENERIC_SPINLOCK_REFCOUNT
+ * 2. ARCH_SPINLOCK_REFCOUNT
+ *
+ * By defining just the GENERIC_SPINLOCK_REFCOUNT parameter, the architecture
+ * will use the generic implementation with default tuning parameters. There
+ * is nothing else an architecture need to do.
+ *
+ * On the other hand, defining just the ARCH_SPINLOCK_REFCOUNT parameter
+ * indicates that the architecture is provding its own implementation. It
+ * has to provide an <asm/spinlock_refcount.h> header file.
+ *
+ * By defining both parameters, the architecture indicates that it is using
+ * the generic implementation, but with customized tuning parameters specified
+ * in the <asm/spinlock_refcount.h> header file. This header file should also
+ * include the <asm-generic/spinlock_refcount.h> header file.
+ *
+ * The supported tuning parameters that can be specified in
+ * <asm/spinlock_refcount.h> are:
+ * 1. LOCKREF_WAIT_SHIFT (default = 0)
+ *    A value of 0 will force the code to wait indefinitely until the spinlock
+ *    is free before attempting to do a lockless update of reference count.
+ *    A non-zero value (n) will cause the waiting code to loop 2^n times
+ *    before aborting the wait for a free spinlock.
+ * 2. LOCKREF_RETRY_COUNT (default = 2)
+ *    The number of lockless reference count updates attempted by the code
+ *    before falling back to taking the spinlock.
+ */
+#ifdef CONFIG_SPINLOCK_REFCOUNT
+
+# ifdef CONFIG_ARCH_SPINLOCK_REFCOUNT
+# include <asm/spinlock_refcount.h>
+# else
+# include <asm-generic/spinlock_refcount.h>
+# endif
+
+#else
+/*
+ * If the spinlock & reference count optimization feature is disabled,
+ * they will be accessed separately on its own.
+ */
+struct lockref {
+	unsigned int refcnt;	/* Reference count */
+	spinlock_t   lock;
+};
+
+/*
+ * Struct lockref helper functions
+ */
+/**
+ * lockref_get - Increments reference count unconditionally
+ * @lockcnt: pointer to lockref structure
+ */
+static __always_inline void lockref_get(struct lockref *lockcnt)
+{
+	spin_lock(&lockcnt->lock);
+	lockcnt->refcnt++;
+	spin_unlock(&lockcnt->lock);
+}
+
+/**
+ * lockref_get_not_zero - Increments count unless the count is 0
+ * @lockcnt: pointer to lockref structure
+ * Return: 1 if count updated successfully or 0 if count is 0
+ */
+static __always_inline int lockref_get_not_zero(struct lockref *lockcnt)
+{
+	int retval = 0;
+
+	spin_lock(&lockcnt->lock);
+	if (likely(lockcnt->refcnt)) {
+		lockcnt->refcnt++;
+		retval = 1;
+	}
+	spin_unlock(&lockcnt->lock);
+	return retval;
+}
+
+/**
+ * lockref_put - Decrements count unless count <= 1 before decrement
+ * @lockcnt: pointer to lockref structure
+ * Return: 1 if count updated successfully or 0 if count <= 1
+ */
+static __always_inline int lockref_put(struct lockref *lockcnt)
+{
+	int retval = 0;
+
+	spin_lock(&lockcnt->lock);
+	if (likely(lockcnt->refcnt > 1)) {
+		lockcnt->refcnt--;
+		retval = 1;
+	}
+	spin_unlock(&lockcnt->lock);
+	return retval;
+}
+
+/**
+ * lockref_put_or_lock - decrements count unless count <= 1 before decrement
+ * @lockcnt: pointer to lockref structure
+ * Return: 1 if count updated successfully or 0 if count <= 1 and lock taken
+ *
+ * The only difference between lockref_put_or_lock and lockref_put is that
+ * the former function will hold the lock on return while the latter one
+ * will free it on return.
+ */
+static __always_inline int lockref_put_or_locked(struct lockref *lockcnt)
+{
+	spin_lock(&lockcnt->lock);
+	if (likely(lockcnt->refcnt > 1)) {
+		lockcnt->refcnt--;
+		spin_unlock(&lockcnt->lock);
+		return 1;
+	}
+	return 0;
+}
+
+#endif /* !CONFIG_SPINLOCK_REFCOUNT */
+#endif /* __LINUX_SPINLOCK_REFCOUNT_H */
diff --git a/kernel/Kconfig.locks b/kernel/Kconfig.locks
index d2b32ac..67ff90b 100644
--- a/kernel/Kconfig.locks
+++ b/kernel/Kconfig.locks
@@ -223,3 +223,18 @@ endif
 config MUTEX_SPIN_ON_OWNER
 	def_bool y
 	depends on SMP && !DEBUG_MUTEXES
+
+#
+# Spinlock with reference count optimization
+#
+config GENERIC_SPINLOCK_REFCOUNT
+	bool
+
+config ARCH_SPINLOCK_REFCOUNT
+	bool
+
+config SPINLOCK_REFCOUNT
+	def_bool y
+	depends on ARCH_SPINLOCK_REFCOUNT || GENERIC_SPINLOCK_REFCOUNT
+	depends on SMP
+	depends on !GENERIC_LOCKBREAK && !DEBUG_SPINLOCK && !DEBUG_LOCK_ALLOC
diff --git a/lib/Makefile b/lib/Makefile
index c09e38e..bb2d83b 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -183,3 +183,5 @@ quiet_cmd_build_OID_registry = GEN     $@
 clean-files	+= oid_registry_data.c
 
 obj-$(CONFIG_UCS2_STRING) += ucs2_string.o
+
+obj-$(CONFIG_GENERIC_SPINLOCK_REFCOUNT) += spinlock_refcount.o
diff --git a/lib/spinlock_refcount.c b/lib/spinlock_refcount.c
new file mode 100644
index 0000000..e32dc58
--- /dev/null
+++ b/lib/spinlock_refcount.c
@@ -0,0 +1,218 @@
+/*
+ * Generic spinlock with reference count combo
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * (C) Copyright 2013 Hewlett-Packard Development Company, L.P.
+ *
+ * Authors: Waiman Long <waiman.long@hp.com>
+ */
+
+#include <linux/spinlock.h>
+#include <linux/spinlock_refcount.h>
+
+/*
+ * The _SHOW_WAIT_LOOP_TIME macro is for internal instrumentation purpose
+ * only during development. It should not be set in production system.
+ */
+#ifdef _SHOW_WAIT_LOOP_TIME
+#include <linux/time.h>
+#endif
+
+/*
+ * The LOCKREF_WAIT_SHIFT macro defines the maximum number of waiting spins
+ * when the lock is not free before trying to attempt a lockless update.
+ * The purpose of the timeout is to limit the amount of unfairness to the
+ * thread that is doing the reference count update. Otherwise, it is
+ * theoretically possible for that thread to be starved for a really long
+ * time causing all kind of problems. If it times out and the lock is still
+ * not free, the code will fall back to the traditional way of queuing up
+ * to acquire the lock before updating the count.
+ *
+ * The actual time spent in the wait loop very much depends on the CPU being
+ * used. On a 2.4GHz Westmere CPU, the execution time of a PAUSE instruction
+ * (cpu_relax) in a 4k loop is about 16us. The lock checking and looping
+ * overhead is about 8us. With 4 cpu_relax's in the loop, it will wait
+ * about 72us before the count reaches 0. With cacheline contention, the
+ * wait time can go up to 3x as much (about 210us). Having multiple
+ * cpu_relax's in the wait loop does seem to reduce cacheline contention
+ * somewhat and give slightly better performance.
+ *
+ * The preset timeout value could be rather arbitrary and really depends on
+ * the CPU being used. The exact value is not that important. A longer wait
+ * time will increase the chance of doing a lockless update, but it results
+ * in more unfairness to the waiting thread and vice versa. A value of 0
+ * indicates that the waiting code will wait forever until the lock is free.
+ *
+ * Default = 0
+ */
+#ifndef LOCKREF_WAIT_SHIFT
+#define LOCKREF_WAIT_SHIFT	0
+#endif
+#if LOCKREF_WAIT_SHIFT == 0
+#define LOCKREF_SPIN_WAIT_MAX	INT_MAX
+#else
+#define	LOCKREF_SPIN_WAIT_MAX	(1<<LOCKREF_WAIT_SHIFT)
+#endif
+
+/*
+ * The number of attempts to update the reference count locklessly before
+ * quitting (default = 2).
+ */
+#ifndef	LOCKREF_RETRY_COUNT
+#define LOCKREF_RETRY_COUNT	2
+#endif
+
+/*
+ * The maximum backoff shift value
+ */
+#define	LOCKREF_BACKOFF_SHIFT_MAX	6
+
+/**
+ *
+ * lockref_add_unless - atomically add to count unless locked or reach threshold
+ *
+ * @lockcnt  : pointer to the lockref structure
+ * @value    : value to be added
+ * @threshold: threshold value for acquiring the lock
+ * Return    : 1 if operation succeeds, 0 otherwise
+ *
+ * If the lock was not acquired, lockref_add_unless() atomically adds the
+ * given value to the reference count unless the given threshold is reached.
+ * If the lock was acquired or the threshold was reached, 0 is returned and
+ * the caller will have to acquire the lock and update the count accordingly
+ * (can be done in a non-atomic way).
+ */
+static __always_inline int
+lockref_add_unless(struct lockref *lockcnt, int value, int threshold)
+{
+	struct lockref old, new;
+	int loopcnt;
+#ifdef _SHOW_WAIT_LOOP_TIME
+	struct timespec tv1, tv2;
+#endif
+
+	/*
+	 * Code doesn't work if raw spinlock is larger than 4 bytes
+	 * or is empty.
+	 */
+	BUILD_BUG_ON((sizeof(arch_spinlock_t) == 0) ||
+		     (sizeof(arch_spinlock_t) >  4));
+
+	/*
+	 * Wait a certain amount of time until the lock is free or the loop
+	 * counter reaches 0. Doing multiple cpu_relax() helps to reduce
+	 * contention in the spinlock cacheline and achieve better performance.
+	 */
+#ifdef _SHOW_WAIT_LOOP_TIME
+	getnstimeofday(&tv1);
+#endif
+	loopcnt = LOCKREF_SPIN_WAIT_MAX;
+	while (loopcnt && spin_is_locked(&lockcnt->lock)) {
+		loopcnt--;
+		cpu_relax();
+		cpu_relax();
+		cpu_relax();
+		cpu_relax();
+	}
+
+#ifdef _SHOW_WAIT_LOOP_TIME
+	if (loopcnt == 0) {
+		unsigned long ns;
+
+		getnstimeofday(&tv2);
+		ns = (tv2.tv_sec - tv1.tv_sec) * NSEC_PER_SEC +
+		     (tv2.tv_nsec - tv1.tv_nsec);
+		pr_info("lockref wait loop time = %lu ns\n", ns);
+	}
+#endif
+
+	loopcnt = 0;
+	barrier();
+	do {
+		unsigned u;
+
+		old.lock_count = ACCESS_ONCE(lockcnt->lock_count);
+		if ((threshold >= 0) && (old.refcnt <= threshold))
+			break;
+		if (likely(!spin_is_locked(&old.lock))) {
+			new.lock_count = old.lock_count;
+			new.refcnt += value;
+			if (cmpxchg64(&lockcnt->lock_count, old.lock_count,
+				      new.lock_count) == old.lock_count)
+				return 1;
+		}
+		/*
+		 * Exponential backoff when contended
+		 * The LOCKREF_RETRY_COUNT should be a small number.
+		 */
+		u = 1 << min(loopcnt, LOCKREF_BACKOFF_SHIFT_MAX);
+		do {
+			cpu_relax();
+		} while (--u > 0);
+	} while (++loopcnt <= LOCKREF_RETRY_COUNT);
+	return 0;
+}
+
+/*
+ * Struct lockref helper functions
+ */
+/**
+ * lockref_get - Increments reference count unconditionally
+ * @lockcnt: pointer to struct lockref structure
+ */
+void lockref_get(struct lockref *lockcnt)
+{
+	if (lockref_add_unless(lockcnt, 1, -1))
+		return;
+	spin_lock(&lockcnt->lock);
+	lockcnt->refcnt++;
+	spin_unlock(&lockcnt->lock);
+}
+EXPORT_SYMBOL(lockref_get);
+
+/**
+ * lockref_get_not_zero - Increments count unless the count is 0
+ * @lockcnt: pointer to struct lockref structure
+ * Return: 1 if count updated successfully or 0 if count is 0 and lock taken
+ */
+int lockref_get_not_zero(struct lockref *lockcnt)
+{
+	return lockref_add_unless(lockcnt, 1, 0);
+}
+EXPORT_SYMBOL(lockref_get_not_zero);
+
+/**
+ * lockref_put - Decrements count unless the count <= 1
+ * @lockcnt: pointer to struct lockref structure
+ * Return: 1 if count updated successfully or 0 if count <= 1
+ */
+int lockref_put(struct lockref *lockcnt)
+{
+	return lockref_add_unless(lockcnt, -1, 1);
+}
+EXPORT_SYMBOL(lockref_put);
+
+/**
+ * lockref_put_or_lock - Decrements count unless the count is <= 1
+ *			 otherwise, the lock will be taken
+ * @lockcnt: pointer to struct lockref structure
+ * Return: 1 if count updated successfully or 0 if count <= 1 and lock taken
+ */
+int
+lockref_put_or_lock(struct lockref *lockcnt)
+{
+	if (lockref_add_unless(lockcnt, -1, 1))
+		return 1;
+	spin_lock(&lockcnt->lock);
+	return 0;
+}
+EXPORT_SYMBOL(lockref_put_or_lock);
-- 
1.7.1

