Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761868AbbA2C2G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:28:06 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:45673 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906AbbA2BsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:48:03 -0500
Date: Wed, 28 Jan 2015 17:30:48 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Robin Murphy <Robin.Murphy@arm.com>
Cc: Murali Karicheri <m-karicheri2@ti.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Rob Herring <robh+dt@kernel.org>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 3/6] of: fix size when dma-range is not used
Message-ID: <20150128173048.GE31752@e104818-lin.cambridge.arm.com>
References: <1422052359-12384-1-git-send-email-m-karicheri2@ti.com>
 <1422052359-12384-4-git-send-email-m-karicheri2@ti.com>
 <54C77616.80301@arm.com>
 <54C7DF13.20402@ti.com>
 <20150128110523.GC6646@e104818-lin.cambridge.arm.com>
 <54C9068D.8050701@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C9068D.8050701@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 03:55:57PM +0000, Robin Murphy wrote:
> On 28/01/15 11:05, Catalin Marinas wrote:
> > On Tue, Jan 27, 2015 at 06:55:15PM +0000, Murali Karicheri wrote:
> >> How about having the logic like this?
> >>
> >> 	ret = of_dma_get_range(np, &dma_addr, &paddr, &size);
> >> 	if (ret < 0) {
> >> 		dma_addr = offset = 0;
> >> 		size = dev->coherent_dma_mask + 1;
> >> 	} else {
> >> 		offset = PFN_DOWN(paddr - dma_addr);
> >> 		dev_dbg(dev, "dma_pfn_offset(%#08lx)\n", offset);
> >> 	}
> >>
> >> 	if (is_power_of_2(size + 1))
> >> 		size = size + 1;
> >> 	else if (!is_power_of_2(size))
> >> 	{
> >> 		dev_err(dev, "invalid size\n");
> >> 		return;
> >> 	}
> >
> > In of_dma_configure(), we currently assume that the default coherent
> > mask is 32-bit. In this thread:
> >
> > http://article.gmane.org/gmane.linux.kernel/1835096
> >
> > we talked about setting the coherent mask based on size automatically.
> > I'm not sure about the size but I think we can assume is 32-bit mask + 1
> > if it is not specified in the DT. Instead of just assuming a default
> > mask, let's assume a default size and create the mask based on this
> > (untested):
> >
> > diff --git a/drivers/of/platform.c b/drivers/of/platform.c
> > index 5b33c6a21807..9ff8d1286b44 100644
> > --- a/drivers/of/platform.c
> > +++ b/drivers/of/platform.c
> > @@ -170,10 +170,10 @@ static void of_dma_configure(struct device *dev)
> >   	struct iommu_ops *iommu;
> >
> >   	/*
> > -	 * Set default dma-mask to 32 bit. Drivers are expected to setup
> > -	 * the correct supported dma_mask.
> > +	 * Set default size to cover the 32-bit. Drivers are expected to setup
> > +	 * the correct size and dma_mask.
> >   	 */
> > -	dev->coherent_dma_mask = DMA_BIT_MASK(32);
> > +	size = 1ULL << 32;
> >
> >   	/*
> >   	 * Set it to coherent_dma_mask by default if the architecture
> > @@ -185,13 +185,24 @@ static void of_dma_configure(struct device *dev)
> >   	ret = of_dma_get_range(dev->of_node, &dma_addr, &paddr, &size);
> >   	if (ret < 0) {
> >   		dma_addr = offset = 0;
> > -		size = dev->coherent_dma_mask;
> >   	} else {
> >   		offset = PFN_DOWN(paddr - dma_addr);
> >   		dev_dbg(dev, "dma_pfn_offset(%#08lx)\n", dev->dma_pfn_offset);
> >   	}
> >   	dev->dma_pfn_offset = offset;
> >
> > +	/*
> > +	 * Workaround for DTs setting the size to a mask or 0.
> > +	 */
> > +	if (is_power_of_2(size + 1))
> > +		size += 1;
> 
> In fact, since the ilog2 below ends up effectively rounding down, we 
> might as well do away with this check as well and just add 1 
> unconditionally. The only time it makes any difference is when we want 
> it to anyway!

Well, we could simply ignore the is_power_of_2() check but without
incrementing size as we don't know what arch_setup_dma_ops() does with
it.

I think we can remove this check altogether (we leaved without it for a
while) but we need to add 1 when calculating the mask:

	dev->coherent_dma_mask = min(DMA_BIT_MASK(32),
				     DMA_BIT_MASK(ilog2(size + 1)));

-- 
Catalin
