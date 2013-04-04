Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932941Ab3DDCCx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 22:02:53 -0400
Received: from mga03.intel.com ([143.182.124.21]:29737 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932881Ab3DDCCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 22:02:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,404,1363158000"; 
   d="scan'208";a="280534564"
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
Subject: [patch v7 18/21] sched: power aware load balance
Date: Thu,  4 Apr 2013 10:00:59 +0800
Message-Id: <1365040862-8390-19-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1365040862-8390-1-git-send-email-alex.shi@intel.com>
References: <1365040862-8390-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enabled the power aware consideration in load balance.

As mentioned in the power aware scheduler proposal, Power aware
scheduling has 2 assumptions:
1, race to idle is helpful for power saving
2, less active sched_groups will reduce power consumption

The first assumption make performance policy take over scheduling when
any scheduler group is busy.
The second assumption make power aware scheduling try to pack disperse
tasks into fewer groups.

The enabling logical summary here:
1, Collect power aware scheduler statistics during performance load
balance statistics collection.
2, If the balance cpu is eligible for power load balance, just do it
and forget performance load balance. If the domain is suitable for
power balance, but the cpu is inappropriate(idle or full), stop both
power/performance balance in this domain.
3, If using performance balance policy or using power balance but any
group is busy, do performance balance.

Above logical is mainly implemented in update_sd_lb_power_stats(). It
decides if a domain is suitable for power aware scheduling. If so,
it will fill the dst group and source group accordingly.

This patch reused some of Suresh's power saving load balance code.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c | 120 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 118 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 9326c22..0682472 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -18,6 +18,9 @@
  *
  *  Adaptive scheduling granularity, math enhancements by Peter Zijlstra
  *  Copyright (C) 2007 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
+ *
+ *  Powersaving balance policy added by Alex Shi
+ *  Copyright (C) 2013 Intel, Alex Shi <alex.shi@intel.com>
  */
 
 #include <linux/latencytop.h>
@@ -4398,6 +4401,101 @@ static unsigned long task_h_load(struct task_struct *p)
 /********** Helpers for find_busiest_group ************************/
 
 /**
+ * init_sd_lb_power_stats - Initialize power savings statistics for
+ * the given sched_domain, during load balancing.
+ *
+ * @env: The load balancing environment.
+ * @sds: Variable containing the statistics for sd.
+ */
+static inline void init_sd_lb_power_stats(struct lb_env *env,
+						struct sd_lb_stats *sds)
+{
+	if (sched_balance_policy == SCHED_POLICY_PERFORMANCE ||
+				env->idle == CPU_NOT_IDLE) {
+		env->flags &= ~LBF_POWER_BAL;
+		env->flags |= LBF_PERF_BAL;
+		return;
+	}
+	env->flags &= ~LBF_PERF_BAL;
+	env->flags |= LBF_POWER_BAL;
+	sds->min_util = UINT_MAX;
+	sds->leader_util = 0;
+}
+
+/**
+ * update_sd_lb_power_stats - Update the power saving stats for a
+ * sched_domain while performing load balancing.
+ *
+ * @env: The load balancing environment.
+ * @group: sched_group belonging to the sched_domain under consideration.
+ * @sds: Variable containing the statistics of the sched_domain
+ * @local_group: Does group contain the CPU for which we're performing
+ * load balancing?
+ * @sgs: Variable containing the statistics of the group.
+ */
+static inline void update_sd_lb_power_stats(struct lb_env *env,
+			struct sched_group *group, struct sd_lb_stats *sds,
+			int local_group, struct sg_lb_stats *sgs)
+{
+	unsigned long threshold_util;
+
+	if (env->flags & LBF_PERF_BAL)
+		return;
+
+	threshold_util =  sgs->group_weight * FULL_UTIL;
+
+	/*
+	 * If the local group is idle or full loaded
+	 * no need to do power savings balance at this domain
+	 */
+	if (local_group && (!sgs->sum_nr_running ||
+		sgs->group_util + FULL_UTIL > threshold_util))
+		env->flags &= ~LBF_POWER_BAL;
+
+	/* Do performance load balance if any group overload */
+	if (sgs->group_util > threshold_util) {
+		env->flags |= LBF_PERF_BAL;
+		env->flags &= ~LBF_POWER_BAL;
+	}
+
+	/*
+	 * If a group is idle,
+	 * don't include that group in power savings calculations
+	 */
+	if (!(env->flags & LBF_POWER_BAL) || !sgs->sum_nr_running)
+		return;
+
+	/*
+	 * Calculate the group which has the least non-idle load.
+	 * This is the group from where we need to pick up the load
+	 * for saving power
+	 */
+	if ((sgs->group_util < sds->min_util) ||
+	    (sgs->group_util == sds->min_util &&
+	     group_first_cpu(group) > group_first_cpu(sds->group_min))) {
+		sds->group_min = group;
+		sds->min_util = sgs->group_util;
+		sds->min_load_per_task = sgs->sum_weighted_load /
+						sgs->sum_nr_running;
+	}
+
+	/*
+	 * Calculate the group which is almost near its
+	 * capacity but still has some space to pick up some load
+	 * from other group and save more power
+	 */
+	if (sgs->group_util + FULL_UTIL > threshold_util)
+		return;
+
+	if (sgs->group_util > sds->leader_util ||
+	    (sgs->group_util == sds->leader_util && sds->group_leader &&
+	     group_first_cpu(group) < group_first_cpu(sds->group_leader))) {
+		sds->group_leader = group;
+		sds->leader_util = sgs->group_util;
+	}
+}
+
+/**
  * get_sd_load_idx - Obtain the load index for a given sched domain.
  * @sd: The sched_domain whose load_idx is to be obtained.
  * @idle: The Idle status of the CPU for whose sd load_icx is obtained.
@@ -4634,6 +4732,10 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 		sgs->group_load += load;
 		sgs->sum_nr_running += nr_running;
 		sgs->sum_weighted_load += weighted_cpuload(i);
+
+		/* add scaled rq utilization */
+		sgs->group_util += max_rq_util(i);
+
 		if (idle_cpu(i))
 			sgs->idle_cpus++;
 	}
