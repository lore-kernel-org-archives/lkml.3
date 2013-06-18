Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab3FRCj4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 22:39:56 -0400
Received: from mail.lang.hm ([64.81.33.126]:54227 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644Ab3FRCjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 22:39:55 -0400
Date: Mon, 17 Jun 2013 18:37:21 -0700 (PDT)
From: David Lang <david@lang.hm>
X-X-Sender: dlang@asgard.lang.hm
To: Morten Rasmussen <morten.rasmussen@arm.com>
cc: Ingo Molnar <mingo@kernel.org>, "alex.shi@intel.com" <alex.shi@intel.com>,
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
In-Reply-To: <20130614160522.GG32728@e103034-lin>
Message-ID: <alpine.DEB.2.02.1306171809200.9258@nftneq.ynat.uz>
References: <20130530134718.GB32728@e103034-lin> <20130531105204.GE30394@gmail.com> <20130614160522.GG32728@e103034-lin>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 14 Jun 2013, Morten Rasmussen wrote:

> Looking at the discussion it seems that people have slightly different
> views, but most agree that the goal is an integrated scheduling,
> frequency, and idle policy like you pointed out from the beginning.
>
> What is less clear is how such design would look like. Catalin has
> suggested two different approaches. Integrating cpufreq into the load
> balancing, or let the scheduler focus on load balancing and extend
> cpufreq to also restrict number of cpus available to the scheduler using
> cpu_power. The former approach would increase the scheduler complexity
> significantly as I already highlighted in my first reply. The latter
> approach introduces a way to, at lease initially, separate load
> balancing from capacity management, which I think is an interesting
> approach. Based on this idea I propose the following design:
>
>                         +-----------------+
>                         |                 |     +----------+
>         current load    | Power scheduler |<----+ cpufreq  |
>              +--------->| sched/power.c   +---->| driver   |
>              |          |                 |     +----------+
>              |          +-------+---------+
>              |             ^    |
>        +-----+---------+   |    |
>        |               |   |    | available capacity
>        | Scheduler     |<--+----+ (e.g. cpu_power)
>        | sched/fair.c  |   |
>        |               +--+|
>        +---------------+  ||
>           ^               ||
>           |               v|
> +---------+--------+  +----------+
> | task load metric |  | cpuidle  |
> | arch/*           |  | driver   |
> +------------------+  +----------+
>
> The intention is that the power scheduler will implement the (unified)
> power policy. It gets the current load of the system from the scheduler.
> Based on this information it will adjust the compute capacity available
> to the scheduler and drive frequency changes such that enough compute
> capacity is available to handle the current load. If the total load can
> be handled by a subset of cpus, it will reduce the capacity of the
> excess cpus to 0 (cpu_power=1). Likewise, if the load increases it will
> increase capacity of one or more idle cpus to allow the scheduler to
> spread the load. The power scheduler has knowledge about the power
> topology and will guide the scheduler to idle the most optimum cpus by
> reducing its capacity. Global idle decision will be handled by the power
> scheduler, so cpuidle can over time be reduced to become just a driver,
> once we have added C-state selection to the power scheduler.
>
> The scheduler is left to focus on scheduling mechanics and finding the
> best possible load balance on the cpu capacities set by the power
> scheduler. It will share a detailed view of the current load with the
> power scheduler to enable it to make the right capacity adjustments. The
> scheduler will need some optimization to cope better with asymmetric
> compute capacities. We may want to reduce capacity of some cpu to
> increase their idle time while letting others take the majority of the
> load.
>
> Frequency scaling has a problematic impact on PJT's load metic, which
> was pointed out a while ago by Chris Redpath
> <https://lkml.org/lkml/2013/4/16/289>.  So I agree with Arjan's
> suggestion to change the load calculation basis to something which is
> frequency invariant. Use whatever counters that are available on the
> specific platform.
>
> I'm aware that the scheduler and power scheduler decisions may be
> inextricably linked so we may decide to merge them. However, I think it
> is worth trying to keep the power scheduling decisions out of the
> scheduler until we have proven it infeasible.
>
> We are going to start working on this design and see where it takes us.
> We will post any results and suggested patches for folk to comment on.
> As a starting point we are planning to create a power scheduler
> (kernel/sched/power.c) similar to a cpufreq governor that does capacity
> management, and then evolve the solution from there.

I don't think that you are passing nearly enough information around.

A fairly simple example

take a relatively modern 4-core system with turbo mode where speed controls 
affect two cores at a time (I don't know the details of the available CPUs to 
know if this is an exact fit to any existing system, but I think it's a 
reasonable fit)

If you are running with a loadave of 2, should you power down 2 cores and run 
the other two in turbo mode, power down 2 cores and not increase the speed, or 
leave all 4 cores running as is.

Depending on the mix of processes, I could see any one of the three being the 
right answer.

If you have a process that's maxing out it's cpu time on one core, going to 
turbo mode is the right thing as the other processes should fit on the other 
core and that process will use more CPU (theoretically getting done sooner)

If no process is close to maxing out the core, then if you are in power saving 
mode, you probably want to shut down two cores and run everything on the other 
two

If you only have two processes eating almost all your CPU time, going to two 
cores is probably the right thing to do.

If you have more processes, each eating a little bit of time, then continuing 
to run on all four cores uses more cache, and could let all of the tasks finish 
faster.


So, how is the Power Scheduler going to get this level of information?

It doesn't seem reasonable to either pass this much data around, or to try and 
give two independant tools access to the same raw data (since that data is so 
tied to the internal details of the scheduler). If we are talking two parts of 
the same thing, then it's perfectly legitimate to have this sort of intimate 
knowledge of the internal data structures.


Also, if the power scheduler puts the cores at different speeds, how is the 
balancing scheduler supposed to know so that it can schedule appropriately? This 
is the bigLittle problem again.

It's this level of knowledge that both the power management and the scheduler 
need to know about what's going on in the guts of the other that make me say 
that they really are going to need to be merged.


The routines to change the core modes will be external, and will vary wildly 
between different systems, but the decision making logic should be unified.

David Lang
