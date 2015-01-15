Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbbAOKM0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 05:12:26 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:35585 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766AbbAOKMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 05:12:20 -0500
From: Vincent Guittot <vincent.guittot@linaro.org>
To: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        preeti@linux.vnet.ibm.com, Morten.Rasmussen@arm.com,
        kamalesh@linux.vnet.ibm.com
Cc: riel@redhat.com, efault@gmx.de, nicolas.pitre@linaro.org,
        dietmar.eggemann@arm.com, linaro-kernel@lists.linaro.org,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH RESEND v9 00/10] sched: consolidation of CPU capacity and usage
Date: Thu, 15 Jan 2015 11:09:20 +0100
Message-Id: <1421316570-23097-1-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset consolidates several changes in the capacity and the usage
tracking of the CPU. It provides a frequency invariant metric of the usage of
CPUs and generally improves the accuracy of load/usage tracking in the
scheduler. The frequency invariant metric is the foundation required for the
consolidation of cpufreq and implementation of a fully invariant load tracking.
These are currently WIP and require several changes to the load balancer
(including how it will use and interprets load and capacity metrics) and
extensive validation. The frequency invariance is done with
arch_scale_freq_capacity and this patchset doesn't provide the backends of
the function which are architecture dependent.

As discussed at LPC14, Morten and I have consolidated our changes into a single
patchset to make it easier to review and merge.

During load balance, the scheduler evaluates the number of tasks that a group
of CPUs can handle. The current method assumes that tasks have a fix load of
SCHED_LOAD_SCALE and CPUs have a default capacity of SCHED_CAPACITY_SCALE.
This assumption generates wrong decision by creating ghost cores or by
removing real ones when the original capacity of CPUs is different from the
default SCHED_CAPACITY_SCALE. With this patch set, we don't try anymore to
evaluate the number of available cores based on the group_capacity but instead
we evaluate the usage of a group and compare it with its capacity.

This patchset mainly replaces the old capacity_factor method by a new one and
keeps the general policy almost unchanged. These new metrics will be also used
in later patches.

The CPU usage is based on a running time tracking version of the current
implementation of the load average tracking. I also have a version that is
based on the new implementation proposal [1] but I haven't provide the patches
and results as [1] is still under review. I can provide change above [1] to
change how CPU usage is computed and to adapt to new mecanism.

Change since V8
 - reorder patches

Change since V7
 - add freq invariance for usage tracking
 - add freq invariance for scale_rt
 - update comments and commits' message
 - fix init of utilization_avg_contrib
 - fix prefer_sibling

Change since V6
 - add group usage tracking
 - fix some commits' messages
 - minor fix like comments and argument order

Change since V5
 - remove patches that have been merged since v5 : patches 01, 02, 03, 04, 05, 07
 - update commit log and add more details on the purpose of the patches
 - fix/remove useless code with the rebase on patchset [2]
 - remove capacity_orig in sched_group_capacity as it is not used
 - move code in the right patch
 - add some helper function to factorize code

Change since V4
 - rebase to manage conflicts with changes in selection of busiest group

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

[1] https://lkml.org/lkml/2014/10/10/131
[2] https://lkml.org/lkml/2014/7/25/589

Morten Rasmussen (2):
  sched: Track group sched_entity usage contributions
  sched: Make sched entity usage tracking scale-invariant

Vincent Guittot (8):
  sched: add utilization_avg_contrib
  sched: remove frequency scaling from cpu_capacity
  sched: make scale_rt invariant with frequency
  sched: add per rq cpu_capacity_orig
  sched: get CPU's usage statistic
  sched: replace capacity_factor by usage
  sched: add SD_PREFER_SIBLING for SMT level
  sched: move cfs task on a CPU with higher capacity

 include/linux/sched.h |  21 ++-
 kernel/sched/core.c   |  15 +-
 kernel/sched/debug.c  |  12 +-
 kernel/sched/fair.c   | 369 ++++++++++++++++++++++++++++++++------------------
 kernel/sched/sched.h  |  15 +-
 5 files changed, 276 insertions(+), 156 deletions(-)

-- 
1.9.1

