Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440Ab3ATEKM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 23:10:12 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:54649 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184Ab3ATEKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 23:10:11 -0500
Message-ID: <1358654997.5743.17.camel@marge.simpson.net>
Subject: Re: [RFC PATCH 0/2] sched: simplify the select_task_rq_fair()
From: Mike Galbraith <bitbucket@online.de>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, peterz@infradead.org,
        mingo@kernel.org, a.p.zijlstra@chello.nl
Date: Sun, 20 Jan 2013 05:09:57 +0100
In-Reply-To: <50F79256.1010900@linux.vnet.ibm.com>
References: <1356588535-23251-1-git-send-email-wangyun@linux.vnet.ibm.com>
	 <50ED384C.1030301@linux.vnet.ibm.com>
	 <1357977704.6796.47.camel@marge.simpson.net>
	 <1357985943.6796.55.camel@marge.simpson.net>
	 <1358155290.5631.19.camel@marge.simpson.net>
	 <50F79256.1010900@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:QsB6XNL4TyIzJzm9G6hu4qq46el4uWdtj6RO3Pf46bV
 F87IQJtZp45ccdZysghO2tbmDkJmQtkrM7PgqfHd8ZrKMsohPl
 bb0Pm4gcxO4JqtqhTAKe+FqoDqbgYmC+CLEKvlKbMqQfDjXYZr
 DdGMtsrZzzErILLrmG+spu3ILSUm9P5gnP++DkgH6ZR85UAvzB
 I+JpKX4p34TZRX4gL5wcwt5x8QeIskcXbAoTztaN5v0oQ19l8K
 6AHbEb7e/1Kp58PX+2EALbYHfoSnSAWfjY1N7s6/ziRBe8PuKw
 MzVJStyUd31Poo0y/d0s5Qd/kZxjpAX/h7Vw4zlN/4GgT1IGjp
 K6rXixI3M4utsdO1efrq4pNFXQAkLUg5GBXX4BVgAR1Dtu/n5o
 +eaGb+DW5R3Sg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-17 at 13:55 +0800, Michael Wang wrote: 
> Hi, Mike
> 
> I've send out the v2, which I suppose it will fix the below BUG and
> perform better, please do let me know if it still cause issues on your
> arm7 machine.

s/arm7/aim7

Someone swiped half of CPUs/ram, so the box is now 2 10 core nodes vs 4.

stock scheduler knobs

3.8-wang-v2                                 avg     3.8-virgin                          avg    vs wang
Tasks    jobs/min
    1      436.29    435.66    435.97    435.97        437.86    441.69    440.09    439.88      1.008
    5     2361.65   2356.14   2350.66   2356.15       2416.27   2563.45   2374.61   2451.44      1.040
   10     4767.90   4764.15   4779.18   4770.41       4946.94   4832.54   4828.69   4869.39      1.020
   20     9672.79   9703.76   9380.80   9585.78       9634.34   9672.79   9727.13   9678.08      1.009
   40    19162.06  19207.61  19299.36  19223.01      19268.68  19192.40  19056.60  19172.56       .997
   80    37610.55  37465.22  37465.22  37513.66      37263.64  37120.98  37465.22  37283.28       .993
  160    69306.65  69655.17  69257.14  69406.32      69257.14  69306.65  69257.14  69273.64       .998
  320   111512.36 109066.37 111256.45 110611.72     108395.75 107913.19 108335.20 108214.71       .978
  640   142850.83 148483.92 150851.81 147395.52     151974.92 151263.65 151322.67 151520.41      1.027
 1280    52788.89  52706.39  67280.77  57592.01     189931.44 189745.60 189792.02 189823.02      3.295
 2560    75403.91  52905.91  45196.21  57835.34     217368.64 217582.05 217551.54 217500.74      3.760

sched_latency_ns = 24ms
sched_min_granularity_ns = 8ms
sched_wakeup_granularity_ns = 10ms

3.8-wang-v2                                 avg     3.8-virgin                          avg    vs wang
Tasks    jobs/min
    1      436.29    436.60    434.72    435.87        434.41    439.77    438.81    437.66      1.004
    5     2382.08   2393.36   2451.46   2408.96       2451.46   2453.44   2425.94   2443.61      1.014
   10     5029.05   4887.10   5045.80   4987.31       4844.12   4828.69   4844.12   4838.97       .970
   20     9869.71   9734.94   9758.45   9787.70       9513.34   9611.42   9565.90   9563.55       .977
   40    19146.92  19146.92  19192.40  19162.08      18617.51  18603.22  18517.95  18579.56       .969
   80    37177.91  37378.57  37292.31  37282.93      36451.13  36179.10  36233.18  36287.80       .973
  160    70260.87  69109.05  69207.71  69525.87      68281.69  68522.97  68912.58  68572.41       .986
  320   114745.56 113869.64 114474.62 114363.27     114137.73 114137.73 114137.73 114137.73       .998
  640   164338.98 164338.98 164618.00 164431.98     164130.34 164130.34 164130.34 164130.34       .998
 1280   209473.40 209134.54 209473.40 209360.44     210040.62 210040.62 210097.51 210059.58      1.003
 2560   242703.38 242627.46 242779.34 242703.39     244001.26 243847.85 243732.91 243860.67      1.004

