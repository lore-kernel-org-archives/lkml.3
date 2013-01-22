Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861Ab3AVUWe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 15:22:34 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:35851 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661Ab3AVUWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 15:22:33 -0500
Message-ID: <50FEF505.60504@linaro.org>
Date: Tue, 22 Jan 2013 12:22:29 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: Feng Tang <feng.tang@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@linux.intel.com>,
        x86@kernel.org, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] Add support for S3 non-stop TSC support.
References: <1358750325-21217-1-git-send-email-feng.tang@intel.com> <50FD8D07.5030908@linaro.org> <20130122195701.GH30647@obsidianresearch.com>
In-Reply-To: <20130122195701.GH30647@obsidianresearch.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2013 11:57 AM, Jason Gunthorpe wrote:
> On Mon, Jan 21, 2013 at 10:46:31AM -0800, John Stultz wrote:
>   
>> What I'd propose is that we break the read_persistent_clock()
>> functionality up. So we need two interfaces:
>> 1) An interface to access a time value we used to initialize the
>> system's CLOCK_REALTIME time.
>> 2) An interface to measure the length of suspend.
>> Interface #1 could be possibly just replaced with the RTCTOSYS
>> functionality. Although the downside there is that for some time at
>> bootup between the timekeeping_init() function running (prior to
>> interrupts being enabled) and the RTC driver being available (after
>> interrupts are enabled), where we'd have an incorrect system clock.
>> So we may want to preserve something like the existing
>> read_persistent_clock() interface, but as Jason suggested, we could
>> push that access into the RTC driver itself.
> How big of an issue is this? Could the RTCTOSYS function be moved to
> the moment the RTC driver is registered rather than using a
> late_initcall?

It may not be huge. Most early boot items are going to be 
CLOCK_MONOTONIC based, which would be unaffected. So that's a potential 
solution, but I'm hesitant to claim there'd be no side effects.


>> Interface #2 could then be either RTC based, or countinuous counter
>> based. Since we still want to do this measurement with interrupts
>> off, we still would need that interrupt-free RTC method like
>> read_persistent_clock() where supported (falling back to the RTC
>> driver's suspend/resume handler to try to fix things up as best it
>> can if that's not available).
> Could the counter version of this be bundled into the clocksource
> framework? It already has generic APIs for handling cycle counters and
> things. Isn't there a TSC driver for clocksource already? Is all that
> is missing is a way to tell if the counter survived suspend?

So without *major* rework, I'd rather not do this. Again, the 
clocksource code has quite a few assumptions built in that are optimized 
for timekeeping (where we avoid overflows by expecting relatively 
frequent updates), and very different approaches are needed for 
something like suspend (where valid suspend times could be potentially 
months to years).

That said, given ARM's use of clocksources for sched_clock, there may be 
some reasonable claim to splitting the clocksource mult/shift selection 
management away from the clocksource itself (instead having it managed 
by the timekeeping core). That would allow other subsystems to use the 
clocksource accessor function, managing their own mult/shift selection 
trade-offs independently.

But such an effort would be of substantial size, given how invasive it 
would be. So I'm not sure this is likely to happen in the near term 
without a dedicated effort.

So I think the smaller effort of splitting up the 
read_persistent_clock() and making it more reasonably handle counters 
like this S3 non-stop TSC and the 32k counter is a more reasonable 
mid-step (especially since there will still be the same logical division 
from a timekeeping perspective between runtime clocksources and 
suspend-measuring clocksources if we were to do the major overhaul 
eventually).


> clocksource already has suspend/resume callbacks stuff, so the counter
> driver could sense if the sleep was too deep and mark itself as
> invalid.
But at that point you've lost time. If this was all centrally 
controlled, you have to know before hand what the bounds would be. With 
the TSC, we know it won't wrap around our starting measurement for at 
least 10 years. That's a reasonable range for suspend.  We don't want to 
resume and just get a "oh, bad call, you picked the wrong clocksource 
for such a long suspend", and really without the clocksource checking 
with the RTC I don't think it can even know if its been too long itself 
(since maybe the counter wrapped, but maybe not).

> This would help solve the problem on ARM with muxing persistent clock
> on multi-platform.
>
> A RTC device flag 'readable with interrupts off' still seems like a
> good idea for the RTC case..

Yea, I think this point you're probably right, as I'm warming to the 
idea of pushing the existing read_persistent_clock() into the rtc device 
code. Just need to make sure not initializing CLOCK_REALTIME at 
timekeeping_init isn't going to have negative effects.

thanks
-john


