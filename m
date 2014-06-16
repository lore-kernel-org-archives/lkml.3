Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840AbaFPTsv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 15:48:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:10265 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755519AbaFPTsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 15:48:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,489,1400050800"; 
   d="scan'208";a="529393973"
Subject: [PATCH v2] sched: Fast idling of CPU when system is partially
 loaded
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Michel Lespinasse <walken@google.com>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>, Jason Low <jason.low2@hp.com>,
        Davidlohr Bueson <davidlohr@hp.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Jun 2014 12:48:47 -0700
Message-ID: <1402948127.2970.578.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks to the review from Jason and Peter.  I've moved the check
of whether load balance is required into fair.c's idle_balance.

When a system is lightly loaded (i.e. no more than 1 job per cpu),
attempt to pull job to a cpu before putting it to idle is unnecessary and
can be skipped.  This patch adds an indicator so the scheduler can know
when there's no more than 1 active job is on any CPU in the system to
skip needless job pulls.

On a 4 socket machine with a request/response kind of workload from
clients, we saw about 0.13 msec delay when we go through a full load
balance to try pull job from all the other cpus.  While 0.1 msec was
spent on processing the request and generating a response, the 0.13 msec
load balance overhead was actually more than the actual work being done.
This overhead can be skipped much of the time for lightly loaded systems.

With this patch, we tested with a netperf request/response workload that
has the server busy with half the cpus in a 4 socket system.  We found
the patch eliminated 75% of the load balance attempts before idling a cpu.

The overhead of setting/clearing the indicator is low as we already gather
the necessary info while we call add_nr_running and update_sd_lb_stats.
We switch to full load balance load immediately if any cpu got more than
one job on its run queue in add_nr_running.  We'll clear the indicator
to avoid load balance when we detect no cpu's have more than one job
when we scan the work queues in update_sg_lb_stats.  We are aggressive
in maintaining the load balance and opportunistic in skipping the load
balance.

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 kernel/sched/fair.c  | 24 +++++++++++++++++++++---
 kernel/sched/sched.h | 10 ++++++++--
 2 files changed, 29 insertions(+), 5 deletions(-)

Change log:
v2. 
1. Move the skip load balance code to idle_balance.
2. Use env->dst_rq->rd to get the root domain directly.

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 9855e87..95bb541 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5863,7 +5863,8 @@ static inline int sg_capacity(struct lb_env *env, struct sched_group *group)
  */
 static inline void update_sg_lb_stats(struct lb_env *env,
 			struct sched_group *group, int load_idx,
-			int local_group, struct sg_lb_stats *sgs)
+			int local_group, struct sg_lb_stats *sgs,
+			bool *overload)
 {
 	unsigned long load;
 	int i;
@@ -5881,6 +5882,8 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 
 		sgs->group_load += load;
 		sgs->sum_nr_running += rq->nr_running;
+		if (overload && rq->nr_running > 1)
+			*overload = true;
 #ifdef CONFIG_NUMA_BALANCING
 		sgs->nr_numa_running += rq->nr_numa_running;
 		sgs->nr_preferred_running += rq->nr_preferred_running;
@@ -5991,6 +5994,7 @@ static inline void update_sd_lb_stats(struct lb_env *env, struct sd_lb_stats *sd
 	struct sched_group *sg = env->sd->groups;
 	struct sg_lb_stats tmp_sgs;
 	int load_idx, prefer_sibling = 0;
+	bool overload = false;
 
 	if (child && child->flags & SD_PREFER_SIBLING)
 		prefer_sibling = 1;
@@ -6011,7 +6015,13 @@ static inline void update_sd_lb_stats(struct lb_env *env, struct sd_lb_stats *sd
 				update_group_power(env->sd, env->dst_cpu);
 		}
 
-		update_sg_lb_stats(env, sg, load_idx, local_group, sgs);
+		if (env->sd->parent)
+			update_sg_lb_stats(env, sg, load_idx, local_group, sgs,
+						NULL);
+		else
+			/* gather overload info if we are at root domain */
+			update_sg_lb_stats(env, sg, load_idx, local_group, sgs,
+						&overload);
 
 		if (local_group)
 			goto next_group;
@@ -6045,6 +6055,13 @@ next_group:
 
 	if (env->sd->flags & SD_NUMA)
 		env->fbq_type = fbq_classify_group(&sds->busiest_stat);
+
+	if (!env->sd->parent) {
+		/* update overload indicator if we are at root domain */
+		if (env->dst_rq->rd->overload != overload)
+			env->dst_rq->rd->overload = overload;
+	}
+
 }
 
 /**
@@ -6762,7 +6779,8 @@ static int idle_balance(struct rq *this_rq)
 	 */
 	this_rq->idle_stamp = rq_clock(this_rq);
 
-	if (this_rq->avg_idle < sysctl_sched_migration_cost) {
+	if (this_rq->avg_idle < sysctl_sched_migration_cost ||
+	    !this_rq->rd->overload) {
 		rcu_read_lock();
 		sd = rcu_dereference_check_sched_domain(this_rq->sd);
 		if (sd)
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index e47679b..396bce0 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -477,6 +477,9 @@ struct root_domain {
 	cpumask_var_t span;
 	cpumask_var_t online;
 
+	/* Indicate more than one runnable task for any CPU */
+	bool overload;
+
 	/*
 	 * The bit corresponding to a CPU gets set here if such CPU has more
 	 * than one runnable -deadline task (as it is below for RT tasks).
@@ -1212,15 +1215,18 @@ static inline void add_nr_running(struct rq *rq, unsigned count)
 
 	rq->nr_running = prev_nr + count;
 
-#ifdef CONFIG_NO_HZ_FULL
 	if (prev_nr < 2 && rq->nr_running >= 2) {
+		if (!rq->rd->overload)
+			rq->rd->overload = true;
+
+#ifdef CONFIG_NO_HZ_FULL
 		if (tick_nohz_full_cpu(rq->cpu)) {
 			/* Order rq->nr_running write against the IPI */
 			smp_wmb();
 			smp_send_reschedule(rq->cpu);
 		}
-       }
 #endif
+	}
 }
 
 static inline void sub_nr_running(struct rq *rq, unsigned count)
-- 
1.7.11.7


