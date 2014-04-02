Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758856AbaDBN2o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 09:28:44 -0400
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:46678 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758798AbaDBN2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 09:28:37 -0400
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
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>,
        Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH v8 04/10] qspinlock: Optimized code path for 2 contending tasks
Date: Wed,  2 Apr 2014 09:27:33 -0400
Message-Id: <1396445259-27670-5-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1396445259-27670-1-git-send-email-Waiman.Long@hp.com>
References: <1396445259-27670-1-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A major problem with the queue spinlock patch is its performance at
low contention level (2-4 contending tasks) where it is slower than
the corresponding ticket spinlock code. The following table shows
the execution time (in ms) of a micro-benchmark where 5M iterations
of the lock/unlock cycles were run on a 10-core Westere-EX x86-64
CPU with 2 different types of loads - standalone (lock and protected
data in different cachelines) and embedded (lock and protected data
in the same cacheline).

		  [Standalone/Embedded]
  # of tasks	Ticket lock	Queue lock	%Change
  ----------	-----------	----------	-------
       1	  135/111	 135/101	  0%/-9%
       2	 1045/950	1884/1853	+80%/+95%
       3	 1827/1783	2256/2264	+23%/+27%
       4	 2689/2725	2880/2884	 +7%/+6%
       5	 3736/3748	3636/3617	 -3%/-3%
       6	 4942/4984	4294/4253	-13%/-15%
       7	 6304/6319	4976/4958	-21%/-22%
       8	 7736/7629	5662/5651	-27%/-26%

It can be seen that the performance degradation is particular bad
with 2 and 3 contending tasks. To reduce that performance deficit
at low contention level, a special specific optimized code path
for 2 contending tasks was added. This special code path can only be
activated with less than 16K of configured CPUs because it uses a byte
in the 32-bit lock word to hold a waiting bit for the 2nd contending
tasks instead of queuing the waiting task in the queue.

With the change, the performance data became:

		  [Standalone/Embedded]
  # of tasks	Ticket lock	Queue lock	%Change
  ----------	-----------	----------	-------
       2	 1045/950	 951/955	 -9%/+1%

In a multi-socketed server, the optimized code path also seems to
produce a pretty good performance improvement in cross-node contention
traffic at low contention level. The table below show the performance
with 1 contending task per node:

		[Standalone]
  # of nodes	Ticket lock	Queue lock	%Change
  ----------	-----------	----------	-------
       1	   135		  135		  0%
       2	  4452		 1024		-77%
       3	 10767		14030		+30%
       4	 20835		10740		-48%

Except some drop in performance at the 3 contending tasks level,
the queue spinlock performs much better than the ticket spinlock at
2 and 4 contending tasks level.

With IvyBridge-EX (2.8 GHz), the performance profile of qspinlock vs
ticket spinlock changes quite a bit due to the fact that the pause
instruction in IvyBridge-EX is about 3 times as long as that in
Westmere-EX (25 cycles vs. 8 cycles according to my measurement). So
spinning on the lock word by the ticket spinlock is less problematic
in IvyBridge-EX.

The table below shows the results of the same low-level spinlock test
run on one socket of IvyBridge-EX (15 cores, 1M iterations instead
of 5M):

		  [Standalone/Embedded]
  # of tasks	Ticket lock	Queue lock	%Change
  ----------	-----------	----------	-------
       1	   59/48	  56/42		 -5%/-13%
       2	  514/487	 289/345	-44%/-29%
       3	  812/768	1048/1053	+29%/+37%
       4	 1136/1077	1219/1220	 +7%/+13%
       5	 1464/1398	1560/1581	 +7%/+13%
       6	 1806/1787	1952/1959	 +8%/+10%
       7	 2185/2204	2360/2377	 +8%/ +8%
       8	 2582/2656	2759/2747	 +7%/ +3%
       9	 2979/3131	3120/3103	 +5%/ -1%
      10	 3398/3602	3484/3498	 +3%/ -3%
      11	 3848/4110	3807/3829	 -1%/ -7%
      12	 4326/4655	4132/4117	 -4%/-12%

