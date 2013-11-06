Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932293Ab3KFLIw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 06:08:52 -0500
Received: from smtp.citrix.com ([66.165.176.89]:64051 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932209Ab3KFLIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 06:08:50 -0500
X-IronPort-AV: E=Sophos;i="4.93,646,1378857600"; 
   d="scan'208";a="71097099"
Date: Wed, 6 Nov 2013 11:07:32 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Xen Devel <Xen-devel@lists.xensource.com>,
        <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Russell King <rmk@arm.linux.org.uk>
Subject: Re: linux-next: manual merge of the xen-tip tree with the arm tree
In-Reply-To: <20131106181740.c5e7e966a750909290ba1f94@canb.auug.org.au>
Message-ID: <alpine.DEB.2.02.1311061107130.26077@kaball.uk.xensource.com>
References: <20131106181740.c5e7e966a750909290ba1f94@canb.auug.org.au>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Nov 2013, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the xen-tip tree got a conflict in
> arch/arm/include/asm/dma-mapping.h between commit 6a6a5c15d871 ("ARM:
> 7805/1: mm: change max*pfn to include the physical offset of memory")
> from the arm tree and commit e24b7aa368a0 ("arm: make SWIOTLB available")
> from the xen-tip tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

It is good, thanks!


> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc arch/arm/include/asm/dma-mapping.h
> index 863cd84eb1a2,8acfef48124a..000000000000
> --- a/arch/arm/include/asm/dma-mapping.h
> +++ b/arch/arm/include/asm/dma-mapping.h
> @@@ -87,13 -97,39 +98,46 @@@ static inline dma_addr_t virt_to_dma(st
>   }
>   #endif
>   
> + static inline dma_addr_t phys_to_dma(struct device *dev, phys_addr_t paddr)
> + {
> + 	unsigned int offset = paddr & ~PAGE_MASK;
> + 	return pfn_to_dma(dev, __phys_to_pfn(paddr)) + offset;
> + }
> + 
> + static inline phys_addr_t dma_to_phys(struct device *dev, dma_addr_t dev_addr)
> + {
> + 	unsigned int offset = dev_addr & ~PAGE_MASK;
> + 	return __pfn_to_phys(dma_to_pfn(dev, dev_addr)) + offset;
> + }
> + 
> + static inline bool dma_capable(struct device *dev, dma_addr_t addr, size_t size)
> + {
> + 	u64 limit, mask;
> + 
> + 	if (!dev->dma_mask)
> + 		return 0;
> + 
> + 	mask = *dev->dma_mask;
> + 
> + 	limit = (mask + 1) & ~mask;
> + 	if (limit && size > limit)
> + 		return 0;
> + 
> + 	if ((addr | (addr + size - 1)) & ~mask)
> + 		return 0;
> + 
> + 	return 1;
> + }
> + 
> + static inline void dma_mark_clean(void *addr, size_t size) { }
> + 
>  +/* The ARM override for dma_max_pfn() */
>  +static inline unsigned long dma_max_pfn(struct device *dev)
>  +{
>  +	return PHYS_PFN_OFFSET + dma_to_pfn(dev, *dev->dma_mask);
>  +}
>  +#define dma_max_pfn(dev) dma_max_pfn(dev)
>  +
>   /*
>    * DMA errors are defined by all-bits-set in the DMA address.
>    */
> 
