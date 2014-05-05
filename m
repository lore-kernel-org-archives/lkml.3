Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151AbaEEIIb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 04:08:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:46110 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755121AbaEEII3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 04:08:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,986,1389772800"; 
   d="scan'208";a="526078460"
From: Yuyang Du <yuyang.du@intel.com>
To: mingo@redhat.com, peterz@infradead.org, rafael.j.wysocki@intel.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Cc: arjan.van.de.ven@intel.com, len.brown@intel.com, alan.cox@intel.com,
        mark.gross@intel.com, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, rajeev.d.muralidhar@intel.com,
        vishwesh.m.rudramuni@intel.com, nicole.chalhoub@intel.com,
        ajaya.durg@intel.com, harinarayanan.seshadri@intel.com,
        yuyang.du@intel.com
Subject: =?UTF-8?q?=5BRFC=20PATCH=2000/12=20v1=5D=20A=20new=20CPU=20load=20metric=20for=20power-efficient=20scheduler=3A=20CPU=20ConCurrency?=
Date: Mon,  5 May 2014 08:02:40 +0800
Message-Id: <1399248172-13871-1-git-send-email-yuyang.du@intel.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo, PeterZ, Rafael, and others,

The current scheduler’s load balancing is completely work-conserving. In some
workload, generally low CPU utilization but immersed with CPU bursts of
transient tasks, migrating task to engage all available CPUs for
work-conserving can lead to significant overhead: cache locality loss,
idle/active HW state transitional latency and power, shallower idle state,
etc, which are both power and performance inefficient especially for today’s
low power processors in mobile. 

This RFC introduces a sense of idleness-conserving into work-conserving (by
all means, we really don’t want to be overwhelming in only one way). But to
what extent the idleness-conserving should be, bearing in mind that we don’t
want to sacrifice performance? We first need a load/idleness indicator to that
end.

Thanks to CFS’s “model an ideal, precise multi-tasking CPU”, tasks can be seen
as concurrently running (the tasks in the runqueue). So it is natural to use
task concurrency as load indicator. Having said that, we do two things:

1) Divide continuous time into periods of time, and average task concurrency
in period, for tolerating the transient bursts:
a = sum(concurrency * time) / period
2) Exponentially decay past periods, and synthesize them all, for hysteresis
to load drops or resilience to load rises (let f be decaying factor, and a_x
the xth period average since period 0):
s = a_n + f^1 * a_n-1 + f^2 * a_n-2 +, ..., + f^(n-1) * a_1 + f^n * a_0

We name this load indicator as CPU ConCurrency (CC): task concurrency
determines how many CPUs are needed to be running concurrently.

Another two ways of how to interpret CC:

1) the current work-conserving load balance also uses CC, but instantaneous
CC.

2) CC vs. CPU utilization. CC is runqueue-length-weighted CPU utilization. If
we change: "a = sum(concurrency * time) / period" to "a' = sum(1 * time) /
period". Then a' is just about the CPU utilization. And the way we weight
runqueue-length is the simplest one (excluding the exponential decays, and you
may have other ways).

To track CC, we intercept the scheduler in 1) enqueue, 2) dequeue, 3)
scheduler tick, and 4) enter/exit idle.

After CC, in the consolidation part, we do 1) attach the CPU topology to be
adaptive beyond our experimental platforms, and 2) intercept the current load
balance for load and load balancing containment.

Currently, CC is per CPU. To consolidate, the formula is based on a heuristic.
Suppose we have 2 CPUs, their task concurrency over time is ('-' means no
task, 'x' having tasks):

1)
CPU0: ---xxxx---------- (CC[0])
CPU1: ---------xxxx---- (CC[1])

2)
CPU0: ---xxxx---------- (CC[0])
CPU1: ---xxxx---------- (CC[1])

If we consolidate CPU0 and CPU1, the consolidated CC will be: CC' = CC[0] +
CC[1] for case 1 and CC'' = (CC[0] + CC[1]) * 2 for case 2. For the cases in
between case 1 and 2 in terms of how xxx overlaps, the CC should be between
CC' and CC''. So, we uniformly use this condition for consolidation (suppose
we consolidate m CPUs to n CPUs, m > n):

(CC[0] + CC[1] + ... + CC[m-2] + CC[m-1]) * (n + log(m-n)) >=<? (1 * n) * n *
consolidate_coefficient

The consolidate_coefficient could be like 100% or more or less.

By CC, we implemented a Workload Consolidation patch on two Intel mobile
platforms (a quad-core composed of two dual-core modules): contain load and
load balancing in the first dual-core when aggregated CC low, and if not in
the full quad-core. Results show that we got power savings and no substantial
performance regression (even gains for some). The workloads we used to
evaluate the Workload Consolidation include 1) 50+ perf/ux benchmarks (almost
all of the magazine ones), and 2) ~10 power workloads, of course, they are the
easiest ones, such as browsing, audio, video, recording, imaging, etc. The
current half-life is 1 period, and the period was 32ms, and now 64ms for more
aggressive consolidation.

Yuyang Du (12):
  CONFIG for CPU ConCurrency
  Init for CPU ConCurrency
  CPU ConCurrency calculation
  CPU ConCurrency collecting in:
  CONFIG for Workload Consolidation
  Attach CPU topology
  CPU ConCurrency API for Workload Consolidation
  Intercept wakeup/fork/exec balance
  Intercept idle balance
  Intercept periodic nohz idle balance
  Intercept periodic load balance
  Intercept RT provocatively

 arch/x86/Kconfig             |   21 +
 include/linux/sched.h        |   13 +
 include/linux/sched/sysctl.h |    8 +
 include/linux/topology.h     |   16 +
 kernel/sched/Makefile        |    1 +
 kernel/sched/concurrency.c   |  928 ++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/core.c          |   49 +++
 kernel/sched/fair.c          |  131 +++++-
 kernel/sched/rt.c            |   25 ++
 kernel/sched/sched.h         |   36 ++
 kernel/sysctl.c              |   16 +
 11 files changed, 1235 insertions(+), 9 deletions(-)
 create mode 100644 kernel/sched/concurrency.c

-- 
1.7.9.5

