Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068Ab3FZNqc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 09:46:32 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:33828 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab3FZNqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 09:46:30 -0400
MIME-Version: 1.0
In-Reply-To: <1372183863-11333-4-git-send-email-leif.lindholm@linaro.org>
References: <1372183863-11333-1-git-send-email-leif.lindholm@linaro.org> <1372183863-11333-4-git-send-email-leif.lindholm@linaro.org>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 26 Jun 2013 14:46:09 +0100
X-Google-Sender-Auth: bRXF8pYvuYCbzFPoiq8A2Nt96Y4
Message-ID: <CACxGe6sH4dAVryBp7TeUmrwsJmnMdLsQm++U4EVDJVNi9pnqYw@mail.gmail.com>
Subject: Re: [PATCH 3/4] arm: Add [U]EFI runtime services support
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-efi@vger.kernel.org,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, matt.fleming@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 7:11 PM, Leif Lindholm <leif.lindholm@linaro.org> wrote:
> This patch implements basic support for UEFI runtime services in the
> ARM architecture - a requirement for using efibootmgr to read and update
> the system boot configuration.
>
> It also locates any presented SMBIOS configuration table and stores it
> for potential later use by DMI.
>
> Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
> ---
>  arch/arm/Kconfig           |   15 ++
>  arch/arm/include/asm/efi.h |   22 +++
>  arch/arm/kernel/Makefile   |    2 +
>  arch/arm/kernel/efi.c      |  456 ++++++++++++++++++++++++++++++++++++++++++++
>  arch/arm/kernel/efi_phys.S |   59 ++++++
>  arch/arm/kernel/setup.c    |    5 +
>  6 files changed, 559 insertions(+)
>  create mode 100644 arch/arm/include/asm/efi.h
>  create mode 100644 arch/arm/kernel/efi.c
>  create mode 100644 arch/arm/kernel/efi_phys.S
>
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index bf8e55d..022d2eb 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -1763,6 +1763,19 @@ config EARLY_IOREMAP
>           Provides a mechanism for kernel initialisation code to temporarily
>           map, in a highmem-agnostic way, memory pages in before paging_init().
>
> +config EFI
> +bool "UEFI runtime service support"
> +       depends on OF
> +       select UCS2_STRING
> +       select EARLY_IOREMAP
> +       ---help---
> +         This enables the kernel to use UEFI runtime services that are
> +         available (such as the UEFI variable services).
> +
> +         This option is only useful on systems that have UEFI firmware.
> +         However, even with this option, the resultant kernel should

Be confident!  s/should/will/  :-)

> +         continue to boot on existing non-UEFI platforms.

s/existing//

