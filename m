Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998Ab3CAF1r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 00:27:47 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:10641 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750884Ab3CAF1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 00:27:45 -0500
X-IronPort-AV: E=Sophos;i="4.84,759,1355068800"; 
   d="scan'208";a="6791822"
From: liguang <lig.fnst@cn.fujitsu.com>
To: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc: liguang <lig.fnst@cn.fujitsu.com>
Subject: [PATCH 1/2] x86: change names of e820 memory map type
Date: Fri, 1 Mar 2013 13:27:17 +0800
Message-Id: <1362115638-10583-1-git-send-email-lig.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.2.5
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/01 13:26:47,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/01 13:26:48,
	Serialize complete at 2013/03/01 13:26:48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

E820_RAM -> E820_TYPE_RAM
E820_ACPI-> E820_TYPE_ACPI
...

names like E820_RAM is conflict-prone,
because user is more likely to define
a macro like this if did not strongly
aware this name have been defined
by e820.h

Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
---
 arch/x86/boot/compressed/eboot.c       |   10 +++---
 arch/x86/include/asm/gart.h            |    2 +-
 arch/x86/include/uapi/asm/e820.h       |   12 ++++----
 arch/x86/kernel/acpi/boot.c            |    2 +-
 arch/x86/kernel/aperture_64.c          |    4 +-
 arch/x86/kernel/cpu/centaur.c          |    2 +-
 arch/x86/kernel/cpu/mtrr/cleanup.c     |    2 +-
 arch/x86/kernel/e820.c                 |   52 ++++++++++++++++----------------
 arch/x86/kernel/setup.c                |   22 +++++++-------
 arch/x86/kernel/tboot.c                |    8 ++--
 arch/x86/mm/init_64.c                  |   12 ++++----
 arch/x86/pci/mmconfig-shared.c         |    2 +-
 arch/x86/platform/efi/efi.c            |   14 ++++----
 arch/x86/platform/visws/visws_quirks.c |    6 ++--
 arch/x86/xen/setup.c                   |   16 +++++-----
 15 files changed, 83 insertions(+), 83 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index f8fa411..5bda487 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -1040,15 +1040,15 @@ again:
 		case EFI_MEMORY_MAPPED_IO:
 		case EFI_MEMORY_MAPPED_IO_PORT_SPACE:
 		case EFI_PAL_CODE:
-			e820_type = E820_RESERVED;
+			e820_type = E820_TYPE_RESERVED;
 			break;
 
 		case EFI_UNUSABLE_MEMORY:
-			e820_type = E820_UNUSABLE;
+			e820_type = E820_TYPE_UNUSABLE;
 			break;
 
 		case EFI_ACPI_RECLAIM_MEMORY:
-			e820_type = E820_ACPI;
+			e820_type = E820_TYPE_ACPI;
 			break;
 
 		case EFI_LOADER_CODE:
@@ -1056,11 +1056,11 @@ again:
 		case EFI_BOOT_SERVICES_CODE:
 		case EFI_BOOT_SERVICES_DATA:
 		case EFI_CONVENTIONAL_MEMORY:
-			e820_type = E820_RAM;
+			e820_type = E820_TYPE_RAM;
 			break;
 
 		case EFI_ACPI_MEMORY_NVS:
-			e820_type = E820_NVS;
+			e820_type = E820_TYPE_NVS;
 			break;
 
 		default:
diff --git a/arch/x86/include/asm/gart.h b/arch/x86/include/asm/gart.h
index 156cd5d..4d22bcc 100644
--- a/arch/x86/include/asm/gart.h
+++ b/arch/x86/include/asm/gart.h
@@ -97,7 +97,7 @@ static inline int aperture_valid(u64 aper_base, u32 aper_size, u32 min_size)
 		printk(KERN_INFO "Aperture beyond 4GB. Ignoring.\n");
 		return 0;
 	}
