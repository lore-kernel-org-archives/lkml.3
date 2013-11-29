Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932230Ab3K2QMV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 11:12:21 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:51193 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751937Ab3K2QMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 11:12:16 -0500
Date: Fri, 29 Nov 2013 16:10:16 +0000
From: Will Deacon <will.deacon@arm.com>
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "linaro-uefi@linaro.org" <linaro-uefi@linaro.org>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "patches@linaro.org" <patches@linaro.org>,
        "roy.franz@linaro.org" <roy.franz@linaro.org>,
        "msalter@redhat.com" <msalter@redhat.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>
Subject: Re: [PATCH v3 2/3] arm: Add [U]EFI runtime services support
Message-ID: <20131129161015.GE31000@mudshark.cambridge.arm.com>
References: <1385656883-4420-1-git-send-email-leif.lindholm@linaro.org>
 <1385656883-4420-3-git-send-email-leif.lindholm@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385656883-4420-3-git-send-email-leif.lindholm@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Leif,

On Thu, Nov 28, 2013 at 04:41:22PM +0000, Leif Lindholm wrote:
> This patch implements basic support for UEFI runtime services in the
> ARM architecture - a requirement for using efibootmgr to read and update
> the system boot configuration.
> 
> It uses the generic configuration table scanning to populate ACPI and
> SMBIOS pointers.

I've got a bunch of implementation questions, so hopefully you can help me
to understand what this is doing!

