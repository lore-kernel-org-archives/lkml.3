Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924Ab3J3UbO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 16:31:14 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:56656 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754315Ab3J3UbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 16:31:10 -0400
Date: Wed, 30 Oct 2013 15:31:05 -0500
From: Andy Gross <agross@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>
Subject: Re: [PATCH 1/2] dmaengine: add msm bam dma driver
Message-ID: <20131030203105.GA14525@agross>
References: <1382732643-8184-1-git-send-email-agross@codeaurora.org>
 <1382732643-8184-2-git-send-email-agross@codeaurora.org>
 <20131029175603.GF21983@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131029175603.GF21983@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 10:56:03AM -0700, Stephen Boyd wrote:
> On 10/25, Andy Gross wrote:
> > diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
> > index f238cfd..a71b415 100644
> > --- a/drivers/dma/Kconfig
> > +++ b/drivers/dma/Kconfig
> > @@ -364,4 +364,13 @@ config DMATEST
> >  	  Simple DMA test client. Say N unless you're debugging a
> >  	  DMA Device driver.
> >  
> > +
> > +config MSM_BAM_DMA
> > +	tristate "MSM BAM DMA support"
> > +	depends on ARCH_MSM
> 
> It would be nice if we didn't have to rely on ARCH_MSM here so we
> get more build coverage.
 
I can remove that.  There is nothing that forces this depend option.

