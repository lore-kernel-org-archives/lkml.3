Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482AbaKCKyi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 05:54:38 -0500
Received: from smtp.citrix.com ([66.165.176.89]:29735 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752420AbaKCKya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 05:54:30 -0500
X-IronPort-AV: E=Sophos;i="5.07,307,1413244800"; 
   d="scan'208";a="187465308"
Date: Mon, 3 Nov 2014 10:45:14 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: <xen-devel@lists.xensource.com>, <konrad.wilk@oracle.com>,
        <Ian.Campbell@citrix.com>, <david.vrabel@citrix.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7 7/8] xen/arm/arm64: introduce xen_arch_need_swiotlb
In-Reply-To: <1414422568-19103-7-git-send-email-stefano.stabellini@eu.citrix.com>
Message-ID: <alpine.DEB.2.02.1411031044480.22875@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1410261621200.22875@kaball.uk.xensource.com> <1414422568-19103-7-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Oct 2014, Stefano Stabellini wrote:
> Introduce an arch specific function to find out whether a particular dma
> mapping operation needs to bounce on the swiotlb buffer.
> 
> On ARM and ARM64, if the page involved is a foreign page and the device
> is not coherent, we need to bounce because at unmap time we cannot
> execute any required cache maintenance operations (we don't know how to
> find the pfn from the mfn).
> 
> No change of behaviour for x86.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> Acked-by: Ian Campbell <ian.campbell@citrix.com>

Konrad, David, are you OK with the swiotlb-xen changes?


 
> Changes in v6:
> - fix ts.
> 
> Changes in v5:
> - fix indentation.
> ---
>  arch/arm/include/asm/xen/page.h |    4 ++++
>  arch/arm/xen/mm.c               |    7 +++++++
>  arch/x86/include/asm/xen/page.h |    7 +++++++
>  drivers/xen/swiotlb-xen.c       |    5 ++++-
>  4 files changed, 22 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/include/asm/xen/page.h b/arch/arm/include/asm/xen/page.h
> index 135c24a..68c739b 100644
> --- a/arch/arm/include/asm/xen/page.h
> +++ b/arch/arm/include/asm/xen/page.h
> @@ -107,4 +107,8 @@ static inline bool set_phys_to_machine(unsigned long pfn, unsigned long mfn)
>  #define xen_remap(cookie, size) ioremap_cache((cookie), (size))
>  #define xen_unmap(cookie) iounmap((cookie))
>  
> +bool xen_arch_need_swiotlb(struct device *dev,
> +			   unsigned long pfn,
> +			   unsigned long mfn);
> +
>  #endif /* _ASM_ARM_XEN_PAGE_H */
> diff --git a/arch/arm/xen/mm.c b/arch/arm/xen/mm.c
> index ff413a8..28396aa 100644
> --- a/arch/arm/xen/mm.c
> +++ b/arch/arm/xen/mm.c
> @@ -139,6 +139,13 @@ void xen_dma_sync_single_for_device(struct device *hwdev,
>  	__xen_dma_page_cpu_to_dev(hwdev, handle, size, dir);
>  }
>  
> +bool xen_arch_need_swiotlb(struct device *dev,
> +			   unsigned long pfn,
> +			   unsigned long mfn)
> +{
> +	return ((pfn != mfn) && !is_device_dma_coherent(dev));
> +}
> +
>  int xen_create_contiguous_region(phys_addr_t pstart, unsigned int order,
>  				 unsigned int address_bits,
>  				 dma_addr_t *dma_handle)
> diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/page.h
> index c949923..f58ef6c 100644
> --- a/arch/x86/include/asm/xen/page.h
> +++ b/arch/x86/include/asm/xen/page.h
> @@ -236,4 +236,11 @@ void make_lowmem_page_readwrite(void *vaddr);
>  #define xen_remap(cookie, size) ioremap((cookie), (size));
>  #define xen_unmap(cookie) iounmap((cookie))
>  
> +static inline bool xen_arch_need_swiotlb(struct device *dev,
> +					 unsigned long pfn,
> +					 unsigned long mfn)
> +{
> +	return false;
> +}
> +
>  #endif /* _ASM_X86_XEN_PAGE_H */
> diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
> index ebd8f21..ac5d41b 100644
> --- a/drivers/xen/swiotlb-xen.c
> +++ b/drivers/xen/swiotlb-xen.c
> @@ -399,7 +399,9 @@ dma_addr_t xen_swiotlb_map_page(struct device *dev, struct page *page,
>  	 * buffering it.
>  	 */
>  	if (dma_capable(dev, dev_addr, size) &&
> -	    !range_straddles_page_boundary(phys, size) && !swiotlb_force) {
> +	    !range_straddles_page_boundary(phys, size) &&
> +		!xen_arch_need_swiotlb(dev, PFN_DOWN(phys), PFN_DOWN(dev_addr)) &&
> +		!swiotlb_force) {
>  		/* we are not interested in the dma_addr returned by
>  		 * xen_dma_map_page, only in the potential cache flushes executed
>  		 * by the function. */
> @@ -557,6 +559,7 @@ xen_swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
>  		dma_addr_t dev_addr = xen_phys_to_bus(paddr);
>  
>  		if (swiotlb_force ||
> +		    xen_arch_need_swiotlb(hwdev, PFN_DOWN(paddr), PFN_DOWN(dev_addr)) ||
>  		    !dma_capable(hwdev, dev_addr, sg->length) ||
>  		    range_straddles_page_boundary(paddr, sg->length)) {
>  			phys_addr_t map = swiotlb_tbl_map_single(hwdev,
> -- 
> 1.7.10.4
> 
