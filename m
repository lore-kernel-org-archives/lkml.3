Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245Ab3K1Qm2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 11:42:28 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:63849 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087Ab3K1QmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 11:42:23 -0500
From: Leif Lindholm <leif.lindholm@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk
Cc: matt.fleming@intel.com, grant.likely@linaro.org, roy.franz@linaro.org,
        msalter@redhat.com, patches@linaro.org, linaro-uefi@linaro.org,
        mark.rutland@arm.com, Leif Lindholm <leif.lindholm@linaro.org>
Subject: [PATCH v3 2/3] arm: Add [U]EFI runtime services support
Date: Thu, 28 Nov 2013 16:41:22 +0000
Message-Id: <1385656883-4420-3-git-send-email-leif.lindholm@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1385656883-4420-1-git-send-email-leif.lindholm@linaro.org>
References: <1385656883-4420-1-git-send-email-leif.lindholm@linaro.org>
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
---
 arch/arm/Kconfig            |   15 ++
 arch/arm/include/asm/uefi.h |   22 ++
 arch/arm/kernel/Makefile    |    2 +
 arch/arm/kernel/setup.c     |    6 +
 arch/arm/kernel/uefi.c      |  469 +++++++++++++++++++++++++++++++++++++++++++
 arch/arm/kernel/uefi_phys.S |   59 ++++++
 include/linux/efi.h         |    2 +-
 7 files changed, 574 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/include/asm/uefi.h
 create mode 100644 arch/arm/kernel/uefi.c
 create mode 100644 arch/arm/kernel/uefi_phys.S

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 78a79a6a..db8d212 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1853,6 +1853,19 @@ config EARLY_IOREMAP
 	  the same virtual memory range as kmap so all early mappings must
 	  be unapped before paging_init() is called.
 
+config EFI
+	bool "UEFI runtime service support"
+	depends on OF && !CPU_BIG_ENDIAN
+	select UCS2_STRING
+	select EARLY_IOREMAP
+	---help---
+	  This enables the kernel to use UEFI runtime services that are
+	  available (such as the UEFI variable services).
+
+	  This option is only useful on systems that have UEFI firmware.
+	  However, even with this option, the resultant kernel will
+	  continue to boot on non-UEFI platforms.
+
 config SECCOMP
 	bool
 	prompt "Enable seccomp to safely compute untrusted bytecode"
@@ -2272,6 +2285,8 @@ source "net/Kconfig"
 
 source "drivers/Kconfig"
 
+source "drivers/firmware/Kconfig"
+
 source "fs/Kconfig"
 
 source "arch/arm/Kconfig.debug"
diff --git a/arch/arm/include/asm/uefi.h b/arch/arm/include/asm/uefi.h
new file mode 100644
index 0000000..519ca18
--- /dev/null
+++ b/arch/arm/include/asm/uefi.h
@@ -0,0 +1,22 @@
+#ifndef _ASM_ARM_EFI_H
+#define _ASM_ARM_EFI_H
+
+#include <asm/mach/map.h>
+
+extern int uefi_memblock_arm_reserve_range(void);
+
+typedef efi_status_t uefi_phys_call_t(u32 memory_map_size,
+				      u32 descriptor_size,
+				      u32 descriptor_version,
+				      efi_memory_desc_t *dsc,
+				      efi_set_virtual_address_map_t *f);
+
+extern efi_status_t uefi_phys_call(u32, u32, u32, efi_memory_desc_t *,
+				   efi_set_virtual_address_map_t *);
+
+#define uefi_remap(cookie, size) __arm_ioremap((cookie), (size), MT_MEMORY)
+#define uefi_ioremap(cookie, size) __arm_ioremap((cookie), (size), MT_DEVICE)
+#define uefi_unmap(cookie) __arm_iounmap((cookie))
+#define uefi_iounmap(cookie) __arm_iounmap((cookie))
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
index 04c1757..9d44edd 100644
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
 
@@ -898,6 +900,10 @@ void __init setup_arch(char **cmdline_p)
 	sanity_check_meminfo();
 	arm_memblock_init(&meminfo, mdesc);
 
+#ifdef CONFIG_EFI
+	uefi_memblock_arm_reserve_range();
+#endif
+
 	paging_init(mdesc);
 	request_standard_resources(mdesc);
 
