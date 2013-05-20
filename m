Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757172Ab3ETOkf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 10:40:35 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:41188 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756825Ab3ETOif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 10:38:35 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 5/8] rcu: Merge __rcu_process_gp_end() into __note_gp_changes()
Date: Mon, 20 May 2013 07:38:12 -0700
Message-Id: <1369060695-29679-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1369060695-29679-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130520143739.GA29365@linux.vnet.ibm.com>
 <1369060695-29679-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052014-5518-0000-0000-00000ED052B2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit eliminates some duplicated code by merging
__rcu_process_gp_end() into __note_gp_changes().

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/rcutree.c | 48 ++++++------------------------------------------
 1 file changed, 6 insertions(+), 42 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 89d1978..26befd0 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1254,18 +1254,16 @@ static void rcu_advance_cbs(struct rcu_state *rsp, struct rcu_node *rnp,
 }
 
 /*
- * Advance this CPU's callbacks, but only if the current grace period
- * has ended.  This may be called only from the CPU to whom the rdp
- * belongs.  In addition, the corresponding leaf rcu_node structure's
- * ->lock must be held by the caller, with irqs disabled.
+ * Update CPU-local rcu_data state to record the beginnings and ends of
+ * grace periods.  The caller must hold the ->lock of the leaf rcu_node
+ * structure corresponding to the current CPU, and must have irqs disabled.
  */
-static void
-__rcu_process_gp_end(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_data *rdp)
+static void __note_gp_changes(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_data *rdp)
 {
-	/* Did another grace period end? */
+	/* Handle the ends of any preceding grace periods first. */
 	if (rdp->completed == rnp->completed) {
 
-		/* No, so just accelerate recent callbacks. */
+		/* No grace period end, so just accelerate recent callbacks. */
 		rcu_accelerate_cbs(rsp, rnp, rdp);
 
 	} else {
@@ -1276,41 +1274,7 @@ __rcu_process_gp_end(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_dat
 		/* Remember that we saw this grace-period completion. */
 		rdp->completed = rnp->completed;
 		trace_rcu_grace_period(rsp->name, rdp->gpnum, "cpuend");
-
-		/*
-		 * If we were in an extended quiescent state, we may have
-		 * missed some grace periods that others CPUs handled on
-		 * our behalf. Catch up with this state to avoid noting
-		 * spurious new grace periods.  If another grace period
-		 * has started, then rnp->gpnum will have advanced, so
-		 * we will detect this later on.  Of course, any quiescent
-		 * states we found for the old GP are now invalid.
-		 */
-		if (ULONG_CMP_LT(rdp->gpnum, rdp->completed)) {
-			rdp->gpnum = rdp->completed;
-			rdp->passed_quiesce = 0;
-		}
-
-		/*
-		 * If RCU does not need a quiescent state from this CPU,
-		 * then make sure that this CPU doesn't go looking for one.
-		 */
-		if ((rnp->qsmask & rdp->grpmask) == 0)
-			rdp->qs_pending = 0;
 	}
-}
-
-/*
- * Update CPU-local rcu_data state to record the newly noticed grace period.
- * This is used both when we started the grace period and when we notice
- * that someone else started the grace period.  The caller must hold the
- * ->lock of the leaf rcu_node structure corresponding to the current CPU,
- *  and must have irqs disabled.
- */
-static void __note_gp_changes(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_data *rdp)
-{
-	/* Handle the ends of any preceding grace periods first. */
-	__rcu_process_gp_end(rsp, rnp, rdp);
 
 	if (rdp->gpnum != rnp->gpnum) {
 		/*
-- 
1.8.1.5

