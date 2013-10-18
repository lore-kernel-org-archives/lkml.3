Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748Ab3JRLyQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 07:54:16 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:52808 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400Ab3JRLx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 07:53:56 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@kernel.org,
        pjt@google.com, Morten.Rasmussen@arm.com, cmetcalf@tilera.com,
        tony.luck@intel.com, alex.shi@intel.com, preeti@linux.vnet.ibm.com,
        linaro-kernel@lists.linaro.org
Cc: rjw@sisk.pl, paulmck@linux.vnet.ibm.com, corbet@lwn.net,
        tglx@linutronix.de, len.brown@intel.com, arjan@linux.intel.com,
        amit.kucheria@linaro.org, l.majewski@samsung.com,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [RFC][PATCH v5 09/14] sched: update the packing cpu list
Date: Fri, 18 Oct 2013 13:52:22 +0200
Message-Id: <1382097147-30088-9-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1382097147-30088-1-git-send-email-vincent.guittot@linaro.org>
References: <1382097147-30088-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the activity statistics to update the list of CPUs that should be used
to hanlde the current system activity.

The cpu_power is updated for CPUs that don't participate to the packing
effort. We consider that their cpu_power is allocated to idleness as it
could be allocated by rt. So the cpu_power that remains available for cfs,
is set to min value (i.e. 1).

The cpu_power is used for a task that wakes up because a waking up task is
already taken into account in the current activity whereas we use the
power_available for a fork and exec because the task is not part of the current
activity.

In order to quickly found the packing starting point, we save information that
will be used to directly start with the right sched_group at the right
sched_domain level instead of running the complete update_packing_domain
algorithm each time we need to use the packing cpu list.

The sd_power_leader defines the leader of a group of CPU that can't be
powergated independantly. As soon as this CPU is used, all the CPU in the same
group will be used based on the fact that it doesn't worth to keep some cores
idle if they can't be power gated while one core in the group is running.
The sd_pack_group and sd_pack_domain are used to quickly check if a power
leader should be used in the packing effort

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/sched/fair.c |  162 ++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 149 insertions(+), 13 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c258c38..f9b03c1 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -185,11 +185,20 @@ static unsigned long available_of(int cpu)
 }
 
 #ifdef CONFIG_SCHED_PACKING_TASKS
+struct sd_pack {
+	int  my_buddy; /* cpu on which tasks should be packed */
+	int my_leader; /* cpu which leads the packing state of a group */
+	struct sched_domain *domain; /* domain at which the check is done */
+	struct sched_group *group; /* starting group for checking */
+};
+
 /*
- * Save the id of the optimal CPU that should be used to pack small tasks
- * The value -1 is used when no buddy has been found
+ * Save per_cpu information about the optimal CPUs that should be used to pack
+ * tasks.
  */
-DEFINE_PER_CPU(int, sd_pack_buddy);
+DEFINE_PER_CPU(struct sd_pack, sd_pack_buddy)  = {
+	.my_buddy = -1,
+};
 
 /*
  * The packing level of the scheduler
@@ -202,6 +211,15 @@ int __read_mostly sysctl_sched_packing_level = DEFAULT_PACKING_LEVEL;
 
 unsigned int sd_pack_threshold = (100 * 1024) / DEFAULT_PACKING_LEVEL;
 
+static inline int get_buddy(int cpu)
+{
+	return per_cpu(sd_pack_buddy, cpu).my_buddy;
+}
+
+static inline int get_leader(int cpu)
+{
+	return per_cpu(sd_pack_buddy, cpu).my_leader;
+}
 
 int sched_proc_update_packing(struct ctl_table *table, int write,
 		void __user *buffer, size_t *lenp,
@@ -219,13 +237,19 @@ int sched_proc_update_packing(struct ctl_table *table, int write,
 
 static inline bool is_packing_cpu(int cpu)
 {
-	int my_buddy = per_cpu(sd_pack_buddy, cpu);
+	int my_buddy = get_buddy(cpu);
 	return (my_buddy == -1) || (cpu == my_buddy);
 }
 
-static inline int get_buddy(int cpu)
+static inline bool is_leader_cpu(int cpu, struct sched_domain *sd)
 {
-	return per_cpu(sd_pack_buddy, cpu);
+	if (sd != per_cpu(sd_pack_buddy, cpu).domain)
+		return 0;
+
+	if (cpu != get_leader(cpu))
+		return 0;
+
+	return 1;
 }
 
 /*
@@ -239,7 +263,9 @@ static inline int get_buddy(int cpu)
 void update_packing_domain(int cpu)
 {
 	struct sched_domain *sd;
-	int id = -1;
+	struct sched_group *target = NULL;
+	struct sd_pack *pack = &per_cpu(sd_pack_buddy, cpu);
+	int id = cpu, pcpu = cpu;
 
 	sd = highest_flag_domain(cpu, SD_SHARE_POWERDOMAIN);
 	if (!sd)
@@ -247,6 +273,12 @@ void update_packing_domain(int cpu)
 	else
 		sd = sd->parent;
 
+	if (sd) {
+		pcpu = cpumask_first(sched_group_cpus(sd->groups));
+		if (pcpu != cpu)
+			goto end;
+	}
+
 	while (sd && (sd->flags & SD_LOAD_BALANCE)
 		&& !(sd->flags & SD_SHARE_POWERDOMAIN)) {
 		struct sched_group *sg = sd->groups;
@@ -258,15 +290,16 @@ void update_packing_domain(int cpu)
 		 * and this CPU of this local group is a good candidate
 		 */
 		id = cpu;
