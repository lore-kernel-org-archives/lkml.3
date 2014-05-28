Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169AbaE1TaS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 15:30:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40630 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbaE1TaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 15:30:16 -0400
Date: Wed, 28 May 2014 12:28:21 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-397335f004f41e5fcf7a795e94eb3ab83411a17c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rostedt@goodmis.org, peterz@infradead.org, tglx@linutronix.de,
        laijs@cn.fujitsu.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, peterz@infradead.org, tglx@linutronix.de,
        laijs@cn.fujitsu.com
In-Reply-To: <20140522031949.725272460@linutronix.de>
References: <20140522031949.725272460@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] rtmutex: Fix deadlock detector for real
Git-Commit-ID: 397335f004f41e5fcf7a795e94eb3ab83411a17c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  397335f004f41e5fcf7a795e94eb3ab83411a17c
Gitweb:     http://git.kernel.org/tip/397335f004f41e5fcf7a795e94eb3ab83411a17c
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 22 May 2014 03:25:39 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 28 May 2014 17:28:13 +0200

rtmutex: Fix deadlock detector for real

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
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/20140522031949.725272460@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/locking/rtmutex.c | 32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

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
