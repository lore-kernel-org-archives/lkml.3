Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbaIVKYJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 06:24:09 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:35381 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbaIVKYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 06:24:08 -0400
Date: Mon, 22 Sep 2014 11:23:52 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Salter <msalter@redhat.com>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jcm@redhat.com" <jcm@redhat.com>
Subject: Re: [PATCH] arm64/pci: fix dma coherency inheritance for PCI devices
Message-ID: <20140922102352.GH30085@e104818-lin.cambridge.arm.com>
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
> diff --git a/arch/arm64/mm/dma-mapping.c b/arch/arm64/mm/dma-mapping.c
> index 4164c5a..0e26bd7 100644
[...]
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
>  
>  	return NOTIFY_OK;
>  }

For AMBA (with an additional patch) and platform devices, we can do the
same as ARM and rely on set_arch_dma_coherent_ops(), so most of the
notifier code removed. So we leave the above notifier for PCI only.

>  static int __init swiotlb_late_init(void)
> @@ -341,6 +357,7 @@ static int __init swiotlb_late_init(void)
>  	 */
>  	bus_register_notifier(&platform_bus_type, &platform_bus_nb);
>  	bus_register_notifier(&amba_bustype, &amba_bus_nb);
> +	bus_register_notifier(&pci_bus_type, &pci_bus_nb);

Does this compile when CONFIG_PCI is disabled?

-- 
Catalin
