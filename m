Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177Ab3ITP0S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 11:26:18 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:44045 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab3ITP0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 11:26:17 -0400
MIME-Version: 1.0
In-Reply-To: <20130920144027.GG12758@n2100.arm.linux.org.uk>
References: <20130919212235.GD12758@n2100.arm.linux.org.uk>
	<E1VMmBi-0007iw-MP@rmk-PC.arm.linux.org.uk>
	<1379687206.10899.5.camel@smile>
	<20130920144027.GG12758@n2100.arm.linux.org.uk>
Date: Fri, 20 Sep 2013 18:26:16 +0300
Message-ID: <CAHp75VdviE_FpEHub=W=f3reb6Dd2VVxtRkd_kYw5XC3772cTQ@mail.gmail.com>
Subject: Re: [PATCH 30/51] DMA-API: dma: dw_dmac.c: convert to use dma_coerce_mask_and_coherent()
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 20, 2013 at 5:40 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Fri, Sep 20, 2013 at 05:26:46PM +0300, Andy Shevchenko wrote:
>> On Thu, 2013-09-19 at 22:55 +0100, Russell King wrote:
>> > This code sequence:
>> >     if (!pdev->dev.dma_mask) {
>> >             pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
>> >             pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
>> >     }
>> > bypasses the architectures check on the DMA mask.  It can be replaced
>> > with dma_coerce_mask_and_coherent(), avoiding the direct initialization
>> > of this mask.
>> >
>> > Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
>> > ---
>> >  drivers/dma/dw/platform.c |    8 +++-----
>> >  1 files changed, 3 insertions(+), 5 deletions(-)
>> >
>> > diff --git a/drivers/dma/dw/platform.c b/drivers/dma/dw/platform.c
>> > index e35d975..453822c 100644
>> > --- a/drivers/dma/dw/platform.c
>> > +++ b/drivers/dma/dw/platform.c
>> > @@ -191,11 +191,9 @@ static int dw_probe(struct platform_device *pdev)
>> >     if (IS_ERR(chip->regs))
>> >             return PTR_ERR(chip->regs);
>> >
>> > -   /* Apply default dma_mask if needed */
>> > -   if (!dev->dma_mask) {
>> > -           dev->dma_mask = &dev->coherent_dma_mask;
>> > -           dev->coherent_dma_mask = DMA_BIT_MASK(32);
>> > -   }
>> > +   err = dma_coerce_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
>> > +   if (err)
>> > +           return err;
>>
>> I have at least one question.
>>
>> In case of new code you always assign dev->dma_mask.
>>
>> static inline int dma_coerce_mask_and_coherent(struct device *dev, u64
>> mask)
>> {
>>        dev->dma_mask = &dev->coherent_dma_mask;
>>        return dma_set_mask_and_coherent(dev, mask);
>> }
>>
>> So, the question is how keep the initialized dma_mask (and should we do
>> so by your opinion)?
>
> Well, the way the DMA mask stuff is supposed to operate is:
>
> - The device creator initializes the DMA mask to some default value.
> - The driver then uses dma_set_mask() / dma_set_coherent_mask() /
>   dma_set_mask_and_coherent() to adjust the mask according to the
>   capabilities of the device, *even* if the mask is the same as the
>   default.
>
> This is specified in the various DMA API documents.
>
> So, in PCI land, it works like this:
> - When a PCI device is created, it has its mask set to 32-bit.
> - When a driver comes along
>   - if the device is capable of 64-bit addressing, it tries to set a
>     64-bit mask.  If this fails, it tries to set a 32-bit mask and
>     turns off 64-bit DMA.
>   - if a device is not capable of 32-bit addressing but of a smaller
>     space (there are some PCI devices which can only do 31-bit) then
>     it tries to set that mask.
>   If the driver can't successfully set a mask, it should fail to
>   initialise.
>

Thanks for explanation.

> This is where we should be headed with all drivers, and I would welcome
> a patch for this driver to make it conform wrt the DMA API and DMA masks
> in place of this patch.

I see.

> Think of the coerse stuff as a middle-step to bring these types of issues
> up to the fore.

I will check your patches on next week, though I think it will neglect
dma_mask set by PCI part of the code in PCI case of the driver.

Well, there are a lot of drivers that are designed like:
- core part as library *or* separate driver
- platform driver
- pci driver
- acpi driver
- ... whatever bus driver for this device

Core part doesn't know what the upper layer (bus layer) sets, and
approaches to set that may differ from bus to bus (e.g. PCI vs. ACPI
).
So, ACPI could set the proper values from its own guts and in core
driver we have to respect those values.

Tioday is Friday, and I'm too lazy now to think a bit how this could
be solved in case of your helper involved.

-- 
With Best Regards,
Andy Shevchenko
