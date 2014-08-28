Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbaH1Sir (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:38:47 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:40384 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753672AbaH1Sig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:38:36 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 08/14] rcu: Create rcuo kthreads only for onlined CPUs
Date: Thu, 28 Aug 2014 11:38:11 -0700
Message-Id: <1409251097-26734-8-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1409251097-26734-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140828183754.GA25488@linux.vnet.ibm.com>
 <1409251097-26734-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082818-7164-0000-0000-0000042C1E00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

RCU currently uses for_each_possible_cpu() to spawn rcuo kthreads,
which can result in more rcuo kthreads than one would expect, for
example, derRichard reported 64 CPUs worth of rcuo kthreads on an
8-CPU image.  This commit therefore creates rcuo kthreads only for
those CPUs that actually come online.

This was reported by derRichard on the OFTC IRC network.

Reported-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/rcu/tree.c        |  3 +-
 kernel/rcu/tree.h        |  6 +++-
 kernel/rcu/tree_plugin.h | 90 ++++++++++++++++++++++++++++++++++++++++++------
 3 files changed, 86 insertions(+), 13 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 9be47f43903b..b49c8433f834 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -3442,6 +3442,7 @@ static int rcu_cpu_notify(struct notifier_block *self,
 	case CPU_UP_PREPARE_FROZEN:
 		rcu_prepare_cpu(cpu);
 		rcu_prepare_kthreads(cpu);
+		rcu_spawn_all_nocb_kthreads(cpu);
 		break;
 	case CPU_ONLINE:
 	case CPU_DOWN_FAILED:
@@ -3506,8 +3507,8 @@ static int __init rcu_spawn_gp_kthread(void)
 		raw_spin_lock_irqsave(&rnp->lock, flags);
 		rsp->gp_kthread = t;
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
-		rcu_spawn_nocb_kthreads(rsp);
 	}
+	rcu_spawn_nocb_kthreads();
 	rcu_spawn_boost_kthreads();
 	return 0;
 }
diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index bd7b63da9a8c..6ca5c386d5a0 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -593,7 +593,11 @@ static bool rcu_nocb_adopt_orphan_cbs(struct rcu_state *rsp,
 static bool rcu_nocb_need_deferred_wakeup(struct rcu_data *rdp);
 static void do_nocb_deferred_wakeup(struct rcu_data *rdp);
 static void rcu_boot_init_nocb_percpu_data(struct rcu_data *rdp);
-static void rcu_spawn_nocb_kthreads(struct rcu_state *rsp);
+static void rcu_spawn_all_nocb_kthreads(int cpu);
+static void __init rcu_spawn_nocb_kthreads(void);
+#ifdef CONFIG_RCU_NOCB_CPU
+static void __init rcu_organize_nocb_kthreads(struct rcu_state *rsp);
+#endif /* #ifdef CONFIG_RCU_NOCB_CPU */
 static void __maybe_unused rcu_kick_nohz_cpu(int cpu);
 static bool init_nocb_callback_list(struct rcu_data *rdp);
 static void rcu_sysidle_enter(struct rcu_dynticks *rdtp, int irq);
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index a9971ac64e00..d7a9e252084f 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2479,6 +2479,7 @@ void __init rcu_init_nohz(void)
 				     rdp->nxttail[RCU_NEXT_TAIL] != NULL);
 			init_nocb_callback_list(rdp);
 		}
+		rcu_organize_nocb_kthreads(rsp);
 	}
 }
 
@@ -2490,15 +2491,85 @@ static void __init rcu_boot_init_nocb_percpu_data(struct rcu_data *rdp)
 	rdp->nocb_follower_tail = &rdp->nocb_follower_head;
 }
 
+/*
+ * If the specified CPU is a no-CBs CPU that does not already have its
+ * rcuo kthread for the specified RCU flavor, spawn it.  If the CPUs are
+ * brought online out of order, this can require re-organizing the
+ * leader-follower relationships.
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
@@ -2506,7 +2577,6 @@ static void __init rcu_spawn_nocb_kthreads(struct rcu_state *rsp)
 	struct rcu_data *rdp;
 	struct rcu_data *rdp_leader = NULL;  /* Suppress misguided gcc warn. */
 	struct rcu_data *rdp_prev = NULL;
-	struct task_struct *t;
 
 	if (rcu_nocb_mask == NULL)
 		return;
@@ -2532,12 +2602,6 @@ static void __init rcu_spawn_nocb_kthreads(struct rcu_state *rsp)
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
 
@@ -2591,7 +2655,11 @@ static void do_nocb_deferred_wakeup(struct rcu_data *rdp)
 {
 }
 
-static void __init rcu_spawn_nocb_kthreads(struct rcu_state *rsp)
+static void rcu_spawn_all_nocb_kthreads(int cpu)
+{
+}
+
+static void __init rcu_spawn_nocb_kthreads(void)
 {
 }
 
-- 
1.8.1.5

