Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230AbaISQ32 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 12:29:28 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40532 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756232AbaISQ31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 12:29:27 -0400
Date: Fri, 19 Sep 2014 17:28:59 +0100
From: Will Deacon <will.deacon@arm.com>
To: Mark Salter <msalter@redhat.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jcm@redhat.com" <jcm@redhat.com>
Subject: Re: [PATCH] arm64/pci: fix dma coherency inheritance for PCI devices
Message-ID: <20140919162859.GG20773@arm.com>
References: <1411141886-11310-1-git-send-email-msalter@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411141886-11310-1-git-send-email-msalter@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 04:51:26PM +0100, Mark Salter wrote:
> The default dma_ops for devices on arm64 systems are noncoherent in
> nature and rely upon special operations and bounce buffers to
> perform a device DMA operation to/from memory. Some drivers rely
> upon coherent operations involving suitably capable hardware. In
> this case, a "dma-coherent" property will exist on the corresponding
> Device Tree node for the bridge device, or one of its ancestors.
> This patch adds support for applying a DMA coherent dma_ops for
> PCI devices in the case of such a property.
> 
> Signed-off-by: Jon Masters <jcm@redhat.com>
> [added search for device with of_node]
> Signed-off-by: Mark Salter <msalter@redhat.com>
> ---
>  arch/arm64/mm/dma-mapping.c | 21 +++++++++++++++++++--
>  1 file changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/mm/dma-mapping.c b/arch/arm64/mm/dma-mapping.c
> index 4164c5a..0e26bd7 100644
> --- a/arch/arm64/mm/dma-mapping.c
> +++ b/arch/arm64/mm/dma-mapping.c
> @@ -23,10 +23,12 @@
>  #include <linux/dma-mapping.h>
>  #include <linux/dma-contiguous.h>
>  #include <linux/of.h>
> +#include <linux/of_address.h>
>  #include <linux/platform_device.h>
>  #include <linux/vmalloc.h>
>  #include <linux/swiotlb.h>
>  #include <linux/amba/bus.h>
> +#include <linux/pci.h>
>  
>  #include <asm/cacheflush.h>
>  
> @@ -316,8 +318,18 @@ static int dma_bus_notifier(struct notifier_block *nb,
>  	if (event != BUS_NOTIFY_ADD_DEVICE)
>  		return NOTIFY_DONE;
>  
> -	if (of_property_read_bool(dev->of_node, "dma-coherent"))
> -		set_dma_ops(dev, &coherent_swiotlb_dma_ops);
> +	/*
> +	 * Some devices won't have an of_node but a bus controller/bridge will.
> +	 * Search up the device chain until we find an of_node to check.
> +	 */
> +	while (dev) {
> +		if (dev->of_node) {
> +			if (of_dma_is_coherent(dev->of_node))
> +				set_dma_ops(_dev, &coherent_swiotlb_dma_ops);
> +			break;
> +		}
> +		dev = dev->parent;
> +	}

Hmm, how does this interact with of_dma_configure? I don't think the
dma-coherent property is inherited there, so I'm uneasy about doing this for
buses other than PCI (i.e. the platform bus).

In other words, we should move to using of_dma_configure for the platform
and amba buses, and have a separate notifier for the PCI bus. Is it likely
that people will have a mixture of coherent and non-coherent devices behind
the same host controller?

Will

>  	return NOTIFY_OK;
>  }
> @@ -330,6 +342,10 @@ static struct notifier_block amba_bus_nb = {
>  	.notifier_call = dma_bus_notifier,
>  };
>  
> +static struct notifier_block pci_bus_nb = {
> +	.notifier_call = dma_bus_notifier,
> +};
> +
>  extern int swiotlb_late_init_with_default_size(size_t default_size);
>  
>  static int __init swiotlb_late_init(void)
> @@ -341,6 +357,7 @@ static int __init swiotlb_late_init(void)
>  	 */
>  	bus_register_notifier(&platform_bus_type, &platform_bus_nb);
>  	bus_register_notifier(&amba_bustype, &amba_bus_nb);
> +	bus_register_notifier(&pci_bus_type, &pci_bus_nb);
>  
>  	dma_ops = &noncoherent_swiotlb_dma_ops;
>  
> -- 
> 1.9.3
> 
> 
