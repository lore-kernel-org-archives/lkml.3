Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbaGNKHO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 06:07:14 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:40970 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637AbaGNKGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 06:06:55 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu, linux-rt-users@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 2/2] rcu: Create rcuo kthreads only for onlined CPUs
Date: Mon, 14 Jul 2014 03:06:44 -0700
Message-Id: <1405332404-10094-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1405332404-10094-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140714100604.GA9905@linux.vnet.ibm.com>
 <1405332404-10094-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14071410-9332-0000-0000-000001602735
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

RCU currently uses for_each_possible_cpu() to spawn rcuo kthreads,
which can result in more rcuo kthreads than one would expect, for
example, derRichard reported 64 CPUs worth of rcuo kthreads on an
8-CPU image.  This commit therefore creates rcuo kthreads only for
those CPUs that actually come online.

Reported-by: derRichard
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree.c        |  4 ++-
 kernel/rcu/tree.h        |  4 ++-
 kernel/rcu/tree_plugin.h | 93 ++++++++++++++++++++++++++++++++++++++++++------
 3 files changed, 88 insertions(+), 13 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index eecdbe20a08e..a1abaa8abd49 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -3444,6 +3444,7 @@ static int rcu_cpu_notify(struct notifier_block *self,
 	case CPU_UP_PREPARE_FROZEN:
 		rcu_prepare_cpu(cpu);
 		rcu_prepare_kthreads(cpu);
+		rcu_spawn_all_nocb_kthreads(cpu);
 		break;
 	case CPU_ONLINE:
 	case CPU_DOWN_FAILED:
@@ -3508,8 +3509,8 @@ static int __init rcu_spawn_gp_kthread(void)
 		raw_spin_lock_irqsave(&rnp->lock, flags);
 		rsp->gp_kthread = t;
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
-		rcu_spawn_nocb_kthreads(rsp);
 	}
+	rcu_spawn_nocb_kthreads();
 	rcu_spawn_boost_kthreads();
 	return 0;
 }
@@ -3643,6 +3644,7 @@ static void __init rcu_init_one(struct rcu_state *rsp,
 		rcu_boot_init_percpu_data(i, rsp);
 	}
 	list_add(&rsp->flavors, &rcu_struct_flavors);
