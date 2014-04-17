Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbaDQPFZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 11:05:25 -0400
Received: from g5t1627.atlanta.hp.com ([15.192.137.10]:43382 "EHLO
	g5t1627.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbaDQPEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 11:04:45 -0400
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
Subject: [PATCH v9 04/19] qspinlock: Extract out the exchange of tail code word
Date: Thu, 17 Apr 2014 11:03:56 -0400
Message-Id: <1397747051-15401-5-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1397747051-15401-1-git-send-email-Waiman.Long@hp.com>
References: <1397747051-15401-1-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch extracts the logic for the exchange of new and previous tail
code words into a new xchg_tail() function which can be optimized in a
later patch.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 include/asm-generic/qspinlock_types.h |    2 +
 kernel/locking/qspinlock.c            |   61 +++++++++++++++++++++------------
 2 files changed, 41 insertions(+), 22 deletions(-)

diff --git a/include/asm-generic/qspinlock_types.h b/include/asm-generic/qspinlock_types.h
index bd25081..ed5d89a 100644
--- a/include/asm-generic/qspinlock_types.h
+++ b/include/asm-generic/qspinlock_types.h
@@ -61,6 +61,8 @@ typedef struct qspinlock {
 #define _Q_TAIL_CPU_BITS	(32 - _Q_TAIL_CPU_OFFSET)
 #define _Q_TAIL_CPU_MASK	_Q_SET_MASK(TAIL_CPU)
 
+#define _Q_TAIL_MASK		(_Q_TAIL_IDX_MASK | _Q_TAIL_CPU_MASK)
+
 #define _Q_LOCKED_VAL		(1U << _Q_LOCKED_OFFSET)
 #define _Q_PENDING_VAL		(1U << _Q_PENDING_OFFSET)
 
diff --git a/kernel/locking/qspinlock.c b/kernel/locking/qspinlock.c
index d35362a..fcf06cb 100644
--- a/kernel/locking/qspinlock.c
+++ b/kernel/locking/qspinlock.c
@@ -86,6 +86,34 @@ static inline struct mcs_spinlock *decode_tail(u32 tail)
 #define _Q_LOCKED_PENDING_MASK	(_Q_LOCKED_MASK | _Q_PENDING_MASK)
 
 /**
+ * xchg_tail - Put in the new queue tail code word & retrieve previous one
+ * @lock : Pointer to queue spinlock structure
+ * @tail : The new queue tail code word
+ * @pval : Pointer to current value of the queue spinlock 32-bit word
+ * Return: The previous queue tail code word
+ *
+ * xchg(lock, tail)
+ *
+ * p,*,* -> n,*,* ; prev = xchg(lock, node)
+ */
+static __always_inline u32
+xchg_tail(struct qspinlock *lock, u32 tail, u32 *pval)
+{
+	u32 old, new, val = *pval;
+
+	for (;;) {
+		new = (val & _Q_LOCKED_PENDING_MASK) | tail;
+		old = atomic_cmpxchg(&lock->val, val, new);
+		if (old == val)
+			break;
+
+		val = old;
+	}
+	*pval = new;
+	return old;
+}
+
+/**
  * trylock_pending - try to acquire queue spinlock using the pending bit
  * @lock : Pointer to queue spinlock structure
  * @pval : Pointer to value of the queue spinlock 32-bit word
@@ -192,36 +220,25 @@ void queue_spin_lock_slowpath(struct qspinlock *lock, u32 val)
 	node->next = NULL;
 
 	/*
-	 * we already touched the queueing cacheline; don't bother with pending
-	 * stuff.
-	 *
-	 * trylock || xchg(lock, node)
-	 *
-	 * 0,0,0 -> 0,0,1 ; trylock
-	 * p,y,x -> n,y,x ; prev = xchg(lock, node)
+	 * We touched a (possibly) cold cacheline; attempt the trylock once
+	 * more in the hope someone let go while we weren't watching as long
+	 * as no one was queuing.
 	 */
-	for (;;) {
-		new = _Q_LOCKED_VAL;
-		if (val)
-			new = tail | (val & _Q_LOCKED_PENDING_MASK);
-
-		old = atomic_cmpxchg(&lock->val, val, new);
-		if (old == val)
-			break;
-
-		val = old;
-	}
+	if (!(val & _Q_TAIL_MASK) && queue_spin_trylock(lock))
+		goto release;
 
 	/*
-	 * we won the trylock; forget about queueing.
+	 * we already touched the queueing cacheline; don't bother with pending
+	 * stuff.
+	 *
+	 * p,*,* -> n,*,*
 	 */
-	if (new == _Q_LOCKED_VAL)
-		goto release;
+	old = xchg_tail(lock, tail, &val);
 
 	/*
 	 * if there was a previous node; link it and wait.
 	 */
-	if (old & ~_Q_LOCKED_PENDING_MASK) {
+	if (old & _Q_TAIL_MASK) {
 		prev = decode_tail(old);
 		ACCESS_ONCE(prev->next) = node;
 
-- 
1.7.1

