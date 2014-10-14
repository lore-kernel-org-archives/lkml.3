Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932514AbaJNQE1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 12:04:27 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:31867 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932239AbaJNQE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 12:04:26 -0400
Date: Tue, 14 Oct 2014 12:03:52 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: xen-devel@lists.xensource.com, Ian.Campbell@citrix.com,
        david.vrabel@citrix.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 6/7] xen/arm/arm64: introduce xen_arch_need_swiotlb
Message-ID: <20141014160352.GF30965@laptop.dumpdata.com>
References: <alpine.DEB.2.02.1410101244090.17038@kaball.uk.xensource.com>
 <1412941908-5850-6-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412941908-5850-6-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2014 at 12:51:47PM +0100, Stefano Stabellini wrote:
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
> ---
>  arch/arm/include/asm/xen/page.h |    4 ++++
>  arch/arm/xen/mm.c               |    7 +++++++
>  arch/x86/include/asm/xen/page.h |    7 +++++++
>  drivers/xen/swiotlb-xen.c       |    5 ++++-
>  4 files changed, 22 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/include/asm/xen/page.h b/arch/arm/include/asm/xen/page.h
> index 135c24a..fb7839d 100644
> --- a/arch/arm/include/asm/xen/page.h
> +++ b/arch/arm/include/asm/xen/page.h
> @@ -107,4 +107,8 @@ static inline bool set_phys_to_machine(unsigned long pfn, unsigned long mfn)
>  #define xen_remap(cookie, size) ioremap_cache((cookie), (size))
>  #define xen_unmap(cookie) iounmap((cookie))
>  
> +bool xen_arch_need_swiotlb(struct device *dev,
> +						   unsigned long pfn,
> +						   unsigned long mfn);
> +
>  #endif /* _ASM_ARM_XEN_PAGE_H */
> diff --git a/arch/arm/xen/mm.c b/arch/arm/xen/mm.c
> index 9d460e0..0c2a75a 100644
> --- a/arch/arm/xen/mm.c
> +++ b/arch/arm/xen/mm.c
> @@ -139,6 +139,13 @@ void xen_dma_sync_single_for_device(struct device *hwdev,
>  	__xen_dma_page_cpu_to_dev(hwdev, handle, size, dir);
>  }
>  
> +bool xen_arch_need_swiotlb(struct device *dev,
> +						   unsigned long pfn,
> +						   unsigned long mfn)
> +{
> +	return ((pfn != mfn) && !is_dma_coherent(dev));
> +}
> +
>  int xen_create_contiguous_region(phys_addr_t pstart, unsigned int order,
>  				 unsigned int address_bits,
>  				 dma_addr_t *dma_handle)
> diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/page.h
> index c949923..0a45242 100644
> --- a/arch/x86/include/asm/xen/page.h
> +++ b/arch/x86/include/asm/xen/page.h
> @@ -236,4 +236,11 @@ void make_lowmem_page_readwrite(void *vaddr);
>  #define xen_remap(cookie, size) ioremap((cookie), (size));
>  #define xen_unmap(cookie) iounmap((cookie))
>  
> +static inline bool xen_arch_need_swiotlb(struct device *dev,
> +		                                 unsigned long pfn,
> +										 unsigned long mfn)

Something funny happend here.
> +{
> +	return false;
> +}

Why not make this an macro?

The xen_unmap and xen_remap are that.
> +
>  #endif /* _ASM_X86_XEN_PAGE_H */
> diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
> index ebd8f21..ac0bd60 100644
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
> +			xen_arch_need_swiotlb(hwdev, PFN_DOWN(paddr), PFN_DOWN(dev_addr)) ||
>  		    !dma_capable(hwdev, dev_addr, sg->length) ||
>  		    range_straddles_page_boundary(paddr, sg->length)) {
>  			phys_addr_t map = swiotlb_tbl_map_single(hwdev,
> -- 
> 1.7.10.4
> 
