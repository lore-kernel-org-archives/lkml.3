Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308Ab3HFDNK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 23:13:10 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:22422 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700Ab3HFDNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 23:13:06 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH v7 1/4] spinlock: A new lockref structure for lockless update of refcount
Date: Mon,  5 Aug 2013 23:12:36 -0400
Message-Id: <1375758759-29629-2-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1375758759-29629-1-git-send-email-Waiman.Long@hp.com>
References: <1375758759-29629-1-git-send-email-Waiman.Long@hp.com>
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
the architecture will have to provide its own implementation.

This optimization won't work for non-SMP system or when spinlock
debugging is turned on. As a result, it is turned off each any of
them is true. It also won't work for full preempt-RT and so should
be turned off in this case.

To maximize the chance of doing lockless atomic update, the new code
will wait until the lock is free before trying to do the update.
The code will also attempt to do lockless atomic update a few times
before falling back to the old code path of acquiring a lock before
doing the update.

The table below shows the average JPM (jobs/minute) number (out of
3 runs) of the AIM7's short workload at 1500 users for different
configurations on an 8-socket 80-core DL980 with HT off with kernel
based on 3.11-rc3.

Configuration					  JPM
-------------					  ---
Wait till lock free, 1 update attempt		5899907
Wait till lock free, 2 update attempts		6534958
Wait till lock free, 3 update attempts		6868170
Wait till lock free, 4 update attempts		6905332
No wait,  2 update attempts			1091273
No wait,  4 update attempts			1281867
No wait,  8 update attempts			5095203
No wait, 16 update attempts			6392709
No wait, 32 update attempts			6438080

The "no wait, 8 update attempts" test showed high variability in the
results.  One run can have 6M JPM whereas the other one is only 2M
JPM, for example. The "wait till lock free" tests, on the other hand,
are much more stable in their throughput numbers.

For this initial version, the code will wait until the lock is free
with 4 update attempts.

To evaluate the performance difference between doing a reference count
update using the old way (lock->update->unlock) and the new lockref
functions in the uncontended case, a 256K loop was run on a 2.4Ghz
Westmere x86-64 CPU.  The following table shows the average time
(in ns) for a single update operation (including the looping and
timing overhead):

Update Type		Time (ns)
-----------		---------
lock->update->unlock	  14.7
lockref_get/lockref_put	  16.0

The new lockref* functions are about 10% slower than when there is
no contention. Since reference count update is usually a very small
part of a typical workload, the actual performance impact of this
change is negligible when there is no contention.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 include/asm-generic/spinlock_refcount.h |   46 +++++++
 include/linux/spinlock_refcount.h       |  126 ++++++++++++++++++++
 kernel/Kconfig.locks                    |   15 +++
 lib/Makefile                            |    2 +
 lib/spinlock_refcount.c                 |  198 +++++++++++++++++++++++++++++++
 5 files changed, 387 insertions(+), 0 deletions(-)
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
index 0000000..abadd87
--- /dev/null
+++ b/include/linux/spinlock_refcount.h
@@ -0,0 +1,126 @@
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
+ * either one of the following two config parameters in its Kconfig file:
+ * 1. GENERIC_SPINLOCK_REFCOUNT
+ * 2. ARCH_SPINLOCK_REFCOUNT
+ *
+ * By defining just the GENERIC_SPINLOCK_REFCOUNT parameter, the architecture
+ * will use the generic implementation. There is nothing else an architecture
+ * need to do.
+ *
+ * On the other hand, defining the ARCH_SPINLOCK_REFCOUNT parameter indicates
+ * that the architecture is provding its own implementation. It has to provide
+ * an <asm/spinlock_refcount.h> header file.
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
+static __always_inline int lockref_put_or_lock(struct lockref *lockcnt)
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
index 7baccfd..91de559 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -187,3 +187,5 @@ quiet_cmd_build_OID_registry = GEN     $@
 clean-files	+= oid_registry_data.c
 
 obj-$(CONFIG_UCS2_STRING) += ucs2_string.o
