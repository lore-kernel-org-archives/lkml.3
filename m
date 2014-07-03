Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759422AbaGCQbh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 12:31:37 -0400
Received: from service87.mimecast.com ([91.220.42.44]:45466 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759271AbaGCQ0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 12:26:17 -0400
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        peterz@infradead.org, mingo@kernel.org
Cc: rjw@rjwysocki.net, vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        preeti@linux.vnet.ibm.com, Dietmar.Eggemann@arm.com, pjt@google.com
Subject: [RFCv2 PATCH 12/23] sched: Rename weighted_cpuload() to cpu_load()
Date: Thu,  3 Jul 2014 17:25:59 +0100
Message-Id: <1404404770-323-13-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404404770-323-1-git-send-email-morten.rasmussen@arm.com>
References: <1404404770-323-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 03 Jul 2014 16:26:15.0897 (UTC) FILETIME=[83204C90:01CF96DB]
X-MC-Unique: 114070317261515201
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s63GVt0X010732

From: Dietmar Eggemann <dietmar.eggemann@arm.com>

The function weighted_cpuload() is the only one in the group of load
related functions used in the scheduler load balancing code
(weighted_cpuload(), source_load(), target_load(), task_h_load()) which
carries an explicit 'weighted' identifier in its name. Get rid of this
'weighted' identifier since following patches will introduce a
weighted/unweighted switch as an argument for these functions.

Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
---
 kernel/sched/fair.c |   33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 93c8dbe..784fdab 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1014,7 +1014,7 @@ bool should_numa_migrate_memory(struct task_struct *p, struct page * page,
 	return group_faults(p, dst_nid) < (group_faults(p, src_nid) * 3 / 4);
 }
 
-static unsigned long weighted_cpuload(const int cpu);
+static unsigned long cpu_load(const int cpu);
 static unsigned long source_load(int cpu, int type);
 static unsigned long target_load(int cpu, int type);
 static unsigned long capacity_of(int cpu);
@@ -1045,7 +1045,7 @@ static void update_numa_stats(struct numa_stats *ns, int nid)
 		struct rq *rq = cpu_rq(cpu);
 
 		ns->nr_running += rq->nr_running;
-		ns->load += weighted_cpuload(cpu);
+		ns->load += cpu_load(cpu);
 		ns->compute_capacity += capacity_of(cpu);
 
 		cpus++;
@@ -4036,7 +4036,7 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 
 #ifdef CONFIG_SMP
 /* Used instead of source_load when we know the type == 0 */
-static unsigned long weighted_cpuload(const int cpu)
+static unsigned long cpu_load(const int cpu)
 {
 	return cpu_rq(cpu)->cfs.runnable_load_avg;
 }
@@ -4051,7 +4051,7 @@ static unsigned long weighted_cpuload(const int cpu)
 static unsigned long source_load(int cpu, int type)
 {
 	struct rq *rq = cpu_rq(cpu);
-	unsigned long total = weighted_cpuload(cpu);
+	unsigned long total = cpu_load(cpu);
 
 	if (type == 0 || !sched_feat(LB_BIAS))
 		return total;
@@ -4066,7 +4066,7 @@ static unsigned long source_load(int cpu, int type)
 static unsigned long target_load(int cpu, int type)
 {
 	struct rq *rq = cpu_rq(cpu);
-	unsigned long total = weighted_cpuload(cpu);
+	unsigned long total = cpu_load(cpu);
 
 	if (type == 0 || !sched_feat(LB_BIAS))
 		return total;
@@ -4433,7 +4433,7 @@ find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
 
 	/* Traverse only the allowed CPUs */
 	for_each_cpu_and(i, sched_group_cpus(group), tsk_cpus_allowed(p)) {
-		load = weighted_cpuload(i);
+		load = cpu_load(i);
 
 		if (load < min_load || (load == min_load && i == this_cpu)) {
 			min_load = load;
@@ -5926,7 +5926,7 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 		sgs->nr_numa_running += rq->nr_numa_running;
 		sgs->nr_preferred_running += rq->nr_preferred_running;
 #endif
-		sgs->sum_weighted_load += weighted_cpuload(i);
+		sgs->sum_weighted_load += cpu_load(i);
 		if (idle_cpu(i))
 			sgs->idle_cpus++;
 	}
@@ -6388,7 +6388,7 @@ static struct rq *find_busiest_queue(struct lb_env *env,
 	int i;
 
 	for_each_cpu_and(i, sched_group_cpus(group), env->cpus) {
-		unsigned long capacity, capacity_factor, wl;
+		unsigned long capacity, capacity_factor, load;
 		enum fbq_type rt;
 
 		rq = cpu_rq(i);
@@ -6421,28 +6421,29 @@ static struct rq *find_busiest_queue(struct lb_env *env,
 		if (!capacity_factor)
 			capacity_factor = fix_small_capacity(env->sd, group);
 
-		wl = weighted_cpuload(i);
+		load = cpu_load(i);
 
 		/*
-		 * When comparing with imbalance, use weighted_cpuload()
+		 * When comparing with imbalance, use cpu_load()
 		 * which is not scaled with the cpu capacity.
 		 */
-		if (capacity_factor && rq->nr_running == 1 && wl > env->imbalance)
+		if (capacity_factor && rq->nr_running == 1 &&
+				load > env->imbalance)
 			continue;
 
 		/*
 		 * For the load comparisons with the other cpu's, consider
-		 * the weighted_cpuload() scaled with the cpu capacity, so
+		 * the cpu_load() scaled with the cpu capacity, so
 		 * that the load can be moved away from the cpu that is
 		 * potentially running at a lower capacity.
 		 *
-		 * Thus we're looking for max(wl_i / capacity_i), crosswise
+		 * Thus we're looking for max(load_i / capacity_i), crosswise
 		 * multiplication to rid ourselves of the division works out
-		 * to: wl_i * capacity_j > wl_j * capacity_i;  where j is
+		 * to: load_i * capacity_j > load_j * capacity_i;  where j is
 		 * our previous maximum.
 		 */
-		if (wl * busiest_capacity > busiest_load * capacity) {
-			busiest_load = wl;
+		if (load * busiest_capacity > busiest_load * capacity) {
+			busiest_load = load;
 			busiest_capacity = capacity;
 			busiest = rq;
 		}
-- 
1.7.9.5


