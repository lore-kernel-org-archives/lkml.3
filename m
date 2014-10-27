Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026AbaJ0LSj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 07:18:39 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:53794 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbaJ0LSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 07:18:37 -0400
MIME-Version: 1.0
In-Reply-To: <1411726268-12605-1-git-send-email-pramod.gurav@smartplayin.com>
References: <1411726268-12605-1-git-send-email-pramod.gurav@smartplayin.com>
Date: Mon, 27 Oct 2014 12:18:29 +0100
Message-ID: <CAPDyKFpy2FjvpEWyo9R6PNGpHsWDwfAr1eatNQr+rhJWNLsM6g@mail.gmail.com>
Subject: Re: [PATCH] mmc: davinci: Fix and simplify probe failure path
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Ball <chris@printf.net>, linux-mmc <linux-mmc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 September 2014 12:11, Pramod Gurav <pramod.gurav@smartplayin.com> wrote:
> The sequence of resource release in probe failure path in this
> driver was wrong and needed fixes to cleanly unload the driver.
> This changes does the same by switching to managed resources and
> fixes return path to release resource in proper sequence.
>
> Cc: Chris Ball <chris@printf.net>
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Cc: linux-mmc@vger.kernel.org
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
>
> ---
>  drivers/mmc/host/davinci_mmc.c |   91 +++++++++++++++-------------------------
>  1 file changed, 33 insertions(+), 58 deletions(-)
>
> diff --git a/drivers/mmc/host/davinci_mmc.c b/drivers/mmc/host/davinci_mmc.c
> index 5d4c5e0..160b7e8 100644
> --- a/drivers/mmc/host/davinci_mmc.c
> +++ b/drivers/mmc/host/davinci_mmc.c
> @@ -1242,22 +1242,20 @@ static int __init davinci_mmcsd_probe(struct platform_device *pdev)
>                 return -ENOENT;
>         }
>
> -       ret = -ENODEV;
>         r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>         irq = platform_get_irq(pdev, 0);
>         if (!r || irq == NO_IRQ)
> -               goto out;
> +               return -ENODEV;
>
> -       ret = -EBUSY;
>         mem_size = resource_size(r);
> -       mem = request_mem_region(r->start, mem_size, pdev->name);
> +       mem = devm_request_mem_region(&pdev->dev, r->start, mem_size,
> +                                     pdev->name);
>         if (!mem)
> -               goto out;
> +               return -EBUSY;
>
> -       ret = -ENOMEM;
>         mmc = mmc_alloc_host(sizeof(struct mmc_davinci_host), &pdev->dev);
>         if (!mmc)
> -               goto out;
> +               return -ENOMEM;
>
>         host = mmc_priv(mmc);
>         host->mmc = mmc;        /* Important */
> @@ -1275,15 +1273,16 @@ static int __init davinci_mmcsd_probe(struct platform_device *pdev)
>                 host->txdma = r->start;
>
>         host->mem_res = mem;
> -       host->base = ioremap(mem->start, mem_size);
> -       if (!host->base)
> -               goto out;
> +       host->base = devm_ioremap(&pdev->dev, mem->start, mem_size);
> +       if (IS_ERR(host->base)) {

devm_ioremap() doesn't return an error which you could check with IS_ERR().

> +               ret = PTR_ERR(host->base);
> +               goto err_ioremap;
> +       }
>
> -       ret = -ENXIO;
> -       host->clk = clk_get(&pdev->dev, "MMCSDCLK");
> +       host->clk = devm_clk_get(&pdev->dev, "MMCSDCLK");
>         if (IS_ERR(host->clk)) {
>                 ret = PTR_ERR(host->clk);
> -               goto out;
> +               goto err_ioremap;
>         }
>         clk_enable(host->clk);
>         host->mmc_input_clk = clk_get_rate(host->clk);
> @@ -1350,20 +1349,22 @@ static int __init davinci_mmcsd_probe(struct platform_device *pdev)
>         ret = mmc_davinci_cpufreq_register(host);
>         if (ret) {
>                 dev_err(&pdev->dev, "failed to register cpufreq\n");
> -               goto cpu_freq_fail;
> +               goto err_cpu_freq;
>         }
>
>         ret = mmc_add_host(mmc);
>         if (ret < 0)
> -               goto out;
> +               goto err_mmc_add;
>
> -       ret = request_irq(irq, mmc_davinci_irq, 0, mmc_hostname(mmc), host);
> +       ret = devm_request_irq(&pdev->dev, irq, mmc_davinci_irq, 0,
> +                              mmc_hostname(mmc), host);
>         if (ret)
> -               goto out;
> +               goto err_request_irq;
>
>         if (host->sdio_irq >= 0) {
> -               ret = request_irq(host->sdio_irq, mmc_davinci_sdio_irq, 0,
> -                                 mmc_hostname(mmc), host);
> +               ret = devm_request_irq(&pdev->dev, host->sdio_irq,
> +                                      mmc_davinci_sdio_irq, 0,
> +                                      mmc_hostname(mmc), host);
>                 if (!ret)
>                         mmc->caps |= MMC_CAP_SDIO_IRQ;
>         }
> @@ -1376,27 +1377,15 @@ static int __init davinci_mmcsd_probe(struct platform_device *pdev)
>
>         return 0;
>
> -out:
> +err_request_irq:
> +       mmc_free_host(mmc);
> +err_mmc_add:
>         mmc_davinci_cpufreq_deregister(host);
> -cpu_freq_fail:
> -       if (host) {
> -               davinci_release_dma_channels(host);
> -
> -               if (host->clk) {
> -                       clk_disable(host->clk);
> -                       clk_put(host->clk);
> -               }
> -
> -               if (host->base)
> -                       iounmap(host->base);
> -       }
> -
> -       if (mmc)
> -               mmc_free_host(mmc);
> -
> -       if (mem)
> -               release_resource(mem);
> -
> +err_cpu_freq:
> +       davinci_release_dma_channels(host);
> +       clk_disable(host->clk);
> +err_ioremap:
> +       mmc_remove_host(mmc);
>         dev_dbg(&pdev->dev, "probe err %d\n", ret);
>
>         return ret;
> @@ -1406,25 +1395,11 @@ static int __exit davinci_mmcsd_remove(struct platform_device *pdev)
>  {
>         struct mmc_davinci_host *host = platform_get_drvdata(pdev);
>
> -       if (host) {
> -               mmc_davinci_cpufreq_deregister(host);
> -
> -               mmc_remove_host(host->mmc);
> -               free_irq(host->mmc_irq, host);
> -               if (host->mmc->caps & MMC_CAP_SDIO_IRQ)
> -                       free_irq(host->sdio_irq, host);
> -
> -               davinci_release_dma_channels(host);
> -
> -               clk_disable(host->clk);
> -               clk_put(host->clk);
> -
> -               iounmap(host->base);
> -
> -               release_resource(host->mem_res);
> -
> -               mmc_free_host(host->mmc);
> -       }
> +       mmc_free_host(host->mmc);
> +       mmc_davinci_cpufreq_deregister(host);
> +       davinci_release_dma_channels(host);
> +       clk_disable(host->clk);
> +       mmc_remove_host(host->mmc);

mmc_remove_host() needs to be invoked earlier.

Kind regards
Uffe
