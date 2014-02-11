Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005AbaBKU66 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:58:58 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:52125 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754315AbaBKU6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 15:58:54 -0500
Date: Tue, 11 Feb 2014 14:58:52 -0600
From: Andy Gross <agross@codeaurora.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>, dmaengine@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
Subject: Re: [Patch v5 1/2] dmaengine: add Qualcomm BAM dma driver
Message-ID: <20140211205852.GA10744@qualcomm.com>
References: <1391546556-27702-1-git-send-email-agross@codeaurora.org>
 <1391546556-27702-2-git-send-email-agross@codeaurora.org>
 <20140211173048.GP10628@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140211173048.GP10628@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 11:00:48PM +0530, Vinod Koul wrote:
> On Tue, Feb 04, 2014 at 02:42:35PM -0600, Andy Gross wrote:
> > Add the DMA engine driver for the QCOM Bus Access Manager (BAM) DMA controller
> > found in the MSM 8x74 platforms.
> > 

[.....]

> > + * QCOM BAM DMA engine driver
> > + *
> > + * Copyright (c) 2013-2014, The Linux Foundation. All rights reserved.
> This is bit strange, usually copyright is retained by your employer, but I am
> fine with it :)

The short answer is that this is due to legal requirements.
 
> > +struct bam_desc_hw {
> > +	u32 addr;		/* Buffer physical address */
> this is where we might have an issue. Is this the DMA register which is 32bit
> wide or you are descibing it so.
> Will this work if you are in 64 bit?

In later implementations, they add 6 more bits to the address field from some of
the reserved bits in the flags.  I am not sure what the solution will be for 64
bit, but it may very well be a slightly different descriptor.  We'll have to
address this when we add support for chips requiring that functionality.

> > +	u16 size;		/* Buffer size in bytes */
> > +	u16 flags;
> > +};

[....]

> > +
> > +	/* reset channel */
> > +	writel_relaxed(1, bdev->regs + BAM_P_RST(bchan->id));
> > +	writel_relaxed(0, bdev->regs + BAM_P_RST(bchan->id));
> > +
> > +	/* don't allow reorder of the channel reset */
> > +	wmb();
> Documentation/memory-barriers.txt describes wmb() as a CPU barier but based on
> above you want it to be a compiler barrier then you should do 1st write,
> barrier(), second write.

Sorry, the comment was not clear.  I need to reword this.  On the Krait,
accesses within a 1k band are not allowed to be reordered.  This memory barrier
is to make sure that no reordering is allowed past the call to this function.

> > +
> > +	/* make sure hw is initialized when channel is used the first time  */
> > +	bchan->initialized = 0;
> > +}
> okay why no locks held while reset?

This function is called from 2 places.  One is during the freeing of the
channel.  The other is when starting the channel (protected via vc.lock).  I was
thinking this was safe, but it's easy enough to add a lock around the
bam_reset_channel in the bam_chan_init_hw() and then add a comment to the reset
function saying that a lock is required.

[.....]

> > +
> > +	/* set fixed direction and mode, then enable channel */
> > +	val = P_EN | P_SYS_MODE;
> > +	if (dir == DMA_DEV_TO_MEM)
> > +		val |= P_DIRECTION;
> > +
> > +	/* make sure the other stores occur before enabling channel */
> > +	wmb();
> here again!

I need to reword.  The various registers are over 1K boundaries, so the barrier
is required to make sure that all the settings are not allowed to be reordered
past the channel enable.

