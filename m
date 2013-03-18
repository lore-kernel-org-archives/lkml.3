Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933571Ab3CRVhO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:37:14 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:45037 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933155Ab3CRVhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:37:11 -0400
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
Subject: [PATCH tip/core/rcu 14/15] rcu: Abstract rcu_start_future_gp() from rcu_nocb_wait_gp()
Date: Mon, 18 Mar 2013 14:36:49 -0700
Message-Id: <1363642610-21390-14-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1363642610-21390-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130318213608.GA20296@linux.vnet.ibm.com>
 <1363642610-21390-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031821-3620-0000-0000-000001AC9362
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

CPUs going idle will need to record the need for a future grace
period, but won't actually need to block waiting on it.  This commit
therefore splits rcu_start_future_gp(), which does the recording, from
rcu_nocb_wait_gp(), which now invokes rcu_start_future_gp() to do the
recording, after which rcu_nocb_wait_gp() does the waiting.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c        | 123 ++++++++++++++++++++++++++++++++++++++++++++++--
 kernel/rcutree.h        |   2 +-
 kernel/rcutree_plugin.h | 104 ++++------------------------------------
 3 files changed, 130 insertions(+), 99 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 0d53295..f4b23f1 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -224,6 +224,7 @@ static ulong jiffies_till_next_fqs = RCU_JIFFIES_TILL_FORCE_QS;
 module_param(jiffies_till_first_fqs, ulong, 0644);
 module_param(jiffies_till_next_fqs, ulong, 0644);
 
+static void rcu_start_gp(struct rcu_state *rsp);
 static void force_qs_rnp(struct rcu_state *rsp, int (*f)(struct rcu_data *));
 static void force_quiescent_state(struct rcu_state *rsp);
 static int rcu_pending(int cpu);
