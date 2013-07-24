Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080Ab3GXUNT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 16:13:19 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:31686 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748Ab3GXUNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 16:13:16 -0400
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
Subject: [PATCH v2 1/3] qrwlock: A queue read/write lock implementation
Date: Wed, 24 Jul 2013 16:12:24 -0400
Message-Id: <1374696746-40184-2-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1374696746-40184-1-git-send-email-Waiman.Long@hp.com>
References: <1374696746-40184-1-git-send-email-Waiman.Long@hp.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a read/write lock implementation that put waiting
readers and writers into a queue instead of actively contending the
lock like the classic read/write lock. This will improve performance
in highly contended situation by reducing the cache line bouncing
effect.

In addition, the queue read/write lock is more deterministic in the
sense that late comers jumping ahead and stealing the lock is unlikely
even though there is still a very small chance for lock stealing to
happen if the reader or writer comes at the right moment.  Other than
that, lock granting is done in a FIFO manner.  As a result, it is
possible to determine a maximum time period after which the waiting
is over and the lock can be acquired.  The only downside is the size
increase in the lock structure by 4 bytes for 32-bit systems and by
12 bytes for 64-bit systems.

This patch allows the optional replacement of architecture specific
implementation of read/write lock by this generic version of queue
read/write lock. Two new config parameters are introduced:

1. QUEUE_RWLOCK
   A select-able option that enables the building and replacement of
   architecture specific read/write lock by queue read/write lock.
2. ARCH_QUEUE_RWLOCK
   Have to be defined in arch/$(ARCH)/Kconfig to enable QUEUE_RWLOCK
   option. This option, by itself, will not enable the queue read/write
   lock feature.

The queue read/write lock can also provide the classic read/write
lock behavior of a steady stream of readers stealing the read lock
from a waiting writer by using a different initializer. This behavior
can be beneficial for workloads that is reader heavy and the writers
can wait or when deviation from the classic behavior can cause problem.

The queue read/write lock readers have two slightly different locking
code paths - one for fair readers and one for classic readers. The
fair readers can use xadd to increment the reader count as the readers
can back off when they find the writer field set. This makes the fair
readers code path less affected by delay due to reader contention.

The classic readers with lock stealing cannot use xadd as they can't be
certain if the writer has seen the reader count going to 0 and hence
owns the lock. So they have to use cmpxchg for this purpose. This
makes the classic readers subject to delay caused by reader
contention. However, the ability to steal the lock from a waiting
writer also make them less susceptible to contention delay caused by
the writer. So the two types of readers are somewhat comparable in
speed depending on the exact mix of reader and writer activities.

In term of single-thread performance (no contention), a 256K
lock/unlock loop was run on a 2.4GHz and 2.93Ghz Westmere as well as
a 3.4GHz Ivy-Bridge x86-64 CPU. The following table shows the average
time (in ns) for a single lock/unlock sequence (including the looping
and timing overhead):

Lock Type		    2.4GHz	2.93GHz		3.4GHz
---------		    ------	-------		------
Ticket spinlock		     14.9	 12.1		 10.6
Read lock		     17.0	 13.5		 12.2
Write lock		     17.2	 13.5		 12.2
Queue fair read lock	     20.2	 16.5		 15.7
Queue classic read lock	     22.4	 19.0		 16.3
Queue write lock	      9.3	  7.8		  7.4

While the queue read lock is about 1.5X the time of a spinlock,
the queue write lock is just about 2/3 of the time of that
spinlock. Comparing to the classic read/write lock, the queue read
lock is about 1/3 slower while the queue write lock is about slightly
more than 1/3 faster.

With lock contention, the speed of each individual lock/unlock function
is less important than the amount of contention-induced delays.

To investigate the performance characteristics of the queue read/write
lock compared with the classic read/write lock, the fserver and
new_fserver benchmarks with ext4 filesystem of the AIM7 test suite
were used on a 8-socket x86-64 system with 80 cores. The read/write
lock in contention was the j_state_lock of the journal_s structure
in include/linux/jbd2.h.

The following kernels were used:
1) Vanilla 3.10.1
2) 3.10.1 with qrwlock patch
3) 3.10.1 with qrwlock patch and classic behavior for j_state_lock
   (classic behavior - readers can steal lock from waiting writer)

The following table shows the averaged results in the 200-1000
user ranges:

