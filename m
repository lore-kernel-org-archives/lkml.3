Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604Ab3AVT5N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 14:57:13 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:60732 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753899Ab3AVT5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 14:57:09 -0500
Date: Tue, 22 Jan 2013 12:57:01 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Feng Tang <feng.tang@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@linux.intel.com>,
        x86@kernel.org, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] Add support for S3 non-stop TSC support.
Message-ID: <20130122195701.GH30647@obsidianresearch.com>
References: <1358750325-21217-1-git-send-email-feng.tang@intel.com>
 <50FD8D07.5030908@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50FD8D07.5030908@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 10:46:31AM -0800, John Stultz wrote:
 
> What I'd propose is that we break the read_persistent_clock()
> functionality up. So we need two interfaces:
> 1) An interface to access a time value we used to initialize the
> system's CLOCK_REALTIME time.
> 2) An interface to measure the length of suspend.

> Interface #1 could be possibly just replaced with the RTCTOSYS
> functionality. Although the downside there is that for some time at
> bootup between the timekeeping_init() function running (prior to
> interrupts being enabled) and the RTC driver being available (after
> interrupts are enabled), where we'd have an incorrect system clock.
> So we may want to preserve something like the existing
> read_persistent_clock() interface, but as Jason suggested, we could
> push that access into the RTC driver itself.

How big of an issue is this? Could the RTCTOSYS function be moved to
the moment the RTC driver is registered rather than using a
late_initcall?
 
> Interface #2 could then be either RTC based, or countinuous counter
> based. Since we still want to do this measurement with interrupts
> off, we still would need that interrupt-free RTC method like
> read_persistent_clock() where supported (falling back to the RTC
> driver's suspend/resume handler to try to fix things up as best it
> can if that's not available).

Could the counter version of this be bundled into the clocksource
framework? It already has generic APIs for handling cycle counters and
things. Isn't there a TSC driver for clocksource already? Is all that
is missing is a way to tell if the counter survived suspend?

clocksource already has suspend/resume callbacks stuff, so the counter
driver could sense if the sleep was too deep and mark itself as
invalid.

This would help solve the problem on ARM with muxing persistent clock
on multi-platform.

A RTC device flag 'readable with interrupts off' still seems like a
good idea for the RTC case..

Cheers,
Jason
