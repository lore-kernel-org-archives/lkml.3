Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933628Ab3CRVhh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:37:37 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:45180 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933182Ab3CRVhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:37:34 -0400
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
Subject: [PATCH tip/core/rcu 05/15] rcu: Add event tracing for no-CBs CPUs' grace periods
Date: Mon, 18 Mar 2013 14:36:40 -0700
Message-Id: <1363642610-21390-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1363642610-21390-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130318213608.GA20296@linux.vnet.ibm.com>
 <1363642610-21390-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031821-3620-0000-0000-000001AC939A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/trace/events/rcu.h | 55 ++++++++++++++++++++++++++++++++++++++++++++++
 kernel/rcutree_plugin.h    | 30 +++++++++++++++++++++++++
 2 files changed, 85 insertions(+)

diff --git a/include/trace/events/rcu.h b/include/trace/events/rcu.h
index 1918e83..cdfed6d 100644
--- a/include/trace/events/rcu.h
+++ b/include/trace/events/rcu.h
@@ -72,6 +72,58 @@ TRACE_EVENT(rcu_grace_period,
 );
 
 /*
+ * Tracepoint for no-callbacks grace-period events.  The caller should
+ * pull the data from the rcu_node structure, other than rcuname, which
+ * comes from the rcu_state structure, and event, which is one of the
+ * following:
+ *
+ * "Startleaf": Request a nocb grace period based on leaf-node data.
+ * "Startedleaf": Leaf-node start proved sufficient.
+ * "Startedleafroot": Leaf-node start proved sufficient after checking root.
+ * "Startedroot": Requested a nocb grace period based on root-node data.
+ * "StartWait": Start waiting for the requested grace period.
+ * "ResumeWait": Resume waiting after signal.
+ * "EndWait": Complete wait.
+ * "Cleanup": Clean up rcu_node structure after previous GP.
+ * "CleanupMore": Clean up, and another no-CB GP is needed.
+ */
+TRACE_EVENT(rcu_nocb_grace_period,
+
+	TP_PROTO(char *rcuname, unsigned long gpnum, unsigned long completed,
+		 unsigned long c, u8 level, int grplo, int grphi,
+		 char *gpevent),
+
+	TP_ARGS(rcuname, gpnum, completed, c, level, grplo, grphi, gpevent),
+
+	TP_STRUCT__entry(
+		__field(char *, rcuname)
+		__field(unsigned long, gpnum)
+		__field(unsigned long, completed)
+		__field(unsigned long, c)
+		__field(u8, level)
+		__field(int, grplo)
+		__field(int, grphi)
+		__field(char *, gpevent)
+	),
+
+	TP_fast_assign(
+		__entry->rcuname = rcuname;
+		__entry->gpnum = gpnum;
+		__entry->completed = completed;
+		__entry->c = c;
+		__entry->level = level;
+		__entry->grplo = grplo;
+		__entry->grphi = grphi;
+		__entry->gpevent = gpevent;
+	),
+
+	TP_printk("%s %lu %lu %lu %u %d %d %s",
+		  __entry->rcuname, __entry->gpnum, __entry->completed,
+		  __entry->c, __entry->level, __entry->grplo, __entry->grphi,
+		  __entry->gpevent)
+);
+
+/*
  * Tracepoint for grace-period-initialization events.  These are
  * distinguished by the type of RCU, the new grace-period number, the
  * rcu_node structure level, the starting and ending CPU covered by the
@@ -601,6 +653,9 @@ TRACE_EVENT(rcu_barrier,
 #define trace_rcu_grace_period(rcuname, gpnum, gpevent) do { } while (0)
 #define trace_rcu_grace_period_init(rcuname, gpnum, level, grplo, grphi, \
 				    qsmask) do { } while (0)
+#define trace_rcu_nocb_grace_period(rcuname, gpnum, completed, c, \
+				    level, grplo, grphi, event) \
+				    do { } while (0)
 #define trace_rcu_preempt_task(rcuname, pid, gpnum) do { } while (0)
 #define trace_rcu_unlock_preempted_task(rcuname, gpnum, pid) do { } while (0)
 #define trace_rcu_quiescent_state_report(rcuname, gpnum, mask, qsmask, level, \
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 7225a5a..e32236e 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -2201,6 +2201,9 @@ static int rcu_nocb_gp_cleanup(struct rcu_state *rsp, struct rcu_node *rnp)
 	wake_up_all(&rnp->nocb_gp_wq[c & 0x1]);
 	rnp->n_nocb_gp_requests[c & 0x1] = 0;
 	needmore = rnp->n_nocb_gp_requests[(c + 1) & 0x1];
+	trace_rcu_nocb_grace_period(rsp->name, rnp->gpnum, rnp->completed,
+				    c, rnp->level, rnp->grplo, rnp->grphi,
+				    needmore ? "CleanupMore" : "Cleanup");
 	return needmore;
 }
 
@@ -2347,6 +2350,9 @@ static void rcu_nocb_wait_gp(struct rcu_data *rdp)
 
 	/* Count our request for a grace period. */
 	rnp->n_nocb_gp_requests[c & 0x1]++;
