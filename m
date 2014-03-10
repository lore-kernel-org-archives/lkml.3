Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393AbaCJQD4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 12:03:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53933 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854AbaCJQCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 12:02:35 -0400
Message-Id: <20140310155543.428990961@infradead.org>
User-Agent: quilt/0.60-1
Date: Mon, 10 Mar 2014 16:42:37 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <waiman.long@hp.com>
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        akpm@linux-foundation.org, walken@google.com, andi@firstfloor.org,
        riel@redhat.com, paulmck@linux.vnet.ibm.com,
        torvalds@linux-foundation.org, oleg@redhat.com,
        Waiman Long <Waiman.Long@hp.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [RFC][PATCH 1/7] qspinlock: Introducing a 4-byte queue spinlock implementation
References: <20140310154236.038181843@infradead.org>
Content-Disposition: inline; filename=waiman_long-qspinlock-introducing_a_4-byte_queue_spinlock_implementation.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simple 4 byte MCS like spinlock implementation.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 include/asm-generic/qspinlock.h       |  113 +++++++++++++++++++
 include/asm-generic/qspinlock_types.h |   59 ++++++++++
 kernel/Kconfig.locks                  |    7 +
 kernel/locking/Makefile               |    1 
 kernel/locking/mcs_spinlock.h         |    1 
 kernel/locking/qspinlock.c            |  196 ++++++++++++++++++++++++++++++++++
 6 files changed, 377 insertions(+)
 create mode 100644 include/asm-generic/qspinlock.h
 create mode 100644 include/asm-generic/qspinlock_types.h
 create mode 100644 kernel/locking/qspinlock.c

