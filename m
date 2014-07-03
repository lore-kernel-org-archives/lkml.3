Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759317AbaGCQbU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 12:31:20 -0400
Received: from service87.mimecast.com ([91.220.42.44]:45531 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759286AbaGCQ0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 12:26:18 -0400
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        peterz@infradead.org, mingo@kernel.org
Cc: rjw@rjwysocki.net, vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        preeti@linux.vnet.ibm.com, Dietmar.Eggemann@arm.com, pjt@google.com
Subject: [RFCv2 PATCH 13/23] sched: Introduce weighted/unweighted switch in load related functions
Date: Thu,  3 Jul 2014 17:26:00 +0100
Message-Id: <1404404770-323-14-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404404770-323-1-git-send-email-morten.rasmussen@arm.com>
References: <1404404770-323-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 03 Jul 2014 16:26:16.0694 (UTC) FILETIME=[8399E960:01CF96DB]
X-MC-Unique: 114070317261614801
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s63GVPfw010722

From: Dietmar Eggemann <dietmar.eggemann@arm.com>

Add weighted/unweighted switch as an additional argument to cpu_load(),
source_load(), target_load() and task_h_load() to enable the user to
either ask for weighted or unweighted load signal. Use 0 (weighted) for
all existing occurrences of these functions.

Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
---
 kernel/sched/fair.c |   65 +++++++++++++++++++++++++++------------------------
 1 file changed, 35 insertions(+), 30 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 784fdab..37e9ea1 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -665,7 +665,7 @@ static u64 sched_vslice(struct cfs_rq *cfs_rq, struct sched_entity *se)
 }
 
 #ifdef CONFIG_SMP
-static unsigned long task_h_load(struct task_struct *p);
+static unsigned long task_h_load(struct task_struct *p, int uw);
 
 static inline void __update_task_entity_contrib(struct sched_entity *se);
 
@@ -1014,9 +1014,9 @@ bool should_numa_migrate_memory(struct task_struct *p, struct page * page,
 	return group_faults(p, dst_nid) < (group_faults(p, src_nid) * 3 / 4);
 }
 
-static unsigned long cpu_load(const int cpu);
-static unsigned long source_load(int cpu, int type);
-static unsigned long target_load(int cpu, int type);
+static unsigned long cpu_load(const int cpu, int uw);
+static unsigned long source_load(int cpu, int type, int uw);
+static unsigned long target_load(int cpu, int type, int uw);
 static unsigned long capacity_of(int cpu);
 static long effective_load(struct task_group *tg, int cpu, long wl, long wg);
 
@@ -1045,7 +1045,7 @@ static void update_numa_stats(struct numa_stats *ns, int nid)
 		struct rq *rq = cpu_rq(cpu);
 
 		ns->nr_running += rq->nr_running;
-		ns->load += cpu_load(cpu);
+		ns->load += cpu_load(cpu, 0);
 		ns->compute_capacity += capacity_of(cpu);
 
 		cpus++;
@@ -1215,12 +1215,12 @@ balance:
 	orig_src_load = env->src_stats.load;
 
 	/* XXX missing capacity terms */
-	load = task_h_load(env->p);
+	load = task_h_load(env->p, 0);
 	dst_load = orig_dst_load + load;
 	src_load = orig_src_load - load;
 
 	if (cur) {
-		load = task_h_load(cur);
+		load = task_h_load(cur, 0);
 		dst_load -= load;
 		src_load += load;
 	}
@@ -4036,9 +4036,10 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 
 #ifdef CONFIG_SMP
 /* Used instead of source_load when we know the type == 0 */
-static unsigned long cpu_load(const int cpu)
+static unsigned long cpu_load(const int cpu, int uw)
 {
-	return cpu_rq(cpu)->cfs.runnable_load_avg;
+	return uw ? cpu_rq(cpu)->cfs.uw_runnable_load_avg :
+			cpu_rq(cpu)->cfs.runnable_load_avg;
 }
 
 /*
@@ -4048,30 +4049,32 @@ static unsigned long cpu_load(const int cpu)
  * We want to under-estimate the load of migration sources, to
  * balance conservatively.
  */
-static unsigned long source_load(int cpu, int type)
+static unsigned long source_load(int cpu, int type, int uw)
 {
 	struct rq *rq = cpu_rq(cpu);
-	unsigned long total = cpu_load(cpu);
+	unsigned long total = cpu_load(cpu, uw);
 
 	if (type == 0 || !sched_feat(LB_BIAS))
 		return total;
 
-	return min(rq->cpu_load[type-1], total);
+	return uw ? min(rq->uw_cpu_load[type-1], total) :
+			min(rq->cpu_load[type-1], total);
 }
 
 /*
  * Return a high guess at the load of a migration-target cpu weighted
  * according to the scheduling class and "nice" value.
  */
