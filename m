Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908Ab3KORoQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 12:44:16 -0500
Received: from mga02.intel.com ([134.134.136.20]:58905 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808Ab3KORoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 12:44:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="409496330"
From: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
To: Florian Meier <florian.meier@koalo.de>
CC: "Koul, Vinod" <vinod.koul@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>, dmaengine <dmaengine@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv5] dmaengine: Add support for BCM2835
Thread-Topic: [PATCHv5] dmaengine: Add support for BCM2835
Thread-Index: AQHO4io75BKXqctgE0maqNIPi+iE6A==
Date: Fri, 15 Nov 2013 17:43:45 +0000
Message-ID: <1384537403.14845.131.camel@smile>
References: <52864BBC.7000506@koalo.de>
In-Reply-To: <52864BBC.7000506@koalo.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.72.173]
Content-Type: text/plain; charset="utf-8"
Content-ID: <3DE0200596CF7E418D1E68B6C245A77D@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rAFHiKZY015960

On Fri, 2013-11-15 at 17:28 +0100, Florian Meier wrote:
> Add support for DMA controller of BCM2835 as used in the Raspberry Pi.
> Currently it only supports cyclic DMA.

Few comments below.

> +++ b/drivers/dma/bcm2835-dma.c
> @@ -0,0 +1,749 @@
> +/*
> + * BCM2835 DMA engine support
> + *
> + * This driver only supports cyclic DMA transfers
> + * as needed for the I2S module.
> + *
> + * Author:      Florian Meier, <florian.meier@koalo.de>

Comma there a bit inconvenient. It would be easier to copy'n'paste
address w/o it.

Up to you.

> + *              Copyright 2013
> + *
> + * based on

Maybe 'Based on'?

[]

> +struct bcm2835_chan {

> +	int dma_ch;

Do you really need this dma_ prefix?

> +	void __iomem *dma_chan_base;
> +	int dma_irq_number;

Ditto.

> +#define BCM2835_DMA_ABORT	(1 << 30) /* stop current CB, go to next, WO */
> +#define BCM2835_DMA_RESET	(1 << 31) /* WO, self clearing */

You have different style of comments in the file: some of them starts
from capital letter, some not. It would be better to have one style.

> +#define BCM2835_DMA_DATA_TYPE_S8 1
> +#define BCM2835_DMA_DATA_TYPE_S16 2
> +#define BCM2835_DMA_DATA_TYPE_S32 4
> +#define BCM2835_DMA_DATA_TYPE_S128 16

Indentation?

> +#define BCM2835_DMA_CHANIO(dma_base, n) ((dma_base) + BCM2835_DMA_CHAN(n))

dma_base -> base ?

[]

> +static size_t bcm2835_dma_desc_size_pos(struct bcm2835_desc *d, dma_addr_t addr)
> +{
> +	unsigned i;
> +	size_t size;

size = 0 here is better.

> +	for (size = i = 0; i < d->frames; i++) {
> +		struct bcm2835_dma_cb *control_block =
> +			&d->control_block_base[i];
> +		size_t this_size = control_block->length;
> +		dma_addr_t dma;
> +
> +		if (d->dir == DMA_DEV_TO_MEM)
> +			dma = control_block->dst;
> +		else
> +			dma = control_block->src;

Do you think it must be dependent on the direction?

Do you have information of how many bytes transferred already in the DMA
controller registers? Would it be better to use it?

> +		if (size)
> +			size += this_size;
> +		else if (addr >= dma && addr < dma + this_size)
> +			size += dma + this_size - addr;

+= -> =


[]

> +static enum dma_status bcm2835_dma_tx_status(struct dma_chan *chan,
> +	dma_cookie_t cookie, struct dma_tx_state *txstate)
> +{

> +	} else {
> +		txstate->residue = 0;

Not needed since it's default by dmaengine.

> +static void bcm2835_dma_issue_pending(struct dma_chan *chan)
> +{

> +}
> +
> +

Redundant empty line

> +static struct dma_async_tx_descriptor *bcm2835_dma_prep_dma_cyclic(

> +		/* The following fields are not used here */
> +		control_block->stride = 0;
> +		control_block->pad[0] = 0;
> +		control_block->pad[1] = 0;

You have already them zeroed by memset.

[]

> +static int bcm2835_dma_slave_config(struct bcm2835_chan *c,
> +		struct dma_slave_config *cfg)
> +{

> +	    (cfg->direction != DMA_DEV_TO_MEM &&
> +	     cfg->direction != DMA_MEM_TO_DEV)) {

We have a helper for those two above.

[]

> +static int bcm2835_dma_chan_init(struct bcm2835_dmadev *d, int chan_id, int irq)
> +{
> +	struct bcm2835_chan *c;
> +
> +	c = kzalloc(sizeof(*c), GFP_KERNEL);

Why this can't be devm_kzalloc?

[]

> +static int bcm2835_dma_probe(struct platform_device *pdev)
> +{

> +	struct resource *dma_res = NULL;
> +	void __iomem *dma_base = NULL;
> +	int rc = 0;
> +	int i = 0;

Useless assignments.

[]

> +	if (!pdev->dev.dma_mask)
> +		pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
> +
> +	rc = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
> +	if (rc)
> +		return rc;
> +	dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));

There is nice helper you may use instead of those two above and remove
'if' condition as well.

[]

> +}

[]

> +module_platform_driver(bcm2835_dma_driver);

Is it possible to get driver initialized after that one that uses it?

-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy
---------------------------------------------------------------------
Intel Finland Oy
Registered Address: PL 281, 00181 Helsinki 
Business Identity Code: 0357606 - 4 
Domiciled in Helsinki 

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
