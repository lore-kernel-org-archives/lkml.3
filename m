Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500Ab3KYU6V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 15:58:21 -0500
Received: from www.linutronix.de ([62.245.132.108]:57384 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab3KYU6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 15:58:16 -0500
Message-Id: <20131125203526.113469628@linutronix.de>
User-Agent: quilt/0.60-1
Date: Mon, 25 Nov 2013 20:58:14 -0000
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
Subject: [RFC patch 5/5] futex: Allow lockless empty check of hash bucket plist
References: <20131125203358.156292370@linutronix.de>
Content-Disposition: inline;
 filename=futex-allow-lockless-check-of-hash-bucket-list.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the early enqueue of the waiter into the hash bucket list in
place, we can guarantee the futex ordering with an smp_mb() pair
and allow the lockless empty check of the hash bucket plist in
futex_wake().

This changes the order to:

 CPU 0				CPU 1
 val = *futex;
 sys_futex(WAIT, futex, val);
   futex_wait(futex, val);
   lock(hash_bucket(futex));
   queue();

   smp_mb(); <-- paired with ---
				|
   uval = *futex;		|
				|	*futex = newval;
				|	sys_futex(WAKE, futex);
				|	  futex_wake(futex);
				|
				------>	  smp_mb();

					  if (!queue_empty)
					    return;
					  lock(hash_bucket(futex));
   if (uval == val)
	unlock(hash_bucket(futex));
	schedule();			  if (!queue_empty())
					    wake_waiters(futex);
					  unlock(hash_bucket(futex));

This does preserve the futex ordering guarantee, which ensures, that a
waiter either observes the changed user space value before blocking or
is woken by a concurrent waker. See the related discussion at:

 http://lkml.kernel.org/r/alpine.DEB.2.02.1311231206380.30673@ionos.tec.linutronix.de

Thanks to Peter Zijlstra for noticing that we require a full mb()
instead of a wmb/rmb() pair.

Note, that this change needs a real justification with numbers of
various workloads aside of the single big database workload which
inspired HP folks to poke on that. This also wants to be verified on
!x86.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/futex.c |   97 +++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 91 insertions(+), 6 deletions(-)

Index: linux-2.6/kernel/futex.c
===================================================================
--- linux-2.6.orig/kernel/futex.c
+++ linux-2.6/kernel/futex.c
@@ -114,10 +114,18 @@
  *   futex_wait(futex, val);
  *   lock(hash_bucket(futex));
  *   queue();
- *   uval = *futex;
- *					*futex = newval;
- *					sys_futex(WAKE, futex);
- *					  futex_wake(futex);
+ *
+ *   smp_mb(); <-- paired with --
+ *				|
+ *   uval = *futex;		|
+ *				|	*futex = newval;
+ *				|	sys_futex(WAKE, futex);
+ *				|	  futex_wake(futex);
+ *				|
+ *				------>	  smp_mb();
+ *
+ *					  if (!queue_empty)
+ *					    return;
  *					  lock(hash_bucket(futex));
  *   if (uval == val)
  *	unlock(hash_bucket(futex));
@@ -125,8 +133,32 @@
  *					    wake_waiters(futex);
  *					  unlock(hash_bucket(futex));
  *
- * The futex_lock_pi ordering is similar to that, but it has the queue
- * operation right before unlocking hash bucket lock and scheduling.
+ * The smp_mb() pair allows a quick check on the waker side whether
+ * the hash bucket queue is empty or not. All other operations are
+ * still proper serialized via the hash bucket lock.
+ *
+ * The futex_lock_pi functionality is similar to that, but it relies
+ * on the full spinlock serialization:
+ *
+ * CPU 0				CPU 1
+ * val = *futex;
+ * sys_futex(LOCK_PI, futex, val);
+ *   futex_lock_pi(futex, val);
+ *   lock(hash_bucket(futex));
+ *
+ *   atomic_cmpxchg(futex, val, uval);
+ *					*futex = newval;
+ *					sys_futex(UNLOCK_PI, futex);
+ *					  futex_unlock_pi(futex);
+ *
+ *					  lock(hash_bucket(futex));
+ *
+ *   if (checks(val, uval))
+ *	queue();
+ *	unlock(hash_bucket(futex));
+ *	schedule();			  if (!queue_empty())
+ *					    wake_waiters(futex);
+ *					  unlock(hash_bucket(futex));
  */
 
 int __read_mostly futex_cmpxchg_enabled;
@@ -1054,6 +1086,43 @@ futex_wake(u32 __user *uaddr, unsigned i
 		goto out;
 
 	hb = hash_futex(&key);
+
+	/*
+	 * The following smp_mb() pairs with the smp_mb() in
+	 * futex_wait_setup().
+	 *
+	 * It ensures the proper ordering of the plist operations with
+	 * the operations on *uaddr.
+	 *
+	 * Abstract problem description:
+	 *
+	 * W[x]		|	W[y]
+	 * mb		|	mb
+	 * R[y]		|	R[x]
+	 *
+	 * i.e.:
+	 *
+	 * Waiter	|	Waker
+	 *
+	 * plist_add()	|	*uaddr = newval
+	 * smp_mb()	|	smp_mb()
+	 * test(*uaddr)	|	plist_head_empty()
+	 *
+	 * So it is guaranteed that:
+	 *
+	 * The waiter observes the change to the uaddr value after it
+	 * added itself to the plist.
+	 *
+	 * The waker observes plist not empty if the change to uaddr
+	 * was made after the waiter checked the value.
+	 *
+	 * See also the comment about ordering guarantees at the top
+	 * of this file.
+	 */
+	smp_mb();
+	if (plist_head_empty(&hb->chain))
+		goto out_put_keys;
+
 	spin_lock(&hb->lock);
 
 	plist_for_each_entry_safe(this, next, &hb->chain, list) {
@@ -1074,6 +1143,7 @@ futex_wake(u32 __user *uaddr, unsigned i
 	}
 
 	spin_unlock(&hb->lock);
+out_put_keys:
 	put_futex_key(&key);
 out:
 	return ret;
@@ -1588,6 +1658,15 @@ unqueue_and_unlock(struct futex_q *q, st
 	__releases(&hb->lock)
 {
 	plist_del(&q->list, &hb->chain);
+	/*
+	 * Note, we do not need a mb() here. This is called in error
+	 * handling pathes under the hb->lock. A potential waker which
+	 * sees the transient state that we are still enqueued is
+	 * going to take hb->lock and then notice that we are
+	 * gone. Not much we can do about that. The lockless check in
+	 * futex_wake() is optimized for the common case, not for the
+	 * error handling transients.
+	 */
 	spin_unlock(&hb->lock);
 }
 
@@ -1911,6 +1990,12 @@ retry_private:
 	 * We queue the futex before validating the user space value.
 	 */
 	queue_me(q, *hb);
+	/*
+	 * Pairs with the smp_mb() in futex_wake() to guarantee the
+	 * ordering between the queueing and the user space value
+	 * test. See detailed explanation of the barrier there.
+	 */
+	smp_mb();
 
 	ret = get_futex_value_locked(&uval, uaddr);
 


