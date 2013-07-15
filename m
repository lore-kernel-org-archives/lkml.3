Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173Ab3GOVE3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 17:04:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49572 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846Ab3GOVE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 17:04:27 -0400
Date: Mon, 15 Jul 2013 23:03:17 +0200
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
Message-ID: <20130715210316.GE23818@dyad.programming.kicks-ass.net>
References: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com>
 <20130713064909.GW25631@dyad.programming.kicks-ass.net>
 <51E166C8.3000902@linux.intel.com>
 <20130715195914.GC23818@dyad.programming.kicks-ass.net>
 <51E45D98.7040404@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E45D98.7040404@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 01:37:44PM -0700, Arjan van de Ven wrote:
> On 7/15/2013 12:59 PM, Peter Zijlstra wrote:
> 
> >>this is where it gets complicated ;-( the race-to-idle depends on the type of
> >>code that is running, if things are memory bound it's outright not true, but
> >>for compute bound it often is.
> >
> >So you didn't actually answer the question about when you'd program a less than
> >max P state. Your recommended interface also glaringly lacks the
> >arch_please_go_slower_noaw() function.
> 
> an arch_you_may_go_slower_now() might make sense, sure.
> (I am not aware of anything DEMANDING to go slower, unlike the go faster side of things)
> I can see that be useful when you stop running that realtime task
> or similar conditions.

Well, if you ever want to go faster there must've been a moment to slow down.
Without means and reason to slow down the entire 'can I go fast noaw pls?'
thing simply doesn't make sense.

> >So you can program any P state; but the hardware is free do as it pleases but
> >not slower than the lowest P state. So clearly the hardware is 'smart'.
> 
> any device on the market has some level of smarts there, just by virtue of
> dual core and on board graphics. Even the ARM world has various smarts there
> (and will get more no doubt over time)
> 
> >Going by your interface there's also not much influence as to where the 'power'
> >goes; can we for example force the GPU to clock lower in order to 'free' up
> >power for cores?
> 
> I would love that to be the case. And the GPU driver certainly has some
> knobs/influence there. That being separate from CPU PM is one of the huge
> holes we have today (much more so than the whole scheduler-vs-power thing)

OK, so drag them gfx people into this. I suppose the 'big' issue is going to be
how to figure out what is more important than the other :-)

But just leaving them do their thing clearly isn't an option.

> >If we can, we should very much include that in the entire discussion.
> 
> absolute. Note that it's not an easy topic, as in... very much unsolved
> anywhere and everywhere, and not for lack of trying.

Right, well, I'm not aware of people trying, so it might be good to 'educate'
those of us who do not know on what didn't work and why.

> >>What I would like to see is
> >>
> >>1) Move the idle predictor logic into the scheduler, or at least a library
> >>    (I'm not sure the scheduler can do better than the current code, but it might,
> >>     and what menu does today is at least worth putting in some generic library)
> >
> >Right, so the idea is that these days we have much better task runtime
> >behaviour tracking than we used to have and this might help. I also realize the
> >idle guestimator uses more than just task activity, interrupt activity is also
> >very important.
> 
> when I wrote that part of the menu governor, it was ALL about interrupts.
> the task side is well known, at least in the short term, since we know
> that that will come via a timer.
> (I'm counting IPI's as interrupts here)
> 
> Now, the other half of this is the "how performance sensitive are we", and I sure
> hope the scheduler has a better idea than the menu governor....
> 
> 
> >Not sure calling it a generic library would be wise; that has such an optional
> >sound to it. The thing we want to avoid is people brewing their own etc..
> 
> well, if it works well, people will use it.
> if it sucks horribly, people won't and make something else...
> ... after which we turn that into the library function.
> If the concepts and interfaces are at the right level, that can be done.

I think we might be talking about the same thing here, but I'd rather there
ever only lives one instance of this logic in the entire kernel, and that when
people find it doesn't work for them they fix it for everybody, not hack their
own little world.

> Especially for things like "when do we expect the next event to pull us out of idle",
> that's a very generic concept that is not hardware dependent....

