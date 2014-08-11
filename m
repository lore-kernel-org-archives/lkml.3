Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbaHKLbq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 07:31:46 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:36747 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbaHKLbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 07:31:44 -0400
Subject: [RFC PATCH V2 00/19] Power Scheduler Design
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
To: alex.shi@intel.com, vincent.guittot@linaro.org, peterz@infradead.org,
        pjt@google.com, efault@gmx.de, rjw@rjwysocki.net,
        morten.rasmussen@arm.com, svaidy@linux.vnet.ibm.com,
        arjan@linux.intel.com, mingo@kernel.org
Cc: nicolas.pitre@linaro.org, len.brown@intel.com, yuyang.du@intel.com,
        linaro-kernel@lists.linaro.org, daniel.lezcano@linaro.org,
        corbet@lwn.net, catalin.marinas@arm.com, markgross@thegnar.org,
        sundar.iyer@intel.com, linux-kernel@vger.kernel.org,
        dietmar.eggemann@arm.com, Lorenzo.Pieralisi@arm.com,
        mike.turquette@linaro.org, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de
Date: Mon, 11 Aug 2014 17:01:23 +0530
Message-ID: <20140811113000.31956.52857.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081111-0928-0000-0000-00000406D417
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new power aware scheduling framework is being designed with a goal that
all the cpu power management is in one place. Today the power management 
policies are fragmented between the cpuidle and cpufreq subsystems, which
makes power management inconsistent. To top this, we were integrating
task packing algorithms into the scheduler which could potentially worsen
the scenario.

The new power aware scheduler design will have all policies, all metrics,
all averaging concerning cpuidle and cpufrequency in one place, that being the
scheduler. This patchset lays the foundation for this approach to help 
remove the existing fragmented approach towards cpu power savings.

NOTE: This patchset targets only cpuidle. cpu-frequency can be integrated into
this design on the same lines.

The design is broken down into incremental steps which will enable
easy validation of the power aware scheduler. This by no means is complete
and will require more work to get to a stage where it can beat the 
current approach. Like I said this is just the foundation to help us
get started. The subsequent patches can be small incremental measured steps.

Ingo had pointed out this approach in http://lwn.net/Articles/552889/ and I
have tried my best at understanding and implementing the initial steps that
he suggested.

1.Start from the dumbest possible state: all CPUs  are powered up fully,
there's no idle state selection essentially. 