@@ -1075,6 +1076,120 @@ static unsigned long rcu_cbs_completed(struct rcu_state *rsp,
 }
 
 /*
+ * Trace-event helper function for rcu_start_future_gp() and
+ * rcu_nocb_wait_gp().
+ */
+static void trace_rcu_future_gp(struct rcu_node *rnp, struct rcu_data *rdp,
+				unsigned long c, char *s)
+{
+	trace_rcu_future_grace_period(rdp->rsp->name, rnp->gpnum,
+				      rnp->completed, c, rnp->level,
+				      rnp->grplo, rnp->grphi, s);
+}
+
+/*
+ * Start some future grace period, as needed to handle newly arrived
+ * callbacks.  The required future grace periods are recorded in each
+ * rcu_node structure's ->need_future_gp field.
+ *
+ * The caller must hold the specified rcu_node structure's ->lock.
+ */
+static unsigned long __maybe_unused
+rcu_start_future_gp(struct rcu_node *rnp, struct rcu_data *rdp)
+{
+	unsigned long c;
+	int i;
+	struct rcu_node *rnp_root = rcu_get_root(rdp->rsp);
+
+	/*
+	 * Pick up grace-period number for new callbacks.  If this
+	 * grace period is already marked as needed, return to the caller.
+	 */
+	c = rcu_cbs_completed(rdp->rsp, rnp);
+	trace_rcu_future_gp(rnp, rdp, c, "Startleaf");
+	if (rnp->need_future_gp[c & 0x1]) {
+		trace_rcu_future_gp(rnp, rdp, c, "Prestartleaf");
+		return c;
+	}
+
+	/*
+	 * If either this rcu_node structure or the root rcu_node structure
+	 * believe that a grace period is in progress, then we must wait
+	 * for the one following, which is in "c".  Because our request
+	 * will be noticed at the end of the current grace period, we don't
+	 * need to explicitly start one.
+	 */
+	if (rnp->gpnum != rnp->completed ||
+	    ACCESS_ONCE(rnp->gpnum) != ACCESS_ONCE(rnp->completed)) {
+		rnp->need_future_gp[c & 0x1]++;
+		trace_rcu_future_gp(rnp, rdp, c, "Startedleaf");
+		return c;
+	}
+
+	/*
+	 * There might be no grace period in progress.  If we don't already
+	 * hold it, acquire the root rcu_node structure's lock in order to
+	 * start one (if needed).
+	 */
+	if (rnp != rnp_root)
+		raw_spin_lock(&rnp_root->lock);
+
+	/*
+	 * Get a new grace-period number.  If there really is no grace
+	 * period in progress, it will be smaller than the one we obtained
+	 * earlier.  Adjust callbacks as needed.  Note that even no-CBs
+	 * CPUs have a ->nxtcompleted[] array, so no no-CBs checks needed.
+	 */
+	c = rcu_cbs_completed(rdp->rsp, rnp_root);
+	for (i = RCU_DONE_TAIL; i < RCU_NEXT_TAIL; i++)
+		if (ULONG_CMP_LT(c, rdp->nxtcompleted[i]))
+			rdp->nxtcompleted[i] = c;
+
+	/*
+	 * If the needed for the required grace period is already
+	 * recorded, trace and leave.
+	 */
+	if (rnp_root->need_future_gp[c & 0x1]) {
+		trace_rcu_future_gp(rnp, rdp, c, "Prestartedroot");
+		goto unlock_out;
+	}
+
+	/* Record the need for the future grace period. */
+	rnp_root->need_future_gp[c & 0x1]++;
+
+	/* If a grace period is not already in progress, start one. */
+	if (rnp_root->gpnum != rnp_root->completed) {
+		trace_rcu_future_gp(rnp, rdp, c, "Startedleafroot");
+	} else {
+		trace_rcu_future_gp(rnp, rdp, c, "Startedroot");
+		rcu_start_gp(rdp->rsp);
+	}
+unlock_out:
+	if (rnp != rnp_root)
+		raw_spin_unlock(&rnp_root->lock);
+	return c;
+}
+
+/*
+ * Clean up any old requests for the just-ended grace period.  Also return
+ * whether any additional grace periods have been requested.  Also invoke
+ * rcu_nocb_gp_cleanup() in order to wake up any no-callbacks kthreads
+ * waiting for this grace period to complete.
+ */
+static int rcu_future_gp_cleanup(struct rcu_state *rsp, struct rcu_node *rnp)
+{
+	int c = rnp->completed;
+	int needmore;
+	struct rcu_data *rdp = this_cpu_ptr(rsp->rda);
+
+	rcu_nocb_gp_cleanup(rsp, rnp);
+	rnp->need_future_gp[c & 0x1] = 0;
+	needmore = rnp->need_future_gp[(c + 1) & 0x1];
+	trace_rcu_future_gp(rnp, rdp, c, needmore ? "CleanupMore" : "Cleanup");
+	return needmore;
+}
+
+/*
  * If there is room, assign a ->completed number to any callbacks on
  * this CPU that have not already been assigned.  Also accelerate any
  * callbacks that were previously assigned a ->completed number that has
@@ -1312,9 +1427,9 @@ static int rcu_gp_init(struct rcu_state *rsp)
 		rdp = this_cpu_ptr(rsp->rda);
 		rcu_preempt_check_blocked_tasks(rnp);
 		rnp->qsmask = rnp->qsmaskinit;
-		rnp->gpnum = rsp->gpnum;
+		ACCESS_ONCE(rnp->gpnum) = rsp->gpnum;
 		WARN_ON_ONCE(rnp->completed != rsp->completed);
-		rnp->completed = rsp->completed;
+		ACCESS_ONCE(rnp->completed) = rsp->completed;
 		if (rnp == rdp->mynode)
 			rcu_start_gp_per_cpu(rsp, rnp, rdp);
 		rcu_preempt_boost_start_gp(rnp);
@@ -1395,11 +1510,11 @@ static void rcu_gp_cleanup(struct rcu_state *rsp)
 	 */
 	rcu_for_each_node_breadth_first(rsp, rnp) {
 		raw_spin_lock_irq(&rnp->lock);
-		rnp->completed = rsp->gpnum;
+		ACCESS_ONCE(rnp->completed) = rsp->gpnum;
 		rdp = this_cpu_ptr(rsp->rda);
 		if (rnp == rdp->mynode)
 			__rcu_process_gp_end(rsp, rnp, rdp);
-		nocb += rcu_nocb_gp_cleanup(rsp, rnp);
+		nocb += rcu_future_gp_cleanup(rsp, rnp);
 		raw_spin_unlock_irq(&rnp->lock);
 		cond_resched();
 	}
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 034b524..c11b46c33 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -526,7 +526,7 @@ static void zero_cpu_stall_ticks(struct rcu_data *rdp);
 static void increment_cpu_stall_ticks(void);
 static int rcu_nocb_needs_gp(struct rcu_state *rsp);
 static void rcu_nocb_gp_set(struct rcu_node *rnp, int nrq);
