Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500AbaKEPtF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 10:49:05 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:42231 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183AbaKEPtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 10:49:02 -0500
From: "pang.xunlei" <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Juri Lelli <juri.lelli@gmail.com>,
        "pang.xunlei" <pang.xunlei@linaro.org>
Subject: [PATCH v3 4/7] sched/deadline: Fix several problems with cpudl_find()
Date: Wed,  5 Nov 2014 23:48:23 +0800
Message-Id: <1415202506-7800-4-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1415202506-7800-1-git-send-email-pang.xunlei@linaro.org>
References: <1415202506-7800-1-git-send-email-pang.xunlei@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpudl_find() has some problems:

1)in check_preempt_equal_dl(), called with NULL later_mask, thus
cpudl_find() doesn't check cpudl.free_cpus at all.

2)Also, the whole system isn't always overloaded with many DL tasks
in which cases all the cpu may have a DL task running, so it may
return the best cpu, because we only return the first maximum deadline
cpu(is there a need to iterate the same deadline value to find more
different cpus if possible?).
So it may be reasonable to change the return value of cpudl_find()
to a bool type, because it isn't always the best cpu actually which
can be better determined in find_later_rq() via sched_domain topology.

3)in the "else if" branch, uses cpus_allowed to test again.

This patch syncs the logic in a former patch by "Juri Lelli", then
problem 1) will be solved naturally, and modifies cpudl_find() and
all its call sites to address these problems.

The former patch by "Juri Lelli" is:
"sched/deadline: Fix inter- exclusive cpusets migrations"

Signed-off-by: pang.xunlei <pang.xunlei@linaro.org>
---
 kernel/sched/cpudeadline.c | 29 ++++++++++++++---------------
 kernel/sched/cpudeadline.h |  2 +-
 kernel/sched/deadline.c    | 45 ++++++++++++++++++++++++++-------------------
 3 files changed, 41 insertions(+), 35 deletions(-)

diff --git a/kernel/sched/cpudeadline.c b/kernel/sched/cpudeadline.c
index 539ca3c..72a3da3 100644
--- a/kernel/sched/cpudeadline.c
+++ b/kernel/sched/cpudeadline.c
@@ -97,30 +97,29 @@ static inline int cpudl_maximum(struct cpudl *cp)
  * cpudl_find - find the best (later-dl) CPU in the system
  * @cp: the cpudl max-heap context
  * @p: the task
- * @later_mask: a mask to fill in with the selected CPUs (or NULL)
+ * @later_mask: a mask used to filter cpus, also used to fill
+ *     in with the selected CPUs if set_flag is set. Not NULL.
+ * @set_flag: a flag to determine if should set the later_mask.
  *
