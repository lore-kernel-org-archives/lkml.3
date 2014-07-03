Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759417AbaGCQ04 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 12:26:56 -0400
Received: from service87.mimecast.com ([91.220.42.44]:45993 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759297AbaGCQ01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 12:26:27 -0400
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        peterz@infradead.org, mingo@kernel.org
Cc: rjw@rjwysocki.net, vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        preeti@linux.vnet.ibm.com, Dietmar.Eggemann@arm.com, pjt@google.com
Subject: [RFCv2 PATCH 23/23] sched: Use energy model in load balance path
Date: Thu,  3 Jul 2014 17:26:10 +0100
Message-Id: <1404404770-323-24-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404404770-323-1-git-send-email-morten.rasmussen@arm.com>
References: <1404404770-323-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 03 Jul 2014 16:26:25.0631 (UTC) FILETIME=[88ED96F0:01CF96DB]
X-MC-Unique: 114070317262500801
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s63GR0gR010637

From: Dietmar Eggemann <dietmar.eggemann@arm.com>

Attempt to pick the source cpu which potentially gives the maximum energy
savings in case the minimum of the amount of utilization which the
destination cpu is additionally able to handle and the current
utilization on the source cpu is taken away from it and put on the
destination cpu instead.
Finding the optimum source requires an exhaustive search through all cpus
in the groups. Instead, the source group is determined based on
utilization and probing the energy cost on a single cpu in each group.

This implementation is not providing an actual energy aware load
balancing right now. It is only trying to showcase the way to find the
most suitable source queue (cpu) based on the energy aware data. The
actual load balance is still done based on the calculated load based
imbalance.

Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
---
 kernel/sched/fair.c |   88 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 83 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 2acd45a..1ce3a89 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4549,6 +4549,42 @@ static int energy_diff_task(int cpu, struct task_struct *p)
 			p->se.avg.wakeup_avg_sum);
 }
 
+static int energy_diff_cpu(int dst_cpu, int src_cpu)
+{
+	int util_diff, dst_nrg_diff, src_nrg_diff;
+	unsigned long src_curr_cap, src_util;
+	unsigned long dst_curr_cap = get_curr_capacity(dst_cpu);
+	unsigned long dst_util = cpu_load(dst_cpu, 1);
+
+	/*
+	 * If the destination cpu is already fully or even over-utilized
+	 * return error.
+	 */
+	if (dst_curr_cap <= dst_util)
+		return INT_MAX;
+
+	src_curr_cap = get_curr_capacity(src_cpu);
+	src_util = cpu_load(src_cpu, 1);
+
+	/*
+	 * If the source cpu is over-utilized return the minimum value
+	 * to indicate maximum potential energy savings. Performance
+	 * is still given priority over pure energy efficiency here.
+	 */
+	if (src_curr_cap < src_util)
+		return INT_MIN;
+
+	util_diff = min(dst_curr_cap - dst_util, src_util);
+
+	dst_nrg_diff = energy_diff_util(dst_cpu, util_diff, 0);
+	src_nrg_diff = energy_diff_util(src_cpu, -util_diff, 0);
+
+	if (dst_nrg_diff == INT_MAX || src_nrg_diff == INT_MAX)
+		return INT_MAX;
+
+	return dst_nrg_diff + src_nrg_diff;
+}
+
 static int wake_wide(struct task_struct *p)
 {
 	int factor = this_cpu_read(sd_llc_size);
@@ -5488,6 +5524,9 @@ struct lb_env {
 	unsigned int		loop_max;
 
 	enum fbq_type		fbq_type;
+
+	unsigned int use_ea;	/* Use energy aware lb */
+
 };
 
 /*
@@ -5957,6 +5996,7 @@ struct sg_lb_stats {
 	unsigned int nr_numa_running;
 	unsigned int nr_preferred_running;
 #endif
+	int nrg_diff; /* Maximum energy difference btwn dst_cpu and probe_cpu */
 };
 
 /*
@@ -5969,9 +6009,11 @@ struct sd_lb_stats {
 	unsigned long total_load;	/* Total load of all groups in sd */
 	unsigned long total_capacity;	/* Total capacity of all groups in sd */
 	unsigned long avg_load;	/* Average load across all groups in sd */
+	unsigned int use_ea;		/* Use energy aware lb */
 
 	struct sg_lb_stats busiest_stat;/* Statistics of the busiest group */
 	struct sg_lb_stats local_stat;	/* Statistics of the local group */
+
 };
 
 static inline void init_sd_lb_stats(struct sd_lb_stats *sds)
