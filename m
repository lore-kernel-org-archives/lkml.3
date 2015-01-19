Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792AbbASEwR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 23:52:17 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:39800 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbbASEv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 23:51:57 -0500
From: Xunlei Pang <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@gmail.com>,
        Xunlei Pang <pang.xunlei@linaro.org>
Subject: [PATCH 4/5] sched/rt: Consider deadline tasks in cpupri_find()
Date: Mon, 19 Jan 2015 04:49:39 +0000
Message-Id: <1421642980-10045-4-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1421642980-10045-1-git-send-email-pang.xunlei@linaro.org>
References: <1421642980-10045-1-git-send-email-pang.xunlei@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, RT global scheduling doesn't factor deadline
tasks, this may cause some problems.

See a case below:
On a 3 CPU system, CPU0 has one running deadline task,
CPU1 has one running low priority RT task or idle, CPU3
has one running high priority RT task. When another mid
priority RT task is woken on CPU3, it will be pushed to
CPU0(this also disturbs the deadline task on CPU0), while
it is reasonable to put it on CPU1.

This patch eliminates this issue by filtering CPUs that
have runnable deadline tasks, using cpudl->free_cpus in
cpupri_find().

NOTE: We want to make the most use of percpu local_cpu_mask
to save an extra mask allocation, so always passing a non-NULL
lowest_mask to cpupri_find().

Signed-off-by: Xunlei Pang <pang.xunlei@linaro.org>
---
 kernel/sched/core.c   |  2 ++
 kernel/sched/cpupri.c | 22 +++++-----------------
 kernel/sched/cpupri.h |  1 +
 kernel/sched/rt.c     |  9 +++++----
 4 files changed, 13 insertions(+), 21 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index ade2958..48c9576 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5652,6 +5652,8 @@ static int init_rootdomain(struct root_domain *rd)
 
 	if (cpupri_init(&rd->cpupri) != 0)
 		goto free_rto_mask;
+
+	rd->cpupri.cpudl = &rd->cpudl;
 	return 0;
 
 free_rto_mask:
diff --git a/kernel/sched/cpupri.c b/kernel/sched/cpupri.c
index 981fcd7..40b8e81 100644
--- a/kernel/sched/cpupri.c
+++ b/kernel/sched/cpupri.c
@@ -32,6 +32,7 @@
 #include <linux/sched/rt.h>
 #include <linux/slab.h>
 #include "cpupri.h"
+#include "cpudeadline.h"
 
 /* Convert between a 140 based task->prio, and our 102 based cpupri */
 static int convert_prio(int prio)
@@ -54,7 +55,7 @@ static int convert_prio(int prio)
  * cpupri_find - find the best (lowest-pri) CPU in the system
  * @cp: The cpupri context
  * @p: The task
- * @lowest_mask: A mask to fill in with selected CPUs (or NULL)
+ * @lowest_mask: A mask to fill in with selected CPUs (not NULL)
  *
  * Note: This function returns the recommended CPUs as calculated during the
  * current invocation.  By the time the call returns, the CPUs may have in
@@ -103,24 +104,11 @@ int cpupri_find(struct cpupri *cp, struct task_struct *p,
 		if (skip)
 			continue;
 
-		if (cpumask_any_and(&p->cpus_allowed, vec->mask) >= nr_cpu_ids)
+		cpumask_and(lowest_mask, &p->cpus_allowed, vec->mask);
+		cpumask_and(lowest_mask, lowest_mask, cp->cpudl->free_cpus);
+		if (cpumask_any(lowest_mask) >= nr_cpu_ids)
 			continue;
 
-		if (lowest_mask) {
-			cpumask_and(lowest_mask, &p->cpus_allowed, vec->mask);
-
-			/*
-			 * We have to ensure that we have at least one bit
-			 * still set in the array, since the map could have
-			 * been concurrently emptied between the first and
-			 * second reads of vec->mask.  If we hit this
-			 * condition, simply act as though we never hit this
-			 * priority level and continue on.
-			 */
-			if (cpumask_any(lowest_mask) >= nr_cpu_ids)
-				continue;
-		}
-
 		return 1;
 	}
 
diff --git a/kernel/sched/cpupri.h b/kernel/sched/cpupri.h
index 63cbb9c..acd7ccf 100644
--- a/kernel/sched/cpupri.h
+++ b/kernel/sched/cpupri.h
@@ -18,6 +18,7 @@ struct cpupri_vec {
 struct cpupri {
 	struct cpupri_vec pri_to_cpu[CPUPRI_NR_PRIORITIES];
 	int *cpu_to_pri;
+	struct cpudl *cpudl;
 };
 
 #ifdef CONFIG_SMP
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 6725e3c..d28cfa4 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1349,14 +1349,17 @@ out:
 	return cpu;
 }
 
+static DEFINE_PER_CPU(cpumask_var_t, local_cpu_mask);
 static void check_preempt_equal_prio(struct rq *rq, struct task_struct *p)
 {
+	struct cpumask *lowest_mask = this_cpu_cpumask_var_ptr(local_cpu_mask);
+
 	/*
 	 * Current can't be migrated, useless to reschedule,
 	 * let's hope p can move out.
 	 */
 	if (rq->curr->nr_cpus_allowed == 1 ||
-	    !cpupri_find(&rq->rd->cpupri, rq->curr, NULL))
+	    !cpupri_find(&rq->rd->cpupri, rq->curr, lowest_mask))
 		return;
 
 	/*
@@ -1364,7 +1367,7 @@ static void check_preempt_equal_prio(struct rq *rq, struct task_struct *p)
 	 * see if it is pushed or pulled somewhere else.
 	 */
 	if (p->nr_cpus_allowed != 1
-	    && cpupri_find(&rq->rd->cpupri, p, NULL))
+	    && cpupri_find(&rq->rd->cpupri, p, lowest_mask))
 		return;
 
 	/*
@@ -1526,8 +1529,6 @@ static struct task_struct *pick_highest_pushable_task(struct rq *rq, int cpu)
 	return NULL;
 }
 
-static DEFINE_PER_CPU(cpumask_var_t, local_cpu_mask);
-
 static int find_lowest_rq(struct task_struct *task)
 {
 	struct sched_domain *sd;
-- 
1.9.1

