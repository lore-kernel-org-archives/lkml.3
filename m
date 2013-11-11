Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067Ab3KKSUK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 13:20:10 -0500
Received: from smtp-out-017.synserver.de ([212.40.185.17]:1276 "EHLO
	smtp-out-207.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754981Ab3KKSUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 13:20:01 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 12926
Message-ID: <52811FDA.7080905@metafoo.de>
Date: Mon, 11 Nov 2013 19:20:10 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130922 Icedove/17.0.9
MIME-Version: 1.0
To: Florian Meier <florian.meier@koalo.de>
CC: Stephen Warren <swarren@wwwdotorg.org>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>, devicetree@vger.kernel.org,
        alsa-devel@alsa-project.org, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        linux-rpi-kernel <linux-rpi-kernel@lists.infradead.org>,
        dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [alsa-devel] [PATCHv2] dmaengine: Add support for BCM2835.
References: <528106E5.5000307@koalo.de>
In-Reply-To: <528106E5.5000307@koalo.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2013 05:33 PM, Florian Meier wrote:
[...]
> +#include <linux/dmaengine.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/err.h>
> +#include <linux/init.h>
> +#include <linux/interrupt.h>
> +#include <linux/list.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <linux/io.h>
> +#include <linux/spinlock.h>
> +#include <linux/irq.h>


No driver (other than irqchip drivers) should ever need to include irq.h

> +#include <linux/of.h>
> +#include <linux/of_dma.h>
> +
> +#include "virt-dma.h"
> +
[...]
> +struct bcm2835_chan {
> +	struct virt_dma_chan vc;
> +	struct list_head node;
> +
> +	struct dma_slave_config	cfg;
> +	unsigned dma_sig;
> +	bool cyclic;
> +	unsigned dreq;
> +
> +	int dma_ch;
> +	struct bcm2835_desc *desc;
> +	unsigned sgidx;
> +
> +	void __iomem *dma_chan_base;
> +	int dma_irq_number;
> +	struct irqaction dma_irq_handler;

dma_irq_handler is not used.

> +};
[...]
> +
[...]
> +/*
> + * This callback schedules all pending channels.  We could be more
> + * clever here by postponing allocation of the real DMA channels to
> + * this point, and freeing them when our virtual channel becomes idle.
> + *
> + * We would then need to deal with 'all channels in-use'
> + */

I'm wondering why does this need to be done in a tasklet?

> +static void bcm2835_dma_sched(unsigned long data)
> +{
> +	struct bcm2835_dmadev *d = (struct bcm2835_dmadev *)data;
> +	LIST_HEAD(head);
> +
> +	spin_lock_irq(&d->lock);
> +	list_splice_tail_init(&d->pending, &head);
> +	spin_unlock_irq(&d->lock);
> +
> +	while (!list_empty(&head)) {
> +		struct bcm2835_chan *c = list_first_entry(&head,
> +			struct bcm2835_chan, node);
> +
> +		spin_lock_irq(&c->vc.lock);
> +		list_del_init(&c->node);
> +		bcm2835_dma_start_desc(c);
> +		spin_unlock_irq(&c->vc.lock);
> +	}
> +}
> +
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

It might make sense to leave the channel id allocation to the core. Each
channel already has an unique id (chan->chan_id) so you could just reuse
that. Otherwise __ffs() is your friend

> +
> +		/* claim the channel */
> +		d->chans_available &= ~(1 << chanID);
> +
> +		c->dma_chan_base = BCM2835_DMA_CHANIO(d->dma_base, chanID);
> +		c->dma_irq_number = d->dma_irq_numbers[chanID];
> +		c->dma_ch = chanID;
> +	} else {
> +		return -ENOMEM;
> +	}
> +
> +	c->dma_irq_handler.name = "DMA engine IRQ handler";
> +	c->dma_irq_handler.flags = 0;
> +	c->dma_irq_handler.handler = bcm2835_dma_callback;
> +
> +	ret = request_irq(c->dma_irq_number,
> +			bcm2835_dma_callback, 0, "DMA IRQ", c);
> +	if (ret < 0)
> +		return ret;
> +
> +	return 0;
> +}
[...]
> +
> +static struct dma_async_tx_descriptor *bcm2835_dma_prep_dma_cyclic(
> +	struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
> +	size_t period_len, enum dma_transfer_direction direction,
> +	unsigned long flags, void *context)
> +{
[...]
> +
> +	c->cyclic = true; /* nothing else is implemented */

The channel should only be switched to cyclic once the descriptor is issued,
not when it is prepared.

> +
> +	return vchan_tx_prep(&c->vc, &d->vd, flags);
> +}
> +
> +static int bcm2835_dma_slave_config(struct bcm2835_chan *c,
> +		struct dma_slave_config *cfg)
> +{
> +	if ((cfg->direction == DMA_DEV_TO_MEM
> +			&& cfg->src_addr_width != DMA_SLAVE_BUSWIDTH_4_BYTES) ||
> +	    (cfg->direction == DMA_MEM_TO_DEV
> +			&& cfg->dst_addr_width != DMA_SLAVE_BUSWIDTH_4_BYTES)) {
> +		return -EINVAL;
> +	}

MEM_TO_MEM and DEV_TO_DEV don't seem to be supported by the driver, so
trying to set that should probably also generate an error.

> +
> +	memcpy(&c->cfg, cfg, sizeof(c->cfg));

	c->cfg = *cfg;

> +
> +	return 0;
> +}
> +
> +static int bcm2835_dma_terminate_all(struct bcm2835_chan *c)
> +{
> +	struct bcm2835_dmadev *d = to_bcm2835_dma_dev(c->vc.chan.device);
> +	unsigned long flags;
> +	LIST_HEAD(head);
> +
> +	spin_lock_irqsave(&c->vc.lock, flags);
> +
> +	/* Prevent this channel being scheduled */
> +	spin_lock(&d->lock);
> +	list_del_init(&c->node);
> +	spin_unlock(&d->lock);
> +
> +	/*
> +	 * Stop DMA activity: we assume the callback will not be called
> +	 * after bcm_dma_abort() returns (even if it does, it will see
> +	 * c->desc is NULL and exit.)
> +	 */
> +	if (c->desc) {
> +		c->desc = NULL;
> +		bcm2835_dma_abort(c->dma_chan_base);
> +
> +		/* Wait for stopping */
> +		while (readl(c->dma_chan_base + BCM2835_DMA_CS)
> +			& BCM2835_DMA_ACTIVE)
> +			;

In case the hardware acts up this should have a timeout.

> +	}
> +
> +	vchan_get_all_descriptors(&c->vc, &head);
> +	spin_unlock_irqrestore(&c->vc.lock, flags);
> +	vchan_dma_desc_free_list(&c->vc, &head);
> +
> +	return 0;
> +}
> +
> +static int bcm2835_dma_pause(struct bcm2835_chan *c)
> +{
> +	/* FIXME: not supported by platform private API */
> +	return -EINVAL;
> +}
> +
> +static int bcm2835_dma_resume(struct bcm2835_chan *c)
> +{
> +	/* FIXME: not supported by platform private API */
> +	return -EINVAL;
> +}

