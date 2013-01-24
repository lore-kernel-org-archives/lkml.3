Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939Ab3AXDiP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:38:15 -0500
Received: from mga11.intel.com ([192.55.52.93]:44721 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753631Ab3AXDhm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:37:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,525,1355126400"; 
   d="scan'208";a="281491700"
Date: Thu, 24 Jan 2013 11:37:30 +0800
From: Feng Tang <feng.tang@intel.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@linux.intel.com>, x86@kernel.org,
        Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [RFC PATCH 0/5] Add support for S3 non-stop TSC support.
Message-ID: <20130124033730.GA28770@feng-snb>
References: <1358750325-21217-1-git-send-email-feng.tang@intel.com>
 <50FD8D07.5030908@linaro.org>
 <20130122145547.GC26140@feng-snb>
 <50FF0AF9.5030904@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50FF0AF9.5030904@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 01:56:09PM -0800, John Stultz wrote:
> On 01/22/2013 06:55 AM, Feng Tang wrote:
> >Hi John,
> >
> >On Mon, Jan 21, 2013 at 10:46:31AM -0800, John Stultz wrote:
> >>What I'd propose is that we break the read_persistent_clock()
> >>functionality up. So we need two interfaces:
> >>1) An interface to access a time value we used to initialize the
> >>system's CLOCK_REALTIME time.
> >>2) An interface to measure the length of suspend.
> >>
> >>
> >>Interface #1 could be possibly just replaced with the RTCTOSYS
> >>functionality. Although the downside there is that for some time at
> >>bootup between the timekeeping_init() function running (prior to
> >>interrupts being enabled) and the RTC driver being available (after
> >>interrupts are enabled), where we'd have an incorrect system clock.
> >>So we may want to preserve something like the existing
> >>read_persistent_clock() interface, but as Jason suggested, we could
> >>push that access into the RTC driver itself.
> >One case is one platform need a minimum size of kernel, which only
> >needs to use the read_persistent_clock for time init, and chose
> >to not compile in the "drivers/rtc/". So I think read_persistent_clock()
> >is needed anyway to remove the dependency over the rtc system.
>
> I think hard numbers would be needed to show the rtc layer is
> causing major issues for space constrained kernels, so this
> trade-off could be properly prioritized. Having duplicate code paths
> in standard kernels is wasteful as well.

Here are some sizes of rtc codes:
size rtc-core.o rtc-lib.o hctosys.o rtc-cmos.o
text    data     bss     dec     hex filename
14810     304     132   15246    3b8e rtc-core.o
1425       0       0    1425     591 rtc-lib.o
486       8       0     494     1ee hctosys.o
7169     456      90    7715    1e23 rtc-cmos.o

Another thing is currently the CONFIG_RTC_XXX is selectable option for
kernel, if we push the read_persistent_clock() from kernel code down to
rtc  driver layer, then some of the CONFIG_RTC_XXX have to be always 'y' 

>
> >IIRC, some EFI backed x86 system's read_persistent_clock() is
> >implemented by EFI's runtime gettime service.
> Interesting, does the rtc driver not support this?

x86's read_persistent_clock() is actually implemented with 
	retval = x86_platform.get_wallclock()

And for x86_32 platform, the efi.c has code to set  x86_platform.get_wallclock()
to efi_get_time() which is efi's runtime service.

I don't know the detail how it works, but I think it could co-exist with a
rtc driver if there is.


>
> >
> >>There is still plenty of ugly details as to how interface #2 would
> >>work. Since it could return something as coarse as seconds, or it
> >>could provide nanosecond granularity, you probably want to return a
> >>timespec that we'd capture at suspend and resume, and calculate the
> >Yes, we should keep to use the timespec way in current code.
> >
> >>delta of. However, in order to properly provide a timespec from a
> >>raw TSC counter, you need to be careful with the math to avoid
> >>overflows as TSC counter value grows (take a look at the sched_clock
> >>code). Also whatever function backs this would need to have the
> >>logic to know when to use the TSC counter vs falling back to the RTC
> >>in the case where we're actually able to go into S4.
> >Thanks for the hint, will study the sched_clock code. And yes, how
> >to tell s2ram or s2disk remains a tough task.
> Although from whatever the new read_persistent_clock interface would
> be, you might be able to detect things like the TSC value being
> reset (less then what it was at suspend time), and fall back to an

Good idea! This could be used to judge the S3/S4, as no clocksource should
still tick in S4 (hibernate) mode.

> RTC approximation of what the timestamp should be? Or alternatively,
> on hardware that can hybernate, avoid using the tsc counter
> entirely. Either way, these implementation details should be
> contained in the architecture's new read_persistent_clock()
> implementation, and likely not need any changes in the timekeeping
> code (other then to adapt to use the new interface).

One concern is this way may push some clocksource ops into arch's
read_persistent_clock() implementation. Currently read_persistent_clock()
is only called in three phases: boot, suspend and resume. If we want it to  
trace the suspended time, then we need to detect which phase is calling it.

One rough thought is adding a struct suspend_time_tracker, and make it part
of struct timekeeper. It can embed the 2 existing global variables
timekeeping_suspended and timekeeping_suspend_time. And add 2 wrappers like
suspend_time_prepare(), suspend_time_calc() as Jason mentioned to take care
the suspend time. 

Thanks,
Feng


