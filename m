Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbaBKRcn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 12:32:43 -0500
Received: from mga09.intel.com ([134.134.136.24]:15905 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751987AbaBKRck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 12:32:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,826,1384329600"; 
   d="scan'208";a="481688183"
Date: Tue, 11 Feb 2014 23:00:48 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Andy Gross <agross@codeaurora.org>
Cc: Dan Williams <dan.j.williams@intel.com>, dmaengine@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
Subject: Re: [Patch v5 1/2] dmaengine: add Qualcomm BAM dma driver
Message-ID: <20140211173048.GP10628@intel.com>
References: <1391546556-27702-1-git-send-email-agross@codeaurora.org>
 <1391546556-27702-2-git-send-email-agross@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391546556-27702-2-git-send-email-agross@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 04, 2014 at 02:42:35PM -0600, Andy Gross wrote:
> Add the DMA engine driver for the QCOM Bus Access Manager (BAM) DMA controller
> found in the MSM 8x74 platforms.
> 
> Each BAM DMA device is associated with a specific on-chip peripheral.  Each
> channel provides a uni-directional data transfer engine that is capable of
> transferring data between the peripheral and system memory (System mode), or
> between two peripherals (BAM2BAM).
> 
> The initial release of this driver only supports slave transfers between
> peripherals and system memory.
> 
> Signed-off-by: Andy Gross <agross@codeaurora.org>

> +++ b/drivers/dma/qcom_bam_dma.c
> @@ -0,0 +1,1066 @@
> +/*
> + * QCOM BAM DMA engine driver
> + *
> + * Copyright (c) 2013-2014, The Linux Foundation. All rights reserved.
This is bit strange, usually copyright is retained by your employer, but I am
fine with it :)

> +struct bam_desc_hw {
> +	u32 addr;		/* Buffer physical address */
this is where we might have an issue. Is this the DMA register which is 32bit
wide or you are descibing it so.
Will this work if you are in 64 bit?

> +	u16 size;		/* Buffer size in bytes */
> +	u16 flags;
> +};


> +
> +/**
> + * bam_reset_channel - Reset individual BAM DMA channel
> + * @bchan: bam channel
> + *
> + * This function resets a specific BAM channel
> + */
> +static void bam_reset_channel(struct bam_chan *bchan)
> +{
> +	struct bam_device *bdev = bchan->bdev;
> +
> +	/* reset channel */
> +	writel_relaxed(1, bdev->regs + BAM_P_RST(bchan->id));
> +	writel_relaxed(0, bdev->regs + BAM_P_RST(bchan->id));
> +
> +	/* don't allow reorder of the channel reset */
> +	wmb();
Documentation/memory-barriers.txt describes wmb() as a CPU barier but based on
above you want it to be a compiler barrier then you should do 1st write,
barrier(), second write.

> +
> +	/* make sure hw is initialized when channel is used the first time  */
> +	bchan->initialized = 0;
> +}
okay why no locks held while reset?

