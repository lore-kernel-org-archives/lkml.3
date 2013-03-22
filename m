Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932846Ab3CVM3o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 08:29:44 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:61184 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932708Ab3CVM3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 08:29:40 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, peterz@infradead.org, mingo@kernel.org,
        linux@arm.linux.org.uk, pjt@google.com, santosh.shilimkar@ti.com,
        morten.rasmussen@arm.com, chander.kashyap@linaro.org,
        cmetcalf@tilera.com, tony.luck@intel.com
Cc: alex.shi@intel.com, preeti@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, len.brown@intel.com, arjan@linux.intel.com,
        amit.kucheria@linaro.org, corbet@lwn.net,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [RFC PATCH v3 3/6] sched: pack small tasks
Date: Fri, 22 Mar 2013 13:25:52 +0100
Message-Id: <1363955155-18382-4-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363955155-18382-1-git-send-email-vincent.guittot@linaro.org>
References: <1363955155-18382-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During the creation of sched_domain, we define a pack buddy CPU for each CPU
when one is available. We want to pack at all levels where a group of CPU can
be power gated independently from others.
On a system that can't power gate a group of CPUs independently, the flag is
set at all sched_domain level and the buddy is set to -1. This is the default
behavior.
On a dual clusters / dual cores system which can power gate each core and
cluster independently, the buddy configuration will be :

      | Cluster 0   | Cluster 1   |
      | CPU0 | CPU1 | CPU2 | CPU3 |
-----------------------------------
buddy | CPU0 | CPU0 | CPU0 | CPU2 |

Small tasks tend to slip out of the periodic load balance so the best place
to choose to migrate them is during their wake up. The decision is in O(1) as
we only check again one buddy CPU

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Reviewed-by: Morten Rasmussen <morten.rasmussen@arm.com>
---
 kernel/sched/core.c  |    1 +
 kernel/sched/fair.c  |  115 ++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/sched.h |    5 +++
 3 files changed, 121 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b827e0c..21c35ce 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5662,6 +5662,7 @@ cpu_attach_domain(struct sched_domain *sd, struct root_domain *rd, int cpu)
 	rcu_assign_pointer(rq->sd, sd);
 	destroy_sched_domains(tmp, cpu);
 
+	update_packing_domain(cpu);
 	update_top_cache_domain(cpu);
 }
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 9c2f726..021c7b7 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -160,6 +160,76 @@ void sched_init_granularity(void)
 	update_sysctl();
 }
 
+
+#ifdef CONFIG_SMP
+/*
+ * Save the id of the optimal CPU that should be used to pack small tasks
+ * The value -1 is used when no buddy has been found
+ */
+DEFINE_PER_CPU(int, sd_pack_buddy);
+
+/*
+ * Look for the best buddy CPU that can be used to pack small tasks
+ * We make the assumption that it doesn't wort to pack on CPU that share the
+ * same powerline. We look for the 1st sched_domain without the
+ * SD_SHARE_POWERDOMAIN flag. Then we look for the sched_group with the lowest
+ * power per core based on the assumption that their power efficiency is
+ * better
+ */
+void update_packing_domain(int cpu)
+{
+	struct sched_domain *sd;
+	int id = -1;
+
+	sd = highest_flag_domain(cpu, SD_SHARE_POWERDOMAIN);
+	if (!sd)
+		sd = rcu_dereference_check_sched_domain(cpu_rq(cpu)->sd);
+	else
+		sd = sd->parent;
+
+	while (sd && (sd->flags & SD_LOAD_BALANCE)
+		&& !(sd->flags & SD_SHARE_POWERDOMAIN)) {
+		struct sched_group *sg = sd->groups;
+		struct sched_group *pack = sg;
+		struct sched_group *tmp;
+
+		/*
+		 * The sched_domain of a CPU points on the local sched_group
+		 * and the 1st CPU of this local group is a good candidate
+		 */
+		id = cpumask_first(sched_group_cpus(pack));
+
+		/* loop the sched groups to find the best one */
+		for (tmp = sg->next; tmp != sg; tmp = tmp->next) {
+			if (tmp->sgp->power * pack->group_weight >
+					pack->sgp->power * tmp->group_weight)
+				continue;
+
+			if ((tmp->sgp->power * pack->group_weight ==
+					pack->sgp->power * tmp->group_weight)
+			 && (cpumask_first(sched_group_cpus(tmp)) >= id))
+				continue;
+
+			/* we have found a better group */
+			pack = tmp;
+
+			/* Take the 1st CPU of the new group */
+			id = cpumask_first(sched_group_cpus(pack));
+		}
+
+		/* Look for another CPU than itself */
+		if (id != cpu)
+			break;
+
+		sd = sd->parent;
+	}
+
+	pr_debug("CPU%d packing on CPU%d\n", cpu, id);
+	per_cpu(sd_pack_buddy, cpu) = id;
+}
+
+#endif /* CONFIG_SMP */
+
 #if BITS_PER_LONG == 32
 # define WMULT_CONST	(~0UL)
 #else
@@ -3291,6 +3361,47 @@ done:
 	return target;
 }
 
+static bool is_buddy_busy(int cpu)
+{
+	struct rq *rq = cpu_rq(cpu);
+
+	/*
+	 * A busy buddy is a CPU with a high load or a small load with a lot of
+	 * running tasks.
+	 */
+	return (rq->avg.runnable_avg_sum >
+			(rq->avg.runnable_avg_period / (rq->nr_running + 2)));
+}
+
+static bool is_light_task(struct task_struct *p)
+{
+	/* A light task runs less than 20% in average */
+	return ((p->se.avg.runnable_avg_sum  * 5) <
+			(p->se.avg.runnable_avg_period));
+}
+
+static int check_pack_buddy(int cpu, struct task_struct *p)
+{
+	int buddy = per_cpu(sd_pack_buddy, cpu);
+
+	/* No pack buddy for this CPU */
+	if (buddy == -1)
+		return false;
+
+	/* buddy is not an allowed CPU */
+	if (!cpumask_test_cpu(buddy, tsk_cpus_allowed(p)))
+		return false;
+
+	/*
+	 * If the task is a small one and the buddy is not overloaded,
+	 * we use buddy cpu
+	 */
+	if (!is_light_task(p) || is_buddy_busy(buddy))
+		return false;
+
+	return true;
+}
+
 /*
  * sched_balance_self: balance the current task (running on cpu) in domains
  * that have the 'flag' flag set. In practice, this is SD_BALANCE_FORK and
@@ -3319,6 +3430,10 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 		if (cpumask_test_cpu(cpu, tsk_cpus_allowed(p)))
 			want_affine = 1;
 		new_cpu = prev_cpu;
+
+		/* We pack only at wake up and not new task */
+		if (check_pack_buddy(new_cpu, p))
+			return per_cpu(sd_pack_buddy, new_cpu);
 	}
 
 	rcu_read_lock();
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 7f36024f..96b164d 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -872,6 +872,7 @@ extern const struct sched_class idle_sched_class;
 
 extern void trigger_load_balance(struct rq *rq, int cpu);
 extern void idle_balance(int this_cpu, struct rq *this_rq);
+extern void update_packing_domain(int cpu);
 
 #else	/* CONFIG_SMP */
 
@@ -879,6 +880,10 @@ static inline void idle_balance(int cpu, struct rq *rq)
 {
 }
 
+static inline void update_packing_domain(int cpu)
+{
+}
+
 #endif
 
 extern void sysrq_sched_debug_show(void);
-- 
1.7.9.5

