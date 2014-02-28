Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765AbaB1JnT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 04:43:19 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:34288 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbaB1JnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 04:43:14 -0500
Date: Fri, 28 Feb 2014 10:40:35 +0100
From: Henrik Austad <henrik@austad.us>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Henrik Austad <haustad@cisco.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        John Stultz <john.stultz@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/6 v2] Expose do_timer CPU as RW to userspace
Message-ID: <20140228094035.GA6113@austad.us>
References: <1393331641-14016-1-git-send-email-henrik@austad.us>
 <20140225141906.GA22814@localhost.localdomain>
 <20140226081602.GA16591@austad.us>
 <20140226130234.GA3104@localhost.localdomain>
 <20140227083735.GA5129@austad.us>
 <20140227135618.GB17608@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140227135618.GB17608@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 02:56:20PM +0100, Frederic Weisbecker wrote:
> On Thu, Feb 27, 2014 at 09:37:35AM +0100, Henrik Austad wrote:
> > On Wed, Feb 26, 2014 at 02:02:42PM +0100, Frederic Weisbecker wrote:
> > > 
> > > -1 could be an option but hmm...
> > 
> > I don't really like -1, that indicates that it is disabled and could 
> > confuse people, letting them think that timekeeping is disabled at all 
> > cores.
> > 
> > > Wouldn't it be saner to use a cpumask of the timer affinity instead? 
> > > This is the traditional way we affine something in /proc or /sys
> > 
> > Yes, that's what I'm starting to think as well, that would make a lot 
> > more sense when the timer is bounced around.
> > 
> > something like a 'current_cpu_mask' which would return a hex-mask of 
> > the cores where the timekeeping update _could_ run.
> 
> Right, or timekeeper_cpumask.

Right, paying some attention to a proper, descriptive name is probably a 
good thing.

Also, for future reference, a consistent name for "the core running the 
timeeping update" would be nice. Ref suggestion above, 'timekeeper' seems 
to be a valid name for the core currently assigned the duty.

All in favour?

> > For periodic, that would be a single core (normally boot), and when 
> > forced, it would return a cpu-mask with only one cpu set. Then the 
> > result would be a lot more informative for NO_HZ_(IDLE|FULL) as well.
> 
> I'd rather suggest that for periodic and NO_HZ_IDLE, this should be equal 
> to cpu_online_mask by default. Because the timekeeping duty can be taken 
> by any CPU.

So basically, we're looking at a few more values here then

# the current (un)restricted mask where timekeeper can run this would be 
# the writable mask

     timekeeper_cpumask

# the mask for which you can assign cores to timekeeper_cpumask For 
# NO_HZ_FULL, I guess this would be all cores except those in 
# nohz_full-mask.
# read-only

     timekeeper_cpumask_possible

# makes sense only in periodic system where it does not bounce around like 
# crazy.
# read-only

     timekeeper_current_cpu

Then force_cpu should accept a mask, or a range, of CPUs on which 
timekeeper should be allowed.

     timekeeper_cpumask_forced

Makes sense?

> Then on subsequent writes on this cpumask, this reflects the reduced 
> subset of CPUs that we allow to take the duty.
> 
> In your usecase you're interested in a single CPU to take that duty but 
> the cpumask allows more flexibility.

I agree.

> Now NO_HZ_FULL is a bit different. For now only CPU 0 can take the duty. 
> This will extend later to every CPUs outside the range of full dynticks.
> 
> > 
> > Worth a shot? (completely disjoint from the write-discussion below)
> 
> I can't judge alone if we really want this patchset. We need the input of 
> timer maintainers for that.

Sure!

> Assuming we want it then yeah, the cpumask affinity in sysfs/procfs looks 
> like a sane approach to me. In term we should also plug it to rcu full 
> system idle detection: https://lwn.net/Articles/558284/ so that we can 
> shutdown the reduced set of timekeepers when there is no other CPU 
> running. I have some patches for it that I can plug afterward. So no 
> worry for you on that side.

Ok, I'm not going to start to worry about that just yet then, but it does 
sound very interesting! :)

