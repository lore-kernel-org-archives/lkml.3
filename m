Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751338AbaGYFHz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 01:07:55 -0400
Received: from mail-yk0-f176.google.com ([209.85.160.176]:59683 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaGYFHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 01:07:54 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: paulmck@linux.vnet.ibm.com, Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org (open list:READ-COPY UPDATE...)
Subject: [RFC PATCH 1/1] rcu: Use rcu_gp_kthread_wake() to wake up kthreads
Date: Fri, 25 Jul 2014 01:06:58 -0400
Message-Id: <1406264818-2296-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rcu_gp_kthread_wake() function checks for three conditions before waking up
grace period kthreads:

*  Is the thread we are trying to wake up the current thread?
*  Are the gp_flags zero? (all threads wait on non-zero gp_flags condition)
*  Is there no thread created for this flavour, hence nothing to wake up?

If any one of these condition is true, we do not call wake_up(). 

In rcu_report_qs_rsp(), I added a pr_info() call testing if any of the above
conditions is true, in which case we can avoid calling wake_up(). It turns out
that quite a few actually are. Most of the cases where we can avoid is condition 2
above and condition 1 also occurs quite often. Condition 3 never happens.

I could not test the wake_up() in force_quiescent_state() as that is not
triggered trivially, but I am assuming we can replace wake_up() there too.

Hence this commit tries to avoid calling wake_up() whenever we can by using
rcu_gp_kthread_wake() function.

One concern is the comment which states that we need a memory barrier at that
location which is being implied by the wake_up(). Should we put an smp_mb() and
just not rely on the barrier provided by wake_up()? Thoughts?

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 kernel/rcu/tree.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 72e0b1f..d0e0d6e 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -1938,7 +1938,8 @@ static void rcu_report_qs_rsp(struct rcu_state *rsp, unsigned long flags)
 {
 	WARN_ON_ONCE(!rcu_gp_in_progress(rsp));
 	raw_spin_unlock_irqrestore(&rcu_get_root(rsp)->lock, flags);
-	wake_up(&rsp->gp_wq);  /* Memory barrier implied by wake_up() path. */
+	/* Memory barrier implied by wake_up() path. */
+	rcu_gp_kthread_wake(rsp);
 }
 
 /*
@@ -2516,7 +2517,8 @@ static void force_quiescent_state(struct rcu_state *rsp)
 	ACCESS_ONCE(rsp->gp_flags) =
 		ACCESS_ONCE(rsp->gp_flags) | RCU_GP_FLAG_FQS;
 	raw_spin_unlock_irqrestore(&rnp_old->lock, flags);
-	wake_up(&rsp->gp_wq);  /* Memory barrier implied by wake_up() path. */
+	/* Memory barrier implied by wake_up() path. */
+	rcu_gp_kthread_wake(rsp);
 }
 
 /*
-- 
2.0.1

