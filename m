Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965108Ab3HIPa6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 11:30:58 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:19684 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964779Ab3HIPa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 11:30:57 -0400
Date: Fri, 9 Aug 2013 11:29:56 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Ian.Campbell@citrix.com,
        will.deacon@arm.com, linux@arm.linux.org.uk
Subject: Re: [PATCH v3 03/10] arm: make SWIOTLB available
Message-ID: <20130809152956.GC5637@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1308051503190.4893@kaball.uk.xensource.com>
 <1375720256-8014-3-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375720256-8014-3-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 05:30:49PM +0100, Stefano Stabellini wrote:
> IOMMU_HELPER is needed because SWIOTLB calls iommu_is_span_boundary,
> provided by lib/iommu_helper.c.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

And Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Thanks.
> CC: will.deacon@arm.com
> CC: linux@arm.linux.org.uk
> 
> 
> Changes in v3:
> - dma_capable: do not treat dma_mask as a limit;
> - remove SWIOTLB dependency on NEED_SG_DMA_LENGTH.
> ---
>  arch/arm/Kconfig                   |    6 ++++++
>  arch/arm/include/asm/dma-mapping.h |   30 ++++++++++++++++++++++++++++++
>  2 files changed, 36 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index ba412e0..c0bfb33 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -1832,6 +1832,12 @@ config CC_STACKPROTECTOR
>  	  neutralized via a kernel panic.
>  	  This feature requires gcc version 4.2 or above.
>  
> +config SWIOTLB
> +	def_bool y
> +
> +config IOMMU_HELPER
> +	def_bool SWIOTLB
> +
>  config XEN_DOM0
>  	def_bool y
>  	depends on XEN
> diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dma-mapping.h
> index 5b579b9..5b8eef9 100644
> --- a/arch/arm/include/asm/dma-mapping.h
> +++ b/arch/arm/include/asm/dma-mapping.h
> @@ -86,6 +86,36 @@ static inline dma_addr_t virt_to_dma(struct device *dev, void *addr)
>  }
>  #endif
>  
> +static inline dma_addr_t phys_to_dma(struct device *dev, phys_addr_t paddr)
> +{
> +	unsigned int offset = paddr & ~PAGE_MASK;
> +	return pfn_to_dma(dev, paddr >> PAGE_SHIFT) + offset;
> +}
> +
> +static inline phys_addr_t dma_to_phys(struct device *dev, dma_addr_t dev_addr)
> +{
> +	unsigned int offset = dev_addr & ~PAGE_MASK;
> +	return (dma_to_pfn(dev, dev_addr) << PAGE_SHIFT) + offset;
> +}
> +
> +static inline bool dma_capable(struct device *dev, dma_addr_t addr, size_t size)
> +{
> +	u64 limit, mask = *dev->dma_mask;
> +
> +	limit = (mask + 1) & ~mask;
> +	if (limit && size > limit)
> +		return 0;
> +
> +	if ((addr | (addr + size - 1)) & ~mask)
> +		return 0;
> +
> +	return 1;
> +}
> +
> +static inline void dma_mark_clean(void *addr, size_t size)
> +{
> +}
> +
>  /*
>   * DMA errors are defined by all-bits-set in the DMA address.
>   */
> -- 
> 1.7.2.5
> 
