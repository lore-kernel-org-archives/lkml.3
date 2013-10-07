Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889Ab3JGTRI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 15:17:08 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:34420 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756622Ab3JGTRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 15:17:05 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/2HSgOPcubZ4mVWQO3g6dO
Date: Mon, 7 Oct 2013 12:17:01 -0700
From: Tony Lindgren <tony@atomide.com>
To: Nishanth Menon <nm@ti.com>
Cc: =?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>,
        Felipe <balbi@ti.com>, Olof Johansson <olof@lixom.net>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] Documentation: dt: OMAP: standardize SoC naming
 definition
Message-ID: <20131007191700.GZ8949@atomide.com>
References: <523C9D8B.2000701@ti.com>
 <1381164584-4008-1-git-send-email-nm@ti.com>
 <1381164584-4008-2-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381164584-4008-2-git-send-email-nm@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Few comments below.

* Nishanth Menon <nm@ti.com> [131007 09:57]:
> SoC family definitions at the moment are reactive to board needs
> as a result, beagle-xm would matchup with ti,omap3 which invokes
> omap3430_init_early instead of omap3630_init_early. Obviously, this is
> the wrong behavior.

It seems that we should try to queue this as a fix to avoid
debugging it multiple times as it's actually quite easy to hit this
one.

So maybe use a subject along lines of:

"ARM: OMAP3: Fix hardware detection for omap3630 when booted with device tree"

And also include these warnings you can get:

omap_hwmod: uart4: cannot clk_get main_clk uart4_fck
omap_hwmod: uart4: cannot _init_clocks

WARNING: CPU: 0 PID: 1 at arch/arm/mach-omap2/omap_hwmod.c:2434 _init+0x6c/0x80()
omap_hwmod: uart4: couldn't init clocks
...

WARNING: CPU: 0 PID: 1 at arch/arm/mach-omap2/omap_hwmod.c:2126 _enable+0x254/0x280()
omap_hwmod: timer12: enabled state can only be entered from initialized, idle, or disabled state
...

WARNING: CPU: 0 PID: 46 at arch/arm/mach-omap2/omap_hwmod.c:2224 _idle+0xd4/0xf8()
omap_hwmod: timer12: idle state can only be entered from enabled state

WARNING: CPU: 0 PID: 1 at arch/arm/mach-omap2/omap_hwmod.c:2126 _enable+0x254/0x280()
omap_hwmod: uart4: enabled state can only be entered from initialized, idle, or disabled state

And also describe that the outcome is that the system fails to boot.
 
> --- a/Documentation/devicetree/bindings/arm/omap/omap.txt
> +++ b/Documentation/devicetree/bindings/arm/omap/omap.txt
> @@ -30,6 +30,51 @@ spinlock@1 {
>      ti,hwmods = "spinlock";
>  };
>  
> +SoC Type(optional):
> +- ti,gp	- General Purpose devices
> +- ti,hs	- High Security devices
> +
> +SoC Families:
> +
> +- OMAP2 generic - defaults to OMAP2420
> +  compatible = "ti,omap2"
> +- OMAP3 generic - defaults to OMAP3430
> +  compatible = "ti,omap3"
> +- OMAP4 generic - defaults to OMAP4430
> +  compatible = "ti,omap4"
> +- OMAP5 generic - defaults to OMAP5430
> +  compatible = "ti,omap5"
> +- DRA7 generic - defaults to DRA742
> +  compatible = "ti,dra7"
> +- AM43x generic - defaults to AM437x
> +  compatible = "ti,am43"
> +
> +SoCs:
> +
> +- OMAP2420
> +  compatible = "ti,omap2420", "ti,omap2"
> +- OMAP2430
> +  compatible = "ti,omap2430", "ti,omap2"
> +
> +- OMAP3430
> +  compatible = "ti,omap343x", "ti,omap3"
> +- OMAP3630
> +  compatible = "ti,omap363x", "ti,omap3"
> +- AM33xx
> +  compatible = "ti,am33xx", "ti,omap3"
> +
> +- OMAP4430
> +  compatible = "ti,omap443x", "ti,omap4"
> +- OMAP4460
> +  compatible = "ti,omap446x", "ti,omap4"
> +
> +- OMAP5430
> +  compatible = "ti,omap5430", "ti,omap5"
> +- OMAP5432
> +  compatible = "ti,omap5432", "ti,omap5"
> +
> +- DRA742
> +  compatible = "ti,dra7xx", "ti,dra7"
>  
>  Boards:

And I would leave the documentation parts out of the fix as
we're pretty late into the -rc cycle.
  
> +++ b/arch/arm/mach-omap2/board-generic.c
> @@ -113,6 +113,7 @@ MACHINE_END
>  #ifdef CONFIG_ARCH_OMAP3
>  static const char *omap3_boards_compat[] __initdata = {
>  	"ti,omap3",
> +	"ti,omap343x",
>  	NULL,
>  };
>  
> @@ -129,6 +130,24 @@ DT_MACHINE_START(OMAP3_DT, "Generic OMAP3 (Flattened Device Tree)")
>  	.restart	= omap3xxx_restart,
>  MACHINE_END
>  
> +static const char *omap36xx_boards_compat[] __initdata = {
> +	"ti,omap363x",
> +	NULL,
> +};

Why not make it just "ti,omap36xx"? This also applies to 3703
where the 3 is missing as it does not have the DSP.

> +DT_MACHINE_START(OMAP36xx_DT, "Generic OMAP363x (Flattened Device Tree)")

Upper case OMAP36XX_DT here please like the others have.

> +	.reserve	= omap_reserve,
> +	.map_io		= omap3_map_io,
> +	.init_early	= omap3630_init_early,
> +	.init_irq	= omap_intc_of_init,
> +	.handle_irq	= omap3_intc_handle_irq,
> +	.init_machine	= omap_generic_init,
> +	.init_late	= omap3_init_late,
> +	.init_time	= omap3_sync32k_timer_init,

Looks like this version has the correct init_time function too :)

> +	.dt_compat	= omap36xx_boards_compat,
> +	.restart	= omap3xxx_restart,
> +MACHINE_END

This looks correct to me.

>  static const char *omap3_gp_boards_compat[] __initdata = {
>  	"ti,omap3-beagle",
>  	"timll,omap3-devkit8000",
> @@ -171,6 +190,8 @@ MACHINE_END
>  #ifdef CONFIG_ARCH_OMAP4
>  static const char *omap4_boards_compat[] __initdata = {
>  	"ti,omap4",
> +	"ti,omap4430",
> +	"ti,omap4460",
>  	NULL,
>  };
>  
> @@ -191,6 +212,8 @@ MACHINE_END
>  #ifdef CONFIG_SOC_OMAP5
>  static const char *omap5_boards_compat[] __initdata = {
>  	"ti,omap5",
> +	"ti,omap5430",
> +	"ti,omap5432",
>  	NULL,
>  };

I would leave these parts for later, maybe with the documentation
changes?

Regards,

Tony
