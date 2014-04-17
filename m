Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680AbaDQPNS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 11:13:18 -0400
Received: from g5t1626.atlanta.hp.com ([15.192.137.9]:27720 "EHLO
	g5t1626.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbaDQPEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 11:04:44 -0400
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
        Waiman Long <Waiman.Long@hp.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH v9 03/19] qspinlock: Add pending bit
Date: Thu, 17 Apr 2014 11:03:55 -0400
Message-Id: <1397747051-15401-4-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1397747051-15401-1-git-send-email-Waiman.Long@hp.com>
References: <1397747051-15401-1-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because the qspinlock needs to touch a second cacheline; add a pending
bit and allow a single in-word spinner before we punt to the second
cacheline.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 include/asm-generic/qspinlock_types.h |   12 +++-
 kernel/locking/qspinlock.c            |  117 +++++++++++++++++++++++++++------
 2 files changed, 106 insertions(+), 23 deletions(-)

diff --git a/include/asm-generic/qspinlock_types.h b/include/asm-generic/qspinlock_types.h
index f66f845..bd25081 100644
--- a/include/asm-generic/qspinlock_types.h
+++ b/include/asm-generic/qspinlock_types.h
@@ -39,8 +39,9 @@ typedef struct qspinlock {
  * Bitfields in the atomic value:
  *
  *  0- 7: locked byte
- *  8- 9: tail index
- * 10-31: tail cpu (+1)
+ *     8: pending
+ *  9-10: tail index
+ * 11-31: tail cpu (+1)
  */
 #define	_Q_SET_MASK(type)	(((1U << _Q_ ## type ## _BITS) - 1)\
 				      << _Q_ ## type ## _OFFSET)
@@ -48,7 +49,11 @@ typedef struct qspinlock {
 #define _Q_LOCKED_BITS		8
 #define _Q_LOCKED_MASK		_Q_SET_MASK(LOCKED)
 
-#define _Q_TAIL_IDX_OFFSET	(_Q_LOCKED_OFFSET + _Q_LOCKED_BITS)
+#define _Q_PENDING_OFFSET	(_Q_LOCKED_OFFSET + _Q_LOCKED_BITS)
+#define _Q_PENDING_BITS		1
+#define _Q_PENDING_MASK		_Q_SET_MASK(PENDING)
+
+#define _Q_TAIL_IDX_OFFSET	(_Q_PENDING_OFFSET + _Q_PENDING_BITS)
 #define _Q_TAIL_IDX_BITS	2
 #define _Q_TAIL_IDX_MASK	_Q_SET_MASK(TAIL_IDX)
 
@@ -57,5 +62,6 @@ typedef struct qspinlock {
 #define _Q_TAIL_CPU_MASK	_Q_SET_MASK(TAIL_CPU)
 
 #define _Q_LOCKED_VAL		(1U << _Q_LOCKED_OFFSET)
+#define _Q_PENDING_VAL		(1U << _Q_PENDING_OFFSET)
 
 #endif /* __ASM_GENERIC_QSPINLOCK_TYPES_H */
diff --git a/kernel/locking/qspinlock.c b/kernel/locking/qspinlock.c
index b97a1ad..d35362a 100644
--- a/kernel/locking/qspinlock.c
+++ b/kernel/locking/qspinlock.c
@@ -83,23 +83,93 @@ static inline struct mcs_spinlock *decode_tail(u32 tail)
 	return per_cpu_ptr(&mcs_nodes[idx], cpu);
 }
 
+#define _Q_LOCKED_PENDING_MASK	(_Q_LOCKED_MASK | _Q_PENDING_MASK)
+
+/**
+ * trylock_pending - try to acquire queue spinlock using the pending bit
+ * @lock : Pointer to queue spinlock structure
+ * @pval : Pointer to value of the queue spinlock 32-bit word
+ * Return: 1 if lock acquired, 0 otherwise
+ */
+static inline int trylock_pending(struct qspinlock *lock, u32 *pval)
+{
+	u32 old, new, val = *pval;
+
+	/*
+	 * trylock || pending
+	 *
+	 * 0,0,0 -> 0,0,1 ; trylock
+	 * 0,0,1 -> 0,1,1 ; pending
+	 */
+	for (;;) {
+		/*
+		 * If we observe any contention; queue.
+		 */
+		if (val & ~_Q_LOCKED_MASK)
+			return 0;
+
+		new = _Q_LOCKED_VAL;
+		if (val == new)
+			new |= _Q_PENDING_VAL;
+
+		old = atomic_cmpxchg(&lock->val, val, new);
+		if (old == val)
+			break;
+
+		*pval = val = old;
+	}
+
+	/*
+	 * we won the trylock
+	 */
+	if (new == _Q_LOCKED_VAL)
+		return 1;
+
+	/*
+	 * we're pending, wait for the owner to go away.
+	 *
+	 * *,1,1 -> *,1,0
+	 */
+	while ((val = atomic_read(&lock->val)) & _Q_LOCKED_MASK)
+		arch_mutex_cpu_relax();
+
+	/*
+	 * take ownership and clear the pending bit.
+	 *
+	 * *,1,0 -> *,0,1
+	 */
+	for (;;) {
+		new = (val & ~_Q_PENDING_MASK) | _Q_LOCKED_VAL;
+
+		old = atomic_cmpxchg(&lock->val, val, new);
+		if (old == val)
+			break;
+
+		val = old;
+	}
+	return 1;
+}
+
 /**
  * queue_spin_lock_slowpath - acquire the queue spinlock
  * @lock: Pointer to queue spinlock structure
  * @val: Current value of the queue spinlock 32-bit word
  *
- * (queue tail, lock bit)
+ * (queue tail, pending bit, lock bit)
  *
- *              fast      :    slow                                  :    unlock
- *                        :                                          :
- * uncontended  (0,0)   --:--> (0,1) --------------------------------:--> (*,0)
- *                        :       | ^--------.                    /  :
- *                        :       v           \                   |  :
- * uncontended            :    (n,x) --+--> (n,0)                 |  :
- *   queue                :       | ^--'                          |  :
- *                        :       v                               |  :
- * contended              :    (*,x) --+--> (*,0) -----> (*,1) ---'  :
- *   queue                :         ^--'                             :
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
  *
  */
 void queue_spin_lock_slowpath(struct qspinlock *lock, u32 val)
@@ -110,6 +180,9 @@ void queue_spin_lock_slowpath(struct qspinlock *lock, u32 val)
 
 	BUILD_BUG_ON(CONFIG_NR_CPUS >= (1U << _Q_TAIL_CPU_BITS));
 
+	if (trylock_pending(lock, &val))
+		return;	/* Lock acquired */
+
 	node = this_cpu_ptr(&mcs_nodes[0]);
 	idx = node->count++;
 	tail = encode_tail(smp_processor_id(), idx);
@@ -119,15 +192,18 @@ void queue_spin_lock_slowpath(struct qspinlock *lock, u32 val)
 	node->next = NULL;
 
 	/*
+	 * we already touched the queueing cacheline; don't bother with pending
+	 * stuff.
+	 *
 	 * trylock || xchg(lock, node)
 	 *
-	 * 0,0 -> 0,1 ; trylock
-	 * p,x -> n,x ; prev = xchg(lock, node)
+	 * 0,0,0 -> 0,0,1 ; trylock
+	 * p,y,x -> n,y,x ; prev = xchg(lock, node)
 	 */
 	for (;;) {
 		new = _Q_LOCKED_VAL;
 		if (val)
-			new = tail | (val & _Q_LOCKED_MASK);
+			new = tail | (val & _Q_LOCKED_PENDING_MASK);
 
 		old = atomic_cmpxchg(&lock->val, val, new);
 		if (old == val)
@@ -145,7 +221,7 @@ void queue_spin_lock_slowpath(struct qspinlock *lock, u32 val)
 	/*
 	 * if there was a previous node; link it and wait.
 	 */
-	if (old & ~_Q_LOCKED_MASK) {
+	if (old & ~_Q_LOCKED_PENDING_MASK) {
 		prev = decode_tail(old);
 		ACCESS_ONCE(prev->next) = node;
 
@@ -153,18 +229,19 @@ void queue_spin_lock_slowpath(struct qspinlock *lock, u32 val)
 	}
 
 	/*
-	 * we're at the head of the waitqueue, wait for the owner to go away.
+	 * we're at the head of the waitqueue, wait for the owner & pending to
+	 * go away.
 	 *
-	 * *,x -> *,0
+	 * *,x,y -> *,0,0
 	 */
-	while ((val = atomic_read(&lock->val)) & _Q_LOCKED_MASK)
+	while ((val = atomic_read(&lock->val)) & _Q_LOCKED_PENDING_MASK)
 		arch_mutex_cpu_relax();
 
 	/*
 	 * claim the lock:
 	 *
-	 * n,0 -> 0,1 : lock, uncontended
-	 * *,0 -> *,1 : lock, contended
+	 * n,0,0 -> 0,0,1 : lock, uncontended
+	 * *,0,0 -> *,0,1 : lock, contended
 	 */
 	for (;;) {
 		new = _Q_LOCKED_VAL;
-- 
1.7.1

