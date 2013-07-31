Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759485Ab3GaK4z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 06:56:55 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39398 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753966Ab3GaK4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 06:56:54 -0400
Date: Wed, 31 Jul 2013 11:56:43 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: [RFC/RFT PATCH 4/5] ARM: mm: change max*pfn to include the
	physical offset of memory
Message-ID: <20130731105643.GW24642@n2100.arm.linux.org.uk>
References: <1373665694-7580-1-git-send-email-santosh.shilimkar@ti.com> <1373665694-7580-5-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373665694-7580-5-git-send-email-santosh.shilimkar@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 05:48:13PM -0400, Santosh Shilimkar wrote:
> diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dma-mapping.h
> index 5b579b9..b2d5937 100644
> --- a/arch/arm/include/asm/dma-mapping.h
> +++ b/arch/arm/include/asm/dma-mapping.h
> @@ -47,12 +47,12 @@ static inline int dma_set_mask(struct device *dev, u64 mask)
>  #ifndef __arch_pfn_to_dma
>  static inline dma_addr_t pfn_to_dma(struct device *dev, unsigned long pfn)
>  {
> -	return (dma_addr_t)__pfn_to_bus(pfn);
> +	return (dma_addr_t)__pfn_to_bus(pfn + PHYS_PFN_OFFSET);
>  }
>  
>  static inline unsigned long dma_to_pfn(struct device *dev, dma_addr_t addr)
>  {
> -	return __bus_to_pfn(addr);
> +	return __bus_to_pfn(addr) - PHYS_PFN_OFFSET;
>  }
>  
>  static inline void *dma_to_virt(struct device *dev, dma_addr_t addr)
> @@ -64,15 +64,16 @@ static inline dma_addr_t virt_to_dma(struct device *dev, void *addr)
>  {
>  	return (dma_addr_t)__virt_to_bus((unsigned long)(addr));
>  }
> +
>  #else
>  static inline dma_addr_t pfn_to_dma(struct device *dev, unsigned long pfn)
>  {
> -	return __arch_pfn_to_dma(dev, pfn);
> +	return __arch_pfn_to_dma(dev, pfn + PHYS_PFN_OFFSET);
>  }
>  
>  static inline unsigned long dma_to_pfn(struct device *dev, dma_addr_t addr)
>  {
> -	return __arch_dma_to_pfn(dev, addr);
> +	return __arch_dma_to_pfn(dev, addr) - PHYS_PFN_OFFSET;
>  }
>  
>  static inline void *dma_to_virt(struct device *dev, dma_addr_t addr)
> @@ -86,6 +87,13 @@ static inline dma_addr_t virt_to_dma(struct device *dev, void *addr)
>  }
>  #endif

Note that I don't think the above are correct - the 'pfn' argument to the
above functions already includes the PFN offset of physical memory -
they're all physical_address >> PAGE_SHIFT values.

> +/* The ARM override for dma_max_pfn() */
> +static inline unsigned long dma_max_pfn(struct device *dev)
> +{
> +	return dma_to_pfn(dev, *dev->dma_mask);
> +}
> +#define dma_max_pfn(dev) dma_max_pfn(dev)

So I'd suggest this becomes:

	return PHYS_PFN_OFFSET + dma_to_pfn(dev, *dev->dma_mask);