-	if (e820_any_mapped(aper_base, aper_base + aper_size, E820_RAM)) {
+	if (e820_any_mapped(aper_base, aper_base + aper_size, E820_TYPE_RAM)) {
 		printk(KERN_INFO "Aperture pointing to e820 RAM. Ignoring.\n");
 		return 0;
 	}
diff --git a/arch/x86/include/uapi/asm/e820.h b/arch/x86/include/uapi/asm/e820.h
index bbae024..2d400b1 100644
--- a/arch/x86/include/uapi/asm/e820.h
+++ b/arch/x86/include/uapi/asm/e820.h
@@ -32,11 +32,11 @@
 
 #define E820NR	0x1e8		/* # entries in E820MAP */
 
-#define E820_RAM	1
-#define E820_RESERVED	2
-#define E820_ACPI	3
-#define E820_NVS	4
-#define E820_UNUSABLE	5
+#define E820_TYPE_RAM	1
+#define E820_TYPE_RESERVED	2
+#define E820_TYPE_ACPI	3
+#define E820_TYPE_NVS	4
+#define E820_TYPE_UNUSABLE	5
 
 
 /*
@@ -45,7 +45,7 @@
  * included in the S3 integrity calculation and so should not include
  * any memory that BIOS might alter over the S3 transition
  */
-#define E820_RESERVED_KERN        128
+#define E820_TYPE_RESERVED_KERN        128
 
 #ifndef __ASSEMBLY__
 #include <linux/types.h>
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 230c8ea..9595747 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -1712,6 +1712,6 @@ int __acpi_release_global_lock(unsigned int *lock)
 
 void __init arch_reserve_mem_area(acpi_physical_address addr, size_t size)
 {
-	e820_add_region(addr, size, E820_ACPI);
+	e820_add_region(addr, size, E820_TYPE_ACPI);
 	update_e820();
 }
diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index d5fd66f..0210300 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -322,10 +322,10 @@ void __init early_gart_iommu_check(void)
 
 	if (gart_fix_e820 && !fix && aper_enabled) {
 		if (e820_any_mapped(aper_base, aper_base + aper_size,
-				    E820_RAM)) {
+				    E820_TYPE_RAM)) {
 			/* reserve it, so we can reuse it in second kernel */
 			printk(KERN_INFO "update e820 for GART\n");
-			e820_add_region(aper_base, aper_size, E820_RESERVED);
+			e820_add_region(aper_base, aper_size, E820_TYPE_RESERVED);
 			update_e820();
 		}
 	}
diff --git a/arch/x86/kernel/cpu/centaur.c b/arch/x86/kernel/cpu/centaur.c
index 159103c..afcfc28 100644
--- a/arch/x86/kernel/cpu/centaur.c
+++ b/arch/x86/kernel/cpu/centaur.c
@@ -57,7 +57,7 @@ static u32 __cpuinit ramtop(void)
 		 * Don't MCR over reserved space. Ignore the ISA hole
 		 * we frob around that catastrophe already
 		 */
