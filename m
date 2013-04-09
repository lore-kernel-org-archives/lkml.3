Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936110Ab3DIWWi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 18:22:38 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:24253 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750943Ab3DIWWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 18:22:36 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX192FEGAlY3C8RvX1AhIdicT
Date: Tue, 9 Apr 2013 15:22:31 -0700
From: Tony Lindgren <tony@atomide.com>
To: Nishanth Menon <nm@ti.com>
Cc: Roger Quadros <rogerq@ti.com>, linux-usb@vger.kernel.org,
        linux@arm.linux.org.uk, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, balbi@ti.com, grygorii.strashko@ti.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC][PATCH 1/2] ARM: OMAP4: clock: Add device tree support
 for AUXCLKs
Message-ID: <20130409222231.GS10155@atomide.com>
References: <1363703220-4777-2-git-send-email-rogerq@ti.com>
 <20130403234242.GE10155@atomide.com>
 <515D2D30.3000306@ti.com>
 <20130404164137.GH10155@atomide.com>
 <515EA9E3.1010409@ti.com>
 <20130405155851.GA10155@atomide.com>
 <5163E589.1040809@ti.com>
 <20130409164928.GL10155@atomide.com>
 <20130409174319.GP10155@atomide.com>
 <20130409204900.GA8815@kahuna>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130409204900.GA8815@kahuna>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nishanth Menon <nm@ti.com> [130409 13:53]:
> I did try to have an implementation for cpufreq using clock nodes.
> unfortunately, device tree wont let me have arguments of strings :(
> So, I am unable to do clock = <&clk mpu_dpll>;
> instead, I am forced to do clock = <&clk 249>;

It seems that you should have a separate clock defines for each
clock instead. That way we can later on populate that with
the clock specific data.
 
> Here is an attempt on beagleXM - adds every clock node to the list.
> Tons of un-necessary prints added to give an idea - see log:
> http://pastebin.com/F9A2zSTr
> 
> Would an cleaned up version be good enough as a step #1 of transition?

Well I would make it even simpler initially. Just a standard .dts
clock defined that gets parsed by drivers/clock/ driver that just
calls clk_add_alias(). Then the consumer driver can just do clk_get()
and and the right clock is found, see below.

> --- a/arch/arm/boot/dts/omap3.dtsi
> +++ b/arch/arm/boot/dts/omap3.dtsi
> @@ -73,6 +73,11 @@
>  			ti,hwmods = "counter_32k";
>  		};
>  
> +		clks: clocks {
> +			compatible = "ti,clock";
> +			#clock-cells = <1>;
> +		};
> +
>  		intc: interrupt-controller@48200000 {
>  			compatible = "ti,omap2-intc";
>  			interrupt-controller;

There should be a separate entry for each clock defined,
like auxclk1 in the USB case assuming the clock being used
is aux clock #1. I doubt that we want to map all the auxclks
as a single clock as they are separate clocks AFAIK.

> --- a/arch/arm/boot/dts/omap34xx.dtsi
> +++ b/arch/arm/boot/dts/omap34xx.dtsi
> @@ -23,6 +23,8 @@
>  				600000  1350000
>  			>;
>  			clock-latency = <300000>; /* From legacy driver */
> +			clocks = <&clks 249>; /* index to cpufreq_ck */
> +			clock-names = "cpu";
>  		};
>  	};
>  };

Then in the consumer driver you would just have:

			clocks = <&auxclk1 0>;

for the USB case, then something else for the cpufreq driver.

> --- a/arch/arm/mach-omap2/cclock3xxx_data.c
> +++ b/arch/arm/mach-omap2/cclock3xxx_data.c
> @@ -22,6 +22,7 @@
>  #include <linux/clk-private.h>
>  #include <linux/list.h>
>  #include <linux/io.h>
> +#include <linux/clk/ti.h>
>  
>  #include "soc.h"
>  #include "iomap.h"
> @@ -3574,7 +3575,7 @@ int __init omap3xxx_clk_init(void)
>  	for (c = omap3xxx_clks; c < omap3xxx_clks + ARRAY_SIZE(omap3xxx_clks);
>  	     c++)
>  		if (c->cpu & cpu_clkflg) {
> -			clkdev_add(&c->lk);
> +			ti_clk_node_add(&c->lk);
>  			if (!__clk_init(NULL, c->lk.clk))
>  				omap2_init_clk_hw_omap_clocks(c->lk.clk);
>  		}

AFAIK no need to tinkering with the clockxxxx_data.c files.

> --- /dev/null
> +++ b/drivers/clk/ti.c
> @@ -0,0 +1,100 @@
> +/*
> + * TI Clock node provider
> + *
> + * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com/
> + *	Nishanth Menon
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
> +#include <linux/kernel.h>
> +#include <linux/list.h>
> +#include <linux/clk-private.h>
> +#include <linux/clkdev.h>
> +#include <linux/io.h>
> +#include <linux/of.h>
> +#include <linux/clk/ti.h>

Then this can be just a minimal DT device driver that initially just
calls clk_add_alias() so the right clock is found when the driver
does clk_get(). Probably should be drivers/clock/omap/clk.c.

Regards,

Tony

