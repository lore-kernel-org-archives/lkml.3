Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757640Ab3FTPX0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 11:23:26 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:59967 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756035Ab3FTPXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 11:23:23 -0400
Date: Thu, 20 Jun 2013 17:23:19 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Morten Rasmussen <morten.rasmussen@arm.com>
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
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: power-efficient scheduling design
Message-ID: <20130620152318.GB17638@gmail.com>
References: <20130530134718.GB32728@e103034-lin>
 <20130531105204.GE30394@gmail.com>
 <20130604150316.GE32728@e103034-lin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130604150316.GE32728@e103034-lin>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Morten Rasmussen <morten.rasmussen@arm.com> wrote:

> On Fri, May 31, 2013 at 11:52:04AM +0100, Ingo Molnar wrote:
> > 
> > * Morten Rasmussen <morten.rasmussen@arm.com> wrote:
> > 
> > > Hi,
> > > 
> > > A number of patch sets related to power-efficient scheduling have been 
> > > posted over the last couple of months. Most of them do not have much 
> > > data to back them up, so I decided to do some testing.
> > 
> > Thanks, numbers are always welcome!
> > 
> > > Measurement technique:
> > > Time spent non-idle (not in idle state) for each cpu based on cpuidle
> > > ftrace events. TC2 does not have per-core power-gating, so packing
> > > inside the A7 cluster does not lead to any significant power savings.
> > > Note that any product grade hardware (TC2 is a test-chip) will very
> > > likely have per-core power-gating, so in those cases packing will have
> > > an appreciable effect on power savings.
> > > Measuring non-idle time rather than power should give a more clear idea
> > > about the effect of the patch sets given that the idle back-end is
> > > highly implementation specific.
> > 
> > Note that I still disagree with the whole design notion of having an "idle 
> > back-end" (and a 'cpufreq back end') separate from scheduler power saving 
> > policy, and none of the patch-sets offered so far solve this fundamental 
> > design problem.
> > 
> > PeterZ and me tried to point out the design requirements previously, but 
> > it still does not appear to be clear enough to people, so let me spell it 
> > out again, in a hopefully clearer fashion.
> > 
> > The scheduler has valuable power saving information available:
> > 
> >  - when a CPU is busy: about how long the current task expects to run
> > 
> >  - when a CPU is idle: how long the current CPU expects _not_ to run
> > 
> >  - topology: it knows how the CPUs and caches interrelate and already 
> >    optimizes based on that
> > 
> >  - various high level and low level load averages and other metrics about 
> >    the recent past that show how busy a particular CPU is, how busy the 
> >    whole system is, and what the runtime properties of individual tasks is 
> >    (how often it sleeps, etc.)
> > 
> > so the scheduler is in an _ideal_ position to do a judgement call about 
> > the near future and estimate how deep an idle state a CPU core should 
> > enter into and what frequency it should run at.
> > 
> > The scheduler is also at a high enough level to host a "I want maximum 
> > performance, power does not matter to me" user policy override switch and 
> > similar user policy details.
> > 
> > No ifs and whens about that.
> > 
> > Today the power saving landscape is fragmented and sad: we just randomly 
> > interface scheduler task packing changes with some idle policy (and 
> > cpufreq policy), which might or might not combine correctly.
> > 
> > Even when the numbers improve, it's an entirely random, essentially 
> > unmaintainable property: because there's no clear split (possible) between 
> > 'scheduler policy' and 'idle policy'. This is why we removed the old, 
> > broken power saving scheduler code a year ago: to make room for something 
> > _better_.
> > 
> > So if we want to add back scheduler power saving then what should happen 
> > is genuinely better code:
> > 
> > To create a new low level idle driver mechanism the scheduler could use 
> > and integrate proper power saving / idle policy into the scheduler.
> > 
> > In that power saving framework the already existing scheduler topology 
> > information should be extended with deep idle parameters:
> > 
> >  - enumeration of idle states
> > 
> >  - how long it takes to enter+exit a particular idle state
> > 
> >  - [ perhaps information about how destructive to CPU caches that
> >      particular idle state is. ]
> > 
> >  - new driver entry point that allows the scheduler to enter any of the 
> >    enumerated idle states. Platform code will not change this state, all 
> >    policy decisions and the idle state is decided at the power saving 
> >    policy level.
> > 
> > All of this combines into a 'cost to enter and exit an idle state' 
> > estimation plus a way to enter idle states. It should be presented to the 
> > scheduler in a platform independent fashion, but without policy embedded: 
> > a low level platform driver interface in essence.
> > 
> > Thomas Gleixner's recent work to generalize platform idle routines will 
> > further help the implementation of this. (that code is upstream already)
> > 
> > _All_ policy, all metrics, all averaging should happen at the scheduler 
> > power saving level, in a single place, and then the scheduler should 
> > directly drive the new low level idle state driver mechanism.
> > 
> > 'scheduler power saving' and 'idle policy' are one and the same principle 
> > and they should be handled in a single place to offer the best power 
> > saving results.
> > 
> > Note that any RFC patch-set that offers an implementation for this could 
> > be structured in a gradual fashion: only implementing it for a limited CPU 
> > range initially. The new framework can then be extended to more and more 
> > CPUs and architectures, incorporating more complicated power saving 
> > features gradually. (The old, existing idle policy code would remain 
> > untouched and available - it would simply not be used when the new policy 
> > is activated.)
> > 
> > I.e. I'm not asking for a 'rewrite the world' kind of impossible task - 
> > I'm providing an actionable path to get improved power saving upstream, 
> > but it has to use a _sane design_.
> > 
> > This is a "line in the sand", a 'must have' design property for any 
> > scheduler power saving patches to be acceptable - and I'm NAK-ing 
> > incomplete approaches that don't solve the root design cause of our power 
> > saving troubles...
> 
> Thanks for sharing your view.
> 
> I agree with idea of having a high level user switch to change
> power/performance policy trade-offs for the system. Not only for
> scheduling. I also share your view that the scheduler is in the ideal
> place to drive the frequency scaling and idle policies.
> 
> However, I think that an integrated solution with one unified policy
> implemented in the scheduler would take a significant rewrite of the
> scheduler and the power management frameworks even if we start with just
> a few SoCs.
> 
> To reach an integrated solution that does better than the current
> approach there is a range of things that need to be considered:
> 
> - Define a power-efficient scheduling policy. Depending on the power
>   gating support on the particular system packing tasks may improve
>   power-efficiency while spreading the tasks may be better for others.
> 
> - Define how the user policy switch works. In previous discussions it
>   was proposed to have a high level switch that allows specification of
>   what the system should strive to achieve - power saving or performance.
>   In those discussions, what power meant wasn't exactly defined.
> 
> - Find a generic way to represent the power topology which includes
>   power domains, voltage domains and frequency domains. Also, more
>   importantly how we can derive the optimal power/performance policy for
>   the specific platform. There may be dependencies between idle and
>   frequency states like it is the case for frequency boost mode like Arjan
>   mentions in his reply.
> 
> - The fact that not all platforms expose all idle states to the OS and
>   that closed firmware may do whatever it likes behind the scenes. There
>   are various reasons to do this. Not all of them are bad.
> 
> - Define a scheduler driven frequency scaling policy that at least
>   matches the 'performance' of the current cpufreq policies and has
>   potential for further improvements.
> 
> - Match the power savings of the current cpuidle governors which are
>   based on arcane heuristics developed over years to predict things like
>   the occurrence of the next interrupt.
> 
> - Thermal aspects add more complexity to the power/performance policy.
>   Depending on the platform, overheating may be handled by frequency
>   capping or restricting the number of active cpus.
> 
> - Asymmetric/heterogeneous multi-processors need to be dealt with.
> 
> This is not a complete list. My point is that moving all policy to the 
> scheduler will significantly increase the complexity of the scheduler. 
> It is my impression that the general opinion is that the scheduler is 
> already too complicated. Correct me if I'm wrong.