--- /dev/null
+++ b/include/asm-generic/qspinlock.h
@@ -0,0 +1,113 @@
+/*
+ * Queue spinlock
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
+ * (C) Copyright 2013-2014 Hewlett-Packard Development Company, L.P.
+ *
+ * Authors: Waiman Long <waiman.long@hp.com>
+ */
+#ifndef __ASM_GENERIC_QSPINLOCK_H
+#define __ASM_GENERIC_QSPINLOCK_H
+
+#include <asm-generic/qspinlock_types.h>
+
+/**
+ * queue_spin_is_locked - is the spinlock locked?
+ * @lock: Pointer to queue spinlock structure
+ * Return: 1 if it is locked, 0 otherwise
+ */
+static __always_inline int queue_spin_is_locked(struct qspinlock *lock)
+{
+	return atomic_read(&lock->val) & _Q_LOCKED_VAL;
+}
+
+/**
+ * queue_spin_value_unlocked - is the spinlock structure unlocked?
+ * @lock: queue spinlock structure
+ * Return: 1 if it is unlocked, 0 otherwise
+ */
+static __always_inline int queue_spin_value_unlocked(struct qspinlock lock)
+{
+	return !(atomic_read(&lock.val) & _Q_LOCKED_VAL);
+}
+
+/**
+ * queue_spin_is_contended - check if the lock is contended
+ * @lock : Pointer to queue spinlock structure
+ * Return: 1 if lock contended, 0 otherwise
+ */
+static __always_inline int queue_spin_is_contended(struct qspinlock *lock)
+{
+	return atomic_read(&lock->val) & ~_Q_LOCKED_MASK;
+}
+/**
+ * queue_spin_trylock - try to acquire the queue spinlock
+ * @lock : Pointer to queue spinlock structure
+ * Return: 1 if lock acquired, 0 if failed
+ */
+static __always_inline int queue_spin_trylock(struct qspinlock *lock)
+{
+	if (!atomic_read(&lock->val) &&
+	   (atomic_cmpxchg(&lock->val, 0, _Q_LOCKED_VAL) == 0))
+		return 1;
+	return 0;
+}
+
+extern void queue_spin_lock_slowpath(struct qspinlock *lock, u32 val);
+
+/**
+ * queue_spin_lock - acquire a queue spinlock
+ * @lock: Pointer to queue spinlock structure
+ */
+static __always_inline void queue_spin_lock(struct qspinlock *lock)
+{
+	u32 val;
+
+	val = atomic_cmpxchg(&lock->val, 0, _Q_LOCKED_VAL);
+	if (likely(val == 0))
+		return;
+	queue_spin_lock_slowpath(lock, val);
+}
+
+#ifndef queue_spin_unlock
+/**
+ * queue_spin_unlock - release a queue spinlock
+ * @lock : Pointer to queue spinlock structure
+ */
+static __always_inline void queue_spin_unlock(struct qspinlock *lock)
+{
+	/*
+	 * smp_mb__before_atomic() in order to guarantee release semantics
+	 */
+	smp_mb__before_atomic_dec();
+	atomic_sub(_QSPINLOCK_LOCKED, &lock->val);
+}
+#endif
+
+/*
+ * Initializier
+ */
+#define	__ARCH_SPIN_LOCK_UNLOCKED	{ ATOMIC_INIT(0) }
+
+/*
+ * Remapping spinlock architecture specific functions to the corresponding
+ * queue spinlock functions.
+ */
+#define arch_spin_is_locked(l)		queue_spin_is_locked(l)
+#define arch_spin_is_contended(l)	queue_spin_is_contended(l)
+#define arch_spin_value_unlocked(l)	queue_spin_value_unlocked(l)
+#define arch_spin_lock(l)		queue_spin_lock(l)
+#define arch_spin_trylock(l)		queue_spin_trylock(l)
+#define arch_spin_unlock(l)		queue_spin_unlock(l)
+#define arch_spin_lock_flags(l, f)	queue_spin_lock(l)
+
+#endif /* __ASM_GENERIC_QSPINLOCK_H */
--- /dev/null
+++ b/include/asm-generic/qspinlock_types.h
@@ -0,0 +1,59 @@
+/*
+ * Queue spinlock
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
+ * (C) Copyright 2013-2014 Hewlett-Packard Development Company, L.P.
+ *
+ * Authors: Waiman Long <waiman.long@hp.com>
+ */
+#ifndef __ASM_GENERIC_QSPINLOCK_TYPES_H
+#define __ASM_GENERIC_QSPINLOCK_TYPES_H
+
+/*
+ * Including atomic.h with PARAVIRT on will cause compilation errors because
+ * of recursive header file incluson via paravirt_types.h. A workaround is
+ * to include paravirt_types.h here.
+ */
+#ifdef CONFIG_PARAVIRT
+#include <asm/paravirt_types.h>
+#endif
+#include <linux/types.h>
+#include <linux/atomic.h>
+#include <linux/bug.h>
+
+typedef struct qspinlock {
+	atomic_t	val;
+} arch_spinlock_t;
+
+/*
+ * Bitfields in the atomic value:
+ *
+ *  0- 7: locked byte
+ *  8- 9: tail index
+ * 10-31: tail cpu (+1)
+ */
+
+#define _Q_LOCKED_OFFSET	0
+#define _Q_LOCKED_BITS		8
+#define _Q_LOCKED_MASK		(((1U << _Q_LOCKED_BITS) - 1) << _Q_LOCKED_OFFSET)
+
+#define _Q_TAIL_IDX_OFFSET	(_Q_LOCKED_OFFSET + _Q_LOCKED_BITS)
+#define _Q_TAIL_IDX_BITS	2
+#define _Q_TAIL_IDX_MASK	(((1U << _Q_TAIL_IDX_BITS) - 1) << _Q_TAIL_IDX_OFFSET)
+
+#define _Q_TAIL_CPU_OFFSET	(_Q_TAIL_IDX_OFFSET + _Q_TAIL_IDX_BITS)
+#define _Q_TAIL_CPU_BITS	(32 - _Q_TAIL_CPU_OFFSET)
+#define _Q_TAIL_CPU_MASK	(((1U << _Q_TAIL_CPU_BITS) - 1) << _Q_TAIL_CPU_OFFSET)
+
+#define _Q_LOCKED_VAL		(1U << _Q_LOCKED_OFFSET)
+
+#endif /* __ASM_GENERIC_QSPINLOCK_TYPES_H */
--- a/kernel/Kconfig.locks
+++ b/kernel/Kconfig.locks
@@ -224,6 +224,13 @@ config MUTEX_SPIN_ON_OWNER
 	def_bool y
 	depends on SMP && !DEBUG_MUTEXES
 
