Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954AbaFUUeN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 16:34:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34791 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753670AbaFUUeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 16:34:12 -0400
Date: Sat, 21 Jun 2014 13:33:03 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-67792e2cabadbadd1a93f6790fa7bcbd47eca7c3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rostedt@goodmis.org, peterz@infradead.org, tglx@linutronix.de,
        laijs@cn.fujitsu.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, peterz@infradead.org, tglx@linutronix.de,
        laijs@cn.fujitsu.com
In-Reply-To: <20140522031950.280830190@linutronix.de>
References: <20140522031950.280830190@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] rtmutex:
  Avoid pointless requeueing in the deadlock detection chain walk
Git-Commit-ID: 67792e2cabadbadd1a93f6790fa7bcbd47eca7c3
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

Commit-ID:  67792e2cabadbadd1a93f6790fa7bcbd47eca7c3
Gitweb:     http://git.kernel.org/tip/67792e2cabadbadd1a93f6790fa7bcbd47eca7c3
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 22 May 2014 03:25:57 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 21 Jun 2014 22:05:31 +0200

rtmutex: Avoid pointless requeueing in the deadlock detection chain walk

In case the dead lock detector is enabled we follow the lock chain to
the end in rt_mutex_adjust_prio_chain, even if we could stop earlier
due to the priority/waiter constellation.

But once we are no longer the top priority waiter in a certain step
or the task holding the lock has already the same priority then there
is no point in dequeing and enqueing along the lock chain as there is
no change at all.

So stop the queueing at this point.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Link: http://lkml.kernel.org/r/20140522031950.280830190@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/locking/rtmutex.c | 77 +++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 70 insertions(+), 7 deletions(-)

diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
index c6ffdaa..a0ea2a1 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -419,6 +419,7 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 	struct rt_mutex *lock;
 	bool detect_deadlock;
 	unsigned long flags;
+	bool requeue = true;
 
 	detect_deadlock = rt_mutex_cond_detect_deadlock(orig_waiter, chwalk);
 
@@ -508,18 +509,31 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 			goto out_unlock_pi;
 		/*
 		 * If deadlock detection is off, we stop here if we
-		 * are not the top pi waiter of the task.
+		 * are not the top pi waiter of the task. If deadlock
+		 * detection is enabled we continue, but stop the
+		 * requeueing in the chain walk.
 		 */
-		if (!detect_deadlock && top_waiter != task_top_pi_waiter(task))
-			goto out_unlock_pi;
+		if (top_waiter != task_top_pi_waiter(task)) {
+			if (!detect_deadlock)
+				goto out_unlock_pi;
+			else
+				requeue = false;
+		}
 	}
 
 	/*
-	 * When deadlock detection is off then we check, if further
-	 * priority adjustment is necessary.
+	 * If the waiter priority is the same as the task priority
+	 * then there is no further priority adjustment necessary.  If
+	 * deadlock detection is off, we stop the chain walk. If its
+	 * enabled we continue, but stop the requeueing in the chain
+	 * walk.
 	 */
-	if (!detect_deadlock && waiter->prio == task->prio)
-		goto out_unlock_pi;
+	if (waiter->prio == task->prio) {
+		if (!detect_deadlock)
+			goto out_unlock_pi;
+		else
+			requeue = false;
+	}
 
 	/*
 	 * [4] Get the next lock
@@ -553,6 +567,55 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 	}
 
 	/*
+	 * If we just follow the lock chain for deadlock detection, no
+	 * need to do all the requeue operations. To avoid a truckload
+	 * of conditionals around the various places below, just do the
+	 * minimum chain walk checks.
+	 */
+	if (!requeue) {
+		/*
+		 * No requeue[7] here. Just release @task [8]
+		 */
+		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
+		put_task_struct(task);
+
+		/*
+		 * [9] check_exit_conditions_3 protected by lock->wait_lock.
+		 * If there is no owner of the lock, end of chain.
+		 */
+		if (!rt_mutex_owner(lock)) {
+			raw_spin_unlock(&lock->wait_lock);
+			return 0;
+		}
+
+		/* [10] Grab the next task, i.e. owner of @lock */
+		task = rt_mutex_owner(lock);
+		get_task_struct(task);
+		raw_spin_lock_irqsave(&task->pi_lock, flags);
+
+		/*
+		 * No requeue [11] here. We just do deadlock detection.
+		 *
+		 * [12] Store whether owner is blocked
+		 * itself. Decision is made after dropping the locks
+		 */
+		next_lock = task_blocked_on_lock(task);
+		/*
+		 * Get the top waiter for the next iteration
+		 */
+		top_waiter = rt_mutex_top_waiter(lock);
+
+		/* [13] Drop locks */
+		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
+		raw_spin_unlock(&lock->wait_lock);
+
+		/* If owner is not blocked, end of chain. */
+		if (!next_lock)
+			goto out_put_task;
+		goto again;
+	}
+
+	/*
 	 * Store the current top waiter before doing the requeue
 	 * operation on @lock. We need it for the boost/deboost
 	 * decision below.
