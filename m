Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634AbaAUWVN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 17:21:13 -0500
Received: from shelob.surriel.com ([74.92.59.67]:44279 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446AbaAUWU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 17:20:27 -0500
From: riel@redhat.com
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, peterz@infradead.org, mgorman@suse.de,
        mingo@redhat.com, chegu_vinod@hp.com
Subject: [PATCH 6/9] numa,sched: normalize faults_cpu stats and weigh by CPU use
Date: Tue, 21 Jan 2014 17:20:08 -0500
Message-Id: <1390342811-11769-7-git-send-email-riel@redhat.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1390342811-11769-1-git-send-email-riel@redhat.com>
References: <1390342811-11769-1-git-send-email-riel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

Tracing the code that decides the active nodes has made it abundantly clear
that the naive implementation of the faults_from code has issues.

Specifically, the garbage collector in some workloads will access orders
of magnitudes more memory than the threads that do all the active work.
This resulted in the node with the garbage collector being marked the only
active node in the group.

This issue is avoided if we weigh the statistics by CPU use of each task in
the numa group, instead of by how many faults each thread has occurred.

To achieve this, we normalize the number of faults to the fraction of faults
that occurred on each node, and then multiply that fraction by the fraction
of CPU time the task has used since the last time task_numa_placement was
invoked.

This way the nodes in the active node mask will be the ones where the tasks
from the numa group are most actively running, and the influence of eg. the
garbage collector and other do-little threads is properly minimized.

On a 4 node system, using CPU use statistics calculated over a longer interval
results in about 1% fewer page migrations with two 32-warehouse specjbb runs
on a 4 node system, and about 5% fewer page migrations, as well as 1% better
throughput, with two 8-warehouse specjbb runs, as compared with the shorter
term statistics kept by the scheduler.

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Chegu Vinod <chegu_vinod@hp.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
---
 include/linux/sched.h |  2 ++
 kernel/sched/core.c   |  2 ++
 kernel/sched/fair.c   | 53 +++++++++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 55 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0bf4ac2..2b3cd41 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1471,6 +1471,8 @@ struct task_struct {
 	int numa_preferred_nid;
 	unsigned long numa_migrate_retry;
 	u64 node_stamp;			/* migration stamp  */
+	u64 last_task_numa_placement;
+	u64 last_sum_exec_runtime;
 	struct callback_head numa_work;
 
 	struct list_head numa_entry;
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 224871f..1bd0727 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1758,6 +1758,8 @@ static void __sched_fork(unsigned long clone_flags, struct task_struct *p)
 	p->numa_work.next = &p->numa_work;
 	p->numa_faults_memory = NULL;
 	p->numa_faults_buffer_memory = NULL;
+	p->last_task_numa_placement = 0;
+	p->last_sum_exec_runtime = 0;
 
 	INIT_LIST_HEAD(&p->numa_entry);
 	p->numa_group = NULL;
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index ddbf20c..bd2100c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -887,6 +887,11 @@ struct numa_group {
 	struct rcu_head rcu;
 	nodemask_t active_nodes;
 	unsigned long total_faults;
+	/*
+	 * Faults_cpu is used to decide whether memory should move
+	 * towards the CPU. As a consequence, these stats are weighted
+	 * more by CPU use than by memory faults.
+	 */
 	unsigned long *faults_cpu;
 	unsigned long faults[0];
 };
@@ -1451,11 +1456,41 @@ static void update_task_scan_period(struct task_struct *p,
 	memset(p->numa_faults_locality, 0, sizeof(p->numa_faults_locality));
 }
 
+/*
+ * Get the fraction of time the task has been running since the last
+ * NUMA placement cycle. The scheduler keeps similar statistics, but
+ * decays those on a 32ms period, which is orders of magnitude off
+ * from the dozens-of-seconds NUMA balancing period. Use the scheduler
+ * stats only if the task is so new there are no NUMA statistics yet.
+ */
+static u64 numa_get_avg_runtime(struct task_struct *p, u64 *period)
+{
+	u64 runtime, delta, now;
+	/* Use the start of this time slice to avoid calculations. */
+	now = p->se.exec_start;
+	runtime = p->se.sum_exec_runtime;
+
+	if (p->last_task_numa_placement) {
+		delta = runtime - p->last_sum_exec_runtime;
+		*period = now - p->last_task_numa_placement;
+	} else {
+		delta = p->se.avg.runnable_avg_sum;
+		*period = p->se.avg.runnable_avg_period;
+	}
+
+	p->last_sum_exec_runtime = runtime;
+	p->last_task_numa_placement = now;
+
+	return delta;
+}
+
 static void task_numa_placement(struct task_struct *p)
 {
 	int seq, nid, max_nid = -1, max_group_nid = -1;
 	unsigned long max_faults = 0, max_group_faults = 0;
 	unsigned long fault_types[2] = { 0, 0 };
+	unsigned long total_faults;
+	u64 runtime, period;
 	spinlock_t *group_lock = NULL;
 
 	seq = ACCESS_ONCE(p->mm->numa_scan_seq);
@@ -1464,6 +1499,10 @@ static void task_numa_placement(struct task_struct *p)
 	p->numa_scan_seq = seq;
 	p->numa_scan_period_max = task_scan_max(p);
 
+	total_faults = p->numa_faults_locality[0] +
+		       p->numa_faults_locality[1] + 1;
+	runtime = numa_get_avg_runtime(p, &period);
+
 	/* If the task is part of a group prevent parallel updates to group stats */
 	if (p->numa_group) {
 		group_lock = &p->numa_group->lock;
@@ -1476,7 +1515,7 @@ static void task_numa_placement(struct task_struct *p)
 		int priv, i;
 
 		for (priv = 0; priv < 2; priv++) {
-			long diff, f_diff;
+			long diff, f_diff, f_weight;
 
 			i = task_faults_idx(nid, priv);
 			diff = -p->numa_faults_memory[i];
@@ -1488,8 +1527,18 @@ static void task_numa_placement(struct task_struct *p)
 			fault_types[priv] += p->numa_faults_buffer_memory[i];
 			p->numa_faults_buffer_memory[i] = 0;
 
+			/*
+			 * Normalize the faults_from, so all tasks in a group
+			 * count according to CPU use, instead of by the raw
+			 * number of faults. Tasks with little runtime have
+			 * little over-all impact on throughput, and thus their
+			 * faults are less important.
+			 */
+			f_weight = (16384 * runtime *
+				   p->numa_faults_buffer_cpu[i]) /
+				   (total_faults * period + 1);
 			p->numa_faults_cpu[i] >>= 1;
-			p->numa_faults_cpu[i] += p->numa_faults_buffer_cpu[i];
+			p->numa_faults_cpu[i] += f_weight;
 			p->numa_faults_buffer_cpu[i] = 0;
 
 			faults += p->numa_faults_memory[i];
-- 
1.8.4.2

