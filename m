Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827Ab3HAABd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 20:01:33 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:35853 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab3HAABa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 20:01:30 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Richard Weinberger <richard@nod.at>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Harvey Harrison <harvey.harrison@gmail.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH v3 1/3] qrwlock: A queue read/write lock implementation
Date: Wed, 31 Jul 2013 20:00:57 -0400
Message-Id: <1375315259-29392-2-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1375315259-29392-1-git-send-email-Waiman.Long@hp.com>
References: <1375315259-29392-1-git-send-email-Waiman.Long@hp.com>
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

Externally, there are two different types of readers - classic (with
lock stealing) and fair. A classic reader will try to steal read lock
even if a waiter is waiting, whereas a fair reader will be waiting
in the queue under this circumstance.  These variants are chosen at
initialization time by using different initializers. The new *_fair()
initializers are added for selecting the use of fair reader.

Internally, there is a third type of readers which steal lock more
aggressively than the classic reader. They simply increments the reader
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

This patch allows the optional replacement of architecture specific
implementation of rwlock by this generic version of queue
rwlock. Two new config parameters are introduced:

1. QUEUE_RWLOCK
   A select-able option that enables the building and replacement of
   architecture specific rwlock by queue rwlock.
2. ARCH_QUEUE_RWLOCK
   Have to be defined in arch/$(ARCH)/Kconfig to enable QUEUE_RWLOCK
   option. This option, by itself, will not enable the queue rwlock
   feature.

In term of single-thread performance (no contention), a 256K
lock/unlock loop was run on a 2.4GHz and 2.93Ghz Westmere x86-64
CPUs. The following table shows the average time (in ns) for a single
lock/unlock sequence (including the looping and timing overhead):

Lock Type		    2.4GHz	2.93GHz
---------		    ------	-------
Ticket spinlock		     14.9	 12.3
Read lock		     17.0	 13.5
Write lock		     17.2	 13.5
Queue fair read lock	     22.7	 18.9
Queue classic read lock	     22.7	 18.9
Queue write lock	     13.9	 11.7

While the queue read lock is about 1.5X the time of a spinlock,
the queue write lock is actually slight faster than that of the
spinlock. Comparing to the classic rwlock, the queue read lock is
about 40% slower while the queue write lock is about 15% faster.

With lock contention, the speed of each individual lock/unlock function
is less important than the amount of contention-induced delays.

To investigate the performance characteristics of the queue rwlock
compared with the regular rwlock, the fserver and new_fserver
benchmarks with ext4 filesystem of the AIM7 test suite were used on
a 8-socket x86-64 system with 80 cores. The rwlock in contention was
the j_state_lock of the journal_s structure in include/linux/jbd2.h.

The following kernels were used:
1) Vanilla 3.10.1
2) 3.10.1 with qrwlock patch (classic j_state_lock)
3) 3.10.1 with qrwlock patch (fair j_state_lock)
   (classic behavior - readers can steal lock from waiting writer)

The following table shows the averaged results in the 200-1000
user ranges:

+-----------------+-------+-------+-------+-------+-------+-------+
|  Kernel         |   1   |   2   |   3   |   1   |   2   |   3   |
|  HT		  |  on   |  on   |  on   |  off  |  off  |  off  |
+-----------------+-------+-------+-------+-------+-------+-------+
| fserver JPM     |283156 |380712 |350170 |454965 |458876 |454873 |
| % change from 1 |  0%   |+34.45 |+23.7% |  0%   | +0.9% |  0.0% |
+-----------------+-------+-------+-------+-------+-------+-------+
| new_fserver JPM |297755 |372344 |367125 |435349 |437807 |436019 |
| % change from 1 |  0%   |+25.1% |+23.3% |  0%   | +0.6% | +0.2% |
+-----------------+-------+-------+-------+-------+-------+-------+

The following table shows the averaged results in the 1100-2000
user ranges:

+-----------------+-------+-------+-------+-------+-------+-------+
|  Kernel         |   1   |   2   |   3   |   1   |   2   |   3   |
|  HT		  |  on   |  on   |  on   |  off  |  off  |  off  |
+-----------------+-------+-------+-------+-------+-------+-------+
| fserver JPM     |270601 |345438 |321303 |465237 |463540 |464991 |
| % change from 1 |  0%   |+27.6% |+18.8% |  0%   | -0.4% | -0.1% |
+-----------------+-------+-------+-------+-------+-------+-------+
| new-fserver JPM |262368 |329760 |305182 |446330 |449002 |446979 |
| % change from 1 |  0%   |+25.7% |+16.3% |  0%   | +0.6% | +0.2% |
+-----------------+-------+-------+-------+-------+-------+-------+

