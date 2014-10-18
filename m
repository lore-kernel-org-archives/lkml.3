Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520AbaJRT6w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 15:58:52 -0400
Received: from homie.mail.dreamhost.com ([208.97.132.208]:50126 "EHLO
	homiemail-a8.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751422AbaJRT6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 15:58:51 -0400
Message-ID: <1413662314.17869.11.camel@linux-t7sj.site>
Subject: Re: [PATCH] futex: Ensure get_futex_key_refs() always implies a
 barrier
From: Davidlohr Bueso <dave@stgolabs.net>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, Matteo Franchin <Matteo.Franchin@arm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>
Date: Sat, 18 Oct 2014 12:58:34 -0700
In-Reply-To: <1413617580.29249.9.camel@linux-t7sj.site>
References: <1413563929-2664-1-git-send-email-catalin.marinas@arm.com>
	 <1413617580.29249.9.camel@linux-t7sj.site>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-10-18 at 00:33 -0700, Davidlohr Bueso wrote:
> On Fri, 2014-10-17 at 17:38 +0100, Catalin Marinas wrote:
> > Commit b0c29f79ecea (futexes: Avoid taking the hb->lock if there's
> > nothing to wake up) changes the futex code to avoid taking a lock when
> > there are no waiters. This code has been subsequently fixed in commit
> > 11d4616bd07f (futex: revert back to the explicit waiter counting code).
> > Both the original commit and the fix-up rely on get_futex_key_refs() to
> > always imply a barrier.
> > 
> > However, for private futexes, none of the cases in the switch statement
> > of get_futex_key_refs() would be hit and the function completes without
> > a memory barrier as required before checking the "waiters" in
> > futex_wake() -> hb_waiters_pending(). 
> 
> Good catch, glad I ran into this thread (my email recently changed).
> Private process futex (PTHREAD_PROCESS_PRIVATE) have no reference on an
> inode or mm so it would need the explicit barrier in those cases.

And [get/put]_futex_keys() shouldn't even be called for private futexes.
The following patch had some very minor testing on a 60 core box last
night, but passes both Darren's and perf's tests. So I *think* this is
right, but lack of sleep and I overall just don't trust them futexes!

8<----------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Date: Sat, 18 Oct 2014 12:30:37 -0700
Subject: [PATCH 2/1] futex: No key referencing for private futexes

Because private futexes do not hold references on either
an inode or mm, they should not be calling key referencing
operations (even though they are practically a nop). However,
we need to call the get part only because we need the barrier
in order to maintain correct ordering guarantees for the lockless
waiter checking. In addition, we can avoid calling the put part
for private futexes altogether, as it serves no purpose in the
ordering.

This patch 1) documents the situation, 2) explicitly avoids calling
drop_futex_key_refs() when calling put_futex_keys() for private futexes
and 3) changes the interface of the function to pass the 'fshared'
variable, similarly to get_futex_key_refs(). In theory this should apply
to all drop_futex_key_refs() callers, but just keep it simple and apply
it as the get/put alternatives when calling futex(2).

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 kernel/futex.c | 99 ++++++++++++++++++++++++++++++++--------------------------
 1 file changed, 55 insertions(+), 44 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 815d7af..21f7e41 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -415,6 +415,11 @@ get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key, int rw)
 	if (!fshared) {
 		key->private.mm = mm;
 		key->private.address = address;
+		/*
+		 * Private futexes do not hold reference on an inode or
+		 * mm, therefore the only purpose of calling get_futex_key_refs
+		 * is because we need the barrier for the lockless waiter check.
+		 */
 		get_futex_key_refs(key);  /* implies MB (B) */
 		return 0;
 	}
@@ -530,9 +535,14 @@ out:
 	return err;
 }
 
