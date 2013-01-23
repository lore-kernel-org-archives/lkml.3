Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335Ab3AWAmI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 19:42:08 -0500
Received: from mail-da0-f51.google.com ([209.85.210.51]:50939 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab3AWAmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 19:42:03 -0500
Message-ID: <50FF31D6.3090304@linaro.org>
Date: Tue, 22 Jan 2013 16:41:58 -0800
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
References: <1358750325-21217-1-git-send-email-feng.tang@intel.com> <50FD8D07.5030908@linaro.org> <20130122195701.GH30647@obsidianresearch.com> <50FEF505.60504@linaro.org> <20130123002610.GA814@obsidianresearch.com>
In-Reply-To: <20130123002610.GA814@obsidianresearch.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2013 04:26 PM, Jason Gunthorpe wrote:
> On Tue, Jan 22, 2013 at 12:22:29PM -0800, John Stultz wrote:
>
>>> How big of an issue is this? Could the RTCTOSYS function be moved to
>>> the moment the RTC driver is registered rather than using a
>>> late_initcall?
>> It may not be huge. Most early boot items are going to be
>> CLOCK_MONOTONIC based, which would be unaffected. So that's a
>> potential solution, but I'm hesitant to claim there'd be no side
>> effects.
> Well, ARM/PPC/etc pretty much rely on RTCTOSYS for time, so if there
> are side effects then they are going to be problematic for not-x86
> today and should be fixed up.. But that probably also says there are
> not many side effects because folks are not complaining??
>
>>>> Interface #2 could then be either RTC based, or countinuous counter
>>>> based. Since we still want to do this measurement with interrupts
>>>> off, we still would need that interrupt-free RTC method like
>>>> read_persistent_clock() where supported (falling back to the RTC
>>>> driver's suspend/resume handler to try to fix things up as best it
>>>> can if that's not available).
>>> Could the counter version of this be bundled into the clocksource
>>> framework? It already has generic APIs for handling cycle counters and
>>> things. Isn't there a TSC driver for clocksource already? Is all that
>>> is missing is a way to tell if the counter survived suspend?
>   
>> So without *major* rework, I'd rather not do this. Again, the
>> clocksource code has quite a few assumptions built in that are
>> optimized for timekeeping (where we avoid overflows by expecting
>> relatively frequent updates), and very different approaches are
>> needed for something like suspend (where valid suspend times could
>> be potentially months to years).
> Well, I was thinking something very simple..
>
> The reason to be interested in the clocksource code is there is
> already so much support code to make it easy to use for many timers
> out there, and there is already TSC support for it. Plus there is
> already the full architecture for muxing multiple drivers, which is
> pretty important...
>
> The simple case is that any clocksource intended for suspend time
> keeping must not over flow for reasonable times (years?), so you can
> ignore the overflow problem entirely. The 32kHz ARM counter and the 64
> bit TSC both seem to be OK in this regard.

Right but to calculate an suspend interval (since they are likely many 
orders of magnitude larger then the intervals between timer interrupts), 
you need different mult/shift selection.  Its splitting out the 
mult/shift management into a per-subsystem level that is the complicated 
part. Additionally, there may be cases where the timekeeping clocksource 
is one clocksource and the suspend clocksource is another. So I think to 
properly integrate this sort of functionality w/ clocksources is going 
to require a serious rework of the clocksource code.


>
>>> clocksource already has suspend/resume callbacks stuff, so the counter
>>> driver could sense if the sleep was too deep and mark itself as
>>> invalid.
>> But at that point you've lost time. If this was all centrally
>> controlled, you have to know before hand what the bounds would be.
>> With the TSC, we know it won't wrap around our starting measurement
>> for at least 10 years. That's a reasonable range for suspend.  We
>> don't want to resume and just get a "oh, bad call, you picked the
>> wrong clocksource for such a long suspend", and really without the
>> clocksource checking with the RTC I don't think it can even know if
>> its been too long itself (since maybe the counter wrapped, but maybe
>> not).
> I'm not worrying about overflow here, I was thinking about different
> sleep states. Eg a timer may only function in suspend to ram but not
> hibernate to disk, so on transition in/out of hibernate it would allow
> the clock source driver to detect that transition and mark itself as
> invalid.
>
> So, it would work something like:
>   - Prior to suspend record the result of read() from all clock_sources
>   - Run through all the suspend call backs. If the suspend state (eg
>     hibernate) is too deep then the clock source PM call back will mark
>     it as invalid
>   - Upon resume do another read from all clock sources, and also do a
>     'survived_suspend' type of call. Take the highest priority
>     clock source that survived suspend and use that delta to update the
>     realtime clock.
>   - If no clock sources survived then attempt to read without
>     interrupts from the RTC driver
>   - If you couldn't read without interrupts from the RTC driver then
>     schedual a RTC read when interrupts are on
>
> A fancier version could sanity check the clocksource delta with the
> RTC delta, if they differ by more max(~10%,2 sec) then use the RTC
> delta, this would handle clocksource overflows fairly simply.

So something like this flow sounds fine, but I think that doing it 
behind the new read_persistent_clock()-like call is the right approach 
in the near term.

thanks
-john