The following table show the amount of CPU time spent on the fastpaths
and slowpaths of the read and write lock for each of the different
kernels listed above as reported by perf with the new_fserver workload
at 1500 users:

+-----------------+-------+-------+-------+-------+-------+-------+
|  Kernel         |   1   |   2   |   3   |   1   |   2   |   3   |
|  HT             |  on   |  on   |  on   |  off  |  off  |  off  |
+-----------------+-------+-------+-------+-------+-------+-------+
| Read fastpath   | 0.88% | 0.19% | 0.16% | 0.22% | 0.24% | 0.22% |
| Read slowpath   | 13.6% | 12.4% | 21.3% | 0.13% | 0.51% | 0.05% |
| Write fastpath  | 0.10% | 0.01% | 0.01% | 0.01% | 0.01% | 0.01% |
| Write slowpath  | 11.1% | 0.08% | 0.18% | 0.05% | 0.00% | 0.00% |
+-----------------+-------+-------+-------+-------+-------+-------+

The small write slowpath numbers for queue rwlock indicates that it
is a reader heavy lock with writers probably holding the lock a lot
longer than the readers. The queue rwlock of both favors causes a
big reduction in the amount of time spent by the writers to get the
lock. Even though the readers need to wait longer in the HT on cases,
it is more than compensated by the reduction in writers' time.

To see how the queue write lock can be used as a replacement for ticket
spinlock (just like rwsem can be used as replacement of mutex), the
mb_cache_spinlock in fs/mbcache.c, which is a bottleneck in the disk
workload (ext4 FS) of the AIM7 benchmark, was converted to both a queue
write lock and a regular write lock.

The following kernels were used when running on a 8-socket 80-core
DL980 system:
1) Vanila 3.10.1
2) 3.10.1 with mb_cache_spinlock replaced by queue write lock
3) 3.10.1 with mb_cache_spinlock replaced by regular write lock

The following table shows the averaged JPM results for the disk
workload:

+----------+--------+--------+--------+--------+--------+--------+
|  Kernel  |    1   |    2   |    3   |    1   |    2   |    3   |
|  HT      |   off  |   off  |   off  |   on   |   on   |   on   |
+----------+--------+--------+--------+--------+--------+--------+
|          |               User Range 10 - 100                   |
+----------+--------+--------+--------+--------+--------+--------+
| disk JPM | 446609 | 564038 | 632162 | 459493 | 579103 | 648145 |
| % change |   0%   | +26.3% | +41.6% |   0%   | +26.0% | +41.1% |
+----------+--------+--------+--------+--------+--------+--------+
|          |              User Range 200 - 1000                  |
+----------+--------+--------+--------+--------+--------+--------+
| disk JPM | 224931 | 354538 | 398609 | 210096 | 334418 | 373342 |
| % change |   0%   | +57.6% | +77.2% |   0%   | +59.2% | +77.7% |
+----------+--------+--------+--------+--------+--------+--------+
|          |              User Range 1100 - 2000                 |
+----------+--------+--------+--------+--------+--------+--------+
| disk JPM | 216317 | 322053 | 345113 | 203974 | 296169 | 299036 |
| % change |   0%   | +50.7% | +61.5% |   0%   | +45.2% | +46.6% |
+----------+--------+--------+--------+--------+--------+--------+

The amount of time spent in mbcache lock contention as reported by perf
for the disk workload at 1000 users were listed in the following table.

+----------------+-------+-------+-------+-------+-------+-------+
|  Kernel        |   1   |   2   |   3   |   1   |   2   |   3   |
|    HT          |  off  |  off  |  off  |  on   |  on   |  on   |
+----------------+-------+-------+-------+-------+-------+-------+
| _raw_spin_lock | 75.9% |   -   |   -   | 72.0% |   -   |   -   |
| wlock fastpath |   -   | 0.08% | 0.56% |   -   | 0.06% | 0.44% |
| wlock slowpath |   -   | 70.8% | 61.6% |   -   | 68.5% | 56.2% |
+----------------+-------+-------+-------+-------+-------+-------+

The higher amount of time spent in the classic write lock fastpath
indicates a higher level contention at the lock level. Fortunately,
the lock is in a separate cacheline from the other data manipulated by
mbcache. Hence, its performance isn't affected that much by contention
in the lock. It seems like classic write lock can response to lock
availability most rapidly followed by queue write lock and then
spinlock.

The following table show the performance data for the same set of
kernels on a 2-socket 12-core system with HT on:

