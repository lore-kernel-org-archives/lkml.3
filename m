Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026AbaKDQN3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 11:13:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59567 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755009AbaKDQN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 11:13:26 -0500
Date: Tue, 4 Nov 2014 08:12:32 -0800
From: tip-bot for Iulia Manda <tipbot@zytor.com>
Message-ID: <tip-44dba3d5d6a10685fb15bd1954e62016334825e0@git.kernel.org>
Cc: mingo@kernel.org, torvalds@linux-foundation.org, hpa@zytor.com,
        iulia.manda21@gmail.com, tglx@linutronix.de, peterz@infradead.org,
        linux-kernel@vger.kernel.org
Reply-To: linux-kernel@vger.kernel.org, tglx@linutronix.de,
        peterz@infradead.org, mingo@kernel.org, torvalds@linux-foundation.org,
        iulia.manda21@gmail.com, hpa@zytor.com
In-Reply-To: <20141031001331.GA30662@winterfell>
References: <20141031001331.GA30662@winterfell>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Refactor task_struct to use numa_faults instead of numa_* pointers
Git-Commit-ID: 44dba3d5d6a10685fb15bd1954e62016334825e0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  44dba3d5d6a10685fb15bd1954e62016334825e0
Gitweb:     http://git.kernel.org/tip/44dba3d5d6a10685fb15bd1954e62016334825e0
Author:     Iulia Manda <iulia.manda21@gmail.com>
AuthorDate: Fri, 31 Oct 2014 02:13:31 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 4 Nov 2014 07:17:57 +0100

sched: Refactor task_struct to use numa_faults instead of numa_* pointers

This patch simplifies task_struct by removing the four numa_* pointers
in the same array and replacing them with the array pointer. By doing this,
on x86_64, the size of task_struct is reduced by 3 ulong pointers (24 bytes on
x86_64).

A new parameter is added to the task_faults_idx function so that it can return
an index to the correct offset, corresponding with the old precalculated
pointers.

All of the code in sched/ that depended on task_faults_idx and numa_* was
changed in order to match the new logic.

