Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532AbaEWSQy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 14:16:54 -0400
Received: from service87.mimecast.com ([91.220.42.44]:35910 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbaEWSQu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 14:16:50 -0400
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        peterz@infradead.org, mingo@kernel.org
Cc: rjw@rjwysocki.net, vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        preeti@linux.vnet.ibm.com, dietmar.eggemann@arm.com
Subject: [RFC PATCH 00/16] sched: Energy cost model for energy-aware scheduling
Date: Fri, 23 May 2014 19:16:27 +0100
Message-Id: <1400869003-27769-1-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
X-OriginalArrivalTime: 23 May 2014 18:16:46.0370 (UTC) FILETIME=[28427020:01CF76B3]
X-MC-Unique: 114052319164801301
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several techniques for saving energy through various scheduler
modifications have been proposed in the past, however most of the
techniques have not been universally beneficial for all use-cases and
platforms. For example, consolidating tasks on fewer cpus is an
effective way to save energy on some platforms, while it might make
things worse on others.

This proposal, which is inspired by the Ksummit workshop discussions
last year [1], takes a different approach by using a (relatively) simple
platform energy cost model to guide scheduling decisions. By providing
the model with platform specific costing data the model can provide a
estimate of the energy implications of scheduling decisions. So instead
of blindly applying scheduling techniques that may or may not work for
the current use-case, the scheduler can make informed energy-aware
decisions. We believe this approach provides a methodology that can be
adapted to any platform, including heterogeneous systems such as ARM
big.LITTLE. The model considers cpus only. Model data includes power
consumption at each P-state, C-state power consumption, and wake-up
energy costs. However, the energy model could potentially be extended to
be used to guide performance/energy decisions in other subsystems.

The scheduler can use energy_diff_task(cpu, task) to estimate the cost
of placing a task on a specific cpu and compare energy costs of
different cpus.

This is an RFC and there are some loose ends that have not been
addressed here or in the code yet. The model and its infrastructure is
in place in the scheduler and it is being used for load-balancing
decisions. However only for the select_task_rq_fair() path for
fork/exec/wake balancing for now. No modifications to periodic or idle
balance yet. There are quite a few dirty hacks in there to tie things
together. To mention a few current limitations:

1. Due to the lack of scale invariant cpu and task utilization, it 
   doesn't work properly with frequency scaling or heterogeneous systems 
   (big.LITTLE).

2. Lacking a proper utilization metric it is assumed that utilization == 
   load. This is only close to being a reasonable assumption if all 
   tasks have nice=0.

3. Platform data for the test platform (ARM TC2) has been hardcoded in 
   arch/arm/ code.

4. Support for multiple per cpu C-states is not implemented yet.

However, the main ideas and the primary focus of this RFC: The energy
model and energy_diff_{load, task}() are there.

Due to limitation 1, the ARM TC2 platform (2xA15+3xA7) was setup to
disable frequency scaling and set frequencies to eliminate the
big.LITTLE performance difference. That basically turns TC2 into an SMP
platform where a subset of the cpus are less energy-efficient.

Tests using a synthetic workload with seven short running periodic
tasks of different size and period, and the sysbench cpu benchmark with
five threads gave the following results:

cpu energy*	short tasks	sysbench
Mainline	100		100
EA		 50		 97

* Note that these energy savings are _not_ representative of what can be
achieved on a true SMP platform where all cpus are equally 
energy-efficient. There should be benefit for SMP platforms as well, 
however, it will be smaller.

The energy model led to consolidation of the short tasks on the A7
cluster (more energy-efficient), while sysbench made use of all cpus as
the A7s didn't have sufficient compute capacity to handle the five
tasks.

To see how scheduling would happen if all cpus would have been A7s the
same tests were done with the A15s' energy model being the same as that
of the A7s (i.e. lying about the platform to the scheduler energy
model). The scheduling pattern for the short tasks changed to being
either consolidated on the A7 or the A15 cluster instead of just on the
A7, which was expected. Currently, there are no tools available to 
easily deduce energy for traces using a platform energy model, which 
could have estimated the energy benefit. Linaro is currently looking 
into extending the idle-stat tool [3] to do this.

Testing using Android workloads [2] didn't go well due to Android's
extensive use of task priority and limitation 2. Once these limitations 
have been addressed benefit is expected on Android as well, which is a 
key target.

The latency overhead induced by the energy model in
select_task_rq_fair() for this unoptimized implementation on TC2 is:

latency		avg (depending on cpu)
Mainline	 2.5 -  4.7 us
EA		10.9 - 16.5 us

However, it should be possible to reduce this significantly.

Patch   1-4: Infrastructure to set up energy model data
Patch   5-9: Bits and pieces needed for the energy model
Patch 10-15: The energy model and scheduler tweaks

This series is based on top of Vincent's topology patches [4].

[1] http://etherpad.osuosl.org/energy-aware-scheduling-ks-2013 (search
for 'cost')
[2] https://lkml.org/lkml/2014/1/7/355
[3] http://git.linaro.org/power/idlestat.git
[4] https://lkml.org/lkml/2014/4/11/137

Dietmar Eggemann (5):
  sched: Introduce sd energy data structures
  sched: Allocate and initialize sched energy
  sched: Add sd energy procfs interface
  arm: topology: Define TC2 sched energy and provide it to scheduler
  sched: Introduce system-wide sched_energy

Morten Rasmussen (11):
  sched: Documentation for scheduler energy cost model
  sched: Introduce CONFIG_SCHED_ENERGY
  sched: Introduce SD_SHARE_CAP_STATES sched_domain flag
  sched, cpufreq: Introduce current cpu compute capacity into scheduler
  sched, cpufreq: Current compute capacity hack for ARM TC2
  sched: Energy model functions
  sched: Task wakeup tracking
  sched: Take task wakeups into account in energy estimates
  sched: Use energy model in select_idle_sibling
  sched: Use energy to guide wakeup task placement
  sched: Disable wake_affine to broaden the scope of wakeup target cpus

 Documentation/scheduler/sched-energy.txt |   66 ++++++
 arch/arm/Kconfig                         |    5 +
 arch/arm/kernel/topology.c               |  120 +++++++++-
 drivers/cpufreq/cpufreq.c                |    8 +
 include/linux/sched.h                    |   30 +++
 kernel/sched/core.c                      |  192 +++++++++++++++-
 kernel/sched/fair.c                      |  359 +++++++++++++++++++++++++++++-
 kernel/sched/sched.h                     |   44 ++++
 8 files changed, 805 insertions(+), 19 deletions(-)
 create mode 100644 Documentation/scheduler/sched-energy.txt

-- 
1.7.9.5


