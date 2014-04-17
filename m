Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227AbaDQPFg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 11:05:36 -0400
Received: from g5t1627.atlanta.hp.com ([15.192.137.10]:43609 "EHLO
	g5t1627.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875AbaDQPE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 11:04:57 -0400
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
Subject: [PATCH v9 12/19] unfair qspinlock: Variable frequency lock stealing mechanism
Date: Thu, 17 Apr 2014 11:04:04 -0400
Message-Id: <1397747051-15401-13-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1397747051-15401-1-git-send-email-Waiman.Long@hp.com>
References: <1397747051-15401-1-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to fully resolve the lock waiter preemption problem in virtual
guests, it is necessary to enable lock stealing in the lock waiters.
A simple test-and-set lock, however, has 2 main problems:

 1) The constant spinning on the lock word put a lot of cacheline
    contention traffic on the affected cacheline, thus slowing tasks
    that need to access the cacheline.
 2) Lock starvation is a real possibility especially if the number of
    virtual CPUs is large.

To alleviate these problems, this patch implements a variable frequency
(from 1/8 to 1/1024) lock stealing mechanism for the lock waiters
in the queue. The node next to the queue head try to steal lock once
every 8 iterations of the pause loop. The next one in the queue has
half the lock stealing frequency (once every 16 iterations) and so
on until it reaches a maximum of once every 1024 iterations.

This mechanism reduces the cacheline contention problem on the lock
word while trying to maintain as much of a FIFO order as possible.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 kernel/locking/qspinlock.c |  147 +++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 146 insertions(+), 1 deletions(-)

diff --git a/kernel/locking/qspinlock.c b/kernel/locking/qspinlock.c
index 954b8b3..c2c79a0 100644
--- a/kernel/locking/qspinlock.c
+++ b/kernel/locking/qspinlock.c
@@ -67,6 +67,11 @@
  */
 struct qnode {
 	struct mcs_spinlock mcs;
+#ifdef CONFIG_PARAVIRT_UNFAIR_LOCKS
+	int		lsteal_mask;	/* Lock stealing frequency mask	*/
+	u32		prev_tail;	/* Tail code of previous node	*/
+	struct qnode   *qprev;		/* Previous queue node addr	*/
+#endif
 };
 #define qhead	mcs.locked	/* The queue head flag */
 
@@ -219,6 +224,139 @@ xchg_tail(struct qspinlock *lock, u32 tail, u32 *pval)
 }
 #endif /* _Q_PENDING_BITS == 8 */
 
+/*
+ ************************************************************************
+ * Inline functions for supporting unfair queue lock			*
+ ************************************************************************
+ */
+/*
+ * Unfair lock support in a virtualized guest
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
+ *  1) In the spin_lock and spin_trylock fastpaths
+ *  2) When spinning in the waiter queue before becoming the queue head
+ *
+ * A lock acquirer has only one chance of stealing the lock in the spin_lock
+ * and spin_trylock fastpath. If the attempt fails for spin_lock, the task
+ * will be queued in the wait queue.
+ *
+ * Even in the wait queue, the task can still attempt to steal the lock
+ * periodically at a frequency about inversely and logarithmically proportional
+ * to its distance from the queue head. In other word, the closer it is to
+ * the queue head, the higher a chance it has of stealing the lock. This
+ * scheme reduces the load on the lock cacheline while trying to maintain
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
+static inline void unfair_init_vars(struct qnode *node)
+{
+	node->qprev	  = NULL;
+	node->prev_tail   = 0;
+	node->lsteal_mask = LSTEAL_MIN_MASK;
+}
+
+/**
+ * unfair_set_vars - set unfair related fields in the queue node structure
+ * @node     : Current queue node address
+ * @prev     : Previous queue node address
+ * @prev_tail: Previous tail code
+ */
+static inline void
+unfair_set_vars(struct qnode *node, struct qnode *prev, u32 prev_tail)
+{
+	if (!static_key_false(&paravirt_unfairlocks_enabled))
+		return;
+
+	node->qprev	= prev;
+	node->prev_tail = prev_tail;
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
+ * unfair_get_lock - try to steal the lock periodically
+ * @lock : Pointer to queue spinlock structure
+ * @node : Current queue node address
+ * @tail : My tail code value
+ * @count: Loop count
+ * Return: true if the lock has been stolen, false otherwise
+ *
+ * When a true value is returned, the caller will have to notify the next
+ * node only if the qhead flag is set and the next pointer in the queue
+ * node is not NULL.
+ */
+static noinline int
+unfair_get_lock(struct qspinlock *lock, struct qnode *node, u32 tail, int count)
+{
+	u32	     prev_tail;
+	int	     isqhead;
+	struct qnode *next;
+
+	if (!static_key_false(&paravirt_unfairlocks_enabled) ||
+	   ((count & node->lsteal_mask) != node->lsteal_mask))
+		return false;
+
+	if (!queue_spin_trylock_unfair(lock)) {
+		/*
+		 * Lock stealing fails, re-adjust the lsteal mask so that
+		 * it is about double of the previous node.
+		 */
+		struct qnode *prev = node->qprev;
+
+		node->lsteal_mask = prev->qhead ? LSTEAL_MIN_MASK :
+				    (prev->lsteal_mask << 1) + 1;
+		if (node->lsteal_mask > LSTEAL_MAX_MASK)
+			node->lsteal_mask = LSTEAL_MAX_MASK;
+		return false;
+	}
+	queue_spin_unlock(lock);
+	return false;
+}
+
+#else /* CONFIG_PARAVIRT_UNFAIR_LOCKS */
+#define	DEF_LOOP_CNT(c)
+#define	INC_LOOP_CNT(c)
+#define	LOOP_CNT(c)	0
+
+static void unfair_init_vars(struct qnode *node)	{}
+static void unfair_set_vars(struct qnode *node, struct qnode *prev,
+		u32 prev_tail)				{}
+static int unfair_get_lock(struct qspinlock *lock, struct qnode *node,
+		u32 tail, int count)			{ return false; }
+#endif /* CONFIG_PARAVIRT_UNFAIR_LOCKS */
+
 /**
  * get_qlock - Set the lock bit and own the lock
  * @lock : Pointer to queue spinlock structure
@@ -369,11 +507,17 @@ queue_spin_lock_slowerpath(struct qspinlock *lock, struct qnode *node, u32 tail)
 	 * if there was a previous node; link it and wait.
 	 */
 	if (old & _Q_TAIL_MASK) {
+		DEF_LOOP_CNT(cnt);
+
 		prev = decode_tail(old);
+		unfair_set_vars(node, prev, old);
 		ACCESS_ONCE(prev->mcs.next) = (struct mcs_spinlock *)node;
 
-		while (!smp_load_acquire(&node->qhead))
+		while (!smp_load_acquire(&node->qhead)) {
+			INC_LOOP_CNT(cnt);
+			unfair_get_lock(lock, node, tail, LOOP_CNT(cnt));
 			arch_mutex_cpu_relax();
+		}
 	}
 
 	/*
@@ -469,6 +613,7 @@ void queue_spin_lock_slowpath(struct qspinlock *lock, u32 val)
 	node += idx;
 	node->qhead = 0;
 	node->mcs.next = NULL;
+	unfair_init_vars(node);
 
 	/*
 	 * We touched a (possibly) cold cacheline; attempt the trylock once
-- 
1.7.1

