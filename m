Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbaFKUpq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 16:45:46 -0400
Received: from www.linutronix.de ([62.245.132.108]:34859 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983AbaFKUpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 16:45:43 -0400
Message-Id: <20140611204237.361836310@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 11 Jun 2014 20:45:41 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Darren Hart <darren@dvhart.com>,
        Ingo Molnar <mingo@kernel.org>, Davidlohr Bueso <davidlohr@hp.com>,
        Kees Cook <kees@outflux.net>, wad@chromium.org
Subject: [patch 5/5] futex: Simplify futex_lock_pi_atomic() and make it more
 robust
References: <20140611202744.676528190@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline;
 filename=futex-make-futex-lock-atomic-p-more-robust.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

futex_lock_pi_atomic() is a maze of retry hoops and loops.

Reduce it to simple and understandable states:

First step is to lookup existing waiters (state) in the kernel.

If there is an existing waiter, validate it and attach to it.

If there is no existing waiter, check the user space value

If the TID encoded in the user space value is 0, take over the futex
preserving the owner died bit.

If the TID encoded in the user space value is != 0, lookup the owner
task, validate it and attach to it.

Reduces text size by 144 bytes on x8664.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/futex.c |  139 +++++++++++++++++++++------------------------------------
 1 file changed, 53 insertions(+), 86 deletions(-)

Index: linux/kernel/futex.c
===================================================================
--- linux.orig/kernel/futex.c
+++ linux/kernel/futex.c
@@ -956,6 +956,17 @@ static int lookup_pi_state(u32 uval, str
 	return attach_to_pi_owner(uval, key, ps);
 }
 
+static int lock_pi_update_atomic(u32 __user *uaddr, u32 uval, u32 newval)
+{
+	u32 uninitialized_var(curval);
+
+	if (unlikely(cmpxchg_futex_value_locked(&curval, uaddr, uval, newval)))
+		return -EFAULT;
+
+	/* If user space value changed, let the caller retry */
+	return curval != uval ? -EAGAIN : 0;
+}
+
 /**
  * futex_lock_pi_atomic() - Atomic work required to acquire a pi aware futex
  * @uaddr:		the pi futex user address
@@ -979,113 +990,67 @@ static int futex_lock_pi_atomic(u32 __us
 				struct futex_pi_state **ps,
 				struct task_struct *task, int set_waiters)
 {
-	int lock_taken, ret, force_take = 0;
-	u32 uval, newval, curval, vpid = task_pid_vnr(task);
-
-retry:
-	ret = lock_taken = 0;
+	u32 uval, newval, vpid = task_pid_vnr(task);
+	struct futex_q *match;
+	int ret;
 
 	/*
-	 * To avoid races, we attempt to take the lock here again
-	 * (by doing a 0 -> TID atomic cmpxchg), while holding all
-	 * the locks. It will most likely not succeed.
+	 * Read the user space value first so we can validate a few
+	 * things before proceeding further.
 	 */
-	newval = vpid;
-	if (set_waiters)
-		newval |= FUTEX_WAITERS;
-
-	if (unlikely(cmpxchg_futex_value_locked(&curval, uaddr, 0, newval)))
+	if (get_futex_value_locked(&uval, uaddr))
 		return -EFAULT;
 
 	/*
 	 * Detect deadlocks.
 	 */
-	if ((unlikely((curval & FUTEX_TID_MASK) == vpid)))
+	if ((unlikely((uval & FUTEX_TID_MASK) == vpid)))
 		return -EDEADLK;
 
 	/*
-	 * Surprise - we got the lock, but we do not trust user space at all.
+	 * Lookup existing state first. If it exists, try to attach to
+	 * its pi_state.
 	 */
-	if (unlikely(!curval)) {
-		/*
-		 * We verify whether there is kernel state for this
-		 * futex. If not, we can safely assume, that the 0 ->
-		 * TID transition is correct. If state exists, we do
-		 * not bother to fixup the user space state as it was
-		 * corrupted already.
-		 */
-		return futex_top_waiter(hb, key) ? -EINVAL : 1;
-	}
-
-	uval = curval;
+	match = futex_top_waiter(hb, key);
+	if (match)
+		return attach_to_pi_state(uval, match->pi_state, ps);
 
 	/*
-	 * Set the FUTEX_WAITERS flag, so the owner will know it has someone
-	 * to wake at the next unlock.
+	 * No waiter and user TID is 0. We are here because the
+	 * waiters or the owner died bit is set or called from
+	 * requeue_cmp_pi or for whatever reason something took the
+	 * syscall.
 	 */
-	newval = curval | FUTEX_WAITERS;
-
-	/*
-	 * Should we force take the futex? See below.
-	 */
-	if (unlikely(force_take)) {
+	if (!(uval & FUTEX_TID_MASK)) {
 		/*
-		 * Keep the OWNER_DIED and the WAITERS bit and set the
-		 * new TID value.
+		 * We take over the futex. No other waiters and the user space
+		 * TID is 0. We preserve the owner died bit.
 		 */
-		newval = (curval & ~FUTEX_TID_MASK) | vpid;
-		force_take = 0;
-		lock_taken = 1;
-	}
+		newval = uval & FUTEX_OWNER_DIED;
+		newval |= vpid;
 
-	if (unlikely(cmpxchg_futex_value_locked(&curval, uaddr, uval, newval)))
-		return -EFAULT;
-	if (unlikely(curval != uval))
-		goto retry;
+		/* The futex requeue_pi code can enforce the waiters bit */
+		if (set_waiters)
+			newval |= FUTEX_WAITERS;
+
+		return lock_pi_update_atomic(uaddr, uval, newval);
+	}
 
 	/*
-	 * We took the lock due to forced take over.
+	 * First waiter. Set the waiters bit before attaching ourself to
+	 * the owner. If owner tries to unlock, it will be forced into
+	 * the kernel and blocked on hb->lock.
 	 */
-	if (unlikely(lock_taken))
-		return 1;
-
+	newval = uval | FUTEX_WAITERS;
+	ret = lock_pi_update_atomic(uaddr, uval, newval);
+	if (ret)
+		return ret;
 	/*
-	 * We dont have the lock. Look up the PI state (or create it if
-	 * we are the first waiter):
+	 * If the update of the user space value succeeded, we try to
+	 * attach to the owner. If that fails, no harm done, we only
+	 * set the FUTEX_WAITERS bit in the user space variable.
 	 */
-	ret = lookup_pi_state(uval, hb, key, ps);
-
-	if (unlikely(ret)) {
-		switch (ret) {
-		case -ESRCH:
-			/*
-			 * We failed to find an owner for this
-			 * futex. So we have no pi_state to block
-			 * on. This can happen in two cases:
-			 *
-			 * 1) The owner died
-			 * 2) A stale FUTEX_WAITERS bit
-			 *
-			 * Re-read the futex value.
-			 */
-			if (get_futex_value_locked(&curval, uaddr))
-				return -EFAULT;
-
-			/*
-			 * If the owner died or we have a stale
-			 * WAITERS bit the owner TID in the user space
-			 * futex is 0.
-			 */
-			if (!(curval & FUTEX_TID_MASK)) {
-				force_take = 1;
-				goto retry;
-			}
-		default:
-			break;
-		}
-	}
-
-	return ret;
+	return attach_to_pi_owner(uval, key, ps);
 }
 
 /**
@@ -2316,8 +2281,10 @@ retry_private:
 			goto uaddr_faulted;
 		case -EAGAIN:
 			/*
-			 * Task is exiting and we just wait for the
-			 * exit to complete.
+			 * Two reasons for this:
+			 * - Task is exiting and we just wait for the
+			 *   exit to complete.
+			 * - The user space value changed.
 			 */
 			queue_unlock(hb);
 			put_futex_key(&q.key);


