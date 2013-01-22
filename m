Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab3AVOzr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 09:55:47 -0500
Received: from mga01.intel.com ([192.55.52.88]:6086 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753087Ab3AVOzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 09:55:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,514,1355126400"; 
   d="scan'208";a="280569342"
Date: Tue, 22 Jan 2013 22:55:47 +0800
From: Feng Tang <feng.tang@intel.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@linux.intel.com>, x86@kernel.org,
        Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [RFC PATCH 0/5] Add support for S3 non-stop TSC support.
Message-ID: <20130122145547.GC26140@feng-snb>
References: <1358750325-21217-1-git-send-email-feng.tang@intel.com>
 <50FD8D07.5030908@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50FD8D07.5030908@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

On Mon, Jan 21, 2013 at 10:46:31AM -0800, John Stultz wrote:
> On 01/20/2013 10:38 PM, Feng Tang wrote:
> >Hi All,
> >
> >On some new Intel Atom processors (Penwell and Cloverview), there is
> >a feature that the TSC won't stop S3, say the TSC value won't be
> >reset to 0 after resume. This feature makes TSC a more reliable
> >clocksource and could benefit the timekeeping code during system
> >suspend/resume cycles.
> >
> >The enabling efforts include adding new flags for this feature,
> >modifying clocksource.c and timekeeping.c to support and utilizing
> >it.
> >
> >One remaining question is inside the timekeeping_resume(), we don't
> >know if it is called by resuming from suspend(s2ram) or from
> >hibernate(s2disk), as there is no easy way to check it currently.
> >But it doesn't hurt as these Penwell/Cloverview platforms only have
> >S3 state, and no S4.
> >
> 
> Ooof. This is an interesting feature, but it does complicate things a bit.
> 
> So just a few high-level thoughts initially.
> 
> The clocksource code has to balance being able to make fine tuned
> adjustments with also being able to properly account for time when
> no timer interrupts occur. So by stretching the maximum time
> interval out, you end up hurting the adjustment granularity.
> 
> Also, since you still have a limited time value (40 minutes instead
> of 10), you will still run into lost time issues if the system
> suspends for longer then that. I think its reasonable to expect we
> get timer interrupts at least every 10 minutes while the system is
> running, but that's maybe not a reasonable expectation in suspend
> (even if we push it out to 40 minutes).

Good point. There were 2 reasons I chose 40 mins, one is the Android
running on our platform will set a RTC alarm to wake up system no
longer than 30 minutes, the other was to not hurt the precision too
much. I agree this change has some problems, and should be dumped.

> 
> Because of this, I think trying to integrate this feature into the
> clocksource code is the wrong approach.
> 
> 
> What this feature really reminds me of, is our discussion with
> Jason, and how the 32k counter is used on some ARM platforms with
> read_persistent_clock(). While read_persistent_clock() was initially
> a sort of special RTC interface, which let us initialize time
> properly in early boot and manage tracking suspend/resume time
> (before interrupts are enabled). The ARM platforms with the 32k
> counter really only use it for suspend/resume tracking (since it
> doesn't give a valid time at boot), and instead initialize time some
> other way.  I always considered it an interesting and creative
> slight misuse of the interface, but now that there's a good example
> of other systems where this approach would be usable, I think we
> should probably formalize it some.

Yes, that ARM platform's usage model is really interesting.

> 
> What I'd propose is that we break the read_persistent_clock()
> functionality up. So we need two interfaces:
> 1) An interface to access a time value we used to initialize the
> system's CLOCK_REALTIME time.
> 2) An interface to measure the length of suspend.
> 
> 
> Interface #1 could be possibly just replaced with the RTCTOSYS
> functionality. Although the downside there is that for some time at
> bootup between the timekeeping_init() function running (prior to
> interrupts being enabled) and the RTC driver being available (after
> interrupts are enabled), where we'd have an incorrect system clock.
> So we may want to preserve something like the existing
> read_persistent_clock() interface, but as Jason suggested, we could
> push that access into the RTC driver itself.

One case is one platform need a minimum size of kernel, which only
needs to use the read_persistent_clock for time init, and chose
to not compile in the "drivers/rtc/". So I think read_persistent_clock()
is needed anyway to remove the dependency over the rtc system.

IIRC, some EFI backed x86 system's read_persistent_clock() is
implemented by EFI's runtime gettime service.

> 
> Interface #2 could then be either RTC based, or countinuous counter
> based. Since we still want to do this measurement with interrupts
> off, we still would need that interrupt-free RTC method like
> read_persistent_clock() where supported (falling back to the RTC
> driver's suspend/resume handler to try to fix things up as best it
> can if that's not available).

Do you mean to create a new function and not embed the suspend/hibernate
time compensation code inside timekeeping_suspend/resume()?

> There is still plenty of ugly details as to how interface #2 would
> work. Since it could return something as coarse as seconds, or it
> could provide nanosecond granularity, you probably want to return a
> timespec that we'd capture at suspend and resume, and calculate the

Yes, we should keep to use the timespec way in current code.

> delta of. However, in order to properly provide a timespec from a
> raw TSC counter, you need to be careful with the math to avoid
> overflows as TSC counter value grows (take a look at the sched_clock
> code). Also whatever function backs this would need to have the
> logic to know when to use the TSC counter vs falling back to the RTC
> in the case where we're actually able to go into S4.

Thanks for the hint, will study the sched_clock code. And yes, how
to tell s2ram or s2disk remains a tough task.

Thanks,
Feng
 
