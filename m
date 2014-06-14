Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377AbaFNUot (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 16:44:49 -0400
Received: from 1wt.eu ([62.212.114.60]:42905 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754241AbaFNUop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 16:44:45 -0400
Message-Id: <20140614191250.210042781@1wt.eu>
User-Agent: quilt/0.48-1
Date: Sat, 14 Jun 2014 21:12:52 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Darren Hart <darren@dvhart.com>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Clark Williams <williams@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Roland McGrath <roland@hack.frob.com>,
        Carlos ODonell <carlos@redhat.com>, Jakub Jelinek <jakub@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 2/9] futex: Add another early deadlock detection check
In-Reply-To: <57d1129d02f4fc14423dd66474950cb7@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

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
Cc: Dave Jones <davej@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Darren Hart <darren@dvhart.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Clark Williams <williams@redhat.com>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Roland McGrath <roland@hack.frob.com>
Cc: Carlos ODonell <carlos@redhat.com>
Cc: Jakub Jelinek <jakub@redhat.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Link: http://lkml.kernel.org/r/20140512201701.097349971@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
(cherry picked from commit 866293ee54227584ffcb4a42f69c1f365974ba7f)
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 kernel/futex.c | 49 +++++++++++++++++++++++++++++++++++--------------
 1 file changed, 35 insertions(+), 14 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 9c5ffe1..731b271 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -538,7 +538,8 @@ void exit_pi_state_list(struct task_struct *curr)
 
 static int
 lookup_pi_state(u32 uval, struct futex_hash_bucket *hb,
-		union futex_key *key, struct futex_pi_state **ps)
+		union futex_key *key, struct futex_pi_state **ps,
+		struct task_struct *task)
 {
 	struct futex_pi_state *pi_state = NULL;
 	struct futex_q *this, *next;
@@ -582,6 +583,16 @@ lookup_pi_state(u32 uval, struct futex_hash_bucket *hb,
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
 
@@ -737,7 +748,7 @@ retry:
 	 * We dont have the lock. Look up the PI state (or create it if
 	 * we are the first waiter):
 	 */
-	ret = lookup_pi_state(uval, hb, key, ps);
+	ret = lookup_pi_state(uval, hb, key, ps, task);
 
 	if (unlikely(ret)) {
 		switch (ret) {
@@ -1122,8 +1133,8 @@ void requeue_pi_wake_futex(struct futex_q *q, union futex_key *key,
  * hb1 and hb2 must be held by the caller.
  *
  * Returns:
- *  0 - failed to acquire the lock atomicly
- *  1 - acquired the lock
+ *  0 - failed to acquire the lock atomically;
+ * >0 - acquired the lock, return value is vpid of the top_waiter
  * <0 - error
  */
 static int futex_proxy_trylock_atomic(u32 __user *pifutex,
@@ -1134,7 +1145,7 @@ static int futex_proxy_trylock_atomic(u32 __user *pifutex,
 {
 	struct futex_q *top_waiter = NULL;
 	u32 curval;
-	int ret;
+	int ret, vpid;
 
 	if (get_futex_value_locked(&curval, pifutex))
 		return -EFAULT;
@@ -1162,11 +1173,13 @@ static int futex_proxy_trylock_atomic(u32 __user *pifutex,
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
 
@@ -1196,7 +1209,6 @@ static int futex_requeue(u32 __user *uaddr1, int fshared, u32 __user *uaddr2,
 	struct futex_hash_bucket *hb1, *hb2;
 	struct plist_head *head1;
 	struct futex_q *this, *next;
-	u32 curval2;
 
 	if (requeue_pi) {
 		/*
@@ -1282,16 +1294,25 @@ retry_private:
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
-- 
1.7.12.2.21.g234cd45.dirty



