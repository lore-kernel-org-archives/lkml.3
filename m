Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751651AbaHKLtR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 07:49:17 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:51268 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbaHKLtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 07:49:16 -0400
Subject: [RFC PATCH V2 17/19] sched: power aware load balance
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
To: alex.shi@intel.com, vincent.guittot@linaro.org, peterz@infradead.org,
        pjt@google.com, efault@gmx.de, rjw@rjwysocki.net,
        morten.rasmussen@arm.com, svaidy@linux.vnet.ibm.com,
        arjan@linux.intel.com, mingo@kernel.org
Cc: nicolas.pitre@linaro.org, len.brown@intel.com, yuyang.du@intel.com,
        linaro-kernel@lists.linaro.org, daniel.lezcano@linaro.org,
        corbet@lwn.net, catalin.marinas@arm.com, markgross@thegnar.org,
        sundar.iyer@intel.com, linux-kernel@vger.kernel.org,
        dietmar.eggemann@arm.com, Lorenzo.Pieralisi@arm.com,
        mike.turquette@linaro.org, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de
Date: Mon, 11 Aug 2014 17:18:55 +0530
Message-ID: <20140811114501.32407.61304.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081111-0928-0000-0000-000003F9B33E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Shi <alex.shi@intel.com>

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
power/performance balance in this domain. If using performance balance
or any group is busy, do performance balance.

Above logical is mainly implemented in update_sd_lb_power_stats(). It
decides if a domain is suitable for power aware scheduling. If so,
it will fill the dst group and source group accordingly.

This patch reused some of Suresh's power saving load balance code.

Signed-off-by: Alex Shi <alex.shi@intel.com>
[Added CONFIG_SCHED_POWER switch to enable this patch]
Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---

 kernel/sched/fair.c |  126 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 125 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 6d40aa3..2e64e96 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5871,6 +5871,109 @@ static inline void init_sd_lb_stats(struct sd_lb_stats *sds)
 	};
 }
 
+#ifdef CONFIG_SCHED_POWER
+/**
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
+#else
+static inline void init_sd_lb_power_stats(struct lb_env *env,
+                                                struct sd_lb_stats *sds) {}
+static inline void update_sd_lb_power_stats(struct lb_env *env,
+                        struct sched_group *group, struct sd_lb_stats *sds,
+                        int local_group, struct sg_lb_stats *sgs) {}
+#endif /* CONFIG_SCHED_POWER */
+
 /**
  * get_sd_load_idx - Obtain the load index for a given sched domain.
  * @sd: The sched_domain whose load_idx is to be obtained.
@@ -6248,6 +6351,10 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 		sgs->group_load += load;
 		sgs->sum_nr_running += rq->nr_running;
 
+#ifdef CONFIG_SCHED_POWER
+		/* add scaled rt utilization */
+                sgs->group_util += max_rq_util(i);
+#endif
 		if (rq->nr_running > 1)
 			*overload = true;
 
@@ -6381,6 +6488,7 @@ static inline void update_sd_lb_stats(struct lb_env *env, struct sd_lb_stats *sd
 
 	if (child && child->flags & SD_PREFER_SIBLING)
 		prefer_sibling = 1;
+	init_sd_lb_power_stats(env, sds);
 
 	load_idx = get_sd_load_idx(env->sd, env->idle);
 
@@ -6433,6 +6541,7 @@ next_group:
 		sds->total_load += sgs->group_load;
 		sds->total_capacity += sgs->group_capacity;
 
+		update_sd_lb_power_stats(env, sg, sds, local_group, sgs);
 		sg = sg->next;
 	} while (sg != env->sd->groups);
 
@@ -6665,6 +6774,21 @@ static struct sched_group *find_busiest_group(struct lb_env *env)
 	 * this level.
 	 */
 	update_sd_lb_stats(env, &sds);
+
+#ifdef CONFIG_SCHED_POWER
+        if (!(env->flags & LBF_POWER_BAL) && !(env->flags & LBF_PERF_BAL))
+                return  NULL;
+ 
+        if (env->flags & LBF_POWER_BAL) {
+                if (sds.this == sds.group_leader &&
+                                sds.group_leader != sds.group_min) {
+                        env->imbalance = sds.min_load_per_task;
+                        return sds.group_min;
+                }
+                env->flags &= ~LBF_POWER_BAL;
+                return NULL;
+        }
+#endif
 	local = &sds.local_stat;
 	busiest = &sds.busiest_stat;
 
@@ -6923,7 +7047,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 		.loop_break	= sched_nr_migrate_break,
 		.cpus		= cpus,
 #ifdef CONFIG_SCHED_POWER
-		.flags		= LBF_PERF_BAL,
+		.flags		= LBF_POWER_BAL,
 #endif
 		.fbq_type	= all,
 	};