+----------+---------+---------+---------+
|  Kernel  |    1    |    2    |    3    |
|  HT      |    on   |    on   |    on   |
+----------+---------+---------+---------+
|          |    User Range 10 - 100      |
+----------+---------+---------+---------+
| disk JPM | 1805396 | 1800737 | 1834068 |
| % change |    0%   |  -0.3%  |  +1.6%  |
+----------+---------+---------+---------+
|          |    User Range 200 - 1000    |
+----------+---------+---------+---------+
| disk JPM | 2697514 | 2746543 | 2709771 |
| % change |    0%   |  +1.8%  |  +0.5%  |
+----------+---------+---------+---------+
|          |    User Range 1100 - 2000   |
+----------+---------+---------+---------+
| disk JPM | 2700273 | 2771454 | 2734525 |
| % change |    0%   |  +2.6%  |  +1.3%  |
+----------+---------+---------+---------+

Apparently, the regular write lock performs even better than the
queue write lock.  However, the queue write lock is quite fair, but
the regular write lock is not. So it is not a very good replacement
for ticket spinlock.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 include/asm-generic/qrwlock.h |  239 ++++++++++++++++++++++++++++++++++++++++
 lib/Kconfig                   |   23 ++++
 lib/Makefile                  |    1 +
 lib/qrwlock.c                 |  242 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 505 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-generic/qrwlock.h
 create mode 100644 lib/qrwlock.c

diff --git a/include/asm-generic/qrwlock.h b/include/asm-generic/qrwlock.h
new file mode 100644
index 0000000..4717bf7
--- /dev/null
+++ b/include/asm-generic/qrwlock.h
@@ -0,0 +1,239 @@
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
+ * It is also useful for rwlock that are used in the interrupt context where
+ * the fair version may cause deadlock if not use carefully. This fair flag
+ * should only be set at initialization time.
+ *
+ * The layout of the structure is endian-sensitive to make sure that adding
+ * QRW_READER_BIAS to the rw field to increment the reader count won't
+ * disturb the writer and the fair fields.
+ */
+#ifndef _QUEUE_RWLOCK_NOWAITQ
+struct qrwnode {
+	struct qrwnode *next;
+	bool		wait;	/* Waiting flag */
+};
+# define _DEFINE_QRWNODE(v)	struct qrwnode v
+# define _INIT_WAITQ		, .waitq = NULL
+#else
+# define _DEFINE_QRWNODE(v)
+# define _INIT_WAITQ
+#endif
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
+	_DEFINE_QRWNODE(*waitq);		/* Tail of waiting queue */
+} arch_rwlock_t;
+
+/*
+ * Writer state values & mask
+ */
+#define	QW_WAITING	1			/* A writer is waiting	   */
+#define	QW_LOCKED	0xff			/* A writer holds the lock */
+#define QW_MASK_FAIR	((u8)~QW_WAITING)	/* Mask for fair reader    */
+#define QW_MASK_CLASSIC	((u8)~0)		/* Mask for classic reader */
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
+	wmask  = cnts.fair ? QW_MASK_FAIR : QW_MASK_CLASSIC;
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
+	if (likely(queue_read_trylock(lock)))
+		return;
+	queue_read_lock_slowpath(lock);
+}
+
+/**
+ * queue_write_lock - acquire write lock of a queue rwlock
+ * @lock : Pointer to queue rwlock structure
+ */
+static inline void queue_write_lock(struct qrwlock *lock)
+{
+	if (likely(queue_write_trylock(lock)))
+		return;
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
+	barrier();
+	ACCESS_ONCE(lock->cnts.writer) = 0;
+	smp_wmb();
+}
+
+/*
+ * Initializier
+ */
+#define	__ARCH_RW_LOCK_UNLOCKED	{ .cnts = { .rw = 0 } _INIT_WAITQ }
+#define	__ARCH_RW_LOCK_UNLOCKED_FAIR	\
+	{ .cnts = { { .writer = 0, .fair = 1, .readers = 0 } } _INIT_WAITQ }
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
diff --git a/lib/Kconfig b/lib/Kconfig
index 35da513..5a219c3 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -412,6 +412,29 @@ config SIGNATURE
 	  Implementation is done using GnuPG MPI library
 
 #
+# Generic queue read/write lock
+#
+config QUEUE_RWLOCK
+	bool "Generic queue read/write lock"
+	depends on ARCH_QUEUE_RWLOCK
+	default n
+	help
+	  Use an alternative read/write lock (rwlock) implementation
+	  that is fairer and more optmized for larger NUMA systems.
+	  These locks use more memory, but is fairer to both readers
+	  and writers and perform better under high contention.
+	  Specifically, waiting readers and writers will be queued
+	  up and granted lock more or less in FIFO order rather than
+	  all spinning on the same cache line to compete for the lock.
+
+	  The kernel will operate correctly either way; this only
+	  affects performance and lock fairness.
+
+	  For common desktop and server systems systems with only one
+	  or two CPU sockets and small memory, the performance and
+	  lock fairness benefits may not worth the additional memory.
+
+#
 # libfdt files, only selected if needed.
 #
 config LIBFDT
