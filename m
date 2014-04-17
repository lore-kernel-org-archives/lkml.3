Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215AbaDQPII (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 11:08:08 -0400
Received: from g5t1627.atlanta.hp.com ([15.192.137.10]:43436 "EHLO
	g5t1627.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbaDQPE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 11:04:59 -0400
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
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>,
        Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH v9 13/19] unfair qspinlock: Enable lock stealing in lock waiters
Date: Thu, 17 Apr 2014 11:04:05 -0400
Message-Id: <1397747051-15401-14-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1397747051-15401-1-git-send-email-Waiman.Long@hp.com>
References: <1397747051-15401-1-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The simple unfair queue lock cannot completely solve the lock waiter
preemption problem as a preempted CPU at the front of the queue will
block forward progress in all the other CPUs behind it in the queue.
To allow those CPUs to move forward, it is necessary to enable lock
stealing for those lock waiters as well.

Enabling those lock waiters to try to steal the lock increases the
cacheline pressure on the lock word. As a result, performance can
suffer on a workload with heavy spinlock contention.

The tables below shows the the performance (jobs/minutes) of other
kernel flavors of a 3.14-based kernel at 3000 users of the AIM7 disk
workload on a 4-socket Westmere-EX bare-metal system. The ebizzy test
was run.

                AIM7 XFS Disk Test
  kernel                 JPM    Real Time   Sys Time    Usr Time
  -----                  ---    ---------   --------    --------
  ticketlock            5678233    3.17       96.61       5.81
  qspinlock             5750799    3.13       94.83       5.97
  simple test-and-set	5625000	   3.20	      98.29	  5.93
  simple unfair		5750799	   3.13	      95.91	  5.98
    qspinlock
  complex unfair	5678233	   3.17	      97.40	  5.93
    qspinlock

                AIM7 EXT4 Disk Test
  kernel                 JPM    Real Time   Sys Time    Usr Time
  -----                  ---    ---------   --------    --------
  ticketlock            1114551   16.15      509.72       7.11
  qspinlock             2184466    8.24      232.99       6.01
  simple test-and-set	 593081	  30.35	     967.55	  9.00
  simple unfair		2292994	   7.85	     222.84	  5.89
    qspinlock
  complex unfair	 972447	  18.51	     589.88	  6.65
    qspinlock

                Ebizzy -m test
  kernel               records/s  Real Time   Sys Time    Usr Time
  -----                ---------  ---------   --------    --------
  ticketlock             2075       10.00      216.35       3.49
  qspinlock              3023       10.00      198.20       4.80
  simple test-and-set	 1667	    10.00      198.93	    2.89
  simple unfair		 2915	    10.00      165.68	    4.31
    qspinlock
  complex unfair	 1965	    10.00      191.96       3.17
    qspinlock

With heavy spinlock contention, the complex unfair lock is faster
than the simple test-and-set lock, but it is still slower than the
baseline ticketlock.

The table below shows the execution times (in ms) of a spinlock
micro-benchmark on the same 4-socket Westmere-EX system.

  # of    Ticket       Fair	 Unfair simple	Unfair complex
  tasks    lock     queue lock    queue lock	  queue lock
  ------  -------   ----------    ----------	  ---------
    1       135        135	     137	    137
    2       890       1082	     421	    663
    3      1932       2248     	     708	   1263
    4      2829       2819	    1030	   1806
    5      3834       3522	    1323	   2315
    6      4963       4173	    1723	   2831
    7      6299       4875          2067	   2878
    8      7691       5563          2360	   3256

Executing one task per node, the performance data were:

  # of    Ticket       Fair	 Unfair simple	Unfair complex
  nodes    lock     queue lock    queue lock	  queue lock
  ------  -------   ----------    ----------	  ---------
    1        135        135          137	    137
    2       4603       1034          670	    888
    3      10940      12087         1389	   2041
    4      21555      10507         1869	   4307

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 kernel/locking/qspinlock.c |  160 ++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 154 insertions(+), 6 deletions(-)

diff --git a/kernel/locking/qspinlock.c b/kernel/locking/qspinlock.c
index c2c79a0..f9c82f6 100644
--- a/kernel/locking/qspinlock.c
+++ b/kernel/locking/qspinlock.c
@@ -170,6 +170,23 @@ xchg_tail(struct qspinlock *lock, u32 tail, u32 *pval)
 	return (u32)xchg(&l->tail, tail >> _Q_TAIL_OFFSET) << _Q_TAIL_OFFSET;
 }
 
