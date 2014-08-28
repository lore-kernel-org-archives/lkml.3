Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161AbaH1S0q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:26:46 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:50676 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383AbaH1S0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:26:44 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 01/15] rcu: Remove remaining read-modify-write ACCESS_ONCE() calls
Date: Thu, 28 Aug 2014 11:26:20 -0700
Message-Id: <1409250394-25159-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <20140828182614.GA23877@linux.vnet.ibm.com>
References: <20140828182614.GA23877@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082818-1542-0000-0000-0000045F4DF0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pranith Kumar <bobby.prani@gmail.com>

Change the remaining uses of ACCESS_ONCE() so that each ACCESS_ONCE() either does a load or a store, but not both.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree.c        | 6 ++++--
 kernel/rcu/tree_plugin.h | 8 +++++---
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 1b70cb6fbe3c..4b526ca46801 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -1684,7 +1684,8 @@ static int rcu_gp_fqs(struct rcu_state *rsp, int fqs_state_in)
 	if (ACCESS_ONCE(rsp->gp_flags) & RCU_GP_FLAG_FQS) {
 		raw_spin_lock_irq(&rnp->lock);
 		smp_mb__after_unlock_lock();
-		ACCESS_ONCE(rsp->gp_flags) &= ~RCU_GP_FLAG_FQS;
+		ACCESS_ONCE(rsp->gp_flags) =
+			ACCESS_ONCE(rsp->gp_flags) & ~RCU_GP_FLAG_FQS;
 		raw_spin_unlock_irq(&rnp->lock);
 	}
 	return fqs_state;
@@ -2505,7 +2506,8 @@ static void force_quiescent_state(struct rcu_state *rsp)
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
index 00dc411e9676..2626a07ae8f2 100644
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
@@ -2428,8 +2429,9 @@ static int rcu_nocb_kthread(void *arg)
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
1.8.1.5

