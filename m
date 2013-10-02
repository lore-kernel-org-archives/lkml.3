Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab3JBOKc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 10:10:32 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:29163 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677Ab3JBOJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 10:09:44 -0400
From: Waiman Long <Waiman.Long@hp.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH v4 1/3] qrwlock: A queue read/write lock implementation
Date: Wed,  2 Oct 2013 10:09:04 -0400
Message-Id: <1380722946-30468-2-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1380722946-30468-1-git-send-email-Waiman.Long@hp.com>
References: <1380722946-30468-1-git-send-email-Waiman.Long@hp.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a new read/write lock implementation that put
waiting readers and writers into a queue instead of actively contending
the lock like the current read/write lock implementation. This will
improve performance in highly contended situation by reducing the
cache line bouncing effect.

The queue read/write lock (qrwlock) is mostly fair with respect to
the writers, even though there is still a slight chance of write
lock stealing.

Externally, there are two different types of readers - unfair (the
default) and fair. A unfair reader will try to steal read lock even
if a writer is waiting, whereas a fair reader will be waiting in
the queue under this circumstance.  These variants are chosen at
initialization time by using different initializers. The new *_fair()
initializers are added for selecting the use of fair reader.

Internally, there is a third type of readers which steal lock more
aggressively than the unfair reader. They simply increments the reader
count and wait until the writer releases the lock. The transition to
aggressive reader happens in the read lock slowpath when
1. In an interrupt context.
2. when a classic reader comes to the head of the wait queue.
3. When a fair reader comes to the head of the wait queue and sees
   the release of a write lock.

The fair queue rwlock is more deterministic in the sense that late
comers jumping ahead and stealing the lock is unlikely even though
there is still a very small chance for lock stealing to happen if
the readers or writers come at the right moment.  Other than that,
lock granting is done in a FIFO manner.  As a result, it is possible
to determine a maximum time period after which the waiting is over
and the lock can be acquired.

The queue read lock is safe to use in an interrupt context (softirq
or hardirq) as it will switch to become an aggressive reader in such
environment allowing recursive read lock. However, the fair readers
will not support recursive read lock in a non-interrupt environment
when a writer is waiting.

The only downside of queue rwlock is the size increase in the lock
structure by 4 bytes for 32-bit systems and by 12 bytes for 64-bit
systems.

This patch will replace the architecture specific implementation
of rwlock by this generic version of queue rwlock when the
ARCH_QUEUE_RWLOCK configuration parameter is set.

In term of single-thread performance (no contention), a 256K
lock/unlock loop was run on a 2.4GHz and 2.93Ghz Westmere x86-64
CPUs. The following table shows the average time (in ns) for a single
lock/unlock sequence (including the looping and timing overhead):

Lock Type		    2.4GHz	2.93GHz
---------		    ------	-------
Ticket spinlock		     14.9	 12.3
Read lock		     17.0	 13.5
Write lock		     17.0	 13.5
Queue read lock	     	     16.0	 13.5
Queue fair read lock	     16.0	 13.5
Queue write lock	      9.2	  7.8
Queue fair write lock	     17.5	 14.5

The queue read lock is slightly slower than the spinlock, but is
slightly faster than the read lock. The queue write lock, however,
is the fastest of all. It is almost twice as fast as the write lock
and about 1.5X of the spinlock. The queue fair write lock, on the
other hand, is slightly slower than the write lock.

With lock contention, the speed of each individual lock/unlock function
is less important than the amount of contention-induced delays.

To investigate the performance characteristics of the queue rwlock
compared with the regular rwlock, Ingo's anon_vmas patch that convert
rwsem to rwlock was applied to a 3.12-rc2 kernel. This kernel was
then tested under the following 4 conditions:

1) Plain 3.12-rc2
2) Ingo's patch
3) Ingo's patch + unfair qrwlock (default)
4) Ingo's patch + fair qrwlock

