Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759213AbaGCQ0M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 12:26:12 -0400
Received: from service87.mimecast.com ([91.220.42.44]:44785 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755667AbaGCQ0I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 12:26:08 -0400
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        peterz@infradead.org, mingo@kernel.org
Cc: rjw@rjwysocki.net, vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        preeti@linux.vnet.ibm.com, Dietmar.Eggemann@arm.com, pjt@google.com
Subject: [RFCv2 PATCH 00/23] sched: Energy cost model for energy-aware scheduling
Date: Thu,  3 Jul 2014 17:25:47 +0100
Message-Id: <1404404770-323-1-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
X-OriginalArrivalTime: 03 Jul 2014 16:26:05.0772 (UTC) FILETIME=[7D1758C0:01CF96DB]
X-MC-Unique: 114070317260606601
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is RFC v2 of this proposal (changelog at the end).

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

For example, the scheduler can use energy_diff_task(cpu, task) to
estimate the cost of placing a task on a specific cpu and compare energy
costs of different cpus.

This is an RFC and there are some loose ends that have not been
addressed here or in the code yet. The model and its infrastructure is
in place in the scheduler and it is being used for load-balancing
decisions. It is used for the select_task_rq_fair() path for
fork/exec/wake balancing and to guide the selection of the source cpu
for periodic or idle balance. The latter is still very early days. There
are quite a few dirty hacks in there to tie things together. To mention
a few current limitations:

1. Due to the lack of scale invariant cpu and task utilization, it 
   doesn't work properly with frequency scaling or heterogeneous systems 
   (big.LITTLE).

2. Platform data for the test platform (ARM TC2) has been hardcoded in 
   arch/arm/ code.

3. Most likely idle-state is currently hardcoded to be the shallowest
   one. cpuidle integration missing.

However, the main ideas and the primary focus of this RFC: The energy
model and energy_diff_{load, task, cpu}() are there.

Due to limitation 1, the ARM TC2 platform (2xA15+3xA7) was setup to
disable frequency scaling and set frequencies to eliminate the
big.LITTLE performance difference. That basically turns TC2 into an SMP
platform where a subset of the cpus are less energy-efficient.

Tests using a synthetic workload with seven short running periodic
tasks of different size and period, and the sysbench cpu benchmark with
five threads gave the following results:

cpu energy*	short tasks	sysbench
Mainline	100		100
EA		 49		 99

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

Testing with more realistic (mobile) use-cases was done using two
previously described Android workloads [2]: Audio playback and Web
browsing. In addition the combination of the the two was measured.
Reported numbers are averages for 20 runs and have been normalized.
Browsing performance score is roughly rendering time (less is better).

		browsing	audio		browsing+audio
Mainline
 A15		 51.5		 17.7		 40.5
 A7		 48.5		 82.3		 59.5
 energy		100.0		100.0		100.0
 perf		100.0				100.0

EA
 A15		 16.3		  2.2		 13.4
 A7		 60.2		 80.7		 61.1
 energy		 76.6		 82.9		 74.6
 perf		108.9				108.9

Diff
 energy		-23.4%		-17.1%		-25.4%
 perf		 -8.9%				 -8.9%

Energy is saved for all three use-cases. The performance loss is due to
the TC2 fixed frequency setup. The A15s are not exactly delivering the
same performance as the A7s. They have ~10% more compute capacity
(guestimate). As with the synthetic tests, these numbers are better than
what should be expected for a true SMP platform.

The latency overhead induced by the energy model in
select_task_rq_fair() for this unoptimized implementation on TC2 is:

latency		avg (depending on cpu)
Mainline	 2.3 -  4.9 us
EA		13.3 - 15.8 us

However, it should be possible to reduce this significantly.

Patch     1: Documentation
Patch   2-5: Infrastructure to set up energy model data
Patch	  6: ARM TC2 energy model data
Patch     7: Infrastructure
Patch  8-13: Unweighted load tracking
Patch 14-17: Bits and pieces needed for the energy model
Patch 18-23: The energy model and scheduler tweaks

This series is based on a fairly recent tip/sched/core.

[1] http://etherpad.osuosl.org/energy-aware-scheduling-ks-2013 (search
for 'cost')
[2] https://lkml.org/lkml/2014/1/7/355
[3] http://git.linaro.org/power/idlestat.git
[4] https://lkml.org/lkml/2014/4/11/137

Changes

RFC v2:
 - Extended documentation:
   - Cover the energy model in greater detail.
   - Recipe for deriving platform energy model.
 - Replaced Kconfig with sched feature (jump label).
 - Add unweighted load tracking.
 - Use unweighted load as task/cpu utilization.
 - Support for multiple idle states per sched_group. cpuidle integration
   still missing.
 - Changed energy aware functionality in select_idle_sibling().
 - Experimental energy aware load-balance support.

Dietmar Eggemann (12):
  sched: Introduce energy data structures
  sched: Allocate and initialize energy data structures
  sched: Add energy procfs interface
  arm: topology: Define TC2 energy and provide it to the scheduler
  sched: Introduce system-wide sched_energy
  sched: Aggregate unweighted load contributed by task entities on
    parenting cfs_rq
  sched: Maintain the unweighted load contribution of blocked entities
  sched: Account for blocked unweighted load waking back up
  sched: Introduce an unweighted cpu_load array
  sched: Rename weighted_cpuload() to cpu_load()
  sched: Introduce weighted/unweighted switch in load related functions
  sched: Use energy model in load balance path

Morten Rasmussen (11):
  sched: Documentation for scheduler energy cost model
  sched: Make energy awareness a sched feature
  sched: Introduce SD_SHARE_CAP_STATES sched_domain flag
  sched, cpufreq: Introduce current cpu compute capacity into scheduler
  sched, cpufreq: Current compute capacity hack for ARM TC2
  sched: Likely idle state statistics placeholder
  sched: Energy model functions
  sched: Task wakeup tracking
  sched: Take task wakeups into account in energy estimates
  sched: Use energy model in select_idle_sibling
  sched: Use energy to guide wakeup task placement

 Documentation/scheduler/sched-energy.txt |  439 ++++++++++++++++++++
 arch/arm/kernel/topology.c               |  126 +++++-
 drivers/cpufreq/cpufreq.c                |    8 +
 include/linux/sched.h                    |   28 ++
 kernel/sched/core.c                      |  178 +++++++-
 kernel/sched/debug.c                     |    6 +
 kernel/sched/fair.c                      |  646 ++++++++++++++++++++++++++----
 kernel/sched/features.h                  |    6 +
 kernel/sched/proc.c                      |   22 +-
 kernel/sched/sched.h                     |   44 +-
 10 files changed, 1416 insertions(+), 87 deletions(-)
 create mode 100644 Documentation/scheduler/sched-energy.txt

-- 
1.7.9.5


