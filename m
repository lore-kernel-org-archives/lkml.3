Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273Ab3IQXY0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 19:24:26 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:48162 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124Ab3IQXYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 19:24:25 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19hCqb5bPLa7IBE7VtgZmGb
Date: Tue, 17 Sep 2013 16:24:17 -0700
From: Tony Lindgren <tony@atomide.com>
To: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Cc: linux-kernel@vger.kernel.org, Aaro Koskinen <aaro.koskinen@iki.fi>,
        linux-omap@vger.kernel.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, Nishanth Menon <nm@ti.com>,
        Pavel Machek <pavel@ucw.cz>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Ivaylo Dimitrov <freemangordon@abv.bg>
Subject: Re: [PATCH v2 2/2] RX-51: ARM errata 430973 workaround
Message-ID: <20130917232417.GK9994@atomide.com>
References: <1362044548-5398-1-git-send-email-pali.rohar@gmail.com>
 <1373461145-9812-1-git-send-email-pali.rohar@gmail.com>
 <1373461145-9812-3-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1373461145-9812-3-git-send-email-pali.rohar@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pali Rohár <pali.rohar@gmail.com> [130710 06:06]:
> --- a/arch/arm/mach-omap2/board-rx51.c
> +++ b/arch/arm/mach-omap2/board-rx51.c

This file will be gone as soon as we're moving to device
tree based booting. So let's do this in more future proof
way.

> +/**
> + * rx51_secure_dispatcher: Routine to dispatch secure PPA API calls
> + * @idx: The PPA API index
> + * @process: Process ID
> + * @flag: The flag indicating criticality of operation
> + * @nargs: Number of valid arguments out of four.
> + * @arg1, arg2, arg3 args4: Parameters passed to secure API
> + *
> + * Return the non-zero error value on failure.
> + */
> +static u32 rx51_secure_dispatcher(u32 idx, u32 process, u32 flag, u32 nargs,
> +			   u32 arg1, u32 arg2, u32 arg3, u32 arg4)
> +{
> +	u32 ret;
> +	u32 param[5];
> +
> +	param[0] = nargs+1; /* RX-51 needs number of arguments + 1 */
> +	param[1] = arg1;
> +	param[2] = arg2;
> +	param[3] = arg3;
> +	param[4] = arg4;
> +
> +	/*
> +	 * Secure API needs physical address
> +	 * pointer for the parameters
> +	 */
> +	local_irq_disable();
> +	local_fiq_disable();
> +	flush_cache_all();
> +	outer_clean_range(__pa(param), __pa(param + 5));
> +	ret = omap_smc3(idx, process, flag, __pa(param));
> +	flush_cache_all();
> +	local_fiq_enable();
> +	local_irq_enable();
> +
> +	return ret;
> +}

I think this used to be in omap-secure.c, and then made rx51
specific.. But since board-rx51.c is going away, let's move
this function to omap-secure.c.

> + * rx51_secure_update_aux_cr: Routine to modify the contents of Auxiliary Control Register
> + *  @set_bits: bits to set in ACR
> + *  @clr_bits: bits to clear in ACR
> + *
> + * Return the non-zero error value on failure.
> +*/
> +static u32 rx51_secure_update_aux_cr(u32 set_bits, u32 clear_bits)
> +{
> +	u32 acr;
> +
> +	/* Read ACR */
> +	asm volatile ("mrc p15, 0, %0, c1, c0, 1" : "=r" (acr));
> +	acr &= ~clear_bits;
> +	acr |= set_bits;
> +
> +	return rx51_secure_dispatcher(RX51_PPA_WRITE_ACR,
> +				      0,
> +				      FLAG_START_CRITICAL,
> +				      1, acr, 0, 0, 0);
> +}

This too.

>  static void __init rx51_init(void)
>  {
>  	struct omap_sdrc_params *sdrc_params;
> @@ -105,6 +175,14 @@ static void __init rx51_init(void)
>  	rx51_peripherals_init();
>  	rx51_camera_init();
>  
> +	if (omap_type() == OMAP2_DEVICE_TYPE_SEC) {
> +#ifdef CONFIG_ARM_ERRATA_430973
> +		pr_info("RX-51: Enabling ARM errata 430973 workaround\n");
> +		/* set IBE to 1 */
> +		rx51_secure_update_aux_cr(BIT(6), 0);
> +#endif
> +	}
> +
>  	/* Ensure SDRC pins are mux'd for self-refresh */
>  	omap_mux_init_signal("sdrc_cke0", OMAP_PIN_OUTPUT);
>  	omap_mux_init_signal("sdrc_cke1", OMAP_PIN_OUTPUT);

Then this can be called both from board-generic.c based on the
compatible flag, and board-rx51.c for now.

Regards,

Tony
