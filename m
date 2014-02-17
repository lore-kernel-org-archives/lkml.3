Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988AbaBQUmJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 15:42:09 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:29942 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbaBQUmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 15:42:04 -0500
From: Waiman Long <Waiman.Long@hp.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
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
        Daniel J Blueman <daniel@numascale.com>,
        Alexander Fyodorov <halcy@yandex.ru>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>,
        Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>,
        Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH v4 1/3] qspinlock: Introducing a 4-byte queue spinlock implementation
Date: Mon, 17 Feb 2014 15:41:22 -0500
Message-Id: <1392669684-4807-2-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1392669684-4807-1-git-send-email-Waiman.Long@hp.com>
References: <1392669684-4807-1-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a new queue spinlock implementation that can
serve as an alternative to the default ticket spinlock. Compared with
the ticket spinlock, this queue spinlock should be almost as fair as
the ticket spinlock. It has about the same speed in single-thread and
it can be much faster in high contention situations. Only in light to
moderate contention where the average queue depth is around 1-3 will
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

The current queue node address encoding of the 4-byte word is as
follows:
Bits 0-7  : the locked byte
Bits 8-9  : queue node index in the per-cpu array (4 entries)
Bits 10-31: cpu number + 1 (max cpus = 4M -1)

In the extremely unlikely case that all the queue node entries are
used up, the current code will fall back to busy spinning without
waiting in a queue with warning message.

For single-thread performance (no contention), a 256K lock/unlock
loop was run on a 2.4Ghz Westmere x86-64 CPU.  The following table
shows the average time (in ns) for a single lock/unlock sequence
(including the looping and timing overhead):

  Lock Type			Time (ns)
  ---------			---------
  Ticket spinlock		  14.1
  Queue spinlock		   8.8

So the queue spinlock is much faster than the ticket spinlock, even
though the overhead of locking and unlocking should be pretty small
when there is no contention. The performance advantage is mainly
due to the fact that ticket spinlock does a read-modify-write (add)
instruction in unlock whereas queue spinlock only does a simple write
in unlock which can be much faster in a pipelined CPU.

The AIM7 benchmark was run on a 8-socket 80-core DL980 with Westmere
x86-64 CPUs with XFS filesystem on a ramdisk and HT off to evaluate
the performance impact of this patch on a 3.13 kernel.

  +------------+----------+-----------------+---------+
  | Kernel     | 3.13 JPM |    3.13 with    | %Change |
  |            |          | qspinlock patch |	      |
  +------------+----------+-----------------+---------+
  |		      10-100 users		      |
  +------------+----------+-----------------+---------+
  |custom      |   357459 |      363109     |  +1.58% |
  |dbase       |   496847 |      498801	    |  +0.39% |
  |disk        |  2925312 |     2771387     |  -5.26% |
  |five_sec    |   166612 |      169215     |  +1.56% |
  |fserver     |   382129 |      383279     |  +0.30% |
  |high_systime|    16356 |       16380     |  +0.15% |
  |short       |  4521978 |     4257363     |  -5.85% |
  +------------+----------+-----------------+---------+
  |		     200-1000 users		      |
  +------------+----------+-----------------+---------+
  |custom      |   449070 |      447711     |  -0.30% |
  |dbase       |   845029 |      853362	    |  +0.99% |
  |disk        |  2725249 |     4892907     | +79.54% |
  |five_sec    |   169410 |      170638     |  +0.72% |
  |fserver     |   489662 |      491828     |  +0.44% |
  |high_systime|   142823 |      143790     |  +0.68% |
  |short       |  7435288 |     9016171     | +21.26% |
  +------------+----------+-----------------+---------+
  |		     1100-2000 users		      |
  +------------+----------+-----------------+---------+
  |custom      |   432470 |      432570     |  +0.02% |
  |dbase       |   889289 |      890026	    |  +0.08% |
  |disk        |  2565138 |     5008732     | +95.26% |
  |five_sec    |   169141 |      170034     |  +0.53% |
  |fserver     |   498569 |      500701     |  +0.43% |
  |high_systime|   229913 |      245866     |  +6.94% |
  |short       |  8496794 |     8281918     |  -2.53% |
  +------------+----------+-----------------+---------+

