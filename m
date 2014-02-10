Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643AbaBJUmY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 15:42:24 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35710 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935AbaBJUla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 15:41:30 -0500
Message-Id: <20140210203659.796912337@infradead.org>
User-Agent: quilt/0.60-1
Date: Mon, 10 Feb 2014 20:58:27 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Jason Low <jason.low2@hp.com>, Waiman Long <waiman.long@hp.com>,
        Peter Zijlstra <peterz@infradead.org>, mingo@kernel.org,
        paulmck@linux.vnet.ibm.com, torvalds@linux-foundation.org,
        tglx@linutronix.de, riel@redhat.com, akpm@linux-foundation.org,
        davidlohr@hp.com, hpa@zytor.com, andi@firstfloor.org, aswin@hp.com,
        scott.norton@hp.com, chegu_vinod@hp.com,
        Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH 7/8] locking: Introduce qrwlock
References: <20140210195820.834693028@infradead.org>
Content-Disposition: inline; filename=qrwlock1.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This rwlock uses the arch_spin_lock_t as a waitqueue, and assuming the
arch_spin_lock_t is a fair lock (ticket,mcs etc..) the resulting
rwlock is a fair lock.

It fits in the same 8 bytes as the regular rwlock_t by folding the
reader and writer count into a single integer, using the remaining 4
bytes for the arch_spinlock_t.

Architectures that can single-copy adress bytes can optimize
queue_write_unlock() with a 0 write to the LSB (the write count).

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
[peterz: near complete rewrite]
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 include/asm-generic/qrwlock.h       |  174 ++++++++++++++++++++++++++++++++++++
 include/asm-generic/qrwlock_types.h |   16 +++
 kernel/Kconfig.locks                |    7 +
 kernel/locking/Makefile             |    1 
 kernel/locking/qrwlock.c            |  133 +++++++++++++++++++++++++++
 5 files changed, 331 insertions(+)

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
+#define	__ARCH_RW_LOCK_UNLOCKED {		\
+	.cnts = ATOMIC_INIT(0),			\
+	.lock = __ARCH_SPIN_LOCK_UNLOCKED,	\
+}
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
@@ -0,0 +1,16 @@
+#ifndef __ASM_GENERIC_QRWLOCK_TYPES_H
+#define __ASM_GENERIC_QRWLOCK_TYPES_H
+
+#include <linux/atomic.h>
+#include <linux/spinlock_types.h>
+
+/*
+ * The queue read/write lock data structure
+ */
+
+struct qrwlock {
+	atomic_t		cnts;
+	arch_spinlock_t		lock;
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
@@ -0,0 +1,133 @@
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
+#include <asm/qrwlock.h>
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
+	arch_spin_lock(&lock->lock);
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
+	arch_spin_unlock(&lock->lock);
+}
+EXPORT_SYMBOL(queue_read_lock_slowpath);
+
+/**
+ * queue_write_lock_slowpath - acquire write lock of a queue rwlock
+ * @lock : Pointer to queue rwlock structure
+ */
+void queue_write_lock_slowpath(struct qrwlock *lock)
+{
+	u32 cnts;
+
+	/* Put the writer into the wait queue */
+	arch_spin_lock(&lock->lock);
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
+	arch_spin_unlock(&lock->lock);
+}
+EXPORT_SYMBOL(queue_write_lock_slowpath);