I think you don't need the two functions above if you are not going to
implement them.

[...]
> +
> +#if defined(CONFIG_OF)
> +static const struct of_device_id bcm2835_dma_of_match[] = {
> +	{
> +		.compatible = "brcm,bcm2835-dma",
> +	}
> +};
> +MODULE_DEVICE_TABLE(of, bcm2835_dma_of_match);

The devicetree binding documentation in Documentation/devicetree/ is missing
for this driver.

> +#endif

[...]

> +static int bcm2835_dma_probe(struct platform_device *pdev)
> +{
> +	struct bcm2835_dmadev *od;
> +	struct resource *dma_res = NULL;
> +	void __iomem *dma_base = NULL;
> +	int rc = 0;
> +	int i;
> +	struct resource *irq;
> +	int irq_resources;

You should set the maximum segment size, this allows the ASoC PCM driver to
query this and use it for the maximum period size. This means that you can
remove the snd_pcm_hardware struct with the hardcoded values from your ASoC
driver.
[...]
This can be done using the following code snippet:

pdev->dev->dma_parms = &od->dma_parms;
dma_set_max_seg_size(&pdev->dev, 0x123456);

Where od->dma_parms is of type struct device_dma_parameters and embedded in
your device struct.
\


> +static const struct platform_device_info bcm2835_dma_dev_info = {
> +	.name = "bcm2835-dma",
> +	.id = -1,
> +	.dma_mask = DMA_BIT_MASK(32),
> +};

This seems to be unused.

[...]

