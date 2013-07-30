Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757873Ab3G3HtM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 03:49:12 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:36607 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575Ab3G3HtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 03:49:10 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Mel Gorman <mgorman@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: [RFC PATCH 02/10] sched: Use numa weights while migrating tasks
Date: Tue, 30 Jul 2013 13:18:17 +0530
Message-Id: <1375170505-5967-3-git-send-email-srikar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1375170505-5967-1-git-send-email-srikar@linux.vnet.ibm.com>
References: <1375170505-5967-1-git-send-email-srikar@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13073007-3620-0000-0000-000003BA6086
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While migrating a task, check if moving it improves consolidation.
However make sure that such a movement doesnt offset fairness or create
imbalance in the nodes.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 include/linux/sched.h |    1 +
 kernel/sched/core.c   |    1 +
 kernel/sched/fair.c   |   80 ++++++++++++++++++++++++++++++++++++++++++------
 3 files changed, 72 insertions(+), 10 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index e692a02..a77c3cd 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -815,6 +815,7 @@ enum cpu_idle_type {
 #define SD_ASYM_PACKING		0x0800  /* Place busy groups earlier in the domain */
 #define SD_PREFER_SIBLING	0x1000	/* Prefer to place tasks in a sibling domain */
 #define SD_OVERLAP		0x2000	/* sched_domains of this level overlap */
+#define SD_NUMA			0x4000	/* cross-node balancing */
 
 extern int __weak arch_sd_sibiling_asym_packing(void);
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 67d0465..e792312 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6136,6 +6136,7 @@ sd_numa_init(struct sched_domain_topology_level *tl, int cpu)
 					| 0*SD_SHARE_PKG_RESOURCES
 					| 1*SD_SERIALIZE
 					| 0*SD_PREFER_SIBLING
+					| 1*SD_NUMA
 					| sd_local_flags(level)
 					,
 		.last_balance		= jiffies,
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 8a2b5aa..3df7f76 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3326,6 +3326,58 @@ static int select_idle_sibling(struct task_struct *p, int target)
 	return target;
 }
 
+#ifdef CONFIG_NUMA_BALANCING
+/* Move a task if
+ * Return -1 if the task has no numa affinity
+ * Return 1 if the task has numa affinity and moving the destination
+ * runqueue is not already loaded.
+ * else return 0
+ */
+static int
+can_numa_migrate_task(struct task_struct *p, struct rq *dst_rq, struct rq *src_rq)
+{
+	struct mm_struct *mm;
+	int dst_node, src_node;
+	int dst_running, src_running;
+
+	mm = p->mm;
+	if (!mm || !mm->numa_weights)
+		return -1;
+
+	if (atomic_read(&mm->numa_weights[nr_node_ids]) < 2)
+		return -1;
+
+	dst_node = cpu_to_node(cpu_of(dst_rq));
+	src_node = cpu_to_node(cpu_of(src_rq));
+	dst_running = atomic_read(&mm->numa_weights[dst_node]);
+	src_running = atomic_read(&mm->numa_weights[src_node]);
+
+	if (dst_rq->nr_running <= src_rq->nr_running) {
+		if (dst_running * src_rq->nr_running >= src_running * dst_rq->nr_running)
+			return 1;
+	}
+
+	return 0;
+}
+#else
+static int
+can_numa_migrate_task(struct task_struct *p, struct rq *dst_rq, struct rq *src_rq)
+{
+	return -1;
+}
+#endif
+/*
+ * Dont move a task if the source runq has more numa affinity.
+ */
+static bool
+check_numa_affinity(struct task_struct *p, int cpu, int prev_cpu)
+{
+	struct rq *src_rq = cpu_rq(prev_cpu);
+	struct rq *dst_rq = cpu_rq(cpu);
+
+	return (can_numa_migrate_task(p, dst_rq, src_rq) != 0);
+}
+
 /*
  * sched_balance_self: balance the current task (running on cpu) in domains
  * that have the 'flag' flag set. In practice, this is SD_BALANCE_FORK and
@@ -3351,7 +3403,8 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 		return prev_cpu;
 
 	if (sd_flag & SD_BALANCE_WAKE) {
-		if (cpumask_test_cpu(cpu, tsk_cpus_allowed(p)))
+		if (cpumask_test_cpu(cpu, tsk_cpus_allowed(p)) &&
+				check_numa_affinity(p, cpu, prev_cpu))
 			want_affine = 1;
 		new_cpu = prev_cpu;
 	}
@@ -3899,6 +3952,17 @@ task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
 	return delta < (s64)sysctl_sched_migration_cost;
 }
 
+static bool force_migrate(struct lb_env *env, struct task_struct *p)
+{
+	if (env->sd->nr_balance_failed > env->sd->cache_nice_tries)
+		return true;
+
+	if (!(env->sd->flags & SD_NUMA))
+		return false;
+
+	return (can_numa_migrate_task(p, env->dst_rq, env->src_rq) == 1);
+}
+
 /*
  * can_migrate_task - may task p from runqueue rq be migrated to this_cpu?
  */
@@ -3949,21 +4013,17 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
 	 * Aggressive migration if:
 	 * 1) task is cache cold, or
 	 * 2) too many balance attempts have failed.
+	 * 3) has numa affinity
 	 */
-
 	tsk_cache_hot = task_hot(p, env->src_rq->clock_task, env->sd);
-	if (!tsk_cache_hot ||
-		env->sd->nr_balance_failed > env->sd->cache_nice_tries) {
+	if (tsk_cache_hot) {
+		if (force_migrate(env, p)) {
 #ifdef CONFIG_SCHEDSTATS
-		if (tsk_cache_hot) {
 			schedstat_inc(env->sd, lb_hot_gained[env->idle]);
 			schedstat_inc(p, se.statistics.nr_forced_migrations);
-		}
 #endif
-		return 1;
-	}
-
-	if (tsk_cache_hot) {
+			return 1;
+		}
 		schedstat_inc(p, se.statistics.nr_failed_migrations_hot);
 		return 0;
 	}
-- 
1.7.1

