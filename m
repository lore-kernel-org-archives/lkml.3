Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941AbaEHUxo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 16:53:44 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:41188 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755554AbaEHUxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 16:53:43 -0400
Date: Thu, 8 May 2014 21:52:23 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Doug Anderson <dianders@chromium.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Will Deacon <will.deacon@arm.com>,
        John Stultz <john.stultz@linaro.org>,
        David Riley <davidriley@chromium.org>,
        "olof@lixom.net" <olof@lixom.net>, Sonny Rao <sonnyrao@chromium.org>,
        Richard Zhao <richard.zhao@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Shawn Guo <shawn.guo@linaro.org>, Stephen Boyd <sboyd@codeaurora.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Stephen Warren <swarren@nvidia.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: Don't ever downscale loops_per_jiffy in SMP
	systems
Message-ID: <20140508205223.GI3693@n2100.arm.linux.org.uk>
References: <1399504982-31181-1-git-send-email-dianders@chromium.org> <CAOh2x=kwaoSdj8JO0Vo08Y0dX2UfKFiF3pBV-qtp-YTyN=8H8Q@mail.gmail.com> <CAD=FV=UEGJGHrdcXgs3EZ_wFXT8GnNeCOMt7CgdiiUzBzZ5Y0A@mail.gmail.com> <alpine.LFD.2.11.1405081149190.980@knanqh.ubzr> <CAD=FV=VtcLOh51LCmafzRMdqtDrwKXCqK6gE6V7OOOUe4gjwbA@mail.gmail.com> <alpine.LFD.2.11.1405081329010.980@knanqh.ubzr> <20140508192209.GH3693@n2100.arm.linux.org.uk> <alpine.LFD.2.11.1405081600260.980@knanqh.ubzr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.11.1405081600260.980@knanqh.ubzr>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2014 at 04:12:14PM -0400, Nicolas Pitre wrote:
> On Thu, 8 May 2014, Russell King - ARM Linux wrote:
> 
> > Anything which is expecting precise timings from udelay() is broken.
> > Firstly, udelay() does _not_ guarantee to give you a delay of at least
> > the requested period - it tries to give an _approximate_ delay.
> > 
> > The first thing to realise is that loops_per_jiffy is calibrated with
> > interrupts _on_, which means that the calculated loops_per_jiffy is
> > the number of iterations in a jiffy _minus_ the time it takes for the
> > timer interrupt to be processed.  This means loops_per_jiffy will
> > always be smaller than the number of loops that would be executed
> > within the same period.
> > 
> > This leads to udelay() always producing slightly shorter than
> > requested delays - this is quite measurable.
> 
> OK, this is certainly bad.  Hopefully it won't be that far off like it 
> would when the CPU is in the middle of a clock freq transition.

It depends on the system, but my point is that assumption that udelay()
gives a delay of at least the requested time is something that is false,
and has *always* been false.

It's not "broken" either - it's just how the thing works, and the "fix"
for it is to use a timer based implementation which isn't affected by
interrupts.

> > So, the only /real/ solution if you want proper delays is for udelay()
> > to use a timer or counter, and this is should always the preferred
> > method where it's available.  Quite rightly, we're not hacking udelay()
> > stuff to work around not having that, or if someone configures it out.
> 
> What about using a default based on ktime_get(), or even sched_clock(), 
> when SMP and cpufreq are configured in?

I see no reason to play those kinds of games.  Keep the message simple.
If you're in a preempt or SMP environment, provide a timer for udelay().
IF you're in an environment with IRQs which can take a long time, use
a timer for udelay().  If you're in an environment where the CPU clock
can change unexpectedly, use a timer for udelay().

The very last thing we want to do is to sit around doing expensive calls
into various time keeping code which themselves add conversion on top,
which then end up making udelay() latency even worse than the loop-based
versions on slower machines.

So... the message is nice and simple: where possible, use a timer for
udelay().

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
