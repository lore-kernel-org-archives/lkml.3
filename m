Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534AbaAPLQl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 06:16:41 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:48936 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752471AbaAPLQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 06:16:37 -0500
Date: Thu, 16 Jan 2014 11:16:34 +0000
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "mingo@kernel.org" <mingo@kernel.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "markgross@thegnar.org" <markgross@thegnar.org>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [5/11] issue 5: Frequency and uarch invariant task load
Message-ID: <20140116111634.GA19029@e103034-lin>
References: <1389111587-5923-1-git-send-email-morten.rasmussen@arm.com>
 <1389111587-5923-6-git-send-email-morten.rasmussen@arm.com>
 <20140108123118.GS30183@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140108123118.GS30183@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 12:31:18PM +0000, Peter Zijlstra wrote:
> On Tue, Jan 07, 2014 at 04:19:41PM +0000, Morten Rasmussen wrote:
> > Potential solution: Frequency invariance has been proposed before [1]
> > where the task load is scaled by the cur/max freq ratio. Another
> > possibility is to use hardware counters if such are available on the
> > platform.
> > 
> > [1] https://lkml.org/lkml/2013/4/16/289
> 
> Right, I just had a look at those patches.. they're not horrible but I
> think they're missing a few opportunities.
> 
> My main objection to them is that I think the newly introduced
> max_capacity is exactly what the current cpu_power thing is -- then
> again, I still haven't let the entire thing sink in well enough.

Yes, you can view it that way. The basic idea is to introduce a
potential compute capacity (max_capacity) and a current compute capacity
(curr_capacity). By scaling the load_contrib of a task by the
current/potential capacity ratio you get a frequency invariant task
load. The invariant task load enables more sensible comparison of load
between task loads of tasks running on different cpus in different
frequency domains.

I would have said that max_capacity is equivalent to cpu_power if wasn't
used for so many other things as you point out below.

> 
> Not to mention we need to fix some of the cpu_power abuse -- like the
> correlation to capacity, which as stated in previous emails should be
> sorted using utilization.

Agreed.

> 
> So DVFS certainly makes sense, and would indeed be required in order to
> make sensible decisions in the face of P states. Even in the face of
> funny hardware like Intel which pretty much ignores whatever you tell it
> and does it own merry thing.
> 
> 
> A few random thoughts:
> 
>  - I think for SMP-nice we want to migrate from /max_capacity to
>    /curr_capacity; because SMP-nice cares about 100% utilization
>    regardless of the actual P state. If we're somehow forced into a
>    lower P state (thermal or otherwise) fairness is best served by
>    normalizing at the rate we're actually running at, not the potential
>    maximal.

I see your point, but normalizing to /curr_capacity would break ability
to compare tasks from different runqueues. When we pull tasks during
load-balance we have no idea what the load of the pulled tasks will be
on the new cpu. The source and target cpus may be at different P-states.

It would probably be better to adjust the max_capacity if we are forced
into a lower P-state for some reason.

> 
>  - We need to re-think SMT and turbo-bins in general; I think we can
>    think of those two as the same effective thing. This does mean Intel
>    chips will have a dual layer of this goo, and we can currently barely
>    deal with the 1 SMT layer, let alone do something sensible with 2.
> 
>    To clarify, a single SMT thread will generally go 'faster' on its own
>    since it doesn't need to compete with the other thread(s) for core
>    resources, but together they might better utilize the core resources
>    giving an over-all throughput win.
> 
>    Similar for turbo bins, a single core can go faster on its own since
>    it doesn't have competition for energy and thermal constraints, but
>    together cores can probably achieve greater throughput.
> 
>    So we need a better way to describe this capacity dependency and
>    variability.

Agreed. It is my impression that SMT works fairly well using cpu_power,
but I don't see how we can further abuse cpu_power to optimize for turbo
boost.

We might as well add heterogeneous systems (big.LITTLE) to the list of
things that need better capacity management. Scheduling for performance
on big.LITTLE you want to utilze the big cpus first and then use the
little cpus. As pointed out in issue 6, cpu_power in its current form
can not do this.

> 
>    I'm fairly sure ARM doesn't do SMT, but they certainly suffer from
>    thermal caps and can thus have effective turbo bins, even though
>    they're not explicit and magic like with Intel.

Thermal management is indeed important. It is up to the SoC implementor
how they deal with it, but I think most ARM systems expose all P-states,
including those that may only be used for shorter periods of time in
small form factor devices.

> 
>    And of course the honorary mention goes to Power7 which has
>    asymmetric bins -- lets hope they fix it and nobody else things them
>    a great idea.
> 
>  - For hardware without P state controls, or hardware that pretty much
>    ignores them, we need means of obtaining the max and curr capacity.
> 
>    Intel has the APERF, MPERF registers which resp. count at actual
>    frequency and fixed frequency. Using them is a bit tricky since
>    APERF doesn't count when idle, but when filtering out the idle time
>    they do provide a current performance ratio.
> 
>    From that we could obtain a max performance ratio by using a wide
>    window max on the current value or somesuch.
> 
>    Again, SMT and turbo-bins will complicate matters..

+ heterogeneous systems (big.LITTLE)...

> 
>    Other CPUs that have magic P state control might not provide such
>    registers which would require PMU resources, which would completely
>    blow :/

For systems with multiple performance counters that are cheap to access
it may be worth it to dedicate a counter or two for use by the scheduler
if it can give significant improvements. But that has yet to be shown.
