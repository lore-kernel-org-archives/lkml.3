Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab3JBRE4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 13:04:56 -0400
Received: from smtp.citrix.com ([66.165.176.89]:5378 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754340Ab3JBREn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 13:04:43 -0400
X-IronPort-AV: E=Sophos;i="4.90,1019,1371081600"; 
   d="scan'208";a="59625443"
Date: Wed, 2 Oct 2013 18:03:46 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>
Subject: Re: [PATCH v6 10/19] xen: introduce xen_alloc/free_coherent_pages
In-Reply-To: <DB675896-3FF2-409B-A2C6-24295C197A3F@arm.com>
Message-ID: <alpine.DEB.2.02.1310021754580.26077@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1309271653420.5498@kaball.uk.xensource.com> <1380298207-29151-10-git-send-email-stefano.stabellini@eu.citrix.com> <20130930153143.GQ3106@phenom.dumpdata.com> <DB675896-3FF2-409B-A2C6-24295C197A3F@arm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Oct 2013, Catalin Marinas wrote:
> On 30 Sep 2013, at 16:31, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> > On Fri, Sep 27, 2013 at 05:09:58PM +0100, Stefano Stabellini wrote:
> >> xen_swiotlb_alloc_coherent needs to allocate a coherent buffer for cpu
> >> and devices. On native x86 and ARMv8 is sufficient to call
> >> __get_free_pages in order to get a coherent buffer, while on ARM we need
> >> to call the native dma_ops->alloc implementation.
> >> 
> >> When arm64 stops using the swiotlb by default and starts having multiple
> >> dma_ops implementations, we'll use __get_dma_ops there too.
> > 
> > I presume this is a future TODO, not some further patch (in which
> > case you should say in here the title of it). If it is a TODO could
> > you stick that in the sentence here somewhere to make it crytal clear that
> > it is not implemented.
> 
> Thanks for pointing this out.  The arm64 patch shouldn't be different
> from arm here.  I thought a subsequent patch already added
> __get_dma_ops() for arm64.

Yes, the arm64 patch already added __get_dma_ops.

However I am not using __get_dma_ops to implement
xen_alloc_coherent_pages for arm64 because I can just use
__get_free_pages for the moment:


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
> +             dma_addr_t *dma_handle, gfp_t flags,
> +             struct dma_attrs *attrs)
> +{
> +     void *vstart = (void*)__get_free_pages(flags, get_order(size));
> +     *dma_handle = virt_to_phys(vstart);
> +     return vstart;
> +}
> +
> +static inline void xen_free_coherent_pages(struct device *hwdev, size_t size,
> +             void *cpu_addr, dma_addr_t dma_handle,
> +             struct dma_attrs *attrs)
> +{
> +     free_pages((unsigned long) cpu_addr, get_order(size));
> +}
> +
> +#endif /* _ASM_ARM64_XEN_PAGE_COHERENT_H */
