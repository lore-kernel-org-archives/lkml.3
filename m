Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758591Ab3HMSmM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 14:42:12 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:21378 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758351Ab3HMSlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 14:41:50 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Harvey Harrison <harvey.harrison@gmail.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH RFC v2 1/2] qspinlock: Introducing a 4-byte queue spinlock implementation
Date: Tue, 13 Aug 2013 14:41:06 -0400
Message-Id: <1376419267-17663-2-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1376419267-17663-1-git-send-email-Waiman.Long@hp.com>
References: <1376419267-17663-1-git-send-email-Waiman.Long@hp.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a new queue spinlock implementation that can
serve as an alternative to the default ticket spinlock. Compared with
the ticket spinlock, this queue spinlock should be almost as fair as
the ticket spinlock. It has about the same speed in single-thread and
it can be much faster in high contention situations. Only in light to
moderate contention where the average queue depth is around 1-2 will
this queue spinlock be potentially a bit slower due to the higher
slowpath overhead.

This queue spinlock is especially suit to NUMA machines with a large
number of cores as the chance of spinlock contention is much higher
in those machines. The cost of contention is also higher because of
slower inter-node memory traffic.

The idea behind this spinlock implementation is the fact that spinlocks
are acquired with preemption disabled. In other words, the process
will not be migrated to another CPU while it is trying to get a
spinlock. Ignoring interrupt handling, a CPU can only be contending
in one spinlock at any one time. Of course, interrupt handler can try
to acquire one spinlock while the interrupted user process is in the
process of getting another spinlock. By allocating a set of per-cpu
queue nodes and used them to form a waiting queue, we can encode the
queue node address into a much smaller 16-bit size. Together with
the 1-byte lock bit, this queue spinlock implementation will only
need 4 bytes to hold all the information that it needs.

The default queue node address encoding is as follows:
Bits 0-1 : queue node index in the per-cpu array (4 entries)
Bits 2-16: cpu number + 1 (max cpus = 16383)

If more CPUs are to be supported (numerous CPU mode), 24 bits of the
32-bit lock will be used to support at least (64K-1) CPUs. There are
additional overhead which can potentially slow it down a little bit.

In the extremely unlikely case that all the queue node entries are
used up, the current code will fall back to busy spinning without
waiting in a queue with warning message.

This patch also has an experimental configuration option
(QSPINLOCK_UNFAIR) to enable lock stealing.  That will break the
FIFO guarantee of lock acquisition process, but it usually results
in better performance when lock contention happens.

The patch allows the optional replacement of architecture specific
implementation of ticket spinlock by this generic version of queue
spinlock. Two new config parameters are introduced:

1. QSPINLOCK
   A select-able option that enables the building and replacement of
   architecture specific spinlock by queue spinlock.
2. ARCH_QSPINLOCK
   Have to be defined in arch/$(ARCH)/Kconfig to enable QUEUE_SPINLOCK
   option. This option, by itself, will not enable the queue spinlock
   feature.

For single-thread performance (no contention), a 256K lock/unlock
loop was run on a 2.93Ghz Westmere x86-64 CPU.  The following table
shows the average time (in ns) for a single lock/unlock sequence
(including the looping and timing overhead):

Lock Type			Time (ns)
---------			---------
Ticket spinlock			  12.2
Queue spinlock (Normal)		  11.9
Queue spinlock (Numerous CPU)	   7.9

So the normal queue spinlock has about the same performance as a
ticket spinlock.  In numerous CPU mode, the queue spinlock is much
faster because of less overhead in the unlock fast path.

The AIM7 benchmark was run on a 8-socket 80-core DL980 with Westmere
x86-64 CPUs and HT off to evaluate the performance impact of this
patch on the 3.10.5 kernel. The following modified kernels were tested:
1) Queue spinlock (normal)
2) Queue spinlock (normal) with lock stealing
3) Queue spinlock (numerous CPU)

The jobs per minute (JPM) results for the 1100-2000 user ranges are
shown below:

+------------+---------+---------+---------+---------+
| Kernel     | 3.10.5  | 3.10.5  | 3.10.5  | 3.10.5  |
|            |         | qlock 1 | qlock 2 | qlock 3 |
+------------+---------+---------+---------+---------+
|alltests    |  401450 |  402184 |  406803 |  400031 |
|% Change    |    -    |   +0.2% |   +1.3% |   -0.4% |
|custom      |  306544 |  305525 |  310030 |  307530 |
|% Change    |    -    |   -0.3% |   +1.1% |   +0.3% |
|dbase       |  897496 |  900656 |  901985 |  900234 |
|% Change    |    -    |   +0.4% |   +0.5% |   +0.3% |
|disk        |  211852 |  269357 |  347108 |  274298 |
|% Change    |    -    |  +27.1% |  +63.8% |  +29.5% |
|five_sec    |  145519 |  157018 |  159820 |  155627 |
|% Change    |    -    |   +7.9% |   +9.8% |   +7.0% |
|fserver     |  454512 |  468861 |  466659 |  459497 |
|% Change    |    -    |   +3.2% |   +2.7% |   +1.1% |
|high_systime|  135079 |  138337 |  140992 |  140198 |
|% Change    |    -    |   +2.4% |   +4.4% |   +3.8% |
|new_dbase   |  936614 |  937732 |  937403 |  936805 |
|% Change    |    -    |   +0.1% |   +0.1% |    0.0% |
|new_fserver |  440808 |  449432 |  450547 |  440155 |
|% Change    |    -    |   +2.0% |   +2.2% |   -0.2% |
|shared      |  371142 |  368907 |  369868 |  370862 |
|% Change    |    -    |   -0.6% |   -0.3% |   -0.1% |
|short       | 1058806 | 3010190 | 6058205 | 3104796 |
|% Change    |    -    | +184.3% | +472.2% | +193.2% |
+------------+---------+---------+---------+---------+

Due to variability of AIM7 results, a change of a few percentage
points may not indicate a real change in performance. However, the
general trend is that enabling lock stealing can improve performance
significantly in workloads with a lot of lock contention. The more than
double in performance in the short workload is particularly impressive.

As for the normal and numerous CPU modes, one was slightly better
in some workloads, but slightly worse in the others. The trade-off
between these two modes are as follows:
1) The normal mode enables unlock wake-up and hence has less lock
   cacheline contention.
2) The numerous CPU mode has less latency between the unlock operation
   of one CPU and the lock operation of the next one in line.

Depending on which factor is more important, one will be slightly
faster than the other.

For the disk workload, the spinlock bottleneck is the standalone
mb_cache_spinlock in fs/mbcache.c. For the short workload, the spinlock
bottleneck is the d_lock in the dentry structure.

The following table shows the %time used up by the locks as reported
by the perf command at 1000 users for disk workload & 1500 users for
short workload with HT off.

--------------------------------+----------+----------+----------+
    Configuration	 	| ticket   |  qlock   |  qlock   |
				| spinlock | fastpath | slowpath |
--------------------------------+----------+----------+----------+
Disk w/o patch			|  69.0%   |    -     |    -     |
Disk with patch         	|    -     |  0.31%   |  73.2%   |
Disk with patch	& lock stealing |    -     |  0.39%   |  67.5%   |
Short w/o patch			|  74.3%   |    -     |    -     |
Short with patch		|    -     |  0.76%   |  73.0%   |
Short with patch & lock stealing|    -     |  2.37%   |  43.3%   |
--------------------------------+----------+----------+----------+

There are 3 observations here:
1. With lock stealing enabled, less time are spent in the lock
   slowpath, thus allowing the system to do more useful work.
2. The %CPU time actually increases in the disk workload with the
   patch without lock stealing. The fact that most of them are spinning
   on their own cacheline with less congestion can probably skew the
   number up.
3. Both the short and disk workloads spend about 70% of their time
   in the lock without lock stealing. However, performance improvement
   is 2.8X vs 1.3X.  This is probably due to the fact that d_lock is
   embedded next to the d_count to be updated whereas mb_cache_spinlock
   is in a standalone cacheline not shared by the data to be updated.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 include/asm-generic/qspinlock.h |  207 ++++++++++++++++
 lib/Kconfig                     |   25 ++
 lib/Makefile                    |    1 +
 lib/qspinlock.c                 |  522 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 755 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-generic/qspinlock.h
 create mode 100644 lib/qspinlock.c