The workload with the most gain was the disk workload. Without the
patch, the perf profile at 1500 users looked like:

 26.19%    reaim  [kernel.kallsyms]  [k] _raw_spin_lock
              |--47.28%-- evict
              |--46.87%-- inode_sb_list_add
              |--1.24%-- xlog_cil_insert_items
              |--0.68%-- __remove_inode_hash
              |--0.67%-- inode_wait_for_writeback
               --3.26%-- [...]
 22.96%  swapper  [kernel.kallsyms]  [k] cpu_idle_loop
  5.56%    reaim  [kernel.kallsyms]  [k] mutex_spin_on_owner
  4.87%    reaim  [kernel.kallsyms]  [k] update_cfs_rq_blocked_load
  2.04%    reaim  [kernel.kallsyms]  [k] mspin_lock
  1.30%    reaim  [kernel.kallsyms]  [k] memcpy
  1.08%    reaim  [unknown]          [.] 0x0000003c52009447

There was pretty high spinlock contention on the inode_sb_list_lock
and maybe the inode's i_lock.

With the patch, the perf profile at 1500 users became:

 26.82%  swapper  [kernel.kallsyms]  [k] cpu_idle_loop
  4.66%    reaim  [kernel.kallsyms]  [k] mutex_spin_on_owner
  3.97%    reaim  [kernel.kallsyms]  [k] update_cfs_rq_blocked_load
  2.40%    reaim  [kernel.kallsyms]  [k] queue_spin_lock_slowpath
              |--88.31%-- _raw_spin_lock
              |          |--36.02%-- inode_sb_list_add
              |          |--35.09%-- evict
              |          |--16.89%-- xlog_cil_insert_items
              |          |--6.30%-- try_to_wake_up
              |          |--2.20%-- _xfs_buf_find
              |          |--0.75%-- __remove_inode_hash
              |          |--0.72%-- __mutex_lock_slowpath
              |          |--0.53%-- load_balance
              |--6.02%-- _raw_spin_lock_irqsave
              |          |--74.75%-- down_trylock
              |          |--9.69%-- rcu_check_quiescent_state
              |          |--7.47%-- down
              |          |--3.57%-- up
              |          |--1.67%-- rwsem_wake
              |          |--1.00%-- remove_wait_queue
              |          |--0.56%-- pagevec_lru_move_fn
              |--5.39%-- _raw_spin_lock_irq
              |          |--82.05%-- rwsem_down_read_failed
              |          |--10.48%-- rwsem_down_write_failed
              |          |--4.24%-- __down
              |          |--2.74%-- __schedule
               --0.28%-- [...]
  2.20%    reaim  [kernel.kallsyms]  [k] memcpy
  1.84%    reaim  [unknown]          [.] 0x000000000041517b
  1.77%    reaim  [kernel.kallsyms]  [k] _raw_spin_lock
              |--21.08%-- xlog_cil_insert_items
              |--10.14%-- xfs_icsb_modify_counters
              |--7.20%-- xfs_iget_cache_hit
              |--6.56%-- inode_sb_list_add
              |--5.49%-- _xfs_buf_find
              |--5.25%-- evict
              |--5.03%-- __remove_inode_hash
              |--4.64%-- __mutex_lock_slowpath
              |--3.78%-- selinux_inode_free_security
              |--2.95%-- xfs_inode_is_filestream
              |--2.35%-- try_to_wake_up
              |--2.07%-- xfs_inode_set_reclaim_tag
              |--1.52%-- list_lru_add
              |--1.16%-- xfs_inode_clear_eofblocks_tag
		  :
  1.30%    reaim  [kernel.kallsyms]  [k] effective_load
  1.27%    reaim  [kernel.kallsyms]  [k] mspin_lock
  1.10%    reaim  [kernel.kallsyms]  [k] security_compute_sid

