Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803Ab3H1I5W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 04:57:22 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57512 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441Ab3H1I5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 04:57:21 -0400
Date: Wed, 28 Aug 2013 10:57:07 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>, Lei Wen <leiwen@marvell.com>,
        Joonsoo Kim <js1304@gmail.com>, Rik van Riel <riel@surriel.com>
Subject: Re: [RFC][PATCH 11/10] sched, fair: Reduce local_group logic
Message-ID: <20130828085707.GJ10002@twins.programming.kicks-ass.net>
References: <20130819160058.539049611@infradead.org>
 <20130828085542.GI10002@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130828085542.GI10002@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


# ls -la defconfig-build/kernel/sched/fair.o*
-rw-r--r-- 1 root root 760688 Aug 28 10:53 defconfig-build/kernel/sched/fair.o
-rw-r--r-- 1 root root 758160 Aug 28 10:36 defconfig-build/kernel/sched/fair.o.orig

---
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4553,9 +4553,9 @@ static inline int sg_imbalanced(struct s
  * @local_group: Does group contain this_cpu.
  * @sgs: variable to hold the statistics for this group.
  */
-static inline void update_sg_lb_stats(struct lb_env *env,
+static void update_sg_lb_stats(struct lb_env *env,
 			struct sched_group *group, int load_idx,
-			int local_group, struct sg_lb_stats *sgs)
+			int group_bias, struct sg_lb_stats *sgs)
 {
 	unsigned long nr_running;
 	unsigned long load;
@@ -4568,8 +4568,7 @@ static inline void update_sg_lb_stats(st
 
 		nr_running = rq->nr_running;
 
-		/* Bias balancing toward cpus of our domain */
-		if (local_group)
+		if (group_bias)
 			load = target_load(i, load_idx);
 		else
 			load = source_load(i, load_idx);
@@ -4667,22 +4666,21 @@ static inline void update_sd_lb_stats(st
 
 	do {
 		struct sg_lb_stats *sgs = &tmp_sgs;
-		int local_group;
 
-		local_group = cpumask_test_cpu(env->dst_cpu, sched_group_cpus(sg));
-		if (local_group) {
+		if (cpumask_test_cpu(env->dst_cpu, sched_group_cpus(sg))) {
 			sds->local = sg;
 			sgs = &sds->local_stat;
 
 			if (env->idle != CPU_NEWLY_IDLE ||
 			    time_after_eq(jiffies, sg->sgp->next_update))
 				update_group_power(env->sd, env->dst_cpu);
-		}
-
-		update_sg_lb_stats(env, sg, load_idx, local_group, sgs);
 
-		if (local_group)
+			/* Bias balancing toward cpus of our domain */
+			update_sg_lb_stats(env, sg, load_idx, 1, sgs);
 			goto next_group;
+		}
+
+		update_sg_lb_stats(env, sg, load_idx, 0, sgs);
 
 		/*
 		 * In case the child domain prefers tasks go to siblings
