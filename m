Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965300AbaGEKpf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 06:45:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58010 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719AbaGEKp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 06:45:28 -0400
Date: Sat, 5 Jul 2014 03:44:11 -0700
From: tip-bot for Tim Chen <tipbot@zytor.com>
Message-ID: <tip-4486edd12b5ac8a9af7a5e16e4b9eeb3b8339c10@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tim.c.chen@linux.intel.com, peter@hurleysoftware.com,
        jason.low2@hp.com, alex.shi@linaro.org, riel@redhat.com,
        paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
        tglx@linutronix.de, walken@google.com, davidlohr@hp.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tim.c.chen@linux.intel.com, jason.low2@hp.com,
        peter@hurleysoftware.com, paulmck@linux.vnet.ibm.com, riel@redhat.com,
        alex.shi@linaro.org, akpm@linux-foundation.org, tglx@linutronix.de,
        davidlohr@hp.com, walken@google.com
In-Reply-To: <1403551009.2970.613.camel@schen9-DESK>
References: <1403551009.2970.613.camel@schen9-DESK>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/fair:
  Implement fast idling of CPUs when the system is partially loaded
Git-Commit-ID: 4486edd12b5ac8a9af7a5e16e4b9eeb3b8339c10
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4486edd12b5ac8a9af7a5e16e4b9eeb3b8339c10
Gitweb:     http://git.kernel.org/tip/4486edd12b5ac8a9af7a5e16e4b9eeb3b8339c10
Author:     Tim Chen <tim.c.chen@linux.intel.com>
AuthorDate: Mon, 23 Jun 2014 12:16:49 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 5 Jul 2014 11:17:32 +0200

sched/fair: Implement fast idling of CPUs when the system is partially loaded

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
the necessary info while we call add_nr_running() and update_sd_lb_stats.()
We switch to full load balance load immediately if any cpu got more than
one job on its run queue in add_nr_running.  We'll clear the indicator
to avoid load balance when we detect no cpu's have more than one job
when we scan the work queues in update_sg_lb_stats().  We are aggressive
in turning on the load balance and opportunistic in skipping the load
balance.

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Jason Low <jason.low2@hp.com>
Cc: "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Alex Shi <alex.shi@linaro.org>
Cc: Michel Lespinasse <walken@google.com>
Cc: Peter Hurley <peter@hurleysoftware.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1403551009.2970.613.camel@schen9-DESK
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c  | 21 ++++++++++++++++++---
 kernel/sched/sched.h | 12 ++++++++++--
 2 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index ef5eac7..e3ff3d1 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5866,7 +5866,8 @@ static inline int sg_capacity_factor(struct lb_env *env, struct sched_group *gro
  */
 static inline void update_sg_lb_stats(struct lb_env *env,
 			struct sched_group *group, int load_idx,
-			int local_group, struct sg_lb_stats *sgs)
+			int local_group, struct sg_lb_stats *sgs,
+			bool *overload)
 {
 	unsigned long load;
 	int i;
@@ -5884,6 +5885,10 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 
 		sgs->group_load += load;
 		sgs->sum_nr_running += rq->nr_running;
+
+		if (rq->nr_running > 1)
+			*overload = true;
+
 #ifdef CONFIG_NUMA_BALANCING
 		sgs->nr_numa_running += rq->nr_numa_running;
 		sgs->nr_preferred_running += rq->nr_preferred_running;
@@ -5994,6 +5999,7 @@ static inline void update_sd_lb_stats(struct lb_env *env, struct sd_lb_stats *sd
 	struct sched_group *sg = env->sd->groups;
 	struct sg_lb_stats tmp_sgs;
 	int load_idx, prefer_sibling = 0;
+	bool overload = false;
 
 	if (child && child->flags & SD_PREFER_SIBLING)
 		prefer_sibling = 1;
@@ -6014,7 +6020,8 @@ static inline void update_sd_lb_stats(struct lb_env *env, struct sd_lb_stats *sd
 				update_group_capacity(env->sd, env->dst_cpu);
 		}
 
-		update_sg_lb_stats(env, sg, load_idx, local_group, sgs);
+		update_sg_lb_stats(env, sg, load_idx, local_group, sgs,
+						&overload);
 
 		if (local_group)
 			goto next_group;
@@ -6048,6 +6055,13 @@ next_group:
 
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
@@ -6766,7 +6780,8 @@ static int idle_balance(struct rq *this_rq)
 	 */
 	this_rq->idle_stamp = rq_clock(this_rq);
 
-	if (this_rq->avg_idle < sysctl_sched_migration_cost) {
+	if (this_rq->avg_idle < sysctl_sched_migration_cost ||
+	    !this_rq->rd->overload) {
 		rcu_read_lock();
 		sd = rcu_dereference_check_sched_domain(this_rq->sd);
 		if (sd)
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index eb85676..0191ed5 100644
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
@@ -1218,8 +1221,13 @@ static inline void add_nr_running(struct rq *rq, unsigned count)
 
 	rq->nr_running = prev_nr + count;
 
-#ifdef CONFIG_NO_HZ_FULL
 	if (prev_nr < 2 && rq->nr_running >= 2) {
+#ifdef CONFIG_SMP
+		if (!rq->rd->overload)
+			rq->rd->overload = true;
+#endif
+
+#ifdef CONFIG_NO_HZ_FULL
 		if (tick_nohz_full_cpu(rq->cpu)) {
 			/*
 			 * Tick is needed if more than one task runs on a CPU.
@@ -1231,8 +1239,8 @@ static inline void add_nr_running(struct rq *rq, unsigned count)
 			 */
 			tick_nohz_full_kick_cpu(rq->cpu);
 		}
-       }
 #endif
+	}
 }
 
 static inline void sub_nr_running(struct rq *rq, unsigned count)