diff --git a/include/asm-generic/qspinlock.h b/include/asm-generic/qspinlock.h
new file mode 100644
index 0000000..1e0403f
--- /dev/null
+++ b/include/asm-generic/qspinlock.h
@@ -0,0 +1,207 @@
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
+ * (C) Copyright 2013 Hewlett-Packard Development Company, L.P.
+ *
+ * Authors: Waiman Long <waiman.long@hp.com>
+ */
+#ifndef __ASM_GENERIC_QSPINLOCK_H
+#define __ASM_GENERIC_QSPINLOCK_H
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
+#ifdef CONFIG_PARAVIRT_SPINLOCKS
+#define	qspinlock arch_spinlock
+#endif
+
+/*
+ * There is 2 slightly different implementations of queue spinlock.
+ * The faster one can support only upto (16K-1) CPUs, but the lock
+ * word has to be 16 bits. The slower one requires a 8-bit lock word
+ * and can currently support (64K-1). However, it is possible to support
+ * more CPUs than the current limit, if necessary.
+ */
+#if !defined(QSPINLOCK_MANYCPUS) && (CONFIG_NR_CPUS >= (16*1024-1))
+#define QSPINLOCK_MANYCPUS
+#endif
+
+#ifdef QSPINLOCK_MANYCPUS
+#define	lock8	locked
+#else
+#define	lock16	locked
+#endif
+
+/*
+ * The queue spinlock data structure
+ * The lock word should always be the least significant portion of the
+ * 32-bit word.
+ */
+typedef struct qspinlock {
+	union {
+		u32		qlock;
+		struct {
+#ifdef __LITTLE_ENDIAN
+			union {
+				u8	lock8;	/* 8-bit lock word */
+				u16	lock16;	/* 16-bit lock word */
+			};
+			u16	qcode;		/* Wait queue code */
+#else
+			u16	qcode;		/* Wait queue code */
+			union {
+				struct {
+					u8	dummy;	/* Reserved	   */
+					u8	lock8;	/* 8-bit lock word */
+				};
+				u16		lock16;	/* 16-bit lock word */
+			};
+#endif
+		};
+	};
+} arch_spinlock_t;
+
+/* Remove the temporary lock8 or lock16 macro */
+#ifdef lock8
+#undef lock8
+#endif
+#ifdef lock16
+#undef lock16
+#endif
+
+#define QSPINLOCK_LOCKED	1
+
+/*
+ * The CONFIG_QSPINLOCK_UNFAIR config parameter breaks the FIFO fairness
+ * guarantee of the queue spinlock and allows some lock stealing to happen.
+ * This slight unfairness may increase the overall throughput and performance
+ * of the system in some circumstances. An example will be a virtual guest
+ * with over-commited CPUs. If a CPU at the queue head is suspended, other
+ * newly arrived CPUs wanting to get the lock may be able to get it while
+ * the others in the queue have to wait until the queue head process returns.
+ */
+#ifdef CONFIG_QSPINLOCK_UNFAIR
+#define	qlock_word	locked
+#else
+#define qlock_word	qlock
+#endif
+
+/*
+ * External function declarations
+ */
+extern void queue_spin_lock_slowpath(struct qspinlock *lock);
+#ifndef QSPINLOCK_MANYCPUS
+extern void queue_spin_unlock_slowpath(struct qspinlock *lock, u16 qcode);
+#endif
+
+/**
+ * queue_spin_is_locked - is the spinlock locked?
+ * @lock: Pointer to queue spinlock structure
+ * Return: 1 if it is locked, 0 otherwise
+ */
+static __always_inline int queue_spin_is_locked(struct qspinlock *lock)
+{
+	return ACCESS_ONCE(lock->locked);
+}
+
+/**
+ * queue_spin_is_contended - check if the lock is contended
+ * @lock : Pointer to queue spinlock structure
+ * Return: 1 if lock contended, 0 otherwise
+ */
+static __always_inline int queue_spin_is_contended(struct qspinlock *lock)
+{
+	return ACCESS_ONCE(lock->qcode);
+}
+/**
+ * queue_spin_trylock - try to acquire the queue spinlock
+ * @lock : Pointer to queue spinlock structure
+ * Return: 1 if lock acquired, 0 if failed
+ */
+static __always_inline int queue_spin_trylock(struct qspinlock *lock)
+{
+	if (!ACCESS_ONCE(lock->qlock_word) &&
+	   (cmpxchg(&lock->qlock_word, 0, QSPINLOCK_LOCKED) == 0))
+		return 1;
+	return 0;
+}
+
+/**
+ * queue_spin_lock - acquire a queue spinlock
+ * @lock: Pointer to queue spinlock structure
+ */
+static __always_inline void queue_spin_lock(struct qspinlock *lock)
+{
+	/*
+	 * To reduce memory access to only once for the cold cache case,
+	 * a direct cmpxchg() is performed in the fastpath to optimize the
+	 * uncontended case. The contended performance, however, may suffer
+	 * a bit because of that.
+	 */
+	if (likely(cmpxchg(&lock->qlock_word, 0, QSPINLOCK_LOCKED) == 0))
+		return;
+	queue_spin_lock_slowpath(lock);
+}
+
+/**
+ * queue_spin_unlock - release a queue spinlock
+ * @lock : Pointer to queue spinlock structure
+ */
+static __always_inline void queue_spin_unlock(struct qspinlock *lock)
+{
+	/*
+	 * This unlock function may get inlined into the caller. The
+	 * compiler barrier is needed to make sure that the lock will
+	 * not be released before changes to the critical section is done.
+	 * The ending smp_wmb() allows queue head process to get the lock ASAP.
+	 */
+	barrier();
+#ifndef QSPINLOCK_MANYCPUS
+	{
+		u16 qcode = ACCESS_ONCE(lock->locked);
+		if (unlikely(qcode != QSPINLOCK_LOCKED))
+			queue_spin_unlock_slowpath(lock, qcode);
+	}
+#endif
+	ACCESS_ONCE(lock->locked) = 0;
+	smp_wmb();
+}
+
+#undef qlock_word
+
+/*
+ * Initializier
+ */
+#define	__ARCH_SPIN_LOCK_UNLOCKED	{ { 0 } }
+
+#ifndef CONFIG_PARAVIRT_SPINLOCKS
+/*
+ * Remapping spinlock architecture specific functions to the corresponding
+ * queue spinlock functions.
+ */
+#define arch_spin_is_locked(l)		queue_spin_is_locked(l)
+#define arch_spin_is_contended(l)	queue_spin_is_contended(l)
+#define arch_spin_lock(l)		queue_spin_lock(l)
+#define arch_spin_trylock(l)		queue_spin_trylock(l)
+#define arch_spin_unlock(l)		queue_spin_unlock(l)
+#define arch_spin_lock_flags(l, f)	queue_spin_lock(l)
+#endif
+
+#endif /* __ASM_GENERIC_QSPINLOCK_H */
diff --git a/lib/Kconfig b/lib/Kconfig
index 71d9f81..d0306a0 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -410,6 +410,31 @@ config SIGNATURE
 	  Implementation is done using GnuPG MPI library
 
 #
