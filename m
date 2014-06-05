Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497AbaFEOgO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:36:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48402 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbaFEOgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:36:10 -0400
Date: Thu, 5 Jun 2014 07:35:28 -0700
From: tip-bot for Nicolas Pitre <tipbot@zytor.com>
Message-ID: <tip-djzkk027jm0e8x8jxy70opzh@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        nicolas.pitre@linaro.org, morten.rasmussen@arm.com, nico@linaro.org,
        vincent.guittot@linaro.org, rjw@rjwysocki.net, tglx@linutronix.de,
        daniel.lezcano@linaro.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        nicolas.pitre@linaro.org, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, nico@linaro.org, tglx@linutronix.de,
        rjw@rjwysocki.net, daniel.lezcano@linaro.org
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/fair: Change "has_capacity" to "
 has_free_capacity"
Git-Commit-ID: 1b6a7495d343fcfe22ff3a8285544bb8e40f1920
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

Commit-ID:  1b6a7495d343fcfe22ff3a8285544bb8e40f1920
Gitweb:     http://git.kernel.org/tip/1b6a7495d343fcfe22ff3a8285544bb8e40f1920
Author:     Nicolas Pitre <nicolas.pitre@linaro.org>
AuthorDate: Mon, 26 May 2014 18:19:35 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 5 Jun 2014 11:52:22 +0200

sched/fair: Change "has_capacity" to "has_free_capacity"

The capacity of a CPU/group should be some intrinsic value that doesn't
change with task placement.  It is like a container which capacity is
stable regardless of the amount of liquid in it (its "utilization")...
unless the container itself is crushed that is, but that's another story.

Therefore let's rename "has_capacity" to "has_free_capacity" in order to
better convey the wanted meaning.

Signed-off-by: Nicolas Pitre <nico@linaro.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linaro-kernel@lists.linaro.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Link: http://lkml.kernel.org/n/tip-djzkk027jm0e8x8jxy70opzh@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 1cfe5a2..8993dfa 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1030,7 +1030,7 @@ struct numa_stats {
 
 	/* Approximate capacity in terms of runnable tasks on a node */
 	unsigned long task_capacity;
-	int has_capacity;
+	int has_free_capacity;
 };
 
 /*
@@ -1056,8 +1056,8 @@ static void update_numa_stats(struct numa_stats *ns, int nid)
 	 * the @ns structure is NULL'ed and task_numa_compare() will
 	 * not find this node attractive.
 	 *
-	 * We'll either bail at !has_capacity, or we'll detect a huge imbalance
-	 * and bail there.
+	 * We'll either bail at !has_free_capacity, or we'll detect a huge
+	 * imbalance and bail there.
 	 */
 	if (!cpus)
 		return;
@@ -1065,7 +1065,7 @@ static void update_numa_stats(struct numa_stats *ns, int nid)
 	ns->load = (ns->load * SCHED_POWER_SCALE) / ns->compute_capacity;
 	ns->task_capacity =
 		DIV_ROUND_CLOSEST(ns->compute_capacity, SCHED_POWER_SCALE);
-	ns->has_capacity = (ns->nr_running < ns->task_capacity);
+	ns->has_free_capacity = (ns->nr_running < ns->task_capacity);
 }
 
 struct task_numa_env {
@@ -1196,8 +1196,8 @@ static void task_numa_compare(struct task_numa_env *env,
 
 	if (!cur) {
 		/* Is there capacity at our destination? */
-		if (env->src_stats.has_capacity &&
-		    !env->dst_stats.has_capacity)
+		if (env->src_stats.has_free_capacity &&
+		    !env->dst_stats.has_free_capacity)
 			goto unlock;
 
 		goto balance;
@@ -1302,8 +1302,8 @@ static int task_numa_migrate(struct task_struct *p)
 	groupimp = group_weight(p, env.dst_nid) - groupweight;
 	update_numa_stats(&env.dst_stats, env.dst_nid);
 
-	/* If the preferred nid has capacity, try to use it. */
-	if (env.dst_stats.has_capacity)
+	/* If the preferred nid has free capacity, try to use it. */
+	if (env.dst_stats.has_free_capacity)
 		task_numa_find_cpu(&env, taskimp, groupimp);
 
 	/* No space available on the preferred nid. Look elsewhere. */
@@ -5538,7 +5538,7 @@ struct sg_lb_stats {
 	unsigned int idle_cpus;
 	unsigned int group_weight;
 	int group_imb; /* Is there an imbalance in the group ? */
-	int group_has_capacity; /* Is there extra capacity in the group? */
+	int group_has_free_capacity;
 #ifdef CONFIG_NUMA_BALANCING
 	unsigned int nr_numa_running;
 	unsigned int nr_preferred_running;
@@ -5905,7 +5905,7 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 	sgs->group_capacity = sg_capacity(env, group);
 
 	if (sgs->group_capacity > sgs->sum_nr_running)
-		sgs->group_has_capacity = 1;
+		sgs->group_has_free_capacity = 1;
 }
 
 /**
@@ -6029,7 +6029,7 @@ static inline void update_sd_lb_stats(struct lb_env *env, struct sd_lb_stats *sd
 		 * with a large weight task outweighs the tasks on the system).
 		 */
 		if (prefer_sibling && sds->local &&
-		    sds->local_stat.group_has_capacity)
+		    sds->local_stat.group_has_free_capacity)
 			sgs->group_capacity = min(sgs->group_capacity, 1U);
 
 		if (update_sd_pick_busiest(env, sds, sg, sgs)) {
@@ -6289,8 +6289,8 @@ static struct sched_group *find_busiest_group(struct lb_env *env)
 		goto force_balance;
 
 	/* SD_BALANCE_NEWIDLE trumps SMP nice when underutilized */
-	if (env->idle == CPU_NEWLY_IDLE && local->group_has_capacity &&
-	    !busiest->group_has_capacity)
+	if (env->idle == CPU_NEWLY_IDLE && local->group_has_free_capacity &&
+	    !busiest->group_has_free_capacity)
 		goto force_balance;
 
 	/*
