Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab3GOUA0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 16:00:26 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48308 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063Ab3GOUAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 16:00:25 -0400
Date: Mon, 15 Jul 2013 21:59:14 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Morten Rasmussen <morten.rasmussen@arm.com>, mingo@kernel.org,
        vincent.guittot@linaro.org, preeti@linux.vnet.ibm.com,
        alex.shi@intel.com, efault@gmx.de, pjt@google.com, len.brown@intel.com,
        corbet@lwn.net, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [RFC][PATCH 0/9] sched: Power scheduler design proposal
Message-ID: <20130715195914.GC23818@dyad.programming.kicks-ass.net>
References: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com>
 <20130713064909.GW25631@dyad.programming.kicks-ass.net>
 <51E166C8.3000902@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E166C8.3000902@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 13, 2013 at 07:40:08AM -0700, Arjan van de Ven wrote:
> On 7/12/2013 11:49 PM, Peter Zijlstra wrote:
> >
> >Arjan; from reading your emails you're mostly busy explaining what cannot be
> >done. Please explain what _can_ be done and what Intel wants. From what I can
> >see you basically promote a max P state max concurrency race to idle FTW.
> 
> >
> >Since you can't say what the max P state is; and I think I understand the
> >reasons for that, and the hardware might not even respect the P state you tell
> >it to run at, does it even make sense to talk about Intel P states? When would
> >you not program the max P state?
> 
> this is where it gets complicated ;-( the race-to-idle depends on the type of
> code that is running, if things are memory bound it's outright not true, but
> for compute bound it often is.

So you didn't actually answer the question about when you'd program a less than
max P state. Your recommended interface also glaringly lacks the
arch_please_go_slower_noaw() function.

What's the point of having a 'go faster' button if you can't also go slower?

So you can program any P state; but the hardware is free do as it pleases but
not slower than the lowest P state. So clearly the hardware is 'smart'.

Going by your interface there's also not much influence as to where the 'power'
goes; can we for example force the GPU to clock lower in order to 'free' up
power for cores?

If we can, we should very much include that in the entire discussion.


> What I would like to see is
> 
> 1) Move the idle predictor logic into the scheduler, or at least a library
>    (I'm not sure the scheduler can do better than the current code, but it might,
>     and what menu does today is at least worth putting in some generic library)

Right, so the idea is that these days we have much better task runtime
behaviour tracking than we used to have and this might help. I also realize the
idle guestimator uses more than just task activity, interrupt activity is also
very important.

This also makes it not a pure scheduling thing so I wouldn't be too bothered if
it lived in kernel/cpu/idle.c instead of in the scheduler proper.

Not sure calling it a generic library would be wise; that has such an optional
sound to it. The thing we want to avoid is people brewing their own etc..

Also, my interest in it is that the scheduler wants to use it; and when we go
do power aware scheduling I feel it should live very near the scheduler if not
in the scheduler for the simple reason that part of being power aware is trying
to stay idle as long as possible; the idle guestimator is the measure of that.

So in that sense they are closely related.

> 2) An interface between scheduler and P state code in the form of (and don't take the names as actual function names ;-)
>     void arch_please_go_fastest(void);   /* or maybe int cpunr as argument, but that's harder to implement */

Here again, the only thing this allows is max P state race for idle. Why would
Intel still pretend to have P states if they're so useless and mean so little?

>     int arch_can_you_go_faster(void);  /* if the scheduler would like to know this instead of load balancing .. unsure */

You said Intel could not say if it were at the max P state; so how could it
possibly answer this one?

>     unsigned long arch_instructions_executed(void); /* like tsc, but on instructions, so the scheduler can account actual work done */

To what purpose? People mostly still care about wall-time for things like
response and such. Also, its not something most arch will be able to provide
without sacrificing a PMU counter if they even have such a thing. Also not
everybody is as 'fast' in reading PMU state as one would like.

> 
>   the first one is for the scheduler to call when it sees a situation of "we
>   care deeply about performance now" coming, for example near overload, or
>   when a realtime (or otherwise high priority) task gets scheduled.  the
>   second one I am dubious about, but maybe you have a use for it; some folks
>   think that there is value in deciding to ramp up the performance rather
>   than load balancing. For load balancing to an idle cpu, I don't see that
>   value (in terms of power efficiency) but I do see a case where your 2 cores
>   happen to be busy (some sort of thundering herd effect) but imbalanced; in
>   that case going faster rather than rebalance... I can certainly see the
>   point.

(reformatted to 80 col text)

The entire scheme seems to disregards everybody who doesn't have a 'smart'
micro controller doing the P state management. Some people will have to
actually control the cpufreq.


> 3) an interface from the C state hardware driver to the scheduler to say "oh
> btw, the LLC got flushed, forget about past cache affinity". The C state
> driver can sometimes know this.. and linux today tries to keep affinity
> anyway while we could get more optimal by being allowed to balance more
> freely

This shouldn't be hard to implement at all.

> 4) this is the most important one, but like the hardest one: An interface
> from the scheduler that says "we are performance sensitive now": void
> arch_sched_performance_sensitive(int duration_ms);
> 
>    I've put a duration as argument, rather than a "arch_no_longer_sensitive",
>    to avoid for the scheduler to run some periodic timer/whatever to keep
>    this; rather it is sort of a "lease", that the scheduler can renew as
>    often as it wants; but it auto-expires eventually.
> 
>    with this the hardware and/or hardware drivers can make a performance bias
>    in their decisions based on what is actually the driving force behind both
>    P and C state decisions: performance sensitivity.  (all this utilization
>    stuff menu but also the P state drivers try to do is estimating how
>    sensitive we are to performance, and if we're not sensitive, consider
>    sacrificing some performance for power. Even with race-to-halt, sometimes
>    sacrificing a little performance gives a power benefit at the top of the
>    range)

Right, trouble is of course we have nothing to base this on. Our task model
completely lacks any clue for this. And the problem with introducing something
like that would also be that I suspect that within a few years every single
task on the system would find itself 'important'.

> >IIRC you at one point said there was a time limit below which concurrency
> >spread wasn't useful anymore?
> 
> there is a time below which waking up a core (not hyperthread pair, that is
> ALWAYS worth it since it's insanely cheap) is not worth it.  Think in the
> order of "+/- 50 microseconds".

OK.

> >Also, most what you say for single socket systems; what does Intel want for
> >multi-socket systems?
> 
> for multisocket, rule number one is "don't screw up numa".
> for tasks where numa matters, that's the top priority.

OK, so again, make sure to get the work done as quickly as possible and go idle
again.
