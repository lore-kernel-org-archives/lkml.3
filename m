Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933713Ab3CRVjy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:39:54 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:43533 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933108Ab3CRVhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:37:12 -0400
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
Subject: [PATCH tip/core/rcu 03/15] rcu: Introduce proper blocking to no-CBs kthreads GP waits
Date: Mon, 18 Mar 2013 14:36:38 -0700
Message-Id: <1363642610-21390-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1363642610-21390-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130318213608.GA20296@linux.vnet.ibm.com>
 <1363642610-21390-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031821-5406-0000-0000-0000067F0C77
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

Currently, the no-CBs kthreads do repeated timed waits for grace periods
to elapse.  This is crude and energy inefficient, so this commit allows
no-CBs kthreads to specify exactly which grace period they are waiting
for and also allows them to block for the entire duration until the
desired grace period completes.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c        |   6 ++-
 kernel/rcutree.h        |  12 ++++-
 kernel/rcutree_plugin.h | 129 +++++++++++++++++++++++++++++++++++++++++-------
 3 files changed, 127 insertions(+), 20 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 6ad0716..433f426 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -310,7 +310,7 @@ cpu_needs_another_gp(struct rcu_state *rsp, struct rcu_data *rdp)
 
 	if (rcu_gp_in_progress(rsp))
 		return 0;  /* No, a grace period is already in progress. */
-	if (rcu_nocb_needs_gp(rdp))
+	if (rcu_nocb_needs_gp(rsp))
 		return 1;  /* Yes, a no-CBs CPU needs one. */
 	if (!rdp->nxttail[RCU_NEXT_TAIL])
 		return 0;  /* No, this is a no-CBs (or offline) CPU. */
@@ -1364,6 +1364,7 @@ int rcu_gp_fqs(struct rcu_state *rsp, int fqs_state_in)
 static void rcu_gp_cleanup(struct rcu_state *rsp)
 {
 	unsigned long gp_duration;
+	int nocb = 0;
 	struct rcu_data *rdp;
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
@@ -1394,11 +1395,13 @@ static void rcu_gp_cleanup(struct rcu_state *rsp)
 	rcu_for_each_node_breadth_first(rsp, rnp) {
 		raw_spin_lock_irq(&rnp->lock);
 		rnp->completed = rsp->gpnum;
+		nocb += rcu_nocb_gp_cleanup(rsp, rnp);
 		raw_spin_unlock_irq(&rnp->lock);
 		cond_resched();
 	}
 	rnp = rcu_get_root(rsp);
 	raw_spin_lock_irq(&rnp->lock);
+	rcu_nocb_gp_set(rnp, nocb);
 
 	rsp->completed = rsp->gpnum; /* Declare grace period done. */
 	trace_rcu_grace_period(rsp->name, rsp->completed, "end");
@@ -3084,6 +3087,7 @@ static void __init rcu_init_one(struct rcu_state *rsp,
 			}
 			rnp->level = i;
 			INIT_LIST_HEAD(&rnp->blkd_tasks);
+			rcu_init_one_nocb(rnp);
 		}
 	}
 
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 7af39f4..e51373c 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -196,6 +196,12 @@ struct rcu_node {
 				/* Refused to boost: not sure why, though. */
 				/*  This can happen due to race conditions. */
 #endif /* #ifdef CONFIG_RCU_BOOST */
+#ifdef CONFIG_RCU_NOCB_CPU
+	wait_queue_head_t nocb_gp_wq[2];
+				/* Place for rcu_nocb_kthread() to wait GP. */
+	int n_nocb_gp_requests[2];
+				/* Counts of upcoming no-CB GP requests. */
+#endif /* #ifdef CONFIG_RCU_NOCB_CPU */
 	raw_spinlock_t fqslock ____cacheline_internodealigned_in_smp;
 } ____cacheline_internodealigned_in_smp;
 
