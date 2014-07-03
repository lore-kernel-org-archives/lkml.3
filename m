Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759463AbaGCQ11 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 12:27:27 -0400
Received: from service87.mimecast.com ([91.220.42.44]:49002 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759085AbaGCQ1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 12:27:20 -0400
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        peterz@infradead.org, mingo@kernel.org
Cc: rjw@rjwysocki.net, vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        preeti@linux.vnet.ibm.com, Dietmar.Eggemann@arm.com, pjt@google.com
Subject: [RFCv2 PATCH 18/23] sched: Energy model functions
Date: Thu,  3 Jul 2014 17:26:05 +0100
Message-Id: <1404404770-323-19-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404404770-323-1-git-send-email-morten.rasmussen@arm.com>
References: <1404404770-323-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 03 Jul 2014 16:26:21.0053 (UTC) FILETIME=[86330AD0:01CF96DB]
X-MC-Unique: 114070317262007801
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s63GRWS0010648

Introduces energy_diff_util() which finds the energy impacts of adding
or removing utilization from a specific cpu. The calculation is based on
the energy information provided by the platform through sched_energy
data in the sched_domain hierarchy.

Task and cpu utilization is based on unweighted load tracking
(uw_load_avg_contrib) and unweighted cpu_load(cpu, 1) that is introduced
earlier in the patch set. While it isn't a perfect utilization metric,
it is better than weighted load. There are several other loose ends that
need to be addressed, such as load/utilization invariance and proper
representation of compute capacity. However, the energy model and
unweighted load metrics are there.

The energy cost model only considers utilization (busy time) and idle
energy (remaining time) for now. The basic idea is to determine the
energy cost at each level in the sched_domain hierarchy.

	for_each_domain(cpu, sd) {
		sg = sched_group_of(cpu)
		energy_before = curr_util(sg) * busy_power(sg)
				+ (1-curr_util(sg)) * idle_power(sg)
		energy_after = new_util(sg) * busy_power(sg)
				+ (1-new_util(sg)) * idle_power(sg)
		energy_diff += energy_before - energy_after
	}

Wake-ups energy is added later in this series.

Assumptions and the basic algorithm are described in the code comments.

Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
---
 kernel/sched/fair.c |  251 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 251 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 353e2d0..44ba754 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4249,6 +4249,32 @@ static long effective_load(struct task_group *tg, int cpu, long wl, long wg)
 
 #endif
 
+/*
+ * Energy model for energy-aware scheduling
+ *
+ * Assumptions:
+ *
+ * 1. Task and cpu load/utilization are assumed to be scale invariant. That is,
+ * task utilization is invariant to frequency scaling and cpu microarchitecture
+ * differences. For example, a task utilization of 256 means a cpu with a
+ * capacity of 1024 will be 25% busy running the task, while another cpu with a
+ * capacity of 512 will be 50% busy.
+ *
+ * 2. When capacity states are shared (SD_SHARE_CAP_STATES) the capacity state
+ * tables are equivalent. That is, the same table index can be used across all
+ * tables.
+ *
+ * 3. Only the lowest level in sched_domain hierarchy has SD_SHARE_CAP_STATES
+ * set. This restriction will be removed later.
+ *
+ * 4. No independent higher level capacity states. Cluster/package power states
+ * are either shared with cpus (SD_SHARE_CAP_STATES) or they only have one.
+ * This restriction will be removed later.
+ *
+ * 5. The scheduler doesn't control capacity (frequency) scaling, but assumes
+ * that the controller will adjust the capacity to match the utilization.
+ */
+
 static inline bool energy_aware(void)
 {
 	return sched_feat(ENERGY_AWARE);
@@ -4267,6 +4293,231 @@ static inline int likely_idle_state_idx(struct sched_group *sg)
 	return 0;
 }
 
+/*
+ * Find suitable capacity state for utilization.
+ * If over-utilized, return nr_cap_states.
+ */
+static int energy_match_cap(unsigned long util,
+		struct sched_group_energy *sge)
+{
+	int idx;
+
+	for (idx = 0; idx < sge->nr_cap_states; idx++) {
+		if (sge->cap_states[idx].cap >= util)
+			return idx;
+	}
+
+	return idx;
+}
+
+/*
+ * Find the max cpu utilization in a group of cpus before and after
+ * adding/removing tasks (util) from a specific cpu (cpu).
+ */
+static void find_max_util(const struct cpumask *mask, int cpu, int util,
+		unsigned long *max_util_bef, unsigned long *max_util_aft)
+{
+	int i;
+
+	*max_util_bef = 0;
+	*max_util_aft = 0;
+
+	for_each_cpu(i, mask) {
+		unsigned long cpu_util = cpu_load(i, 1);
+
+		*max_util_bef = max(*max_util_bef, cpu_util);
+
+		if (i == cpu)
+			cpu_util += util;
+
+		*max_util_aft = max(*max_util_aft, cpu_util);
+	}
+}
+
+static inline unsigned long get_curr_capacity(int cpu);
+
+/*
+ * Estimate the energy cost delta caused by adding/removing utilization (util)
+ * from a specific cpu (cpu).
+ *
+ * The basic idea is to determine the energy cost at each level in sched_domain
+ * hierarchy based on utilization:
+ *
+ * for_each_domain(cpu, sd) {
+ *	sg = sched_group_of(cpu)
+ *	energy_before = curr_util(sg) * busy_power(sg)
+ *				+ (1-curr_util(sg)) * idle_power(sg)
+ *	energy_after = new_util(sg) * busy_power(sg)
+ *				+ (1-new_util(sg)) * idle_power(sg)
+ *	energy_diff += energy_before - energy_after
+ * }
+ *
+ */
+static int energy_diff_util(int cpu, int util)
+{
+	struct sched_domain *sd;
+	int i;
+	int nrg_diff = 0;
+	int curr_cap_idx = -1;
+	int new_cap_idx = -1;
+	unsigned long max_util_bef, max_util_aft, aff_util_bef, aff_util_aft;
+	unsigned long unused_util_bef, unused_util_aft;
+	unsigned long cpu_curr_capacity;
+
+	cpu_curr_capacity = get_curr_capacity(cpu);
+
+	max_util_aft = cpu_load(cpu, 1) + util;
+
+	/* Can't remove more utilization than there is */
+	if (max_util_aft < 0) {
+		max_util_aft = 0;
+		util = -cpu_load(cpu, 1);
+	}
+
+	rcu_read_lock();
+	for_each_domain(cpu, sd) {
+		struct capacity_state *curr_state, *new_state, *cap_table;
+		struct idle_state *is;
+		struct sched_group_energy *sge;
+
+		if (!sd->groups->sge)
+			continue;
+
+		sge = sd->groups->sge;
+		cap_table = sge->cap_states;
+
+		if (curr_cap_idx < 0 || !(sd->flags & SD_SHARE_CAP_STATES)) {
+
+			/* TODO: Fix assumption 2 and 3. */
+			curr_cap_idx = energy_match_cap(cpu_curr_capacity, sge);
+
+			/*
+			 * If we remove tasks, i.e. util < 0, we should find
+			 * out if the cap state changes as well, but that is
+			 * complicated and might not be worth it. It is assumed
+			 * that the state won't be lowered for now.
+			 *
+			 * Also, if the cap state is shared new_cap_state can't
+			 * be lower than curr_cap_idx as the utilization on an
+			 * other cpu might have higher utilization than this
+			 * cpu.
+			 */
+
+			if (cap_table[curr_cap_idx].cap < max_util_aft) {
+				new_cap_idx = energy_match_cap(max_util_aft,
+						sge);
+				if (new_cap_idx >= sge->nr_cap_states) {
+					/*
+					 * Can't handle the additional
+					 * utilization
+					 */
+					nrg_diff = INT_MAX;
+					goto unlock;
+				}
+			} else {
+				new_cap_idx = curr_cap_idx;
+			}
+		}
+
+		curr_state = &cap_table[curr_cap_idx];
+		new_state = &cap_table[new_cap_idx];
+		find_max_util(sched_group_cpus(sd->groups), cpu, util,
+				&max_util_bef, &max_util_aft);
+		is = &sge->idle_states[likely_idle_state_idx(sd->groups)];
+
+		if (!sd->child) {
+			/* Lowest level - groups are individual cpus */
+			if (sd->flags & SD_SHARE_CAP_STATES) {
+				int sum_util = 0;
+				for_each_cpu(i, sched_domain_span(sd))
+					sum_util += cpu_load(i, 1);
+				aff_util_bef = sum_util;
+			} else {
+				aff_util_bef = cpu_load(cpu, 1);
+			}
+			aff_util_aft = aff_util_bef + util;
+
+			/* Estimate idle time based on unused utilization */
+			unused_util_bef = curr_state->cap
+						- cpu_load(cpu, 1);
+			unused_util_aft = new_state->cap - cpu_load(cpu, 1)
+						- util;
+		} else {
+			/* Higher level */
+			aff_util_bef = max_util_bef;
+			aff_util_aft = max_util_aft;
+
+			/* Estimate idle time based on unused utilization */
+			unused_util_bef = curr_state->cap
+					- min(aff_util_bef, curr_state->cap);
+			unused_util_aft = new_state->cap
+					- min(aff_util_aft, new_state->cap);
+		}
+
+		/*
+		 * The utilization change has no impact at this level (or any
+		 * parent level).
+		 */
+		if (aff_util_bef == aff_util_aft && curr_cap_idx == new_cap_idx)
+			goto unlock;
+
+		/* Energy before */
+		nrg_diff -= (aff_util_bef * curr_state->power)/curr_state->cap;
+		nrg_diff -= (unused_util_bef * is->power)/curr_state->cap;
+
+		/* Energy after */
+		nrg_diff += (aff_util_aft*new_state->power)/new_state->cap;
+		nrg_diff += (unused_util_aft * is->power)/new_state->cap;
+	}
+
+	/*
+	 * We don't have any sched_group covering all cpus in the sched_domain
+	 * hierarchy to associate system wide energy with. Treat it specially
+	 * for now until it can be folded into the loop above.
+	 */
+	if (sse) {
+		struct capacity_state *cap_table = sse->cap_states;
+		struct capacity_state *curr_state, *new_state;
+		struct idle_state *is;
+
+		curr_state = &cap_table[curr_cap_idx];
+		new_state = &cap_table[new_cap_idx];
+
+		find_max_util(cpu_online_mask, cpu, util, &aff_util_bef,
+				&aff_util_aft);
+		is = &sse->idle_states[likely_idle_state_idx(NULL)];
+
+		/* Estimate idle time based on unused utilization */
+		unused_util_bef = curr_state->cap - aff_util_bef;
+		unused_util_aft = new_state->cap - aff_util_aft;
+
+		/* Energy before */
+		nrg_diff -= (aff_util_bef*curr_state->power)/curr_state->cap;
+		nrg_diff -= (unused_util_bef * is->power)/curr_state->cap;
+
+		/* Energy after */
+		nrg_diff += (aff_util_aft*new_state->power)/new_state->cap;
+		nrg_diff += (unused_util_aft * is->power)/new_state->cap;
+	}
+
+unlock:
+	rcu_read_unlock();
+
+	return nrg_diff;
+}
+
+static int energy_diff_task(int cpu, struct task_struct *p)
+{
+	if (!energy_aware())
+		return INT_MAX;
+
+	if (!cpumask_test_cpu(cpu, tsk_cpus_allowed(p)))
+		return INT_MAX;
+
+	return energy_diff_util(cpu, p->se.avg.uw_load_avg_contrib);
+
+}
+
 static int wake_wide(struct task_struct *p)
 {
 	int factor = this_cpu_read(sd_llc_size);
-- 
1.7.9.5


