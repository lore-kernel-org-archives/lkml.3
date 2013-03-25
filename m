Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758512Ab3CYPj0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 11:39:26 -0400
Received: from service87.mimecast.com ([91.220.42.44]:49415 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758275Ab3CYPjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 11:39:24 -0400
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        peterz@infradead.org, mingo@kernel.org, pjt@google.com,
        vincent.guittot@linaro.org
Cc: alex.shi@intel.com, preeti@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, corbet@lwn.net, amit.kucheria@linaro.org,
        robin.randhawa@arm.com, morten.rasmussen@arm.com
Subject: [RFC PATCH 2/2] sched: Pull tasks from cpus with multiple tasks when idle
Date: Mon, 25 Mar 2013 15:40:06 +0000
Message-Id: <1364226006-21419-3-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364226006-21419-1-git-send-email-morten.rasmussen@arm.com>
References: <1364226006-21419-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 25 Mar 2013 15:39:21.0416 (UTC) FILETIME=[EB7AD480:01CE296E]
X-MC-Unique: 113032515392204301
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r2PFdTCP028446

If a cpu is idle and another cpu has more than one runnable task,
pull one of them without considering cpu_power source or target.
This allows low cpu_power cpus to offload potentially oversubscribed
high cpu_power cpus.

In heterogeneous systems containing cpus with different cpu_power,
the load-balancer will put more tasks on sched_domains with high
(above default) cpu_power cpus and fewer on sched_domains with low
cpu_power cpus. Hence, if the number of running tasks is equal to
the number of cpus, the load-balancer may decide to leave low
cpu_power idle and placing more than one task on each high cpu_power
cpu. This is not optimal use of the available compute resources.

Placing one task on each cpu before adding more to any of the high
cpu_power cpus should generally give a better overall throughput
regardless of the cpu_power of the cpus.

Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/sched/fair.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 4781cdd..095885c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4039,7 +4039,8 @@ static int move_tasks(struct lb_env *env)
 		if (sched_feat(LB_MIN) && load < 16 && !env->sd->nr_balance_failed)
 			goto next;
 
-		if ((load / 2) > env->imbalance)
+		if ((load / 2) > env->imbalance &&
+			(env->idle != CPU_IDLE && env->idle != CPU_NEWLY_IDLE))
 			goto next;
 
 		if (!can_migrate_task(p, env))
@@ -4539,6 +4540,15 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 	if (overloaded_cpu)
 		sgs->group_imb = 1;
 
+	/*
+	 * When idle balancing pull tasks if more than one task per cpu
+	 * in group
+	 */
+	if (env->idle == CPU_IDLE || env->idle == CPU_NEWLY_IDLE) {
+		if (group->group_weight < sgs->sum_nr_running)
+			sgs->group_imb = 1;
+	}
+
 	sgs->group_capacity = DIV_ROUND_CLOSEST(group->sgp->power,
 						SCHED_POWER_SCALE);
 	if (!sgs->group_capacity)
@@ -4766,8 +4776,13 @@ void fix_small_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
 			min(sds->this_load_per_task, sds->this_load + tmp);
 	pwr_move /= SCHED_POWER_SCALE;
 
-	/* Move if we gain throughput */
-	if (pwr_move > pwr_now)
+	/*
+	 * Move if we gain throughput, or if we have cpus idling while others
+	 * are running more than one task.
+	 */
+	if ((pwr_move > pwr_now) ||
+		(sds->busiest_group_weight < sds->busiest_nr_running &&
+		(env->idle == CPU_IDLE || env->idle == CPU_NEWLY_IDLE)))
 		env->imbalance = sds->busiest_load_per_task;
 }
 
-- 
1.7.9.5