- * Returns: int - best CPU (heap maximum if suitable)
+ * Returns: (int)bool - CPUs were found
  */
 int cpudl_find(struct cpudl *cp, struct task_struct *p,
-	       struct cpumask *later_mask)
+	       struct cpumask *later_mask, int set_flag)
 {
-	int best_cpu = -1;
+	struct cpumask tmp_mask;
 	const struct sched_dl_entity *dl_se = &p->dl;
 
-	if (later_mask && cpumask_and(later_mask, later_mask, cp->free_cpus)) {
-		best_cpu = cpumask_any(later_mask);
-		goto out;
-	} else if (cpumask_test_cpu(cpudl_maximum(cp), &p->cpus_allowed) &&
+
+	if (cpumask_and(&tmp_mask, later_mask, cp->free_cpus)) {
+		if (set_flag)
+			cpumask_copy(later_mask, &tmp_mask);
+		return 1;
+	} else if (cpumask_and(later_mask, later_mask, cpumask_of(cpudl_maximum(cp))) &&
 			dl_time_before(dl_se->deadline, cp->elements[0].dl)) {
-		best_cpu = cpudl_maximum(cp);
-		if (later_mask)
-			cpumask_set_cpu(best_cpu, later_mask);
+		return 1;
 	}
 
-out:
-	WARN_ON(best_cpu != -1 && !cpu_present(best_cpu));
-
-	return best_cpu;
+	return 0;
 }
 
 /*
diff --git a/kernel/sched/cpudeadline.h b/kernel/sched/cpudeadline.h
index 538c979..0c9636e 100644
--- a/kernel/sched/cpudeadline.h
+++ b/kernel/sched/cpudeadline.h
@@ -21,7 +21,7 @@ struct cpudl {
 
 #ifdef CONFIG_SMP
 int cpudl_find(struct cpudl *cp, struct task_struct *p,
-	       struct cpumask *later_mask);
+	       struct cpumask *later_mask, int set_flag);
 void cpudl_set(struct cpudl *cp, int cpu, u64 dl, int is_valid);
 int cpudl_init(struct cpudl *cp);
 void cpudl_cleanup(struct cpudl *cp);
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 256e577..42edfcd 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -946,23 +946,34 @@ out:
 	return cpu;
 }
 
+static DEFINE_PER_CPU(cpumask_var_t, local_cpu_mask_dl);
+
 static void check_preempt_equal_dl(struct rq *rq, struct task_struct *p)
 {
+	struct cpumask *later_mask = this_cpu_cpumask_var_ptr(local_cpu_mask_dl);
+
 	/*
 	 * Current can't be migrated, useless to reschedule,
 	 * let's hope p can move out.
 	 */
-	if (rq->curr->nr_cpus_allowed == 1 ||
-	    cpudl_find(&rq->rd->cpudl, rq->curr, NULL) == -1)
+	if (rq->curr->nr_cpus_allowed == 1)
+		return;
+
+	cpumask_and(later_mask, rq->rd->span, cpu_active_mask);
+	cpumask_and(later_mask, later_mask, &rq->curr->cpus_allowed);
+	if (!cpudl_find(&rq->rd->cpudl, rq->curr, later_mask, 0))
 		return;
 
 	/*
 	 * p is migratable, so let's not schedule it and
 	 * see if it is pushed or pulled somewhere else.
 	 */
-	if (p->nr_cpus_allowed != 1 &&
-	    cpudl_find(&rq->rd->cpudl, p, NULL) != -1)
-		return;
+	if (p->nr_cpus_allowed != 1) {
+		cpumask_and(later_mask, rq->rd->span, cpu_active_mask);
+		cpumask_and(later_mask, later_mask, &p->cpus_allowed);
+		if (cpudl_find(&rq->rd->cpudl, p, later_mask, 0))
+			return;
+	}
 
 	resched_curr(rq);
 }
@@ -1148,14 +1159,12 @@ next_node:
 	return NULL;
 }
 
-static DEFINE_PER_CPU(cpumask_var_t, local_cpu_mask_dl);
-
 static int find_later_rq(struct task_struct *task)
 {
 	struct sched_domain *sd;
 	struct cpumask *later_mask = this_cpu_cpumask_var_ptr(local_cpu_mask_dl);
 	int this_cpu = smp_processor_id();
-	int best_cpu, cpu = task_cpu(task);
+	int cpu = task_cpu(task);
 
 	/* Make sure the mask is initialized first */
 	if (unlikely(!later_mask))
@@ -1168,14 +1177,14 @@ static int find_later_rq(struct task_struct *task)
 	 * We have to consider system topology and task affinity
 	 * first, then we can look for a suitable cpu.
 	 */
-	cpumask_copy(later_mask, task_rq(task)->rd->span);
-	cpumask_and(later_mask, later_mask, cpu_active_mask);
+	cpumask_and(later_mask, task_rq(task)->rd->span, cpu_active_mask);
 	cpumask_and(later_mask, later_mask, &task->cpus_allowed);
-	best_cpu = cpudl_find(&task_rq(task)->rd->cpudl,
-			task, later_mask);
-	if (best_cpu == -1)
+	if (!cpudl_find(&task_rq(task)->rd->cpudl, task, later_mask, 1))
 		return -1;
 
+	if (cpumask_weight(later_mask) == 1)
+		return cpumask_any(later_mask);
+
 	/*
 	 * If we are here, some target has been found,
 	 * the most suitable of which is cached in best_cpu.
@@ -1200,6 +1209,7 @@ static int find_later_rq(struct task_struct *task)
 
 	rcu_read_lock();
 	for_each_domain(cpu, sd) {
+		int best_cpu;
 		if (sd->flags & SD_WAKE_AFFINE) {
 
 			/*
@@ -1212,12 +1222,9 @@ static int find_later_rq(struct task_struct *task)
 				return this_cpu;
 			}
 
-			/*
-			 * Last chance: if best_cpu is valid and is
-			 * in the mask, that becomes our choice.
-			 */
-			if (best_cpu < nr_cpu_ids &&
-			    cpumask_test_cpu(best_cpu, sched_domain_span(sd))) {
+			best_cpu = cpumask_first_and(later_mask,
+								sched_domain_span(sd));
+			if (best_cpu < nr_cpu_ids) {
 				rcu_read_unlock();
 				return best_cpu;
 			}
-- 
2.1.0

