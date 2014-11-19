Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbaKSL3c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 06:29:32 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:33203 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753595AbaKSL3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 06:29:31 -0500
Date: Wed, 19 Nov 2014 11:29:10 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ding Tianhong <dingtianhong@huawei.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: For the problem when using swiotlb
Message-ID: <20141119112910.GD7156@e104818-lin.cambridge.arm.com>
References: <5469E26B.2010905@huawei.com>
 <20141117180947.GI29595@e104818-lin.cambridge.arm.com>
 <546C0BBB.9070000@huawei.com>
 <1535751.CcvIi3DN4F@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1535751.CcvIi3DN4F@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 08:45:43AM +0000, Arnd Bergmann wrote:
> On Wednesday 19 November 2014 11:17:15 Ding Tianhong wrote:
> > On 2014/11/18 2:09, Catalin Marinas wrote:
> > > On Mon, Nov 17, 2014 at 12:18:42PM +0000, Arnd Bergmann wrote:
> > >> On Monday 17 November 2014 19:56:27 Ding Tianhong wrote:
> > >>>         The commit 3690951fc6d42f3a0903987677d0e592c49dd8db(arm64: Use swiotlb late initialisation)
> > >>> switches the DMA mapping code to swiotlb_tlb_late_init_with_default_size(), this will occur a problem
> > >>> when I run the scsi stress tests, the message as below:
> > >>>
> > >>>         sas_controller b1000000.sas: swiotlb buffer is full (sz: 65536 bytes)..
> > >>>         DMA: Out of SW-IOMMU space for 65536 bytes at device b1000000.sas
> > >>>
> > >>> The reason is that the swiotlb_tlb_late_init_with_default_size() could only alloc 16M memory for DMA-mapping,
> > >>> and the param in cmdline "swiotlb=xxx" is useless because the get_free_pages() only use the buddy to assigned a
> > >>> maximum memory of 16M(The MAX_ORDER is 13 for 4k pages), obviously 16M is too small in many scenes, but
> > >>> the swiotlb_init() which could reserved a bigger memory as wished could work well for most drivers.
> > >>>
> > >>> I could not get a better way to fix this problem except to revert this patch, so could you please give me some
> > >>> advise and help me, thanks very much.
> > >>
> > >> In general, you should not need to use swiotlb for most devices, in
> > >> particular for high-performance devices like network or block.
> > >>
> > >> Please make sure that you have set up the dma-ranges properties in
> > >> your DT properly to allow 64-bit DMA if the device supports it.
> > > 
> > > That's the problem indeed, the DMA API ends up using swiotlb bounce
> > > buffers because the physical address of the pages passed to (or
> > > allocated by) the driver are beyond 32-bit limit (which is the default
> > > dma mask).
> > > 
> > 
> > Thanks everyone, I think I found the way to fix it, need to enable DMA_CMA, to reserve a big memory
> > for CMA and set coherent mask for dev, then dma_alloc and dma_mapping will not use the swiotlb until
> > the memory out of mask or swiotlb_force is enabled.
> > 
> > If I still understand uncorrectly, please inform me.
> 
> Please do not use CMA to work around the problem, but fix the underlying bug
> instead.

Agree.

> The driver should call 'dma_set_mask_and_coherent()' with the appropriate
> dma mask, and check whether that succeeded. However, the code implementing
> dma_set_mask_and_coherent on arm64 also needs to be changed to look up
> the dma-ranges property (see of_dma_configure()), and check if the mask
> is possible.

dma_set_mask_and_coherent() is a generic function. I think the
of_dma_configure() should start with a coherent_dma_mask based on
dma-ranges if given rather than defaulting to DMA_BIT_MASK(32). The
comment in of_dma_configure() says that devices should set up the
supported mask but it's not always up to them but the bus they are
connected to.

Something like below, untested:

diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 3b64d0bf5bba..dff34883db45 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -200,6 +200,10 @@ static void of_dma_configure(struct device *dev)
 	/* DMA ranges found. Calculate and set dma_pfn_offset */
 	dev->dma_pfn_offset = PFN_DOWN(paddr - dma_addr);
 	dev_dbg(dev, "dma_pfn_offset(%#08lx)\n", dev->dma_pfn_offset);
+
+	/* Set the coherent_dma_mask based on the dma-ranges property */
+	if (size)
+		dev->coherent_dma_mask = DMA_BIT_MASK(ilog2(size));
 }
 
 /**
