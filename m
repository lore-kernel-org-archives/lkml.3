Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079Ab3GMBes (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 21:34:48 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:23219 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758011Ab3GMBep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 21:34:45 -0400
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
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH RFC 1/2] qrwlock: A queue read/write lock implementation
Date: Fri, 12 Jul 2013 21:34:08 -0400
Message-Id: <1373679249-27123-2-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1373679249-27123-1-git-send-email-Waiman.Long@hp.com>
References: <1373679249-27123-1-git-send-email-Waiman.Long@hp.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a read/write lock implementation that put waiting
readers and writers into a queue instead of actively contending the
lock like the regular read/write lock. This will improve performance in
highly contended situation by reducing the cache line bouncing effect.

In addition, the queue read/write lock is more deterministic even
though there is still a smaller chance for lock stealing if the reader
or writer comes at the right moment. Other than that, lock granting
is done in a FIFO manner. The only downside is the size increase in
the lock structure by 4 bytes for 32-bit systems and by 12 bytes for
64-bit systems.

This patch allows the replacement of architecture specific
implementation of read/write lock by this generic version of queue
read/write lock. Two new config parameters are introduced:

1. QUEUE_RWLOCK
   A select-able option that enables the building and replacement of
   architecture specific read/write lock.
2. ARCH_QUEUE_RWLOCK
   Have to be defined in arch/$(arch)/Kconfig to enable QUEUE_RWLOCK

In term of single-thread performance (no contention), a 256K
lock/unlock loop was run on a 2.4GHz Westmere x86-64 CPU. The following
table shows the average time for a single lock/unlock sequence:

Lock Type		Time (ns)
---------		---------
Ticket spinlock		  15.7
Read lock		  17.0
Write lock		  17.2
Queue read lock		  31.1
Queue write lock	  13.6

While the queue read lock is almost double the time of a read lock
or spinlock, the queue write lock is the fastest of them all. The
execution time can probably be reduced a bit by allowing inlining of
the lock fast paths like the other locks.

To see how the queue write lock can be used as a replacement for ticket
spinlock (just like rwsem can be used as replacement of mutex), the
mb_cache_spinlock in fs/mbcache.c, which is a bottleneck in the disk
workload (ext4 FS) of the AIM7 benchmark, was converted to both a queue
write lock and a regular write lock. When running on a 8-socket 80-core
DL980 system, the performance improvement was shown in the table below.

+-----------------+------------+------------+-----------+---------+
|  Configuration  |  Mean JPM  |  Mean JPM  | Mean JPM  | qrwlock |
|                 |Vanilla 3.10|3.10-qrwlock|3.10-rwlock| %Change |
+-----------------+-----------------------------------------------+
|                 |              User Range 10 - 100              |
+-----------------+-----------------------------------------------+
| 8 nodes, HT off |   441374   |   532774   |  637205   | +20.7%  |
| 8 nodes, HT on  |   449373   |   584387   |  641965   | +30.1%  |
+-----------------+-----------------------------------------------+
|                 |              User Range 200 - 1000            |
+-----------------+-----------------------------------------------+
| 8 nodes, HT off |   226870   |   354490   |  371593   | +56.3%  |
| 8 nodes, HT on  |   205997   |   314891   |  306378   | +52.9%  |
+-----------------+-----------------------------------------------+
|                 |              User Range 1100 - 2000           |
+-----------------+-----------------------------------------------+
| 8 nodes, HT off |   208234   |   321420   |  343694   | +54.4%  |
| 8 nodes, HT on  |   199612   |   297853   |  252569   | +49.2%  |
+-----------------+------------+------------+-----------+---------+

Apparently, the regular read/write lock performs even better than
the queue read/write lock in some cases.  This is probably due to the
fact that mb_cache_spinlock is in a separate cache line from the data
being manipulated.

Looking at the fserver and new_fserver workloads (ext4 FS) where the
journal->j_state_lock (a read/write lock) is a bottleneck especially
when HT is on, we see a slight different story. The j_state_lock is
an embedded read/write lock which is in the same cacheline as some
of the data being manipulated. The replacement by a queue read/write
lock gives the following improvement.

