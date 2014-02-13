Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830AbaBMQgK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 11:36:10 -0500
Received: from merlin.infradead.org ([205.233.59.134]:47474 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbaBMQgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 11:36:07 -0500
Date: Thu, 13 Feb 2014 17:35:46 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <waiman.long@hp.com>
Cc: linux-kernel@vger.kernel.org, Jason Low <jason.low2@hp.com>,
        mingo@kernel.org, paulmck@linux.vnet.ibm.com,
        torvalds@linux-foundation.org, tglx@linutronix.de, riel@redhat.com,
        akpm@linux-foundation.org, davidlohr@hp.com, hpa@zytor.com,
        andi@firstfloor.org, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com
Subject: Re: [PATCH 7/8] locking: Introduce qrwlock
Message-ID: <20140213163546.GF6835@laptop.programming.kicks-ass.net>
References: <20140210195820.834693028@infradead.org>
 <20140210203659.796912337@infradead.org>
 <52FA6941.4060102@hp.com>
 <52FA844B.7070003@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52FA844B.7070003@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 03:12:59PM -0500, Waiman Long wrote:
> Using the same locktest program to repetitively take a single rwlock with
> programmable number of threads and count their execution times. Each
> thread takes the lock 5M times on a 4-socket 40-core Westmere-EX
> system. I bound all the threads to different CPUs with the following
> 3 configurations:
> 
>  1) Both CPUs and lock are in the same node
>  2) CPUs and lock are in different nodes
>  3) Half of the CPUs are in same node as the lock & the other half
>     are remote

I can't find these configurations in the below numbers; esp the first is
interesting because most computers out there have no nodes.

> Two types of qrwlock are tested:
>  1) Use MCS lock
>  2) Use ticket lock

arch_spinlock_t; you forget that if you change that to an MCS style lock
this one goes along for free.

On that; I had a look at your qspinlock and got a massive head-ache so I
rewrote it. Aside from being very mess code it also suffered from a few
fairness issues in that it is possible (albeit highly unlikely) to steal
a lock instead of being properly queued; per your xchg() usage.

The below boots; but I've not done much else with it, so it will
probably explode in your face.

---
 arch/x86/Kconfig                      |    1 
 arch/x86/include/asm/spinlock.h       |    2 
 arch/x86/include/asm/spinlock_types.h |    4 
 b/arch/x86/include/asm/qspinlock.h    |   13 ++
 b/include/asm-generic/qspinlock.h     |  128 ++++++++++++++++++++++++
 b/kernel/locking/qspinlock.c          |  178 ++++++++++++++++++++++++++++++++++
 kernel/Kconfig.locks                  |    7 +
 kernel/locking/Makefile               |    1 
 kernel/locking/mcs_spinlock.h         |    1 
 9 files changed, 335 insertions(+)

--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -17,6 +17,7 @@ config X86_64
 	depends on 64BIT
 	select X86_DEV_DMA_OPS
 	select ARCH_USE_CMPXCHG_LOCKREF
+	select ARCH_USE_QUEUE_SPINLOCK
 
 ### Arch settings
 config X86
--- /dev/null
+++ b/arch/x86/include/asm/qspinlock.h
@@ -0,0 +1,13 @@
+#ifndef _ASM_X86_QSPINLOCK_H
+#define _ASM_X86_QSPINLOCK_H
+
+#if !defined(CONFIG_X86_OOSTORE) && !defined(CONFIG_X86_PPRO_FENCE)
+#define queue_spin_unlock queue_spin_unlock
+static __always_inline void queue_spin_unlock(struct qspinlock *lock)
+{
+	barrier();
+	ACCESS_ONCE(*(u8 *)&lock->val) = 0;
+}
+#endif
+
+#endif /* _ASM_X86_QSPINLOCK_H */
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -43,6 +43,7 @@
 extern struct static_key paravirt_ticketlocks_enabled;
 static __always_inline bool static_key_false(struct static_key *key);
 
+#ifndef CONFIG_QUEUE_SPINLOCK
 #ifdef CONFIG_PARAVIRT_SPINLOCKS
 
 static inline void __ticket_enter_slowpath(arch_spinlock_t *lock)
@@ -181,6 +182,7 @@ static __always_inline void arch_spin_lo
 {
 	arch_spin_lock(lock);
 }
