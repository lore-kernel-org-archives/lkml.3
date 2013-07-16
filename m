Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932658Ab3GPMoI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 08:44:08 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:46262 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932086Ab3GPMoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 08:44:06 -0400
Date: Tue, 16 Jul 2013 13:42:48 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "alex.shi@intel.com" <alex.shi@intel.com>,
        "efault@gmx.de" <efault@gmx.de>, "pjt@google.com" <pjt@google.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [RFC][PATCH 0/9] sched: Power scheduler design proposal
Message-ID: <20130716124248.GB10036@arm.com>
References: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com>
 <20130713064909.GW25631@dyad.programming.kicks-ass.net>
 <20130713102350.GA8067@MacBook-Pro.local>
 <20130715203922.GD23818@dyad.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130715203922.GD23818@dyad.programming.kicks-ass.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 09:39:22PM +0100, Peter Zijlstra wrote:
> On Sat, Jul 13, 2013 at 11:23:51AM +0100, Catalin Marinas wrote:
> > > This looks like a userspace hotplug deamon approach lifted to kernel space :/
> > 
> > The difference is that this is faster. We even had hotplug in mind some
> > years ago for big.LITTLE but it wouldn't give the performance we need
> > (hotplug is incredibly slow even if driven from the kernel).
> 
> faster, slower, still horrid :-)

Hotplug for power management is horrid, I agree, but it depends on how
you look at the problem. What we need (at least or ARM) is to leave a
socket/cluster idle when the number of tasks is sufficient to run on the
other. The old power saving scheduling used to have some hierarchy with
different balancing policies per level of hierarchy. IIRC this was too
complex with 9 possible states and some chance of going to to 27. To get
a simpler replacement, just left-packing of tasks does not work either,
so you need some power topology information into the scheduler.

I can see two approaches with regards to task placement:

1. Get the load balancer to pack tasks in a way to optimise performance
   within a socket but let other sockets idle.
2. Have another entity (power scheduler as per Morten's patches) decide
   which sockets to be used and let the main scheduler do its best
   within those constraints.

With (2) you have little changes to the main load balancer with reduced
state space (basically it only cares about CPU capacities rather than
balancing policies at different levels). We then keep the power
topology, feedback from the low-level driver (like what can/cannot be
done) into the separate power scheduler entity. I would say the load
balancer state space from a power awareness perspective is linearised.

> > That's what we've been pushing for. From a big.LITTLE perspective, I
> > would probably vote for Vincent's patches but I guess we could probably
> > adapt any of the other options.
> > 
> > But then we got Ingo NAK'ing all these approaches. Taking the best bits
> > from the current load balancing patches would create yet another set of
> > patches which don't fall under Ingo's requirements (at least as I
> > understand them).
> 
> Right, so Ingo is currently away as well -- should be back 'today' or tomorrow.
> But I suspect he mostly fell over the presentation. 
> 
> I've never known Ingo to object to doing incremental development; in fact he
> often suggests doing so.
> 
> So don't present the packing thing as a power aware scheduler; that
> presentation suggests its the complete deal. Give instead a complete
> description of the problem; and tell how the current patch set fits into that
> and which aspect it solves; and that further patches will follow to sort the
> other issues.

Thanks for the clarification ;).

> > > Then worry about power thingies.
> > 
> > To quote Ingo: "To create a new low level idle driver mechanism the
> > scheduler could use and integrate proper power saving / idle policy into
> > the scheduler."
> > 
> > That's unless we all agree (including Ingo) that the above requirement
> > is orthogonal to task packing and, as a *separate* project, we look at
> > better integrating the cpufreq/cpuidle with the scheduler, possibly with
> > a new driver model and governors as libraries used by such drivers. In
> > which case the current packing patches shouldn't be NAK'ed but reviewed
> > so that they can be improved further or rewritten.
> 
> Right, so first thing would be to list all the thing that need doing:
> 
>  - integrate idle guestimator
>  - intergrate cpufreq stats
>  - fix per entity runtime vs cpufreq
>  - intrgrate/redo cpufreq
>  - add packing features
>  - {all the stuff I forgot}
> 
> Then see what is orthogonal and what is most important and get people to agree
> to an order. Then go..

It sounds fine, not different from what we've thought. A problem is that
task packing on its own doesn't give any clear view of what the overall
solution will look like, so I assume you/Ingo would like to see the
bigger picture (though probably not the complete implementation but
close enough).

Morten's power scheduler tries to address the above and it will grow
into controlling a new model of power driver (and taking into account
Arjan's and others' comments regarding the API). At the same time, we
need some form of task packing. The power scheduler can drive this
(currently via cpu_power) or can simply turn a knob if there are better
options that will be accepted in the scheduler.

> > I agree in general but there is the intel_pstate.c driver which has it's
> > own separate statistics that the scheduler does not track. 
> 
> Right, question is how much of that will survive Arjan next-gen effort.

I think all Arjan's care about is a simple go_fastest() API ;).

> > We could move
> > to invariant task load tracking which uses aperf/mperf (and could do
> > similar things with perf counters on ARM). As I understand from Arjan,
> > the new pstate driver will be different, so we don't know exactly what
> > it requires.
> 
> Right, so part of the effort should be understanding what the various parties
> want/need. As far as I understand the Intel stuff, P states are basically
> useless and the only useful state to ever program is the max one -- although
> I'm sure Arjan will eventually explain how that is wrong :-)
> 
> We could do optional things; I'm not much for 'requiring' stuff that other
> arch simply cannot support, or only support at great effort/cost.
> 
> Stealing PMU counters for sched work would be crossing the line for me, that
> must be optional.

I agree, it should be optional.

-- 
Catalin
