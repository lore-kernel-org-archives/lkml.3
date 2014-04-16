Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751412AbaDPQfg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 12:35:36 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:28892 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbaDPQfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 12:35:34 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18hhEQsanqC9g5ScE1cMS4y
Date: Wed, 16 Apr 2014 09:35:27 -0700
From: Tony Lindgren <tony@atomide.com>
To: Felipe Balbi <balbi@ti.com>
Cc: dbaryshkov@gmail.com, dwmw2@infradead.org,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH] power: twl4030_charger: clear IRQs after handling them
Message-ID: <20140416163526.GA3049@atomide.com>
References: <1397661299-31342-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397661299-31342-1-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Felipe Balbi <balbi@ti.com> [140416 08:18]:
> TRM says we *must* write 1 to each bit we're handling
> in order to clear the IRQ status and bring IRQ line
> low. This patch implements that.
> 
> Signed-off-by: Felipe Balbi <balbi@ti.com>
> ---
> 
> Russell, I don't have HW to test, but this should
> solve the problem you saw when not using battery
> with Zoom board. Let me know if it doesn't.

BTW, looks like we're enabling BCI automatically in twl4030.dtsi
while the legacy booting does not have TWL_COMMON_PDATA_BCI
enabled for LDP. Anyways, for LDP BCI should be enabled for
sure, that's the only way to power at least the earlier LDP
revisions.

>  drivers/power/twl4030_charger.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/power/twl4030_charger.c b/drivers/power/twl4030_charger.c
> index f141088..b090842 100644
> --- a/drivers/power/twl4030_charger.c
> +++ b/drivers/power/twl4030_charger.c
> @@ -301,12 +301,24 @@ static irqreturn_t twl4030_bci_interrupt(int irq, void *arg)
>  	ret = twl_i2c_read_u8(TWL4030_MODULE_INTERRUPTS, &irqs1,
>  			      TWL4030_INTERRUPTS_BCIISR1A);
>  	if (ret < 0)
> -		return IRQ_HANDLED;
> +		return IRQ_NONE;
> +
> +	/* clear IRQs early */
> +	ret = twl_i2c_write_u8(TWL4030_MODULE_INTERRUPTS, irqs1,
> +			TWL4030_INTERRUPTS_BCIISR1A);
> +	if (ret < 0)
> +		return IRQ_NONE;
>  
>  	ret = twl_i2c_read_u8(TWL4030_MODULE_INTERRUPTS, &irqs2,
>  			      TWL4030_INTERRUPTS_BCIISR2A);
>  	if (ret < 0)
> -		return IRQ_HANDLED;
> +		return IRQ_NONE;
> +
> +	/* clear IRQs early */
> +	ret = twl_i2c_write_u8(TWL4030_MODULE_INTERRUPTS, irqs2,
> +			      TWL4030_INTERRUPTS_BCIISR2A);
> +	if (ret < 0)
> +		return IRQ_NONE;
>  
>  	dev_dbg(bci->dev, "BCI irq %02x %02x\n", irqs2, irqs1);
>  
> -- 
> 1.9.1.286.g5172cb3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