-static inline void put_futex_key(union futex_key *key)
+static inline void put_futex_key(int fshared, union futex_key *key)
 {
-	drop_futex_key_refs(key);
+	/*
+	 * See comment in get_futex_key() about key
+	 * referencing when dealing with private futexes.
+	 */
+	if (fshared)
+		drop_futex_key_refs(key);
 }
 
 /**
@@ -1202,12 +1212,12 @@ futex_wake(u32 __user *uaddr, unsigned int flags, int nr_wake, u32 bitset)
 	struct futex_hash_bucket *hb;
 	struct futex_q *this, *next;
 	union futex_key key = FUTEX_KEY_INIT;
-	int ret;
+	int ret, fshared = flags & FLAGS_SHARED;
 
 	if (!bitset)
 		return -EINVAL;
 
-	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &key, VERIFY_READ);
+	ret = get_futex_key(uaddr, fshared, &key, VERIFY_READ);
 	if (unlikely(ret != 0))
 		goto out;
 
@@ -1238,7 +1248,7 @@ futex_wake(u32 __user *uaddr, unsigned int flags, int nr_wake, u32 bitset)
 
 	spin_unlock(&hb->lock);
 out_put_key:
-	put_futex_key(&key);
+	put_futex_key(fshared, &key);
 out:
 	return ret;
 }
@@ -1254,13 +1264,13 @@ futex_wake_op(u32 __user *uaddr1, unsigned int flags, u32 __user *uaddr2,
 	union futex_key key1 = FUTEX_KEY_INIT, key2 = FUTEX_KEY_INIT;
 	struct futex_hash_bucket *hb1, *hb2;
 	struct futex_q *this, *next;
-	int ret, op_ret;
+	int ret, op_ret, fshared = flags & FLAGS_SHARED;
 
 retry:
-	ret = get_futex_key(uaddr1, flags & FLAGS_SHARED, &key1, VERIFY_READ);
+	ret = get_futex_key(uaddr1, fshared, &key1, VERIFY_READ);
 	if (unlikely(ret != 0))
 		goto out;
-	ret = get_futex_key(uaddr2, flags & FLAGS_SHARED, &key2, VERIFY_WRITE);
+	ret = get_futex_key(uaddr2, fshared, &key2, VERIFY_WRITE);
 	if (unlikely(ret != 0))
 		goto out_put_key1;
 
@@ -1292,11 +1302,11 @@ retry_private:
 		if (ret)
 			goto out_put_keys;
 
-		if (!(flags & FLAGS_SHARED))
+		if (!fshared)
 			goto retry_private;
 
-		put_futex_key(&key2);
-		put_futex_key(&key1);
+		put_futex_key(fshared, &key2);
+		put_futex_key(fshared, &key1);
 		goto retry;
 	}
 
@@ -1331,9 +1341,9 @@ retry_private:
 out_unlock:
 	double_unlock_hb(hb1, hb2);
 out_put_keys:
-	put_futex_key(&key2);
+	put_futex_key(fshared, &key2);
 out_put_key1:
-	put_futex_key(&key1);
+	put_futex_key(fshared, &key1);
 out:
 	return ret;
 }
@@ -1485,10 +1495,11 @@ static int futex_requeue(u32 __user *uaddr1, unsigned int flags,
 			 u32 *cmpval, int requeue_pi)
 {
 	union futex_key key1 = FUTEX_KEY_INIT, key2 = FUTEX_KEY_INIT;
-	int drop_count = 0, task_count = 0, ret;
+	int drop_count = 0, task_count = 0;
 	struct futex_pi_state *pi_state = NULL;
 	struct futex_hash_bucket *hb1, *hb2;
 	struct futex_q *this, *next;
+	int ret, fshared = flags & FLAGS_SHARED;
 
 	if (requeue_pi) {
 		/*
@@ -1528,10 +1539,10 @@ retry:
 		pi_state = NULL;
 	}
 
-	ret = get_futex_key(uaddr1, flags & FLAGS_SHARED, &key1, VERIFY_READ);
+	ret = get_futex_key(uaddr1, fshared, &key1, VERIFY_READ);
 	if (unlikely(ret != 0))
 		goto out;
-	ret = get_futex_key(uaddr2, flags & FLAGS_SHARED, &key2,
+	ret = get_futex_key(uaddr2, fshared, &key2,
 			    requeue_pi ? VERIFY_WRITE : VERIFY_READ);
 	if (unlikely(ret != 0))
 		goto out_put_key1;
@@ -1565,11 +1576,11 @@ retry_private:
 			if (ret)
 				goto out_put_keys;
 
-			if (!(flags & FLAGS_SHARED))
+			if (!fshared)
 				goto retry_private;
 
-			put_futex_key(&key2);
-			put_futex_key(&key1);
+			put_futex_key(fshared, &key2);
+			put_futex_key(fshared, &key1);
 			goto retry;
 		}
 		if (curval != *cmpval) {
@@ -1619,8 +1630,8 @@ retry_private:
 		case -EFAULT:
 			double_unlock_hb(hb1, hb2);
 			hb_waiters_dec(hb2);
-			put_futex_key(&key2);
-			put_futex_key(&key1);
+			put_futex_key(fshared, &key2);
+			put_futex_key(fshared, &key1);
 			ret = fault_in_user_writeable(uaddr2);
 			if (!ret)
 				goto retry;
@@ -1634,8 +1645,8 @@ retry_private:
 			 */
 			double_unlock_hb(hb1, hb2);
 			hb_waiters_dec(hb2);
-			put_futex_key(&key2);
-			put_futex_key(&key1);
+			put_futex_key(fshared, &key2);
+			put_futex_key(fshared, &key1);
 			cond_resched();
 			goto retry;
 		default:
@@ -1721,9 +1732,9 @@ out_unlock:
 		drop_futex_key_refs(&key1);
 
 out_put_keys:
-	put_futex_key(&key2);
+	put_futex_key(fshared, &key2);
 out_put_key1:
-	put_futex_key(&key1);
+	put_futex_key(fshared, &key1);
 out:
 	if (pi_state != NULL)
 		free_pi_state(pi_state);
