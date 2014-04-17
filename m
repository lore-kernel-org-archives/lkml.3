Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018AbaDQPFG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 11:05:06 -0400
Received: from g5t1627.atlanta.hp.com ([15.192.137.10]:43360 "EHLO
	g5t1627.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbaDQPEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 11:04:42 -0400
From: Waiman Long <Waiman.Long@hp.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-arch@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>,
        Waiman Long <Waiman.Long@hp.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH v9 01/19] qspinlock: A simple generic 4-byte queue spinlock
Date: Thu, 17 Apr 2014 11:03:53 -0400
Message-Id: <1397747051-15401-2-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1397747051-15401-1-git-send-email-Waiman.Long@hp.com>
References: <1397747051-15401-1-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a new generic queue spinlock implementation that
can serve as an alternative to the default ticket spinlock. Compared
with the ticket spinlock, this queue spinlock should be almost as fair
as the ticket spinlock. It has about the same speed in single-thread
and it can be much faster in high contention situations especially when
the spinlock is embedded within the data structure to be protected.

Only in light to moderate contention where the average queue depth
is around 1-3 will this queue spinlock be potentially a bit slower
due to the higher slowpath overhead.

This queue spinlock is especially suit to NUMA machines with a large
number of cores as the chance of spinlock contention is much higher
in those machines. The cost of contention is also higher because of
slower inter-node memory traffic.

Due to the fact that spinlocks are acquired with preemption disabled,
the process will not be migrated to another CPU while it is trying
to get a spinlock. Ignoring interrupt handling, a CPU can only be
contending in one spinlock at any one time. Counting soft IRQ, hard
IRQ and NMI, a CPU can only have a maximum of 4 concurrent lock waiting
activities.  By allocating a set of per-cpu queue nodes and used them
to form a waiting queue, we can encode the queue node address into a
much smaller 24-bit size (including CPU number and queue node index)
leaving one byte for the lock.

Please note that the queue node is only needed when waiting for the
lock. Once the lock is acquired, the queue node can be released to
be used later.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 include/asm-generic/qspinlock.h       |  118 ++++++++++++++++++++
 include/asm-generic/qspinlock_types.h |   61 ++++++++++
 kernel/Kconfig.locks                  |    7 +
 kernel/locking/Makefile               |    1 +
 kernel/locking/mcs_spinlock.h         |    1 +
 kernel/locking/qspinlock.c            |  197 +++++++++++++++++++++++++++++++++
 6 files changed, 385 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-generic/qspinlock.h
 create mode 100644 include/asm-generic/qspinlock_types.h
 create mode 100644 kernel/locking/qspinlock.c

diff --git a/include/asm-generic/qspinlock.h b/include/asm-generic/qspinlock.h
new file mode 100644
index 0000000..e8a7ae8
--- /dev/null
+++ b/include/asm-generic/qspinlock.h
@@ -0,0 +1,118 @@
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
+	return atomic_read(&lock->val);
+}
+
+/**
+ * queue_spin_value_unlocked - is the spinlock structure unlocked?
+ * @lock: queue spinlock structure
+ * Return: 1 if it is unlocked, 0 otherwise
+ *
+ * N.B. Whenever there are tasks waiting for the lock, it is considered
+ *      locked wrt the lockref code to avoid lock stealing by the lockref
+ *      code and change things underneath the lock. This also allows some
+ *      optimizations to be applied without conflict with lockref.
+ */
+static __always_inline int queue_spin_value_unlocked(struct qspinlock lock)
+{
+	return !atomic_read(&lock.val);
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
+	atomic_sub(_Q_LOCKED_VAL, &lock->val);
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
diff --git a/include/asm-generic/qspinlock_types.h b/include/asm-generic/qspinlock_types.h
new file mode 100644
index 0000000..f66f845
--- /dev/null
+++ b/include/asm-generic/qspinlock_types.h
@@ -0,0 +1,61 @@
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
+#else
+#include <linux/types.h>
+#include <linux/atomic.h>
+#include <linux/bug.h>
+#endif
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
+#define	_Q_SET_MASK(type)	(((1U << _Q_ ## type ## _BITS) - 1)\
+				      << _Q_ ## type ## _OFFSET)
+#define _Q_LOCKED_OFFSET	0
+#define _Q_LOCKED_BITS		8
+#define _Q_LOCKED_MASK		_Q_SET_MASK(LOCKED)
+
+#define _Q_TAIL_IDX_OFFSET	(_Q_LOCKED_OFFSET + _Q_LOCKED_BITS)
+#define _Q_TAIL_IDX_BITS	2
+#define _Q_TAIL_IDX_MASK	_Q_SET_MASK(TAIL_IDX)
+
+#define _Q_TAIL_CPU_OFFSET	(_Q_TAIL_IDX_OFFSET + _Q_TAIL_IDX_BITS)
+#define _Q_TAIL_CPU_BITS	(32 - _Q_TAIL_CPU_OFFSET)
+#define _Q_TAIL_CPU_MASK	_Q_SET_MASK(TAIL_CPU)
+
+#define _Q_LOCKED_VAL		(1U << _Q_LOCKED_OFFSET)
+
+#endif /* __ASM_GENERIC_QSPINLOCK_TYPES_H */
diff --git a/kernel/Kconfig.locks b/kernel/Kconfig.locks
index d2b32ac..f185584 100644
--- a/kernel/Kconfig.locks
+++ b/kernel/Kconfig.locks
@@ -223,3 +223,10 @@ endif
 config MUTEX_SPIN_ON_OWNER
 	def_bool y
 	depends on SMP && !DEBUG_MUTEXES
+
+config ARCH_USE_QUEUE_SPINLOCK
+	bool
+
+config QUEUE_SPINLOCK
+	def_bool y if ARCH_USE_QUEUE_SPINLOCK
+	depends on SMP && !PARAVIRT_SPINLOCKS
diff --git a/kernel/locking/Makefile b/kernel/locking/Makefile
index 306a76b..877bdd0 100644
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
diff --git a/kernel/locking/mcs_spinlock.h b/kernel/locking/mcs_spinlock.h
index a2dbac4..a59b677 100644
--- a/kernel/locking/mcs_spinlock.h
+++ b/kernel/locking/mcs_spinlock.h
@@ -17,6 +17,7 @@
 struct mcs_spinlock {
 	struct mcs_spinlock *next;
 	int locked; /* 1 if lock acquired */
+	int count;
 };
 
 #ifndef arch_mcs_spin_lock_contended
diff --git a/kernel/locking/qspinlock.c b/kernel/locking/qspinlock.c
new file mode 100644
index 0000000..b97a1ad
--- /dev/null
+++ b/kernel/locking/qspinlock.c
@@ -0,0 +1,197 @@
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
+	int idx = (tail &  _Q_TAIL_IDX_MASK) >> _Q_TAIL_IDX_OFFSET;
+
+	return per_cpu_ptr(&mcs_nodes[idx], cpu);
+}
+
+/**
+ * queue_spin_lock_slowpath - acquire the queue spinlock
+ * @lock: Pointer to queue spinlock structure
+ * @val: Current value of the queue spinlock 32-bit word
+ *
+ * (queue tail, lock bit)
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
+		arch_mutex_cpu_relax();
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
-- 
1.7.1

