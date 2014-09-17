Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964AbaIQSm7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 14:42:59 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:56303 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755632AbaIQSm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 14:42:56 -0400
MIME-Version: 1.0
In-Reply-To: <1410857494-15936-5-git-send-email-k.kozlowski@samsung.com>
References: <1410857494-15936-1-git-send-email-k.kozlowski@samsung.com>
	<1410857494-15936-5-git-send-email-k.kozlowski@samsung.com>
Date: Wed, 17 Sep 2014 20:42:55 +0200
Message-ID: <CAPDyKFqoLQh=FYg33LTSp-HTs-oJDT4y_K6hGRoiu9zDxOX9sw@mail.gmail.com>
Subject: Re: [PATCH v4 4/4] dma: pl330: add Power Management support
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dmaengine@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Randy Dunlap <rdunlap@infradead.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 September 2014 10:51, Krzysztof Kozlowski <k.kozlowski@samsung.com> wrote:
> This patch adds both normal PM suspend/resume support and runtime PM
> support to pl330 DMA engine driver.
>
> The runtime power management for pl330 DMA driver allows gating of AMBA
> clock (PDMA) in FSYS clock domain, when the device is not processing any
> requests. This is necessary to enter low power modes on Exynos SoCs
> (e.g. LPA on Exynos4x12 or W-AFTR on Exynos3250).
>
> Runtime PM resuming of the device may happen in atomic context (during
> call device_issue_pending()) so pm_runtime_irq_safe() is used. This will
> lead only to disabling/enabling of the clock but this is sufficient for
> gating the clock and for reducing energy usage.
>
> During system sleep the AMBA bus clock is also unprepared.
>
> Suggested-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  drivers/dma/pl330.c | 77 ++++++++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 73 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
> index 4839bfa74a10..9c014874c33d 100644
> --- a/drivers/dma/pl330.c
> +++ b/drivers/dma/pl330.c
> @@ -27,6 +27,7 @@
>  #include <linux/of.h>
>  #include <linux/of_dma.h>
>  #include <linux/err.h>
> +#include <linux/pm_runtime.h>
>
>  #include "dmaengine.h"
>  #define PL330_MAX_CHAN         8
> @@ -1958,6 +1959,7 @@ static void pl330_tasklet(unsigned long data)
>         struct dma_pl330_chan *pch = (struct dma_pl330_chan *)data;
>         struct dma_pl330_desc *desc, *_dt;
>         unsigned long flags;
> +       bool power_down = false;
>
>         spin_lock_irqsave(&pch->lock, flags);
>
> @@ -1972,10 +1974,17 @@ static void pl330_tasklet(unsigned long data)
>         /* Try to submit a req imm. next to the last completed cookie */
>         fill_queue(pch);
>
> -       /* Make sure the PL330 Channel thread is active */
> -       spin_lock(&pch->thread->dmac->lock);
> -       _start(pch->thread);
> -       spin_unlock(&pch->thread->dmac->lock);
> +       if (list_empty(&pch->work_list)) {
> +               spin_lock(&pch->thread->dmac->lock);
> +               _stop(pch->thread);
> +               spin_unlock(&pch->thread->dmac->lock);
> +               power_down = true;
> +       } else {
> +               /* Make sure the PL330 Channel thread is active */
> +               spin_lock(&pch->thread->dmac->lock);
> +               _start(pch->thread);
> +               spin_unlock(&pch->thread->dmac->lock);
> +       }
>
>         while (!list_empty(&pch->completed_list)) {
>                 dma_async_tx_callback callback;
> @@ -1990,6 +1999,12 @@ static void pl330_tasklet(unsigned long data)
>                 if (pch->cyclic) {
>                         desc->status = PREP;
>                         list_move_tail(&desc->node, &pch->work_list);
> +                       if (power_down) {
> +                               spin_lock(&pch->thread->dmac->lock);
> +                               _start(pch->thread);
> +                               spin_unlock(&pch->thread->dmac->lock);
> +                               power_down = false;
> +                       }
>                 } else {
>                         desc->status = FREE;
>                         list_move_tail(&desc->node, &pch->dmac->desc_pool);
> @@ -2004,6 +2019,10 @@ static void pl330_tasklet(unsigned long data)
>                 }
>         }
>         spin_unlock_irqrestore(&pch->lock, flags);
> +
> +       /* If work list empty, power down */
> +       if (power_down)
> +               pm_runtime_put(pch->dmac->ddma.dev);
>  }
>
>  bool pl330_filter(struct dma_chan *chan, void *param)
> @@ -2073,6 +2092,7 @@ static int pl330_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd, unsigned
>
>         switch (cmd) {
>         case DMA_TERMINATE_ALL:
> +               pm_runtime_get_sync(pl330->ddma.dev);
>                 spin_lock_irqsave(&pch->lock, flags);
>
>                 spin_lock(&pl330->lock);
> @@ -2099,10 +2119,14 @@ static int pl330_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd, unsigned
>                         dma_cookie_complete(&desc->txd);
>                 }
>
> +               if (!list_empty(&pch->work_list))
> +                       pm_runtime_put(pl330->ddma.dev);
> +
>                 list_splice_tail_init(&pch->submitted_list, &pl330->desc_pool);
>                 list_splice_tail_init(&pch->work_list, &pl330->desc_pool);
>                 list_splice_tail_init(&pch->completed_list, &pl330->desc_pool);
>                 spin_unlock_irqrestore(&pch->lock, flags);
> +               pm_runtime_put(pl330->ddma.dev);
>                 break;
>         case DMA_SLAVE_CONFIG:
>                 slave_config = (struct dma_slave_config *)arg;
> @@ -2138,6 +2162,7 @@ static void pl330_free_chan_resources(struct dma_chan *chan)
>
>         tasklet_kill(&pch->task);
>
> +       pm_runtime_get_sync(pch->dmac->ddma.dev);
>         spin_lock_irqsave(&pch->lock, flags);
>
>         pl330_release_channel(pch->thread);
> @@ -2147,6 +2172,7 @@ static void pl330_free_chan_resources(struct dma_chan *chan)
>                 list_splice_tail_init(&pch->work_list, &pch->dmac->desc_pool);
>
>         spin_unlock_irqrestore(&pch->lock, flags);
> +       pm_runtime_put(pch->dmac->ddma.dev);
>  }
>
>  static enum dma_status
> @@ -2162,6 +2188,15 @@ static void pl330_issue_pending(struct dma_chan *chan)
>         unsigned long flags;
>
>         spin_lock_irqsave(&pch->lock, flags);
> +       if (list_empty(&pch->work_list)) {
> +               /*
> +                * Warn on nothing pending. Empty submitted_list may
> +                * break our pm_runtime usage counter as it is
> +                * updated on work_list emptiness status.
> +                */
> +               WARN_ON(list_empty(&pch->submitted_list));
> +               pm_runtime_get_sync(pch->dmac->ddma.dev);
> +       }
>         list_splice_tail_init(&pch->submitted_list, &pch->work_list);
>         spin_unlock_irqrestore(&pch->lock, flags);
>
> @@ -2585,6 +2620,34 @@ static int pl330_dma_device_slave_caps(struct dma_chan *dchan,
>         return 0;
>  }
>
> +/*
> + * Assume that IRQ safe runtime PM is chosen in probe and amba bus driver
> + * will only disable/enable the clock in runtime PM suspend/resume.
> + */
> +static int __maybe_unused pl330_suspend(struct device *dev)
> +{
> +       struct amba_device *pcdev = to_amba_device(dev);
> +
> +       if (!pm_runtime_suspended(dev))
> +               amba_pclk_disable(pcdev);

I would suggest to use pm_runtime_force_suspend() instead of the above.

> +       amba_pclk_unprepare(pcdev);
> +
> +       return 0;
> +}
> +
> +static int __maybe_unused pl330_resume(struct device *dev)
> +{
> +       struct amba_device *pcdev = to_amba_device(dev);
> +
> +       amba_pclk_prepare(pcdev);
> +       if (!pm_runtime_suspended(dev))
> +               return amba_pclk_enable(pcdev);

The above if statement could be replaced with pm_runtime_force_resume().

Doing that, means the amba_pclk_enable|disable() don't need to be
exported from the AMBA bus header, but entirely handled by the AMBA
bus itself.

> +
> +       return 0;
> +}
> +
> +static SIMPLE_DEV_PM_OPS(pl330_pm, pl330_suspend, pl330_resume);
> +
>  static int
>  pl330_probe(struct amba_device *adev, const struct amba_id *id)
>  {
> @@ -2738,6 +2801,9 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
>                 pcfg->data_buf_dep, pcfg->data_bus_width / 8, pcfg->num_chan,
>                 pcfg->num_peri, pcfg->num_events);
>

You need pm_runtime_set_active() here as well.

> +       pm_runtime_irq_safe(&adev->dev);
> +       pm_runtime_put_noidle(&adev->dev);

Why pm_runtime_put_noidle(), that seems like you might end up leaving
the device in active state - unless you get some request. Likely not
what you want?

A final question, have you considered using runtime PM autosuspend
feature. Any reason to why not?

> +
>         return 0;
>  probe_err3:
>         /* Idle the DMAC */
> @@ -2764,6 +2830,8 @@ static int pl330_remove(struct amba_device *adev)
>         struct pl330_dmac *pl330 = amba_get_drvdata(adev);
>         struct dma_pl330_chan *pch, *_p;
>
> +       pm_runtime_get_noresume(pl330->ddma.dev);
> +
>         if (adev->dev.of_node)
>                 of_dma_controller_free(adev->dev.of_node);
>
> @@ -2802,6 +2870,7 @@ static struct amba_driver pl330_driver = {
>         .drv = {
>                 .owner = THIS_MODULE,
>                 .name = "dma-pl330",
> +               .pm = &pl330_pm,
>         },
>         .id_table = pl330_ids,
>         .probe = pl330_probe,
> --
> 1.9.1
>

Kind regards
Uffe
