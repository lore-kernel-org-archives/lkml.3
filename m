Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161374AbaDPN4r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 09:56:47 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:49099 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161077AbaDPN4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 09:56:45 -0400
MIME-Version: 1.0
In-Reply-To: <1392138636-29240-5-git-send-email-pawel.moll@arm.com>
References: <1392138636-29240-1-git-send-email-pawel.moll@arm.com>
	<1392138636-29240-5-git-send-email-pawel.moll@arm.com>
Date: Wed, 16 Apr 2014 08:56:45 -0500
Message-ID: <CAL_JsqLiFE_D+PSFg62sVm3wO0uvZT+pwAVyn7Lwn2ma3+3DoA@mail.gmail.com>
Subject: Re: [PATCH 04/12] clocksource: Sched clock source for Versatile Express
From: Rob Herring <robherring2@gmail.com>
To: Pawel Moll <pawel.moll@arm.com>
Cc: "arm@kernel.org" <arm@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding Linus W...

On Tue, Feb 11, 2014 at 11:10 AM, Pawel Moll <pawel.moll@arm.com> wrote:
> This patch adds a trival sched clock source using free
> running, 24MHz clocked counter present in the ARM Ltd.
> Versatile Express platform's System Registers block.
>
> This code replaces the call in the VE machine code.
>
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Pawel Moll <pawel.moll@arm.com>
> ---
>  arch/arm/mach-vexpress/v2m.c   |  2 --
>  drivers/clocksource/Kconfig    |  9 +++++++++
>  drivers/clocksource/Makefile   |  1 +
>  drivers/clocksource/vexpress.c | 40 ++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 50 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/clocksource/vexpress.c
>
> diff --git a/arch/arm/mach-vexpress/v2m.c b/arch/arm/mach-vexpress/v2m.c
> index 90f04c9..d8a9fd7 100644
> --- a/arch/arm/mach-vexpress/v2m.c
> +++ b/arch/arm/mach-vexpress/v2m.c
> @@ -418,8 +418,6 @@ void __init v2m_dt_init_early(void)
>                         pr_warning("vexpress: DT HBI (%x) is not matching "
>                                         "hardware (%x)!\n", dt_hbi, hbi);
>         }
> -
> -       versatile_sched_clock_init(vexpress_get_24mhz_clock_base(), 24000000);
>  }
>
>
> diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
> index cd6950f..9799744 100644
> --- a/drivers/clocksource/Kconfig
> +++ b/drivers/clocksource/Kconfig
> @@ -140,3 +140,12 @@ config VF_PIT_TIMER
>         bool
>         help
>           Support for Period Interrupt Timer on Freescale Vybrid Family SoCs.
> +
> +config CLKSRC_VEXPRESS
> +       bool
> +       depends on MFD_VEXPRESS_SYSREG

But you don't really depend on this...

> +       depends on GENERIC_SCHED_CLOCK

I think this should be a select, not a depends.

> +       select CLKSRC_OF
> +       default y
> +       help
> +         Simple provider of sched clock on ARM Versatile Express platform.
> diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
> index c7ca50a..1051a23 100644
> --- a/drivers/clocksource/Makefile
> +++ b/drivers/clocksource/Makefile
> @@ -37,3 +37,4 @@ obj-$(CONFIG_ARM_ARCH_TIMER)          += arm_arch_timer.o
>  obj-$(CONFIG_ARM_GLOBAL_TIMER)         += arm_global_timer.o
>  obj-$(CONFIG_CLKSRC_METAG_GENERIC)     += metag_generic.o
>  obj-$(CONFIG_ARCH_HAS_TICK_BROADCAST)  += dummy_timer.o
> +obj-$(CONFIG_CLKSRC_VEXPRESS)  += vexpress.o
> diff --git a/drivers/clocksource/vexpress.c b/drivers/clocksource/vexpress.c
> new file mode 100644
> index 0000000..55b8ab4
> --- /dev/null
> +++ b/drivers/clocksource/vexpress.c
> @@ -0,0 +1,40 @@
> +/*
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * Copyright (C) 2013 ARM Limited

Did you write this last year?

> + */
> +
> +#include <linux/clocksource.h>
> +#include <linux/io.h>
> +#include <linux/of_address.h>
> +#include <linux/sched_clock.h>
> +
> +#define SYS_24MHZ 0x05c
> +
> +static void __iomem *vexpress_sys_24mhz;
> +
> +static u32 notrace vexpress_sys_24mhz_read(void)
> +{
> +       return readl(vexpress_sys_24mhz);
> +}
> +
> +static void __init vexpress_sched_clock_init(struct device_node *node)
> +{
> +       void __iomem *base = of_iomap(node, 0);
> +
> +       if (!base)
> +               return;
> +
> +       vexpress_sys_24mhz = base + SYS_24MHZ;
> +
> +       setup_sched_clock(vexpress_sys_24mhz_read, 32, 24000000);

This frequency should come from a DT clock binding. You will have to
fallback to 24MHz for backwards compatibility though.

> +}

Wouldn't this code work for Versatile and Realview ARM reference
boards? Even the register offset is the same.

> +CLOCKSOURCE_OF_DECLARE(vexpress, "arm,vexpress-sysreg",
> +               vexpress_sched_clock_init);
> --
> 1.8.3.2
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
