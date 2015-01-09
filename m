Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609AbbAICJ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 21:09:28 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:35126 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907AbbAICJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 21:09:27 -0500
Date: Fri, 9 Jan 2015 02:09:25 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-tegra@vger.kernel.org, Allen Martin <amartin@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Alexandre Courbot <gnurou@gmail.com>, pwalmsley@nvidia.com
Subject: Re: [PATCH] clocksource: tegra: wrap arch/arm-specific sections in
 CONFIG_ARM
In-Reply-To: <54AEB719.5060103@linaro.org>
Message-ID: <alpine.DEB.2.02.1501090135280.28771@utopia.booyaka.com>
References: <alpine.DEB.2.02.1412092201200.31750@utopia.booyaka.com> <54AEB719.5060103@linaro.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Content-ID: <alpine.DEB.2.02.1501090143282.28771@utopia.booyaka.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Daniel

On Thu, 8 Jan 2015, Daniel Lezcano wrote:

> On 12/09/2014 11:07 PM, Paul Walmsley wrote:
> > 
> > Like several of the other files in drivers/clocksource,
> > tegra20_timer.c contains code that can only compile when CONFIG_ARM is
> > enabled.  This causes obvious problems when trying to compile this
> > code for NVIDIA ARM64-based SoCs, such as Tegra132.  The same timer IP
> > blocks exist, so it seems appropriate to provide support for them.
> > 
> > So until we figure out a better way to partition this code, wrap the
> > delay_timer and persistent_clock support code with preprocessor tests
> > for CONFIG_ARM.
> >
> >  (The delay_timer code should not be needed at all on
> > ARM64 due to the presence of the ARMv8 architected timer.  The
> > persistent_clock support code could become important once power
> > management modes are implemented that turn off the CPU complex.)
> 
> IIUC, the cpuidle driver is not yet ready, right ?
> 
> If it is the case, this driver is not needed yet, no ?

The point of the patch is to allow the hardware drivers selected by 
CONFIG_ARCH_TEGRA to build for an arm64 kernel, just as they build for 
32-bit ARM.  

There's nothing CPUIdle-specific about the patch - that is, this timer can 
be selected as a clockevent and clocksource provider without the use of 
CPUIdle - although low-power PM idle is likely to be a primary use-case.

> Perhaps you can rework a bit this driver in the meantime to have a better fix
> than disabling the code with macros ?

I'm happy to do that, but it would be nice to get the driver compiling 
first for ARM64 :-)

> Otherwise, please try at least to group the code into a minimal set of macros.

So, would it be accurate to say that you would prefer a patch that changes 
more lines of code, but minimizes preprocessor directives, to the current 
patch?

> One comment below.

> > diff --git a/drivers/clocksource/tegra20_timer.c
> > b/drivers/clocksource/tegra20_timer.c
> > index d2616ef16770..83a8f5c9e139 100644
> > --- a/drivers/clocksource/tegra20_timer.c
> > +++ b/drivers/clocksource/tegra20_timer.c
> > @@ -29,8 +29,10 @@
> >   #include <linux/sched_clock.h>
> >   #include <linux/delay.h>
> > 
> > +#ifdef CONFIG_ARM
> >   #include <asm/mach/time.h>
> >   #include <asm/smp_twd.h>
> 
> Is smp_twd.h really needed ?
> 
> > +#endif

No, it can be removed.  

Would you be willing to ack or merge a revision of this patch with 

1. the #include <asm/smp_twd.h> removed

2. a larger number of changed lines, in order to minimize the number of 
new #ifdefs?




- Paul