-		if (e820.map[i].type == E820_RESERVED) {
+		if (e820.map[i].type == E820_TYPE_RESERVED) {
 			if (e820.map[i].addr >= 0x100000UL &&
 			    e820.map[i].addr < clip)
 				clip = e820.map[i].addr;
diff --git a/arch/x86/kernel/cpu/mtrr/cleanup.c b/arch/x86/kernel/cpu/mtrr/cleanup.c
index 35ffda5..6976e3d 100644
--- a/arch/x86/kernel/cpu/mtrr/cleanup.c
+++ b/arch/x86/kernel/cpu/mtrr/cleanup.c
@@ -854,7 +854,7 @@ real_trim_memory(unsigned long start_pfn, unsigned long limit_pfn)
 	trim_size <<= PAGE_SHIFT;
 	trim_size -= trim_start;
 
-	return e820_update_range(trim_start, trim_size, E820_RAM, E820_RESERVED);
+	return e820_update_range(trim_start, trim_size, E820_TYPE_RAM, E820_TYPE_RESERVED);
 }
 
 /**
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index d32abea..82e7498 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -133,20 +133,20 @@ void __init e820_add_region(u64 start, u64 size, int type)
 static void __init e820_print_type(u32 type)
 {
 	switch (type) {
-	case E820_RAM:
-	case E820_RESERVED_KERN:
+	case E820_TYPE_RAM:
+	case E820_TYPE_RESERVED_KERN:
 		printk(KERN_CONT "usable");
 		break;
-	case E820_RESERVED:
+	case E820_TYPE_RESERVED:
 		printk(KERN_CONT "reserved");
 		break;
-	case E820_ACPI:
+	case E820_TYPE_ACPI:
 		printk(KERN_CONT "ACPI data");
 		break;
-	case E820_NVS:
+	case E820_TYPE_NVS:
 		printk(KERN_CONT "ACPI NVS");
 		break;
-	case E820_UNUSABLE:
+	case E820_TYPE_UNUSABLE:
 		printk(KERN_CONT "unusable");
 		break;
 	default:
@@ -694,7 +694,7 @@ void __init e820_mark_nosave_regions(unsigned long limit_pfn)
 			register_nosave_region(pfn, PFN_UP(ei->addr));
 
 		pfn = PFN_DOWN(ei->addr + ei->size);
-		if (ei->type != E820_RAM && ei->type != E820_RESERVED_KERN)
+		if (ei->type != E820_TYPE_RAM && ei->type != E820_TYPE_RESERVED_KERN)
 			register_nosave_region(PFN_UP(ei->addr), pfn);
 
 		if (pfn >= limit_pfn)
@@ -715,7 +715,7 @@ static int __init e820_mark_nvs_memory(void)
 	for (i = 0; i < e820.nr_map; i++) {
 		struct e820entry *ei = &e820.map[i];
 
-		if (ei->type == E820_NVS)
+		if (ei->type == E820_TYPE_NVS)
 			acpi_nvs_register(ei->addr, ei->size);
 	}
 
@@ -733,7 +733,7 @@ u64 __init early_reserve_e820(u64 size, u64 align)
 
 	addr = __memblock_alloc_base(size, align, MEMBLOCK_ALLOC_ACCESSIBLE);
 	if (addr) {
-		e820_update_range_saved(addr, size, E820_RAM, E820_RESERVED);
+		e820_update_range_saved(addr, size, E820_TYPE_RAM, E820_TYPE_RESERVED);
 		printk(KERN_INFO "e820: update e820_saved for early_reserve_e820\n");
 		update_e820_saved();
 	}
@@ -790,12 +790,12 @@ static unsigned long __init e820_end_pfn(unsigned long limit_pfn, unsigned type)
 }
 unsigned long __init e820_end_of_ram_pfn(void)
 {
-	return e820_end_pfn(MAX_ARCH_PFN, E820_RAM);
+	return e820_end_pfn(MAX_ARCH_PFN, E820_TYPE_RAM);
 }
 
 unsigned long __init e820_end_of_low_ram_pfn(void)
 {
-	return e820_end_pfn(1UL<<(32 - PAGE_SHIFT), E820_RAM);
+	return e820_end_pfn(1UL<<(32 - PAGE_SHIFT), E820_TYPE_RAM);
 }
 
 static void early_panic(char *msg)
@@ -829,7 +829,7 @@ static int __init parse_memopt(char *p)
 	/* don't remove all of memory when handling "mem={invalid}" param */
 	if (mem_size == 0)
 		return -EINVAL;
-	e820_remove_range(mem_size, ULLONG_MAX - mem_size, E820_RAM, 1);
+	e820_remove_range(mem_size, ULLONG_MAX - mem_size, E820_TYPE_RAM, 1);
 
 	return 0;
 }
@@ -865,15 +865,15 @@ static int __init parse_memmap_one(char *p)
 	userdef = 1;
 	if (*p == '@') {
 		start_at = memparse(p+1, &p);
-		e820_add_region(start_at, mem_size, E820_RAM);
+		e820_add_region(start_at, mem_size, E820_TYPE_RAM);
 	} else if (*p == '#') {
 		start_at = memparse(p+1, &p);
-		e820_add_region(start_at, mem_size, E820_ACPI);
+		e820_add_region(start_at, mem_size, E820_TYPE_ACPI);
 	} else if (*p == '$') {
 		start_at = memparse(p+1, &p);
-		e820_add_region(start_at, mem_size, E820_RESERVED);
+		e820_add_region(start_at, mem_size, E820_TYPE_RESERVED);
 	} else
-		e820_remove_range(mem_size, ULLONG_MAX - mem_size, E820_RAM, 1);
+		e820_remove_range(mem_size, ULLONG_MAX - mem_size, E820_TYPE_RAM, 1);
 
 	return *p == '\0' ? 0 : -EINVAL;
 }
