Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237AbaGHVqo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 17:46:44 -0400
Received: from mail-yh0-f43.google.com ([209.85.213.43]:53563 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbaGHVqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 17:46:43 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        linux-kernel@vger.kernel.org (open list:READ-COPY UPDATE...)
Subject: [PATCH 1/1] rcu: remove remaining read-modify-write ACCESS_ONCE() calls
Date: Tue,  8 Jul 2014 17:46:50 -0400
Message-Id: <1404856010-7506-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the remaining uses of ACCESS_ONCE() so that each ACCESS_ONCE() either does a load or a store, but not both.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 kernel/rcu/tree.c        | 6 ++++--
 kernel/rcu/tree_plugin.h | 8 +++++---
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index dac6d20..c356bf6 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -1700,7 +1700,8 @@ static int rcu_gp_fqs(struct rcu_state *rsp, int fqs_state_in)
 	if (ACCESS_ONCE(rsp->gp_flags) & RCU_GP_FLAG_FQS) {
 		raw_spin_lock_irq(&rnp->lock);
 		smp_mb__after_unlock_lock();
-		ACCESS_ONCE(rsp->gp_flags) &= ~RCU_GP_FLAG_FQS;
+		ACCESS_ONCE(rsp->gp_flags) =
+			ACCESS_ONCE(rsp->gp_flags) & ~RCU_GP_FLAG_FQS;
 		raw_spin_unlock_irq(&rnp->lock);
 	}
 	return fqs_state;
@@ -2514,7 +2515,8 @@ static void force_quiescent_state(struct rcu_state *rsp)
 		raw_spin_unlock_irqrestore(&rnp_old->lock, flags);
 		return;  /* Someone beat us to it. */
 	}
-	ACCESS_ONCE(rsp->gp_flags) |= RCU_GP_FLAG_FQS;
+	ACCESS_ONCE(rsp->gp_flags) =
+		ACCESS_ONCE(rsp->gp_flags) | RCU_GP_FLAG_FQS;
 	raw_spin_unlock_irqrestore(&rnp_old->lock, flags);
 	wake_up(&rsp->gp_wq);  /* Memory barrier implied by wake_up() path. */
 }
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 637a8a9..f87b88c 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -897,7 +897,8 @@ void synchronize_rcu_expedited(void)
 
 	/* Clean up and exit. */
 	smp_mb(); /* ensure expedited GP seen before counter increment. */
-	ACCESS_ONCE(sync_rcu_preempt_exp_count)++;
+	ACCESS_ONCE(sync_rcu_preempt_exp_count) =
+					sync_rcu_preempt_exp_count + 1;
 unlock_mb_ret:
 	mutex_unlock(&sync_rcu_preempt_exp_mutex);
 mb_ret:
@@ -2307,8 +2308,9 @@ static int rcu_nocb_kthread(void *arg)
 			list = next;
 		}
 		trace_rcu_batch_end(rdp->rsp->name, c, !!list, 0, 0, 1);
-		ACCESS_ONCE(rdp->nocb_p_count) -= c;
-		ACCESS_ONCE(rdp->nocb_p_count_lazy) -= cl;
+		ACCESS_ONCE(rdp->nocb_p_count) = rdp->nocb_p_count - c;
+		ACCESS_ONCE(rdp->nocb_p_count_lazy) =
+						rdp->nocb_p_count_lazy - cl;
 		rdp->n_nocbs_invoked += c;
 	}
 	return 0;
-- 
1.9.1

