Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932214Ab3FVKOu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 06:14:50 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:47188 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534Ab3FVKOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 06:14:47 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Tomasz Figa <t.figa@samsung.com>, Marc Zyngier <marc.zyngier@arm.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Mark Brown <broonie@kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Benoit Cousson <benoit.cousson@linaro.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Jason Cooper <jason@lakedaemon.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nicolas Pitre <nico@fluxnic.net>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH v6 4/8] ARM: Add .init_platform() callback to machine descriptor
Date: Sat, 22 Jun 2013 12:14:44 +0200
Message-ID: <6564540.EvIEu9dlOG@flatron>
User-Agent: KMail/4.10.4 (Linux/3.9.6-gentoo; KDE/4.10.4; x86_64; ; )
In-Reply-To: <201306211612.15508.arnd@arndb.de>
References: <1371774924-9224-1-git-send-email-tomasz.figa@gmail.com> <72209947.cQvP4jsDBz@amdc1227> <201306211612.15508.arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 of June 2013 16:12:15 Arnd Bergmann wrote:
> On Friday 21 June 2013, Tomasz Figa wrote:
> > > To me, this new hook is strictly equivalent to init_irq. What do we
> > > gain exactly? I didn't think init_irq was going away...
> > > 
> > > I know init_irq is not pretty, and we tend to overload it with other
> > > stuff, but I don't really see the point of adding a new callback
> > > that
> > > has the exact same properties.
> > 
> > Well, it doesn't really give us any functional benefits.
> > 
> > However in my opinion it looks much saner in case of DT-only platforms
> > that don't need any specific IRQ initialization, but need to call
> > some platform specific initialization routines, after memory
> > management, but before anything else is initialized.
> > 
> > This way irqchip_init() doesn't have to be explicitly called in
> > platform code.
> > 
> > Anyway, I don't have any strong opinion on this. If it is perfectly
> > fine to abuse irqchip_init() for anything that must be done at this
> > stage of boot, then I'm fine with this either and will modify the
> > board file from further patch from this series to not rely on this
> > change any more.
> 
> Your init_platform only has these two calls in it:
> 
> +       of_clk_init(NULL);
> +       samsung_wdt_reset_of_init();
> 
> Presumably you need of_clk_init() for the watchdog to work.

Clock initialization is also required for timekeeping to work, so if we 
had to defer it, it must happen before (or inside) init_time().

Putting this platform aside, there might be other platforms which require 
clock initialization before IRQ initialization, e.g. to enable clock of an 
interrupt controller.

> But do you
> actually need to initialize the reset logic this early? Why not turn
> samsung_wdt_reset_of_init into a standalone driver, or call it from
> init_machine?

This is debatable. One might want to have reset support working as early 
as possible to have panic timeout working, but I'm not sure if there is 
any point of rebooting the machine if the kernel fails so early.

Personally I'd prefer this to be a separate driver, in 
drivers/power/reset/ or wherever appropriate, but I didn't want to change 
existing behavior too much, which was the reset working already after 
clock initialization.

> I would actually like to call of_clk_init from common code at some point
> between init_irq and init_time, although I'm not sure if some platforms
> need it to be called before init_irq.

Now as I think of it, some platforms might need it earlier, some later, so 
my init_platform(), which is not flexible at all, would be useless for 
some of them, that need such things done after init_irq().

I'm going to drop this patch from this series (and simply abuse one of 
existing callbacks instead), but we should think about a better solution 
for this issue.

Best regards,
Tomasz

> 	Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-samsung-soc" in the body of a message to
> majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
