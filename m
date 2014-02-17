Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbaBQB5N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 20:57:13 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:65319 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbaBQB5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 20:57:10 -0500
From: Alex Shi <alex.shi@linaro.org>
To: mingo@redhat.com, peterz@infradead.org, morten.rasmussen@arm.com
Cc: vincent.guittot@linaro.org, daniel.lezcano@linaro.org, fweisbec@gmail.com,
        linux@arm.linux.org.uk, tony.luck@intel.com, fenghua.yu@intel.com,
        james.hogan@imgtec.com, alex.shi@linaro.org, jason.low2@hp.com,
        viresh.kumar@linaro.org, hanjun.guo@linaro.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, pjt@google.com,
        fengguang.wu@intel.com, linaro-kernel@lists.linaro.org,
        wangyun@linux.vnet.ibm.com
Subject: [PATCH v2 07/11] sched: clean up weighted_cpuload
Date: Mon, 17 Feb 2014 09:55:13 +0800
Message-Id: <1392602117-20773-8-git-send-email-alex.shi@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1392602117-20773-1-git-send-email-alex.shi@linaro.org>
References: <1392602117-20773-1-git-send-email-alex.shi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

weighted_cpuload is used instead of source_load() when !idx.
Now idx is always 0. so unify the usage to soruce_load. That make
code more readable.

Signed-off-by: Alex Shi <alex.shi@linaro.org>
---
 kernel/sched/fair.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 2da0e3b..5cdc838 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1045,7 +1045,7 @@ static void update_numa_stats(struct numa_stats *ns, int nid)
 		struct rq *rq = cpu_rq(cpu);
 
 		ns->nr_running += rq->nr_running;
-		ns->load += weighted_cpuload(cpu);
+		ns->load += source_load(cpu);
 		ns->power += power_of(cpu);
 
 		cpus++;
@@ -3940,7 +3940,7 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 
 #ifdef CONFIG_SMP
 /* Used instead of source_load when we know the type == 0 */
-static unsigned long weighted_cpuload(const int cpu)
+static inline unsigned long weighted_cpuload(const int cpu)
 {
 	return cpu_rq(cpu)->cfs.runnable_load_avg;
 }
@@ -4324,7 +4324,7 @@ find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
 
 	/* Traverse only the allowed CPUs */
 	for_each_cpu_and(i, sched_group_cpus(group), tsk_cpus_allowed(p)) {
-		load = weighted_cpuload(i);
+		load = source_load(i);
 
 		if (load < min_load || (load == min_load && i == this_cpu)) {
 			min_load = load;
@@ -5762,7 +5762,7 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 		sgs->nr_numa_running += rq->nr_numa_running;
 		sgs->nr_preferred_running += rq->nr_preferred_running;
 #endif
-		sgs->sum_weighted_load += weighted_cpuload(i);
+		sgs->sum_weighted_load += source_load(i);
 		if (idle_cpu(i))
 			sgs->idle_cpus++;
 	}
@@ -6248,10 +6248,10 @@ static struct rq *find_busiest_queue(struct lb_env *env,
 		if (!capacity)
 			capacity = fix_small_capacity(env->sd, group);
 
-		wl = weighted_cpuload(i);
+		wl = source_load(i);
 
 		/*
-		 * When comparing with imbalance, use weighted_cpuload()
+		 * When comparing with imbalance, use source_load()
 		 * which is not scaled with the cpu power.
 		 */
 		if (capacity && rq->nr_running == 1 && wl > env->imbalance)
@@ -6259,7 +6259,7 @@ static struct rq *find_busiest_queue(struct lb_env *env,
 
 		/*
 		 * For the load comparisons with the other cpu's, consider
-		 * the weighted_cpuload() scaled with the cpu power, so that
+		 * the source_load() scaled with the cpu power, so that
 		 * the load can be moved away from the cpu that is potentially
 		 * running at a lower capacity.
 		 *
-- 
1.8.1.2

