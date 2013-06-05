Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897Ab3FEJ4r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 05:56:47 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:50305 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529Ab3FEJ4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 05:56:44 -0400
MIME-Version: 1.0
In-Reply-To: <20130531105204.GE30394@gmail.com>
References: <20130530134718.GB32728@e103034-lin>
	<20130531105204.GE30394@gmail.com>
Date: Wed, 5 Jun 2013 15:26:43 +0530
Message-ID: <CAP245DVnCW_gNp64QYzavg=0kyMgxV3opbOB84Snw11sOPqZZA@mail.gmail.com>
Subject: Re: power-efficient scheduling design
From: Amit Kucheria <amit.kucheria@linaro.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Morten Rasmussen <morten.rasmussen@arm.com>,
        "Brown, Len" <len.brown@intel.com>, Alex Shi <alex.shi@intel.com>,
        corbet@lwn.net, Peter Zijlstra <peterz@infradead.org>,
        arjan@linux.intel.com, Mike Galbraith <efault@gmx.de>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, pjt@google.com,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 4:22 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Morten Rasmussen <morten.rasmussen@arm.com> wrote:
>
>> Hi,
>>
>> A number of patch sets related to power-efficient scheduling have been
>> posted over the last couple of months. Most of them do not have much
>> data to back them up, so I decided to do some testing.
>
> Thanks, numbers are always welcome!
>
>> Measurement technique:
>> Time spent non-idle (not in idle state) for each cpu based on cpuidle
>> ftrace events. TC2 does not have per-core power-gating, so packing
>> inside the A7 cluster does not lead to any significant power savings.
>> Note that any product grade hardware (TC2 is a test-chip) will very
>> likely have per-core power-gating, so in those cases packing will have
>> an appreciable effect on power savings.
>> Measuring non-idle time rather than power should give a more clear idea
>> about the effect of the patch sets given that the idle back-end is
>> highly implementation specific.
>
> Note that I still disagree with the whole design notion of having an "idle
> back-end" (and a 'cpufreq back end') separate from scheduler power saving
> policy, and none of the patch-sets offered so far solve this fundamental
> design problem.

I don't think you'll see any argument on this one.

> PeterZ and me tried to point out the design requirements previously, but
> it still does not appear to be clear enough to people, so let me spell it
> out again, in a hopefully clearer fashion.

It hasn't been spelled out in as many words before, so thank you!

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

My understanding (and that of several of my colleagues) in discussions
with some of the folks on cc was that we wanted the following things
to happen in somewhat this order:

1. Replacement for task packing bits of sched_mc (Vincent's packing
small task patchset)
2. General scalability improvements and low-hanging fruit e.g. Thomas'
hotplug/kthread rework, un-pinned workqueues (queued for 3.11 by
Tejun), migrating running timers (RFC patches being discussed),
Adaptive NO_HZ, etc.
3. Scheduler-driven CPU states (DVFS and idle)
    a. More CPU topology information in scheduler (to replace
related_cpus, affected_cpus, couple C-states and other such
constructs)
    b. Intermediate step to replace cpufreq/cpuidle governors with a
'sched governor' that uses scheduler statistics instead of heuristics
in the governors today.
    c. Thermal input into scheduling decisions
    d. Co-existing sched-driven and legacy cpufreq/cpuidle policies
    e. Switch over newer HW to default to sched-driven policy

Morten has already gone in great detail about some of the things we
need to address before the scheduler can drive power management.

What you've outlined in this email more or less reverses the order we
had in mind. And that is fine as long as we're all agreeing that it is
the way forward. More below.

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

Someone will have to rewrite the world at some point. IMHO, you're
just asking for the schedule to be brought forward. :)

Doing steps 1. and 2. has brought us to an acceptable
power/performance threshold. Sure, we still have separate cpuidle,
cpufreq and thermal subsystems that sometimes fight each other, but it
is mostly a well-understood problem with known workarounds. Step 3
feels like good hygiene at this point, but one that we intend to help
with.

> This is a "line in the sand", a 'must have' design property for any
> scheduler power saving patches to be acceptable - and I'm NAK-ing
> incomplete approaches that don't solve the root design cause of our power
> saving troubles...

>From what I've read in your proposal, you want step 3. done first. Am
I correct in that assumption? I really want to nail down the
requirements and perhaps a sequence of steps that you might have in
mind.

Can we also expect more timely feedback/flames on this topic going forward?

Regards,
Amit
