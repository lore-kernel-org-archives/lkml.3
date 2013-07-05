Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509Ab3GEOsM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 10:48:12 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:32705 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757474Ab3GEOsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 10:48:05 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH v5 01/12] spinlock: A new lockref structure for lockless update of refcount
Date: Fri,  5 Jul 2013 10:47:34 -0400
Message-Id: <1373035656-40600-2-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1373035656-40600-1-git-send-email-Waiman.Long@hp.com>
References: <1373035656-40600-1-git-send-email-Waiman.Long@hp.com>
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

Two new config parameters are introduced:
1. SPINLOCK_REFCOUNT
2. ARCH_SPINLOCK_REFCOUNT

The first one is defined in the kernel/Kconfig.locks which is used
to enable or disable the faster lockless reference count update
optimization. The second one has to be defined in each of the
architecture's Kconfig file to enable the optimization for that
architecture. Therefore, each architecture has to opt-in for this
optimization or it won't get it. This allows each architecture plenty
of time to test it out before deciding to use it or replace it with
a better architecture specific solution.

This optimization won't work for non-SMP system or when spinlock
debugging is turned on. As a result, it is turned off each any of
them is true. It also won't work for full preempt-RT and so should
be turned on in this case.

The current patch allows 3 levels of access to the new lockref
structure:

1. The lockless update optimization is turned off (SPINLOCK_REFCOUNT=n).
2. The lockless update optimization is turned on and the generic version
   is used (SPINLOCK_REFCOUNT=y and ARCH_SPINLOCK_REFCOUNT=y).
3. The lockless update optimization is turned on and the architecture
   provides its own version.

To maximize the chance of doing lockless update in the generic version,
the inlined __lockref_add_unless() function will wait for a certain
amount of time if the lock is not free before trying to do the update.

The new code also attempts to do lockless atomic update twice before
falling back to the old code path of acquiring a lock before doing
the update. It is because there will still be some fair amount of
contention with only one attempt.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 include/asm-generic/spinlock_refcount.h |   46 ++++++
 include/linux/spinlock_refcount.h       |  107 ++++++++++++++
 kernel/Kconfig.locks                    |    5 +
 lib/Makefile                            |    2 +
 lib/spinlock_refcount.c                 |  229 +++++++++++++++++++++++++++++++
 5 files changed, 389 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-generic/spinlock_refcount.h
 create mode 100644 include/linux/spinlock_refcount.h
 create mode 100644 lib/spinlock_refcount.c

diff --git a/include/asm-generic/spinlock_refcount.h b/include/asm-generic/spinlock_refcount.h
new file mode 100644
index 0000000..469b96b
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
+		u64		__lock_count;
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
+extern int  lockref_put_or_locked(struct lockref *lockcnt);
+
+#endif /* __ASM_GENERIC_SPINLOCK_REFCOUNT_H */
diff --git a/include/linux/spinlock_refcount.h b/include/linux/spinlock_refcount.h
new file mode 100644
index 0000000..28b0b89
--- /dev/null
+++ b/include/linux/spinlock_refcount.h
@@ -0,0 +1,107 @@
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
+#ifndef __LINUX_SPINLOCK_REFCOUNT_H
+#define __LINUX_SPINLOCK_REFCOUNT_H
+
+#include <linux/spinlock.h>
+
+#ifdef CONFIG_SPINLOCK_REFCOUNT
+#include <asm/spinlock_refcount.h>
+#else
+/*
+ * If the spinlock & reference count optimization feature is disabled,
+ * the spinlock and reference count are accessed separately on its own.
+ */
+struct lockref {
+	unsigned int refcnt;	/* Reference count */
+	spinlock_t   lock;
+};
+
+/*
+ * Struct lockref helper functions
+ */
+/*
+ * lockref_get - increments reference count while not locked
+ * @lockcnt: pointer to lockref structure
+ */
+static __always_inline void
+lockref_get(struct lockref *lockcnt)
+{
+	spin_lock(&lockcnt->lock);
+	lockcnt->refcnt++;
+	spin_unlock(&lockcnt->lock);
+}
+
+/*
+ * lockref_get_not_zero - increments count unless the count is 0
+ * @lockcnt: pointer to lockref structure
+ * Return: 1 if count updated successfully or 0 if count is 0
+ */
+static __always_inline int
+lockref_get_not_zero(struct lockref *lockcnt)
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
+/*
+ * lockref_put - decrements count unless count <= 1 before decrement
+ * @lockcnt: pointer to lockref structure
+ * Return: 1 if count updated successfully or 0 if count <= 1
+ */
+static __always_inline int
+lockref_put(struct lockref *lockcnt)
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
+/*
+ * lockref_put_or_locked - decrements count unless count <= 1 before decrement
+ *			   otherwise the lock will be taken
+ * @lockcnt: pointer to lockref structure
+ * Return: 1 if count updated successfully or 0 if count <= 1 and lock taken
+ */
+static __always_inline int
+lockref_put_or_locked(struct lockref *lockcnt)
+{
+	spin_lock(&lockcnt->lock);
+	if (likely(lockcnt->refcnt > 1)) {
+		lockcnt->refcnt--;
+		spin_unlock(&lockcnt->lock);
+		return 1;
+	}
+	return 0;	/* Count is 1 & lock taken */
+}
+
+#endif /* CONFIG_SPINLOCK_REFCOUNT */
+#endif /* __LINUX_SPINLOCK_REFCOUNT_H */
diff --git a/kernel/Kconfig.locks b/kernel/Kconfig.locks
index 44511d1..d1f8670 100644
--- a/kernel/Kconfig.locks
+++ b/kernel/Kconfig.locks
@@ -223,3 +223,8 @@ endif
 config MUTEX_SPIN_ON_OWNER
 	def_bool y
 	depends on SMP && !DEBUG_MUTEXES