> > > > > Now looking at the write part. What kind of usecase do you have 
> > > > > in mind?
> > > > 
> > > > Forcing the timer to run on single core only, and a core of my 
> > > > choosing at that.
> > > > 
> > > > - Get timekeeping away from cores with bad interrupts (no, I cannot 
> > > > move
> > > >   them). - Avoid running timekeeping udpates on worker-cores.
> > > 
> > > Ok but what you're moving away is not the tick but the timekeeping 
> > > duty, which is only a part of the tick. A significant part but still 
> > > just a part.
> > 
> > That is certainly true, but that part happens to be of global 
> > influence, so if I have a core where a driver disables interrupts a lot 
> > (or drops into a hypervisor, or any other silly thing it really 
> > shouldn't be doing), then I would like to be able to move the 
> > timekeeping updates away from that core.
> 
> I don't understand how these things are linked together. If your driver 
> disables interrupt and you don't want to be disturbed, moving the 
> timekeeping duty doesn't move the tick itself.

True, but it reduces some amount of jitter from the tick itself. It's more 
like damagecontrol than damage-prevention.

> What happens to be disturbing for you in the timekeeping update that is 
> not with the tick as a whole? Is the delta of cputime added by jiffies 
> and gtod update alone a problem?

I had some examples where timekeeper would grab timekeeper.lock and hold it 
for a very long time. The reason was not very easy to pinpoint, so one of 
the things I wanted to try, was to move the timekeeper around and see what 
happened (yeah, debugging at it's best!)

> This sounds surprising but possible. Still I want to be sure that's the 
> exact problem you're encoutering.
> 
> > 
> > The same goes for cores running rt-tasks (>1), I really do not want 
> > -any- interference at all, and if I can remove the extra jitter from 
> > the timekeeping, I'm pretty happy to do so.
> 
> Then again if you don't want interference at all, NO_HZ_FULL sounds like 
> a better solution. NO_HZ_FULL implies that the timekeeping is handled by 
> CPUs in the nohz_full boot paramater range. If NO_HZ_FULL_ALL then it's 
> CPU 0.

Aha, thanks for clearing that up!

> > > Does this all make sense outside the NO_HZ_FULL case?
> > 
> > In my view, it makes sense in the periodic case as well since all 
> > timekeeping updates then happens on the boot-cpu (unless it is 
> > hotunplugged that is).
> 
> But if we get back to your requirements, you want no interference at all. 
> HZ_PERIODIC doesn't look like what you want.

True, but I also needed a mechanism for moving the timekeeper away from a 
problematic core.

Another benefit from periodic, is that it supports skewed timers and that 
the overhead is lower than NO_HZ when you do have timer-interrupts.

> > > > > It's also important to consider that, in the case of NO_HZ_IDLE, 
> > > > > if you force the timekeeping duty to a specific CPU, it won't be 
> > > > > able to enter in dynticks idle mode as long as any other CPU is 
> > > > > running.
> > > > 
> > > > Yes, it will in effect be a TICK_PERIODIC core where I can 
> > > > configure which core the timekeeping update will happen.
> > > 
> > > Ok, I missed that part. So when the timekeeping is affine to a 
> > > specific CPU, this CPU is prevented to enter into dynticks idle mode?
> > 
> > That's what I aimed at, and I *think* I managed that. I added a 
> > forced_timer_can_stop_tick() and let can_stop_full_tick() and 
> > can_stop_idle_tick() call that. I think that is sufficient, at least I 
> > did not see that the timerduty was transferred to another core 
> > afterwards.
> 
> Ok, I need to look at the details.

Ahem, no, my understanding of the NOHZ-cpumask was flawed. I'm reworking 
this based on feedback as well as the discussion below.

> > > > > Because those CPUs can make use of jiffies or gettimeofday() and 
> > > > > must have uptodate values. This involve quite some complication 
> > > > > like using the full system idle detection 
> > > > > (CONFIG_NO_HZ_FULL_SYSIDLE) to avoid races between timekeeper 
> > > > > entering dynticks idle mode and other CPUs waking up from idle. 
> > > > > But the worst here is the powesaving issues resulting from the 
> > > > > timekeeper who can't sleep.
> > > > 
> > > > Personally, when I force the timer to be bound to a specific CPU, 
> > > > I'm pretty happy with the fact that it won't be allowed to turn 
> > > > ticks off. At that stage, powersave is the least of my concerns, 
> > > > throughput and/or jitter is.
> > > > 
> > > > I know that what I'm doing is in effect turning the kernel into a 
> > > > somewhat more configurable TICK_PERIODIC kernel (in the sense that 
> > > > I can set the timer to run on something other than the boot-cpu).
> > > 
> > > I see.
> > > 
> > > > 
> > > > > These issues are being dealt with in NO_HZ_FULL because we want 
> > > > > the timekeeping duty to be affine to the CPUs that are no full 
> > > > > dynticks. But in the case of NO_HZ_IDLE, I fear it's not going to 
> > > > > be desirable.
> > > > 
> > > > Hum? I didn't get that one, what do you mean?
> > > 
> > > So in NO_HZ_FULL we do something that is very close to what're doing: 
> > > the timekeeping is affine to the boot CPU and it stays periodic 
> > > whatever happens.
> > > 
> > > But we start to worry about powersaving. When the whole system is 
> > > idle, there is no point is preventing the CPU 0 to sleep. So we are 
> > > dealing with that by using a full system idle detection that lets CPU 
> > > 0 go to sleep when there is strictly nothing to do. Then when nohz 
> > > full CPU wakes up from idle, CPU 0 is woken up as well to get back to 
> > > its timekeeping duty.
> > 
> > Hmm, I had the impreesion that when a CPU with timekeeping-duty was 
> > sent to sleep, it would set tick_do_timer_cpu to TICK_DO_TIMER_NONE, 
> > and whenever another core would run do_timer() it would see if 
> > tick_do_timer_cpu was set to TICK_DO_TIMER_NONE and if so, grab it and 
> > run with it.
> 
> Yep that's true for periodic and dynticks idle. Not for full dynticks.
>
> > 
> > I really don't see how this wakes up CPU0 (but then again, there's 
> > probably several layers of logic here that I'm missing :)
> 
> By way of an IPI.
> 
> Scenario is: CPU 0 handles timekeeping and CPU 1 is full dynticks. Both 
> are running then CPU 1 goes to sleep. CPU 0 notices that CPU 1 went to 
> sleep and thus nobody else needs the timekeeping to be uptodate. If CPU 0 
> is idle as well it can go to sleep. So does it. Then later if CPU 1 wakes 
> up to do something, it sends an IPI to CPU 0 such that CPU 0 wakes up, 
> notices that CPU 1 is alive and run the timekeeping update on its behalf.
> 
> It's not yet upstream but that's the plan :)

So all dynticks-kernel will send an IPI to CPU0 upon wakeup to notify  
that they're no longer sleeping?

Sounds like having a (effective) way to detect that the entire system is 
idle in an effective manner would be really nice in this scenario! That 
way, if CPU1 could determine that the system was not idle, it would not 
have to send an IPI to CPU0 to wake it up.

-- 
Henrik
