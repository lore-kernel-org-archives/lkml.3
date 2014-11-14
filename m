Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161222AbaKNPUG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 10:20:06 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:15131 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965740AbaKNPUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 10:20:01 -0500
X-IronPort-AV: E=Sophos;i="5.07,386,1413244800"; 
   d="scan'208";a="192880196"
Date: Fri, 14 Nov 2014 15:19:39 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: David Vrabel <david.vrabel@citrix.com>
CC: <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        <x86@kernel.org>, <xen-devel@lists.xenproject.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 2/3] x86: allow dma_get_required_mask() to be
 overridden
In-Reply-To: <1415805906-27316-3-git-send-email-david.vrabel@citrix.com>
Message-ID: <alpine.DEB.2.02.1411141519100.26318@kaball.uk.xensource.com>
References: <1415805906-27316-1-git-send-email-david.vrabel@citrix.com> <1415805906-27316-3-git-send-email-david.vrabel@citrix.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Nov 2014, David Vrabel wrote:
> Use dma_ops->get_required_mask() if provided, defaulting to
> dma_get_requried_mask_from_max_pfn().
> 
> This is needed on systems (such as Xen PV guests) where the DMA
> address and the physical address are not equal.
> 
> Signed-off-by: David Vrabel <david.vrabel@citrix.com>

Reviewed-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>


>  arch/x86/include/asm/device.h |    2 ++
>  arch/x86/kernel/pci-dma.c     |    8 ++++++++
>  2 files changed, 10 insertions(+)
> 
> diff --git a/arch/x86/include/asm/device.h b/arch/x86/include/asm/device.h
> index 03dd729..10bc628 100644
> --- a/arch/x86/include/asm/device.h
> +++ b/arch/x86/include/asm/device.h
> @@ -13,4 +13,6 @@ struct dev_archdata {
>  struct pdev_archdata {
>  };
>  
> +#define ARCH_HAS_DMA_GET_REQUIRED_MASK
> +
>  #endif /* _ASM_X86_DEVICE_H */
> diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
> index a25e202..5154400 100644
> --- a/arch/x86/kernel/pci-dma.c
> +++ b/arch/x86/kernel/pci-dma.c
> @@ -140,6 +140,14 @@ void dma_generic_free_coherent(struct device *dev, size_t size, void *vaddr,
>  		free_pages((unsigned long)vaddr, get_order(size));
>  }
>  
> +u64 dma_get_required_mask(struct device *dev)
> +{
> +	if (dma_ops->get_required_mask)
> +		return dma_ops->get_required_mask(dev);
> +	return dma_get_required_mask_from_max_pfn(dev);
> +}
> +EXPORT_SYMBOL_GPL(dma_get_required_mask);
> +
>  /*
>   * See <Documentation/x86/x86_64/boot-options.txt> for the iommu kernel
>   * parameter documentation.
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://secure-web.cisco.com/1ixXdBDpz1KdvMlO1aynlM5N1jrQ7I1zdB_g1CPo0rimcVM76xTOPAvm484tRhqPosYwwpXnvHtyzSn_CZ4-EcYzELZhn5abgWc7e5fB0Ki0nE024_U4cvFTVoR2qflul0tkkVvivUWBl8v3vMWMTT6wuEYW3UcP3Bt3ttSORXPc/http%3A%2F%2Fwww.tux.org%2Flkml%2F
> 
