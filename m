Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670AbaIHIQG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 04:16:06 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:27075 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492AbaIHIQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 04:16:00 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-aa-540d65bd2bd7
Message-id: <1410164155.4300.8.camel@AMDC1943>
Subject: Re: [RFC PATCH] dma: pl330: add Power Management support
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Michal Simek <michal.simek@xilinx.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Dan Carpenter <dan.carpenter@oracle.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Mon, 08 Sep 2014 10:15:55 +0200
In-reply-to: <8b73ba80-c055-42c3-a784-96e120482319@BN1BFFO11FD058.protection.gbl>
References: <1409929562-29583-1-git-send-email-k.kozlowski@samsung.com>
 <8b73ba80-c055-42c3-a784-96e120482319@BN1BFFO11FD058.protection.gbl>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsVy+t/xy7p7U3lDDN61GltsnLGe1eL1v+ks
	FtOnXmC0WD31L6vF2aY37BZLJs9ntbi8aw6bxdojd9kt3r2MsHjZt5/Fgctj8Z6XTB5L3hxi
	9fj49BaLR9+WVYwenzfJeez9/JslgC2KyyYlNSezLLVI3y6BK2PasS0sBY0WFU1XpjI2ME7W
	6WLk5JAQMJGY9egsE4QtJnHh3nq2LkYuDiGBpYwSC1o2sEA4nxklPh3qZwap4hXQk+ic+BvM
	FhZwlGhdOxGsm03AWGLz8iVsILaIgJbEp6brTCDNzALvmSS6+nvAGlgEVCX6bu4AK+IUCJbY
	sfM4E8SGPkaJ5fv2gyWYBdQlJs1bBNTAAXSTskRjvxvEYkGJH5PvsUCUyEtsXvOWeQKjwCwk
	HbOQlM1CUraAkXkVo2hqaXJBcVJ6rpFecWJucWleul5yfu4mRkg8fN3BuPSY1SFGAQ5GJR7e
	hKs8IUKsiWXFlbmHGCU4mJVEeBnCeEOEeFMSK6tSi/Lji0pzUosPMTJxcEo1MO4K+DtpluVP
	A837uxoZ/J6JCfB9i1kvP/FV9vSJggv/v8ndt8EyTXFP8hbthU9znvEllrEuv/DJRJJPo/Nf
	QRPXB+9Qhq7GT/89XR9m34o6uil6qX3tx8JPttP6fy86fGbRlNyI3W8kTR3W+VnkRFtPrJ/X
	OLFm/uuZU9LWCz4xaW4/t2/W30IlluKMREMt5qLiRABKpkBMZQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pon, 2014-09-08 at 10:06 +0200, Michal Simek wrote:
