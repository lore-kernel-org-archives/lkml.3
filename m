Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271Ab3C1VoX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 17:44:23 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:51869 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909Ab3C1VoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 17:44:21 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+b/8QrWYxUPXXr6U3w5d3g
Date: Thu, 28 Mar 2013 14:44:11 -0700
From: Tony Lindgren <tony@atomide.com>
To: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Cc: Juha Yrjola <juha.yrjola@solidboot.com>,
        Russell King <linux@arm.linux.org.uk>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] OMAP3 ROM Random Number Generator support
Message-ID: <20130328214411.GZ10155@atomide.com>
References: <201302281905.48546@pali>
 <201303272303.44420@pali>
 <20130327222524.GR10155@atomide.com>
 <201303281854.02847@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201303281854.02847@pali>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pali Rohár <pali.rohar@gmail.com> [130328 10:58]:
> 
> Here is new version of patch:
> 
> --- a/arch/arm/mach-omap2/devices.c
> +++ b/arch/arm/mach-omap2/devices.c
> @@ -486,6 +486,23 @@ static void omap_init_mcspi(void)
>  static inline void omap_init_mcspi(void) {}
>  #endif
>  
> +extern u32 *omap3_rom_rng_call(u32 id, u32 proc, u32 flags, u32 va_ptr);
> +
> +static struct platform_device omap3_rom_rng_device = {
> +	.name		= "omap3-rom-rng",
> +	.id		= -1,
> +	.dev	= {
> +		.platform_data	= omap3_rom_rng_call,
> +	},
> +};
> +
> +static void omap_init_rom_rng(void)
> +{
> +	if (!cpu_is_omap34xx() || omap_type() == OMAP2_DEVICE_TYPE_GP)
> +		return;
> +	platform_device_register(&omap3_rom_rng_device);
> +}
> +
>  /**
>   * omap_init_rng - bind the RNG hwmod to the RNG omap_device
>   *

This driver probably only works on Nokia boards because of the
different SMC call numbering. Until it's been verified on some
other HS omap34xx, I'd probably register this only from the
Nokia board-*.c file.

> --- /dev/null
> +++ b/drivers/char/hw_random/omap3-rom-rng.c
> +static int omap3_rom_rng_probe(struct platform_device *pdev)
> +{
> +	printk(KERN_INFO "%s: initializing\n", omap3_rom_rng_name);
> +
> +	omap3_rom_rng_call = pdev->dev.platform_data;
> +	if (!omap3_rom_rng_call) {
> +		printk(KERN_ERR "%s: omap3_rom_rng_call is NULL\n",
> +		       omap3_rom_rng_name);
> +		return -EINVAL;
> +	}
> +
> +	setup_timer(&idle_timer, omap3_rom_idle_rng, 0);
> +	rng_clk = clk_get_sys("omap_rng", "ick");
> +	if (IS_ERR(rng_clk)) {
> +		printk(KERN_ERR "%s: unable to get RNG clock\n",
> +		       omap3_rom_rng_name);
> +		return IS_ERR(rng_clk);
> +	}

You can use regular clk_get if you add the alias to
struct omap_clk omap3xxx_clks table.

Regards,

Tony
