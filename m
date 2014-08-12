Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812AbaHLRH3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 13:07:29 -0400
Received: from mail-yh0-f43.google.com ([209.85.213.43]:58135 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117AbaHLRH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 13:07:28 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org (open list:READ-COPY UPDATE...)
Subject: [PATCH v2] rcu: Use rcu_gp_kthread_wake() to wake up grace period kthreads
Date: Tue, 12 Aug 2014 13:07:47 -0400
Message-Id: <1407863267-27559-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated changelog regarding the removed comment about the implied barrier
provided by wake_up() logic.

--
Pranith

The rcu_gp_kthread_wake() function checks for three conditions before waking up
grace period kthreads:

*  Is the thread we are trying to wake up the current thread?
*  Are the gp_flags zero? (all threads wait on non-zero gp_flags condition)
*  Is there no thread created for this flavour, hence nothing to wake up?

If any one of these condition is true, we do not call wake_up().
It was found that there are quite a few avoidable wake ups both during
idle time and under stress induced by rcutorture.

Idle:

Total:66000, unnecessary:66000, case1:61827, case2:66000, case3:0
Total:68000, unnecessary:68000, case1:63696, case2:68000, case3:0

rcutorture:

Total:254000, unnecessary:254000, case1:199913, case2:254000, case3:0
Total:256000, unnecessary:256000, case1:201784, case2:256000, case3:0

Here case{1-3} are the cases listed above. We can avoid these wake ups by using
rcu_gp_kthread_wake() to conditionally wake up the grace period kthreads.

There is a comment about an implied barrier supplied by the wake_up() logic.
This barrier is necessary for the awakened thread to see the updated ->gp_flags.
This flag is always being updated with the root node lock held. Also, the
awakened thread tries to acquire the root node lock before reading ->gp_flags
because of which there is proper ordering.

Hence this commit tries to avoid calling wake_up() whenever we can by using
rcu_gp_kthread_wake() function.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
CC: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/rcu/tree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index b63517c..6b68d2d 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -1938,7 +1938,7 @@ static void rcu_report_qs_rsp(struct rcu_state *rsp, unsigned long flags)
 {
 	WARN_ON_ONCE(!rcu_gp_in_progress(rsp));
 	raw_spin_unlock_irqrestore(&rcu_get_root(rsp)->lock, flags);
-	wake_up(&rsp->gp_wq);  /* Memory barrier implied by wake_up() path. */
+	rcu_gp_kthread_wake(rsp);
 }
 
 /*
@@ -2516,7 +2516,7 @@ static void force_quiescent_state(struct rcu_state *rsp)
 	ACCESS_ONCE(rsp->gp_flags) =
 		ACCESS_ONCE(rsp->gp_flags) | RCU_GP_FLAG_FQS;
 	raw_spin_unlock_irqrestore(&rnp_old->lock, flags);
-	wake_up(&rsp->gp_wq);  /* Memory barrier implied by wake_up() path. */
+	rcu_gp_kthread_wake(rsp);
 }
 
 /*
-- 
1.9.1

