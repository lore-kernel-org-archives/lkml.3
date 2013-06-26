Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619Ab3FZRn4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 13:43:56 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:38930 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab3FZRny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 13:43:54 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH v2 1/2] spinlock: New spinlock_refcount.h for lockless update of refcount
Date: Wed, 26 Jun 2013 13:43:22 -0400
Message-Id: <1372268603-46748-2-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1372268603-46748-1-git-send-email-Waiman.Long@hp.com>
References: <1372268603-46748-1-git-send-email-Waiman.Long@hp.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a new spinlock_refcount.h header file to be
included by kernel code that want to do a lockless update of reference
count protected by a spinlock.

To try to locklessly update the reference count while lock isn't
acquired by others, the 32-bit count and 32-bit raw spinlock can be
combined into a single 64-bit word to be updated atomically whenever
the following conditions are true:

1. The lock is not taken, i.e. spin_can_lock() returns true.
2. The value of the count isn't equal to the given non-negative
   threshold value.

To maximize the chance of doing lockless update, the inlined
__lockcnt_add_unless() function calls spin_unlock_wait() before trying
to do the update.

The new code also attempts to do lockless atomic update twice before
falling back to the old code path of acquring a lock before doing
the update. It is because there will still be some fair amount of
contention with only one attempt.

After including the header file, the LOCK_WITH_REFCOUNT() macro
should be used to define the spinlock with reference count combo in
an embedding data structure.  Then the __lockcnt_add_unless() inlined
function can be used to locklessly update the reference count if the
lock hasn't be acquired by others. Some predefined lockref_*() macros
that call __lockcnt_add_unless() can also be used for this purpose.

Build and boot tests of the new code and the associated dcache changes
were conducted for the following configurations:
1. x86 64-bit SMP, CONFIG_DEBUG_SPINLOCK=n
2. x86 64-bit SMP, CONFIG_DEBUG_SPINLOCK=y
3. x86 32-bit UP , CONFIG_DEBUG_SPINLOCK=n
4. x86 32-bit SMP, CONFIG_DEBUG_SPINLOCK=n
5. x86 32-bit SMP, CONFIG_DEBUG_SPINLOCK=y

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 include/linux/spinlock_refcount.h |  177 +++++++++++++++++++++++++++++++++++++
 include/linux/spinlock_types.h    |   19 ++++
 2 files changed, 196 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/spinlock_refcount.h