> > +	select DMA_ENGINE
> > +	---help---
> > +	  Enable support for the MSM BAM DMA controller.  This controller
> > +	  provides DMA capabilities for a variety of on-chip devices.
> > +
> >  endif
> > diff --git a/drivers/dma/msm_bam_dma.c b/drivers/dma/msm_bam_dma.c
> > new file mode 100644
> > index 0000000..d16bf94
> > --- /dev/null
> > +++ b/drivers/dma/msm_bam_dma.c
> > @@ -0,0 +1,840 @@
> > +/*
> > + * MSM BAM DMA engine driver
> > + *
> > + * Copyright (c) 2013, The Linux Foundation. All rights reserved.
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 and
> > + * only version 2 as published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#include <linux/kernel.h>
> > +#include <linux/io.h>
> > +#include <linux/init.h>
> > +#include <linux/slab.h>
> > +#include <linux/module.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/dma-mapping.h>
> > +#include <linux/dmaengine.h>
> > +#include <linux/interrupt.h>
> 
> interrupt.h is here twice
 
Will remove.

> > +#include <linux/scatterlist.h>
> > +#include <linux/device.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/of.h>
> > +#include <linux/of_address.h>
> > +#include <linux/of_irq.h>
> > +#include <linux/of_dma.h>
> > +#include <linux/clk.h>
> > +#include <linux/msm_bam_dma.h>
> > +
> > +#include "dmaengine.h"
> > +#include "msm_bam_dma_priv.h"
> 
> Why do we need this file? Can't we just put the #defines in this
> file?
 
There were enough definitions and structures to warrant another file.

> > +
> > +
> > +/*
> 
> There should be two '*'s here for kernel-doc.
 
Ok.  I'll conform.

> > + * bam_alloc_chan - Allocate channel resources for DMA channel.
> > + * @chan: specified channel
> > + *
> > + * This function allocates the FIFO descriptor memory and resets the channel
> > + */
> > +static int bam_alloc_chan(struct dma_chan *chan)
> > +{
> > +	struct bam_chan *bchan = to_bam_chan(chan);
> > +	struct bam_device *bdev = bchan->device;
> > +	u32 val;
> > +	union bam_pipe_ctrl pctrl;
> > +
> > +	/* check for channel activity */
> > +	pctrl.value = ioread32(bdev->regs + BAM_P_CTRL(bchan->id));
> 
> I recall io{read,write}*() being used for PCI and other ioport
> devices. If that's right then readl/writel would be more
> appropriate, and the *_relaxed variants would be even better if
> the correct memory barriers are also put in place.
 
I swear I ran across something about readl going legacy, which is why I went
with io{read,write}.  The relaxed variants would definitely be better.  I'll
switch over.

> > +	if (pctrl.bits.p_en) {
> > +		dev_err(bdev->dev, "channel already active\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	/* allocate FIFO descriptor space */
> > +	bchan->fifo_virt = (struct bam_desc_hw *)dma_alloc_coherent(bdev->dev,
> 
> There isn't any need to cast from void *.

Missed this one and a couple of others.  will fix.

> > +				BAM_DESC_FIFO_SIZE, &bchan->fifo_phys,
> > +				GFP_KERNEL);
> > +
> > +	if (!bchan->fifo_virt) {
> > +		dev_err(bdev->dev, "Failed to allocate descriptor fifo\n");
> > +		return -ENOMEM;
> > +	}
> > +
> > +	/* reset channel */
> > +	iowrite32(1, bdev->regs + BAM_P_RST(bchan->id));
> > +	iowrite32(0, bdev->regs + BAM_P_RST(bchan->id));
> > +
> > +	/* configure fifo address/size in bam channel registers */
> > +	iowrite32(bchan->fifo_phys, bdev->regs +
> > +			BAM_P_DESC_FIFO_ADDR(bchan->id));
> > +	iowrite32(BAM_DESC_FIFO_SIZE, bdev->regs +
> > +			BAM_P_FIFO_SIZES(bchan->id));
> > +
> > +	/* unmask and enable interrupts for defined EE, bam and error irqs */
> > +	iowrite32(BAM_IRQ_MSK, bdev->regs + BAM_IRQ_SRCS_EE(bchan->ee));
> > +
> > +	/* enable the per pipe interrupts, enable EOT and INT irqs */
> > +	iowrite32(P_DEFAULT_IRQS_EN, bdev->regs + BAM_P_IRQ_EN(bchan->id));
> > +
> > +	/* unmask the specific pipe and EE combo */
> > +	val = ioread32(bdev->regs + BAM_IRQ_SRCS_MSK_EE(bchan->ee));
> > +	val |= 1 << bchan->id;
> > +	iowrite32(val, bdev->regs + BAM_IRQ_SRCS_MSK_EE(bchan->ee));
> > +
> > +	/* set fixed direction and mode, then enable channel */
> > +	pctrl.value = 0;
> > +	pctrl.bits.p_direction =
> > +		(bchan->bam_slave.slave.direction == DMA_DEV_TO_MEM) ?
> > +			BAM_PIPE_PRODUCER : BAM_PIPE_CONSUMER;
> > +	pctrl.bits.p_sys_mode = BAM_PIPE_MODE_SYSTEM;
> > +	pctrl.bits.p_en = 1;
> > +
> > +	iowrite32(pctrl.value, bdev->regs + BAM_P_CTRL(bchan->id));
> > +
> > +	/* set desc threshold */
> 
> Is this a TODO?

I had moved this to the slave_config.  I'll remove the comment and make sure the
default is being set properly.

> > +	/* do bookkeeping for tracking used EEs, used during IRQ handling */
> > +	set_bit(bchan->ee, &bdev->enabled_ees);
> > +
> > +	bchan->head = 0;
> > +	bchan->tail = 0;
> > +
> > +	return 0;
> > +}
> > +
> > +/*
> > + * bam_free_chan - Frees dma resources associated with specific channel
> > + * @chan: specified channel
> > + *
> > + * Free the allocated fifo descriptor memory and channel resources
> > + *
> > + */
> > +static void bam_free_chan(struct dma_chan *chan)
> > +{
> > +	struct bam_chan *bchan = to_bam_chan(chan);
> > +	struct bam_device *bdev = bchan->device;
> > +	u32 val;
> > +
> > +	/* reset channel */
> > +	iowrite32(1, bdev->regs + BAM_P_RST(bchan->id));
> > +	iowrite32(0, bdev->regs + BAM_P_RST(bchan->id));
> > +
> > +	dma_free_coherent(bdev->dev, BAM_DESC_FIFO_SIZE, bchan->fifo_virt,
> > +				bchan->fifo_phys);
> > +
> > +	/* mask irq for pipe/channel */
> > +	val = ioread32(bdev->regs + BAM_IRQ_SRCS_MSK_EE(bchan->ee));
> > +	val &= ~(1 << bchan->id);
> > +	iowrite32(val, bdev->regs + BAM_IRQ_SRCS_MSK_EE(bchan->ee));
> > +
> > +	/* disable irq */
> > +	iowrite32(0, bdev->regs + BAM_P_IRQ_EN(bchan->id));
> > +
> > +	clear_bit(bchan->ee, &bdev->enabled_ees);
> > +}
> > +
> > +/*
> > + * bam_slave_config - set slave configuration for channel
> > + * @chan: dma channel
> > + * @cfg: slave configuration
> > + *
> > + * Sets slave configuration for channel
> > + * Only allow setting direction once.  BAM channels are unidirectional
> > + * and the direction is set in hardware.
> > + *
> > + */
> > +static void bam_slave_config(struct bam_chan *bchan,
> > +		struct bam_dma_slave_config *bcfg)
> > +{
> > +	struct bam_device *bdev = bchan->device;
> > +
> > +	bchan->bam_slave.desc_threshold = bcfg->desc_threshold;
> > +
> > +	/* set desc threshold */
> > +	iowrite32(bcfg->desc_threshold, bdev->regs + BAM_DESC_CNT_TRSHLD);
> > +}
> > +
> > +/*
> > + * bam_start_dma - loads up descriptors and starts dma
> > + * @chan: dma channel
> > + *
> > + * Loads descriptors into descriptor fifo and starts dma controller
> > + *
> > + * NOTE: Must hold channel lock
> > +*/
> > +static void bam_start_dma(struct bam_chan *bchan)
> > +{
> > +	struct bam_device *bdev = bchan->device;
> > +	struct bam_async_desc *async_desc, *_adesc;
> > +	u32 curr_len, val;
> > +	u32 num_processed = 0;
> > +
> > +	if (list_empty(&bchan->pending))
> > +		return;
> > +
> > +	curr_len = (bchan->head <= bchan->tail) ?
> > +			bchan->tail - bchan->head :
> > +			MAX_DESCRIPTORS - bchan->head + bchan->tail;
> > +
> > +	list_for_each_entry_safe(async_desc, _adesc, &bchan->pending, node) {
> > +
> > +		/* bust out if we are out of room */
> > +		if (async_desc->num_desc + curr_len > MAX_DESCRIPTORS)
> > +			break;
> > +
> > +		/* copy descriptors into fifo */
> > +		if (bchan->tail + async_desc->num_desc > MAX_DESCRIPTORS) {
> > +			u32 partial = MAX_DESCRIPTORS - bchan->tail;
> > +
> > +			memcpy(&bchan->fifo_virt[bchan->tail], async_desc->desc,
> > +				partial * sizeof(struct bam_desc_hw));
> > +			memcpy(bchan->fifo_virt, &async_desc->desc[partial],
> > +				(async_desc->num_desc - partial) *
> > +					sizeof(struct bam_desc_hw));
> > +		} else {
> > +			memcpy(&bchan->fifo_virt[bchan->tail], async_desc->desc,
> > +				async_desc->num_desc *
> > +				sizeof(struct bam_desc_hw));
> > +		}
> > +
> > +		num_processed++;
> > +		bchan->tail += async_desc->num_desc;
> > +		bchan->tail %= MAX_DESCRIPTORS;
> > +		curr_len += async_desc->num_desc;
> 
> I wonder if you could use the circ_buf API here.
 
I'll look into that.  I did a onceover and it looked promising.

> > +
> > +		list_move_tail(&async_desc->node, &bchan->active);
> > +	}
> > +
> > +	/* bail if we didn't queue anything to the active queue */
> > +	if (!num_processed)
> > +		return;
> > +
> > +	async_desc = list_first_entry(&bchan->active, struct bam_async_desc,
> > +			node);
> > +
> > +	val = ioread32(bdev->regs + BAM_P_SW_OFSTS(bchan->id));
> > +	val &= P_SW_OFSTS_MASK;
> > +
> > +	/* kick off dma by forcing a write event to the pipe */
> > +	iowrite32((bchan->tail * sizeof(struct bam_desc_hw)),
> > +			bdev->regs + BAM_P_EVNT_REG(bchan->id));
> > +}
> > +
> > +/*
> > + * bam_tx_submit - Adds transaction to channel pending queue
> > + * @tx: transaction to queue
> > + *
> > + * Adds dma transaction to pending queue for channel
> > + *
> > +*/
> > +static dma_cookie_t bam_tx_submit(struct dma_async_tx_descriptor *tx)
> > +{
> > +	struct bam_chan *bchan = to_bam_chan(tx->chan);
> > +	struct bam_async_desc *desc = to_bam_async_desc(tx);
> > +	dma_cookie_t cookie;
> > +
> > +	spin_lock_bh(&bchan->lock);
> > +
> > +	cookie = dma_cookie_assign(tx);
> > +	list_add_tail(&desc->node, &bchan->pending);
> > +
> > +	spin_unlock_bh(&bchan->lock);
> > +
> > +	return cookie;
> > +}
> > +
> > +/*
> > + * bam_prep_slave_sg - Prep slave sg transaction
> > + *
> > + * @chan: dma channel
> > + * @sgl: scatter gather list
> > + * @sg_len: length of sg
> > + * @direction: DMA transfer direction
> > + * @flags: DMA flags
> > + * @context: transfer context (unused)
> > + */
> > +static struct dma_async_tx_descriptor *bam_prep_slave_sg(struct dma_chan *chan,
> > +	struct scatterlist *sgl, unsigned int sg_len,
> > +	enum dma_transfer_direction direction, unsigned long flags,
> > +	void *context)
> > +{
> > +	struct bam_chan *bchan = to_bam_chan(chan);
> > +	struct bam_device *bdev = bchan->device;
> > +	struct bam_async_desc *async_desc = NULL;
> 
> Useless assignment? Just return NULL instead of the next 3 goto's and
> this can be avoided.
> 
> > +	struct scatterlist *sg;
> > +	u32 i;
> > +	struct bam_desc_hw *desc;
> > +
> > +
> > +	if (!is_slave_direction(direction)) {
> > +		dev_err(bdev->dev, "invalid dma direction\n");
> > +		goto err_out;
> > +	}
> 
> I'm surprised the core framework doesn't do this.

The is_slave_direction() was added as a helper.  And yeah I'd have expected it
as well.

> > +
> > +	/* direction has to match pipe configuration from the slave config */
> > +	if (direction != bchan->bam_slave.slave.direction) {
> > +		dev_err(bdev->dev,
> > +				"trans does not match channel configuration\n");
> 
> s/trans/transfer/ ?
 
Will reword to stay under 80 columns.  That's why I abbreviated

> > +		goto err_out;
> > +	}
> > +
> > +	/* make sure number of descriptors will fit within the fifo */
> > +	if (sg_len > MAX_DESCRIPTORS) {
> > +		dev_err(bdev->dev, "not enough fifo descriptor space\n");
> > +		goto err_out;
> > +	}
> > +
> > +	/* allocate enough room to accomodate the number of entries */
> > +	async_desc = kzalloc(sizeof(*async_desc) +
> > +			(sg_len * sizeof(struct bam_desc_hw)), GFP_KERNEL);
> > +
> > +	if (!async_desc) {
> > +		dev_err(bdev->dev, "failed to allocate async descriptor\n");
> > +		goto err_out;
> > +	}
> > +
> > +	async_desc->num_desc = sg_len;
> > +	async_desc->dir = (direction == DMA_DEV_TO_MEM) ? BAM_PIPE_PRODUCER :
> > +				BAM_PIPE_CONSUMER;
> > +
> > +	/* fill in descriptors, align hw descriptor to 8 bytes */
> > +	desc = async_desc->desc;
> > +	for_each_sg(sgl, sg, sg_len, i) {
> > +		if (sg_dma_len(sg) > BAM_MAX_DATA_SIZE) {
> > +			dev_err(bdev->dev, "segment exceeds max size\n");
> > +			goto err_out;
> > +		}
> > +
> > +		desc->addr = sg_dma_address(sg);
> > +		desc->size = sg_dma_len(sg);
> > +		desc++;
> > +	}
> > +
> > +	/* set EOT flag on last descriptor, we want IRQ on completion */
> > +	async_desc->desc[async_desc->num_desc-1].flags |= DESC_FLAG_EOT;
> 
> Please add space between num_desc, dash, and 1.
 
will fix

> > +
> > +	dma_async_tx_descriptor_init(&async_desc->txd, chan);
> > +	async_desc->txd.tx_submit = bam_tx_submit;
> > +
> > +	return &async_desc->txd;
> > +
> > +err_out:
> > +	kfree(async_desc);
> > +	return NULL;
> > +}
> > +
> > +/*
> > + * bam_dma_terminate_all - terminate all transactions
> > + * @chan: dma channel
> > + *
> > + * Idles channel and dequeues and frees all transactions
> > + * No callbacks are done
> > + *
> > +*/
> > +static void bam_dma_terminate_all(struct dma_chan *chan)
> > +{
> > +	struct bam_chan *bchan = to_bam_chan(chan);
> > +	struct bam_device *bdev = bchan->device;
> > +	LIST_HEAD(desc_cleanup);
> > +	struct bam_async_desc *desc, *_desc;
> > +
> > +	spin_lock_bh(&bchan->lock);
> > +
> > +	/* reset channel */
> > +	iowrite32(1, bdev->regs + BAM_P_RST(bchan->id));
> > +	iowrite32(0, bdev->regs + BAM_P_RST(bchan->id));
> > +
> > +	/* grab all the descriptors and free them */
> > +	list_splice_tail_init(&bchan->pending, &desc_cleanup);
> > +	list_splice_tail_init(&bchan->active, &desc_cleanup);
> > +
> > +	list_for_each_entry_safe(desc, _desc, &desc_cleanup, node)
> > +		kfree(desc);
> > +
> > +	spin_unlock_bh(&bchan->lock);
> > +}
> > +
> > +/*
> > + * bam_control - DMA device control
> > + * @chan: dma channel
> > + * @cmd: control cmd
> > + * @arg: cmd argument
> > + *
> > + * Perform DMA control command
> > + *
> > +*/
> > +static int bam_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
> > +	unsigned long arg)
> > +{
> > +	struct bam_chan *bchan = to_bam_chan(chan);
> > +	struct bam_device *bdev = bchan->device;
> > +	struct bam_dma_slave_config *bconfig;
> > +	int ret = 0;
> > +
> > +	switch (cmd) {
> > +	case DMA_PAUSE:
> > +		spin_lock_bh(&bchan->lock);
> > +		iowrite32(1, bdev->regs + BAM_P_HALT(bchan->id));
> > +		spin_unlock_bh(&bchan->lock);
> > +		break;
> > +	case DMA_RESUME:
> > +		spin_lock_bh(&bchan->lock);
> > +		iowrite32(0, bdev->regs + BAM_P_HALT(bchan->id));
> > +		spin_unlock_bh(&bchan->lock);
> > +		break;
> > +	case DMA_TERMINATE_ALL:
> > +		bam_dma_terminate_all(chan);
> > +		break;
> > +	case DMA_SLAVE_CONFIG:
> > +		bconfig = (struct bam_dma_slave_config *)arg;
> > +		bam_slave_config(bchan, bconfig);
> > +		break;
> > +	default:
> > +		ret = -EIO;
> > +		break;
> > +	}
> > +
> > +	return ret;
> > +}
> > +
> > +/*
> > + * process_irqs_per_ee - processes the interrupts for a specific ee
> > + * @bam: bam controller
> > + * @ee: execution environment
> > + *
> > + * This function processes the interrupts for a given execution environment
> > + *
> > + */
> > +static u32 process_irqs_per_ee(struct bam_device *bdev,
> > +	u32 ee)
> > +{
> > +	u32 i, srcs, stts, pipe_stts;
> > +	u32 clr_mask = 0;
> > +
> > +
> > +	srcs = ioread32(bdev->regs + BAM_IRQ_SRCS_EE(ee));
> > +
> > +	/* check for general bam error */
> > +	if (srcs & BAM_IRQ) {
> > +		stts = ioread32(bdev->regs + BAM_IRQ_STTS);
> > +		clr_mask |= stts;
> > +	}
> > +
> > +	/* check pipes / channels */
> > +	if (srcs & P_IRQ) {
> > +
> > +		for (i = 0; i < bdev->num_channels; i++) {
> > +			if (srcs & (1 << i)) {
> > +				/* clear pipe irq */
> > +				pipe_stts = ioread32(bdev->regs +
> > +					BAM_P_IRQ_STTS(i));
> > +
> > +				iowrite32(pipe_stts, bdev->regs +
> > +					BAM_P_IRQ_CLR(i));
> > +
> > +				/* schedule channel work */
> > +				tasklet_schedule(&bdev->channels[i].tasklet);
> 
> Maybe this little hunk inside the for loop deserves another
> function because we're pretty deeply nested here. Or invert the
> logic so that if (!(srcs & P_IRQ)) returns clr_mask and then this
> can be less indented.

Right I thought about the function originally.  I'll see about doing that or the
inverse logic solution.

> > +			}
> > +		}
> > +	}
> > +
> > +	return clr_mask;
> > +}
> > +
> > +/*
> > + * bam_dma_irq - irq handler for bam controller
> > + * @irq: IRQ of interrupt
> > + * @data: callback data
> > + *
> > + * IRQ handler for the bam controller
> > + */
> > +static irqreturn_t bam_dma_irq(int irq, void *data)
> > +{
> > +	struct bam_device *bdev = (struct bam_device *)data;
> 
> Unnecessary cast.
> 
> > +	u32 clr_mask = 0;
> > +	u32 i;
> > +
> > +
> > +	for (i = 0; i < bdev->num_ees; i++) {
> > +		if (test_bit(i, &bdev->enabled_ees))
> > +			clr_mask |= process_irqs_per_ee(bdev, i);
> > +	}
> 
> These braces aren't really necessary.
> 
> > +
> > +	iowrite32(clr_mask, bdev->regs + BAM_IRQ_CLR);
> > +
> > +	return IRQ_HANDLED;
> > +}
> > +
> > +/*
> > + * bam_tx_status - returns status of transaction
> > + * @chan: dma channel
> > + * @cookie: transaction cookie
> > + * @txstate: DMA transaction state
> > + *
> > + * Return status of dma transaction
> > + */
> > +static enum dma_status bam_tx_status(struct dma_chan *chan, dma_cookie_t cookie,
> > +		struct dma_tx_state *txstate)
> > +{
> > +	return dma_cookie_status(chan, cookie, txstate);
> > +}
> 
> Do we actually need this function? Can't we just assign
> dma_cookie_status to device_tx_status below?

Maybe.  That would simplify things.

> > +
> > +/*
> > + * dma_tasklet - DMA IRQ tasklet
> > + * @data: tasklet argument (bam controller structure)
> > + *
> > + * Sets up next DMA operation and then processes all completed transactions
> > + */
> > +static void dma_tasklet(unsigned long data)
> > +{
> > +	struct bam_chan *bchan = (struct bam_chan *)data;
> > +	struct bam_async_desc *desc, *_desc;
> > +	LIST_HEAD(desc_cleanup);
> > +	u32 fifo_length;
> > +
> > +
> > +	spin_lock_bh(&bchan->lock);
> > +
> > +	if (list_empty(&bchan->active))
> > +		goto out;
> > +
> > +	fifo_length = (bchan->head <= bchan->tail) ?
> > +		bchan->tail - bchan->head :
> > +		MAX_DESCRIPTORS - bchan->head + bchan->tail;
> 
> This is fairly complicated. Can't we just write it like this?
> 
> 	if (bchan->head <= bchan->tail)
> 		fifo_length = bchan->tail - bchan->head;
> 	else
> 		fifo_length = MAX_DESCRIPTORS - bchan->head + bchan->tail;

Yeah, or if I switch to circ_buf it might simplify as well.

> > +
> > +	/* only process those which are currently done */
> > +	list_for_each_entry_safe(desc, _desc, &bchan->active, node) {
> > +		if (desc->num_desc > fifo_length)
> > +			break;
> > +
> > +		dma_cookie_complete(&desc->txd);
> > +
> > +		list_move_tail(&desc->node, &desc_cleanup);
> > +		fifo_length -= desc->num_desc;
> > +		bchan->head += desc->num_desc;
> > +		bchan->head %= MAX_DESCRIPTORS;
> > +	}
> > +
> > +out:
> > +	/* kick off processing of any queued descriptors */
> > +	bam_start_dma(bchan);
> > +
> > +	spin_unlock_bh(&bchan->lock);
> > +
> > +	/* process completed descriptors */
> > +	list_for_each_entry_safe(desc, _desc, &desc_cleanup, node) {
> > +		if (desc->txd.callback)
> > +			desc->txd.callback(desc->txd.callback_param);
> > +
> > +		kfree(desc);
> > +	}
> > +}
> > +
> > +/*
> > + * bam_issue_pending - starts pending transactions
> > + * @chan: dma channel
> > + *
> > + * Calls tasklet directly which in turn starts any pending transactions
> > + */
> > +static void bam_issue_pending(struct dma_chan *chan)
> > +{
> > +	dma_tasklet((unsigned long)chan);
> > +}
> > +
> > +struct bam_filter_args {
> > +	struct dma_device *dev;
> > +	u32 id;
> > +	u32 ee;
> > +	u32 dir;
> > +};
> > +
> > +static bool bam_dma_filter(struct dma_chan *chan, void *data)
> > +{
> > +	struct bam_filter_args *args = data;
> > +	struct bam_chan *bchan = to_bam_chan(chan);
> > +
> > +	if (args->dev == chan->device &&
> > +		args->id == bchan->id) {
> > +
> > +		/* we found the channel, so lets set the EE and dir */
> > +		bchan->ee = args->ee;
> > +		bchan->bam_slave.slave.direction = args->dir ?
> > +				DMA_DEV_TO_MEM : DMA_MEM_TO_DEV;
> > +		return true;
> > +	}
> > +
> > +	return false;
> > +}
> > +
> > +static struct dma_chan *bam_dma_xlate(struct of_phandle_args *dma_spec,
> > +		struct of_dma *of)
> > +{
> > +	struct bam_filter_args args;
> > +	dma_cap_mask_t cap;
> > +
> > +	if (dma_spec->args_count != 3)
> > +		return NULL;
> > +
> > +	args.dev = of->of_dma_data;
> > +	args.id = dma_spec->args[0];
> > +	args.ee = dma_spec->args[1];
> > +	args.dir = dma_spec->args[2];
> > +
> > +	dma_cap_zero(cap);
> > +	dma_cap_set(DMA_SLAVE, cap);
> > +
> > +	return dma_request_channel(cap, bam_dma_filter, &args);
> > +}
> > +
> > +/*
> > + * bam_init
> > + * @bdev: bam device
> > + *
> > + * Initialization helper for global bam registers
> > + */
> > +static int bam_init(struct bam_device *bdev)
> > +{
> > +	union bam_num_pipes num_pipes;
> > +	union bam_ctrl ctrl;
> > +	union bam_cnfg_bits cnfg_bits;
> > +	union bam_revision revision;
> > +
> > +	/* read versioning information */
> > +	revision.value = ioread32(bdev->regs + BAM_REVISION);
> > +	bdev->num_ees = revision.bits.num_ees;
> > +
> > +	num_pipes.value = ioread32(bdev->regs + BAM_NUM_PIPES);
> > +	bdev->num_channels = num_pipes.bits.bam_num_pipes;
> > +
> > +	/* s/w reset bam */
> > +	/* after reset all pipes are disabled and idle */
> > +	ctrl.value = ioread32(bdev->regs + BAM_CTRL);
> > +	ctrl.bits.bam_sw_rst = 1;
> > +	iowrite32(ctrl.value, bdev->regs + BAM_CTRL);
> > +	ctrl.bits.bam_sw_rst = 0;
> > +	iowrite32(ctrl.value, bdev->regs + BAM_CTRL);
> > +
> > +	/* enable bam */
> > +	ctrl.bits.bam_en = 1;
> > +	iowrite32(ctrl.value, bdev->regs + BAM_CTRL);
> > +
> > +	/* set descriptor threshhold, start with 4 bytes */
> > +	iowrite32(DEFAULT_CNT_THRSHLD, bdev->regs + BAM_DESC_CNT_TRSHLD);
> > +
> > +	/* set config bits for h/w workarounds */
> > +	/* Enable all workarounds except BAM_FULL_PIPE */
> > +	cnfg_bits.value = 0xffffffff;
> > +	cnfg_bits.bits.obsolete = 0;
> > +	cnfg_bits.bits.obsolete2 = 0;
> > +	cnfg_bits.bits.reserved = 0;
> > +	cnfg_bits.bits.reserved2 = 0;
> > +	cnfg_bits.bits.bam_full_pipe = 0;
> > +	iowrite32(cnfg_bits.value, bdev->regs + BAM_CNFG_BITS);
> > +
> > +	/* enable irqs for errors */
> > +	iowrite32(BAM_ERROR_EN | BAM_HRESP_ERR_EN, bdev->regs + BAM_IRQ_EN);
> > +	return 0;
> > +}
> > +
> > +static void bam_channel_init(struct bam_device *bdev, struct bam_chan *bchan,
> > +	u32 index)
> > +{
> > +	bchan->id = index;
> > +	bchan->common.device = &bdev->common;
> > +	bchan->device = bdev;
> > +	spin_lock_init(&bchan->lock);
> > +
> > +	INIT_LIST_HEAD(&bchan->pending);
> > +	INIT_LIST_HEAD(&bchan->active);
> > +
> > +	dma_cookie_init(&bchan->common);
> > +	list_add_tail(&bchan->common.device_node,
> > +		&bdev->common.channels);
> > +
> > +	tasklet_init(&bchan->tasklet, dma_tasklet, (unsigned long)bchan);
> > +
> > +	/* reset channel - just to be sure */
> > +	iowrite32(1, bdev->regs + BAM_P_RST(bchan->id));
> > +	iowrite32(0, bdev->regs + BAM_P_RST(bchan->id));
> > +}
> > +
> > +static int bam_dma_probe(struct platform_device *pdev)
> > +{
> > +	struct bam_device *bdev;
> > +	int err, i;
> > +
> > +	bdev = kzalloc(sizeof(*bdev), GFP_KERNEL);
> 
> Please use devm_kzalloc() here to simplify error paths.
> 

agreed

> > +	if (!bdev) {
> > +		dev_err(&pdev->dev, "insufficient memory for private data\n");
> 
> kmalloc calls already print errors when they fail, so this can be
> removed.
 
has this always been the case?

> > +		err = -ENOMEM;
> > +		goto err_no_bdev;
> 
> Just return the error here.
> 

Since it's the first check, I'm ok with that.  Otherwise i'd prefer to stick
with a unified return

> > +	}
> > +
> > +	bdev->dev = &pdev->dev;
> > +	dev_set_drvdata(bdev->dev, bdev);
> > +
> > +	bdev->regs = of_iomap(pdev->dev.of_node, 0);
> > +	if (!bdev->regs) {
> > +		dev_err(bdev->dev, "unable to ioremap base\n");
> > +		err = -ENOMEM;
> > +		goto err_free_bamdev;
> > +	}
> > +
> > +	bdev->irq = irq_of_parse_and_map(pdev->dev.of_node, 0);
> > +	if (bdev->irq == NO_IRQ) {
> > +		dev_err(bdev->dev, "unable to map irq\n");
> > +		err = -EINVAL;
> > +		goto err_unmap_mem;
> > +	}
> 
> Please use platform_* APIs here, this is a platform driver after
> all. Notably, use platform_get_irq() and platform_get_resource()
> followed by devm_ioremap_resource().
 
agreed.

> > +
> > +	bdev->bamclk = devm_clk_get(bdev->dev, "bam_clk");
> > +	if (IS_ERR(bdev->bamclk)) {
> > +		err = PTR_ERR(bdev->bamclk);
> > +		goto err_free_irq;
> > +	}
> > +
> > +	err = clk_prepare_enable(bdev->bamclk);
> > +	if (err) {
> > +		dev_err(bdev->dev, "failed to prepare/enable clock");
> > +		goto err_free_irq;
> > +	}
> > +
> > +	err = request_irq(bdev->irq, &bam_dma_irq, IRQF_TRIGGER_HIGH, "bam_dma",
> > +				bdev);
> 
> Can be devm_request_irq(). Shouldn't this be done much later in
> the probe? It looks like bdev isn't fully setup yet.
 
All the IRQs are disabled and masked, however in a module situation this might
not be the case.  It probably should be moved later.

> > +	if (err) {
> > +		dev_err(bdev->dev, "error requesting irq\n");
> > +		err = -EINVAL;
> > +		goto err_disable_clk;
> > +	}
> > +
> > +	if (bam_init(bdev)) {
> > +		dev_err(bdev->dev, "cannot initialize bam device\n");
> > +		err = -EINVAL;
> > +		goto err_disable_clk;
> > +	}
> > +
> > +	bdev->channels = kzalloc(sizeof(*bdev->channels) * bdev->num_channels,
> > +				GFP_KERNEL);
> > +
> 
> We're going to have devm_kcalloc() in 3.13 so you should be able
> to use that here.
> 
> > +	if (!bdev->channels) {
> > +		dev_err(bdev->dev, "unable to allocate channels\n");
> > +		err = -ENOMEM;
> > +		goto err_disable_clk;
> > +	}
> > +
> > +	/* allocate and initialize channels */
> > +	INIT_LIST_HEAD(&bdev->common.channels);
> > +
> > +	for (i = 0; i < bdev->num_channels; i++)
> > +		bam_channel_init(bdev, &bdev->channels[i], i);
> > +
> > +	/* set max dma segment size */
> > +	bdev->common.dev = bdev->dev;
> > +	bdev->common.dev->dma_parms = &bdev->dma_parms;
> > +	if (dma_set_max_seg_size(bdev->common.dev, BAM_MAX_DATA_SIZE)) {
> > +		dev_err(bdev->dev, "cannot set maximum segment size\n");
> > +		goto err_disable_clk;
> > +	}
> > +
> > +	/* set capabilities */
> > +	dma_cap_zero(bdev->common.cap_mask);
> > +	dma_cap_set(DMA_SLAVE, bdev->common.cap_mask);
> > +
> > +	/* initialize dmaengine apis */
> > +	bdev->common.device_alloc_chan_resources = bam_alloc_chan;
> > +	bdev->common.device_free_chan_resources = bam_free_chan;
> > +	bdev->common.device_prep_slave_sg = bam_prep_slave_sg;
> > +	bdev->common.device_control = bam_control;
> > +	bdev->common.device_issue_pending = bam_issue_pending;
> > +	bdev->common.device_tx_status = bam_tx_status;
> > +	bdev->common.dev = bdev->dev;
> > +
> > +	dma_async_device_register(&bdev->common);
> 
> This can fail. Please check error codes.
 
agreed

> > +
> > +	if (pdev->dev.of_node) {
> > +		err = of_dma_controller_register(pdev->dev.of_node,
> > +				bam_dma_xlate, &bdev->common);
> > +
> > +		if (err) {
> > +			dev_err(bdev->dev, "failed to register of_dma\n");
> > +			goto err_unregister_dma;
> > +		}
> > +	}
> > +
> > +	return 0;
> > +
> > +err_unregister_dma:
> > +	dma_async_device_unregister(&bdev->common);
> > +err_free_irq:
> > +	free_irq(bdev->irq, bdev);
> > +err_disable_clk:
> > +	clk_disable_unprepare(bdev->bamclk);
> > +err_unmap_mem:
> > +	iounmap(bdev->regs);
> > +err_free_bamdev:
> > +	if (bdev)
> > +		kfree(bdev->channels);
> > +	kfree(bdev);
> > +err_no_bdev:
> > +	return err;
> > +}
> > +
> > +static int bam_dma_remove(struct platform_device *pdev)
> > +{
> > +	struct bam_device *bdev;
> > +
> > +	bdev = dev_get_drvdata(&pdev->dev);
> > +	dev_set_drvdata(&pdev->dev, NULL);
> 
> This is unnecessary.
> 
> > +
> > +	dma_async_device_unregister(&bdev->common);
> > +
> > +	if (bdev) {
> 
> Ouch. We just dereferenced bdev one line before so it seems that
> this check is unnecessary.

True.  I believe at one point I was using the remove function call directly from
within the probe during failure.  I can rework this.

> > +		free_irq(bdev->irq, bdev);
> > +		clk_disable_unprepare(bdev->bamclk);
> > +		iounmap(bdev->regs);
> > +		kfree(bdev->channels);
> > +	}
> > +
> > +	kfree(bdev);
> > +	return 0;
> > +}
> [...]
> > +
> > +static int __init bam_dma_init(void)
> > +{
> > +	return platform_driver_register(&bam_dma_driver);
> > +}
> > +
> > +static void __exit bam_dma_exit(void)
> > +{
> > +	return platform_driver_unregister(&bam_dma_driver);
> > +}
> > +
> > +arch_initcall(bam_dma_init);
> > +module_exit(bam_dma_exit);
> 
> module_platform_driver()? Or is there some probe deferral problem
> that isn't resolved?
> 

Good point. If this becomes a problem, the peripheral drivers using the DMA can
implement probe deferral.

> > +
> > +MODULE_AUTHOR("Andy Gross <agross@codeaurora.org>");
> > +MODULE_DESCRIPTION("MSM BAM DMA engine driver");
> > +MODULE_LICENSE("GPL v2");
> > diff --git a/drivers/dma/msm_bam_dma_priv.h b/drivers/dma/msm_bam_dma_priv.h
> > new file mode 100644
> > index 0000000..4d6a10c7
> > --- /dev/null
> > +++ b/drivers/dma/msm_bam_dma_priv.h
> > @@ -0,0 +1,286 @@
> > +/*
> > + * Copyright (c) 2013, The Linux Foundation. All rights reserved.
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 and
> > + * only version 2 as published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +#ifndef __MSM_BAM_DMA_PRIV_H__
> > +#define __MSM_BAM_DMA_PRIV_H__
> > +
> > +#include <linux/dmaengine.h>
> > +
> > +enum bam_channel_mode {
> > +	BAM_PIPE_MODE_BAM2BAM = 0,	/* BAM to BAM aka device to device */
> > +	BAM_PIPE_MODE_SYSTEM,		/* BAM to/from System Memory */
> > +};
> > +
> > +enum bam_channel_dir {
> > +	BAM_PIPE_CONSUMER = 0,	/* channel reads from data-fifo or memory */
> > +	BAM_PIPE_PRODUCER,	/* channel writes to data-fifo or memory */
> > +};
> > +
> > +struct bam_desc_hw {
> > +	u32 addr;		/* Buffer physical address */
> > +	u32 size:16;		/* Buffer size in bytes */
> > +	u32 flags:16;
> > +};
> 
> Is this an in memory structure that the hardware reads? It should
> probably use the correct types (i.e. u16 instead of bit fields)
> and then be marked as __packed__ so that compile doesn't mess
> up the alignment.
 