As you can see, the load collapsed at the high load end with stock
scheduler knobs (desktop latency).  With knobs set to scale, the delta
disappeared.

I thought perhaps the bogus (shouldn't exist) CPU domain in mainline
somehow contributes to the strange behavioral delta, but killing it made
zero difference.  All of these numbers for both trees were logged with
the below applies, but as noted, it changed nothing. 

From: Alex Shi <alex.shi@intel.com>
Date: Mon, 17 Dec 2012 09:42:57 +0800
Subject: [PATCH 01/18] sched: remove SD_PERFER_SIBLING flag

The flag was introduced in commit b5d978e0c7e79a. Its purpose seems
trying to fullfill one node first in NUMA machine via pulling tasks
from other nodes when the node has capacity.

Its advantage is when few tasks share memories among them, pulling
together is helpful on locality, so has performance gain. The shortage
is it will keep unnecessary task migrations thrashing among different
nodes, that reduces the performance gain, and just hurt performance if
tasks has no memory cross.

Thinking about the sched numa balancing patch is coming. The small
advantage are meaningless to us, So better to remove this flag.

Reported-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 include/linux/sched.h    |  1 -
 include/linux/topology.h |  2 --
 kernel/sched/core.c      |  1 -
 kernel/sched/fair.c      | 19 +------------------
 4 files changed, 1 insertion(+), 22 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5dafac3..6dca96c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -836,7 +836,6 @@ enum cpu_idle_type {
 #define SD_SHARE_PKG_RESOURCES	0x0200	/* Domain members share cpu pkg resources */
 #define SD_SERIALIZE		0x0400	/* Only a single load balancing instance */
 #define SD_ASYM_PACKING		0x0800  /* Place busy groups earlier in the domain */
-#define SD_PREFER_SIBLING	0x1000	/* Prefer to place tasks in a sibling domain */
 #define SD_OVERLAP		0x2000	/* sched_domains of this level overlap */
 
 extern int __weak arch_sd_sibiling_asym_packing(void);
diff --git a/include/linux/topology.h b/include/linux/topology.h
index d3cf0d6..15864d1 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -100,7 +100,6 @@ int arch_update_cpu_topology(void);
 				| 1*SD_SHARE_CPUPOWER			\
 				| 1*SD_SHARE_PKG_RESOURCES		\
 				| 0*SD_SERIALIZE			\
-				| 0*SD_PREFER_SIBLING			\
 				| arch_sd_sibling_asym_packing()	\
 				,					\
 	.last_balance		= jiffies,				\
@@ -162,7 +161,6 @@ int arch_update_cpu_topology(void);
 				| 0*SD_SHARE_CPUPOWER			\
 				| 0*SD_SHARE_PKG_RESOURCES		\
 				| 0*SD_SERIALIZE			\
-				| 1*SD_PREFER_SIBLING			\
 				,					\
 	.last_balance		= jiffies,				\
 	.balance_interval	= 1,					\
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5dae0d2..8ed2784 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6014,7 +6014,6 @@ sd_numa_init(struct sched_domain_topology_level *tl, int cpu)
 					| 0*SD_SHARE_CPUPOWER
 					| 0*SD_SHARE_PKG_RESOURCES
 					| 1*SD_SERIALIZE
-					| 0*SD_PREFER_SIBLING
 					| sd_local_flags(level)
 					,
 		.last_balance		= jiffies,
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 59e072b..5d175f2 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4339,13 +4339,9 @@ static bool update_sd_pick_busiest(struct lb_env *env,
 static inline void update_sd_lb_stats(struct lb_env *env,
 					int *balance, struct sd_lb_stats *sds)
 {
-	struct sched_domain *child = env->sd->child;
 	struct sched_group *sg = env->sd->groups;
 	struct sg_lb_stats sgs;
-	int load_idx, prefer_sibling = 0;
-
-	if (child && child->flags & SD_PREFER_SIBLING)
-		prefer_sibling = 1;
+	int load_idx;
 
 	load_idx = get_sd_load_idx(env->sd, env->idle);
 
@@ -4362,19 +4358,6 @@ static inline void update_sd_lb_stats(struct lb_env *env,
 		sds->total_load += sgs.group_load;
 		sds->total_pwr += sg->sgp->power;
 
-		/*
-		 * In case the child domain prefers tasks go to siblings
-		 * first, lower the sg capacity to one so that we'll try
-		 * and move all the excess tasks away. We lower the capacity
-		 * of a group only if the local group has the capacity to fit
-		 * these excess tasks, i.e. nr_running < group_capacity. The
-		 * extra check prevents the case where you always pull from the
-		 * heaviest group when it is already under-utilized (possible
-		 * with a large weight task outweighs the tasks on the system).
-		 */
-		if (prefer_sibling && !local_group && sds->this_has_capacity)
-			sgs.group_capacity = min(sgs.group_capacity, 1UL);
-
 		if (local_group) {
 			sds->this_load = sgs.avg_load;
 			sds->this = sg;


