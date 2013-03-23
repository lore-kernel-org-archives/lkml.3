Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751021Ab3CWL5u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 07:57:50 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:41110 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab3CWL5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 07:57:49 -0400
Message-ID: <514D9837.6050300@linux.vnet.ibm.com>
Date: Sat, 23 Mar 2013 17:25:35 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, peterz@infradead.org, mingo@kernel.org,
        linux@arm.linux.org.uk, pjt@google.com, santosh.shilimkar@ti.com,
        morten.rasmussen@arm.com, chander.kashyap@linaro.org,
        cmetcalf@tilera.com, tony.luck@intel.com, alex.shi@intel.com,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de, len.brown@intel.com,
        arjan@linux.intel.com, amit.kucheria@linaro.org, corbet@lwn.net
Subject: Re: [RFC PATCH v3 0/6]  sched: packing small tasks
References: <1363955155-18382-1-git-send-email-vincent.guittot@linaro.org>
In-Reply-To: <1363955155-18382-1-git-send-email-vincent.guittot@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032311-8256-0000-0000-000006C4BE2B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vincent,

The power aware scheduler patchset that has been released by Alex
recently [https://lkml.org/lkml/2013/2/18/4], also has the idea of
packing of small tasks.In that patchset, the waking of small tasks in
done on a leader cpu, which of course varies dynamically.
https://lkml.org/lkml/2013/2/18/6

I will refer henceforth to the above patchset as Patch A and your
current patchset in this mail as Patch B.

The difference in Patch A is that it is packing small tasks onto a
leader cpu, i.e. a cpu which has just enough capacity to take on itself
a light weight task. Essentially belonging to a group which has a
favourable grp_power and the leader cpu having a suitable rq->util.

In Patch B, you are choosing a buddy cpu, belonging to a group with the
least cpu power, and while deciding to pack tasks onto the buddy cpu,
this again boils down to, verifying if the
grp_power is favourable and the buddy cpu has a suitable rq->util.

In my opinion, this goes to say that both the patches are using similar
metrics to decide if a cpu is capable of handling the light weight task.
The difference lies in how far the search for the appropriate cpu can
proceed. While Patch A continues to search at all levels of sched
domains till the last to find the appropriate cpu, Patch B queries only
the buddy CPU.

The point I am trying to make is that, considering the above
similarities and differences, is it possible for us to see if the ideas
that both these patches bring in can be merged into one, since both of
them are having the common goal of packing small tasks.

Thanks

Regards
Preeti U Murthy

On 03/22/2013 05:55 PM, Vincent Guittot wrote:
> Hi,
> 
> This patchset takes advantage of the new per-task load tracking that is
> available in the kernel for packing the small tasks in as few as possible
> CPU/Cluster/Core. The main goal of packing small tasks is to reduce the power
> consumption in the low load use cases by minimizing the number of power domain
> that are enabled. The packing is done in 2 steps:
> 
> The 1st step looks for the best place to pack tasks in a system according to
> its topology and it defines a pack buddy CPU for each CPU if there is one
> available. We define the best CPU during the build of the sched_domain instead
> of evaluating it at runtime because it can be difficult to define a stable
> buddy CPU in a low CPU load situation. The policy for defining a buddy CPU is
> that we pack at all levels inside a node where a group of CPU can be power
> gated independently from others. For describing this capability, a new flag
> has been introduced SD_SHARE_POWERDOMAIN that is used to indicate whether the
> groups of CPUs of a scheduling domain are sharing their power state. By
> default, this flag has been set in all sched_domain in order to keep unchanged
> the current behavior of the scheduler and only ARM platform clears the
> SD_SHARE_POWERDOMAIN flag for MC and CPU level.
> 
> In a 2nd step, the scheduler checks the load average of a task which wakes up
> as well as the load average of the buddy CPU and it can decide to migrate the
> light tasks on a not busy buddy. This check is done during the wake up because
> small tasks tend to wake up between periodic load balance and asynchronously
> to each other which prevents the default mechanism to catch and migrate them
> efficiently. A light task is defined by a runnable_avg_sum that is less than
> 20% of the runnable_avg_period. In fact, the former condition encloses 2 ones:
> The average CPU load of the task must be less than 20% and the task must have
> been runnable less than 10ms when it woke up last time in order to be
> electable for the packing migration. So, a task than runs 1 ms each 5ms will
> be considered as a small task but a task that runs 50 ms with a period of
> 500ms, will not.
> Then, the business of the buddy CPU depends of the load average for the rq and
> the number of running tasks. A CPU with a load average greater than 50% will
> be considered as busy CPU whatever the number of running tasks is and this
> threshold will be reduced by the number of running tasks in order to not
> increase too much the wake up latency of a task. When the buddy CPU is busy,
> the scheduler falls back to default CFS policy.
> 
> Change since V2:
> 
>  - Migrate only a task that wakes up
>  - Change the light tasks threshold to 20%
>  - Change the loaded CPU threshold to not pull tasks if the current number of
>    running tasks is null but the load average is already greater than 50%
>  - Fix the algorithm for selecting the buddy CPU.
> 
> Change since V1:
> 
> Patch 2/6
>  - Change the flag name which was not clear. The new name is
>    SD_SHARE_POWERDOMAIN.
>  - Create an architecture dependent function to tune the sched_domain flags
> Patch 3/6
>  - Fix issues in the algorithm that looks for the best buddy CPU
>  - Use pr_debug instead of pr_info
>  - Fix for uniprocessor
> Patch 4/6
>  - Remove the use of usage_avg_sum which has not been merged
> Patch 5/6
>  - Change the way the coherency of runnable_avg_sum and runnable_avg_period is
>    ensured
> Patch 6/6
>  - Use the arch dependent function to set/clear SD_SHARE_POWERDOMAIN for ARM
>    platform
> 
> 
> New results for v3:
> 
> This series has been tested with hackbench on ARM platform and the results
> don't show any performance regression
> 
> Hackbench             3.9-rc2  +patches
> Mean Time (10 tests): 2.048    2.015
> stdev               : 0.047    0.068
> 
> Previous results for V2:
> 
> This series has been tested with MP3 play back on ARM platform:
> TC2 HMP (dual CA-15 and 3xCA-7 cluster).
> 
> The measurements have been done on an Ubuntu image during 60 seconds of
> playback and the result has been normalized to 100.
> 
>               | CA15 | CA7  | total |
> -------------------------------------
> default       |  81  |   97 | 178   |
> pack          |  13  |  100 | 113   |
> -------------------------------------
> 
> Previous results for V1:
> 
> The patch-set has been tested on ARM platforms: quad CA-9 SMP and TC2 HMP
> (dual CA-15 and 3xCA-7 cluster). For ARM platform, the results have
> demonstrated that it's worth packing small tasks at all topology levels.
> 
> The performance tests have been done on both platforms with sysbench. The
> results don't show any performance regressions. These results are aligned with
> the policy which uses the normal behavior with heavy use cases.
> 
> test: sysbench --test=cpu --num-threads=N --max-requests=R run
> 
> Results below is the average duration of 3 tests on the quad CA-9.
> default is the current scheduler behavior (pack buddy CPU is -1)
> pack is the scheduler with the pack mechanism
> 
>               | default |  pack   |
> -----------------------------------
> N=8;  R=200   |  3.1999 |  3.1921 |
> N=8;  R=2000  | 31.4939 | 31.4844 |
> N=12; R=200   |  3.2043 |  3.2084 |
> N=12; R=2000  | 31.4897 | 31.4831 |
> N=16; R=200   |  3.1774 |  3.1824 |
> N=16; R=2000  | 31.4899 | 31.4897 |
> -----------------------------------
> 
> The power consumption tests have been done only on TC2 platform which has got
> accessible power lines and I have used cyclictest to simulate small tasks. The
> tests show some power consumption improvements.
> 
> test: cyclictest -t 8 -q -e 1000000 -D 20 & cyclictest -t 8 -q -e 1000000 -D 20
> 
> The measurements have been done during 16 seconds and the result has been
> normalized to 100
> 
>               | CA15 | CA7  | total |
> -------------------------------------
> default       | 100  |  40  | 140   |
> pack          |  <1  |  45  | <46   |
> -------------------------------------
> 
> The A15 cluster is less power efficient than the A7 cluster but if we assume
> that the tasks is well spread on both clusters, we can guest estimate that the
> power consumption on a dual cluster of CA7 would have been for a default
> kernel:
> 
>               | CA7  | CA7  | total |
> -------------------------------------
> default       |  40  |  40  |  80   |
> -------------------------------------
> 
> Vincent Guittot (6):
>   Revert "sched: Introduce temporary FAIR_GROUP_SCHED dependency for
>     load-tracking"
>   sched: add a new SD_SHARE_POWERDOMAIN flag for sched_domain
>   sched: pack small tasks
>   sched: secure access to other CPU statistics
>   sched: pack the idle load balance
>   ARM: sched: clear SD_SHARE_POWERDOMAIN
> 
>  arch/arm/kernel/topology.c       |    9 +++
>  arch/ia64/include/asm/topology.h |    1 +
>  arch/tile/include/asm/topology.h |    1 +
>  include/linux/sched.h            |    9 +--
>  include/linux/topology.h         |    4 +
>  kernel/sched/core.c              |   14 ++--
>  kernel/sched/fair.c              |  149 +++++++++++++++++++++++++++++++++++---
>  kernel/sched/sched.h             |   14 ++--
>  8 files changed, 169 insertions(+), 32 deletions(-)
> 

