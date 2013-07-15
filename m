Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab3GOUk3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 16:40:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49056 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754342Ab3GOUk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 16:40:27 -0400
Date: Mon, 15 Jul 2013 22:39:22 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Catalin Marinas <catalin.marinas@arm.com>
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
Message-ID: <20130715203922.GD23818@dyad.programming.kicks-ass.net>
References: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com>
 <20130713064909.GW25631@dyad.programming.kicks-ass.net>
 <20130713102350.GA8067@MacBook-Pro.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130713102350.GA8067@MacBook-Pro.local>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 13, 2013 at 11:23:51AM +0100, Catalin Marinas wrote:
> > This looks like a userspace hotplug deamon approach lifted to kernel space :/
> 
> The difference is that this is faster. We even had hotplug in mind some
> years ago for big.LITTLE but it wouldn't give the performance we need
> (hotplug is incredibly slow even if driven from the kernel).

faster, slower, still horrid :-)

> That's what we've been pushing for. From a big.LITTLE perspective, I
> would probably vote for Vincent's patches but I guess we could probably
> adapt any of the other options.
> 
> But then we got Ingo NAK'ing all these approaches. Taking the best bits
> from the current load balancing patches would create yet another set of
> patches which don't fall under Ingo's requirements (at least as I
> understand them).

Right, so Ingo is currently away as well -- should be back 'today' or tomorrow.
But I suspect he mostly fell over the presentation. 

I've never known Ingo to object to doing incremental development; in fact he
often suggests doing so.

So don't present the packing thing as a power aware scheduler; that
presentation suggests its the complete deal. Give instead a complete
description of the problem; and tell how the current patch set fits into that
and which aspect it solves; and that further patches will follow to sort the
other issues.

That keeps the entire thing much clearer.

> > Then worry about power thingies.
> 
> To quote Ingo: "To create a new low level idle driver mechanism the
> scheduler could use and integrate proper power saving / idle policy into
> the scheduler."
> 
> That's unless we all agree (including Ingo) that the above requirement
> is orthogonal to task packing and, as a *separate* project, we look at
> better integrating the cpufreq/cpuidle with the scheduler, possibly with
> a new driver model and governors as libraries used by such drivers. In
> which case the current packing patches shouldn't be NAK'ed but reviewed
> so that they can be improved further or rewritten.

Right, so first thing would be to list all the thing that need doing:

 - integrate idle guestimator
 - intergrate cpufreq stats
 - fix per entity runtime vs cpufreq
 - intrgrate/redo cpufreq
 - add packing features
 - {all the stuff I forgot}

Then see what is orthogonal and what is most important and get people to agree
to an order. Then go..

> I agree in general but there is the intel_pstate.c driver which has it's
> own separate statistics that the scheduler does not track. 

Right, question is how much of that will survive Arjan next-gen effort.

> We could move
> to invariant task load tracking which uses aperf/mperf (and could do
> similar things with perf counters on ARM). As I understand from Arjan,
> the new pstate driver will be different, so we don't know exactly what
> it requires.

Right, so part of the effort should be understanding what the various parties
want/need. As far as I understand the Intel stuff, P states are basically
useless and the only useful state to ever program is the max one -- although
I'm sure Arjan will eventually explain how that is wrong :-)

We could do optional things; I'm not much for 'requiring' stuff that other
arch simply cannot support, or only support at great effort/cost.

Stealing PMU counters for sched work would be crossing the line for me, that
must be optional.
