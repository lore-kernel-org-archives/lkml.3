Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587Ab3EMXv0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 19:51:26 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:41845 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461Ab3EMXvY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 19:51:24 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Nishanth Menon <nm@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Kevin Hilman <khilman@deeprootsystems.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1368039976-29648-2-git-send-email-nm@ti.com>
Cc: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Nishanth Menon <nm@ti.com>, Paul Walmsley <paul@pwsan.com>
References: <1368039976-29648-1-git-send-email-nm@ti.com>
 <1368039976-29648-2-git-send-email-nm@ti.com>
Message-ID: <20130513235119.10068.47040@quantum>
User-Agent: alot/0.3.4
Subject: Re: [PATCH V5 1/6] clk: OMAP: introduce device tree binding to kernel clock
 data
Date: Mon, 13 May 2013 16:51:19 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Nishanth Menon (2013-05-08 12:06:11)
<snip>
> Overall strategy introduced here is simple: a clock node described in
> device tree blob is used to identify the exact clock provided in the
> SoC specific data. This is then linked back using of_clk_add_provider
> to the device node to be accessible by of_clk_get.
> 

FYI, I'm working on moving the OMAP clocks over to DT which is a better
alternative than this patch.  I'll share what I have on the list,
hopefully next week.

Regards,
Mike

