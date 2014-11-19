Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134AbaKSPrA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 10:47:00 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:46298 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756065AbaKSPq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 10:46:58 -0500
From: "pang.xunlei" <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Juri Lelli <juri.lelli@gmail.com>,
        "pang.xunlei" <pang.xunlei@linaro.org>
Subject: [PATCH v2 3/4] sched/deadline: add the "set_flag" argument to cpudl_find()
Date: Wed, 19 Nov 2014 23:46:21 +0800
Message-Id: <1416411982-1204-3-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1416411982-1204-1-git-send-email-pang.xunlei@linaro.org>
References: <1416411982-1204-1-git-send-email-pang.xunlei@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The call site of cpudl_find() in check_preempt_equal_dl() doesn't
use later_mask, so add this extra argument to distinquish the case.

Signed-off-by: pang.xunlei <pang.xunlei@linaro.org>
---
 kernel/sched/cpudeadline.c |    6 ++++--
 kernel/sched/cpudeadline.h |    2 +-
 kernel/sched/deadline.c    |    6 +++---
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/cpudeadline.c b/kernel/sched/cpudeadline.c
index c01b3aa..3047846 100644
--- a/kernel/sched/cpudeadline.c
+++ b/kernel/sched/cpudeadline.c
@@ -98,11 +98,12 @@ static inline int cpudl_maximum(struct cpudl *cp)
  * @cp: the cpudl max-heap context
  * @p: the task
  * @later_mask: a mask to fill in with the selected CPUs (not NULL)
+ * @set_flag: indicate if later_mask should be set
  *
  * Returns: int - best CPU (heap maximum if suitable)
  */
 int cpudl_find(struct cpudl *cp, struct task_struct *p,
-	       struct cpumask *later_mask)
+	       struct cpumask *later_mask, int set_flag)
 {
 	int best_cpu = -1;
 	const struct sched_dl_entity *dl_se = &p->dl;
@@ -114,7 +115,8 @@ int cpudl_find(struct cpudl *cp, struct task_struct *p,
 	} else if (cpumask_test_cpu(cpudl_maximum(cp), &p->cpus_allowed) &&
 			dl_time_before(dl_se->deadline, cp->elements[0].dl)) {
 		best_cpu = cpudl_maximum(cp);
-		cpumask_set_cpu(best_cpu, later_mask);
+		if (set_flag)
+			cpumask_set_cpu(best_cpu, later_mask);
 	}
 
 out:
diff --git a/kernel/sched/cpudeadline.h b/kernel/sched/cpudeadline.h
index 4a10a65..a3a85e8 100644
--- a/kernel/sched/cpudeadline.h
+++ b/kernel/sched/cpudeadline.h
@@ -22,7 +22,7 @@ struct cpudl {
 #ifdef CONFIG_SMP
 int cpudl_find(struct cpudl *cp, struct task_struct *p,
 	       struct cpumask *later_mask);
-void cpudl_set(struct cpudl *cp, int cpu, u64 dl, int is_valid);
+void cpudl_set(struct cpudl *cp, int cpu, u64 dl, int is_valid, int set_flag);
 int cpudl_init(struct cpudl *cp);
 void cpudl_set_freecpu(struct cpudl *cp, int cpu);
 void cpudl_cleanup(struct cpudl *cp);
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 3ecf838..e8208d0 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -976,7 +976,7 @@ static void check_preempt_equal_dl(struct rq *rq, struct task_struct *p)
 	 * let's hope p can move out.
 	 */
 	if (rq->curr->nr_cpus_allowed == 1 ||
-	    cpudl_find(&rq->rd->cpudl, rq->curr, later_mask) == -1)
+	    cpudl_find(&rq->rd->cpudl, rq->curr, later_mask, 0) == -1)
 		return;
 
 	/*
@@ -984,7 +984,7 @@ static void check_preempt_equal_dl(struct rq *rq, struct task_struct *p)
 	 * see if it is pushed or pulled somewhere else.
 	 */
 	if (p->nr_cpus_allowed != 1 &&
-	    cpudl_find(&rq->rd->cpudl, p, later_mask) != -1)
+	    cpudl_find(&rq->rd->cpudl, p, later_mask, 0) != -1)
 		return;
 
 	resched_curr(rq);
@@ -1190,7 +1190,7 @@ static int find_later_rq(struct task_struct *task)
 	 * first, then we can look for a suitable cpu.
 	 */
 	best_cpu = cpudl_find(&task_rq(task)->rd->cpudl,
-			task, later_mask);
+			task, later_mask, 1);
 	if (best_cpu == -1)
 		return -1;
 
-- 
1.7.9.5