@@ -910,11 +910,11 @@ void __init finish_e820_parsing(void)
 static inline const char *e820_type_to_string(int e820_type)
 {
 	switch (e820_type) {
-	case E820_RESERVED_KERN:
-	case E820_RAM:	return "System RAM";
-	case E820_ACPI:	return "ACPI Tables";
-	case E820_NVS:	return "ACPI Non-volatile Storage";
-	case E820_UNUSABLE:	return "Unusable memory";
+	case E820_TYPE_RESERVED_KERN:
+	case E820_TYPE_RAM:	return "System RAM";
+	case E820_TYPE_ACPI:	return "ACPI Tables";
+	case E820_TYPE_NVS:	return "ACPI Non-volatile Storage";
+	case E820_TYPE_UNUSABLE:	return "Unusable memory";
 	default:	return "reserved";
 	}
 }
@@ -948,7 +948,7 @@ void __init e820_reserve_resources(void)
 		 * pci device BAR resource and insert them later in
 		 * pcibios_resource_survey()
 		 */
-		if (e820.map[i].type != E820_RESERVED || res->start < (1ULL<<20)) {
+		if (e820.map[i].type != E820_TYPE_RESERVED || res->start < (1ULL<<20)) {
 			res->flags |= IORESOURCE_BUSY;
 			insert_resource(&iomem_resource, res);
 		}
@@ -1002,7 +1002,7 @@ void __init e820_reserve_resources_late(void)
 		struct e820entry *entry = &e820.map[i];
 		u64 start, end;
 
-		if (entry->type != E820_RAM)
+		if (entry->type != E820_TYPE_RAM)
 			continue;
 		start = entry->addr + entry->size;
 		end = round_up(start, ram_alignment(start)) - 1;
@@ -1048,8 +1048,8 @@ char *__init default_machine_specific_memory_setup(void)
 		}
 
 		e820.nr_map = 0;
-		e820_add_region(0, LOWMEMSIZE(), E820_RAM);
-		e820_add_region(HIGH_MEMORY, mem_size << 10, E820_RAM);
+		e820_add_region(0, LOWMEMSIZE(), E820_TYPE_RAM);
+		e820_add_region(HIGH_MEMORY, mem_size << 10, E820_TYPE_RAM);
 	}
 
 	/* In case someone cares... */
@@ -1085,7 +1085,7 @@ void __init memblock_x86_fill(void)
 		if (end != (resource_size_t)end)
 			continue;
 
-		if (ei->type != E820_RAM && ei->type != E820_RESERVED_KERN)
+		if (ei->type != E820_TYPE_RAM && ei->type != E820_TYPE_RESERVED_KERN)
 			continue;
 
 		memblock_add(ei->addr, ei->size);
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 9c857f0..5f197d8 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -116,7 +116,7 @@
  * max_low_pfn_mapped: highest direct mapped pfn under 4GB
  * max_pfn_mapped:     highest direct mapped pfn over 4GB
  *
- * The direct mapping only covers E820_RAM regions, so the ranges and gaps are
+ * The direct mapping only covers E820_TYPE_RAM regions, so the ranges and gaps are
  * represented by pfn_mapped
  */
 unsigned long max_low_pfn_mapped;
@@ -464,7 +464,7 @@ static void __init e820_reserve_setup_data(void)
 	while (pa_data) {
 		data = early_memremap(pa_data, sizeof(*data));
 		e820_update_range(pa_data, sizeof(*data)+data->len,
-			 E820_RAM, E820_RESERVED_KERN);
+			 E820_TYPE_RAM, E820_TYPE_RESERVED_KERN);
 		found = 1;
 		pa_data = data->next;
 		early_iounmap(data, sizeof(*data));
@@ -732,14 +732,14 @@ static void __init trim_bios_range(void)
 	 * since some BIOSes are known to corrupt low memory.  See the
 	 * Kconfig help text for X86_RESERVE_LOW.
 	 */
-	e820_update_range(0, PAGE_SIZE, E820_RAM, E820_RESERVED);
+	e820_update_range(0, PAGE_SIZE, E820_TYPE_RAM, E820_TYPE_RESERVED);
 
 	/*
 	 * special case: Some BIOSen report the PC BIOS
 	 * area (640->1Mb) as ram even though it is not.
 	 * take them out.
 	 */
