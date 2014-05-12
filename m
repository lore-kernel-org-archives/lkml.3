Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758426AbaELUpe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 16:45:34 -0400
Received: from www.linutronix.de ([62.245.132.108]:56760 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758360AbaELUpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 16:45:32 -0400
Message-Id: <20140512201701.097349971@linutronix.de>
User-Agent: quilt/0.60-1
Date: Mon, 12 May 2014 20:45:34 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Darren Hart <darren@dvhart.com>,
        Davidlohr Bueso <davidlohr@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Clark Williams <williams@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Roland McGrath <roland@hack.frob.com>,
        Carlos ODonell <carlos@redhat.com>, Jakub Jelinek <jakub@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [patch 2/3] futex: Add another early deadlock detection check
References: <20140512190438.314125476@linutronix.de>
Content-Disposition: inline; filename=futex-add-early-deadlock-detection.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones trinity syscall fuzzer exposed an issue in the deadlock
detection code of rtmutex:
  http://lkml.kernel.org/r/20140429151655.GA14277@redhat.com

That underlying issue has been fixed with a patch to the rtmutex code,
but the futex code must not call into rtmutex in that case because
    - it can detect that issue early
    - it avoids a different and more complex fixup for backing out

If the user space variable got manipulated to 0x80000000 which means
no lock holder, but the waiters bit set and an active pi_state in the
kernel is found we can figure out the recursive locking issue by
looking at the pi_state owner. If that is the current task, then we
can safely return -EDEADLK.

The check should have been added in commit 59fa62451 (futex: Handle
futex_pi OWNER_DIED take over correctly) already, but I did not see
the above issue caused by user space manipulation back then.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
---
 kernel/futex.c |   47 ++++++++++++++++++++++++++++++++++-------------
 1 file changed, 34 insertions(+), 13 deletions(-)

Index: linux-2.6/kernel/futex.c
===================================================================
--- linux-2.6.orig/kernel/futex.c
+++ linux-2.6/kernel/futex.c
@@ -745,7 +745,8 @@ void exit_pi_state_list(struct task_stru
 
 static int
 lookup_pi_state(u32 uval, struct futex_hash_bucket *hb,
-		union futex_key *key, struct futex_pi_state **ps)
+		union futex_key *key, struct futex_pi_state **ps,
+		struct task_struct *task)
 {
 	struct futex_pi_state *pi_state = NULL;
 	struct futex_q *this, *next;
@@ -786,6 +787,16 @@ lookup_pi_state(u32 uval, struct futex_h
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
 
@@ -935,7 +946,7 @@ retry:
 	 * We dont have the lock. Look up the PI state (or create it if
 	 * we are the first waiter):
 	 */
-	ret = lookup_pi_state(uval, hb, key, ps);
+	ret = lookup_pi_state(uval, hb, key, ps, task);
 
 	if (unlikely(ret)) {
 		switch (ret) {
@@ -1347,7 +1358,7 @@ void requeue_pi_wake_futex(struct futex_
  *
  * Return:
  *  0 - failed to acquire the lock atomically;
- *  1 - acquired the lock;
+ * >0 - acquired the lock, return value is vpid of the top_waiter
  * <0 - error
  */
 static int futex_proxy_trylock_atomic(u32 __user *pifutex,
@@ -1358,7 +1369,7 @@ static int futex_proxy_trylock_atomic(u3
 {
 	struct futex_q *top_waiter = NULL;
 	u32 curval;
-	int ret;
+	int ret, vpid;
 
 	if (get_futex_value_locked(&curval, pifutex))
 		return -EFAULT;
@@ -1386,11 +1397,13 @@ static int futex_proxy_trylock_atomic(u3
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
 
@@ -1421,7 +1434,6 @@ static int futex_requeue(u32 __user *uad
 	struct futex_pi_state *pi_state = NULL;
 	struct futex_hash_bucket *hb1, *hb2;
 	struct futex_q *this, *next;
-	u32 curval2;
 
 	if (requeue_pi) {
 		/*
@@ -1509,16 +1521,25 @@ retry_private:
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


