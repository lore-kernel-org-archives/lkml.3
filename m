Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751383AbaG1Rwj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 13:52:39 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:59307 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbaG1Rwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 13:52:36 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        preeti@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org
Cc: riel@redhat.com, Morten.Rasmussen@arm.com, efault@gmx.de,
        nicolas.pitre@linaro.org, linaro-kernel@lists.linaro.org,
        daniel.lezcano@linaro.org, dietmar.eggemann@arm.com,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH v4 00/12] sched: consolidation of cpu_capacity
Date: Mon, 28 Jul 2014 19:51:34 +0200
Message-Id: <1406569906-9763-1-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Part of this patchset was previously part of the larger tasks packing patchset
[1]. I have splitted the latter in 3 different patchsets (at least) to make the
thing easier.
-configuration of sched_domain topology [2]
-update and consolidation of cpu_capacity (this patchset)
-tasks packing algorithm

SMT system is no more the only system that can have a CPUs with an original
capacity that is different from the default value. We need to extend the use of
cpu_capacity_orig to all kind of platform so the scheduler will have both the
maximum capacity (cpu_capacity_orig/capacity_orig) and the current capacity
(cpu_capacity/capacity) of CPUs and sched_groups. A new function
arch_scale_cpu_capacity has been created and replace arch_scale_smt_capacity,
which is SMT specifc in the computation of the capapcity of a CPU.

During load balance, the scheduler evaluates the number of tasks that a group
of CPUs can handle. The current method assumes that tasks have a fix load of
SCHED_LOAD_SCALE and CPUs have a default capacity of SCHED_CAPACITY_SCALE.
This assumption generates wrong decision by creating ghost cores and by
removing real ones when the original capacity of CPUs is different from the
default SCHED_CAPACITY_SCALE. We don't try anymore to evaluate the number of
available cores based on the group_capacity but instead we detect when the
group is fully utilized

Now that we have the original capacity of CPUS and their activity/utilization,
we can evaluate more accuratly the capacity and the level of utilization of a
group of CPUs.

This patchset mainly replaces the old capacity method by a new one and has kept
the policy almost unchanged whereas we could certainly take advantage of this
new statistic in several other places of the load balance.

Tests results:
I have put below results of 4 kind of tests:
- hackbench -l 500 -s 4096
- perf bench sched pipe -l 400000
- scp of 100MB file on the platform
- ebizzy with various number of threads
on 4 kernels :
- tip = tip/sched/core
- step1 = tip + patches(1-8)
- patchset = tip + whole patchset
- patchset+irq = tip + this patchset + irq accounting

each test has been run 6 times and the figure below show the stdev and the
diff compared to the tip kernel

Dual A7				 tip   |  +step1           |  +patchset        |  patchset+irq	
			         stdev |  results    stdev |  results    stdev |  results    stdev
hackbench (lower is better) (+/-)0.64% | -0.19% (+/-)0.73% |  0.58% (+/-)1.29% |  0.20% (+/-)1.00%
perf	(lower is better)   (+/-)0.28% |  1.22% (+/-)0.17% |  1.29% (+/-)0.06% |  2.85% (+/-)0.33%
scp			    (+/-)4.81% |  2.61% (+/-)0.28% |  2.39% (+/-)0.22% | 82.18% (+/-)3.30%
ebizzy	-t 1		    (+/-)2.31% | -1.32% (+/-)1.90% | -0.79% (+/-)2.88% |  3.10% (+/-)2.32%
ebizzy	-t 2		    (+/-)0.70% |  8.29% (+/-)6.66% |  1.93% (+/-)5.47% |  2.72% (+/-)5.72%
ebizzy	-t 4		    (+/-)3.54% |  5.57% (+/-)8.00% |  0.36% (+/-)9.00% |  2.53% (+/-)3.17%
ebizzy	-t 6		    (+/-)2.36% | -0.43% (+/-)3.29% | -1.93% (+/-)3.47% |  0.57% (+/-)0.75%
ebizzy	-t 8		    (+/-)1.65% | -0.45% (+/-)0.93% | -1.95% (+/-)1.52% | -1.18% (+/-)1.61%
ebizzy	-t 10		    (+/-)2.55% | -0.98% (+/-)3.06% | -1.18% (+/-)6.17% | -2.33% (+/-)3.28%
ebizzy	-t 12		    (+/-)6.22% |  0.17% (+/-)5.63% |  2.98% (+/-)7.11% |  1.19% (+/-)4.68%
ebizzy	-t 14		    (+/-)5.38% | -0.14% (+/-)5.33% |  2.49% (+/-)4.93% |  1.43% (+/-)6.55%
															
