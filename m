Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256Ab3HFDPO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 23:15:14 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:55614 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701Ab3HFDPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 23:15:12 -0400
MIME-Version: 1.0
In-Reply-To: <E1V51J5-0006uq-1h@rmk-PC.arm.linux.org.uk>
References: <20130801213420.GL23006@n2100.arm.linux.org.uk>
	<E1V51J5-0006uq-1h@rmk-PC.arm.linux.org.uk>
Date: Mon, 5 Aug 2013 22:15:11 -0500
Message-ID: <CAL_Jsq+9+LBVCwQKKJznbPP06WA0Wn-7m+cFoyF==GRkP9XXmQ@mail.gmail.com>
Subject: Re: [PATCH RFC 51/51] ARM: 7805/1: mm: change max*pfn to include the
 physical offset of memory
From: Rob Herring <robherring2@gmail.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 1, 2013 at 5:25 PM, Santosh Shilimkar
<santosh.shilimkar@ti.com> wrote:
> Most of the kernel code assumes that max*pfn is maximum pfns because
> the physical start of memory is expected to be PFN0. Since this
> assumption is not true on ARM architectures, the meaning of max*pfn
> is number of memory pages. This is done to keep drivers happy which
> are making use of of these variable to calculate the dma bounce limit
> using dma_mask.
>
> Now since we have a architecture override possibility for DMAable
> maximum pfns, lets make meaning of max*pfns as maximum pnfs on ARM
> as well.
>
> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> ---
>  arch/arm/include/asm/dma-mapping.h |    8 ++++++++
>  arch/arm/mm/init.c                 |   10 ++++------
>  2 files changed, 12 insertions(+), 6 deletions(-)
>
> diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dma-mapping.h
> index 5b579b9..863cd84 100644
> --- a/arch/arm/include/asm/dma-mapping.h
> +++ b/arch/arm/include/asm/dma-mapping.h
> @@ -64,6 +64,7 @@ static inline dma_addr_t virt_to_dma(struct device *dev, void *addr)
>  {
>         return (dma_addr_t)__virt_to_bus((unsigned long)(addr));
>  }
> +
>  #else
>  static inline dma_addr_t pfn_to_dma(struct device *dev, unsigned long pfn)
>  {
> @@ -86,6 +87,13 @@ static inline dma_addr_t virt_to_dma(struct device *dev, void *addr)
>  }
>  #endif
>
> +/* The ARM override for dma_max_pfn() */
> +static inline unsigned long dma_max_pfn(struct device *dev)
> +{
> +       return PHYS_PFN_OFFSET + dma_to_pfn(dev, *dev->dma_mask);

Do we need to handle dev == NULL case?

Rob