2.Then go  for the biggest effect first and add the ability to idle in a
lower power  state (with new functions and a low level driver that implements
this for the platform with no policy embedded into it.

3.Implement the task packing algorithm.

This patchset implements the above three steps and makes the fundamental design
of power aware scheduler clear. It shows how:

1.The design should be non intrusive with the existing code. It should be
enabled/disabled by a config switch. This way we can continue to work towards
making it better without having to worry about regressing the kernel and
yet have it in the kernel at the same time; a confidence booster that it is
making headway.
  CONFIG_SCHED_POWER is the switch that makes the new code appear when turned on
and disappear and default to the original code when turned off.

2.The design should help us test it better. Like Ingo pointed out:

"Important: it's not a problem that the initial code won't outperform the 
current kernel's performance. It should outperform the _initial_ 'dumb'
code in the first step. Then the next step should outperform the previous 
step, etc.
  The quality of this iterative approach will eventually surpass the 
combined effect of currently available but non-integrated facilities."

This is precisely what this design does. PATCH[1/19] disables cpuidle and
cpufrequency sub systems altogether if CONFIG_SCHED_POWER is enabled.
This is the dumb code. Our subsequent patches should outperform this.

3. Introduce a low level driver which interfaces scheduler with C-state
switching. Again Ingo had pointed out this saying:
"It should be presented to the scheduler in a platform independent fashion,
but without policy embedded: a low level platform driver interface in essence."

PATCH[2/19] ensures that CPUIDLE governors no longer control
idle state selection. The idle state selection and policies are moved into
kernel/sched/power.c. True, its the same code from the menu governor, however
it has been moved into scheduler specific code and no longer functions like
a driver. Its meant to be part of the core kernel. The "low level driver" lives
under drivers/cpuidle/cpuidle.c like before. It registers platform specific
cpuidle drivers and does other low level stuff that the scheduler needn't
bother about. It has no policies embedded into it whatsoever. Importantly it
is an entry point to switching C states and nothing beyond that.

PATCH[3/19] enumerates idle states and parameters in the scheduler topology.
This is so that the scheduler knows the cost of entry/exit into 
idle states that can be made use of going ahead. As an example, this patchset
shows how the platform specific cpuidle driver should help fill up the idle state
details into the topology. This fundamental information is missing today in the
scheduler.

These two patches are not expected to change the performance/power savings
in any way. They are just the first steps towards the integrated approach of
the power aware scheduler.

The patches PATCH[4/19] to PATCH[18/19] do task packing. This series is the
one that Alex Shi had posted long ago https://lkml.org/lkml/2013/3/30/78.
However this patch series will come into effect only if CONFIG_SCHED_POWER is
enabled. It is this series which is expected to bring about changes in
performance and power savings; not necessarily better than the existing code,
but certainly should be better than the dumb code.

Our subsequent efforts should surpass the performance/powersavings of the
existing code. This patch series is compile tested only.

V1 of this power efficient scheduling design was posted by Morten after
Ingo posted his suggestions on http://lwn.net/Articles/552889/.
[RFC][PATCH 0/9] sched: Power scheduler design proposal:
https://lkml.org/lkml/2013/7/15/101
   But it decoupled the scheduler into the regular and power scheduler with
the latter controlling the cpus that could be used by the regular scheduler.
We do not need this kind of decoupling. With the foundation that this patch
set lays, it must be relatively easy to make the existing scheduler power
aware.

---

Alex Shi (16):
      sched: add sched balance policies in kernel
      sched: add sysfs interface for sched_balance_policy selection
      sched: log the cpu utilization at rq
      sched: add new sg/sd_lb_stats fields for incoming fork/exec/wake balancing
      sched: move sg/sd_lb_stats struct ahead
      sched: get rq potential maximum utilization
      sched: detect wakeup burst with rq->avg_idle
      sched: add power aware scheduling in fork/exec/wake
      sched: using avg_idle to detect bursty wakeup
      sched: packing transitory tasks in wakeup power balancing
      sched: add power/performance balance allow flag
      sched: pull all tasks from source grp and no balance for prefer_sibling
      sched: add new members of sd_lb_stats
      sched: power aware load balance
      sched: lazy power balance
      sched: don't do power balance on share cpu power domain

Preeti U Murthy (3):
      sched/power: Remove cpu idle state selection and cpu frequency tuning
      sched/power: Move idle state selection into the scheduler
      sched/idle: Enumerate idle states in scheduler topology


 Documentation/ABI/testing/sysfs-devices-system-cpu |   23 +
 arch/powerpc/Kconfig                               |    1 
 arch/powerpc/platforms/powernv/Kconfig             |   12 
 drivers/cpufreq/Kconfig                            |    2 
 drivers/cpuidle/Kconfig                            |   10 
 drivers/cpuidle/cpuidle-powernv.c                  |   10 
 drivers/cpuidle/cpuidle.c                          |   65 ++
 include/linux/sched.h                              |   16 -
 include/linux/sched/sysctl.h                       |    3 
 kernel/Kconfig.sched                               |   11 
 kernel/sched/Makefile                              |    1 
 kernel/sched/debug.c                               |    3 
 kernel/sched/fair.c                                |  632 +++++++++++++++++++-
 kernel/sched/power.c                               |  480 +++++++++++++++
 kernel/sched/sched.h                               |   16 +
 kernel/sysctl.c                                    |    9 
 16 files changed, 1234 insertions(+), 60 deletions(-)
 create mode 100644 kernel/Kconfig.sched
 create mode 100644 kernel/sched/power.c

--

