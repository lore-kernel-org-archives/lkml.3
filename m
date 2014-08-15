Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685AbaHOOmg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 10:42:36 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:38327 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbaHOOme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 10:42:34 -0400
MIME-Version: 1.0
In-Reply-To: <1408029833-6970-1-git-send-email-geert+renesas@glider.be>
References: <1408029833-6970-1-git-send-email-geert+renesas@glider.be>
Date: Fri, 15 Aug 2014 16:42:33 +0200
Message-ID: <CAPDyKFpuCyRVJe_oRTukoryDAMK9iN5qoR4VU2wrjnvjMA-+Bg@mail.gmail.com>
Subject: Re: [PATCH] mmc: tmio: Fix hang during suspend
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Ian Molton <ian.molton@codethink.co.uk>, Chris Ball <chris@printf.net>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 August 2014 17:23, Geert Uytterhoeven <geert+renesas@glider.be> wrote:
> On R-Car Gen 2, the SDHI registers cannot be accessed while the SDHI
> module clock is disabled. Doing so will cause a lock-up.
>
> When suspending, enable the module clock before disabling the SDHI
> interrupts, and disable the clock again afterwards.
>
> This fixes suspend and resume on r8a7791/koelsch.

Out of curiosity, are you using CONFIG_PM_RUNTIME to trigger this bug?

Kind regards
Uffe

>
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  drivers/mmc/host/tmio_mmc_pio.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/drivers/mmc/host/tmio_mmc_pio.c b/drivers/mmc/host/tmio_mmc_pio.c
> index faf0924e71cb..83192420a7e3 100644
> --- a/drivers/mmc/host/tmio_mmc_pio.c
> +++ b/drivers/mmc/host/tmio_mmc_pio.c
> @@ -1147,8 +1147,18 @@ int tmio_mmc_host_suspend(struct device *dev)
>  {
>         struct mmc_host *mmc = dev_get_drvdata(dev);
>         struct tmio_mmc_host *host = mmc_priv(mmc);
> +       struct tmio_mmc_data *pdata = host->pdata;
> +
> +       if (pdata->clk_enable) {
> +               unsigned int f;
> +               pdata->clk_enable(host->pdev, &f);
> +       }
>
>         tmio_mmc_disable_mmc_irqs(host, TMIO_MASK_ALL);
> +
> +       if (pdata->clk_disable)
> +               pdata->clk_disable(host->pdev);
> +
>         return 0;
>  }
>  EXPORT_SYMBOL(tmio_mmc_host_suspend);
> --
> 1.9.1
>
