Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622AbaATTW0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 14:22:26 -0500
Received: from shelob.surriel.com ([74.92.59.67]:39501 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbaATTV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 14:21:26 -0500
From: riel@redhat.com
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, peterz@infradead.org, mgorman@suse.de,
        mingo@redhat.com, chegu_vinod@hp.com
Subject: [PATCH 5/6] numa,sched: normalize faults_from stats and weigh by CPU use
Date: Mon, 20 Jan 2014 14:21:06 -0500
Message-Id: <1390245667-24193-6-git-send-email-riel@redhat.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1390245667-24193-1-git-send-email-riel@redhat.com>
References: <1390245667-24193-1-git-send-email-riel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

The tracepoint has made it abundantly clear that the naive
implementation of the faults_from code has issues.

Specifically, the garbage collector in some workloads will
access orders of magnitudes more memory than the threads
that do all the active work. This resulted in the node with
the garbage collector being marked the only active node in
the group.

This issue is avoided if we weigh the statistics by CPU use
of each task in the numa group, instead of by how many faults
each thread has occurred.

To achieve this, we normalize the number of faults to the
fraction of faults that occurred on each node, and then
multiply that fraction by the fraction of CPU time the
task has used since the last time task_numa_placement was
invoked.

This way the nodes in the active node mask will be the ones
where the tasks from the numa group are most actively running,
and the influence of eg. the garbage collector and other
do-little threads is properly minimized.

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Chegu Vinod <chegu_vinod@hp.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
---
 kernel/sched/fair.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index ea873b6..203877d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1426,6 +1426,8 @@ static void task_numa_placement(struct task_struct *p)
 	int seq, nid, max_nid = -1, max_group_nid = -1;
 	unsigned long max_faults = 0, max_group_faults = 0;
 	unsigned long fault_types[2] = { 0, 0 };
+	unsigned long total_faults;
+	u64 runtime, period;
 	spinlock_t *group_lock = NULL;
 
 	seq = ACCESS_ONCE(p->mm->numa_scan_seq);
@@ -1434,6 +1436,11 @@ static void task_numa_placement(struct task_struct *p)
 	p->numa_scan_seq = seq;
 	p->numa_scan_period_max = task_scan_max(p);
 
+	total_faults = p->numa_faults_locality[0] +
+		       p->numa_faults_locality[1] + 1;
+	runtime = p->se.avg.runnable_avg_sum;
+	period = p->se.avg.runnable_avg_period;
+
 	/* If the task is part of a group prevent parallel updates to group stats */
 	if (p->numa_group) {
 		group_lock = &p->numa_group->lock;
@@ -1446,7 +1453,7 @@ static void task_numa_placement(struct task_struct *p)
 		int priv, i;
 
 		for (priv = 0; priv < 2; priv++) {
-			long diff, f_diff;
+			long diff, f_diff, f_weight;
 
 			i = task_faults_idx(nid, priv);
 			diff = -p->numa_faults[i];
@@ -1458,8 +1465,18 @@ static void task_numa_placement(struct task_struct *p)
 			fault_types[priv] += p->numa_faults_buffer[i];
 			p->numa_faults_buffer[i] = 0;
 
+			/*
+			 * Normalize the faults_from, so all tasks in a group
+			 * count according to CPU use, instead of by the raw
+			 * number of faults. Tasks with little runtime have
+			 * little over-all impact on throughput, and thus their
+			 * faults are less important.
+			 */
+			f_weight = (16384 * runtime *
+				   p->numa_faults_from_buffer[i]) /
+				   (total_faults * period + 1);
 			p->numa_faults_from[i] >>= 1;
-			p->numa_faults_from[i] += p->numa_faults_from_buffer[i];
+			p->numa_faults_from[i] += f_weight;
 			p->numa_faults_from_buffer[i] = 0;
 
 			faults += p->numa_faults[i];
-- 
1.8.4.2

