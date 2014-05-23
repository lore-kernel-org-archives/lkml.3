Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596AbaEWPyI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 11:54:08 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:55813 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283AbaEWPyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 11:54:06 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org
Cc: preeti@linux.vnet.ibm.com, Morten.Rasmussen@arm.com, efault@gmx.de,
        nicolas.pitre@linaro.org, linaro-kernel@lists.linaro.org,
        daniel.lezcano@linaro.org,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH v2 00/11]  sched: consolidation of cpu_power
Date: Fri, 23 May 2014 17:52:54 +0200
Message-Id: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
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
default SCHED_POWER_SCALE.

Now that we have the original capacity of a CPUS and its activity/utilization,
we can evaluate more accuratly the capacity of a group of CPUs.

This patchset mainly replaces the old capacity method by a new one and has kept
the policy almost unchanged whereas we can certainly take advantage of this new
statistic in several other places of the load balance.

TODO:
 - align variable's and field's name with the renaming [3]

Tests results:
I have put below results of 2 tests:
- hackbench -l 500 -s 4096
- scp of 100MB file on the platform

on a dual cortex-A7 
                  hackbench        scp    
tip/master        25.75s(+/-0.25)  5.16MB/s(+/-1.49)
+ patches 1,2     25.89s(+/-0.31)  5.18MB/s(+/-1.45)
+ patches 3-10    25.68s(+/-0.22)  7.00MB/s(+/-1.88)
+ irq accounting  25.80s(+/-0.25)  8.06MB/s(+/-0.05)

on a quad cortex-A15 
                  hackbench        scp    
tip/master        15.69s(+/-0.16)  9.70MB/s(+/-0.04)
+ patches 1,2     15.53s(+/-0.13)  9.72MB/s(+/-0.05)
+ patches 3-10    15.56s(+/-0.22)  9.88MB/s(+/-0.05)
+ irq accounting  15.99s(+/-0.08) 10.37MB/s(+/-0.03)

The improvement of scp bandwidth happens when tasks and irq are using
different CPU which is a bit random without irq accounting config

Change since V1:
 - add 3 fixes
 - correct some commit messages
 - replace capacity computation by activity
 - take into account current cpu capacity

[1] https://lkml.org/lkml/2013/10/18/121
[2] https://lkml.org/lkml/2014/3/19/377
[3] https://lkml.org/lkml/2014/5/14/622

Vincent Guittot (11):
  sched: fix imbalance flag reset
  sched: remove a wake_affine condition
  sched: fix avg_load computation
  sched: Allow all archs to set the power_orig
  ARM: topology: use new cpu_power interface
  sched: add per rq cpu_power_orig
  Revert "sched: Put rq's sched_avg under CONFIG_FAIR_GROUP_SCHED"
  sched: get CPU's activity statistic
  sched: test the cpu's capacity in wake affine
  sched: move cfs task on a CPU with higher capacity
  sched: replace capacity by activity

 arch/arm/kernel/topology.c |   4 +-
 kernel/sched/core.c        |   2 +-
 kernel/sched/fair.c        | 229 ++++++++++++++++++++++-----------------------
 kernel/sched/sched.h       |   5 +-
 4 files changed, 118 insertions(+), 122 deletions(-)

-- 
1.9.1

