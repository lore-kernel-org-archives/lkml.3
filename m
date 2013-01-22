Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635Ab3AVS7I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 13:59:08 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:59812 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554Ab3AVS7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 13:59:05 -0500
Message-ID: <50FEE175.90504@linaro.org>
Date: Tue, 22 Jan 2013 10:59:01 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Matt Sealey <matt@genesi-usa.com>, LKML <linux-kernel@vger.kernel.org>,
        Ben Dooks <ben@simtec.co.uk>, Ingo Molnar <mingo@redhat.com>,
        Linux ARM Kernel ML <linux-arm-kernel@lists.infradead.org>
Subject: Re: One of these things (CONFIG_HZ) is not like the others..
References: <CAKGA1bkiowcO7OPSfPmaB6eRj_3FNr+4ONnaQHEZkpxB2XfduQ@mail.gmail.com> <20130121232322.GK15361@atomide.com> <50FE307F.9000701@ti.com> <201301220931.24570.arnd@arndb.de> <50FE666B.10902@ti.com> <20130122145113.GK23505@n2100.arm.linux.org.uk>
In-Reply-To: <20130122145113.GK23505@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2013 06:51 AM, Russell King - ARM Linux wrote:
> On Tue, Jan 22, 2013 at 03:44:03PM +0530, Santosh Shilimkar wrote:
>> Sorry for not being clear enough. On OMAP, 32KHz is the only clock which
>> is always running(even during low power states) and hence the clock
>> source and clock event have been clocked using 32KHz clock. As mentioned
>> by RMK, with 32768 Hz clock and HZ = 100, there will be always an
>> error of 0.1 %. This accuracy also impacts the timer tick interval.
>> This was the reason, OMAP has been using the HZ = 128.
> Ok.  Let's look at this.  As far as time-of-day is concerned, this
> shouldn't really matter with the clocksource/clockevent based system
> that we now have (where *important point* platforms have been converted
> over.)
>
> Any platform providing a clocksource will override the jiffy-based
> clocksource.  The measurement of time-of-day passing is now based on
> the difference in values read from the clocksource, not from the actual
> tick rate.
>
> Anything _not_ providing a clock source will be reliant on jiffies
> incrementing, which in turn _requires_ one timer interrupt per jiffies
> at a known rate (which is HZ).

Correct. As long as we have a fine-grained hardware clocksource 
installed, HZ error should not affect timekeeping in any major way.


> Now, that's the time of day, what about jiffies?  Well, jiffies is
> incremented based on a certain number of nsec having passed since the
> last jiffy update.  That means the code copes with dropped ticks and
> the like.
>
> However, if your actual interrupt rate is close to the desired HZ, then
> it can lead to some interesting effects (and noise):
>
> - if the interrupt rate is slightly faster than HZ, then you can end up
>    with updates being delayed by 2x interrupt rate.
> - if the interrupt rate is slightly slower than HZ, you can occasionally
>    end up with jiffies incrementing by two.
> - if your interrupt rate is dead on HZ, then other system noise can come
>    into effect and you may get maybe zero, one or two jiffy increments per
>    interrupt.
>
> (You have to think about time passing in NS, where jiffy updates should
> be vs where the timer interrupts happen.)  See tick_do_update_jiffies64()
> for the details.

Correct, with HRT, we actually trigger the HZ-frequency timer tick from 
an hrtimer (which expires based on the system time driven by the 
clocksource). Thus even if there is a theoretical error between the 
ideal HZ and what the hardware can do, that error will not propagate 
forward.

Instead, you may only see timer jitter on the order of how fine-grained 
the timer hardware can be triggered. If that is relatively fine, it 
shouldn't be an issue, if its relatively coarse (closer to HZ), then 
there may be the noise effects you list above. Although that should be 
mostly ok since jiffy timers will always have a few jiffys of jitter due 
to the granularity (ie: when setting a jiffies timer, you don't how how 
far into the current jiffy you are).

In the case where we don't have HRT, and the timers are triggered by the 
HZ periodic interrupt, then there is a mix of possibilities, for 
hrtimers you'll still see the behavior you list above (since they are 
still time based), but for jiffies timers, the rules are mostly inverted 
(if the interrupt rate is fast, jiffies timers will trigger sooner, if 
the rate is slow, jiffies timers will trigger later).

And if you are using jiffies for time (and not using the 
register_refined_jiffies code), then everything will follow the 
interrupt freq. So if interrupts are faster then HZ, time will move 
faster, timers will expire early, etc.


> The timer infrastructure is jiffy based - which includes scheduling where
> the scheduler does not use hrtimers.  That means a slight discrepency
> between HZ and the actual interrupt rate can cause around 1/HZ jitter.
> That's a matter of fact due to how the code works.
>
> So, actually, I think the accuracy of HZ has much overall effect _provided_
> a platform provides a clocksource to the accuracy of jiffy based timers
> nor timekeeping.  For those which don't, the accuracy of the timer
> interrupt to HZ is very important.

I think you're right, but I suspect there are some typos in the above. 
So to clarify:

The accuracy of HZ shouldn't have much affect on timekeeping on systems 
that use fine-grained clocksources. Though for systems that use 
jiffies/arch_gettimeoffset() HZ accuracy is more important. However, the 
register_refined_jiffies() call should allow for smaller error on those 
systems to be corrected.

The accuracy of HZ may have some affect on systems that do not have a 
clockevent driver and do not use hrt mode. It should be relatively bounded


> (This is just based on reading some code and not on practical
> experiments - I'd suggest some research of this is done, trying HZ=100
> on OMAP's 32kHz timers, checking whether there's any drift, checking
> how accurately a single task can be woken from various select/poll/epoll
> delays, and checking whether NTP works.)

Yea, for omap and other more "modern" systems with clocksources and 
clockevents, HZ=100 should be ok. Although I'd still like to see the 
experiments run, since as always, there may be bugs (I'd be interested 
in hearing about).

Even on systems w/o clocksources and clockevents, small HZ error should 
be able to be managed via the register_refined_jiffies() and I'd like to 
hear if folks have issues with that (there may be bounds limits I've not 
run into - so I'd like to get that fixed if so).

The only really problematic cases are systems where there aren't 
clocksources nor clockevents, and the hardware has specific limits on 
what HZ ranges it can do (ie the EBSA110), but I think we're all ok with 
those not being able to be compiled into a multi-platform kernel.

thanks
-john

