Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876AbaA1TZt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 14:25:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34389 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755349AbaA1TZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 14:25:45 -0500
Date: Tue, 28 Jan 2014 11:25:00 -0800
From: tip-bot for Rik van Riel <tipbot@zytor.com>
Message-ID: <tip-be1e4e760d940c14d119bffef5eb007dfdf29046@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, riel@redhat.com, chegu_vinod@hp.com,
        mgorman@suse.de, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, riel@redhat.com, chegu_vinod@hp.com,
        mgorman@suse.de, tglx@linutronix.de
In-Reply-To: <1390860228-21539-10-git-send-email-riel@redhat.com>
References: <1390860228-21539-10-git-send-email-riel@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/numa] sched/numa:
  Turn some magic numbers into #defines
Git-Commit-ID: be1e4e760d940c14d119bffef5eb007dfdf29046
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 28 Jan 2014 11:25:06 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  be1e4e760d940c14d119bffef5eb007dfdf29046
Gitweb:     http://git.kernel.org/tip/be1e4e760d940c14d119bffef5eb007dfdf29046
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Mon, 27 Jan 2014 17:03:48 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 Jan 2014 15:03:21 +0100

sched/numa: Turn some magic numbers into #defines

Cleanup suggested by Mel Gorman. Now the code contains some more
hints on what statistics go where.

Suggested-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Chegu Vinod <chegu_vinod@hp.com>
Link: http://lkml.kernel.org/r/1390860228-21539-10-git-send-email-riel@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index d5832c3..1f41b12 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -896,6 +896,15 @@ struct numa_group {
 	unsigned long faults[0];
 };
 
+/* Shared or private faults. */
+#define NR_NUMA_HINT_FAULT_TYPES 2
+
+/* Memory and CPU locality */
+#define NR_NUMA_HINT_FAULT_STATS (NR_NUMA_HINT_FAULT_TYPES * 2)
+
+/* Averaged statistics, and temporary buffers. */
+#define NR_NUMA_HINT_FAULT_BUCKETS (NR_NUMA_HINT_FAULT_STATS * 2)
+
 pid_t task_numa_group_id(struct task_struct *p)
 {
 	return p->numa_group ? p->numa_group->gid : 0;
@@ -903,7 +912,7 @@ pid_t task_numa_group_id(struct task_struct *p)
 
 static inline int task_faults_idx(int nid, int priv)
 {
-	return 2 * nid + priv;
+	return NR_NUMA_HINT_FAULT_TYPES * nid + priv;
 }
 
 static inline unsigned long task_faults(struct task_struct *p, int nid)
@@ -1509,7 +1518,7 @@ static void task_numa_placement(struct task_struct *p)
 		unsigned long faults = 0, group_faults = 0;
 		int priv, i;
 
-		for (priv = 0; priv < 2; priv++) {
+		for (priv = 0; priv < NR_NUMA_HINT_FAULT_TYPES; priv++) {
 			long diff, f_diff, f_weight;
 
 			i = task_faults_idx(nid, priv);
@@ -1620,11 +1629,12 @@ static void task_numa_group(struct task_struct *p, int cpupid, int flags,
 		INIT_LIST_HEAD(&grp->task_list);
 		grp->gid = p->pid;
 		/* Second half of the array tracks nids where faults happen */
-		grp->faults_cpu = grp->faults + 2 * nr_node_ids;
+		grp->faults_cpu = grp->faults + NR_NUMA_HINT_FAULT_TYPES *
+						nr_node_ids;
 
 		node_set(task_node(current), grp->active_nodes);
 
-		for (i = 0; i < 4*nr_node_ids; i++)
+		for (i = 0; i < NR_NUMA_HINT_FAULT_STATS * nr_node_ids; i++)
 			grp->faults[i] = p->numa_faults_memory[i];
 
 		grp->total_faults = p->total_numa_faults;
@@ -1682,7 +1692,7 @@ static void task_numa_group(struct task_struct *p, int cpupid, int flags,
 
 	double_lock(&my_grp->lock, &grp->lock);
 
-	for (i = 0; i < 4*nr_node_ids; i++) {
+	for (i = 0; i < NR_NUMA_HINT_FAULT_STATS * nr_node_ids; i++) {
 		my_grp->faults[i] -= p->numa_faults_memory[i];
 		grp->faults[i] += p->numa_faults_memory[i];
 	}
@@ -1714,7 +1724,7 @@ void task_numa_free(struct task_struct *p)
 
 	if (grp) {
 		spin_lock(&grp->lock);
-		for (i = 0; i < 4*nr_node_ids; i++)
+		for (i = 0; i < NR_NUMA_HINT_FAULT_STATS * nr_node_ids; i++)
 			grp->faults[i] -= p->numa_faults_memory[i];
 		grp->total_faults -= p->total_numa_faults;
 
@@ -1755,14 +1765,20 @@ void task_numa_fault(int last_cpupid, int mem_node, int pages, int flags)
 
 	/* Allocate buffer to track faults on a per-node basis */
 	if (unlikely(!p->numa_faults_memory)) {
-		int size = sizeof(*p->numa_faults_memory) * 4 * nr_node_ids;
+		int size = sizeof(*p->numa_faults_memory) *
+			   NR_NUMA_HINT_FAULT_BUCKETS * nr_node_ids;
 
-		/* numa_faults and numa_faults_buffer share the allocation */
-		p->numa_faults_memory = kzalloc(size * 2, GFP_KERNEL|__GFP_NOWARN);
+		p->numa_faults_memory = kzalloc(size, GFP_KERNEL|__GFP_NOWARN);
 		if (!p->numa_faults_memory)
 			return;
 
 		BUG_ON(p->numa_faults_buffer_memory);
+		/*
+		 * The averaged statistics, shared & private, memory & cpu,
+		 * occupy the first half of the array. The second half of the
+		 * array is for current counters, which are averaged into the
+		 * first set by task_numa_placement.
+		 */
 		p->numa_faults_cpu = p->numa_faults_memory + (2 * nr_node_ids);
 		p->numa_faults_buffer_memory = p->numa_faults_memory + (4 * nr_node_ids);
 		p->numa_faults_buffer_cpu = p->numa_faults_memory + (6 * nr_node_ids);
