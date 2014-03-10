Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288AbaCJQCm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 12:02:42 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53939 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035AbaCJQCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 12:02:37 -0400
Message-Id: <20140310155543.537361784@infradead.org>
User-Agent: quilt/0.60-1
Date: Mon, 10 Mar 2014 16:42:39 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <waiman.long@hp.com>
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        akpm@linux-foundation.org, walken@google.com, andi@firstfloor.org,
        riel@redhat.com, paulmck@linux.vnet.ibm.com,
        torvalds@linux-foundation.org, oleg@redhat.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: [RFC][PATCH 3/7] qspinlock: Add pending bit
References: <20140310154236.038181843@infradead.org>
Content-Disposition: inline; filename=peterz-qspinlock-pending.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because the qspinlock needs to touch a second cacheline; add a pending
bit and allow a single in-word spinner before we punt to the second
cacheline.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 include/asm-generic/qspinlock_types.h |   12 +++-
 kernel/locking/qspinlock.c            |   92 ++++++++++++++++++++++++++++------
 2 files changed, 87 insertions(+), 17 deletions(-)

--- a/include/asm-generic/qspinlock_types.h
+++ b/include/asm-generic/qspinlock_types.h
@@ -38,15 +38,20 @@ typedef struct qspinlock {
  * Bitfields in the atomic value:
  *
  *  0- 7: locked byte
- *  8- 9: tail index
- * 10-31: tail cpu (+1)
+ *     8: pending
+ *  9-10: tail index
+ * 11-31: tail cpu (+1)
  */
 
 #define _Q_LOCKED_OFFSET	0
 #define _Q_LOCKED_BITS		8
 #define _Q_LOCKED_MASK		(((1U << _Q_LOCKED_BITS) - 1) << _Q_LOCKED_OFFSET)
 
-#define _Q_TAIL_IDX_OFFSET	(_Q_LOCKED_OFFSET + _Q_LOCKED_BITS)
+#define _Q_PENDING_OFFSET	(_Q_LOCKED_OFFSET + _Q_LOCKED_BITS)
+#define _Q_PENDING_BITS		1
+#define _Q_PENDING_MASK		(((1U << _Q_PENDING_BITS) - 1) << _Q_PENDING_OFFSET)
+
+#define _Q_TAIL_IDX_OFFSET	(_Q_PENDING_OFFSET + _Q_PENDING_BITS)
 #define _Q_TAIL_IDX_BITS	2
 #define _Q_TAIL_IDX_MASK	(((1U << _Q_TAIL_IDX_BITS) - 1) << _Q_TAIL_IDX_OFFSET)
 
@@ -55,5 +60,6 @@ typedef struct qspinlock {
 #define _Q_TAIL_CPU_MASK	(((1U << _Q_TAIL_CPU_BITS) - 1) << _Q_TAIL_CPU_OFFSET)
 
 #define _Q_LOCKED_VAL		(1U << _Q_LOCKED_OFFSET)
+#define _Q_PENDING_VAL		(1U << _Q_PENDING_OFFSET)
 
 #endif /* __ASM_GENERIC_QSPINLOCK_TYPES_H */
--- a/kernel/locking/qspinlock.c
+++ b/kernel/locking/qspinlock.c
@@ -83,6 +83,8 @@ static inline struct mcs_spinlock *decod
 	return per_cpu_ptr(&mcs_nodes[idx], cpu);
 }
 
+#define _Q_LOCKED_PENDING_MASK	(_Q_LOCKED_MASK | _Q_PENDING_MASK)
+
 /**
  * queue_spin_lock_slowpath - acquire the queue spinlock
  * @lock: Pointer to queue spinlock structure
@@ -91,13 +93,16 @@ static inline struct mcs_spinlock *decod
  *
  *              fast      :    slow                                  :    unlock
  *                        :                                          :
- * uncontended  (0,0)   --:--> (0,1) --------------------------------:--> (*,0)
- *                        :       | ^--------.                    /  :
- *                        :       v           \                   |  :
- * uncontended            :    (n,x) --+--> (n,0)                 |  :
+ * uncontended  (0,0,0) --:--> (0,0,1) ------------------------------:--> (*,*,0)
+ *                        :       | ^--------.------.             /  :
+ *                        :       v           \      \            |  :
+ * pending                :    (0,1,1) +--> (0,1,0)   \           |  :
+ *                        :       | ^--'              |           |  :
+ *                        :       v                   |           |  :
+ * uncontended            :    (n,x,y) +--> (n,0,0) --'           |  :
  *   queue                :       | ^--'                          |  :
  *                        :       v                               |  :
- * contended              :    (*,x) --+--> (*,0) -----> (*,1) ---'  :
+ * contended              :    (*,x,y) +--> (*,0,0) ---> (*,0,1) -'  :
  *   queue                :         ^--'                             :
  *
  */
@@ -109,6 +114,61 @@ void queue_spin_lock_slowpath(struct qsp
 
 	BUILD_BUG_ON(CONFIG_NR_CPUS >= (1U << _Q_TAIL_CPU_BITS));
 
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
+queue:
 	node = this_cpu_ptr(&mcs_nodes[0]);
 	idx = node->count++;
 	tail = encode_tail(smp_processor_id(), idx);
@@ -118,15 +178,18 @@ void queue_spin_lock_slowpath(struct qsp
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
@@ -144,7 +207,7 @@ void queue_spin_lock_slowpath(struct qsp
 	/*
 	 * if there was a previous node; link it and wait.
 	 */
-	if (old & ~_Q_LOCKED_MASK) {
+	if (old & ~_Q_LOCKED_PENDING_MASK) {
 		prev = decode_tail(old);
 		ACCESS_ONCE(prev->next) = node;
 
@@ -152,18 +215,19 @@ void queue_spin_lock_slowpath(struct qsp
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


