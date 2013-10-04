Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047Ab3JDQIJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 12:08:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13548 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754395Ab3JDQIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 12:08:07 -0400
Message-ID: <1380902861.17503.57.camel@deneb.redhat.com>
Subject: Re: [PATCH] arm64: add early_ioremap support
From: Mark Salter <msalter@redhat.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Fri, 04 Oct 2013 12:07:41 -0400
In-Reply-To: <20131004150453.GG25137@arm.com>
References: <1380890819-27831-1-git-send-email-msalter@redhat.com>
	 <20131004150453.GG25137@arm.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-10-04 at 16:04 +0100, Catalin Marinas wrote:
> Hi Mark,
> 
> > --- /dev/null
> > +++ b/arch/arm64/include/asm/fixmap.h
> > @@ -0,0 +1,117 @@
> > +/*
> > + * fixmap.h: compile-time virtual memory allocation
> > + *
> > + * This file is subject to the terms and conditions of the GNU General Public
> > + * License.  See the file "COPYING" in the main directory of this archive
> > + * for more details.
> > + *
> > + * Copyright (C) 1998 Ingo Molnar
> > + *
> > + */
> 
> I can see several architectures having very similar macros/functions in
> fixmap.h. It would make sense to create a generic fixmap.h holding at
> least the fix_to_virt and related macros, FIXADDR_START etc. with enum
> fixed_addresses in arch code.

Right, there are a quite a few using similar fixmap code. I actually 
looked at consolidating them, but I gave up so that I could get
something working for EFI work in progress. But yeah, I think I
will step back and have another go at it. I think I can get at a
few of the architectures using common code and make it so others
can be converted as desired.

> 
> > --- a/arch/arm64/kernel/setup.c
> > +++ b/arch/arm64/kernel/setup.c
> > @@ -42,6 +42,7 @@
> >  #include <linux/of_fdt.h>
> >  #include <linux/of_platform.h>
> > 
> > +#include <asm/fixmap.h>
> >  #include <asm/cputype.h>
> >  #include <asm/elf.h>
> >  #include <asm/cputable.h>
> > @@ -252,6 +253,8 @@ void __init setup_arch(char **cmdline_p)
> > 
> >         *cmdline_p = boot_command_line;
> > 
> > +       early_ioremap_init();
> > +
> >         parse_early_param();
> 
> Should the early_ioremap_init() call happen after parse_early_param()?
> Is early_ioremap_debug initialised already?

No, early_ioremap_debug is not initialized which makes the debug
prints in early_ioremap_init() unreachable. I'll fix that. On x86,
the init comes first, but there is other code between that and
parse_early_param() which uses early_ioremap(). Not the case for
arm64.

> 
> > --- a/arch/arm64/mm/ioremap.c
> > +++ b/arch/arm64/mm/ioremap.c
> > @@ -25,6 +25,10 @@
> >  #include <linux/vmalloc.h>
> >  #include <linux/io.h>
> > 
> > +#include <asm/fixmap.h>
> > +#include <asm/tlbflush.h>
> > +#include <asm/pgalloc.h>
> > +
> >  static void __iomem *__ioremap_caller(phys_addr_t phys_addr, size_t size,
> >                                       pgprot_t prot, void *caller)
> >  {
> > @@ -82,3 +86,284 @@ void __iounmap(volatile void __iomem *io_addr)
> >         vunmap(addr);
> >  }
> >  EXPORT_SYMBOL(__iounmap);
> > +
> > +static int early_ioremap_debug __initdata;
> > +
> > +static int __init early_ioremap_debug_setup(char *str)
> > +{
> > +       early_ioremap_debug = 1;
> > +
> > +       return 0;
> > +}
> > +early_param("early_ioremap_debug", early_ioremap_debug_setup);
> > +
> > +static int after_paging_init __initdata;
> > +#ifndef CONFIG_ARM64_64K_PAGES
> > +static pte_t bm_pte[PAGE_SIZE/sizeof(pte_t)] __page_aligned_bss;
> > +#endif
> 
> bm_pte[PTRS_PER_PTE];

ok

