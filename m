Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150AbaKSPrG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 10:47:06 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:59469 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756065AbaKSPrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 10:47:03 -0500
From: "pang.xunlei" <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Juri Lelli <juri.lelli@gmail.com>,
        "pang.xunlei" <pang.xunlei@linaro.org>
Subject: [PATCH v2 4/4] sched/deadline: change cpudl_find() to return bool instead of best_cpu
Date: Wed, 19 Nov 2014 23:46:22 +0800
Message-Id: <1416411982-1204-4-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1416411982-1204-1-git-send-email-pang.xunlei@linaro.org>
References: <1416411982-1204-1-git-send-email-pang.xunlei@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpudl_find() is not a good place to select the best cpu, so leave
this role to its call site, currently it is find_later_rq() where
we can do the election of the best cpu according to sd topology.

Signed-off-by: pang.xunlei <pang.xunlei@linaro.org>
---
 kernel/sched/cpudeadline.c |   15 +++++----------
 kernel/sched/deadline.c    |   17 ++++++-----------
 2 files changed, 11 insertions(+), 21 deletions(-)

diff --git a/kernel/sched/cpudeadline.c b/kernel/sched/cpudeadline.c
index 3047846..41d3578 100644
--- a/kernel/sched/cpudeadline.c
+++ b/kernel/sched/cpudeadline.c
@@ -100,29 +100,24 @@ static inline int cpudl_maximum(struct cpudl *cp)
  * @later_mask: a mask to fill in with the selected CPUs (not NULL)
  * @set_flag: indicate if later_mask should be set
  *
- * Returns: int - best CPU (heap maximum if suitable)
+ * Return: (int)bool - CPUs were found
  */
 int cpudl_find(struct cpudl *cp, struct task_struct *p,
 	       struct cpumask *later_mask, int set_flag)
 {
-	int best_cpu = -1;
 	const struct sched_dl_entity *dl_se = &p->dl;
 
 	cpumask_and(later_mask, cpu_active_mask, &p->cpus_allowed);
 	if (cpumask_and(later_mask, later_mask, cp->free_cpus)) {
-		best_cpu = cpumask_any(later_mask);
-		goto out;
+		return 1;
 	} else if (cpumask_test_cpu(cpudl_maximum(cp), &p->cpus_allowed) &&
 			dl_time_before(dl_se->deadline, cp->elements[0].dl)) {
-		best_cpu = cpudl_maximum(cp);
 		if (set_flag)
-			cpumask_set_cpu(best_cpu, later_mask);
+			cpumask_set_cpu(cpudl_maximum(cp), later_mask);
+		return 1;
 	}
 
-out:
-	WARN_ON(best_cpu != -1 && !cpu_present(best_cpu));
-
-	return best_cpu;
+	return 0;
 }
 
 /*
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index e8208d0..3e82cf3 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -976,7 +976,7 @@ static void check_preempt_equal_dl(struct rq *rq, struct task_struct *p)
 	 * let's hope p can move out.
 	 */
 	if (rq->curr->nr_cpus_allowed == 1 ||
-	    cpudl_find(&rq->rd->cpudl, rq->curr, later_mask, 0) == -1)
+	    !cpudl_find(&rq->rd->cpudl, rq->curr, later_mask, 0))
 		return;
 
 	/*
@@ -984,7 +984,7 @@ static void check_preempt_equal_dl(struct rq *rq, struct task_struct *p)
 	 * see if it is pushed or pulled somewhere else.
 	 */
 	if (p->nr_cpus_allowed != 1 &&
-	    cpudl_find(&rq->rd->cpudl, p, later_mask, 0) != -1)
+	    cpudl_find(&rq->rd->cpudl, p, later_mask, 0))
 		return;
 
 	resched_curr(rq);
@@ -1189,9 +1189,7 @@ static int find_later_rq(struct task_struct *task)
 	 * We have to consider system topology and task affinity
 	 * first, then we can look for a suitable cpu.
 	 */
-	best_cpu = cpudl_find(&task_rq(task)->rd->cpudl,
-			task, later_mask, 1);
-	if (best_cpu == -1)
+	if (!cpudl_find(&task_rq(task)->rd->cpudl, task, later_mask, 1))
 		return -1;
 
 	/*
@@ -1230,12 +1228,9 @@ static int find_later_rq(struct task_struct *task)
 				return this_cpu;
 			}
 
-			/*
-			 * Last chance: if best_cpu is valid and is
-			 * in the mask, that becomes our choice.
-			 */
-			if (best_cpu < nr_cpu_ids &&
-			    cpumask_test_cpu(best_cpu, sched_domain_span(sd))) {
+			best_cpu = cpumask_first_and(lowest_mask,
+						sched_domain_span(sd));
+			if (best_cpu < nr_cpu_ids) {
 				rcu_read_unlock();
 				return best_cpu;
 			}
-- 
1.7.9.5

