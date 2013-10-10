Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264Ab3JJJnq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 05:43:46 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:52846 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752132Ab3JJJnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 05:43:45 -0400
Date: Thu, 10 Oct 2013 10:43:08 +0100
From: Will Deacon <will.deacon@arm.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
Subject: Re: [PATCH v8 01/17] arm: make SWIOTLB available
Message-ID: <20131010094307.GD3817@mudshark.cambridge.arm.com>
References: <alpine.DEB.2.02.1310092109190.26077@kaball.uk.xensource.com>
 <1381351710-1876-1-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381351710-1876-1-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 09, 2013 at 09:48:14PM +0100, Stefano Stabellini wrote:
> IOMMU_HELPER is needed because SWIOTLB calls iommu_is_span_boundary,
> provided by lib/iommu_helper.c.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> CC: will.deacon@arm.com
> CC: linux@arm.linux.org.uk

[...]

> diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dma-mapping.h
> index 5b579b9..9aa5384 100644
> --- a/arch/arm/include/asm/dma-mapping.h
> +++ b/arch/arm/include/asm/dma-mapping.h
> @@ -10,6 +10,7 @@
>  
>  #include <asm-generic/dma-coherent.h>
>  #include <asm/memory.h>
> +#include <asm/cacheflush.h>
>  
>  #define DMA_ERROR_CODE	(~0)
>  extern struct dma_map_ops arm_dma_ops;
> @@ -86,6 +87,42 @@ static inline dma_addr_t virt_to_dma(struct device *dev, void *addr)
>  }
>  #endif
>  
> +static inline dma_addr_t phys_to_dma(struct device *dev, phys_addr_t paddr)
> +{
> +	unsigned int offset = paddr & ~PAGE_MASK;
> +	return pfn_to_dma(dev, paddr >> PAGE_SHIFT) + offset;

__phys_to_pfn instead of the explicit shift?

> +}
> +
> +static inline phys_addr_t dma_to_phys(struct device *dev, dma_addr_t dev_addr)
> +{
> +	unsigned int offset = dev_addr & ~PAGE_MASK;
> +	return (dma_to_pfn(dev, dev_addr) << PAGE_SHIFT) + offset;i

then __pfn_to_phys here.

> +}
> +
> +static inline bool dma_capable(struct device *dev, dma_addr_t addr, size_t size)
> +{
> +	u64 limit, mask;
> +	
> +	if (dev->dma_mask)
> +		mask = *dev->dma_mask;
> +	else 
> +		mask = dev->coherent_dma_mask;
> +
> +	if (mask == 0)
> +		return 0;
> +
> +	limit = (mask + 1) & ~mask;

This looks like homebrew alignment to me. Can you use __ALIGN_KERNEL_MASK or
one of thoese guys from kernel.h?

Will
