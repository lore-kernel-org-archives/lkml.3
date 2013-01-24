Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646Ab3AXDJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:09:21 -0500
Received: from mga01.intel.com ([192.55.52.88]:29018 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753436Ab3AXDHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:07:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,525,1355126400"; 
   d="scan'208";a="277725066"
From: Alex Shi <alex.shi@intel.com>
To: torvalds@linux-foundation.org, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
        bp@alien8.de, pjt@google.com, namhyung@kernel.org, efault@gmx.de
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, alex.shi@intel.com
Subject: [patch v4 13/18] sched: packing small tasks in wake/exec balancing
Date: Thu, 24 Jan 2013 11:06:55 +0800
Message-Id: <1358996820-23036-14-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1358996820-23036-1-git-send-email-alex.shi@intel.com>
References: <1358996820-23036-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the waked/execed task is idle enough, it will has the chance to be
packed into a cpu which is busy but still has time to care it.

Morten Rasmussen catch a bug and suggest using different criteria for
different policy, thanks!

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c | 66 ++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 60 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7c7d9db..eede065 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3466,19 +3466,72 @@ static inline int get_sd_sched_policy(struct sched_domain *sd,
 }
 
 /*
+ * find_leader_cpu - find the busiest but still has enough leisure time cpu
+ * among the cpus in group.
+ */
+static int
+find_leader_cpu(struct sched_group *group, struct task_struct *p, int this_cpu,
+		int policy)
+{
+	/* percentage of the task's util */
+	unsigned putil = p->se.avg.runnable_avg_sum * 100
+				/ (p->se.avg.runnable_avg_period + 1);
+
+	struct rq *rq = cpu_rq(this_cpu);
+	int nr_running = rq->nr_running > 0 ? rq->nr_running : 1;
+	int vacancy, min_vacancy = INT_MAX, max_util;
+	int leader_cpu = -1;
+	int i;
+
+	if (policy == SCHED_POLICY_POWERSAVING)
+		max_util = FULL_UTIL;
+	else
+		/* maximum allowable util is 60% */
+		max_util = 60;
+
+	/* bias toward local cpu */
+	if (cpumask_test_cpu(this_cpu, tsk_cpus_allowed(p)) &&
+		max_util - (rq->util * nr_running + (putil << 2)) > 0)
+			return this_cpu;
+
+	/* Traverse only the allowed CPUs */
+	for_each_cpu_and(i, sched_group_cpus(group), tsk_cpus_allowed(p)) {
+		if (i == this_cpu)
+			continue;
+
+		rq = cpu_rq(i);
+		nr_running = rq->nr_running > 0 ? rq->nr_running : 1;
+
+		/* only light task allowed, like putil < 25% for powersaving */
+		vacancy = max_util - (rq->util * nr_running + (putil << 2));
+
+		if (vacancy > 0 && vacancy < min_vacancy) {
+			min_vacancy = vacancy;
+			leader_cpu = i;
+		}
+	}
+	return leader_cpu;
+}
+
+/*
  * If power policy is eligible for this domain, and it has task allowed cpu.
  * we will select CPU from this domain.
  */
 static int get_cpu_for_power_policy(struct sched_domain *sd, int cpu,
-		struct task_struct *p, struct sd_lb_stats *sds)
+		struct task_struct *p, struct sd_lb_stats *sds, int fork)
 {
 	int policy;
 	int new_cpu = -1;
 
 	policy = get_sd_sched_policy(sd, cpu, p, sds);
-	if (policy != SCHED_POLICY_PERFORMANCE && sds->group_leader)
-		new_cpu = find_idlest_cpu(sds->group_leader, p, cpu);
-
+	if (policy != SCHED_POLICY_PERFORMANCE && sds->group_leader) {
+		if (!fork)
+			new_cpu = find_leader_cpu(sds->group_leader,
+							p, cpu, policy);
+		/* for fork balancing and a little busy task */
+		if (new_cpu == -1)
+			new_cpu = find_idlest_cpu(sds->group_leader, p, cpu);
+	}
 	return new_cpu;
 }
 
@@ -3529,14 +3582,15 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int flags)
 		if (tmp->flags & sd_flag) {
 			sd = tmp;
 
-			new_cpu = get_cpu_for_power_policy(sd, cpu, p, &sds);
+			new_cpu = get_cpu_for_power_policy(sd, cpu, p, &sds,
+						flags & SD_BALANCE_FORK);
 			if (new_cpu != -1)
 				goto unlock;
 		}
 	}
 
 	if (affine_sd) {
-		new_cpu = get_cpu_for_power_policy(affine_sd, cpu, p, &sds);
+		new_cpu = get_cpu_for_power_policy(affine_sd, cpu, p, &sds, 0);
 		if (new_cpu != -1)
 			goto unlock;
 
-- 
1.7.12

