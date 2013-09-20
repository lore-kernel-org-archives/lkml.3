Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211Ab3ITOki (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 10:40:38 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39620 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043Ab3ITOkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 10:40:37 -0400
Date: Fri, 20 Sep 2013 15:40:27 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Viresh Kumar <viresh.linux@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>
Subject: Re: [PATCH 30/51] DMA-API: dma: dw_dmac.c: convert to use
	dma_coerce_mask_and_coherent()
Message-ID: <20130920144027.GG12758@n2100.arm.linux.org.uk>
References: <20130919212235.GD12758@n2100.arm.linux.org.uk> <E1VMmBi-0007iw-MP@rmk-PC.arm.linux.org.uk> <1379687206.10899.5.camel@smile>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379687206.10899.5.camel@smile>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 20, 2013 at 05:26:46PM +0300, Andy Shevchenko wrote:
> On Thu, 2013-09-19 at 22:55 +0100, Russell King wrote:
> > This code sequence:
> > 	if (!pdev->dev.dma_mask) {
> > 		pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
> > 		pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
> > 	}
> > bypasses the architectures check on the DMA mask.  It can be replaced
> > with dma_coerce_mask_and_coherent(), avoiding the direct initialization
> > of this mask.
> > 
> > Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> > ---
> >  drivers/dma/dw/platform.c |    8 +++-----
> >  1 files changed, 3 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/dma/dw/platform.c b/drivers/dma/dw/platform.c
> > index e35d975..453822c 100644
> > --- a/drivers/dma/dw/platform.c
> > +++ b/drivers/dma/dw/platform.c
> > @@ -191,11 +191,9 @@ static int dw_probe(struct platform_device *pdev)
> >  	if (IS_ERR(chip->regs))
> >  		return PTR_ERR(chip->regs);
> >  
> > -	/* Apply default dma_mask if needed */
> > -	if (!dev->dma_mask) {
> > -		dev->dma_mask = &dev->coherent_dma_mask;
> > -		dev->coherent_dma_mask = DMA_BIT_MASK(32);
> > -	}
> > +	err = dma_coerce_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
> > +	if (err)
> > +		return err;
> 
> I have at least one question.
> 
> In case of new code you always assign dev->dma_mask.
> 
> static inline int dma_coerce_mask_and_coherent(struct device *dev, u64
> mask)
> {
>        dev->dma_mask = &dev->coherent_dma_mask;
>        return dma_set_mask_and_coherent(dev, mask);
> }
> 
> So, the question is how keep the initialized dma_mask (and should we do
> so by your opinion)?

Well, the way the DMA mask stuff is supposed to operate is:

- The device creator initializes the DMA mask to some default value.
- The driver then uses dma_set_mask() / dma_set_coherent_mask() /
  dma_set_mask_and_coherent() to adjust the mask according to the
  capabilities of the device, *even* if the mask is the same as the
  default.

This is specified in the various DMA API documents.

So, in PCI land, it works like this:
- When a PCI device is created, it has its mask set to 32-bit.
- When a driver comes along
  - if the device is capable of 64-bit addressing, it tries to set a
    64-bit mask.  If this fails, it tries to set a 32-bit mask and
    turns off 64-bit DMA.
  - if a device is not capable of 32-bit addressing but of a smaller
    space (there are some PCI devices which can only do 31-bit) then
    it tries to set that mask.
  If the driver can't successfully set a mask, it should fail to
  initialise.

This is where we should be headed with all drivers, and I would welcome
a patch for this driver to make it conform wrt the DMA API and DMA masks
in place of this patch.

Think of the coerse stuff as a middle-step to bring these types of issues
up to the fore.