+config ARCH_USE_QUEUE_SPINLOCK
+	bool
+
+config QUEUE_SPINLOCK
+	def_bool y if ARCH_USE_QUEUE_SPINLOCK
+	depends on SMP && !PARAVIRT_SPINLOCKS
+
 config ARCH_USE_QUEUE_RWLOCK
 	bool
 
--- a/kernel/locking/Makefile
+++ b/kernel/locking/Makefile
@@ -15,6 +15,7 @@ obj-$(CONFIG_LOCKDEP) += lockdep_proc.o
 endif
 obj-$(CONFIG_SMP) += spinlock.o
 obj-$(CONFIG_PROVE_LOCKING) += spinlock.o
+obj-$(CONFIG_QUEUE_SPINLOCK) += qspinlock.o
 obj-$(CONFIG_RT_MUTEXES) += rtmutex.o
 obj-$(CONFIG_DEBUG_RT_MUTEXES) += rtmutex-debug.o
 obj-$(CONFIG_RT_MUTEX_TESTER) += rtmutex-tester.o
--- a/kernel/locking/mcs_spinlock.h
+++ b/kernel/locking/mcs_spinlock.h
@@ -17,6 +17,7 @@
 struct mcs_spinlock {
 	struct mcs_spinlock *next;
 	int locked; /* 1 if lock acquired */
+	int count;
 };
 
 #ifndef arch_mcs_spin_lock_contended