+		target = pack;
 
 		/* loop the sched groups to find the best one */
 		for (tmp = sg->next; tmp != sg; tmp = tmp->next) {
-			if (tmp->sgp->power * pack->group_weight >
-					pack->sgp->power * tmp->group_weight)
+			if (tmp->sgp->power_available * pack->group_weight >
+				pack->sgp->power_available * tmp->group_weight)
 				continue;
 
-			if ((tmp->sgp->power * pack->group_weight ==
-					pack->sgp->power * tmp->group_weight)
+			if ((tmp->sgp->power_available * pack->group_weight ==
+				pack->sgp->power_available * tmp->group_weight)
 			 && (cpumask_first(sched_group_cpus(tmp)) >= id))
 				continue;
 
@@ -275,6 +308,7 @@ void update_packing_domain(int cpu)
 
 			/* Take the 1st CPU of the new group */
 			id = cpumask_first(sched_group_cpus(pack));
+			target = pack;
 		}
 
 		/* Look for another CPU than itself */
@@ -284,15 +318,75 @@ void update_packing_domain(int cpu)
 		sd = sd->parent;
 	}
 
+end:
 	pr_debug("CPU%d packing on CPU%d\n", cpu, id);
-	per_cpu(sd_pack_buddy, cpu) = id;
+
+	pack->my_leader = pcpu;
+	pack->my_buddy = id;
+	pack->domain = sd;
+	pack->group = target;
 }
 
+
+void update_packing_buddy(int cpu, int activity)
+{
+	struct sched_group *tmp;
+	int id = cpu, pcpu = get_leader(cpu);
+
+	/* Get the state of 1st CPU of the power group */
+	if (!is_packing_cpu(pcpu))
+		id = get_buddy(pcpu);
+
+	if (cpu != pcpu)
+		goto end;
+
+	/* Set the activity level */
+	if (sysctl_sched_packing_level == 0)
+		activity = INT_MAX;
+	else
+		activity = (activity * sd_pack_threshold) / 1024;
+
+	tmp = per_cpu(sd_pack_buddy, cpu).group;
+	id = cpumask_first(sched_group_cpus(tmp));
+
+	/* Take the best group at this sd level to pack activity */
+	for (; activity > 0; tmp = tmp->next) {
+		int next;
+		if (tmp->sgp->power_available > activity) {
+			next = cpumask_first(sched_group_cpus(tmp));
+			while ((activity > 0) && (id < nr_cpu_ids)) {
+				activity -= available_of(id);
+				id = next;
+				if (pcpu == id) {
+					activity = 0;
+					id = cpu;
+				} else
+					next = cpumask_next(id,
+							sched_group_cpus(tmp));
+			}
+		} else if (cpumask_test_cpu(cpu, sched_group_cpus(tmp))) {
+			id = cpu;
+			activity = 0;
+		} else {
+			activity -= tmp->sgp->power_available;
+		}
+	}
+
+end:
+	per_cpu(sd_pack_buddy, cpu).my_buddy = id;
+}
+
+static int get_cpu_activity(int cpu);
+
 static int check_nohz_packing(int cpu)
 {
 	if (!is_packing_cpu(cpu))
 		return true;
 
+	if ((get_cpu_activity(cpu) * 100) >=
+			(available_of(cpu) * sysctl_sched_packing_level))
+		return true;
+
 	return false;
 }
 #else /* CONFIG_SCHED_PACKING_TASKS */