The thing we care about is the net complexity of the kernel. Moving 
related kernel code next to each other will in the _worst case_ result in 
exactly the same complexity as we had before.

But even just a small number of unifications will decrease complexity and 
give us a chance to implement a more workable, more maintainable, more 
correct power saving policy.

The scheduler maintainers have no problem with going this way - we've 
asked for such a design and approach for years.

> While the proposed task packing patches are not complete solutions, they 
> address the first item on the above list and can be seen as a step 
> towards the goal.
>
> Should I read your recommendation as you prefer a complete and 
> potentially huge patch set over incremental patch sets?

I like incremental and see no reason why this couldn't be made 
incremental, by adding the new facility for a smallish, manageable number 
of supported configurations - then extending it gradually as it proves 
itself.

> It would be good to have even a high level agreement on the path forward 
> where the expectation first and foremost is to take advantage of the 
> schedulers ideal position to drive the power management while 
> simplifying the power management code.

I'd suggest to try a set of patches that implements this for the hw 
configuration you are most interested in - then measure and see where we 
stand.

It should be a non-disruptive approach: i.e. a new CONFIG_SCHED_POWER 
.config switch, which, if turned off, makes the new code go away, and it 
also won't do anything on platforms that don't (yet) support the driver 
model where the scheduler determines idle and performance states.

On CONFIG_SCHED_POWER=y kernels the new policy activates if there's low 
level support present.

There's no other mode of operation: either the new scheduling policy is 
fully there, or it's totally inactive.

This makes it entirely non-disruptive and non-regressive, while still 
providing a road towards goodness.

Thanks,

	Ingo