-static unsigned long target_load(int cpu, int type)
+static unsigned long target_load(int cpu, int type, int uw)
 {
 	struct rq *rq = cpu_rq(cpu);
-	unsigned long total = cpu_load(cpu);
+	unsigned long total = cpu_load(cpu, uw);
 
 	if (type == 0 || !sched_feat(LB_BIAS))
 		return total;
 
-	return max(rq->cpu_load[type-1], total);
+	return uw ? max(rq->uw_cpu_load[type-1], total) :
+			max(rq->cpu_load[type-1], total);
 }
 
 static unsigned long capacity_of(int cpu)
@@ -4292,8 +4295,8 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 	idx	  = sd->wake_idx;
 	this_cpu  = smp_processor_id();
 	prev_cpu  = task_cpu(p);
-	load	  = source_load(prev_cpu, idx);
-	this_load = target_load(this_cpu, idx);
+	load	  = source_load(prev_cpu, idx, 0);
+	this_load = target_load(this_cpu, idx, 0);
 
 	/*
 	 * If sync wakeup then subtract the (maximum possible)
@@ -4349,7 +4352,7 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 
 	if (balanced ||
 	    (this_load <= load &&
-	     this_load + target_load(prev_cpu, idx) <= tl_per_task)) {
+	     this_load + target_load(prev_cpu, idx, 0) <= tl_per_task)) {
 		/*
 		 * This domain has SD_WAKE_AFFINE and
 		 * p is cache cold in this domain, and
@@ -4398,9 +4401,9 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p,
 		for_each_cpu(i, sched_group_cpus(group)) {
 			/* Bias balancing toward cpus of our domain */
 			if (local_group)
-				load = source_load(i, load_idx);
+				load = source_load(i, load_idx, 0);
 			else
-				load = target_load(i, load_idx);
+				load = target_load(i, load_idx, 0);
 
 			avg_load += load;
 		}
@@ -4433,7 +4436,7 @@ find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
 
 	/* Traverse only the allowed CPUs */
 	for_each_cpu_and(i, sched_group_cpus(group), tsk_cpus_allowed(p)) {
-		load = cpu_load(i);
+		load = cpu_load(i, 0);
 
 		if (load < min_load || (load == min_load && i == this_cpu)) {
 			min_load = load;
@@ -5402,7 +5405,7 @@ static int move_tasks(struct lb_env *env)
 		if (!can_migrate_task(p, env))
 			goto next;
 
-		load = task_h_load(p);
+		load = task_h_load(p, 0);
 
 		if (sched_feat(LB_MIN) && load < 16 && !env->sd->nr_balance_failed)
 			goto next;
@@ -5542,12 +5545,14 @@ static void update_cfs_rq_h_load(struct cfs_rq *cfs_rq)
 	}
 }
 
-static unsigned long task_h_load(struct task_struct *p)
+static unsigned long task_h_load(struct task_struct *p, int uw)
 {
 	struct cfs_rq *cfs_rq = task_cfs_rq(p);
+	unsigned long task_load = uw ? p->se.avg.uw_load_avg_contrib
+				     : p->se.avg.load_avg_contrib;
 
 	update_cfs_rq_h_load(cfs_rq);
-	return div64_ul(p->se.avg.load_avg_contrib * cfs_rq->h_load,
+	return div64_ul(task_load * cfs_rq->h_load,
 			cfs_rq->runnable_load_avg + 1);
 }
 #else
@@ -5555,9 +5560,9 @@ static inline void update_blocked_averages(int cpu)
 {
 }
 
-static unsigned long task_h_load(struct task_struct *p)
+static unsigned long task_h_load(struct task_struct *p, int uw)
 {
-	return p->se.avg.load_avg_contrib;
+	return uw ? p->se.avg.uw_load_avg_contrib : p->se.avg.load_avg_contrib;
 }
 #endif
 
@@ -5916,9 +5921,9 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 
 		/* Bias balancing toward cpus of our domain */
 		if (local_group)
-			load = target_load(i, load_idx);
+			load = target_load(i, load_idx, 0);
 		else
-			load = source_load(i, load_idx);
+			load = source_load(i, load_idx, 0);
 
 		sgs->group_load += load;
 		sgs->sum_nr_running += rq->nr_running;
@@ -5926,7 +5931,7 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 		sgs->nr_numa_running += rq->nr_numa_running;
 		sgs->nr_preferred_running += rq->nr_preferred_running;
 #endif
-		sgs->sum_weighted_load += cpu_load(i);
+		sgs->sum_weighted_load += cpu_load(i, 0);
 		if (idle_cpu(i))
 			sgs->idle_cpus++;
 	}
@@ -6421,7 +6426,7 @@ static struct rq *find_busiest_queue(struct lb_env *env,
 		if (!capacity_factor)
 			capacity_factor = fix_small_capacity(env->sd, group);
 
-		load = cpu_load(i);
+		load = cpu_load(i, 0);
 
 		/*
 		 * When comparing with imbalance, use cpu_load()
-- 
1.7.9.5


