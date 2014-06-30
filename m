Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897AbaF3QGq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 12:06:46 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:51064 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbaF3QGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 12:06:45 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org
Cc: preeti@linux.vnet.ibm.com, Morten.Rasmussen@arm.com, efault@gmx.de,
        nicolas.pitre@linaro.org, linaro-kernel@lists.linaro.org,
        daniel.lezcano@linaro.org, dietmar.eggemann@arm.com,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH v3 00/12] sched: consolidation of cpu_power
Date: Mon, 30 Jun 2014 18:05:31 +0200
Message-Id: <1404144343-18720-1-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Part of this patchset was previously part of the larger tasks packing patchset
[1]. I have splitted the latter in 3 different patchsets (at least) to make the
thing easier.
-configuration of sched_domain topology [2]
-update and consolidation of cpu_power (this patchset)
-tasks packing algorithm

SMT system is no more the only system that can have a CPUs with an original
capacity that is different from the default value. We need to extend the use of
cpu_power_orig to all kind of platform so the scheduler will have both the
maximum capacity (cpu_power_orig/power_orig) and the current capacity
(cpu_power/power) of CPUs and sched_groups. A new function arch_scale_cpu_power
has been created and replace arch_scale_smt_power, which is SMT specifc in the
computation of the capapcity of a CPU.

During load balance, the scheduler evaluates the number of tasks that a group
of CPUs can handle. The current method assumes that tasks have a fix load of
SCHED_LOAD_SCALE and CPUs have a default capacity of SCHED_POWER_SCALE.
This assumption generates wrong decision by creating ghost cores and by
removing real ones when the original capacity of CPUs is different from the
default SCHED_POWER_SCALE. We don't try anymore to evaluate the number of
available cores based on the group_capacity but instead we detect when the group
is fully utilized

Now that we have the original capacity of CPUS and their activity/utilization,
we can evaluate more accuratly the capacity and the level of utilization of a
group of CPUs.

This patchset mainly replaces the old capacity method by a new one and has kept
the policy almost unchanged whereas we could certainly take advantage of this
new statistic in several other places of the load balance.

Tests results:
I have put below results of 3 kind of tests:
- hackbench -l 500 -s 4096
- scp of 100MB file on the platform
- ebizzy with various number of threads
on 3 kernel

tip = tip/sched/core
patch = tip + this patchset
patch+irq = tip + this patchset + irq accounting

each test has been run 6 times and the figure below show the stdev and the
diff compared to the tip kernel

Dual cortex A7     tip   | patch             |  patch+irq
                   stdev | diff       stdev  |  diff       stdev
hackbench     (+/-)1.02% | +0.42%(+/-)1.29%  |  -0.65%(+/-)0.44%
scp           (+/-)0.41% | +0.18%(+/-)0.10%  | +78.05%(+/-)0.70%
ebizzy -t 1   (+/-)1.72% | +1.43%(+/-)1.62%  |  +2.58%(+/-)2.11%
ebizzy -t 2   (+/-)0.42% | +0.06%(+/-)0.45%  |  +1.45%(+/-)4.05%
ebizzy -t 4   (+/-)0.73% | +8.39%(+/-)13.25% |  +4.25%(+/-)10.08%
ebizzy -t 6  (+/-)10.30% | +2.19%(+/-)3.59%  |  +0.58%(+/-)1.80%
ebizzy -t 8   (+/-)1.45% | -0.05%(+/-)2.18%  |  +2.53%(+/-)3.40%
ebizzy -t 10  (+/-)3.78% | -2.71%(+/-)2.79%  |  -3.16%(+/-)3.06%
ebizzy -t 12  (+/-)3.21% | +1.13%(+/-)2.02%  |  -1.13%(+/-)4.43%
ebizzy -t 14  (+/-)2.05% | +0.15%(+/-)3.47%  |  -2.08%(+/-)1.40%
											
uad cortex A15     tip   | patch             |  patch+irq
                   stdev | diff       stdev  |  diff       stdev
hackbench     (+/-)0.55% | -0.58%(+/-)0.90%  |  +0.62%(+/-)0.43%
scp           (+/-)0.21% | -0.10%(+/-)0.10%  |  +5.70%(+/-)0.53%
ebizzy -t 1   (+/-)0.42% | -0.58%(+/-)0.48%  |  -0.29%(+/-)0.18%
ebizzy -t 2   (+/-)0.52% | -0.83%(+/-)0.20%  |  -2.07%(+/-)0.35%
ebizzy -t 4   (+/-)0.22% | -1.39%(+/-)0.49%  |  -1.78%(+/-)0.67%
ebizzy -t 6   (+/-)0.44% | -0.78%(+/-)0.15%  |  -1.79%(+/-)1.10%
ebizzy -t 8   (+/-)0.43% | +0.13%(+/-)0.92%  |  -0.17%(+/-)0.67%
ebizzy -t 10  (+/-)0.71% | +0.10%(+/-)0.93%  |  -0.36%(+/-)0.77%
ebizzy -t 12  (+/-)0.65% | -1.07%(+/-)1.13%  |  -1.13%(+/-)0.70%
ebizzy -t 14  (+/-)0.92% | -0.28%(+/-)1.25%  |  +2.84%(+/-)9.33%

I haven't been able to fully test the patchset for a SMT system to check that
the regression that has been reported by Preethi has been solved but the
various tests that i have done, don't show any regression so far.
The correction of SD_PREFER_SIBLING mode and the use of the latter at SMT level
should have fix the regression.

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


Vincent Guittot (12):
  sched: fix imbalance flag reset
  sched: remove a wake_affine condition
  sched: fix avg_load computation
  sched: Allow all archs to set the power_orig
  ARM: topology: use new cpu_power interface
  sched: add per rq cpu_power_orig
  sched: test the cpu's capacity in wake affine
  sched: move cfs task on a CPU with higher capacity
  Revert "sched: Put rq's sched_avg under CONFIG_FAIR_GROUP_SCHED"
  sched: get CPU's utilization statistic
  sched: replace capacity_factor by utilization
  sched: add SD_PREFER_SIBLING for SMT level

 arch/arm/kernel/topology.c |   4 +-
 kernel/sched/core.c        |   3 +-
 kernel/sched/fair.c        | 290 +++++++++++++++++++++++----------------------
 kernel/sched/sched.h       |   5 +-
 4 files changed, 158 insertions(+), 144 deletions(-)

-- 
1.9.1