+-----------------+-------+-------+-------+-------+-------+-------+
|  Kernel         |   1   |   2   |   3   |   1   |   2   |   3   |
|  HT		  |  on   |  on   |  on   |  off  |  off  |  off  |
+-----------------+-------+-------+-------+-------+-------+-------+
| fserver JPM     |308872 |372662 |298547 |460371 |463712 |454369 |
| % change from 1 |  0%   |+20.7% | -3.3% |  0%   | +0.7% | -1.3% |
+-----------------+-------+-------+-------+-------+-------+-------+
| new_fserver JPM |314730 |385665 |321122 |441284 |441606 |441579 |
| % change from 1 |  0%   |+22.5% | +2.0% |  0%   | +0.1% | +0.1% |
+-----------------+-------+-------+-------+-------+-------+-------+

The following table shows the averaged results in the 1100-2000
user ranges:

+-----------------+-------+-------+-------+-------+-------+-------+
|  Kernel         |   1   |   2   |   3   |   1   |   2   |   3   |
|  HT		  |  on   |  on   |  on   |  off  |  off  |  off  |
+-----------------+-------+-------+-------+-------+-------+-------+
| fserver JPM     |263151 |332506 |325699 |472254 |472166 |464351 |
| % change from 1 |  0%   |+26.4% |+23.8% |  0%   |  0.0% | -1.7% |
+-----------------+-------+-------+-------+-------+-------+-------+
| new-fserver JPM |264615 |322803 |297902 |445516 |450811 |452229 |
| % change from 1 |  0%   |+22.0% |+12.6% |  0%   | +1.2% | +1.5% |
+-----------------+-------+-------+-------+-------+-------+-------+

The following table show the amount of CPU time spent on the fastpaths
and slowpaths of the read and write lock for each of the different
kernels listed above as reported by perf with the fserver workload
at 1500 users:

+-----------------+-------+-------+-------+-------+-------+-------+
|  Kernel         |   1   |   2   |   3   |   1   |   2   |   3   |
|  HT             |  on   |  on   |  on   |  off  |  off  |  off  |
+-----------------+-------+-------+-------+-------+-------+-------+
| Read fastpath   | 0.83% | 0.18% | 0.19% | 0.22% | 0.21% | 0.22% |
| Read slowpath   | 13.4% | 18.9% | 18.2% | 0.28% | 0.52% | 0.55% |
| Write fastpath  | 0.10% | 0.01% | 0.02% | 0.01% | 0.01% | 0.01% |
| Write slowpath  | 11.1% | 0.05% | 0.14% | 0.08% | 0.00% | 0.00% |
+-----------------+-------+-------+-------+-------+-------+-------+

The small write slowpath numbers for queue read/write lock indicates
that it is a reader heavy lock with writers probably holding the
lock a lot longer than the readers. The queue read/write lock of
both favors causes a big reduction in the amount of time spent by the
writers to get the lock. Even though the readers need to wait longer,
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
3) 3.10.1 with mb_cache_spinlock replaced by classic write lock

The following table shows the averaged JPM results for the disk
workload:

+----------+--------+--------+--------+--------+--------+--------+
|  Kernel  |    1   |    2   |    3   |    1   |    2   |    3   |
|  HT      |   off  |   off  |   off  |   on   |   on   |   on   |
+----------+--------+--------+--------+--------+--------+--------+
|          |               User Range 10 - 100                   |
+----------+--------+--------+--------+--------+--------+--------+
| disk JPM | 439561 | 609084 | 614491 | 441911 | 572606 | 625140 |
| % change |   0%   | +38.6% | +39.8% |   0%   | +29.6% | +41.5% |
+----------+--------+--------+--------+--------+--------+--------+
|          |              User Range 200 - 1000                  |
+----------+--------+--------+--------+--------+--------+--------+
| disk JPM | 223976 | 363216 | 394828 | 207602 | 331567 | 350162 |
| % change |   0%   | +62.1% | +76.3% |   0%   | +59.7% | +68.7% |
+----------+--------+--------+--------+--------+--------+--------+
|          |              User Range 1100 - 2000                 |
+----------+--------+--------+--------+--------+--------+--------+
| disk JPM | 216317 | 324617 | 326147 | 200440 | 294092 | 258985 |
| % change |   0%   | +50.1% | +50.8% |   0%   | +46.7% | +29.2% |
+----------+--------+--------+--------+--------+--------+--------+

The amount of time spent in mbcache lock contention as reported by perf
for the disk workload at 1000 users were listed in the following table.

