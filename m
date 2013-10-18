Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab3JRLyE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 07:54:04 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:55157 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262Ab3JRLxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 07:53:48 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@kernel.org,
        pjt@google.com, Morten.Rasmussen@arm.com, cmetcalf@tilera.com,
        tony.luck@intel.com, alex.shi@intel.com, preeti@linux.vnet.ibm.com,
        linaro-kernel@lists.linaro.org
Cc: rjw@sisk.pl, paulmck@linux.vnet.ibm.com, corbet@lwn.net,
        tglx@linutronix.de, len.brown@intel.com, arjan@linux.intel.com,
        amit.kucheria@linaro.org, l.majewski@samsung.com,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [RFC][PATCH v5 04/14] sched: do load balance only with packing cpus
Date: Fri, 18 Oct 2013 13:52:17 +0200
Message-Id: <1382097147-30088-4-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1382097147-30088-1-git-send-email-vincent.guittot@linaro.org>
References: <1382097147-30088-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tasks will be scheduled only on the CPUs that participate to the packing
effort. A CPU participates to the packing effort when it is its own buddy.

For ILB, look for an idle CPU close to the packing CPUs whenever possible.
The goal is to prevent the wake up of a CPU which doesn't share the power
domain of the pack buddy CPU.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/sched/fair.c |   80 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 76 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 5547831..7149f38 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -186,6 +186,17 @@ void sched_init_granularity(void)
  */
 DEFINE_PER_CPU(int, sd_pack_buddy);
 
+static inline bool is_packing_cpu(int cpu)
+{
+	int my_buddy = per_cpu(sd_pack_buddy, cpu);
+	return (my_buddy == -1) || (cpu == my_buddy);
+}
+
+static inline int get_buddy(int cpu)
+{
+	return per_cpu(sd_pack_buddy, cpu);
+}
+
 /*
  * Look for the best buddy CPU that can be used to pack small tasks
  * We make the assumption that it doesn't wort to pack on CPU that share the
@@ -245,6 +256,32 @@ void update_packing_domain(int cpu)
 	pr_debug("CPU%d packing on CPU%d\n", cpu, id);
 	per_cpu(sd_pack_buddy, cpu) = id;
 }
+
+static int check_nohz_packing(int cpu)
+{
+	if (!is_packing_cpu(cpu))
+		return true;
+
+	return false;
+}
+#else /* CONFIG_SCHED_PACKING_TASKS */
+
+static inline bool is_packing_cpu(int cpu)
+{
+	return 1;
+}
+
+static inline int get_buddy(int cpu)
+{
+	return -1;
+}
+
+static inline int check_nohz_packing(int cpu)
+{
+	return false;
+}
+
+
 #endif /* CONFIG_SCHED_PACKING_TASKS */
 #endif /* CONFIG_SMP */
 
@@ -3370,7 +3407,7 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p,
 
 	do {
 		unsigned long load, avg_load;
-		int local_group;
+		int local_group, packing_cpus = 0;
 		int i;
 
 		/* Skip over this group if it has no CPUs allowed */
@@ -3392,8 +3429,14 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p,
 				load = target_load(i, load_idx);
 
 			avg_load += load;
+
+			if (is_packing_cpu(i))
+				packing_cpus = 1;
 		}
 
+		if (!packing_cpus)
+			continue;
+
 		/* Adjust by relative CPU power of the group */
 		avg_load = (avg_load * SCHED_POWER_SCALE) / group->sgp->power;
 
@@ -3448,7 +3491,8 @@ static int select_idle_sibling(struct task_struct *p, int target)
 	/*
 	 * If the prevous cpu is cache affine and idle, don't be stupid.
 	 */
-	if (i != target && cpus_share_cache(i, target) && idle_cpu(i))
+	if (i != target && cpus_share_cache(i, target) && idle_cpu(i)
+			&& is_packing_cpu(i))
 		return i;
 
 	/*
@@ -3463,7 +3507,8 @@ static int select_idle_sibling(struct task_struct *p, int target)
 				goto next;
 
 			for_each_cpu(i, sched_group_cpus(sg)) {
-				if (i == target || !idle_cpu(i))
+				if (i == target || !idle_cpu(i)
+						|| !is_packing_cpu(i))
 					goto next;
 			}
 
@@ -3528,9 +3573,13 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 	}
 
 	if (affine_sd) {
-		if (cpu != prev_cpu && wake_affine(affine_sd, p, sync))
+		if (cpu != prev_cpu && (wake_affine(affine_sd, p, sync)
+					|| !is_packing_cpu(prev_cpu)))
 			prev_cpu = cpu;
 
+		if (!is_packing_cpu(prev_cpu))
+			prev_cpu =  get_buddy(prev_cpu);
+
 		new_cpu = select_idle_sibling(p, prev_cpu);
 		goto unlock;
 	}
@@ -5593,7 +5642,26 @@ static struct {
 
 static inline int find_new_ilb(int call_cpu)
 {
+	struct sched_domain *sd;
 	int ilb = cpumask_first(nohz.idle_cpus_mask);
+	int buddy = get_buddy(call_cpu);
+
+	/*
+	 * If we have a pack buddy CPU, we try to run load balance on a CPU
+	 * that is close to the buddy.
+	 */
+	if (buddy != -1) {
+		for_each_domain(buddy, sd) {
+			if (sd->flags & SD_SHARE_CPUPOWER)
+				continue;
+
+			ilb = cpumask_first_and(sched_domain_span(sd),
+					nohz.idle_cpus_mask);
+
+			if (ilb < nr_cpu_ids)
+				break;
+		}
+	}
 
 	if (ilb < nr_cpu_ids && idle_cpu(ilb))
 		return ilb;
@@ -5874,6 +5942,10 @@ static inline int nohz_kick_needed(struct rq *rq, int cpu)
 	if (rq->nr_running >= 2)
 		goto need_kick;
 
+	/* This cpu doesn't contribute to packing effort */
+	if (check_nohz_packing(cpu))
+		goto need_kick;
+
 	rcu_read_lock();
 	for_each_domain(cpu, sd) {
 		struct sched_group *sg = sd->groups;
-- 
1.7.9.5

