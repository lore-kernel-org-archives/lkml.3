Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759399AbaGCQ0k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 12:26:40 -0400
Received: from service87.mimecast.com ([91.220.42.44]:46035 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759368AbaGCQ01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 12:26:27 -0400
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        peterz@infradead.org, mingo@kernel.org
Cc: rjw@rjwysocki.net, vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        preeti@linux.vnet.ibm.com, Dietmar.Eggemann@arm.com, pjt@google.com
Subject: [RFCv2 PATCH 22/23] sched: Use energy to guide wakeup task placement
Date: Thu,  3 Jul 2014 17:26:09 +0100
Message-Id: <1404404770-323-23-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404404770-323-1-git-send-email-morten.rasmussen@arm.com>
References: <1404404770-323-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 03 Jul 2014 16:26:24.0834 (UTC) FILETIME=[8873FA20:01CF96DB]
X-MC-Unique: 114070317262600201
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s63GQiLB010631

Attempt to pick most energy efficient wakeup in find_idlest_{group,
cpu}(). Finding the optimum target requires an exhaustive search
through all cpus in the groups. Instead, the target group is determined
based on load and probing the energy cost on a single cpu in each group.
The target cpu is the cpu with the lowest energy cost.

Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
---
 kernel/sched/fair.c |   71 +++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 57 insertions(+), 14 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index a32d6eb..2acd45a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4662,25 +4662,27 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
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
+	int local_nrg = 0, min_nrg = INT_MAX;
 
 	if (sd_flag & SD_BALANCE_WAKE)
 		load_idx = sd->wake_idx;
 
 	do {
-		unsigned long load, avg_load;
+		unsigned long load, avg_load, util, probe_util = UINT_MAX;
 		int local_group;
 		int i;
+		int probe_cpu, nrg_diff;
 
 		/* Skip over this group if it has no CPUs allowed */
 		if (!cpumask_intersects(sched_group_cpus(group),
@@ -4692,53 +4694,94 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p,
 
 		/* Tally up the load of all CPUs in the group */
 		avg_load = 0;
+		probe_cpu = cpumask_first(sched_group_cpus(group));
 
 		for_each_cpu(i, sched_group_cpus(group)) {
 			/* Bias balancing toward cpus of our domain */
-			if (local_group)
+			if (local_group) {
 				load = source_load(i, load_idx, 0);
-			else
+				util = source_load(i, load_idx, 1);
+			} else {
 				load = target_load(i, load_idx, 0);
+				util = target_load(i, load_idx, 1);
+			}
 
 			avg_load += load;
+
+			if (util < probe_util) {
+				probe_util = util;
+				probe_cpu = i;
+			}
 		}
 
 		/* Adjust by relative CPU capacity of the group */
 		avg_load = (avg_load * SCHED_CAPACITY_SCALE) / group->sgc->capacity;
 
+		/*
+		 * Sample energy diff on probe_cpu.
+		 * Finding the optimum cpu requires testing all cpus which is
+		 * expensive.
+		 */
+
+		nrg_diff = energy_diff_task(probe_cpu, p);
+
 		if (local_group) {
 			this_load = avg_load;
-		} else if (avg_load < min_load) {
-			min_load = avg_load;
-			idlest = group;
+			local_nrg = nrg_diff;
+		} else {
+			if (avg_load < min_load) {
+				min_load = avg_load;
+				idlest = group;
+			}
+
+			if (nrg_diff < min_nrg) {
+				min_nrg = nrg_diff;
+				energy = group;
+			}
 		}
 	} while (group = group->next, group != sd->groups);
 
+	if (energy_aware()) {
+		if (energy && min_nrg < local_nrg)
+			return energy;
+		return NULL;
+	}
+
 	if (!idlest || 100*this_load < imbalance*min_load)
 		return NULL;
 	return idlest;
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
+	int min_nrg = INT_MAX, nrg, least_nrg = -1;
 	int idlest = -1;
 	int i;
 
 	/* Traverse only the allowed CPUs */
 	for_each_cpu_and(i, sched_group_cpus(group), tsk_cpus_allowed(p)) {
 		load = cpu_load(i, 0);
+		nrg = energy_diff_task(i, p);
 
 		if (load < min_load || (load == min_load && i == this_cpu)) {
 			min_load = load;
 			idlest = i;
 		}
+
+		if (nrg < min_nrg) {
+			min_nrg = nrg;
+			least_nrg = i;
+		}
 	}
 
+	if (least_nrg >= 0)
+		return least_nrg;
+
 	return idlest;
 }
 
@@ -4886,13 +4929,13 @@ select_task_rq_fair(struct task_struct *p, int prev_cpu, int sd_flag, int wake_f
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


