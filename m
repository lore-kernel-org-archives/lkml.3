Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856AbaDQPHm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 11:07:42 -0400
Received: from g5t1627.atlanta.hp.com ([15.192.137.10]:43695 "EHLO
	g5t1627.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbaDQPFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 11:05:01 -0400
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
Subject: [PATCH v9 16/19] pvqspinlock: Enable coexistence with the unfair lock
Date: Thu, 17 Apr 2014 11:04:08 -0400
Message-Id: <1397747051-15401-17-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1397747051-15401-1-git-send-email-Waiman.Long@hp.com>
References: <1397747051-15401-1-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables the coexistence of both the PV qspinlock and
unfair lock.  When both are enabled, however, only the lock fastpath
will perform lock stealing whereas the slowpath will have that disabled
to get the best of both features.

We also need to transition a CPU spinning too long in the pending
bit code path back to the regular queuing code path so that it can
be properly halted by the PV qspinlock code.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 kernel/locking/qspinlock.c |   74 ++++++++++++++++++++++++++++++++++++++------
 1 files changed, 64 insertions(+), 10 deletions(-)

diff --git a/kernel/locking/qspinlock.c b/kernel/locking/qspinlock.c
index f9c82f6..21421a6 100644
--- a/kernel/locking/qspinlock.c
+++ b/kernel/locking/qspinlock.c
@@ -76,6 +76,30 @@ struct qnode {
 #define qhead	mcs.locked	/* The queue head flag */
 
 /*
+ * Allow spinning loop count only if either PV spinlock or unfair lock is
+ * configured.
+ */
+#if defined(CONFIG_PARAVIRT_UNFAIR_LOCKS) || defined(CONFIG_PARAVIRT_SPINLOCKS)
+#define	DEF_LOOP_CNT(c)		int c = 0
+#define	INC_LOOP_CNT(c)		(c)++
+#define	LOOP_CNT(c)		c
+#else
+#define	DEF_LOOP_CNT(c)
+#define	INC_LOOP_CNT(c)
+#define	LOOP_CNT(c)		0
+#endif
+
+/*
+ * Check the pending bit spinning threshold only if PV qspinlock is enabled
+ */
+#define PSPIN_THRESHOLD		(1 << 10)
+#ifdef CONFIG_PARAVIRT_SPINLOCKS
+#define pv_qspinlock_enabled()	static_key_false(&paravirt_spinlocks_enabled)
+#else
+#define pv_qspinlock_enabled()	false
+#endif
+
+/*
  * Per-CPU queue node structures; we can never have more than 4 nested
  * contexts: task, softirq, hardirq, nmi.
  *
@@ -306,9 +330,6 @@ cmpxchg_tail(struct qspinlock *lock, u32 old, u32 new)
  * starvation.
  */
 #ifdef CONFIG_PARAVIRT_UNFAIR_LOCKS
-#define DEF_LOOP_CNT(c)		int c = 0
-#define INC_LOOP_CNT(c)		(c)++
-#define LOOP_CNT(c)		c
 #define LSTEAL_MIN		(1 << 3)
 #define LSTEAL_MAX		(1 << 10)
 #define LSTEAL_MIN_MASK		(LSTEAL_MIN - 1)
@@ -334,7 +355,11 @@ static inline void unfair_init_vars(struct qnode *node)
 static inline void
 unfair_set_vars(struct qnode *node, struct qnode *prev, u32 prev_tail)
 {
-	if (!static_key_false(&paravirt_unfairlocks_enabled))
+	/*
+	 * Disable waiter lock stealing if PV spinlock is enabled
+	 */
+	if (pv_qspinlock_enabled() ||
+	   !static_key_false(&paravirt_unfairlocks_enabled))
 		return;
 
 	node->qprev	= prev;
@@ -360,7 +385,11 @@ unfair_set_vars(struct qnode *node, struct qnode *prev, u32 prev_tail)
  */
 static inline int unfair_check_and_clear_tail(struct qspinlock *lock, u32 tail)
 {
-	if (!static_key_false(&paravirt_unfairlocks_enabled))
+	/*
+	 * Disable waiter lock stealing if PV spinlock is enabled
+	 */
+	if (pv_qspinlock_enabled() ||
+	   !static_key_false(&paravirt_unfairlocks_enabled))
 		return false;
 
 	/*
@@ -389,7 +418,11 @@ unfair_get_lock(struct qspinlock *lock, struct qnode *node, u32 tail, int count)
 	int	     isqhead;
 	struct qnode *next;
 
-	if (!static_key_false(&paravirt_unfairlocks_enabled) ||
+	/*
+	 * Disable waiter lock stealing if PV spinlock is enabled
+	 */
+	if (pv_qspinlock_enabled() ||
+	   !static_key_false(&paravirt_unfairlocks_enabled) ||
 	   ((count & node->lsteal_mask) != node->lsteal_mask))
 		return false;
 
@@ -467,9 +500,6 @@ unfair_get_lock(struct qspinlock *lock, struct qnode *node, u32 tail, int count)
 }
 
 #else /* CONFIG_PARAVIRT_UNFAIR_LOCKS */
-#define	DEF_LOOP_CNT(c)
-#define	INC_LOOP_CNT(c)
-#define	LOOP_CNT(c)	0
 
 static void unfair_init_vars(struct qnode *node)	{}
 static void unfair_set_vars(struct qnode *node, struct qnode *prev,
@@ -587,9 +617,28 @@ static inline int trylock_pending(struct qspinlock *lock, u32 *pval)
 	 * store-release that clears the locked bit and create lock
 	 * sequentiality; this because not all try_clear_pending_set_locked()
 	 * implementations imply full barriers.
+	 *
+	 * When PV qspinlock is enabled, exit the pending bit code path and
+	 * go back to the regular queuing path if the lock isn't available
+	 * within a certain threshold.
 	 */
-	while ((val = smp_load_acquire(&lock->val.counter)) & _Q_LOCKED_MASK)
+	if (pv_qspinlock_enabled())
+		retry = PSPIN_THRESHOLD;
+	while ((val = smp_load_acquire(&lock->val.counter)) & _Q_LOCKED_MASK) {
+		if (pv_qspinlock_enabled() && (--retry == 0)) {
+			/*
+			 * Clear the pending bit and exit
+			 */
+			for (;;) {
+				new = val & ~_Q_PENDING_MASK;
+				old = atomic_cmpxchg(&lock->val, val, new);
+				if (old == val)
+					return 0;
+				val = old;
+			}
+		}
 		arch_mutex_cpu_relax();
+	}
 
 	/*
 	 * take ownership and clear the pending bit.
@@ -650,6 +699,8 @@ queue_spin_lock_slowerpath(struct qspinlock *lock, struct qnode *node, u32 tail)
 			}
 			arch_mutex_cpu_relax();
 		}
+	} else {
+		ACCESS_ONCE(node->qhead) = true;
 	}
 
 	/*
@@ -717,6 +768,9 @@ notify_next:
 	while (!(next = (struct qnode *)ACCESS_ONCE(node->mcs.next)))
 		arch_mutex_cpu_relax();
 
+	/*
+	 * The next one in queue is now at the head
+	 */
 	arch_mcs_spin_unlock_contended(&next->qhead);
 }
 
-- 
1.7.1