The queue spinlock is still faster than the ticket spinlock with 1 or
2 contending tasks (light spinlock contention). After that, ticket
spinlock is faster (moderate spinlock contention) until there are
11 or more contending tasks for a standalone spinlock or 9 or more
contending tasks for an embedded spinlocks.

The table below shows the performance profile when there is one
contending task are from each of the different nodes in an 8-node
prototype IvyBridge-EX machine:

		[Standalone]
  # of nodes	Ticket lock	Queue lock	%Change
  ----------	-----------	----------	-------
       2	   532		  503		 -5%
       3	  2449		 3812		+56%
       4	  6211		 4571		-26%
       5	  8606		 6104		-29%
       6	  9011		 7641		-15%
       7	 12907		 8373		-35%
       8	 15094		10259		-32%

There is some performance drop at the 3 contending tasks level.
Other than that, queue spinlock is faster than ticket spinlock.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 arch/x86/include/asm/qspinlock.h |    3 +-
 kernel/locking/qspinlock.c       |  212 +++++++++++++++++++++++++++++++++-----
 2 files changed, 187 insertions(+), 28 deletions(-)

diff --git a/arch/x86/include/asm/qspinlock.h b/arch/x86/include/asm/qspinlock.h
index f058b91..265b10b 100644
--- a/arch/x86/include/asm/qspinlock.h
+++ b/arch/x86/include/asm/qspinlock.h
@@ -21,9 +21,10 @@ union arch_qspinlock {
 	struct qspinlock slock;
 	struct {
 		u8  lock;	/* Lock bit	*/
-		u8  reserved;
+		u8  wait;	/* Waiting bit	*/
 		u16 qcode;	/* Queue code	*/
 	};
+	u16 lock_wait;		/* Lock and wait bits */
 	u32 qlcode;		/* Complete lock word */
 };
 
diff --git a/kernel/locking/qspinlock.c b/kernel/locking/qspinlock.c
index 45c68a4..cf16bba 100644
--- a/kernel/locking/qspinlock.c
+++ b/kernel/locking/qspinlock.c
@@ -121,6 +121,8 @@ static DEFINE_PER_CPU_ALIGNED(struct qnode_set, qnset) = { { { 0 } }, 0 };
  *      o lock      - the lock byte					*
  *      o qcode     - the queue node code				*
  *      o qlcode    - the 32-bit qspinlock word				*
+ *      o wait      - the waiting byte					*
+ *      o lock_wait - the combined lock and waiting bytes		*
  *									*
  ************************************************************************
  */
@@ -131,9 +133,135 @@ static DEFINE_PER_CPU_ALIGNED(struct qnode_set, qnset) = { { { 0 } }, 0 };
  * architectures that allows atomic 8/16 bit operations:
  *  1) The 16-bit queue code can be accessed or modified directly as a
  *     16-bit short value without disturbing the first 2 bytes.
+ *  2) The 2nd byte of the 32-bit lock word can be used as a pending bit
+ *     for waiting lock acquirer so that it won't need to go through the
+ *     MCS style locking queuing which has a higher overhead.
  */
+
+/*
+ * Masks for the lock and wait bits
+ */
+#define _QLOCK_WAIT_SHIFT	8	/* Waiting bit position */
+#define _QLOCK_WAITING		(1 << _QLOCK_WAIT_SHIFT)
+#define _QLOCK_LW_MASK		(_QLOCK_WAITING | _QLOCK_LOCKED)
+
 #define queue_encode_qcode(cpu, idx)	(((cpu) + 1) << 2 | (idx))
 