@@ -326,7 +332,6 @@ struct rcu_data {
 	int nocb_p_count_lazy;		/*  (approximate). */
 	wait_queue_head_t nocb_wq;	/* For nocb kthreads to sleep on. */
 	struct task_struct *nocb_kthread;
-	bool nocb_needs_gp;
 #endif /* #ifdef CONFIG_RCU_NOCB_CPU */
 
 	int cpu;
@@ -524,7 +529,10 @@ static void print_cpu_stall_info(struct rcu_state *rsp, int cpu);
 static void print_cpu_stall_info_end(void);
 static void zero_cpu_stall_ticks(struct rcu_data *rdp);
 static void increment_cpu_stall_ticks(void);
-static int rcu_nocb_needs_gp(struct rcu_data *rdp);
+static int rcu_nocb_needs_gp(struct rcu_state *rsp);
+static void rcu_nocb_gp_set(struct rcu_node *rnp, int nrq);
+static int rcu_nocb_gp_cleanup(struct rcu_state *rsp, struct rcu_node *rnp);
+static void rcu_init_one_nocb(struct rcu_node *rnp);
 static bool is_nocb_cpu(int cpu);
 static bool __call_rcu_nocb(struct rcu_data *rdp, struct rcu_head *rhp,
 			    bool lazy);
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 3e33aef..90a1914 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -2176,11 +2176,51 @@ static int __init parse_rcu_nocb_poll(char *arg)
 early_param("rcu_nocb_poll", parse_rcu_nocb_poll);
 
 /*
- * Does this CPU needs a grace period due to offloaded callbacks?
+ * Do any no-CBs CPUs need another grace period?
+ *
+ * Interrupts must be disabled.  If the caller does not hold the root
+ * rnp_node structure's ->lock, the results are advisory only.
+ */
+static int rcu_nocb_needs_gp(struct rcu_state *rsp)
+{
+	struct rcu_node *rnp = rcu_get_root(rsp);
+
+	return rnp->n_nocb_gp_requests[(ACCESS_ONCE(rnp->completed) + 1) & 0x1];
+}
+
+/*
+ * Clean up this rcu_node structure's no-CBs state at the end of
+ * a grace period, and also return whether any no-CBs CPU associated
+ * with this rcu_node structure needs another grace period.
+ */
+static int rcu_nocb_gp_cleanup(struct rcu_state *rsp, struct rcu_node *rnp)
+{
+	int c = rnp->completed;
+	int needmore;
+
+	wake_up_all(&rnp->nocb_gp_wq[c & 0x1]);
+	rnp->n_nocb_gp_requests[c & 0x1] = 0;
+	needmore = rnp->n_nocb_gp_requests[(c + 1) & 0x1];
+	return needmore;
+}
+
+/*
+ * Set the root rcu_node structure's ->n_nocb_gp_requests field
+ * based on the sum of those of all rcu_node structures.  This does
+ * double-count the root rcu_node structure's requests, but this
+ * is necessary to handle the possibility of a rcu_nocb_kthread()
+ * having awakened during the time that the rcu_node structures
+ * were being updated for the end of the previous grace period.
  */
-static int rcu_nocb_needs_gp(struct rcu_data *rdp)
+static void rcu_nocb_gp_set(struct rcu_node *rnp, int nrq)
+{
+	rnp->n_nocb_gp_requests[(rnp->completed + 1) & 0x1] += nrq;
+}
+
+static void rcu_init_one_nocb(struct rcu_node *rnp)
 {
-	return rdp->nocb_needs_gp;
+	init_waitqueue_head(&rnp->nocb_gp_wq[0]);
+	init_waitqueue_head(&rnp->nocb_gp_wq[1]);
 }
 
 /* Is the specified CPU a no-CPUs CPU? */
@@ -2289,31 +2329,73 @@ static bool __maybe_unused rcu_nocb_adopt_orphan_cbs(struct rcu_state *rsp,
 static void rcu_nocb_wait_gp(struct rcu_data *rdp)
 {
 	unsigned long c;
+	bool d;
 	unsigned long flags;
-	unsigned long j;
+	unsigned long flags1;
 	struct rcu_node *rnp = rdp->mynode;
+	struct rcu_node *rnp_root = rcu_get_root(rdp->rsp);
 
 	raw_spin_lock_irqsave(&rnp->lock, flags);
 	c = rnp->completed + 2;
-	rdp->nocb_needs_gp = true;
-	raw_spin_unlock_irqrestore(&rnp->lock, flags);
+
+	/* Count our request for a grace period. */
+	rnp->n_nocb_gp_requests[c & 0x1]++;
+
+	if (rnp->gpnum != rnp->completed) {
+
+		/*
+		 * This rcu_node structure believes that a grace period
+		 * is in progress, so we are done.  When this grace
+		 * period ends, our request will be acted upon.
+		 */
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
+
+	} else {
+
+		/*
+		 * Might not be a grace period, check root rcu_node
+		 * structure to see if we must start one.
+		 */
+		if (rnp != rnp_root)
+			raw_spin_lock(&rnp_root->lock); /* irqs disabled. */
+		if (rnp_root->gpnum != rnp_root->completed) {
+			raw_spin_unlock(&rnp_root->lock); /* irqs disabled. */
+		} else {
+
+			/*
+			 * No grace period, so we need to start one.
+			 * The good news is that we can wait for exactly
+			 * one grace period instead of part of the current
+			 * grace period and all of the next grace period.
+			 * Adjust counters accordingly and start the
+			 * needed grace period.
+			 */
+			rnp->n_nocb_gp_requests[c & 0x1]--;
+			c = rnp_root->completed + 1;
+			rnp->n_nocb_gp_requests[c & 0x1]++;
+			rnp_root->n_nocb_gp_requests[c & 0x1]++;
+			local_save_flags(flags1);
+			rcu_start_gp(rdp->rsp, flags1); /* Rlses ->lock. */
+		}
+
+		/* Clean up locking and irq state. */
+		if (rnp != rnp_root)
+			raw_spin_unlock_irqrestore(&rnp->lock, flags);
+		else
+			local_irq_restore(flags);
+	}
 
 	/*
 	 * Wait for the grace period.  Do so interruptibly to avoid messing
 	 * up the load average.
 	 */
 	for (;;) {
-		j = jiffies;
-		schedule_timeout_interruptible(2);
-		raw_spin_lock_irqsave(&rnp->lock, flags);
-		if (ULONG_CMP_GE(rnp->completed, c)) {
-			rdp->nocb_needs_gp = false;
-			raw_spin_unlock_irqrestore(&rnp->lock, flags);
+		wait_event_interruptible(
+			rnp->nocb_gp_wq[c & 0x1],
+			(d = ULONG_CMP_GE(ACCESS_ONCE(rnp->completed), c)));
+		if (likely(d))
 			break;
-		}
-		if (j == jiffies)
-			flush_signals(current);
-		raw_spin_unlock_irqrestore(&rnp->lock, flags);
+		flush_signals(current);
 	}
 	smp_mb(); /* Ensure that CB invocation happens after GP end. */
 }
@@ -2416,11 +2498,24 @@ static bool init_nocb_callback_list(struct rcu_data *rdp)
 
 #else /* #ifdef CONFIG_RCU_NOCB_CPU */
 
-static int rcu_nocb_needs_gp(struct rcu_data *rdp)
+static int rcu_nocb_needs_gp(struct rcu_state *rsp)
+{
+	return 0;
+}
+
+static int rcu_nocb_gp_cleanup(struct rcu_state *rsp, struct rcu_node *rnp)
 {
 	return 0;
 }
 
+static void rcu_nocb_gp_set(struct rcu_node *rnp, int nrq)
+{
+}
+
+static void rcu_init_one_nocb(struct rcu_node *rnp)
+{
+}
+
 static bool is_nocb_cpu(int cpu)
 {
 	return false;
-- 
1.8.1.5