> +
>  config SECCOMP
>         bool
>         prompt "Enable seccomp to safely compute untrusted bytecode"
> @@ -2217,6 +2230,8 @@ source "net/Kconfig"
>
>  source "drivers/Kconfig"
>
> +source "drivers/firmware/Kconfig"
> +
>  source "fs/Kconfig"
>
>  source "arch/arm/Kconfig.debug"
> diff --git a/arch/arm/include/asm/efi.h b/arch/arm/include/asm/efi.h
> new file mode 100644
> index 0000000..aead94c
> --- /dev/null
> +++ b/arch/arm/include/asm/efi.h
> @@ -0,0 +1,22 @@
> +#ifndef _ASM_ARM_EFI_H
> +#define _ASM_ARM_EFI_H
> +
> +#include <asm/mach/map.h>
> +
> +extern int efi_memblock_arm_reserve_range(void);
> +
> +typedef efi_status_t efi_phys_call_t(u32 memory_map_size,
> +                                    u32 descriptor_size,
> +                                    u32 descriptor_version,
> +                                    efi_memory_desc_t *dsc,
> +                                    efi_set_virtual_address_map_t *f);
> +
> +extern efi_status_t efi_phys_call(u32, u32, u32, efi_memory_desc_t *,
> +                                 efi_set_virtual_address_map_t *);
> +
> +#define efi_remap(cookie, size) __arm_ioremap((cookie), (size), MT_MEMORY)
> +#define efi_ioremap(cookie, size) __arm_ioremap((cookie), (size), MT_DEVICE)
> +#define efi_unmap(cookie) __arm_iounmap((cookie))
> +#define efi_iounmap(cookie) __arm_iounmap((cookie))
> +
> +#endif /* _ASM_ARM_EFI_H */
> diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
> index 5f3338e..12b9c30 100644
> --- a/arch/arm/kernel/Makefile
> +++ b/arch/arm/kernel/Makefile
> @@ -84,4 +84,6 @@ obj-$(CONFIG_EARLY_PRINTK)    += early_printk.o
>  obj-$(CONFIG_ARM_VIRT_EXT)     += hyp-stub.o
>  obj-$(CONFIG_ARM_PSCI)         += psci.o
>
> +obj-$(CONFIG_EFI)              += efi.o efi_phys.o
> +
>  extra-y := $(head-y) vmlinux.lds
> diff --git a/arch/arm/kernel/efi.c b/arch/arm/kernel/efi.c
> new file mode 100644
> index 0000000..43ecf0b
> --- /dev/null
> +++ b/arch/arm/kernel/efi.c
> @@ -0,0 +1,456 @@
> +/*
> + * Extensible Firmware Interface
> + *
> + * Based on Extensible Firmware Interface Specification version 2.3.1
> + *
> + * Copyright (C) 2013 Linaro Ltd.

Was any of the above code extracted from the x86/ia64 efi code base?
If so then make sure the copyright header and license text gets
retained.

> + *
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
> +#include <asm/efi.h>
> +#include <asm/idmap.h>
> +#include <asm/tlbflush.h>
> +
> +struct efi efi;
> +EXPORT_SYMBOL(efi);
> +struct efi_memory_map memmap;

The above symbols should be pulled out of x86 and ia64 and made part
of drivers/efi/efi.c. Although in my quick look I don't see memmap
defined for ia64. You'll need to make sure that it actually exists
before moving it. That will also affect your earlier patch which moves
the memmap lookup function. I suspect that function won't build on
ia64.

> +
> +static efi_runtime_services_t *runtime;
> +
> +static phys_addr_t efi_system_table;
> +static phys_addr_t efi_boot_mmap;
> +static u32 efi_boot_mmap_size;
> +static u32 efi_mmap_desc_size;
> +static u32 efi_mmap_desc_ver;
> +
> +/* Default memory map descriptor information */
> +#define DESC_SIZE 48
> +#define DESC_VER   1
> +
> +/* If you're planning to wire up a debugger and debug the UEFI side ... */
> +#undef KEEP_ALL_REGIONS
> +#define KEEP_BOOT_SERVICES_REGIONS
> +
> +static int __initdata uefi_debug;
> +static int __init uefi_debug_setup(char *str)
> +{
> +       uefi_debug = 1;
> +
> +       return 0;
> +}
> +early_param("uefi_debug", uefi_debug_setup);
> +
> +static int __init fdt_find_efi_params(unsigned long node, const char *uname,
> +                                     int depth, void *data)
> +{
> +       unsigned long len;
> +       __be32 *prop;
> +
> +       if (depth != 1 ||
> +           (strcmp(uname, "chosen") != 0 && strcmp(uname, "chosen@0") != 0))
> +               return 0;
> +
> +       pr_info("Getting EFI parameters from FDT.\n");
> +
> +       prop = of_get_flat_dt_prop(node, "efi-system-table", &len);
> +       if (!prop)
> +               return 0;
> +       efi_system_table = of_read_ulong(prop, len/4);
> +
> +       prop = of_get_flat_dt_prop(node, "efi-runtime-mmap", &len);
> +       if (!prop)
> +               return 0;
> +       efi_boot_mmap = of_read_ulong(prop, len/4);
> +
> +       prop = of_get_flat_dt_prop(node, "efi-runtime-mmap-size", &len);
> +       if (!prop)
> +               return 0;
> +       efi_boot_mmap_size  = of_read_ulong(prop, len/4);
> +
> +       prop = of_get_flat_dt_prop(node, "efi-mmap-desc-size", &len);
> +       if (prop)
> +               efi_mmap_desc_size  = of_read_ulong(prop, len/4);
> +       else
> +               efi_mmap_desc_size = DESC_SIZE;
> +
> +       prop = of_get_flat_dt_prop(node, "efi-mmap-desc-ver", &len);
> +       if (prop)
> +               efi_mmap_desc_ver  = of_read_ulong(prop, len/4);
> +       else
> +               efi_mmap_desc_ver = DESC_VER;

As discussed in the binding patch, if the memmap is being passed in
from GRUB, then it can be embedded directly into the device tree which
will change the above code.

> +
> +       if (uefi_debug) {
> +               pr_info("  EFI system table @ 0x%08x\n",
> +                       (unsigned int) efi_system_table);
> +               pr_info("  EFI mmap @ 0x%08x\n",
> +                       (unsigned int) efi_boot_mmap);
> +               pr_info("  EFI mmap size = 0x%08x\n",
> +                       (unsigned int) efi_boot_mmap_size);
> +               pr_info("  EFI mmap descriptor size = 0x%08x\n",
> +                       (unsigned int) efi_mmap_desc_size);
> +               pr_info("  EFI mmap descriptor version = 0x%08x\n",
> +                       (unsigned int) efi_mmap_desc_ver);
> +       }
> +
> +       return 1;
> +}
> +
> +static int __init uefi_config_init(void)
> +{
> +       efi_char16_t *c16;
> +       char vendor[100] = "unknown";
> +       efi_config_table_t *config_tables;
> +       u32 nr_tables;
> +       int i;
> +
> +       efi.systab = early_ioremap(efi_system_table,
> +                                  sizeof(efi_system_table_t));
> +
> +       /*
> +        * Verify the EFI Table
> +        */
> +       if (efi.systab == NULL)
> +               panic("Whoa! Can't find EFI system table.\n");
> +       if (efi.systab->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
> +               panic("Whoa! EFI system table signature incorrect\n");
> +       if ((efi.systab->hdr.revision >> 16) == 0)
> +               pr_warn("Warning: EFI system table version %d.%02d, expected 1.00 or greater\n",
> +                       efi.systab->hdr.revision >> 16,
> +                       efi.systab->hdr.revision & 0xffff);
> +
> +       /* Show what we know for posterity */
> +       c16 = (efi_char16_t *)early_ioremap(efi.systab->fw_vendor,
> +                                           sizeof(vendor));
> +       if (c16) {
> +               for (i = 0; i < (int) sizeof(vendor) - 1 && *c16; ++i)
> +                       vendor[i] = c16[i];
> +               vendor[i] = '\0';
> +       }
> +
> +       pr_info("EFI v%u.%.02u by %s\n",
> +               efi.systab->hdr.revision >> 16,
> +               efi.systab->hdr.revision & 0xffff, vendor);
> +
> +
> +       nr_tables = efi.systab->nr_tables;
> +
> +       config_tables = early_ioremap(efi.systab->tables,
> +                                     sizeof(efi_config_table_t) * nr_tables);
> +
> +       for (i = 0; i < nr_tables; i++) {
> +               efi_guid_t guid;
> +               unsigned long table;
> +               u8 str[38];
> +
> +               guid = config_tables[i].guid;
> +               table = config_tables[i].table;
> +
> +               efi_guid_unparse(&guid, str);
> +               if (uefi_debug)
> +                       pr_info("  Config Table: UUID=%s @ 0x%08x\n",
> +                               str, (u32)table);
> +               if (!efi_guidcmp(guid, SMBIOS_TABLE_GUID))
> +                       efi.smbios = table;
> +       }
> +
> +       early_iounmap(config_tables, sizeof(efi_config_table_t) * nr_tables);
> +       early_iounmap(c16, sizeof(vendor));
> +       early_iounmap(efi.systab,  sizeof(efi_system_table_t));
> +
> +       return 0;
> +}
> +
> +static __init int is_discardable_region(efi_memory_desc_t *md)
> +{
> +#ifdef KEEP_ALL_REGIONS
> +       return 0;
> +#endif
> +
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
> +       }
> +
> +       return 1;
> +}
> +
> +static __initdata struct {
> +       u32 type;
> +       const char *name;
> +}  memory_type_name_map[] = {
> +       {EFI_RESERVED_TYPE, "EFI reserved"},
> +       {EFI_LOADER_CODE, "EFI loader code"},
> +       {EFI_LOADER_DATA, "EFI loader data"},
> +       {EFI_BOOT_SERVICES_CODE, "EFI boot services code"},
> +       {EFI_BOOT_SERVICES_DATA, "EFI boot services data"},
> +       {EFI_RUNTIME_SERVICES_CODE, "EFI runtime services code"},
> +       {EFI_RUNTIME_SERVICES_DATA, "EFI runtime services data"},
> +       {EFI_CONVENTIONAL_MEMORY, "EFI conventional memory"},
> +       {EFI_UNUSABLE_MEMORY, "EFI unusable memory"},
> +       {EFI_ACPI_RECLAIM_MEMORY, "EFI ACPI reclaim memory"},
> +       {EFI_ACPI_MEMORY_NVS, "EFI ACPI memory nvs"},
> +       {EFI_MEMORY_MAPPED_IO, "EFI memory mapped I/O"},
> +       {EFI_MEMORY_MAPPED_IO_PORT_SPACE, "EFI memory mapped I/O port space"},
> +       {EFI_PAL_CODE, "EFI pal code"},
> +       {EFI_MAX_MEMORY_TYPE, NULL},
> +};

