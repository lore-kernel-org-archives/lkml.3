Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890AbbATUNP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 15:13:15 -0500
Received: from g4t3427.houston.hp.com ([15.201.208.55]:57427 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736AbbATUNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 15:13:12 -0500
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
        Oleg Nesterov <oleg@redhat.com>, Scott J Norton <scott.norton@hp.com>,
        Douglas Hatch <doug.hatch@hp.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH v14 03/11] qspinlock: Add pending bit
Date: Tue, 20 Jan 2015 15:12:27 -0500
Message-Id: <1421784755-21945-4-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1421784755-21945-1-git-send-email-Waiman.Long@hp.com>
References: <1421784755-21945-1-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

Because the qspinlock needs to touch a second cacheline (the per-cpu
mcs_nodes[]); add a pending bit and allow a single in-word spinner
before we punt to the second cacheline.

It is possible so observe the pending bit without the locked bit when
the last owner has just released but the pending owner has not yet
taken ownership.

In this case we would normally queue -- because the pending bit is
already taken. However, in this case the pending bit is guaranteed
to be released 'soon', therefore wait for it and avoid queueing.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 include/asm-generic/qspinlock_types.h |   12 +++-
 kernel/locking/qspinlock.c            |  119 +++++++++++++++++++++++++++------
 2 files changed, 107 insertions(+), 24 deletions(-)

diff --git a/include/asm-generic/qspinlock_types.h b/include/asm-generic/qspinlock_types.h
index 67a2110..4196694 100644
--- a/include/asm-generic/qspinlock_types.h
+++ b/include/asm-generic/qspinlock_types.h
@@ -36,8 +36,9 @@ typedef struct qspinlock {
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
@@ -45,7 +46,11 @@ typedef struct qspinlock {
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
 
@@ -54,5 +59,6 @@ typedef struct qspinlock {
 #define _Q_TAIL_CPU_MASK	_Q_SET_MASK(TAIL_CPU)
 
 #define _Q_LOCKED_VAL		(1U << _Q_LOCKED_OFFSET)
+#define _Q_PENDING_VAL		(1U << _Q_PENDING_OFFSET)
 
 #endif /* __ASM_GENERIC_QSPINLOCK_TYPES_H */
diff --git a/kernel/locking/qspinlock.c b/kernel/locking/qspinlock.c
index c114076..226b11d 100644
--- a/kernel/locking/qspinlock.c
+++ b/kernel/locking/qspinlock.c
@@ -92,24 +92,28 @@ static inline struct mcs_spinlock *decode_tail(u32 tail)
 	return per_cpu_ptr(&mcs_nodes[idx], cpu);
 }
 
+#define _Q_LOCKED_PENDING_MASK (_Q_LOCKED_MASK | _Q_PENDING_MASK)
+
 /**
  * queue_spin_lock_slowpath - acquire the queue spinlock
  * @lock: Pointer to queue spinlock structure
  * @val: Current value of the queue spinlock 32-bit word
  *
- * (queue tail, lock value)
- *
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
+ * (queue tail, pending bit, lock value)
  *
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
  */
 void queue_spin_lock_slowpath(struct qspinlock *lock, u32 val)
 {
@@ -119,6 +123,75 @@ void queue_spin_lock_slowpath(struct qspinlock *lock, u32 val)
 
 	BUILD_BUG_ON(CONFIG_NR_CPUS >= (1U << _Q_TAIL_CPU_BITS));
 
+	/*
+	 * wait for in-progress pending->locked hand-overs
+	 *
+	 * 0,1,0 -> 0,0,1
+	 */
+	if (val == _Q_PENDING_VAL) {
+		while ((val = atomic_read(&lock->val)) == _Q_PENDING_VAL)
+			cpu_relax();
+	}
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
+			goto queue;
+
+		new = _Q_LOCKED_VAL;
+		if (val == new)
+			new |= _Q_PENDING_VAL;
+
+		old = atomic_cmpxchg(&lock->val, val, new);
+		if (old == val)
+			break;
+
+		val = old;
+	}
+
+	/*
+	 * we won the trylock
+	 */
+	if (new == _Q_LOCKED_VAL)
+		return;
+
+	/*
+	 * we're pending, wait for the owner to go away.
+	 *
+	 * *,1,1 -> *,1,0
+	 */
+	while ((val = atomic_read(&lock->val)) & _Q_LOCKED_MASK)
+		cpu_relax();
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
+	return;
+
+	/*
+	 * End of pending bit optimistic spinning and beginning of MCS
+	 * queuing.
+	 */
+queue:
 	node = this_cpu_ptr(&mcs_nodes[0]);
 	idx = node->count++;
 	tail = encode_tail(smp_processor_id(), idx);
@@ -128,15 +201,18 @@ void queue_spin_lock_slowpath(struct qspinlock *lock, u32 val)
 	node->next = NULL;
 
 	/*
+	 * We have already touched the queueing cacheline; don't bother with
+	 * pending stuff.
+	 *
 	 * trylock || xchg(lock, node)
 	 *
-	 * 0,0 -> 0,1 ; no tail, not locked -> no tail, locked.
-	 * p,x -> n,x ; tail was p -> tail is n; preserving locked.
+	 * 0,0,0 -> 0,0,1 ; no tail, not locked -> no tail, locked.
+	 * p,y,x -> n,y,x ; tail was p -> tail is n; preserving locked.
 	 */
 	for (;;) {
 		new = _Q_LOCKED_VAL;
 		if (val)
-			new = tail | (val & _Q_LOCKED_MASK);
+			new = tail | (val & _Q_LOCKED_PENDING_MASK);
 
 		old = atomic_cmpxchg(&lock->val, val, new);
 		if (old == val)
@@ -155,7 +231,7 @@ void queue_spin_lock_slowpath(struct qspinlock *lock, u32 val)
 	 * if there was a previous node; link it and wait until reaching the
 	 * head of the waitqueue.
 	 */
-	if (old & ~_Q_LOCKED_MASK) {
+	if (old & ~_Q_LOCKED_PENDING_MASK) {
 		prev = decode_tail(old);
 		ACCESS_ONCE(prev->next) = node;
 
@@ -163,18 +239,19 @@ void queue_spin_lock_slowpath(struct qspinlock *lock, u32 val)
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
 		cpu_relax();
 
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