> +
> +/**
> + * bam_chan_init_hw - Initialize channel hardware
> + * @bchan: bam channel
> + *
> + * This function resets and initializes the BAM channel
> + */
> +static void bam_chan_init_hw(struct bam_chan *bchan,
> +	enum dma_transfer_direction dir)
> +{
> +	struct bam_device *bdev = bchan->bdev;
> +	u32 val;
> +
> +	/* Reset the channel to clear internal state of the FIFO */
> +	bam_reset_channel(bchan);
> +
> +	/*
> +	 * write out 8 byte aligned address.  We have enough space for this
> +	 * because we allocated 1 more descriptor (8 bytes) than we can use
> +	 */
> +	writel_relaxed(ALIGN(bchan->fifo_phys, sizeof(struct bam_desc_hw)),
> +			bdev->regs + BAM_P_DESC_FIFO_ADDR(bchan->id));
> +	writel_relaxed(BAM_DESC_FIFO_SIZE, bdev->regs +
> +			BAM_P_FIFO_SIZES(bchan->id));
> +
> +	/* enable the per pipe interrupts, enable EOT, ERR, and INT irqs */
> +	writel_relaxed(P_DEFAULT_IRQS_EN, bdev->regs + BAM_P_IRQ_EN(bchan->id));
> +
> +	/* unmask the specific pipe and EE combo */
> +	val = readl_relaxed(bdev->regs + BAM_IRQ_SRCS_MSK_EE(bdev->ee));
> +	val |= BIT(bchan->id);
> +	writel_relaxed(val, bdev->regs + BAM_IRQ_SRCS_MSK_EE(bdev->ee));
> +
> +	/* set fixed direction and mode, then enable channel */
> +	val = P_EN | P_SYS_MODE;
> +	if (dir == DMA_DEV_TO_MEM)
> +		val |= P_DIRECTION;
> +
> +	/* make sure the other stores occur before enabling channel */
> +	wmb();
here again!

> +	writel_relaxed(val, bdev->regs + BAM_P_CTRL(bchan->id));
> +
> +	bchan->initialized = 1;
> +
> +	/* init FIFO pointers */
> +	bchan->head = 0;
> +	bchan->tail = 0;
> +}
> +
> +/**
> + * bam_alloc_chan - Allocate channel resources for DMA channel.
> + * @chan: specified channel
> + *
> + * This function allocates the FIFO descriptor memory
> + */
> +static int bam_alloc_chan(struct dma_chan *chan)
> +{
> +	struct bam_chan *bchan = to_bam_chan(chan);
> +	struct bam_device *bdev = bchan->bdev;
> +
> +	/* allocate FIFO descriptor space, but only if necessary */
> +	if (!bchan->fifo_virt) {
> +		bchan->fifo_virt = dma_alloc_writecombine(bdev->dev,
> +					BAM_DESC_FIFO_SIZE, &bchan->fifo_phys,
> +					GFP_KERNEL);
> +
> +		if (!bchan->fifo_virt) {
> +			dev_err(bdev->dev, "Failed to allocate desc fifo\n");
> +			return -ENOMEM;
> +		}
> +	}
> +
> +	return BAM_DESC_FIFO_SIZE;
But you cna have SW descriptors more than HW ones and issue new ones once HW is
done with them. Why tie the limit to what HW supports and not create a better
driver?


> +
> +/**
> + * bam_slave_config - set slave configuration for channel
> + * @chan: dma channel
> + * @cfg: slave configuration
> + *
> + * Sets slave configuration for channel
> + *
> + */
> +static void bam_slave_config(struct bam_chan *bchan,
> +		struct dma_slave_config *cfg)
> +{
> +	struct bam_device *bdev = bchan->bdev;
> +	u32 maxburst;
> +
> +	if (bchan->slave.direction == DMA_DEV_TO_MEM)
> +		maxburst = bchan->slave.src_maxburst = cfg->src_maxburst;
> +	else
> +		maxburst = bchan->slave.dst_maxburst = cfg->dst_maxburst;
can you remove usage of slave.direction have save both. I am going to remove
this member...

> +
> +	/* set desc threshold */
> +	writel_relaxed(maxburst, bdev->regs + BAM_DESC_CNT_TRSHLD);
> +}
> +
> +/**
> + * bam_prep_slave_sg - Prep slave sg transaction
> + *
> + * @chan: dma channel
> + * @sgl: scatter gather list
> + * @sg_len: length of sg
> + * @direction: DMA transfer direction
> + * @flags: DMA flags
> + * @context: transfer context (unused)
> + */
> +static struct dma_async_tx_descriptor *bam_prep_slave_sg(struct dma_chan *chan,
> +	struct scatterlist *sgl, unsigned int sg_len,
> +	enum dma_transfer_direction direction, unsigned long flags,
> +	void *context)
> +{
> +	struct bam_chan *bchan = to_bam_chan(chan);
> +	struct bam_device *bdev = bchan->bdev;
> +	struct bam_async_desc *async_desc;
> +	struct scatterlist *sg;
> +	u32 i;
> +	struct bam_desc_hw *desc;
> +
> +
> +	if (!is_slave_direction(direction)) {
> +		dev_err(bdev->dev, "invalid dma direction\n");
> +		return NULL;
> +	}
> +
> +
> +	/* allocate enough room to accomodate the number of entries */
> +	async_desc = kzalloc(sizeof(*async_desc) +
> +			(sg_len * sizeof(struct bam_desc_hw)), GFP_NOWAIT);
this seems to assume that each sg entry length will not exceed the HW capablity.
Does engine support any length descriptor, if not you may want to split to
multiple.

> +
> +	if (!async_desc) {
> +		dev_err(bdev->dev, "failed to allocate async descriptor\n");
> +		goto err_out;
> +	}
> +
> +	async_desc->num_desc = sg_len;
> +	async_desc->curr_desc = async_desc->desc;
> +	async_desc->dir = direction;
> +
> +	/* fill in descriptors, align hw descriptor to 8 bytes */
> +	desc = async_desc->desc;
> +	for_each_sg(sgl, sg, sg_len, i) {
> +		if (sg_dma_len(sg) > BAM_MAX_DATA_SIZE) {
> +			dev_err(bdev->dev, "segment exceeds max size\n");
> +			goto err_out;
gottcha, okay why not split here to multiple descriptors with max size all but
last?

> +		}
> +
> +		desc->addr = sg_dma_address(sg);
> +		desc->size = sg_dma_len(sg);
> +		async_desc->length += sg_dma_len(sg);
> +		desc++;
> +	}
> +
> +	return vchan_tx_prep(&bchan->vc, &async_desc->vd, flags);
> +
> +err_out:
> +	kfree(async_desc);
> +	return NULL;
> +}
> +
> +/**
> + * bam_dma_terminate_all - terminate all transactions on a channel
> + * @bchan: bam dma channel
> + *
> + * Dequeues and frees all transactions
> + * No callbacks are done
> + *
> + */
> +static void bam_dma_terminate_all(struct bam_chan *bchan)
> +{
> +	unsigned long flag;
> +	LIST_HEAD(head);
> +
> +	/* remove all transactions, including active transaction */
> +	spin_lock_irqsave(&bchan->vc.lock, flag);
> +	if (bchan->curr_txd) {
> +		list_add(&bchan->curr_txd->vd.node, &bchan->vc.desc_issued);
> +		bchan->curr_txd = NULL;
> +	}
> +
> +	vchan_get_all_descriptors(&bchan->vc, &head);
> +	spin_unlock_irqrestore(&bchan->vc.lock, flag);
> +
> +	vchan_dma_desc_free_list(&bchan->vc, &head);
why drop the lock here, i dont think this one needs to be called with lock
dropped, didnt see it garbbing.

> +}
> +
> +/**
> + * bam_control - DMA device control
> + * @chan: dma channel
> + * @cmd: control cmd
> + * @arg: cmd argument
> + *
> + * Perform DMA control command
> + *
> + */
> +static int bam_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
> +	unsigned long arg)
> +{
> +	struct bam_chan *bchan = to_bam_chan(chan);
> +	struct bam_device *bdev = bchan->bdev;
> +	int ret = 0;
> +	unsigned long flag;
> +
> +	switch (cmd) {
> +	case DMA_PAUSE:
> +		spin_lock_irqsave(&bchan->vc.lock, flag);
> +		writel_relaxed(1, bdev->regs + BAM_P_HALT(bchan->id));
> +		bchan->paused = 1;
> +		spin_unlock_irqrestore(&bchan->vc.lock, flag);
> +		break;
> +	case DMA_RESUME:
> +		spin_lock_irqsave(&bchan->vc.lock, flag);
> +		writel_relaxed(0, bdev->regs + BAM_P_HALT(bchan->id));
> +		bchan->paused = 0;
> +		spin_unlock_irqrestore(&bchan->vc.lock, flag);
> +		break;
> +	case DMA_TERMINATE_ALL:
> +		bam_dma_terminate_all(bchan);
> +		break;
> +	case DMA_SLAVE_CONFIG:
> +		bam_slave_config(bchan, (struct dma_slave_config *)arg);
> +		break;
> +	default:
> +		ret = -ENXIO;
> +		break;
> +	}
empty line after each break would be appreciated.
> +
> +	return ret;
> +}
> +

