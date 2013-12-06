Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759Ab3LFMVQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 07:21:16 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:41215 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753035Ab3LFMVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 07:21:14 -0500
Date: Fri, 6 Dec 2013 12:20:09 +0000
From: Will Deacon <will.deacon@arm.com>
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "linaro-uefi@linaro.org" <linaro-uefi@lists.linaro.org>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "patches@linaro.org" <patches@linaro.org>,
        "roy.franz@linaro.org" <roy.franz@linaro.org>,
        "msalter@redhat.com" <msalter@redhat.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>
Subject: Re: [PATCH v3 2/3] arm: Add [U]EFI runtime services support
Message-ID: <20131206122009.GF16079@mudshark.cambridge.arm.com>
References: <1385656883-4420-1-git-send-email-leif.lindholm@linaro.org>
 <1385656883-4420-3-git-send-email-leif.lindholm@linaro.org>
 <20131129161015.GE31000@mudshark.cambridge.arm.com>
 <20131129174303.GV24997@rocoto.smurfnet.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131129174303.GV24997@rocoto.smurfnet.nu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Leif,

Sorry it took so long to get back to you on this...

On Fri, Nov 29, 2013 at 05:43:04PM +0000, Leif Lindholm wrote:
> > > + */
> > > +static void __init phys_call_prologue(void)
> > > +{
> > > +       local_irq_disable();
> > > +
> > > +       /* Take out a flat memory mapping. */
> > > +       setup_mm_for_reboot();
> > > +
> > > +       /* Clean and invalidate caches */
> > > +       flush_cache_all();
> > > +
> > > +       /* Turn off caching */
> > > +       cpu_proc_fin();
> > > +
> > > +       /* Push out any further dirty data, and ensure cache is empty */
> > > +       flush_cache_all();
> >
> > Do we care about outer caches here?
> 
> I think we do. We jump into UEFI and make it relocate itself to the
> new virtual addresses, with MMU disabled (so all accesses NC).

Ok, so that means you need some calls to the outer_* cache ops.

> > This all looks suspiciously like
> > copy-paste from __soft_restart;
> 
> Yeah, 'cause you told me to :)
> 
> > perhaps some refactoring/reuse is in order?
> 
> Could do. Turn this into a process.c:idcall_prepare(), or something less
> daftly named?

Sure, something like that (can't think of a good name either, right
now...).

> > > + * Restore original memory map and re-enable interrupts.
> > > + */
> > > +static void __init phys_call_epilogue(void)
> > > +{
> > > +       static struct mm_struct *mm = &init_mm;
> > > +
> > > +       /* Restore original memory mapping */
> > > +       cpu_switch_mm(mm->pgd, mm);
> > > +
> > > +       /* Flush branch predictor and TLBs */
> > > +       local_flush_bp_all();
> > > +#ifdef CONFIG_CPU_HAS_ASID
> > > +       local_flush_tlb_all();
> > > +#endif
> >
> > ... and this looks like copy-paste from setup_mm_for_reboot.
> 
> You told me that too!

Hehe, I don't recall the conversation but I was probably talking in terms of
`let's get something working, then tidy it up afterwards'.

> Only this goes the other way.
> 
> Is the refactoring worth the extra code?

I think so. This code is pretty subtle, and I don't like it getting copied
around, particularly if we have to fix issues in it later on.

> > > +       local_irq_enable();
> > > +}
> > > +
> > > +static int __init remap_region(efi_memory_desc_t *md, efi_memory_desc_t *entry)
> > > +{
> > > +       u64 va;
> > > +       u64 paddr;
> > > +       u64 size;
> > > +
> > > +       *entry = *md;
> > > +       paddr = entry->phys_addr;
> > > +       size = entry->num_pages << EFI_PAGE_SHIFT;
> > > +
> > > +       /*
> > > +        * Map everything writeback-capable as coherent memory,
> > > +        * anything else as device.
> > > +        */
> > > +       if (md->attribute & EFI_MEMORY_WB)
> > > +               va = (u64)((u32)uefi_remap(paddr, size) & 0xffffffffUL);
> > > +       else
> > > +               va = (u64)((u32)uefi_ioremap(paddr, size) & 0xffffffffUL);
> >
> > Do you really need all those casts/masking?
> 
> I didn't find a better way to avoid warnings when building this code
> for both LPAE/non-LPAE.

Hmm, well phys_addr_t will be appropriately sized, if that helps you.

> > > + * This function switches the UEFI runtime services to virtual mode.
> > > + * This operation must be performed only once in the system's lifetime,
> > > + * including any kecec calls.
> > > + *
> > > + * This must be done with a 1:1 mapping. The current implementation
> > > + * resolves this by disabling the MMU.
> > > + */
> > > +efi_status_t  __init phys_set_virtual_address_map(u32 memory_map_size,
> > > +                                                 u32 descriptor_size,
> > > +                                                 u32 descriptor_version,
> > > +                                                 efi_memory_desc_t *dsc)
> > > +{
> > > +       uefi_phys_call_t *phys_set_map;
> > > +       efi_status_t status;
> > > +
> > > +       phys_call_prologue();
> > > +
> > > +       phys_set_map = (void *)(unsigned long)virt_to_phys(uefi_phys_call);
> > > +
> > > +       /* Called with caches disabled, returns with caches enabled */
> > > +       status = phys_set_map(memory_map_size, descriptor_size,
> > > +                             descriptor_version, dsc,
> > > +                             efi.set_virtual_address_map)
> > > +;
> >
> > Guessing this relies on a physically-tagged cache? Wouldn't hurt to put
> > something in the epilogue code to deal with vivt caches if they're not
> > prohibited by construction (e.g. due to some build dependency magic).
> 
> Sorry, I don't quite follow?
> How would it depend on a physically-tagged cache?

I was wondering if you could run into issues in the epilogue, since you've
changed page tables without cleaning the cache, but actually cpu_switch_mm
takes care of that.

> > > +       phys_call_epilogue();
> > > +
> > > +       return status;
> > > +}
> 
> 
> > > diff --git a/arch/arm/kernel/uefi_phys.S b/arch/arm/kernel/uefi_phys.S
> > > new file mode 100644
> > > index 0000000..e9a1542
> > > --- /dev/null
> > > +++ b/arch/arm/kernel/uefi_phys.S
> > > @@ -0,0 +1,59 @@
> > > +/*
> > > + * arch/arm/kernel/uefi_phys.S
> > > + *
> > > + * Copyright (C) 2013  Linaro Ltd.
> > > + *
> > > + * This program is free software; you can redistribute it and/or modify
> > > + * it under the terms of the GNU General Public License version 2 as
> > > + * published by the Free Software Foundation.
> > > + */
> > > +
> > > +#include <linux/linkage.h>
> > > +#define PAR_MASK 0xfff
> > > +
> > > +       .text
> > > +@ uefi_phys_call(a, b, c, d, *f)
> > > +       .align  5
> > > +        .pushsection    .idmap.text, "ax"
> > > +ENTRY(uefi_phys_call)
> > > +       @ Save physical context
> > > +       mov     r12, sp
> > > +       push    {r4-r5, r12, lr}
> > > +
> > > +       @ Extract function pointer (don't write r12 beyond this)
> > > +       ldr     r12, [sp, #16]
> > > +
> > > +       @ Convert sp to 32-bit physical
> > > +       mov     lr, sp
> > > +       ldr     r4, =PAR_MASK
> > > +       and     r5, lr, r4                      @ Extract lower 12 bits of sp
> > > +       mcr     p15, 0, lr, c7, c8, 1           @ Write VA -> ATS1CPW
> >
> > This is broken without an isb but, more to the point, why can't we just do
> > the standard lowmem virt_to_phys conversion here instead?
> 
> I can't use that from within asm (right?). Are you suggesting that I
> should duplicate the mechanism of virt_to_phys here?

I think you need an extra argument: either the physical SP, or the virt->
phys offset.

> > > +       mrc     p15, 0, lr, c7, c4, 0           @ Physical Address Register
> > > +       mvn     r4, r4
> > > +       and     lr, lr, r4                      @ Clear lower 12 bits of PA
> > > +       add     lr, lr, r5                      @ Calculate phys sp
> > > +       mov     sp, lr                          @ Update
> > > +
> > > +       @ Disable MMU
> > > +        mrc     p15, 0, lr, c1, c0, 0           @ ctrl register
> > > +        bic     lr, lr, #0x1                    @ ...............m
> > > +        mcr     p15, 0, lr, c1, c0, 0           @ disable MMU
> > > +       isb
> > > +
> > > +       @ Make call
> > > +       blx     r12
> >
> > This is basically a copy-paste of cpu_v7_reset. Perhaps using some assembler
> > macros would help here?
> 
> Well, I explicitly don't want to touch SCTLR.TE.
> We could macro-ize it, but I think that would increase the amount of
> code.

How would using a macro increase the amount of code? Just make the macro
take the bits to clear and the bits to set as arguments.

> > > +
> > > +       pop     {r4-r5, r12, lr}
> > > +
> > > +       @ Enable MMU + Caches
> > > +        mrc     p15, 0, r1, c1, c0, 0          @ ctrl register
> > > +        orr     r1, r1, #0x1000                        @ ...i............
> > > +        orr     r1, r1, #0x0005                        @ .............c.m
> > > +        mcr     p15, 0, r1, c1, c0, 0          @ enable MMU
> > > +       isb
> >
> > Why do we have to enable the caches so early?
> 
> You'd prefer it being done back in phys_call_epilogue()?

Unless there's a good reason to move stuff into early assembly, it would be
better off using functions/macros from C code imo.

Will
