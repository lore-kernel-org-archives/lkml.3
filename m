Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423AbaGWFKz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 01:10:55 -0400
Received: from mail-yk0-f178.google.com ([209.85.160.178]:63456 "EHLO
	mail-yk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757306AbaGWFKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 01:10:53 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org (open list:READ-COPY UPDATE...)
Subject: [PATCH 07/16] rcu: Save and restore irq flags in rcu_gp_cleanup()
Date: Wed, 23 Jul 2014 01:09:44 -0400
Message-Id: <1406092194-13004-8-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1406092194-13004-1-git-send-email-bobby.prani@gmail.com>
References: <1406092194-13004-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use raw_spin_lock_irqsave/restore() family of functions throughout the code
but for two locations. This commit replaces raw_spin_lock_irq()/unlock_irq()
with irqsave/restore() in one such location. This is not strictly necessary,
so I did not change the other location. I will update the other location if
this is accepted :)

This commit changes raw_spin_lock_irq()/unlock_irq() to lock_irqsave()/restore().

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 kernel/rcu/tree.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index b14cecd..5dcbf36 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -1706,13 +1706,13 @@ static int rcu_gp_fqs(struct rcu_state *rsp, int fqs_state_in)
  */
 static void rcu_gp_cleanup(struct rcu_state *rsp)
 {
-	unsigned long gp_duration;
+	unsigned long gp_duration, flags;
 	bool needgp = false;
 	int nocb = 0;
 	struct rcu_data *rdp;
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
-	raw_spin_lock_irq(&rnp->lock);
+	raw_spin_lock_irqsave(&rnp->lock, flags);
 	smp_mb__after_unlock_lock();
 	gp_duration = jiffies - rsp->gp_start;
 	if (gp_duration > rsp->gp_max)
@@ -1726,7 +1726,7 @@ static void rcu_gp_cleanup(struct rcu_state *rsp)
 	 * safe for us to drop the lock in order to mark the grace
 	 * period as completed in all of the rcu_node structures.
 	 */
-	raw_spin_unlock_irq(&rnp->lock);
+	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 
 	/*
 	 * Propagate new ->completed value to rcu_node structures so
@@ -1738,7 +1738,7 @@ static void rcu_gp_cleanup(struct rcu_state *rsp)
 	 * grace period is recorded in any of the rcu_node structures.
 	 */
 	rcu_for_each_node_breadth_first(rsp, rnp) {
-		raw_spin_lock_irq(&rnp->lock);
+		raw_spin_lock_irqsave(&rnp->lock, flags);
 		smp_mb__after_unlock_lock();
 		ACCESS_ONCE(rnp->completed) = rsp->gpnum;
 		rdp = this_cpu_ptr(rsp->rda);
@@ -1746,11 +1746,11 @@ static void rcu_gp_cleanup(struct rcu_state *rsp)
 			needgp = __note_gp_changes(rsp, rnp, rdp) || needgp;
 		/* smp_mb() provided by prior unlock-lock pair. */
 		nocb += rcu_future_gp_cleanup(rsp, rnp);
-		raw_spin_unlock_irq(&rnp->lock);
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 		cond_resched();
 	}
 	rnp = rcu_get_root(rsp);
-	raw_spin_lock_irq(&rnp->lock);
+	raw_spin_lock_irqsave(&rnp->lock, flags);
 	smp_mb__after_unlock_lock(); /* Order GP before ->completed update. */
 	rcu_nocb_gp_set(rnp, nocb);
 
@@ -1767,7 +1767,7 @@ static void rcu_gp_cleanup(struct rcu_state *rsp)
 				       ACCESS_ONCE(rsp->gpnum),
 				       TPS("newreq"));
 	}
-	raw_spin_unlock_irq(&rnp->lock);
+	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 }
 
 /*
-- 
2.0.0.rc2

