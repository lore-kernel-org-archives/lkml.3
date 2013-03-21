Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345Ab3CUNI5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 09:08:57 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:50472 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756576Ab3CUNIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 09:08:55 -0400
Message-ID: <514B0650.5070406@ti.com>
Date: Thu, 21 Mar 2013 18:38:32 +0530
From: Rajendra Nayak <rnayak@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>
CC: <tony@atomide.com>, <b-cousson@ti.com>, <linux@arm.linux.org.uk>,
        <balbi@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 1/2] ARM: OMAP4: clock: Add device tree support for
 AUXCLKs
References: <1363703220-4777-1-git-send-email-rogerq@ti.com> <1363703220-4777-2-git-send-email-rogerq@ti.com>
In-Reply-To: <1363703220-4777-2-git-send-email-rogerq@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[]..

> diff --git a/arch/arm/mach-omap2/board-generic.c b/arch/arm/mach-omap2/board-generic.c
> index 0274ff7..23f2064 100644
> --- a/arch/arm/mach-omap2/board-generic.c
> +++ b/arch/arm/mach-omap2/board-generic.c
> @@ -158,7 +158,7 @@ DT_MACHINE_START(OMAP4_DT, "Generic OMAP4 (Flattened Device Tree)")
>  	.init_irq	= omap_gic_of_init,
>  	.init_machine	= omap_generic_init,
>  	.init_late	= omap4430_init_late,
> -	.init_time	= omap4_local_timer_init,
> +	.init_time	= omap4_init_time,
>  	.dt_compat	= omap4_boards_compat,
>  	.restart	= omap44xx_restart,
>  MACHINE_END

[]..
> +#ifdef CONFIG_OF
> +int __init omap4_clk_init_dt(void)
> +{
> +	struct device_node *np;
> +
> +	np = of_find_compatible_node(NULL, NULL, "ti,omap4-scrm");
> +	if (np) {
> +		scrm_data.clks = scrm_clks;
> +		scrm_data.clk_num = ARRAY_SIZE(scrm_clks);
> +		of_clk_add_provider(np, of_clk_src_onecell_get,	&scrm_data);
> +	}
> +
> +	return 0;
> +}

[]..
> +
> +void __init omap4_init_time(void)
> +{
> +	omap4_clk_init_dt();
> +	omap4_local_timer_init();
> +}

I guess you did all this because of_clk_add_provider() needs
slab to be initialized. With the below patch[1], now clk inits
happen within .init_timer already, so none of this would
be needed.

[1] http://www.spinics.net/lists/arm-kernel/msg231288.html