-	e820_remove_range(BIOS_BEGIN, BIOS_END - BIOS_BEGIN, E820_RAM, 1);
+	e820_remove_range(BIOS_BEGIN, BIOS_END - BIOS_BEGIN, E820_TYPE_RAM, 1);
 
 	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
 }
@@ -751,18 +751,18 @@ static void __init e820_add_kernel_range(void)
 	u64 size = __pa_symbol(_end) - start;
 
 	/*
-	 * Complain if .text .data and .bss are not marked as E820_RAM and
+	 * Complain if .text .data and .bss are not marked as E820_TYPE_RAM and
 	 * attempt to fix it by adding the range. We may have a confused BIOS,
 	 * or the user may have used memmap=exactmap or memmap=xxM$yyM to
 	 * exclude kernel range. If we really are running on top non-RAM,
 	 * we will crash later anyways.
 	 */
-	if (e820_all_mapped(start, start + size, E820_RAM))
+	if (e820_all_mapped(start, start + size, E820_TYPE_RAM))
 		return;
 
-	pr_warn(".text .data .bss are not marked as E820_RAM!\n");
-	e820_remove_range(start, size, E820_RAM, 0);
-	e820_add_region(start, size, E820_RAM);
+	pr_warn(".text .data .bss are not marked as E820_TYPE_RAM!\n");
+	e820_remove_range(start, size, E820_TYPE_RAM, 0);
+	e820_add_region(start, size, E820_TYPE_RAM);
 }
 
 static unsigned reserve_low = CONFIG_X86_RESERVE_LOW << 10;
@@ -982,8 +982,8 @@ void __init setup_arch(char **cmdline_p)
 	trim_bios_range();
 #ifdef CONFIG_X86_32
 	if (ppro_with_ram_bug()) {
-		e820_update_range(0x70000000ULL, 0x40000ULL, E820_RAM,
-				  E820_RESERVED);
+		e820_update_range(0x70000000ULL, 0x40000ULL, E820_TYPE_RAM,
+				  E820_TYPE_RESERVED);
 		sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
 		printk(KERN_INFO "fixed physical RAM map:\n");
 		e820_print_map("bad_ppro");
diff --git a/arch/x86/kernel/tboot.c b/arch/x86/kernel/tboot.c
index f84fe00..9be3a2a 100644
--- a/arch/x86/kernel/tboot.c
+++ b/arch/x86/kernel/tboot.c
@@ -68,8 +68,8 @@ void __init tboot_probe(void)
 	 * set_fixmap(), to reduce chance of garbage value causing crash
 	 */
 	if (!e820_any_mapped(boot_params.tboot_addr,
-			     boot_params.tboot_addr, E820_RESERVED)) {
-		pr_warning("non-0 tboot_addr but it is not of type E820_RESERVED\n");
+			     boot_params.tboot_addr, E820_TYPE_RESERVED)) {
+		pr_warning("non-0 tboot_addr but it is not of type E820_TYPE_RESERVED\n");
 		return;
 	}
 
@@ -194,8 +194,8 @@ static int tboot_setup_sleep(void)
 	tboot->num_mac_regions = 0;
 
 	for (i = 0; i < e820.nr_map; i++) {
-		if ((e820.map[i].type != E820_RAM)
-		 && (e820.map[i].type != E820_RESERVED_KERN))
+		if ((e820.map[i].type != E820_TYPE_RAM)
+		 && (e820.map[i].type != E820_TYPE_RESERVED_KERN))
 			continue;
 
 		add_mac_region(e820.map[i].addr, e820.map[i].size);
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 474e28f..9bded61 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -412,8 +412,8 @@ phys_pte_init(pte_t *pte_page, unsigned long addr, unsigned long end,
 		next = (addr & PAGE_MASK) + PAGE_SIZE;
 		if (addr >= end) {
 			if (!after_bootmem &&
-			    !e820_any_mapped(addr & PAGE_MASK, next, E820_RAM) &&
-			    !e820_any_mapped(addr & PAGE_MASK, next, E820_RESERVED_KERN))
+			    !e820_any_mapped(addr & PAGE_MASK, next, E820_TYPE_RAM) &&
+			    !e820_any_mapped(addr & PAGE_MASK, next, E820_TYPE_RESERVED_KERN))
 				set_pte(pte, __pte(0));
 			continue;
 		}
@@ -460,8 +460,8 @@ phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
 		next = (address & PMD_MASK) + PMD_SIZE;
 		if (address >= end) {
 			if (!after_bootmem &&
-			    !e820_any_mapped(address & PMD_MASK, next, E820_RAM) &&
-			    !e820_any_mapped(address & PMD_MASK, next, E820_RESERVED_KERN))
+			    !e820_any_mapped(address & PMD_MASK, next, E820_TYPE_RAM) &&
+			    !e820_any_mapped(address & PMD_MASK, next, E820_TYPE_RESERVED_KERN))
 				set_pmd(pmd, __pmd(0));
 			continue;
 		}
