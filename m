Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759301Ab3KMJOj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 04:14:39 -0500
Received: from mga09.intel.com ([134.134.136.24]:57641 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759276Ab3KMJOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 04:14:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="434451838"
Date: Wed, 13 Nov 2013 13:48:19 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Florian Meier <florian.meier@koalo.de>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Dan Williams <dan.j.williams@intel.com>,
        devicetree <devicetree@vger.kernel.org>, alsa-devel@alsa-project.org,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@kernel.org>,
        linux-rpi-kernel <linux-rpi-kernel@lists.infradead.org>,
        dmaengine <dmaengine@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv3] dmaengine: Add support for BCM2835
Message-ID: <20131113081819.GP8834@intel.com>
References: <528154A1.1050303@koalo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528154A1.1050303@koalo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
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
> Regarding the endian-ness: I have not found any hint about that in the datasheet. Therefore, I chose uint32_t. If you think fixed le32 is more likely I will change it.
> The PAD fields do not seem to be used, but the datasheet states they should be set to 0.
can you pls reflow this to 80chars...

Also going thru driver I suspect you have not run checkpatch, pls do run this
scriprt to check for coding style 
> +static irqreturn_t bcm2835_dma_callback(int irq, void *data)
> +{
> +	struct bcm2835_chan *c = data;
> +	struct bcm2835_desc *d;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&c->vc.lock, flags);
> +
> +	/* acknowledge interrupt */
> +	writel(BCM2835_DMA_INT, c->dma_chan_base + BCM2835_DMA_CS);
> +
> +	d = c->desc;
> +
> +	if (d) {
> +		if (!c->cyclic) {
> +			bcm2835_dma_start_desc(c);
> +			vchan_cookie_complete(&d->vd);
I dont see callback being invoked for this case?

> +		} else {
> +			vchan_cyclic_callback(&d->vd);
> +		}
> +	}
> +
> +	/* keep the DMA engine running */
> +	dsb(); /* ARM synchronization barrier */
> +	writel(BCM2835_DMA_ACTIVE, c->dma_chan_base + BCM2835_DMA_CS);
> +
> +	spin_unlock_irqrestore(&c->vc.lock, flags);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int bcm2835_dma_alloc_chan_resources(struct dma_chan *chan)
> +{
> +	struct bcm2835_chan *c = to_bcm2835_dma_chan(chan);
> +	int ret;
> +	struct bcm2835_dmadev *d = to_bcm2835_dma_dev(chan->device);
> +	uint32_t chans = d->chans_available;
> +	int chanID = 0;
Pls avoid camel case

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
> +
> +	if (ret < 0)
> +		return ret;
> +
> +	return 0;
unconditional return ret; will do same!

> +static size_t bcm2835_dma_desc_size(struct bcm2835_desc *d)
> +{
> +	unsigned i;
> +	size_t size;
> +
> +	for (size = i = 0; i < d->frames; i++) {
> +		struct bcm2835_dma_cb *control_block =
> +			&d->control_block_base[i];
> +
> +		size += control_block->length;
> +	}
> +
> +	return size;
you may want to store this in descritpor which creating that, so you can
avoid computation at query

> +static struct dma_async_tx_descriptor *bcm2835_dma_prep_dma_cyclic(
> +	struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
> +	size_t period_len, enum dma_transfer_direction direction,
> +	unsigned long flags, void *context)
> +{
> +	struct bcm2835_chan *c = to_bcm2835_dma_chan(chan);
> +	enum dma_slave_buswidth dev_width;
> +	struct bcm2835_desc *d;
> +	dma_addr_t dev_addr;
> +	unsigned es, sync_type;
> +	unsigned frame;
> +
> +	/* Grab configuration */
> +	if (direction == DMA_DEV_TO_MEM) {
> +		dev_addr = c->cfg.src_addr;
> +		dev_width = c->cfg.src_addr_width;
> +		sync_type = BCM2835_DMA_S_DREQ;
> +	} else if (direction == DMA_MEM_TO_DEV) {
> +		dev_addr = c->cfg.dst_addr;
> +		dev_width = c->cfg.dst_addr_width;
> +		sync_type = BCM2835_DMA_D_DREQ;
> +	} else {
> +		dev_err(chan->device->dev, "%s: bad direction?\n", __func__);
> +		return NULL;
> +	}
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
> +	d = kzalloc(sizeof(*d), GFP_ATOMIC);
GFP_NOWAIT is recommendation for DMA drivers

> +	if (!d)
> +		return NULL;
> +
> +	d->dir = direction;
> +	d->dev_addr = dev_addr;
> +	d->frames = buf_len / period_len;
> +
> +	/* Allocate memory for control blocks */
> +	d->control_block_size = d->frames * sizeof(struct bcm2835_dma_cb);
> +	d->control_block_base = dma_alloc_coherent(chan->device->dev,
> +			d->control_block_size, &d->control_block_base_phys,
> +			GFP_KERNEL);
ditto

> +
> +	if (!d->control_block_base) {
> +		dev_err(chan->device->dev,
> +				"%s: Memory allocation error\n", __func__);
> +		return NULL;
you need to free "d" allocated above..
> +	}
> +
> +	memset(d->control_block_base, 0, d->control_block_size);

> +static int bcm2835_dma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
> +	unsigned long arg)
> +{
> +	struct bcm2835_chan *c = to_bcm2835_dma_chan(chan);
> +	int ret;
> +
> +	switch (cmd) {
> +	case DMA_SLAVE_CONFIG:
> +		return bcm2835_dma_slave_config(c,
> +				(struct dma_slave_config *)arg);
> +
> +	case DMA_TERMINATE_ALL:
> +		bcm2835_dma_terminate_all(c);
> +		break;
> +
> +	case DMA_PAUSE:
> +		ret = -EINVAL;
> +		break;
> +
> +	case DMA_RESUME:
> +		ret = -EINVAL;
> +		break;
> +
> +	default:
> +		ret = -ENXIO;
> +		break;
you should do same for PAUSE/RESUME, actually no need to add code for those and
fall thru default!

Also since you are going to use for audio pls do implement the capablity APIs in
the driver so that thing like what you support and parametsr and automatically
discovered and need not be hard coded

> +static int bcm2835_dma_probe(struct platform_device *pdev)
> +{
> +	struct bcm2835_dmadev *od;
> +	struct resource *dma_res = NULL;
> +	void __iomem *dma_base = NULL;
> +	int rc = 0;
> +	int i;
> +	struct resource *irq;
> +	int irq_resources;
> +
> +	if (!pdev->dev.dma_mask)
> +		pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
> +
> +	rc = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
> +	if (rc)
> +		return rc;
> +	dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
> +
> +	od = devm_kzalloc(&pdev->dev, sizeof(*od), GFP_KERNEL);
> +	if (!od)
> +		return -ENOMEM;
> +
> +	pdev->dev.dma_parms = &od->dma_parms;
> +	dma_set_max_seg_size(&pdev->dev, 0x3FFFFFFF);
Can you support such a large txn or you want to do this thur SW?

> +module_platform_driver(bcm2835_dma_driver);
> +
> +MODULE_AUTHOR("Florian Meier");
> +MODULE_DESCRIPTION("BCM2835 DMA engine driver");
> +MODULE_LICENSE("GPL");
MODULE_ALIAS too pls

--
~Vinod
