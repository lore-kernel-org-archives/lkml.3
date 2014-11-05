Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827AbaKESPy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 13:15:54 -0500
Received: from smtp.citrix.com ([66.165.176.89]:31270 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963AbaKESPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 13:15:51 -0500
X-IronPort-AV: E=Sophos;i="5.07,321,1413244800"; 
   d="scan'208";a="188436681"
Date: Wed, 5 Nov 2014 18:15:38 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        "david.vrabel@citrix.com" <david.vrabel@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7 3/8] arm64: introduce is_device_dma_coherent
In-Reply-To: <20141105165646.GN32700@e104818-lin.cambridge.arm.com>
Message-ID: <alpine.DEB.2.02.1411051757140.22875@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1410261621200.22875@kaball.uk.xensource.com> <1414422568-19103-3-git-send-email-stefano.stabellini@eu.citrix.com> <alpine.DEB.2.02.1411031045340.22875@kaball.uk.xensource.com> <20141103105716.GC23162@arm.com>
 <alpine.DEB.2.02.1411031101400.22875@kaball.uk.xensource.com> <20141105165646.GN32700@e104818-lin.cambridge.arm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Nov 2014, Catalin Marinas wrote:
> On Mon, Nov 03, 2014 at 11:10:18AM +0000, Stefano Stabellini wrote:
> > On Mon, 3 Nov 2014, Will Deacon wrote:
> > > On Mon, Nov 03, 2014 at 10:46:03AM +0000, Stefano Stabellini wrote:
> > > > On Mon, 27 Oct 2014, Stefano Stabellini wrote:
> > > > > Introduce a boolean flag and an accessor function to check whether a
> > > > > device is dma_coherent. Set the flag from set_arch_dma_coherent_ops.
> > > > > 
> > > > > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > > > > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > > > > CC: will.deacon@arm.com
> > > > 
> > > > Will, Catalin,
> > > > are you OK with this patch?
> > > 
> > > It would be nicer if the dma_coherent flag didn't have to be duplicated by
> > > each architecture in dev_archdata. Is there any reason not to put it in the
> > > core code?
> > 
> > Yes, there is a reason for it: if I added a boolean dma_coherent flag in
> > struct device as Catalin initially suggested, what would be the default
> > for each architecture? Where would I set it for arch that don't use
> > device tree?
> 
> You don't need to. An architecture that has coherent DMA always doesn't
> need to do anything. One that has non-coherent DMA always only needs to
> select HAVE_DMA_NONCOHERENT. One that has a mix of both needs to find a
> way to set dev->dma_coherent. Since that's a new API you introduce, it
> doesn't break any existing architectures.

I am not sure that this is better than the current patch but I can see
that this approach is not too controversial, so I am happy to go with
whatever the maintainers prefer.


> Note that if !is_device_dma_coherent(), it doesn't always mean that
> standard cache maintenance would be enough (but that's a Xen problem,
> not sure how to solve).

It is a thorny issue indeed.
Xen would need to know how to do non-standard cache maintenance
operations.
Otherwise we would need to resurrect XENFEAT_grant_map_identity (that I
am reverting in this series) and be content with having CONFIG_XEN_DOM0
depend on CONFIG_ARM_LPAE.


> diff --git a/arch/Kconfig b/arch/Kconfig
> index 05d7a8a458d5..8462b2e7491b 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -203,6 +203,9 @@ config HAVE_DMA_ATTRS
>  config HAVE_DMA_CONTIGUOUS
>  	bool
>  
> +config HAVE_DMA_NONCOHERENT
> +	bool
> +
>  config GENERIC_SMP_IDLE_THREAD
>         bool
>  
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 89c4b5ccc68d..fd7d5522764c 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -40,6 +40,7 @@ config ARM
>  	select HAVE_DMA_API_DEBUG
>  	select HAVE_DMA_ATTRS
>  	select HAVE_DMA_CONTIGUOUS if MMU
> +	select HAVE_DMA_NONCOHERENT if OF
>  	select HAVE_DYNAMIC_FTRACE if (!XIP_KERNEL)
>  	select HAVE_EFFICIENT_UNALIGNED_ACCESS if (CPU_V6 || CPU_V6K || CPU_V7) && MMU
>  	select HAVE_FTRACE_MCOUNT_RECORD if (!XIP_KERNEL)
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 9532f8d5857e..eb7a5aa64e0e 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -46,6 +46,7 @@ config ARM64
>  	select HAVE_DMA_API_DEBUG
>  	select HAVE_DMA_ATTRS
>  	select HAVE_DMA_CONTIGUOUS
> +	select HAVE_DMA_NONCOHERENT
>  	select HAVE_DYNAMIC_FTRACE
>  	select HAVE_EFFICIENT_UNALIGNED_ACCESS
>  	select HAVE_FTRACE_MCOUNT_RECORD
> diff --git a/drivers/of/platform.c b/drivers/of/platform.c
> index 3b64d0bf5bba..7e827726b702 100644
> --- a/drivers/of/platform.c
> +++ b/drivers/of/platform.c
> @@ -183,6 +183,7 @@ static void of_dma_configure(struct device *dev)
>  	 * dma coherent operations.
>  	 */
>  	if (of_dma_is_coherent(dev->of_node)) {
> +		dev->dma_coherent = true;
>  		set_arch_dma_coherent_ops(dev);
>  		dev_dbg(dev, "device is dma coherent\n");
>  	}

I think that this would need to be #ifdef'ed as it is possible to have
OF support but no HAVE_DMA_NONCOHERENT (PPC?).


> diff --git a/include/linux/device.h b/include/linux/device.h
> index ce1f21608b16..e00ca876db01 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -796,6 +796,7 @@ struct device {
>  
>  	bool			offline_disabled:1;
>  	bool			offline:1;
> +	bool			dma_coherent:1;
>  };

I guess we would have to #ifdef CONFIG_HAVE_DMA_NONCOHERENT the
dma_coherent flag, right? Otherwise architecures that do not select
CONFIG_HAVE_DMA_NONCOHERENT (x86 for example) would end up with a flag
in struct device that doesn't reflect the properties of the device (dma
coherent devices with dev->dma_coherent == 0).

Overall it is a lot of ifdefs for not so much code sharing.


>  static inline struct device *kobj_to_dev(struct kobject *kobj)
> diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
> index d5d388160f42..0bdffba2337d 100644
> --- a/include/linux/dma-mapping.h
> +++ b/include/linux/dma-mapping.h
> @@ -78,6 +78,18 @@ static inline int is_device_dma_capable(struct device *dev)
>  	return dev->dma_mask != NULL && *dev->dma_mask != DMA_MASK_NONE;
>  }
>  
> +#ifdef CONFIG_HAVE_DMA_NONCOHERENT
> +static inline int is_device_dma_coherent(struct device *dev)
> +{
> +	return dev->dma_coherent;
> +}
> +#else
> +static inline int is_device_dma_coherent(struct device *dev)
> +{
> +	return 1
> +}
> +#endif
> +
>  #ifdef CONFIG_HAS_DMA
>  #include <asm/dma-mapping.h>
>  #else
