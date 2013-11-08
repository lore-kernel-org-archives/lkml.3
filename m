Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758082Ab3KHTL4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 14:11:56 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42529 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757478Ab3KHTLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 14:11:54 -0500
Date: Fri, 8 Nov 2013 19:11:17 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Florian Meier <florian.meier@koalo.de>
Cc: Stephen Warren <swarren@wwwdotorg.org>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>, devicetree@vger.kernel.org,
        alsa-devel@alsa-project.org, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        linux-rpi-kernel <linux-rpi-kernel@lists.infradead.org>,
        dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] dmaengine: Add support for BCM2835.
Message-ID: <20131108191117.GT16735@n2100.arm.linux.org.uk>
References: <527D1DDA.2040004@koalo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <527D1DDA.2040004@koalo.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 08, 2013 at 06:22:34PM +0100, Florian Meier wrote:

Hi Florian, some initial comments.

> +#define BCM2835_DMA_DATA_TYPE_S8 1
> +#define BCM2835_DMA_DATA_TYPE_S16 2
> +#define BCM2835_DMA_DATA_TYPE_S32 4
> +#define BCM2835_DMA_DATA_TYPE_S128 16
...
> +
> +static const unsigned es_bytes[] = {
> +	[BCM2835_DMA_DATA_TYPE_S8] = 1,
> +	[BCM2835_DMA_DATA_TYPE_S16] = 2,
> +	[BCM2835_DMA_DATA_TYPE_S32] = 4,
> +	[BCM2835_DMA_DATA_TYPE_S128] = 16
> +};

This looks rather fun - and the only place d->es is used is to convey
this as an index into this table for bcm2835_dma_desc_size().  I can't
quite see the point of this table existing.