+	rcu_organize_nocb_kthreads(rsp);
 }
 
 /*
diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index bd7b63da9a8c..f703ea8b7836 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -593,7 +593,9 @@ static bool rcu_nocb_adopt_orphan_cbs(struct rcu_state *rsp,
 static bool rcu_nocb_need_deferred_wakeup(struct rcu_data *rdp);
 static void do_nocb_deferred_wakeup(struct rcu_data *rdp);
 static void rcu_boot_init_nocb_percpu_data(struct rcu_data *rdp);
-static void rcu_spawn_nocb_kthreads(struct rcu_state *rsp);
+static void rcu_spawn_all_nocb_kthreads(int cpu);
+static void __init rcu_spawn_nocb_kthreads(void);
+static void __init rcu_organize_nocb_kthreads(struct rcu_state *rsp);
 static void __maybe_unused rcu_kick_nohz_cpu(int cpu);
 static bool init_nocb_callback_list(struct rcu_data *rdp);
 static void rcu_sysidle_enter(struct rcu_dynticks *rdtp, int irq);
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index f5314cc20750..cedb020f1f90 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2455,15 +2455,85 @@ static void __init rcu_boot_init_nocb_percpu_data(struct rcu_data *rdp)
 	rdp->nocb_follower_tail = &rdp->nocb_follower_head;
 }
 
+/*
+ * If the specified CPU is a no-CBs CPU that does not already have its
+ * rcuo kthread for the specified RCU flavor, spawn it.  If the CPUs are
+ * brought online out of order, this can require require re-organizing
+ * the leader-follower relationships.
+ */
+static void rcu_spawn_one_nocb_kthread(struct rcu_state *rsp, int cpu)
+{
+	struct rcu_data *rdp;
+	struct rcu_data *rdp_last;
+	struct rcu_data *rdp_old_leader;
+	struct rcu_data *rdp_spawn = per_cpu_ptr(rsp->rda, cpu);
+	struct task_struct *t;
+
+	/*
+	 * If this isn't a no-CBs CPU or if it already has an rcuo kthread,
+	 * then nothing to do.
+	 */
+	if (!rcu_is_nocb_cpu(cpu) || rdp_spawn->nocb_kthread)
+		return;
+
+	/* If we didn't spawn the leader first, reorganize! */
+	rdp_old_leader = rdp_spawn->nocb_leader;
+	if (rdp_old_leader != rdp_spawn && !rdp_old_leader->nocb_kthread) {
+		rdp_last = NULL;
+		rdp = rdp_old_leader;
+		do {
+			rdp->nocb_leader = rdp_spawn;
+			if (rdp_last && rdp != rdp_spawn)
+				rdp_last->nocb_next_follower = rdp;
+			rdp_last = rdp;
+			rdp = rdp->nocb_next_follower;
+			rdp_last->nocb_next_follower = NULL;
+		} while (rdp);
+		rdp_spawn->nocb_next_follower = rdp_old_leader;
+	}
+
+	/* Spawn the kthread for this CPU and RCU flavor. */
+	t = kthread_run(rcu_nocb_kthread, rdp_spawn,
+			"rcuo%c/%d", rsp->abbr, cpu);
+	BUG_ON(IS_ERR(t));
+	ACCESS_ONCE(rdp_spawn->nocb_kthread) = t;
+}
+
+/*
+ * If the specified CPU is a no-CBs CPU that does not already have its
+ * rcuo kthreads, spawn them.
+ */
+static void rcu_spawn_all_nocb_kthreads(int cpu)
+{
+	struct rcu_state *rsp;
+
+	if (rcu_scheduler_fully_active)
+		for_each_rcu_flavor(rsp)
+			rcu_spawn_one_nocb_kthread(rsp, cpu);
+}
+
+/*
+ * Once the scheduler is running, spawn rcuo kthreads for all online
+ * no-CBs CPUs.  This assumes that the early_initcall()s happen before
+ * non-boot CPUs come online -- if this changes, we will need to add
+ * some mutual exclusion.
+ */
+static void __init rcu_spawn_nocb_kthreads(void)
+{
+	int cpu;
+
+	for_each_online_cpu(cpu)
+		rcu_spawn_all_nocb_kthreads(cpu);
+}
+
 /* How many follower CPU IDs per leader?  Default of -1 for sqrt(nr_cpu_ids). */
 static int rcu_nocb_leader_stride = -1;
 module_param(rcu_nocb_leader_stride, int, 0444);
 
 /*
- * Create a kthread for each RCU flavor for each no-CBs CPU.
- * Also initialize leader-follower relationships.
+ * Initialize leader-follower relationships for all no-CBs CPU.
  */
-static void __init rcu_spawn_nocb_kthreads(struct rcu_state *rsp)
+static void __init rcu_organize_nocb_kthreads(struct rcu_state *rsp)
 {
 	int cpu;
 	int ls = rcu_nocb_leader_stride;
@@ -2471,7 +2541,6 @@ static void __init rcu_spawn_nocb_kthreads(struct rcu_state *rsp)
 	struct rcu_data *rdp;
 	struct rcu_data *rdp_leader = NULL;  /* Suppress misguided gcc warn. */
 	struct rcu_data *rdp_prev = NULL;
-	struct task_struct *t;
 
 	if (rcu_nocb_mask == NULL)
 		return;
@@ -2500,12 +2569,6 @@ static void __init rcu_spawn_nocb_kthreads(struct rcu_state *rsp)
 			rdp_prev->nocb_next_follower = rdp;
 		}
 		rdp_prev = rdp;
-
-		/* Spawn the kthread for this CPU. */
-		t = kthread_run(rcu_nocb_kthread, rdp,
-				"rcuo%c/%d", rsp->abbr, cpu);
-		BUG_ON(IS_ERR(t));
-		ACCESS_ONCE(rdp->nocb_kthread) = t;
 	}
 }
 
@@ -2559,7 +2622,15 @@ static void do_nocb_deferred_wakeup(struct rcu_data *rdp)
 {
 }
 
-static void __init rcu_spawn_nocb_kthreads(struct rcu_state *rsp)
+static void rcu_spawn_all_nocb_kthreads(int cpu)
+{
+}
+
+static void __init rcu_spawn_nocb_kthreads(void)
+{
+}
+
+static void __init rcu_organize_nocb_kthreads(struct rcu_state *rsp)
 {
 }
 
-- 
1.8.1.5