+#endif /* !CONFIG_QUEUE_SPINLOCK */
 
 static inline void arch_spin_unlock_wait(arch_spinlock_t *lock)
 {
--- a/arch/x86/include/asm/spinlock_types.h
+++ b/arch/x86/include/asm/spinlock_types.h
@@ -11,6 +11,9 @@
 #define TICKET_SLOWPATH_FLAG	((__ticket_t)0)
 #endif
 
+#ifdef CONFIG_QUEUE_SPINLOCK
+#include <asm-generic/qspinlock.h>
+#else
 #if (CONFIG_NR_CPUS < (256 / __TICKET_LOCK_INC))
 typedef u8  __ticket_t;
 typedef u16 __ticketpair_t;
@@ -33,6 +36,7 @@ typedef struct arch_spinlock {
 } arch_spinlock_t;
 
 #define __ARCH_SPIN_LOCK_UNLOCKED	{ { 0 } }
+#endif /* CONFIG_QUEUE_SPINLOCK */
 
 #ifdef CONFIG_QUEUE_RWLOCK
 #include <asm/qrwlock.h>
--- /dev/null
+++ b/include/asm-generic/qspinlock.h
@@ -0,0 +1,128 @@
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
+#include <linux/types.h>
+#include <linux/atomic.h>
+#include <asm/cmpxchg.h>
+#include <asm/barrier.h>
+#include <asm/processor.h>
+#include <asm/byteorder.h>
+
+/*
+ * The queue spinlock data structure - a 32-bit word
+ * Bits 0-7 : Set if locked
+ * Bits 8-31: Queue code
+ */
+typedef struct qspinlock {
+	atomic_t	val;
+} arch_spinlock_t;
+
+#define _QSPINLOCK_LOCKED	1U
+#define _QLOCKED_MASK		0xffU
+#define	_QCODE_OFFSET		8
+
+#include <asm/qspinlock.h>
+
+/*
+ * External function declarations
+ */
+extern void queue_spin_lock_slowpath(struct qspinlock *lock);
+
+/**
+ * queue_spin_is_locked - is the spinlock locked?
+ * @lock: Pointer to queue spinlock structure
+ * Return: 1 if it is locked, 0 otherwise
+ */
+static __always_inline int queue_spin_is_locked(struct qspinlock *lock)
+{
+	return atomic_read(&lock->val) & _QLOCKED_MASK;
+}
+
+/**
+ * queue_spin_value_unlocked - is the spinlock structure unlocked?
+ * @lock: queue spinlock structure
+ * Return: 1 if it is unlocked, 0 otherwise
+ */
+static __always_inline int queue_spin_value_unlocked(struct qspinlock lock)
+{
+	return !queue_spin_is_locked(&lock);
+}
+
+/**
+ * queue_spin_is_contended - check if the lock is contended
+ * @lock : Pointer to queue spinlock structure
+ * Return: 1 if lock contended, 0 otherwise
+ */
+static __always_inline int queue_spin_is_contended(struct qspinlock *lock)
+{
+	return atomic_read(&lock->val) >> _QCODE_OFFSET;
+}
+/**
+ * queue_spin_trylock - try to acquire the queue spinlock
+ * @lock : Pointer to queue spinlock structure
+ * Return: 1 if lock acquired, 0 if failed
+ */
+static __always_inline int queue_spin_trylock(struct qspinlock *lock)
+{
+	return !atomic_read(&lock->val) &&
+	       atomic_cmpxchg(&lock->val, 0, _QSPINLOCK_LOCKED) == 0;
+}
+
+/**
+ * queue_spin_lock - acquire a queue spinlock
+ * @lock: Pointer to queue spinlock structure
+ */
+static __always_inline void queue_spin_lock(struct qspinlock *lock)
+{
+	if (likely(atomic_cmpxchg(&lock->val, 0, _QSPINLOCK_LOCKED) == 0))
+		return;
+	queue_spin_lock_slowpath(lock);
+}
+
+/**
+ * queue_spin_unlock - release a queue spinlock
+ * @lock : Pointer to queue spinlock structure
+ */
+#ifndef queue_spin_unlock
+static __always_inline void queue_spin_unlock(struct qspinlock *lock)
+{
+	smp_mb__before_atomic_dec();
+	atomic_sub(_QSPINLOCK_LOCKED, &lock->qlcode_a);
+}
+#endif
+
+/*
+ * Initializier
+ */
+#define	__ARCH_SPIN_LOCK_UNLOCKED	{ .val = ATOMIC_INIT(0), }
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
@@ -23,4 +23,5 @@ obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock
 obj-$(CONFIG_RWSEM_GENERIC_SPINLOCK) += rwsem-spinlock.o
 obj-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem-xadd.o
 obj-$(CONFIG_PERCPU_RWSEM) += percpu-rwsem.o
+obj-$(CONFIG_QUEUE_SPINLOCK) += qspinlock.o
 obj-$(CONFIG_QUEUE_RWLOCK) += qrwlock.o
--- a/kernel/locking/mcs_spinlock.h
+++ b/kernel/locking/mcs_spinlock.h
@@ -17,6 +17,7 @@
 struct mcs_spinlock {
 	struct mcs_spinlock *next;
 	int locked; /* 1 if lock acquired */
+	int count; /* see qspinlock.c */
 };
 
 #ifndef arch_mcs_spin_lock_contended
--- /dev/null
+++ b/kernel/locking/qspinlock.c
@@ -0,0 +1,178 @@
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
+#include <linux/smp.h>
+#include <linux/bug.h>
+#include <linux/cpumask.h>
+#include <linux/percpu.h>
+#include <linux/hardirq.h>
+#include <linux/mutex.h>
+#include <asm-generic/qspinlock.h>
+
+/*
+ * The basic principle of a queue-based spinlock can best be understood
+ * by studying a classic queue-based spinlock implementation called the
+ * MCS lock. The paper below provides a good description for this kind
+ * of lock.
+ *
+ * http://www.cise.ufl.edu/tr/DOC/REP-1992-71.pdf
+ *
+ * This queue spinlock implementation is based on the MCS lock with twists
+ * to make it fit the following constraints:
+ * 1. A max spinlock size of 4 bytes
+ * 2. Good fastpath performance
+ * 3. No change in the locking APIs
+ *
+ * The queue spinlock fastpath is as simple as it can get, all the heavy
+ * lifting is done in the lock slowpath. The main idea behind this queue
+ * spinlock implementation is to keep the spinlock size at 4 bytes while
+ * at the same time implement a queue structure to queue up the waiting
+ * lock spinners.
+ *
+ * Since preemption is disabled before getting the lock, a given CPU will
+ * only need to use one queue node structure in a non-interrupt context.
+ * A percpu queue node structure will be allocated for this purpose and the
+ * cpu number will be put into the queue spinlock structure to indicate the
+ * tail of the queue.
+ */
+
+#include "mcs_spinlock.h"
+
+/*
+ * Exactly fills one cacheline on 64bit.
+ */
+static DEFINE_PER_CPU_ALIGNED(struct mcs_spinlock, mcs_nodes[4]);
+
+/*
+ * The 24-bit queue node code is divided into the following 2 fields:
+ * Bits 0-1 : queue node index (4 nodes)
+ * Bits 2-23: CPU number + 1   (4M - 1 CPUs)
+ *
+ * A queue node code of 0 indicates that no one is waiting for the lock.
+ * As the value 0 cannot be used as a valid CPU number. We need to add
+ * 1 to it before putting it into the queue code.
+ */
+
+static inline u32 encode(int cpu, int idx)
+{
+	u32 code;
+
+        code  = (cpu + 1) << 10;
+	code |= idx << 8; /* assume < 4 */
+
+	return code;
+}
+
+static inline struct mcs_spinlock *decode(u32 code)
+{
+	int cpu = (code >> 10) - 1;
+	int idx = (code >> 8) & 0x3;
+
+	return per_cpu_ptr(&mcs_nodes[idx], cpu);
+}
+
+/**
+ * queue_spin_lock_slowpath - acquire the queue spinlock
+ * @lock: Pointer to queue spinlock structure
+ */
+void queue_spin_lock_slowpath(struct qspinlock *lock)
+{
+	struct mcs_spinlock *prev, *next, *node = this_cpu_ptr(mcs_nodes);
+	int idx = node->count++;
+	u32 val, new, old;
+
+	u32 code = encode(smp_processor_id(), idx);
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
+	val = atomic_read(&lock->val);
+	for (;;) {
+		new = _QSPINLOCK_LOCKED;
+		if (val)
+			new = code | (val & new);
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
+	if (new == _QSPINLOCK_LOCKED) {
+		this_cpu_dec(mcs_nodes[0].count);
+		return;
+	}
+
+	/*
+	 * if there was a previous node; link it and wait.
+	 */
+	if (old & ~_QSPINLOCK_LOCKED) {
+		prev = decode(old);
+		ACCESS_ONCE(prev->next) = node;
+
+		arch_mcs_spin_lock_contended(&node->locked);
+	}
+
+	/*
+	 * We're at the head of the waitqueue, wait for the owner to go away.
+	 */
+	while ((val = atomic_read(&lock->val)) & _QSPINLOCK_LOCKED)
+		arch_mutex_cpu_relax();
+
+	/*
+	 * n,0 -> 0,1 : lock, uncontended
+	 * x,0 -> x,1 : lock, contended
+	 */
+	for (;;) {
+		new = _QSPINLOCK_LOCKED;
+		if (val != code)
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
+	if (new != _QSPINLOCK_LOCKED) {
+		while (!(next = ACCESS_ONCE(node->next)))
+			arch_mutex_cpu_relax();
+
+		arch_mcs_spin_unlock_contended(&next->locked);
+	}
+
+	/*
+	 * release the node
+	 */
+	this_cpu_dec(mcs_nodes[0].count);
+}
+EXPORT_SYMBOL(queue_spin_lock_slowpath);
