Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068Ab3KORwV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 12:52:21 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42935 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab3KORwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 12:52:12 -0500
Date: Fri, 15 Nov 2013 17:51:55 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
Cc: Florian Meier <florian.meier@koalo.de>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>, dmaengine <dmaengine@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv5] dmaengine: Add support for BCM2835
Message-ID: <20131115175155.GQ16735@n2100.arm.linux.org.uk>
References: <52864BBC.7000506@koalo.de> <1384537403.14845.131.camel@smile>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384537403.14845.131.camel@smile>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 05:43:45PM +0000, Shevchenko, Andriy wrote:
> On Fri, 2013-11-15 at 17:28 +0100, Florian Meier wrote:
> > +static size_t bcm2835_dma_desc_size_pos(struct bcm2835_desc *d, dma_addr_t addr)
> > +{
> > +	unsigned i;
> > +	size_t size;
> 
> size = 0 here is better.

See my other comment to Joe.

> > +	for (size = i = 0; i < d->frames; i++) {
> > +		struct bcm2835_dma_cb *control_block =
> > +			&d->control_block_base[i];
> > +		size_t this_size = control_block->length;
> > +		dma_addr_t dma;
> > +
> > +		if (d->dir == DMA_DEV_TO_MEM)
> > +			dma = control_block->dst;
> > +		else
> > +			dma = control_block->src;
> 
> Do you think it must be dependent on the direction?

Of course it does.  Take a moment to think about it please.

> Do you have information of how many bytes transferred already in the DMA
> controller registers? Would it be better to use it?
> 
> > +		if (size)
> > +			size += this_size;
> > +		else if (addr >= dma && addr < dma + this_size)
> > +			size += dma + this_size - addr;
> 
> += -> =

No functional change, as 'size' has to be initialised anyway.  The
code is fine.

> > +	if (!pdev->dev.dma_mask)
> > +		pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
> > +
> > +	rc = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
> > +	if (rc)
> > +		return rc;
> > +	dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
> 
> There is nice helper you may use instead of those two above and remove
> 'if' condition as well.

There is _now_ but at the time this is being developed, it wasn't there.
Such a change is probably only appropriate at least after -rc1 has
happened.  Since I'm the one who introduced that helper, and I haven't
said to use it yet in this driver, that suggests I've already thought
about this point...

> > +module_platform_driver(bcm2835_dma_driver);
> 
> Is it possible to get driver initialized after that one that uses it?

Doesn't quite make sense.  If you're asking whether other drivers can
try to make use of this driver before it's initialised, then the answer
is no.  We have mechanisms to cope with that - see deferred probing.