The above *definitely* belongs in common code!  :-)

> +
> +static __init void remove_sections(phys_addr_t addr, unsigned long size)
> +{
> +       unsigned long section_offset;
> +       unsigned long num_sections;
> +
> +       section_offset = addr - (addr & SECTION_MASK);
> +       num_sections = size / SECTION_SIZE;
> +       if (size % SECTION_SIZE)
> +               num_sections++;
> +
> +       memblock_remove(addr - section_offset, num_sections * SECTION_SIZE);
> +}
> +
> +static __init int remove_regions(void)
> +{
> +       efi_memory_desc_t *md;
> +       int count = 0;
> +
> +       void *p;
> +
> +       memmap.phys_map = early_ioremap(efi_boot_mmap, efi_boot_mmap_size);
> +
> +       memmap.desc_size = efi_mmap_desc_size;
> +       memmap.desc_version = efi_mmap_desc_ver;
> +       memmap.map_end = (void *) memmap.phys_map + efi_boot_mmap_size;
> +       memmap.nr_map = 0;
> +
> +       if (uefi_debug)
> +               pr_info("Processing EFI memory map:\n");
> +
> +       for (p = memmap.phys_map; p < memmap.map_end; p += memmap.desc_size) {
> +               md = p;
> +               if (is_discardable_region(md))
> +                       continue;
> +
> +               if (uefi_debug)
> +                       pr_info("  %8llu pages @ %016llx (%s)\n",
> +                               md->num_pages, md->phys_addr,
> +                               memory_type_name_map[md->type].name);
> +
> +               if (md->type != EFI_MEMORY_MAPPED_IO) {
> +                       remove_sections(md->phys_addr,
> +                                       md->num_pages * PAGE_SIZE);
> +                       count++;
> +               }
> +               memmap.nr_map++;
> +       }
> +
> +       if (uefi_debug)
> +               pr_info("%d regions preserved.\n", memmap.nr_map);
> +
> +       early_iounmap(memmap.phys_map, efi_boot_mmap_size);
> +
> +       return 0;
> +}
> +
> +int __init efi_memblock_arm_reserve_range(void)
> +{
> +       /* Grab system table location out of FDT (or ACPI) */
> +       of_scan_flat_dt(fdt_find_efi_params, NULL);
> +
> +       if (!efi_system_table || !efi_boot_mmap || !efi_boot_mmap_size)
> +               return 0;
> +
> +       remove_regions();
> +
> +       uefi_config_init();
> +
> +       return 0;
> +}
> +
> +/*
> + * Disable instrrupts, enable idmap and disable caches.
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
> +
> +       local_irq_enable();
> +}
> +
> +/*
> + * This function switches the EFI runtime services to virtual mode.
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
> +       efi_phys_call_t *phys_set_map;
> +       efi_status_t status;
> +
> +       phys_call_prologue();
> +
> +       phys_set_map = (void *)(unsigned long)virt_to_phys(efi_phys_call);
> +
> +       /* Called with caches disabled, returns with caches enabled */
> +       status = phys_set_map(memory_map_size, descriptor_size,
> +                             descriptor_version, dsc,
> +                             efi.set_virtual_address_map);
> +
> +       phys_call_epilogue();
> +
> +       return status;
> +}

Eventually we'll need to look at how this interacts with kexec. A
kexec'd kernel will need to use the mapping already chosen by a
previous kernel, but that's an issue for another patch series.

The patch needs some rework, but otherwise looks good, although I'm
concerned about duplicate code. However, I've not dug deep into the
mmu handling code. Others more cluefull that I on the MMU details will
need to weigh in on that.

g.
