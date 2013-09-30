Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094Ab3I3PcS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 11:32:18 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:48276 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755876Ab3I3PcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 11:32:16 -0400
Date: Mon, 30 Sep 2013 11:31:43 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Ian.Campbell@citrix.com
Subject: Re: [PATCH v6 10/19] xen: introduce xen_alloc/free_coherent_pages
Message-ID: <20130930153143.GQ3106@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1309271653420.5498@kaball.uk.xensource.com>
 <1380298207-29151-10-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380298207-29151-10-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 05:09:58PM +0100, Stefano Stabellini wrote:
> xen_swiotlb_alloc_coherent needs to allocate a coherent buffer for cpu
> and devices. On native x86 and ARMv8 is sufficient to call
> __get_free_pages in order to get a coherent buffer, while on ARM we need
> to call the native dma_ops->alloc implementation.
> 
> When arm64 stops using the swiotlb by default and starts having multiple
> dma_ops implementations, we'll use __get_dma_ops there too.

I presume this is a future TODO, not some further patch (in which
case you should say in here the title of it). If it is a TODO could
you stick that in the sentence here somewhere to make it crytal clear that
it is not implemented.

Thank you.

> 
> Introduce xen_alloc_coherent_pages to abstract the arch specific buffer
> allocation.
> 
> Similarly introduce xen_free_coherent_pages to free a coherent buffer:
> on x86 and ARM64 is simply a call to free_pages while on ARM is
> arm_dma_ops.free.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> 
> 
> Changes in v6:
> - call __get_dma_ops to get the native dma_ops pointer on arm.
> ---
>  arch/arm/include/asm/xen/page-coherent.h   |   22 ++++++++++++++++++++++
>  arch/arm64/include/asm/xen/page-coherent.h |   24 ++++++++++++++++++++++++
>  arch/ia64/include/asm/xen/page-coherent.h  |   24 ++++++++++++++++++++++++
>  arch/x86/include/asm/xen/page-coherent.h   |   24 ++++++++++++++++++++++++
>  4 files changed, 94 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/include/asm/xen/page-coherent.h
>  create mode 100644 arch/arm64/include/asm/xen/page-coherent.h
>  create mode 100644 arch/ia64/include/asm/xen/page-coherent.h
>  create mode 100644 arch/x86/include/asm/xen/page-coherent.h
> 
> diff --git a/arch/arm/include/asm/xen/page-coherent.h b/arch/arm/include/asm/xen/page-coherent.h
> new file mode 100644
> index 0000000..92b7a8a
> --- /dev/null
> +++ b/arch/arm/include/asm/xen/page-coherent.h
> @@ -0,0 +1,22 @@
> +#ifndef _ASM_ARM_XEN_PAGE_COHERENT_H
> +#define _ASM_ARM_XEN_PAGE_COHERENT_H
> +
> +#include <asm/page.h>
> +#include <linux/dma-attrs.h>
> +#include <linux/dma-mapping.h>
> +
> +static inline void *xen_alloc_coherent_pages(struct device *hwdev, size_t size,
> +		dma_addr_t *dma_handle, gfp_t flags,
> +		struct dma_attrs *attrs)
> +{
> +	return __get_dma_ops(hwdev)->alloc(hwdev, size, dma_handle, flags, attrs);
> +}
> +
> +static inline void xen_free_coherent_pages(struct device *hwdev, size_t size,
> +		void *cpu_addr, dma_addr_t dma_handle,
> +		struct dma_attrs *attrs)
> +{
> +	__get_dma_ops(hwdev)->free(hwdev, size, cpu_addr, dma_handle, attrs);
> +}
> +
> +#endif /* _ASM_ARM_XEN_PAGE_COHERENT_H */
> diff --git a/arch/arm64/include/asm/xen/page-coherent.h b/arch/arm64/include/asm/xen/page-coherent.h
> new file mode 100644
> index 0000000..0d6ad25
> --- /dev/null
> +++ b/arch/arm64/include/asm/xen/page-coherent.h
> @@ -0,0 +1,24 @@
> +#ifndef _ASM_ARM64_XEN_PAGE_COHERENT_H
> +#define _ASM_ARM64_XEN_PAGE_COHERENT_H
> +
> +#include <asm/page.h>
> +#include <linux/dma-attrs.h>
> +#include <linux/dma-mapping.h>
> +
> +static inline void *xen_alloc_coherent_pages(struct device *hwdev, size_t size,
> +		dma_addr_t *dma_handle, gfp_t flags,
> +		struct dma_attrs *attrs)
> +{
> +	void *vstart = (void*)__get_free_pages(flags, get_order(size));
> +	*dma_handle = virt_to_phys(vstart);
> +	return vstart;
> +}
> +
> +static inline void xen_free_coherent_pages(struct device *hwdev, size_t size,
> +		void *cpu_addr, dma_addr_t dma_handle,
> +		struct dma_attrs *attrs)
> +{
> +	free_pages((unsigned long) cpu_addr, get_order(size));
> +}
> +
> +#endif /* _ASM_ARM64_XEN_PAGE_COHERENT_H */
> diff --git a/arch/ia64/include/asm/xen/page-coherent.h b/arch/ia64/include/asm/xen/page-coherent.h
> new file mode 100644
> index 0000000..37b929c
> --- /dev/null
> +++ b/arch/ia64/include/asm/xen/page-coherent.h
> @@ -0,0 +1,24 @@
> +#ifndef _ASM_IA64_XEN_PAGE_COHERENT_H
> +#define _ASM_IA64_XEN_PAGE_COHERENT_H
> +
> +#include <asm/page.h>
> +#include <linux/dma-attrs.h>
> +#include <linux/dma-mapping.h>
> +
> +static inline void *xen_alloc_coherent_pages(struct device *hwdev, size_t size,
> +		dma_addr_t *dma_handle, gfp_t flags,
> +		struct dma_attrs *attrs)
> +{
> +	void *vstart = (void*)__get_free_pages(flags, get_order(size));
> +	*dma_handle = virt_to_phys(vstart);
> +	return vstart;
> +}
> +
> +static inline void xen_free_coherent_pages(struct device *hwdev, size_t size,
> +		void *cpu_addr, dma_addr_t dma_handle,
> +		struct dma_attrs *attrs)
> +{
> +	free_pages((unsigned long) cpu_addr, get_order(size));
> +}
> +
> +#endif /* _ASM_IA64_XEN_PAGE_COHERENT_H */
> diff --git a/arch/x86/include/asm/xen/page-coherent.h b/arch/x86/include/asm/xen/page-coherent.h
> new file mode 100644
> index 0000000..31de2e0
> --- /dev/null
> +++ b/arch/x86/include/asm/xen/page-coherent.h
> @@ -0,0 +1,24 @@
> +#ifndef _ASM_X86_XEN_PAGE_COHERENT_H
> +#define _ASM_X86_XEN_PAGE_COHERENT_H
> +
> +#include <asm/page.h>
> +#include <linux/dma-attrs.h>
> +#include <linux/dma-mapping.h>
> +
> +static inline void *xen_alloc_coherent_pages(struct device *hwdev, size_t size,
> +		dma_addr_t *dma_handle, gfp_t flags,
> +		struct dma_attrs *attrs)
> +{
> +	void *vstart = (void*)__get_free_pages(flags, get_order(size));
> +	*dma_handle = virt_to_phys(vstart);
> +	return vstart;
> +}
> +
> +static inline void xen_free_coherent_pages(struct device *hwdev, size_t size,
> +		void *cpu_addr, dma_addr_t dma_handle,
> +		struct dma_attrs *attrs)
> +{
> +	free_pages((unsigned long) cpu_addr, get_order(size));
> +}
> +
> +#endif /* _ASM_X86_XEN_PAGE_COHERENT_H */
> -- 
> 1.7.2.5
> 
