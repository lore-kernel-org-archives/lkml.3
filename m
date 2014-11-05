Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903AbaKEOVq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 09:21:46 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:40447 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715AbaKEOVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 09:21:44 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7f956d000005ed7-3a-545a3274b01d
Content-transfer-encoding: 8BIT
Message-id: <1415197299.30831.10.camel@AMDC1943>
Subject: Re: [PATCH v9 3/4] dma: pl330: add Power Management support
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Vinod Koul <vinod.koul@intel.com>
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
Date: Wed, 05 Nov 2014 15:21:39 +0100
In-reply-to: <20141105140116.GN1870@intel.com>
References: <1415105570-7871-1-git-send-email-k.kozlowski@samsung.com>
 <1415105570-7871-4-git-send-email-k.kozlowski@samsung.com>
 <20141105140116.GN1870@intel.com>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJIsWRmVeSWpSXmKPExsVy+t/xq7olRlEhBnc2m1psnLGe1eLJgXZG
	i+lTLzBarJ76l9Xi6ebHTBZnm96wWyyZPJ/VonPiEnaLWVP2Mllc3jWHzeJz7xFGi9uXeS3W
	HrnLbvHuZYTF3VNH2SzOnL7EajHh9wU2i+Nrwy1e9u1ncRD2aGnuYfOY3TGT1WPxnpdMHptW
	dbJ53Lm2h81jcd9kVo8lbw6xemy52s7iMfvuD0aPvi2rGD1WrP7O7vF5k5zH3s+/WQJ4o7hs
	UlJzMstSi/TtErgyWu5PZSk4q1bx9Hd9A+NXuS5GDg4JAROJlnlpXYycQKaYxIV769lAbCGB
	pYwSz7skQWxeAUGJH5PvsYCUMwvISxy5lA0SZhZQl5g0bxFzFyMXUPlnRonT1w+wQtQbSCze
	+5kdxBYWcJHYtPAGI4jNJmAssXn5ErD5IgKqElt+djCCNDMLHGeVWDH3BivIAhagxMJXKSA1
	nAJ6EicWTWOGuGc5o8TnbieIk5UlGvvdJjAKzEJy3SyE62YhuW4BI/MqRtHU0uSC4qT0XCO9
	4sTc4tK8dL3k/NxNjJDo/LqDcekxq0OMAhyMSjy8Hk2RIUKsiWXFlbmHGCU4mJVEeJu0o0KE
	eFMSK6tSi/Lji0pzUosPMTJxcEo1MArwmDgom19MvTj1ou2jW5v6+BcnJmQ3LLz4yED1ev3v
	CTaVE5PvK05eosFZX5b+P8XKaNkVgZ6PGQ01hzeKzuB/8f6o8Fpl/vPPFmdNOPvJ2fFgraGm
	mr1ZPnvfo39Kf/1ks5Z6mtmHeqgulbKOmnMi/PTxmnCnyffW8s6NY2eKmL0iY110jhJLcUai
	oRZzUXEiACWJA5ysAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On śro, 2014-11-05 at 19:31 +0530, Vinod Koul wrote:
> On Tue, Nov 04, 2014 at 01:52:49PM +0100, Krzysztof Kozlowski wrote:
> >  bool pl330_filter(struct dma_chan *chan, void *param)
> > @@ -2073,6 +2097,7 @@ static int pl330_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd, unsigned
> >  
> >  	switch (cmd) {
> >  	case DMA_TERMINATE_ALL:
> > +		pm_runtime_get_sync(pl330->ddma.dev);
> Why do we need _get() here? If we are terminating then channel is already in
> use so should be active?

The runtime PM is kind a aggressive here so I think the device could be
suspended in that moment. The terminate may happen some time after
channel was used.

> 
> >  		spin_lock_irqsave(&pch->lock, flags);
> >  
> >  		spin_lock(&pl330->lock);
> > @@ -2099,10 +2124,15 @@ static int pl330_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd, unsigned
> >  			dma_cookie_complete(&desc->txd);
> >  		}
> >  
> > +		if (!list_empty(&pch->work_list))
> > +			pm_runtime_put(pl330->ddma.dev);
> Well else should be error here, so I would expect loud complains in that
> case here

The 'else' path is fine. Just the terminate command was triggered when
work_list was empty. 

The 'else' here could be triggered easily with:

echo dma0chan0 > /sys/module/dmatest/parameters/channel
echo 1 > /sys/module/dmatest/parameters/run
sleep 3
cat /sys/module/dmatest/parameters/run


