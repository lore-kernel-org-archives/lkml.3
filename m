Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767AbaEWSRA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 14:17:00 -0400
Received: from service87.mimecast.com ([91.220.42.44]:36460 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbaEWSQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 14:16:58 -0400
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        peterz@infradead.org, mingo@kernel.org
Cc: rjw@rjwysocki.net, vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        preeti@linux.vnet.ibm.com, dietmar.eggemann@arm.com
Subject: [RFC PATCH 15/16] sched: Use energy to guide wakeup task placement
Date: Fri, 23 May 2014 19:16:42 +0100
Message-Id: <1400869003-27769-16-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400869003-27769-1-git-send-email-morten.rasmussen@arm.com>
References: <1400869003-27769-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 23 May 2014 18:16:56.0432 (UTC) FILETIME=[2E41C700:01CF76B3]
X-MC-Unique: 114052319165605701
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s4NIHRSg005153

Attempt to pick most energy efficient wakeup in find_idlest_{group,
cpu}(). Finding the optimum target requires an exhaustive search
through all cpus in the groups. Instead, the target group is determined
based on load and probing the energy cost on a single cpu in each group.
The target cpu is the cpu with the lowest energy cost.

Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
---
 kernel/sched/fair.c |   64 +++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 52 insertions(+), 12 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 542c2b2..0d3334b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4556,25 +4556,27 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 }
 
 /*
- * find_idlest_group finds and returns the least busy CPU group within the
- * domain.
+ * find_target_group finds and returns the least busy/most energy-efficient
+ * CPU group within the domain.
  */
 static struct sched_group *
-find_idlest_group(struct sched_domain *sd, struct task_struct *p,
+find_target_group(struct sched_domain *sd, struct task_struct *p,
 		  int this_cpu, int sd_flag)
 {
-	struct sched_group *idlest = NULL, *group = sd->groups;
+	struct sched_group *idlest = NULL, *group = sd->groups, *energy = NULL;
 	unsigned long min_load = ULONG_MAX, this_load = 0;
 	int load_idx = sd->forkexec_idx;
 	int imbalance = 100 + (sd->imbalance_pct-100)/2;
+	int local_energy = 0, min_energy = INT_MAX;
 
 	if (sd_flag & SD_BALANCE_WAKE)
 		load_idx = sd->wake_idx;
 
 	do {
-		unsigned long load, avg_load;
+		unsigned long load, avg_load, probe_load = UINT_MAX;
 		int local_group;
 		int i;
+		int probe_cpu, energy_diff;
 
 		/* Skip over this group if it has no CPUs allowed */
 		if (!cpumask_intersects(sched_group_cpus(group),
@@ -4586,6 +4588,7 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p,
 
 		/* Tally up the load of all CPUs in the group */
 		avg_load = 0;
+		probe_cpu = cpumask_first(sched_group_cpus(group));
 
 		for_each_cpu(i, sched_group_cpus(group)) {
 			/* Bias balancing toward cpus of our domain */
@@ -4595,44 +4598,81 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p,
 				load = target_load(i, load_idx);
 
 			avg_load += load;
+
+			if (load < probe_load) {
+				probe_load = load;
+				probe_cpu = i;
+			}
 		}
 
 		/* Adjust by relative CPU power of the group */
 		avg_load = (avg_load * SCHED_POWER_SCALE) / group->sgp->power;
 
+		/*
+		 * Sample energy diff on probe_cpu.
+		 * Finding the optimum cpu requires testing all cpus which is
+		 * expensive.
+		 */
+
+		energy_diff = energy_diff_task(probe_cpu, p);
+
 		if (local_group) {
 			this_load = avg_load;
-		} else if (avg_load < min_load) {
-			min_load = avg_load;
-			idlest = group;
+			local_energy = energy_diff;
+		} else {
+			if (avg_load < min_load) {
+				min_load = avg_load;
+				idlest = group;
+			}
+
+			if (energy_diff < min_energy) {
+				min_energy = energy_diff;
+				energy = group;
+			}
 		}
 	} while (group = group->next, group != sd->groups);
 
+#ifdef CONFIG_SCHED_ENERGY
+	if (energy && min_energy < local_energy)
+		return energy;
+	return NULL;
+#else
 	if (!idlest || 100*this_load < imbalance*min_load)
 		return NULL;
 	return idlest;
+#endif
 }
 
 /*
- * find_idlest_cpu - find the idlest cpu among the cpus in group.
+ * find_target_cpu - find the target cpu among the cpus in group.
  */
 static int
-find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
+find_target_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
 {
 	unsigned long load, min_load = ULONG_MAX;
+	int min_energy = INT_MAX, energy, least_energy = -1;
 	int idlest = -1;
 	int i;
 
 	/* Traverse only the allowed CPUs */
 	for_each_cpu_and(i, sched_group_cpus(group), tsk_cpus_allowed(p)) {
 		load = weighted_cpuload(i);
+		energy = energy_diff_task(i, p);
 
 		if (load < min_load || (load == min_load && i == this_cpu)) {
 			min_load = load;
 			idlest = i;
 		}
+
+		if (energy < min_energy) {
+			min_energy = energy;
+			least_energy = i;
+		}
 	}
 
+	if (least_energy >= 0)
+		return least_energy;
+
 	return idlest;
 }
 
@@ -4755,13 +4795,13 @@ select_task_rq_fair(struct task_struct *p, int prev_cpu, int sd_flag, int wake_f
 			continue;
 		}
 
-		group = find_idlest_group(sd, p, cpu, sd_flag);
+		group = find_target_group(sd, p, cpu, sd_flag);
 		if (!group) {
 			sd = sd->child;
 			continue;
 		}
 
-		new_cpu = find_idlest_cpu(group, p, cpu);
+		new_cpu = find_target_cpu(group, p, cpu);
 		if (new_cpu == -1 || new_cpu == cpu) {
 			/* Now try balancing at a lower domain level of cpu */
 			sd = sd->child;
-- 
1.7.9.5


