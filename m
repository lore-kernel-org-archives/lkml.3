Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965266AbaE3Pqp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 11:46:45 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:39357 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965026AbaE3Pqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 11:46:42 -0400
From: Waiman Long <Waiman.Long@hp.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-arch@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>,
        Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH v11 13/16] pvqspinlock: Enable coexistence with the unfair lock
Date: Fri, 30 May 2014 11:43:59 -0400
Message-Id: <1401464642-33890-14-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1401464642-33890-1-git-send-email-Waiman.Long@hp.com>
References: <1401464642-33890-1-git-send-email-Waiman.Long@hp.com>
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
 kernel/locking/qspinlock.c |   47 ++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 43 insertions(+), 4 deletions(-)

diff --git a/kernel/locking/qspinlock.c b/kernel/locking/qspinlock.c
index 93c663a..8deedcf 100644
--- a/kernel/locking/qspinlock.c
+++ b/kernel/locking/qspinlock.c
@@ -57,12 +57,24 @@
 #include "mcs_spinlock.h"
 
 /*
+ * Check the pending bit spinning threshold only if PV qspinlock is enabled
+ */
+#define PSPIN_THRESHOLD		(1 << 10)
+#define MAX_NODES		4
+
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
  * Exactly fits one cacheline.
  */
-static DEFINE_PER_CPU_ALIGNED(struct mcs_spinlock, mcs_nodes[4]);
+static DEFINE_PER_CPU_ALIGNED(struct mcs_spinlock, mcs_nodes[MAX_NODES]);
 
 /*
  * We must be able to distinguish between no-tail and the tail at 0:0,
@@ -265,6 +277,9 @@ static noinline void queue_spin_lock_slowerpath(struct qspinlock *lock,
 		ACCESS_ONCE(prev->next) = node;
 
 		arch_mcs_spin_lock_contended(&node->locked);
+	} else {
+		/* Mark it as the queue head */
+		ACCESS_ONCE(node->locked) = true;
 	}
 
 	/*
@@ -344,14 +359,17 @@ void queue_spin_lock_slowpath(struct qspinlock *lock, u32 val)
 	struct mcs_spinlock *node;
 	u32 new, old, tail;
 	int idx;
+	int retry = INT_MAX;	/* Retry count, queue if <= 0 */
 
 	BUILD_BUG_ON(CONFIG_NR_CPUS >= (1U << _Q_TAIL_CPU_BITS));
 
 #ifdef CONFIG_VIRT_UNFAIR_LOCKS
 	/*
 	 * A simple test and set unfair lock
+	 * Disable waiter lock stealing if PV spinlock is enabled
 	 */
-	if (static_key_false(&virt_unfairlocks_enabled)) {
+	if (!pv_qspinlock_enabled() &&
+	    static_key_false(&virt_unfairlocks_enabled)) {
 		cpu_relax();	/* Relax after a failed lock attempt */
 		while (!queue_spin_trylock(lock))
 			cpu_relax();
@@ -360,6 +378,14 @@ void queue_spin_lock_slowpath(struct qspinlock *lock, u32 val)
 #endif /* CONFIG_VIRT_UNFAIR_LOCKS */
 
 	/*
+	 * When PV qspinlock is enabled, exit the pending bit code path and
+	 * go back to the regular queuing path if the lock isn't available
+	 * within a certain threshold.
+	 */
+	if (pv_qspinlock_enabled())
+		retry = PSPIN_THRESHOLD;
+
+	/*
 	 * trylock || pending
 	 *
 	 * 0,0,0 -> 0,0,1 ; trylock
@@ -370,7 +396,7 @@ void queue_spin_lock_slowpath(struct qspinlock *lock, u32 val)
 		 * If we observe that the queue is not empty or both
 		 * the pending and lock bits are set, queue
 		 */
-		if ((val & _Q_TAIL_MASK) ||
+		if ((val & _Q_TAIL_MASK) || (retry-- <= 0) ||
 		    (val == (_Q_LOCKED_VAL|_Q_PENDING_VAL)))
 			goto queue;
 
@@ -413,8 +439,21 @@ void queue_spin_lock_slowpath(struct qspinlock *lock, u32 val)
 	 * sequentiality; this because not all clear_pending_set_locked()
 	 * implementations imply full barriers.
 	 */
-	while ((val = smp_load_acquire(&lock->val.counter)) & _Q_LOCKED_MASK)
+	while ((val = smp_load_acquire(&lock->val.counter)) & _Q_LOCKED_MASK) {
+		if (pv_qspinlock_enabled() && (retry-- <= 0)) {
+			/*
+			 * Clear the pending bit and queue
+			 */
+			for (;;) {
+				new = val & ~_Q_PENDING_MASK;
+				old = atomic_cmpxchg(&lock->val, val, new);
+				if (old == val)
+					goto queue;
+				val = old;
+			}
+		}
 		arch_mutex_cpu_relax();
+	}
 
 	/*
 	 * take ownership and clear the pending bit.
-- 
1.7.1

