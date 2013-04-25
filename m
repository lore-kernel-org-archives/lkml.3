Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759148Ab3DYRZU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 13:25:20 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:62731 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759098Ab3DYRZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 13:25:11 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, peterz@infradead.org, mingo@kernel.org,
        linux@arm.linux.org.uk, pjt@google.com, santosh.shilimkar@ti.com,
        Morten.Rasmussen@arm.com, chander.kashyap@linaro.org,
        cmetcalf@tilera.com, tony.luck@intel.com, alex.shi@intel.com,
        preeti@linux.vnet.ibm.com
Cc: paulmck@linux.vnet.ibm.com, tglx@linutronix.de, len.brown@intel.com,
        arjan@linux.intel.com, amit.kucheria@linaro.org, corbet@lwn.net,
        l.majewski@samsung.com, Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH 10/14] sched: update the buddy CPU
Date: Thu, 25 Apr 2013 19:23:26 +0200
Message-Id: <1366910611-20048-11-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1366910611-20048-1-git-send-email-vincent.guittot@linaro.org>
References: <1366910611-20048-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Periodically updates the buddy of a CPU according to the current activity of
the system. A CPU is its own buddy if it participates to the packing effort.
Otherwise, it points to a CPU that participates to the packing effort.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/sched/fair.c |   91 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 86 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 234ecdd..28f8ea7 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -174,11 +174,17 @@ void sched_init_granularity(void)
 
 
 #ifdef CONFIG_SMP
+static unsigned long power_of(int cpu)
+{
+	return cpu_rq(cpu)->cpu_power;
+}
+
 /*
  * Save the id of the optimal CPU that should be used to pack small tasks
  * The value -1 is used when no buddy has been found
  */
 DEFINE_PER_CPU(int, sd_pack_buddy);
+DEFINE_PER_CPU(struct sched_domain *, sd_pack_domain);
 
 /*
  * Look for the best buddy CPU that can be used to pack small tasks
@@ -237,6 +243,68 @@ void update_packing_domain(int cpu)
 	}
 
 	pr_debug("CPU%d packing on CPU%d\n", cpu, id);
+	per_cpu(sd_pack_domain, cpu) = sd;
+	per_cpu(sd_pack_buddy, cpu) = id;
+}
+
+void update_packing_buddy(int cpu, int activity)
+{
+	struct sched_domain *sd = per_cpu(sd_pack_domain, cpu);
+	struct sched_group *sg, *pack, *tmp;
+	int id = cpu;
+
+	if (!sd)
+		return;
+
+	/*
+	 * The sched_domain of a CPU points on the local sched_group
+	 * and this CPU of this local group is a good candidate
+	 */
+	pack = sg = sd->groups;
+
+	/* loop the sched groups to find the best one */
+	for (tmp = sg->next; tmp != sg; tmp = tmp->next) {
+		if ((tmp->sgp->power * pack->group_weight) >
+			(pack->sgp->power_available * tmp->group_weight))
+			continue;
+
+		if (((tmp->sgp->power * pack->group_weight) ==
+			 (pack->sgp->power * tmp->group_weight))
+		 && (cpumask_first(sched_group_cpus(tmp)) >= id))
+			continue;
+
+		/* we have found a better group */
+		pack = tmp;
+
+		/* Take the 1st CPU of the new group */
+		id = cpumask_first(sched_group_cpus(pack));
+	}
+
+	if ((cpu == id) || (activity <= power_of(id))) {
+		per_cpu(sd_pack_buddy, cpu) = id;
+		return;
+	}
+
+	for (tmp = pack; activity > 0; tmp = tmp->next) {
+		if (tmp->sgp->power > activity) {
+			id = cpumask_first(sched_group_cpus(tmp));
+			activity -= power_of(id);
+			if (cpu == id)
+				activity = 0;
+			while ((activity > 0) && (id < nr_cpu_ids)) {
+				id = cpumask_next(id, sched_group_cpus(tmp));
+				activity -= power_of(id);
+				if (cpu == id)
+					activity = 0;
+			}
+		} else if (cpumask_test_cpu(cpu, sched_group_cpus(tmp))) {
+			id = cpu;
+			activity = 0;
+		} else {
+			activity -= tmp->sgp->power;
+		}
+	}
+
 	per_cpu(sd_pack_buddy, cpu) = id;
 }
 
@@ -3014,11 +3082,6 @@ static unsigned long target_load(int cpu, int type)
 	return max(rq->cpu_load[type-1], total);
 }
 
-static unsigned long power_of(int cpu)
-{
-	return cpu_rq(cpu)->cpu_power;
-}
-
 static unsigned long cpu_avg_load_per_task(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
@@ -4740,6 +4803,22 @@ static bool update_sd_pick_busiest(struct lb_env *env,
 	return false;
 }
 
+static void update_plb_buddy(int cpu, int *balance, struct sd_lb_stats *sds,
+		struct sched_domain *sd)
+{
+	int buddy;
+
+	if (sysctl_sched_packing_mode != SCHED_PACKING_FULL)
+		return;
+
+	/* Update my buddy */
+	if (sd == per_cpu(sd_pack_domain, cpu))
+		update_packing_buddy(cpu, sds->total_activity);
+
+	/* Get my new buddy */
+	buddy = per_cpu(sd_pack_buddy, cpu);
+}
+
 /**
  * update_sd_lb_stats - Update sched_domain's statistics for load balancing.
  * @env: The load balancing environment.
@@ -4807,6 +4886,8 @@ static inline void update_sd_lb_stats(struct lb_env *env,
 
 		sg = sg->next;
 	} while (sg != env->sd->groups);
+
+	update_plb_buddy(env->dst_cpu, balance, sds, env->sd);
 }
 
 /**
-- 
1.7.9.5

