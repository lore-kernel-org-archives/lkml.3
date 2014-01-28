Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830AbaA1TZM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 14:25:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34357 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755816AbaA1TZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 14:25:07 -0500
Date: Tue, 28 Jan 2014 11:24:26 -0800
From: tip-bot for Rik van Riel <tipbot@zytor.com>
Message-ID: <tip-7e2703e6099609adc93679c4d45cd6247f565971@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, riel@redhat.com, chegu_vinod@hp.com,
        mgorman@suse.de, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, riel@redhat.com, chegu_vinod@hp.com,
        mgorman@suse.de, tglx@linutronix.de
In-Reply-To: <1390860228-21539-7-git-send-email-riel@redhat.com>
References: <1390860228-21539-7-git-send-email-riel@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/numa] sched/numa:
  Normalize faults_cpu stats and weigh by CPU use
Git-Commit-ID: 7e2703e6099609adc93679c4d45cd6247f565971
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 28 Jan 2014 11:24:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7e2703e6099609adc93679c4d45cd6247f565971
Gitweb:     http://git.kernel.org/tip/7e2703e6099609adc93679c4d45cd6247f565971
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Mon, 27 Jan 2014 17:03:45 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 Jan 2014 15:03:10 +0100

sched/numa: Normalize faults_cpu stats and weigh by CPU use

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

Signed-off-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Chegu Vinod <chegu_vinod@hp.com>
Link: http://lkml.kernel.org/r/1390860228-21539-7-git-send-email-riel@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched.h |  2 ++
 kernel/sched/core.c   |  2 ++
 kernel/sched/fair.c   | 53 +++++++++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 55 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5ab3b89..ef92953 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1459,6 +1459,8 @@ struct task_struct {
 	int numa_preferred_nid;
 	unsigned long numa_migrate_retry;
 	u64 node_stamp;			/* migration stamp  */
+	u64 last_task_numa_placement;
+	u64 last_sum_exec_runtime;
 	struct callback_head numa_work;
 
 	struct list_head numa_entry;
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index bc708c5..a561c9e 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1746,6 +1746,8 @@ static void __sched_fork(unsigned long clone_flags, struct task_struct *p)
 	p->numa_work.next = &p->numa_work;
 	p->numa_faults_memory = NULL;
 	p->numa_faults_buffer_memory = NULL;
+	p->last_task_numa_placement = 0;
+	p->last_sum_exec_runtime = 0;
 
 	INIT_LIST_HEAD(&p->numa_entry);
 	p->numa_group = NULL;
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index eeabb33..8fc3a82 100644
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
@@ -1446,11 +1451,41 @@ static void update_task_scan_period(struct task_struct *p,
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
@@ -1459,6 +1494,10 @@ static void task_numa_placement(struct task_struct *p)
 	p->numa_scan_seq = seq;
 	p->numa_scan_period_max = task_scan_max(p);
 
+	total_faults = p->numa_faults_locality[0] +
+		       p->numa_faults_locality[1];
+	runtime = numa_get_avg_runtime(p, &period);
+
 	/* If the task is part of a group prevent parallel updates to group stats */
 	if (p->numa_group) {
 		group_lock = &p->numa_group->lock;
@@ -1471,7 +1510,7 @@ static void task_numa_placement(struct task_struct *p)
 		int priv, i;
 
 		for (priv = 0; priv < 2; priv++) {
-			long diff, f_diff;
+			long diff, f_diff, f_weight;
 
 			i = task_faults_idx(nid, priv);
 			diff = -p->numa_faults_memory[i];
@@ -1483,8 +1522,18 @@ static void task_numa_placement(struct task_struct *p)
 			fault_types[priv] += p->numa_faults_buffer_memory[i];
 			p->numa_faults_buffer_memory[i] = 0;
 
+			/*
+			 * Normalize the faults_from, so all tasks in a group
+			 * count according to CPU use, instead of by the raw
+			 * number of faults. Tasks with little runtime have
+			 * little over-all impact on throughput, and thus their
+			 * faults are less important.
+			 */
+			f_weight = div64_u64(runtime << 16, period + 1);
+			f_weight = (f_weight * p->numa_faults_buffer_cpu[i]) /
+				   (total_faults + 1);
 			p->numa_faults_cpu[i] >>= 1;
-			p->numa_faults_cpu[i] += p->numa_faults_buffer_cpu[i];
+			p->numa_faults_cpu[i] += f_weight;
 			p->numa_faults_buffer_cpu[i] = 0;
 
 			faults += p->numa_faults_memory[i];