+# Generic queue spinlock
+#
+config QSPINLOCK
+	bool "Use queue spinlock"
+	depends on ARCH_QSPINLOCK
+	default n
+	help
+	  This option enables an alternative spinlock implementation
+	  that has the same spinlock structure size but is more
+	  optimized for larger NUMA systems with a lot of CPU
+	  cores. Specifically, waiting lock spinners are put to wait
+	  in a queue on a local cacheline rather than all spinning
+	  on the same lock cacheline.
+
+config QSPINLOCK_UNFAIR
+	bool "Allow lock stealing in queue spinlock (EXPERIMENTAL)"
+	depends on QSPINLOCK
+	default n
+	help
+	  This option allows some lock stealing to happen and
+	  breaks the FIFO guarantee on which process will get the
+	  lock next. This kind of unfairness may help to improve
+	  performance for some workloads.
+
+#
 # libfdt files, only selected if needed.
 #
 config LIBFDT
diff --git a/lib/Makefile b/lib/Makefile
index 7baccfd..a557f8c 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -187,3 +187,4 @@ quiet_cmd_build_OID_registry = GEN     $@
 clean-files	+= oid_registry_data.c
 
 obj-$(CONFIG_UCS2_STRING) += ucs2_string.o
+obj-$(CONFIG_QSPINLOCK) += qspinlock.o
diff --git a/lib/qspinlock.c b/lib/qspinlock.c
new file mode 100644
index 0000000..2b65bec
--- /dev/null
+++ b/lib/qspinlock.c
@@ -0,0 +1,522 @@
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
+ * (C) Copyright 2013 Hewlett-Packard Development Company, L.P.
+ *
+ * Authors: Waiman Long <waiman.long@hp.com>
+ */
+#include <linux/smp.h>
+#include <linux/bug.h>
+#include <linux/cpumask.h>
+#include <linux/percpu.h>
+#include <linux/hardirq.h>
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
+ *
+ * To handle spinlock acquisition at interrupt context (softirq or hardirq),
+ * the queue node structure is actually an array for supporting nested spin
+ * locking operations in interrupt handlers. If all the entries in the
+ * array are used up, a warning message will be printed (as that shouldn't
+ * happen in normal circumstances) and the lock spinner will fall back to
+ * busy spinning instead of waiting in a queue.
+ *
+ * This queue spinlock implementation can be operated with the following 2
+ * sets of orthogonal operation modes:
+ * 1) Numerous CPU vs. normal CPU mode
+ * 2) Fair vs. lock stealing mode
+ *
+ * Numerous CPU mode is on when NR_CPUS >= 16K, otherwise the code will be
+ * in normal CPU mode. The differences between these 2 modes are:
+ * 1) 24 bits of the 32-bit lock word can be used to encode the queue node
+ *    address in numerous CPU mode whereas only 16 bits are used in normal
+ *    mode.
+ * 2) The normal mode allows unlock wakeup of the queue head, whereas in the
+ *    numerous CPU mode, the next queue head is always woken up at the end
+ *    of lock operation.
+ * 3) The performance should be a little bit better in the normal CPU mode.
+ *
+ * The ability to do unlock wakeup does slow down the unlock fastpath a little
+ * bit. However, that eliminates the remaining CPU that is actively spinning
+ * on the lock cacheline hindering lock holder performance if it needs to
+ * access the same cacheline as the lock. The queue code of the next node
+ * is stored in the 16-bit lock word if one is available before the current
+ * CPU gets the lock.
+ *
+ * In fair mode, the queue spinlock is almost as fair as the ticket spinlock.
+ * There is a small window between the lock acquisition failure and the setup
+ * of the qcode in the lock where lock stealing can happen if the lock holder
+ * releases the lock during that period. Other than that, lock acquisition is
+ * in straight FIFO order.
+ *
+ * In lock stealing mode, lock stealing can happen whenever the lock holder
+ * releases the lock. This can improve performance in certain workloads
+ * especially if the critical section is really short. It can also help in
+ * virtualized guests where the queue head CPU may be suspended preventing
+ * others from getting the lock without lock stealing.
+ *
+ * The selection of fair or lock stealing mode is controlled by the setting
+ * of QSPINLOCK_UNFAIR kernel config parameter.
+ */
+
+/*
+#ifndef CONFIG_DEBUG_SPINLOCK
+#define CONFIG_DEBUG_SPINLOCK 1
+#endif
+ */
+
+/*
+ * The queue node structure
+ *
+ * The used flag is used for synchronization between processs and initerrupt
+ * contexts of the same CPU. So it should be set first at initialization and
+ * cleared last in the cleanup code.
+ */
+struct qnode {
+	u8		 used;		/* Used flag		*/
+	u8		 wait;		/* Waiting flag		*/
+#ifndef QSPINLOCK_MANYCPUS
+	u16		 qcode;		/* Next queue node code	*/
+#endif
+	struct qnode	*next;		/* Next queue node addr */
+#ifdef	CONFIG_DEBUG_SPINLOCK
+	u16		 cpu_nr;	/* CPU number		*/
+	void		*lock;		/* Lock address		*/
+#endif
+};
+
+/*
+ * With 16K-1 CPUs or less, the 16-bit queue node code is divided into the
+ * following 2 fields:
+ * Bits 0-1 : queue node index (4 nodes)
+ * Bits 2-15: CPU number + 1   (16383 CPUs)
+ *
+ * A queue code of 0 indicates that no one is waiting on the lock. As the
+ * value 0 cannot be used as a valid CPU number. We need to add 1 to it
+ * before putting it into the queue code.
+ *
+ * With more CPUs (QSPINLOCK_MANYCPUS mode - currently limited to 64K-1),
+ * the queue node code is just the CPU number + 1. The bits in the 32-bit
+ * lock are allocated as follows:
+ * Bits 0-7: lock word
+ * Bits 8-15: queue node index (Only first 2 bits used - 4 nodes)
+ * Bits 16-31: CPU number + 1 (65535 CPUs)
+ *
+ * The CPU number limit can be extended even further. The only constraints
+ * are:
+ * 1) Bits 0-7 cannot be used other than for locking.
+ * 2) Bits 16-31 cannot be 0 if at least one CPU is queuing.
+ */
+#define MAX_QNODES		4
+#define	MAX_CPUS		(64*1024 - 1)
+#ifdef QSPINLOCK_MANYCPUS
+# define GET_QN_IDX(code)	(((code) >> 8) & 0xff)
+# define GET_CPU_NR(code)	(((code) >> 16) - 1)
+# define SET_QCODE(cpu, idx)	((((cpu) + 1) << 16) | ((idx) << 8) |\
+				 QSPINLOCK_LOCKED)
+# define SET_NODE_QCODE(node, code)
+# define QCODE_T		u32
+# define QCODE			qlock
+#else
+# define GET_QN_IDX(code)	((code) & 3)
+# define GET_CPU_NR(code)	(((code) >> 2) - 1)
+# define SET_QCODE(cpu, idx)	((((cpu) + 1) << 2) | idx)
+# define SET_NODE_QCODE(node, code) \
+		do { ACCESS_ONCE((node)->qcode) = (code); } while (0)
+# define QCODE_T		u16
+# define QCODE			qcode
+#endif
+
+/*
+ * Per-CPU queue node structures
+ */
+static DEFINE_PER_CPU(struct qnode [MAX_QNODES], qnodes) ____cacheline_aligned
+	= { { 0 } };
+
+/**
+ * xlate_qcode - translate the queue code into the queue node address
+ * @qcode: Queue code to be translated
+ * Return: The corresponding queue node address
+ */
+static inline struct qnode *xlate_qcode(QCODE_T qcode)
+{
+	u16 cpu_nr = GET_CPU_NR(qcode);
+	u16 qn_idx = GET_QN_IDX(qcode);
+
+	return per_cpu_ptr(&qnodes[qn_idx], cpu_nr);
+}
+
+/*
+ * Debugging macros & function
+ */
+#ifdef	CONFIG_DEBUG_SPINLOCK
+#define	ASSERT(cond)		BUG_ON(!(cond))
+#define	SET_NODE(var, val)	do { node->(var) = (val); } while (0)
+
+/**
+ * assert_nextnode - assert the next node is valid
+ * @next:   Pointer to the next node
+ * @lock:   Pointer to queue spinlock structure
+ * @cpu_nr: CPU number
+ */
+static noinline void
+assert_nextnode(struct qnode *next, struct qspinlock *lock, u16 cpu_nr)
+{
+	ASSERT(next->lock == (void *)lock);
+	ASSERT(next->wait);
+	ASSERT(next->used);
+}
+
+
+/**
+ * assert_prevnode - assert the previous node is valid
+ * @prev:   Pointer to the previous node
+ * @lock:   Pointer to queue spinlock structure
+ * @cpu_nr: CPU number
+ */
+static noinline void
+assert_prevnode(struct qnode *prev, struct qspinlock *lock, u16 cpu_nr)
+{
+	ASSERT(prev->cpu_nr != cpu_nr);
+	ASSERT(prev->lock == (void *)lock);
+	ASSERT(prev->used);
+	ASSERT(prev->next == NULL);
+#ifndef QSPINLOCK_MANYCPUS
+	ASSERT(prev->qcode == 0);
+#endif
+}
+
+#else
+#define	ASSERT(cond)
+#define	SET_NODE(var, val)
+#define	assert_nextnode(next, lock, cpu_nr)
+#define	assert_prevnode(prev, lock, cpu_nr)
+#endif
+
+/**
+ * unfair_trylock - try to acquire the lock ignoring the qcode
+ * @lock: Pointer to queue spinlock structure
+ * Return: 1 if lock acquired, 0 if failed
+ */
+static __always_inline int unfair_trylock(struct qspinlock *lock)
+{
+	if (!ACCESS_ONCE(lock->locked) &&
+	   (cmpxchg(&lock->locked, 0, QSPINLOCK_LOCKED) == 0))
+		return 1;
+	return 0;
+}
+
+/**
+ * init_node - initialize the queue node
+ * @node:   Pointer to queue node structure
+ * @lock:   Pointer to queue spinlock structure
+ * @cpu_nr: CPU number
+ *
+ * The used flag must be set before other fields.
+ */
+static inline void
+init_node(struct qnode *node, struct qspinlock *lock, u16 cpu_nr)
+{
+#ifdef QSPINLOCK_MANYCPUS
+	BUILD_BUG_ON(sizeof(lock->locked) != 1);
+#else
+	BUILD_BUG_ON(sizeof(lock->locked) != 2);
+#endif
+	ASSERT(!node->used);
+	node->used = true;
+	barrier();
+
+	ASSERT(!node->lock);
+	ASSERT(!node->next);
+	ASSERT(!node->wait);
+#ifndef QSPINLOCK_MANYCPUS
+	ASSERT(!node->qcode);
+#endif
+	node->wait = true;
+	node->next = NULL;
+	SET_NODE_QCODE(node, 0);
+	SET_NODE(cpu_nr, cpu_nr);
+	SET_NODE(lock, (void *)lock);
+}
+
+/**
+ * cleanup_node - Clean up the queue node
+ * @node:   Pointer to queue node structure
+ * @cpu_nr: CPU number
+ *
+ * The used flag must be the last one to be cleared.
+ */
+static inline void cleanup_node(struct qnode *node, u16 cpu_nr)
+{
+	node->next = NULL;
+	node->wait = false;
+	SET_NODE_QCODE(node, 0);
+	SET_NODE(lock, NULL);
+	ASSERT(cpu_nr == smp_processor_id());
+	barrier();
+	node->used = false;
+}
+
+/**
+ * queue_spin_lock_slowpath - acquire the queue spinlock
+ * @lock: Pointer to queue spinlock structure
+ */
+void queue_spin_lock_slowpath(struct qspinlock *lock)
+{
+	unsigned int cpu_nr, qn_idx;
+	struct qnode *node, *next = NULL;
+	QCODE_T prev_qcode, my_qcode;
+	u16 lockcode = QSPINLOCK_LOCKED;
+
+	/*
+	 * Current code cannot support more than 64K-1 CPUs
+	 */
+	BUILD_BUG_ON(CONFIG_NR_CPUS > MAX_CPUS);
+
+	/*
+	 * Get the queue node
+	 */
+	cpu_nr = smp_processor_id();
+	node   = this_cpu_ptr(&qnodes[0]);
+	qn_idx = 0;
+
+	if (unlikely(node->used)) {
+		/*
+		 * This node has been used, try to find an empty queue
+		 * node entry.
+		 */
+		for (qn_idx = 1; qn_idx < MAX_QNODES; qn_idx++)
+			if (!node[qn_idx].used)
+				break;
+		if (unlikely(qn_idx == MAX_QNODES)) {
+			/*
+			 * This shouldn't happen, print a warning message
+			 * & busy spinning on the lock.
+			 */
+			printk_sched(
+			  "qspinlock: queue node table exhausted at cpu %d!\n",
+			  cpu_nr);
+			while (!unfair_trylock(lock))
+				cpu_relax();
+			return;
+		}
+		/* Adjust node pointer */
+		node += qn_idx;
+	}
+
+	/*
+	 * Set up the new cpu code to be exchanged
+	 */
+	my_qcode = SET_QCODE(cpu_nr, qn_idx);
+
+	/*
+	 * The lock may be available at this point, try again before waiting
+	 * in a queue.
+	 */
+	if (queue_spin_trylock(lock))
+		return;
+
+	/*
+	 * Initialize the queue node
+	 */
+	init_node(node, lock, cpu_nr);
+
+	/*
+	 * Exchange current copy of the queue node code
+	 */
+	prev_qcode = xchg(&lock->QCODE, my_qcode);
+#ifdef QSPINLOCK_MANYCPUS
+	/*
+	 * In large NR_CPUS mode, it is possible that we may accidentally
+	 * steal the lock. If this is the case, we need to either release it
+	 * if not the head of the queue or get the lock and be done with it.
+	 */
+	if (unlikely(!(prev_qcode & QSPINLOCK_LOCKED))) {
+		if (prev_qcode == 0) {
+			/*
+			 * Got the lock since it is at the head of the queue
+			 * Now try to atomically clear the queue code.
+			 */
+			if (cmpxchg(&lock->QCODE, my_qcode, QSPINLOCK_LOCKED)
+				== my_qcode)
+				goto release_node;
+			/*
+			 * The cmpxchg fails only if one or more processes
+			 * are added to the queue. In this case, we need to
+			 * notify the next one to be the head of the queue.
+			 */
+			goto notify_next;
+		}
+		/*
+		 * Accidentally steal the lock, release the lock and
+		 * let the queue head get it.
+		 */
+		ACCESS_ONCE(lock->locked) = 0;
+		smp_wmb();
+	} else
+		prev_qcode &= ~QSPINLOCK_LOCKED;	/* Clear the lock bit */
+	my_qcode &= ~QSPINLOCK_LOCKED;
+	ASSERT((my_qcode   & 0xff) == 0);
+	ASSERT((prev_qcode & 0xff) == 0);
+#endif
+	if (prev_qcode) {
+		/*
+		 * Not at the queue head, get the address of the previous node
+		 * and setup the "next" & "qcode" fields of the previous node.
+		 */
+		struct qnode *prev = xlate_qcode(prev_qcode);
+
+		assert_prevnode(prev, lock, cpu_nr);
+		/*
+		 * The queue code should be set before the next pointer or
+		 * queue code assertion in init_node() may fail.
+		 */
+		SET_NODE_QCODE(prev, my_qcode);
+		ACCESS_ONCE(prev->next) = node;
+		smp_wmb();
+		/*
+		 * Wait until the waiting flag is off
+		 */
+		while (ACCESS_ONCE(node->wait))
+			cpu_relax();
+	}
+
+	/*
+	 * At the head of the wait queue now
+	 */
+	while (true) {
+		struct qspinlock old, new;
+
+		if (unlikely(!next)) {
+			/*
+			 * Get the next node & clean up current node, if
+			 * available.
+			 */
+			next = ACCESS_ONCE(node->next);
+			if (next) {
+#ifndef QSPINLOCK_MANYCPUS
+				u16 qcode = ACCESS_ONCE(node->qcode);
+
+				while (unlikely(!qcode)) {
+					cpu_relax();
+					qcode = ACCESS_ONCE(node->qcode);
+				}
+				lockcode = qcode;
+#endif
+				assert_nextnode(next, lock, cpu_nr);
+				cleanup_node(node, cpu_nr);
+				node = NULL;
+			}
+		}
+		old.qlock = ACCESS_ONCE(lock->qlock);
+		if (old.locked)
+			;	/* Lock not available yet */
+		else if (old.QCODE != my_qcode) {
+			/*
+			 * Just get the lock with other waiting processes
+			 */
+			if (cmpxchg(&lock->locked, 0, lockcode) == 0) {
+				/*
+				 * If lockcode is not QSPINLOCK_LOCKED, node
+				 * has been freed and we can return without
+				 * doing anything.
+				 */
+				if (lockcode != QSPINLOCK_LOCKED)
+					return;
+				break;	/* May need to set up the next node */
+			}
+		} else {
+			/*
+			 * Get the lock & clear the queue code simultaneously
+			 */
+			new.qlock  = 0;
+			new.locked = QSPINLOCK_LOCKED;
+			if (cmpxchg(&lock->qlock, old.qlock, new.qlock)
+				== old.qlock) {
+				ASSERT(!next);
+				goto release_node;
+			}
+		}
+		cpu_relax();
+	}
+
+#ifdef QSPINLOCK_MANYCPUS
+notify_next:
+#endif
+	/*
+	 * If the next pointer is not set, we need to wait and notify the
+	 * next one in line to do busy spinning.
+	 */
+	if (unlikely(!next)) {
+		/*
+		 * Wait until the next one in queue set up the next field
+		 */
+		while (!(next = ACCESS_ONCE(node->next)))
+			cpu_relax();
+		assert_nextnode(next, lock, cpu_nr);
+	}
+	/*
+	 * The next one in queue is now at the head
+	 */
+	ACCESS_ONCE(next->wait) = false;
+	smp_wmb();
+
+release_node:
+	if (node)
+		cleanup_node(node, cpu_nr);
+}
+EXPORT_SYMBOL(queue_spin_lock_slowpath);
+
+#ifndef QSPINLOCK_MANYCPUS
+/**
+ * queue_spin_lock_slowpath - notify the next one in the queue to get lock
+ * @lock : Pointer to queue spinlock structure
+ * @qcode: Queue code of the next node to be woken up
+ */
+void queue_spin_unlock_slowpath(struct qspinlock *lock, u16 qcode)
+{
+	struct qnode *next = xlate_qcode(qcode);
+
+	assert_nextnode(next, lock, smp_processor_id());
+	ACCESS_ONCE(next->wait) = false;
+	/*
+	 * An smp_wmb() call will be issued at the end of the fastpath, so
+	 * we don't need one here.
+	 */
+}
+EXPORT_SYMBOL(queue_spin_unlock_slowpath);
+#endif
-- 
1.7.1