> > +	writel_relaxed(val, bdev->regs + BAM_P_CTRL(bchan->id));
> > +
> > +	bchan->initialized = 1;
> > +
> > +	/* init FIFO pointers */
> > +	bchan->head = 0;
> > +	bchan->tail = 0;
> > +}
> > +
> > +/**
> > + * bam_alloc_chan - Allocate channel resources for DMA channel.
> > + * @chan: specified channel
> > + *
> > + * This function allocates the FIFO descriptor memory
> > + */
> > +static int bam_alloc_chan(struct dma_chan *chan)
> > +{
> > +	struct bam_chan *bchan = to_bam_chan(chan);
> > +	struct bam_device *bdev = bchan->bdev;
> > +
> > +	/* allocate FIFO descriptor space, but only if necessary */
> > +	if (!bchan->fifo_virt) {
> > +		bchan->fifo_virt = dma_alloc_writecombine(bdev->dev,
> > +					BAM_DESC_FIFO_SIZE, &bchan->fifo_phys,
> > +					GFP_KERNEL);
> > +
> > +		if (!bchan->fifo_virt) {
> > +			dev_err(bdev->dev, "Failed to allocate desc fifo\n");
> > +			return -ENOMEM;
> > +		}
> > +	}
> > +
> > +	return BAM_DESC_FIFO_SIZE;
> But you cna have SW descriptors more than HW ones and issue new ones once HW is
> done with them. Why tie the limit to what HW supports and not create a better
> driver?

Given that the virt-dma only allows me to have one outstanding transaction that
consumes the fifo, and that I allocate descriptors from kzalloc, this would be
as many as you can get until you go OOM.

The slave_sg() doesn't pull from a pool of descriptors.  It uses kzalloc.  So
what value should I use for return value?  Most drivers use 1.

[....]

> > +static void bam_slave_config(struct bam_chan *bchan,
> > +		struct dma_slave_config *cfg)
> > +{
> > +	struct bam_device *bdev = bchan->bdev;
> > +	u32 maxburst;
> > +
> > +	if (bchan->slave.direction == DMA_DEV_TO_MEM)
> > +		maxburst = bchan->slave.src_maxburst = cfg->src_maxburst;
> > +	else
> > +		maxburst = bchan->slave.dst_maxburst = cfg->dst_maxburst;
> can you remove usage of slave.direction have save both. I am going to remove
> this member...
> 

Yes. no problem.

[....]

> > +
> > +
> > +	/* allocate enough room to accomodate the number of entries */
> > +	async_desc = kzalloc(sizeof(*async_desc) +
> > +			(sg_len * sizeof(struct bam_desc_hw)), GFP_NOWAIT);
> this seems to assume that each sg entry length will not exceed the HW capablity.
> Does engine support any length descriptor, if not you may want to split to
> multiple.

Isn't this what the dma_set_max_seg_size supposed to fix?  The client is not
supposed to send segments larger than the max segment you can take.  If that is
true, then I have no issues.

> > +
> > +	if (!async_desc) {
> > +		dev_err(bdev->dev, "failed to allocate async descriptor\n");
> > +		goto err_out;
> > +	}
> > +
> > +	async_desc->num_desc = sg_len;
> > +	async_desc->curr_desc = async_desc->desc;
> > +	async_desc->dir = direction;
> > +
> > +	/* fill in descriptors, align hw descriptor to 8 bytes */
> > +	desc = async_desc->desc;
> > +	for_each_sg(sgl, sg, sg_len, i) {
> > +		if (sg_dma_len(sg) > BAM_MAX_DATA_SIZE) {
> > +			dev_err(bdev->dev, "segment exceeds max size\n");
> > +			goto err_out;
> gottcha, okay why not split here to multiple descriptors with max size all but
> last?

The client exceeded my dma_max_seg_size.  I reject that.  If that is not an
allowed solution, then I have to fix my kzalloc size above and split it here.
 
[....]

> > +
> > +	vchan_get_all_descriptors(&bchan->vc, &head);
> > +	spin_unlock_irqrestore(&bchan->vc.lock, flag);
> > +
> > +	vchan_dma_desc_free_list(&bchan->vc, &head);
> why drop the lock here, i dont think this one needs to be called with lock
> dropped, didnt see it garbbing.

It doesn't need lock.  This func just iterates over the head and calls the
desc_free func.

[....]

> > +		break;
> > +	}
> empty line after each break would be appreciated.

Ok.

[....]

> > +	if (bchan->tail + async_desc->xfer_len > MAX_DESCRIPTORS) {
> > +		u32 partial = MAX_DESCRIPTORS - bchan->tail;
> > +
> > +		memcpy(&fifo[bchan->tail], desc,
> > +				partial * sizeof(struct bam_desc_hw));
> > +		memcpy(fifo, &desc[partial], (async_desc->xfer_len - partial) *
> > +				sizeof(struct bam_desc_hw));
> > +	} else {
> > +		memcpy(&fifo[bchan->tail], desc,
> > +			async_desc->xfer_len * sizeof(struct bam_desc_hw));
> where is the destination memeory located, device or system memory. I think
> later, right?

The destination is the system memory being used for the hw fifo.  This was
allocated using dma_alloc_writecombine.

> > +	}
> > +
> > +	bchan->tail += async_desc->xfer_len;
> > +	bchan->tail %= MAX_DESCRIPTORS;
> > +
> > +	/* ensure descriptor writes and dma start not reordered */
> > +	wmb();
> > +	writel_relaxed(bchan->tail * sizeof(struct bam_desc_hw),
> > +			bdev->regs + BAM_P_EVNT_REG(bchan->id));
> > +}
> > +
> 
> Overall driver loooks fine mostly with few comments as above.
> 
> And yes for 2nd patch, would need someone to ACK it before we can appply this

Thanks for the comments.  I'll get those done and see about getting the DT
ACK'd.

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
