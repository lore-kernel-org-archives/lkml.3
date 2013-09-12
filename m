Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912Ab3ILSGU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:06:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37934 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756895Ab3ILSGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 14:06:07 -0400
Date: Thu, 12 Sep 2013 11:05:35 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-mgezl354xgyhiyrte78fdkpd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/fair: Reduce local_group logic
Git-Commit-ID: b72ff13ce6021b37459afacbccc0bc9b16989013
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 12 Sep 2013 11:05:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b72ff13ce6021b37459afacbccc0bc9b16989013
Gitweb:     http://git.kernel.org/tip/b72ff13ce6021b37459afacbccc0bc9b16989013
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 28 Aug 2013 10:32:32 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 12 Sep 2013 19:14:43 +0200

sched/fair: Reduce local_group logic

Try and reduce the local_group logic by pulling most of it into
update_sd_lb_stats.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-mgezl354xgyhiyrte78fdkpd@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7325ca7..f9f4385 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4563,6 +4563,8 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 	unsigned long load;
 	int i;
 
+	memset(sgs, 0, sizeof(*sgs));
+
 	for_each_cpu_and(i, sched_group_cpus(group), env->cpus) {
 		struct rq *rq = cpu_rq(i);
 
@@ -4581,10 +4583,6 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 			sgs->idle_cpus++;
 	}
 
-	if (local_group && (env->idle != CPU_NEWLY_IDLE ||
-			time_after_eq(jiffies, group->sgp->next_update)))
-		update_group_power(env->sd, env->dst_cpu);
-
 	/* Adjust by relative CPU power of the group */
 	sgs->group_power = group->sgp->power;
 	sgs->avg_load = (sgs->group_load*SCHED_POWER_SCALE) / sgs->group_power;
@@ -4677,11 +4675,17 @@ static inline void update_sd_lb_stats(struct lb_env *env,
 		if (local_group) {
 			sds->local = sg;
 			sgs = &sds->local_stat;
+
+			if (env->idle != CPU_NEWLY_IDLE ||
+			    time_after_eq(jiffies, sg->sgp->next_update))
+				update_group_power(env->sd, env->dst_cpu);
 		}
 
-		memset(sgs, 0, sizeof(*sgs));
 		update_sg_lb_stats(env, sg, load_idx, local_group, sgs);
 
+		if (local_group)
+			goto next_group;
+
 		/*
 		 * In case the child domain prefers tasks go to siblings
 		 * first, lower the sg capacity to one so that we'll try
@@ -4692,19 +4696,20 @@ static inline void update_sd_lb_stats(struct lb_env *env,
 		 * heaviest group when it is already under-utilized (possible
 		 * with a large weight task outweighs the tasks on the system).
 		 */
-		if (prefer_sibling && !local_group &&
-				sds->local && sds->local_stat.group_has_capacity)
+		if (prefer_sibling && sds->local &&
+		    sds->local_stat.group_has_capacity)
 			sgs->group_capacity = min(sgs->group_capacity, 1U);
 
-		/* Now, start updating sd_lb_stats */
-		sds->total_load += sgs->group_load;
-		sds->total_pwr += sgs->group_power;
-
-		if (!local_group && update_sd_pick_busiest(env, sds, sg, sgs)) {
+		if (update_sd_pick_busiest(env, sds, sg, sgs)) {
 			sds->busiest = sg;
 			sds->busiest_stat = *sgs;
 		}
 
+next_group:
+		/* Now, start updating sd_lb_stats */
+		sds->total_load += sgs->group_load;
+		sds->total_pwr += sgs->group_power;
+
 		sg = sg->next;
 	} while (sg != env->sd->groups);
 }
