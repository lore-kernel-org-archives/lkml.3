Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320AbaDPJQR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 05:16:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:25995 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755218AbaDPJQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 05:16:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,871,1389772800"; 
   d="scan'208";a="494034856"
Date: Wed, 16 Apr 2014 14:36:05 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Srikanth Thokala <sthokal@xilinx.com>
Cc: dan.j.williams@intel.com, michal.simek@xilinx.com, grant.likely@linaro.org,
        robh+dt@kernel.org, levex@linux.com, lars@metafoo.de,
        andriy.shevchenko@linux.jf.intel.com, jaswinder.singh@linaro.org,
        dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 2/2] dma: Add Xilinx AXI Video Direct Memory Access
 Engine driver support
Message-ID: <20140416090605.GP32284@intel.com>
References: <1396008222-7058-1-git-send-email-sthokal@xilinx.com>
 <1396008222-7058-3-git-send-email-sthokal@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396008222-7058-3-git-send-email-sthokal@xilinx.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2014 at 05:33:42PM +0530, Srikanth Thokala wrote:
> This is the driver for the AXI Video Direct Memory Access (AXI
> VDMA) core, which is a soft Xilinx IP core that provides high-
> bandwidth direct memory access between memory and AXI4-Stream
> type video target peripherals. The core provides efficient two
> dimensional DMA operations with independent asynchronous read
> and write channel operation.
> 
> This module works on Zynq (ARM Based SoC) and Microblaze platforms.

Okay the series is fine and was going to apply it BUT
1) need ack on DT patch..
2) issues below on managing the descriptor and resetting the cookie :(

> +
> +/**
> + * xilinx_vdma_tx_descriptor - Allocate transaction descriptor
> + * @chan: Driver specific VDMA channel
> + *
> + * Return: The allocated descriptor on success and NULL on failure.
> + */
> +static struct xilinx_vdma_tx_descriptor *
> +xilinx_vdma_alloc_tx_descriptor(struct xilinx_vdma_chan *chan)
> +{
> +	struct xilinx_vdma_tx_descriptor *desc;
> +	unsigned long flags;
> +
> +	if (chan->allocated_desc)
> +		return chan->allocated_desc;
??

> +
> +	desc = kzalloc(sizeof(*desc), GFP_KERNEL);
> +	if (!desc)
> +		return NULL;
> +
> +	spin_lock_irqsave(&chan->lock, flags);
> +	chan->allocated_desc = desc;
ah why do you need this? 

So this essentailly prevents you from preparing two trasactions at same time as
you would overwrite??

You should maintain a list for pending and submitted.

> +	spin_unlock_irqrestore(&chan->lock, flags);
> +
> +	INIT_LIST_HEAD(&desc->segments);
> +
> +	return desc;
> +}
> +

> +/**
> + * xilinx_vdma_tx_submit - Submit DMA transaction
> + * @tx: Async transaction descriptor
> + *
> + * Return: cookie value on success and failure value on error
> + */
> +static dma_cookie_t xilinx_vdma_tx_submit(struct dma_async_tx_descriptor *tx)
> +{
> +	struct xilinx_vdma_tx_descriptor *desc = to_vdma_tx_descriptor(tx);
> +	struct xilinx_vdma_chan *chan = to_xilinx_chan(tx->chan);
> +	dma_cookie_t cookie;
> +	unsigned long flags;
> +	int err;
> +
> +	if (chan->err) {
> +		/*
> +		 * If reset fails, need to hard reset the system.
> +		 * Channel is no longer functional
> +		 */
> +		err = xilinx_vdma_chan_reset(chan);
> +		if (err < 0)
> +			return err;
> +	}
> +
> +	spin_lock_irqsave(&chan->lock, flags);
> +
> +	cookie = dma_cookie_assign(tx);
> +
> +	/* Append the transaction to the pending transactions queue. */
> +	list_add_tail(&desc->node, &chan->pending_list);
> +
> +	/* Free the allocated desc */
> +	chan->allocated_desc = NULL;
> +
> +	spin_unlock_irqrestore(&chan->lock, flags);
> +
> +	return cookie;
> +}
> +
> +/**
> + * xilinx_vdma_dma_prep_interleaved - prepare a descriptor for a
> + *	DMA_SLAVE transaction
> + * @dchan: DMA channel
> + * @xt: Interleaved template pointer
> + * @flags: transfer ack flags
> + *
> + * Return: Async transaction descriptor on success and NULL on failure
> + */
> +static struct dma_async_tx_descriptor *
> +xilinx_vdma_dma_prep_interleaved(struct dma_chan *dchan,
> +				 struct dma_interleaved_template *xt,
> +				 unsigned long flags)
> +{
> +	struct xilinx_vdma_chan *chan = to_xilinx_chan(dchan);
> +	struct xilinx_vdma_tx_descriptor *desc;
> +	struct xilinx_vdma_tx_segment *segment, *prev = NULL;
> +	struct xilinx_vdma_desc_hw *hw;
> +
> +	if (!is_slave_direction(xt->dir))
> +		return NULL;
> +
> +	if (!xt->numf || !xt->sgl[0].size)
> +		return NULL;
> +
> +	/* Allocate a transaction descriptor. */
> +	desc = xilinx_vdma_alloc_tx_descriptor(chan);
> +	if (!desc)
> +		return NULL;
> +
> +	dma_async_tx_descriptor_init(&desc->async_tx, &chan->common);
> +	desc->async_tx.tx_submit = xilinx_vdma_tx_submit;
> +	desc->async_tx.cookie = 0;
why this is initialized in submit.. when you call dma_cookie_assign()

-- 
~Vinod
