Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335AbaDQPFw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 11:05:52 -0400
Received: from g5t1627.atlanta.hp.com ([15.192.137.10]:43608 "EHLO
	g5t1627.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869AbaDQPE5 (ORCPT
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
Subject: [PATCH v9 11/19] qspinlock: Split the MCS queuing code into a separate slowerpath
Date: Thu, 17 Apr 2014 11:04:03 -0400
Message-Id: <1397747051-15401-12-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1397747051-15401-1-git-send-email-Waiman.Long@hp.com>
References: <1397747051-15401-1-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the pending addition of more codes to support unfair lock and
PV spinlock, the complexity of the slowpath function increases to
the point that the number of scratch-pad registers in the x86-64
architecture is not enough and so those additional non-scratch-pad
registers will need to be used. This has the downside of requiring
saving and restoring of those registers in the prolog and epilog of
the slowpath function slowing down the nominally faster pending bit
and trylock code path at the beginning of the slowpath function.

This patch separates out the actual MCS queuing code into a slowerpath
function. This avoids the slow down of the pending bit and trylock
code path at the expense of a little bit of additional overhead to
the MCS queuing code path.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 kernel/locking/qspinlock.c |  111 ++++++++++++++++++++++++++------------------
 1 files changed, 65 insertions(+), 46 deletions(-)

diff --git a/kernel/locking/qspinlock.c b/kernel/locking/qspinlock.c
index 20e3fa6..954b8b3 100644
--- a/kernel/locking/qspinlock.c
+++ b/kernel/locking/qspinlock.c
@@ -340,53 +340,22 @@ static inline int trylock_pending(struct qspinlock *lock, u32 *pval)
 }
 
 /**
- * queue_spin_lock_slowpath - acquire the queue spinlock
+ * queue_spin_lock_slowerpath - a slower path for acquiring queue spinlock
  * @lock: Pointer to queue spinlock structure
- * @val: Current value of the queue spinlock 32-bit word
- *
- * (queue tail, pending bit, lock bit)
- *
- *              fast     :    slow                                  :    unlock
- *                       :                                          :
- * uncontended  (0,0,0) -:--> (0,0,1) ------------------------------:--> (*,*,0)
- *                       :       | ^--------.------.             /  :
- *                       :       v           \      \            |  :
- * pending               :    (0,1,1) +--> (0,1,0)   \           |  :
- *                       :       | ^--'              |           |  :
- *                       :       v                   |           |  :
- * uncontended           :    (n,x,y) +--> (n,0,0) --'           |  :
- *   queue               :       | ^--'                          |  :
- *                       :       v                               |  :
- * contended             :    (*,x,y) +--> (*,0,0) ---> (*,0,1) -'  :
- *   queue               :         ^--'                             :
+ * @node: Pointer to the queue node
+ * @tail: The tail code
  *
+ * The reason for splitting a slowerpath from slowpath is to avoid the
+ * unnecessary overhead of non-scratch pad register pushing and popping
+ * due to increased complexity with unfair and PV spinlock from slowing
+ * down the nominally faster pending bit and trylock code path. So this
+ * function is not inlined.
  */
-void queue_spin_lock_slowpath(struct qspinlock *lock, u32 val)
+static noinline void
+queue_spin_lock_slowerpath(struct qspinlock *lock, struct qnode *node, u32 tail)
 {
-	struct qnode *prev, *next, *node;
-	u32 old, tail;
-	int idx;
-
-	BUILD_BUG_ON(CONFIG_NR_CPUS >= (1U << _Q_TAIL_CPU_BITS));
-
-	if (trylock_pending(lock, &val))
-		return;	/* Lock acquired */
-
-	node = this_cpu_ptr(&qnodes[0]);
-	idx = node->mcs.count++;
-	tail = encode_tail(smp_processor_id(), idx);
-
-	node += idx;
-	node->qhead = 0;
-	node->mcs.next = NULL;
-
-	/*
-	 * We touched a (possibly) cold cacheline; attempt the trylock once
-	 * more in the hope someone let go while we weren't watching as long
-	 * as no one was queuing.
-	 */
-	if (!(val & _Q_TAIL_MASK) && queue_spin_trylock(lock))
-		goto release;
+	struct qnode *prev, *next;
+	u32 old, val;
 
 	/*
 	 * we already touched the queueing cacheline; don't bother with pending
@@ -443,7 +412,7 @@ retry_queue_wait:
 		}
 		old = atomic_cmpxchg(&lock->val, val, _Q_LOCKED_VAL);
 		if (old == val)
-			goto release;	/* No contention */
+			return;	/* No contention */
 		else if (old & _Q_LOCKED_MASK)
 			goto retry_queue_wait;
 
@@ -451,14 +420,64 @@ retry_queue_wait:
 	}
 
 	/*
-	 * contended path; wait for next, release.
+	 * contended path; wait for next, return.
 	 */
 	while (!(next = (struct qnode *)ACCESS_ONCE(node->mcs.next)))
 		arch_mutex_cpu_relax();
 
 	arch_mcs_spin_unlock_contended(&next->qhead);
+}
+
+/**
+ * queue_spin_lock_slowpath - acquire the queue spinlock
+ * @lock: Pointer to queue spinlock structure
+ * @val: Current value of the queue spinlock 32-bit word
+ *
+ * (queue tail, pending bit, lock bit)
+ *
+ *              fast     :    slow                                  :    unlock
+ *                       :                                          :
+ * uncontended  (0,0,0) -:--> (0,0,1) ------------------------------:--> (*,*,0)
+ *                       :       | ^--------.------.             /  :
+ *                       :       v           \      \            |  :
+ * pending               :    (0,1,1) +--> (0,1,0)   \           |  :
+ *                       :       | ^--'              |           |  :
+ *                       :       v                   |           |  :
+ * uncontended           :    (n,x,y) +--> (n,0,0) --'           |  :
+ *   queue               :       | ^--'                          |  :
+ *                       :       v                               |  :
+ * contended             :    (*,x,y) +--> (*,0,0) ---> (*,0,1) -'  :
+ *   queue               :         ^--'                             :
+ *
+ * This slowpath only contains the faster pending bit and trylock codes.
+ * The slower queuing code is in the slowerpath function.
+ */
+void queue_spin_lock_slowpath(struct qspinlock *lock, u32 val)
+{
+	struct qnode *node;
+	u32 tail, idx;
+
+	BUILD_BUG_ON(CONFIG_NR_CPUS >= (1U << _Q_TAIL_CPU_BITS));
+
+	if (trylock_pending(lock, &val))
+		return;	/* Lock acquired */
+
+	node = this_cpu_ptr(&qnodes[0]);
+	idx = node->mcs.count++;
+	tail = encode_tail(smp_processor_id(), idx);
+
+	node += idx;
+	node->qhead = 0;
+	node->mcs.next = NULL;
+
+	/*
+	 * We touched a (possibly) cold cacheline; attempt the trylock once
+	 * more in the hope someone let go while we weren't watching as long
+	 * as no one was queuing.
+	 */
+	if ((val & _Q_TAIL_MASK) || !queue_spin_trylock(lock))
+		queue_spin_lock_slowerpath(lock, node, tail);
 
-release:
 	/*
 	 * release the node
 	 */
-- 
1.7.1

