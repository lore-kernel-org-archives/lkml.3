Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932826Ab3DDCCe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 22:02:34 -0400
Received: from mga03.intel.com ([143.182.124.21]:29688 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932785Ab3DDCC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 22:02:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,404,1363158000"; 
   d="scan'208";a="280534405"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        morten.rasmussen@arm.com
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, alex.shi@intel.com, len.brown@intel.com,
        rafael.j.wysocki@intel.com, jkosina@suse.cz, clark.williams@gmail.com,
        tony.luck@intel.com, keescook@chromium.org, mgorman@suse.de,
        riel@redhat.com
Subject: [patch v7 10/21] sched: add power aware scheduling in fork/exec/wake
Date: Thu,  4 Apr 2013 10:00:51 +0800
Message-Id: <1365040862-8390-11-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1365040862-8390-1-git-send-email-alex.shi@intel.com>
References: <1365040862-8390-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add power aware scheduling in fork/exec/wake. It try to
select cpu from the busiest while still has utilization group. That's
will save power since it leaves more groups idle in system.

The trade off is adding a power aware statistics collection in group
seeking. But since the collection just happened in power scheduling
eligible condition, the worst case of hackbench testing just drops
about 2% with powersaving policy. No clear change for performance
policy.

The main function in this patch is get_cpu_for_power_policy(), that
will try to get a idlest cpu from the busiest while still has
utilization group, if the system is using power aware policy and
has such group.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c | 109 +++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 103 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 70a99c9..0c08773 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3372,25 +3372,113 @@ static unsigned int max_rq_util(int cpu)
 }
 
 /*
- * sched_balance_self: balance the current task (running on cpu) in domains
+ * Try to collect the task running number and capacity of the group.
+ */
+static void get_sg_power_stats(struct sched_group *group,
+	struct sched_domain *sd, struct sg_lb_stats *sgs)
+{
+	int i;
+
+	for_each_cpu(i, sched_group_cpus(group))
+		sgs->group_util += max_rq_util(i);
+
+	sgs->group_weight = group->group_weight;
+}
+
+/*
+ * Is this domain full of utilization with the task?
+ */
+static int is_sd_full(struct sched_domain *sd,
+		struct task_struct *p, struct sd_lb_stats *sds)
+{
+	struct sched_group *group;
+	struct sg_lb_stats sgs;
+	long sd_min_delta = LONG_MAX;
+	unsigned int putil;
+
+	if (p->se.load.weight == p->se.avg.load_avg_contrib)
+		/* p maybe a new forked task */
+		putil = FULL_UTIL;
+	else
+		putil = (u64)(p->se.avg.runnable_avg_sum << SCHED_POWER_SHIFT)
+				/ (p->se.avg.runnable_avg_period + 1);
+
+	/* Try to collect the domain's utilization */
+	group = sd->groups;
+	do {
+		long g_delta;
+
+		memset(&sgs, 0, sizeof(sgs));
+		get_sg_power_stats(group, sd, &sgs);
+
+		g_delta = sgs.group_weight * FULL_UTIL - sgs.group_util;
+
+		if (g_delta > 0 && g_delta < sd_min_delta) {
+			sd_min_delta = g_delta;
+			sds->group_leader = group;
+		}
+
+		sds->sd_util += sgs.group_util;
+	} while  (group = group->next, group != sd->groups);
+
+	if (sds->sd_util + putil < sd->span_weight * FULL_UTIL)
+		return 0;
+
+	/* can not hold one more task in this domain */
+	return 1;
+}
+
+/*
+ * Execute power policy if this domain is not full.
+ */
+static inline int get_sd_sched_balance_policy(struct sched_domain *sd,
+	int cpu, struct task_struct *p, struct sd_lb_stats *sds)
+{
+	if (sched_balance_policy == SCHED_POLICY_PERFORMANCE)
+		return SCHED_POLICY_PERFORMANCE;
+
+	memset(sds, 0, sizeof(*sds));
+	if (is_sd_full(sd, p, sds))
+		return SCHED_POLICY_PERFORMANCE;
+	return sched_balance_policy;
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
+/*
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
@@ -3416,11 +3504,20 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
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

