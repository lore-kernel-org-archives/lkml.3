Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036Ab3AVV4R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 16:56:17 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:64562 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab3AVV4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 16:56:14 -0500
Message-ID: <50FF0AF9.5030904@linaro.org>
Date: Tue, 22 Jan 2013 13:56:09 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Feng Tang <feng.tang@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@linux.intel.com>, x86@kernel.org,
        Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [RFC PATCH 0/5] Add support for S3 non-stop TSC support.
References: <1358750325-21217-1-git-send-email-feng.tang@intel.com> <50FD8D07.5030908@linaro.org> <20130122145547.GC26140@feng-snb>
In-Reply-To: <20130122145547.GC26140@feng-snb>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2013 06:55 AM, Feng Tang wrote:
> Hi John,
>
> On Mon, Jan 21, 2013 at 10:46:31AM -0800, John Stultz wrote:
>> What I'd propose is that we break the read_persistent_clock()
>> functionality up. So we need two interfaces:
>> 1) An interface to access a time value we used to initialize the
>> system's CLOCK_REALTIME time.
>> 2) An interface to measure the length of suspend.
>>
>>
>> Interface #1 could be possibly just replaced with the RTCTOSYS
>> functionality. Although the downside there is that for some time at
>> bootup between the timekeeping_init() function running (prior to
>> interrupts being enabled) and the RTC driver being available (after
>> interrupts are enabled), where we'd have an incorrect system clock.
>> So we may want to preserve something like the existing
>> read_persistent_clock() interface, but as Jason suggested, we could
>> push that access into the RTC driver itself.
> One case is one platform need a minimum size of kernel, which only
> needs to use the read_persistent_clock for time init, and chose
> to not compile in the "drivers/rtc/". So I think read_persistent_clock()
> is needed anyway to remove the dependency over the rtc system.

I think hard numbers would be needed to show the rtc layer is causing 
major issues for space constrained kernels, so this trade-off could be 
properly prioritized. Having duplicate code paths in standard kernels is 
wasteful as well.

> IIRC, some EFI backed x86 system's read_persistent_clock() is
> implemented by EFI's runtime gettime service.
Interesting, does the rtc driver not support this?



>
>> Interface #2 could then be either RTC based, or countinuous counter
>> based. Since we still want to do this measurement with interrupts
>> off, we still would need that interrupt-free RTC method like
>> read_persistent_clock() where supported (falling back to the RTC
>> driver's suspend/resume handler to try to fix things up as best it
>> can if that's not available).
> Do you mean to create a new function and not embed the suspend/hibernate
> time compensation code inside timekeeping_suspend/resume()?

No, that's not what I mean.  timekeeping_suspend/resume still would do 
the proper timekeeping adjustments, but there would be a new interface 
that is similar to read_persistent_clock() that does not necessarily 
return a time value to be used to initialize CLOCK_REALTIME. It could 
return the same value read_persistent_clock() does today, but it would 
be acceptable for it to return time values that are not based from the 
unix epoch (as platforms with the 32k counter do already).


>
>> There is still plenty of ugly details as to how interface #2 would
>> work. Since it could return something as coarse as seconds, or it
>> could provide nanosecond granularity, you probably want to return a
>> timespec that we'd capture at suspend and resume, and calculate the
> Yes, we should keep to use the timespec way in current code.
>
>> delta of. However, in order to properly provide a timespec from a
>> raw TSC counter, you need to be careful with the math to avoid
>> overflows as TSC counter value grows (take a look at the sched_clock
>> code). Also whatever function backs this would need to have the
>> logic to know when to use the TSC counter vs falling back to the RTC
>> in the case where we're actually able to go into S4.
> Thanks for the hint, will study the sched_clock code. And yes, how
> to tell s2ram or s2disk remains a tough task.
Although from whatever the new read_persistent_clock interface would be, 
you might be able to detect things like the TSC value being reset (less 
then what it was at suspend time), and fall back to an RTC approximation 
of what the timestamp should be? Or alternatively, on hardware that can 
hybernate, avoid using the tsc counter entirely. Either way, these 
implementation details should be contained in the architecture's new 
read_persistent_clock() implementation, and likely not need any changes 
in the timekeeping code (other then to adapt to use the new interface).

thanks
-john

