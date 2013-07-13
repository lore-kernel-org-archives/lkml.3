Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933348Ab3GMOkM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 10:40:12 -0400
Received: from mga03.intel.com ([143.182.124.21]:19509 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933198Ab3GMOkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 10:40:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,659,1367996400"; 
   d="scan'208";a="364748869"
Message-ID: <51E166C8.3000902@linux.intel.com>
Date: Sat, 13 Jul 2013 07:40:08 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Morten Rasmussen <morten.rasmussen@arm.com>, mingo@kernel.org,
        vincent.guittot@linaro.org, preeti@linux.vnet.ibm.com,
        alex.shi@intel.com, efault@gmx.de, pjt@google.com, len.brown@intel.com,
        corbet@lwn.net, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [RFC][PATCH 0/9] sched: Power scheduler design proposal
References: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com> <20130713064909.GW25631@dyad.programming.kicks-ass.net>
In-Reply-To: <20130713064909.GW25631@dyad.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/12/2013 11:49 PM, Peter Zijlstra wrote:
>
> Arjan; from reading your emails you're mostly busy explaining what cannot be
> done. Please explain what _can_ be done and what Intel wants. From what I can
> see you basically promote a max P state max concurrency race to idle FTW.

>
> Since you can't say what the max P state is; and I think I understand the
> reasons for that, and the hardware might not even respect the P state you tell
> it to run at, does it even make sense to talk about Intel P states? When would
> you not program the max P state?

this is where it gets complicated ;-(
the race-to-idle depends on the type of code that is running, if things are memory bound it's outright
not true, but for compute bound it often is.

What I would like to see is

1) Move the idle predictor logic into the scheduler, or at least a library
    (I'm not sure the scheduler can do better than the current code, but it might,
     and what menu does today is at least worth putting in some generic library)

2) An interface between scheduler and P state code in the form of (and don't take the names as actual function names ;-)
     void arch_please_go_fastest(void);   /* or maybe int cpunr as argument, but that's harder to implement */
     int arch_can_you_go_faster(void);  /* if the scheduler would like to know this instead of load balancing .. unsure */
     unsigned long arch_instructions_executed(void); /* like tsc, but on instructions, so the scheduler can account actual work done */

   the first one is for the scheduler to call when it sees a situation of "we care deeply about performance now" coming,
   for example near overload, or when a realtime (or otherwise high priority) task gets scheduled.
   the second one I am dubious about, but maybe you have a use for it; some folks think that there is value in
   deciding to ramp up the performance rather than load balancing. For load balancing to an idle cpu, I don't see that
   value (in terms of power efficiency) but I do see a case where your 2 cores happen to be busy (some sort of thundering
   herd effect) but imbalanced; in that case going faster rather than rebalance... I can certainly see the point.

3) an interface from the C state hardware driver to the scheduler to say "oh btw, the LLC got flushed, forget about past
    cache affinity". The C state driver can sometimes know this.. and linux today tries to keep affinity anyway
    while we could get more optimal by being allowed to balance more freely

4) this is the most important one, but like the hardest one:
    An interface from the scheduler that says "we are performance sensitive now":
    void arch_sched_performance_sensitive(int duration_ms);

    I've put a duration as argument, rather than a "arch_no_longer_sensitive", to avoid for the scheduler to run some
    periodic timer/whatever to keep this; rather it is sort of a "lease", that the scheduler can renew as often as it
    wants; but it auto-expires eventually.

    with this the hardware and/or hardware drivers can make a performance bias in their decisions based on what
    is actually the driving force behind both P and C state decisions: performance sensitivity.
    (all this utilization stuff menu but also the P state drivers try to do is estimating how sensitive we are to
    performance, and if we're not sensitive, consider sacrificing some performance for power. Even with race-to-halt,
    sometimes sacrificing a little performance gives a power benefit at the top of the range)

>
> IIRC you at one point said there was a time limit below which concurrency
> spread wasn't useful anymore?

there is a time below which waking up a core (not hyperthread pair, that is ALWAYS worth it since it's insanely cheap)
is not worth it.
Think in the order of "+/- 50 microseconds".


> Also, most what you say for single socket systems; what does Intel want for
> multi-socket systems?

for multisocket, rule number one is "don't screw up numa".
for tasks where numa matters, that's the top priority.
beyond that, experiments seem to show that grouping "a little" helps.
Say on a 2x 4 core system, it's worth running the first 2 tasks on the same package
but after that we need to start considering the 2nd package.
I have to say that we don't have quite enough data yet to figure out where this cutoff is;
most of the microbenchmarks in this have been done with fspin, which by design has zero cache
footprint or memory use... and the whole damage side of grouping (and thus the reason for spreading)
is in sharing of the caches and memory bandwidth.
(if you end up thrashing the cache, the power you burn by losing the efficiency there is not easy to win back
by placement)



