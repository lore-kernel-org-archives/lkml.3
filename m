Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495AbaCCKpP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 05:45:15 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:39131 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112AbaCCKoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 05:44:54 -0500
Date: Mon, 3 Mar 2014 11:42:13 +0100
From: Henrik Austad <henrik@austad.us>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Henrik Austad <haustad@cisco.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        John Stultz <john.stultz@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/6 v2] Expose do_timer CPU as RW to userspace
Message-ID: <20140303104212.GA16001@austad.us>
References: <1393331641-14016-1-git-send-email-henrik@austad.us>
 <20140225141906.GA22814@localhost.localdomain>
 <20140226081602.GA16591@austad.us>
 <20140226130234.GA3104@localhost.localdomain>
 <20140227083735.GA5129@austad.us>
 <20140227135618.GB17608@localhost.localdomain>
 <20140228094035.GA6113@austad.us>
 <20140228230832.GA26658@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140228230832.GA26658@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 01, 2014 at 12:08:36AM +0100, Frederic Weisbecker wrote:
> On Fri, Feb 28, 2014 at 10:40:35AM +0100, Henrik Austad wrote:
> > On Thu, Feb 27, 2014 at 02:56:20PM +0100, Frederic Weisbecker wrote:
> > > Right, or timekeeper_cpumask.
> > 
> > Right, paying some attention to a proper, descriptive name is probably a 
> > good thing.
> > 
> > Also, for future reference, a consistent name for "the core running the 
> > timeeping update" would be nice. Ref suggestion above, 'timekeeper' seems 
> > to be a valid name for the core currently assigned the duty.
> > 
> > All in favour?
> 
> Yeah definetly. I'm already using it in my changelogs for a few.
> 
> > 
> > > > For periodic, that would be a single core (normally boot), and when 
> > > > forced, it would return a cpu-mask with only one cpu set. Then the 
> > > > result would be a lot more informative for NO_HZ_(IDLE|FULL) as well.
> > > 
> > > I'd rather suggest that for periodic and NO_HZ_IDLE, this should be equal 
> > > to cpu_online_mask by default. Because the timekeeping duty can be taken 
> > > by any CPU.
> > 
> > So basically, we're looking at a few more values here then
> 
> I feel we don't need more than a strictly single cpumask that can do all of that.
> Look:
> 
> > 
> > # the current (un)restricted mask where timekeeper can run this would be 
> > # the writable mask
> > 
> >      timekeeper_cpumask
> 
> Ok. By default cpu_possible_mask.
>
> > # the mask for which you can assign cores to timekeeper_cpumask For 
> > # NO_HZ_FULL, I guess this would be all cores except those in 
> > # nohz_full-mask.
> > # read-only
> > 
> >      timekeeper_cpumask_possible
> 
> Right but why a different mask here? Just in the case of NO_HZ_FULL,
> timekeeper_cpumask is (cpu_possible_mask & ~tick_nohz_full_mask)

I wanted to distinguish between what's actually set and what's possible to 
set.

> > # makes sense only in periodic system where it does not bounce around like 
> > # crazy.
> > # read-only
> > 
> >      timekeeper_current_cpu
> 
> It may not bounce crazy but it can bounce actually. Just offline the timekeeper
> and this happens.
> 
> Then again I feel like timekeeper_cpumask is still a good fit here.

True, this was more for getting an idea about where it is _right_now_. But 

I guess you're right, if you want to know -excatly- where timekeeper is, 
you need to do some tracing and see where it has been.

> > Then force_cpu should accept a mask, or a range, of CPUs on which 
> > timekeeper should be allowed.
> > 
> >      timekeeper_cpumask_forced
> 
> That too can be timekeeper_cpumask.

Yes, and no.

In a system where you haven't set a forced-mask, then you could use this to 
read that info out (-1 or a cleared mask returned). Once you set a mask, 
then you can get the exact mask the system has used from here.

This is information you can infer, but it makes using the system a bit 
easier.

I know you can deduce most of this based on original state, hardware 
konwledge and how timekeeper works, but exposing it in cleartext back to 
userland would be beneficial in my view.

Why obscure it more than necessary?