diff --git a/arch/arm/kernel/uefi.c b/arch/arm/kernel/uefi.c
new file mode 100644
index 0000000..f771026
--- /dev/null
+++ b/arch/arm/kernel/uefi.c
@@ -0,0 +1,469 @@
+/*
+ * Based on Unified Extensible Firmware Interface Specification version 2.3.1
+ *
+ * Copyright (C) 2013  Linaro Ltd.
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
+static unsigned long arm_uefi_facility;
+
+/*
+ * If you're planning to wire up a debugger and debug the UEFI side ...
+ */
+#undef KEEP_ALL_REGIONS
+
+/*
+ * If you need to (temporarily) support buggy firmware.
+ */
+#define KEEP_BOOT_SERVICES_REGIONS
+
+/*
+ * Returns 1 if 'facility' is enabled, 0 otherwise.
+ */
+int efi_enabled(int facility)
+{
+	return test_bit(facility, &arm_uefi_facility) != 0;
+}
+EXPORT_SYMBOL(efi_enabled);
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
+static struct {
+	const char *name;
+	const char *propname;
+	int numcells;
+	void *target;
+} dt_params[] = {
+	{
+		"UEFI System Table", "linux,uefi-system-table",
+		2, &uefi_system_table
+	}, {
+		"UEFI mmap address", "linux,uefi-mmap-start",
+		2, &uefi_boot_mmap
+	}, {
+		"UEFI mmap size", "linux,uefi-mmap-size",
+		1, &uefi_boot_mmap_size
+	}, {
+		"UEFI mmap descriptor size", "linux,uefi-mmap-desc-size",
+		1, &uefi_mmap_desc_size
+	}, {
+		"UEFI mmap descriptor version", "linux,uefi-mmap-desc-ver",
+		1, &uefi_mmap_desc_ver
+	}
+};
+
+static int __init fdt_find_uefi_params(unsigned long node, const char *uname,
+				       int depth, void *data)
+{
+	void *prop;
+	int i;
+
+	if (depth != 1 ||
+	    (strcmp(uname, "chosen") != 0 && strcmp(uname, "chosen@0") != 0))
+		return 0;
+
+	pr_info("Getting UEFI parameters from FDT.\n");
+
+	for (i = 0; i < sizeof(dt_params)/sizeof(*dt_params); i++) {
+		prop = of_get_flat_dt_prop(node, dt_params[i].propname, NULL);
+		if (!prop)
+			return 0;
+		if (dt_params[i].numcells == 1) {
+			u32 *target = dt_params[i].target;
+			*target = of_read_ulong(prop, 1);
+		} else {
+			u64 *target = dt_params[i].target;
+			*target = of_read_number(prop, 2);
+		}
+
+		if (uefi_debug)
+			pr_info("  %s @ 0x%08x\n", dt_params[i].name,
+				*((u32 *)dt_params[i].target));
+	}
+
+	return 1;
+}
+
+static int __init uefi_init(void)
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
+		pr_warn("Warning: UEFI system table version %d.%02d, expected 1.00 or greater\n",
+			efi.systab->hdr.revision >> 16,
+			efi.systab->hdr.revision & 0xffff);
+
+	/* Show what we know for posterity */
+	c16 = (efi_char16_t *)early_memremap(efi.systab->fw_vendor,
+					    sizeof(vendor));
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
+		set_bit(EFI_CONFIG_TABLES, &arm_uefi_facility);
+
+	early_iounmap(c16, sizeof(vendor));
+	early_iounmap(efi.systab,  sizeof(efi_system_table_t));
+
+	return retval;
+}
+
+static __init int is_discardable_region(efi_memory_desc_t *md)
+{
+#ifdef KEEP_ALL_REGIONS
+	return 0;
+#endif
+
+	if (md->attribute & EFI_MEMORY_RUNTIME)
+		return 0;
+
+	switch (md->type) {
+#ifdef KEEP_BOOT_SERVICES_REGIONS
+	case EFI_BOOT_SERVICES_CODE:
+	case EFI_BOOT_SERVICES_DATA:
+#endif
+	/* Keep tables around for any future kexec operations */
+	case EFI_ACPI_RECLAIM_MEMORY:
+		return 0;
+	/* Preserve */
+	case EFI_RESERVED_TYPE:
+		return 0;
+	}
+
+	return 1;
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
+static __init int remove_regions(void)
+{
+	efi_memory_desc_t *md;
+	int count = 0;
+	void *p, *e;
+
+	if (uefi_debug)
+		pr_info("Processing UEFI memory map:\n");
+
+	memmap.phys_map = early_memremap((phys_addr_t)(u32) uefi_boot_mmap,
+					 uefi_boot_mmap_size);
+	if (!memmap.phys_map)
+		return 1;
+
+	p = memmap.phys_map;
+	e = (void *)((u32)p + uefi_boot_mmap_size);
+	for (; p < e; p += uefi_mmap_desc_size) {
+		md = p;
+		if (is_discardable_region(md))
+			continue;
+
+		if (uefi_debug)
+			pr_info("  %8llu pages @ %016llx (%s)\n",
+				md->num_pages, md->phys_addr,
+				memory_type_name_map[md->type].name);
+
+		if (md->type != EFI_MEMORY_MAPPED_IO) {
+			remove_sections(md->phys_addr,
+					md->num_pages * PAGE_SIZE);
+			count++;
+		}
+		memmap.nr_map++;
+	}
+
+	early_iounmap(memmap.phys_map, uefi_boot_mmap_size);
+
+	if (uefi_debug)
+		pr_info("%d regions preserved.\n", memmap.nr_map);
+
+	return 0;
+}
+
+int __init uefi_memblock_arm_reserve_range(void)
+{
+	if (!of_scan_flat_dt(fdt_find_uefi_params, NULL))
+		return 0;
+
+	set_bit(EFI_BOOT, &arm_uefi_facility);
+
+	uefi_init();
+
+	remove_regions();
+
+	return 0;
+}
+
+/*
+ * Disable instrrupts, enable idmap and disable caches.
+ */
+static void __init phys_call_prologue(void)
+{
+	local_irq_disable();
+
+	/* Take out a flat memory mapping. */
+	setup_mm_for_reboot();
+
+	/* Clean and invalidate caches */
+	flush_cache_all();
+
+	/* Turn off caching */
+	cpu_proc_fin();
+
+	/* Push out any further dirty data, and ensure cache is empty */
+	flush_cache_all();
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
+	/* Flush branch predictor and TLBs */
+	local_flush_bp_all();
+#ifdef CONFIG_CPU_HAS_ASID
+	local_flush_tlb_all();
+#endif
+
+	local_irq_enable();
+}
+
+static int __init remap_region(efi_memory_desc_t *md, efi_memory_desc_t *entry)
+{
+	u64 va;
+	u64 paddr;
+	u64 size;
+
+	*entry = *md;
+	paddr = entry->phys_addr;
+	size = entry->num_pages << EFI_PAGE_SHIFT;
+
+	/*
+	 * Map everything writeback-capable as coherent memory,
+	 * anything else as device.
+	 */
+	if (md->attribute & EFI_MEMORY_WB)
+		va = (u64)((u32)uefi_remap(paddr, size) & 0xffffffffUL);
+	else
+		va = (u64)((u32)uefi_ioremap(paddr, size) & 0xffffffffUL);
+	if (!va)
+		return 0;
+	entry->virt_addr = va;
+
+	if (uefi_debug)
+		pr_info("  %016llx-%016llx => 0x%08x : (%s)\n",
+			paddr, paddr + size - 1, (u32)va,
+			md->attribute &  EFI_MEMORY_WB ? "WB" : "I/O");
+
+	return 1;
+}
+
+static int __init remap_regions(void)
+{
+	void *p, *next;
+	efi_memory_desc_t *md;
+
+	memmap.phys_map = uefi_remap(uefi_boot_mmap, uefi_boot_mmap_size);
+	if (!memmap.phys_map)
+		return 0;
+	memmap.map_end = (void *)memmap.phys_map + uefi_boot_mmap_size;
+	memmap.desc_size = uefi_mmap_desc_size;
+	memmap.desc_version = uefi_mmap_desc_ver;
+
+	/* Allocate space for the physical region map */
+	memmap.map = kzalloc(memmap.nr_map * memmap.desc_size, GFP_KERNEL);
+	if (!memmap.map)
+		return 0;
+
+	next = memmap.map;
+	for (p = memmap.phys_map; p < memmap.map_end; p += memmap.desc_size) {
+		md = p;
+		if (is_discardable_region(md) || md->type == EFI_RESERVED_TYPE)
+			continue;
+
+		if (!remap_region(p, next))
+			return 0;
+
+		next += memmap.desc_size;
+	}
+
+	memmap.map_end = next;
+	efi.memmap = &memmap;
+
+	uefi_unmap(memmap.phys_map);
+	memmap.phys_map = efi_lookup_mapped_addr(uefi_boot_mmap);
+	efi.systab = efi_lookup_mapped_addr(uefi_system_table);
+	if (efi.systab)
+		set_bit(EFI_SYSTEM_TABLES, &arm_uefi_facility);
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
+	status = phys_set_map(memory_map_size, descriptor_size,
+			      descriptor_version, dsc,
+			      efi.set_virtual_address_map)
+;
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
+	efi.set_virtual_address_map =
+		(efi_set_virtual_address_map_t *)
+		runtime->set_virtual_address_map;
+	memmap.phys_map =
+		(efi_memory_desc_t *)(u32) __virt_to_phys((u32)memmap.map);
+
+	status = phys_set_virtual_address_map(memmap.nr_map * memmap.desc_size,
+					      memmap.desc_size,
+					      memmap.desc_version,
+					      memmap.phys_map);
+
+	if (status != EFI_SUCCESS) {
+		pr_info("Failed to set UEFI virtual address map!\n");
+		return;
+	}
+
+	/* Set up function pointers for efivars */
+	efi.get_variable = (efi_get_variable_t *)runtime->get_variable;
+	efi.get_next_variable =
+		(efi_get_next_variable_t *)runtime->get_next_variable;
+	efi.set_variable = (efi_set_variable_t *)runtime->set_variable;
+	set_bit(EFI_RUNTIME_SERVICES, &arm_uefi_facility);
+}
diff --git a/arch/arm/kernel/uefi_phys.S b/arch/arm/kernel/uefi_phys.S
new file mode 100644
index 0000000..e9a1542
--- /dev/null
+++ b/arch/arm/kernel/uefi_phys.S
@@ -0,0 +1,59 @@
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
+#include <linux/linkage.h>
+#define PAR_MASK 0xfff
+
+	.text
+@ uefi_phys_call(a, b, c, d, *f)
+	.align  5
+        .pushsection    .idmap.text, "ax"
+ENTRY(uefi_phys_call)
+	@ Save physical context
+	mov	r12, sp
+	push	{r4-r5, r12, lr}
+
+	@ Extract function pointer (don't write r12 beyond this)
+	ldr	r12, [sp, #16]
+
+	@ Convert sp to 32-bit physical
+	mov	lr, sp
+	ldr	r4, =PAR_MASK
+	and	r5, lr, r4			@ Extract lower 12 bits of sp
+	mcr	p15, 0, lr, c7, c8, 1		@ Write VA -> ATS1CPW
+	mrc	p15, 0, lr, c7, c4, 0		@ Physical Address Register
+	mvn	r4, r4
+	and	lr, lr, r4			@ Clear lower 12 bits of PA
+	add	lr, lr, r5			@ Calculate phys sp
+	mov	sp, lr				@ Update
+
+	@ Disable MMU
+        mrc     p15, 0, lr, c1, c0, 0           @ ctrl register
+        bic     lr, lr, #0x1                    @ ...............m
+        mcr     p15, 0, lr, c1, c0, 0           @ disable MMU
+	isb
+
+	@ Make call
+	blx	r12
+
+	pop	{r4-r5, r12, lr}
+
+	@ Enable MMU + Caches
+        mrc     p15, 0, r1, c1, c0, 0		@ ctrl register
+        orr     r1, r1, #0x1000			@ ...i............
+        orr     r1, r1, #0x0005			@ .............c.m
+        mcr     p15, 0, r1, c1, c0, 0		@ enable MMU
+	isb
+
+	@ Restore virtual sp and return
+	mov	sp, r12
+	bx	lr
+ENDPROC(uefi_phys_call)
+        .popsection
diff --git a/include/linux/efi.h b/include/linux/efi.h
index bc5687d..ebb34ee 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -655,7 +655,7 @@ extern int __init efi_setup_pcdp_console(char *);
 #define EFI_64BIT		5	/* Is the firmware 64-bit? */
 
 #ifdef CONFIG_EFI
-# ifdef CONFIG_X86
+# if defined(CONFIG_X86) || defined(CONFIG_ARM)
 extern int efi_enabled(int facility);
 # else
 static inline int efi_enabled(int facility)
-- 
1.7.10.4

