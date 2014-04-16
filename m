Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161451AbaDPOWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 10:22:18 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:38917 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756307AbaDPOWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 10:22:16 -0400
Message-ID: <1397658125.3407.84.camel@hornet>
Subject: Re: [PATCH 04/12] clocksource: Sched clock source for Versatile
 Express
From: Pawel Moll <pawel.moll@arm.com>
To: Rob Herring <robherring2@gmail.com>
Cc: "arm@kernel.org" <arm@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Date: Wed, 16 Apr 2014 15:22:05 +0100
In-Reply-To: <CAL_JsqLiFE_D+PSFg62sVm3wO0uvZT+pwAVyn7Lwn2ma3+3DoA@mail.gmail.com>
References: <1392138636-29240-1-git-send-email-pawel.moll@arm.com>
	 <1392138636-29240-5-git-send-email-pawel.moll@arm.com>
	 <CAL_JsqLiFE_D+PSFg62sVm3wO0uvZT+pwAVyn7Lwn2ma3+3DoA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,

Thanks for reminding me about this stuff. I'll get around and re-spin
the series this week.

On Wed, 2014-04-16 at 14:56 +0100, Rob Herring wrote:
> > diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
> > index cd6950f..9799744 100644
> > --- a/drivers/clocksource/Kconfig
> > +++ b/drivers/clocksource/Kconfig
> > @@ -140,3 +140,12 @@ config VF_PIT_TIMER
> >         bool
> >         help
> >           Support for Period Interrupt Timer on Freescale Vybrid Family SoCs.
> > +
> > +config CLKSRC_VEXPRESS
> > +       bool
> > +       depends on MFD_VEXPRESS_SYSREG
> 
> But you don't really depend on this...

Hm. Strictly speaking it's true (no code level dependency) but if one
doesn't build sysreg driver, one doesn't care 

> > +       depends on GENERIC_SCHED_CLOCK
> 
> I think this should be a select, not a depends.

Don't think so, no. It's being selected by an arch. 

> > +       select CLKSRC_OF
> > +       default y
> > +       help
> > +         Simple provider of sched clock on ARM Versatile Express platform.
> > diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
> > index c7ca50a..1051a23 100644
> > --- a/drivers/clocksource/Makefile
> > +++ b/drivers/clocksource/Makefile
> > @@ -37,3 +37,4 @@ obj-$(CONFIG_ARM_ARCH_TIMER)          += arm_arch_timer.o
> >  obj-$(CONFIG_ARM_GLOBAL_TIMER)         += arm_global_timer.o
> >  obj-$(CONFIG_CLKSRC_METAG_GENERIC)     += metag_generic.o
> >  obj-$(CONFIG_ARCH_HAS_TICK_BROADCAST)  += dummy_timer.o
> > +obj-$(CONFIG_CLKSRC_VEXPRESS)  += vexpress.o
> > diff --git a/drivers/clocksource/vexpress.c b/drivers/clocksource/vexpress.c
> > new file mode 100644
> > index 0000000..55b8ab4
> > --- /dev/null
> > +++ b/drivers/clocksource/vexpress.c
> > @@ -0,0 +1,40 @@
> > +/*
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * Copyright (C) 2013 ARM Limited
> 
> Did you write this last year?

Yes. Can bump it up anyway.

> > + */
> > +
> > +#include <linux/clocksource.h>
> > +#include <linux/io.h>
> > +#include <linux/of_address.h>
> > +#include <linux/sched_clock.h>
> > +
> > +#define SYS_24MHZ 0x05c
> > +
> > +static void __iomem *vexpress_sys_24mhz;
> > +
> > +static u32 notrace vexpress_sys_24mhz_read(void)
> > +{
> > +       return readl(vexpress_sys_24mhz);
> > +}
> > +
> > +static void __init vexpress_sched_clock_init(struct device_node *node)
> > +{
> > +       void __iomem *base = of_iomap(node, 0);
> > +
> > +       if (!base)
> > +               return;
> > +
> > +       vexpress_sys_24mhz = base + SYS_24MHZ;
> > +
> > +       setup_sched_clock(vexpress_sys_24mhz_read, 32, 24000000);
> 
> This frequency should come from a DT clock binding. You will have to
> fallback to 24MHz for backwards compatibility though.

I don't see why would it go to the binding. You may have noticed the
register is called "SYS_24MHZ", not "SYS_RANDOMCLOCK". The driver
*knows* what the frequency is.

> > +}
> 
> Wouldn't this code work for Versatile and Realview ARM reference
> boards? Even the register offset is the same.
> 
> > +CLOCKSOURCE_OF_DECLARE(vexpress, "arm,vexpress-sysreg",
> > +               vexpress_sched_clock_init);

I guess it would, yes. The sysregs are annoyingly similar and different
at the same time.

One could of course try to come up with a "generic mmio clock source"
binding, taking the frequency as a property, but don't count on me doing
this... ;-)

Pawel

