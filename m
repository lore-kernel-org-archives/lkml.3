Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933357AbaEGPI3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:08:29 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:10011 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933002AbaEGPCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:02:45 -0400
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
Subject: [PATCH v10 08/19] qspinlock: Make a new qnode structure to support virtualization
Date: Wed,  7 May 2014 11:01:36 -0400
Message-Id: <1399474907-22206-9-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1399474907-22206-1-git-send-email-Waiman.Long@hp.com>
References: <1399474907-22206-1-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to support additional virtualization features like unfair lock
and para-virtualized spinlock, it is necessary to store additional
CPU specific data into the queue node structure. As a result, a new
qnode structure is created and the mcs_spinlock structure is now part
of the new structure.

It is also necessary to expand arch_mcs_spin_lock_contended() to the
underlying while loop as additional code will need to be inserted
into the loop.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 kernel/locking/qspinlock.c |   36 +++++++++++++++++++++++-------------
 1 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/kernel/locking/qspinlock.c b/kernel/locking/qspinlock.c
index 0ee1a23..e98d7d4 100644
--- a/kernel/locking/qspinlock.c
+++ b/kernel/locking/qspinlock.c
@@ -57,12 +57,21 @@
 #include "mcs_spinlock.h"
 
 /*
+ * To have additional features for better virtualization support, it is
+ * necessary to store additional data in the queue node structure. So
+ * a new queue node structure will have to be defined and used here.
+ */
+struct qnode {
+	struct mcs_spinlock mcs;
+};
+
+/*
  * Per-CPU queue node structures; we can never have more than 4 nested
  * contexts: task, softirq, hardirq, nmi.
  *
  * Exactly fits one cacheline.
  */
-static DEFINE_PER_CPU_ALIGNED(struct mcs_spinlock, mcs_nodes[4]);
+static DEFINE_PER_CPU_ALIGNED(struct qnode, qnodes[4]);
 
 /*
  * We must be able to distinguish between no-tail and the tail at 0:0,
@@ -79,12 +88,12 @@ static inline u32 encode_tail(int cpu, int idx)
 	return tail;
 }
 
-static inline struct mcs_spinlock *decode_tail(u32 tail)
+static inline struct qnode *decode_tail(u32 tail)
 {
 	int cpu = (tail >> _Q_TAIL_CPU_OFFSET) - 1;
 	int idx = (tail &  _Q_TAIL_IDX_MASK) >> _Q_TAIL_IDX_OFFSET;
 
-	return per_cpu_ptr(&mcs_nodes[idx], cpu);
+	return per_cpu_ptr(&qnodes[idx], cpu);
 }
 
 #define _Q_LOCKED_PENDING_MASK	(_Q_LOCKED_MASK | _Q_PENDING_MASK)
@@ -342,7 +351,7 @@ static inline int trylock_pending(struct qspinlock *lock, u32 *pval)
  */
 void queue_spin_lock_slowpath(struct qspinlock *lock, u32 val)
 {
-	struct mcs_spinlock *prev, *next, *node;
+	struct qnode *prev, *next, *node;
 	u32 old, tail;
 	int idx;
 
@@ -351,13 +360,13 @@ void queue_spin_lock_slowpath(struct qspinlock *lock, u32 val)
 	if (trylock_pending(lock, &val))
 		return;	/* Lock acquired */
 
-	node = this_cpu_ptr(&mcs_nodes[0]);
-	idx = node->count++;
+	node = this_cpu_ptr(&qnodes[0]);
+	idx = node->mcs.count++;
 	tail = encode_tail(smp_processor_id(), idx);
 
 	node += idx;
-	node->locked = 0;
-	node->next = NULL;
+	node->mcs.locked = 0;
+	node->mcs.next = NULL;
 
 	/*
 	 * We touched a (possibly) cold cacheline in the per-cpu queue node;
@@ -380,9 +389,10 @@ void queue_spin_lock_slowpath(struct qspinlock *lock, u32 val)
 	 */
 	if (old & _Q_TAIL_MASK) {
 		prev = decode_tail(old);
-		ACCESS_ONCE(prev->next) = node;
+		ACCESS_ONCE(prev->mcs.next) = (struct mcs_spinlock *)node;
 
-		arch_mcs_spin_lock_contended(&node->locked);
+		while (!smp_load_acquire(&node->mcs.locked))
+			arch_mutex_cpu_relax();
 	}
 
 	/*
@@ -422,15 +432,15 @@ void queue_spin_lock_slowpath(struct qspinlock *lock, u32 val)
 	/*
 	 * contended path; wait for next, release.
 	 */
-	while (!(next = ACCESS_ONCE(node->next)))
+	while (!(next = (struct qnode *)ACCESS_ONCE(node->mcs.next)))
 		arch_mutex_cpu_relax();
 
-	arch_mcs_spin_unlock_contended(&next->locked);
+	arch_mcs_spin_unlock_contended(&next->mcs.locked);
 
 release:
 	/*
 	 * release the node
 	 */
-	this_cpu_dec(mcs_nodes[0].count);
+	this_cpu_dec(qnodes[0].mcs.count);
 }
 EXPORT_SYMBOL(queue_spin_lock_slowpath);
-- 
1.7.1

