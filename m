Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270AbaDNPd4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 11:33:56 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:56618 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbaDNPdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 11:33:54 -0400
Date: Mon, 14 Apr 2014 16:33:46 +0100
From: Steve Capper <steve.capper@linaro.org>
To: Jungseok Lee <jays.lee@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin.Marinas@arm.com, Marc Zyngier <Marc.Zyngier@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>, kgene.kim@samsung.com,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        ilho215.lee@samsung.com,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        sungjinn.chung@samsung.com
Subject: Re: [PATCH 7/8] arm64: mm: Implement 4 levels of translation tables
Message-ID: <20140414153346.GA32602@linaro.org>
References: <000501cf57b4$e57e8e80$b07bab80$@samsung.com>
 <20140414151333.GA29654@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140414151333.GA29654@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 04:13:35PM +0100, Steve Capper wrote:
> On Mon, Apr 14, 2014 at 04:41:07PM +0900, Jungseok Lee wrote:

[ ... ]

> > diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
> > index 0fd5650..0b0b16a 100644
> > --- a/arch/arm64/kernel/head.S
> > +++ b/arch/arm64/kernel/head.S
> 
> A comment above this line needs to also be changed?
> 
> > @@ -46,8 +46,8 @@
> >  #error KERNEL_RAM_VADDR must start at 0xXXX80000
> >  #endif
> >  
> > -#define SWAPPER_DIR_SIZE	(3 * PAGE_SIZE)
> > -#define IDMAP_DIR_SIZE		(2 * PAGE_SIZE)
> > +#define SWAPPER_DIR_SIZE	(4 * PAGE_SIZE)
> > +#define IDMAP_DIR_SIZE		(3 * PAGE_SIZE)
> 
> Again, this affects <4 levels of paging.
> 
> >  
> >  	.globl	swapper_pg_dir
> >  	.equ	swapper_pg_dir, KERNEL_RAM_VADDR - SWAPPER_DIR_SIZE
> > @@ -384,6 +384,20 @@ ENDPROC(__calc_phys_offset)
> >  	.endm
> >  
> >  /*
> > + * Macro to populate the PUD for the corresponding block entry in the next
> > + * level (tbl) for the given virtual address.
> > + *
> > + * Preserves:	pud, tbl, virt
> > + * Corrupts:	tmp1, tmp2
> > + */
> > +	.macro create_pud_entry, pud, tbl, virt, tmp1, tmp2
> > +	lsr	\tmp1, \virt, #PUD_SHIFT
> > +	and	\tmp1, \tmp1, #PTRS_PER_PUD - 1	// PUD index
> > +	orr	\tmp2, \tbl, #3			// PUD entry table type
> > +	str	\tmp2, [\pud, \tmp1, lsl #3]
> > +	.endm
> > +
> > +/*
> >   * Macro to populate block entries in the page table for the start..end
> >   * virtual range (inclusive).
> >   *
> > @@ -445,10 +459,18 @@ __create_page_tables:
> >  	ldr	x3, =KERNEL_START
> >  	add	x3, x3, x28			// __pa(KERNEL_START)
> >  	create_pgd_entry x25, x0, x3, x5, x6
> > +#ifdef CONFIG_ARM64_4_LEVELS
> > +	add	x1, x0, #PAGE_SIZE
> > +	create_pud_entry x0, x1, x3, x5, x6
> > +#endif
> >  	ldr	x6, =KERNEL_END
> >  	mov	x5, x3				// __pa(KERNEL_START)
> >  	add	x6, x6, x28			// __pa(KERNEL_END)
> > +#ifndef CONFIG_ARM64_4_LEVELS
> >  	create_block_map x0, x7, x3, x5, x6
> > +#else
> > +	create_block_map x1, x7, x3, x5, x6
> > +#endif
> >  
> >  	/*
> >  	 * Map the kernel image (starting with PHYS_OFFSET).
> > @@ -456,9 +478,17 @@ __create_page_tables:
> >  	add	x0, x26, #PAGE_SIZE		// section table address
> >  	mov	x5, #PAGE_OFFSET
> >  	create_pgd_entry x26, x0, x5, x3, x6
> > +#ifdef CONFIG_ARM64_4_LEVELS
> > +	add	x1, x0, #PAGE_SIZE
> > +	create_pud_entry x0, x1, x3, x5, x6
> > +#endif
> >  	ldr	x6, =KERNEL_END
> >  	mov	x3, x24				// phys offset
> > +#ifndef CONFIG_ARM64_4_LEVELS
> >  	create_block_map x0, x7, x3, x5, x6
> > +#else
> > +	create_block_map x1, x7, x3, x5, x6
> > +#endif
> >  
> >  	/*
> >  	 * Map the FDT blob (maximum 2MB; must be within 512MB of
> > @@ -474,14 +504,25 @@ __create_page_tables:
> >  	add	x5, x5, x6			// __va(FDT blob)
> >  	add	x6, x5, #1 << 21		// 2MB for the FDT blob
> >  	sub	x6, x6, #1			// inclusive range
> > +#ifndef CONFIG_ARM64_4_LEVELS
> >  	create_block_map x0, x7, x3, x5, x6
> > +#else
> > +	create_block_map x1, x7, x3, x5, x6
> > +#endif
> >  1:
> >  	/*
> >  	 * Create the pgd entry for the fixed mappings.
> >  	 */
> >  	ldr	x5, =FIXADDR_TOP		// Fixed mapping virtual address
> > +#ifndef CONFIG_ARM64_4_LEVELS
> >  	add	x0, x26, #2 * PAGE_SIZE		// section table address
> >  	create_pgd_entry x26, x0, x5, x6, x7
> > +#else
> > +	add	x0, x26, #PAGE_SIZE
> > +	create_pgd_entry x26, x0, x5, x6, x7
> > +	add	x1, x0, #2 * PAGE_SIZE
> > +	create_pud_entry x0, x1, x5, x6, x7
> > +#endif
> 
> So we essentially need an extra page for PUD mappings for both the
> idmap and swapper mappings. Could the logic of create_pgd_entry be
> adapted to call create_pud_entry for 4levels? That way a lot of #ifdefs
> can be eliminated.
> 

I forgot to mention, create_pgd_entry could also return the address that is
then used as the first argument of create_block_map, that would further
simplify the 4 level logic.
