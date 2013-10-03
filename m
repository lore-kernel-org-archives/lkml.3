Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab3JCL0W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 07:26:22 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:39426 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011Ab3JCL0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 07:26:17 -0400
From: Leif Lindholm <leif.lindholm@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        matt.fleming@intel.com, grant.likely@secretlab.ca,
        roy.franz@linaro.org, msalter@redhat.com,
        Leif Lindholm <leif.lindholm@linaro.org>
Subject: [PATCH v2 2/3] arm: Add [U]EFI runtime services support
Date: Thu,  3 Oct 2013 12:24:40 +0100
Message-Id: <1380799481-5470-3-git-send-email-leif.lindholm@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1380799481-5470-1-git-send-email-leif.lindholm@linaro.org>
References: <1380799481-5470-1-git-send-email-leif.lindholm@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements basic support for UEFI runtime services in the
ARM architecture - a requirement for using efibootmgr to read and update
the system boot configuration.

It uses the generic configuration table scanning to populate ACPI and
SMBIOS pointers.

Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
---
 arch/arm/Kconfig           |   15 ++
 arch/arm/include/asm/efi.h |   22 ++
 arch/arm/kernel/Makefile   |    2 +
 arch/arm/kernel/efi.c      |  485 ++++++++++++++++++++++++++++++++++++++++++++
 arch/arm/kernel/efi_phys.S |   59 ++++++
 arch/arm/kernel/setup.c    |    6 +
 include/linux/efi.h        |    2 +-
 7 files changed, 590 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/include/asm/efi.h
 create mode 100644 arch/arm/kernel/efi.c
 create mode 100644 arch/arm/kernel/efi_phys.S

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 5916a90..317c75d 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1855,6 +1855,19 @@ config EARLY_IOREMAP
 	  It generates its map entries in kmap region (0xfff00000) before kmap
 	  is initialized.
 
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
@@ -2267,6 +2280,8 @@ source "net/Kconfig"
 
 source "drivers/Kconfig"
 
+source "drivers/firmware/Kconfig"
+
 source "fs/Kconfig"
 
 source "arch/arm/Kconfig.debug"
diff --git a/arch/arm/include/asm/efi.h b/arch/arm/include/asm/efi.h
new file mode 100644
index 0000000..aead94c
--- /dev/null
+++ b/arch/arm/include/asm/efi.h
@@ -0,0 +1,22 @@
+#ifndef _ASM_ARM_EFI_H
+#define _ASM_ARM_EFI_H
+
+#include <asm/mach/map.h>
+
+extern int efi_memblock_arm_reserve_range(void);
+
+typedef efi_status_t efi_phys_call_t(u32 memory_map_size,
+				     u32 descriptor_size,
+				     u32 descriptor_version,
+				     efi_memory_desc_t *dsc,
+				     efi_set_virtual_address_map_t *f);
+
+extern efi_status_t efi_phys_call(u32, u32, u32, efi_memory_desc_t *,
+				  efi_set_virtual_address_map_t *);
+
+#define efi_remap(cookie, size) __arm_ioremap((cookie), (size), MT_MEMORY)
+#define efi_ioremap(cookie, size) __arm_ioremap((cookie), (size), MT_DEVICE)
+#define efi_unmap(cookie) __arm_iounmap((cookie))
+#define efi_iounmap(cookie) __arm_iounmap((cookie))
+
+#endif /* _ASM_ARM_EFI_H */
diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
index 5140df5f..81b8865 100644
--- a/arch/arm/kernel/Makefile
+++ b/arch/arm/kernel/Makefile
@@ -96,4 +96,6 @@ obj-y				+= psci.o
 obj-$(CONFIG_SMP)		+= psci_smp.o
 endif
 
+obj-$(CONFIG_EFI)		+= efi.o efi_phys.o
+
 extra-y := $(head-y) vmlinux.lds