@@ -2098,7 +2109,7 @@ static int futex_wait_setup(u32 __user *uaddr, u32 val, unsigned int flags,
 			   struct futex_q *q, struct futex_hash_bucket **hb)
 {
 	u32 uval;
-	int ret;
+	int ret, fshared = flags & FLAGS_SHARED;
 
 	/*
 	 * Access the page AFTER the hash-bucket is locked.
@@ -2119,7 +2130,7 @@ static int futex_wait_setup(u32 __user *uaddr, u32 val, unsigned int flags,
 	 * while the syscall executes.
 	 */
 retry:
-	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &q->key, VERIFY_READ);
+	ret = get_futex_key(uaddr, fshared, &q->key, VERIFY_READ);
 	if (unlikely(ret != 0))
 		return ret;
 
@@ -2135,10 +2146,10 @@ retry_private:
 		if (ret)
 			goto out;
 
-		if (!(flags & FLAGS_SHARED))
+		if (!fshared)
 			goto retry_private;
 
-		put_futex_key(&q->key);
+		put_futex_key(fshared, &q->key);
 		goto retry;
 	}
 
@@ -2149,7 +2160,7 @@ retry_private:
 
 out:
 	if (ret)
-		put_futex_key(&q->key);
+		put_futex_key(fshared, &q->key);
 	return ret;
 }
 
@@ -2256,7 +2267,7 @@ static int futex_lock_pi(u32 __user *uaddr, unsigned int flags, int detect,
 	struct hrtimer_sleeper timeout, *to = NULL;
 	struct futex_hash_bucket *hb;
 	struct futex_q q = futex_q_init;
-	int res, ret;
+	int res, ret, fshared = flags & FLAGS_SHARED;
 
 	if (refill_pi_state_cache())
 		return -ENOMEM;
@@ -2270,7 +2281,7 @@ static int futex_lock_pi(u32 __user *uaddr, unsigned int flags, int detect,
 	}
 
 retry:
-	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &q.key, VERIFY_WRITE);
+	ret = get_futex_key(uaddr, fshared, &q.key, VERIFY_WRITE);
 	if (unlikely(ret != 0))
 		goto out;
 
@@ -2294,7 +2305,7 @@ retry_private:
 			 * - The user space value changed.
 			 */
 			queue_unlock(hb);
-			put_futex_key(&q.key);
+			put_futex_key(fshared, &q.key);
 			cond_resched();
 			goto retry;
 		default:
@@ -2348,7 +2359,7 @@ out_unlock_put_key:
 	queue_unlock(hb);
 
 out_put_key:
-	put_futex_key(&q.key);
+	put_futex_key(fshared, &q.key);
 out:
 	if (to)
 		destroy_hrtimer_on_stack(&to->timer);
@@ -2361,10 +2372,10 @@ uaddr_faulted:
 	if (ret)
 		goto out_put_key;
 
-	if (!(flags & FLAGS_SHARED))
+	if (!fshared)
 		goto retry_private;
 
-	put_futex_key(&q.key);
+	put_futex_key(fshared, &q.key);
 	goto retry;
 }
 
@@ -2379,7 +2390,7 @@ static int futex_unlock_pi(u32 __user *uaddr, unsigned int flags)
 	union futex_key key = FUTEX_KEY_INIT;
 	struct futex_hash_bucket *hb;
 	struct futex_q *match;
-	int ret;
+	int ret, fshared = flags & FLAGS_SHARED;
 
 retry:
 	if (get_user(uval, uaddr))
@@ -2390,7 +2401,7 @@ retry:
 	if ((uval & FUTEX_TID_MASK) != vpid)
 		return -EPERM;
 
-	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &key, VERIFY_WRITE);
+	ret = get_futex_key(uaddr, fshared, &key, VERIFY_WRITE);
 	if (ret)
 		return ret;
 
@@ -2431,12 +2442,12 @@ retry:
 
 out_unlock:
 	spin_unlock(&hb->lock);
-	put_futex_key(&key);
+	put_futex_key(fshared, &key);
 	return ret;
 
 pi_faulted:
 	spin_unlock(&hb->lock);
-	put_futex_key(&key);
+	put_futex_key(fshared, &key);
 
 	ret = fault_in_user_writeable(uaddr);
 	if (!ret)
@@ -2544,7 +2555,7 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, unsigned int flags,
 	struct futex_hash_bucket *hb;
 	union futex_key key2 = FUTEX_KEY_INIT;
 	struct futex_q q = futex_q_init;
-	int res, ret;
+	int res, ret, fshared = flags & FLAGS_SHARED;
 
 	if (uaddr == uaddr2)
 		return -EINVAL;
@@ -2571,7 +2582,7 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, unsigned int flags,
 	RB_CLEAR_NODE(&rt_waiter.tree_entry);
 	rt_waiter.task = NULL;
 
-	ret = get_futex_key(uaddr2, flags & FLAGS_SHARED, &key2, VERIFY_WRITE);
+	ret = get_futex_key(uaddr2, fshared, &key2, VERIFY_WRITE);
 	if (unlikely(ret != 0))
 		goto out;
 
@@ -2673,9 +2684,9 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, unsigned int flags,
 	}
 
 out_put_keys:
-	put_futex_key(&q.key);
+	put_futex_key(fshared, &q.key);
 out_key2:
-	put_futex_key(&key2);
+	put_futex_key(fshared, &key2);
 
 out:
 	if (to) {
-- 
1.8.4.5