+
+config SPINLOCK_REFCOUNT
+	def_bool y
+	depends on ARCH_SPINLOCK_REFCOUNT && SMP
+	depends on !GENERIC_LOCKBREAK && !DEBUG_SPINLOCK && !DEBUG_LOCK_ALLOC
diff --git a/lib/Makefile b/lib/Makefile
index c55a037..0367915 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -179,3 +179,5 @@ quiet_cmd_build_OID_registry = GEN     $@
 clean-files	+= oid_registry_data.c
 
 obj-$(CONFIG_UCS2_STRING) += ucs2_string.o
+
+obj-$(CONFIG_SPINLOCK_REFCOUNT) += spinlock_refcount.o
diff --git a/lib/spinlock_refcount.c b/lib/spinlock_refcount.c
new file mode 100644
index 0000000..1f599a7
--- /dev/null
+++ b/lib/spinlock_refcount.c
@@ -0,0 +1,229 @@
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
+#include <asm-generic/spinlock_refcount.h>
+
+#ifdef _SHOW_WAIT_LOOP_TIME
+#include <linux/time.h>
+#endif
+
+/*
+ * The maximum number of waiting spins when the lock was acquiring before
+ * trying to attempt a lockless update. The purpose of the timeout is to
+ * limit the amount of unfairness to the thread that is doing the reference
+ * count update. Otherwise, it is theoretically possible for that thread to
+ * be starved for a really long time causing all kind of problems. If it
+ * times out and the lock is still not free, the code will fall back to the
+ * traditional way of queuing up to acquire the lock before updating the count.
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
+ * The preset timeout value is rather arbitrary and really depends on the CPU
+ * being used. If customization is needed, we could add a config variable for
+ * that. The exact value is not that important. A longer wait time will
+ * increase the chance of doing a lockless update, but it results in more
+ * unfairness to the waiting thread and vice versa.
+ */
+#ifndef CONFIG_LOCKREF_WAIT_SHIFT
+#define CONFIG_LOCKREF_WAIT_SHIFT	12
+#endif
+#define	LOCKREF_SPIN_WAIT_MAX	(1<<CONFIG_LOCKREF_WAIT_SHIFT)
+
+/**
+ *
+ * __lockref_add_unless - atomically add the given value to the count unless
+ *			  the lock was acquired or the count equals to the
+ *			  given threshold value.
+ *
+ * @plockcnt : pointer to the combined lock and count 8-byte data
+ * @plock    : pointer to the spinlock
+ * @pcount   : pointer to the reference count
+ * @value    : value to be added
+ * @threshold: threshold value for acquiring the lock
+ * Return    : 1 if operation succeeds, 0 otherwise
+ *
+ * If the lock was not acquired, __lockref_add_unless() atomically adds the
+ * given value to the reference count unless the given threshold is reached.
+ * If the lock was acquired or the threshold was reached, 0 is returned and
+ * the caller will have to acquire the lock and update the count accordingly
+ * (can be done in a non-atomic way).
+ *
+ * N.B. The lockdep code won't be run as this optimization should be disabled
+ *	when LOCK_STAT is enabled.
+ */
+static __always_inline int
+__lockref_add_unless(u64 *plockcnt, spinlock_t *plock, unsigned int *pcount,
+		     int value, int threshold)
+{
+	struct lockref old, new;
+	int   get_lock, loopcnt;
+#ifdef _SHOW_WAIT_LOOP_TIME
+	struct timespec tv1, tv2;
+#endif
+
+	/*
+	 * Code doesn't work if raw spinlock is larger than 4 bytes
+	 * or is empty.
+	 */
+	BUILD_BUG_ON(sizeof(arch_spinlock_t) == 0);
+	if (sizeof(arch_spinlock_t) > 4)
+		return 0;	/* Need to acquire the lock explicitly */
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
+	while (loopcnt && spin_is_locked(plock)) {
+		loopcnt--;
+		cpu_relax();
+		cpu_relax();
+		cpu_relax();
+		cpu_relax();
+	}
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
+#ifdef CONFIG_LOCK_STAT
+	if (loopcnt != LOCKREF_SPIN_WAIT_MAX)
+		lock_contended(plock->dep_map, _RET_IP_);
+#endif
+	old.__lock_count = ACCESS_ONCE(*plockcnt);
+	get_lock = ((threshold >= 0) && (old.refcnt <= threshold));
+	if (likely(!get_lock && !spin_is_locked(&old.lock))) {
+		new.__lock_count = old.__lock_count;
+		new.refcnt += value;
+		if (cmpxchg64(plockcnt, old.__lock_count, new.__lock_count)
+		    == old.__lock_count)
+			return 1;
+		cpu_relax();
+		cpu_relax();
+		/*
+		 * Try one more time
+		 */
+		old.__lock_count = ACCESS_ONCE(*plockcnt);
+		get_lock = ((threshold >= 0) && (old.refcnt <= threshold));
+		if (likely(!get_lock && !spin_is_locked(&old.lock))) {
+			new.__lock_count = old.__lock_count;
+			new.refcnt += value;
+			if (cmpxchg64(plockcnt, old.__lock_count,
+				      new.__lock_count) == old.__lock_count)
+				return 1;
+			cpu_relax();
+		}
+	}
+	return 0;	/* The caller will need to acquire the lock */
+}
+
+/*
+ * Generic macros to increment and decrement reference count
+ * @sname : pointer to lockref structure
+ * @lock  : name of spinlock in structure
+ * @count : name of reference count in structure
+ *
+ * LOCKREF_GET()  - increments count unless it is locked
+ * LOCKREF_GET0() - increments count unless it is locked or count is 0
+ * LOCKREF_PUT()  - decrements count unless it is locked or count is 1
+ */
+#define LOCKREF_GET(sname, lock, count)					\
+	__lockref_add_unless(&(sname)->__lock_count, &(sname)->lock,	\
+			     &(sname)->count, 1, -1)
+#define LOCKREF_GET0(sname, lock, count)				\
+	__lockref_add_unless(&(sname)->__lock_count, &(sname)->lock,	\
+			     &(sname)->count, 1, 0)
+#define LOCKREF_PUT(sname, lock, count)					\
+	__lockref_add_unless(&(sname)->__lock_count, &(sname)->lock,	\
+			     &(sname)->count, -1, 1)
+
+/*
+ * Struct lockref helper functions
+ */
+/*
+ * lockref_get - increments reference count
+ * @lockcnt: pointer to struct lockref structure
+ */
+void
+lockref_get(struct lockref *lockcnt)
+{
+	if (LOCKREF_GET(lockcnt, lock, refcnt))
+		return;
+	spin_lock(&lockcnt->lock);
+	lockcnt->refcnt++;
+	spin_unlock(&lockcnt->lock);
+}
+EXPORT_SYMBOL(lockref_get);
+
+/*
+ * lockref_get_not_zero - increments count unless the count is 0
+ * @lockcnt: pointer to struct lockref structure
+ * Return: 1 if count updated successfully or 0 if count is 0 and lock taken
+ */
+int
+lockref_get_not_zero(struct lockref *lockcnt)
+{
+	return LOCKREF_GET0(lockcnt, lock, refcnt);
+}
+EXPORT_SYMBOL(lockref_get_not_zero);
+
+/*
+ * lockref_put - decrements count unless the count <= 1
+ * @lockcnt: pointer to struct lockref structure
+ * Return: 1 if count updated successfully or 0 if count <= 1
+ */
+int
+lockref_put(struct lockref *lockcnt)
+{
+	return LOCKREF_PUT(lockcnt, lock, refcnt);
+}
+EXPORT_SYMBOL(lockref_put);
+
+/*
+ * lockref_put_or_locked - decrements count unless the count is <= 1
+ *			   otherwise, the lock will be taken
+ * @lockcnt: pointer to struct lockref structure
+ * Return: 1 if count updated successfully or 0 if count <= 1 and lock taken
+ */
+int
+lockref_put_or_locked(struct lockref *lockcnt)
+{
+	if (LOCKREF_PUT(lockcnt, lock, refcnt))
+		return 1;
+	spin_lock(&lockcnt->lock);
+	return 0;
+}
+EXPORT_SYMBOL(lockref_put_or_locked);
-- 
1.7.1

