Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840AbaEFMBn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 08:01:43 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:33541 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbaEFMBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 08:01:39 -0400
Date: Tue, 6 May 2014 13:01:32 +0100
From: Steve Capper <steve.capper@linaro.org>
To: Jungseok Lee <jays.lee@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin.Marinas@arm.com, Marc Zyngier <Marc.Zyngier@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        linux-kernel@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        sungjinn.chung@samsung.com, Arnd Bergmann <arnd@arndb.de>,
        kgene.kim@samsung.com, ilho215.lee@samsung.com
Subject: Re: [PATCH v5 5/6] arm64: mm: Implement 4 levels of translation
 tables
Message-ID: <20140506120131.GA26776@linaro.org>
References: <000501cf64e5$d92ae870$8b80b950$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000501cf64e5$d92ae870$8b80b950$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2014 at 11:34:16AM +0900, Jungseok Lee wrote:
> This patch implements 4 levels of translation tables since 3 levels
> of page tables with 4KB pages cannot support 40-bit physical address
> space described in [1] due to the following issue.
> 
> It is a restriction that kernel logical memory map with 4KB + 3 levels
> (0xffffffc000000000-0xffffffffffffffff) cannot cover RAM region from
> 544GB to 1024GB in [1]. Specifically, ARM64 kernel fails to create
> mapping for this region in map_mem function since __phys_to_virt for
> this region reaches to address overflow.
> 
> If SoC design follows the document, [1], over 32GB RAM would be placed
> from 544GB. Even 64GB system is supposed to use the region from 544GB
> to 576GB for only 32GB RAM. Naturally, it would reach to enable 4 levels
> of page tables to avoid hacking __virt_to_phys and __phys_to_virt.
> 
> However, it is recommended 4 levels of page table should be only enabled
> if memory map is too sparse or there is about 512GB RAM.
> 

Hi Jungseok,
One comment below:

[ ... ]

> diff --git a/arch/arm64/include/asm/tlb.h b/arch/arm64/include/asm/tlb.h
> index bc19101..086112b 100644
> --- a/arch/arm64/include/asm/tlb.h
> +++ b/arch/arm64/include/asm/tlb.h
> @@ -100,6 +100,15 @@ static inline void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmdp,
>  }
>  #endif
>  
> +#ifdef CONFIG_ARM64_4_LEVELS
> +static inline void __pud_free_tlb(struct mmu_gather *tlb, pmd_t *pudp,
> +				  unsigned long addr)

The second parameter needs to be a pointer to pud_t ?
(this fires up a warning with STRICT_MM_TYPECHECKS).

With that and Christoffer's feedback about expanding the comments on
create_pud_entry addressed:

Reviewed-by: Steve Capper <steve.capper@linaro.org>

Cheers,
-- 
Steve
