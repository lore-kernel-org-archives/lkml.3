Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211AbaDNJdx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 05:33:53 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:39298 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbaDNJdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 05:33:50 -0400
Date: Mon, 14 Apr 2014 10:33:43 +0100
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
Message-ID: <20140414093342.GA14635@linaro.org>
References: <000501cf57b4$e57e8e80$b07bab80$@samsung.com>
 <20140414091424.GA14204@linaro.org>
 <000c01cf57c3$65afc110$310f4330$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000c01cf57c3$65afc110$310f4330$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 06:24:55PM +0900, Jungseok Lee wrote:
> On Monday, April 14, 2014 6:14 PM, Steve Capper wrote:
> > On Mon, Apr 13, 2014 at 04:41:07PM +0900, Jungseok Lee wrote:
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
> > 
> > Hi,
> > So I thought I'd apply this series and have a play, this patch doesn't apply cleanly for me, please
> > see below why...
> 
> This pathset is based on 3.15-rc1.

Thanks, yes that applies cleanly for me now.

> 
> > [ ... ]
> > 
> > > diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S index
> > > 0fd5650..0b0b16a 100644
> > > --- a/arch/arm64/kernel/head.S
> > > +++ b/arch/arm64/kernel/head.S
> > > @@ -46,8 +46,8 @@
> > >  #error KERNEL_RAM_VADDR must start at 0xXXX80000  #endif
> > >
> > > -#define SWAPPER_DIR_SIZE	(3 * PAGE_SIZE)
> > > -#define IDMAP_DIR_SIZE		(2 * PAGE_SIZE)
> > > +#define SWAPPER_DIR_SIZE	(4 * PAGE_SIZE)
> > > +#define IDMAP_DIR_SIZE		(3 * PAGE_SIZE)
> > >
> > >  	.globl	swapper_pg_dir
> > >  	.equ	swapper_pg_dir, KERNEL_RAM_VADDR - SWAPPER_DIR_SIZE
> > > @@ -384,6 +384,20 @@ ENDPROC(__calc_phys_offset)
> > >  	.endm
> > >
> > >  /*
> > > + * Macro to populate the PUD for the corresponding block entry in the
> > > +next
> > > + * level (tbl) for the given virtual address.
> > > + *
> > > + * Preserves:	pud, tbl, virt
> > > + * Corrupts:	tmp1, tmp2
> > > + */
> > > +	.macro create_pud_entry, pud, tbl, virt, tmp1, tmp2
> > > +	lsr	\tmp1, \virt, #PUD_SHIFT
> > > +	and	\tmp1, \tmp1, #PTRS_PER_PUD - 1	// PUD index
> > > +	orr	\tmp2, \tbl, #3			// PUD entry table type
> > > +	str	\tmp2, [\pud, \tmp1, lsl #3]
> > > +	.endm
> > > +
> > > +/*
> > >   * Macro to populate block entries in the page table for the start..end
> > >   * virtual range (inclusive).
> > >   *
> > > @@ -445,10 +459,18 @@ __create_page_tables:
> > >  	ldr	x3, =KERNEL_START
> > >  	add	x3, x3, x28			// __pa(KERNEL_START)
> > 
> > I don't think we have C++ style comments in the kernel. Also, I can't see any references to
> > =KERNEL_START in arch/arm64/kernel/head.S (from 3.14 down).
> 
> C++ style comments are prevalent in arch/arm64/kernel/head.S. I've followed the
> code style written previously.

Apologies, my mistake, I've been staring at arch/arm too long where @ is used.

Cheers,
-- 
Steve