> Based on discussion contributions from Roger Quadros, Grygorii Strashko
> and others.
> 
> Cc: Kevin Hilman <khilman@deeprootsystems.com>
> Cc: Mike Turquette <mturquette@linaro.org>
> Cc: Paul Walmsley <paul@pwsan.com>
> [tony@atomide.com: co-developed]
> Signed-off-by: Tony Lindgren <tony@atomide.com>
> Signed-off-by: Nishanth Menon <nm@ti.com>
> ---
> Changes in this version:
>         - review comments incorporated.
> Previous version of this patch was discussed in:
>         http://marc.info/?t=136580758500001&r=1&w=2
> 
>  .../devicetree/bindings/clock/omap-clock.txt       |   40 +++++++++
>  drivers/clk/Makefile                               |    1 +
>  drivers/clk/omap/Makefile                          |    1 +
>  drivers/clk/omap/clk.c                             |   91 ++++++++++++++++++++
>  4 files changed, 133 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/clock/omap-clock.txt
>  create mode 100644 drivers/clk/omap/Makefile
>  create mode 100644 drivers/clk/omap/clk.c
> 
> diff --git a/Documentation/devicetree/bindings/clock/omap-clock.txt b/Documentation/devicetree/bindings/clock/omap-clock.txt
> new file mode 100644
> index 0000000..047c1e7
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/clock/omap-clock.txt
> @@ -0,0 +1,40 @@
> +Device Tree Clock bindings for Texas Instrument's OMAP compatible platforms
> +
> +This binding is an initial minimal binding that may be enhanced as part of
> +transitioning OMAP clock data out of kernel image.
> +
> +This binding uses the common clock binding[1].
> +
> +[1] Documentation/devicetree/bindings/clock/clock-bindings.txt
> +
> +Required properties:
> +- compatible : shall be "ti,omap-clock"
> +- #clock-cells : from common clock binding; shall be set to 0.
> +NOTE:
> +node name should map to clock database in arch/arm/mach-omap2/cclock<SoC>_data.c
> +Since all clocks are described with _ck, the node name is optimized to drop the
> +usage of _ck. For example, a clock called dpll1_ck will be defined as dpll1.
> +
> +Example #1: describing clock node for CPU on OMAP34xx platform:
> +Ref: arch/arm/mach-omap2/cclock3xxx_data.c
> +describes the CPU clock to be as follows
> +       CLK(NULL,       "dpll1_ck",     &dpll1_ck,      CK_3XXX),
> +Corresponding binding will be:
> +       dpll1: dpll1 {
> +               #clock-cells = <0>;
> +               compatible = "ti,omap-clock";
> +       };
> +And it's usage will be:
> +               clocks = <&dpll1>;
> +
> +Example #2: describing clock node for auxilary clock #3 on OMAP443x platform:
> +Ref: arch/arm/mach-omap2/cclock44xx_data.c
> +describes the auxclk3 clock to be as follows:
> +       CLK(NULL,       "auxclk3_ck",   &auxclk3_ck,    CK_443X),
> +Corresponding binding will be:
> +       auxclk3: auxclk3 {
> +               #clock-cells = <0>;
> +               compatible = "ti,omap-clock";
> +       };
> +And it's usage will be:
> +       clocks = <&auxclk3>;
> diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
> index 137d3e7..1d5a2ec 100644
> --- a/drivers/clk/Makefile
> +++ b/drivers/clk/Makefile
> @@ -30,6 +30,7 @@ obj-$(CONFIG_ARCH_VT8500)     += clk-vt8500.o
>  obj-$(CONFIG_ARCH_ZYNQ)                += clk-zynq.o
>  obj-$(CONFIG_ARCH_TEGRA)       += tegra/
>  obj-$(CONFIG_PLAT_SAMSUNG)     += samsung/
> +obj-$(CONFIG_ARCH_OMAP)                += omap/
>  
>  obj-$(CONFIG_X86)              += x86/
>  
> diff --git a/drivers/clk/omap/Makefile b/drivers/clk/omap/Makefile
> new file mode 100644
> index 0000000..8195931
> --- /dev/null
> +++ b/drivers/clk/omap/Makefile
> @@ -0,0 +1 @@
> +obj-y                                  += clk.o
> diff --git a/drivers/clk/omap/clk.c b/drivers/clk/omap/clk.c
> new file mode 100644
> index 0000000..5a3c6d9
> --- /dev/null
> +++ b/drivers/clk/omap/clk.c
> @@ -0,0 +1,91 @@
> +/*
> + * Texas Instruments OMAP Clock driver
> + *
> + * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com/
> + *     Nishanth Menon <nm@ti.com>
> + *     Tony Lindgren <tony@atomide.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
> + * kind, whether express or implied; without even the implied warranty
> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/clkdev.h>
> +#include <linux/clk-provider.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of_device.h>
> +#include <linux/platform_device.h>
> +#include <linux/string.h>
> +
> +static const struct of_device_id omap_clk_of_match[] = {
> +       {.compatible = "ti,omap-clock",},
> +       {},
> +};
> +
> +/**
> + * omap_clk_src_get() - Get OMAP clock from node name when needed
> + * @clkspec:   clkspec argument
> + * @data:      unused
> + *
> + * REVISIT: We assume the following:
> + * 1. omap clock names end with _ck
> + * 2. omap clock names are under 32 characters in length
> + */
> +static struct clk *omap_clk_src_get(struct of_phandle_args *clkspec, void *data)
> +{
> +       struct clk *clk;
> +       char clk_name[32];
> +       struct device_node *np = clkspec->np;
> +
> +       snprintf(clk_name, 32, "%s_ck", np->name);
> +       clk = clk_get(NULL, clk_name);
> +       if (IS_ERR(clk))
> +               pr_err("%s: could not get clock %s(%ld)\n", __func__,
> +                      clk_name, PTR_ERR(clk));
> +
> +       return clk;
> +}
> +
> +/**
> + * omap_clk_probe() - create link from DT definition to clock data
> + * @pdev:      device node
> + *
> + * NOTE: we look up the clock lazily when the consumer driver does
> + * of_clk_get() and initialize a NULL clock here.
> + */
> +static int omap_clk_probe(struct platform_device *pdev)
> +{
> +       int res;
> +       struct device_node *np = pdev->dev.of_node;
> +
> +       /* This allows the driver to of_clk_get() */
> +       res = of_clk_add_provider(np, omap_clk_src_get, NULL);
> +       if (res)
> +               dev_err(&pdev->dev, "could not add provider(%d)\n", res);
> +
> +       return res;
> +}
> +
> +static struct platform_driver omap_clk_driver = {
> +       .probe = omap_clk_probe,
> +       .driver = {
> +                  .name = "omap_clk",
> +                  .of_match_table = of_match_ptr(omap_clk_of_match),
> +                  },
> +};
> +
> +static int __init omap_clk_init(void)
> +{
> +       return platform_driver_register(&omap_clk_driver);
> +}
> +arch_initcall(omap_clk_init);
> +
> +MODULE_DESCRIPTION("OMAP Clock driver");
> +MODULE_AUTHOR("Texas Instruments Inc.");
> +MODULE_LICENSE("GPL v2");
> -- 
> 1.7.9.5
