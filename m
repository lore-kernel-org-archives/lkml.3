Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758901AbaJ3LIU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 07:08:20 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:63965 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758162AbaJ3LIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 07:08:19 -0400
MIME-Version: 1.0
In-Reply-To: <1414655193-16952-1-git-send-email-pramod.gurav@smartplayin.com>
References: <1414655193-16952-1-git-send-email-pramod.gurav@smartplayin.com>
Date: Thu, 30 Oct 2014 12:08:18 +0100
Message-ID: <CAPDyKFqFOb9L6WyFhLbSY-dQy_75YVUhTzVsBku1BKcEMmgpBg@mail.gmail.com>
Subject: Re: [PATCH v2] mmc: davinci: Fix and simplify probe failure path
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Ball <chris@printf.net>, linux-mmc <linux-mmc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 October 2014 08:46, Pramod Gurav <pramod.gurav@smartplayin.com> wrote:
> The sequence of resource release in probe failure path in this
> driver was wrong and needed fixes to cleanly unload the driver.
> This changes does the same by switching to managed resources and
> fixes return path to release resource in proper sequence.
>
> Cc: Chris Ball <chris@printf.net>
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Cc: linux-mmc@vger.kernel.org

Please remove these Ccs above from the commit message. It's not needed
when you anyway need to send the patches directly to these addresses.

> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
> ---
> Changes since v1:
> - Dropped IS_ERR check on devm_ioremap() return.
> - Fixed sequence on mmc_remove_host in fail as well as in remove function
>
>  drivers/mmc/host/davinci_mmc.c |   91 +++++++++++++++-------------------------
>  1 file changed, 33 insertions(+), 58 deletions(-)
>
> diff --git a/drivers/mmc/host/davinci_mmc.c b/drivers/mmc/host/davinci_mmc.c
> index 5d4c5e0..dc49b22 100644
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

I realized that you should use devm_ioremap_resource() instead. That
would simplify the code even more.

[...]

Kind regards
Uffe
