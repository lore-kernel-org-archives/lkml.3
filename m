Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047AbaEBPAB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:00:01 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:33254 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751636AbaEBPAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:00:00 -0400
Date: Fri, 2 May 2014 15:58:52 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v3 5/7] ARM: dma: Use dma_pfn_offset for dma address
	translation
Message-ID: <20140502145852.GC3693@n2100.arm.linux.org.uk>
References: <1398353407-2345-1-git-send-email-santosh.shilimkar@ti.com> <1398353407-2345-6-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398353407-2345-6-git-send-email-santosh.shilimkar@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 11:30:05AM -0400, Santosh Shilimkar wrote:
> diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dma-mapping.h
> index e701a4d..424fda9 100644
> --- a/arch/arm/include/asm/dma-mapping.h
> +++ b/arch/arm/include/asm/dma-mapping.h
> @@ -58,22 +58,35 @@ static inline int dma_set_mask(struct device *dev, u64 mask)
>  #ifndef __arch_pfn_to_dma
>  static inline dma_addr_t pfn_to_dma(struct device *dev, unsigned long pfn)
>  {
> -	return (dma_addr_t)__pfn_to_bus(pfn);
> +	if (!dev)
> +		return (dma_addr_t)__pfn_to_bus(pfn);
> +	else
> +		return (dma_addr_t)__pfn_to_bus(pfn - dev->dma_pfn_offset);

I really don't trust gcc to do this right, so I think it would be better
to make life easier on the compiler:

	if (dev)
		pfn -= dev->dma_pfn_offset;
	return (dma_addr_t)__pfn_to_bus(pfn);

>  static inline unsigned long dma_to_pfn(struct device *dev, dma_addr_t addr)
>  {
> -	return __bus_to_pfn(addr);
> +	if (!dev)
> +		return __bus_to_pfn(addr);
> +	else
> +		return __bus_to_pfn(addr) + dev->dma_pfn_offset;

and:

	unsigned long pfn = __bus_to_pfn(addr);

	if (dev)
		pfn += dev->dma_pfn_offset;

	return pfn;

>  }
>  
>  static inline void *dma_to_virt(struct device *dev, dma_addr_t addr)
>  {
> -	return (void *)__bus_to_virt((unsigned long)addr);
> +	if (!dev)
> +		return (void *)__bus_to_virt((unsigned long)addr);
> +	else
> +		return (void *)__bus_to_virt(__pfn_to_bus(dma_to_pfn(dev, addr)));

This is quite horrendous.  There's easier ways to do this...  I assume
you haven't looked at the assembler resulting from this at all with
stuff like the p2v patching enabled?

>  }
>  
>  static inline dma_addr_t virt_to_dma(struct device *dev, void *addr)
>  {
> -	return (dma_addr_t)__virt_to_bus((unsigned long)(addr));
> +	if (!dev)
> +		return (dma_addr_t)__virt_to_bus((unsigned long)(addr));
> +	else
> +		return pfn_to_dma(dev,
> +				__bus_to_pfn(__virt_to_bus((unsigned long)(addr))));

Same here.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
