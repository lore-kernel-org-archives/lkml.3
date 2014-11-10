Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751731AbaKJS1M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 13:27:12 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:55724 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbaKJS1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 13:27:10 -0500
Date: Mon, 10 Nov 2014 18:27:00 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        "david.vrabel@citrix.com" <david.vrabel@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v8 08/13] xen/arm: use hypercall to flush caches in
 map_page
Message-ID: <20141110182659.GE25609@e104818-lin.cambridge.arm.com>
References: <alpine.DEB.2.02.1411101607130.22875@kaball.uk.xensource.com>
 <1415636045-24669-8-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415636045-24669-8-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 04:14:00PM +0000, Stefano Stabellini wrote:
> In xen_dma_map_page, if the page is a local page, call the native
> map_page dma_ops. If the page is foreign, call __xen_dma_map_page that
> issues any required cache maintenane operations via hypercall.
> 
> The reason for doing this is that the native dma_ops map_page could
> allocate buffers than need to be freed. If the page is foreign we don't
> call the native unmap_page dma_ops function, resulting in a memory leak.
> 
> Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  arch/arm/include/asm/xen/page-coherent.h |    9 ++++++++-
>  arch/arm/xen/mm32.c                      |   12 ++++++++++++
>  2 files changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/include/asm/xen/page-coherent.h b/arch/arm/include/asm/xen/page-coherent.h
> index 25d450c..36b79a8 100644
> --- a/arch/arm/include/asm/xen/page-coherent.h
> +++ b/arch/arm/include/asm/xen/page-coherent.h
> @@ -5,6 +5,9 @@
>  #include <linux/dma-attrs.h>
>  #include <linux/dma-mapping.h>
>  
> +void __xen_dma_map_page(struct device *hwdev, struct page *page,
> +	     dma_addr_t dev_addr, unsigned long offset, size_t size,
> +	     enum dma_data_direction dir, struct dma_attrs *attrs);
>  void __xen_dma_unmap_page(struct device *hwdev, dma_addr_t handle,
>  		size_t size, enum dma_data_direction dir,
>  		struct dma_attrs *attrs);
> @@ -32,7 +35,11 @@ static inline void xen_dma_map_page(struct device *hwdev, struct page *page,
>  	     dma_addr_t dev_addr, unsigned long offset, size_t size,
>  	     enum dma_data_direction dir, struct dma_attrs *attrs)
>  {
> -	__generic_dma_ops(hwdev)->map_page(hwdev, page, offset, size, dir, attrs);
> +	if (PFN_DOWN(dev_addr) == page_to_pfn(page)) {

Nitpick: you could write:

	bool foreign = PFN_DOWN(dev_addr) == page_to_pfn(page);

or even a static inline xen_foreign_page(page, dev_addr) function for
clarity. This code lacks comments.

> +		if (__generic_dma_ops(hwdev)->map_page)

I'm not sure we need to check map_page() here. I thought it's always
present as host DMA API does not check for it.

-- 
Catalin
