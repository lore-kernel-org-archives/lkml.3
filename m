Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112AbbAOLEe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 06:04:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47251 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbbAOLEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 06:04:33 -0500
Date: Thu, 15 Jan 2015 11:04:53 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>, xen-devel@lists.xensource.com,
        catalin.marinas@arm.com, Ian Campbell <ian.campbell@citrix.com>
Subject: Re: backport a4dba130891271084344c12537731542ec77cb85 to 3.16+
Message-ID: <20150115110453.GB5176@charon>
References: <alpine.DEB.2.02.1501121704380.3058@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.DEB.2.02.1501121704380.3058@kaball.uk.xensource.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 06:09:33PM +0000, Stefano Stabellini wrote:
> Hi all,
> I would like to request a backport of the following commit:
> 
> 
> commit a4dba130891271084344c12537731542ec77cb85
> Author: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> Date:   Fri Nov 21 11:07:39 2014 +0000
> 
>     xen/arm/arm64: introduce xen_arch_need_swiotlb
> 
> 
> to stable trees from 3.16 onward (3.16 included).
> 
> 
> The commit needs to be slightly modified because is_device_dma_coherent
> is not available on kernels < 3.19, so I just removed the call,
> thus assuming that the device is not coherent on arm (slower but safe):
> 
>  diff --git a/arch/arm/xen/mm.c b/arch/arm/xen/mm.c
> -index ab700e1..28ebf3e 100644
> +index b0e77de..f8a576b 100644
>  --- a/arch/arm/xen/mm.c
>  +++ b/arch/arm/xen/mm.c
> -@@ -100,6 +100,13 @@ void __xen_dma_sync_single_for_device(struct device *hwdev,
> - 	__xen_dma_page_cpu_to_dev(hwdev, handle, size, dir);
> - }
> +@@ -16,6 +16,13 @@
> + #include <asm/xen/hypercall.h>
> + #include <asm/xen/interface.h>
>   
>  +bool xen_arch_need_swiotlb(struct device *dev,
>  +			   unsigned long pfn,
>  +			   unsigned long mfn)
>  +{
> -+	return ((pfn != mfn) && !is_device_dma_coherent(dev));
> ++	return (pfn != mfn);
>  +}
>  +
>   int xen_create_contiguous_region(phys_addr_t pstart, unsigned int order,
> 
> 
> The modified patch follows.
> 
>

Thank you Stefano, I will queue this for the next 3.16 kernel.

Cheers,
--
Luís

> ---
> 
> xen/arm/arm64: introduce xen_arch_need_swiotlb
> 
> From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> 
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
> Reviewed-by: David Vrabel <david.vrabel@citrix.com>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> Acked-by: Ian Campbell <ian.campbell@citrix.com>
> Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
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
> index b0e77de..f8a576b 100644
> --- a/arch/arm/xen/mm.c
> +++ b/arch/arm/xen/mm.c
> @@ -16,6 +16,13 @@
>  #include <asm/xen/hypercall.h>
>  #include <asm/xen/interface.h>
>  
> +bool xen_arch_need_swiotlb(struct device *dev,
> +			   unsigned long pfn,
> +			   unsigned long mfn)
> +{
> +	return (pfn != mfn);
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
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