+/*
+ * cmpxchg_tail - Put in the new tail code if it matches the old one
+ * @lock : Pointer to queue spinlock structure
+ * @old  : The old tail code value
+ * @new  : The new tail code value
+ * Return: true if operation succeeds, fail otherwise
+ */
+static __always_inline int
+cmpxchg_tail(struct qspinlock *lock, u32 old, u32 new)
+{
+	struct __qspinlock *l = (void *)lock;
+
+	old >>= _Q_TAIL_OFFSET;
+	new >>= _Q_TAIL_OFFSET;
+	return cmpxchg(&l->tail, old, new) == old;
+}
+
 #else /* _Q_PENDING_BITS == 8 */
 
 /**
@@ -222,6 +239,35 @@ xchg_tail(struct qspinlock *lock, u32 tail, u32 *pval)
 	*pval = new;
 	return old;
 }
+
+/*
+ * cmpxchg_tail - Put in the new tail code if it matches the old one
+ * @lock : Pointer to queue spinlock structure
+ * @old  : The old tail code value
+ * @new  : The new tail code value
+ * Return: true if operation succeeds, fail otherwise
+ *
+ * It is assumed that the caller has grabbed the lock before calling it.
+ */
+static __always_inline int
+cmpxchg_tail(struct qspinlock *lock, u32 old, u32 new)
+{
+	u32 val;
+	u32 lp = _Q_LOCKED_VAL;	/* Lock & pending bits value */
+
+	for (;;) {
+		u32 val = atomic_cmpxchg(&lock->val, old | lp, new | lp);
+
+		/*
+		 * If the lock or pending bits somehow changes, redo it again
+		 */
+		if ((val & _Q_LOCKED_PENDING_MASK) != lp) {
+			lp = val & _Q_LOCKED_PENDING_MASK;
+			continue;
+		}
+		return val == (old | lp);
+	}
+}
 #endif /* _Q_PENDING_BITS == 8 */
 
 /*
@@ -306,6 +352,25 @@ unfair_set_vars(struct qnode *node, struct qnode *prev, u32 prev_tail)
 }
 
 /**
+ * unfair_check_and_clear_tail - check the tail value in lock & clear it if
+ *				 it matches the given tail
+ * @lock : Pointer to queue spinlock structure
+ * @tail : The tail code to be checked against
+ * Return: true if the tail code matches and is cleared, false otherwise
+ */
+static inline int unfair_check_and_clear_tail(struct qspinlock *lock, u32 tail)
+{
+	if (!static_key_false(&paravirt_unfairlocks_enabled))
+		return false;
+
+	/*
+	 * Try to clear the current tail code if it matches the given tail
+	 */
+	return ((atomic_read(&lock->val) & _Q_TAIL_MASK) == tail) &&
+		cmpxchg_tail(lock, tail, 0);
+}
+
+/**
  * unfair_get_lock - try to steal the lock periodically
  * @lock : Pointer to queue spinlock structure
  * @node : Current queue node address
@@ -317,7 +382,7 @@ unfair_set_vars(struct qnode *node, struct qnode *prev, u32 prev_tail)
  * node only if the qhead flag is set and the next pointer in the queue
  * node is not NULL.
  */
-static noinline int
+static inline int
 unfair_get_lock(struct qspinlock *lock, struct qnode *node, u32 tail, int count)
 {
 	u32	     prev_tail;
@@ -341,8 +406,64 @@ unfair_get_lock(struct qspinlock *lock, struct qnode *node, u32 tail, int count)
 			node->lsteal_mask = LSTEAL_MAX_MASK;
 		return false;
 	}