> > +
> >  		list_splice_tail_init(&pch->submitted_list, &pl330->desc_pool);
> >  		list_splice_tail_init(&pch->work_list, &pl330->desc_pool);
> >  		list_splice_tail_init(&pch->completed_list, &pl330->desc_pool);
> >  		spin_unlock_irqrestore(&pch->lock, flags);
> > +		pm_runtime_mark_last_busy(pl330->ddma.dev);
> > +		pm_runtime_put_autosuspend(pl330->ddma.dev);
> >  		break;
> >  	case DMA_SLAVE_CONFIG:
> >  		slave_config = (struct dma_slave_config *)arg;
> > @@ -2138,6 +2168,7 @@ static void pl330_free_chan_resources(struct dma_chan *chan)
> >  
> >  	tasklet_kill(&pch->task);
> >  
> > +	pm_runtime_get_sync(pch->dmac->ddma.dev);
> Again why do we need _get() in free callback.

Hmmm... I think because of the same reason as terminate_all. It may
happen after some time since last usage. The driver here stops thread
which requires device resumed.

> 
> >  	spin_lock_irqsave(&pch->lock, flags);
> >  
> >  	pl330_release_channel(pch->thread);
> > @@ -2147,6 +2178,8 @@ static void pl330_free_chan_resources(struct dma_chan *chan)
> >  		list_splice_tail_init(&pch->work_list, &pch->dmac->desc_pool);
> >  
> >  	spin_unlock_irqrestore(&pch->lock, flags);
> > +	pm_runtime_mark_last_busy(pch->dmac->ddma.dev);
> > +	pm_runtime_put_autosuspend(pch->dmac->ddma.dev);
> >  }
> 
> > +
> > +static int __maybe_unused pl330_resume(struct device *dev)
> > +{
> > +	struct amba_device *pcdev = to_amba_device(dev);
> > +
> > +	amba_pclk_prepare(pcdev);
> > +
> > +	/*
> > +	 * TODO: Idea for future. The device should not be woken up after
> > +	 * system resume if it is not needed. It could stay runtime suspended
> > +	 * waiting for DMA requests. However for safe suspend and resume we
> > +	 * forcibly resume the device here.
> > +	 */
> > +	return pm_runtime_force_resume(dev);
> > +}
> > +
> > +static SIMPLE_DEV_PM_OPS(pl330_pm, pl330_suspend, pl330_resume);
> IIUC this sets .suspend and .resume, aren't you trying to add runtime
> support as well?
> Did you want UNIVERSAL_DEV_PM_OPS() ?

The runtime suspend and resume callbacks are provided by amba/bus.c.

> 
> > +
> >  static int
> >  pl330_probe(struct amba_device *adev, const struct amba_id *id)
> >  {
> > @@ -2738,6 +2815,12 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
> >  		pcfg->data_buf_dep, pcfg->data_bus_width / 8, pcfg->num_chan,
> >  		pcfg->num_peri, pcfg->num_events);
> >  
> > +	pm_runtime_irq_safe(&adev->dev);
> > +	pm_runtime_use_autosuspend(&adev->dev);
> > +	pm_runtime_set_autosuspend_delay(&adev->dev, PL330_AUTOSUSPEND_DELAY);
> > +	pm_runtime_mark_last_busy(&adev->dev);
> > +	pm_runtime_put_autosuspend(&adev->dev);
> > +
> >  	return 0;
> >  probe_err3:
> >  	/* Idle the DMAC */
> > @@ -2764,6 +2847,8 @@ static int pl330_remove(struct amba_device *adev)
> >  	struct pl330_dmac *pl330 = amba_get_drvdata(adev);
> >  	struct dma_pl330_chan *pch, *_p;
> >  
> > +	pm_runtime_get_noresume(pl330->ddma.dev);
> > +
> >  	if (adev->dev.of_node)
> >  		of_dma_controller_free(adev->dev.of_node);
> >  
> > @@ -2802,6 +2887,7 @@ static struct amba_driver pl330_driver = {
> >  	.drv = {
> >  		.owner = THIS_MODULE,
> >  		.name = "dma-pl330",
> > +		.pm = &pl330_pm,
> >  	},
> >  	.id_table = pl330_ids,
> >  	.probe = pl330_probe,
> > -- 
> > 1.9.1
> > 
> 
> Last please use the right subsystem name, dmaengine is patches.

Sure, I just got confused by name of directory.

Thanks for looking at code,
Krzysztof