@@ -302,6 +396,11 @@ static inline bool is_packing_cpu(int cpu)
 	return 1;
 }
 
+static inline bool is_leader_cpu(int cpu, struct sched_domain *sd)
+{
+	return 1;
+}
+
 static inline int get_buddy(int cpu)
 {
 	return -1;
@@ -3443,6 +3542,7 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p,
 	do {
 		unsigned long load, avg_load;
 		int local_group, packing_cpus = 0;
+		unsigned int power;
 		int i;
 
 		/* Skip over this group if it has no CPUs allowed */
@@ -3472,8 +3572,13 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p,
 		if (!packing_cpus)
 			continue;
 
+		if (sd_flag & SD_BALANCE_WAKE)
+			power = group->sgp->power;
+		else
+			power = group->sgp->power_available;
+
 		/* Adjust by relative CPU power of the group */
-		avg_load = (avg_load * SCHED_POWER_SCALE) / group->sgp->power;
+		avg_load = (avg_load * SCHED_POWER_SCALE) / power;
 
 		if (local_group) {
 			this_load = avg_load;
@@ -4611,6 +4716,9 @@ static void update_cpu_power(struct sched_domain *sd, int cpu)
 	cpu_rq(cpu)->cpu_available = power;
 	sdg->sgp->power_available = power;
 
+	if (!is_packing_cpu(cpu))
+		power = 1;
+
 	cpu_rq(cpu)->cpu_power = power;
 	sdg->sgp->power = power;
 
@@ -4931,6 +5039,25 @@ static inline void update_sd_lb_stats(struct lb_env *env,
 	} while (sg != env->sd->groups);
 }
 
+#ifdef CONFIG_SCHED_PACKING_TASKS
+static void update_sd_lb_packing(int cpu, struct sd_lb_stats *sds,
+		struct sched_domain *sd)
+{
+	/* Update the list of packing CPU */
+	if (sd == per_cpu(sd_pack_buddy, cpu).domain)
+		update_packing_buddy(cpu, sds->total_activity);
+
+	/* This CPU doesn't act for agressive packing */
+	if (!is_packing_cpu(cpu))
+		sds->busiest = NULL;
+}
+
+#else /* CONFIG_SCHED_PACKING_TASKS */
+static void update_sd_lb_packing(int cpu, struct sd_lb_stats *sds,
+		struct sched_domain *sd) {}
+
+#endif /* CONFIG_SCHED_PACKING_TASKS */
+
 /**
  * check_asym_packing - Check to see if the group is packed into the
  *			sched doman.
@@ -5153,6 +5280,11 @@ static struct sched_group *find_busiest_group(struct lb_env *env)
 	local = &sds.local_stat;
 	busiest = &sds.busiest_stat;
 
+	/*
+	 * Update the involvement of the CPU in the packing effort
+	 */
+	update_sd_lb_packing(env->dst_cpu, &sds, env->sd);
+
 	if ((env->idle == CPU_IDLE || env->idle == CPU_NEWLY_IDLE) &&
 	    check_asym_packing(env, &sds))
 		return sds.busiest;
@@ -5312,6 +5444,10 @@ static int should_we_balance(struct lb_env *env)
 	if (env->idle == CPU_NEWLY_IDLE)
 		return 1;
 
+	/* Leader CPU must be used to update packing CPUs list */
+	if (is_leader_cpu(env->dst_cpu, env->sd))
+		return 1;
+
 	sg_cpus = sched_group_cpus(sg);
 	sg_mask = sched_group_mask(sg);
 	/* Try to find first idle cpu */
-- 
1.7.9.5