> > > Assuming we want it then yeah, the cpumask affinity in sysfs/procfs looks 
> > > like a sane approach to me. In term we should also plug it to rcu full 
> > > system idle detection: https://lwn.net/Articles/558284/ so that we can 
> > > shutdown the reduced set of timekeepers when there is no other CPU 
> > > running. I have some patches for it that I can plug afterward. So no 
> > > worry for you on that side.
> > 
> > Ok, I'm not going to start to worry about that just yet then, but it does 
> > sound very interesting! :)
> 
> And moreover it's very convenient for me if we do that since that would
> setup all the infrastrucuture I need to affine timekeeper and adaptively
> run the timekeeper in dynticks idle mode on NO_HZ_FULL.
> 
> > > > That is certainly true, but that part happens to be of global 
> > > > influence, so if I have a core where a driver disables interrupts a lot 
> > > > (or drops into a hypervisor, or any other silly thing it really 
> > > > shouldn't be doing), then I would like to be able to move the 
> > > > timekeeping updates away from that core.
> > > 
> > > I don't understand how these things are linked together. If your driver 
> > > disables interrupt and you don't want to be disturbed, moving the 
> > > timekeeping duty doesn't move the tick itself.
> > 
> > True, but it reduces some amount of jitter from the tick itself. It's more 
> > like damagecontrol than damage-prevention.
> 
> Ok.
> 
> > 
> > > What happens to be disturbing for you in the timekeeping update that is 
> > > not with the tick as a whole? Is the delta of cputime added by jiffies 
> > > and gtod update alone a problem?
> > 
> > I had some examples where timekeeper would grab timekeeper.lock and hold it 
> > for a very long time. The reason was not very easy to pinpoint, so one of 
> > the things I wanted to try, was to move the timekeeper around and see what 
> > happened (yeah, debugging at it's best!)
> 
> And you got better results?

Define better, I was trying to work around a fault, and then I realized 
that I could use this for a lot more than just fixing that particular
issue.

> > > > > Does this all make sense outside the NO_HZ_FULL case?
> > > > 
> > > > In my view, it makes sense in the periodic case as well since all 
> > > > timekeeping updates then happens on the boot-cpu (unless it is 
> > > > hotunplugged that is).
> > > 
> > > But if we get back to your requirements, you want no interference at all. 
> > > HZ_PERIODIC doesn't look like what you want.
> > 
> > True, but I also needed a mechanism for moving the timekeeper away from a 
> > problematic core.
> > 
> > Another benefit from periodic, is that it supports skewed timers and that 
> > the overhead is lower than NO_HZ when you do have timer-interrupts.
> 
> Yeah that's a point.
> 
> > > > That's what I aimed at, and I *think* I managed that. I added a 
> > > > forced_timer_can_stop_tick() and let can_stop_full_tick() and 
> > > > can_stop_idle_tick() call that. I think that is sufficient, at least I 
> > > > did not see that the timerduty was transferred to another core 
> > > > afterwards.
> > > 
> > > Ok, I need to look at the details.
> > 
> > Ahem, no, my understanding of the NOHZ-cpumask was flawed. I'm reworking 
> > this based on feedback as well as the discussion below.
> 
> Ok.
> 
> > > Scenario is: CPU 0 handles timekeeping and CPU 1 is full dynticks. Both 
> > > are running then CPU 1 goes to sleep. CPU 0 notices that CPU 1 went to 
> > > sleep and thus nobody else needs the timekeeping to be uptodate. If CPU 0 
> > > is idle as well it can go to sleep. So does it. Then later if CPU 1 wakes 
> > > up to do something, it sends an IPI to CPU 0 such that CPU 0 wakes up, 
> > > notices that CPU 1 is alive and run the timekeeping update on its behalf.
> > > 
> > > It's not yet upstream but that's the plan :)
> > 
> > So all dynticks-kernel will send an IPI to CPU0 upon wakeup to notify  
> > that they're no longer sleeping?
> 
> I guess you meant s/dynticks-kernel/full-dynticks CPU/

Yes.

> So yes that's exactly what happens!

Ok, so that gives you a nice way of knowing that the system is *not* idle. 

But how do you know that it -is- idle? If the full dynticks-kernel are 
running a single task, they're not idle and would require timekeeper to 
run. How do you ensure that timekeeper does not suspend?

Perhaps it doesn't matter, if the other cores can detect when CPU#0 is idle 
and send an IPI, then it will probably be woken up pretty fast anyway.

> > Sounds like having a (effective) way to detect that the entire system is 
> > idle in an effective manner would be really nice in this scenario! That 
> > way, if CPU1 could determine that the system was not idle, it would not 
> > have to send an IPI to CPU0 to wake it up.
> 
> Exactly! The full system idle detection provides that clever information (taking care
> of races and all) that lets us know if the IPI is really needed or if it can be spared,
> depending on CPU 0 state.
> 
> This all relies on a tricky lockless machine state. Checkout CONFIG_NO_HZ_FULL_SYSIDLE
> for details, it's an interesting devilry ;)

/me reads 'interesting devilry' and instantly gets a bad feeling. :)
 
> It's not yet used but we are in the good way: https://lkml.org/lkml/2013/12/17/708

-- 
Henrik Austad