+--------------------+-------------+--------------+---------------+
|      Workload      |mean % change|mean % change |mean % change  |
|                    |10-100 users |200-1000 users|1100-2000 users|
+--------------------+-------------+--------------+---------------+
|fserver (HT off)    |    +0.3%    |    -0.1%     |    +1.9%      |
|fserver (HT on)     |    -0.1%    |   +32.2%     |   +34.7%      |
|new_fserver (HT on) |    +0.8%    |    +0.9%     |    +0.9%      |
|new_fserver (HT off)|    -1.2%    |   +29.8%     |   +40.5%      |
+--------------------+-------------+--------------+---------------+

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 include/asm-generic/qrwlock.h |  124 +++++++++++++++++++++
 lib/Kconfig                   |   11 ++
 lib/Makefile                  |    1 +
 lib/qrwlock.c                 |  246 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 382 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-generic/qrwlock.h
 create mode 100644 lib/qrwlock.c

diff --git a/include/asm-generic/qrwlock.h b/include/asm-generic/qrwlock.h
new file mode 100644
index 0000000..d758dd0
--- /dev/null
+++ b/include/asm-generic/qrwlock.h
@@ -0,0 +1,124 @@
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
+
+#if (CONFIG_NR_CPUS < 65536)
+typedef u16 __nrcpu_t;
+typedef u32 __nrcpupair_t;
+#else
+typedef u32 __nrcpu_t;
+typedef u64 __nrcpupair_t;
+#endif
+
+/*
+ * The queue read/write lock data structure
+ * The reader stealing flag, if sea,t will enable reader at the head of the
+ * waiting queue to steal the read lock even if a writer is waiting. However,
+ * that may cause starving of a writer by a perpetual stream of readers.
+ */
+struct qrwnode {
+	struct qrwnode *next;
+	bool		wait;	/* Waiting flag */
+};
+
+typedef struct qrwlock {
+	union {
+		__nrcpupair_t rw;		/* Reader/writer number pair */
+		struct {
+			u8	  writer;	/* Set if a writer is waiting */
+			u8	  rsteal;	/* Reader stealing flag */
+			__nrcpu_t readers;	/* Number of active readers */
+		};
+	};
+	struct qrwnode *waitq;			/* Tail of waiting queue */
+} arch_rwlock_t;
+
+/**
+ * queue_read_can_lock- would read_trylock() succeed?
+ * @lock: Pointer to queue read/writer lock structure
+ */
+static inline int queue_read_can_lock(struct qrwlock *lock)
+{
+	return lock->writer == 0;
+}
+
+/**
+ * queue_write_can_lock- would write_trylock() succeed?
+ * @lock: Pointer to queue read/writer lock structure
+ */
+static inline int queue_write_can_lock(struct qrwlock *lock)
+{
+	return lock->rw == 0;
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
+	add_smp(&lock->readers, -1);
+}
+
+/**
+ * queue_write_unlock - release write lock of a queue read/write lock
+ * @lock : Pointer to queue read/writer lock structure
+ */
+static inline void queue_write_unlock(struct qrwlock *lock)
+{
+	ACCESS_ONCE(lock->writer) = 0;
+	smp_wmb();
+}
+
+/*
+ * External function declarations
+ */
+extern void queue_read_lock(struct qrwlock *);
+extern void queue_write_lock(struct qrwlock *);
+extern int  queue_read_trylock(struct qrwlock *);
+extern int  queue_write_trylock(struct qrwlock *);
+
+/*
+ * Initializier
+ */
+#define	__ARCH_RW_LOCK_UNLOCKED	{ { .rw = 0 }, .waitq = NULL }
+#define	__ARCH_RW_LOCK_UNLOCKED_RSTEAL	\
+	{ { .writer = 0, .rsteal = 1, .readers = 0 }, waitq = NULL }
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
index 35da513..de32799 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -412,6 +412,17 @@ config SIGNATURE
 	  Implementation is done using GnuPG MPI library
 
 #
