Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236Ab3JRLxq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 07:53:46 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:43670 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481Ab3JRLxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 07:53:44 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@kernel.org,
        pjt@google.com, Morten.Rasmussen@arm.com, cmetcalf@tilera.com,
        tony.luck@intel.com, alex.shi@intel.com, preeti@linux.vnet.ibm.com,
        linaro-kernel@lists.linaro.org
Cc: rjw@sisk.pl, paulmck@linux.vnet.ibm.com, corbet@lwn.net,
        tglx@linutronix.de, len.brown@intel.com, arjan@linux.intel.com,
        amit.kucheria@linaro.org, l.majewski@samsung.com,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [RFC][PATCH v5 00/14] sched: packing tasks
Date: Fri, 18 Oct 2013 13:52:14 +0200
Message-Id: <1382097147-30088-1-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the 5th version of the previously named "packing small tasks" patchset.
"small" has been removed because the patchset doesn't only target small tasks 
anymore.

This patchset takes advantage of the new per-task load tracking that is
available in the scheduler to pack the tasks in a minimum number of
CPU/Cluster/Core. The packing mechanism takes into account the power gating
topology of the CPUs to minimize the number of power domains that need to be 
powered on simultaneously.

Most of the code has been put in fair.c file but it can be easily moved to
another location. This patchset tries to solve one part of the larger
energy-efficient scheduling problem and it should be merged with other
proposals that solve other parts like the power-scheduler made by Morten.

The packing is done in 3 steps:

The 1st step creates a topology of the power gating of the CPUs that will help
the scheduler to choose which CPUs will handle the current activity. This
topology is described thanks to a new flag SD_SHARE_POWERDOMAIN that indicates
whether the groups of CPUs of a scheduling domain share their power state. In
order to be efficient, a group of CPUs that share their power state will be
used (or not) simultaneously. By default, this flag is set in all sched_domain
in order to keep the current behavior of the scheduler unchanged.

The 2nd step evaluates the current activity of the system and creates a list of
CPUs for handling it. The average activity level of CPUs is set to 80% but is
configurable by changing the sched_packing_level knob. The activity level and
the involvement of a CPU in the packing effort is evaluated during the periodic
load balance similarly to cpu_power. Then, the default load balancing behavior
is used to balance tasks between this reduced list of CPUs.
As the current activity doesn't take into account a new task, an unused CPUs
can also be selected during the 1st wake up and until the activity is updated.

The 3rd step occurs when the scheduler selects a target CPU for a newly
awakened task. The current wakeup latency of  idle CPUs is used to select the
one with the most shallow c-state. In some situation where the task load is
small compared to the latency, the newly awakened task can even stay on the
current CPU. Since the load is the main metric for the scheduler, the wakeup
latency is transposed into an equivalent load so that the current mechanism of
the load balance that is based on load comparison, is kept unchanged. A shared
structure has been created to exchange information between scheduler and
cpuidle (or any other framework that needs to share information). The wakeup
latency is the only field for the moment but it could be extended with
additional useful information like the target load or the expected sleep
duration of a CPU.

The patchset is based on v3.12-rc2 and is available in the git tree:
git://git.linaro.org/people/vingu/kernel.git
branch sched-packing-small-tasks-v5

If you want to test the patchset, you must enable CONFIG_PACKING_TASKS first.
Then, you also need to create a arch_sd_local_flags that will clear the
SD_SHARE_POWERDOMAIN flag at the appropriate level for your architecture. This
has already be done for ARM architecture in the patchset.

The figures below show the latency of cyclictest with and without the patchset
on an ARM platform with a v3.11. The test has been runned 10 times on each kernel.
#cyclictest -t 3 -q -e 1000000 -l 3000  -i 1800 -d 100
                 average (us) stdev
v3.11            381,5        79,86
v3.11 + patches  173,83       13,62

Change since V4:
 - v4 posting:https://lkml.org/lkml/2013/4/25/396
 - Keep only the aggressive packing mode.
 - Add a finer grain power domain description mechanism that includes
DT description
 - Add a structure to share information with other framework
 - Use current wakeup latency of an idle CPU when selecting the target idle CPU
 - All the task packing mechanism can be disabled with a single config option

Change since V3:
 - v3 posting: https://lkml.org/lkml/2013/3/22/183
 - Take into account comments on previous version.
 - Add an aggressive packing mode and a knob to select between the various mode

Change since V2:
 - v2 posting: https://lkml.org/lkml/2012/12/12/164
 - Migrate only a task that wakes up
 - Change the light tasks threshold to 20%
 - Change the loaded CPU threshold to not pull tasks if the current number of
   running tasks is null but the load average is already greater than 50%
 - Fix the algorithm for selecting the buddy CPU.

Change since V1:
 -v1 posting: https://lkml.org/lkml/2012/10/7/19
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

Vincent Guittot (14):
  sched: add a new arch_sd_local_flags for sched_domain init
  ARM: sched: clear SD_SHARE_POWERDOMAIN
  sched: define pack buddy CPUs
  sched: do load balance only with packing cpus
  sched: add a packing level knob
  sched: create a new field with available capacity
  sched: get CPU's activity statistic
  sched: move load idx selection in find_idlest_group
  sched: update the packing cpu list
  sched: init this_load to max in find_idlest_group
  sched: add a SCHED_PACKING_TASKS config
  sched: create a statistic structure
  sched: differantiate idle cpu
  cpuidle: set the current wake up latency

 arch/arm/include/asm/topology.h  |    4 +
 arch/arm/kernel/topology.c       |   50 ++++-
 arch/ia64/include/asm/topology.h |    3 +-
 arch/tile/include/asm/topology.h |    3 +-
 drivers/cpuidle/cpuidle.c        |   11 ++
 include/linux/sched.h            |   13 +-
 include/linux/sched/sysctl.h     |    9 +
 include/linux/topology.h         |   11 +-
 init/Kconfig                     |   11 ++
 kernel/sched/core.c              |   11 +-
 kernel/sched/fair.c              |  395 ++++++++++++++++++++++++++++++++++++--
 kernel/sched/sched.h             |    8 +-
 kernel/sysctl.c                  |   17 ++
 13 files changed, 521 insertions(+), 25 deletions(-)

-- 
1.7.9.5