diff --git a/include/linux/spinlock_refcount.h b/include/linux/spinlock_refcount.h
new file mode 100644
index 0000000..0160861
--- /dev/null
+++ b/include/linux/spinlock_refcount.h
@@ -0,0 +1,177 @@
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
+ * (C) Copyright 2013 Hewlett-Packard Development Company, L.P.
+ *
+ * Authors: Waiman Long <waiman.long@hp.com>
+ */
+#ifndef __LINUX_SPINLOCK_REFCOUNT_H
+#define __LINUX_SPINLOCK_REFCOUNT_H
+
+#include <linux/spinlock.h>
+
+/*
+ * The raw __LOCK_WITH_REFCOUNT() macro defines the combined spinlock with
+ * reference count data structure to be embedded in a larger structure.
+ * With unnamed union, the lock and count names can be accessed directly if
+ * no field name is assigned to the structure. Otherwise, they will have to
+ * be accessed indirectly via the assigned field name of the combined
+ * structure.
+ *
+ * The combined data structure is 8-byte aligned. So proper placement of this
+ * structure in the larger embedding data structure is needed to ensure that
+ * there is no hole in it.
+ *
+ * @lock:   Name of the spinlock
+ * @count:  Name of the reference count
+ * @u_name: Name of combined data structure union (can be empty for unnamed
+ *	    union)
+ */
+#ifndef CONFIG_SMP
+#define __LOCK_WITH_REFCOUNT(lock, count, u_name)	\
+	unsigned int count;				\
+	spinlock_t   lock
+
+#elif defined(__SPINLOCK_HAS_REFCOUNT)
+#define __LOCK_WITH_REFCOUNT(lock, count, u_name)	\
+	union u_name {					\
+		u64		__lock_count;		\
+		spinlock_t	lock;			\
+		struct {				\
+			arch_spinlock_t __raw_lock;	\
+			unsigned int	count;		\
+		};					\
+	}
+
+#else /* __SPINLOCK_HAS_REFCOUNT */
+#define __LOCK_WITH_REFCOUNT(lock, count, u_name)	\
+	union u_name {					\
+		u64		__lock_count;		\
+		struct {				\
+			unsigned int	count;		\
+			spinlock_t	lock;		\
+		};					\
+	}
+
+#endif /* __SPINLOCK_HAS_REFCOUNT */
+
+/*
+ * The LOCK_WITH_REFCOUNT() macro create an unnamed union structure
+ */
+#define LOCK_WITH_REFCOUNT(lock, count)			\
+	__LOCK_WITH_REFCOUNT(lock, count, /**/)
+
+#ifdef CONFIG_SMP
+#define	LOCKCNT_COMBO_PTR(s)	(&(s)->__lock_count)
+
+/*
+ * Define a "union _lock_refcnt" structure to be used by the helper function
+ */
+__LOCK_WITH_REFCOUNT(lock, count, __lock_refcnt);
+
+/**
+ *
+ * __lockcnt_add_unless - atomically add the given value to the count unless
+ *			  the lock was acquired or the count equals to the
+ *			  given threshold value.
+ *
+ * @plockcnt : pointer to the combined lock and count 8-byte data
+ * @plock    : pointer to the spinlock
+ * @pcount   : pointer to the reference count
+ * @value    : value to be added
+ * @threshold: threshold value for acquiring the lock
+ * Return    : 1 if operation succeed, 0 otherwise
+ *
+ * If the lock was not acquired, __lockcnt_add_unless() atomically adds the
+ * given value to the reference count unless the given threshold is reached.
+ * If the lock was acquired or the threshold was reached, 0 is returned and
+ * the caller will have to acquire the lock and update the count accordingly
+ * (can be done in a non-atomic way).
+ */
+static inline int
+__lockcnt_add_unless(u64 *plockcnt, spinlock_t *plock, unsigned int *pcount,
+		     int value, int threshold)
+{
+	union __lock_refcnt old, new;
+	int   get_lock;
+
+	/*
+	 * Code doesn't work if raw spinlock is larger than 4 bytes
+	 * or is empty.
+	 */
+	BUG_ON((sizeof(arch_spinlock_t) > 4) || (sizeof(arch_spinlock_t) == 0));
+
+	spin_unlock_wait(plock);	/* Wait until lock is released */
+	old.__lock_count = ACCESS_ONCE(*plockcnt);
+	get_lock = ((threshold >= 0) && (old.count == threshold));
+	if (likely(!get_lock && spin_can_lock(&old.lock))) {
+		new.__lock_count = old.__lock_count;
+		new.count += value;
+		if (cmpxchg64(plockcnt, old.__lock_count, new.__lock_count)
+		    == old.__lock_count)
+			return 1;
+		cpu_relax();
+		/*
+		 * Try one more time
+		 */
+		old.__lock_count = ACCESS_ONCE(*plockcnt);
+		get_lock = ((threshold >= 0) && (old.count == threshold));
+		if (likely(!get_lock && spin_can_lock(&old.lock))) {
+			new.__lock_count = old.__lock_count;
+			new.count += value;
+			if (cmpxchg64(plockcnt, old.__lock_count,
+				      new.__lock_count) == old.__lock_count)
+				return 1;
+			cpu_relax();
+		}
+	}
+	return 0;	/* The caller will need to acquire the lock */
+}
+#else /* CONFIG_SMP */
+#define	LOCKCNT_COMBO_PTR(s)	NULL
+
+/*
+ * Just add the value as the spinlock is a no-op
+ */
+static inline int
+__lockcnt_add_unless(u64 *plockcnt, spinlock_t *plock, unsigned int *pcount,
+		     int value, int threshold)
+{
+	if ((threshold >= 0) && (*pcount == threshold))
+		return 0;
+	(*pcount) += value;
+	return 1;
+}
+#endif /* CONFIG_SMP */
+
+/*
+ * Generic macros to increment and decrement reference count
+ * @sname : pointer to structure that embeds spinlock & reference count combo
+ * @lock  : name of spinlock in structure
+ * @count : name of reference count in structure
+ *
+ * lockref_get()  - increments count unless it is locked
+ * lockref_get0() - increments count unless it is locked or count is 0
+ * lockref_put()  - decrements count unless it is locked or count is 1
+ */
+#define lockref_get(sname, lock, count) 				\
+	__lockcnt_add_unless(LOCKCNT_COMBO_PTR(sname), &(sname)->lock,	\
+			     &(sname)->count, 1, -1)
+#define lockref_get0(sname, lock, count) 				\
+	__lockcnt_add_unless(LOCKCNT_COMBO_PTR(sname), &(sname)->lock,	\
+			     &(sname)->count, 1, 0)
+#define lockref_put(sname, lock, count) 				\
+	__lockcnt_add_unless(LOCKCNT_COMBO_PTR(sname), &(sname)->lock,	\
+			     &(sname)->count, -1, 1)
+
+#endif /* __LINUX_SPINLOCK_REFCOUNT_H */
diff --git a/include/linux/spinlock_types.h b/include/linux/spinlock_types.h
index 73548eb..cc107ad 100644
--- a/include/linux/spinlock_types.h
+++ b/include/linux/spinlock_types.h
@@ -17,8 +17,27 @@
 
 #include <linux/lockdep.h>
 
+/*
+ * The presence of either one of the CONFIG_DEBUG_SPINLOCK or
+ * CONFIG_DEBUG_LOCK_ALLOC configuration parameter will force the
+ * spinlock_t structure to be 8-byte aligned.
+ *
+ * To support the spinlock/reference count combo data type for 64-bit SMP
+ * environment with spinlock debugging turned on, the reference count has
+ * to be integrated into the spinlock_t data structure in this special case.
+ * The spinlock_t data type will be 8 bytes larger if CONFIG_GENERIC_LOCKBREAK
+ * is also defined.
+ */
+#if defined(CONFIG_64BIT) && (defined(CONFIG_DEBUG_SPINLOCK) ||\
+			      defined(CONFIG_DEBUG_LOCK_ALLOC))
+#define	__SPINLOCK_HAS_REFCOUNT	1
+#endif
+
 typedef struct raw_spinlock {
 	arch_spinlock_t raw_lock;
+#ifdef __SPINLOCK_HAS_REFCOUNT
+	unsigned int count;
+#endif
 #ifdef CONFIG_GENERIC_LOCKBREAK
 	unsigned int break_lock;
 #endif
-- 
1.7.1

