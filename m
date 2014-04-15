Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751430AbaDOH2X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 03:28:23 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:52881 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaDOH2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 03:28:21 -0400
Date: Tue, 15 Apr 2014 08:28:12 +0100
From: Steve Capper <steve.capper@linaro.org>
To: Jungseok Lee <jays.lee@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin.Marinas@arm.com, "'Marc Zyngier'" <Marc.Zyngier@arm.com>,
        "'Christoffer Dall'" <christoffer.dall@linaro.org>,
        kgene.kim@samsung.com, "'Arnd Bergmann'" <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, ilho215.lee@samsung.com,
        "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>,
        sungjinn.chung@samsung.com
Subject: Re: [PATCH 7/8] arm64: mm: Implement 4 levels of translation tables
Message-ID: <20140415072811.GA1795@linaro.org>
References: <000501cf57b4$e57e8e80$b07bab80$@samsung.com>
 <20140414151333.GA29654@linaro.org>
 <001a01cf584b$38945370$a9bcfa50$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <001a01cf584b$38945370$a9bcfa50$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 10:37:11AM +0900, Jungseok Lee wrote:
> On Tuesday, April 15, 2014 12:14 AM, Steve Capper wrote:
> > On Mon, Apr 14, 2014 at 04:41:07PM +0900, Jungseok Lee wrote:
> > > This patch implements 4 levels of translation tables since 3 levels of
> > > page tables with 4KB pages cannot support 40-bit physical address
> > > space described in [1] due to the following issue.
> > >
> > > It is a restriction that kernel logical memory map with 4KB + 3 levels
> > > (0xffffffc000000000-0xffffffffffffffff) cannot cover RAM region from
> > > 544GB to 1024GB in [1]. Specifically, ARM64 kernel fails to create
> > > mapping for this region in map_mem function since __phys_to_virt for
> > > this region reaches to address overflow.
> > >
> > > If SoC design follows the document, [1], over 32GB RAM would be placed
> > > from 544GB. Even 64GB system is supposed to use the region from 544GB
> > > to 576GB for only 32GB RAM. Naturally, it would reach to enable 4
> > > levels of page tables to avoid hacking __virt_to_phys and __phys_to_virt.
> > >
> > > However, it is recommended 4 levels of page table should be only
> > > enabled if memory map is too sparse or there is about 512GB RAM.
> > >
> > > References
> > > ----------
> > > [1]: Principle of ARM Memory Maps, White Paper, Issue C
> > >
> 
> [ ... ]
> 
> > > diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c index
> > > 6b7e895..321f569 100644
> > > --- a/arch/arm64/mm/mmu.c
> > > +++ b/arch/arm64/mm/mmu.c
> > > @@ -222,9 +222,17 @@ static void __init alloc_init_pmd(pud_t *pud,
> > > unsigned long addr,  static void __init alloc_init_pud(pgd_t *pgd, unsigned long addr,
> > >  				  unsigned long end, unsigned long phys)  {
> > > -	pud_t *pud = pud_offset(pgd, addr);
> > > +	pud_t *pud;
> > >  	unsigned long next;
> > >
> > > +#ifdef CONFIG_ARM64_4_LEVELS
> > > +	if (pgd_none(*pgd) || pgd_bad(*pgd)) {
> > > +		pud = early_alloc(PTRS_PER_PUD * sizeof(pud_t));
> > > +		pgd_populate(&init_mm, pgd, pud);
> > > +	}
> > > +#endif
> > 
> > We don't need this #ifdef block, as pgd_none and pgd_bad should be zero when we have fewer than 4
> > levels.
> 
> This block is needed to cover the third RAM region from 544GB to 1024GB
> described in the document [1].
> 
> A single PGD can cover only up to 512GB with 4KB+4Level. In other words,
> kernel would reach to panic if a system has RAM over 512GB memory map space.
> That is why pgd_none should be handled.

I could have been clearer; I meant to say keep the code but remove the #ifdef
and #endif. The condition for the if statement will be false for <4 levels so
the whole block will compile out in those situations anyay; and for 4 levels
we then check the pgd.

Cheers,
-- 
Steve
