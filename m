Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418AbaCJQD5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 12:03:57 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53932 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705AbaCJQCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 12:02:35 -0400
Message-Id: <20140310155543.644544511@infradead.org>
User-Agent: quilt/0.60-1
Date: Mon, 10 Mar 2014 16:42:41 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <waiman.long@hp.com>
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        akpm@linux-foundation.org, walken@google.com, andi@firstfloor.org,
        riel@redhat.com, paulmck@linux.vnet.ibm.com,
        torvalds@linux-foundation.org, oleg@redhat.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: [RFC][PATCH 5/7] qspinlock: Optimize the pending case
References: <20140310154236.038181843@infradead.org>
Content-Disposition: inline; filename=peterz-qspinlock-pending-test_and_set_bit.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the initial set-pending cmpxchg() loop with an unconditional
test-and-set bit (x86: bts) instruction.

It looses the direct trylock state transition; however since that should
be very unlikely (we've just done a trylock) that shouldn't be a
problem.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 include/asm-generic/qspinlock_types.h |    2 +
 kernel/locking/qspinlock.c            |   60 +++++++++++++++++++---------------
 2 files changed, 36 insertions(+), 26 deletions(-)

--- a/include/asm-generic/qspinlock_types.h
+++ b/include/asm-generic/qspinlock_types.h
@@ -59,6 +59,8 @@ typedef struct qspinlock {
 #define _Q_TAIL_CPU_BITS	(32 - _Q_TAIL_CPU_OFFSET)
 #define _Q_TAIL_CPU_MASK	(((1U << _Q_TAIL_CPU_BITS) - 1) << _Q_TAIL_CPU_OFFSET)
 
+#define _Q_TAIL_MASK		(_Q_TAIL_IDX_MASK | _Q_TAIL_CPU_MASK)
+
 #define _Q_LOCKED_VAL		(1U << _Q_LOCKED_OFFSET)
 #define _Q_PENDING_VAL		(1U << _Q_PENDING_OFFSET)
 
--- a/kernel/locking/qspinlock.c
+++ b/kernel/locking/qspinlock.c
@@ -83,6 +83,37 @@ static inline struct mcs_spinlock *decod
 	return per_cpu_ptr(&mcs_nodes[idx], cpu);
 }
 
+/*
+ * 0,0,1 -> 0,1,* ; pending
+ *
+ * Ignore the locked bit; if we set pending and locked happens to be clear
+ * we'll fall through on the subsequent wait.
+ */
+static int __always_inline
+try_set_pending(struct qspinlock *lock, u32 val)
+{
+	if (val & ~_Q_LOCKED_MASK)
+		return 0; /* fail; queue */
+
+	/*
+	 * If we find the pending bit was already set; fail and queue.
+	 */
+	if (atomic_test_and_set_bit(_Q_PENDING_OFFSET, &lock->val))
+		return 0;
+
+	/*
+	 * If we raced and someone concurrently set the tail; no problem. He
+	 * need not have observed our pending bit and can have claimed the
+	 * lock.
+	 *
+	 * The next node in line however will wait for the pending to go away
+	 * again though, so in effect we've just flipped order between two
+	 * contenders which already had undetermined order as per the race.
+	 */
+
+	return 1;
+}
+
 #define _Q_LOCKED_PENDING_MASK	(_Q_LOCKED_MASK | _Q_PENDING_MASK)
 
 /**
@@ -115,34 +146,10 @@ void queue_spin_lock_slowpath(struct qsp
 	BUILD_BUG_ON(CONFIG_NR_CPUS >= (1U << _Q_TAIL_CPU_BITS));
 
 	/*
-	 * trylock || pending
-	 *
-	 * 0,0,0 -> 0,0,1 ; trylock
 	 * 0,0,1 -> 0,1,1 ; pending
 	 */
-	for (;;) {
-		/*
-		 * If we observe any contention; queue.
-		 */
-		if (val & ~_Q_LOCKED_MASK)
-			goto queue;
-
-		new = _Q_LOCKED_VAL;
-		if (val == new)
-			new |= _Q_PENDING_VAL;
-
-		old = atomic_cmpxchg(&lock->val, val, new);
-		if (old == val)
-			break;
-
-		val = old;
-	}
-
-	/*
-	 * we won the trylock
-	 */
-	if (new == _Q_LOCKED_VAL)
-		return;
+	if (!try_set_pending(lock, val))
+		goto queue;
 
 	/*
 	 * we're pending, wait for the owner to go away.
@@ -186,6 +193,7 @@ void queue_spin_lock_slowpath(struct qsp
 	 * 0,0,0 -> 0,0,1 ; trylock
 	 * p,y,x -> n,y,x ; prev = xchg(lock, node)
 	 */
+	val = atomic_read(&lock->val);
 	for (;;) {
 		new = _Q_LOCKED_VAL;
 		if (val)


