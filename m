Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148AbaKDKGE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 05:06:04 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:45137 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012AbaKDKF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 05:05:57 -0500
MIME-Version: 1.0
In-Reply-To: <1414641641-32691-1-git-send-email-wenyou.yang@atmel.com>
References: <1414641641-32691-1-git-send-email-wenyou.yang@atmel.com>
Date: Tue, 4 Nov 2014 11:05:56 +0100
Message-ID: <CAPDyKFpVjoyNWpuZJ=k=nvcZkfarJtJ9oNAVjRBvmqZKuedxfA@mail.gmail.com>
Subject: Re: [PATCH v2] mmc: atmel-mci: add runtime pm support
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Ludovic Desroches <ludovic.desroches@atmel.com>
Cc: Chris Ball <chris@printf.net>, Wenyou Yang <wenyou.yang@atmel.com>,
        Kevin Hilman <khilman@kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 October 2014 05:00, Wenyou Yang <wenyou.yang@atmel.com> wrote:
> Add runtime pm support to atmel mci controller.
> Use runtime pm APIs to enable/disable atmel mci's clock.
> Use runtime autosuspend APIs to enable auto suspend delay.
>
> Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>

Ludovic, any objections to this one?

Kind regards
Uffe

> ---
> Changes v1 -> v2:
> * Adjust the APIs and invoking sequence to avoid clock unbalance issue during ->probe.
> * Fix miss to invoke clk_disable_unprepare() in the error handling in ->probe.
> * Remove atmci_suspend/resume and use pm_runtime_force_suspend/resume() to simplify code.
>
>  drivers/mmc/host/atmel-mci.c |   90 +++++++++++++++++++++++++++++++-----------
>  1 file changed, 67 insertions(+), 23 deletions(-)
>
> diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
> index 0b9ddf8..f8f2bbe 100644
> --- a/drivers/mmc/host/atmel-mci.c
> +++ b/drivers/mmc/host/atmel-mci.c
> @@ -37,6 +37,8 @@
>
>  #include <linux/atmel-mci.h>
>  #include <linux/atmel_pdc.h>
> +#include <linux/pm.h>
> +#include <linux/pm_runtime.h>
>
>  #include <asm/cacheflush.h>
>  #include <asm/io.h>
> @@ -44,6 +46,8 @@
>
>  #include "atmel-mci-regs.h"
>
> +#define AUTOSUSPEND_DELAY      50
> +
>  #define ATMCI_DATA_ERROR_FLAGS (ATMCI_DCRCE | ATMCI_DTOE | ATMCI_OVRE | ATMCI_UNRE)
>  #define ATMCI_DMA_THRESHOLD    16
>
> @@ -386,20 +390,19 @@ static int atmci_regs_show(struct seq_file *s, void *v)
>         if (!buf)
>                 return -ENOMEM;
>
> +       pm_runtime_get_sync(&host->pdev->dev);
> +
>         /*
>          * Grab a more or less consistent snapshot. Note that we're
>          * not disabling interrupts, so IMR and SR may not be
>          * consistent.
>          */
> -       ret = clk_prepare_enable(host->mck);
> -       if (ret)
> -               goto out;
> -
>         spin_lock_bh(&host->lock);
>         memcpy_fromio(buf, host->regs, ATMCI_REGS_SIZE);
>         spin_unlock_bh(&host->lock);
>
> -       clk_disable_unprepare(host->mck);
> +       pm_runtime_mark_last_busy(&host->pdev->dev);
> +       pm_runtime_put_autosuspend(&host->pdev->dev);
>
>         seq_printf(s, "MR:\t0x%08x%s%s ",
>                         buf[ATMCI_MR / 4],
> @@ -449,7 +452,6 @@ static int atmci_regs_show(struct seq_file *s, void *v)
>                                 val & ATMCI_CFG_LSYNC ? " LSYNC" : "");
>         }
>
> -out:
>         kfree(buf);
>
>         return ret;
> @@ -1252,6 +1254,8 @@ static void atmci_request(struct mmc_host *mmc, struct mmc_request *mrq)
>         WARN_ON(slot->mrq);
>         dev_dbg(&host->pdev->dev, "MRQ: cmd %u\n", mrq->cmd->opcode);
>
> +       pm_runtime_get_sync(&host->pdev->dev);
> +
>         /*
>          * We may "know" the card is gone even though there's still an
>          * electrical connection. If so, we really need to communicate
> @@ -1281,7 +1285,8 @@ static void atmci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
>         struct atmel_mci_slot   *slot = mmc_priv(mmc);
>         struct atmel_mci        *host = slot->host;
>         unsigned int            i;
> -       bool                    unprepare_clk;
> +
> +       pm_runtime_get_sync(&host->pdev->dev);
>
>         slot->sdc_reg &= ~ATMCI_SDCBUS_MASK;
>         switch (ios->bus_width) {
> @@ -1297,13 +1302,8 @@ static void atmci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
>                 unsigned int clock_min = ~0U;
>                 u32 clkdiv;
>
> -               clk_prepare(host->mck);
> -               unprepare_clk = true;
> -
>                 spin_lock_bh(&host->lock);
>                 if (!host->mode_reg) {
> -                       clk_enable(host->mck);
> -                       unprepare_clk = false;
>                         atmci_writel(host, ATMCI_CR, ATMCI_CR_SWRST);
>                         atmci_writel(host, ATMCI_CR, ATMCI_CR_MCIEN);
>                         if (host->caps.has_cfg_reg)
> @@ -1371,8 +1371,6 @@ static void atmci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
>         } else {
>                 bool any_slot_active = false;
>
> -               unprepare_clk = false;
> -
>                 spin_lock_bh(&host->lock);
>                 slot->clock = 0;
>                 for (i = 0; i < ATMCI_MAX_NR_SLOTS; i++) {
> @@ -1385,17 +1383,12 @@ static void atmci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
>                         atmci_writel(host, ATMCI_CR, ATMCI_CR_MCIDIS);
>                         if (host->mode_reg) {
>                                 atmci_readl(host, ATMCI_MR);
> -                               clk_disable(host->mck);
> -                               unprepare_clk = true;
>                         }
>                         host->mode_reg = 0;
>                 }
>                 spin_unlock_bh(&host->lock);
>         }
>
> -       if (unprepare_clk)
> -               clk_unprepare(host->mck);
> -
>         switch (ios->power_mode) {
>         case MMC_POWER_OFF:
>                 if (!IS_ERR(mmc->supply.vmmc))
> @@ -1421,6 +1414,9 @@ static void atmci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
>                  */
>                 break;
>         }
> +
> +       pm_runtime_mark_last_busy(&host->pdev->dev);
> +       pm_runtime_put_autosuspend(&host->pdev->dev);
>  }
>
>  static int atmci_get_ro(struct mmc_host *mmc)
> @@ -1512,6 +1508,9 @@ static void atmci_request_end(struct atmel_mci *host, struct mmc_request *mrq)
>         spin_unlock(&host->lock);
>         mmc_request_done(prev_mmc, mrq);
>         spin_lock(&host->lock);
> +
> +       pm_runtime_mark_last_busy(&host->pdev->dev);
> +       pm_runtime_put_autosuspend(&host->pdev->dev);
>  }
>
>  static void atmci_command_complete(struct atmel_mci *host,
> @@ -2417,15 +2416,16 @@ static int __init atmci_probe(struct platform_device *pdev)
>
>         atmci_writel(host, ATMCI_CR, ATMCI_CR_SWRST);
>         host->bus_hz = clk_get_rate(host->mck);
> -       clk_disable_unprepare(host->mck);
>
>         host->mapbase = regs->start;
>
>         tasklet_init(&host->tasklet, atmci_tasklet_func, (unsigned long)host);
>
>         ret = request_irq(irq, atmci_interrupt, 0, dev_name(&pdev->dev), host);
> -       if (ret)
> +       if (ret) {
> +               clk_disable_unprepare(host->mck);
>                 return ret;
> +       }
>
>         /* Get MCI capabilities and set operations according to it */
>         atmci_get_cap(host);
> @@ -2449,6 +2449,12 @@ static int __init atmci_probe(struct platform_device *pdev)
>
>         setup_timer(&host->timer, atmci_timeout_timer, (unsigned long)host);
>
> +       pm_runtime_get_noresume(&pdev->dev);
> +       pm_runtime_set_active(&pdev->dev);
> +       pm_runtime_set_autosuspend_delay(&pdev->dev, AUTOSUSPEND_DELAY);
> +       pm_runtime_use_autosuspend(&pdev->dev);
> +       pm_runtime_enable(&pdev->dev);
> +
>         /* We need at least one slot to succeed */
>         nr_slots = 0;
>         ret = -ENODEV;
> @@ -2491,6 +2497,9 @@ static int __init atmci_probe(struct platform_device *pdev)
>                         "Atmel MCI controller at 0x%08lx irq %d, %u slots\n",
>                         host->mapbase, irq, nr_slots);
>
> +       pm_runtime_mark_last_busy(&host->pdev->dev);
> +       pm_runtime_put_autosuspend(&pdev->dev);
> +
>         return 0;
>
>  err_dma_alloc:
> @@ -2499,6 +2508,11 @@ err_dma_alloc:
>                         atmci_cleanup_slot(host->slot[i], i);
>         }
>  err_init_slot:
> +       clk_disable_unprepare(host->mck);
> +
> +       pm_runtime_disable(&pdev->dev);
> +       pm_runtime_put_noidle(&pdev->dev);
> +
>         del_timer_sync(&host->timer);
>         if (host->dma.chan)
>                 dma_release_channel(host->dma.chan);
> @@ -2511,6 +2525,8 @@ static int __exit atmci_remove(struct platform_device *pdev)
>         struct atmel_mci        *host = platform_get_drvdata(pdev);
>         unsigned int            i;
>
> +       pm_runtime_get_sync(&pdev->dev);
> +
>         if (host->buffer)
>                 dma_free_coherent(&pdev->dev, host->buf_size,
>                                   host->buffer, host->buf_phys_addr);
> @@ -2520,11 +2536,9 @@ static int __exit atmci_remove(struct platform_device *pdev)
>                         atmci_cleanup_slot(host->slot[i], i);
>         }
>
> -       clk_prepare_enable(host->mck);
>         atmci_writel(host, ATMCI_IDR, ~0UL);
>         atmci_writel(host, ATMCI_CR, ATMCI_CR_MCIDIS);
>         atmci_readl(host, ATMCI_SR);
> -       clk_disable_unprepare(host->mck);
>
>         del_timer_sync(&host->timer);
>         if (host->dma.chan)
> @@ -2532,14 +2546,44 @@ static int __exit atmci_remove(struct platform_device *pdev)
>
>         free_irq(platform_get_irq(pdev, 0), host);
>
> +       clk_disable_unprepare(host->mck);
> +
> +       pm_runtime_disable(&pdev->dev);
> +       pm_runtime_put_noidle(&pdev->dev);
> +
> +       return 0;
> +}
> +
> +#ifdef CONFIG_PM
> +static int atmci_runtime_suspend(struct device *dev)
> +{
> +       struct atmel_mci *host = dev_get_drvdata(dev);
> +
> +       clk_disable_unprepare(host->mck);
> +
>         return 0;
>  }
>
> +static int atmci_runtime_resume(struct device *dev)
> +{
> +       struct atmel_mci *host = dev_get_drvdata(dev);
> +
> +       return clk_prepare_enable(host->mck);
> +}
> +
> +static const struct dev_pm_ops atmci_dev_pm_ops = {
> +       SET_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend,
> +                               pm_runtime_force_resume)
> +       SET_PM_RUNTIME_PM_OPS(atmci_runtime_suspend, atmci_runtime_resume, NULL)
> +};
> +#endif
> +
>  static struct platform_driver atmci_driver = {
>         .remove         = __exit_p(atmci_remove),
>         .driver         = {
>                 .name           = "atmel_mci",
>                 .of_match_table = of_match_ptr(atmci_dt_ids),
> +               .pm             = &atmci_dev_pm_ops,
>         },
>  };
>
> --
> 1.7.9.5
>