Clean concepts can help but are not required; the entire kernel is open source
and if you need something do a tree wide fix-up. That never stopped anybody.

> >>     int arch_can_you_go_faster(void);  /* if the scheduler would like to know this instead of load balancing .. unsure */
> >
> >You said Intel could not say if it were at the max P state; so how could it
> >possibly answer this one?
> 
> we do know if we asked for max... since it was us asking.

Sure, but you can't tell if programming a higher P state will actually make you
go faster. Which is what the function asks for, can we go faster, you don't
know. You could program a higher P state, but it might not actually go any
faster simply because you're already at your thermal limits.

> well, right now for various scheduler priorities we use "time" as a metric for
> timeslicing/etc without regard for the cpu performance at the time.
> There likely is room for a different measure for "system capacity used"
> that is a bit more finegrained than just time. Time is not bad,
> and if there's no cheap special HW, it'll do... but I can see value for
> doing something more advanced. Surely the big.little guys want this
> (more than I'd want it)

Ah, I see what you mean. I think this issue will get sorted when we 'fix' the
runtime vs cpufreq issue. Using actual instructions executed might be one
solution; another would be to simply scale the measured time by the frequency
at which we ran.

I suppose it depends on what's cheapest etc. on the specific platforms and/or
makes most sense.

> >The entire scheme seems to disregards everybody who doesn't have a 'smart'
> >micro controller doing the P state management. Some people will have to
> >actually control the cpufreq.
> 
> that is ok, but the whole point is to make that control part of the hardware
> specific driver side. The interface from the scheduler should be generic
> enough that you can plug in various hardware specific parts on the other side.
> Most certainly different CPU chips will use different algorithms over time.
> (and of course there will be a library of such algorithms so that not every
> cpu vendor/implementation has to reinvent the wheel from scratch).
> 
> heck, Linus waaay back insisted on this for cpufreq, since the Transmeta
> cpus at the time did most of this purely in "hardware".

Hmm,. okay, but I feel I'm still missing something. Notably the entire
go-faster thing. That simply cannot live without a matching go-slower side.


> 
> 
> >>3) an interface from the C state hardware driver to the scheduler to say "oh
> >>btw, the LLC got flushed, forget about past cache affinity". The C state
> >>driver can sometimes know this.. and linux today tries to keep affinity
> >>anyway while we could get more optimal by being allowed to balance more
> >>freely
> >
> >This shouldn't be hard to implement at all.
> 
> great!
> Do you think it's worth having on the scheduler side? E.g. does it give you
> more freedom in placement?
> It's not completely free to get (think "an MSR read") and
> there's the interesting question if this would be a per cpu
> or a global statement... but we can get this
> 
> And at least for client systems (read: relatively low core counts) the cache
> will get flushed quite a lot on Intel.
> (and then refilled quickly of course)

Now idea, give it a go -- completely untested and such ;-)

----
 kernel/sched/fair.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index f77f9c5..ef83361 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3895,6 +3895,20 @@ static void move_task(struct task_struct *p, struct lb_env *env)
 	check_preempt_curr(env->dst_rq, p, 0);
 }
 
+DEFINE_PER_CPU(u64, llc_wipe_stamp);
+
+void arch_sched_wipe_llc(int cpu)
+{
+	struct sched_domain *sd;
+	u64 now = sched_clock_cpu(cpu);
+
+	rcu_read_lock();
+	sd = rcu_dereference(per_cpu(sd_llc, cpu));
+	if (sd) for_each_cpu(cpu, sched_domain_span(sd))
+		per_cpu(llc_wipe_stamp, cpu) = now;
+	rcu_read_unlock();
+}
+
 /*
  * Is this task likely cache-hot:
  */
@@ -3910,6 +3925,12 @@ task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
 		return 0;
 
 	/*
+	 * Can't be hot if the LLC got wiped since we ran last.
+	 */
+	if (p->se.exec_start < this_cpu_read(llc_wipe_stamp))
+		return 0;
+
+	/*
 	 * Buddy candidates are cache hot:
 	 */
 	if (sched_feat(CACHE_HOT_BUDDY) && this_rq()->nr_running &&