@@ -534,8 +534,8 @@ phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end,
 		next = (addr & PUD_MASK) + PUD_SIZE;
 		if (addr >= end) {
 			if (!after_bootmem &&
-			    !e820_any_mapped(addr & PUD_MASK, next, E820_RAM) &&
-			    !e820_any_mapped(addr & PUD_MASK, next, E820_RESERVED_KERN))
+			    !e820_any_mapped(addr & PUD_MASK, next, E820_TYPE_RAM) &&
+			    !e820_any_mapped(addr & PUD_MASK, next, E820_TYPE_RESERVED_KERN))
 				set_pud(pud, __pud(0));
 			continue;
 		}
diff --git a/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
index 082e881..15badb0 100644
--- a/arch/x86/pci/mmconfig-shared.c
+++ b/arch/x86/pci/mmconfig-shared.c
@@ -449,7 +449,7 @@ static int __ref is_mmconf_reserved(check_reserved_t is_reserved,
 	int num_buses;
 	char *method = with_e820 ? "E820" : "ACPI motherboard resources";
 
-	while (!is_reserved(addr, addr + size, E820_RESERVED)) {
+	while (!is_reserved(addr, addr + size, E820_TYPE_RESERVED)) {
 		size >>= 1;
 		if (size < (16UL<<20))
 			break;
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 2f81db4..5faa188 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -327,18 +327,18 @@ static void __init do_add_efi_memmap(void)
 		case EFI_BOOT_SERVICES_DATA:
 		case EFI_CONVENTIONAL_MEMORY:
 			if (md->attribute & EFI_MEMORY_WB)
-				e820_type = E820_RAM;
+				e820_type = E820_TYPE_RAM;
 			else
-				e820_type = E820_RESERVED;
+				e820_type = E820_TYPE_RESERVED;
 			break;
 		case EFI_ACPI_RECLAIM_MEMORY:
-			e820_type = E820_ACPI;
+			e820_type = E820_TYPE_ACPI;
 			break;
 		case EFI_ACPI_MEMORY_NVS:
-			e820_type = E820_NVS;
+			e820_type = E820_TYPE_NVS;
 			break;
 		case EFI_UNUSABLE_MEMORY:
-			e820_type = E820_UNUSABLE;
+			e820_type = E820_TYPE_UNUSABLE;
 			break;
 		default:
 			/*
@@ -346,7 +346,7 @@ static void __init do_add_efi_memmap(void)
 			 * EFI_RUNTIME_SERVICES_DATA EFI_MEMORY_MAPPED_IO
 			 * EFI_MEMORY_MAPPED_IO_PORT_SPACE EFI_PAL_CODE
 			 */
-			e820_type = E820_RESERVED;
+			e820_type = E820_TYPE_RESERVED;
 			break;
 		}
 		e820_add_region(start, size, e820_type);
@@ -419,7 +419,7 @@ void __init efi_reserve_boot_services(void)
 		*/
 		if ((start+size >= __pa_symbol(_text)
 				&& start <= __pa_symbol(_end)) ||
-			!e820_all_mapped(start, start+size, E820_RAM) ||
+			!e820_all_mapped(start, start+size, E820_TYPE_RAM) ||
 			memblock_is_region_reserved(start, size)) {
 			/* Could not reserve, skip it */
 			md->num_pages = 0;
diff --git a/arch/x86/platform/visws/visws_quirks.c b/arch/x86/platform/visws/visws_quirks.c
index 94d8a39..1531add 100644
--- a/arch/x86/platform/visws/visws_quirks.c
+++ b/arch/x86/platform/visws/visws_quirks.c
@@ -106,9 +106,9 @@ static char * __init visws_memory_setup(void)
 	sgivwfb_mem_size &= ~((1 << 20) - 1);
 	sgivwfb_mem_phys = mem_size - gfx_mem_size;
 
-	e820_add_region(0, LOWMEMSIZE(), E820_RAM);
-	e820_add_region(HIGH_MEMORY, mem_size - sgivwfb_mem_size - HIGH_MEMORY, E820_RAM);
-	e820_add_region(sgivwfb_mem_phys, sgivwfb_mem_size, E820_RESERVED);
+	e820_add_region(0, LOWMEMSIZE(), E820_TYPE_RAM);
+	e820_add_region(HIGH_MEMORY, mem_size - sgivwfb_mem_size - HIGH_MEMORY, E820_TYPE_RAM);
+	e820_add_region(sgivwfb_mem_phys, sgivwfb_mem_size, E820_TYPE_RESERVED);
 
 	return "PROM";
 }
diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 94eac5c..877d2ef 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -173,7 +173,7 @@ static unsigned long __init xen_populate_chunk(
 		if (credits_left <= 0)
 			break;
 
-		if (entry->type != E820_RAM)
+		if (entry->type != E820_TYPE_RAM)
 			continue;
 
 		e_pfn = PFN_DOWN(entry->addr + entry->size);
@@ -252,11 +252,11 @@ static unsigned long __init xen_set_identity_and_release(
 	 */
 	for (i = 0, entry = list; i < map_size; i++, entry++) {
 		phys_addr_t end = entry->addr + entry->size;
-		if (entry->type == E820_RAM || i == map_size - 1) {
+		if (entry->type == E820_TYPE_RAM || i == map_size - 1) {
 			unsigned long start_pfn = PFN_DOWN(start);
 			unsigned long end_pfn = PFN_UP(end);
 
-			if (entry->type == E820_RAM)
+			if (entry->type == E820_TYPE_RAM)
 				end_pfn = PFN_UP(entry->addr);
 
 			if (start_pfn < end_pfn)
@@ -305,7 +305,7 @@ static void xen_align_and_add_e820_region(u64 start, u64 size, int type)
 	u64 end = start + size;
 
 	/* Align RAM regions to page boundaries. */
-	if (type == E820_RAM) {
+	if (type == E820_TYPE_RAM) {
 		start = PAGE_ALIGN(start);
 		end &= ~((u64)PAGE_SIZE - 1);
 	}
@@ -348,7 +348,7 @@ char * __init xen_memory_setup(void)
 		map[0].size = mem_end;
 		/* 8MB slack (to balance backend allocations). */
 		map[0].size += 8ULL << 20;
-		map[0].type = E820_RAM;
+		map[0].type = E820_TYPE_RAM;
 		rc = 0;
 	}
 	BUG_ON(rc);
@@ -400,7 +400,7 @@ char * __init xen_memory_setup(void)
 		u64 size = map[i].size;
 		u32 type = map[i].type;
 
-		if (type == E820_RAM) {
+		if (type == E820_TYPE_RAM) {
 			if (addr < mem_end) {
 				size = min(size, mem_end - addr);
 			} else if (extra_pages) {
@@ -408,7 +408,7 @@ char * __init xen_memory_setup(void)
 				extra_pages -= size / PAGE_SIZE;
 				xen_add_extra_mem(addr, size);
 			} else
-				type = E820_UNUSABLE;
+				type = E820_TYPE_UNUSABLE;
 		}
 
 		xen_align_and_add_e820_region(addr, size, type);
@@ -425,7 +425,7 @@ char * __init xen_memory_setup(void)
 	 * about in there.
 	 */
 	e820_add_region(ISA_START_ADDRESS, ISA_END_ADDRESS - ISA_START_ADDRESS,
-			E820_RESERVED);
+			E820_TYPE_RESERVED);
 
 	/*
 	 * Reserve Xen bits:
-- 
1.7.2.5

