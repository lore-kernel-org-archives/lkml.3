Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335AbbAWLzI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 06:55:08 -0500
Received: from mail-qg0-f41.google.com ([209.85.192.41]:38395 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310AbbAWLzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 06:55:01 -0500
MIME-Version: 1.0
In-Reply-To: <1422007701-7496-1-git-send-email-jszhang@marvell.com>
References: <1422007701-7496-1-git-send-email-jszhang@marvell.com>
Date: Fri, 23 Jan 2015 12:55:00 +0100
Message-ID: <CAPDyKFo=F3qvVQTJhHNKm78VUY++4JYfdBUeJDM_vthJuuQq0g@mail.gmail.com>
Subject: Re: [PATCH v2] mmc: sdhci-pxav3: fix race between runtime pm and irq
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Jisheng Zhang <jszhang@marvell.com>
Cc: Chris Ball <chris@printf.net>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 January 2015 at 11:08, Jisheng Zhang <jszhang@marvell.com> wrote:
> This patch is to fix a race condition that may cause an unhandled irq,
> which results in big sdhci interrupt numbers and endless "mmc1: got irq
> while runtime suspended" msgs before v3.15.
>
> Consider following scenario:
>
>       CPU0                            CPU1
>                               sdhci_pxav3_runtime_suspend()
>                                spin_lock_irqsave(&host->lock, flags);
>  sdhci_irq()
>   spining on the &host->lock
>                                host->runtime_suspended = true;
>                                spin_unlock_irqrestore(&host->lock, flags);
>   get the &host->lock
>   runtime_suspended is true now
>   return IRQ_NONE;
>
> Fix this race by using the core sdhci.c supplied sdhci_runtime_suspend_host()
> in runtime suspend hook which will disable card interrupts. We also use the
> sdhci_runtime_resume_host() in the runtime resume hook accordingly.
>
> Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
> Cc: <stable@vger.kernel.org> # v3.9+

Thanks! Applied for next.

Kind regards
Uffe

> ---
> Changes in v2:
>  return ret once sdhci_runtime_suspend_host() gives an error
>  drivers/mmc/host/sdhci-pxav3.c | 15 +++++----------
>  1 file changed, 5 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/mmc/host/sdhci-pxav3.c b/drivers/mmc/host/sdhci-pxav3.c
> index 4de39fb..e2817cc 100644
> --- a/drivers/mmc/host/sdhci-pxav3.c
> +++ b/drivers/mmc/host/sdhci-pxav3.c
> @@ -460,11 +460,11 @@ static int sdhci_pxav3_runtime_suspend(struct device *dev)
>         struct sdhci_host *host = dev_get_drvdata(dev);
>         struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
>         struct sdhci_pxa *pxa = pltfm_host->priv;
> -       unsigned long flags;
> +       int ret;
>
> -       spin_lock_irqsave(&host->lock, flags);
> -       host->runtime_suspended = true;
> -       spin_unlock_irqrestore(&host->lock, flags);
> +       ret = sdhci_runtime_suspend_host(host);
> +       if (ret)
> +               return ret;
>
>         clk_disable_unprepare(pxa->clk_io);
>         if (!IS_ERR(pxa->clk_core))
> @@ -478,17 +478,12 @@ static int sdhci_pxav3_runtime_resume(struct device *dev)
>         struct sdhci_host *host = dev_get_drvdata(dev);
>         struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
>         struct sdhci_pxa *pxa = pltfm_host->priv;
> -       unsigned long flags;
>
>         clk_prepare_enable(pxa->clk_io);
>         if (!IS_ERR(pxa->clk_core))
>                 clk_prepare_enable(pxa->clk_core);
>
> -       spin_lock_irqsave(&host->lock, flags);
> -       host->runtime_suspended = false;
> -       spin_unlock_irqrestore(&host->lock, flags);
> -
> -       return 0;
> +       return sdhci_runtime_resume_host(host);
>  }
>  #endif
>
> --
> 2.1.4
>
