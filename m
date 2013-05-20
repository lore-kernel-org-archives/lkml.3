Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757150Ab3ETOjr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 10:39:47 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:39037 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756660Ab3ETOjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 10:39:44 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 4/8] rcu: Switch callers from rcu_process_gp_end() to note_gp_changes()
Date: Mon, 20 May 2013 07:38:11 -0700
Message-Id: <1369060695-29679-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1369060695-29679-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130520143739.GA29365@linux.vnet.ibm.com>
 <1369060695-29679-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052014-4834-0000-0000-000007283C27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Because note_gp_changes() now incorporates rcu_process_gp_end() function,
this commit switches to the former and eliminates the latter.  In
addition, this commit changes external calls from __rcu_process_gp_end()
to __note_gp_changes().

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/rcutree.c        | 31 +++----------------------------
 kernel/rcutree_plugin.h |  2 +-
 2 files changed, 4 insertions(+), 29 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 2f40b4d..89d1978 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1344,28 +1344,6 @@ static void note_gp_changes(struct rcu_state *rsp, struct rcu_data *rdp)
 }
 
 /*
- * Advance this CPU's callbacks, but only if the current grace period
- * has ended.  This may be called only from the CPU to whom the rdp
- * belongs.
- */
-static void
-rcu_process_gp_end(struct rcu_state *rsp, struct rcu_data *rdp)
-{
-	unsigned long flags;
-	struct rcu_node *rnp;
-
-	local_irq_save(flags);
-	rnp = rdp->mynode;
-	if (rdp->completed == ACCESS_ONCE(rnp->completed) || /* outside lock. */
-	    !raw_spin_trylock(&rnp->lock)) { /* irqs already off, so later. */
-		local_irq_restore(flags);
-		return;
-	}
-	__rcu_process_gp_end(rsp, rnp, rdp);
-	raw_spin_unlock_irqrestore(&rnp->lock, flags);
-}
-
-/*
  * Did someone else start a new RCU grace period start since we last
  * checked?  Update local state appropriately if so.  Must be called
  * on the CPU corresponding to rdp.
@@ -1393,9 +1371,6 @@ check_for_new_grace_period(struct rcu_state *rsp, struct rcu_data *rdp)
 static void
 rcu_start_gp_per_cpu(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_data *rdp)
 {
-	/* Prior grace period ended, so advance callbacks for current CPU. */
-	__rcu_process_gp_end(rsp, rnp, rdp);
-
 	/* Set state so that this CPU will detect the next quiescent state. */
 	__note_gp_changes(rsp, rnp, rdp);
 }
@@ -1531,7 +1506,7 @@ static void rcu_gp_cleanup(struct rcu_state *rsp)
 		ACCESS_ONCE(rnp->completed) = rsp->gpnum;
 		rdp = this_cpu_ptr(rsp->rda);
 		if (rnp == rdp->mynode)
-			__rcu_process_gp_end(rsp, rnp, rdp);
+			__note_gp_changes(rsp, rnp, rdp);
 		nocb += rcu_future_gp_cleanup(rsp, rnp);
 		raw_spin_unlock_irq(&rnp->lock);
 		cond_resched();
@@ -2264,7 +2239,7 @@ __rcu_process_callbacks(struct rcu_state *rsp)
 	WARN_ON_ONCE(rdp->beenonline == 0);
 
 	/* Handle the end of a grace period that some other CPU ended.  */
-	rcu_process_gp_end(rsp, rdp);
+	note_gp_changes(rsp, rdp);
 
 	/* Update RCU state based on any recent quiescent states. */
 	rcu_check_quiescent_state(rsp, rdp);
@@ -2350,7 +2325,7 @@ static void __call_rcu_core(struct rcu_state *rsp, struct rcu_data *rdp,
 	if (unlikely(rdp->qlen > rdp->qlen_last_fqs_check + qhimark)) {
 
 		/* Are we ignoring a completed grace period? */
-		rcu_process_gp_end(rsp, rdp);
+		note_gp_changes(rsp, rdp);
 		check_for_new_grace_period(rsp, rdp);
 
 		/* Start a new grace period if one not already started. */
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 207844e..f279148 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1628,7 +1628,7 @@ static bool rcu_try_advance_all_cbs(void)
 		 */
 		if (rdp->completed != rnp->completed &&
 		    rdp->nxttail[RCU_DONE_TAIL] != rdp->nxttail[RCU_NEXT_TAIL])
-			rcu_process_gp_end(rsp, rdp);
+			note_gp_changes(rsp, rdp);
 
 		if (cpu_has_callbacks_ready_to_invoke(rdp))
 			cbs_ready = true;
-- 
1.8.1.5