-static int rcu_nocb_gp_cleanup(struct rcu_state *rsp, struct rcu_node *rnp);
+static void rcu_nocb_gp_cleanup(struct rcu_state *rsp, struct rcu_node *rnp);
 static void rcu_init_one_nocb(struct rcu_node *rnp);
 static bool is_nocb_cpu(int cpu);
 static bool __call_rcu_nocb(struct rcu_data *rdp, struct rcu_head *rhp,
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index f3f0020..723af5f 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -2022,22 +2022,12 @@ static int rcu_nocb_needs_gp(struct rcu_state *rsp)
 }
 
 /*
- * Clean up this rcu_node structure's no-CBs state at the end of
- * a grace period, and also return whether any no-CBs CPU associated
- * with this rcu_node structure needs another grace period.
+ * Wake up any no-CBs CPUs' kthreads that were waiting on the just-ended
+ * grace period.
  */
-static int rcu_nocb_gp_cleanup(struct rcu_state *rsp, struct rcu_node *rnp)
+static void rcu_nocb_gp_cleanup(struct rcu_state *rsp, struct rcu_node *rnp)
 {
-	int c = rnp->completed;
-	int needmore;
-
-	wake_up_all(&rnp->nocb_gp_wq[c & 0x1]);
-	rnp->need_future_gp[c & 0x1] = 0;
-	needmore = rnp->need_future_gp[(c + 1) & 0x1];
-	trace_rcu_future_grace_period(rsp->name, rnp->gpnum, rnp->completed,
-				      c, rnp->level, rnp->grplo, rnp->grphi,
-				      needmore ? "CleanupMore" : "Cleanup");
-	return needmore;
+	wake_up_all(&rnp->nocb_gp_wq[rnp->completed & 0x1]);
 }
 
 /*
@@ -2175,84 +2165,16 @@ static void rcu_nocb_wait_gp(struct rcu_data *rdp)
 	bool d;
 	unsigned long flags;
 	struct rcu_node *rnp = rdp->mynode;
-	struct rcu_node *rnp_root = rcu_get_root(rdp->rsp);
 
 	raw_spin_lock_irqsave(&rnp->lock, flags);
-	c = rnp->completed + 2;
-
-	/* Count our request for a grace period. */
-	rnp->need_future_gp[c & 0x1]++;
-	trace_rcu_future_grace_period(rdp->rsp->name, rnp->gpnum,
-				      rnp->completed, c, rnp->level,
-				      rnp->grplo, rnp->grphi, "Startleaf");
-
-	if (rnp->gpnum != rnp->completed) {
-
-		/*
-		 * This rcu_node structure believes that a grace period
-		 * is in progress, so we are done.  When this grace
-		 * period ends, our request will be acted upon.
-		 */
-		trace_rcu_future_grace_period(rdp->rsp->name, rnp->gpnum,
-					      rnp->completed, c, rnp->level,
-					      rnp->grplo, rnp->grphi,
-					      "Startedleaf");
-		raw_spin_unlock_irqrestore(&rnp->lock, flags);
-
-	} else {
-
-		/*
-		 * Might not be a grace period, check root rcu_node
-		 * structure to see if we must start one.
-		 */
-		if (rnp != rnp_root)
-			raw_spin_lock(&rnp_root->lock); /* irqs disabled. */
-		if (rnp_root->gpnum != rnp_root->completed) {
-			trace_rcu_future_grace_period(rdp->rsp->name,
-						      rnp->gpnum,
-						      rnp->completed,
-						      c, rnp->level,
-						      rnp->grplo, rnp->grphi,
-						      "Startedleafroot");
-			raw_spin_unlock(&rnp_root->lock); /* irqs disabled. */
-		} else {
-
-			/*
-			 * No grace period, so we need to start one.
-			 * The good news is that we can wait for exactly
-			 * one grace period instead of part of the current
-			 * grace period and all of the next grace period.
-			 * Adjust counters accordingly and start the
-			 * needed grace period.
-			 */
-			rnp->need_future_gp[c & 0x1]--;
-			c = rnp_root->completed + 1;
-			rnp->need_future_gp[c & 0x1]++;
-			rnp_root->need_future_gp[c & 0x1]++;
-			trace_rcu_future_grace_period(rdp->rsp->name,
-						      rnp->gpnum,
-						      rnp->completed,
-						      c, rnp->level,
-						      rnp->grplo, rnp->grphi,
-						      "Startedroot");
-			rcu_start_gp(rdp->rsp);
-			raw_spin_unlock(&rnp->lock);
-		}
-
-		/* Clean up locking and irq state. */
-		if (rnp != rnp_root)
-			raw_spin_unlock_irqrestore(&rnp->lock, flags);
-		else
-			local_irq_restore(flags);
-	}
+	c = rcu_start_future_gp(rnp, rdp);
+	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 
 	/*
 	 * Wait for the grace period.  Do so interruptibly to avoid messing
 	 * up the load average.
 	 */