+	trace_rcu_nocb_grace_period(rdp->rsp->name, rnp->gpnum, rnp->completed,
+				    c, rnp->level, rnp->grplo, rnp->grphi,
+				    "Startleaf");
 
 	if (rnp->gpnum != rnp->completed) {
 
@@ -2355,6 +2361,10 @@ static void rcu_nocb_wait_gp(struct rcu_data *rdp)
 		 * is in progress, so we are done.  When this grace
 		 * period ends, our request will be acted upon.
 		 */
+		trace_rcu_nocb_grace_period(rdp->rsp->name,
+					    rnp->gpnum, rnp->completed, c,
+					    rnp->level, rnp->grplo, rnp->grphi,
+					    "Startedleaf");
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 
 	} else {
@@ -2366,6 +2376,11 @@ static void rcu_nocb_wait_gp(struct rcu_data *rdp)
 		if (rnp != rnp_root)
 			raw_spin_lock(&rnp_root->lock); /* irqs disabled. */
 		if (rnp_root->gpnum != rnp_root->completed) {
+			trace_rcu_nocb_grace_period(rdp->rsp->name,
+						    rnp->gpnum, rnp->completed,
+						    c, rnp->level,
+						    rnp->grplo, rnp->grphi,
+						    "Startedleafroot");
 			raw_spin_unlock(&rnp_root->lock); /* irqs disabled. */
 		} else {
 
@@ -2381,6 +2396,11 @@ static void rcu_nocb_wait_gp(struct rcu_data *rdp)
 			c = rnp_root->completed + 1;
 			rnp->n_nocb_gp_requests[c & 0x1]++;
 			rnp_root->n_nocb_gp_requests[c & 0x1]++;
+			trace_rcu_nocb_grace_period(rdp->rsp->name,
+						    rnp->gpnum, rnp->completed,
+						    c, rnp->level,
+						    rnp->grplo, rnp->grphi,
+						    "Startedroot");
 			local_save_flags(flags1);
 			rcu_start_gp(rdp->rsp, flags1); /* Rlses ->lock. */
 		}
@@ -2396,6 +2416,9 @@ static void rcu_nocb_wait_gp(struct rcu_data *rdp)
 	 * Wait for the grace period.  Do so interruptibly to avoid messing
 	 * up the load average.
 	 */
+	trace_rcu_nocb_grace_period(rdp->rsp->name, rnp->gpnum, rnp->completed,
+				    c, rnp->level, rnp->grplo, rnp->grphi,
+				    "StartWait");
 	for (;;) {
 		wait_event_interruptible(
 			rnp->nocb_gp_wq[c & 0x1],
@@ -2403,7 +2426,14 @@ static void rcu_nocb_wait_gp(struct rcu_data *rdp)
 		if (likely(d))
 			break;
 		flush_signals(current);
+		trace_rcu_nocb_grace_period(rdp->rsp->name,
+					    rnp->gpnum, rnp->completed, c,
+					    rnp->level, rnp->grplo, rnp->grphi,
+					    "ResumeWait");
 	}
+	trace_rcu_nocb_grace_period(rdp->rsp->name, rnp->gpnum, rnp->completed,
+				    c, rnp->level, rnp->grplo, rnp->grphi,
+				    "EndWait");
 	smp_mb(); /* Ensure that CB invocation happens after GP end. */
 }
 
-- 
1.8.1.5