> diff --git a/arch/arm/kernel/uefi.c b/arch/arm/kernel/uefi.c
> new file mode 100644
> index 0000000..f771026
> --- /dev/null
> +++ b/arch/arm/kernel/uefi.c
> @@ -0,0 +1,469 @@
> +/*
> + * Based on Unified Extensible Firmware Interface Specification version 2.3.1
> + *
> + * Copyright (C) 2013  Linaro Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/efi.h>
> +#include <linux/export.h>
> +#include <linux/memblock.h>
> +#include <linux/of.h>
> +#include <linux/of_fdt.h>
> +#include <linux/sched.h>
> +#include <linux/slab.h>
> +
> +#include <asm/cacheflush.h>
> +#include <asm/idmap.h>
> +#include <asm/tlbflush.h>
> +#include <asm/uefi.h>
> +
> +struct efi_memory_map memmap;
> +
> +static efi_runtime_services_t *runtime;
> +
> +static phys_addr_t uefi_system_table;
> +static phys_addr_t uefi_boot_mmap;
> +static u32 uefi_boot_mmap_size;
> +static u32 uefi_mmap_desc_size;
> +static u32 uefi_mmap_desc_ver;
> +
> +static unsigned long arm_uefi_facility;
> +
> +/*
> + * If you're planning to wire up a debugger and debug the UEFI side ...
> + */
> +#undef KEEP_ALL_REGIONS
> +
> +/*
> + * If you need to (temporarily) support buggy firmware.
> + */
> +#define KEEP_BOOT_SERVICES_REGIONS
> +
> +/*
> + * Returns 1 if 'facility' is enabled, 0 otherwise.
> + */
> +int efi_enabled(int facility)
> +{
> +       return test_bit(facility, &arm_uefi_facility) != 0;

!test_bit(...) ?

> +static int __init uefi_init(void)
> +{
> +       efi_char16_t *c16;
> +       char vendor[100] = "unknown";
> +       int i, retval;
> +
> +       efi.systab = early_memremap(uefi_system_table,
> +                                   sizeof(efi_system_table_t));
> +
> +       /*
> +        * Verify the UEFI System Table
> +        */
> +       if (efi.systab == NULL)
> +               panic("Whoa! Can't find UEFI system table.\n");
> +       if (efi.systab->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
> +               panic("Whoa! UEFI system table signature incorrect\n");
> +       if ((efi.systab->hdr.revision >> 16) == 0)
> +               pr_warn("Warning: UEFI system table version %d.%02d, expected 1.00 or greater\n",
> +                       efi.systab->hdr.revision >> 16,
> +                       efi.systab->hdr.revision & 0xffff);
> +
> +       /* Show what we know for posterity */
> +       c16 = (efi_char16_t *)early_memremap(efi.systab->fw_vendor,
> +                                           sizeof(vendor));
> +       if (c16) {
> +               for (i = 0; i < (int) sizeof(vendor) - 1 && *c16; ++i)
> +                       vendor[i] = c16[i];
> +               vendor[i] = '\0';
> +       }
> +
> +       pr_info("UEFI v%u.%.02u by %s\n",
> +               efi.systab->hdr.revision >> 16,
> +               efi.systab->hdr.revision & 0xffff, vendor);
> +
> +       retval = efi_config_init(NULL);
> +       if (retval == 0)
> +               set_bit(EFI_CONFIG_TABLES, &arm_uefi_facility);

Does this actually need to be atomic?

> +
> +       early_iounmap(c16, sizeof(vendor));
> +       early_iounmap(efi.systab,  sizeof(efi_system_table_t));
> +
> +       return retval;
> +}
> +
> +static __init int is_discardable_region(efi_memory_desc_t *md)
> +{
> +#ifdef KEEP_ALL_REGIONS
> +       return 0;
> +#endif

Maybe just have a dummy is_discardable_region in this case, like we usually
do instead of inlining the #ifdef?

> +       if (md->attribute & EFI_MEMORY_RUNTIME)
> +               return 0;
> +
> +       switch (md->type) {
> +#ifdef KEEP_BOOT_SERVICES_REGIONS
> +       case EFI_BOOT_SERVICES_CODE:
> +       case EFI_BOOT_SERVICES_DATA:
> +#endif
> +       /* Keep tables around for any future kexec operations */
> +       case EFI_ACPI_RECLAIM_MEMORY:
> +               return 0;
> +       /* Preserve */
> +       case EFI_RESERVED_TYPE:
> +               return 0;
> +       }
> +
> +       return 1;
> +}

[...]

> +int __init uefi_memblock_arm_reserve_range(void)
> +{
> +       if (!of_scan_flat_dt(fdt_find_uefi_params, NULL))
> +               return 0;
> +
> +       set_bit(EFI_BOOT, &arm_uefi_facility);

Similar comment wrt atomicity here (and in the rest of this patch).

> +       uefi_init();
> +
> +       remove_regions();
> +
> +       return 0;
> +}
> +
> +/*
> + * Disable instrrupts, enable idmap and disable caches.

interrupts

> + */
> +static void __init phys_call_prologue(void)
> +{
> +       local_irq_disable();
> +
> +       /* Take out a flat memory mapping. */
> +       setup_mm_for_reboot();
> +
> +       /* Clean and invalidate caches */
> +       flush_cache_all();
> +
> +       /* Turn off caching */
> +       cpu_proc_fin();
> +
> +       /* Push out any further dirty data, and ensure cache is empty */
> +       flush_cache_all();

Do we care about outer caches here? This all looks suspiciously like
copy-paste from __soft_restart; perhaps some refactoring/reuse is in order?

> +}
> +
> +/*
> + * Restore original memory map and re-enable interrupts.
> + */
> +static void __init phys_call_epilogue(void)
> +{
> +       static struct mm_struct *mm = &init_mm;
> +
> +       /* Restore original memory mapping */
> +       cpu_switch_mm(mm->pgd, mm);
> +
> +       /* Flush branch predictor and TLBs */
> +       local_flush_bp_all();
> +#ifdef CONFIG_CPU_HAS_ASID
> +       local_flush_tlb_all();
> +#endif

... and this looks like copy-paste from setup_mm_for_reboot.

> +       local_irq_enable();
> +}
> +
> +static int __init remap_region(efi_memory_desc_t *md, efi_memory_desc_t *entry)
> +{
> +       u64 va;
> +       u64 paddr;
> +       u64 size;
> +
> +       *entry = *md;
> +       paddr = entry->phys_addr;
> +       size = entry->num_pages << EFI_PAGE_SHIFT;
> +
> +       /*
> +        * Map everything writeback-capable as coherent memory,
> +        * anything else as device.
> +        */
> +       if (md->attribute & EFI_MEMORY_WB)
> +               va = (u64)((u32)uefi_remap(paddr, size) & 0xffffffffUL);
> +       else
> +               va = (u64)((u32)uefi_ioremap(paddr, size) & 0xffffffffUL);

Do you really need all those casts/masking?

> +       if (!va)
> +               return 0;
> +       entry->virt_addr = va;
> +
> +       if (uefi_debug)
> +               pr_info("  %016llx-%016llx => 0x%08x : (%s)\n",
> +                       paddr, paddr + size - 1, (u32)va,
> +                       md->attribute &  EFI_MEMORY_WB ? "WB" : "I/O");
> +
> +       return 1;
> +}
> +
> +static int __init remap_regions(void)
> +{
> +       void *p, *next;
> +       efi_memory_desc_t *md;
> +
> +       memmap.phys_map = uefi_remap(uefi_boot_mmap, uefi_boot_mmap_size);
> +       if (!memmap.phys_map)
> +               return 0;
> +       memmap.map_end = (void *)memmap.phys_map + uefi_boot_mmap_size;
> +       memmap.desc_size = uefi_mmap_desc_size;
> +       memmap.desc_version = uefi_mmap_desc_ver;
> +
> +       /* Allocate space for the physical region map */
> +       memmap.map = kzalloc(memmap.nr_map * memmap.desc_size, GFP_KERNEL);
> +       if (!memmap.map)
> +               return 0;
> +
> +       next = memmap.map;
> +       for (p = memmap.phys_map; p < memmap.map_end; p += memmap.desc_size) {
> +               md = p;
> +               if (is_discardable_region(md) || md->type == EFI_RESERVED_TYPE)
> +                       continue;
> +
> +               if (!remap_region(p, next))
> +                       return 0;

What about the kzalloc above, does that need freeing?

> +
> +               next += memmap.desc_size;
> +       }
> +
> +       memmap.map_end = next;
> +       efi.memmap = &memmap;
> +
> +       uefi_unmap(memmap.phys_map);
> +       memmap.phys_map = efi_lookup_mapped_addr(uefi_boot_mmap);
> +       efi.systab = efi_lookup_mapped_addr(uefi_system_table);
> +       if (efi.systab)
> +               set_bit(EFI_SYSTEM_TABLES, &arm_uefi_facility);
> +       /*
> +        * efi.systab->runtime is a 32-bit pointer to something guaranteed by
> +        * the UEFI specification to be 1:1 mapped in a 4GB address space.
> +        */
> +       runtime = efi_lookup_mapped_addr((u32)efi.systab->runtime);
> +
> +       return 1;
> +}
> +
> +
> +/*
> + * This function switches the UEFI runtime services to virtual mode.
> + * This operation must be performed only once in the system's lifetime,
> + * including any kecec calls.
> + *
> + * This must be done with a 1:1 mapping. The current implementation
> + * resolves this by disabling the MMU.
> + */
> +efi_status_t  __init phys_set_virtual_address_map(u32 memory_map_size,
> +                                                 u32 descriptor_size,
> +                                                 u32 descriptor_version,
> +                                                 efi_memory_desc_t *dsc)
> +{
> +       uefi_phys_call_t *phys_set_map;
> +       efi_status_t status;
> +
> +       phys_call_prologue();
> +
> +       phys_set_map = (void *)(unsigned long)virt_to_phys(uefi_phys_call);
> +
> +       /* Called with caches disabled, returns with caches enabled */
> +       status = phys_set_map(memory_map_size, descriptor_size,
> +                             descriptor_version, dsc,
> +                             efi.set_virtual_address_map)
> +;

Guessing this relies on a physically-tagged cache? Wouldn't hurt to put
something in the epilogue code to deal with vivt caches if they're not
prohibited by construction (e.g. due to some build dependency magic).

> +       phys_call_epilogue();
> +
> +       return status;
> +}
> +
> +/*
> + * Called explicitly from init/mm.c
> + */
> +void __init efi_enter_virtual_mode(void)
> +{
> +       efi_status_t status;
> +
> +       if (!efi_enabled(EFI_BOOT)) {
> +               pr_info("UEFI services will not be available.\n");
> +               return;
> +       }
> +
> +       pr_info("Remapping and enabling UEFI services.\n");
> +
> +       /* Map the regions we memblock_remove:d earlier into kernel
> +          address space */
> +       if (!remap_regions()) {
> +               pr_info("Failed to remap UEFI regions - runtime services will not be available.\n");
> +               return;
> +       }
> +
> +       /* Call SetVirtualAddressMap with the physical address of the map */
> +       efi.set_virtual_address_map =
> +               (efi_set_virtual_address_map_t *)
> +               runtime->set_virtual_address_map;
> +       memmap.phys_map =
> +               (efi_memory_desc_t *)(u32) __virt_to_phys((u32)memmap.map);
> +
> +       status = phys_set_virtual_address_map(memmap.nr_map * memmap.desc_size,
> +                                             memmap.desc_size,
> +                                             memmap.desc_version,
> +                                             memmap.phys_map);
> +
> +       if (status != EFI_SUCCESS) {
> +               pr_info("Failed to set UEFI virtual address map!\n");
> +               return;
> +       }
> +
> +       /* Set up function pointers for efivars */
> +       efi.get_variable = (efi_get_variable_t *)runtime->get_variable;
> +       efi.get_next_variable =
> +               (efi_get_next_variable_t *)runtime->get_next_variable;
> +       efi.set_variable = (efi_set_variable_t *)runtime->set_variable;
> +       set_bit(EFI_RUNTIME_SERVICES, &arm_uefi_facility);
> +}
> diff --git a/arch/arm/kernel/uefi_phys.S b/arch/arm/kernel/uefi_phys.S
> new file mode 100644
> index 0000000..e9a1542
> --- /dev/null
> +++ b/arch/arm/kernel/uefi_phys.S
> @@ -0,0 +1,59 @@
> +/*
> + * arch/arm/kernel/uefi_phys.S
> + *
> + * Copyright (C) 2013  Linaro Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/linkage.h>
> +#define PAR_MASK 0xfff
> +
> +       .text
> +@ uefi_phys_call(a, b, c, d, *f)
> +       .align  5
> +        .pushsection    .idmap.text, "ax"
> +ENTRY(uefi_phys_call)
> +       @ Save physical context
> +       mov     r12, sp
> +       push    {r4-r5, r12, lr}
> +
> +       @ Extract function pointer (don't write r12 beyond this)
> +       ldr     r12, [sp, #16]
> +
> +       @ Convert sp to 32-bit physical
> +       mov     lr, sp
> +       ldr     r4, =PAR_MASK
> +       and     r5, lr, r4                      @ Extract lower 12 bits of sp
> +       mcr     p15, 0, lr, c7, c8, 1           @ Write VA -> ATS1CPW

This is broken without an isb but, more to the point, why can't we just do
the standard lowmem virt_to_phys conversion here instead?

> +       mrc     p15, 0, lr, c7, c4, 0           @ Physical Address Register
> +       mvn     r4, r4
> +       and     lr, lr, r4                      @ Clear lower 12 bits of PA
> +       add     lr, lr, r5                      @ Calculate phys sp
> +       mov     sp, lr                          @ Update
> +
> +       @ Disable MMU
> +        mrc     p15, 0, lr, c1, c0, 0           @ ctrl register
> +        bic     lr, lr, #0x1                    @ ...............m
> +        mcr     p15, 0, lr, c1, c0, 0           @ disable MMU
> +       isb
> +
> +       @ Make call
> +       blx     r12

This is basically a copy-paste of cpu_v7_reset. Perhaps using some assembler
macros would help here?

> +
> +       pop     {r4-r5, r12, lr}
> +
> +       @ Enable MMU + Caches
> +        mrc     p15, 0, r1, c1, c0, 0          @ ctrl register
> +        orr     r1, r1, #0x1000                        @ ...i............
> +        orr     r1, r1, #0x0005                        @ .............c.m
> +        mcr     p15, 0, r1, c1, c0, 0          @ enable MMU
> +       isb

Why do we have to enable the caches so early?

Will