--- /dev/null
+++ b/kernel/locking/qspinlock.c
@@ -0,0 +1,196 @@
+/*
+ * Queue spinlock
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
+ * (C) Copyright 2013-2014 Hewlett-Packard Development Company, L.P.
+ *
+ * Authors: Waiman Long <waiman.long@hp.com>
+ *          Peter Zijlstra <pzijlstr@redhat.com>
+ */
+#include <linux/smp.h>
+#include <linux/bug.h>
+#include <linux/cpumask.h>
+#include <linux/percpu.h>
+#include <linux/hardirq.h>
+#include <linux/mutex.h>
+#include <asm/qspinlock.h>
+
+/*
+ * The basic principle of a queue-based spinlock can best be understood
+ * by studying a classic queue-based spinlock implementation called the
+ * MCS lock. The paper below provides a good description for this kind
+ * of lock.
+ *
+ * http://www.cise.ufl.edu/tr/DOC/REP-1992-71.pdf
+ *
+ * This queue spinlock implementation is based on the MCS lock, however to make
+ * it fit the 4 bytes we assume spinlock_t to be, and preserve its existing
+ * API, we must modify it some.
+ *
+ * In particular; where the traditional MCS lock consists of a tail pointer
+ * (8 bytes) and needs the next pointer (another 8 bytes) of its own node to
+ * unlock the next pending (next->locked), we compress both these: {tail,
+ * next->locked} into a single u32 value.
+ *
+ * Since a spinlock disables recursion of its own context and there is a limit
+ * to the contexts that can nest; namely: task, softirq, hardirq, nmi, we can
+ * encode the tail as and index indicating this context and a cpu number.
+ *
+ * We can further change the first spinner to spin on a bit in the lock word
+ * instead of its node; whereby avoiding the need to carry a node from lock to
+ * unlock, and preserving API.
+ */
+
+#include "mcs_spinlock.h"
+
+/*
+ * Per-CPU queue node structures; we can never have more than 4 nested
+ * contexts: task, softirq, hardirq, nmi.
+ *
+ * Exactly fits one cacheline.
+ */
+static DEFINE_PER_CPU_ALIGNED(struct mcs_spinlock, mcs_nodes[4]);
+
+/*
+ * We must be able to distinguish between no-tail and the tail at 0:0,
+ * therefore increment the cpu number by one.
+ */
+
+static inline u32 encode_tail(int cpu, int idx)
+{
+	u32 tail;
+
+	tail  = (cpu + 1) << _Q_TAIL_CPU_OFFSET;
+	tail |= idx << _Q_TAIL_IDX_OFFSET; /* assume < 4 */
+
+	return tail;
+}
+
+static inline struct mcs_spinlock *decode_tail(u32 tail)
+{
+	int cpu = (tail >> _Q_TAIL_CPU_OFFSET) - 1;
+	int idx = (tail >> _Q_TAIL_IDX_OFFSET) & _Q_TAIL_IDX_MASK;
+
+	return per_cpu_ptr(&mcs_nodes[idx], cpu);
+}
+
+/**
+ * queue_spin_lock_slowpath - acquire the queue spinlock
+ * @lock: Pointer to queue spinlock structure
+ * @val: Current value of the queue spinlock 32-bit word
+ *
+ *
+ *              fast      :    slow                                  :    unlock
+ *                        :                                          :
+ * uncontended  (0,0)   --:--> (0,1) --------------------------------:--> (*,0)
+ *                        :       | ^--------.                    /  :
+ *                        :       v           \                   |  :
+ * uncontended            :    (n,x) --+--> (n,0)                 |  :
+ *   queue                :       | ^--'                          |  :
+ *                        :       v                               |  :
+ * contended              :    (*,x) --+--> (*,0) -----> (*,1) ---'  :
+ *   queue                :         ^--'                             :
+ *
+ */
+void queue_spin_lock_slowpath(struct qspinlock *lock, u32 val)
+{
+	struct mcs_spinlock *prev, *next, *node;
+	u32 new, old, tail;
+	int idx;
+
+	BUILD_BUG_ON(CONFIG_NR_CPUS >= (1U << _Q_TAIL_CPU_BITS));
+
+	node = this_cpu_ptr(&mcs_nodes[0]);
+	idx = node->count++;
+	tail = encode_tail(smp_processor_id(), idx);
+
+	node += idx;
+	node->locked = 0;
+	node->next = NULL;
+
+	/*
+	 * trylock || xchg(lock, node)
+	 *
+	 * 0,0 -> 0,1 ; trylock
+	 * p,x -> n,x ; prev = xchg(lock, node)
+	 */
+	for (;;) {
+		new = _Q_LOCKED_VAL;
+		if (val)
+			new = tail | (val & _Q_LOCKED_MASK);
+
+		old = atomic_cmpxchg(&lock->val, val, new);
+		if (old == val)
+			break;
+
+		val = old;
+	}
+
+	/*
+	 * we won the trylock; forget about queueing.
+	 */
+	if (new == _Q_LOCKED_VAL)
+		goto release;
+
+	/*
+	 * if there was a previous node; link it and wait.
+	 */
+	if (old & ~_Q_LOCKED_MASK) {
+		prev = decode_tail(old);
+		ACCESS_ONCE(prev->next) = node;
+
+		arch_mcs_spin_lock_contended(&node->locked);
+	}
+
+	/*
+	 * we're at the head of the waitqueue, wait for the owner to go away.
+	 *
+	 * *,x -> *,0
+	 */
+	while ((val = atomic_read(&lock->val)) & _Q_LOCKED_MASK)
+		cpu_relax();
+
+	/*
+	 * claim the lock:
+	 *
+	 * n,0 -> 0,1 : lock, uncontended
+	 * *,0 -> *,1 : lock, contended
+	 */
+	for (;;) {
+		new = _Q_LOCKED_VAL;
+		if (val != tail)
+			new |= val;
+
+		old = atomic_cmpxchg(&lock->val, val, new);
+		if (old == val)
+			break;
+
+		val = old;
+	}
+
+	/*
+	 * contended path; wait for next, release.
+	 */
+	if (new != _Q_LOCKED_VAL) {
+		while (!(next = ACCESS_ONCE(node->next)))
+			arch_mutex_cpu_relax();
+
+		arch_mcs_spin_unlock_contended(&next->locked);
+	}
+
+release:
+	/*
+	 * release the node
+	 */
+	this_cpu_dec(mcs_nodes[0].count);
+}
+EXPORT_SYMBOL(queue_spin_lock_slowpath);


