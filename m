Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331AbaA0WER (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 17:04:17 -0500
Received: from shelob.surriel.com ([74.92.59.67]:58584 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754293AbaA0WEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 17:04:14 -0500
From: riel@redhat.com
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, peterz@infradead.org, mgorman@suse.de,
        mingo@redhat.com, chegu_vinod@hp.com
Subject: [PATCH 5/9] numa,sched,mm: use active_nodes nodemask to limit numa migrations
Date: Mon, 27 Jan 2014 17:03:44 -0500
Message-Id: <1390860228-21539-6-git-send-email-riel@redhat.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1390860228-21539-1-git-send-email-riel@redhat.com>
References: <1390860228-21539-1-git-send-email-riel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

Use the active_nodes nodemask to make smarter decisions on NUMA migrations.

In order to maximize performance of workloads that do not fit in one NUMA
node, we want to satisfy the following criteria:
1) keep private memory local to each thread
2) avoid excessive NUMA migration of pages
3) distribute shared memory across the active nodes, to
   maximize memory bandwidth available to the workload

This patch accomplishes that by implementing the following policy for
NUMA migrations:
1) always migrate on a private fault
2) never migrate to a node that is not in the set of active nodes
   for the numa_group
3) always migrate from a node outside of the set of active nodes,
   to a node that is in that set
4) within the set of active nodes in the numa_group, only migrate
   from a node with more NUMA page faults, to a node with fewer
   NUMA page faults, with a 25% margin to avoid ping-ponging

This results in most pages of a workload ending up on the actively
used nodes, with reduced ping-ponging of pages between those nodes.

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Chegu Vinod <chegu_vinod@hp.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
---
 include/linux/sched.h |  7 ++++++
 kernel/sched/fair.c   | 63 +++++++++++++++++++++++++++++++++++++++++++++++++++
 mm/mempolicy.c        | 29 +-----------------------
 3 files changed, 71 insertions(+), 28 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5fb0cfb..5ab3b89 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1589,6 +1589,8 @@ extern void task_numa_fault(int last_node, int node, int pages, int flags);
 extern pid_t task_numa_group_id(struct task_struct *p);
 extern void set_numabalancing_state(bool enabled);
 extern void task_numa_free(struct task_struct *p);
+extern bool should_numa_migrate_memory(struct task_struct *p, struct page *page,
+					int src_nid, int dst_cpu);
 #else
 static inline void task_numa_fault(int last_node, int node, int pages,
 				   int flags)
@@ -1604,6 +1606,11 @@ static inline void set_numabalancing_state(bool enabled)
 static inline void task_numa_free(struct task_struct *p)
 {
 }
+static inline bool should_numa_migrate_memory(struct task_struct *p,
+				struct page *page, int src_nid, int dst_cpu)
+{
+	return true;
+}
 #endif
 
 static inline struct pid *task_pid(struct task_struct *task)
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 1ee921f..eeabb33 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -954,6 +954,69 @@ static inline unsigned long group_weight(struct task_struct *p, int nid)
 	return 1000 * group_faults(p, nid) / p->numa_group->total_faults;
 }
 
+bool should_numa_migrate_memory(struct task_struct *p, struct page * page,
+				int src_nid, int dst_cpu)
+{
+	struct numa_group *ng = p->numa_group;
+	int dst_nid = cpu_to_node(dst_cpu);
+	int last_cpupid, this_cpupid;
+
+	this_cpupid = cpu_pid_to_cpupid(dst_cpu, current->pid);
+
+	/*
+	 * Multi-stage node selection is used in conjunction with a periodic
+	 * migration fault to build a temporal task<->page relation. By using
+	 * a two-stage filter we remove short/unlikely relations.
+	 *
+	 * Using P(p) ~ n_p / n_t as per frequentist probability, we can equate
+	 * a task's usage of a particular page (n_p) per total usage of this
+	 * page (n_t) (in a given time-span) to a probability.
+	 *
+	 * Our periodic faults will sample this probability and getting the
+	 * same result twice in a row, given these samples are fully
+	 * independent, is then given by P(n)^2, provided our sample period
+	 * is sufficiently short compared to the usage pattern.
+	 *
+	 * This quadric squishes small probabilities, making it less likely we
+	 * act on an unlikely task<->page relation.
+	 */
+	last_cpupid = page_cpupid_xchg_last(page, this_cpupid);
+	if (!cpupid_pid_unset(last_cpupid) &&
+				cpupid_to_nid(last_cpupid) != dst_nid)
+		return false;
+
+	/* Always allow migrate on private faults */
+	if (cpupid_match_pid(p, last_cpupid))
+		return true;
+
+	/* A shared fault, but p->numa_group has not been set up yet. */
+	if (!ng)
+		return true;
+
+	/*
+	 * Do not migrate if the destination is not a node that
+	 * is actively used by this numa group.
+	 */
+	if (!node_isset(dst_nid, ng->active_nodes))
+		return false;
+
+	/*
+	 * Source is a node that is not actively used by this
+	 * numa group, while the destination is. Migrate.
+	 */
+	if (!node_isset(src_nid, ng->active_nodes))
+		return true;
+
+	/*
+	 * Both source and destination are nodes in active
+	 * use by this numa group. Maximize memory bandwidth
+	 * by migrating from more heavily used groups, to less
+	 * heavily used ones, spreading the load around.
+	 * Use a 1/4 hysteresis to avoid spurious page movement.
+	 */
+	return group_faults(p, dst_nid) < (group_faults(p, src_nid) * 3 / 4);
+}
+
 static unsigned long weighted_cpuload(const int cpu);
 static unsigned long source_load(int cpu, int type);
 static unsigned long target_load(int cpu, int type);
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 68d5c7f..784c11e 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2377,37 +2377,10 @@ int mpol_misplaced(struct page *page, struct vm_area_struct *vma, unsigned long
 
 	/* Migrate the page towards the node whose CPU is referencing it */
 	if (pol->flags & MPOL_F_MORON) {
-		int last_cpupid;
-		int this_cpupid;
-
 		polnid = thisnid;
-		this_cpupid = cpu_pid_to_cpupid(thiscpu, current->pid);
 
-		/*
-		 * Multi-stage node selection is used in conjunction
-		 * with a periodic migration fault to build a temporal
-		 * task<->page relation. By using a two-stage filter we
-		 * remove short/unlikely relations.
-		 *
-		 * Using P(p) ~ n_p / n_t as per frequentist
-		 * probability, we can equate a task's usage of a
-		 * particular page (n_p) per total usage of this
-		 * page (n_t) (in a given time-span) to a probability.
-		 *
-		 * Our periodic faults will sample this probability and
-		 * getting the same result twice in a row, given these
-		 * samples are fully independent, is then given by
-		 * P(n)^2, provided our sample period is sufficiently
-		 * short compared to the usage pattern.
-		 *
-		 * This quadric squishes small probabilities, making
-		 * it less likely we act on an unlikely task<->page
-		 * relation.
-		 */
-		last_cpupid = page_cpupid_xchg_last(page, this_cpupid);
-		if (!cpupid_pid_unset(last_cpupid) && cpupid_to_nid(last_cpupid) != thisnid) {
+		if (!should_numa_migrate_memory(current, page, curnid, thiscpu))
 			goto out;
-		}
 	}
 
 	if (curnid != polnid)
-- 
1.8.4.2