@@ -4742,6 +4844,7 @@ static inline void update_sd_lb_stats(struct lb_env *env,
 	if (child && child->flags & SD_PREFER_SIBLING)
 		prefer_sibling = 1;
 
+	init_sd_lb_power_stats(env, sds);
 	load_idx = get_sd_load_idx(env->sd, env->idle);
 
 	do {
@@ -4793,6 +4896,7 @@ static inline void update_sd_lb_stats(struct lb_env *env,
 			sds->group_imb = sgs.group_imb;
 		}
 
+		update_sd_lb_power_stats(env, sg, sds, local_group, &sgs);
 		sg = sg->next;
 	} while (sg != env->sd->groups);
 }
@@ -5010,6 +5114,19 @@ find_busiest_group(struct lb_env *env, int *balance)
 	 */
 	update_sd_lb_stats(env, balance, &sds);
 
+	if (!(env->flags & LBF_POWER_BAL) && !(env->flags & LBF_PERF_BAL))
+		return  NULL;
+
+	if (env->flags & LBF_POWER_BAL) {
+		if (sds.this == sds.group_leader &&
+				sds.group_leader != sds.group_min) {
+			env->imbalance = sds.min_load_per_task;
+			return sds.group_min;
+		}
+		env->flags &= ~LBF_POWER_BAL;
+		return NULL;
+	}
+
 	/*
 	 * this_cpu is not the appropriate cpu to perform load balancing at
 	 * this level.
@@ -5187,7 +5304,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 		.idle		= idle,
 		.loop_break	= sched_nr_migrate_break,
 		.cpus		= cpus,
-		.flags		= LBF_PERF_BAL,
+		.flags		= LBF_POWER_BAL,
 	};
 
 	cpumask_copy(cpus, cpu_active_mask);
@@ -6265,7 +6382,6 @@ void unregister_fair_sched_group(struct task_group *tg, int cpu) { }
 
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
-
 static unsigned int get_rr_interval_fair(struct rq *rq, struct task_struct *task)
 {
 	struct sched_entity *se = &task->se;
-- 
1.7.12

