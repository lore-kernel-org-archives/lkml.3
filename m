Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563Ab3KORDl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 12:03:41 -0500
Received: from smtprelay0189.hostedemail.com ([216.40.44.189]:45454 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751067Ab3KORDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 12:03:38 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:960:966:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1535:1544:1593:1594:1605:1711:1730:1747:1777:1792:1981:2194:2196:2199:2200:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3870:3871:3872:4250:4321:4385:4605:5007:7652:78
X-HE-Tag: bit24_21f077951e36
X-Filterd-Recvd-Size: 5577
Message-ID: <1384535016.18739.23.camel@joe-AO722>
Subject: Re: [PATCHv5] dmaengine: Add support for BCM2835
From: Joe Perches <joe@perches.com>
To: Florian Meier <florian.meier@koalo.de>
Cc: Stephen Warren <swarren@wwwdotorg.org>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        devicetree <devicetree@vger.kernel.org>, alsa-devel@alsa-project.org,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@kernel.org>,
        linux-rpi-kernel <linux-rpi-kernel@lists.infradead.org>,
        dmaengine <dmaengine@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Date: Fri, 15 Nov 2013 09:03:36 -0800
In-Reply-To: <52864BBC.7000506@koalo.de>
References: <52864BBC.7000506@koalo.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-11-15 at 17:28 +0100, Florian Meier wrote:
> Add support for DMA controller of BCM2835 as used in the Raspberry Pi.
> Currently it only supports cyclic DMA.

trivial style notes:

> diff --git a/drivers/dma/bcm2835-dma.c b/drivers/dma/bcm2835-dma.c
[]
> +/* DMA CS Control and Status bits */
> +#define BCM2835_DMA_ACTIVE	(1 << 0)
> +#define BCM2835_DMA_INT	(1 << 2)
> +#define BCM2835_DMA_ISPAUSED	(1 << 4)  /* Pause requested or not active */
> +#define BCM2835_DMA_ISHELD	(1 << 5)  /* Is held by DREQ flow control */
> +#define BCM2835_DMA_ERR	(1 << 8)
> +#define BCM2835_DMA_ABORT	(1 << 30) /* stop current CB, go to next, WO */
> +#define BCM2835_DMA_RESET	(1 << 31) /* WO, self clearing */

These could use the BIT macro

> +#define BCM2835_DMA_DATA_TYPE_S8 1
> +#define BCM2835_DMA_DATA_TYPE_S16 2
> +#define BCM2835_DMA_DATA_TYPE_S32 4
> +#define BCM2835_DMA_DATA_TYPE_S128 16

Are these sizeof(s8), sizeof(s16), sizeof(s32)?
Is there a S64's?  Are there any s128's?

> +static int bcm2835_dma_abort(void __iomem *dma_chan_base)
> +{
> +	unsigned long int cs;
> +	int rc = 0;

Perhaps better without using an automatic for rc
and using direct returns.

> +
> +	cs = readl(dma_chan_base + BCM2835_DMA_CS);
> +
> +	if (BCM2835_DMA_ACTIVE & cs) {

	if (!(cs & BCM2835_DMA_ACTIVE))
		return 0;

and avoid the indent level and use consistent
(cs & bit) style through the routine instead
of mixing (bit & cs) and (cs & bit)

> +		long int timeout = 10000;

Move timeout to start of routine.

> +		/* write 0 to the active bit - pause the DMA */
> +		writel(0, dma_chan_base + BCM2835_DMA_CS);
> +
> +		/* wait for any current AXI transfer to complete */
> +		while ((cs & BCM2835_DMA_ISPAUSED) && --timeout >= 0)
> +			cs = readl(dma_chan_base + BCM2835_DMA_CS);
> +
> +		if (cs & BCM2835_DMA_ISPAUSED) {
> +			/* we'll un-pause when we set of our next DMA */
> +			rc = -ETIMEDOUT;

	return -ETIMEDOUT;

and avoid another indentation level.

> +
> +		} else if (BCM2835_DMA_ACTIVE & cs) {
> +			/* terminate the control block chain */
> +			writel(0, dma_chan_base + BCM2835_DMA_NEXTCB);
> +
> +			/* abort the whole DMA */
> +			writel(BCM2835_DMA_ABORT | BCM2835_DMA_ACTIVE,
> +			       dma_chan_base + BCM2835_DMA_CS);
> +		}
> +	}
> +
> +	return rc;
> +}

So perhaps this becomes:

static int bcm2835_dma_abort(void __iomem *dma_chan_base)
{
	unsigned long int cs;
	long timeout;

	cs = readl(dma_chan_base + BCM2835_DMA_CS);
+       if (!(cs & BCM2835_DMA_ACTIVE))
		return 0;
	
	/* write 0 to the active bit - pause the DMA */
	writel(0, dma_chan_base + BCM2835_DMA_CS);

	/* wait for any current AXI transfer to complete */
	timeout = 10000;
	while ((cs & BCM2835_DMA_ISPAUSED) && --timeout >= 0)
		cs = readl(dma_chan_base + BCM2835_DMA_CS);

	/* we'll un-pause when we set of our next DMA */
	if (cs & BCM2835_DMA_ISPAUSED)
		return -ETIMEDOUT;

	if (!(cs & BCM2835_DMA_ACTIVE))
		return 0;

	/* terminate the control block chain */
	writel(0, dma_chan_base + BCM2835_DMA_NEXTCB);
	/* abort the whole DMA */
	writel(BCM2835_DMA_ABORT | BCM2835_DMA_ACTIVE,
	       dma_chan_base + BCM2835_DMA_CS);

	return 0;
}

[]

> +static size_t bcm2835_dma_desc_size_pos(struct bcm2835_desc *d, dma_addr_t addr)
> +{
> +	unsigned i;
> +	size_t size;

Please set size to 0 here and not in the for loop
> +
> +	for (size = i = 0; i < d->frames; i++) {

[]

> +static struct dma_async_tx_descriptor *bcm2835_dma_prep_dma_cyclic(
> +	struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
> +	size_t period_len, enum dma_transfer_direction direction,
> +	unsigned long flags, void *context)
> +{

> +	/* Allocate memory for control blocks */
> +	d->control_block_size = d->frames * sizeof(struct bcm2835_dma_cb);
> +	d->control_block_base = dma_alloc_coherent(chan->device->dev,
> +			d->control_block_size, &d->control_block_base_phys,
> +			GFP_NOWAIT);
> +
> +	if (!d->control_block_base) {
> +		kfree(d);
> +		dev_err(chan->device->dev,
> +				"%s: Memory allocation error\n", __func__);

Please use dma_zalloc_coherent and the OOM message
isn't necessary as dma_alloc_coherent has a generic
OOM message.

> +		return NULL;
> +	}
> +
> +	memset(d->control_block_base, 0, d->control_block_size);

unnecessary with dma_zalloc_coherent


