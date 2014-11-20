Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757825AbaKTR3G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 12:29:06 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:56223 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbaKTR3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 12:29:02 -0500
From: "pang.xunlei" <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Juri Lelli <juri.lelli@gmail.com>,
        "pang.xunlei" <pang.xunlei@linaro.org>
Subject: [PATCH v3 3/3] sched/deadline: Change the return meaning of cpudl_find()
Date: Fri, 21 Nov 2014 01:28:05 +0800
Message-Id: <1416504485-8180-3-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1416504485-8180-1-git-send-email-pang.xunlei@linaro.org>
References: <1416504485-8180-1-git-send-email-pang.xunlei@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpudl_find() is not a good place to select the best cpu, so leave
this role to its call site, currently it is find_later_rq() where
we can do the election of the best cpu according to sd topology.

This patch tackles cpudl_find() using a trick with its return value:
- define macros for the return values of cpudl_find():

then, with return value >=0, means it returns the only available cpu.

- In the leg of "if", it can just return CPUDL_FIND_CPUMASK, as we
want to select the best_cpu in find_later_rq().
In the leg of "else if", just returns cpudl_maximum(cp), apparently
there is no need to set the later_mask, since we will definitely
select this cpu as the best_cpu in find_later_rq() .

- Convert all its call sites to reflect this return meaning change.
Sync find_later_rq()'s processing logic of best cpu election to that
of RT find_lowest_rq().

Additionally, this patch avoids the extra cpumask_set_cpu() operation
in cpudl_find() as well.

Signed-off-by: pang.xunlei <pang.xunlei@linaro.org>
---
 kernel/sched/cpudeadline.c | 16 +++++++---------
 kernel/sched/cpudeadline.h |  3 +++
 kernel/sched/deadline.c    | 17 ++++++++---------
 3 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/kernel/sched/cpudeadline.c b/kernel/sched/cpudeadline.c
index c01b3aa..f17e6af 100644
--- a/kernel/sched/cpudeadline.c
+++ b/kernel/sched/cpudeadline.c
@@ -99,28 +99,26 @@ static inline int cpudl_maximum(struct cpudl *cp)
  * @p: the task
  * @later_mask: a mask to fill in with the selected CPUs (not NULL)
  *
- * Returns: int - best CPU (heap maximum if suitable)
+ * Returns: int
+ * CPUDL_FIND_NONE: no available cpus;
+ * CPUDL_FIND_CPUMASK: available cpus in later_mask
+ * >=0: the only one available 0-based cpu
  */
 int cpudl_find(struct cpudl *cp, struct task_struct *p,
 	       struct cpumask *later_mask)
 {
-	int best_cpu = -1;
 	const struct sched_dl_entity *dl_se = &p->dl;
 
 	cpumask_and(later_mask, cpu_active_mask, &p->cpus_allowed);
 	if (cpumask_and(later_mask, later_mask, cp->free_cpus)) {
-		best_cpu = cpumask_any(later_mask);
-		goto out;
+		return CPUDL_FIND_CPUMASK;
 	} else if (cpumask_test_cpu(cpudl_maximum(cp), &p->cpus_allowed) &&
 			dl_time_before(dl_se->deadline, cp->elements[0].dl)) {
-		best_cpu = cpudl_maximum(cp);
-		cpumask_set_cpu(best_cpu, later_mask);
+		return cpudl_maximum(cp);
 	}
 
-out:
-	WARN_ON(best_cpu != -1 && !cpu_present(best_cpu));
 
-	return best_cpu;
+	return CPUDL_FIND_NONE;
 }
 
 /*
diff --git a/kernel/sched/cpudeadline.h b/kernel/sched/cpudeadline.h
index 4a10a65..235f2b9 100755
--- a/kernel/sched/cpudeadline.h
+++ b/kernel/sched/cpudeadline.h
@@ -3,6 +3,9 @@
 
 #include <linux/sched.h>
 
+#define CPUDL_FIND_NONE      -2  /* no available cpus */
+#define CPUDL_FIND_CPUMASK   -1  /* available cpus in later_mask */
+
 #define IDX_INVALID     -1
 
 struct cpudl_item {
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 03bb3f0..bb37506 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -980,7 +980,7 @@ static void check_preempt_equal_dl(struct rq *rq, struct task_struct *p)
 	 * let's hope p can move out.
 	 */
 	if (rq->curr->nr_cpus_allowed == 1 ||
-	    cpudl_find(&rq->rd->cpudl, rq->curr, later_mask) == -1)
+	    cpudl_find(&rq->rd->cpudl, rq->curr, later_mask) == CPUDL_FIND_NONE)
 		return;
 
 	/*
@@ -988,7 +988,7 @@ static void check_preempt_equal_dl(struct rq *rq, struct task_struct *p)
 	 * see if it is pushed or pulled somewhere else.
 	 */
 	if (p->nr_cpus_allowed != 1 &&
-	    cpudl_find(&rq->rd->cpudl, p, later_mask) != -1)
+	    cpudl_find(&rq->rd->cpudl, p, later_mask) != CPUDL_FIND_NONE)
 		return;
 
 	resched_curr(rq);
@@ -1195,8 +1195,10 @@ static int find_later_rq(struct task_struct *task)
 	 */
 	best_cpu = cpudl_find(&task_rq(task)->rd->cpudl,
 			task, later_mask);
-	if (best_cpu == -1)
+	if (best_cpu == CPUDL_FIND_NONE)
 		return -1;
+	if (best_cpu != CPUDL_FIND_CPUMASK)
+		return best_cpu;
 
 	/*
 	 * If we are here, some target has been found,
@@ -1234,12 +1236,9 @@ static int find_later_rq(struct task_struct *task)
 				return this_cpu;
 			}
 
-			/*
-			 * Last chance: if best_cpu is valid and is
-			 * in the mask, that becomes our choice.
-			 */
-			if (best_cpu < nr_cpu_ids &&
-			    cpumask_test_cpu(best_cpu, sched_domain_span(sd))) {
+			best_cpu = cpumask_first_and(later_mask,
+					sched_domain_span(sd));
+			if (best_cpu < nr_cpu_ids) {
 				rcu_read_unlock();
 				return best_cpu;
 			}
-- 
2.1.0

