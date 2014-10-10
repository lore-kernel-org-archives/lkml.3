Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022AbaJJHvo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 03:51:44 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57070 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbaJJHvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 03:51:40 -0400
Date: Fri, 10 Oct 2014 09:51:28 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Matteo Facchinetti <matteo.facchinetti@sirius-es.it>
Cc: chris@printf.net, ulf.hansson@linaro.org, shc_work@mail.ru,
        peter.griffin@linaro.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, agust@denx.de, gsi@denx.de,
        sbabic@denx.de
Subject: Re: [PATCH v2 2/2] mmc: mxcmmc: fix the default value for available
 voltages into mxcmci_probe
Message-ID: <20141010075128.GP4992@pengutronix.de>
References: <1412778273-13464-1-git-send-email-matteo.facchinetti@sirius-es.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412778273-13464-1-git-send-email-matteo.facchinetti@sirius-es.it>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:50:45 up 30 days, 38 min, 86 users,  load average: 0.08, 0.11,
 0.19
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 04:24:33PM +0200, Matteo Facchinetti wrote:
> From: Matteo Facchinetti <matteo.facchinetti@sirius-es.it>
> 
> If available voltages are not given, mmc_regulator_get_supply() function
> returns 0 and mxcmmc driver doesn't set a value for ocr_avail mask.
> 
> In accordance with the comment in platform_data/mmc-mxcmmc.h,
> fix it, assuming MMC_VDD_32_33 | MMC_VDD_33_34 as default value.
> 
> Signed-off-by: Matteo Facchinetti <matteo.facchinetti@sirius-es.it>

Looks okay now.

Reviewed-by: Sascha Hauer <s.hauer@pengutronix.de>

Sascha

> ---
> v2:
> * Add test to check if mmc->ocr_avail is setted by mmc_regulator_get_supply().
>   This will prevent that it be overwritten unconditionally.
> ---
>  drivers/mmc/host/mxcmmc.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/mmc/host/mxcmmc.c b/drivers/mmc/host/mxcmmc.c
> index 536a898..5316d9b 100644
> --- a/drivers/mmc/host/mxcmmc.c
> +++ b/drivers/mmc/host/mxcmmc.c
> @@ -1077,12 +1077,14 @@ static int mxcmci_probe(struct platform_device *pdev)
>  		dat3_card_detect = true;
>  
>  	ret = mmc_regulator_get_supply(mmc);
> -	if (ret) {
> -		if (pdata && ret != -EPROBE_DEFER)
> -			mmc->ocr_avail = pdata->ocr_avail ? :
> -				MMC_VDD_32_33 | MMC_VDD_33_34;
> +	if (ret == -EPROBE_DEFER)
> +		goto out_free;
> +
> +	if (!mmc->ocr_avail) {
> +		if (pdata && pdata->ocr_avail)
> +			mmc->ocr_avail = pdata->ocr_avail;
>  		else
> -			goto out_free;
> +			mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
>  	}
>  
>  	if (dat3_card_detect)
> -- 
> 1.8.3.2
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
