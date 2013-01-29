Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930Ab3A2ABW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 19:01:22 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:37894 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755564Ab3A2ABU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 19:01:20 -0500
Message-ID: <5107114C.4070307@linaro.org>
Date: Mon, 28 Jan 2013 16:01:16 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Matt Sealey <matt@genesi-usa.com>, LKML <linux-kernel@vger.kernel.org>,
        Ben Dooks <ben@simtec.co.uk>, Ingo Molnar <mingo@redhat.com>,
        Linux ARM Kernel ML <linux-arm-kernel@lists.infradead.org>
Subject: Re: One of these things (CONFIG_HZ) is not like the others..
References: <CAKGA1bkiowcO7OPSfPmaB6eRj_3FNr+4ONnaQHEZkpxB2XfduQ@mail.gmail.com> <20130121232322.GK15361@atomide.com> <50FE307F.9000701@ti.com> <201301220931.24570.arnd@arndb.de> <50FE666B.10902@ti.com> <20130122145113.GK23505@n2100.arm.linux.org.uk> <50FEAABA.6050307@ti.com> <510615F8.7010203@ti.com>
In-Reply-To: <510615F8.7010203@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2013 10:08 PM, Santosh Shilimkar wrote:
> On Tuesday 22 January 2013 08:35 PM, Santosh Shilimkar wrote:
>> On Tuesday 22 January 2013 08:21 PM, Russell King - ARM Linux wrote:
>>> On Tue, Jan 22, 2013 at 03:44:03PM +0530, Santosh Shilimkar wrote:
>>>> Sorry for not being clear enough. On OMAP, 32KHz is the only clock 
>>>> which
>>>> is always running(even during low power states) and hence the clock
>>>> source and clock event have been clocked using 32KHz clock. As 
>>>> mentioned
>>>> by RMK, with 32768 Hz clock and HZ = 100, there will be always an
>>>> error of 0.1 %. This accuracy also impacts the timer tick interval.
>>>> This was the reason, OMAP has been using the HZ = 128.
>>>
>>> Ok.  Let's look at this.  As far as time-of-day is concerned, this
>>> shouldn't really matter with the clocksource/clockevent based system
>>> that we now have (where *important point* platforms have been converted
>>> over.)
>>>
>>> Any platform providing a clocksource will override the jiffy-based
>>> clocksource.  The measurement of time-of-day passing is now based on
>>> the difference in values read from the clocksource, not from the actual
>>> tick rate.
>>>
>>> Anything _not_ providing a clock source will be reliant on jiffies
>>> incrementing, which in turn _requires_ one timer interrupt per jiffies
>>> at a known rate (which is HZ).
>>>
>>> Now, that's the time of day, what about jiffies?  Well, jiffies is
>>> incremented based on a certain number of nsec having passed since the
>>> last jiffy update.  That means the code copes with dropped ticks and
>>> the like.
>>>
>>> However, if your actual interrupt rate is close to the desired HZ, then
>>> it can lead to some interesting effects (and noise):
>>>
>>> - if the interrupt rate is slightly faster than HZ, then you can end up
>>>    with updates being delayed by 2x interrupt rate.
>>> - if the interrupt rate is slightly slower than HZ, you can 
>>> occasionally
>>>    end up with jiffies incrementing by two.
>>> - if your interrupt rate is dead on HZ, then other system noise can 
>>> come
>>>    into effect and you may get maybe zero, one or two jiffy increments
>>> per
>>>    interrupt.
>>>
>>> (You have to think about time passing in NS, where jiffy updates should
>>> be vs where the timer interrupts happen.)  See 
>>> tick_do_update_jiffies64()
>>> for the details.
>>>
>>> The timer infrastructure is jiffy based - which includes scheduling 
>>> where
>>> the scheduler does not use hrtimers.  That means a slight discrepency
>>> between HZ and the actual interrupt rate can cause around 1/HZ jitter.
>>> That's a matter of fact due to how the code works.
>>>
>>> So, actually, I think the accuracy of HZ has much overall effect
>>> _provided_
>>> a platform provides a clocksource to the accuracy of jiffy based timers
>>> nor timekeeping.  For those which don't, the accuracy of the timer
>>> interrupt to HZ is very important.
>>>
>>> (This is just based on reading some code and not on practical
>>> experiments - I'd suggest some research of this is done, trying HZ=100
>>> on OMAP's 32kHz timers, checking whether there's any drift, checking
>>> how accurately a single task can be woken from various 
>>> select/poll/epoll
>>> delays, and checking whether NTP works.)
>>>
>> Thanks for expanding it. It is really helpful.
>>
>>> And I think further discussion is pointless until such research has 
>>> been
>>> done (or someone who _really_ knows the time keeping/timer/sched code
>>> inside out comments.)
>>>
>> Fully agree about experimentation to re-asses the drift.
>>  From what I recollect from past, few OMAP customers did
>> report the time drift issue and that is how the switch
>> from 100 --> 128 happened.
>>
>> Anyway I have added the suggested task to my long todo list.
>>
> So I tried to see if any time drift with HZ = 100 on OMAP. I ran the
> setup for 62 hours and 27 mins with time synced up once with NTP server.
> I measure about ~174 millisecond drift which is almost noise considering
> the observed duration was ~224820000 milliseconds.

So 174ms drift doesn't sound great, as < 2ms (often much less - though 
that depends on how close the server is) can be expected with NTP. 
Although its not clear how you were measuring: Did you see a max 174ms 
offset while trying to sync with NTP? Was that offset shortly after 
starting NTP or after NTP converged down?

thanks
-john