+# Generic queue read/write lock
+#
+config QUEUE_RWLOCK
+	bool "Generic queue read/write lock"
+	depends on ARCH_QUEUE_RWLOCK
+	help
+	  Use a NUMA optimized queue read/write lock implementation. This
+	  improves performance under lock contention on systems with more
+	  than two sockets.
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
index 0000000..a206fae
--- /dev/null
+++ b/lib/qrwlock.c
@@ -0,0 +1,246 @@
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
+	barrier();
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
+	if (ACCESS_ONCE(lock->waitq) == node) {
+		if (cmpxchg(&lock->waitq, node, NULL) == node)
+			return;
+	}
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
+
+/**
+ * queue_read_lock - acquire read lock of a queue read/write lock
+ * @lock: Pointer to queue read/writer lock structure
+ */
+void queue_read_lock(struct qrwlock *lock)
+{
+	struct qrwlock old, new;
+	struct qrwnode node;
+
+	old.rw = ACCESS_ONCE(lock->rw);
+	while (likely(!old.writer)) {
+		/*
+		 * Atomically increment the reader count while writer is 0
+		 */
+		new.rw = old.rw;
+		new.readers++;
+
+		if (cmpxchg(&lock->rw, old.rw, new.rw) == old.rw)
+			return;
+		cpu_relax();
+		old.rw = ACCESS_ONCE(lock->rw);
+	}
+	/*
+	 * Slowpath
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
+		old.rw = ACCESS_ONCE(lock->rw);
+		if (old.writer && (!old.rsteal || !old.readers)) {
+			cpu_relax();
+			continue;
+		}
+		new.rw = old.rw;
+		new.readers++;
+		if (cmpxchg(&lock->rw, old.rw, new.rw) == old.rw)
+			break;
+		cpu_relax();
+	}
+	signal_next(lock, &node);
+}
+EXPORT_SYMBOL(queue_read_lock);
+
+
+/*
+ * queue_read_trylock - try to acquire read lock of a queue read/write lock
+ * @lock : Pointer to queue read/writer lock structure
+ * Return: 1 if lock acquired, 0 if failed
+ */
+int queue_read_trylock(struct qrwlock *lock)
+{
+	struct qrwlock old, new;
+
+	old.rw = ACCESS_ONCE(lock->rw);
+	if (unlikely(old.writer))
+		return 0;
+	new.rw = old.rw;
+	new.readers++;
+
+	if (cmpxchg(&lock->rw, old.rw, new.rw) == old.rw)
+		return 1;
+	cpu_relax();
+	return 0;
+}
+EXPORT_SYMBOL(queue_read_trylock);
+
+/**
+ * queue_write_lock - acquire write lock of a queue read/write lock
+ * @lock : Pointer to queue read/writer lock structure
+ */
+void queue_write_lock(struct qrwlock *lock)
+{
+	struct qrwnode node, *next;
+
+	if (likely(!ACCESS_ONCE(lock->writer))) {
+		/*
+		 * Atomically set the writer to 1, then wait until reader
+		 * count goes to 0.
+		 */
+		if (xchg(&lock->writer, 1) == 0) {
+			while (ACCESS_ONCE(lock->readers))
+				cpu_relax();
+			return;
+		}
+		cpu_relax();
+	}
+	/*
+	 * Slowpath
+	 * Put the writer into the waiting queue
+	 */
+	wait_in_queue(lock, &node);
+
+	/*
+	 * At the head of the wait queue now, wait until no writer is pending
+	 * and then atomically set it again.
+	 */
+	while (true) {
+		if (ACCESS_ONCE(lock->writer)) {
+			cpu_relax();
+			continue;
+		}
+		if (xchg(&lock->writer, 1) != 0) {
+			cpu_relax();
+			continue;
+		}
+		break;
+	}
+	/*
+	 * Wait until the reader count go to zero
+	 */
+	while (ACCESS_ONCE(lock->readers))
+		cpu_relax();
+
+	signal_next(lock, &node);
+}
+EXPORT_SYMBOL(queue_write_lock);
+
+/**
+ * queue_write_trylock - try to acquire write lock of a queue read/write lock
+ * @lock : Pointer to queue read/writer lock structure
+ * Return: 1 if lock acquired, 0 if failed
+ */
+int queue_write_trylock(struct qrwlock *lock)
+{
+	struct qrwlock old, new;
+
+	old.rw = ACCESS_ONCE(lock->rw);
+	if (!old.rw) {
+		/*
+		 * Atomically set the writer to 1 if readers = 0
+		 */
+		new.rw = old.rw;
+		new.writer = 1;
+		if (cmpxchg(&lock->rw, old.rw, new.rw) == old.rw)
+			return 1;
+		cpu_relax();
+	}
+	return 0;
+}
+EXPORT_SYMBOL(queue_write_trylock);
-- 
1.7.1

