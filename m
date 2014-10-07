Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605AbaJGMPL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 08:15:11 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:36500 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbaJGMPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 08:15:08 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        preeti@linux.vnet.ibm.com, Morten.Rasmussen@arm.com,
        kamalesh@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org
Cc: riel@redhat.com, efault@gmx.de, nicolas.pitre@linaro.org,
        linaro-kernel@lists.linaro.org, daniel.lezcano@linaro.org,
        dietmar.eggemann@arm.com, pjt@google.com, bsegall@google.com,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH v7 0/7] sched: consolidation of cpu_capacity
Date: Tue,  7 Oct 2014 14:13:30 +0200
Message-Id: <1412684017-16595-1-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During load balance, the scheduler evaluates the number of tasks that a group
of CPUs can handle. The current method assumes that tasks have a fix load of
SCHED_LOAD_SCALE and CPUs have a default capacity of SCHED_CAPACITY_SCALE.
This assumption generates wrong decision by creating ghost cores or by
removing real ones when the original capacity of CPUs is different from the
default SCHED_CAPACITY_SCALE. We don't try anymore to evaluate the number of
available cores based on the group_capacity but instead we evaluate the usage
of a group and compare it with its capacity.

This patchset mainly replaces the old capacity method by a new one and has kept
the policy almost unchanged whereas we could certainly take advantage of this
new statistic in several other places of the load balance.

The utilization_avg_contrib is based on the current implementation of the
load avg tracking. I also have a version of the utilization_avg_contrib that
is based on the new implementation proposal [1] but haven't provide the patches
and results as [1] is still under review. I can provide change above [1] to
change how utilization_avg_contrib is computed and adapt to new mecanism.

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
 - rebase to manage conflicts with changes in selection of busiest group [4]

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

[1] https://lkml.org/lkml/2014/7/18/110
[2] https://lkml.org/lkml/2014/7/25/589

Morten Rasmussen (1):
  sched: Track group sched_entity usage contributions

Vincent Guittot (6):
  sched: add per rq cpu_capacity_orig
  sched: move cfs task on a CPU with higher capacity
  sched: add utilization_avg_contrib
  sched: get CPU's usage statistic
  sched: replace capacity_factor by usage
  sched: add SD_PREFER_SIBLING for SMT level

 include/linux/sched.h |  21 +++-
 kernel/sched/core.c   |  15 +--
 kernel/sched/debug.c  |  12 ++-
 kernel/sched/fair.c   | 283 ++++++++++++++++++++++++++++++--------------------
 kernel/sched/sched.h  |  11 +-
 5 files changed, 209 insertions(+), 133 deletions(-)

-- 
1.9.1

