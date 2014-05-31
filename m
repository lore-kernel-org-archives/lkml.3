Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751575AbaEaPEk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 11:04:40 -0400
Received: from www.linutronix.de ([62.245.132.108]:34208 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbaEaPEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 11:04:39 -0400
Date: Sat, 31 May 2014 17:04:35 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT pull] core fixes for 3.15
Message-ID: <alpine.DEB.2.10.1405311659090.3952@nanos>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest core-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-urgent-for-linus

Three fixlets for long standing issues in the futex/rtmutex code
unearthed by Dave Jones syscall fuzzer:

- Add missing early deadlock detection checks in the futex code
- Prevent user space from attaching a futex to kernel threads
- Make the deadlock detector of rtmutex work again

Looks large, but is more comments than code change.

Thanks,

	tglx

------------------>
Thomas Gleixner (3):
      futex: Add another early deadlock detection check
      futex: Prevent attaching to kernel threads
      rtmutex: Fix deadlock detector for real


 kernel/futex.c           | 52 ++++++++++++++++++++++++++++++++++++------------
 kernel/locking/rtmutex.c | 32 +++++++++++++++++++++++++----
 2 files changed, 67 insertions(+), 17 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 5f58927..81dbe77 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -745,7 +745,8 @@ void exit_pi_state_list(struct task_struct *curr)
 
 static int
 lookup_pi_state(u32 uval, struct futex_hash_bucket *hb,
-		union futex_key *key, struct futex_pi_state **ps)
+		union futex_key *key, struct futex_pi_state **ps,
+		struct task_struct *task)
 {
 	struct futex_pi_state *pi_state = NULL;
 	struct futex_q *this, *next;
@@ -786,6 +787,16 @@ lookup_pi_state(u32 uval, struct futex_hash_bucket *hb,
 					return -EINVAL;
 			}
 
+			/*
+			 * Protect against a corrupted uval. If uval
+			 * is 0x80000000 then pid is 0 and the waiter
+			 * bit is set. So the deadlock check in the
+			 * calling code has failed and we did not fall
+			 * into the check above due to !pid.
+			 */
+			if (task && pi_state->owner == task)
+				return -EDEADLK;
+
 			atomic_inc(&pi_state->refcount);
 			*ps = pi_state;
 
@@ -803,6 +814,11 @@ lookup_pi_state(u32 uval, struct futex_hash_bucket *hb,
 	if (!p)
 		return -ESRCH;
 
+	if (!p->mm) {
+		put_task_struct(p);
+		return -EPERM;
+	}
+
 	/*
 	 * We need to look at the task state flags to figure out,
 	 * whether the task is exiting. To protect against the do_exit
@@ -935,7 +951,7 @@ retry:
 	 * We dont have the lock. Look up the PI state (or create it if
 	 * we are the first waiter):
 	 */
-	ret = lookup_pi_state(uval, hb, key, ps);
+	ret = lookup_pi_state(uval, hb, key, ps, task);
 
 	if (unlikely(ret)) {
 		switch (ret) {
@@ -1347,7 +1363,7 @@ void requeue_pi_wake_futex(struct futex_q *q, union futex_key *key,
  *
  * Return:
  *  0 - failed to acquire the lock atomically;
- *  1 - acquired the lock;
+ * >0 - acquired the lock, return value is vpid of the top_waiter
  * <0 - error
  */
 static int futex_proxy_trylock_atomic(u32 __user *pifutex,
@@ -1358,7 +1374,7 @@ static int futex_proxy_trylock_atomic(u32 __user *pifutex,
 {
 	struct futex_q *top_waiter = NULL;
 	u32 curval;
-	int ret;
+	int ret, vpid;
 
 	if (get_futex_value_locked(&curval, pifutex))
 		return -EFAULT;
@@ -1386,11 +1402,13 @@ static int futex_proxy_trylock_atomic(u32 __user *pifutex,
 	 * the contended case or if set_waiters is 1.  The pi_state is returned
 	 * in ps in contended cases.
 	 */
+	vpid = task_pid_vnr(top_waiter->task);
 	ret = futex_lock_pi_atomic(pifutex, hb2, key2, ps, top_waiter->task,
 				   set_waiters);
-	if (ret == 1)
+	if (ret == 1) {
 		requeue_pi_wake_futex(top_waiter, key2, hb2);
-
+		return vpid;
+	}
 	return ret;
 }
 
@@ -1421,7 +1439,6 @@ static int futex_requeue(u32 __user *uaddr1, unsigned int flags,
 	struct futex_pi_state *pi_state = NULL;
 	struct futex_hash_bucket *hb1, *hb2;
 	struct futex_q *this, *next;
-	u32 curval2;
 
 	if (requeue_pi) {
 		/*
@@ -1509,16 +1526,25 @@ retry_private:
 		 * At this point the top_waiter has either taken uaddr2 or is
 		 * waiting on it.  If the former, then the pi_state will not
 		 * exist yet, look it up one more time to ensure we have a
-		 * reference to it.
+		 * reference to it. If the lock was taken, ret contains the
+		 * vpid of the top waiter task.
 		 */
-		if (ret == 1) {
+		if (ret > 0) {
 			WARN_ON(pi_state);
 			drop_count++;
 			task_count++;
-			ret = get_futex_value_locked(&curval2, uaddr2);
-			if (!ret)
-				ret = lookup_pi_state(curval2, hb2, &key2,
-						      &pi_state);
+			/*
+			 * If we acquired the lock, then the user
+			 * space value of uaddr2 should be vpid. It
+			 * cannot be changed by the top waiter as it
+			 * is blocked on hb2 lock if it tries to do
+			 * so. If something fiddled with it behind our
+			 * back the pi state lookup might unearth
+			 * it. So we rather use the known value than
+			 * rereading and handing potential crap to
+			 * lookup_pi_state.
+			 */
+			ret = lookup_pi_state(ret, hb2, &key2, &pi_state, NULL);
 		}
 
 		switch (ret) {
diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
index aa4dff0..a620d4d 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -343,9 +343,16 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 	 * top_waiter can be NULL, when we are in the deboosting
 	 * mode!
 	 */
-	if (top_waiter && (!task_has_pi_waiters(task) ||
-			   top_waiter != task_top_pi_waiter(task)))
-		goto out_unlock_pi;
+	if (top_waiter) {
+		if (!task_has_pi_waiters(task))
+			goto out_unlock_pi;
+		/*
+		 * If deadlock detection is off, we stop here if we
+		 * are not the top pi waiter of the task.
+		 */
+		if (!detect_deadlock && top_waiter != task_top_pi_waiter(task))
+			goto out_unlock_pi;
+	}
 
 	/*
 	 * When deadlock detection is off then we check, if further
@@ -361,7 +368,12 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 		goto retry;
 	}
 
-	/* Deadlock detection */
+	/*
+	 * Deadlock detection. If the lock is the same as the original
+	 * lock which caused us to walk the lock chain or if the
+	 * current lock is owned by the task which initiated the chain
+	 * walk, we detected a deadlock.
+	 */
 	if (lock == orig_lock || rt_mutex_owner(lock) == top_task) {
 		debug_rt_mutex_deadlock(deadlock_detect, orig_waiter, lock);
 		raw_spin_unlock(&lock->wait_lock);
@@ -527,6 +539,18 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 	unsigned long flags;
 	int chain_walk = 0, res;
 
+	/*
+	 * Early deadlock detection. We really don't want the task to
+	 * enqueue on itself just to untangle the mess later. It's not
+	 * only an optimization. We drop the locks, so another waiter
+	 * can come in before the chain walk detects the deadlock. So
+	 * the other will detect the deadlock and return -EDEADLOCK,
+	 * which is wrong, as the other waiter is not in a deadlock
+	 * situation.
+	 */
+	if (detect_deadlock && owner == task)
+		return -EDEADLK;
+
 	raw_spin_lock_irqsave(&task->pi_lock, flags);
 	__rt_mutex_adjust_prio(task);
 	waiter->task = task;
