Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140AbaLHKd3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 05:33:29 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:45983 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbaLHKd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 05:33:28 -0500
Date: Mon, 8 Dec 2014 10:33:29 +0000
From: Will Deacon <will.deacon@arm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Xen Devel <Xen-devel@lists.xensource.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Vrabel <david.vrabel@citrix.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: linux-next: manual merge of the xen-tip tree with the arm-soc
 tree
Message-ID: <20141208103328.GE27367@arm.com>
References: <20141208184908.27bfd605@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141208184908.27bfd605@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2014 at 07:49:08AM +0000, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the xen-tip tree got a conflict in
> arch/arm/include/asm/dma-mapping.h between commits a3a60f81ee6f
> ("dma-mapping: replace set_arch_dma_coherent_ops with
> arch_setup_dma_ops") and 4bb25789ed28 ("arm: dma-mapping: plumb our
> iommu mapping ops into arch_setup_dma_ops") from the arm-soc tree and
> commit 3d5391ac6f5e ("arm: introduce is_device_dma_coherent") from the
> xen-tip tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
> 
> I also neede this merge fix patch:
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 8 Dec 2014 18:46:59 +1100
> Subject: [PATCH] arm: introduce is_device_dma_coherent merge fix
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  arch/arm/mm/dma-mapping.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
> index 09645f00bd17..43064cbe58f9 100644
> --- a/arch/arm/mm/dma-mapping.c
> +++ b/arch/arm/mm/dma-mapping.c
> @@ -2058,6 +2058,7 @@ void arch_setup_dma_ops(struct device *dev, u64 dma_base, u64 size,
>  	else
>  		dma_ops = arm_get_dma_map_ops(coherent);
>  
> +	dev->archdata.dma_coherent = coherent;
>  	set_dma_ops(dev, dma_ops);
>  }

Looks good to me.

Cheers,

Will

> -- 
> 2.1.3
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc arch/arm/include/asm/dma-mapping.h
> index 9410b7e548fc,e6e3446abdf6..000000000000
> --- a/arch/arm/include/asm/dma-mapping.h
> +++ b/arch/arm/include/asm/dma-mapping.h
> @@@ -121,13 -121,20 +121,19 @@@ static inline unsigned long dma_max_pfn
>   }
>   #define dma_max_pfn(dev) dma_max_pfn(dev)
>   
>  -static inline int set_arch_dma_coherent_ops(struct device *dev)
>  -{
>  -	dev->archdata.dma_coherent = true;
>  -	set_dma_ops(dev, &arm_coherent_dma_ops);
>  -	return 0;
>  -}
>  -#define set_arch_dma_coherent_ops(dev)	set_arch_dma_coherent_ops(dev)
>  +#define arch_setup_dma_ops arch_setup_dma_ops
>  +extern void arch_setup_dma_ops(struct device *dev, u64 dma_base, u64 size,
>  +			       struct iommu_ops *iommu, bool coherent);
>  +
>  +#define arch_teardown_dma_ops arch_teardown_dma_ops
>  +extern void arch_teardown_dma_ops(struct device *dev);
>   
> + /* do not use this function in a driver */
> + static inline bool is_device_dma_coherent(struct device *dev)
> + {
> + 	return dev->archdata.dma_coherent;
> + }
> + 
>   static inline dma_addr_t phys_to_dma(struct device *dev, phys_addr_t paddr)
>   {
>   	unsigned int offset = paddr & ~PAGE_MASK;


