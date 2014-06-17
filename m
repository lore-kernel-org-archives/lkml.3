Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966890AbaFQVvh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:51:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54617 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966852AbaFQVvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:51:31 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 184/212] rtmutex: Fix deadlock detector for real
Date: Tue, 17 Jun 2014 14:44:38 -0700
Message-Id: <1403041506-13646-185-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 397335f004f41e5fcf7a795e94eb3ab83411a17c upstream.

The current deadlock detection logic does not work reliably due to the
following early exit path:

	/*
	 * Drop out, when the task has no waiters. Note,
	 * top_waiter can be NULL, when we are in the deboosting
	 * mode!
	 */
	if (top_waiter && (!task_has_pi_waiters(task) ||
			   top_waiter != task_top_pi_waiter(task)))
		goto out_unlock_pi;

So this not only exits when the task has no waiters, it also exits
unconditionally when the current waiter is not the top priority waiter
of the task.

So in a nested locking scenario, it might abort the lock chain walk
and therefor miss a potential deadlock.

Simple fix: Continue the chain walk, when deadlock detection is
enabled.

We also avoid the whole enqueue, if we detect the deadlock right away
(A-A). It's an optimization, but also prevents that another waiter who
comes in after the detection and before the task has undone the damage
observes the situation and detects the deadlock and returns
-EDEADLOCK, which is wrong as the other task is not in a deadlock
situation.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Link: http://lkml.kernel.org/r/20140522031949.725272460@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 kernel/locking/rtmutex.c | 32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
index 0dd6aec..16d5356c 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -225,9 +225,16 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
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
@@ -243,7 +250,12 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
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
@@ -412,6 +424,18 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
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
-- 
1.9.1