Signed-off-by: Iulia Manda <iulia.manda21@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: mgorman@suse.de
Cc: dave@stgolabs.net
Cc: riel@redhat.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20141031001331.GA30662@winterfell
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched.h |  31 ++++++--------
 kernel/sched/core.c   |   3 +-
 kernel/sched/debug.c  |   4 +-
 kernel/sched/fair.c   | 110 ++++++++++++++++++++++++++------------------------
 kernel/sched/sched.h  |   7 ++++
 5 files changed, 80 insertions(+), 75 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4400ddc..bd7c14b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1597,28 +1597,23 @@ struct task_struct {
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
index df0569e..72d9d92 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1857,8 +1857,7 @@ static void __sched_fork(unsigned long clone_flags, struct task_struct *p)
 	p->numa_scan_seq = p->mm ? p->mm->numa_scan_seq : 0;
 	p->numa_scan_period = sysctl_numa_balancing_scan_delay;
 	p->numa_work.next = &p->numa_work;
-	p->numa_faults_memory = NULL;
-	p->numa_faults_buffer_memory = NULL;
+	p->numa_faults = NULL;
 	p->last_task_numa_placement = 0;
 	p->last_sum_exec_runtime = 0;
 
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index eeb6046..92cc520 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -535,8 +535,8 @@ static void sched_show_numa(struct task_struct *p, struct seq_file *m)
 			unsigned long nr_faults = -1;
 			int cpu_current, home_node;
 
-			if (p->numa_faults_memory)
-				nr_faults = p->numa_faults_memory[2*node + i];
+			if (p->numa_faults)
+				nr_faults = p->numa_faults[2*node + i];
 
 			cpu_current = !i ? (task_node(p) == node) :
 				(pol && node_isset(node, pol->v.nodes));
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index d03d76d..826fdf3 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -896,18 +896,24 @@ pid_t task_numa_group_id(struct task_struct *p)
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
+	return NR_NUMA_HINT_FAULT_TYPES * (s * nr_node_ids + nid) + priv;
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
@@ -915,14 +921,14 @@ static inline unsigned long group_faults(struct task_struct *p, int nid)
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
 
 /* Handle placement on systems where not all nodes are directly connected. */
@@ -1001,7 +1007,7 @@ static inline unsigned long task_weight(struct task_struct *p, int nid,
 {
 	unsigned long faults, total_faults;
 
-	if (!p->numa_faults_memory)
+	if (!p->numa_faults)
 		return 0;
 
 	total_faults = p->total_numa_faults;
@@ -1517,7 +1523,7 @@ static void numa_migrate_preferred(struct task_struct *p)
 	unsigned long interval = HZ;
 
 	/* This task has no NUMA fault statistics yet */
-	if (unlikely(p->numa_preferred_nid == -1 || !p->numa_faults_memory))
+	if (unlikely(p->numa_preferred_nid == -1 || !p->numa_faults))
 		return;
 
 	/* Periodically retry migrating the task to the preferred node */
@@ -1779,18 +1785,23 @@ static void task_numa_placement(struct task_struct *p)
 
 	/* Find the node with the highest number of faults */
 	for_each_online_node(nid) {
+		/* Keep track of the offsets in numa_faults array */
+		int mem_idx, membuf_idx, cpu_idx, cpubuf_idx;
 		unsigned long faults = 0, group_faults = 0;
-		int priv, i;
+		int priv;
 
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
@@ -1800,21 +1811,27 @@ static void task_numa_placement(struct task_struct *p)
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
+				/*
+				 * safe because we can only change our own group
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
 
@@ -1886,7 +1903,7 @@ static void task_numa_group(struct task_struct *p, int cpupid, int flags,
 		node_set(task_node(current), grp->active_nodes);
 
 		for (i = 0; i < NR_NUMA_HINT_FAULT_STATS * nr_node_ids; i++)
-			grp->faults[i] = p->numa_faults_memory[i];
+			grp->faults[i] = p->numa_faults[i];
 
 		grp->total_faults = p->total_numa_faults;
 
@@ -1945,8 +1962,8 @@ static void task_numa_group(struct task_struct *p, int cpupid, int flags,
 	double_lock_irq(&my_grp->lock, &grp->lock);
 
 	for (i = 0; i < NR_NUMA_HINT_FAULT_STATS * nr_node_ids; i++) {
-		my_grp->faults[i] -= p->numa_faults_memory[i];
-		grp->faults[i] += p->numa_faults_memory[i];
+		my_grp->faults[i] -= p->numa_faults[i];
+		grp->faults[i] += p->numa_faults[i];
 	}
 	my_grp->total_faults -= p->total_numa_faults;
 	grp->total_faults += p->total_numa_faults;
@@ -1971,14 +1988,14 @@ no_join:
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
@@ -1988,10 +2005,7 @@ void task_numa_free(struct task_struct *p)
 		put_numa_group(grp);
 	}
 
-	p->numa_faults_memory = NULL;
-	p->numa_faults_buffer_memory = NULL;
-	p->numa_faults_cpu= NULL;
-	p->numa_faults_buffer_cpu = NULL;
+	p->numa_faults = NULL;
 	kfree(numa_faults);
 }
 
@@ -2014,24 +2028,14 @@ void task_numa_fault(int last_cpupid, int mem_node, int pages, int flags)
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
@@ -2071,8 +2075,8 @@ void task_numa_fault(int last_cpupid, int mem_node, int pages, int flags)
 	if (migrated)
 		p->numa_pages_migrated += pages;
 
-	p->numa_faults_buffer_memory[task_faults_idx(mem_node, priv)] += pages;
-	p->numa_faults_buffer_cpu[task_faults_idx(cpu_node, priv)] += pages;
+	p->numa_faults[task_faults_idx(NUMA_MEMBUF, mem_node, priv)] += pages;
+	p->numa_faults[task_faults_idx(NUMA_CPUBUF, cpu_node, priv)] += pages;
 	p->numa_faults_locality[local] += pages;
 }
 
@@ -5361,7 +5365,7 @@ static bool migrate_improves_locality(struct task_struct *p, struct lb_env *env)
 	struct numa_group *numa_group = rcu_dereference(p->numa_group);
 	int src_nid, dst_nid;
 
-	if (!sched_feat(NUMA_FAVOUR_HIGHER) || !p->numa_faults_memory ||
+	if (!sched_feat(NUMA_FAVOUR_HIGHER) || !p->numa_faults ||
 	    !(env->sd->flags & SD_NUMA)) {
 		return false;
 	}
@@ -5400,7 +5404,7 @@ static bool migrate_degrades_locality(struct task_struct *p, struct lb_env *env)
 	if (!sched_feat(NUMA) || !sched_feat(NUMA_RESIST_LOWER))
 		return false;
 
-	if (!p->numa_faults_memory || !(env->sd->flags & SD_NUMA))
+	if (!p->numa_faults || !(env->sd->flags & SD_NUMA))
 		return false;
 
 	src_nid = cpu_to_node(env->src_cpu);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 7e5c1ee..31f1e4d 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -709,6 +709,13 @@ extern bool find_numa_distance(int distance);
 #endif
 
 #ifdef CONFIG_NUMA_BALANCING
+/* The regions in numa_faults array from task_struct */
+enum numa_faults_stats {
+	NUMA_MEM = 0,
+	NUMA_CPU,
+	NUMA_MEMBUF,
+	NUMA_CPUBUF
+};
 extern void sched_setnuma(struct task_struct *p, int node);
 extern int migrate_task_to(struct task_struct *p, int cpu);
 extern int migrate_swap(struct task_struct *, struct task_struct *);