The jobs per minutes (JPM) results of the AIM7's high_systime workload
at 1500 users on a 8-socket 80-core DL980 (HT off) were:

Kernel	JPM	%Change from (1)
------	---	----------------
  1	148265		-
  2	238715	       +61%
  3	242048	       +63%
  4	234881	       +58%

The use of unfair qrwlock provides a small boost of 2%, while using
fair qrwlock leads to 3% decrease of performance. However, looking
at the perf profiles, we can clearly see that other bottlenecks were
constraining the performance improvement.

Perf profile of kernel (2):

  18.20%   reaim  [kernel.kallsyms]  [k] __write_lock_failed
   9.36%   reaim  [kernel.kallsyms]  [k] _raw_spin_lock_irqsave
   2.91%   reaim  [kernel.kallsyms]  [k] mspin_lock
   2.73%   reaim  [kernel.kallsyms]  [k] anon_vma_interval_tree_insert
   2.23%      ls  [kernel.kallsyms]  [k] _raw_spin_lock_irqsave
   1.29%   reaim  [kernel.kallsyms]  [k] __read_lock_failed
   1.21%    true  [kernel.kallsyms]  [k] _raw_spin_lock_irqsave
   1.14%   reaim  [kernel.kallsyms]  [k] zap_pte_range
   1.13%   reaim  [kernel.kallsyms]  [k] _raw_spin_lock
   1.04%   reaim  [kernel.kallsyms]  [k] mutex_spin_on_owner

Perf profile of kernel (3):

  10.57%   reaim  [kernel.kallsyms]  [k] _raw_spin_lock_irqsave
   7.98%   reaim  [kernel.kallsyms]  [k] queue_write_lock_slowpath
   5.83%   reaim  [kernel.kallsyms]  [k] mspin_lock
   2.86%      ls  [kernel.kallsyms]  [k] _raw_spin_lock_irqsave
   2.71%   reaim  [kernel.kallsyms]  [k] anon_vma_interval_tree_insert
   1.52%    true  [kernel.kallsyms]  [k] _raw_spin_lock_irqsave
   1.51%   reaim  [kernel.kallsyms]  [k] queue_read_lock_slowpath
   1.35%   reaim  [kernel.kallsyms]  [k] mutex_spin_on_owner
   1.12%   reaim  [kernel.kallsyms]  [k] zap_pte_range
   1.06%   reaim  [kernel.kallsyms]  [k] perf_event_aux_ctx
   1.01%   reaim  [kernel.kallsyms]  [k] perf_event_aux

Tim Chen also tested the qrwlock with Ingo's patch on a 4-socket
machine.  It was found the performance improvement of 11% was the
same with regular rwlock or queue rwlock.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 include/asm-generic/qrwlock.h |  256 +++++++++++++++++++++++++++++++++++++++++
 kernel/Kconfig.locks          |    7 +
 lib/Makefile                  |    1 +
 lib/qrwlock.c                 |  247 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 511 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-generic/qrwlock.h
 create mode 100644 lib/qrwlock.c