diff --git a/lib/Makefile b/lib/Makefile
index 7baccfd..2888c17 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -187,3 +187,4 @@ quiet_cmd_build_OID_registry = GEN     $@
 clean-files	+= oid_registry_data.c
 
 obj-$(CONFIG_UCS2_STRING) += ucs2_string.o
+obj-$(CONFIG_QUEUE_RWLOCK) += qrwlock.o
diff --git a/lib/qrwlock.c b/lib/qrwlock.c
new file mode 100644
index 0000000..d0b34aa
--- /dev/null
+++ b/lib/qrwlock.c
@@ -0,0 +1,242 @@
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
+ *    granting of the lock is mostly in FIFO order. Even the classic variant
+ *    is fairer at least among the writers.
+ * 2. It is faster in high contention situation.
+ *
+ * The only downside is that the lock is 4 bytes larger in 32-bit systems
+ * and 12 bytes larger in 64-bit systems.
+ *
+ * There are two queues for writers. The writer state of the lock is a
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
+#ifdef _QUEUE_RWLOCK_NOWAITQ
+# define wait_in_queue(l, n)
+# define signal_next(l, n)
+#else
+/**
+ * wait_in_queue - Add to queue and wait until it is at the head
+ * @lock: Pointer to queue rwlock structure
+ * @node: Node pointer to be added to the queue
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
+	} else
+		node->wait = false;
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
+	ACCESS_ONCE(next->wait) = false;
+	smp_wmb();
+}
+#endif
+
+/**
+ * rspin_until_writer_unlock - inc reader count & spin until writer is gone
+ * @lock: Pointer to queue rwlock structure
+ *
+ * In interrupt context or at the head of the queue, the reader will just
+ * increment the reader count & wait until the writer releases the lock.
+ */
+static __always_inline void rspin_until_writer_unlock(struct qrwlock *lock)
+{
+	union qrwcnts cnts;
+
+	cnts.rw = xadd(&lock->cnts.rw, QRW_READER_BIAS);
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
+	_DEFINE_QRWNODE(node);
+
+	/*
+	 * Readers come here when it cannot get the lock without waiting
+	 */
+	if (unlikely(irq_count())) {
+		/*
+		 * Readers in interrupt context will spin until the lock is
+		 * available without waiting in the queue.
+		 */
+		rspin_until_writer_unlock(lock);
+		return;
+	}
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
+	if (unlikely(lock->cnts.fair)) {
+		/*
+		 * For fair reader, wait until the writer state goes to 0
+		 * before incrementing the reader count.
+		 */
+		while (ACCESS_ONCE(lock->cnts.writer))
+			cpu_relax();
+	}
+	rspin_until_writer_unlock(lock);
+	signal_next(lock, &node);
+}
+EXPORT_SYMBOL(queue_read_lock_slowpath);
+
+/**
+ * queue_write_2step_lock - acquire write lock in 2 steps
+ * @lock : Pointer to queue rwlock structure
+ * Return: 1 if lock acquired, 0 otherwise
+ *
+ * Step 1 - Set the waiting flag to notify readers that a writer is waiting
+ * Step 2 - When the readers field goes to 0, set the locked flag
+ *
+ * The 2-step locking code should be used when readers are present. When
+ * not in fair mode, the readers actually ignore the first step. However,
+ * this is still necessary to force other writers to fall in line.
+ */
+static __always_inline int queue_write_2step_lock(struct qrwlock *lock)
+{
+	union qrwcnts old, new;
+
+	old.rw = ACCESS_ONCE(lock->cnts.rw);
+	/* Step 1 */
+	if (old.writer || (cmpxchg(&lock->cnts.writer, 0, QW_WAITING) != 0))
+		return 0;
+
+	/* Step 2 */
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
+	_DEFINE_QRWNODE(node);
+
+	if (queue_write_2step_lock(lock))
+		return;
+	/*
+	 * Put the writer into the wait queue
+	 */
+	wait_in_queue(lock, &node);
+
+	/*
+	 * At the head of the wait queue now, call queue_write_trylock()
+	 * and queue_write_2step_lock() to acquire the lock until it is done.
+	 */
+	while (true) {
+		if (queue_write_trylock(lock))
+			break;
+		cpu_relax();
+		if (queue_write_2step_lock(lock))
+			break;
+		cpu_relax();
+	}
+	signal_next(lock, &node);
+}
+EXPORT_SYMBOL(queue_write_lock_slowpath);
-- 
1.7.1

