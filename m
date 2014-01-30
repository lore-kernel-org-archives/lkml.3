Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410AbaA3PRt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 10:17:49 -0500
Received: from merlin.infradead.org ([205.233.59.134]:52691 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321AbaA3PRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 10:17:48 -0500
Date: Thu, 30 Jan 2014 16:17:15 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "Aswin Chandramouleeswaran\"" <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH v11 0/4] Introducing a queue read/write lock
 implementation
Message-ID: <20140130151715.GA5126@laptop.programming.kicks-ass.net>
References: <1390537731-45996-1-git-send-email-Waiman.Long@hp.com>
 <20140130130453.GB2936@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140130130453.GB2936@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 02:04:53PM +0100, Peter Zijlstra wrote:
> 
> So I took out that ugly union and rewrote the code to be mostly
> atomic_*(), gcc generates acceptable code and its smaller too.
> 
>     824       0       0     824     338 defconfig-build/kernel/locking/qrwlock.o
>     776       0       0     776     308 defconfig-build/kernel/locking/qrwlock.o
> 
> I don't think I wrecked it, but I've not actually tried it yet.

I did wreck it.. :-)

The below is still small and actually works.

---
 arch/x86/Kconfig                      |    1 
 arch/x86/include/asm/spinlock.h       |    2 
 arch/x86/include/asm/spinlock_types.h |    4 
 b/arch/x86/include/asm/qrwlock.h      |   18 +++
 b/include/asm-generic/qrwlock.h       |  174 ++++++++++++++++++++++++++++++++++
 b/include/asm-generic/qrwlock_types.h |   17 +++
 b/kernel/locking/qrwlock.c            |  157 ++++++++++++++++++++++++++++++
 kernel/Kconfig.locks                  |    7 +
 kernel/locking/Makefile               |    1 
 9 files changed, 381 insertions(+)

--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -119,6 +119,7 @@ config X86
 	select MODULES_USE_ELF_RELA if X86_64
 	select CLONE_BACKWARDS if X86_32
 	select ARCH_USE_BUILTIN_BSWAP
+	select ARCH_USE_QUEUE_RWLOCK
 	select OLD_SIGSUSPEND3 if X86_32 || IA32_EMULATION
 	select OLD_SIGACTION if X86_32
 	select COMPAT_OLD_SIGACTION if IA32_EMULATION
--- /dev/null
+++ b/arch/x86/include/asm/qrwlock.h
@@ -0,0 +1,18 @@
+#ifndef _ASM_X86_QRWLOCK_H
+#define _ASM_X86_QRWLOCK_H
+
+#include <asm-generic/qrwlock_types.h>
+
+#if !defined(CONFIG_X86_OOSTORE) && !defined(CONFIG_X86_PPRO_FENCE)
+#define queue_write_unlock queue_write_unlock
+static inline void queue_write_unlock(struct qrwlock *lock)
+{
+        barrier();
+        ACCESS_ONCE(*(u8 *)&lock->cnts) = 0;
+}
+#endif
+
+#include <asm-generic/qrwlock.h>
+
+#endif /* _ASM_X86_QRWLOCK_H */
+
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -188,6 +188,7 @@ static inline void arch_spin_unlock_wait
 		cpu_relax();
 }
 
+#ifndef CONFIG_QUEUE_RWLOCK
 /*
  * Read-write spinlocks, allowing multiple readers
  * but only one writer.
@@ -270,6 +271,7 @@ static inline void arch_write_unlock(arc
 	asm volatile(LOCK_PREFIX WRITE_LOCK_ADD(%1) "%0"
 		     : "+m" (rw->write) : "i" (RW_LOCK_BIAS) : "memory");
 }
+#endif /* CONFIG_QUEUE_RWLOCK */
 
 #define arch_read_lock_flags(lock, flags) arch_read_lock(lock)
 #define arch_write_lock_flags(lock, flags) arch_write_lock(lock)
