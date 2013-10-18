Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab3JRLxv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 07:53:51 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:45986 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247Ab3JRLxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 07:53:47 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@kernel.org,
        pjt@google.com, Morten.Rasmussen@arm.com, cmetcalf@tilera.com,
        tony.luck@intel.com, alex.shi@intel.com, preeti@linux.vnet.ibm.com,
        linaro-kernel@lists.linaro.org
Cc: rjw@sisk.pl, paulmck@linux.vnet.ibm.com, corbet@lwn.net,
        tglx@linutronix.de, len.brown@intel.com, arjan@linux.intel.com,
        amit.kucheria@linaro.org, l.majewski@samsung.com,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [RFC][PATCH v5 03/14] sched: define pack buddy CPUs
Date: Fri, 18 Oct 2013 13:52:16 +0200
Message-Id: <1382097147-30088-3-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1382097147-30088-1-git-send-email-vincent.guittot@linaro.org>
References: <1382097147-30088-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During the creation of sched_domain, we define a pack buddy CPU for each CPU
when one is available. We want to pack at all levels where a group of CPUs can
be power gated independently from others.
On a system that can't power gate a group of CPUs independently, the flag is
set at all sched_domain level and the buddy is set to -1. This is the default
behavior for all architectures.

On a dual clusters / dual cores system which can power gate each core and
cluster independently, the buddy configuration will be :

      | Cluster 0   | Cluster 1   |
      | CPU0 | CPU1 | CPU2 | CPU3 |
-----------------------------------
buddy | CPU0 | CPU0 | CPU0 | CPU2 |

If the cores in a cluster can't be power gated independently, the buddy
configuration becomes:

      | Cluster 0   | Cluster 1   |
      | CPU0 | CPU1 | CPU2 | CPU3 |
-----------------------------------
buddy | CPU0 | CPU1 | CPU0 | CPU0 |

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/sched/core.c  |    1 +
 kernel/sched/fair.c  |   70 ++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/sched.h |    5 ++++
 3 files changed, 76 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 735e964..0bf5f4d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5184,6 +5184,7 @@ cpu_attach_domain(struct sched_domain *sd, struct root_domain *rd, int cpu)
 	rcu_assign_pointer(rq->sd, sd);
 	destroy_sched_domains(tmp, cpu);
 
+	update_packing_domain(cpu);
 	update_top_cache_domain(cpu);
 }
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 11cd136..5547831 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -178,6 +178,76 @@ void sched_init_granularity(void)
 	update_sysctl();
 }
 
+#ifdef CONFIG_SMP
+#ifdef CONFIG_SCHED_PACKING_TASKS
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
+		 * and this CPU of this local group is a good candidate
+		 */
+		id = cpu;
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
+#endif /* CONFIG_SCHED_PACKING_TASKS */
+#endif /* CONFIG_SMP */
+
 #if BITS_PER_LONG == 32
 # define WMULT_CONST	(~0UL)
 #else
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index b3c5653..22e3f1d 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1022,6 +1022,11 @@ extern void update_group_power(struct sched_domain *sd, int cpu);
 
 extern void trigger_load_balance(struct rq *rq, int cpu);
 extern void idle_balance(int this_cpu, struct rq *this_rq);
+#ifdef CONFIG_SCHED_PACKING_TASKS
+extern void update_packing_domain(int cpu);
+#else
+static inline void update_packing_domain(int cpu) {};
+#endif
 
 extern void idle_enter_fair(struct rq *this_rq);
 extern void idle_exit_fair(struct rq *this_rq);
-- 
1.7.9.5

