Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501AbaLVXIK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 18:08:10 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:54545 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108AbaLVXII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 18:08:08 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: bhelgaas@google.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, grant.likely@linaro.org,
        robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, will.deacon@arm.com
Subject: Re: [RFC v1 PATCH 1/2] of/pci: add of_pci_dma_configure() update dma configuration
Date: Tue, 23 Dec 2014 00:07:57 +0100
Message-ID: <5090769.jqAkiDgYu7@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1723662.JYr5muIJha@wuerfel>
References: <1418940425-2017-1-git-send-email-m-karicheri2@ti.com> <54989DDE.3060409@ti.com> <1723662.JYr5muIJha@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:7D7GEdZGIlbBVAEBmMVQxto4gxBvNEuJ5k0/csNgtE8vg7jsFP/
 /KUyUBHl2NrZBKiSGAFGUcrEKa7jwe0iXqOdeDDUofF/WTCBm38Y7C3nHzyLn2rq9Y11ASf
 nO4HVzgCRqp8nf/NcFdS1SlJ4uDRK/cr7CBEiuNDwg1CZL3t9eE0z8itx/irgsmnAki7NAB
 NzRBPBq30CDeFehCJ1IXQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 December 2014 23:44:52 Arnd Bergmann wrote:
> On Monday 22 December 2014 17:40:30 Murali Karicheri wrote:
> > On 12/22/2014 05:24 PM, Arnd Bergmann wrote:
> > > On Monday 22 December 2014 16:40:43 Murali Karicheri wrote:
> > >>>> +++ b/arch/arm/mm/dma-mapping.c
> > >>>> @@ -2052,9 +2052,10 @@ void arch_setup_dma_ops(struct device *dev, u64
> > >>>> dma_base, u64 size,
> > >>>>                            struct iommu_ops *iommu, bool coherent)
> > >>>>     {
> > >>>>            struct dma_map_ops *dma_ops;
> > >>>> +       u64 temp_size = min((*(dev->dma_mask) + 1), size);
> > >>>>
> > >>>>            dev->archdata.dma_coherent = coherent;
> > >>>> -       if (arm_setup_iommu_dma_ops(dev, dma_base, size, iommu))
> > >>>> +       if (arm_setup_iommu_dma_ops(dev, dma_base, temp_size, iommu))
> > >>>>
> > >>>> If you agree, I will post v1 of the patch with these updates. Let me
> > >>>> know. I did some basic tests on Keystone with these changes and it works
> > >>>> fine.
> > >>>
> > >>> It's not exactly what I meant. My main point was that we need to limit
> > >>> dev->dma_mask to (size-1) here, but you are not touching that.
> > >>
> > >> if you mean overriding the dev->dma_mask to min((*dev->dma_mask),
> > >> size-1), then I am getting the error "Coherent DMA mask 0x7fffffff (pfn
> > >> 0x780000-0x800000) covers a smaller range of system memory than the DMA
> > >> zone pfn 0x0-0x880000) when the devices on Keystone tries to set the dma
> > >> mask. Something wrong and I need to look into the code.
> > >
> > > Right, it sounds like the offset was applied incorrectly at some point.
> > >
> > > What are the DMA zone size and the phys-offset?
> > 2G and 0x8_0000_0000. This limit the usable DMA size to 2G on Keystone, 
> > I believe you shouldn't be limiting the dma mask to size-1 in this case, 
> > right? The DT setup the dma-range to have a size of 2G (0x80000000).
> 
> No, the problem is something else: the pfn range that we calculate for the
> coherent DMA mask should have been 0x800000-0x880000, not 0x780000-0x800000,
> so we would exactly match the ZONE_DMA.

I gave it some more thought, and concluded that the size that gets passed
down is not really the right value to be compared to a mask if the dma-capable
area starts at a nonzero bus address.

In your case, bus addresses 0x80000000-0xffffffff are valid for DMA, so
the mask must be 0xffffffff to forbid any DMA to addresses larger than
0x100000000, not 0x7fffffff which would not be enough to cover any RAM.

I guess the dma_mask should be 'min((*dev->dma_mask), dma_base + size - 1)'
here.

	Arnd
