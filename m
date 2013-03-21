Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756936Ab3CULGx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 07:06:53 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:39165 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755911Ab3CULGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 07:06:50 -0400
Date: Thu, 21 Mar 2013 11:06:47 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Rob Herring <robherring2@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Simon Horman <horms@verge.net.au>,
        John Stultz <john.stultz@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] ARM: convert arm/arm64 arch timer to use CLKSRC_OF init
Message-ID: <20130321110646.GE15279@e106331-lin.cambridge.arm.com>
References: <1363818875-15978-1-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363818875-15978-1-git-send-email-robherring2@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,

(adding Marc to Cc as he may have comments).

On Wed, Mar 20, 2013 at 10:34:35PM +0000, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> This converts arm and arm64 to use CLKSRC_OF DT based initialization for
> the arch timer. A new function arch_timer_arch_init is added to allow for
> arch specific setup.
> 
> This has a side effect of enabling sched_clock on omap5 and exynos5. There
> should not be any reason not to use the arch timers for sched_clock.

Nice! I was just about to post a (slightly updated) version of Thomas Abraham's
arch_timer clocksource_of_init patch, but this seems much more comprehensive.

I have some other arch_timer patches which may clash, but they could be rebased
atop of this.

> 
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Kukjin Kim <kgene.kim@samsung.com>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Simon Horman <horms@verge.net.au>
> Cc: Magnus Damm <magnus.damm@gmail.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: linux-samsung-soc@vger.kernel.org
> Cc: linux-omap@vger.kernel.org
> Cc: linux-sh@vger.kernel.org
> ---
> This is dependent on my CLKSRC_OF clean-up in arm-soc, my 64-bit sched_clock
> support series, and Arnd's default machine descriptor patch (for default
> clocksource_of_init call). This is only compile tested on arm.
> 
> The full series (including sp804 work) is available here:
> git://sources.calxeda.com/kernel/linux.git arm-timers
> 
> Rob
> 

[...]

> diff --git a/arch/arm/mach-vexpress/v2m.c b/arch/arm/mach-vexpress/v2m.c
> index d0ad789..6215717 100644
> --- a/arch/arm/mach-vexpress/v2m.c
> +++ b/arch/arm/mach-vexpress/v2m.c
> @@ -1,6 +1,7 @@
>  /*
>   * Versatile Express V2M Motherboard Support
>   */
> +#include <linux/clocksource.h>
>  #include <linux/device.h>
>  #include <linux/amba/bus.h>
>  #include <linux/amba/mmci.h>
> @@ -23,7 +24,6 @@
>  #include <linux/regulator/machine.h>
>  #include <linux/vexpress.h>
> 
> -#include <asm/arch_timer.h>
>  #include <asm/mach-types.h>
>  #include <asm/sizes.h>
>  #include <asm/mach/arch.h>
> @@ -446,10 +446,7 @@ static void __init v2m_dt_timer_init(void)
>                                 irq_of_parse_and_map(node, 0));
>         }
> 
> -       arch_timer_of_register();
> -
> -       if (arch_timer_sched_clock_init() != 0)
> -               versatile_sched_clock_init(vexpress_get_24mhz_clock_base(),
> +       versatile_sched_clock_init(vexpress_get_24mhz_clock_base(),
>                                 24000000);
>  }
> 

On TC2 this series leads to using the vexpress 24MHz clock as the sched clock
in preference to the architected timer:

  Architected local timer running at 24.00MHz (virt).
  Switching to timer-based delay loop
  Registered arch_counter_get_cntvct+0x0/0x14 as sched_clock source
  sched_clock: 32 bits at 24MHz, resolution 41ns, wraps every 178956ms
  Registered versatile_read_sched_clock+0x0/0x28 as sched_clock source

As they both have the same frequency, neither overrides the other, and
whichever gets registered last is used as the sched_clock. As accesses to the
architected timer are going to have a much lower overhead, this isn't very nice
(and it could be better to use it even if it had a lower frequency).

We could move the versatile_sched_clock_init call before the
clocksource_of_init, but that doesn't feel like an ideal solution. We may have
similar problems elsewhere.

[...]

> diff --git a/arch/arm64/kernel/time.c b/arch/arm64/kernel/time.c
> index b0ef18d..a551f88 100644
> --- a/arch/arm64/kernel/time.c
> +++ b/arch/arm64/kernel/time.c
> @@ -32,6 +32,7 @@
>  #include <linux/timer.h>
>  #include <linux/irq.h>
>  #include <linux/delay.h>
> +#include <linux/clocksource.h>
> 
>  #include <clocksource/arm_arch_timer.h>
> 
> @@ -77,10 +78,11 @@ void __init time_init(void)
>  {
>         u32 arch_timer_rate;
> 
> -       if (arch_timer_init())
> -               panic("Unable to initialise architected timer.\n");
> +       clocksource_of_init();
> 
>         arch_timer_rate = arch_timer_get_rate();
> +       if (!arch_timer_rate)
> +               panic("Unable to initialise architected timer.\n");
> 
>         /* Cache the sched_clock multiplier to save a divide in the hot path. */
>         sched_clock_mult = NSEC_PER_SEC / arch_timer_rate;
> diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
> index e507ab7..d98e7e1 100644
> --- a/drivers/clocksource/Kconfig
> +++ b/drivers/clocksource/Kconfig
> @@ -62,6 +62,7 @@ config CLKSRC_DBX500_PRCMU_SCHED_CLOCK
> 
>  config ARM_ARCH_TIMER
>         bool
> +       select CLKSRC_OF if OF
> 
>  config CLKSRC_METAG_GENERIC
>         def_bool y if METAG

[...]

> diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
> index d7ad425..afb70aa 100644
> --- a/drivers/clocksource/arm_arch_timer.c
> +++ b/drivers/clocksource/arm_arch_timer.c
> @@ -337,24 +337,11 @@ out:
>         return err;
>  }
> 
> -static const struct of_device_id arch_timer_of_match[] __initconst = {
> -       { .compatible   = "arm,armv7-timer",    },
> -       { .compatible   = "arm,armv8-timer",    },
> -       {},
> -};
> -
> -int __init arch_timer_init(void)
> +static void __init arch_timer_init(struct device_node *np)
>  {
> -       struct device_node *np;
>         u32 freq;
>         int i;
> 

If we the following here:

	if (arch_timer_get_rate()) {
		pr_warn("arch_timer: multiple nodes in dt, skipping\n");
		return;
	}

We may save ourselves a whole world of pain with dts which (erroneously) have
multiple timer nodes (though these are now disappearing). Otherwise we could
have a memory leak and multiple instances of the cpu0 timer registered, which
could lead to all sorts of weirdness. The existing code side-steps this issue
by only grabbing the first node, so this would keep things consistent.

> -       np = of_find_matching_node(NULL, arch_timer_of_match);
> -       if (!np) {
> -               pr_err("arch_timer: can't find DT node\n");
> -               return -ENODEV;
> -       }
> -
>         /* Try to determine the frequency from the device tree or CNTFRQ */
>         if (!of_property_read_u32(np, "clock-frequency", &freq))
>                 arch_timer_rate = freq;

[...]

Thanks,
Mark.