+#define queue_spin_trylock_quick queue_spin_trylock_quick
+/**
+ * queue_spin_trylock_quick - quick spinning on the queue spinlock
+ * @lock : Pointer to queue spinlock structure
+ * @qsval: Old queue spinlock value
+ * Return: 1 if lock acquired, 0 if failed
+ *
+ * This is an optimized contention path for 2 contending tasks. It
+ * should only be entered if no task is waiting in the queue.
+ *
+ * The lock and wait bits can be in one of following 4 states:
+ *
+ * State lock wait
+ * ----- ---------
+ *  [0]   0    0	Lock is free and no one is waiting
+ *  [1]   1    0	Lock is not available, but no one is waiting
+ *  [2]   0    1	Lock is free, but a waiter is present
+ *  [3]   1    1	Lock is not available and a waiter is present
+ *
+ * A task entering the quick path will set the wait bit and be in either
+ * either states 2 or 3. The allowable transitions are:
+ *
+ *   [3] => [2] => [1] => [0]
+ *    ^             |
+ *    +-------------+
+ *
+ * N.B. The wait bit won't be set if the queue code has been set before.
+ *	As a result, the queue head can safely get the lock without using
+ *	atomic operation as long as it checks that the wait bit hasn't been
+ *	set. The cpu_relax() function is used after atomic operation whereas
+ *	arch_mutex_cpu_relax() is used after a read.
+ */
+static inline int queue_spin_trylock_quick(struct qspinlock *lock, int qsval)
+{
+	union arch_qspinlock *qlock = (union arch_qspinlock *)lock;
+	int		      wset  = false;	/* True if wait bit was set */
+
+	/*
+	 * Fall into the quick spinning code path only if no task is waiting
+	 * in the queue.
+	 */
+	for (; likely(!(qsval >> _QCODE_OFFSET));
+			qsval = atomic_read(&lock->qlcode)) {
+
+		if (unlikely((qsval & _QLOCK_LW_MASK) == _QLOCK_LW_MASK)) {
+			/*
+			 * Wait a while to see if either lock or wait bit
+			 * is cleared. Leave if the condition isn't changed.
+			 */
+			cpu_relax();
+			cpu_relax();
+			qsval = atomic_read(&lock->qlcode);
+			if ((qsval >> _QCODE_OFFSET) ||
+			   ((qsval & _QLOCK_LW_MASK) == _QLOCK_LW_MASK))
+				return 0;
+		}
+		if (unlikely(qsval == 0)) {
+			/*
+			 * Attempt to acquire the lock directly here
+			 */
+			qsval = atomic_cmpxchg(&lock->qlcode, 0, _QLOCK_LOCKED);
+			if (qsval == 0)
+				return 1;	/* Got the lock */
+			cpu_relax();
+			continue;
+		}
+		if (unlikely(qsval & _QLOCK_WAITING)) {
+			arch_mutex_cpu_relax();
+			wset = true;
+			continue;
+		}
+
+		/*
+		 * If the wait bit has just been cleared, the new lock holder
+		 * should be busy in the critical section. It was found that
+		 * waiting a bit longer before the exchange operation helps
+		 * performance.
+		 */
+		if (unlikely(wset))
+			arch_mutex_cpu_relax();
+
+		if (atomic_cmpxchg(&lock->qlcode, qsval, qsval|_QLOCK_WAITING)
+				  != qsval) {
+			/*
+			 * Another task has got the wait bit before us or
+			 * the queue code has been set. Wait a bit and try
+			 * again.
+			 */
+			cpu_relax();
+			wset = false;
+			continue;
+		}
+
+		/*
+		 * Wait a bit here if the lock bit was set.
+		 */
+		if (unlikely(qsval & _QLOCK_LOCKED))
+			arch_mutex_cpu_relax();
+
+		/*
+		 * Now wait until the lock bit is cleared
+		 */
+		while (smp_load_acquire(&qlock->qlcode) & _QLOCK_LOCKED)
+			arch_mutex_cpu_relax();
+
+		/*
+		 * Set the lock bit & clear the waiting bit simultaneously
+		 * No lock stealing is allowed when this quick path is active.
+		 */
+		ACCESS_ONCE(qlock->lock_wait) = _QLOCK_LOCKED;
+		return 1;
+	}
+	return 0;
+}
+
 #define queue_code_xchg queue_code_xchg
 /**
  * queue_code_xchg - exchange a queue code value
@@ -192,7 +320,7 @@ static __always_inline int __queue_spin_trylock(struct qspinlock *lock)
 {
 	union arch_qspinlock *qlock = (union arch_qspinlock *)lock;
 
-	return cmpxchg(&qlock->lock, 0, _QLOCK_LOCKED) == 0;
+	return cmpxchg(&qlock->lock_wait, 0, _QLOCK_LOCKED) == 0;
 }
 #endif
 #endif /*  _ARCH_SUPPORTS_ATOMIC_8_16_BITS_OPS  */
