Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368AbaCJQDz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 12:03:55 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53934 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881AbaCJQCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 12:02:35 -0400
Message-Id: <20140310155543.698785364@infradead.org>
User-Agent: quilt/0.60-1
Date: Mon, 10 Mar 2014 16:42:42 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <waiman.long@hp.com>
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        akpm@linux-foundation.org, walken@google.com, andi@firstfloor.org,
        riel@redhat.com, paulmck@linux.vnet.ibm.com,
        torvalds@linux-foundation.org, oleg@redhat.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: [RFC][PATCH 6/7] qspinlock: Optimize xchg_tail
References: <20140310154236.038181843@infradead.org>
Content-Disposition: inline; filename=peterz-qspinlock-queue-xchg.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the xchg(lock, tail) cmpxchg loop with an actual xchg().

This is a little tricky in that we need to preserve the
(locked,pending) state that is also in this word.

By making sure all wait-acquire loops re-start when they observe lock
wasn't in fact free after all, we can have the initial xchg() op set
the lock bit unconditionally.

This means that even if we raced with an unlock and the wait loop has
already terminated the acquire will stall and we can fix-up any state
we wrecked with the xchg().

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/locking/qspinlock.c |   88 +++++++++++++++++++++++++++++++++------------
 1 file changed, 65 insertions(+), 23 deletions(-)

--- a/kernel/locking/qspinlock.c
+++ b/kernel/locking/qspinlock.c
@@ -115,6 +115,50 @@ try_set_pending(struct qspinlock *lock,
 	return 1;
 }
 
+/*
+ * xchg(lock, tail)
+ *
+ * p,*,* -> n,*,* ; prev = xchg(lock, node)
+ */
+static u32 __always_inline
+xchg_tail(struct qspinlock *lock, u32 tail)
+{
+	u32 old, new, val = atomic_read(&lock->val);
+
+	/*
+	 * guess the pending bit; if we race no harm done because we'll
+	 * unconditionally set the locked bit, so we can always fix up.
+	 *
+	 * we must always assume the lock bit is set; accidentially clearing it
+	 * would release pending waiters and screw up our ordering.
+	 */
+	new = tail | (val & _Q_PENDING_MASK) | _Q_LOCKED_VAL;
+	old = atomic_xchg(&lock->val, new);
+
+	/*
+	 * fixup the pending bit; since we now have a tail the pending bit is
+	 * stable, see try_pending() and since we have the locked bit set,
+	 * nothing can claim the lock and make progress.
+	 */
+	if (unlikely((old & _Q_PENDING_MASK) != (new & _Q_PENDING_MASK))) {
+		if (old & _Q_PENDING_MASK)
+			atomic_clear_mask(_Q_PENDING_MASK, &lock->val);
+		else
+			atomic_set_mask(_Q_PENDING_VAL, &lock->val);
+	}
+
+	/*
+	 * fixup the locked bit; having accidentally set the locked bit
+	 * we must make sure our wait-acquire loops are robust and not
+	 * set the locked bit when its already set, otherwise we cannot
+	 * release here.
+	 */
+	if (unlikely(!(old & _Q_LOCKED_MASK)))
+		queue_spin_unlock(lock);
+
+	return old; /* tail bits are still fine */
+}
+
 #define _Q_LOCKED_PENDING_MASK	(_Q_LOCKED_MASK | _Q_PENDING_MASK)
 
 /**
@@ -155,6 +199,7 @@ void queue_spin_lock_slowpath(struct qsp
 	 *
 	 * *,1,1 -> *,1,0
 	 */
+retry_pending_wait:
 	while ((val = atomic_read(&lock->val)) & _Q_LOCKED_MASK)
 		cpu_relax();
 
@@ -170,6 +215,9 @@ void queue_spin_lock_slowpath(struct qsp
 		if (old == val)
 			break;
 
+		if (unlikely(old & _Q_LOCKED_MASK))
+			goto retry_pending_wait;
+
 		val = old;
 	}
 	return;
@@ -184,37 +232,24 @@ void queue_spin_lock_slowpath(struct qsp
 	node->next = NULL;
 
 	/*
-	 * we already touched the queueing cacheline; don't bother with pending
-	 * stuff.
-	 *
-	 * trylock || xchg(lock, node)
-	 *
-	 * 0,0,0 -> 0,0,1 ; trylock
-	 * p,y,x -> n,y,x ; prev = xchg(lock, node)
+	 * we touched a (possibly) cold cacheline; attempt the trylock once
+	 * more in the hope someone let go while we weren't watching.
 	 */
-	val = atomic_read(&lock->val);
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
+	if (queue_spin_trylock(lock))
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
+	old = xchg_tail(lock, tail);
 
 	/*
 	 * if there was a previous node; link it and wait.
 	 */
-	if (old & ~_Q_LOCKED_PENDING_MASK) {
+	if (old & _Q_TAIL_MASK) {
 		prev = decode_tail(old);
 		ACCESS_ONCE(prev->next) = node;
 
@@ -227,6 +262,7 @@ void queue_spin_lock_slowpath(struct qsp
 	 *
 	 * *,x,y -> *,0,0
 	 */
+retry_queue_wait:
 	while ((val = atomic_read(&lock->val)) & _Q_LOCKED_PENDING_MASK)
 		cpu_relax();
 
@@ -245,6 +281,12 @@ void queue_spin_lock_slowpath(struct qsp
 		if (old == val)
 			break;
 
+		/*
+		 * ensure to never claim a locked value; see xchg_tail().
+		 */
+		if (unlikely(old & _Q_LOCKED_PENDING_MASK))
+			goto retry_queue_wait;
+
 		val = old;
 	}
 


