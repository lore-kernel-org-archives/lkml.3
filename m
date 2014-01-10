Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758256AbaAJWaX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 17:30:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44555 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757474AbaAJWaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 17:30:17 -0500
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, matt.fleming@intel.com,
        Leif Lindholm <leif.lindholm@linaro.org>, roy.franz@linaro.org,
        patches@linaro.org, Grant Likely <grant.likely@secretlab.ca>,
        Mark Salter <msalter@redhat.com>
Subject: [PATCH 6/6] arm64: add EFI runtime services
Date: Fri, 10 Jan 2014 17:29:10 -0500
Message-Id: <1389392950-22457-7-git-send-email-msalter@redhat.com>
In-Reply-To: <1389392950-22457-1-git-send-email-msalter@redhat.com>
References: <1389392950-22457-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds EFI runtime support for arm64. The runtime support allows
the kernel to access various EFI runtime services provided by EFI firmware.
Things like reboot, real time clock, EFI boot variables, and others.

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 arch/arm64/Kconfig           |  16 ++
 arch/arm64/include/asm/efi.h |  12 ++
 arch/arm64/kernel/Makefile   |   1 +
 arch/arm64/kernel/efi.c      | 353 +++++++++++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/setup.c    |   6 +
 include/linux/efi.h          |   2 +-
 6 files changed, 389 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/include/asm/efi.h
 create mode 100644 arch/arm64/kernel/efi.c

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 3f1c2b2..862026d 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -249,6 +249,20 @@ config CMDLINE_FORCE
 	  This is useful if you cannot or don't want to change the
 	  command-line options your boot loader passes to the kernel.
 
+config EFI
+        bool "EFI runtime service support"
+	depends on !ARM64_64K_PAGES && OF
+	select UCS2_STRING
+	select LIBFDT
+	select UEFI_PARAMS_FROM_FDT
+	help
+	  This enables the kernel to use UEFI runtime services that are
+	  available (such as the UEFI variable services).
+
+	  This option is only useful on systems that have UEFI firmware.
+	  However, even with this option, the resultant kernel should
+	  continue to boot on existing non-UEFI platforms.
+
 config EFI_STUB
 	bool "EFI stub support"
 	depends on !ARM64_64K_PAGES && OF
@@ -290,6 +304,8 @@ source "net/Kconfig"
 
 source "drivers/Kconfig"
 
+source "drivers/firmware/Kconfig"
+
 source "fs/Kconfig"
 
 source "arch/arm64/kvm/Kconfig"
diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
new file mode 100644
index 0000000..a835b2c
--- /dev/null
+++ b/arch/arm64/include/asm/efi.h
@@ -0,0 +1,12 @@
+#ifndef _ASM_ARM64_EFI_H
+#define _ASM_ARM64_EFI_H
+
+#include <asm/io.h>
+
+#ifdef CONFIG_EFI
+extern void efi_init(void);
+#else
+#define efi_init()
+#endif
+
+#endif /* _ASM_ARM64_EFI_H */
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index 1c52b84..8897cf5a5 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -21,6 +21,7 @@ arm64-obj-$(CONFIG_HW_PERF_EVENTS)	+= perf_event.o
 arm64-obj-$(CONFIG_HAVE_HW_BREAKPOINT)+= hw_breakpoint.o
 arm64-obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
 arm64-obj-$(CONFIG_EFI_STUB)		+= efi-stub.o efi-entry.o
+arm64-obj-$(CONFIG_EFI)			+= efi.o
 
 obj-y					+= $(arm64-obj-y) vdso/
 obj-m					+= $(arm64-obj-m)
diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
new file mode 100644
index 0000000..a42dc38
--- /dev/null
+++ b/arch/arm64/kernel/efi.c
@@ -0,0 +1,353 @@
+/*
+ * Extensible Firmware Interface
+ *
+ * Based on Extensible Firmware Interface Specification version 2.4
+ *
+ * Copyright (C) 2013 Linaro Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
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
+#include <asm/tlbflush.h>
+#include <asm/mmu_context.h>
+
+struct efi_memory_map memmap;
+
+static efi_runtime_services_t *runtime;
+
+static u64 efi_system_table;
+
+static unsigned long arm_efi_facility;
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
+static void __init efi_setup_idmap(void)
+{
+	unsigned long len;
+	struct memblock_region *r;
+
+	for_each_memblock(memory, r) {
+		/* section align addr/len */
+		len = ALIGN(r->size + (r->base & ~SECTION_MASK), SECTION_SIZE);
+		create_id_mapping(r->base & SECTION_MASK, len);
+	}
+}
+
+static int __init uefi_init(void)
+{
+	efi_char16_t *c16;
+	char vendor[100] = "unknown";
+	int i, retval;
+
+	efi.systab = early_memremap(efi_system_table,
+				    sizeof(efi_system_table_t));
+	if (efi.systab == NULL) {
+		pr_warn("Unable to map EFI system table.\n");
+		return -ENOMEM;
+	}
+
+	set_bit(EFI_BOOT, &arm_efi_facility);
+	set_bit(EFI_64BIT, &arm_efi_facility);
+
+	/*
+	 * Verify the EFI Table
+	 */
+	if (efi.systab->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE) {
+		pr_err("System table signature incorrect\n");
+		return -EINVAL;
+	}
+	if ((efi.systab->hdr.revision >> 16) < 2)
+		pr_warn("Warning: EFI system table version %d.%02d, expected 2.00 or greater\n",
+			efi.systab->hdr.revision >> 16,
+			efi.systab->hdr.revision & 0xffff);
+
+	/* Show what we know for posterity */
+	c16 = early_memremap(efi.systab->fw_vendor,
+			     sizeof(vendor));
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
+	early_memunmap(c16, sizeof(vendor));
+	early_memunmap(efi.systab,  sizeof(efi_system_table_t));
+
+	return retval;
+}
+
+static __initdata char memory_type_name[][32] = {
+	{"Reserved"},
+	{"Loader Code"},
+	{"Loader Data"},
+	{"Boot Code"},
+	{"Boot Data"},
+	{"Runtime Code"},
+	{"Runtime Data"},
+	{"Conventional Memory"},
+	{"Unusable Memory"},
+	{"ACPI Reclaim Memory"},
+	{"ACPI Memory NVS"},
+	{"Memory Mapped I/O"},
+	{"MMIO Port Space"},
+	{"PAL Code"},
+};
+
+static __init void reserve_regions(void)
+{
+	efi_memory_desc_t *md;
+	u64 paddr, npages, size;
+
+	if (uefi_debug)
+		pr_info("Processing EFI memory map:\n");
+
+	for_each_efi_memory_desc(&memmap, md) {
+		paddr = md->phys_addr;
+		npages = md->num_pages;
+		memrange_efi_to_native(&paddr, &npages);
+		size = npages << PAGE_SHIFT;
+
+		if (uefi_debug)
+			pr_info("  0x%012llx-0x%012llx [%s]",
+				paddr, paddr + size - 1,
+				memory_type_name[md->type]);
+
+		if ((md->attribute & EFI_MEMORY_RUNTIME) ||
+		    md->type == EFI_BOOT_SERVICES_CODE ||
+		    md->type == EFI_BOOT_SERVICES_DATA ||
+		    md->type == EFI_ACPI_RECLAIM_MEMORY) {
+			if (md->type != EFI_MEMORY_MAPPED_IO) {
+				memblock_reserve(paddr, size);
+				if (uefi_debug)
+					pr_cont("*");
+			}
+		}
+
+		if (uefi_debug)
+			pr_cont("\n");
+	}
+}
+
+static void __init free_boot_services(void)
+{
+	u64 total_freed = 0;
+	efi_memory_desc_t *md;
+
+	for_each_efi_memory_desc(&memmap, md) {
+		u64 paddr, npages, size;
+
+		if (md->type != EFI_BOOT_SERVICES_CODE &&
+		    md->type != EFI_BOOT_SERVICES_DATA)
+			continue;
+
+		/* Don't free areas not reserved by reserve_regions() */
+		if (!md->num_pages)
+			continue;
+
+		paddr = md->phys_addr;
+		npages = md->num_pages;
+		memrange_efi_to_native(&paddr, &npages);
+		size = npages << PAGE_SHIFT;
+
+		if (uefi_debug)
+			pr_info("  EFI freeing: 0x%012llx-0x%012llx [%s]\n",
+				paddr, paddr + size - 1,
+				memory_type_name[md->type]);
+
+		memblock_free(paddr, size);
+		total_freed += size;
+	}
+	if (total_freed)
+		pr_info("Freed 0x%llx bytes of EFI boot services memory",
+			total_freed);
+}
+
+void __init efi_init(void)
+{
+	struct efi_fdt_params params;
+
+	/* Grab UEFI information placed in FDT by stub */
+	if (!efi_get_fdt_params(&params, uefi_debug))
+		return;
+
+	efi_system_table = params.system_table;
+
+	memblock_reserve(params.mmap, params.mmap_size);
+	memmap.phys_map = (void *)params.mmap;
+	memmap.map = early_memremap(params.mmap, params.mmap_size);
+	memmap.map_end = memmap.map + params.mmap_size;
+	memmap.desc_size = params.desc_size;
+	memmap.desc_version = params.desc_ver;
+
+	if (uefi_init() < 0)
+		return;
+
+	reserve_regions();
+}
+
+static int __init remap_region(efi_memory_desc_t *md, void **new)
+{
+	u64 paddr, npages, size;
+
+	paddr = md->phys_addr;
+	npages = md->num_pages;
+	memrange_efi_to_native(&paddr, &npages);
+	size = npages << PAGE_SHIFT;
+
+	/*
+	 * Map everything writeback-capable as coherent memory,
+	 * anything else as device.
+	 */
+	if (md->attribute & EFI_MEMORY_WB)
+		md->virt_addr = (__force u64)ioremap_cache(paddr, size);
+	else
+		md->virt_addr = (__force u64)ioremap(paddr, size);
+
+	if (!md->virt_addr) {
+		pr_err("Unable to remap 0x%llx pages @ %p\n",
+		       npages, (void *)paddr);
+		return 0;
+	}
+
+	if (uefi_debug)
+		pr_info("  EFI remap 0x%012llx => %p\n",
+			md->phys_addr, (void *)md->virt_addr);
+
+	memcpy(*new, md, memmap.desc_size);
+	*new += memmap.desc_size;
+
+	return 1;
+}
+
+/*
+ * Called from setup_arch with interrupts disabled.
+ */
+void __init efi_enter_virtual_mode(void)
+{
+	efi_memory_desc_t *md;
+	phys_addr_t virtmap_phys;
+	void *virtmap, *virt_md;
+	efi_status_t status;
+	u64 mapsize;
+	int count = 0;
+
+	if (!efi_enabled(EFI_BOOT)) {
+		pr_info("EFI services will not be available.\n");
+		return;
+	}
+
+	pr_info("Remapping and enabling EFI services.\n");
+
+	/* replace early memmap mapping with permanent mapping */
+	mapsize = memmap.map_end - memmap.map;
+	early_memunmap(memmap.map, mapsize);
+	memmap.map = (__force void *)ioremap_cache((phys_addr_t)memmap.phys_map,
+						   mapsize);
+	memmap.map_end = memmap.map + mapsize;
+
+	efi.memmap = &memmap;
+
+	/* Map the runtime regions */
+	virtmap_phys = memblock_alloc(mapsize, PAGE_SIZE);
+	if (!virtmap_phys) {
+		pr_err("Failed to allocate EFI virtual memmap\n");
+		return;
+	}
+	virtmap = phys_to_virt(virtmap_phys);
+	virt_md = virtmap;
+
+	for_each_efi_memory_desc(&memmap, md) {
+		if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
+		    md->type != EFI_ACPI_RECLAIM_MEMORY)
+			continue;
+		if (remap_region(md, &virt_md))
+			++count;
+	}
+
+	efi.systab = (__force void *)efi_lookup_mapped_addr(efi_system_table);
+	if (efi.systab)
+		set_bit(EFI_SYSTEM_TABLES, &arm_efi_facility);
+
+	/* boot time idmap_pg_dir is incomplete, so fill in missing parts */
+	efi_setup_idmap();
+
+	cpu_switch_mm(idmap_pg_dir, &init_mm);
+	flush_tlb_all();
+	flush_cache_all();
+
+	/* Call SetVirtualAddressMap with the physical address of the map */
+	runtime = efi.systab->runtime;
+	efi.set_virtual_address_map = runtime->set_virtual_address_map;
+
+	status = efi.set_virtual_address_map(count * memmap.desc_size,
+					     memmap.desc_size,
+					     memmap.desc_version,
+					     (efi_memory_desc_t *)virtmap_phys);
+	cpu_set_reserved_ttbr0();
+	flush_tlb_all();
+	flush_cache_all();
+
+	memblock_free(virtmap_phys, mapsize);
+
+	free_boot_services();
+
+	if (status != EFI_SUCCESS) {
+		pr_err("Failed to set EFI virtual address map! [%lx]\n",
+			status);
+		return;
+	}
+
+	/* Set up runtime services function pointers */
+	runtime = efi.systab->runtime;
+	efi.get_time = runtime->get_time;
+	efi.set_time = runtime->set_time;
+	efi.get_wakeup_time = runtime->get_wakeup_time;
+	efi.set_wakeup_time = runtime->set_wakeup_time;
+	efi.get_variable = runtime->get_variable;
+	efi.get_next_variable = runtime->get_next_variable;
+	efi.set_variable = runtime->set_variable;
+	efi.query_variable_info = runtime->query_variable_info;
+	efi.update_capsule = runtime->update_capsule;
+	efi.query_capsule_caps = runtime->query_capsule_caps;
+	efi.get_next_high_mono_count = runtime->get_next_high_mono_count;
+	efi.reset_system = runtime->reset_system;
+
+	set_bit(EFI_RUNTIME_SERVICES, &arm_efi_facility);
+}
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index 5516f54..7a45095 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -41,6 +41,7 @@
 #include <linux/memblock.h>
 #include <linux/of_fdt.h>
 #include <linux/of_platform.h>
+#include <linux/efi.h>
 
 #include <asm/fixmap.h>
 #include <asm/cputype.h>
@@ -55,6 +56,7 @@
 #include <asm/traps.h>
 #include <asm/memblock.h>
 #include <asm/psci.h>
+#include <asm/efi.h>
 
 unsigned int processor_id;
 EXPORT_SYMBOL(processor_id);
@@ -229,9 +231,13 @@ void __init setup_arch(char **cmdline_p)
 
 	arm64_memblock_init();
 
+	efi_init();
 	paging_init();
 	request_standard_resources();
 
+	if (efi_enabled(EFI_BOOT))
+		efi_enter_virtual_mode();
+
 	unflatten_device_tree();
 
 	psci_init();
diff --git a/include/linux/efi.h b/include/linux/efi.h
index ff8524e..4d73efe 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -670,7 +670,7 @@ extern int __init efi_setup_pcdp_console(char *);
 #define EFI_64BIT		5	/* Is the firmware 64-bit? */
 
 #ifdef CONFIG_EFI
-# ifdef CONFIG_X86
+# if defined(CONFIG_X86) || defined(CONFIG_ARM64)
 extern int efi_enabled(int facility);
 # else
 static inline int efi_enabled(int facility)
-- 
1.8.3.1

