Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759753AbaJ3Tii (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 15:38:38 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:64126 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755522AbaJ3Tig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 15:38:36 -0400
Date: Thu, 30 Oct 2014 21:38:17 +0200
From: Iulia Manda <iulia.manda21@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: riel@redhat.com, mingo@redhat.com, peterz@infradead.org, mgorman@suse.de
Subject: [PATCH] kernel: Refactor task_struct to use numa_faults instead of
 numa_* pointers
Message-ID: <20141030193817.GA17859@winterfell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch simplifies task_struct by removing the four numa_* pointers
in the same array and replacing them with the array pointer. By doing this,
the size of task_struct is reduced.

A new parameter is added to the task_faults_idx function so that it can return
an index to the correct offset, corresponding with the old precalculated
pointers.

All of the code in sched/ that depended on task_faults_idx and numa_* was
changed in order to match the new logic.

Signed-off-by: Iulia Manda <iulia.manda21@gmail.com>
---
 include/linux/sched.h |   40 ++++++++++--------
 kernel/sched/core.c   |    3 +-
 kernel/sched/debug.c  |    4 +-
 kernel/sched/fair.c   |  110 +++++++++++++++++++++++++------------------------
 4 files changed, 82 insertions(+), 75 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5e344bb..bf8c19f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -796,6 +796,15 @@ struct sched_info {
 };
 #endif /* defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT) */
 
+#ifdef CONFIG_NUMA_BALANCING
+enum numa_faults_stats {
+	NUMA_MEM = 0,
+	NUMA_CPU,
+	NUMA_MEMBUF,
+	NUMA_CPUBUF
+};
+#endif
+
 #ifdef CONFIG_TASK_DELAY_ACCT
 struct task_delay_info {
 	spinlock_t	lock;
@@ -1558,28 +1567,23 @@ struct task_struct {
 	struct numa_group *numa_group;
 
 	/*
-	 * Exponential decaying average of faults on a per-node basis.
-	 * Scheduling placement decisions are made based on the these counts.
-	 * The values remain static for the duration of a PTE scan
+	 * numa_faults is an array split into four regions:
+	 * faults_memory, faults_cpu, faults_memory_buffer, faults_cpu_buffer
+	 * in this precise order.
+	 *
+	 * faults_memory: Exponential decaying average of faults on a per-node
+	 * basis. Scheduling placement decisions are made based on these
+	 * counts. The values remain static for the duration of a PTE scan.
+	 * faults_cpu: Track the nodes the process was running on when a NUMA
+	 * hinting fault was incurred.
+	 * faults_memory_buffer and faults_cpu_buffer: Record faults per node
+	 * during the current scan window. When the scan completes, the counts
+	 * in faults_memory and faults_cpu decay and these values are copied.
 	 */
-	unsigned long *numa_faults_memory;
+	unsigned long *numa_faults;
 	unsigned long total_numa_faults;
 
 	/*
-	 * numa_faults_buffer records faults per node during the current
-	 * scan window. When the scan completes, the counts in
-	 * numa_faults_memory decay and these values are copied.
-	 */
-	unsigned long *numa_faults_buffer_memory;
-
-	/*
-	 * Track the nodes the process was running on when a NUMA hinting
-	 * fault was incurred.
-	 */
-	unsigned long *numa_faults_cpu;
-	unsigned long *numa_faults_buffer_cpu;
-
-	/*
 	 * numa_faults_locality tracks if faults recorded during the last
 	 * scan window were remote/local. The task scan period is adapted
 	 * based on the locality of the faults with different weights
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 4499950..b28bd0b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1853,8 +1853,7 @@ static void __sched_fork(unsigned long clone_flags, struct task_struct *p)
 	p->numa_scan_seq = p->mm ? p->mm->numa_scan_seq : 0;
 	p->numa_scan_period = sysctl_numa_balancing_scan_delay;
 	p->numa_work.next = &p->numa_work;
-	p->numa_faults_memory = NULL;
-	p->numa_faults_buffer_memory = NULL;
+	p->numa_faults = NULL;
 	p->last_task_numa_placement = 0;
 	p->last_sum_exec_runtime = 0;
 
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index ce33780..567fc0f 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -528,8 +528,8 @@ static void sched_show_numa(struct task_struct *p, struct seq_file *m)
 			unsigned long nr_faults = -1;
 			int cpu_current, home_node;
 
-			if (p->numa_faults_memory)
-				nr_faults = p->numa_faults_memory[2*node + i];
+			if (p->numa_faults)
+				nr_faults = p->numa_faults[2*node + i];
 
 			cpu_current = !i ? (task_node(p) == node) :
 				(pol && node_isset(node, pol->v.nodes));
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 0b069bf..7aded81 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -895,18 +895,25 @@ pid_t task_numa_group_id(struct task_struct *p)
 	return p->numa_group ? p->numa_group->gid : 0;
 }
 
-static inline int task_faults_idx(int nid, int priv)
+/*
+ * The averaged statistics, shared & private, memory & cpu,
+ * occupy the first half of the array. The second half of the
+ * array is for current counters, which are averaged into the
+ * first set by task_numa_placement.
+ */
+static inline int task_faults_idx(enum numa_faults_stats s, int nid, int priv)
 {
-	return NR_NUMA_HINT_FAULT_TYPES * nid + priv;
+	return s * NR_NUMA_HINT_FAULT_TYPES * nr_node_ids +
+		NR_NUMA_HINT_FAULT_TYPES * nid + priv;
 }
 
 static inline unsigned long task_faults(struct task_struct *p, int nid)
 {
-	if (!p->numa_faults_memory)
+	if (!p->numa_faults)
 		return 0;
 
-	return p->numa_faults_memory[task_faults_idx(nid, 0)] +
-		p->numa_faults_memory[task_faults_idx(nid, 1)];
+	return p->numa_faults[task_faults_idx(NUMA_MEM, nid, 0)] +
+		p->numa_faults[task_faults_idx(NUMA_MEM, nid, 1)];
 }
 
 static inline unsigned long group_faults(struct task_struct *p, int nid)
@@ -914,14 +921,14 @@ static inline unsigned long group_faults(struct task_struct *p, int nid)
 	if (!p->numa_group)
 		return 0;
 
-	return p->numa_group->faults[task_faults_idx(nid, 0)] +
-		p->numa_group->faults[task_faults_idx(nid, 1)];
+	return p->numa_group->faults[task_faults_idx(NUMA_MEM, nid, 0)] +
+		p->numa_group->faults[task_faults_idx(NUMA_MEM, nid, 1)];
 }
 
 static inline unsigned long group_faults_cpu(struct numa_group *group, int nid)
 {
-	return group->faults_cpu[task_faults_idx(nid, 0)] +
-		group->faults_cpu[task_faults_idx(nid, 1)];
+	return group->faults_cpu[task_faults_idx(NUMA_MEM, nid, 0)] +
+		group->faults_cpu[task_faults_idx(NUMA_MEM, nid, 1)];
 }
 
 /*
@@ -934,7 +941,7 @@ static inline unsigned long task_weight(struct task_struct *p, int nid)
 {
 	unsigned long total_faults;
 
-	if (!p->numa_faults_memory)
+	if (!p->numa_faults)
 		return 0;
 
 	total_faults = p->total_numa_faults;
@@ -1408,7 +1415,7 @@ static void numa_migrate_preferred(struct task_struct *p)
 	unsigned long interval = HZ;
 
 	/* This task has no NUMA fault statistics yet */
-	if (unlikely(p->numa_preferred_nid == -1 || !p->numa_faults_memory))
+	if (unlikely(p->numa_preferred_nid == -1 || !p->numa_faults))
 		return;
 
 	/* Periodically retry migrating the task to the preferred node */
@@ -1585,17 +1592,22 @@ static void task_numa_placement(struct task_struct *p)
 	/* Find the node with the highest number of faults */
 	for_each_online_node(nid) {
 		unsigned long faults = 0, group_faults = 0;
-		int priv, i;
+		int priv;
+		/* Keep track of the offsets in numa_faults array */
+		int mem_idx, membuf_idx, cpu_idx, cpubuf_idx;
 
 		for (priv = 0; priv < NR_NUMA_HINT_FAULT_TYPES; priv++) {
 			long diff, f_diff, f_weight;
 
-			i = task_faults_idx(nid, priv);
+			mem_idx = task_faults_idx(NUMA_MEM, nid, priv);
+			membuf_idx = task_faults_idx(NUMA_MEMBUF, nid, priv);
+			cpu_idx = task_faults_idx(NUMA_CPU, nid, priv);
+			cpubuf_idx = task_faults_idx(NUMA_CPUBUF, nid, priv);
 
 			/* Decay existing window, copy faults since last scan */
-			diff = p->numa_faults_buffer_memory[i] - p->numa_faults_memory[i] / 2;
-			fault_types[priv] += p->numa_faults_buffer_memory[i];
-			p->numa_faults_buffer_memory[i] = 0;
+			diff = p->numa_faults[membuf_idx] - p->numa_faults[mem_idx] / 2;
+			fault_types[priv] += p->numa_faults[membuf_idx];
+			p->numa_faults[membuf_idx] = 0;
 
 			/*
 			 * Normalize the faults_from, so all tasks in a group
@@ -1605,21 +1617,26 @@ static void task_numa_placement(struct task_struct *p)
 			 * faults are less important.
 			 */
 			f_weight = div64_u64(runtime << 16, period + 1);
-			f_weight = (f_weight * p->numa_faults_buffer_cpu[i]) /
+			f_weight = (f_weight * p->numa_faults[cpubuf_idx]) /
 				   (total_faults + 1);
-			f_diff = f_weight - p->numa_faults_cpu[i] / 2;
-			p->numa_faults_buffer_cpu[i] = 0;
+			f_diff = f_weight - p->numa_faults[cpu_idx] / 2;
+			p->numa_faults[cpubuf_idx] = 0;
 
-			p->numa_faults_memory[i] += diff;
-			p->numa_faults_cpu[i] += f_diff;
-			faults += p->numa_faults_memory[i];
+			p->numa_faults[mem_idx] += diff;
+			p->numa_faults[cpu_idx] += f_diff;
+			faults += p->numa_faults[mem_idx];
 			p->total_numa_faults += diff;
 			if (p->numa_group) {
-				/* safe because we can only change our own group */
-				p->numa_group->faults[i] += diff;
-				p->numa_group->faults_cpu[i] += f_diff;
+				/* safe because we can only change our own group
+				 *
+				 * mem_idx represents the offset for a given
+				 * nid and priv in a specific region because it
+				 * is at the beginning of the numa_faults array.
+				 */
+				p->numa_group->faults[mem_idx] += diff;
+				p->numa_group->faults_cpu[mem_idx] += f_diff;
 				p->numa_group->total_faults += diff;
-				group_faults += p->numa_group->faults[i];
+				group_faults += p->numa_group->faults[mem_idx];
 			}
 		}
 
@@ -1691,7 +1708,7 @@ static void task_numa_group(struct task_struct *p, int cpupid, int flags,
 		node_set(task_node(current), grp->active_nodes);
 
 		for (i = 0; i < NR_NUMA_HINT_FAULT_STATS * nr_node_ids; i++)
-			grp->faults[i] = p->numa_faults_memory[i];
+			grp->faults[i] = p->numa_faults[i];
 
 		grp->total_faults = p->total_numa_faults;
 
@@ -1750,8 +1767,8 @@ static void task_numa_group(struct task_struct *p, int cpupid, int flags,
 	double_lock_irq(&my_grp->lock, &grp->lock);
 
 	for (i = 0; i < NR_NUMA_HINT_FAULT_STATS * nr_node_ids; i++) {
-		my_grp->faults[i] -= p->numa_faults_memory[i];
-		grp->faults[i] += p->numa_faults_memory[i];
+		my_grp->faults[i] -= p->numa_faults[i];
+		grp->faults[i] += p->numa_faults[i];
 	}
 	my_grp->total_faults -= p->total_numa_faults;
 	grp->total_faults += p->total_numa_faults;
@@ -1776,14 +1793,14 @@ no_join:
 void task_numa_free(struct task_struct *p)
 {
 	struct numa_group *grp = p->numa_group;
-	void *numa_faults = p->numa_faults_memory;
+	void *numa_faults = p->numa_faults;
 	unsigned long flags;
 	int i;
 
 	if (grp) {
 		spin_lock_irqsave(&grp->lock, flags);
 		for (i = 0; i < NR_NUMA_HINT_FAULT_STATS * nr_node_ids; i++)
-			grp->faults[i] -= p->numa_faults_memory[i];
+			grp->faults[i] -= p->numa_faults[i];
 		grp->total_faults -= p->total_numa_faults;
 
 		list_del(&p->numa_entry);
@@ -1793,10 +1810,7 @@ void task_numa_free(struct task_struct *p)
 		put_numa_group(grp);
 	}
 
-	p->numa_faults_memory = NULL;
-	p->numa_faults_buffer_memory = NULL;
-	p->numa_faults_cpu= NULL;
-	p->numa_faults_buffer_cpu = NULL;
+	p->numa_faults = NULL;
 	kfree(numa_faults);
 }
 
@@ -1819,24 +1833,14 @@ void task_numa_fault(int last_cpupid, int mem_node, int pages, int flags)
 		return;
 
 	/* Allocate buffer to track faults on a per-node basis */
-	if (unlikely(!p->numa_faults_memory)) {
-		int size = sizeof(*p->numa_faults_memory) *
+	if (unlikely(!p->numa_faults)) {
+		int size = sizeof(*p->numa_faults) *
 			   NR_NUMA_HINT_FAULT_BUCKETS * nr_node_ids;
 
-		p->numa_faults_memory = kzalloc(size, GFP_KERNEL|__GFP_NOWARN);
-		if (!p->numa_faults_memory)
+		p->numa_faults = kzalloc(size, GFP_KERNEL|__GFP_NOWARN);
+		if (!p->numa_faults)
 			return;
 
-		BUG_ON(p->numa_faults_buffer_memory);
-		/*
-		 * The averaged statistics, shared & private, memory & cpu,
-		 * occupy the first half of the array. The second half of the
-		 * array is for current counters, which are averaged into the
-		 * first set by task_numa_placement.
-		 */
-		p->numa_faults_cpu = p->numa_faults_memory + (2 * nr_node_ids);
-		p->numa_faults_buffer_memory = p->numa_faults_memory + (4 * nr_node_ids);
-		p->numa_faults_buffer_cpu = p->numa_faults_memory + (6 * nr_node_ids);
 		p->total_numa_faults = 0;
 		memset(p->numa_faults_locality, 0, sizeof(p->numa_faults_locality));
 	}
@@ -1876,8 +1880,8 @@ void task_numa_fault(int last_cpupid, int mem_node, int pages, int flags)
 	if (migrated)
 		p->numa_pages_migrated += pages;
 
-	p->numa_faults_buffer_memory[task_faults_idx(mem_node, priv)] += pages;
-	p->numa_faults_buffer_cpu[task_faults_idx(cpu_node, priv)] += pages;
+	p->numa_faults[task_faults_idx(NUMA_MEMBUF, mem_node, priv)] += pages;
+	p->numa_faults[task_faults_idx(NUMA_CPUBUF, cpu_node, priv)] += pages;
 	p->numa_faults_locality[local] += pages;
 }
 
@@ -5166,7 +5170,7 @@ static bool migrate_improves_locality(struct task_struct *p, struct lb_env *env)
 	struct numa_group *numa_group = rcu_dereference(p->numa_group);
 	int src_nid, dst_nid;
 
-	if (!sched_feat(NUMA_FAVOUR_HIGHER) || !p->numa_faults_memory ||
+	if (!sched_feat(NUMA_FAVOUR_HIGHER) || !p->numa_faults ||
 	    !(env->sd->flags & SD_NUMA)) {
 		return false;
 	}
@@ -5205,7 +5209,7 @@ static bool migrate_degrades_locality(struct task_struct *p, struct lb_env *env)
 	if (!sched_feat(NUMA) || !sched_feat(NUMA_RESIST_LOWER))
 		return false;
 
-	if (!p->numa_faults_memory || !(env->sd->flags & SD_NUMA))
+	if (!p->numa_faults || !(env->sd->flags & SD_NUMA))
 		return false;
 
 	src_nid = cpu_to_node(env->src_cpu);
-- 
1.7.10.4

