Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760683AbaEMNXX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 09:23:23 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:15917 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360AbaEMNXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 09:23:20 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7fae6d000004d6d-88-53721cc6f77a
Content-transfer-encoding: 8BIT
Message-id: <1399987413.16665.4.camel@AMDC1943>
Subject: Re: [RFC PATCH 00/12 v2] A new CPU load metric for power-efficient
 scheduler: CPU ConCurrency
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Yuyang Du <yuyang.du@intel.com>
Cc: mingo@redhat.com, peterz@infradead.org, rafael.j.wysocki@intel.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        arjan.van.de.ven@intel.com, len.brown@intel.com, alan.cox@intel.com,
        mark.gross@intel.com, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, rajeev.d.muralidhar@intel.com,
        vishwesh.m.rudramuni@intel.com, nicole.chalhoub@intel.com,
        ajaya.durg@intel.com, harinarayanan.seshadri@intel.com,
        jacob.jun.pan@linux.intel.com, fengguang.wu@intel.com
Date: Tue, 13 May 2014 15:23:33 +0200
In-reply-to: <1399832221-8314-1-git-send-email-yuyang.du@intel.com>
References: <1399832221-8314-1-git-send-email-yuyang.du@intel.com>
X-Mailer: Evolution 3.10.4-0ubuntu1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRmVeSWpSXmKPExsVy+t/xq7rHZIqCDY5MlbW4fOk7m8WD/RfY
	LP6tu8Nm8f75emaLs7tnsFosPbiexWLWlL1MFpd3zWGz+Nx7hNFi04udrBaXDixgsnj/7jeb
	xey3t1gtjvceYLJ4vOItu8XvoxuYLDqOfGO2eNm9kdXi+arljA7CHmvmrWH02LxCy2PxnpdM
	Hneu7WHzmHcy0OP9vqtsHp83yQWwR3HZpKTmZJalFunbJXBldDx8xFgwS6fi8dybbA2MF5S6
	GDk4JARMJD6/t+pi5AQyxSQu3FvP1sXIxSEksJRR4uL5RUwgCV4BQYkfk++xgNQzC8hLHLmU
	DRJmFlCXmDRvETOILSTwmVFi0TY7iHJ9iUunpoLFhQUyJPYd3sAOYrMJGEtsXr6EDcQWEVCW
	+NiyB2wXs8AzZon13b/AilgEVCV23NwG1swp4Cwx+dZLNogFThIfzixmhThUWWLe/mNMExgF
	ZiE5bxbCebOQnLeAkXkVo2hqaXJBcVJ6rpFecWJucWleul5yfu4mRkikfd3BuPSY1SFGAQ5G
	JR5eD+aCYCHWxLLiytxDjBIczEoivM5SRcFCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGNldZinp
	77MLFnkv7HpNZJW8g6/g7w0fNSfMcLpftDG9RsM9XZ177bNfk779f+d4IkTQeO7me6sbCxly
	O9snCOyxXPeoMcFgkvmETbaJXxJbtAvXn9lTz31EgD2FdUoJ747uldVXbKeukUo9tuxQMPui
	CtVHvNNK9ZZv6+F/yFiiNevylvU6ukosxRmJhlrMRcWJAGDs/xqSAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pon, 2014-05-12 at 02:16 +0800, Yuyang Du wrote:
> Hi Ingo, PeterZ, Rafael, and others,
> 
> The current schedulerâ€™s load balancing is completely work-conserving. In some
> workload, generally low CPU utilization but immersed with CPU bursts of
> transient tasks, migrating task to engage all available CPUs for
> work-conserving can lead to significant overhead: cache locality loss,
> idle/active HW state transitional latency and power, shallower idle state,
> etc, which are both power and performance inefficient especially for todayâ€™s
> low power processors in mobile. 
> 
> This RFC introduces a sense of idleness-conserving into work-conserving (by
> all means, we really donâ€™t want to be overwhelming in only one way). But to
> what extent the idleness-conserving should be, bearing in mind that we donâ€™t
> want to sacrifice performance? We first need a load/idleness indicator to that
> end.
> 
> Thanks to CFSâ€™s â€œmodel an ideal, precise multi-tasking CPUâ€, tasks can be seen
> as concurrently running (the tasks in the runqueue). So it is natural to use
> task concurrency as load indicator. Having said that, we do two things:
> 
> 1) Divide continuous time into periods of time, and average task concurrency
> in period, for tolerating the transient bursts:
> a = sum(concurrency * time) / period
> 2) Exponentially decay past periods, and synthesize them all, for hysteresis
> to load drops or resilience to load rises (let f be decaying factor, and a_x
> the xth period average since period 0):
> s = a_n + f^1 * a_n-1 + f^2 * a_n-2 +, ..., + f^(n-1) * a_1 + f^n * a_0
> 
> We name this load indicator as CPU ConCurrency (CC): task concurrency
> determines how many CPUs are needed to be running concurrently.
> 
> Another two ways of how to interpret CC:
> 
> 1) the current work-conserving load balance also uses CC, but instantaneous
> CC.
> 
> 2) CC vs. CPU utilization. CC is runqueue-length-weighted CPU utilization. If
> we change: "a = sum(concurrency * time) / period" to "a' = sum(1 * time) /
> period". Then a' is just about the CPU utilization. And the way we weight
> runqueue-length is the simplest one (excluding the exponential decays, and you
> may have other ways).
> 
> To track CC, we intercept the scheduler in 1) enqueue, 2) dequeue, 3)
> scheduler tick, and 4) enter/exit idle.
> 
> After CC, in the consolidation part, we do 1) attach the CPU topology to be
> adaptive beyond our experimental platforms, and 2) intercept the current load
> balance for load and load balancing containment.
> 
> Currently, CC is per CPU. To consolidate, the formula is based on a heuristic.
> Suppose we have 2 CPUs, their task concurrency over time is ('-' means no
> task, 'x' having tasks):
> 
> 1)
> CPU0: ---xxxx---------- (CC[0])
> CPU1: ---------xxxx---- (CC[1])
> 
> 2)
> CPU0: ---xxxx---------- (CC[0])
> CPU1: ---xxxx---------- (CC[1])
> 
> If we consolidate CPU0 and CPU1, the consolidated CC will be: CC' = CC[0] +
> CC[1] for case 1 and CC'' = (CC[0] + CC[1]) * 2 for case 2. For the cases in
> between case 1 and 2 in terms of how xxx overlaps, the CC should be between
> CC' and CC''. So, we uniformly use this condition for consolidation (suppose
> we consolidate m CPUs to n CPUs, m > n):
> 
> (CC[0] + CC[1] + ... + CC[m-2] + CC[m-1]) * (n + log(m-n)) >=<? (1 * n) * n *
> consolidating_coefficient
> 
> The consolidating_coefficient could be like 100% or more or less.
> 
> By CC, we implemented a Workload Consolidation patch on two Intel mobile
> platforms (a quad-core composed of two dual-core modules): contain load and
> load balancing in the first dual-core when aggregated CC low, and if not in
> the full quad-core. Results show that we got power savings and no substantial
> performance regression (even gains for some). The workloads we used to
> evaluate the Workload Consolidation include 1) 50+ perf/ux benchmarks (almost
> all of the magazine ones), and 2) ~10 power workloads, of course, they are the
> easiest ones, such as browsing, audio, video, recording, imaging, etc. The
> current half-life is 1 period, and the period was 32ms, and now 64ms for more
> aggressive consolidation.

Hi,

Could you share some more numbers for energy savings and impact on
performance? I am also interested in these 10 power workloads - what
they are exactly?

Best regards,
Krzysztof




> v2:
> - Data type defined in formation
> 
> Yuyang Du (12):
>   CONFIG for CPU ConCurrency
>   Init CPU ConCurrency
>   CPU ConCurrency calculation
>   CPU ConCurrency tracking
>   CONFIG for Workload Consolidation
>   Attach CPU topology to specify each sched_domain's workload
>     consolidation
>   CPU ConCurrency API for Workload Consolidation
>   Intercept wakeup/fork/exec load balancing
>   Intercept idle balancing
>   Intercept periodic nohz idle balancing
>   Intercept periodic load balancing
>   Intercept RT scheduler
> 
>  arch/x86/Kconfig             |   21 +
>  include/linux/sched.h        |   13 +
>  include/linux/sched/sysctl.h |    8 +
>  include/linux/topology.h     |   16 +
>  kernel/sched/Makefile        |    1 +
>  kernel/sched/concurrency.c   |  928 ++++++++++++++++++++++++++++++++++++++++++
>  kernel/sched/core.c          |   46 +++
>  kernel/sched/fair.c          |  131 +++++-
>  kernel/sched/rt.c            |   25 ++
>  kernel/sched/sched.h         |   36 ++
>  kernel/sysctl.c              |   16 +
>  11 files changed, 1232 insertions(+), 9 deletions(-)
>  create mode 100644 kernel/sched/concurrency.c
> 