Will fix this.  There isn't any need for the bitfields.

> > +
> > +#define DESC_FLAG_INT	(1<<15)
> > +#define DESC_FLAG_EOT	(1<<14)
> > +#define DESC_FLAG_EOB	(1<<13)
> 
> Space around << here please. Or use the BIT() macro.
> 

BIT() makes it cleaner.  I'll use that instead

> > +
> > +struct bam_async_desc {
> > +	struct list_head node;
> > +	struct dma_async_tx_descriptor txd;
> > +	u32 num_desc;
> > +	enum bam_channel_dir dir;
> > +	u32 fifo_pos;
> > +	struct bam_desc_hw desc[0];
> > +};
> > +
> > +static inline struct bam_async_desc *to_bam_async_desc(
> > +		struct dma_async_tx_descriptor *txd)
> > +{
> > +	return container_of(txd, struct bam_async_desc, txd);
> > +}
> > +
> > +
> > +#define BAM_CTRL			0x0000
> > +#define BAM_REVISION			0x0004
> > +#define BAM_SW_REVISION			0x0080
> > +#define BAM_NUM_PIPES			0x003C
> > +#define BAM_TIMER			0x0040
> > +#define BAM_TIMER_CTRL			0x0044
> > +#define BAM_DESC_CNT_TRSHLD		0x0008
> > +#define BAM_IRQ_SRCS			0x000C
> > +#define BAM_IRQ_SRCS_MSK		0x0010
> > +#define BAM_IRQ_SRCS_UNMASKED		0x0030
> > +#define BAM_IRQ_STTS			0x0014
> > +#define BAM_IRQ_CLR			0x0018
> > +#define BAM_IRQ_EN			0x001C
> > +#define BAM_CNFG_BITS			0x007C
> > +#define BAM_IRQ_SRCS_EE(x)		(0x0800 + ((x) * 0x80))
> > +#define BAM_IRQ_SRCS_MSK_EE(x)		(0x0804 + ((x) * 0x80))
> > +#define BAM_P_CTRL(x)			(0x1000 + ((x) * 0x1000))
> > +#define BAM_P_RST(x)			(0x1004 + ((x) * 0x1000))
> > +#define BAM_P_HALT(x)			(0x1008 + ((x) * 0x1000))
> > +#define BAM_P_IRQ_STTS(x)		(0x1010 + ((x) * 0x1000))
> > +#define BAM_P_IRQ_CLR(x)		(0x1014 + ((x) * 0x1000))
> > +#define BAM_P_IRQ_EN(x)			(0x1018 + ((x) * 0x1000))
> > +#define BAM_P_EVNT_DEST_ADDR(x)		(0x182C + ((x) * 0x1000))
> > +#define BAM_P_EVNT_REG(x)		(0x1818 + ((x) * 0x1000))
> > +#define BAM_P_SW_OFSTS(x)		(0x1800 + ((x) * 0x1000))
> > +#define BAM_P_DATA_FIFO_ADDR(x)		(0x1824 + ((x) * 0x1000))
> > +#define BAM_P_DESC_FIFO_ADDR(x)		(0x181C + ((x) * 0x1000))
> > +#define BAM_P_EVNT_TRSHLD(x)		(0x1828 + ((x) * 0x1000))
> > +#define BAM_P_FIFO_SIZES(x)		(0x1820 + ((x) * 0x1000))
> 
> If you have the columns it might be nice to s/x/pipe/ so that it's
> clear what 'x' is.

