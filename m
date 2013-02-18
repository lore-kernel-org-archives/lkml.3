Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201Ab3BRFJj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 00:09:39 -0500
Received: from mga03.intel.com ([143.182.124.21]:23970 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752469Ab3BRFH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 00:07:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,684,1355126400"; 
   d="scan'208";a="258209990"
From: Alex Shi <alex.shi@intel.com>
To: torvalds@linux-foundation.org, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
        bp@alien8.de, pjt@google.com, namhyung@kernel.org, efault@gmx.de
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, alex.shi@intel.com,
        morten.rasmussen@arm.com
Subject: [patch v5 09/15] sched: add power aware scheduling in fork/exec/wake
Date: Mon, 18 Feb 2013 13:07:36 +0800
Message-Id: <1361164062-20111-10-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1361164062-20111-1-git-send-email-alex.shi@intel.com>
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add power aware scheduling in fork/exec/wake. It try to
select cpu from the busiest while still has utilization group. That's
will save power since it leaves more groups idle in system.

The trade off is adding a power aware statistics collection in group
seeking. But since the collection just happened in power scheduling
eligible condition, the worst case of hackbench testing just drops
about 2% with powersaving/balance policy. No clear change for
performance policy.

The main function in this patch is get_cpu_for_power_policy(), that
will try to get a idlest cpu from the busiest while still has
utilization group, if the system is using power aware policy and
has such group.

I had tried to use rq utilisation in this balancing, but since the
utilisation need much time to accumulate itself(345ms). It's bad for
any burst balancing. So I use instant rq utilisation -- nr_running.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c | 129 +++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 123 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 287582b..b172678 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3362,26 +3362,134 @@ struct sg_lb_stats {
 	unsigned int group_utils;	/* sum utilizations of group */
 };
 
+static inline int
+fix_small_capacity(struct sched_domain *sd, struct sched_group *group);
+
+/*
+ * Try to collect the task running number and capacity of the group.
+ */
+static void get_sg_power_stats(struct sched_group *group,
+	struct sched_domain *sd, struct sg_lb_stats *sgs)
+{
+	int i;
+
+	for_each_cpu(i, sched_group_cpus(group)) {
+		struct rq *rq = cpu_rq(i);
+
+		sgs->group_utils += rq->nr_running;
+	}
+
+	sgs->group_capacity = DIV_ROUND_CLOSEST(group->sgp->power,
+						SCHED_POWER_SCALE);
+	if (!sgs->group_capacity)
+		sgs->group_capacity = fix_small_capacity(sd, group);
+	sgs->group_weight = group->group_weight;
+}
+
+/*
+ * Try to collect the task running number and capacity of the domain.
+ */
+static void get_sd_power_stats(struct sched_domain *sd,
+		struct task_struct *p, struct sd_lb_stats *sds)
+{
+	struct sched_group *group;
+	struct sg_lb_stats sgs;
+	int sd_min_delta = INT_MAX;
+	int cpu = task_cpu(p);
+
+	group = sd->groups;
+	do {
+		long g_delta;
+		unsigned long threshold;
+
+		if (!cpumask_test_cpu(cpu, sched_group_mask(group)))
+			continue;
+
+		memset(&sgs, 0, sizeof(sgs));
+		get_sg_power_stats(group, sd, &sgs);
+
+		if (sched_balance_policy == SCHED_POLICY_POWERSAVING)
+			threshold = sgs.group_weight;
+		else
+			threshold = sgs.group_capacity;
+
+		g_delta = threshold - sgs.group_utils;
+
+		if (g_delta > 0 && g_delta < sd_min_delta) {
+			sd_min_delta = g_delta;
+			sds->group_leader = group;
+		}
+
+		sds->sd_utils += sgs.group_utils;
+		sds->total_pwr += group->sgp->power;
+	} while  (group = group->next, group != sd->groups);
+
+	sds->sd_capacity = DIV_ROUND_CLOSEST(sds->total_pwr,
+						SCHED_POWER_SCALE);
+}
+
+/*
+ * Execute power policy if this domain is not full.
+ */
+static inline int get_sd_sched_balance_policy(struct sched_domain *sd,
+	int cpu, struct task_struct *p, struct sd_lb_stats *sds)
+{
+	unsigned long threshold;
+
+	if (sched_balance_policy == SCHED_POLICY_PERFORMANCE)
+		return SCHED_POLICY_PERFORMANCE;
+
+	memset(sds, 0, sizeof(*sds));
+	get_sd_power_stats(sd, p, sds);
+
+	if (sched_balance_policy == SCHED_POLICY_POWERSAVING)
+		threshold = sd->span_weight;
+	else
+		threshold = sds->sd_capacity;
+
+	/* still can hold one more task in this domain */
+	if (sds->sd_utils < threshold)
+		return sched_balance_policy;
+
+	return SCHED_POLICY_PERFORMANCE;
+}
+
+/*
+ * If power policy is eligible for this domain, and it has task allowed cpu.
+ * we will select CPU from this domain.
+ */
+static int get_cpu_for_power_policy(struct sched_domain *sd, int cpu,
+		struct task_struct *p, struct sd_lb_stats *sds)
+{
+	int policy;
+	int new_cpu = -1;
+
+	policy = get_sd_sched_balance_policy(sd, cpu, p, sds);
+	if (policy != SCHED_POLICY_PERFORMANCE && sds->group_leader)
+		new_cpu = find_idlest_cpu(sds->group_leader, p, cpu);
+
+	return new_cpu;
+}
+
 /*
- * sched_balance_self: balance the current task (running on cpu) in domains
+ * select_task_rq_fair: balance the current task (running on cpu) in domains
  * that have the 'flag' flag set. In practice, this is SD_BALANCE_FORK and
  * SD_BALANCE_EXEC.
  *
- * Balance, ie. select the least loaded group.
- *
  * Returns the target CPU number, or the same CPU if no balancing is needed.
  *
  * preempt must be disabled.
  */
 static int
-select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
+select_task_rq_fair(struct task_struct *p, int sd_flag, int flags)
 {
 	struct sched_domain *tmp, *affine_sd = NULL, *sd = NULL;
 	int cpu = smp_processor_id();
 	int prev_cpu = task_cpu(p);
 	int new_cpu = cpu;
 	int want_affine = 0;
-	int sync = wake_flags & WF_SYNC;
+	int sync = flags & WF_SYNC;
+	struct sd_lb_stats sds;
 
 	if (p->nr_cpus_allowed == 1)
 		return prev_cpu;
@@ -3407,11 +3515,20 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 			break;
 		}
 
-		if (tmp->flags & sd_flag)
+		if (tmp->flags & sd_flag) {
 			sd = tmp;
+
+			new_cpu = get_cpu_for_power_policy(sd, cpu, p, &sds);
+			if (new_cpu != -1)
+				goto unlock;
+		}
 	}
 
 	if (affine_sd) {
+		new_cpu = get_cpu_for_power_policy(affine_sd, cpu, p, &sds);
+		if (new_cpu != -1)
+			goto unlock;
+
 		if (cpu != prev_cpu && wake_affine(affine_sd, p, sync))
 			prev_cpu = cpu;
 
-- 
1.7.12

