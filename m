Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345AbaB0IkO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 03:40:14 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:43383 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbaB0IkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 03:40:12 -0500
Date: Thu, 27 Feb 2014 09:37:35 +0100
From: Henrik Austad <henrik@austad.us>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Henrik Austad <haustad@cisco.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        John Stultz <john.stultz@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/6 v2] Expose do_timer CPU as RW to userspace
Message-ID: <20140227083735.GA5129@austad.us>
References: <1393331641-14016-1-git-send-email-henrik@austad.us>
 <20140225141906.GA22814@localhost.localdomain>
 <20140226081602.GA16591@austad.us>
 <20140226130234.GA3104@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140226130234.GA3104@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 02:02:42PM +0100, Frederic Weisbecker wrote:
> On Wed, Feb 26, 2014 at 09:16:03AM +0100, Henrik Austad wrote:
> > On Tue, Feb 25, 2014 at 03:19:09PM +0100, Frederic Weisbecker wrote:
> > > On Tue, Feb 25, 2014 at 01:33:55PM +0100, Henrik Austad wrote:
> > > > From: Henrik Austad <haustad@cisco.com>
> > > > 
> > > > Hi!
> > > > 
> > > > This is a rework of the preiovus patch based on the feedback gathered
> > > > from the last round. I've split it up a bit, mostly to make it easier to
> > > > single out the parts that require more attention (#4 comes to mind).
> > > > 
> > > > Being able to read (and possible force a specific CPU to handle all
> > > > do_timer() updates) can be very handy when debugging a system and tuning
> > > > for performance. It is not always easy to route interrupts to a specific
> > > > core (or away from one, for that matter).
> > > 
> > > It's a bit vague as a reason for the patchset. Do we really need it?
> > 
> > One case is to move the timekeeping away from cores I know have 
> > interrupt-issues (in an embedded setup, it is not always easy to move 
> > interrupts away).
> > 
> > Another is to remove jitter from cores doing either real-time work or heavy 
> > workerthreads. The timekeeping update is pretty fast, but I do not see any 
> > reason for letting timekeeping interfere with my workers if it does not 
> > have to.
> 
> Ok. I'll get back to that below.
>  
> > > Concerning the read-only part, if I want to know which CPU is handling the
> > > timekeeping, I'd rather use tracing than a sysfs file. I can correlate
> > > timekeeping update traces with other events. Especially as the timekeeping duty
> > > can change hands and move to any CPU all the time. We really don't want to
> > > poll on a sysfs file to get that information. It's not adapted and doesn't
> > > carry any timestamp. It may be useful only if the timekeeping CPU is static.
> > 
> > I agree that not having a timestamp will make it useless wrt to tracing, 
> > but that was never the intention. By having a sysfs/sysctl value you can 
> > quickly determine if the timekeeping is bound to a single core or if it is 
> > handled everywhere.
> > 
> > Tracing will give you the most accurate result, but that's not always what 
> > you want as tracing also provides an overhead (both in the kernel as well 
> > as in the head of the user) using the sysfs/sysctl interface for grabbing 
> > the CPU does not.
> > 
> > You can also use it to verify that the forced-cpu you just sat, did in fact 
> > have the desired effect.
> > 
> > Another approach I was contemplating, was to let current_cpu return the 
> > current mask CPUs where the timer is running, once you set it via 
> > forced_cpu, it will narrow down to that particular core. Would that be more 
> > useful for the RO approach outisde TICK_PERIODIC?
> 
> Ok so this is about checking which CPU the timekeeping is bound to.
> But what do you diplay in the normal case (ie: when timekeeping is globally affine?)
> 
> -1 could be an option but hmm...

I don't really like -1, that indicates that it is disabled and could 
confuse people, letting them think that timekeeping is disabled at all 
cores.

> Wouldn't it be saner to use a cpumask of the timer affinity instead? This
> is the traditional way we affine something in /proc or /sys

Yes, that's what I'm starting to think as well, that would make a lot more 
sense when the timer is bounced around.

something like a 'current_cpu_mask' which would return a hex-mask 
of the cores where the timekeeping update _could_ run.

For periodic, that would be a single core (normally boot), and when forced, 
it would return a cpu-mask with only one cpu set. Then the result would be 
a lot more informative for NO_HZ_(IDLE|FULL) as well.

Worth a shot? (completely disjoint from the write-discussion below)

> > > Now looking at the write part. What kind of usecase do you have in mind?
> > 
> > Forcing the timer to run on single core only, and a core of my choosing at 
> > that.
> > 
> > - Get timekeeping away from cores with bad interrupts (no, I cannot move 
> >   them).
> > - Avoid running timekeeping udpates on worker-cores.
> 
> Ok but what you're moving away is not the tick but the timekeeping duty, which
> is only a part of the tick. A significant part but still just a part.

That is certainly true, but that part happens to be of global influence, so 
if I have a core where a driver disables interrupts a lot (or drops into a 
hypervisor, or any other silly thing it really shouldn't be doing), then I 
would like to be able to move the timekeeping updates away from that core. 

The same goes for cores running rt-tasks (>1), I really do not want -any- 
interference at all, and if I can remove the extra jitter from the 
timekeeping, I'm pretty happy to do so.

> Does this all make sense outside the NO_HZ_FULL case?

In my view, it makes sense in the periodic case as well since all 
timekeeping updates then happens on the boot-cpu (unless it is hotunplugged 
that is).

> > 
> > > It's also important to consider that, in the case of NO_HZ_IDLE, if you force
> > > the timekeeping duty to a specific CPU, it won't be able to enter in dynticks
> > > idle mode as long as any other CPU is running. 
> > 
> > Yes, it will in effect be a TICK_PERIODIC core where I can configure which 
> > core the timekeeping update will happen.
> 
> Ok, I missed that part. So when the timekeeping is affine to a specific CPU,
> this CPU is prevented to enter into dynticks idle mode?

That's what I aimed at, and I *think* I managed that. I added a 
forced_timer_can_stop_tick() and let can_stop_full_tick() and 
can_stop_idle_tick() call that. I think that is sufficient, at least I did 
not see that the timerduty was transferred to another core afterwards.

> > > Because those CPUs can make use of jiffies or gettimeofday() and must 
> > > have uptodate values. This involve quite some complication like using the 
> > > full system idle detection (CONFIG_NO_HZ_FULL_SYSIDLE) to avoid races 
> > > between timekeeper entering dynticks idle mode and other CPUs waking up 
> > > from idle. But the worst here is the powesaving issues resulting from the 
> > > timekeeper who can't sleep.
> > 
> > Personally, when I force the timer to be bound to a specific CPU, I'm 
> > pretty happy with the fact that it won't be allowed to turn ticks off. At 
> > that stage, powersave is the least of my concerns, throughput and/or jitter 
> > is.
> > 
> > I know that what I'm doing is in effect turning the kernel into a 
> > somewhat more configurable TICK_PERIODIC kernel (in the sense that I can 
> > set the timer to run on something other than the boot-cpu).
> 
> I see.
> 
> > 
> > > These issues are being dealt with in NO_HZ_FULL because we want the 
> > > timekeeping duty to be affine to the CPUs that are no full dynticks. But 
> > > in the case of NO_HZ_IDLE, I fear it's not going to be desirable.
> > 
> > Hum? I didn't get that one, what do you mean?
> 
> So in NO_HZ_FULL we do something that is very close to what're doing: the timekeeping
> is affine to the boot CPU and it stays periodic whatever happens.
> 
> But we start to worry about powersaving. When the whole system is idle, there is
> no point is preventing the CPU 0 to sleep. So we are dealing with that by using a
> full system idle detection that lets CPU 0 go to sleep when there is strictly nothing
> to do. Then when nohz full CPU wakes up from idle, CPU 0 is woken up as well to get back
> to its timekeeping duty.

Hmm, I had the impreesion that when a CPU with timekeeping-duty was sent to 
sleep, it would set tick_do_timer_cpu to TICK_DO_TIMER_NONE, and whenever 
another core would run do_timer() it would see if tick_do_timer_cpu was set 
to TICK_DO_TIMER_NONE and if so, grab it and run with it.

I really don't see how this wakes up CPU0 (but then again, there's probably 
several layers of logic here that I'm missing :)


-- 
Henrik Austad
