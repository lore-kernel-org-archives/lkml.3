Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149AbaC1NYa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 09:24:30 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:53340 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbaC1NY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 09:24:26 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org
Cc: preeti@linux.vnet.ibm.com, Morten.Rasmussen@arm.com, efault@gmx.de,
        linaro-kernel@lists.linaro.org,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [RFC 3/4] sched: fix computed capacity for HMP
Date: Fri, 28 Mar 2014 14:22:28 +0100
Message-Id: <1396012949-6227-4-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1396012949-6227-1-git-send-email-vincent.guittot@linaro.org>
References: <1396012949-6227-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current sg_capacity solves the ghost cores issue for SMT system and
cluster made of big cores which have a cpu_power above SCHED_POWER_SCALE at
core level. But it still removes some real cores of a cluster made of LITTLE
cores which have a cpu_power below SCHED_POWER_SCALE.

Instead of using the power_orig to detect SMT system and compute a smt factor
that will be used to calculate the real number of cores, we set a core_fct
field when building the sched_domain topology. We can detect SMT system thanks
to SD_SHARE_CPUPOWER flag and set core_fct to know how many CPUs per core we
have. The core_fct will ensure that sg_capacity will return cores capacity of
a SMT system and will not remove any real core of LITTLE cluster.

This method also fixes a use case where the capacity of a SMT system was
overrated.
Let take the example of a system made of 8 cores HT system:
At CPU level, sg_capacity is cap to a maximum capacity of 8 whereas
DIV_ROUND_CLOSEST(power, SCHED_POWER_SCALE) returns 9.
((589*16) / 1024) = 9.3
Now if 2 CPUs (1 core) are fully loaded by rt tasks, sg_capacity still returns
a capacity of 8 whereas it should return a capacity of 7. This happen because
DIV_ROUND_CLOSEST(power, SCHED_POWER_SCALE) is still above 7.5:
((589*14) / 1024) = 8.05

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/sched/core.c  | 7 +++++++
 kernel/sched/fair.c  | 6 ++----
 kernel/sched/sched.h | 2 +-
 3 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index f9d9776..5b20b27 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5844,6 +5844,13 @@ static void init_sched_groups_power(int cpu, struct sched_domain *sd)
 
 	WARN_ON(!sg);
 
+	if (!sd->child)
+		sg->core_fct = 1;
+	else if (sd->child->flags & SD_SHARE_CPUPOWER)
+		sg->core_fct = cpumask_weight(sched_group_cpus(sg));
+	else
+		sg->core_fct = sd->child->groups->core_fct;
+
 	do {
 		sg->group_weight = cpumask_weight(sched_group_cpus(sg));
 		sg = sg->next;
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index ed42061..7387c05 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5773,12 +5773,10 @@ static inline int sg_capacity(struct lb_env *env, struct sched_group *group)
 	power = group->sgp->power;
 	power_orig = group->sgp->power_orig;
 	cpus = group->group_weight;
+	smt = group->core_fct;
 
-	/* smt := ceil(cpus / power), assumes: 1 < smt_power < 2 */
-	smt = DIV_ROUND_UP(SCHED_POWER_SCALE * cpus, power_orig);
-	capacity = cpus / smt; /* cores */
+	capacity = DIV_ROUND_CLOSEST(power * cpus, power_orig * smt);
 
-	capacity = min_t(unsigned, capacity, DIV_ROUND_CLOSEST(power, SCHED_POWER_SCALE));
 	if (!capacity)
 		capacity = fix_small_capacity(env->sd, group);
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index c9007f2..46c3784 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -759,7 +759,7 @@ struct sched_group {
 	struct sched_group *next;	/* Must be a circular list */
 	atomic_t ref;
 
-	unsigned int group_weight;
+	unsigned int group_weight, core_fct;
 	struct sched_group_power *sgp;
 
 	/*
-- 
1.9.0

