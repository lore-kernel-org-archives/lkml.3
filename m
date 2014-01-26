Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980AbaAZOY5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 09:24:57 -0500
Received: from mga09.intel.com ([134.134.136.24]:13375 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752701AbaAZOYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 09:24:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,724,1384329600"; 
   d="scan'208";a="464918695"
Date: Sun, 26 Jan 2014 19:54:36 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Srikanth Thokala <sthokal@xilinx.com>
Cc: dan.j.williams@intel.com, michal.simek@xilinx.com, grant.likely@linaro.org,
        robh+dt@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        dmaengine@vger.kernel.org
Subject: Re: [PATCH v2] dma: Add Xilinx AXI Video Direct Memory Access
 Engine driver support
Message-ID: <20140126142436.GF10628@intel.com>
References: <1390409565-4200-1-git-send-email-sthokal@xilinx.com>
 <1390409565-4200-2-git-send-email-sthokal@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390409565-4200-2-git-send-email-sthokal@xilinx.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 10:22:45PM +0530, Srikanth Thokala wrote:
> This is the driver for the AXI Video Direct Memory Access (AXI
> VDMA) core, which is a soft Xilinx IP core that provides high-
> bandwidth direct memory access between memory and AXI4-Stream
> type video target peripherals. The core provides efficient two
> dimensional DMA operations with independent asynchronous read
ok here is tha catch, do you want to support interleaved API rather?

> +* DMA client + +Required properties: +- dmas: a list of <[Video DMA device
> phandle] [Channel ID]> pairs, +	where Channel ID is '0' for write/tx and
> '1' for read/rx +	channel.  +- dma-names: a list of DMA channel names, one
> per "dmas" entry + +Example: +++++++++ + +vdmatest_0: vdmatest@0 { +
> compatible ="xlnx,axi-vdma-test-1.00.a"; +	dmas = <&axi_vdma_0 0 +
> &axi_vdma_0 1>; +	dma-names = "vdma0", "vdma1"; +} ;
Need ack from DT folks. ALso would be better to split the binding to a separate
patch


> +/**
> + * struct xilinx_vdma_chan - Driver specific VDMA channel structure
> + * @xdev: Driver specific device structure
> + * @ctrl_offset: Control registers offset
> + * @desc_offset: TX descriptor registers offset
> + * @completed_cookie: Maximum cookie completed
> + * @cookie: The current cookie
> + * @lock: Descriptor operation lock
> + * @pending_list: Descriptors waiting
> + * @active_desc: Active descriptor
> + * @done_list: Complete descriptors
> + * @common: DMA common channel
> + * @desc_pool: Descriptors pool
> + * @dev: The dma device
> + * @irq: Channel IRQ
> + * @id: Channel ID
> + * @direction: Transfer direction
> + * @num_frms: Number of frames
> + * @has_sg: Support scatter transfers
> + * @genlock: Support genlock mode
> + * @err: Channel has errors
> + * @tasklet: Cleanup work after irq
> + * @config: Device configuration info
> + * @flush_on_fsync: Flush on Frame sync
> + */
> +struct xilinx_vdma_chan {
> +	struct xilinx_vdma_device *xdev;
> +	u32 ctrl_offset;
> +	u32 desc_offset;
> +	dma_cookie_t completed_cookie;
> +	dma_cookie_t cookie;
> +	spinlock_t lock;
> +	struct list_head pending_list;
> +	struct xilinx_vdma_tx_descriptor *active_desc;
> +	struct list_head done_list;
> +	struct dma_chan common;
> +	struct dma_pool *desc_pool;
> +	struct device *dev;
> +	int irq;
> +	int id;
> +	enum dma_transfer_direction direction;
why should channel have a direction... descriptor should have direction and not
the channel!

> +/**
> + * xilinx_vdma_free_tx_descriptor - Free transaction descriptor
> + * @chan: Driver specific VDMA channel
> + * @desc: VDMA transaction descriptor
> + */
> +static void
> +xilinx_vdma_free_tx_descriptor(struct xilinx_vdma_chan *chan,
> +			       struct xilinx_vdma_tx_descriptor *desc)
> +{
> +	struct xilinx_vdma_tx_segment *segment, *next;
> +
> +	if (!desc)
> +		return;
> +
> +	list_for_each_entry_safe(segment, next, &desc->segments, node) {
do you want to use _safe. Isee that this is called for cleanup while lock held,
and in other case within another _safe iterator!

> +		list_del(&segment->node);
> +		xilinx_vdma_free_tx_segment(chan, segment);
> +	}
> +
> +	kfree(desc);
> +}
> +
> +/* Required functions */
> +

> + * xilinx_vdma_do_tasklet - Schedule completion tasklet
> + * @data: Pointer to the Xilinx VDMA channel structure
> + */
> +static void xilinx_vdma_do_tasklet(unsigned long data)
> +{
> +	struct xilinx_vdma_chan *chan = (struct xilinx_vdma_chan *)data;
> +
> +	xilinx_vdma_chan_desc_cleanup(chan);
> +}
> +
> +/**
> + * xilinx_vdma_alloc_chan_resources - Allocate channel resources
> + * @dchan: DMA channel
> + *
> + * Return: '1' on success and failure value on error
naaah, we dont do that, pls use standard notation of 0 on success
Also API wants you to return descriptors allocated here!

> + */
> +static int xilinx_vdma_alloc_chan_resources(struct dma_chan *dchan)
> +{
> +	struct xilinx_vdma_chan *chan = to_xilinx_chan(dchan);
> +
> +	/* Has this channel already been allocated? */
> +	if (chan->desc_pool)
> +		return 1;
> +
> +	/*
> +	 * We need the descriptor to be aligned to 64bytes
> +	 * for meeting Xilinx VDMA specification requirement.
> +	 */
> +	chan->desc_pool = dma_pool_create("xilinx_vdma_desc_pool",
> +				chan->dev,
> +				sizeof(struct xilinx_vdma_tx_segment),
> +				__alignof__(struct xilinx_vdma_tx_segment), 0);
> +	if (!chan->desc_pool) {
> +		dev_err(chan->dev,
> +			"unable to allocate channel %d descriptor pool\n",
> +			chan->id);
> +		return -ENOMEM;
> +	}
> +
> +	tasklet_init(&chan->tasklet, xilinx_vdma_do_tasklet,
> +			(unsigned long)chan);
> +
> +	chan->completed_cookie = DMA_MIN_COOKIE;
> +	chan->cookie = DMA_MIN_COOKIE;
Can you use virtual dma implementation to simplfy your implemenattion of lists,
cookies (driver/dma/virt-dma.c)

> +	/* There is at least one descriptor free to be allocated */
???

> +	return 1;
> +}
> +

> + * xilinx_vdma_tx_status - Get VDMA transaction status
> + * @dchan: DMA channel
> + * @cookie: Transaction identifier
> + * @txstate: Transaction state
> + *
> + * Return: DMA transaction status
> + */
> +static enum dma_status xilinx_vdma_tx_status(struct dma_chan *dchan,
> +					dma_cookie_t cookie,
> +					struct dma_tx_state *txstate)
> +{
> +	struct xilinx_vdma_chan *chan = to_xilinx_chan(dchan);
> +	dma_cookie_t last_used;
> +	dma_cookie_t last_complete;
> +
> +	xilinx_vdma_chan_desc_cleanup(chan);
> +
> +	last_used = dchan->cookie;
> +	last_complete = chan->completed_cookie;
> +
> +	dma_set_tx_state(txstate, last_complete, last_used, 0);
> +
> +	return dma_async_is_complete(cookie, last_complete, last_used);
no residue calculation?

> +}
> +
> + * xilinx_vdma_start - Start VDMA channel
> + * @chan: Driver specific VDMA channel
> + */
> +static void xilinx_vdma_start(struct xilinx_vdma_chan *chan)
> +{
> +	int loop = XILINX_VDMA_LOOP_COUNT + 1;
> +
> +	vdma_ctrl_set(chan, XILINX_VDMA_REG_DMACR, XILINX_VDMA_DMACR_RUNSTOP);
> +
> +	/* Wait for the hardware to start */
> +	while (loop--)
> +		if (!(vdma_ctrl_read(chan, XILINX_VDMA_REG_DMASR) &
> +		      XILINX_VDMA_DMASR_HALTED))
> +			break;
wouldnt do while be better than doing than increamenting loop by 1 above and
using in while!
> +
> +	if (!loop) {
> +		dev_err(chan->dev, "Cannot start channel %p: %x\n",
> +			chan, vdma_ctrl_read(chan, XILINX_VDMA_REG_DMASR));
> +
> +		chan->err = true;
> +	}
> +
> +	return;
> +}
> +

> +/**
> + * xilinx_vdma_prep_slave_sg - prepare a descriptor for a DMA_SLAVE transaction
> + * @dchan: DMA channel
> + * @sgl: scatterlist to transfer to/from
> + * @sg_len: number of entries in @sgl
> + * @dir: DMA direction
> + * @flags: transfer ack flags
> + * @context: unused
> + *
> + * Return: Async transaction descriptor on success and NULL on failure
> + */
> +static struct dma_async_tx_descriptor *
> +xilinx_vdma_prep_slave_sg(struct dma_chan *dchan, struct scatterlist *sgl,
> +			  unsigned int sg_len, enum dma_transfer_direction dir,
> +			  unsigned long flags, void *context)
okay now am worried, this is supposed to memcpy DMA so why slave-sg??

Looking at the driver overall, IMHO we need to do:
- use the virt-dma to simplfy the cookie handling and perhpasn the descrptors
  too!
- Perhpas use interleaved API..?
- I dont think we should use the slave API as this seems memcpy case!

-- 
~Vinod