Will do

> > +
> > +union bam_ctrl {
> > +	u32 value;
> > +	struct {
> > +		u32 bam_sw_rst:1;
> > +		u32 bam_en:1;
> > +		u32 reserved3:2;
> > +		u32 bam_en_accum:1;
> > +		u32 testbus_sel:7;
> > +		u32 reserved2:1;
> > +		u32 bam_desc_cache_sel:2;
> > +		u32 bam_cached_desc_store:1;
> > +		u32 ibc_disable:1;
> > +		u32 reserved1:15;
> > +	} bits;
> > +};
> > +
> > +union bam_revision {
> > +	u32 value;
> > +	struct {
> > +		u32 revision:8;
> > +		u32 num_ees:4;
> > +		u32 reserved1:1;
> > +		u32 ce_buffer_size:1;
> > +		u32 axi_active:1;
> > +		u32 use_vmidmt:1;
> > +		u32 secured:1;
> > +		u32 bam_has_no_bypass:1;
> > +		u32 high_frequency_bam:1;
> > +		u32 inactiv_tmrs_exst:1;
> > +		u32 num_inactiv_tmrs:1;
> > +		u32 desc_cache_depth:2;
> > +		u32 cmd_desc_en:1;
> > +		u32 inactiv_tmr_base:8;
> > +	} bits;
> > +};
> > +
> > +union bam_sw_revision {
> > +	u32 value;
> > +	struct {
> > +		u32 step:16;
> > +		u32 minor:12;
> > +		u32 major:4;
> > +	} bits;
> > +};
> > +
> > +union bam_num_pipes {
> > +	u32 value;
> > +	struct {
> > +		u32 bam_num_pipes:8;
> > +		u32 reserved:8;
> > +		u32 periph_non_pipe_grp:8;
> > +		u32 bam_non_pipe_grp:8;
> > +	} bits;
> > +};
> > +
> > +union bam_irq_srcs_msk {
> > +	u32 value;
> > +	struct {
> > +		u32 p_irq_msk:31;
> > +		u32 bam_irq_msk:1;
> > +	} bits;
> > +};
> > +
> > +union bam_cnfg_bits {
> > +	u32 value;
> > +	struct {
> > +		u32 obsolete:2;
> > +		u32 bam_pipe_cnfg:1;
> > +		u32 obsolete2:1;
> > +		u32 reserved:7;
> > +		u32 bam_full_pipe:1;
> > +		u32 bam_no_ext_p_rst:1;
> > +		u32 bam_ibc_disable:1;
> > +		u32 bam_sb_clk_req:1;
> > +		u32 bam_psm_csw_req:1;
> > +		u32 bam_psm_p_res:1;
> > +		u32 bam_au_p_res:1;
> > +		u32 bam_si_p_res:1;
> > +		u32 bam_wb_p_res:1;
> > +		u32 bam_wb_blk_csw:1;
> > +		u32 bam_wb_csw_ack_idl:1;
> > +		u32 bam_wb_retr_svpnt:1;
> > +		u32 bam_wb_dsc_avl_p_rst:1;
> > +		u32 bam_reg_p_en:1;
> > +		u32 bam_psm_p_hd_data:1;
> > +		u32 bam_au_accumed:1;
> > +		u32 bam_cd_enable:1;
> > +		u32 reserved2:4;
> > +	} bits;
> > +};
> > +
> > +union bam_pipe_ctrl {
> > +	u32 value;
> > +	struct {
> > +		u32 reserved:1;
> > +		u32 p_en:1;
> > +		u32 reserved2:1;
> > +		u32 p_direction:1;
> > +		u32 p_sys_strm:1;
> > +		u32 p_sys_mode:1;
> > +		u32 p_auto_eob:1;
> > +		u32 p_auto_eob_sel:2;
> > +		u32 p_prefetch_limit:2;
> > +		u32 p_write_nwd:1;
> > +		u32 reserved3:4;
> > +		u32 p_lock_group:5;
> > +		u32 reserved4:11;
> > +	} bits;
> > +};
> 
> Hmm.. I believe bitfields are not portable and rely on
> implementation defined behavior. The compiler is free to put
> these bits in whatever order it wants. For example, you're not
> guaranteed that p_en comes after reserved. Please move away from
> these unions and just do the bit shifting in the code.
 