-	queue_spin_unlock(lock);
-	return false;
+
+	/*
+	 * Have stolen the lock, need to remove itself from the wait queue.
+	 * There are 3 steps that need to be done:
+	 * 1) If it is at the end of the queue, change the tail code in the
+	 *    lock to the one before it. If the current node happens to be
+	 *    the queue head, the previous tail code is 0.
+	 * 2) Change the next pointer in the previous queue node to point
+	 *    to the next one in queue or NULL if it is at the end of queue.
+	 * 3) If a next node is present, copy the prev_tail and qprev values
+	 *    to the next node.
+	 */
+	isqhead   = ACCESS_ONCE(node->qhead);
+	prev_tail = isqhead ? 0 : node->prev_tail;
+
+	/* Step 1 */
+	if (((atomic_read(&lock->val) & _Q_TAIL_MASK) == tail) &&
+	     cmpxchg_tail(lock, tail, prev_tail)) {
+		/*
+		 * Successfully change the tail code back to the previous one.
+		 * Now need to clear the next pointer in the previous node
+		 * only if it contains my queue node address and is not
+		 * the queue head. The cmpxchg() call below may fail if
+		 * a new task comes along and put its node address into the
+		 * next pointer. Whether the operation succeeds or fails
+		 * doesn't really matter.
+		 */
+		/* Step 2 */
+		if (!isqhead)
+			(void)cmpxchg(&node->qprev->mcs.next, &node->mcs, NULL);
+		node->mcs.next = NULL;
+		return true;
+	}
+
+	/*
+	 * A next node has to be present if the lock has a different tail
+	 * code. So wait until the next pointer is set.
+	 */
+	while (!(next = (struct qnode *)ACCESS_ONCE(node->mcs.next)))
+		arch_mutex_cpu_relax();
+
+	if (!isqhead) {
+		/*
+		 * Change the node data only if it is not the queue head
+		 * Steps 2 & 3
+		 */
+		ACCESS_ONCE(node->qprev->mcs.next) =
+				(struct mcs_spinlock *)next;
+		ACCESS_ONCE(next->qprev)     = node->qprev;
+		ACCESS_ONCE(next->prev_tail) = node->prev_tail;
+
+		/*
+		 * Make sure all the new node information are visible
+		 * before proceeding.
+		 */
+		smp_wmb();
+	}
+	return true;
 }
 
 #else /* CONFIG_PARAVIRT_UNFAIR_LOCKS */
@@ -355,6 +476,8 @@ static void unfair_set_vars(struct qnode *node, struct qnode *prev,
 		u32 prev_tail)				{}
 static int unfair_get_lock(struct qspinlock *lock, struct qnode *node,
 		u32 tail, int count)			{ return false; }
+static int unfair_check_and_clear_tail(struct qspinlock *lock, u32 tail)
+							{ return false; }
 #endif /* CONFIG_PARAVIRT_UNFAIR_LOCKS */
 
 /**
@@ -515,7 +638,16 @@ queue_spin_lock_slowerpath(struct qspinlock *lock, struct qnode *node, u32 tail)
 
 		while (!smp_load_acquire(&node->qhead)) {
 			INC_LOOP_CNT(cnt);
-			unfair_get_lock(lock, node, tail, LOOP_CNT(cnt));
+			if (unfair_get_lock(lock, node, tail, LOOP_CNT(cnt))) {
+				/*
+				 * Need to notify the next node only if both
+				 * the qhead flag and the next pointer in the
+				 * queue node are set.
+				 */
+				if (unlikely(node->qhead && node->mcs.next))
+					goto notify_next;
+				return;
+			}
 			arch_mutex_cpu_relax();
 		}
 	}
@@ -549,10 +681,25 @@ retry_queue_wait:
 			 * The get_qlock function will only failed if the
 			 * lock was stolen.
 			 */
-			if (get_qlock(lock))
+			if (get_qlock(lock)) {
+				/*
+				 * It is possible that in between the reading
+				 * of the lock value and the acquisition of
+				 * the lock, the next node may have stolen the
+				 * lock and be removed from the queue. So
+				 * the lock value may contain the tail code
+				 * of the current node. We need to recheck
+				 * the tail value here to be sure. And if
+				 * the tail code was cleared, we don't need
+				 * to notify the next node.
+				 */
+				if (unlikely(unfair_check_and_clear_tail(lock,
+						tail)))
+					return;
 				break;
-			else
+			} else {
 				goto retry_queue_wait;
+			}
 		}
 		old = atomic_cmpxchg(&lock->val, val, _Q_LOCKED_VAL);
 		if (old == val)
@@ -566,6 +713,7 @@ retry_queue_wait:
 	/*
 	 * contended path; wait for next, return.
 	 */
+notify_next:
 	while (!(next = (struct qnode *)ACCESS_ONCE(node->mcs.next)))
 		arch_mutex_cpu_relax();
 
-- 
1.7.1

