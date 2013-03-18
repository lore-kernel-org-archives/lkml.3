Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933598Ab3CRVh0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:37:26 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:33783 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933182Ab3CRVhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:37:20 -0400
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
Subject: [PATCH tip/core/rcu 11/15] rcu: Repurpose no-CBs event tracing to future-GP events
Date: Mon, 18 Mar 2013 14:36:46 -0700
Message-Id: <1363642610-21390-11-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1363642610-21390-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130318213608.GA20296@linux.vnet.ibm.com>
 <1363642610-21390-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031821-2398-0000-0000-000012514ECE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

Dyntick-idle CPUs need to be able to pre-announce their need for grace
periods.  This can be done using something similar to the mechanism used
by no-CB CPUs to announce their need for grace periods.  This commit
moves in this direction by renaming the no-CBs grace-period event tracing
to suit the new future-grace-period needs.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/trace/events/rcu.h | 16 ++++++------
 kernel/rcutree_plugin.h    | 62 ++++++++++++++++++++++++----------------------
 2 files changed, 40 insertions(+), 38 deletions(-)

diff --git a/include/trace/events/rcu.h b/include/trace/events/rcu.h
index cdfed6d..59ebcc8 100644
--- a/include/trace/events/rcu.h
+++ b/include/trace/events/rcu.h
@@ -72,10 +72,10 @@ TRACE_EVENT(rcu_grace_period,
 );
 
 /*
- * Tracepoint for no-callbacks grace-period events.  The caller should
- * pull the data from the rcu_node structure, other than rcuname, which
- * comes from the rcu_state structure, and event, which is one of the
- * following:
+ * Tracepoint for future grace-period events, including those for no-callbacks
+ * CPUs.  The caller should pull the data from the rcu_node structure,
+ * other than rcuname, which comes from the rcu_state structure, and event,
+ * which is one of the following:
  *
  * "Startleaf": Request a nocb grace period based on leaf-node data.
  * "Startedleaf": Leaf-node start proved sufficient.
@@ -87,7 +87,7 @@ TRACE_EVENT(rcu_grace_period,
  * "Cleanup": Clean up rcu_node structure after previous GP.
  * "CleanupMore": Clean up, and another no-CB GP is needed.
  */
-TRACE_EVENT(rcu_nocb_grace_period,
+TRACE_EVENT(rcu_future_grace_period,
 
 	TP_PROTO(char *rcuname, unsigned long gpnum, unsigned long completed,
 		 unsigned long c, u8 level, int grplo, int grphi,
@@ -653,9 +653,9 @@ TRACE_EVENT(rcu_barrier,
 #define trace_rcu_grace_period(rcuname, gpnum, gpevent) do { } while (0)
 #define trace_rcu_grace_period_init(rcuname, gpnum, level, grplo, grphi, \
 				    qsmask) do { } while (0)
-#define trace_rcu_nocb_grace_period(rcuname, gpnum, completed, c, \
-				    level, grplo, grphi, event) \
-				    do { } while (0)
+#define trace_rcu_future_grace_period(rcuname, gpnum, completed, c, \
+				      level, grplo, grphi, event) \
+				      do { } while (0)
 #define trace_rcu_preempt_task(rcuname, pid, gpnum) do { } while (0)
 #define trace_rcu_unlock_preempted_task(rcuname, gpnum, pid) do { } while (0)
 #define trace_rcu_quiescent_state_report(rcuname, gpnum, mask, qsmask, level, \
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index d318f9f..df50502 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -2034,9 +2034,9 @@ static int rcu_nocb_gp_cleanup(struct rcu_state *rsp, struct rcu_node *rnp)
 	wake_up_all(&rnp->nocb_gp_wq[c & 0x1]);
 	rnp->n_nocb_gp_requests[c & 0x1] = 0;
 	needmore = rnp->n_nocb_gp_requests[(c + 1) & 0x1];
-	trace_rcu_nocb_grace_period(rsp->name, rnp->gpnum, rnp->completed,
-				    c, rnp->level, rnp->grplo, rnp->grphi,
-				    needmore ? "CleanupMore" : "Cleanup");
+	trace_rcu_future_grace_period(rsp->name, rnp->gpnum, rnp->completed,
+				      c, rnp->level, rnp->grplo, rnp->grphi,
+				      needmore ? "CleanupMore" : "Cleanup");
 	return needmore;
 }
 
@@ -2183,9 +2183,9 @@ static void rcu_nocb_wait_gp(struct rcu_data *rdp)
 
 	/* Count our request for a grace period. */
 	rnp->n_nocb_gp_requests[c & 0x1]++;
