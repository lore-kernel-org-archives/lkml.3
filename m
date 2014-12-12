Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758760AbaLLCNh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 21:13:37 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:49046 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758641AbaLLCNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 21:13:34 -0500
Date: Fri, 12 Dec 2014 02:13:31 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Thierry Reding <treding@nvidia.com>
cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-tegra@vger.kernel.org, Allen Martin <amartin@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] clocksource: tegra: wrap arch/arm-specific sections in
 CONFIG_ARM
In-Reply-To: <20141210111425.GD15287@ulmo.nvidia.com>
Message-ID: <alpine.DEB.2.02.1412112206120.29716@utopia.booyaka.com>
References: <alpine.DEB.2.02.1412092201200.31750@utopia.booyaka.com> <20141210111425.GD15287@ulmo.nvidia.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ lakml

Hello Thierry

On Wed, 10 Dec 2014, Thierry Reding wrote:

> On Tue, Dec 09, 2014 at 10:07:18PM +0000, Paul Walmsley wrote:
> > 
> > Like several of the other files in drivers/clocksource,
> > tegra20_timer.c contains code that can only compile when CONFIG_ARM is
> > enabled.  This causes obvious problems when trying to compile this
> > code for NVIDIA ARM64-based SoCs, such as Tegra132.  The same timer IP
> > blocks exist, so it seems appropriate to provide support for them.
> > 
> > So until we figure out a better way to partition this code, wrap the
> > delay_timer and persistent_clock support code with preprocessor tests
> > for CONFIG_ARM.  (The delay_timer code should not be needed at all on
> > ARM64 due to the presence of the ARMv8 architected timer.  The
> > persistent_clock support code could become important once power
> > management modes are implemented that turn off the CPU complex.)
> > 
> > Signed-off-by: Paul Walmsley <paul@pwsan.com>
> > Signed-off-by: Paul Walmsley <pwalmsley@nvidia.com>
> > Cc: Allen Martin <amartin@nvidia.com>
> > Cc: Stephen Warren <swarren@nvidia.com>
> > Cc: Thierry Reding <treding@nvidia.com>
> > Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Alexandre Courbot <gnurou@gmail.com>
> > ---
> > Applies against next-20141209.
> > Intended for v3.20.
> > Boot-tested on Tegra124 Jetson TK1 on next-20141209.
> > Also boot-tested on Tegra132 Norrin FFD on next-20141209 + extra, 
> > unrelated patches.
> > 
> >  drivers/clocksource/tegra20_timer.c | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> 
> You might want to read the following thread:
> 
> 	https://lkml.org/lkml/2014/11/7/605

Thanks for the link, I hadn't seen that discussion.

> I haven't gotten around to look at this in detail, but it seems like we
> may not need to register the RTC early here at all. If that's really the
> case we can just get rid of this hackery and do everything within the
> RTC driver rather than duplicate some of that code here.

I'd suggest that we keep that project separate from just getting this file 
to compile on ARM64.

Broadly speaking, I agree that tegra20_timer.c needs to be cleaned up; it 
should not mix code for two distinct IP blocks into one driver.

> On 32-bit ARM, Tegra114 and Tegra124 also support the architected timer,
> so the only remaining issue would be for Tegra20 and Tegra30 hardware.

I believe on most NVIDIA chips (and probably most ARM SoCs) the ARM 
architected timer is only usable as a clockevent timer when the CPU 
doesn't enter deep low power states.  So the architected timer won't be 
enough.

> But I also seem to remember that on most boards the Tegra RTC can't be
> used properly because it doesn't have a battery. So while it may still
> work while the board is powered it is not very useful as RTC. Or for
> timekeeping across suspend/resume for that matter. The majority of
> boards seem to have a PMIC with an integrated RTC and will use that
> instead.

>From my point of view, the Tegra RTC IP block's primary use case is to 
provide an always-on clockevent to wake the system from SC7 (aka LP0 
idle)[1].  In SC7, the ARM architected timer comparator logic and Tegra 
TMR IP blocks will be power-gated, and thus can't wake the system.

PMIC RTC timers are generally a bad fit for this purpose, since they tend 
to be low-resolution (+/- 1 second) and slow to program (via some slow 
serial bus).  They are good for keeping calendars, though...

> Otherwise this looks good to me to get things going on 64-bit ARM while
> we iron out the other issues. Can I assume that you plan on sending in
> patches that enable 64-bit ARM Tegra in the 3.20 timeframe? If so it
> might be best to take this patch through the Tegra tree, provided that
> Daniel and Thomas have no objections, to make sure we don't have
> intermittent build breakage depending on the order in which the trees
> get pulled into linux-next and Linus' tree. Even more so because there
> are a couple of other, similar patches which makes a stable branches
> oriented approach to resolving these dependencies somewhat impractical.

Given the rather small number of mainline T132 users, I'll probably just 
send these patches up via their corresponding trees and let them merge via 
their respective maintainers.  That keeps the risk of merge conflicts low. 
At this point I don't think there will be any significant dependency 
problems.

- Paul

1. Section 11.0 "Real-time Clock" of the _NVIDIA Tegra K1 Mobile Processor
   Technical Reference Manual v03p (DP-06905-001_v03p)_, 
   https://developer.nvidia.com/tegra-k1-technical-reference-manual