> +static void bcm2835_dma_start_sg(struct bcm2835_chan *c, struct bcm2835_desc *d,
> +		unsigned idx)
> +{
> +	struct bcm2835_sg *sg = d->sg + idx;
> +	int frame;
> +	int frames = sg->fn;
> +
> +	/*
> +	 * Iterate over all frames and create a control block
> +	 * for each frame and link them together.
> +	 */
> +	for (frame = 0; frame < frames; frame++) {
> +		struct bcm2835_dma_cb *control_block =
> +			&d->control_block_base[frame];
> +
> +		/* Setup adresses */
> +		if (d->dir == DMA_DEV_TO_MEM) {
> +			control_block->info = BCM2835_DMA_D_INC;
> +			control_block->src = d->dev_addr;
> +			control_block->dst = sg->addr+frame*sg->en;
> +		} else {
> +			control_block->info = BCM2835_DMA_S_INC;
> +			control_block->src = sg->addr+frame*sg->en;
> +			control_block->dst = d->dev_addr;
> +		}
> +
> +		/* Enable interrupt */
> +		control_block->info |= BCM2835_DMA_INT_EN;
> +
> +		/* Setup synchronization */
> +		if (d->sync_type != 0)
> +			control_block->info |= d->sync_type;
> +
> +		/* Setup DREQ channel */
> +		if (d->sync_dreq != 0)
> +			control_block->info |=
> +				BCM2835_DMA_PER_MAP(d->sync_dreq);
> +
> +		/* Length of a frame */
> +		control_block->length = sg->en;
> +
> +		/*
> +		 * Next block is the next frame.
> +		 * This DMA engine driver currently only supports cyclic DMA.
> +		 * Therefore, wrap around at number of frames.
> +		 */
> +		control_block->next = d->control_block_base_phys +
> +			sizeof(struct bcm2835_dma_cb)*((frame+1)%(frames));
> +
> +		/* The following fields are not used here */
> +		control_block->stride = 0;
> +		control_block->pad[0] = 0;
> +		control_block->pad[1] = 0;
> +	}

Why not move the initialisation of this control block to the preparation
function?  I think doing that would simplify this code somewhat, as
you won't be converting the information passed to the preparation function
multiple times.

> +static int bcm2835_dma_alloc_chan_resources(struct dma_chan *chan)
> +{
> +	struct bcm2835_chan *c = to_bcm2835_dma_chan(chan);
> +	int ret;
> +	struct bcm2835_dmadev *d = to_bcm2835_dma_dev(chan->device);
> +	uint32_t chans = d->chans_available;
> +	int chanID = 0;
> +
> +	dev_dbg(c->vc.chan.device->dev,
> +			"allocating channel for %u\n", c->dma_sig);
> +
> +	/* do not use the FIQ and BULK channels */
> +	chans &= ~0xD;
> +
> +	if (chans) {
> +		/* return the ordinal of the first channel in the bitmap */
> +		while (chans != 0 && (chans & 1) == 0) {
> +			chans >>= 1;
> +			chanID++;
> +		}
> +
> +		/* claim the channel */
> +		d->chans_available &= ~(1 << chanID);
> +
> +		c->dma_chan_base = BCM2835_DMA_CHANIO(d->dma_base, chanID);
> +
> +		c->dma_irq_number = d->dma_irq_numbers[chanID];
> +
> +		c->dma_ch = chanID;
> +	} else {
> +		return -ENOMEM;
> +	}
> +
> +	c->dma_irq_handler.name = "DMA engine IRQ handler";
> +	c->dma_irq_handler.flags = 0;
> +	c->dma_irq_handler.handler = bcm2835_dma_callback;
> +
> +	ret = request_any_context_irq(c->dma_irq_number,
> +			bcm2835_dma_callback, 0, "DMA IRQ", c);

Hmm.  Why "request_any_context_irq" ?  Looking at what your "dma callback"
is doing, it's operating entirely beneath a spinlock with IRQs disabled.
You might as well handle it in hard IRQ context.

> +static struct dma_async_tx_descriptor *bcm2835_dma_prep_dma_cyclic(
> +	struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
> +	size_t period_len, enum dma_transfer_direction direction,
> +	unsigned long flags, void *context)
> +{
> +	struct bcm2835_chan *c = to_bcm2835_dma_chan(chan);
> +	enum dma_slave_buswidth dev_width;
> +	struct bcm2835_desc *d;
> +	dma_addr_t dev_addr;
> +	unsigned int es, sync_type, sync_dreq;
> +
> +	/* Grab configuration */
> +	if (direction == DMA_DEV_TO_MEM) {
> +		dev_addr = c->cfg.src_addr;
> +		dev_width = c->cfg.src_addr_width;
> +		sync_type = BCM2835_DMA_S_DREQ;
> +		sync_dreq = c->cfg.slave_id;
> +	} else if (direction == DMA_MEM_TO_DEV) {
> +		dev_addr = c->cfg.dst_addr;
> +		dev_width = c->cfg.dst_addr_width;
> +		sync_type = BCM2835_DMA_D_DREQ;
> +		sync_dreq = c->cfg.slave_id;
> +	} else {
> +		dev_err(chan->device->dev, "%s: bad direction?\n", __func__);
> +		return NULL;
> +	}

Please move sync_dreq out of the if() statements; it doesn't appear to
depend on the direction (there's only one of them in that structure too.)
While there, you might as well assign it directly to d->sync_dreq below.

Even better, with the code in bcm2835_dma_start_sg() moved into this
function to generate the control block, you don't need to save a lot
of the information in your descriptor.

> +
> +	/* Bus width translates to the element size (ES) */
> +	switch (dev_width) {
> +	case DMA_SLAVE_BUSWIDTH_4_BYTES:
> +		es = BCM2835_DMA_DATA_TYPE_S32;
> +		break;
> +	default:
> +		return NULL;
> +	}
> +
> +	/* Now allocate and setup the descriptor. */
> +	d = kzalloc(sizeof(*d) + sizeof(d->sg[0]), GFP_ATOMIC);
> +	if (!d)
> +		return NULL;
> +
> +	d->dir = direction;
> +	d->dev_addr = dev_addr;
> +	d->es = es;
> +	d->sync_type = sync_type;
> +	d->sync_dreq = sync_dreq;
> +	d->sg[0].addr = buf_addr;
> +	d->sg[0].en = period_len;
> +	d->sg[0].fn = buf_len / period_len;
> +	d->sglen = 1;
> +
> +	/* Allocate memory for control blocks */
> +	d->control_block_size = d->sg[0].fn*sizeof(struct bcm2835_dma_cb);
> +	d->control_block_base = dma_alloc_coherent(chan->device->dev,
> +			d->control_block_size, &d->control_block_base_phys,
> +			GFP_KERNEL);
> +
> +	if (!d->control_block_base) {
> +		dev_err(chan->device->dev,
> +				"%s: Memory allocation error\n", __func__);
> +		return NULL;
> +	}
> +
> +	memset(d->control_block_base, 0, d->control_block_size);
> +
> +	if (!c->cyclic) {
> +		c->cyclic = true;
> +		/* nothing else is implemented */
> +	}

This is needlessly complex; please simplify this.

> +
> +	return vchan_tx_prep(&c->vc, &d->vd, DMA_CTRL_ACK | DMA_PREP_INTERRUPT);

You should pass 'flags' as the 3rd argument here.