-	trace_rcu_nocb_grace_period(rdp->rsp->name, rnp->gpnum, rnp->completed,
-				    c, rnp->level, rnp->grplo, rnp->grphi,
-				    "Startleaf");
+	trace_rcu_future_grace_period(rdp->rsp->name, rnp->gpnum,
+				      rnp->completed, c, rnp->level,
+				      rnp->grplo, rnp->grphi, "Startleaf");
 
 	if (rnp->gpnum != rnp->completed) {
 
@@ -2194,10 +2194,10 @@ static void rcu_nocb_wait_gp(struct rcu_data *rdp)
 		 * is in progress, so we are done.  When this grace
 		 * period ends, our request will be acted upon.
 		 */
-		trace_rcu_nocb_grace_period(rdp->rsp->name,
-					    rnp->gpnum, rnp->completed, c,
-					    rnp->level, rnp->grplo, rnp->grphi,
-					    "Startedleaf");
+		trace_rcu_future_grace_period(rdp->rsp->name, rnp->gpnum,
+					      rnp->completed, c, rnp->level,
+					      rnp->grplo, rnp->grphi,
+					      "Startedleaf");
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 
 	} else {
@@ -2209,11 +2209,12 @@ static void rcu_nocb_wait_gp(struct rcu_data *rdp)
 		if (rnp != rnp_root)
 			raw_spin_lock(&rnp_root->lock); /* irqs disabled. */
 		if (rnp_root->gpnum != rnp_root->completed) {
-			trace_rcu_nocb_grace_period(rdp->rsp->name,
-						    rnp->gpnum, rnp->completed,
-						    c, rnp->level,
-						    rnp->grplo, rnp->grphi,
-						    "Startedleafroot");
+			trace_rcu_future_grace_period(rdp->rsp->name,
+						      rnp->gpnum,
+						      rnp->completed,
+						      c, rnp->level,
+						      rnp->grplo, rnp->grphi,
+						      "Startedleafroot");
 			raw_spin_unlock(&rnp_root->lock); /* irqs disabled. */
 		} else {
 
@@ -2229,11 +2230,12 @@ static void rcu_nocb_wait_gp(struct rcu_data *rdp)
 			c = rnp_root->completed + 1;
 			rnp->n_nocb_gp_requests[c & 0x1]++;
 			rnp_root->n_nocb_gp_requests[c & 0x1]++;
-			trace_rcu_nocb_grace_period(rdp->rsp->name,
-						    rnp->gpnum, rnp->completed,
-						    c, rnp->level,
-						    rnp->grplo, rnp->grphi,
-						    "Startedroot");
+			trace_rcu_future_grace_period(rdp->rsp->name,
+						      rnp->gpnum,
+						      rnp->completed,
+						      c, rnp->level,
+						      rnp->grplo, rnp->grphi,
+						      "Startedroot");
 			local_save_flags(flags1);
 			rcu_start_gp(rdp->rsp, flags1); /* Rlses ->lock. */
 		}
@@ -2249,9 +2251,9 @@ static void rcu_nocb_wait_gp(struct rcu_data *rdp)
 	 * Wait for the grace period.  Do so interruptibly to avoid messing
 	 * up the load average.
 	 */
-	trace_rcu_nocb_grace_period(rdp->rsp->name, rnp->gpnum, rnp->completed,
-				    c, rnp->level, rnp->grplo, rnp->grphi,
-				    "StartWait");
+	trace_rcu_future_grace_period(rdp->rsp->name, rnp->gpnum,
+				      rnp->completed, c, rnp->level,
+				      rnp->grplo, rnp->grphi, "StartWait");
 	for (;;) {
 		wait_event_interruptible(
 			rnp->nocb_gp_wq[c & 0x1],
@@ -2259,14 +2261,14 @@ static void rcu_nocb_wait_gp(struct rcu_data *rdp)
 		if (likely(d))
 			break;
 		flush_signals(current);
-		trace_rcu_nocb_grace_period(rdp->rsp->name,
-					    rnp->gpnum, rnp->completed, c,
-					    rnp->level, rnp->grplo, rnp->grphi,
-					    "ResumeWait");
+		trace_rcu_future_grace_period(rdp->rsp->name,
+					      rnp->gpnum, rnp->completed, c,
+					      rnp->level, rnp->grplo,
+					      rnp->grphi, "ResumeWait");
 	}
-	trace_rcu_nocb_grace_period(rdp->rsp->name, rnp->gpnum, rnp->completed,
-				    c, rnp->level, rnp->grplo, rnp->grphi,
-				    "EndWait");
+	trace_rcu_future_grace_period(rdp->rsp->name, rnp->gpnum,
+				      rnp->completed, c, rnp->level,
+				      rnp->grplo, rnp->grphi, "EndWait");
 	smp_mb(); /* Ensure that CB invocation happens after GP end. */
 }
 
-- 
1.8.1.5