> 
> > +
> > +static inline pmd_t * __init early_ioremap_pmd(unsigned long addr)
> > +{
> > +       pgd_t *pgd = &swapper_pg_dir[pgd_index(addr)];
> 
> pgd_offset_k(addr);

ok

> 
> > +       pud_t *pud = pud_offset(pgd, addr);
> > +       pmd_t *pmd = pmd_offset(pud, addr);
> > +
> > +       return pmd;
> > +}
> > +
> > +static inline pte_t * __init early_ioremap_pte(unsigned long addr)
> > +{
> > +#ifdef CONFIG_ARM64_64K_PAGES
> > +       pmd_t *pmd = early_ioremap_pmd(addr);
> > +       return pte_offset_kernel(pmd, addr);
> > +#else
> > +       return &bm_pte[pte_index(addr)];
> > +#endif
> 
> If we populate the pmd correctly with 4K pages (and I think we do in
> early_ioremap_init()), can we not just use this function without the
> #ifdef-else part (always pte_offset_kernel())?

Ah, yes. Nice!

> 
> > +static unsigned long slot_virt[FIX_BTMAPS_SLOTS] __initdata;
> > +
> > +void __init early_ioremap_init(void)
> > +{
> > +       pmd_t *pmd;
> > +       int i;
> > +
> > +       if (early_ioremap_debug)
> > +               pr_info("early_ioremap_init()\n");
> > +
> > +       for (i = 0; i < FIX_BTMAPS_SLOTS; i++)
> > +               slot_virt[i] = __fix_to_virt(FIX_BTMAP_BEGIN - NR_FIX_BTMAPS*i);
> > +
> > +       pmd = early_ioremap_pmd(fix_to_virt(FIX_BTMAP_BEGIN));
> > +#ifndef CONFIG_ARM64_64K_PAGES
> > +       /* need to populate pmd for 4k pagesize only */
> > +       memset(bm_pte, 0, sizeof(bm_pte));
> 
> Do we need memset() here? bm_pte[] is placed in the .bss section.

No we don't. If .bss isn't cleared here, we have bigger problems.

> 
> > +       pmd_populate_kernel(&init_mm, pmd, bm_pte);
> > +#endif
> > +
> > +       /*
> > +        * The boot-ioremap range spans multiple pmds, for which
> > +        * we are not prepared:
> > +        */
> > +#define __FIXADDR_TOP (-PAGE_SIZE)
> > +       BUILD_BUG_ON((__fix_to_virt(FIX_BTMAP_BEGIN) >> PMD_SHIFT)
> > +                    != (__fix_to_virt(FIX_BTMAP_END) >> PMD_SHIFT));
> > +#undef __FIXADDR_TOP
> 
> Why this #define/#undef? FIXADDR_TOP is statically defined.

Right. Copy and paste from x86 where is isn't static, so the trick to
trigger a BUILD_BUG_ON isn't needed here.

> 
> > +void __init __set_fixmap(enum fixed_addresses idx,
> > +                        phys_addr_t phys, pgprot_t flags)
> > +{
> > +       unsigned long addr = __fix_to_virt(idx);
> > +       pte_t *pte;
> > +
> > +       if (idx >= __end_of_fixed_addresses) {
> > +               BUG();
> > +               return;
> > +       }
> > +       if (after_paging_init) {
> > +               WARN_ON(1);
> > +               return;
> > +       }
> > +
> > +       pte = early_ioremap_pte(addr);
> > +
> > +       if (pgprot_val(flags))
> > +               set_pte(pte, pfn_pte(phys >> PAGE_SHIFT, flags));
> > +       else
> > +               pte_clear(&init_mm, addr, pte);
> > +       flush_tlb_kernel_range(addr, addr+PAGE_SIZE);
> 
> Would __set_fixmap be used to change valid ptes? If not, we could keep
> the flush_tlb_kernel_range() call only under the 'else' block.

A valid pte shouldn't be updated except for the unmap case. Nothing
prevents it though. We could do the tlb flush only in the else block
and add a BUG_ON to catch attempts to modify an already used pte.

> 
> As I was going through the patch, I realised that the early_ioremap()
> looks really to the x86 implementation. Can we move it into a library to
> be shared between the two?
> 
Yes, that's where I started. I will look at consolidating the common
bits.

Thanks.

--Mark