diff --git a/include/asm-generic/qrwlock.h b/include/asm-generic/qrwlock.h
new file mode 100644
index 0000000..e94c69c
--- /dev/null
+++ b/include/asm-generic/qrwlock.h
@@ -0,0 +1,256 @@
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
+ * (C) Copyright 2013 Hewlett-Packard Development Company, L.P.
+ *
+ * Authors: Waiman Long <waiman.long@hp.com>
+ */
+#ifndef __ASM_GENERIC_QRWLOCK_H
+#define __ASM_GENERIC_QRWLOCK_H
+
+#include <linux/types.h>
+#include <asm/bitops.h>
+#include <asm/cmpxchg.h>
+#include <asm/barrier.h>
+#include <asm/processor.h>
+#include <asm/byteorder.h>
+
+#if !defined(__LITTLE_ENDIAN) && !defined(__BIG_ENDIAN)
+#error "Missing either LITTLE_ENDIAN or BIG_ENDIAN definition."
+#endif
+
+#if (CONFIG_NR_CPUS < 65536)
+typedef u16 __nrcpu_t;
+typedef u32 __nrcpupair_t;
+#define	QRW_READER_BIAS	(1U << 16)
+#else
+typedef u32 __nrcpu_t;
+typedef u64 __nrcpupair_t;
+#define	QRW_READER_BIAS	(1UL << 32)
+#endif
+
+/*
+ * The queue read/write lock data structure
+ *
+ * Read lock stealing can only happen when there is at least one reader
+ * holding the read lock. When the fair flag is not set, it mimics the
+ * behavior of the regular rwlock at the expense that a perpetual stream
+ * of readers could starve a writer for a long period of time. That
+ * behavior, however, may be beneficial to a workload that is reader heavy
+ * with slow writers, and the writers can wait without undesirable consequence.
+ * This fair flag should only be set at initialization time.
+ *
+ * The layout of the structure is endian-sensitive to make sure that adding
+ * QRW_READER_BIAS to the rw field to increment the reader count won't
+ * disturb the writer and the fair fields.
+ */
+struct qrwnode {
+	struct qrwnode *next;
+	bool		wait;	/* Waiting flag */
+};
+
+typedef struct qrwlock {
+	union qrwcnts {
+		struct {
+#ifdef __LITTLE_ENDIAN
+			u8	  writer;	/* Writer state		*/
+			u8	  fair;		/* Fair rwlock flag	*/
+			__nrcpu_t readers;	/* # of active readers	*/
+#else
+			__nrcpu_t readers;	/* # of active readers	*/
+			u8	  fair;		/* Fair rwlock flag	*/
+			u8	  writer;	/* Writer state		*/
+#endif
+		};
+		__nrcpupair_t rw;		/* Reader/writer number pair */
+	} cnts;
+	struct qrwnode *waitq;			/* Tail of waiting queue */
+} arch_rwlock_t;
+
+/*
+ * Writer state values & mask
+ */
+#define	QW_WAITING	1			/* A writer is waiting	   */
+#define	QW_LOCKED	0xff			/* A writer holds the lock */
+#define QW_MASK_FAIR	((u8)~QW_WAITING)	/* Mask for fair reader    */
+#define QW_MASK_UNFAIR	((u8)~0)		/* Mask for unfair reader  */
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
+	union qrwcnts rwcnts;
+
+	rwcnts.rw = ACCESS_ONCE(lock->cnts.rw);
+	return !rwcnts.writer || (!rwcnts.fair && rwcnts.readers);
+}
+
+/**
+ * queue_write_can_lock- would write_trylock() succeed?
+ * @lock: Pointer to queue rwlock structure
+ */
+static inline int queue_write_can_lock(struct qrwlock *lock)
+{
+	union qrwcnts rwcnts;
+
+	rwcnts.rw = ACCESS_ONCE(lock->cnts.rw);
+	return !rwcnts.writer && !rwcnts.readers;
+}
+
+/**
+ * queue_read_trylock - try to acquire read lock of a queue rwlock
+ * @lock : Pointer to queue rwlock structure
+ * Return: 1 if lock acquired, 0 if failed
+ */
+static inline int queue_read_trylock(struct qrwlock *lock)
+{
+	union qrwcnts cnts;
+	u8 wmask;
+
+	cnts.rw = ACCESS_ONCE(lock->cnts.rw);
+	wmask   = cnts.fair ? QW_MASK_FAIR : QW_MASK_UNFAIR;
+	if (likely(!(cnts.writer & wmask))) {
+		cnts.rw = xadd(&lock->cnts.rw, QRW_READER_BIAS);
+		if (likely(!(cnts.writer & wmask)))
+			return 1;
+		/*
+		 * Restore correct reader count
+		 * It had been found that two nearly consecutive atomic
+		 * operations (xadd & add) can cause significant cacheline
+		 * contention. By inserting a pause between these two atomic
+		 * operations, it can significantly reduce unintended
+		 * contention.
+		 */
+		cpu_relax();
+		add_smp(&lock->cnts.readers, -1);
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
+	union qrwcnts old, new;
+
+	old.rw = ACCESS_ONCE(lock->cnts.rw);
+	if (likely(!old.writer && !old.readers)) {
+		new.rw = old.rw;
+		new.writer = QW_LOCKED;
+		if (likely(cmpxchg(&lock->cnts.rw, old.rw, new.rw) == old.rw))
+			return 1;
+	}
+	return 0;
+}
+/**
+ * queue_read_lock - acquire read lock of a queue rwlock
+ * @lock: Pointer to queue rwlock structure
+ */
+static inline void queue_read_lock(struct qrwlock *lock)
+{
+	union qrwcnts cnts;
+	u8 wmask;
+
+	cnts.rw = xadd(&lock->cnts.rw, QRW_READER_BIAS);
+	wmask   = cnts.fair ? QW_MASK_FAIR : QW_MASK_UNFAIR;
+	if (likely(!(cnts.writer & wmask)))
+		return;
+	/*
+	 * Slowpath will decrement the reader count, if necessary
+	 */
+	queue_read_lock_slowpath(lock);
+}
+
+/**
+ * queue_write_lock - acquire write lock of a queue rwlock
+ * @lock : Pointer to queue rwlock structure
+ */
+static inline void queue_write_lock(struct qrwlock *lock)
+{
+	union qrwcnts old;
+
+	/*
+	 * Optimize for the unfair lock case where the fair flag is 0.
+	 */
+	old.rw = cmpxchg(&lock->cnts.rw, 0, QW_LOCKED);
+	if (likely(old.rw == 0))
+		return;
+	if (likely(!old.writer && !old.readers)) {
+		union qrwcnts new;
+
+		new.rw = old.rw;
+		new.writer = QW_LOCKED;
+		if (likely(cmpxchg(&lock->cnts.rw, old.rw, new.rw) == old.rw))
+			return;
+	}
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
+	add_smp(&lock->cnts.readers, -1);
+}
+
+/**
+ * queue_write_unlock - release write lock of a queue rwlock
+ * @lock : Pointer to queue rwlock structure
+ */
+static inline void queue_write_unlock(struct qrwlock *lock)
+{
+	/*
+	 * Make sure that none of the critical section will be leaked out.
+	 */
+	smp_mb__before_clear_bit();
+	ACCESS_ONCE(lock->cnts.writer) = 0;
+	smp_mb__after_clear_bit();
+}
+
+/*
+ * Initializier
+ */
+#define	__ARCH_RW_LOCK_UNLOCKED	{ .cnts = { .rw = 0 }, .waitq = NULL }
+#define	__ARCH_RW_LOCK_UNLOCKED_FAIR	\
+	{ .cnts = { { .writer = 0, .fair = 1, .readers = 0 } }, .waitq = NULL }
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
diff --git a/kernel/Kconfig.locks b/kernel/Kconfig.locks
index d2b32ac..b665478 100644
--- a/kernel/Kconfig.locks
+++ b/kernel/Kconfig.locks
@@ -223,3 +223,10 @@ endif
 config MUTEX_SPIN_ON_OWNER
 	def_bool y
 	depends on SMP && !DEBUG_MUTEXES
+
+config ARCH_QUEUE_RWLOCK
+	bool
+
+config QUEUE_RWLOCK
+	def_bool y if ARCH_QUEUE_RWLOCK
+	depends on SMP
diff --git a/lib/Makefile b/lib/Makefile
index f3bb2cb..e3175db 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -189,3 +189,4 @@ quiet_cmd_build_OID_registry = GEN     $@
 clean-files	+= oid_registry_data.c
 
 obj-$(CONFIG_UCS2_STRING) += ucs2_string.o
+obj-$(CONFIG_QUEUE_RWLOCK) += qrwlock.o
diff --git a/lib/qrwlock.c b/lib/qrwlock.c
new file mode 100644
index 0000000..a85b9e1
--- /dev/null
+++ b/lib/qrwlock.c
@@ -0,0 +1,247 @@
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
+ * (C) Copyright 2013 Hewlett-Packard Development Company, L.P.
+ *
+ * Authors: Waiman Long <waiman.long@hp.com>
+ */
+#include <linux/smp.h>
+#include <linux/bug.h>
+#include <linux/cpumask.h>
+#include <linux/percpu.h>
+#include <linux/hardirq.h>
+#include <asm-generic/qrwlock.h>
+
+/*
+ * Compared with regular rwlock, the queue rwlock has has the following
+ * advantages:
+ * 1. It is more deterministic for the fair variant. Even though there is
+ *    a slight chance of stealing the lock if come at the right moment, the
+ *    granting of the lock is mostly in FIFO order. Even the default unfair
+ *    variant is fairer at least among the writers.
+ * 2. It is faster in high contention situation.
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
+ * wait_in_queue - Add to queue and wait until it is at the head
+ * @lock: Pointer to queue rwlock structure
+ * @node: Node pointer to be added to the queue
+ *
+ * The use of smp_wmb() is to make sure that the other CPUs see the change
+ * ASAP.
+ */
+static __always_inline void
+wait_in_queue(struct qrwlock *lock, struct qrwnode *node)
+{
+	struct qrwnode *prev;
+
+	node->next = NULL;
+	node->wait = true;
+	prev = xchg(&lock->waitq, node);
+	if (prev) {
+		prev->next = node;
+		smp_wmb();
+		/*
+		 * Wait until the waiting flag is off
+		 */
+		while (ACCESS_ONCE(node->wait))
+			cpu_relax();
+	}
+}
+
+/**
+ * signal_next - Signal the next one in queue to be at the head
+ * @lock: Pointer to queue rwlock structure
+ * @node: Node pointer to the current head of queue
+ */
+static __always_inline void
+signal_next(struct qrwlock *lock, struct qrwnode *node)
+{
+	struct qrwnode *next;
+
+	/*
+	 * Try to notify the next node first without disturbing the cacheline
+	 * of the lock. If that fails, check to see if it is the last node
+	 * and so should clear the wait queue.
+	 */
+	next = ACCESS_ONCE(node->next);
+	if (likely(next))
+		goto notify_next;
+
+	/*
+	 * Clear the wait queue if it is the last node
+	 */
+	if ((ACCESS_ONCE(lock->waitq) == node) &&
+	    (cmpxchg(&lock->waitq, node, NULL) == node))
+			return;
+	/*
+	 * Wait until the next one in queue set up the next field
+	 */
+	while (likely(!(next = ACCESS_ONCE(node->next))))
+		cpu_relax();
+	/*
+	 * The next one in queue is now at the head
+	 */
+notify_next:
+	barrier();
+	ACCESS_ONCE(next->wait) = false;
+	smp_wmb();
+}
+
+/**
+ * rspin_until_writer_unlock - inc reader count & spin until writer is gone
+ * @lock: Pointer to queue rwlock structure
+ *
+ * In interrupt context or at the head of the queue, the reader will just
+ * increment the reader count & wait until the writer releases the lock.
+ */
+static __always_inline void
+rspin_until_writer_unlock(struct qrwlock *lock, int inc)
+{
+	union qrwcnts cnts;
+
+	if (inc)
+		cnts.rw = xadd(&lock->cnts.rw, QRW_READER_BIAS);
+	else
+		cnts.rw = ACCESS_ONCE(lock->cnts.rw);
+	while (cnts.writer == QW_LOCKED) {
+		cpu_relax();
+		cnts.rw = ACCESS_ONCE(lock->cnts.rw);
+	}
+}
+
+/**
+ * queue_read_lock_slowpath - acquire read lock of a queue rwlock
+ * @lock: Pointer to queue rwlock structure
+ */
+void queue_read_lock_slowpath(struct qrwlock *lock)
+{
+	struct qrwnode node;
+	union qrwcnts cnts;
+
+	/*
+	 * Readers come here when it cannot get the lock without waiting
+	 */
+	if (unlikely(irq_count())) {
+		/*
+		 * Readers in interrupt context will spin until the lock is
+		 * available without waiting in the queue.
+		 */
+		rspin_until_writer_unlock(lock, 0);
+		return;
+	}
+	cnts.rw = xadd(&lock->cnts.rw, -QRW_READER_BIAS);
+
+	/*
+	 * Put the reader into the wait queue
+	 */
+	wait_in_queue(lock, &node);
+
+	/*
+	 * At the head of the wait queue now, try to increment the reader
+	 * count and get the lock.
+	 */
+	if (unlikely(cnts.fair)) {
+		/*
+		 * For fair reader, wait until the writer state goes to 0
+		 * before incrementing the reader count.
+		 */
+		while (ACCESS_ONCE(lock->cnts.writer))
+			cpu_relax();
+	}
+	rspin_until_writer_unlock(lock, 1);
+	signal_next(lock, &node);
+}
+EXPORT_SYMBOL(queue_read_lock_slowpath);
+
+/**
+ * queue_write_3step_lock - acquire write lock in 3 steps
+ * @lock : Pointer to queue rwlock structure
+ * Return: 1 if lock acquired, 0 otherwise
+ *
+ * Step 1 - Try to acquire the lock directly if no reader is present
+ * Step 2 - Set the waiting flag to notify readers that a writer is waiting
+ * Step 3 - When the readers field goes to 0, set the locked flag
+ *
+ * When not in fair mode, the readers actually ignore the second step.
+ * However, this is still necessary to force other writers to fall in line.
+ */
+static __always_inline int queue_write_3step_lock(struct qrwlock *lock)
+{
+	union qrwcnts old, new;
+
+	old.rw = ACCESS_ONCE(lock->cnts.rw);
+
+	/* Step 1 */
+	if (!old.writer & !old.readers) {
+		new.rw     = old.rw;
+		new.writer = QW_LOCKED;
+		if (likely(cmpxchg(&lock->cnts.rw, old.rw, new.rw) == old.rw))
+			return 1;
+	}
+
+	/* Step 2 */
+	if (old.writer || (cmpxchg(&lock->cnts.writer, 0, QW_WAITING) != 0))
+		return 0;
+
+	/* Step 3 */
+	while (true) {
+		cpu_relax();
+		old.rw = ACCESS_ONCE(lock->cnts.rw);
+		if (!old.readers) {
+			new.rw     = old.rw;
+			new.writer = QW_LOCKED;
+			if (likely(cmpxchg(&lock->cnts.rw, old.rw, new.rw)
+				== old.rw))
+				return 1;
+		}
+	}
+	/* Should never reach here */
+	return 0;
+}
+
+/**
+ * queue_write_lock_slowpath - acquire write lock of a queue rwlock
+ * @lock : Pointer to queue rwlock structure
+ */
+void queue_write_lock_slowpath(struct qrwlock *lock)
+{
+	struct qrwnode node;
+
+	/*
+	 * Put the writer into the wait queue
+	 */
+	wait_in_queue(lock, &node);
+
+	/*
+	 * At the head of the wait queue now, call queue_write_3step_lock()
+	 * to acquire the lock until it is done.
+	 */
+	while (!queue_write_3step_lock(lock))
+		cpu_relax();
+	signal_next(lock, &node);
+}
+EXPORT_SYMBOL(queue_write_lock_slowpath);
-- 
1.7.1