> +/**
> + * bam_start_dma - start next transaction
> + * @bchan - bam dma channel
> + *
> + * Note: must hold bam dma channel vc.lock
> + */
> +static void bam_start_dma(struct bam_chan *bchan)
> +{
> +	struct virt_dma_desc *vd = vchan_next_desc(&bchan->vc);
> +	struct bam_device *bdev = bchan->bdev;
> +	struct bam_async_desc *async_desc;
> +	struct bam_desc_hw *desc;
> +	struct bam_desc_hw *fifo = PTR_ALIGN(bchan->fifo_virt,
> +					sizeof(struct bam_desc_hw));
> +
> +	if (!vd)
> +		return;
> +
> +	list_del(&vd->node);
> +
> +	async_desc = container_of(vd, struct bam_async_desc, vd);
> +	bchan->curr_txd = async_desc;
> +
> +	/* on first use, initialize the channel hardware */
> +	if (!bchan->initialized)
> +		bam_chan_init_hw(bchan, async_desc->dir);
> +
> +
> +	desc = bchan->curr_txd->curr_desc;
> +
> +	if (async_desc->num_desc > MAX_DESCRIPTORS)
> +		async_desc->xfer_len = MAX_DESCRIPTORS;
> +	else
> +		async_desc->xfer_len = async_desc->num_desc;
> +
> +	/* set INT on last descriptor */
> +	desc[async_desc->xfer_len - 1].flags |= DESC_FLAG_INT;
> +
> +	if (bchan->tail + async_desc->xfer_len > MAX_DESCRIPTORS) {
> +		u32 partial = MAX_DESCRIPTORS - bchan->tail;
> +
> +		memcpy(&fifo[bchan->tail], desc,
> +				partial * sizeof(struct bam_desc_hw));
> +		memcpy(fifo, &desc[partial], (async_desc->xfer_len - partial) *
> +				sizeof(struct bam_desc_hw));
> +	} else {
> +		memcpy(&fifo[bchan->tail], desc,
> +			async_desc->xfer_len * sizeof(struct bam_desc_hw));
where is the destination memeory located, device or system memory. I think
later, right?
> +	}
> +
> +	bchan->tail += async_desc->xfer_len;
> +	bchan->tail %= MAX_DESCRIPTORS;
> +
> +	/* ensure descriptor writes and dma start not reordered */
> +	wmb();
> +	writel_relaxed(bchan->tail * sizeof(struct bam_desc_hw),
> +			bdev->regs + BAM_P_EVNT_REG(bchan->id));
> +}
> +

Overall driver loooks fine mostly with few comments as above.

And yes for 2nd patch, would need someone to ACK it before we can appply this

-- 
~Vinod
