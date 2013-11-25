Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614Ab3KYU6p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 15:58:45 -0500
Received: from www.linutronix.de ([62.245.132.108]:57372 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab3KYU6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 15:58:15 -0500
Message-Id: <20131125203526.001421959@linutronix.de>
User-Agent: quilt/0.60-1
Date: Mon, 25 Nov 2013 20:58:13 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Davidlohr Bueso <davidlohr@hp.com>, Jason Low <jason.low2@hp.com>,
        Ingo Molnar <mingo@kernel.org>, Darren Hart <dvhart@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
        Jeff Mahoney <jeffm@suse.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Scott Norton <scott.norton@hp.com>, Tom Vaden <tom.vaden@hp.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Waiman Long <Waiman.Long@hp.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [RFC patch 4/5] futex: Enqueue waiter before user space check
References: <20131125203358.156292370@linutronix.de>
Content-Disposition: inline; filename=futex-queue-early.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This changes the queue ordering on the waiter side from 

     lock(hash_bucket);
     validate user space value();
     queue();
     unlock(hash_bucket);

to
     lock(hash_bucket);
     queue();
     validate user space value();
     unlock(hash_bucket);

This is a preparatory patch for a lockless empty check of the hash
bucket plist.

No functional implication. All futex operations are still serialized
via the hasb bucket lock.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/futex.c |   84 +++++++++++++++++++++++++++++++++------------------------
 1 file changed, 49 insertions(+), 35 deletions(-)

Index: linux-2.6/kernel/futex.c
===================================================================
--- linux-2.6.orig/kernel/futex.c
+++ linux-2.6/kernel/futex.c
@@ -107,22 +107,26 @@
  * and the waker did not find the waiter in the hash bucket queue.
  * The spinlock serializes that:
  *
+ *
  * CPU 0				CPU 1
  * val = *futex;
  * sys_futex(WAIT, futex, val);
  *   futex_wait(futex, val);
  *   lock(hash_bucket(futex));
+ *   queue();
  *   uval = *futex;
  *					*futex = newval;
  *					sys_futex(WAKE, futex);
  *					  futex_wake(futex);
  *					  lock(hash_bucket(futex));
  *   if (uval == val)
- *      queue();
  *	unlock(hash_bucket(futex));
  *	schedule();			  if (!queue_empty())
  *					    wake_waiters(futex);
  *					  unlock(hash_bucket(futex));
+ *
+ * The futex_lock_pi ordering is similar to that, but it has the queue
+ * operation right before unlocking hash bucket lock and scheduling.
  */
 
 int __read_mostly futex_cmpxchg_enabled;
@@ -1575,6 +1579,19 @@ static inline void queue_me(struct futex
 }
 
 /**
+ * unqueue_and_unlock() - Dequeue the futex_q and release hash bucket lock
+ * @q:	The futex_q to dequeue
+ * @hb:	The hash bucket
+ */
+static inline void
+unqueue_and_unlock(struct futex_q *q, struct futex_hash_bucket *hb)
+	__releases(&hb->lock)
+{
+	plist_del(&q->list, &hb->chain);
+	spin_unlock(&hb->lock);
+}
+
+/**
  * unqueue_me() - Remove the futex_q from its futex_hash_bucket
  * @q:	The futex_q to unqueue
  *
@@ -1816,28 +1833,12 @@ out:
 }
 
 /**
- * futex_wait_queue_me() - queue_me() and wait for wakeup, timeout, or signal
- * @hb:		the futex hash bucket, must be locked by the caller
+ * __futex_wait() - wait for wakeup, timeout, or signal
  * @q:		the futex_q to queue up on
  * @timeout:	the prepared hrtimer_sleeper, or null for no timeout
  */
-static void futex_wait_queue_me(struct futex_hash_bucket *hb, struct futex_q *q,
-				struct hrtimer_sleeper *timeout)
+static void __futex_wait(struct futex_q *q, struct hrtimer_sleeper *timeout)
 {
-	/*
-	 * The task state is guaranteed to be set before another task can
-	 * wake it. set_current_state() is implemented using set_mb() and
-	 * queue_me() calls spin_unlock() upon completion, both serializing
-	 * access to the hash list and forcing another memory barrier.
-	 */
-	set_current_state(TASK_INTERRUPTIBLE);
-	queue_me(q, hb);
-	/*
-	 * Unlock _AFTER_ we queued ourself. See the comment describing
-	 * the futex ordering guarantees on top of this file.
-	 */
-	queue_unlock(hb);
-
 	/* Arm the timer */
 	if (timeout) {
 		hrtimer_start_expires(&timeout->timer, HRTIMER_MODE_ABS);
@@ -1897,10 +1898,6 @@ static int futex_wait_setup(u32 __user *
 	 * would open a race condition where we could block indefinitely with
 	 * cond(var) false, which would violate the guarantee.
 	 *
-	 * On the other hand, we insert q and release the hash-bucket only
-	 * after testing *uaddr.  This guarantees that futex_wait() will NOT
-	 * absorb a wakeup if *uaddr does not match the desired values
-	 * while the syscall executes.
 	 */
 retry:
 	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &q->key, VERIFY_READ);
@@ -1910,10 +1907,15 @@ retry:
 retry_private:
 	*hb = queue_lock(q);
 
+	/*
+	 * We queue the futex before validating the user space value.
+	 */
+	queue_me(q, *hb);
+
 	ret = get_futex_value_locked(&uval, uaddr);
 
 	if (ret) {
-		queue_unlock(*hb);
+		unqueue_and_unlock(q, *hb);
 
 		ret = get_user(uval, uaddr);
 		if (ret)
@@ -1927,13 +1929,25 @@ retry_private:
 	}
 
 	if (uval != val) {
-		queue_unlock(*hb);
+		unqueue_and_unlock(q, *hb);
 		ret = -EWOULDBLOCK;
 	}
 
 out:
-	if (ret)
+	if (!ret) {
+		/*
+		 * If we sucessfully queued ourself, set the state to
+		 * TASK_INTERRUPTIBLE. A potential waker cannot wake
+		 * us yet, as it waits for the hb->lock to be released
+		 * by us. A potential timeout timer is not yet armed
+		 * and a signal wakeup which happened before this is
+		 * going to be reissued by the scheduler.
+		 */
+		set_current_state(TASK_INTERRUPTIBLE);
+		queue_unlock(*hb);
+	} else {
 		put_futex_key(&q->key);
+	}
 	return ret;
 }
 
@@ -1963,15 +1977,15 @@ static int futex_wait(u32 __user *uaddr,
 
 retry:
 	/*
-	 * Prepare to wait on uaddr. On success, holds hb lock and increments
-	 * q.key refs.
+	 * Prepare to wait on uaddr. On success, increments q.key (key1) ref
+	 * count and q enqueued on hb.
 	 */
 	ret = futex_wait_setup(uaddr, val, flags, &q, &hb);
 	if (ret)
 		goto out;
 
-	/* queue_me and wait for wakeup, timeout, or a signal. */
-	futex_wait_queue_me(hb, &q, to);
+	/* Wait for wakeup, timeout, or a signal. */
+	__futex_wait(&q, to);
 
 	/* If we were woken (and unqueued), we succeeded, whatever. */
 	ret = 0;
@@ -2308,8 +2322,8 @@ int handle_early_requeue_pi_wakeup(struc
  * without one, the pi logic would not know which task to boost/deboost, if
  * there was a need to.
  *
- * We call schedule in futex_wait_queue_me() when we enqueue and return there
- * via the following--
+ * We call schedule in __futex_wait() and return there via the
+ * following:
  * 1) wakeup on uaddr2 after an atomic lock acquisition by futex_requeue()
  * 2) wakeup on uaddr2 after a requeue
  * 3) signal
@@ -2376,14 +2390,14 @@ static int futex_wait_requeue_pi(u32 __u
 
 	/*
 	 * Prepare to wait on uaddr. On success, increments q.key (key1) ref
-	 * count.
+	 * count and q enqueued on hb.
 	 */
 	ret = futex_wait_setup(uaddr, val, flags, &q, &hb);
 	if (ret)
 		goto out_key2;
 
-	/* Queue the futex_q, drop the hb lock, wait for wakeup. */
-	futex_wait_queue_me(hb, &q, to);
+	/* Wait for wakeup. */
+	__futex_wait(&q, to);
 
 	spin_lock(&hb->lock);
 	ret = handle_early_requeue_pi_wakeup(hb, &q, &key2, to);


