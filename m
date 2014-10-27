Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755AbaJ0MM0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 08:12:26 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:53715 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731AbaJ0MMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 08:12:22 -0400
MIME-Version: 1.0
In-Reply-To: <1412778273-13464-1-git-send-email-matteo.facchinetti@sirius-es.it>
References: <1412778273-13464-1-git-send-email-matteo.facchinetti@sirius-es.it>
Date: Mon, 27 Oct 2014 13:12:22 +0100
Message-ID: <CAPDyKFqQna5W1eVas84x0wp-gzBSnP7hgofQbSt6nTnZ8t9LYA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mmc: mxcmmc: fix the default value for available
 voltages into mxcmci_probe
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Matteo Facchinetti <matteo.facchinetti@sirius-es.it>
Cc: Chris Ball <chris@printf.net>, Alexander Shiyan <shc_work@mail.ru>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Peter Griffin <peter.griffin@linaro.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anatolij Gustschin <agust@denx.de>, gsi@denx.de, sbabic@denx.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 October 2014 16:24, Matteo Facchinetti
<matteo.facchinetti@sirius-es.it> wrote:
> From: Matteo Facchinetti <matteo.facchinetti@sirius-es.it>
>
> If available voltages are not given, mmc_regulator_get_supply() function
> returns 0 and mxcmmc driver doesn't set a value for ocr_avail mask.
>
> In accordance with the comment in platform_data/mmc-mxcmmc.h,
> fix it, assuming MMC_VDD_32_33 | MMC_VDD_33_34 as default value.
>
> Signed-off-by: Matteo Facchinetti <matteo.facchinetti@sirius-es.it>

Thanks! Applied for next!

Kind regards
Uffe


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
>                 dat3_card_detect = true;
>
>         ret = mmc_regulator_get_supply(mmc);
> -       if (ret) {
> -               if (pdata && ret != -EPROBE_DEFER)
> -                       mmc->ocr_avail = pdata->ocr_avail ? :
> -                               MMC_VDD_32_33 | MMC_VDD_33_34;
> +       if (ret == -EPROBE_DEFER)
> +               goto out_free;
> +
> +       if (!mmc->ocr_avail) {
> +               if (pdata && pdata->ocr_avail)
> +                       mmc->ocr_avail = pdata->ocr_avail;
>                 else
> -                       goto out_free;
> +                       mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
>         }
>
>         if (dat3_card_detect)
> --
> 1.8.3.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
