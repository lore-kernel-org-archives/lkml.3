Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758471AbaELUpf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 16:45:35 -0400
Received: from www.linutronix.de ([62.245.132.108]:56758 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758355AbaELUpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 16:45:32 -0400
Message-Id: <20140512201700.999660035@linutronix.de>
User-Agent: quilt/0.60-1
Date: Mon, 12 May 2014 20:45:33 -0000
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
Subject: [patch 1/3] rtmutex: Add missing deadlock check
References: <20140512190438.314125476@linutronix.de>
Content-Disposition: inline; filename=rtmutex-add-missing-deadlock-check.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a task T holds rtmutex L and has pending waiters on that lock then
an attempt of task T to recursivly lock L can escape the deadlock
detection if T itself does not end up being the top most waiter on
that lock. So it happily enqueues itself in the waiter list.

This was exposed by Dave Jones trinity syscall fuzzer:
  http://lkml.kernel.org/r/20140429151655.GA14277@redhat.com

The fix for the issue at hand is simple and more comment than actual
code: Test whether the new waiter task owns one of the locks in the
lock chain and handle it the same way as the other deadlock sites.

The problem has been in the rtmutex code forever.

I would have added a testcase for such a scenario to the rtmutex
tester, but the tester got wreckaged with commit 8161239a8 (rtmutex:
Simplify PI algorithm and make highest prio task get lock). So that
becomes a separate issue. Sigh!

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
---
 kernel/locking/rtmutex.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

Index: linux-2.6/kernel/locking/rtmutex.c
===================================================================
--- linux-2.6.orig/kernel/locking/rtmutex.c
+++ linux-2.6/kernel/locking/rtmutex.c
@@ -284,7 +284,7 @@ static int rt_mutex_adjust_prio_chain(st
 				      struct rt_mutex_waiter *orig_waiter,
 				      struct task_struct *top_task)
 {
-	struct rt_mutex *lock;
+	struct rt_mutex *lock = orig_lock;
 	struct rt_mutex_waiter *waiter, *top_waiter = orig_waiter;
 	int detect_deadlock, ret = 0, depth = 0;
 	unsigned long flags;
@@ -339,6 +339,22 @@ static int rt_mutex_adjust_prio_chain(st
 		goto out_unlock_pi;
 
 	/*
+	 * Deadlock check for the following scenario:
+	 *
+	 * T holds lock L and has waiters
+	 * T locks L again, but does not end up as it's own top waiter
+	 *
+	 * So we would drop out at the next check without noticing.
+	 *
+	 * Note, we need to check for orig_waiter as it might be NULL
+	 * when deboosting!
+	 */
+	if (orig_waiter && orig_waiter->task == rt_mutex_owner(lock)) {
+		ret = deadlock_detect ? -EDEADLK : 0;
+		goto out_unlock_pi;
+	}
+
+	/*
 	 * Drop out, when the task has no waiters. Note,
 	 * top_waiter can be NULL, when we are in the deboosting
 	 * mode!