+
+obj-$(CONFIG_GENERIC_SPINLOCK_REFCOUNT) += spinlock_refcount.o
diff --git a/lib/spinlock_refcount.c b/lib/spinlock_refcount.c
new file mode 100644
index 0000000..963ff07
--- /dev/null
+++ b/lib/spinlock_refcount.c
@@ -0,0 +1,198 @@
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
+#ifdef CONFIG_SPINLOCK_REFCOUNT
+#include <linux/spinlock.h>
+#include <linux/spinlock_refcount.h>
+
+/*
+ * The number of attempts to update the reference count locklessly before
+ * quitting (default = 4).
+ */
+#ifndef	LOCKREF_RETRY_COUNT
+#define LOCKREF_RETRY_COUNT	4
+#endif
+
+/**
+ *
+ * add_unless - atomically add to count unless locked or reach threshold
+ *
+ * @lockcnt  : pointer to the lockref structure
+ * @value    : value to be added
+ * @threshold: threshold value for acquiring the lock
+ * Return    : 1 if operation succeeds, -1 if threshold reached, 0 otherwise
+ *
+ * If the lock was not acquired, add_unless() atomically adds the given value
+ * to the reference count unless the given threshold is reached. If the lock
+ * was acquired or the threshold was reached, 0 is returned and the caller
+ * will have to acquire the lock and update the count accordingly (can be
+ * done in a non-atomic way).
+ */
+static __always_inline int
+add_unless(struct lockref *lockcnt, int value, int threshold)
+{
+	struct lockref old;
+	register struct lockref new;
+
+	old.lock_count = ACCESS_ONCE(lockcnt->lock_count);
+	if ((threshold >= 0) && (old.refcnt <= threshold))
+		return -1;
+	if (likely(!spin_is_locked(&old.lock))) {
+		new.lock_count = old.lock_count;
+		new.refcnt += value;
+		if (likely(cmpxchg64(&lockcnt->lock_count, old.lock_count,
+				     new.lock_count) == old.lock_count))
+			return 1;
+	}
+	return 0;
+}
+
+/**
+ *
+ * add_unless_loop - call add_unless in a loop
+ *
+ * @lockcnt  : pointer to the lockref structure
+ * @value    : value to be added
+ * @threshold: threshold value for acquiring the lock
+ * @loopcnt  : loop count
+ * Return    : 1 if operation succeeds, 0 otherwise
+ */
+static noinline int
+add_unless_loop(struct lockref *lockcnt, int value, int threshold, int loopcnt)
+{
+	int ret;
+
+	if (threshold >= 0) {
+		for (; loopcnt > 0; loopcnt--) {
+			ret = add_unless(lockcnt, value, threshold);
+			if (ret > 0)
+				return 1;
+			else if (ret < 0)
+				return 0;
+			cpu_relax();
+		}
+	} else {
+		for (; loopcnt > 0; loopcnt--) {
+			if (add_unless(lockcnt, value, -1) > 0)
+				return 1;
+			cpu_relax();
+		}
+	}
+	return 0;
+}
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
+ * The reason for separating out the first lockless update attempt from the
+ * rest is due to the fact that gcc compiler seems to be less able to optimize
+ * complex operations in a loop. So we try it once, if it doesn't work, we
+ * try out the remaining attempts in a separate slowpath function.
+ */
+static __always_inline int
+lockref_add_unless(struct lockref *lockcnt, int value, int threshold)
+{
+	int ret;
+
+	/*
+	 * Code doesn't work if raw spinlock is larger than 4 bytes
+	 * or is empty.
+	 */
+	BUILD_BUG_ON((sizeof(arch_spinlock_t) == 0) ||
+		     (sizeof(arch_spinlock_t) >  4));
+
+	/*
+	 * Wait until the lock is free before attempting to do a lockless
+	 * reference count update.
+	 */
+	while (spin_is_locked(&lockcnt->lock))
+		cpu_relax();
+
+	ret = add_unless(lockcnt, value, threshold);
+	if (likely(ret > 0))
+		return 1;
+	if (unlikely((ret == 0) && (LOCKREF_RETRY_COUNT > 1))) {
+		cpu_relax();
+		if (add_unless_loop(lockcnt, value, threshold,
+				    LOCKREF_RETRY_COUNT - 1))
+			return 1;
+	}
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
+	if (likely(lockref_add_unless(lockcnt, 1, -1)))
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
+	if (likely(lockref_add_unless(lockcnt, -1, 1)))
+		return 1;
+	spin_lock(&lockcnt->lock);
+	return 0;
+}
+EXPORT_SYMBOL(lockref_put_or_lock);
+#endif /* CONFIG_SPINLOCK_REFCOUNT */
-- 
1.7.1