> On 09/05/2014 05:06 PM, Krzysztof Kozlowski wrote:
> > This patch adds both normal PM suspend/resume support and runtime PM
> > support to pl330 DMA engine driver.
> > 
> > The runtime power management for pl330 DMA driver allows gating of AMBA
> > clock (PDMA) in FSYS clock domain, when the device is not processing any
> > requests. This is necessary to enter W-AFTR low power mode on Exynos3250.
> > 
> > The patch is based on previous work of Bartlomiej Zolnierkiewicz
> > <b.zolnierkie@samsung.com>.
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > ---
> >  drivers/dma/pl330.c | 78 ++++++++++++++++++++++++++++++++++++++++++++++++++---
> >  1 file changed, 74 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
> > index 66e89f04504c..bdc6ff8ee2bf 100644
> > --- a/drivers/dma/pl330.c
> > +++ b/drivers/dma/pl330.c
> > @@ -27,6 +27,7 @@
> >  #include <linux/of.h>
> >  #include <linux/of_dma.h>
> >  #include <linux/err.h>
> > +#include <linux/pm_runtime.h>
> >  
> >  #include "dmaengine.h"
> >  #define PL330_MAX_CHAN		8
> > @@ -1966,6 +1967,7 @@ static void pl330_tasklet(unsigned long data)
> >  	struct dma_pl330_chan *pch = (struct dma_pl330_chan *)data;
> >  	struct dma_pl330_desc *desc, *_dt;
> >  	unsigned long flags;
> > +	bool power_down = false;
> >  
> >  	spin_lock_irqsave(&pch->lock, flags);
> >  
> > @@ -1980,10 +1982,17 @@ static void pl330_tasklet(unsigned long data)
> >  	/* Try to submit a req imm. next to the last completed cookie */
> >  	fill_queue(pch);
> >  
> > -	/* Make sure the PL330 Channel thread is active */
> > -	spin_lock(&pch->thread->dmac->lock);
> > -	_start(pch->thread);
> > -	spin_unlock(&pch->thread->dmac->lock);
> > +	if (list_empty(&pch->work_list)) {
> > +		spin_lock(&pch->thread->dmac->lock);
> > +		_stop(pch->thread);
> > +		spin_unlock(&pch->thread->dmac->lock);
> > +		power_down = true;
> > +	} else {
> > +		/* Make sure the PL330 Channel thread is active */
> > +		spin_lock(&pch->thread->dmac->lock);
> > +		_start(pch->thread);
> > +		spin_unlock(&pch->thread->dmac->lock);
> > +	}
> >  
> >  	while (!list_empty(&pch->completed_list)) {
> >  		dma_async_tx_callback callback;
> > @@ -1998,6 +2007,12 @@ static void pl330_tasklet(unsigned long data)
> >  		if (pch->cyclic) {
> >  			desc->status = PREP;
> >  			list_move_tail(&desc->node, &pch->work_list);
> > +			if (power_down) {
> > +				spin_lock(&pch->thread->dmac->lock);
> > +				_start(pch->thread);
> > +				spin_unlock(&pch->thread->dmac->lock);
> > +				power_down = false;
> > +			}
> >  		} else {
> >  			desc->status = FREE;
> >  			list_move_tail(&desc->node, &pch->dmac->desc_pool);
> > @@ -2012,6 +2027,10 @@ static void pl330_tasklet(unsigned long data)
> >  		}
> >  	}
> >  	spin_unlock_irqrestore(&pch->lock, flags);
> > +
> > +	/* If work list empty, power down */
> > +	if (power_down)
> > +		pm_runtime_put(pch->dmac->ddma.dev);
> >  }
> >  
> >  bool pl330_filter(struct dma_chan *chan, void *param)
> > @@ -2077,10 +2096,12 @@ static int pl330_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd, unsigned
> >  	unsigned long flags;
> >  	struct pl330_dmac *pl330 = pch->dmac;
> >  	struct dma_slave_config *slave_config;
> > +	bool power_down = false;
> >  	LIST_HEAD(list);
> >  
> >  	switch (cmd) {
> >  	case DMA_TERMINATE_ALL:
> > +		pm_runtime_get_sync(pl330->ddma.dev);
> >  		spin_lock_irqsave(&pch->lock, flags);
> >  
> >  		spin_lock(&pl330->lock);
> > @@ -2107,10 +2128,18 @@ static int pl330_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd, unsigned
> >  			dma_cookie_complete(&desc->txd);
> >  		}
> >  
> > +		if (!list_empty(&pch->work_list))
> > +			power_down = true;
> > +
> >  		list_splice_tail_init(&pch->submitted_list, &pl330->desc_pool);
> >  		list_splice_tail_init(&pch->work_list, &pl330->desc_pool);
> >  		list_splice_tail_init(&pch->completed_list, &pl330->desc_pool);
> >  		spin_unlock_irqrestore(&pch->lock, flags);
> > +		pm_runtime_put(pl330->ddma.dev);
> > +
> > +		/* If work list empty, power down */
> > +		if (power_down)
> > +			pm_runtime_put(pl330->ddma.dev);
> >  		break;
> >  	case DMA_SLAVE_CONFIG:
> >  		slave_config = (struct dma_slave_config *)arg;
> > @@ -2146,6 +2175,7 @@ static void pl330_free_chan_resources(struct dma_chan *chan)
> >  
> >  	tasklet_kill(&pch->task);
> >  
> > +	pm_runtime_get_sync(pch->dmac->ddma.dev);
> >  	spin_lock_irqsave(&pch->lock, flags);
> >  
> >  	pl330_release_channel(pch->thread);
> > @@ -2155,6 +2185,7 @@ static void pl330_free_chan_resources(struct dma_chan *chan)
> >  		list_splice_tail_init(&pch->work_list, &pch->dmac->desc_pool);
> >  
> >  	spin_unlock_irqrestore(&pch->lock, flags);
> > +	pm_runtime_put(pch->dmac->ddma.dev);
> >  }
> >  
> >  static enum dma_status
> > @@ -2168,11 +2199,23 @@ static void pl330_issue_pending(struct dma_chan *chan)
> >  {
> >  	struct dma_pl330_chan *pch = to_pchan(chan);
> >  	unsigned long flags;
> > +	bool power_up;
> >  
> >  	spin_lock_irqsave(&pch->lock, flags);
> > +	power_up = list_empty(&pch->work_list);
> >  	list_splice_tail_init(&pch->submitted_list, &pch->work_list);
> >  	spin_unlock_irqrestore(&pch->lock, flags);
> >  
> > +	if (power_up) {
> > +		/*
> > +		 * Warn on nothing pending. This may break our pm_runtime
> > +		 * usage counter as it is updated on work_list emptiness
> > +		 * status.
> > +		 */
> > +		WARN_ON(list_empty(&pch->work_list));
> > +		pm_runtime_get_sync(pch->dmac->ddma.dev);
> > +	}
> > +
> >  	pl330_tasklet((unsigned long)pch);
> >  }
> >  
> > @@ -2205,6 +2248,7 @@ static dma_cookie_t pl330_tx_submit(struct dma_async_tx_descriptor *tx)
> >  
> >  	cookie = dma_cookie_assign(&last->txd);
> >  	list_add_tail(&last->node, &pch->submitted_list);
> > +
> 
> unrelated change.

Right.

> 
> >  	spin_unlock_irqrestore(&pch->lock, flags);
> >  
> >  	return cookie;
> > @@ -2593,6 +2637,28 @@ static int pl330_dma_device_slave_caps(struct dma_chan *dchan,
> >  	return 0;
> >  }
> >  
> > +#ifdef CONFIG_PM_SLEEP
> 
> remove this line
> 
> > +static int pl330_suspend(struct device *dev)
> 
> __maybe_unused here
> 
> > +{
> > +	struct amba_device *pcdev = to_amba_device(dev);
> > +
> > +	if (!pm_runtime_suspended(dev))
> > +		amba_pclk_disable(pcdev);
> > +	return 0;
> > +}
> > +
> > +static int pl330_resume(struct device *dev)
> 
> __maybe_unused here
> 
> > +{
> > +	struct amba_device *pcdev = to_amba_device(dev);
> > +
> > +	if (!pm_runtime_suspended(dev))
> > +		return amba_pclk_enable(pcdev);
> > +	return 0;
> > +}
> > +#endif
> 
> remove this line
> 
> > +
> > +static SIMPLE_DEV_PM_OPS(pl330_pm, pl330_suspend, pl330_resume);
> 
> Everything is handle inside this macro and your functions are not calling
> anything what it is not defined for both cases.

Thank you for feedback. I'll fix this in next version.

Best regards,
Krzysztof


> 
> Thanks,
> Michal
> 

