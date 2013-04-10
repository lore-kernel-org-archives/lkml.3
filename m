Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155Ab3DJSt2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 14:49:28 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:40592 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab3DJSt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 14:49:26 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19pTtZXhjuksucc3XoQUzWU
Date: Wed, 10 Apr 2013 11:49:20 -0700
From: Tony Lindgren <tony@atomide.com>
To: Nishanth Menon <nm@ti.com>
Cc: Roger Quadros <rogerq@ti.com>, Mike Turquette <mturquette@linaro.org>,
        linux-usb@vger.kernel.org, linux@arm.linux.org.uk,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        balbi@ti.com, grygorii.strashko@ti.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC][PATCH 1/2] ARM: OMAP4: clock: Add device tree support
 for AUXCLKs
Message-ID: <20130410184919.GJ10155@atomide.com>
References: <20130404164137.GH10155@atomide.com>
 <515EA9E3.1010409@ti.com>
 <20130405155851.GA10155@atomide.com>
 <5163E589.1040809@ti.com>
 <20130409164928.GL10155@atomide.com>
 <20130409174319.GP10155@atomide.com>
 <20130409204900.GA8815@kahuna>
 <20130410080630.14359.68178@quantum>
 <5165453E.6090503@ti.com>
 <20130410173921.GA31017@kahuna>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130410173921.GA31017@kahuna>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nishanth Menon <nm@ti.com> [130410 10:44]:
> Details in the patch below (Tony, I have added you as collaborator for
> helping in getting this working-clk_add_alias was'nt needed in the
> internal patch discussion we had - I have taken a bit of freedom in
> adding your contributions to the patch below)

OK thanks. Noticed few minor things, see below.
 
> Folks, this does seem to be the best compromise we can achieve at this
> point in time. feedback on this approach is much appreciated - if folks
> are ok, I can post this as an formal patch series.
> 
> From 130a41821bf57081ca45ef654029175d173135e6 Mon Sep 17 00:00:00 2001
> From: Nishanth Menon <nm@ti.com>
> Date: Tue, 9 Apr 2013 19:26:40 -0500
> Subject: [RFC PATCH] clk: OMAP: introduce device tree binding to kernel clock
>  data
> 
> OMAP clock data is located in arch/arm/mach-omap2/cclockXYZ_data.c.
> However, this presents an obstacle for using these clock nodes in
> Device Tree definitions. There are many possible approaches to this
> problem as discussed in the following thread:
> http://marc.info/?t=136370325600009&r=1&w=2

It might be worth clarifying that this is especially for the board
specific clocks initially. The fixed clocks are currently found via
the clock aliases table.

> Highlights of the options:
> a) device specific clk_add_alias:
> 	cons: driver handling required
> b) using an generic clk node and indexing to reach the clock required.
>    This is similar in approach taken by tegra and few other platforms.
>    example clock = <&clk 5>;
>    cons: potential to have mismatches in indexed table and associated
>    dtb data. In addition, managing continued documentation in bindings
>    as clock indexing increases. Even though readability angle could be
>    improved by using preprocessing of DT using macros, indexed approach
>    is inherently risky from cases like the following:
>    clk indexes in kernel:
>    1 - mpu_dpll
>    2 - aux_clk1
>    3 - core_clk
>    DT entry for peripheral x uses <&clk 2>, kernel updates to:
>    1 - mpu_dpll
>    2 - per_dpll
>    3 - aux_clk1
>    4 - core_clk
>    using the old dtb(or dts missing an update), on new kernel which has
>    updated indices will result in per_dpll now controlled for peripheral
>    X without warning or any potential error detection and warning.
> 
>    Even though we can claim this is user error, such errors are hard to
>    track down and fix.
> 
> An alternate approach introduced here is to introduce device tree bindings
> corresponding to the clock nodes required in DT definition for SoC which
> automatically maps back to the definitions in cclockXYZ_data.c.
> 
> The driver introduced here to do this mapping will eventually be the
> place where the clock handling will migrate to. We need to consider this
> angle as well so that the solution will be an valid transition point for
> moving the clock data out of kernel image (into device tree or firmware load
> etc..).
> 
> Overall strategy introduced here is simple: an clock node described in
> device tree blob is used to identify the exact clock provided in the SoC
> specific data. This is then linked back using of_clk_add_provider to the
> device node to be accessible by of_clk_get.
> 
> Based on discussion contributions from Roger Quadros, Grygorii Strashko
> and others.
> 
> [tony@atomide.com: co-developed]
> Signed-off-by: Tony Lindgren <tony@atomide.com>
> Signed-off-by: Nishanth Menon <nm@ti.com>
> ---
>  .../devicetree/bindings/clock/omap-clock.txt       |   40 +++++++++
>  drivers/clk/Makefile                               |    1 +
>  drivers/clk/omap/Makefile                          |    1 +
>  drivers/clk/omap/clk.c                             |   94 ++++++++++++++++++++
>  4 files changed, 136 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/clock/omap-clock.txt
>  create mode 100644 drivers/clk/omap/Makefile
>  create mode 100644 drivers/clk/omap/clk.c
> 
> diff --git a/Documentation/devicetree/bindings/clock/omap-clock.txt b/Documentation/devicetree/bindings/clock/omap-clock.txt
> new file mode 100644
> index 0000000..07e3ff8
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/clock/omap-clock.txt
> @@ -0,0 +1,40 @@
> +Device Tree Clock bindings for Texas Instrument's OMAP compatible platforms
> +
> +This binding is a work-in-progress, and meant to be stage #1 of transitioning
> +OMAP clock data out of kernel image.