-	trace_rcu_future_grace_period(rdp->rsp->name, rnp->gpnum,
-				      rnp->completed, c, rnp->level,
-				      rnp->grplo, rnp->grphi, "StartWait");
+	trace_rcu_future_gp(rnp, rdp, c, "StartWait");
 	for (;;) {
 		wait_event_interruptible(
 			rnp->nocb_gp_wq[c & 0x1],
@@ -2260,14 +2182,9 @@ static void rcu_nocb_wait_gp(struct rcu_data *rdp)
 		if (likely(d))
 			break;
 		flush_signals(current);
-		trace_rcu_future_grace_period(rdp->rsp->name,
-					      rnp->gpnum, rnp->completed, c,
-					      rnp->level, rnp->grplo,
-					      rnp->grphi, "ResumeWait");
+		trace_rcu_future_gp(rnp, rdp, c, "ResumeWait");
 	}
-	trace_rcu_future_grace_period(rdp->rsp->name, rnp->gpnum,
-				      rnp->completed, c, rnp->level,
-				      rnp->grplo, rnp->grphi, "EndWait");
+	trace_rcu_future_gp(rnp, rdp, c, "EndWait");
 	smp_mb(); /* Ensure that CB invocation happens after GP end. */
 }
 
@@ -2375,9 +2292,8 @@ static int rcu_nocb_needs_gp(struct rcu_state *rsp)
 	return 0;
 }
 
-static int rcu_nocb_gp_cleanup(struct rcu_state *rsp, struct rcu_node *rnp)
+static void rcu_nocb_gp_cleanup(struct rcu_state *rsp, struct rcu_node *rnp)
 {
-	return 0;
 }
 
 static void rcu_nocb_gp_set(struct rcu_node *rnp, int nrq)
-- 
1.8.1.5