--- a/arch/x86/include/asm/spinlock_types.h
+++ b/arch/x86/include/asm/spinlock_types.h
@@ -34,6 +34,10 @@ typedef struct arch_spinlock {
 
 #define __ARCH_SPIN_LOCK_UNLOCKED	{ { 0 } }
 
+#ifdef CONFIG_QUEUE_RWLOCK
+#include <asm/qrwlock.h>
+#else
 #include <asm/rwlock.h>
+#endif
 
 #endif /* _ASM_X86_SPINLOCK_TYPES_H */
--- /dev/null
+++ b/include/asm-generic/qrwlock.h
@@ -0,0 +1,174 @@
+/*
+ * Queue read/write lock
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
+#ifndef __ASM_GENERIC_QRWLOCK_H
+#define __ASM_GENERIC_QRWLOCK_H
+
+#include <linux/types.h>
+#include <linux/atomic.h>
+#include <asm/barrier.h>
+#include <asm/processor.h>
+
+#include <asm-generic/qrwlock_types.h>
+
+/*
+ * Writer states & reader shift and bias
+ */
+#define	_QW_WAITING	1		/* A writer is waiting	   */
+#define	_QW_LOCKED	0xff		/* A writer holds the lock */
+#define	_QW_WMASK	0xff		/* Writer mask		   */
+#define	_QR_SHIFT	8		/* Reader count shift	   */
+#define _QR_BIAS	(1U << _QR_SHIFT)
+
+/*
+ * External function declarations
+ */
+extern void queue_read_lock_slowpath(struct qrwlock *lock);
+extern void queue_write_lock_slowpath(struct qrwlock *lock);
+
+/**
+ * queue_read_can_lock- would read_trylock() succeed?
+ * @lock: Pointer to queue rwlock structure
+ */
+static inline int queue_read_can_lock(struct qrwlock *lock)
+{
+	return !(atomic_read(&lock->cnts) & _QW_WMASK);
+}
+
+/**
+ * queue_write_can_lock- would write_trylock() succeed?
+ * @lock: Pointer to queue rwlock structure
+ */
+static inline int queue_write_can_lock(struct qrwlock *lock)
+{
+	return !atomic_read(&lock->cnts);
+}
+
+/**
+ * queue_read_trylock - try to acquire read lock of a queue rwlock
+ * @lock : Pointer to queue rwlock structure
+ * Return: 1 if lock acquired, 0 if failed
+ */
+static inline int queue_read_trylock(struct qrwlock *lock)
+{
+	u32 cnts;
+
+	cnts = atomic_read(&lock->cnts);
+	if (likely(!(cnts & _QW_WMASK))) {
+		cnts = (u32)atomic_add_return(_QR_BIAS, &lock->cnts);
+		if (likely(!(cnts & _QW_WMASK)))
+			return 1;
+		atomic_sub(_QR_BIAS, &lock->cnts);
+	}
+	return 0;
+}
+
+/**
+ * queue_write_trylock - try to acquire write lock of a queue rwlock
+ * @lock : Pointer to queue rwlock structure
+ * Return: 1 if lock acquired, 0 if failed
+ */
+static inline int queue_write_trylock(struct qrwlock *lock)
+{
+	u32 cnts;
+
+	cnts = atomic_read(&lock->cnts);
+	if (unlikely(cnts))
+		return 0;
+
+	return likely(atomic_cmpxchg(&lock->cnts,
+				     cnts, cnts | _QW_LOCKED) == cnts);
+}
+/**
+ * queue_read_lock - acquire read lock of a queue rwlock
+ * @lock: Pointer to queue rwlock structure
+ */
+static inline void queue_read_lock(struct qrwlock *lock)
+{
+	u32 cnts;
+
+	cnts = atomic_add_return(_QR_BIAS, &lock->cnts);
+	if (likely(!(cnts & _QW_WMASK)))
+		return;
+
+	/* The slowpath will decrement the reader count, if necessary. */
+	queue_read_lock_slowpath(lock);
+}
+
+/**
+ * queue_write_lock - acquire write lock of a queue rwlock
+ * @lock : Pointer to queue rwlock structure
+ */
+static inline void queue_write_lock(struct qrwlock *lock)
+{
+	/* Optimize for the unfair lock case where the fair flag is 0. */
+	if (atomic_cmpxchg(&lock->cnts, 0, _QW_LOCKED) == 0)
+		return;
+
+	queue_write_lock_slowpath(lock);
+}
+
+/**
+ * queue_read_unlock - release read lock of a queue rwlock
+ * @lock : Pointer to queue rwlock structure
+ */
+static inline void queue_read_unlock(struct qrwlock *lock)
+{
+	/*
+	 * Atomically decrement the reader count
+	 */
+	smp_mb__before_atomic_dec();
+	atomic_sub(_QR_BIAS, &lock->cnts);
+}
+
+#ifndef queue_write_unlock
+/**
+ * queue_write_unlock - release write lock of a queue rwlock
+ * @lock : Pointer to queue rwlock structure
+ */
+static inline void queue_write_unlock(struct qrwlock *lock)
+{
+	/*
+	 * If the writer field is atomic, it can be cleared directly.
+	 * Otherwise, an atomic subtraction will be used to clear it.
+	 */
+	smp_mb__before_atomic_dec();
+	atomic_sub(_QW_LOCKED, &lock->cnts);
+}
+#endif
+
+typedef struct qrwlock arch_rwlock_t;
+
+/*
+ * Initializier
+ */
+#define	__ARCH_RW_LOCK_UNLOCKED	{ .cnts = ATOMIC_INIT(0), .waitq = NULL, }
+
+/*
+ * Remapping rwlock architecture specific functions to the corresponding
+ * queue rwlock functions.
+ */
+#define arch_read_can_lock(l)	queue_read_can_lock(l)
+#define arch_write_can_lock(l)	queue_write_can_lock(l)
+#define arch_read_lock(l)	queue_read_lock(l)
+#define arch_write_lock(l)	queue_write_lock(l)
+#define arch_read_trylock(l)	queue_read_trylock(l)
+#define arch_write_trylock(l)	queue_write_trylock(l)
+#define arch_read_unlock(l)	queue_read_unlock(l)
+#define arch_write_unlock(l)	queue_write_unlock(l)
+
+#endif /* __ASM_GENERIC_QRWLOCK_H */
--- /dev/null
+++ b/include/asm-generic/qrwlock_types.h
@@ -0,0 +1,17 @@
+#ifndef __ASM_GENERIC_QRWLOCK_TYPES_H
+#define __ASM_GENERIC_QRWLOCK_TYPES_H
+
+#include <linux/atomic.h>
+
+struct mcs_spinlock;
+
+/*
+ * The queue read/write lock data structure
+ */
+
+struct qrwlock {
+	atomic_t		cnts;
+	struct mcs_spinlock	*waitq;
+};
+
+#endif /* __ASM_GENERIC_QRWLOCK_TYPES_H */
--- a/kernel/Kconfig.locks
+++ b/kernel/Kconfig.locks
@@ -223,3 +223,10 @@ endif
 config MUTEX_SPIN_ON_OWNER
 	def_bool y
 	depends on SMP && !DEBUG_MUTEXES
+
+config ARCH_USE_QUEUE_RWLOCK
+	bool
+
+config QUEUE_RWLOCK
+	def_bool y if ARCH_USE_QUEUE_RWLOCK
+	depends on SMP
--- a/kernel/locking/Makefile
+++ b/kernel/locking/Makefile
@@ -23,3 +23,4 @@ obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock
 obj-$(CONFIG_RWSEM_GENERIC_SPINLOCK) += rwsem-spinlock.o
 obj-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem-xadd.o
 obj-$(CONFIG_PERCPU_RWSEM) += percpu-rwsem.o
+obj-$(CONFIG_QUEUE_RWLOCK) += qrwlock.o
--- /dev/null
+++ b/kernel/locking/qrwlock.c
@@ -0,0 +1,157 @@
+/*
+ * Queue read/write lock
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
+#include <linux/mcs_spinlock.h>
+#include <asm/qrwlock.h>
+
+/*
+ * Compared with regular rwlock, the queue rwlock has has the following
+ * advantages:
+ * 1. Even though there is a slight chance of stealing the lock if come at
+ *    the right moment, the granting of the lock is mostly in FIFO order.
+ * 2. It is usually faster in high contention situation.
+ *
+ * The only downside is that the lock is 4 bytes larger in 32-bit systems
+ * and 12 bytes larger in 64-bit systems.
+ *
+ * There are two queues for writers. The writer field of the lock is a
+ * one-slot wait queue. The writers that follow will have to wait in the
+ * combined reader/writer queue (waitq).
+ *
+ * Compared with x86 ticket spinlock, the queue rwlock is faster in high
+ * contention situation. The writer lock is also faster in single thread
+ * operations. Therefore, queue rwlock can be considered as a replacement
+ * for those spinlocks that are highly contended as long as an increase
+ * in lock size is not an issue.
+ */
+
+/**
+ * rspin_until_writer_unlock - inc reader count & spin until writer is gone
+ * @lock  : Pointer to queue rwlock structure
+ * @writer: Current queue rwlock writer status byte
+ *
+ * In interrupt context or at the head of the queue, the reader will just
+ * increment the reader count & wait until the writer releases the lock.
+ */
+static __always_inline void
+rspin_until_writer_unlock(struct qrwlock *lock, u32 cnts)
+{
+	while ((cnts & _QW_WMASK) == _QW_LOCKED) {
+		arch_mutex_cpu_relax();
+		cnts = smp_load_acquire((u32 *)&lock->cnts);
+	}
+}
+
+/**
+ * queue_read_lock_slowpath - acquire read lock of a queue rwlock
+ * @lock: Pointer to queue rwlock structure
+ */
+void queue_read_lock_slowpath(struct qrwlock *lock)
+{
+	struct mcs_spinlock node;
+	u32 cnts;
+
+	/*
+	 * Readers come here when they cannot get the lock without waiting
+	 */
+	if (unlikely(in_interrupt())) {
+		/*
+		 * Readers in interrupt context will spin until the lock is
+		 * available without waiting in the queue.
+		 */
+		cnts = smp_load_acquire((u32 *)&lock->cnts);
+		rspin_until_writer_unlock(lock, cnts);
+		return;
+	}
+	atomic_sub(_QR_BIAS, &lock->cnts);
+
+	/*
+	 * Put the reader into the wait queue
+	 */
+	mcs_spin_lock(&lock->waitq, &node);
+
+	/*
+	 * At the head of the wait queue now, wait until the writer state
+	 * goes to 0 and then try to increment the reader count and get
+	 * the lock. It is possible that an incoming writer may steal the
+	 * lock in the interim, so it is necessary to check the writer byte
+	 * to make sure that the write lock isn't taken.
+	 */
+	while (atomic_read(&lock->cnts) & _QW_WMASK)
+		arch_mutex_cpu_relax();
+
+	cnts = atomic_add_return(_QR_BIAS, &lock->cnts) - _QR_BIAS;
+	rspin_until_writer_unlock(lock, cnts);
+
+	/*
+	 * Signal the next one in queue to become queue head
+	 */
+	mcs_spin_unlock(&lock->waitq, &node);
+}
+EXPORT_SYMBOL(queue_read_lock_slowpath);
+
+/**
+ * queue_write_lock_slowpath - acquire write lock of a queue rwlock
+ * @lock : Pointer to queue rwlock structure
+ */
+void queue_write_lock_slowpath(struct qrwlock *lock)
+{
+	struct mcs_spinlock node;
+	u32 cnts;
+
+	/* Put the writer into the wait queue */
+	mcs_spin_lock(&lock->waitq, &node);
+
+	/* Try to acquire the lock directly if no reader is present */
+	if (!atomic_read(&lock->cnts) &&
+	    (atomic_cmpxchg(&lock->cnts, 0, _QW_LOCKED) == 0))
+		goto unlock;
+
+	/*
+	 * Set the waiting flag to notify readers that a writer is pending,
+	 * or wait for a previous writer to go away.
+	 */
+	for (;;) {
+		cnts = atomic_read(&lock->cnts);
+		if (!(cnts & _QW_WMASK) &&
+		    (atomic_cmpxchg(&lock->cnts, cnts,
+				    cnts | _QW_WAITING) == cnts))
+			break;
+
+		arch_mutex_cpu_relax();
+	}
+
+	/* When no more readers, set the locked flag */
+	for (;;) {
+		cnts = atomic_read(&lock->cnts);
+		if ((cnts == _QW_WAITING) &&
+		    (atomic_cmpxchg(&lock->cnts, _QW_WAITING,
+				    _QW_LOCKED) == _QW_WAITING))
+			break;
+
+		arch_mutex_cpu_relax();
+	}
+unlock:
+	mcs_spin_unlock(&lock->waitq, &node);
+}
+EXPORT_SYMBOL(queue_write_lock_slowpath);
