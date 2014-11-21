Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbaKULoU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 06:44:20 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:19992 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691AbaKULoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 06:44:18 -0500
X-IronPort-AV: E=Sophos;i="5.07,429,1413244800"; 
   d="scan'208";a="195200227"
Date: Fri, 21 Nov 2014 11:43:53 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: David Vrabel <david.vrabel@citrix.com>
CC: <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        <x86@kernel.org>, <xen-devel@lists.xenproject.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 4/4] x86/xen: assume a 64-bit DMA mask is required
In-Reply-To: <1416484225-28054-5-git-send-email-david.vrabel@citrix.com>
Message-ID: <alpine.DEB.2.02.1411211137520.12596@kaball.uk.xensource.com>
References: <1416484225-28054-1-git-send-email-david.vrabel@citrix.com> <1416484225-28054-5-git-send-email-david.vrabel@citrix.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Nov 2014, David Vrabel wrote:
> On a Xen PV guest the DMA addresses and physical addresses are not 1:1
> (such as Xen PV guests) and the generic dma_get_required_mask() does
> not return the correct mask (since it uses max_pfn).
> 
> Some device drivers (such as mptsas, mpt2sas) use
> dma_get_required_mask() to set the device's DMA mask to allow them to
> use only 32-bit DMA addresses in hardware structures.  This results in
> unnecessary use of the SWIOTLB if DMA addresses are more than 32-bits,
> impacting performance significantly.
> 
> We could base the DMA mask on the maximum MFN but:
> 
> a) The hypercall op to get the maximum MFN (XENMEM_maximum_ram_page)
> will truncate the result to an int in 32-bit guests.
> 
> b) Future uses of the IOMMU in Xen may map frames at bus addresses
> above the end of RAM.
> 
> So, just assume a 64-bit DMA mask is always required.
 
That's OK for me but at this point I am unsure whether swiotlb-xen is
the right place to put this function.  It feels more like something that
should be introduced in pci-swiotlb-xen.c or arch/x86/xen/mmu.c?

If I were to introduce it on ARM, I would add it to arch/arm/xen/mm.c.


> Signed-off-by: David Vrabel <david.vrabel@citrix.com>
>
>  arch/x86/xen/pci-swiotlb-xen.c |    1 +
>  drivers/xen/swiotlb-xen.c      |    9 +++++++++
>  include/xen/swiotlb-xen.h      |    4 ++++
>  3 files changed, 14 insertions(+)
> 
> diff --git a/arch/x86/xen/pci-swiotlb-xen.c b/arch/x86/xen/pci-swiotlb-xen.c
> index 0e98e5d..a5d180a 100644
> --- a/arch/x86/xen/pci-swiotlb-xen.c
> +++ b/arch/x86/xen/pci-swiotlb-xen.c
> @@ -31,6 +31,7 @@ static struct dma_map_ops xen_swiotlb_dma_ops = {
>  	.map_page = xen_swiotlb_map_page,
>  	.unmap_page = xen_swiotlb_unmap_page,
>  	.dma_supported = xen_swiotlb_dma_supported,
> +	.get_required_mask = xen_swiotlb_get_required_mask,
>  };
>  
>  /*
> diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
> index ebd8f21..767d048 100644
> --- a/drivers/xen/swiotlb-xen.c
> +++ b/drivers/xen/swiotlb-xen.c
> @@ -42,9 +42,11 @@
>  #include <xen/page.h>
>  #include <xen/xen-ops.h>
>  #include <xen/hvc-console.h>
> +#include <xen/interface/memory.h>
>  
>  #include <asm/dma-mapping.h>
>  #include <asm/xen/page-coherent.h>
> +#include <asm/xen/hypercall.h>
>  
>  #include <trace/events/swiotlb.h>
>  /*
> @@ -683,3 +685,10 @@ xen_swiotlb_set_dma_mask(struct device *dev, u64 dma_mask)
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(xen_swiotlb_set_dma_mask);
> +
> +u64
> +xen_swiotlb_get_required_mask(struct device *dev)
> +{
> +	return DMA_BIT_MASK(64);
> +}
> +EXPORT_SYMBOL_GPL(xen_swiotlb_get_required_mask);
> diff --git a/include/xen/swiotlb-xen.h b/include/xen/swiotlb-xen.h
> index 8b2eb93..6408888 100644
> --- a/include/xen/swiotlb-xen.h
> +++ b/include/xen/swiotlb-xen.h
> @@ -58,4 +58,8 @@ xen_swiotlb_dma_supported(struct device *hwdev, u64 mask);
>  
>  extern int
>  xen_swiotlb_set_dma_mask(struct device *dev, u64 dma_mask);
> +
> +extern u64
> +xen_swiotlb_get_required_mask(struct device *dev);
> +
>  #endif /* __LINUX_SWIOTLB_XEN_H */
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://secure-web.cisco.com/1uIZMIeWCQQAJEnGQc6XX-CEjdCVm87GER9t4JEG7wumHKaVAK-6pwSilKvT3RCicfLK8CEakvw_GaO39BTHmmtTqFXSad9_K_6hMXHETF0twK9R1Pdq_kGKFl6aw081mC3L6qVNyOQdb-Hyqn38-_ESRf6rGMDflx4RA3XBEjGA/http%3A%2F%2Fwww.tux.org%2Flkml%2F
> 
