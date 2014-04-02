Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758841AbaDBN2m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 09:28:42 -0400
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:15258 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758819AbaDBN2h (ORCPT
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
Subject: [PATCH v8 06/10] pvqspinlock: Enable lock stealing in queue lock waiters
Date: Wed,  2 Apr 2014 09:27:35 -0400
Message-Id: <1396445259-27670-7-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1396445259-27670-1-git-send-email-Waiman.Long@hp.com>
References: <1396445259-27670-1-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The simple unfair queue lock cannot completely solve the lock waiter
preemption problem as a preempted CPU at the front of the queue will
block forward progress in all the other CPUs behind it in the queue.
To allow those CPUs to move forward, it is necessary to enable lock
stealing for those lock waiters as well.

This patch enables those lock waiters to try to steal the lock
periodically at a frequency that is inverse algorithmatically
proportional to its distance from the queue head until it reaches a
maximum value.

Enabling those lock waiters to try to steal the lock increases the
cacheline pressure on the lock word. As a result, performance can
suffer on a workload with heavy spinlock contention.

The table below shows the the performance (jobs/minutes) of that
scheme when compared with other kernel flavors at 3000 users of the
AIM7 disk workload on a 4-socket Westmere-EX system.

  Kernel			disk-xfs JPM	disk-ext4 JPM
  ------			------------	-------------
  ticketlock	 		5,660,377	 1,151,631
  qspinlock	 		5,678,233	 2,033,898
  simple test-and-set   	5,678,233	   533,966
  simple unfair qspinlock	5,732,484	 2,216,749
  complex unfair qspinlock	5,625,000	   707,547

With heavy spinlock contention, the complex unfair lock is faster
than the simple test-and-set lock, but it is still slower than the
baseline ticketlock.

As for the lock starvation problem, the patch tries to reduce the
chance of this problem by enabling the CPUs at the front of the queue
has a much higher chance of getting the lock than the ones behind. This
should greatly improve the chance of making forward progress in the
queue without unacceptably long delay.

The table below shows the execution times (in ms) of a spinlock
micro-benchmark on the same 4-socket Westmere-EX system.

  # of    Ticket       Fair	 Unfair simple	Unfair complex
  tasks    lock     queue lock    queue lock	  queue lock
  ------  -------   ----------    ----------	--------------
    1       135        135	     137	    137
    2      1045        951	     732	    696
    3      1827       2256     	     915	   1267
    4      2689       2880	    1377	   1695
    5      3736       3636	    1439	   2243
    6      4942       4294	    1724	   2617
    7      6304       4976          2001	   2776
    8      7736       5662          2317	   2941

Executing one task per node, the performance data were:

  # of    Ticket       Fair	 Unfair simple	Unfair complex
  nodes    lock     queue lock    queue lock	  queue lock
  ------  -------   ----------    ----------	--------------
    1        135        135          137	    137
    2       4452       1024         1697	   1354
    3      10767      14030         2015	   2581
    4      20835      10740         2732	   4653

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 kernel/locking/qspinlock.c |  270 +++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 265 insertions(+), 5 deletions(-)

diff --git a/kernel/locking/qspinlock.c b/kernel/locking/qspinlock.c
index cf16bba..527efc3 100644
--- a/kernel/locking/qspinlock.c
+++ b/kernel/locking/qspinlock.c
@@ -86,13 +86,14 @@ enum exitval {
 
 /*
  * The queue node structure
- *
- * This structure is essentially the same as the mcs_spinlock structure
- * in mcs_spinlock.h file. It is retained for future extension where new
- * fields may be added.
  */
 struct qnode {
 	u32		 qhead;		/* Queue head flag		*/
+#ifdef CONFIG_PARAVIRT_UNFAIR_LOCKS
+	int		 lsteal_mask;	/* Lock stealing frequency mask	*/
+	u32		 prev_qcode;	/* Queue code of previous node	*/
+	struct qnode    *qprev;		/* Previous queue node addr	*/
+#endif
 	struct qnode	*next;		/* Next queue node addr		*/
 };
 
@@ -107,6 +108,11 @@ struct qnode_set {
 static DEFINE_PER_CPU_ALIGNED(struct qnode_set, qnset) = { { { 0 } }, 0 };
 
 /*
+ * Macro to get queue code from queue spinlock
+ */
+#define queue_get_qcode(lock)	qsval_to_qcode(atomic_read(&(lock)->qlcode))
+
+/*
  ************************************************************************
  * The following optimized codes are for architectures that support:	*
  *  1) Atomic byte and short data write					*
@@ -279,6 +285,22 @@ queue_code_xchg(struct qspinlock *lock, u32 *ocode, u32 ncode)
 	return NORMAL_EXIT;
 }
 
+#define	cmpxchg_queue_code cmpxchg_queue_code
+/**
+ * cmpxchg_queue_code - compare and exchange a queue code value in the lock
+ * @lock : Pointer to queue spinlock structure
+ * @ocode: Old queue code value
+ * @ncode: New queue code value
+ * Return: true if compare and exchange successful, false otherwise
+ */
+static inline int
+cmpxchg_queue_code(struct qspinlock *lock, u32 ocode, u32 ncode)
+{
+	union arch_qspinlock *qlock = (union arch_qspinlock *)lock;
+
+	return cmpxchg(&qlock->qcode, (u16)ocode, (u16)ncode) == (u16)ocode;
+}
+
 #define queue_spin_trylock_and_clr_qcode queue_spin_trylock_and_clr_qcode
 /**
  * queue_spin_trylock_and_clr_qcode - Try to lock & clear qcode simultaneously
@@ -449,6 +471,223 @@ queue_code_xchg(struct qspinlock *lock, u32 *ocode, u32 ncode)
 }
 #endif /* queue_code_xchg */
 
+#ifndef cmpxchg_queue_code
+/**
+ * cmpxchg_queue_code - compare and exchange a queue code value in the lock
+ * @lock : Pointer to queue spinlock structure
+ * @ocode: Old queue code value
+ * @ncode: New queue code value
+ * Return: true if compare and exchange successful, false otherwise
+ */
+static inline int
+cmpxchg_queue_code(struct qspinlock *lock, u32 ocode, u32 ncode)
+{
+	u32 lockval = atomic_read(lock->qlcode) & _QLOCK_LOCK_MASK;
+
+	ocode |= lockval;
+	ncode |= lockval;
+	return atomic_cmpxchg(&lock->qlcode, ocode, ncode) == ocode;
+}
+#endif /* cmpxchg_queue_code */
+
+/*
+ ************************************************************************
+ * Inline functions for supporting unfair queue lock			*
+ ************************************************************************
+ */
+/*
+ * Unfair lock support in a paravirtualized guest
+ *
+ * An unfair lock can be implemented using a simple test-and-set lock like
+ * what is being done in a read-write lock. This simple scheme has 2 major
+ * problems:
+ *  1) It needs constant reading and occasionally writing to the lock word
+ *     thus putting a lot of cacheline contention traffic on the affected
+ *     cacheline.
+ *  2) Lock starvation is a real possibility especially if the number of
+ *     virtual CPUs is large.
+ *
+ * To reduce the undesirable side effects of an unfair lock, the queue
+ * unfair spinlock implements a more elaborate scheme.  Lock stealing is
+ * allowed in the following places:
+ *  1) In the spin_lock and spin_trylock functiopns
+ *  2) When spinning in the waiter queue before becoming the queue head
+ *
+ * A lock acquirer has only one chance of stealing the lock in the spin_lock
+ * and spin_trylock function. If the attempt fails for spin_lock, the task
+ * will be queued in the wait queue.
+ *
+ * Even in the wait queue, the task can still attempt to steal the lock
+ * periodically at a frequency about inversely and logarithmically proportional
+ * to its distance from the queue head. In other word, the closer it is to
+ * the queue head, the higher a chance it has of stealing the lock. This
+ * scheme reduce the load on the lock cacheline while trying to maintain
+ * a somewhat FIFO way of getting the lock so as to reduce the chance of lock
+ * starvation.
+ */
+#ifdef CONFIG_PARAVIRT_UNFAIR_LOCKS
+#define DEF_LOOP_CNT(c)		int c = 0
+#define INC_LOOP_CNT(c)		(c)++
+#define LOOP_CNT(c)		c
+#define LSTEAL_MIN		(1 << 3)
+#define LSTEAL_MAX		(1 << 10)
+#define LSTEAL_MIN_MASK		(LSTEAL_MIN - 1)
+#define LSTEAL_MAX_MASK		(LSTEAL_MAX - 1)
+
+/**
+ * unfair_init_vars - initialize unfair relevant fields in queue node structure
+ * @node: Current queue node address
+ */
+static void unfair_init_vars(struct qnode *node)
+{
+	node->qprev	  = NULL;
+	node->prev_qcode  = 0;
+	node->lsteal_mask = LSTEAL_MIN_MASK;
+}
+
+/**
+ * unfair_set_vars - set unfair related fields in the queue node structure
+ * @node      : Current queue node address
+ * @prev      : Previous queue node address
+ * @prev_qcode: Previous qcode value
+ */
+static void
+unfair_set_vars(struct qnode *node, struct qnode *prev, u32 prev_qcode)
+{
+	if (!static_key_false(&paravirt_unfairlocks_enabled))
+		return;
+
+	node->qprev	  = prev;
+	node->prev_qcode  = prev_qcode;
+	/*
+	 * This node will spin double the number of time of the previous node
+	 * before attempting to steal the lock until it reaches a maximum.
+	 */
+	node->lsteal_mask = prev->qhead ? LSTEAL_MIN_MASK :
+			    (prev->lsteal_mask << 1) + 1;
+	if (node->lsteal_mask > LSTEAL_MAX_MASK)
+		node->lsteal_mask = LSTEAL_MAX_MASK;
+	/* Make sure the new fields are visible to others */
+	smp_wmb();
+}
+
+/**
+ * unfair_check_qcode - check the current to see if it is the last one
+ *			and need to be cleared.
+ * @lock    : Pointer to queue spinlock structure
+ * @my_qcode: My queue code value to be checked again
+ * Return   : Either RELEASE_NODE or NOTIFY_NEXT
+ */
+static enum exitval unfair_check_qcode(struct qspinlock *lock, u32 my_qcode)
+{
+	if (!static_key_false(&paravirt_unfairlocks_enabled))
+		return NOTIFY_NEXT;
+
+	/*
+	 * Try to clear the current queue code if it match my_qcode
+	 */
+	if ((queue_get_qcode(lock) == my_qcode) &&
+	     cmpxchg_queue_code(lock, my_qcode, 0))
+		return RELEASE_NODE;
+	return NOTIFY_NEXT;
+}
+
+/**
+ * unfair_get_lock - try to steal the lock periodically
+ * @lock    : Pointer to queue spinlock structure
+ * @node    : Current queue node address
+ * @my_qcode: My queue code value
+ * @count   : Loop count
+ * Return   : NORMAL_EXIT, RELEASE_NODE or NOTIFY_NEXT
+ */
+static enum exitval unfair_get_lock(struct qspinlock *lock, struct qnode *node,
+				    u32 my_qcode, int count)
+{
+	u32	     pqcode;
+	int	     qhead;
+	struct qnode *next;
+
+	if (!static_key_false(&paravirt_unfairlocks_enabled) ||
+	   ((count & node->lsteal_mask) != node->lsteal_mask))
+		return NORMAL_EXIT;
+
+	if (!queue_spin_trylock_unfair(lock)) {
+		/*
+		 * Lock stealing fails, re-adjust the lsteal mask.
+		 */
+		struct qnode *prev = node->qprev;
+
+		node->lsteal_mask = prev->qhead ? LSTEAL_MIN_MASK :
+				    (prev->lsteal_mask << 1) + 1;
+		if (node->lsteal_mask > LSTEAL_MAX_MASK)
+			node->lsteal_mask = LSTEAL_MAX_MASK;
+		return NORMAL_EXIT;
+	}
+
+	/*
+	 * Have stolen the lock, need to remove itself from the wait queue
+	 * 1) If it is at the end of the queue, change the qcode in the lock
+	 *    word to the one before it.
+	 * 2) Change the next pointer in the previous queue node to point
+	 *    to the next one in queue or NULL if it is at the end of queue.
+	 * 3) If a next node is present, copy the prev_qcode and qprev values
+	 *    to the next node.
+	 */
+	qhead  = ACCESS_ONCE(node->qhead);
+	pqcode = qhead ? 0 : node->prev_qcode;
+
+	if ((queue_get_qcode(lock) == my_qcode) &&
+	     cmpxchg_queue_code(lock, my_qcode, pqcode)) {
+		/*
+		 * Successfully change the qcode back to the previous one.
+		 * Now need to clear the next pointer in the previous node
+		 * only if it contains my queue node address. Whether the
+		 * cmpxchg() call below fails or succeeds doesn't really
+		 * matter.
+		 */
+		(void)cmpxchg(&node->qprev->next, node, NULL);
+		return RELEASE_NODE;
+	}
+
+	next = ACCESS_ONCE(node->next);
+	if (unlikely(!next))
+		/* Wait until the next pointer is set */
+		do {
+			arch_mutex_cpu_relax();
+		} while (!(next = ACCESS_ONCE(node->next)));
+
+	if (!qhead) {
+		/*
+		 * Change the node data only if it is not the queue head
+		 */
+		ACCESS_ONCE(node->qprev->next) = next;
+		ACCESS_ONCE(next->qprev)       = node->qprev;
+		ACCESS_ONCE(next->prev_qcode)  = node->prev_qcode;
+
+		/*
+		 * Make sure all the new node information are visible
+		 * before proceeding.
+		 */
+		smp_wmb();
+		return RELEASE_NODE;
+	}
+	return NOTIFY_NEXT;
+}
+
+#else /* CONFIG_PARAVIRT_UNFAIR_LOCKS */
+#define	DEF_LOOP_CNT(c)
+#define	INC_LOOP_CNT(c)
+#define	LOOP_CNT(c)		0
+
+static void unfair_init_vars(struct qnode *node)	{}
+static void unfair_set_vars(struct qnode *node, struct qnode *prev,
+		u32 prev_qcode)				{}
+static enum exitval unfair_get_lock(struct qspinlock *lock, struct qnode *node,
+		u32 my_qcode, int count)		{ return NORMAL_EXIT; }
+static enum exitval unfair_check_qcode(struct qspinlock *lock, u32 my_qcode)
+							{ return NORMAL_EXIT; }
+#endif /* CONFIG_PARAVIRT_UNFAIR_LOCKS */
+
 /*
  ************************************************************************
  * Other inline functions needed by the queue_spin_lock_slowpath()	*
@@ -525,13 +764,22 @@ static noinline void queue_spin_lock_slowerpath(struct qspinlock *lock,
 		 * and set up the "next" fields of the that node.
 		 */
 		struct qnode *prev = xlate_qcode(prev_qcode);
+		DEF_LOOP_CNT(cnt);
 
+		unfair_set_vars(node, prev, prev_qcode);
 		ACCESS_ONCE(prev->next) = node;
 		/*
 		 * Wait until the queue head flag is on
 		 */
 		do {
+			INC_LOOP_CNT(cnt);
 			arch_mutex_cpu_relax();
+			exitval = unfair_get_lock(lock, node, my_qcode,
+						  LOOP_CNT(cnt));
+			if (unlikely(exitval == RELEASE_NODE))
+				goto release_node;
+			else if (unlikely(exitval == NOTIFY_NEXT))
+				goto notify_next;
 		} while (!ACCESS_ONCE(node->qhead));
 	}
 
@@ -540,7 +788,6 @@ static noinline void queue_spin_lock_slowerpath(struct qspinlock *lock,
 	 */
 	for (;; arch_mutex_cpu_relax()) {
 		qsval = atomic_read(&lock->qlcode);
-		next  = ACCESS_ONCE(node->next);
 		if (qsval & _QLOCK_LOCK_MASK)
 			continue;	/* Lock not available yet */
 
@@ -550,6 +797,18 @@ static noinline void queue_spin_lock_slowerpath(struct qspinlock *lock,
 			 */
 			if (unlikely(!__queue_spin_trylock(lock)))
 				continue;	/* Trylock fails! */
+
+			next = ACCESS_ONCE(node->next);
+			/*
+			 * The unfair lock stealing code may cause the
+			 * next node, whose qcode is in the lock, to get
+			 * the lock first and thus don't need to be notify.
+			 * Need to recheck the qcode value in the lock.
+			 */
+			if (unlikely(unfair_check_qcode(lock, my_qcode)
+					== RELEASE_NODE))
+				goto release_node;
+
 			if (likely(next))
 				goto set_qhead;
 			else
@@ -611,6 +870,7 @@ void queue_spin_lock_slowpath(struct qspinlock *lock, int qsval)
 	 */
 	node->qhead = false;
 	node->next  = NULL;
+	unfair_init_vars(node);
 
 	/*
 	 * The lock may be available at this point, try again if no task was
-- 
1.7.1

