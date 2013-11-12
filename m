Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152Ab3KLTRF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 14:17:05 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42731 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754814Ab3KLTRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 14:17:03 -0500
Date: Tue, 12 Nov 2013 19:16:33 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Florian Meier <florian.meier@koalo.de>
Cc: Stephen Warren <swarren@wwwdotorg.org>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        devicetree <devicetree@vger.kernel.org>, alsa-devel@alsa-project.org,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@kernel.org>,
        linux-rpi-kernel <linux-rpi-kernel@lists.infradead.org>,
        dmaengine <dmaengine@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv3] dmaengine: Add support for BCM2835
Message-ID: <20131112191633.GR16735@n2100.arm.linux.org.uk>
References: <528154A1.1050303@koalo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528154A1.1050303@koalo.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 11:05:21PM +0100, Florian Meier wrote:
> Add support for DMA controller of BCM2835 as used in the Raspberry Pi.
> Currently it only supports cyclic DMA.
> 
> Signed-off-by: Florian Meier <florian.meier@koalo.de>
> ---
> 
> Thank you for your comments!
> I hope I have now removed all leftovers of the sg struct.
> Regarding the endian-ness: I have not found any hint about that in the
> datasheet. Therefore, I chose uint32_t. If you think fixed le32 is more
> likely I will change it.

I guess it's easy to change later if needed; there's likely a large
number of drivers which fall into this same category.

> The PAD fields do not seem to be used, but the datasheet states they
> should be set to 0.

Ok.  This now looks a lot better, and is smaller too!  There's a few
issues which need to be resolved still...

> +struct bcm2835_desc {
> +	struct virt_dma_desc vd;
> +	enum dma_transfer_direction dir;
> +	dma_addr_t dev_addr;

I don't think you need dev_addr here anymore - it seems to only be used
within bcm2835_dma_prep_dma_cyclic().

> +static int bcm2835_dma_alloc_chan_resources(struct dma_chan *chan)
> +{
> +	struct bcm2835_chan *c = to_bcm2835_dma_chan(chan);
> +	int ret;
> +	struct bcm2835_dmadev *d = to_bcm2835_dma_dev(chan->device);
> +	uint32_t chans = d->chans_available;

Probably just uint32_t chans; here is sufficient.  Also, as you'll be
touching this area again, a minor comment to order the variable
declarations in a more tidy way here.

> +	int chanID = 0;

Is a channel ID of zero a legal channel number?

> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&d->lock, flags);
> +
> +	chans = d->chans_available;
> +
> +	dev_dbg(c->vc.chan.device->dev,
> +			"allocating channel for %u\n", c->dma_sig);
> +
> +	/* do not use the FIQ and BULK channels */
> +	chans &= ~0xD;
> +
> +	if (!chans) {
> +		spin_unlock_irqrestore(&d->lock, flags);
> +		return -ENOMEM;
> +	}
> +
> +	/* return the ordinal of the first channel in the bitmap */
> +	chanID = __ffs(chans);
> +
> +	/* claim the channel */
> +	d->chans_available &= ~(1 << chanID);
> +
> +	c->dma_chan_base = BCM2835_DMA_CHANIO(d->dma_base, chanID);
> +	c->dma_irq_number = d->dma_irq_numbers[chanID];
> +	c->dma_ch = chanID;
> +
> +	ret = request_irq(c->dma_irq_number,
> +			bcm2835_dma_callback, 0, "DMA IRQ", c);
> +
> +	spin_unlock_irqrestore(&d->lock, flags);

Calling request_irq() from within a spinlocked region is not a nice thing
to do.  May I suggest an alternative coding for this function?

	int chanID = -1;

	dev_dbg(c->vc.chan.device->dev,
		"allocating channel for %u\n", c->dma_sig);

	spin_lock_irqsave(&d->lock, flags);

	chans = d->chans_available;
	if (chans) {
		/* return the ordinal of the first channel in the bitmap */
		chanID = __ffs(chans);

		d->chans_available &= ~(1 << chanID);
	}

	spin_unlock_irqrestore(&d->lock, flags);

	if (chanID == -1)
		return -ENOMEM;

	c->dma_chan_base = BCM2835_DMA_CHANIO(d->dma_base, chanID);
	c->dma_irq_number = d->dma_irq_numbers[chanID];
	c->dma_ch = chanID;

	ret = request_irq(c->dma_irq_number,
			bcm2835_dma_callback, 0, "DMA IRQ", c);

Now, don't forget to clean up if request_irq() fails...

	if (ret < 0) {
		spin_lock_irqsave(&d->lock, flags);
		d->chans_available |= 1 << chanID;
		spin_unlock_irqrestore(&d->lock, flags);
	}

	return ret;

How does that look?

> +
> +	if (ret < 0)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +static void bcm2835_dma_free_chan_resources(struct dma_chan *chan)
> +{
> +	struct bcm2835_chan *c = to_bcm2835_dma_chan(chan);
> +	struct bcm2835_dmadev *d = to_bcm2835_dma_dev(chan->device);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&d->lock, flags);
> +	vchan_free_chan_resources(&c->vc);
> +	d->chans_available |= 1 << c->dma_ch;
> +	free_irq(c->dma_irq_number, c);
> +	spin_unlock_irqrestore(&d->lock, flags);

A better ordering here would be:

	vchan_free_chan_resources(&c->vc);
	free_irq(c->dma_irq_number, c);

	spin_lock_irqsave(&d->lock, flags);
	d->chans_available |= 1 << c->dma_ch;
	spin_unlock_irqrestore(&d->lock, flags);

You don't need to call the first two under the spinlock - all you need to
protect is the read-modify-write of d->chans_available here and also in
the above function.

...
> +		/*
> +		 * Next block is the next frame.
> +		 * This DMA engine driver currently only supports cyclic DMA.
> +		 * Therefore, wrap around at number of frames.
> +		 */
> +		control_block->next = d->control_block_base_phys +
> +			sizeof(struct bcm2835_dma_cb) * ((frame + 1) % (d->frames));

Minor comment here - the parens around d->frames isn't required, and
wrapping this a little better would be nice.  I'd suggest moving
((frame + 1) % d->frames) onto the next line.

Other than those comments, it's looking really quite good!  Well done.
