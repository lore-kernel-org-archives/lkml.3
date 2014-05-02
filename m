Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257AbaEBOc7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 10:32:59 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:61892 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757AbaEBOc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 10:32:57 -0400
MIME-Version: 1.0
In-Reply-To: <1398353407-2345-6-git-send-email-santosh.shilimkar@ti.com>
References: <1398353407-2345-1-git-send-email-santosh.shilimkar@ti.com>
	<1398353407-2345-6-git-send-email-santosh.shilimkar@ti.com>
Date: Fri, 2 May 2014 09:32:56 -0500
Message-ID: <CAL_JsqKapfHRMQLU+4hmRUh7Swf-_YedW=yU=nrqzftoJ09PYQ@mail.gmail.com>
Subject: Re: [PATCH v3 5/7] ARM: dma: Use dma_pfn_offset for dma address translation
From: Rob Herring <robherring2@gmail.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 10:30 AM, Santosh Shilimkar
<santosh.shilimkar@ti.com> wrote:
> From: Grygorii Strashko <grygorii.strashko@ti.com>
>
> In most of cases DMA addresses can be performed using offset value of
>  Bus address space relatively to physical address space as following:
>
> PFN->DMA:
>  __pfn_to_phys(pfn + [-]dma_pfn_offset)
>
> DMA->PFN:
>  __phys_to_pfn(dma_addr) + [-]dma_pfn_offset
>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Olof Johansson <olof@lixom.net>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

Reviewed-by: Rob Herring <robh@kernel.org>

> ---
>  arch/arm/include/asm/dma-mapping.h |   21 +++++++++++++++++----
>  1 file changed, 17 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dma-mapping.h
> index e701a4d..424fda9 100644
> --- a/arch/arm/include/asm/dma-mapping.h
> +++ b/arch/arm/include/asm/dma-mapping.h
> @@ -58,22 +58,35 @@ static inline int dma_set_mask(struct device *dev, u64 mask)
>  #ifndef __arch_pfn_to_dma
>  static inline dma_addr_t pfn_to_dma(struct device *dev, unsigned long pfn)
>  {
> -       return (dma_addr_t)__pfn_to_bus(pfn);
> +       if (!dev)
> +               return (dma_addr_t)__pfn_to_bus(pfn);
> +       else
> +               return (dma_addr_t)__pfn_to_bus(pfn - dev->dma_pfn_offset);
>  }
>
>  static inline unsigned long dma_to_pfn(struct device *dev, dma_addr_t addr)
>  {
> -       return __bus_to_pfn(addr);
> +       if (!dev)
> +               return __bus_to_pfn(addr);
> +       else
> +               return __bus_to_pfn(addr) + dev->dma_pfn_offset;
>  }
>
>  static inline void *dma_to_virt(struct device *dev, dma_addr_t addr)
>  {
> -       return (void *)__bus_to_virt((unsigned long)addr);
> +       if (!dev)
> +               return (void *)__bus_to_virt((unsigned long)addr);
> +       else
> +               return (void *)__bus_to_virt(__pfn_to_bus(dma_to_pfn(dev, addr)));
>  }
>
>  static inline dma_addr_t virt_to_dma(struct device *dev, void *addr)
>  {
> -       return (dma_addr_t)__virt_to_bus((unsigned long)(addr));
> +       if (!dev)
> +               return (dma_addr_t)__virt_to_bus((unsigned long)(addr));
> +       else
> +               return pfn_to_dma(dev,
> +                               __bus_to_pfn(__virt_to_bus((unsigned long)(addr))));
>  }
>
>  #else
> --
> 1.7.9.5
>