diff --git a/arch/arm/kernel/efi.c b/arch/arm/kernel/efi.c
new file mode 100644
index 0000000..a7c2c8d
--- /dev/null
+++ b/arch/arm/kernel/efi.c
@@ -0,0 +1,485 @@
+/*
+ * Extensible Firmware Interface
+ *
+ * Based on Extensible Firmware Interface Specification version 2.3.1
+ *
+ * Copyright (C) 2013 Linaro Ltd.
+ *
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
+#include <asm/efi.h>
+#include <asm/idmap.h>
+#include <asm/tlbflush.h>
+
+struct efi_memory_map memmap;
+
+static efi_runtime_services_t *runtime;
+
+static phys_addr_t efi_system_table;
+static phys_addr_t efi_boot_mmap;
+static u32 efi_boot_mmap_size;
+static u32 efi_mmap_desc_size;
+static u32 efi_mmap_desc_ver;
+
+static unsigned long arm_efi_facility;
+
+/*
+ * Default memory map descriptor information
+ */
+#define DESC_SIZE 48
+#define DESC_VER   1
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
+	return test_bit(facility, &arm_efi_facility) != 0;
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
+static int __init fdt_find_efi_params(unsigned long node, const char *uname,
+				      int depth, void *data)
+{
+	unsigned long len;
+	void *prop;
+
+	if (depth != 1 ||
+	    (strcmp(uname, "chosen") != 0 && strcmp(uname, "chosen@0") != 0))
+		return 0;
+
+	pr_info("Getting EFI parameters from FDT.\n");
+
+	prop = of_get_flat_dt_prop(node, "linux,efi-system-table", &len);
+	if (!prop)
+		return 0;
+	efi_system_table = of_read_ulong(prop, len/4);
+
+	prop = of_get_flat_dt_prop(node, "linux,efi-mmap", &len);
+	if (!prop)
+		return 0;
+	efi_boot_mmap = (u32) prop;
+	efi_boot_mmap_size = len;
+
+	prop = of_get_flat_dt_prop(node, "linux,efi-mmap-desc-size", NULL);
+	if (prop)
+		efi_mmap_desc_size  = of_read_ulong(prop, 1);
+	else
+		efi_mmap_desc_size = DESC_SIZE;
+
+	prop = of_get_flat_dt_prop(node, "linux,efi-mmap-desc-ver", NULL);
+	if (prop)
+		efi_mmap_desc_ver  = of_read_ulong(prop, 1);
+	else
+		efi_mmap_desc_ver = DESC_VER;
+
+	if (uefi_debug) {
+		pr_info("  EFI system table @ 0x%08x\n",
+			(unsigned int) efi_system_table);
+		pr_info("  EFI mmap @ 0x%08x\n",
+			(unsigned int) efi_boot_mmap);
+		pr_info("  EFI mmap size = 0x%08x\n",
+			(unsigned int) efi_boot_mmap_size);
+		pr_info("  EFI mmap descriptor size = 0x%08x\n",
+			(unsigned int) efi_mmap_desc_size);
+		pr_info("  EFI mmap descriptor version = 0x%08x\n",
+			(unsigned int) efi_mmap_desc_ver);
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
+	efi.systab = early_ioremap(efi_system_table,
+				   sizeof(efi_system_table_t));
+
+	/*
+	 * Verify the EFI Table
+	 */
+	if (efi.systab == NULL)
+		panic("Whoa! Can't find EFI system table.\n");
+	if (efi.systab->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
+		panic("Whoa! EFI system table signature incorrect\n");
+	if ((efi.systab->hdr.revision >> 16) == 0)
+		pr_warn("Warning: EFI system table version %d.%02d, expected 1.00 or greater\n",
+			efi.systab->hdr.revision >> 16,
+			efi.systab->hdr.revision & 0xffff);
+
+	/* Show what we know for posterity */
+	c16 = (efi_char16_t *)early_ioremap(efi.systab->fw_vendor,
+					    sizeof(vendor));
+	if (c16) {
+		for (i = 0; i < (int) sizeof(vendor) - 1 && *c16; ++i)
+			vendor[i] = c16[i];
+		vendor[i] = '\0';
+	}
+
+	pr_info("EFI v%u.%.02u by %s\n",
+		efi.systab->hdr.revision >> 16,
+		efi.systab->hdr.revision & 0xffff, vendor);
+
+	retval = efi_config_init(NULL);
+	if (retval == 0)
+		set_bit(EFI_CONFIG_TABLES, &arm_efi_facility);
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
+	}
+
+	return 1;
+}
+
+static __initdata struct {
+	u32 type;
+	const char *name;
+}  memory_type_name_map[] = {
+	{EFI_RESERVED_TYPE, "EFI reserved"},
+	{EFI_LOADER_CODE, "EFI loader code"},
+	{EFI_LOADER_DATA, "EFI loader data"},
+	{EFI_BOOT_SERVICES_CODE, "EFI boot services code"},
+	{EFI_BOOT_SERVICES_DATA, "EFI boot services data"},
+	{EFI_RUNTIME_SERVICES_CODE, "EFI runtime services code"},
+	{EFI_RUNTIME_SERVICES_DATA, "EFI runtime services data"},
+	{EFI_CONVENTIONAL_MEMORY, "EFI conventional memory"},
+	{EFI_UNUSABLE_MEMORY, "EFI unusable memory"},
+	{EFI_ACPI_RECLAIM_MEMORY, "EFI ACPI reclaim memory"},
+	{EFI_ACPI_MEMORY_NVS, "EFI ACPI memory nvs"},
+	{EFI_MEMORY_MAPPED_IO, "EFI memory mapped I/O"},
+	{EFI_MEMORY_MAPPED_IO_PORT_SPACE, "EFI memory mapped I/O port space"},
+	{EFI_PAL_CODE, "EFI pal code"},
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
+	void *p;
+
+	memmap.phys_map = (void *) (u32) efi_boot_mmap;
+	memmap.desc_size = efi_mmap_desc_size;
+	memmap.desc_version = efi_mmap_desc_ver;
+	memmap.map_end = (void *) memmap.phys_map + efi_boot_mmap_size;
+	memmap.nr_map = 0;
+
+	if (uefi_debug)
+		pr_info("Processing EFI memory map:\n");
+
+	for (p = memmap.phys_map; p < memmap.map_end; p += memmap.desc_size) {
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
+	if (uefi_debug)
+		pr_info("%d regions preserved.\n", memmap.nr_map);
+
+	return 0;
+}
+
+int __init efi_memblock_arm_reserve_range(void)
+{
+	if (!of_scan_flat_dt(fdt_find_efi_params, NULL))
+		return 0;
+
+	set_bit(EFI_BOOT, &arm_efi_facility);
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
+/*
+ * Memory map was previously extracted from flattened device tree for
+ * reserving regions. Now we need to grab it from the unflattened tree
+ * in order to access it for remapping purposes.
+ */
+static void __init *get_runtime_mmap(void)
+{
+	struct device_node *node;
+	int len;
+	void *map;
+
+	node = of_find_node_by_path("/chosen");
+	if (node != NULL) {
+		map = (void *) of_get_property(node, "linux,efi-mmap", &len);
+
+		if (len != efi_boot_mmap_size) {
+			pr_info(" EFI mmap size mismatch!\n");
+			map = NULL;
+		}
+	} else {
+		map = NULL;
+	}
+
+	return map;
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
+		va = (u64)((u32)efi_remap(paddr, size) & 0xffffffffUL);
+	else
+		va = (u64)((u32)efi_ioremap(paddr, size) & 0xffffffffUL);
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
+	memmap.phys_map = get_runtime_mmap();
+	if (!memmap.phys_map)
+		return 0;
+	memmap.map_end = (void *)memmap.phys_map + efi_boot_mmap_size;
+
+	/* Allocate space for the physical region map */
+	memmap.map = kzalloc(memmap.nr_map * memmap.desc_size, GFP_KERNEL);
+	if (!memmap.map)
+		return 0;
+
+	next = memmap.map;
+	for (p = memmap.phys_map; p < memmap.map_end; p += memmap.desc_size) {
+		md = p;
+		if (is_discardable_region(md))
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
+	efi.systab = efi_lookup_mapped_addr(efi_system_table);
+	if (efi.systab)
+		set_bit(EFI_SYSTEM_TABLES, &arm_efi_facility);
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
+ * This function switches the EFI runtime services to virtual mode.
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
+	efi_phys_call_t *phys_set_map;
+	efi_status_t status;
+
+	phys_call_prologue();
+
+	phys_set_map = (void *)(unsigned long)virt_to_phys(efi_phys_call);
+
+	/* Called with caches disabled, returns with caches enabled */
+	status = phys_set_map(memory_map_size, descriptor_size,
+			      descriptor_version, dsc,
+			      efi.set_virtual_address_map);
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
+
+	if (!efi_enabled(EFI_BOOT)) {
+		pr_info("EFI services will not be available.\n");
+		return;
+	} else {
+		pr_info("Remapping and enabling EFI services.\n");
+	}
+
+	/* Map the regions we memblock_remove:d earlier into kernel
+	   address space */
+	if (!remap_regions()) {
+		pr_info("Failed to remap EFI regions - runtime services will not be available.\n");
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
+		pr_info("Failed to set EFI virtual address map!\n");
+		return;
+	}
+
+	/* Set up function pointers for efivars */
+	efi.get_variable = (efi_get_variable_t *)runtime->get_variable;
+	efi.get_next_variable =
+		(efi_get_next_variable_t *)runtime->get_next_variable;
+	efi.set_variable = (efi_set_variable_t *)runtime->set_variable;
+	set_bit(EFI_RUNTIME_SERVICES, &arm_efi_facility);
+}
diff --git a/arch/arm/kernel/efi_phys.S b/arch/arm/kernel/efi_phys.S
new file mode 100644
index 0000000..e36cc17
--- /dev/null
+++ b/arch/arm/kernel/efi_phys.S
@@ -0,0 +1,59 @@
+/*
+ * arch/arm/kernel/efi_phys.S
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
+@ efi_phys_call(a, b, c, d, *f)
+	.align  5
+        .pushsection    .idmap.text, "ax"
+ENTRY(efi_phys_call)
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
+ENDPROC(efi_phys_call)
+        .popsection
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index b0b2360..87ff95d 100644
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
+#include <asm/efi.h>
 
 #include "atags.h"
 
@@ -884,6 +886,10 @@ void __init setup_arch(char **cmdline_p)
 	sanity_check_meminfo();
 	arm_memblock_init(&meminfo, mdesc);
 
+#ifdef CONFIG_EFI
+	efi_memblock_arm_reserve_range();
+#endif
+
 	paging_init(mdesc);
 	request_standard_resources(mdesc);
 
diff --git a/include/linux/efi.h b/include/linux/efi.h
index c084b6d..ba4d175 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -644,7 +644,7 @@ extern int __init efi_setup_pcdp_console(char *);
 #define EFI_64BIT		5	/* Is the firmware 64-bit? */
 
 #ifdef CONFIG_EFI
-# ifdef CONFIG_X86
+# if defined(CONFIG_X86) || defined(CONFIG_ARM)
 extern int efi_enabled(int facility);
 # else
 static inline int efi_enabled(int facility)
-- 
1.7.10.4

