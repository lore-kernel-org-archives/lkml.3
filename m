Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149Ab3K2WGP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 17:06:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47601 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755509Ab3K2WGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 17:06:00 -0500
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: patches@linaro.org, Mark Salter <msalter@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org, matt.fleming@intel.com,
        linux-efi@vger.kernel.org, Leif Lindholm <leif.lindholm@linaro.org>,
        roy.franz@linaro.org
Subject: [PATCH 3/3] arm64: add EFI runtime services
Date: Fri, 29 Nov 2013 17:05:12 -0500
Message-Id: <1385762712-17043-4-git-send-email-msalter@redhat.com>
In-Reply-To: <1385762712-17043-1-git-send-email-msalter@redhat.com>
References: <1385762712-17043-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds EFI runtime support for arm64. The runtime support allows the
kernel to access various EFI runtime services provided by EFI firmware. Things
like reboot, real time clock, EFI boot variables, and others.

Signed-off-by: Mark Salter <msalter@redhat.com>
CC: Catalin Marinas <catalin.marinas@arm.com>
CC: Will Deacon <will.deacon@arm.com>
CC: linux-arm-kernel@lists.infradead.org
CC: matt.fleming@intel.com
CC: linux-efi@vger.kernel.org
CC: Leif Lindholm <leif.lindholm@linaro.org>
CC: roy.franz@linaro.org
---
 arch/arm64/Kconfig           |  15 ++
 arch/arm64/include/asm/efi.h |  18 ++
 arch/arm64/kernel/Makefile   |   1 +
 arch/arm64/kernel/efi.c      | 507 +++++++++++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/setup.c    |   6 +
 include/linux/efi.h          |   2 +-
 6 files changed, 548 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/include/asm/efi.h
 create mode 100644 arch/arm64/kernel/efi.c

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 10b0e93..6baaf75 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -250,6 +250,19 @@ config CMDLINE_FORCE
 	  This is useful if you cannot or don't want to change the
 	  command-line options your boot loader passes to the kernel.
 
+config EFI
+        bool "EFI runtime service support"
+	depends on !CPU_BIG_ENDIAN && !ARM64_64K_PAGES && OF
+	select UCS2_STRING
+	select LIBFDT
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
 	depends on !CPU_BIG_ENDIAN && !ARM64_64K_PAGES && OF
@@ -291,6 +304,8 @@ source "net/Kconfig"
 
 source "drivers/Kconfig"
 
+source "drivers/firmware/Kconfig"
+
 source "fs/Kconfig"
 
 source "arch/arm64/kvm/Kconfig"
diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
new file mode 100644
index 0000000..7384048
--- /dev/null
+++ b/arch/arm64/include/asm/efi.h
@@ -0,0 +1,18 @@
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
+#define efi_remap(cookie, size) __ioremap((cookie), (size), PAGE_KERNEL_EXEC)
+#define efi_ioremap(cookie, size) __ioremap((cookie), (size), \
+					    __pgprot(PROT_DEVICE_nGnRE))
+#define efi_unmap(cookie) __iounmap((cookie))
+#define efi_iounmap(cookie) __iounmap((cookie))
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
index 0000000..1bad8a7
--- /dev/null
+++ b/arch/arm64/kernel/efi.c
@@ -0,0 +1,507 @@
+/*
+ * Extensible Firmware Interface
+ *
+ * Based on Extensible Firmware Interface Specification version 2.3.1
+ *
+ * Copyright (C) 2013 Linaro Ltd.
+ *
+ * Adapted for arm64 from arch/arm/kernel/efi.c code
+ */
+
+#include <linux/efi.h>
+#include <linux/export.h>
+#include <linux/memblock.h>
+#include <linux/of.h>
+#include <linux/of_fdt.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/bootmem.h>
+
+#include <asm/cacheflush.h>
+#include <asm/efi.h>
+#include <asm/tlbflush.h>
+#include <asm/mmu_context.h>
+
+#define efi_early_remap(a, b) \
+	((__force void *)early_ioremap((a), (b)))
+#define efi_early_unmap(a, b) \
+	early_iounmap((void __iomem *)(a), (b))
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
+static int __init fdt_find_efi_params(unsigned long node, const char *uname,
+				      int depth, void *data)
+{
+	unsigned long len, size;
+	__be32 *prop;
+
+	if (depth != 1 ||
+	    (strcmp(uname, "chosen") != 0 && strcmp(uname, "chosen@0") != 0))
+		return 0;
+
+	pr_info("Getting EFI parameters from FDT.\n");
+
+	prop = of_get_flat_dt_prop(node, "linux,uefi-system-table", &len);
+	if (!prop) {
+		pr_err("No EFI system table in FDT\n");
+		return 0;
+	}
+	efi_system_table = of_read_ulong(prop, len/4);
+
+	prop = of_get_flat_dt_prop(node, "linux,uefi-mmap-start", &len);
+	if (!prop) {
+		pr_err("No EFI memmap in FDT\n");
+		return 0;
+	}
+	memmap.phys_map = (void *)of_read_ulong(prop, len/4);
+
+	prop = of_get_flat_dt_prop(node, "linux,uefi-mmap-size", &len);
+	if (!prop) {
+		pr_err("No EFI memmap size in FDT\n");
+		return 0;
+	}
+	size = of_read_ulong(prop, len/4);
+	memmap.map_end = memmap.phys_map + size;
+
+	/* reserve memmap */
+	memblock_reserve((u64)memmap.phys_map, size);
+
+	prop = of_get_flat_dt_prop(node, "linux,uefi-mmap-desc-size", &len);
+	if (!prop) {
+		pr_err("No EFI memmap descriptor size in FDT\n");
+		return 0;
+	}
+	memmap.desc_size = of_read_ulong(prop, len/4);
+
+	memmap.nr_map = size / memmap.desc_size;
+
+	prop = of_get_flat_dt_prop(node, "linux,uefi-mmap-desc-ver", &len);
+	if (!prop) {
+		pr_err("No EFI memmap descriptor version in FDT\n");
+		return 0;
+	}
+	memmap.desc_version = of_read_ulong(prop, len/4);
+
+	if (uefi_debug) {
+		pr_info("  EFI system table @ %p\n", (void *)efi_system_table);
+		pr_info("  EFI mmap @ %p-%p\n", memmap.phys_map,
+			memmap.map_end);
+		pr_info("  EFI mmap descriptor size = 0x%lx\n",
+			memmap.desc_size);
+		pr_info("  EFI mmap descriptor version = 0x%lx\n",
+			memmap.desc_version);
+	}
+
+	return 1;
+}
+
+#define PGD_END  (&idmap_pg_dir[sizeof(idmap_pg_dir)/sizeof(pgd_t)])
+#ifndef CONFIG_SMP
+#define PMD_FLAGS  (PMD_ATTRINDX(MT_NORMAL) | PMD_TYPE_SECT | PMD_SECT_AF)
+#else
+#define PMD_FLAGS  (PMD_ATTRINDX(MT_NORMAL) | PMD_TYPE_SECT | PMD_SECT_AF | \
+		    PMD_SECT_S)
+#endif
+
+static void __init create_idmap(unsigned long addr, unsigned long len)
+{
+	unsigned long end, next, p;
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+
+	/* section align it */
+	len = ALIGN(len + (addr & ~SECTION_MASK), SECTION_SIZE);
+	addr &= SECTION_MASK;
+
+	end = addr + len;
+	pgd = &idmap_pg_dir[pgd_index(addr)];
+
+	do {
+		next = pgd_addr_end(addr, end);
+		if (pgd >= PGD_END)
+			continue;
+
+		pud = pud_offset(pgd, addr);
+		if (pud_none(*pud)) {
+			pmd = alloc_bootmem_pages(PAGE_SIZE);
+			if (!pmd)
+				continue;
+			set_pud(pud, __pud(__pa(pmd) | PMD_TYPE_TABLE));
+		}
+
+		for (p = addr; p < next; p += SECTION_SIZE) {
+			pmd = pmd_offset(pud, p);
+
+			if (pmd_none(*pmd))
+				set_pmd(pmd, __pmd(p | PMD_FLAGS));
+		}
+	} while (pgd++, addr = next, addr != end);
+}
+
+static void __init efi_setup_idmap(void)
+{
+	struct memblock_region *r;
+
+	for_each_memblock(memory, r)
+		create_idmap(r->base, r->size);
+}
+
+static int __init uefi_init(void)
+{
+	efi_char16_t *c16;
+	char vendor[100] = "unknown";
+	int i, retval;
+
+	efi.systab = efi_early_remap(efi_system_table,
+				     sizeof(efi_system_table_t));
+
+	/*
+	 * Verify the EFI Table
+	 */
+	if (efi.systab == NULL)
+		panic("Whoa! Can't map EFI system table.\n");
+	if (efi.systab->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
+		panic("Whoa! EFI system table signature incorrect\n");
+	if ((efi.systab->hdr.revision >> 16) == 0)
+		pr_warn("Warning: EFI system table version %d.%02d, expected 1.00 or greater\n",
+			efi.systab->hdr.revision >> 16,
+			efi.systab->hdr.revision & 0xffff);
+
+	/* Show what we know for posterity */
+	c16 = efi_early_remap(efi.systab->fw_vendor,
+			      sizeof(vendor));
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
+	efi_early_unmap(c16, sizeof(vendor));
+	efi_early_unmap(efi.systab,  sizeof(efi_system_table_t));
+
+	return retval;
+}
+
+static __initdata struct {
+	u32 type;
+	const char *name;
+}  memory_type_name_map[] = {
+	{EFI_RESERVED_TYPE, "Reserved"},
+	{EFI_LOADER_CODE, "Loader Code"},
+	{EFI_LOADER_DATA, "Loader Data"},
+	{EFI_BOOT_SERVICES_CODE, "Boot Code"},
+	{EFI_BOOT_SERVICES_DATA, "Boot Data"},
+	{EFI_RUNTIME_SERVICES_CODE, "Runtime Code"},
+	{EFI_RUNTIME_SERVICES_DATA, "Runtime Data"},
+	{EFI_CONVENTIONAL_MEMORY, "Conventional Memory"},
+	{EFI_UNUSABLE_MEMORY, "Unusable Memory"},
+	{EFI_ACPI_RECLAIM_MEMORY, "ACPI Reclaim Memory"},
+	{EFI_ACPI_MEMORY_NVS, "ACPI Memory NVS"},
+	{EFI_MEMORY_MAPPED_IO, "Memory Mapped I/O"},
+	{EFI_MEMORY_MAPPED_IO_PORT_SPACE, "MMIO Port Space"},
+	{EFI_PAL_CODE, "PAL Code"},
+	{EFI_MAX_MEMORY_TYPE, NULL},
+};
+
+/* memmap walk functions may return one of these or a negative error */
+#define MEMMAP_WALK_CONT 0
+#define MEMMAP_WALK_STOP 1
+
+static __init int memmap_walk(struct efi_memory_map *memmap,
+			      int (*func)(efi_memory_desc_t *, void *),
+			      void *private_data, int early)
+{
+	void *start, *map;
+	unsigned long len;
+	int i, ret;
+
+	if (early) {
+		len = memmap->map_end - memmap->phys_map;
+		map = start = efi_early_remap((u64)memmap->phys_map, len);
+		if (map == NULL)
+			panic("Can't map EFI memory map.\n");
+
+	} else {
+		len = memmap->map_end - memmap->map;
+		map = memmap->map;
+	}
+
+	for (i = 0; i < memmap->nr_map; i++, map += memmap->desc_size) {
+		ret = func(map, private_data);
+		if (ret)
+			break;
+	}
+
+	if (early)
+		efi_early_unmap(start, len);
+
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static __init int reserve_region(efi_memory_desc_t *md, void *priv)
+{
+	u64 paddr, npages;
+	int *count = priv;
+
+	paddr = md->phys_addr;
+	npages = md->num_pages;
+	memrange_efi_to_native(&paddr, &npages);
+
+	if (uefi_debug)
+		pr_info("  0x%012llx-0x%012llx [%s]",
+			paddr, paddr + (npages << PAGE_SHIFT) - 1,
+			memory_type_name_map[md->type].name);
+
+	if ((md->attribute & EFI_MEMORY_RUNTIME) ||
+	    md->type == EFI_BOOT_SERVICES_CODE ||
+	    md->type == EFI_BOOT_SERVICES_DATA ||
+	    md->type == EFI_ACPI_RECLAIM_MEMORY) {
+		if (md->type != EFI_MEMORY_MAPPED_IO) {
+			memblock_reserve(paddr, npages << PAGE_SHIFT);
+			if (uefi_debug)
+				pr_cont("*");
+			*count += 1;
+		}
+	}
+
+	if (uefi_debug)
+		pr_cont("\n");
+
+	return MEMMAP_WALK_CONT;
+}
+
+static __init void reserve_regions(void)
+{
+	int nr_reserved = 0;
+
+	if (uefi_debug)
+		pr_info("Processing EFI memory map:\n");
+
+	memmap_walk(&memmap, reserve_region, &nr_reserved, 1);
+
+	if (uefi_debug)
+		pr_info("%d EFI regions reserved.\n", nr_reserved);
+}
+
+void __init efi_init(void)
+{
+	/* Grab EFI information from FDT */
+	if (!of_scan_flat_dt(fdt_find_efi_params, NULL))
+		return;
+
+	set_bit(EFI_BOOT, &arm_efi_facility);
+	set_bit(EFI_64BIT, &arm_efi_facility);
+
+	uefi_init();
+
+	reserve_regions();
+}
+
+static int __init remap_region(efi_memory_desc_t *md, void *priv)
+{
+	efi_memory_desc_t *new;
+	u64 paddr, npages, size;
+
+	if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
+	    md->type != EFI_ACPI_RECLAIM_MEMORY)
+		return MEMMAP_WALK_CONT;
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
+	if (md->attribute & EFI_MEMORY_WB) {
+		if (memblock_is_memory(paddr))
+			md->virt_addr = (u64)phys_to_virt(paddr);
+		else
+			md->virt_addr = (__force u64)efi_remap(paddr, size);
+	} else
+		md->virt_addr = (__force u64)efi_ioremap(paddr, size);
+
+	if (!md->virt_addr)
+		panic("EFI unable to remap 0x%llx pages @ %p\n",
+		      npages, (void *)paddr);
+
+	if (uefi_debug)
+		pr_info("  EFI remap 0x%012llx => %p\n",
+			md->phys_addr, (void *)md->virt_addr);
+
+	new = *(efi_memory_desc_t **)priv;
+	*new = *md;
+	*(efi_memory_desc_t **)priv = (void *)new + memmap.desc_size;
+
+	return MEMMAP_WALK_CONT;
+}
+
+static int __init remap_regions(efi_memory_desc_t *map)
+{
+	efi_memory_desc_t *new = map;
+
+	memmap_walk(&memmap, remap_region, &new, 0);
+
+	return new - map;
+}
+
+static int __init free_boot_region(efi_memory_desc_t *md, void *priv)
+{
+	u64 *total = priv;
+	u64 paddr, npages, size;
+
+	if (md->type != EFI_BOOT_SERVICES_CODE &&
+	    md->type != EFI_BOOT_SERVICES_DATA)
+		return MEMMAP_WALK_CONT;
+
+	paddr = md->phys_addr;
+	npages = md->num_pages;
+	memrange_efi_to_native(&paddr, &npages);
+	size = npages << PAGE_SHIFT;
+
+	if (uefi_debug)
+		pr_info("  EFI freeing: 0x%012llx-0x%012llx [%s]\n",
+			paddr, paddr + (npages << PAGE_SHIFT) - 1,
+			memory_type_name_map[md->type].name);
+
+	free_bootmem(paddr, size);
+	*total += size;
+
+	return MEMMAP_WALK_CONT;
+}
+
+/*
+ * Called from setup_arch with interrupts disabled.
+ */
+void __init efi_enter_virtual_mode(void)
+{
+	void *newmap;
+	efi_status_t status;
+	u64 mapsize, total_freed = 0;
+	int count;
+
+	if (!efi_enabled(EFI_BOOT)) {
+		pr_info("EFI services will not be available.\n");
+		return;
+	}
+
+	pr_info("Remapping and enabling EFI services.\n");
+
+	mapsize = memmap.map_end - memmap.phys_map;
+	memmap.map = (__force void *)ioremap_cache((phys_addr_t)memmap.phys_map,
+						   mapsize);
+	memmap.map_end = memmap.map + mapsize;
+
+	/* Map the regions we reserved earlier */
+	newmap = alloc_bootmem(mapsize);
+	if (newmap == NULL) {
+		pr_err("Failed to allocate new EFI memmap\n");
+		return;
+	}
+
+	count = remap_regions(newmap);
+	if (count <= 0) {
+		pr_err("Failed to remap EFI regions.\n");
+		return;
+	}
+
+	efi.memmap = &memmap;
+
+	efi.systab = (__force void *)efi_lookup_mapped_addr(efi_system_table);
+	if (efi.systab)
+		set_bit(EFI_SYSTEM_TABLES, &arm_efi_facility);
+
+	/*
+	 * efi.systab->runtime is a pointer to something guaranteed by
+	 * the UEFI specification to be 1:1 mapped.
+	 */
+	runtime = (__force void *)efi_lookup_mapped_addr((u64)efi.systab->runtime);
+
+	/* Call SetVirtualAddressMap with the physical address of the map */
+	efi.set_virtual_address_map = runtime->set_virtual_address_map;
+
+	/* boot time idmap_pg_dir is incomplete, so fill in missing parts */
+	efi_setup_idmap();
+
+	cpu_switch_mm(idmap_pg_dir, &init_mm);
+	flush_tlb_all();
+	flush_cache_all();
+
+	status = efi.set_virtual_address_map(count * memmap.desc_size,
+					     memmap.desc_size,
+					     memmap.desc_version,
+					     newmap);
+	cpu_set_reserved_ttbr0();
+	flush_tlb_all();
+	flush_cache_all();
+
+	free_bootmem((unsigned long)newmap, mapsize);
+
+	if (status != EFI_SUCCESS) {
+		pr_err("Failed to set EFI virtual address map! [%lx]\n",
+			status);
+		return;
+	}
+
+	pr_info("EFI Virtual address map set\n");
+
+	/* Okay to free boot services memory now */
+	memmap_walk(&memmap, free_boot_region, &total_freed, 0);
+	if (total_freed)
+		pr_info("Freed 0x%llx bytes of EFI boot services memory",
+			total_freed);
+
+	/* Set up runtime services function pointers */
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
index 790871a..395ab1d 100644
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
@@ -222,9 +224,13 @@ void __init setup_arch(char **cmdline_p)
 
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
index bc5687d..510a6d0 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -655,7 +655,7 @@ extern int __init efi_setup_pcdp_console(char *);
 #define EFI_64BIT		5	/* Is the firmware 64-bit? */
 
 #ifdef CONFIG_EFI
-# ifdef CONFIG_X86
+# if defined(CONFIG_X86) || defined(CONFIG_ARM64)
 extern int efi_enabled(int facility);
 # else
 static inline int efi_enabled(int facility)
-- 
1.8.3.1