As it's using the common clock binding, this will be supported in the
long run too. So maybe replace work-in-progress with initial minimal
binding that can be enhanced later on.

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
> +	CLK(NULL,	"dpll1_ck",	&dpll1_ck,	CK_3XXX),
> +Corresponding binding will be:
> +	dpll1: dpll1 {
> +		#clock-cells = <0>;
> +		compatible = "ti,omap-clock";
> +	};
> +And it's usage will be:
> +		clocks = <&dpll1>;
> +
> +Example #2: describing clock node for auxilary clock #3 on OMAP443x platform:
> +Ref: arch/arm/mach-omap2/cclock44xx_data.c
> +describes the auxclk3 clock to be as follows:
> +	CLK(NULL,	"auxclk3_ck",	&auxclk3_ck,	CK_443X),
> +Corresponding binding will be:
> +	auxclk3: auxclk3 {
> +		#clock-cells = <1>;
> +		compatible = "ti,omap-clock";
> +	};
> +And it's usage will be:
> +	clocks = <&auxclk3>;

The #clock-cells in the auxclk3 example should also be 0 instead of 1
AFAIK. We should only use #clock-cells = <1> when the same physical
clock provides multiple outputs. I believe the auxclocks are all separate,
but that needs to be verified.

> diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
> index 300d477..a0209d7 100644
> --- a/drivers/clk/Makefile
> +++ b/drivers/clk/Makefile
> @@ -27,6 +27,7 @@ obj-$(CONFIG_ARCH_U8500)	+= ux500/
>  obj-$(CONFIG_ARCH_VT8500)	+= clk-vt8500.o
>  obj-$(CONFIG_ARCH_ZYNQ)		+= clk-zynq.o
>  obj-$(CONFIG_ARCH_TEGRA)	+= tegra/
> +obj-$(CONFIG_ARCH_OMAP)		+= omap/
>  
>  obj-$(CONFIG_X86)		+= x86/
>  
> diff --git a/drivers/clk/omap/Makefile b/drivers/clk/omap/Makefile
> new file mode 100644
> index 0000000..8195931
> --- /dev/null
> +++ b/drivers/clk/omap/Makefile
> @@ -0,0 +1 @@
> +obj-y					+= clk.o
> diff --git a/drivers/clk/omap/clk.c b/drivers/clk/omap/clk.c
> new file mode 100644
> index 0000000..63a4cce
> --- /dev/null
> +++ b/drivers/clk/omap/clk.c
> @@ -0,0 +1,94 @@
> +/*
> + * Texas Instruments OMAP Clock driver
> + *
> + * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com/
> + *	Nishanth Menon
> + *	Tony Lindgren <tony@atomide.com>
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
> +#include <linux/clk-private.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of_device.h>
> +#include <linux/platform_device.h>
> +#include <linux/string.h>
> +
> +static const struct of_device_id omap_clk_of_match[] = {
> +	{.compatible = "ti,omap-clock",},
> +	{},
> +};
> +
> +MODULE_DEVICE_TABLE(of, omap_clk_of_match);
> +
> +/**
> + * omap_clk_probe() - create link from DT definition to clock data
> + * @pdev:	device node
> + *
> + * REVISIT: We are now assuming the following:
> + * 1. omap clock names end with _ck
> + * 2. omap clocks don't get removed
> + */
> +static int omap_clk_probe(struct platform_device *pdev)
> +{
> +	struct clk *clk;
> +	int res;
> +
> +	const struct of_device_id *match;
> +	struct device_node *np = pdev->dev.of_node;
> +	char clk_name[32];
> +
> +	match = of_match_device(omap_clk_of_match, &pdev->dev);
> +
> +	/* Set up things so consumer can call clk_get() with name */
> +	snprintf(clk_name, 32, "%s_ck", np->name);
> +	clk = clk_get(NULL, clk_name);
> +	if (IS_ERR(clk)) {
> +		res = PTR_ERR(clk);
> +		dev_err(&pdev->dev, "could not get clock %s (%d)\n",
> +			clk_name, res);
> +		goto out;
> +	}

It seems that at least for now we can assume the naming will stay
that way, then if we need other rules for finding clocks, we can
add omap_match_clock() function or something.

> +	/* This allows the driver to of_clk_get() */
> +	res = of_clk_add_provider(np, of_clk_src_simple_get, clk);
> +	if (res)
> +		dev_err(&pdev->dev, "could not add provider for %s (%d)\n",
> +			clk_name, res);
> +
> +	clk_put(clk);
> +out:
> +	return res;
> +}

We can avoid the concern of storing the struct clk * and do the
look up lazily on consumer driver probe by setting a dummy struct
clk * here. Then replace of_clk_src_simple_get() with a custom
omap_clk_src_get() that does the lookup and replaces the struct
clk * with the real one.

> +MODULE_ALIAS("platform:omap_clk");
> +
> +/* We assume here that OMAP clocks will not be removed */
> +static struct platform_driver omap_clk_driver = {
> +	.probe = omap_clk_probe,
> +	.driver = {
> +		   .name = "omap_clk",
> +		   .owner = THIS_MODULE,
> +		   .of_match_table = of_match_ptr(omap_clk_of_match),
> +		   },
> +};
> +
> +static int __init omap_clk_init(void)
> +{
> +	return platform_driver_register(&omap_clk_driver);
> +}
> +
> +arch_initcall(omap_clk_init);
>
> +MODULE_DESCRIPTION("OMAP Clock driver");
> +MODULE_AUTHOR("Texas Instruments Inc.");
> +MODULE_LICENSE("GPL v2");

Regards,

Tony
