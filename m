Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab3JRMZA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 08:25:00 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:60224 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773Ab3JRMY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 08:24:59 -0400
X-IronPort-AV: E=Sophos;i="4.93,522,1378857600"; 
   d="scan'208";a="62259004"
Date: Fri, 18 Oct 2013 13:23:59 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <konrad.wilk@oracle.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Catalin Marinas <catalin.marinas@arm.com>, <linux@arm.linux.org.uk>
Subject: Re: [PATCH v8 16/19] arm,arm64: do not always merge biovec if we
 are running on Xen
In-Reply-To: <1382031814-8782-16-git-send-email-stefano.stabellini@eu.citrix.com>
Message-ID: <alpine.DEB.2.02.1310181322301.26077@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1310171833520.26077@kaball.uk.xensource.com> <1382031814-8782-16-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell, Catalin,
are you OK with this patch?

It shouldn't have any impact when running on native, only on Xen.


On Thu, 17 Oct 2013, Stefano Stabellini wrote:
> This is similar to what it is done on X86: biovecs are prevented from merging
> otherwise every dma requests would be forced to bounce on the swiotlb buffer.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> 
> 
> Changes in v7:
> - remove the extra autotranslate check in biomerge.c.
> ---
>  arch/arm/include/asm/io.h   |    8 ++++++++
>  arch/arm64/include/asm/io.h |    9 +++++++++
>  2 files changed, 17 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/include/asm/io.h b/arch/arm/include/asm/io.h
> index d070741..c45effc 100644
> --- a/arch/arm/include/asm/io.h
> +++ b/arch/arm/include/asm/io.h
> @@ -24,9 +24,11 @@
>  #ifdef __KERNEL__
>  
>  #include <linux/types.h>
> +#include <linux/blk_types.h>
>  #include <asm/byteorder.h>
>  #include <asm/memory.h>
>  #include <asm-generic/pci_iomap.h>
> +#include <xen/xen.h>
>  
>  /*
>   * ISA I/O bus memory addresses are 1:1 with the physical address.
> @@ -372,6 +374,12 @@ extern void pci_iounmap(struct pci_dev *dev, void __iomem *addr);
>  #define BIOVEC_MERGEABLE(vec1, vec2)	\
>  	((bvec_to_phys((vec1)) + (vec1)->bv_len) == bvec_to_phys((vec2)))
>  
> +extern bool xen_biovec_phys_mergeable(const struct bio_vec *vec1,
> +				      const struct bio_vec *vec2);
> +#define BIOVEC_PHYS_MERGEABLE(vec1, vec2)				\
> +	(__BIOVEC_PHYS_MERGEABLE(vec1, vec2) &&				\
> +	 (!xen_domain() || xen_biovec_phys_mergeable(vec1, vec2)))
> +
>  #ifdef CONFIG_MMU
>  #define ARCH_HAS_VALID_PHYS_ADDR_RANGE
>  extern int valid_phys_addr_range(phys_addr_t addr, size_t size);
> diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
> index 1d12f89..c163287b 100644
> --- a/arch/arm64/include/asm/io.h
> +++ b/arch/arm64/include/asm/io.h
> @@ -22,11 +22,14 @@
>  #ifdef __KERNEL__
>  
>  #include <linux/types.h>
> +#include <linux/blk_types.h>
>  
>  #include <asm/byteorder.h>
>  #include <asm/barrier.h>
>  #include <asm/pgtable.h>
>  
> +#include <xen/xen.h>
> +
>  /*
>   * Generic IO read/write.  These perform native-endian accesses.
>   */
> @@ -263,5 +266,11 @@ extern int devmem_is_allowed(unsigned long pfn);
>   */
>  #define xlate_dev_kmem_ptr(p)	p
>  
> +extern bool xen_biovec_phys_mergeable(const struct bio_vec *vec1,
> +				      const struct bio_vec *vec2);
> +#define BIOVEC_PHYS_MERGEABLE(vec1, vec2)				\
> +	(__BIOVEC_PHYS_MERGEABLE(vec1, vec2) &&				\
> +	 (!xen_domain() || xen_biovec_phys_mergeable(vec1, vec2)))
> +
>  #endif	/* __KERNEL__ */
>  #endif	/* __ASM_IO_H */
> -- 
> 1.7.2.5
> 