Quad A15			 tip	| +patchset1	    | +patchset2        | patchset+irq		
			         stdev  | results     stdev | results    stdev  | results    stdev
hackbench (lower is better)  (+/-)0.78% |  0.87% (+/-)1.72% |  0.91% (+/-)2.02% |  3.30% (+/-)2.02%
perf	(lower is better)    (+/-)2.03% | -0.31% (+/-)0.76% | -2.38% (+/-)1.37% |  1.42% (+/-)3.14%
scp			     (+/-)0.04% |  0.51% (+/-)1.37% |  1.79% (+/-)0.84% |  1.77% (+/-)0.38%
ebizzy	-t 1		     (+/-)0.41% |  2.05% (+/-)0.38% |  2.08% (+/-)0.24% |  0.17% (+/-)0.62%
ebizzy	-t 2		     (+/-)0.78% |  0.60% (+/-)0.63% |  0.43% (+/-)0.48% |  1.61% (+/-)0.38%
ebizzy	-t 4		     (+/-)0.58% | -0.10% (+/-)0.97% | -0.65% (+/-)0.76% | -0.75% (+/-)0.86%
ebizzy	-t 6		     (+/-)0.31% |  1.07% (+/-)1.12% | -0.16% (+/-)0.87% | -0.76% (+/-)0.22%
ebizzy	-t 8		     (+/-)0.95% | -0.30% (+/-)0.85% | -0.79% (+/-)0.28% | -1.66% (+/-)0.21%
ebizzy	-t 10		     (+/-)0.31% |  0.04% (+/-)0.97% | -1.44% (+/-)1.54% | -0.55% (+/-)0.62%
ebizzy	-t 12		     (+/-)8.35% | -1.89% (+/-)7.64% |  0.75% (+/-)5.30% | -1.18% (+/-)8.16%
ebizzy	-t 14		    (+/-)13.17% |  6.22% (+/-)4.71% |  5.25% (+/-)9.14% |  5.87% (+/-)5.77%

I haven't been able to fully test the patchset for a SMT system to check that
the regression that has been reported by Preethi has been solved but the
various tests that i have done, don't show any regression so far.
The correction of SD_PREFER_SIBLING mode and the use of the latter at SMT level
should have fix the regression.

The usage_avg_contrib is based on the current implementation of the
load avg tracking. I also have a version of the usage_avg_contrib that is based
on the new implementation [3] but haven't provide the patches and results as
[3] is still under review. I can provide change above [3] to change how 
usage_avg_contrib is computed and adapt to new mecanism.

TODO: manage conflict with the next version of [4]

Change since V3:
 - add usage_avg_contrib statistic which sums the running time of tasks on a rq
 - use usage_avg_contrib instead of runnable_avg_sum for cpu_utilization
 - fix replacement power by capacity
 - update some comments

Change since V2:
 - rebase on top of capacity renaming
 - fix wake_affine statistic update
 - rework nohz_kick_needed
 - optimize the active migration of a task from CPU with reduced capacity
 - rename group_activity by group_utilization and remove unused total_utilization
 - repair SD_PREFER_SIBLING and use it for SMT level
 - reorder patchset to gather patches with same topics

Change since V1:
 - add 3 fixes
 - correct some commit messages
 - replace capacity computation by activity
 - take into account current cpu capacity

[1] https://lkml.org/lkml/2013/10/18/121
[2] https://lkml.org/lkml/2014/3/19/377
[3] https://lkml.org/lkml/2014/7/18/110
[4] https://lkml.org/lkml/2014/7/25/589

Vincent Guittot (12):
  sched: fix imbalance flag reset
  sched: remove a wake_affine condition
  sched: fix avg_load computation
  sched: Allow all archs to set the capacity_orig
  ARM: topology: use new cpu_capacity interface
  sched: add per rq cpu_capacity_orig
  sched: test the cpu's capacity in wake affine
  sched: move cfs task on a CPU with higher capacity
  sched: add usage_load_avg
  sched: get CPU's utilization statistic
  sched: replace capacity_factor by utilization
  sched: add SD_PREFER_SIBLING for SMT level

 arch/arm/kernel/topology.c |   4 +-
 include/linux/sched.h      |   4 +-
 kernel/sched/core.c        |   3 +-
 kernel/sched/fair.c        | 350 ++++++++++++++++++++++++++-------------------
 kernel/sched/sched.h       |   3 +-
 5 files changed, 207 insertions(+), 157 deletions(-)

-- 
1.9.1

