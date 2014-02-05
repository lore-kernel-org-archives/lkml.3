Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729AbaBERJQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 12:09:16 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:34460 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376AbaBERF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 12:05:29 -0500
From: Leif Lindholm <leif.lindholm@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-efi@vger.kernel.org
Cc: patches@linaro.org, Leif Lindholm <leif.lindholm@linaro.org>
Subject: [PATCH 13/22] arm: Add [U]EFI runtime services support
Date: Wed,  5 Feb 2014 17:04:04 +0000
Message-Id: <1391619853-10601-14-git-send-email-leif.lindholm@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1391619853-10601-1-git-send-email-leif.lindholm@linaro.org>
References: <1391619853-10601-1-git-send-email-leif.lindholm@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements basic support for UEFI runtime services in the
ARM architecture - a requirement for using efibootmgr to read and update
the system boot configuration.

It uses the generic configuration table scanning to populate ACPI and
SMBIOS pointers.

Changes since v2:
- Updated FDT bindings.
- Preserve regions marked RESERVED (but don't map them).
- Rename 'efi' -> 'uefi' within this new port (leaving core code as is).

Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
Reviewed-by: Grant Likely <grant.likely@linaro.org>
---
 arch/arm/Kconfig            |   16 ++
 arch/arm/include/asm/uefi.h |   28 +++
 arch/arm/kernel/Makefile    |    2 +
 arch/arm/kernel/setup.c     |    7 +-
 arch/arm/kernel/uefi.c      |  413 +++++++++++++++++++++++++++++++++++++++++++
 arch/arm/kernel/uefi_phys.S |   69 ++++++++
 6 files changed, 533 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm/include/asm/uefi.h
 create mode 100644 arch/arm/kernel/uefi.c
 create mode 100644 arch/arm/kernel/uefi_phys.S

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index a693921..1e1273d 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1885,6 +1885,20 @@ config EARLY_IOREMAP
 	  the same virtual memory range as kmap so all early mappings must
 	  be unapped before paging_init() is called.
 
+config EFI
+	bool "UEFI runtime service support"
+	depends on OF && !CPU_BIG_ENDIAN
+	select UCS2_STRING
+	select EARLY_IOREMAP
+	select UEFI_PARAMS_FROM_FDT
+	---help---
+	  This enables the kernel to use UEFI runtime services that are
+	  available (such as the UEFI variable services).
+
+	  This option is only useful on systems that have UEFI firmware.
+	  However, even with this option, the resultant kernel will
+	  continue to boot on non-UEFI platforms.
+
 config EFI_STUB
 	bool "EFI stub support"
 	depends on EFI && !CPU_BIG_ENDIAN
@@ -2304,6 +2318,8 @@ source "net/Kconfig"
 
 source "drivers/Kconfig"
 
+source "drivers/firmware/Kconfig"
+
 source "fs/Kconfig"
 
 source "arch/arm/Kconfig.debug"
diff --git a/arch/arm/include/asm/uefi.h b/arch/arm/include/asm/uefi.h
new file mode 100644
index 0000000..3bc4c60
--- /dev/null
+++ b/arch/arm/include/asm/uefi.h
@@ -0,0 +1,28 @@
+#ifndef _ASM_ARM_EFI_H
+#define _ASM_ARM_EFI_H
+
+#ifdef CONFIG_EFI
+#include <asm/mach/map.h>
+
+extern void uefi_init(void);
+
+typedef efi_status_t uefi_phys_call_t(efi_set_virtual_address_map_t *f,
+				      u32 virt_phys_offset,
+				      u32 memory_map_size,
+				      u32 descriptor_size,
+				      u32 descriptor_version,
+				      efi_memory_desc_t *dsc);
+
+extern efi_status_t uefi_phys_call(u32, u32, u32, efi_memory_desc_t *,
+				   efi_set_virtual_address_map_t *);
+
+#define uefi_remap(cookie, size) __arm_ioremap((cookie), (size), MT_MEMORY_RWX)
+#define uefi_ioremap(cookie, size) __arm_ioremap((cookie), (size), MT_DEVICE)
+#define uefi_unmap(cookie) __arm_iounmap((cookie))
+#define uefi_iounmap(cookie) __arm_iounmap((cookie))
+
+#else
+#define uefi_init()
+#endif /* CONFIG_EFI */
+
+#endif /* _ASM_ARM_EFI_H */
diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
index a30fc9b..736cce4 100644
--- a/arch/arm/kernel/Makefile
+++ b/arch/arm/kernel/Makefile
@@ -98,4 +98,6 @@ obj-y				+= psci.o
 obj-$(CONFIG_SMP)		+= psci_smp.o
 endif
 
+obj-$(CONFIG_EFI)		+= uefi.o uefi_phys.o
+
 extra-y := $(head-y) vmlinux.lds
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index b074ef5..71b8839 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -30,6 +30,7 @@
 #include <linux/bug.h>
 #include <linux/compiler.h>
 #include <linux/sort.h>
+#include <linux/efi.h>
 
 #include <asm/unified.h>
 #include <asm/cp15.h>
@@ -57,6 +58,7 @@
 #include <asm/unwind.h>
 #include <asm/memblock.h>
 #include <asm/virt.h>
+#include <asm/uefi.h>
 
 #include "atags.h"
 
@@ -878,6 +880,9 @@ void __init setup_arch(char **cmdline_p)
 	if (mdesc->reboot_mode != REBOOT_HARD)
 		reboot_mode = mdesc->reboot_mode;
 
+	early_ioremap_init();
+	uefi_init();
+
 	init_mm.start_code = (unsigned long) _text;
 	init_mm.end_code   = (unsigned long) _etext;
 	init_mm.end_data   = (unsigned long) _edata;
@@ -889,8 +894,6 @@ void __init setup_arch(char **cmdline_p)
 
 	parse_early_param();
 
-	early_ioremap_init();
-
 	early_paging_init(mdesc, lookup_processor_type(read_cpuid_id()));
 	setup_dma_zone(mdesc);
 	sanity_check_meminfo();
diff --git a/arch/arm/kernel/uefi.c b/arch/arm/kernel/uefi.c
new file mode 100644
index 0000000..77c18b6
--- /dev/null
+++ b/arch/arm/kernel/uefi.c
@@ -0,0 +1,413 @@
+/*
+ * Based on Unified Extensible Firmware Interface Specification version 2.3.1
+ *
+ * Copyright (C) 2013-2014  Linaro Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/efi.h>
+#include <linux/export.h>
+#include <linux/memblock.h>
+#include <linux/of.h>
+#include <linux/of_fdt.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+
+#include <asm/cacheflush.h>
+#include <asm/idmap.h>
+#include <asm/setup.h>
+#include <asm/tlbflush.h>
+#include <asm/uefi.h>
+
+struct efi_memory_map memmap;
+
+static efi_runtime_services_t *runtime;
+
+static phys_addr_t uefi_system_table;
+static phys_addr_t uefi_boot_mmap;
+static u32 uefi_boot_mmap_size;
+static u32 uefi_mmap_desc_size;
+static u32 uefi_mmap_desc_ver;
+
+/*
+ * If you want to wire up a debugger and debug the UEFI side, set to 0.
+ */
+#define DISCARD_UNUSED_REGIONS 1
+
+/*
+ * If you need to (temporarily) support buggy firmware, set to 0.
+ */
+#define DISCARD_BOOT_SERVICES_REGIONS 1
+
+static int uefi_debug __initdata;
+static int __init uefi_debug_setup(char *str)
+{
+	uefi_debug = 1;
+
+	return 0;
+}
+early_param("uefi_debug", uefi_debug_setup);
+
+static int __init uefi_systab_init(void)
+{
+	efi_char16_t *c16;
+	char vendor[100] = "unknown";
+	int i, retval;
+
+	efi.systab = early_memremap(uefi_system_table,
+				    sizeof(efi_system_table_t));
+
+	/*
+	 * Verify the UEFI System Table
+	 */
+	if (efi.systab == NULL)
+		panic("Whoa! Can't find UEFI system table.\n");
+	if (efi.systab->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
+		panic("Whoa! UEFI system table signature incorrect\n");
+	if ((efi.systab->hdr.revision >> 16) == 0)
+		pr_warn("Warning: UEFI system table version %d.%02d, expected 2.30 or greater\n",
+			efi.systab->hdr.revision >> 16,
+			efi.systab->hdr.revision & 0xffff);
+
+	/* Show what we know for posterity */
+	c16 = early_memremap(efi.systab->fw_vendor, sizeof(vendor));
+	if (c16) {
+		for (i = 0; i < (int) sizeof(vendor) - 1 && *c16; ++i)
+			vendor[i] = c16[i];
+		vendor[i] = '\0';
+	}
+
+	pr_info("UEFI v%u.%.02u by %s\n",
+		efi.systab->hdr.revision >> 16,
+		efi.systab->hdr.revision & 0xffff, vendor);
+
+	retval = efi_config_init(NULL);
+	if (retval == 0)
+		set_bit(EFI_CONFIG_TABLES, &efi.flags);
+
+	early_memunmap(c16, sizeof(vendor));
+	early_memunmap(efi.systab,  sizeof(efi_system_table_t));
+
+	return retval;
+}
+
+static __init int is_discardable_region(efi_memory_desc_t *md)
+{
+	if (md->attribute & EFI_MEMORY_RUNTIME)
+		return 0;
+
+	switch (md->type) {
+	case EFI_CONVENTIONAL_MEMORY:
+		return 1;
+	case EFI_BOOT_SERVICES_CODE:
+	case EFI_BOOT_SERVICES_DATA:
+		return DISCARD_BOOT_SERVICES_REGIONS;
+	/* Keep tables around for any future kexec operations */
+	case EFI_ACPI_MEMORY_NVS:
+	case EFI_ACPI_RECLAIM_MEMORY:
+		return 0;
+	/* Preserve */
+	case EFI_RESERVED_TYPE:
+		return 0;
+	}
+
+	return DISCARD_UNUSED_REGIONS;
+}
+
+static __initdata struct {
+	u32 type;
+	const char *name;
+}  memory_type_name_map[] = {
+	{EFI_RESERVED_TYPE, "reserved"},
+	{EFI_LOADER_CODE, "loader code"},
+	{EFI_LOADER_DATA, "loader data"},
+	{EFI_BOOT_SERVICES_CODE, "boot services code"},
+	{EFI_BOOT_SERVICES_DATA, "boot services data"},
+	{EFI_RUNTIME_SERVICES_CODE, "runtime services code"},
+	{EFI_RUNTIME_SERVICES_DATA, "runtime services data"},
+	{EFI_CONVENTIONAL_MEMORY, "conventional memory"},
+	{EFI_UNUSABLE_MEMORY, "unusable memory"},
+	{EFI_ACPI_RECLAIM_MEMORY, "ACPI reclaim memory"},
+	{EFI_ACPI_MEMORY_NVS, "ACPI memory nvs"},
+	{EFI_MEMORY_MAPPED_IO, "memory mapped I/O"},
+	{EFI_MEMORY_MAPPED_IO_PORT_SPACE, "memory mapped I/O port space"},
+	{EFI_PAL_CODE, "pal code"},
+	{EFI_MAX_MEMORY_TYPE, NULL},
+};
+
+static __init void remove_sections(phys_addr_t addr, unsigned long size)
+{
+	unsigned long section_offset;
+	unsigned long num_sections;
+
+	section_offset = addr - (addr & SECTION_MASK);
+	num_sections = size / SECTION_SIZE;
+	if (size % SECTION_SIZE)
+		num_sections++;
+
+	memblock_remove(addr - section_offset, num_sections * SECTION_SIZE);
+}
+
+static void memmap_init(void)
+{
+	efi_memory_desc_t *md;
+	int i = 0;
+
+	if (uefi_debug)
+		pr_info("Processing UEFI memory map:\n");
+
+	memmap.map = early_memremap(uefi_boot_mmap, uefi_boot_mmap_size);
+	if (!memmap.map)
+		return;
+
+	memmap.map_end = memmap.map + uefi_boot_mmap_size;
+	memmap.nr_map = 0;
+
+	for_each_efi_memory_desc(&memmap, md) {
+		pr_info("  %8llu pages @ %016llx (%s)\n",
+			md->num_pages, md->phys_addr,
+			memory_type_name_map[md->type].name);
+		if (md->attribute & EFI_MEMORY_WB) {
+			if (is_discardable_region(md)) {
+				arm_add_memory(md->phys_addr,
+					       md->num_pages * EFI_PAGE_SIZE);
+				i++;
+			}
+		}
+		memmap.nr_map++;
+	}
+
+	if (uefi_debug)
+		pr_info("%d memory regions added.\n", i);
+
+	remove_sections(uefi_boot_mmap, uefi_boot_mmap_size);
+
+	early_memunmap(memmap.map, uefi_boot_mmap_size);
+
+	set_bit(EFI_MEMMAP, &efi.flags);
+}
+
+void __init uefi_init(void)
+{
+	struct efi_fdt_params params;
+
+	uefi_debug = 1;
+
+	/* Grab UEFI information placed in FDT by stub */
+	if (!efi_get_fdt_params(&params, uefi_debug))
+		return;
+
+	uefi_system_table = params.system_table;
+
+	uefi_boot_mmap = params.mmap;
+	uefi_boot_mmap_size = params.mmap_size;
+	uefi_mmap_desc_size = params.desc_size;
+	uefi_mmap_desc_ver = params.desc_ver;
+	memmap.desc_size = uefi_mmap_desc_size;
+	memmap.map_end = memmap.map + params.mmap_size;
+	if (uefi_boot_mmap > UINT_MAX) {
+		pr_err("UEFI memory map located above 4GB - unusable!");
+		return;
+	}
+
+	if (uefi_systab_init() < 0)
+		return;
+
+	memmap_init();
+
+	set_bit(EFI_BOOT, &efi.flags);
+}
+
+/*
+ * Disable instrrupts, enable idmap and disable caches.
+ */
+static void __init phys_call_prologue(void)
+{
+	local_irq_disable();
+
+	outer_disable();
+
+	idmap_prepare();
+}
+
+/*
+ * Restore original memory map and re-enable interrupts.
+ */
+static void __init phys_call_epilogue(void)
+{
+	static struct mm_struct *mm = &init_mm;
+
+	/* Restore original memory mapping */
+	cpu_switch_mm(mm->pgd, mm);
+
+	local_flush_bp_all();
+	local_flush_tlb_all();
+
+	outer_resume();
+
+	local_irq_enable();
+}
+
+static int __init remap_region(efi_memory_desc_t *md, int entry)
+{
+	efi_memory_desc_t *region;
+	u32 va;
+	u64 paddr;
+	u64 size;
+
+	region = memmap.map + entry * memmap.desc_size;
+	*region = *md;
+	paddr = region->phys_addr;
+	size = region->num_pages << EFI_PAGE_SHIFT;
+
+	/*
+	 * Map everything writeback-capable as coherent memory,
+	 * anything else as device.
+	 */
+	if (md->attribute & EFI_MEMORY_WB)
+		va = (u32)uefi_remap(paddr, size);
+	else
+		va = (u32)uefi_ioremap(paddr, size);
+	if (!va)
+		return 0;
+	region->virt_addr = va;
+
+	if (uefi_debug)
+		pr_info("  %016llx-%016llx => 0x%08x : (%s)\n",
+			paddr, paddr + size - 1, va,
+			md->attribute &  EFI_MEMORY_WB ? "WB" : "I/O");
+
+	return 1;
+}
+
+static int __init remap_regions(void)
+{
+	void *p;
+	efi_memory_desc_t *md;
+	int mapped_regions;
+
+	memmap.phys_map = uefi_remap(uefi_boot_mmap, uefi_boot_mmap_size);
+	if (!memmap.phys_map)
+		return 0;
+
+	memmap.map_end = memmap.phys_map + uefi_boot_mmap_size;
+	memmap.desc_size = uefi_mmap_desc_size;
+	memmap.desc_version = uefi_mmap_desc_ver;
+
+	/* Allocate space for the physical region map */
+	memmap.map = kzalloc(memmap.nr_map * memmap.desc_size, GFP_ATOMIC);
+	if (!memmap.map)
+		return 0;
+
+	mapped_regions = 0;
+	for (p = memmap.phys_map; p < memmap.map_end; p += memmap.desc_size) {
+		md = p;
+		if (is_discardable_region(md))
+			continue;
+
+		if (!remap_region(p, mapped_regions++))
+			return 0;
+	}
+
+	memmap.map_end = memmap.map + mapped_regions * memmap.desc_size;
+	efi.memmap = &memmap;
+
+	uefi_unmap(memmap.phys_map);
+	memmap.phys_map = efi_lookup_mapped_addr(uefi_boot_mmap);
+	efi.systab = efi_lookup_mapped_addr(uefi_system_table);
+	if (efi.systab)
+		set_bit(EFI_SYSTEM_TABLES, &efi.flags);
+	/*
+	 * efi.systab->runtime is a 32-bit pointer to something guaranteed by
+	 * the UEFI specification to be 1:1 mapped in a 4GB address space.
+	 */
+	runtime = efi_lookup_mapped_addr((u32)efi.systab->runtime);
+
+	return 1;
+}
+
+
+/*
+ * This function switches the UEFI runtime services to virtual mode.
+ * This operation must be performed only once in the system's lifetime,
+ * including any kecec calls.
+ *
+ * This must be done with a 1:1 mapping. The current implementation
+ * resolves this by disabling the MMU.
+ */
+efi_status_t  __init phys_set_virtual_address_map(u32 memory_map_size,
+						  u32 descriptor_size,
+						  u32 descriptor_version,
+						  efi_memory_desc_t *dsc)
+{
+	uefi_phys_call_t *phys_set_map;
+	efi_status_t status;
+
+	phys_call_prologue();
+
+	phys_set_map = (void *)(unsigned long)virt_to_phys(uefi_phys_call);
+
+	/* Called with caches disabled, returns with caches enabled */
+	status = phys_set_map(efi.set_virtual_address_map,
+			      PAGE_OFFSET - PHYS_OFFSET,
+			      memory_map_size, descriptor_size,
+			      descriptor_version, dsc);
+
+	phys_call_epilogue();
+
+	return status;
+}
+
+/*
+ * Called explicitly from init/mm.c
+ */
+void __init efi_enter_virtual_mode(void)
+{
+	efi_status_t status;
+	u32 mmap_phys_addr;
+
+	if (!efi_enabled(EFI_BOOT)) {
+		pr_info("UEFI services will not be available.\n");
+		return;
+	}
+
+	pr_info("Remapping and enabling UEFI services.\n");
+
+	/* Map the regions we memblock_remove:d earlier into kernel
+	   address space */
+	if (!remap_regions()) {
+		pr_info("Failed to remap UEFI regions - runtime services will not be available.\n");
+		return;
+	}
+
+	/* Call SetVirtualAddressMap with the physical address of the map */
+	efi.set_virtual_address_map = runtime->set_virtual_address_map;
+
+	/*
+	 * __virt_to_phys() takes an unsigned long and returns a phys_addr_t
+	 * memmap.phys_map is a void *
+	 * The gymnastics below makes this compile validly with/without LPAE.
+	 */
+	mmap_phys_addr = __virt_to_phys((u32)memmap.map);
+	memmap.phys_map = (void *)mmap_phys_addr;
+
+	status = phys_set_virtual_address_map(memmap.nr_map * memmap.desc_size,
+					      memmap.desc_size,
+					      memmap.desc_version,
+					      memmap.phys_map);
+	if (status != EFI_SUCCESS) {
+		pr_info("Failed to set UEFI virtual address map!\n");
+		return;
+	}
+
+	/* Set up function pointers for efivars */
+	efi.get_variable = runtime->get_variable;
+	efi.get_next_variable = runtime->get_next_variable;
+	efi.set_variable = runtime->set_variable;
+	efi.set_virtual_address_map = NULL;
+
+	set_bit(EFI_RUNTIME_SERVICES, &efi.flags);
+}
diff --git a/arch/arm/kernel/uefi_phys.S b/arch/arm/kernel/uefi_phys.S
new file mode 100644
index 0000000..a999626
--- /dev/null
+++ b/arch/arm/kernel/uefi_phys.S
@@ -0,0 +1,69 @@
+/*
+ * arch/arm/kernel/uefi_phys.S
+ *
+ * Copyright (C) 2013  Linaro Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <asm/assembler.h>
+#include <asm/cp15.h>
+#include <linux/linkage.h>
+#define PAR_MASK 0xfff
+
+	.text
+@ uefi_phys_call(*f, virt_phys_offset, a, b, c, d, ...)
+	.align  5
+	.pushsection    .idmap.text, "ax"
+ENTRY(uefi_phys_call)
+	@ Save physical context
+	mov	r12, sp
+	ldr	sp, =tmpstack
+	stmfd	sp, {r4-r5, r12, lr}	@ push is redefined by asm/assembler.h
+
+	mov	r4, r1
+
+	@ Extract function pointer (don't write lr again before call)
+	mov	lr, r0
+
+	@ Shift arguments down
+	mov	r0, r2
+	mov	r1, r3
+	ldr	r2, [r12], #4
+	ldr	r3, [r12], #4
+
+	@ Convert sp to physical
+	sub	r12, r12, r4
+	mov	sp, r12
+
+	@ Disable MMU
+	ldr	r5, =(CR_M)
+	update_sctlr	r12, , r5
+	isb
+
+	@ Make call
+	blx	lr
+
+	@ Enable MMU + Caches
+	ldr	r4, =(CR_I | CR_C | CR_M)
+	update_sctlr	r12, r4
+	isb
+
+	ldr	sp, =tmpstack_top
+	ldmfd	sp, {r4-r5, r12, lr}
+
+	@ Restore virtual sp and return
+	mov	sp, r12
+	bx	lr
+
+	.align	3
+tmpstack_top:
+	.long	0	@ r4
+	.long	0	@ r5
+	.long	0	@ r12
+	.long	0	@ lr
+tmpstack:
+ENDPROC(uefi_phys_call)
+	.popsection
-- 
1.7.10.4

