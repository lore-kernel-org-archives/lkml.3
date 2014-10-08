Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796AbaJHTjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 15:39:19 -0400
Received: from shelob.surriel.com ([74.92.59.67]:34510 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471AbaJHTiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 15:38:03 -0400
From: riel@redhat.com
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mgorman@suse.de, chegu_vinod@hp.com,
        mingo@kernel.org, efault@gmx.de, vincent.guittot@linaro.org
Subject: [PATCH RFC 3/5] sched,numa: preparations for complex topology placement
Date: Wed,  8 Oct 2014 15:37:28 -0400
Message-Id: <1412797050-8903-4-git-send-email-riel@redhat.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1412797050-8903-1-git-send-email-riel@redhat.com>
References: <1412797050-8903-1-git-send-email-riel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

Preparatory patch for adding NUMA placement on systems with
complex NUMA topology. Also fix a potential divide by zero
in group_weight()

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 include/linux/topology.h |  1 +
 kernel/sched/core.c      |  2 +-
 kernel/sched/fair.c      | 57 +++++++++++++++++++++++++++++++-----------------
 3 files changed, 39 insertions(+), 21 deletions(-)

diff --git a/include/linux/topology.h b/include/linux/topology.h
index bf40d46..f8dfad9 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -47,6 +47,7 @@
 		if (nr_cpus_node(node))
 
 int arch_update_cpu_topology(void);
+extern int sched_domains_numa_levels;
 extern int node_hops(int i, int j);
 
 enum numa_topology_type {
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 1898914..2528f97 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6074,7 +6074,7 @@ static void claim_allocations(int cpu, struct sched_domain *sd)
 }
 
 #ifdef CONFIG_NUMA
-static int sched_domains_numa_levels;
+int sched_domains_numa_levels;
 enum numa_topology_type sched_numa_topology_type;
 static int *sched_domains_numa_distance;
 static int *sched_domains_numa_hops;
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 6d44052..8b3f884 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -930,9 +930,10 @@ static inline unsigned long group_faults_cpu(struct numa_group *group, int nid)
  * larger multiplier, in order to group tasks together that are almost
  * evenly spread out between numa nodes.
  */
-static inline unsigned long task_weight(struct task_struct *p, int nid)
+static inline unsigned long task_weight(struct task_struct *p, int nid,
+					int hops)
 {
-	unsigned long total_faults;
+	unsigned long faults, total_faults;
 
 	if (!p->numa_faults_memory)
 		return 0;
@@ -942,15 +943,25 @@ static inline unsigned long task_weight(struct task_struct *p, int nid)
 	if (!total_faults)
 		return 0;
 
-	return 1000 * task_faults(p, nid) / total_faults;
+	faults = task_faults(p, nid);
+	return 1000 * faults / total_faults;
 }
 
-static inline unsigned long group_weight(struct task_struct *p, int nid)
+static inline unsigned long group_weight(struct task_struct *p, int nid,
+					 int hops)
 {
-	if (!p->numa_group || !p->numa_group->total_faults)
+	unsigned long faults, total_faults;
+
+	if (!p->numa_group)
+		return 0;
+
+	total_faults = p->numa_group->total_faults;
+
+	if (!total_faults)
 		return 0;
 
-	return 1000 * group_faults(p, nid) / p->numa_group->total_faults;
+	faults = group_faults(p, nid);
+	return 1000 * faults / total_faults;
 }
 
 bool should_numa_migrate_memory(struct task_struct *p, struct page * page,
@@ -1083,6 +1094,7 @@ struct task_numa_env {
 	struct numa_stats src_stats, dst_stats;
 
 	int imbalance_pct;
+	int hops;
 
 	struct task_struct *best_task;
 	long best_imp;
@@ -1162,6 +1174,7 @@ static void task_numa_compare(struct task_numa_env *env,
 	long load;
 	long imp = env->p->numa_group ? groupimp : taskimp;
 	long moveimp = imp;
+	int hops = env->hops;
 
 	rcu_read_lock();
 	cur = ACCESS_ONCE(dst_rq->curr);
@@ -1185,8 +1198,8 @@ static void task_numa_compare(struct task_numa_env *env,
 		 * in any group then look only at task weights.
 		 */
 		if (cur->numa_group == env->p->numa_group) {
-			imp = taskimp + task_weight(cur, env->src_nid) -
-			      task_weight(cur, env->dst_nid);
+			imp = taskimp + task_weight(cur, env->src_nid, hops) -
+			      task_weight(cur, env->dst_nid, hops);
 			/*
 			 * Add some hysteresis to prevent swapping the
 			 * tasks within a group over tiny differences.
@@ -1200,11 +1213,11 @@ static void task_numa_compare(struct task_numa_env *env,
 			 * instead.
 			 */
 			if (cur->numa_group)
-				imp += group_weight(cur, env->src_nid) -
-				       group_weight(cur, env->dst_nid);
+				imp += group_weight(cur, env->src_nid, hops) -
+				       group_weight(cur, env->dst_nid, hops);
 			else
-				imp += task_weight(cur, env->src_nid) -
-				       task_weight(cur, env->dst_nid);
+				imp += task_weight(cur, env->src_nid, hops) -
+				       task_weight(cur, env->dst_nid, hops);
 		}
 	}
 
@@ -1303,7 +1316,7 @@ static int task_numa_migrate(struct task_struct *p)
 	};
 	struct sched_domain *sd;
 	unsigned long taskweight, groupweight;
-	int nid, ret;
+	int nid, ret, hops;
 	long taskimp, groupimp;
 
 	/*
@@ -1331,12 +1344,13 @@ static int task_numa_migrate(struct task_struct *p)
 		return -EINVAL;
 	}
 
-	taskweight = task_weight(p, env.src_nid);
-	groupweight = group_weight(p, env.src_nid);
-	update_numa_stats(&env.src_stats, env.src_nid);
 	env.dst_nid = p->numa_preferred_nid;
-	taskimp = task_weight(p, env.dst_nid) - taskweight;
-	groupimp = group_weight(p, env.dst_nid) - groupweight;
+	hops = env.hops = node_hops(env.src_nid, env.dst_nid);
+	taskweight = task_weight(p, env.src_nid, hops);
+	groupweight = group_weight(p, env.src_nid, hops);
+	update_numa_stats(&env.src_stats, env.src_nid);
+	taskimp = task_weight(p, env.dst_nid, hops) - taskweight;
+	groupimp = group_weight(p, env.dst_nid, hops) - groupweight;
 	update_numa_stats(&env.dst_stats, env.dst_nid);
 
 	/* Try to find a spot on the preferred nid. */
@@ -1348,12 +1362,15 @@ static int task_numa_migrate(struct task_struct *p)
 			if (nid == env.src_nid || nid == p->numa_preferred_nid)
 				continue;
 
+			hops = node_hops(env.src_nid, env.dst_nid);
+
 			/* Only consider nodes where both task and groups benefit */
-			taskimp = task_weight(p, nid) - taskweight;
-			groupimp = group_weight(p, nid) - groupweight;
+			taskimp = task_weight(p, nid, hops) - taskweight;
+			groupimp = group_weight(p, nid, hops) - groupweight;
 			if (taskimp < 0 && groupimp < 0)
 				continue;
 
+			env.hops = hops;
 			env.dst_nid = nid;
 			update_numa_stats(&env.dst_stats, env.dst_nid);
 			task_numa_find_cpu(&env, taskimp, groupimp);
-- 
1.9.3

