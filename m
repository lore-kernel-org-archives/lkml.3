Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab3FNQFQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 12:05:16 -0400
Received: from service87.mimecast.com ([91.220.42.44]:46264 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab3FNQFN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 12:05:13 -0400
Date: Fri, 14 Jun 2013 17:05:22 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: "alex.shi@intel.com" <alex.shi@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "efault@gmx.de" <efault@gmx.de>, "pjt@google.com" <pjt@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>, catalin.marinas@arm.com
Subject: Re: power-efficient scheduling design
Message-ID: <20130614160522.GG32728@e103034-lin>
References: <20130530134718.GB32728@e103034-lin>
 <20130531105204.GE30394@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20130531105204.GE30394@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 14 Jun 2013 16:05:09.0412 (UTC) FILETIME=[F19E0640:01CE6918]
X-MC-Unique: 113061417051001201
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, May 31, 2013 at 11:52:04AM +0100, Ingo Molnar wrote:
> 
> * Morten Rasmussen <morten.rasmussen@arm.com> wrote:
> 
> > Hi,
> > 
> > A number of patch sets related to power-efficient scheduling have been 
> > posted over the last couple of months. Most of them do not have much 
> > data to back them up, so I decided to do some testing.
> 
> Thanks, numbers are always welcome!
> 
> > Measurement technique:
> > Time spent non-idle (not in idle state) for each cpu based on cpuidle
> > ftrace events. TC2 does not have per-core power-gating, so packing
> > inside the A7 cluster does not lead to any significant power savings.
> > Note that any product grade hardware (TC2 is a test-chip) will very
> > likely have per-core power-gating, so in those cases packing will have
> > an appreciable effect on power savings.
> > Measuring non-idle time rather than power should give a more clear idea
> > about the effect of the patch sets given that the idle back-end is
> > highly implementation specific.
> 
> Note that I still disagree with the whole design notion of having an "idle 
> back-end" (and a 'cpufreq back end') separate from scheduler power saving 
> policy, and none of the patch-sets offered so far solve this fundamental 
> design problem.
> 
> PeterZ and me tried to point out the design requirements previously, but 
> it still does not appear to be clear enough to people, so let me spell it 
> out again, in a hopefully clearer fashion.
> 
> The scheduler has valuable power saving information available:
> 
>  - when a CPU is busy: about how long the current task expects to run
> 
>  - when a CPU is idle: how long the current CPU expects _not_ to run
> 
>  - topology: it knows how the CPUs and caches interrelate and already 
>    optimizes based on that
> 
>  - various high level and low level load averages and other metrics about 
>    the recent past that show how busy a particular CPU is, how busy the 
>    whole system is, and what the runtime properties of individual tasks is 
>    (how often it sleeps, etc.)
> 
> so the scheduler is in an _ideal_ position to do a judgement call about 
> the near future and estimate how deep an idle state a CPU core should 
> enter into and what frequency it should run at.
> 
> The scheduler is also at a high enough level to host a "I want maximum 
> performance, power does not matter to me" user policy override switch and 
> similar user policy details.
> 
> No ifs and whens about that.
> 
> Today the power saving landscape is fragmented and sad: we just randomly 
> interface scheduler task packing changes with some idle policy (and 
> cpufreq policy), which might or might not combine correctly.
> 
> Even when the numbers improve, it's an entirely random, essentially 
> unmaintainable property: because there's no clear split (possible) between 
> 'scheduler policy' and 'idle policy'. This is why we removed the old, 
> broken power saving scheduler code a year ago: to make room for something 
> _better_.
> 
> So if we want to add back scheduler power saving then what should happen 
> is genuinely better code:
> 
> To create a new low level idle driver mechanism the scheduler could use 
> and integrate proper power saving / idle policy into the scheduler.
> 
> In that power saving framework the already existing scheduler topology 
> information should be extended with deep idle parameters:
> 
>  - enumeration of idle states
> 
>  - how long it takes to enter+exit a particular idle state
> 
>  - [ perhaps information about how destructive to CPU caches that
>      particular idle state is. ]
> 
>  - new driver entry point that allows the scheduler to enter any of the 
>    enumerated idle states. Platform code will not change this state, all 
>    policy decisions and the idle state is decided at the power saving 
>    policy level.
> 
> All of this combines into a 'cost to enter and exit an idle state' 
> estimation plus a way to enter idle states. It should be presented to the 
> scheduler in a platform independent fashion, but without policy embedded: 
> a low level platform driver interface in essence.
> 
> Thomas Gleixner's recent work to generalize platform idle routines will 
> further help the implementation of this. (that code is upstream already)
> 
> _All_ policy, all metrics, all averaging should happen at the scheduler 
> power saving level, in a single place, and then the scheduler should 
> directly drive the new low level idle state driver mechanism.
> 
> 'scheduler power saving' and 'idle policy' are one and the same principle 
> and they should be handled in a single place to offer the best power 
> saving results.
> 
> Note that any RFC patch-set that offers an implementation for this could 
> be structured in a gradual fashion: only implementing it for a limited CPU 
> range initially. The new framework can then be extended to more and more 
> CPUs and architectures, incorporating more complicated power saving 
> features gradually. (The old, existing idle policy code would remain 
> untouched and available - it would simply not be used when the new policy 
> is activated.)
> 
> I.e. I'm not asking for a 'rewrite the world' kind of impossible task - 
> I'm providing an actionable path to get improved power saving upstream, 
> but it has to use a _sane design_.
> 
> This is a "line in the sand", a 'must have' design property for any 
> scheduler power saving patches to be acceptable - and I'm NAK-ing 
> incomplete approaches that don't solve the root design cause of our power 
> saving troubles...
> 

Looking at the discussion it seems that people have slightly different
views, but most agree that the goal is an integrated scheduling,
frequency, and idle policy like you pointed out from the beginning.

What is less clear is how such design would look like. Catalin has
suggested two different approaches. Integrating cpufreq into the load
balancing, or let the scheduler focus on load balancing and extend
cpufreq to also restrict number of cpus available to the scheduler using
cpu_power. The former approach would increase the scheduler complexity
significantly as I already highlighted in my first reply. The latter
approach introduces a way to, at lease initially, separate load
balancing from capacity management, which I think is an interesting
approach. Based on this idea I propose the following design:

                         +-----------------+
                         |                 |     +----------+
         current load    | Power scheduler |<----+ cpufreq  |
              +--------->| sched/power.c   +---->| driver   |
              |          |                 |     +----------+
              |          +-------+---------+
              |             ^    |
        +-----+---------+   |    |
        |               |   |    | available capacity
        | Scheduler     |<--+----+ (e.g. cpu_power)
        | sched/fair.c  |   |
        |               +--+|
        +---------------+  ||
           ^               ||
           |               v|
 +---------+--------+  +----------+
 | task load metric |  | cpuidle  |
 | arch/*           |  | driver   |
 +------------------+  +----------+

The intention is that the power scheduler will implement the (unified)
power policy. It gets the current load of the system from the scheduler.
Based on this information it will adjust the compute capacity available
to the scheduler and drive frequency changes such that enough compute
capacity is available to handle the current load. If the total load can
be handled by a subset of cpus, it will reduce the capacity of the
excess cpus to 0 (cpu_power=1). Likewise, if the load increases it will
increase capacity of one or more idle cpus to allow the scheduler to
spread the load. The power scheduler has knowledge about the power
topology and will guide the scheduler to idle the most optimum cpus by
reducing its capacity. Global idle decision will be handled by the power
scheduler, so cpuidle can over time be reduced to become just a driver,
once we have added C-state selection to the power scheduler.

The scheduler is left to focus on scheduling mechanics and finding the
best possible load balance on the cpu capacities set by the power
scheduler. It will share a detailed view of the current load with the
power scheduler to enable it to make the right capacity adjustments. The
scheduler will need some optimization to cope better with asymmetric
compute capacities. We may want to reduce capacity of some cpu to
increase their idle time while letting others take the majority of the
load.

Frequency scaling has a problematic impact on PJT's load metic, which
was pointed out a while ago by Chris Redpath
<https://lkml.org/lkml/2013/4/16/289>.  So I agree with Arjan's
suggestion to change the load calculation basis to something which is
frequency invariant. Use whatever counters that are available on the
specific platform.

I'm aware that the scheduler and power scheduler decisions may be
inextricably linked so we may decide to merge them. However, I think it
is worth trying to keep the power scheduling decisions out of the
scheduler until we have proven it infeasible.

We are going to start working on this design and see where it takes us.
We will post any results and suggested patches for folk to comment on.
As a starting point we are planning to create a power scheduler
(kernel/sched/power.c) similar to a cpufreq governor that does capacity
management, and then evolve the solution from there.

Morten

> Thanks,
> 
> 	Ingo
> 