Will do.  I can just define bits/masks and do it that way.

> > +
> > +/* BAM_DESC_CNT_TRSHLD */
> > +#define CNT_TRSHLD		0xffff
> > +#define DEFAULT_CNT_THRSHLD	0x4
> > +
> > +/* BAM_IRQ_SRCS */
> > +#define BAM_IRQ			(0x1 << 31)
> > +#define P_IRQ			0x7fffffff
> > +
> > +/* BAM_IRQ_SRCS_MSK */
> > +#define BAM_IRQ_MSK		(0x1 << 31)
> > +#define P_IRQ_MSK		0x7fffffff
> > +
> > +/* BAM_IRQ_STTS */
> > +#define BAM_TIMER_IRQ		(0x1 << 4)
> > +#define BAM_EMPTY_IRQ		(0x1 << 3)
> > +#define BAM_ERROR_IRQ		(0x1 << 2)
> > +#define BAM_HRESP_ERR_IRQ	(0x1 << 1)
> > +
> > +/* BAM_IRQ_CLR */
> > +#define BAM_TIMER_CLR		(0x1 << 4)
> > +#define BAM_EMPTY_CLR		(0x1 << 3)
> > +#define BAM_ERROR_CLR		(0x1 << 2)
> > +#define BAM_HRESP_ERR_CLR	(0x1 << 1)
> > +
> > +/* BAM_IRQ_EN */
> > +#define BAM_TIMER_EN		(0x1 << 4)
> > +#define BAM_EMPTY_EN		(0x1 << 3)
> > +#define BAM_ERROR_EN		(0x1 << 2)
> > +#define BAM_HRESP_ERR_EN	(0x1 << 1)
> > +
> > +/* BAM_P_IRQ_EN */
> > +#define P_PRCSD_DESC_EN		(0x1 << 0)
> > +#define P_TIMER_EN		(0x1 << 1)
> > +#define P_WAKE_EN		(0x1 << 2)
> > +#define P_OUT_OF_DESC_EN	(0x1 << 3)
> > +#define P_ERR_EN		(0x1 << 4)
> > +#define P_TRNSFR_END_EN		(0x1 << 5)
> > +#define P_DEFAULT_IRQS_EN	(P_PRCSD_DESC_EN | P_ERR_EN | P_TRNSFR_END_EN)
> > +
> > +/* BAM_P_SW_OFSTS */
> > +#define P_SW_OFSTS_MASK		0xffff
> > +
> > +#define BAM_DESC_FIFO_SIZE	SZ_32K
> > +#define MAX_DESCRIPTORS (BAM_DESC_FIFO_SIZE / sizeof(struct bam_desc_hw) - 1)
> > +#define BAM_MAX_DATA_SIZE	(SZ_32K - 8)
> > +
> > +struct bam_chan {
> > +	struct dma_chan common;
> > +	struct bam_device *device;
> > +	u32 id;
> > +	u32 ee;
> > +	bool idle;
> 
> Is this used?

It is orphaned, will be removed

> > +	struct bam_dma_slave_config bam_slave;	/* runtime configuration */
> > +
> > +	struct tasklet_struct tasklet;
> > +	spinlock_t lock;		/* descriptor lock */
> > +
> > +	struct list_head pending;	/* desc pending queue */
> > +	struct list_head active;	/* desc running queue */
> > +
> > +	struct bam_desc_hw *fifo_virt;
> > +	dma_addr_t fifo_phys;
> > +
> > +	/* fifo markers */
> > +	unsigned short head;		/* start of active descriptor entries */
> > +	unsigned short tail;		/* end of active descriptor entries */
> > +};
> > +
> > +static inline struct bam_chan *to_bam_chan(struct dma_chan *common)
> > +{
> > +	return container_of(common, struct bam_chan, common);
> > +}
> > +
> > +struct bam_device {
> > +	void __iomem *regs;
> > +	struct device *dev;
> > +	struct dma_device common;
> > +	struct device_dma_parameters dma_parms;
> > +	struct bam_chan *channels;
> > +	u32 num_channels;
> > +	u32 num_ees;
> > +	unsigned long enabled_ees;
> > +	u32 feature;
> 
> Is this used?

It is orphaned, will be removed
 
> > +	int irq;
> > +	struct clk *bamclk;
> > +};
> > +
> > +static inline struct bam_device *to_bam_device(struct dma_device *common)
> > +{
> > +	return container_of(common, struct bam_device, common);
> > +}
> > +
> > +#endif /* __MSM_BAM_DMA_PRIV_H__ */

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