@@ -5987,8 +6029,10 @@ static inline void init_sd_lb_stats(struct sd_lb_stats *sds)
 		.local = NULL,
 		.total_load = 0UL,
 		.total_capacity = 0UL,
+		.use_ea = 0,
 		.busiest_stat = {
 			.avg_load = 0UL,
+			.nrg_diff = INT_MAX,
 		},
 	};
 }
@@ -6282,20 +6326,32 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 			struct sched_group *group, int load_idx,
 			int local_group, struct sg_lb_stats *sgs)
 {
-	unsigned long load;
-	int i;
+	unsigned long load, probe_util = 0;
+	int i, probe_cpu = cpumask_first(sched_group_cpus(group));
 
 	memset(sgs, 0, sizeof(*sgs));
 
+	sgs->nrg_diff = INT_MAX;
+
 	for_each_cpu_and(i, sched_group_cpus(group), env->cpus) {
 		struct rq *rq = cpu_rq(i);
 
 		/* Bias balancing toward cpus of our domain */
 		if (local_group)
 			load = target_load(i, load_idx, 0);
-		else
+		else {
 			load = source_load(i, load_idx, 0);
 
+			if (energy_aware()) {
+				unsigned long util = source_load(i, load_idx, 1);
+
+				if (probe_util < util) {
+					probe_util = util;
+					probe_cpu = i;
+				}
+			}
+		}
+
 		sgs->group_load += load;
 		sgs->sum_nr_running += rq->nr_running;
 #ifdef CONFIG_NUMA_BALANCING
@@ -6321,6 +6377,9 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 
 	if (sgs->group_capacity_factor > sgs->sum_nr_running)
 		sgs->group_has_free_capacity = 1;
+
+	if (energy_aware() && !local_group)
+		sgs->nrg_diff = energy_diff_cpu(env->dst_cpu, probe_cpu);
 }
 
 /**
@@ -6341,6 +6400,14 @@ static bool update_sd_pick_busiest(struct lb_env *env,
 				   struct sched_group *sg,
 				   struct sg_lb_stats *sgs)
 {
+	if (energy_aware()) {
+		if (sgs->nrg_diff < sds->busiest_stat.nrg_diff) {
+			sds->use_ea = 1;
+			return true;
+		}
+		sds->use_ea = 0;
+	}
+
 	if (sgs->avg_load <= sds->busiest_stat.avg_load)
 		return false;
 
@@ -6450,6 +6517,8 @@ static inline void update_sd_lb_stats(struct lb_env *env, struct sd_lb_stats *sd
 		if (update_sd_pick_busiest(env, sds, sg, sgs)) {
 			sds->busiest = sg;
 			sds->busiest_stat = *sgs;
+			if (energy_aware())
+				env->use_ea = sds->use_ea;
 		}
 
 next_group:
@@ -6761,7 +6830,7 @@ static struct rq *find_busiest_queue(struct lb_env *env,
 {
 	struct rq *busiest = NULL, *rq;
 	unsigned long busiest_load = 0, busiest_capacity = 1;
-	int i;
+	int i, min_nrg = INT_MAX;
 
 	for_each_cpu_and(i, sched_group_cpus(group), env->cpus) {
 		unsigned long capacity, capacity_factor, load;
@@ -6807,6 +6876,14 @@ static struct rq *find_busiest_queue(struct lb_env *env,
 				load > env->imbalance)
 			continue;
 
+		if (energy_aware() && env->use_ea) {
+			int nrg = energy_diff_cpu(env->dst_cpu, i);
+
+			if (nrg < min_nrg) {
+				min_nrg = nrg;
+				busiest = rq;
+			}
+		}
 		/*
 		 * For the load comparisons with the other cpu's, consider
 		 * the cpu_load() scaled with the cpu capacity, so
@@ -6818,7 +6895,7 @@ static struct rq *find_busiest_queue(struct lb_env *env,
 		 * to: load_i * capacity_j > load_j * capacity_i;  where j is
 		 * our previous maximum.
 		 */
-		if (load * busiest_capacity > busiest_load * capacity) {
+		else if (load * busiest_capacity > busiest_load * capacity) {
 			busiest_load = load;
 			busiest_capacity = capacity;
 			busiest = rq;
@@ -6915,6 +6992,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 		.loop_break	= sched_nr_migrate_break,
 		.cpus		= cpus,
 		.fbq_type	= all,
+		.use_ea		= 0,
 	};
 
 	/*
-- 
1.7.9.5


