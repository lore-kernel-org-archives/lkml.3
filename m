Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965181AbaE3PqX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 11:46:23 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:3412 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965026AbaE3PqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 11:46:17 -0400
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
Subject: [PATCH v11 10/16] qspinlock: Split the MCS queuing code into a separate slowerpath
Date: Fri, 30 May 2014 11:43:56 -0400
Message-Id: <1401464642-33890-11-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1401464642-33890-1-git-send-email-Waiman.Long@hp.com>
References: <1401464642-33890-1-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the pending addition of more codes to support PV spinlock, the
complexity of the slowpath function increases to the point that the
number of scratch-pad registers in the x86-64 architecture is not
enough and so those additional non-scratch-pad registers will need
to be used. This has the downside of requiring saving and restoring
of those registers in the prolog and epilog of the slowpath function
slowing down the nominally faster pending bit and trylock code path
at the beginning of the slowpath function.

This patch separates out the actual MCS queuing code into a slowerpath
function. This avoids the slow down of the pending bit and trylock
code path at the expense of a little bit of additional overhead to
the MCS queuing code path.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 kernel/locking/qspinlock.c |  162 ++++++++++++++++++++++++-------------------
 1 files changed, 90 insertions(+), 72 deletions(-)

diff --git a/kernel/locking/qspinlock.c b/kernel/locking/qspinlock.c
index 3723c83..93c663a 100644
--- a/kernel/locking/qspinlock.c
+++ b/kernel/locking/qspinlock.c
@@ -232,6 +232,93 @@ static __always_inline int try_set_locked(struct qspinlock *lock)
 }
 
 /**
+ * queue_spin_lock_slowerpath - a slower patch for acquiring queue spinlock
+ * @lock: Pointer to queue spinlock structure
+ * @node: Pointer to the queue node
+ * @tail: The tail code
+ *
+ * The reason for splitting a slowerpath from slowpath is to avoid the
+ * unnecessary overhead of non-scratch pad register pushing and popping
+ * due to increased complexity with unfair and PV spinlock from slowing
+ * down the nominally faster pending bit and trylock code path. So this
+ * function is not inlined.
+ */
+static noinline void queue_spin_lock_slowerpath(struct qspinlock *lock,
+			struct mcs_spinlock *node, u32 tail)
+{
+	struct mcs_spinlock *prev, *next;
+	u32 val, old;
+
+	/*
+	 * we already touched the queueing cacheline; don't bother with pending
+	 * stuff.
+	 *
+	 * p,*,* -> n,*,*
+	 */
+	old = xchg_tail(lock, tail);
+
+	/*
+	 * if there was a previous node; link it and wait.
+	 */
+	if (old & _Q_TAIL_MASK) {
+		prev = decode_tail(old);
+		ACCESS_ONCE(prev->next) = node;
+
+		arch_mcs_spin_lock_contended(&node->locked);
+	}
+
+	/*
+	 * we're at the head of the waitqueue, wait for the owner & pending to
+	 * go away.
+	 * Load-acquired is used here because the try_set_locked()
+	 * function below may not be a full memory barrier.
+	 *
+	 * *,x,y -> *,0,0
+	 */
+retry_queue_wait:
+	while ((val = smp_load_acquire(&lock->val.counter))
+				       & _Q_LOCKED_PENDING_MASK)
+		arch_mutex_cpu_relax();
+
+	/*
+	 * claim the lock:
+	 *
+	 * n,0,0 -> 0,0,1 : lock, uncontended
+	 * *,0,0 -> *,0,1 : lock, contended
+	 *
+	 * If the queue head is the only one in the queue (lock value == tail),
+	 * clear the tail code and grab the lock. Otherwise, we only need
+	 * to grab the lock.
+	 */
+	for (;;) {
+		if (val != tail) {
+			/*
+			 * The try_set_locked function will only failed if the
+			 * lock was stolen.
+			 */
+			if (try_set_locked(lock))
+				break;
+			else
+				goto  retry_queue_wait;
+		}
+		old = atomic_cmpxchg(&lock->val, val, _Q_LOCKED_VAL);
+		if (old == val)
+			return;	/* No contention */
+		else if (old &  _Q_LOCKED_MASK)
+			goto retry_queue_wait;
+		val = old;
+	}
+
+	/*
+	 * contended path; wait for next
+	 */
+	while (!(next = ACCESS_ONCE(node->next)))
+		arch_mutex_cpu_relax();
+
+	arch_mcs_spin_unlock_contended(&next->locked);
+}
+
+/**
  * queue_spin_lock_slowpath - acquire the queue spinlock
  * @lock: Pointer to queue spinlock structure
  * @val: Current value of the queue spinlock 32-bit word
@@ -254,7 +341,7 @@ static __always_inline int try_set_locked(struct qspinlock *lock)
  */
 void queue_spin_lock_slowpath(struct qspinlock *lock, u32 val)
 {
-	struct mcs_spinlock *prev, *next, *node;
+	struct mcs_spinlock *node;
 	u32 new, old, tail;
 	int idx;
 
@@ -355,78 +442,9 @@ queue:
 	 * attempt the trylock once more in the hope someone let go while we
 	 * weren't watching.
 	 */
-	if (queue_spin_trylock(lock))
-		goto release;
-
-	/*
-	 * we already touched the queueing cacheline; don't bother with pending
-	 * stuff.
-	 *
-	 * p,*,* -> n,*,*
-	 */
-	old = xchg_tail(lock, tail);
-
-	/*
-	 * if there was a previous node; link it and wait.
-	 */
-	if (old & _Q_TAIL_MASK) {
-		prev = decode_tail(old);
-		ACCESS_ONCE(prev->next) = node;
-
-		arch_mcs_spin_lock_contended(&node->locked);
-	}
-
-	/*
-	 * we're at the head of the waitqueue, wait for the owner & pending to
-	 * go away.
-	 * Load-acquired is used here because the try_set_locked()
-	 * function below may not be a full memory barrier.
-	 *
-	 * *,x,y -> *,0,0
-	 */
-retry_queue_wait:
-	while ((val = smp_load_acquire(&lock->val.counter))
-				       & _Q_LOCKED_PENDING_MASK)
-		arch_mutex_cpu_relax();
-
-	/*
-	 * claim the lock:
-	 *
-	 * n,0,0 -> 0,0,1 : lock, uncontended
-	 * *,0,0 -> *,0,1 : lock, contended
-	 *
-	 * If the queue head is the only one in the queue (lock value == tail),
-	 * clear the tail code and grab the lock. Otherwise, we only need
-	 * to grab the lock.
-	 */
-	for (;;) {
-		if (val != tail) {
-			/*
-			 * The try_set_locked function will only failed if the
-			 * lock was stolen.
-			 */
-			if (try_set_locked(lock))
-				break;
-			else
-				goto  retry_queue_wait;
-		}
-		old = atomic_cmpxchg(&lock->val, val, _Q_LOCKED_VAL);
-		if (old == val)
-			goto release;	/* No contention */
-		else if (old &  _Q_LOCKED_MASK)
-			goto retry_queue_wait;
-		val = old;
-	}
-
-	/*
-	 * contended path; wait for next, release.
-	 */
-	while (!(next = ACCESS_ONCE(node->next)))
-		arch_mutex_cpu_relax();
-
-	arch_mcs_spin_unlock_contended(&next->locked);
+	if (!queue_spin_trylock(lock))
+		queue_spin_lock_slowerpath(lock, node, tail);
 
-release:
 	/*
 	 * release the node
 	 */
-- 
1.7.1

