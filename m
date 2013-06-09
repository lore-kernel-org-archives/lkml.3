Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452Ab3FIWxA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 18:53:00 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:33445 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751997Ab3FIWw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 18:52:58 -0400
Date: Sun, 9 Jun 2013 23:53:06 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Ingo Molnar <mingo@kernel.org>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "alex.shi@intel.com" <alex.shi@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Mike Galbraith <efault@gmx.de>, "pjt@google.com" <pjt@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: power-efficient scheduling design
Message-ID: <20130609225306.GA8695@MacBook-Pro.local>
References: <20130530134718.GB32728@e103034-lin>
 <51B221AF.9070906@linux.vnet.ibm.com>
 <20130608112801.GA8120@MacBook-Pro.local>
 <1834293.MlyIaiESPL@vostro.rjw.lan>
 <51B3F99A.4000101@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51B3F99A.4000101@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Preeti,

(trimming lots of text, hopefully to make it easier to follow)

On Sun, Jun 09, 2013 at 04:42:18AM +0100, Preeti U Murthy wrote:
> On 06/08/2013 07:32 PM, Rafael J. Wysocki wrote:
> > On Saturday, June 08, 2013 12:28:04 PM Catalin Marinas wrote:
> >> On Fri, Jun 07, 2013 at 07:08:47PM +0100, Preeti U Murthy wrote:
> >>> Meanwhile the scheduler should ensure that the tasks are retained on
> >>> that CPU,whose frequency is boosted and should not load balance it, so
> >>> that they can get over quickly. This I think is what is missing. Again
> >>> this comes down to the scheduler taking feedback from the CPU frequency
> >>> governors which is not currently happening.
> >>
> >> Same loop again. The cpu load goes high because (a) there is more work,
> >> possibly triggered by external events, and (b) the scheduler decided to
> >> balance the CPUs in a certain way. As for cpuidle above, the scheduler
> >> has direct influence on the cpufreq decisions. How would the scheduler
> >> know which CPU not to balance against? Are CPUs in a cluster
> >> synchronous? Is it better do let other CPU idle or more efficient to run
> >> this cluster at half-speed?
> >>
> >> Let's say there is an increase in the load, does the scheduler wait
> >> until cpufreq figures this out or tries to take the other CPUs out of
> >> idle? Who's making this decision? That's currently a potentially
> >> unstable loop.
> >
> > Yes, it is and I don't think we currently have good answers here.
> 
> My answer to the above question is scheduler does not wait until cpufreq
> figures it out. All that the scheduler cares about today is load
> balancing. Spread the load and hope it finishes soon. There is a
> possibility today that even before cpu frequency governor can boost the
> frequency of cpu, the scheduler can spread the load.
> 
> As for the second question it will wakeup idle cpus if it must to load
> balance.

That's exactly my point. Such behaviour can become unstable (it probably
won't oscillate but it affects the power or performance).

> It is a good question asked: "does the scheduler wait until cpufreq
> figures it out." Currently the answer is no, it does not communicate
> with cpu frequency at all (except through cpu power, but that is the
> good part of the story, so I will not get there now). But maybe we
> should change this. I think we can do so the following way.
> 
> When can a scheduler talk to cpu frequency? It can do so under the below
> circumstances:
> 
> 1. Load is too high across the systems, all cpus are loaded, no chance
> of load balancing. Therefore ask cpu frequency governor to step up
> frequency to get improve performance.

Too high or too low loads across the whole system are relatively simple
scenarios: for the former boost the frequency (cpufreq can do this on
its own, the scheduler has nowhere to balance anyway), for the latter
pack small tasks (or other heuristics).

But the bigger issue is where some CPUs are idle while others are
running at a smaller frequency. With the current implementation it is
even hard to get into this asymmetric state (some cluster loaded while
the other in deep sleep) unless the load is low and you apply some small
task packing patch.

> 2. The scheduler finds out that if it has to load balance, it has to do
> so on cpus which are in deep idle state( Currently this logic is not
> present, but worth getting it in). It then decides to increase the
> frequency of the already loaded cpus to improve performance. It calls
> cpu freq governor.

So you say that the scheduler decides to increase the frequency of the
already loaded cpus to improve performance. Doesn't this mean that the
scheduler takes on some of the responsibilities of cpufreq? You now add
logic about boosting CPU frequency to the scheduler.

What's even more problematic is that cpufreq has policies decided by the
user (or pre-configured OS policies) but the scheduler is not aware of
them. Let's say the user wants a more conservative cpufreq policy, how
long should the scheduler wait for cpufreq to boost the frequency before
waking idle CPUs?

