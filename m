Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817AbaENU75 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 16:59:57 -0400
Received: from relais.videotron.ca ([24.201.245.36]:62660 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217AbaENU7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 16:59:55 -0400
Content-transfer-encoding: 7BIT
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Subject: [PATCH 2/6] sched/fair.c: change "has_capacity" to "has_free_capacity"
Date: Wed, 14 May 2014 16:57:06 -0400
Message-id: <1400101030-17717-3-git-send-email-nicolas.pitre@linaro.org>
X-Mailer: git-send-email 1.8.4.108.g55ea5f6
In-reply-to: <1400101030-17717-1-git-send-email-nicolas.pitre@linaro.org>
References: <1400101030-17717-1-git-send-email-nicolas.pitre@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The capacity of a CPU/group should be some intrinsic value that doesn't
change with task placement.  It is like a container which capacity is
stable regardless of the amount of liquid in it... unless the container
itself is crushed that is, but that's another story.

Therefore let's rename "has_capacity" to "has_free_capacity" in order to
better convey the wanted meaning.

Signed-off-by: Nicolas Pitre <nico@linaro.org>
---
 kernel/sched/fair.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index e375dcc3f2..0eda4c527e 100644
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
@@ -1167,8 +1167,8 @@ static void task_numa_compare(struct task_numa_env *env,
 
 	if (!cur) {
 		/* Is there capacity at our destination? */
-		if (env->src_stats.has_capacity &&
-		    !env->dst_stats.has_capacity)
+		if (env->src_stats.has_free_capacity &&
+		    !env->dst_stats.has_free_capacity)
 			goto unlock;
 
 		goto balance;
@@ -1276,8 +1276,8 @@ static int task_numa_migrate(struct task_struct *p)
 	groupimp = group_weight(p, env.dst_nid) - groupweight;
 	update_numa_stats(&env.dst_stats, env.dst_nid);
 
-	/* If the preferred nid has capacity, try to use it. */
-	if (env.dst_stats.has_capacity)
+	/* If the preferred nid has free capacity, try to use it. */
+	if (env.dst_stats.has_free_capacity)
 		task_numa_find_cpu(&env, taskimp, groupimp);
 
 	/* No space available on the preferred nid. Look elsewhere. */
@@ -5491,7 +5491,7 @@ struct sg_lb_stats {
 	unsigned int idle_cpus;
 	unsigned int group_weight;
 	int group_imb; /* Is there an imbalance in the group ? */
-	int group_has_capacity; /* Is there extra capacity in the group? */
+	int group_has_free_capacity;
 #ifdef CONFIG_NUMA_BALANCING
 	unsigned int nr_numa_running;
 	unsigned int nr_preferred_running;
@@ -5858,7 +5858,7 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 	sgs->group_capacity = sg_capacity(env, group);
 
 	if (sgs->group_capacity > sgs->sum_nr_running)
-		sgs->group_has_capacity = 1;
+		sgs->group_has_free_capacity = 1;
 }
 
 /**
@@ -5982,7 +5982,7 @@ static inline void update_sd_lb_stats(struct lb_env *env, struct sd_lb_stats *sd
 		 * with a large weight task outweighs the tasks on the system).
 		 */
 		if (prefer_sibling && sds->local &&
-		    sds->local_stat.group_has_capacity)
+		    sds->local_stat.group_has_free_capacity)
 			sgs->group_capacity = min(sgs->group_capacity, 1U);
 
 		if (update_sd_pick_busiest(env, sds, sg, sgs)) {
@@ -6242,8 +6242,8 @@ static struct sched_group *find_busiest_group(struct lb_env *env)
 		goto force_balance;
 
 	/* SD_BALANCE_NEWIDLE trumps SMP nice when underutilized */
-	if (env->idle == CPU_NEWLY_IDLE && local->group_has_capacity &&
-	    !busiest->group_has_capacity)
+	if (env->idle == CPU_NEWLY_IDLE && local->group_has_free_capacity &&
+	    !busiest->group_has_free_capacity)
 		goto force_balance;
 
 	/*
-- 
1.8.4.108.g55ea5f6

