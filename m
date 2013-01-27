Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879Ab3A0FR7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 00:17:59 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:51306 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755237Ab3A0FQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 00:16:08 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 05/12] rcu: Accelerate RCU callbacks at grace-period end
Date: Sat, 26 Jan 2013 16:29:56 -0800
Message-Id: <1359246603-6863-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1359246603-6863-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130127002943.GA6067@linux.vnet.ibm.com>
 <1359246603-6863-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012705-5518-0000-0000-00000B0BCA26
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

Now that callback acceleration is idempotent, it is safe to accelerate
callbacks during grace-period cleanup on any CPUs that the kthread happens
to be running on.  This commit therefore propagates the completion
of the grace period to the per-CPU data structures, and also adds an
rcu_advance_cbs() just before the cpu_needs_another_gp() check in order
to reduce false-positive grace periods.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |   21 +++++++++++++--------
 1 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 074cb2d..2015bce 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1396,6 +1396,9 @@ static void rcu_gp_cleanup(struct rcu_state *rsp)
 	rcu_for_each_node_breadth_first(rsp, rnp) {
 		raw_spin_lock_irq(&rnp->lock);
 		rnp->completed = rsp->gpnum;
+		rdp = this_cpu_ptr(rsp->rda);
+		if (rnp == rdp->mynode)
+			__rcu_process_gp_end(rsp, rnp, rdp);
 		nocb += rcu_nocb_gp_cleanup(rsp, rnp);
 		raw_spin_unlock_irq(&rnp->lock);
 		cond_resched();
@@ -1408,6 +1411,7 @@ static void rcu_gp_cleanup(struct rcu_state *rsp)
 	trace_rcu_grace_period(rsp->name, rsp->completed, "end");
 	rsp->fqs_state = RCU_GP_IDLE;
 	rdp = this_cpu_ptr(rsp->rda);
+	rcu_advance_cbs(rsp, rnp, rdp);  /* Reduce false positives below. */
 	if (cpu_needs_another_gp(rsp, rdp))
 		rsp->gp_flags = 1;
 	raw_spin_unlock_irq(&rnp->lock);
@@ -1497,6 +1501,15 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 	struct rcu_data *rdp = this_cpu_ptr(rsp->rda);
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
+	/*
+	 * If there is no grace period in progress right now, any
+	 * callbacks we have up to this point will be satisfied by the
+	 * next grace period.  Also, advancing the callbacks reduces the
+	 * probability of false positives from cpu_needs_another_gp()
+	 * resulting in pointless grace periods.  So, advance callbacks!
+	 */
+	rcu_advance_cbs(rsp, rnp, rdp);
+
 	if (!rsp->gp_kthread ||
 	    !cpu_needs_another_gp(rsp, rdp)) {
 		/*
@@ -1509,14 +1522,6 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 		return;
 	}
 
-	/*
-	 * Because there is no grace period in progress right now,
-	 * any callbacks we have up to this point will be satisfied
-	 * by the next grace period.  So this is a good place to
-	 * assign a grace period number to recently posted callbacks.
-	 */
-	rcu_accelerate_cbs(rsp, rnp, rdp);
-
 	rsp->gp_flags = RCU_GP_FLAG_INIT;
 	raw_spin_unlock(&rnp->lock); /* Interrupts remain disabled. */
 
-- 
1.7.8

