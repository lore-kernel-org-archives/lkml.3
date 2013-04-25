Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758890Ab3DYRYu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 13:24:50 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:44268 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755292Ab3DYRYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 13:24:49 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, peterz@infradead.org, mingo@kernel.org,
        linux@arm.linux.org.uk, pjt@google.com, santosh.shilimkar@ti.com,
        Morten.Rasmussen@arm.com, chander.kashyap@linaro.org,
        cmetcalf@tilera.com, tony.luck@intel.com, alex.shi@intel.com,
        preeti@linux.vnet.ibm.com
Cc: paulmck@linux.vnet.ibm.com, tglx@linutronix.de, len.brown@intel.com,
        arjan@linux.intel.com, amit.kucheria@linaro.org, corbet@lwn.net,
        l.majewski@samsung.com, Vincent Guittot <vincent.guittot@linaro.org>
Subject: [RFC PATCH v4 00/14] sched: packing small tasks
Date: Thu, 25 Apr 2013 19:23:16 +0200
Message-Id: <1366910611-20048-1-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset takes advantage of the new per-task load tracking that is
available in the kernel for packing the tasks in as few as possible
CPU/Cluster/Core. It has got 2 packing modes:
-The 1st mode packs the small tasks when the system is not too busy. The main
goal is to reduce the power consumption in the low system load use cases by
minimizing the number of power domain that are enabled but it also keeps the
default behavior which is performance oriented.
-The 2nd mode packs all tasks in as few as possible power domains in order to
improve the power consumption of the system but at the cost of possible
performance decrease because of the increase of the rate of ressources sharing
compared to the default mode.

The packing is done in 3 steps (the last step is only applicable for the
agressive packing mode):

The 1st step looks for the best place to pack tasks in a system according to
its topology and it defines a 1st pack buddy CPU for each CPU if there is one
available. The policy for defining a buddy CPU is that we want to pack at
levels where a group of CPU can be power gated independently from others. To
describe this capability, a new flag SD_SHARE_POWERDOMAIN has been introduced,
that is used to indicate whether the groups of CPUs of a scheduling domain
share their power state. By default, this flag is set in all sched_domain in
order to keep unchanged the current behavior of the scheduler and only ARM
platform clears the SD_SHARE_POWERDOMAIN flag for MC and CPU level.

In a 2nd step, the scheduler checks the load average of a task which wakes up
as well as the load average of the buddy CPU and it can decide to migrate the
light tasks on a not busy buddy. This check is done during the wake up because
small tasks tend to wake up between periodic load balance and asynchronously
to each other which prevents the default mechanism to catch and migrate them
efficiently. A light task is defined by a runnable_avg_sum that is less than
20% of the runnable_avg_period. In fact, the former condition encloses 2 ones:
The average CPU load of the task must be less than 20% and the task must have
been runnable less than 10ms when it woke up last time in order to be
electable for the packing migration. So, a task than runs 1 ms each 5ms will
be considered as a small task but a task that runs 50 ms with a period of
500ms, will not.
Then, the business of the buddy CPU depends of the load average for the rq and
the number of running tasks. A CPU with a load average greater than 50% will
be considered as busy CPU whatever the number of running tasks is and this
threshold will be reduced by the number of running tasks in order to not
increase too much the wake up latency of a task. When the buddy CPU is busy,
the scheduler falls back to default CFS policy.

