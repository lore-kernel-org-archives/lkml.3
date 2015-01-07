Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162AbbAGRxA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:53:00 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:52088 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755044AbbAGRw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 12:52:57 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 05/10] rcu: Handle gpnum/completed wrap while dyntick idle
Date: Wed,  7 Jan 2015 09:52:43 -0800
Message-Id: <1420653168-6434-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1420653168-6434-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20150107175225.GA4237@linux.vnet.ibm.com>
 <1420653168-6434-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010717-0013-0000-0000-000007B53701
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Subtle race conditions can result if a CPU stays in dyntick-idle mode
long enough for the ->gpnum and ->completed fields to wrap.  For
example, consider the following sequence of events:

o	CPU 1 encounters a quiescent state while waiting for grace period
	5 to complete, but then enters dyntick-idle mode.

o	While CPU 1 is in dyntick-idle mode, the grace-period counters
	wrap around so that the grace period number is now 4.

o	Just as CPU 1 exits dyntick-idle mode, grace period 4 completes
	and grace period 5 begins.

o	The quiescent state that CPU 1 passed through during the old
	grace period 5 looks like it applies to the new grace period
	5.  Therefore, the new grace period 5 completes without CPU 1
	having passed through a quiescent state.

This could clearly be a fatal surprise to any long-running RCU read-side
critical section that happened to be running on CPU 1 at the time.  At one
time, this was not a problem, given that it takes significant time for
the grace-period counters to overflow even on 32-bit systems.  However,
with the advent of NO_HZ_FULL and SMP embedded systems, arbitrarily long
idle periods are now becoming quite feasible.  It is therefore time to
close this race.

This commit therefore avoids this race condition by having the
quiescent-state forcing code detect when a CPU is falling too far
behind, and setting a new rcu_data field ->gpwrap when this happens.
Whenever this new ->gpwrap field is set, the CPU's ->gpnum and ->completed
fields are known to be untrustworthy, and can be ignored, along with
any associated quiescent states.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree.c        | 17 ++++++++++++-----
 kernel/rcu/tree.h        |  1 +
 kernel/rcu/tree_plugin.h |  3 ++-
 3 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index a2ceb66bcd67..5987fdc85fc4 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -930,6 +930,9 @@ static int dyntick_save_progress_counter(struct rcu_data *rdp,
 		trace_rcu_fqs(rdp->rsp->name, rdp->gpnum, rdp->cpu, TPS("dti"));
 		return 1;
 	} else {
+		if (ULONG_CMP_LT(ACCESS_ONCE(rdp->gpnum) + ULONG_MAX / 4,
+				 rdp->mynode->gpnum))
+			ACCESS_ONCE(rdp->gpwrap) = true;
 		return 0;
 	}
 }
@@ -1577,7 +1580,8 @@ static bool __note_gp_changes(struct rcu_state *rsp, struct rcu_node *rnp,
 	bool ret;
 
 	/* Handle the ends of any preceding grace periods first. */
-	if (rdp->completed == rnp->completed) {
+	if (rdp->completed == rnp->completed &&
+	    !unlikely(ACCESS_ONCE(rdp->gpwrap))) {
 
 		/* No grace period end, so just accelerate recent callbacks. */
 		ret = rcu_accelerate_cbs(rsp, rnp, rdp);
@@ -1592,7 +1596,7 @@ static bool __note_gp_changes(struct rcu_state *rsp, struct rcu_node *rnp,
 		trace_rcu_grace_period(rsp->name, rdp->gpnum, TPS("cpuend"));
 	}
 
-	if (rdp->gpnum != rnp->gpnum) {
+	if (rdp->gpnum != rnp->gpnum || unlikely(ACCESS_ONCE(rdp->gpwrap))) {
 		/*
 		 * If the current grace period is waiting for this CPU,
 		 * set up to detect a quiescent state, otherwise don't
@@ -1603,6 +1607,7 @@ static bool __note_gp_changes(struct rcu_state *rsp, struct rcu_node *rnp,
 		rdp->passed_quiesce = 0;
 		rdp->qs_pending = !!(rnp->qsmask & rdp->grpmask);
 		zero_cpu_stall_ticks(rdp);
+		ACCESS_ONCE(rdp->gpwrap) = false;
 	}
 	return ret;
 }
@@ -1616,7 +1621,8 @@ static void note_gp_changes(struct rcu_state *rsp, struct rcu_data *rdp)
 	local_irq_save(flags);
 	rnp = rdp->mynode;
 	if ((rdp->gpnum == ACCESS_ONCE(rnp->gpnum) &&
-	     rdp->completed == ACCESS_ONCE(rnp->completed)) || /* w/out lock. */
+	     rdp->completed == ACCESS_ONCE(rnp->completed) &&
+	     !unlikely(ACCESS_ONCE(rdp->gpwrap))) || /* w/out lock. */
 	    !raw_spin_trylock(&rnp->lock)) { /* irqs already off, so later. */
 		local_irq_restore(flags);
 		return;
@@ -2066,7 +2072,7 @@ rcu_report_qs_rdp(int cpu, struct rcu_state *rsp, struct rcu_data *rdp)
 	raw_spin_lock_irqsave(&rnp->lock, flags);
 	smp_mb__after_unlock_lock();
 	if (rdp->passed_quiesce == 0 || rdp->gpnum != rnp->gpnum ||
-	    rnp->completed == rnp->gpnum) {
+	    rnp->completed == rnp->gpnum || rdp->gpwrap) {
 
 		/*
 		 * The grace period in which this quiescent state was
@@ -3190,7 +3196,8 @@ static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
 	}
 
 	/* Has a new RCU grace period started? */
-	if (ACCESS_ONCE(rnp->gpnum) != rdp->gpnum) { /* outside lock */
+	if (ACCESS_ONCE(rnp->gpnum) != rdp->gpnum ||
+	    unlikely(ACCESS_ONCE(rdp->gpwrap))) { /* outside lock */
 		rdp->n_rp_gp_started++;
 		return 1;
 	}
diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index 5ec81cf938fd..7472ff388d55 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -260,6 +260,7 @@ struct rcu_data {
 	bool		passed_quiesce;	/* User-mode/idle loop etc. */
 	bool		qs_pending;	/* Core waits for quiesc state. */
 	bool		beenonline;	/* CPU online at least once. */
+	bool		gpwrap;		/* Possible gpnum/completed wrap. */
 	struct rcu_node *mynode;	/* This CPU's leaf of hierarchy */
 	unsigned long grpmask;		/* Mask to apply to leaf qsmask. */
 #ifdef CONFIG_RCU_CPU_STALL_INFO
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 769384d77437..81ff8b9a5a39 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -1605,7 +1605,8 @@ static bool __maybe_unused rcu_try_advance_all_cbs(void)
 		 * completed since we last checked and there are
 		 * callbacks not yet ready to invoke.
 		 */
-		if (rdp->completed != rnp->completed &&
+		if ((rdp->completed != rnp->completed ||
+		     unlikely(ACCESS_ONCE(rdp->gpwrap))) &&
 		    rdp->nxttail[RCU_DONE_TAIL] != rdp->nxttail[RCU_NEXT_TAIL])
 			note_gp_changes(rsp, rdp);
 
-- 
1.8.1.5