@@ -203,6 +331,10 @@ static __always_inline int __queue_spin_trylock(struct qspinlock *lock)
  * that may get superseded by a more optimized version.			*
  ************************************************************************
  */
+#ifndef queue_spin_trylock_quick
+static inline int queue_spin_trylock_quick(struct qspinlock *lock, int qsval)
+{ return 0; }
+#endif
 
 #ifndef __queue_spin_trylock
 /**
@@ -365,37 +497,20 @@ static inline void put_qnode(void)
 }
 
 /**
- * queue_spin_lock_slowpath - acquire the queue spinlock
- * @lock : Pointer to queue spinlock structure
- * @qsval: Current value of the queue spinlock 32-bit word
+ * queue_spin_lock_slowerpath - put lock waiter in queue & wait for its turn
+ * @lock    : Pointer to queue spinlock structure
+ * @node    : Pointer to the queue node
+ * @my_qcode: Queue code for the queue node
  */
-void queue_spin_lock_slowpath(struct qspinlock *lock, int qsval)
+static noinline void queue_spin_lock_slowerpath(struct qspinlock *lock,
+					struct qnode *node, u32 my_qcode)
 {
-	unsigned int cpu_nr;
-	struct qnode *node, *next;
-	u32 prev_qcode, my_qcode;
+	int qsval;
+	struct qnode *next;
+	u32 prev_qcode;
 	enum exitval exitval;
 
 	/*
-	 * Get the queue node
-	 */
-	cpu_nr = smp_processor_id();
-	node   = get_qnode(cpu_nr, &my_qcode);
-
-	/*
-	 * Initialize the queue node
-	 */
-	node->qhead = false;
-	node->next  = NULL;
-
-	/*
-	 * The lock may be available at this point, try again if no task was
-	 * waiting in the queue.
-	 */
-	if (!(qsval >> _QCODE_OFFSET) && queue_spin_trylock(lock))
-		goto release_node;
-
-	/*
 	 * Exchange current copy of the queue node code
 	 */
 	exitval = queue_code_xchg(lock, &prev_qcode, my_qcode);
@@ -463,4 +578,47 @@ set_qhead:
 release_node:
 	put_qnode();
 }
+
+/**
+ * queue_spin_lock_slowpath - acquire the queue spinlock
+ * @lock : Pointer to queue spinlock structure
+ * @qsval: Current value of the queue spinlock 32-bit word
+ *
+ * The slowpath was broken into a regular slowpath and a slowerpath. The
+ * slowpath contains the quick spinning code and the slower path contains
+ * the regular lock waiter queuing code. This is to avoid the complexity in
+ * the queuing code from slowing down the quick spinning path due to
+ * compiler optimization.
+ */
+void queue_spin_lock_slowpath(struct qspinlock *lock, int qsval)
+{
+	struct qnode *node;
+	u32 my_qcode, cpu_nr;
+
+	/*
+	 * Try the quick spinning code path
+	 */
+	if (queue_spin_trylock_quick(lock, qsval))
+		return;
+	/*
+	 * Get the queue node
+	 */
+	cpu_nr = smp_processor_id();
+	node   = get_qnode(cpu_nr, &my_qcode);
+
+	/*
+	 * Initialize the queue node
+	 */
+	node->qhead = false;
+	node->next  = NULL;
+
+	/*
+	 * The lock may be available at this point, try again if no task was
+	 * waiting in the queue.
+	 */
+	if (likely(!(qsval >> _QCODE_OFFSET) && queue_spin_trylock(lock)))
+		put_qnode();	/* Return the queue node */
+	else
+		queue_spin_lock_slowerpath(lock, node, my_qcode);
+}
 EXPORT_SYMBOL(queue_spin_lock_slowpath);
-- 
1.7.1

