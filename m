Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932384AbaFIU2V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 16:28:21 -0400
Received: from www.linutronix.de ([62.245.132.108]:46586 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112AbaFIU2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 16:28:11 -0400
Message-Id: <20140609202336.158034184@linutronix.de>
User-Agent: quilt/0.63-1
Date: Mon, 09 Jun 2014 20:28:08 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jason Low <jason.low2@hp.com>,
        Brad Mouring <bmouring@ni.com>
Subject: [patch V3 3/7] rtmutex: Document pi chain walk
References: <20140609201118.387571774@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=rtmutex-document-chain-walk.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add commentry to document the chain walk and the protection mechanisms
and their scope.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/locking/rtmutex.c |   52 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

Index: tip/kernel/locking/rtmutex.c
===================================================================
--- tip.orig/kernel/locking/rtmutex.c
+++ tip/kernel/locking/rtmutex.c
@@ -285,6 +285,47 @@ static inline struct rt_mutex *task_bloc
  * @top_task:	the current top waiter
  *
  * Returns 0 or -EDEADLK.
+ *
+ * Chain walk basics and protection scope
+ *
+ * [A] refcount on task
+ * [B] task->pi_lock held
+ * [C] rtmutex->lock held
+ *
+ * call()					Protected by
+ *	@task					[A]
+ *	@orig_lock if != NULL			@top_task is blocked on it
+ *	@next_lock				Unprotected. Cannot be
+ *						dereferenced. Only used for
+ *						comparison.
+ *	@orig_waiter if != NULL			@top_task is blocked on it
+ *	@top_task				current, or in case of proxy
+ *						locking protected by calling
+ *						code
+ * again:
+ *	loop_sanity_check();
+ * retry:
+ *	lock(task->pi_lock);			[A] acquire [B]
+ *	waiter = task->pi_blocked_on;		[B]
+ *	check_exit_conditions();		[B]
+ *	lock = waiter->lock;			[B]
+ *	if (!try_lock(lock->wait_lock)) {	[B] try to acquire [C]
+ *		unlock(task->pi_lock);		drop [B]
+ *		goto retry;
+ *	}
+ *	check_exit_conditions();		[B] + [C]
+ *	requeue_lock_waiter(lock, waiter);	[B] + [C]
+ *	unlock(task->pi_lock);			drop [B]
+ *	drop_task_ref(task);			drop [A]
+ *	check_exit_conditions();		[C]
+ *	task = owner(lock);			[C]
+ *	get_task_ref(task);			[C] acquire [A]
+ *	lock(task->pi_lock);			[C] acquire [B]
+ *	requeue_pi_waiter(task, waiters(lock));	[B] + [C]
+ *	check_exit_conditions();		[B] + [C]
+ *	unlock(task->pi_lock);			drop [B]
+ *	unlock(lock->wait_lock);		drop [C]
+ *	goto again;
  */
 static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 				      int deadlock_detect,
@@ -326,6 +367,12 @@ static int rt_mutex_adjust_prio_chain(st
 
 		return -EDEADLK;
 	}
+
+	/*
+	 * We are fully preemptible here and only hold the refcount on
+	 * @task. So everything can have changed under us since the
+	 * caller or our own code below (goto retry) dropped all locks.
+	 */
  retry:
 	/*
 	 * Task can not go away as we did a get_task() before !
@@ -383,6 +430,11 @@ static int rt_mutex_adjust_prio_chain(st
 	if (!detect_deadlock && waiter->prio == task->prio)
 		goto out_unlock_pi;
 
+	/*
+	 * We need to trylock here as we are holding task->pi_lock,
+	 * which is the reverse lock order versus the other rtmutex
+	 * operations.
+	 */
 	lock = waiter->lock;
 	if (!raw_spin_trylock(&lock->wait_lock)) {
 		raw_spin_unlock_irqrestore(&task->pi_lock, flags);


