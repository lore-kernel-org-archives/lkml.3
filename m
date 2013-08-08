Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966614Ab3HHVG1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 17:06:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50208 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966588Ab3HHVGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 17:06:25 -0400
Date: Thu, 8 Aug 2013 23:06:10 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Christian Daudt <csd@broadcom.com>
cc: Chris Ball <cjb@laptop.org>, Shawn Guo <shawn.guo@linaro.org>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc: change mmc_gpio_get_cd to call non-sleep gpio
In-Reply-To: <1375994855-12472-1-git-send-email-csd@broadcom.com>
Message-ID: <Pine.LNX.4.64.1308082258260.29611@axis700.grange>
References: <1375994855-12472-1-git-send-email-csd@broadcom.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:58gCCpARB+jtBnulJUb+zGuqxAcCrJV69l2AvKlXs2i
 +FCwLoAERoO/Rqtm3FxdvAV+4hHZqt7CXw2GWD/U2WNF4B+l1T
 8dwmSjI94L7rlHVE6ETNY/yEwNwm1XB2pe0O+O4t4aixOvUEeS
 0kEIDU/t17AVsyqMdQx+isnTD3d3bvoT9DBDLlwhoStBT3t0X1
 GxSeFjgxS5sBLzNJsNNef3YZQc1bonar8QeZnP/NStt/5GhTdv
 ibf7WTkvvW14MYf2jIiH/PHP9hme3dalvy2gvIkhqnl8/8J2Ur
 HqIpZ3NSc7BJrs+69erMOzjbjYnfc485QjBmlAAtcnTSal+BuU
 D1og44Ak+vLGXKbonaNEBV3kkbeM1Nsv9kJlsYU57gKkRBcN1I
 pZIH1hgbLMNIA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Aug 2013, Christian Daudt wrote:

> Given that mmc_gpio_get_cd can be called in softirq
> context (by sdhci_tasklet_card -> sdhci_card_event ->
> sdhci_do_get_cd -> mmc_gpio_get_cd ), it is necessary
> for it to use gpio_get_value instead of
> gpio_get_value_cansleep
> Note that at present sdhci_card_event gets called both
> from mmc_gpio_cd_irqt and sdhci_tasklet_card, and from
> both it gets called immediately while the actual cd
> processing is debounced to 200ms later. I think that
> the better solution might be to move the sdhci_card_event
> callback into mmc_rescan and remove it from its 2
> present locations. That way the cd related callbacks
> are aligned with the actual cd detection code. I can
> submit a follow-up patch with these mods if that sounds
> like a better way to solve this.
> 
> Signed-off-by: Christian Daudt <csd@broadcom.com>

I don't think this is a right approach. It will Oops if the card-detect 
GPIO is provided by, e.g. an I2C GPIO controller. Instead the driver 
should be fixed to only call this function from a sleeping context.

Thanks
Guennadi

> 
> diff --git a/drivers/mmc/core/slot-gpio.c b/drivers/mmc/core/slot-gpio.c
> index 3242351..897b298 100644
> --- a/drivers/mmc/core/slot-gpio.c
> +++ b/drivers/mmc/core/slot-gpio.c
> @@ -87,7 +87,7 @@ int mmc_gpio_get_cd(struct mmc_host *host)
>  	if (!ctx || !gpio_is_valid(ctx->cd_gpio))
>  		return -ENOSYS;
>  
> -	return !gpio_get_value_cansleep(ctx->cd_gpio) ^
> +	return !gpio_get_value(ctx->cd_gpio) ^
>  		!!(host->caps2 & MMC_CAP2_CD_ACTIVE_HIGH);
>  }
>  EXPORT_SYMBOL(mmc_gpio_get_cd);
> -- 
> 1.7.10.4
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
