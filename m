Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909AbaKEOBG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 09:01:06 -0500
Received: from mga14.intel.com ([192.55.52.115]:56368 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753988AbaKEOBC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 09:01:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,320,1413270000"; 
   d="scan'208";a="617555719"
Date: Wed, 5 Nov 2014 19:31:16 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Jonathan Corbet <corbet@lwn.net>,
        Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>,
        Kevin Hilman <khilman@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v9 3/4] dma: pl330: add Power Management support
Message-ID: <20141105140116.GN1870@intel.com>
References: <1415105570-7871-1-git-send-email-k.kozlowski@samsung.com>
 <1415105570-7871-4-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415105570-7871-4-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 01:52:49PM +0100, Krzysztof Kozlowski wrote:
>  bool pl330_filter(struct dma_chan *chan, void *param)
> @@ -2073,6 +2097,7 @@ static int pl330_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd, unsigned
>  
>  	switch (cmd) {
>  	case DMA_TERMINATE_ALL:
> +		pm_runtime_get_sync(pl330->ddma.dev);
Why do we need _get() here? If we are terminating then channel is already in
use so should be active?

>  		spin_lock_irqsave(&pch->lock, flags);
>  
>  		spin_lock(&pl330->lock);
> @@ -2099,10 +2124,15 @@ static int pl330_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd, unsigned
>  			dma_cookie_complete(&desc->txd);
>  		}
>  
> +		if (!list_empty(&pch->work_list))
> +			pm_runtime_put(pl330->ddma.dev);
Well else should be error here, so I would expect loud complains in that
case here
> +
>  		list_splice_tail_init(&pch->submitted_list, &pl330->desc_pool);
>  		list_splice_tail_init(&pch->work_list, &pl330->desc_pool);
>  		list_splice_tail_init(&pch->completed_list, &pl330->desc_pool);
>  		spin_unlock_irqrestore(&pch->lock, flags);
> +		pm_runtime_mark_last_busy(pl330->ddma.dev);
> +		pm_runtime_put_autosuspend(pl330->ddma.dev);
>  		break;
>  	case DMA_SLAVE_CONFIG:
>  		slave_config = (struct dma_slave_config *)arg;
> @@ -2138,6 +2168,7 @@ static void pl330_free_chan_resources(struct dma_chan *chan)
>  
>  	tasklet_kill(&pch->task);
>  
> +	pm_runtime_get_sync(pch->dmac->ddma.dev);
Again why do we need _get() in free callback.

>  	spin_lock_irqsave(&pch->lock, flags);
>  
>  	pl330_release_channel(pch->thread);
> @@ -2147,6 +2178,8 @@ static void pl330_free_chan_resources(struct dma_chan *chan)
>  		list_splice_tail_init(&pch->work_list, &pch->dmac->desc_pool);
>  
>  	spin_unlock_irqrestore(&pch->lock, flags);
> +	pm_runtime_mark_last_busy(pch->dmac->ddma.dev);
> +	pm_runtime_put_autosuspend(pch->dmac->ddma.dev);
>  }

> +
> +static int __maybe_unused pl330_resume(struct device *dev)
> +{
> +	struct amba_device *pcdev = to_amba_device(dev);
> +
> +	amba_pclk_prepare(pcdev);
> +
> +	/*
> +	 * TODO: Idea for future. The device should not be woken up after
> +	 * system resume if it is not needed. It could stay runtime suspended
> +	 * waiting for DMA requests. However for safe suspend and resume we
> +	 * forcibly resume the device here.
> +	 */
> +	return pm_runtime_force_resume(dev);
> +}
> +
> +static SIMPLE_DEV_PM_OPS(pl330_pm, pl330_suspend, pl330_resume);
IIUC this sets .suspend and .resume, aren't you trying to add runtime
support as well?
Did you want UNIVERSAL_DEV_PM_OPS() ?

> +
>  static int
>  pl330_probe(struct amba_device *adev, const struct amba_id *id)
>  {
> @@ -2738,6 +2815,12 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
>  		pcfg->data_buf_dep, pcfg->data_bus_width / 8, pcfg->num_chan,
>  		pcfg->num_peri, pcfg->num_events);
>  
> +	pm_runtime_irq_safe(&adev->dev);
> +	pm_runtime_use_autosuspend(&adev->dev);
> +	pm_runtime_set_autosuspend_delay(&adev->dev, PL330_AUTOSUSPEND_DELAY);
> +	pm_runtime_mark_last_busy(&adev->dev);
> +	pm_runtime_put_autosuspend(&adev->dev);
> +
>  	return 0;
>  probe_err3:
>  	/* Idle the DMAC */
> @@ -2764,6 +2847,8 @@ static int pl330_remove(struct amba_device *adev)
>  	struct pl330_dmac *pl330 = amba_get_drvdata(adev);
>  	struct dma_pl330_chan *pch, *_p;
>  
> +	pm_runtime_get_noresume(pl330->ddma.dev);
> +
>  	if (adev->dev.of_node)
>  		of_dma_controller_free(adev->dev.of_node);
>  
> @@ -2802,6 +2887,7 @@ static struct amba_driver pl330_driver = {
>  	.drv = {
>  		.owner = THIS_MODULE,
>  		.name = "dma-pl330",
> +		.pm = &pl330_pm,
>  	},
>  	.id_table = pl330_ids,
>  	.probe = pl330_probe,
> -- 
> 1.9.1
> 

Last please use the right subsystem name, dmaengine is patches.

-- 
~Vinod
