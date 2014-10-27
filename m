Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751184AbaJ0KYL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 06:24:11 -0400
Received: from mx.vmgattei.com ([77.223.18.35]:58583 "EHLO mx.vmgattei.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785AbaJ0KYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 06:24:10 -0400
Message-ID: <544E1D33.8060303@sirius-es.it>
Date: Mon, 27 Oct 2014 11:23:47 +0100
From: Matteo Facchinetti <matteo.facchinetti@sirius-es.it>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: chris@printf.net, ulf.hansson@linaro.org
CC: shc_work@mail.ru, s.hauer@pengutronix.de, peter.griffin@linaro.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org, agust@denx.de,
        gsi@denx.de, sbabic@denx.de
Subject: Re: [PATCH v2 2/2] mmc: mxcmmc: fix the default value for available
 voltages into mxcmci_probe
References: <1412778273-13464-1-git-send-email-matteo.facchinetti@sirius-es.it>
In-Reply-To: <1412778273-13464-1-git-send-email-matteo.facchinetti@sirius-es.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch was reviewed, and seems that work it's complete.

Can you merge?


On 08/10/2014 16:24, Matteo Facchinetti wrote:
> From: Matteo Facchinetti <matteo.facchinetti@sirius-es.it>
>
> If available voltages are not given, mmc_regulator_get_supply() function
> returns 0 and mxcmmc driver doesn't set a value for ocr_avail mask.
>
> In accordance with the comment in platform_data/mmc-mxcmmc.h,
> fix it, assuming MMC_VDD_32_33 | MMC_VDD_33_34 as default value.
>
> Signed-off-by: Matteo Facchinetti <matteo.facchinetti@sirius-es.it>
> ---
> v2:
> * Add test to check if mmc->ocr_avail is setted by mmc_regulator_get_supply().
>    This will prevent that it be overwritten unconditionally.
> ---
>   drivers/mmc/host/mxcmmc.c | 12 +++++++-----
>   1 file changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/mmc/host/mxcmmc.c b/drivers/mmc/host/mxcmmc.c
> index 536a898..5316d9b 100644
> --- a/drivers/mmc/host/mxcmmc.c
> +++ b/drivers/mmc/host/mxcmmc.c
> @@ -1077,12 +1077,14 @@ static int mxcmci_probe(struct platform_device *pdev)
>   		dat3_card_detect = true;
>   
>   	ret = mmc_regulator_get_supply(mmc);
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
>   		else
> -			goto out_free;
> +			mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
>   	}
>   
>   	if (dat3_card_detect)

