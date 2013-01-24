Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab3AXDJc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:09:32 -0500
Received: from mga01.intel.com ([192.55.52.88]:7626 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753405Ab3AXDHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:07:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,525,1355126400"; 
   d="scan'208";a="277725060"
From: Alex Shi <alex.shi@intel.com>
To: torvalds@linux-foundation.org, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
        bp@alien8.de, pjt@google.com, namhyung@kernel.org, efault@gmx.de
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, alex.shi@intel.com
Subject: [patch v4 12/18] sched: add power aware scheduling in fork/exec/wake
Date: Thu, 24 Jan 2013 11:06:54 +0800
Message-Id: <1358996820-23036-13-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1358996820-23036-1-git-send-email-alex.shi@intel.com>
References: <1358996820-23036-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add power aware scheduling in fork/exec/wake. It try to
select cpu from the busiest while still has utilization group. That's
will save power for other groups.

The trade off is adding a power aware statistics collection in group
seeking. But since the collection just happened in power scheduling
eligible condition, the worst case of hackbench testing just drops
about 2% with powersaving/balance policy. No clear change for
performance policy.

I had tried to use rq utilisation in this balancing, but since the
utilisation need much time to accumulate itself(345ms). It's bad for
any burst balancing. So I use instant rq utilisation -- nr_running.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c | 230 ++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 179 insertions(+), 51 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 20363fb..7c7d9db 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3318,25 +3318,189 @@ done:
 }
 
 /*
- * sched_balance_self: balance the current task (running on cpu) in domains
+ * sd_lb_stats - Structure to store the statistics of a sched_domain
+ *		during load balancing.
+ */
+struct sd_lb_stats {
+	struct sched_group *busiest; /* Busiest group in this sd */
+	struct sched_group *this;  /* Local group in this sd */
+	unsigned long total_load;  /* Total load of all groups in sd */
+	unsigned long total_pwr;   /*	Total power of all groups in sd */
+	unsigned long avg_load;	   /* Average load across all groups in sd */
+
+	/** Statistics of this group */
+	unsigned long this_load;
+	unsigned long this_load_per_task;
+	unsigned long this_nr_running;
+	unsigned int  this_has_capacity;
+	unsigned int  this_idle_cpus;
+
+	/* Statistics of the busiest group */
+	unsigned int  busiest_idle_cpus;
+	unsigned long max_load;
+	unsigned long busiest_load_per_task;
+	unsigned long busiest_nr_running;
+	unsigned long busiest_group_capacity;
+	unsigned int  busiest_has_capacity;
+	unsigned int  busiest_group_weight;
+
+	int group_imb; /* Is there imbalance in this sd */
+
+	/* Varibles of power awaring scheduling */
+	unsigned int  sd_utils;	/* sum utilizations of this domain */
+	unsigned long sd_capacity;	/* capacity of this domain */
+	struct sched_group *group_leader; /* Group which relieves group_min */
+	unsigned long min_load_per_task; /* load_per_task in group_min */
+	unsigned int  leader_util;	/* sum utilizations of group_leader */
+	unsigned int  min_util;		/* sum utilizations of group_min */
+};
+
+/*
+ * sg_lb_stats - stats of a sched_group required for load_balancing
+ */
+struct sg_lb_stats {
+	unsigned long avg_load; /*Avg load across the CPUs of the group */
+	unsigned long group_load; /* Total load over the CPUs of the group */
+	unsigned long sum_nr_running; /* Nr tasks running in the group */
+	unsigned long sum_weighted_load; /* Weighted load of group's tasks */
+	unsigned long group_capacity;
+	unsigned long idle_cpus;
+	unsigned long group_weight;
+	int group_imb; /* Is there an imbalance in the group ? */
+	int group_has_capacity; /* Is there extra capacity in the group? */
+	unsigned int group_utils;	/* sum utilizations of group */
+
+	unsigned long sum_shared_running;	/* 0 on non-NUMA */
+};
+
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
+ * Try to collect the task running number and capacity of the doamin.
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
+		if (sched_policy == SCHED_POLICY_POWERSAVING)
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
+static inline int get_sd_sched_policy(struct sched_domain *sd,
+	int cpu, struct task_struct *p, struct sd_lb_stats *sds)
+{
+	unsigned long threshold;
+
+	if (sched_policy == SCHED_POLICY_PERFORMANCE)
+		return SCHED_POLICY_PERFORMANCE;
+
+	memset(sds, 0, sizeof(*sds));
+	get_sd_power_stats(sd, p, sds);
+
+	if (sched_policy == SCHED_POLICY_POWERSAVING)
+		threshold = sd->span_weight;
+	else
+		threshold = sds->sd_capacity;
+
+	/* still can hold one more task in this domain */
+	if (sds->sd_utils < threshold)
+		return sched_policy;
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
+	policy = get_sd_sched_policy(sd, cpu, p, sds);
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
@@ -3362,11 +3526,20 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
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
 
@@ -4167,51 +4340,6 @@ static unsigned long task_h_load(struct task_struct *p)
 #endif
 
 /********** Helpers for find_busiest_group ************************/
-/*
- * sd_lb_stats - Structure to store the statistics of a sched_domain
- * 		during load balancing.
- */
-struct sd_lb_stats {
-	struct sched_group *busiest; /* Busiest group in this sd */
-	struct sched_group *this;  /* Local group in this sd */
-	unsigned long total_load;  /* Total load of all groups in sd */
-	unsigned long total_pwr;   /*	Total power of all groups in sd */
-	unsigned long avg_load;	   /* Average load across all groups in sd */
-
-	/** Statistics of this group */
-	unsigned long this_load;
-	unsigned long this_load_per_task;
-	unsigned long this_nr_running;
-	unsigned long this_has_capacity;
-	unsigned int  this_idle_cpus;
-
-	/* Statistics of the busiest group */
-	unsigned int  busiest_idle_cpus;
-	unsigned long max_load;
-	unsigned long busiest_load_per_task;
-	unsigned long busiest_nr_running;
-	unsigned long busiest_group_capacity;
-	unsigned long busiest_has_capacity;
-	unsigned int  busiest_group_weight;
-
-	int group_imb; /* Is there imbalance in this sd */
-};
-
-/*
- * sg_lb_stats - stats of a sched_group required for load_balancing
- */
-struct sg_lb_stats {
-	unsigned long avg_load; /*Avg load across the CPUs of the group */
-	unsigned long group_load; /* Total load over the CPUs of the group */
-	unsigned long sum_nr_running; /* Nr tasks running in the group */
-	unsigned long sum_weighted_load; /* Weighted load of group's tasks */
-	unsigned long group_capacity;
-	unsigned long idle_cpus;
-	unsigned long group_weight;
-	int group_imb; /* Is there an imbalance in the group ? */
-	int group_has_capacity; /* Is there extra capacity in the group? */
-};
-
 /**
  * get_sd_load_idx - Obtain the load index for a given sched domain.
  * @sd: The sched_domain whose load_idx is to be obtained.
-- 
1.7.12