The 3rd step is only used when the agressive packing mode is enable. In this
case, the CPUs pack their tasks in their buddy until they becomes full. Unlike
the previous step, we can't keep the same buddy so we update it during load
balance. During the periodic load balance, the scheduler computes the activity
of the system thanks the runnable_avg_sum and the cpu_power of all CPUs and
then it defines the CPUs that will be used to handle the current activity. The
selected CPUs will be their own buddy and will participate to the default
load balancing mecanism in order to share the tasks in a fair way, whereas the
not selected CPUs will not, and their buddy will be the last selected CPU.
The behavior can be summarized as: The scheduler defines how many CPUs are
required to handle the current activity, keeps the tasks on these CPUS and
perform normal load balancing (or any evolution of the current load balancer
like the use of runnable load avg from Alex https://lkml.org/lkml/2013/4/1/580)
on this limited number of CPUs . Like the other steps, the CPUs are selected to
minimize the number of power domain that must stay on.

Change since V3:

 - Take into account comments on previous version.
 - Add an agressive packing mode and a knob to select between the various mode

Change since V2:

 - Migrate only a task that wakes up
 - Change the light tasks threshold to 20%
 - Change the loaded CPU threshold to not pull tasks if the current number of
   running tasks is null but the load average is already greater than 50%
 - Fix the algorithm for selecting the buddy CPU.

Change since V1:

Patch 2/6
 - Change the flag name which was not clear. The new name is
   SD_SHARE_POWERDOMAIN.
 - Create an architecture dependent function to tune the sched_domain flags
Patch 3/6
 - Fix issues in the algorithm that looks for the best buddy CPU
 - Use pr_debug instead of pr_info
 - Fix for uniprocessor
Patch 4/6
 - Remove the use of usage_avg_sum which has not been merged
Patch 5/6
 - Change the way the coherency of runnable_avg_sum and runnable_avg_period is
   ensured
Patch 6/6
 - Use the arch dependent function to set/clear SD_SHARE_POWERDOMAIN for ARM
   platform

Previous results for v3:

This series has been tested with hackbench on ARM platform and the results
don't show any performance regression

Hackbench             3.9-rc2  +patches
Mean Time (10 tests): 2.048    2.015
stdev               : 0.047    0.068

Previous results for V2:

This series has been tested with MP3 play back on ARM platform:
TC2 HMP (dual CA-15 and 3xCA-7 cluster).

The measurements have been done on an Ubuntu image during 60 seconds of
playback and the result has been normalized to 100.

              | CA15 | CA7  | total |
-------------------------------------
default       |  81  |   97 | 178   |
pack          |  13  |  100 | 113   |
-------------------------------------

Previous results for V1:

The patch-set has been tested on ARM platforms: quad CA-9 SMP and TC2 HMP
(dual CA-15 and 3xCA-7 cluster). For ARM platform, the results have
demonstrated that it's worth packing small tasks at all topology levels.

The performance tests have been done on both platforms with sysbench. The
results don't show any performance regressions. These results are aligned with
the policy which uses the normal behavior with heavy use cases.

test: sysbench --test=cpu --num-threads=N --max-requests=R run

Results below is the average duration of 3 tests on the quad CA-9.
default is the current scheduler behavior (pack buddy CPU is -1)
pack is the scheduler with the pack mechanism

              | default |  pack   |
-----------------------------------
N=8;  R=200   |  3.1999 |  3.1921 |
N=8;  R=2000  | 31.4939 | 31.4844 |
N=12; R=200   |  3.2043 |  3.2084 |
N=12; R=2000  | 31.4897 | 31.4831 |
N=16; R=200   |  3.1774 |  3.1824 |
N=16; R=2000  | 31.4899 | 31.4897 |
-----------------------------------

The power consumption tests have been done only on TC2 platform which has got
accessible power lines and I have used cyclictest to simulate small tasks. The
tests show some power consumption improvements.

test: cyclictest -t 8 -q -e 1000000 -D 20 & cyclictest -t 8 -q -e 1000000 -D 20

The measurements have been done during 16 seconds and the result has been
normalized to 100

              | CA15 | CA7  | total |
-------------------------------------
default       | 100  |  40  | 140   |
pack          |  <1  |  45  | <46   |
-------------------------------------

The A15 cluster is less power efficient than the A7 cluster but if we assume
that the tasks is well spread on both clusters, we can guest estimate that the
power consumption on a dual cluster of CA7 would have been for a default
kernel:

              | CA7  | CA7  | total |
-------------------------------------
default       |  40  |  40  |  80   |
-------------------------------------

Vincent Guittot (14):
  Revert "sched: Introduce temporary FAIR_GROUP_SCHED dependency for
    load-tracking"
  sched: add a new SD_SHARE_POWERDOMAIN flag for sched_domain
  sched: pack small tasks
  sched: pack the idle load balance
  ARM: sched: clear SD_SHARE_POWERDOMAIN
  sched: add a knob to choose the packing level
  sched: agressively pack at wake/fork/exec
  sched: trig ILB on an idle buddy
  sched: evaluate the activity level of the system
  sched: update the buddy CPU
  sched: filter task pull request
  sched: create a new field with available capacity
  sched: update the cpu_power
  sched: force migration on buddy CPU

 arch/arm/kernel/topology.c       |    9 +
 arch/ia64/include/asm/topology.h |    1 +
 arch/tile/include/asm/topology.h |    1 +
 include/linux/sched.h            |   11 +-
 include/linux/sched/sysctl.h     |    8 +
 include/linux/topology.h         |    4 +
 kernel/sched/core.c              |   14 +-
 kernel/sched/fair.c              |  393 +++++++++++++++++++++++++++++++++++---
 kernel/sched/sched.h             |   15 +-
 kernel/sysctl.c                  |   13 ++
 10 files changed, 423 insertions(+), 46 deletions(-)

-- 
1.7.9.5