+----------------+-------+-------+-------+-------+-------+-------+
|  Kernel        |   1   |   2   |   3   |   1   |   2   |   3   |
|    HT          |  off  |  off  |  off  |  on   |  on   |  on   |
+----------------+-------+-------+-------+-------+-------+-------+
| _raw_spin_lock | 76.9% |   -   |   -   | 72.1% |   -   |   -   |
| wlock fastpath |   -   | 0.09% | 0.53% |   -   | 0.06% | 0.39% |
| wlock slowpath |   -   | 68.1% | 62.8% |   -   | 67.5% | 60.2% |
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

Apparently, the classic write lock performs even better than the queue
write lock in some cases.  However, the queue write lock is fair, but
the classic write lock is not. So it is not a very good replacement
for ticket spinlock.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 include/asm-generic/qrwlock.h |  251 +++++++++++++++++++++++++++++++++++++++++
 lib/Kconfig                   |   23 ++++
 lib/Makefile                  |    1 +
 lib/qrwlock.c                 |  194 +++++++++++++++++++++++++++++++
 4 files changed, 469 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-generic/qrwlock.h
 create mode 100644 lib/qrwlock.c

diff --git a/include/asm-generic/qrwlock.h b/include/asm-generic/qrwlock.h
new file mode 100644
index 0000000..2b47a62
--- /dev/null
+++ b/include/asm-generic/qrwlock.h
@@ -0,0 +1,251 @@
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
+ * holding the read lock. When the read lock stealing flag is set, it mimics
+ * the behavior of the classical read/write lock at the expense that a
+ * perpetual stream of readers could starve a writer for a long period of time.
+ * That behavior, however, may be beneficial to a workload that is reader heavy
+ * with slow writers, and the writers can wait without undesirable consequence.
+ * It is also useful for read/write locks that may not work properly if the 
+ * behavior deviates from the classical one. This flag should only be set
+ * at initialization time.
+ *
+ * The layout of the structure is endian-sensitive to make sure that adding
+ * QRW_READER_BIAS to the rw field to increment the reader count won't
+ * disturb the writer and the rsteal fields.
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
+			u8	  writer;	/* Set if a writer is waiting */
+			u8	  rsteal;	/* Read lock stealing flag */
+			__nrcpu_t readers;	/* Number of active readers */
+#else
+			__nrcpu_t readers;	/* Number of active readers */
+			u8	  rsteal;	/* Read lock stealing flag */
+			u8	  writer;	/* Set if a writer is waiting */
+#endif
+		};
+		__nrcpupair_t rw;		/* Reader/writer number pair */
+	} cnts;
+	_DEFINE_QRWNODE(*waitq);		/* Tail of waiting queue */
+} arch_rwlock_t;
+
+/*
+ * External function declarations
+ */
+extern void queue_read_lock_slowpath( struct qrwlock *lock, int dec_reader);
+extern void queue_write_lock_slowpath(struct qrwlock *lock);
+
+/**
+ * queue_read_can_lock- would read_trylock() succeed?
+ * @lock: Pointer to queue read/writer lock structure
+ */
+static inline int queue_read_can_lock(struct qrwlock *lock)
+{
+	return lock->cnts.writer == 0;
+}
+
+/**
+ * queue_write_can_lock- would write_trylock() succeed?
+ * @lock: Pointer to queue read/writer lock structure
+ */
+static inline int queue_write_can_lock(struct qrwlock *lock)
+{
+	return (lock->cnts.writer == 0) && (lock->cnts.readers == 0);
+}
+
+/**
+ * queue_read_lock - acquire read lock of a queue read/write lock
+ * @lock: Pointer to queue read/writer lock structure
+ *
+ * For fair queue read/write lock, xadd can be used to increment the reader
+ * count to remove failure cases due to reader contention. If a writer is now
+ * present, the slowpath will have to decrement the reader count first before
+ * waiting. For classic behavior queue read/write lock, we have to make sure
+ * that there is no illegal reader lock stealing by not incrementing reader
+ * count when writer is present.
+ */
+static inline void queue_read_lock(struct qrwlock *lock)
+{
+	union qrwcnts old;
+	int   dec_reader = 0;	/* Decrement reader count */
+
+	old.rw = ACCESS_ONCE(lock->cnts.rw);
+	if (likely(!old.writer && !old.rsteal)) {
+		/* Fair queue rwlock reader */
+		old.rw = xadd(&lock->cnts.rw, QRW_READER_BIAS);
+		if (likely(!old.writer))
+			return;
+		dec_reader = 1;
+	} else if (likely(!old.writer)) {
+		/* Classic behavior queue rwlock reader */
+		union qrwcnts new;
+
+		new.rw = old.rw;
+		new.readers++;
+		if (likely(cmpxchg(&lock->cnts.rw, old.rw, new.rw) == old.rw))
+			return;
+	}
+	queue_read_lock_slowpath(lock, dec_reader);
+}
+
+/**
+ * queue_write_lock - acquire write lock of a queue read/write lock
+ * @lock : Pointer to queue read/writer lock structure
+ */
+static inline void queue_write_lock(struct qrwlock *lock)
+{
+	if (likely(!ACCESS_ONCE(lock->cnts.writer))) {
+		/*
+		 * Atomically set the writer to 1, then wait until reader
+		 * count goes to 0.
+		 */
+		if (likely(xchg(&lock->cnts.writer, 1) == 0)) {
+			while (ACCESS_ONCE(lock->cnts.readers))
+				cpu_relax();
+			return;
+		}
+	}
+	queue_write_lock_slowpath(lock);
+}
+
+/*
+ * queue_read_trylock - try to acquire read lock of a queue read/write lock
+ * @lock : Pointer to queue read/writer lock structure
+ * Return: 1 if lock acquired, 0 if failed
+ */
+static inline int queue_read_trylock(struct qrwlock *lock)
+{
+	union qrwcnts old, new;
+
+	old.rw = ACCESS_ONCE(lock->cnts.rw);
+	if (unlikely(old.writer))
+		return 0;
+	new.rw = old.rw;
+	new.readers++;
+	if (cmpxchg(&lock->cnts.rw, old.rw, new.rw) == old.rw)
+		return 1;
+	return 0;
+}
+
+/**
+ * queue_write_trylock - try to acquire write lock of a queue read/write lock
+ * @lock : Pointer to queue read/writer lock structure
+ * Return: 1 if lock acquired, 0 if failed
+ */
+static inline int queue_write_trylock(struct qrwlock *lock)
+{
+	union qrwcnts old, new;
+
+	old.rw = ACCESS_ONCE(lock->cnts.rw);
+	if (!old.rw) {
+		/*
+		 * Atomically set the writer to 1 if readers = 0
+		 */
+		new.rw = old.rw;
+		new.writer = 1;
+		if (cmpxchg(&lock->cnts.rw, old.rw, new.rw) == old.rw)
+			return 1;
+	}
+	return 0;
+}
+
+/**
+ * queue_read_unlock - release read lock of a queue read/write lock
+ * @lock : Pointer to queue read/writer lock structure
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
+ * queue_write_unlock - release write lock of a queue read/write lock
+ * @lock : Pointer to queue read/writer lock structure
+ */
+static inline void queue_write_unlock(struct qrwlock *lock)
+{
+	ACCESS_ONCE(lock->cnts.writer) = 0;
+	smp_wmb();
+}
+
+/*
+ * Initializier
+ */
+#define	__ARCH_RW_LOCK_UNLOCKED	{ .cnts = { .rw = 0 } _INIT_WAITQ }
+#define	__ARCH_RW_LOCK_UNLOCKED_RSTEAL	\
+	{ .cnts = {{ .writer = 0, .rsteal = 1, .readers = 0 }} _INIT_WAITQ }
+#define	__ARCH_RW_LOCK_UNLOCKED_CLASSIC	__ARCH_RW_LOCK_UNLOCKED_RSTEAL
+
+/*
+ * Remapping read/write lock architecture specific functions to the
+ * corresponding queue read/write lock functions.
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
index 35da513..e577e6c 100644
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
+	  that are fairer and more optmized for larger NUMA systems.
+	  These locks use more memory, but is fair to both readers
+	  and writers and perform better under high contention.
+	  Specifically, waiting readers and writers will be queued
+	  up and granted lock in FIFO order rather than all spinning
+	  on the same cache line to compete for the lock.
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
index 0000000..f62e787
--- /dev/null
+++ b/lib/qrwlock.c
@@ -0,0 +1,194 @@
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
+#include <asm-generic/qrwlock.h>
+
+/*
+ * Compared with regular read/write lock, the queue read/write lock has
+ * has the following advantages:
+ * 1. It is more deterministic. Even though there is a slight chance of
+ *    stealing the lock if come at the right moment, the granting of the
+ *    lock is mostly in FIFO order.
+ * 2. It is faster in high contention situation.
+ *
+ * The only downside is that the lock is 4 bytes larger in 32-bit systems
+ * and 12 bytes larger in 64-bit systems.
+ *
+ * There are two queues for writers. The writer field of the lock is a
+ * one-slot waiting queue. The writers that follows will have to wait
+ * in the combined reader/writer queue (waitq).
+ *
+ * Compared with x86 ticket spinlock, the queue read/write lock is faster
+ * in high contention situation. The writer lock is also faster in single
+ * thread operations. Therefore, queue read/write lock can be considered as
+ * a replacement for those spinlocks that are highly contended as long as
+ * an increase in lock size is not an issue.
+ */
+
+#ifdef _QUEUE_RWLOCK_NOWAITQ
+# define wait_in_queue(l, n)
+# define signal_next(l, n)
+#else
+/**
+ * wait_in_queue - Add to queue and wait until it is at the head
+ * @lock: Pointer to queue read/writer lock structure
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
+ * @lock: Pointer to queue read/writer lock structure
+ * @node: Node pointer to the current head of queue
+ */
+static __always_inline void
+signal_next(struct qrwlock *lock, struct qrwnode *node)
+{
+	struct qrwnode *next;
+
+	/*
+	 * Notify the next one in queue or clear the waiting queue
+	 */
+	if ((ACCESS_ONCE(lock->waitq) == node) &&
+	    (cmpxchg(&lock->waitq, node, NULL) == node))
+			return;
+	/*
+	 * Wait until the next one in queue set up the next field
+	 */
+	while (!likely(next = ACCESS_ONCE(node->next)))
+		cpu_relax();
+	/*
+	 * The next one in queue is now at the head
+	 */
+	ACCESS_ONCE(next->wait) = false;
+	smp_wmb();
+}
+#endif
+
+/**
+ * queue_read_lock_slowpath - acquire read lock of a queue read/write lock
+ * @lock: Pointer to queue read/writer lock structure
+ */
+void queue_read_lock_slowpath(struct qrwlock *lock, int dec_reader)
+{
+	int rsteal;
+	union qrwcnts old, new;
+	_DEFINE_QRWNODE(node);
+
+	if (unlikely(dec_reader))
+		add_smp(&lock->cnts.readers, -1);
+	old.rw = lock->cnts.rw;
+	rsteal = old.rsteal;
+	while (unlikely(rsteal && old.readers)) {
+		/*
+		 * Read lock stealing enabled
+		 */
+		new.rw = old.rw;
+		new.readers++;
+		if (likely(cmpxchg(&lock->cnts.rw, old.rw, new.rw) == old.rw))
+			return;
+		cpu_relax();
+		old.rw = ACCESS_ONCE(lock->cnts.rw);
+	}
+
+	/*
+	 * Put the reader into the waiting queue
+	 */
+	wait_in_queue(lock, &node);
+
+	/*
+	 * At the head of the wait queue now, wait until no writer is pending
+	 * or when the reader stealing flag is set and readers are present.
+	 * Then try to atomically inc the reader number.
+	 */
+	while (true) {
+		old.rw = ACCESS_ONCE(lock->cnts.rw);
+		if (likely(!rsteal)) {
+			/* Fair queue rwlock reader */
+			if (!old.writer) {
+				old.rw = xadd(&lock->cnts.rw, QRW_READER_BIAS);
+				if (likely(!old.writer))
+					break;
+				add_smp(&lock->cnts.readers, -1);
+			}
+		} else if (!old.writer || old.readers) {
+			/* Classic behavior queue rwlock reader */
+			new.rw = old.rw;
+			new.readers++;
+			if (cmpxchg(&lock->cnts.rw, old.rw, new.rw) == old.rw)
+				break;
+		}
+		cpu_relax();
+	}
+	signal_next(lock, &node);
+}
+EXPORT_SYMBOL(queue_read_lock_slowpath);
+
+/**
+ * queue_write_lock_slowpath - acquire write lock of a queue read/write lock
+ * @lock : Pointer to queue read/writer lock structure
+ */
+void queue_write_lock_slowpath(struct qrwlock *lock)
+{
+	_DEFINE_QRWNODE(node);
+
+	/*
+	 * Put the writer into the waiting queue
+	 */
+	wait_in_queue(lock, &node);
+
+	/*
+	 * At the head of the wait queue now, wait until no writer is pending
+	 * and then atomically set it again.
+	 */
+	while (true) {
+		if ((ACCESS_ONCE(lock->cnts.writer) == 0) &&
+		    (xchg(&lock->cnts.writer, 1) == 0))
+				break;
+		cpu_relax();
+	}
+	/*
+	 * Wait until the reader count go to zero
+	 */
+	while (ACCESS_ONCE(lock->cnts.readers))
+		cpu_relax();
+
+	signal_next(lock, &node);
+}
+EXPORT_SYMBOL(queue_write_lock_slowpath);
-- 
1.7.1