On the ext4 filesystem, the disk workload improved from 416281 JPM
to 899101 JPM (+116%) with the patch. In this case, the contended
spinlock is the mb_cache_spinlock.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
Acked-by: Rik van Riel <riel@redhat.com>
---
 include/asm-generic/qspinlock.h       |  122 ++++++++++++
 include/asm-generic/qspinlock_types.h |   43 ++++
 kernel/Kconfig.locks                  |    7 +
 kernel/locking/Makefile               |    1 +
 kernel/locking/qspinlock.c            |  353 +++++++++++++++++++++++++++++++++
 5 files changed, 526 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-generic/qspinlock.h
 create mode 100644 include/asm-generic/qspinlock_types.h
 create mode 100644 kernel/locking/qspinlock.c

diff --git a/include/asm-generic/qspinlock.h b/include/asm-generic/qspinlock.h
new file mode 100644
index 0000000..d2196ed
--- /dev/null
+++ b/include/asm-generic/qspinlock.h
@@ -0,0 +1,122 @@
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
+/*
+ * External function declarations
+ */
+extern void queue_spin_lock_slowpath(struct qspinlock *lock, int qsval);
+
+/**
+ * queue_spin_is_locked - is the spinlock locked?
+ * @lock: Pointer to queue spinlock structure
+ * Return: 1 if it is locked, 0 otherwise
+ */
+static __always_inline int queue_spin_is_locked(struct qspinlock *lock)
+{
+	return _QLOCK(lock);
+}
+
+/**
+ * queue_spin_value_unlocked - is the spinlock structure unlocked?
+ * @lock: queue spinlock structure
+ * Return: 1 if it is unlocked, 0 otherwise
+ */
+static __always_inline int queue_spin_value_unlocked(struct qspinlock lock)
+{
+	return !_QLOCK(&lock);
+}
+
+/**
+ * queue_spin_is_contended - check if the lock is contended
+ * @lock : Pointer to queue spinlock structure
+ * Return: 1 if lock contended, 0 otherwise
+ */
+static __always_inline int queue_spin_is_contended(struct qspinlock *lock)
+{
+	return _QCODE(lock);
+}
+/**
+ * queue_spin_trylock - try to acquire the queue spinlock
+ * @lock : Pointer to queue spinlock structure
+ * Return: 1 if lock acquired, 0 if failed
+ */
+static __always_inline int queue_spin_trylock(struct qspinlock *lock)
+{
+	if (!atomic_read(&lock->qlcode) &&
+	   (atomic_cmpxchg(&lock->qlcode, 0, _QSPINLOCK_LOCKED) == 0))
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
+	int qsval;
+
+	/*
+	 * To reduce memory access to only once for the cold cache case,
+	 * a direct cmpxchg() is performed in the fastpath to optimize the
+	 * uncontended case. The contended performance, however, may suffer
+	 * a bit because of that.
+	 */
+	qsval = atomic_cmpxchg(&lock->qlcode, 0, _QSPINLOCK_LOCKED);
+	if (likely(qsval == 0))
+		return;
+	queue_spin_lock_slowpath(lock, qsval);
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
+	 * Use an atomic subtraction to clear the lock bit.
+	 */
+	smp_mb__before_atomic_dec();
+	atomic_sub(_QSPINLOCK_LOCKED, &lock->qlcode);
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
index 0000000..e8cc9ca
--- /dev/null
+++ b/include/asm-generic/qspinlock_types.h
@@ -0,0 +1,43 @@
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
+#include <linux/types.h>
+#include <linux/atomic.h>
+#include <asm/barrier.h>
+#include <asm/processor.h>
+
+/*
+ * The queue spinlock data structure - a 32-bit word
+ *
+ * The bits assignment are:
+ *   Bit  0   : Set if locked
+ *   Bits 1-7 : Not used
+ *   Bits 8-31: Queue code
+ */
+typedef struct qspinlock {
+	atomic_t	qlcode;	/* Lock + queue code */
+} arch_spinlock_t;
+
+#define _QCODE_OFFSET		8
+#define _QSPINLOCK_LOCKED	1U
+#define	_QCODE(lock)	(atomic_read(&(lock)->qlcode) >> _QCODE_OFFSET)
+#define	_QLOCK(lock)	(atomic_read(&(lock)->qlcode) & _QSPINLOCK_LOCKED)
+
+#endif /* __ASM_GENERIC_QSPINLOCK_TYPES_H */
diff --git a/kernel/Kconfig.locks b/kernel/Kconfig.locks
index d2b32ac..df71bfa 100644
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
+	depends on SMP && !PARAVIRT
diff --git a/kernel/locking/Makefile b/kernel/locking/Makefile
index baab8e5..1a17380 100644
--- a/kernel/locking/Makefile
+++ b/kernel/locking/Makefile
@@ -23,3 +23,4 @@ obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock_debug.o
 obj-$(CONFIG_RWSEM_GENERIC_SPINLOCK) += rwsem-spinlock.o
 obj-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem-xadd.o
 obj-$(CONFIG_PERCPU_RWSEM) += percpu-rwsem.o
+obj-$(CONFIG_QUEUE_SPINLOCK) += qspinlock.o
diff --git a/kernel/locking/qspinlock.c b/kernel/locking/qspinlock.c
new file mode 100644
index 0000000..fab9819
--- /dev/null
+++ b/kernel/locking/qspinlock.c
@@ -0,0 +1,353 @@
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
+#include <linux/spinlock.h>
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
+ */
+
+/*
+ * The queue node structure
+ *
+ * This structure is essentially the same as the mcs_spinlock structure
+ * in mcs_spinlock.h file. This structure is retained for future extension
+ * where new fields may be added.
+ */
+struct qnode {
+	u32		 wait;		/* Waiting flag		*/
+	struct qnode	*next;		/* Next queue node addr */
+};
+
+/*
+ * The 24-bit queue node code is divided into the following 2 fields:
+ * Bits 0-1 : queue node index (4 nodes)
+ * Bits 2-23: CPU number + 1   (4M - 1 CPUs)
+ *
+ * The 16-bit queue node code is divided into the following 2 fields:
+ * Bits 0-1 : queue node index (4 nodes)
+ * Bits 2-15: CPU number + 1   (16K - 1 CPUs)
+ *
+ * A queue node code of 0 indicates that no one is waiting for the lock.
+ * As the value 0 cannot be used as a valid CPU number. We need to add
+ * 1 to it before putting it into the queue code.
+ */
+#ifndef _QCODE_VAL_OFFSET
+#define _QCODE_VAL_OFFSET	_QCODE_OFFSET
+#endif
+#define MAX_QNODES		4
+#define GET_QN_IDX(code)	(((code) >> _QCODE_VAL_OFFSET) & 3)
+#define GET_CPU_NR(code)	(((code) >> (_QCODE_VAL_OFFSET + 2)) - 1)
+#ifndef _SET_QCODE
+#define _SET_QCODE(cpu, idx)	((((cpu) + 1) << (_QCODE_VAL_OFFSET + 2)) |\
+				((idx) << _QCODE_VAL_OFFSET) |\
+				 _QSPINLOCK_LOCKED)
+#endif
+
+struct qnode_set {
+	int		node_idx;	/* Current node to use */
+	struct qnode	nodes[MAX_QNODES];
+};
+
+/*
+ * Per-CPU queue node structures
+ */
+static DEFINE_PER_CPU(struct qnode_set, qnset) ____cacheline_aligned
+	= { 0 };
+
+/**
+ * xlate_qcode - translate the queue code into the queue node address
+ * @qcode: Queue code to be translated
+ * Return: The corresponding queue node address
+ */
+static inline struct qnode *xlate_qcode(u32 qcode)
+{
+	u32 cpu_nr = GET_CPU_NR(qcode);
+	u8  qn_idx = GET_QN_IDX(qcode);
+
+	return per_cpu_ptr(&qnset.nodes[qn_idx], cpu_nr);
+}
+
+#ifndef queue_spin_trylock_unfair
+/**
+ * queue_spin_trylock_unfair - try to acquire the lock ignoring the qcode
+ * @lock: Pointer to queue spinlock structure
+ * Return: 1 if lock acquired, 0 if failed
+ */
+static __always_inline int queue_spin_trylock_unfair(struct qspinlock *lock)
+{
+	int qlcode = atomic_read(lock->qlcode);
+
+	if (!(qlcode & _QSPINLOCK_LOCKED) && (atomic_cmpxchg(&lock->qlcode,
+		qlcode, qlcode|_QSPINLOCK_LOCKED) == qlcode))
+			return 1;
+	return 0;
+}
+#endif /* queue_spin_trylock_unfair */
+
+#ifndef queue_get_lock_qcode
+/**
+ * queue_get_lock_qcode - get the lock & qcode values
+ * @lock  : Pointer to queue spinlock structure
+ * @qcode : Pointer to the returned qcode value
+ * @mycode: My qcode value (not used)
+ * Return : > 0 if lock is not available, = 0 if lock is free
+ */
+static inline int
+queue_get_lock_qcode(struct qspinlock *lock, u32 *qcode, u32 mycode)
+{
+	int qlcode = atomic_read(&lock->qlcode);
+
+	*qcode = qlcode;
+	return qlcode & _QSPINLOCK_LOCKED;
+}
+#endif /* queue_get_lock_qcode */
+
+#ifndef queue_spin_trylock_and_clr_qcode
+/**
+ * queue_spin_trylock_and_clr_qcode - Try to lock & clear qcode simultaneously
+ * @lock : Pointer to queue spinlock structure
+ * @qcode: The supposedly current qcode value
+ * Return: true if successful, false otherwise
+ */
+static inline int
+queue_spin_trylock_and_clr_qcode(struct qspinlock *lock, u32 qcode)
+{
+	return atomic_cmpxchg(&lock->qlcode, qcode, _QSPINLOCK_LOCKED) == qcode;
+}
+#endif /* queue_spin_trylock_and_clr_qcode */
+
+/**
+ * get_qnode - Get a queue node address
+ * @qn_idx: Pointer to queue node index [out]
+ * Return : queue node address & queue node index in qn_idx, or NULL if
+ *	    no free queue node available.
+ */
+static struct qnode *get_qnode(unsigned int *qn_idx)
+{
+	struct qnode_set *qset = this_cpu_ptr(&qnset);
+	int i;
+
+	if (unlikely(qset->node_idx >= MAX_QNODES))
+		return NULL;
+	i = qset->node_idx++;
+	*qn_idx = i;
+	return &qset->nodes[i];
+}
+
+/**
+ * put_qnode - Return a queue node to the pool
+ */
+static void put_qnode(void)
+{
+	struct qnode_set *qset = this_cpu_ptr(&qnset);
+
+	qset->node_idx--;
+}
+
+/**
+ * queue_spin_lock_slowpath - acquire the queue spinlock
+ * @lock : Pointer to queue spinlock structure
+ * @qsval: Current value of the queue spinlock 32-bit word
+ */
+void queue_spin_lock_slowpath(struct qspinlock *lock, int qsval)
+{
+	unsigned int cpu_nr, qn_idx;
+	struct qnode *node, *next;
+	u32 prev_qcode, my_qcode;
+
+#ifdef queue_spin_trylock_quick
+	/*
+	 * Try the quick spinning code path
+	 */
+	if (queue_spin_trylock_quick(lock, qsval))
+		return;
+#endif
+	/*
+	 * Get the queue node
+	 */
+	cpu_nr = smp_processor_id();
+	node   = get_qnode(&qn_idx);
+
+	if (unlikely(!node)) {
+		/*
+		 * This shouldn't happen, print a warning message
+		 * & busy spinning on the lock.
+		 */
+		printk_sched(
+		  "qspinlock: queue node table exhausted at cpu %d!\n",
+		  cpu_nr);
+		while (!queue_spin_trylock_unfair(lock))
+			arch_mutex_cpu_relax();
+		return;
+	}
+
+	/*
+	 * Set up the new cpu code to be exchanged
+	 */
+	my_qcode = _SET_QCODE(cpu_nr, qn_idx);
+
+	/*
+	 * Initialize the queue node
+	 */
+	node->wait = true;
+	node->next = NULL;
+
+	/*
+	 * The lock may be available at this point, try again if no task was
+	 * waiting in the queue.
+	 */
+	if (!(qsval >> _QCODE_OFFSET) && queue_spin_trylock(lock)) {
+		put_qnode();
+		return;
+	}
+
+#ifdef queue_code_xchg
+	prev_qcode = queue_code_xchg(lock, my_qcode);
+#else
+	/*
+	 * Exchange current copy of the queue node code
+	 */
+	prev_qcode = atomic_xchg(&lock->qlcode, my_qcode);
+	/*
+	 * It is possible that we may accidentally steal the lock. If this is
+	 * the case, we need to either release it if not the head of the queue
+	 * or get the lock and be done with it.
+	 */
+	if (unlikely(!(prev_qcode & _QSPINLOCK_LOCKED))) {
+		if (prev_qcode == 0) {
+			/*
+			 * Got the lock since it is at the head of the queue
+			 * Now try to atomically clear the queue code.
+			 */
+			if (atomic_cmpxchg(&lock->qlcode, my_qcode,
+					  _QSPINLOCK_LOCKED) == my_qcode)
+				goto release_node;
+			/*
+			 * The cmpxchg fails only if one or more tasks
+			 * are added to the queue. In this case, we need to
+			 * notify the next one to be the head of the queue.
+			 */
+			goto notify_next;
+		}
+		/*
+		 * Accidentally steal the lock, release the lock and
+		 * let the queue head get it.
+		 */
+		queue_spin_unlock(lock);
+	} else
+		prev_qcode &= ~_QSPINLOCK_LOCKED;	/* Clear the lock bit */
+	my_qcode &= ~_QSPINLOCK_LOCKED;
+#endif /* queue_code_xchg */
+
+	if (prev_qcode) {
+		/*
+		 * Not at the queue head, get the address of the previous node
+		 * and set up the "next" fields of the that node.
+		 */
+		struct qnode *prev = xlate_qcode(prev_qcode);
+
+		ACCESS_ONCE(prev->next) = node;
+		/*
+		 * Wait until the waiting flag is off
+		 */
+		while (smp_load_acquire(&node->wait))
+			arch_mutex_cpu_relax();
+	}
+
+	/*
+	 * At the head of the wait queue now
+	 */
+	while (true) {
+		u32 qcode;
+		int retval;
+
+		retval = queue_get_lock_qcode(lock, &qcode, my_qcode);
+		if (retval > 0)
+			;	/* Lock not available yet */
+		else if (retval < 0)
+			/* Lock taken, can release the node & return */
+			goto release_node;
+		else if (qcode != my_qcode) {
+			/*
+			 * Just get the lock with other spinners waiting
+			 * in the queue.
+			 */
+			if (queue_spin_trylock_unfair(lock))
+				goto notify_next;
+		} else {
+			/*
+			 * Get the lock & clear the queue code simultaneously
+			 */
+			if (queue_spin_trylock_and_clr_qcode(lock, qcode))
+				/* No need to notify the next one */
+				goto release_node;
+		}
+		arch_mutex_cpu_relax();
+	}
+
+notify_next:
+	/*
+	 * Wait, if needed, until the next one in queue set up the next field
+	 */
+	while (!(next = ACCESS_ONCE(node->next)))
+		arch_mutex_cpu_relax();
+	/*
+	 * The next one in queue is now at the head
+	 */
+	smp_store_release(&next->wait, false);
+
+release_node:
+	put_qnode();
+}
+EXPORT_SYMBOL(queue_spin_lock_slowpath);
-- 
1.7.1