There are many questions like above. I'm not looking for specific
answers but rather trying get a higher level clear view of the
responsibilities of the three main factors contributing to
power/performance: load balancing (scheduler), cpufreq and cpuidle.

> 3. The scheduler finds out that if it has to load balance, it has to do
> so on a different power domain which is idle currently(shallow/deep). It
> thinks the better of it and calls cpu frequency governor to boost the
> frequency of the cpus in the current domain.

As for 2, the scheduler would make power decisions. Then why don't make
a unified implementation? Or remove such decisions from the scheduler.

> > The results of many measurements seem to indicate that it generally is better
> > to do the work as quickly as possible and then go idle again, but there are
> > costs associated with going back and forth from idle to non-idle etc.
> 
> I think we can even out the cost benefit of race to idle, by choosing to
> do it wisely. Like for example if points 2 and 3 above are true (idle
> cpus are in deep sleep states or need to ld balance on a different power
> domain), then step up the frequency of the current working cpus and reap
> its benefit.

And such decision would be made by ...? I guess the scheduler again.

> > And what about performance scaling?  Quite frankly, in my opinion that
> > requires some more investigation, because there still are some open questions
> > in that area.  To start with we can just continue using the current heuristics,
> > but perhaps with the scheduler calling the scaling "governor" when it sees fit
> > instead of that "governor" running kind of in parallel with it.
> 
> Exactly. How this can be done is elaborated above. This is one of the
> key things we need today,IMHO.

The scheduler asking the cpufreq governor of what it needs is a too
simplistic view IMHO. What if the governor is conservative? How much
does the scheduler wait until the feedback loop reacts (CPU frequency
raised increasing the idle time so that the scheduler eventually
measures a smaller load)?

The scheduler could get more direct feedback from cpufreq like "I'll get
to this frequency in x ms" or not at all but then the scheduler needs to
make another power-related decision on whether to wait (be conservative)
or wake up an idle CPU. Do you want to add various power policies at the
scheduler level just to match the cpufreq ones?

> >> That's why I suggested maybe starting to take the load balancing out of
> >> fair.c and make it easily extensible (my opinion, the scheduler guys may
> >> disagree). Then make it more aware of topology, power configuration so
> >> that it makes the right task placement decision. You then get it to
> >> tell cpufreq about the expected performance requirements (frequency
> >> decided by cpufreq) and cpuidle about how long it could be idle for (you
> >> detect a periodic task every 1ms, or you don't have any at all because
> >> they were migrated, the right C state being decided by the governor).
> >
> > There is another angle to look at that as I said somewhere above.
> >
> > What if we could integrate cpuidle with cpufreq so that there is one code
> > layer representing what the hardware can do to the scheduler?  What benefits
> > can we get from that, if any?
> 
> We could debate on this point. I am a bit confused about this. As I see
> it, there is no problem with keeping them separately. One, because of
> code readability; it is easy to understand what are the different
> parameters that the performance of CPU depends on, without needing to
> dig through the code. Two, because cpu frequency kicks in during runtime
> primarily and cpuidle during idle time of the cpu.
> 
> But this would also mean creating well defined interfaces between them.
> Integrating cpufreq and cpuidle seems like a better argument to make due
> to their common functionality at a higher level of talking to hardware
> and tuning the performance parameters of cpu. But I disagree that
> scheduler should be put into this common framework as well as it has
> functionalities which are totally disjoint from what subsystems such as
> cpuidle and cpufreq are intended to do.

It's not about the whole scheduler but rather the load balancing, task
placement. You can try to create well defined interfaces between them
but first of all let's define clearly what responsibilities each of the
three frameworks have.

As I said in my first email on this subject, we could:

a) let the scheduler focus on performance only but control (restrict)
   the load balancing from cpufreq. For example via cpu_power, a value
   of 0 meaning don't balance against it. Cpufreq changes the frequency
   based on the load and may allow the scheduler to use idle CPUs. Such
   approach requires closer collaboration between cpufreq and cpuidle
   (possibly even merging them) and cpufreq needs to become even more
   aware of CPU topology.

or:

b) Merge the load balancer and cpufreq together (could leave cpuidle
   out initially) with a new design.

Any other proposals are welcome. So far they were either tweaks in
various places (small task packing) or are relatively vague (like we
need two-way communication between cpuidle and scheduler).

Best regards.

-- 
Catalin
