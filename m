Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756346Ab3JHR7y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 13:59:54 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:46098 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753013Ab3JHR7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 13:59:52 -0400
Message-ID: <525447FF.3050106@ti.com>
Date: Tue, 8 Oct 2013 12:59:27 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: =?ISO-8859-1?Q?Beno=EEt_Cousson?= <bcousson@baylibre.com>,
        Felipe <balbi@ti.com>, Olof Johansson <olof@lixom.net>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH V3] ARM: OMAP3: Fix hardware detection for omap3630 when
 booted with device tree
References: <20131007192009.GA8949@atomide.com> <1381178629-13488-1-git-send-email-nm@ti.com> <20131008000515.GA2097@earth.universe> <5253F3D6.5060403@ti.com> <20131008175818.GC8313@atomide.com>
In-Reply-To: <20131008175818.GC8313@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2013 12:58 PM, Tony Lindgren wrote:
> * Nishanth Menon <nm@ti.com> [131008 05:08]:
>> On 10/07/2013 07:05 PM, Sebastian Reichel wrote:
>>> On Mon, Oct 07, 2013 at 03:43:49PM -0500, Nishanth Menon wrote:
>>>> diff --git a/arch/arm/mach-omap2/board-generic.c b/arch/arm/mach-omap2/board-generic.c
>>>> index 39c7838..4fe5b9c 100644
>>>> --- a/arch/arm/mach-omap2/board-generic.c
>>>> +++ b/arch/arm/mach-omap2/board-generic.c
>>>> @@ -113,6 +113,7 @@ MACHINE_END
>>>>  #ifdef CONFIG_ARCH_OMAP3
>>>>  static const char *omap3_boards_compat[] __initdata = {
>>>>  	"ti,omap3",
>>>> +	"ti,omap343x",
>>>             ^^^^
>>> You used omap36xx everywhere, so I guess this should be
>>> "ti,omap34xx"?
>>
>> 3630 has at least two variants:
>> http://www.ti.com/product/omap3621
>> http://www.ti.com/product/omap3630
>>
>> It got further spun off in 37xx family:
>> http://www.ti.com/product/dm3730 (DM3730 and DM3725)
>>
>> 3430 is no longer in production - but just had a single version (at
>> least what I can remember).
>>
>> 3530 variant of 3430 on the other hand has a few:
>> http://processors.wiki.ti.com/index.php/OMAP3_Overview
>>
>>
>> I am ok to change to ti,omap34xx if folks think that is the right
>> thing to do. Personally, I might prefer to handle 35xx family slightly
>> differently considering deltas.
> 
> I've dropped that part as that's not needed for the fix AFAIK.
> Here's what I've applied and pushed out to omap-for-v3.12/fixes.
> 
> Regards,
> 
> Tony
> 
> From: Nishanth Menon <nm@ti.com>
> Date: Mon, 7 Oct 2013 15:43:49 -0500
> Subject: [PATCH] ARM: OMAP3: Fix hardware detection for omap3630 when booted with device tree
> 
> SoC family definitions at the moment are reactive to board needs
> as a result, beagle-xm would matchup with ti,omap3 which invokes
> omap3430_init_early instead of omap3630_init_early. Obviously, this is
> the wrong behavior.
> 
> With clock node dts conversion, we get the following warnings before
> system hangs as a result and 3630 based platforms fails to boot
> (uart4 clocks are only present in OMAP3630 and not present in
> OMAP3430):
> 
> ...
> omap_hwmod: uart4: cannot clk_get main_clk uart4_fck
> omap_hwmod: uart4: cannot _init_clocks
> 
> WARNING: CPU: 0 PID: 1 at arch/arm/mach-omap2/omap_hwmod.c:2434
> _init+0x6c/0x80()
> omap_hwmod: uart4: couldn't init clocks
> ...
> 
> WARNING: CPU: 0 PID: 1 at arch/arm/mach-omap2/omap_hwmod.c:2126
> _enable+0x254/0x280()
> omap_hwmod: timer12: enabled state can only be entered from
> initialized, idle, or disabled state
> ...
> 
> WARNING: CPU: 0 PID: 46 at arch/arm/mach-omap2/omap_hwmod.c:2224
> _idle+0xd4/0xf8()
> omap_hwmod: timer12: idle state can only be entered from enabled state
> 
> WARNING: CPU: 0 PID: 1 at arch/arm/mach-omap2/omap_hwmod.c:2126
> _enable+0x254/0x280()
> omap_hwmod: uart4: enabled state can only be entered from
> initialized, idle, or disabled state
> 
> So, add specific compatiblity for 3630 to allow match for Beagle-XM
> platform.
> 
> Signed-off-by: Nishanth Menon <nm@ti.com>
> [tony@atomide.com: left out ti,omap343x, updated comments]
> Signed-off-by: Tony Lindgren <tony@atomide.com>
> 
> diff --git a/arch/arm/boot/dts/omap3-beagle-xm.dts b/arch/arm/boot/dts/omap3-beagle-xm.dts
> index 0c514dc..2816bf6 100644
> --- a/arch/arm/boot/dts/omap3-beagle-xm.dts
> +++ b/arch/arm/boot/dts/omap3-beagle-xm.dts
> @@ -11,7 +11,7 @@
>  
>  / {
>  	model = "TI OMAP3 BeagleBoard xM";
> -	compatible = "ti,omap3-beagle-xm", "ti,omap3-beagle", "ti,omap3";
> +	compatible = "ti,omap3-beagle-xm", "ti,omap36xx", "ti,omap3";
>  
>  	cpus {
>  		cpu@0 {
> diff --git a/arch/arm/mach-omap2/board-generic.c b/arch/arm/mach-omap2/board-generic.c
> index 39c7838..87162e1 100644
> --- a/arch/arm/mach-omap2/board-generic.c
> +++ b/arch/arm/mach-omap2/board-generic.c
> @@ -129,6 +129,24 @@ DT_MACHINE_START(OMAP3_DT, "Generic OMAP3 (Flattened Device Tree)")
>  	.restart	= omap3xxx_restart,
>  MACHINE_END
>  
> +static const char *omap36xx_boards_compat[] __initdata = {
> +	"ti,omap36xx",
> +	NULL,
> +};
> +
> +DT_MACHINE_START(OMAP36XX_DT, "Generic OMAP36xx (Flattened Device Tree)")
> +	.reserve	= omap_reserve,
> +	.map_io		= omap3_map_io,
> +	.init_early	= omap3630_init_early,
> +	.init_irq	= omap_intc_of_init,
> +	.handle_irq	= omap3_intc_handle_irq,
> +	.init_machine	= omap_generic_init,
> +	.init_late	= omap3_init_late,
> +	.init_time	= omap3_sync32k_timer_init,
> +	.dt_compat	= omap36xx_boards_compat,
> +	.restart	= omap3xxx_restart,
> +MACHINE_END
> +
>  static const char *omap3_gp_boards_compat[] __initdata = {
>  	"ti,omap3-beagle",
>  	"timll,omap3-devkit8000",
> 

LGTM. Thanks for doing it.

-- 
Regards,
Nishanth Menon
