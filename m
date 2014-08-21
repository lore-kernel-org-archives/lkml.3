Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091AbaHUMZB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 08:25:01 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:35322 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754854AbaHUMXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 08:23:45 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Joe Perches <joe@perches.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-kernel@vger.kernel.org, Mathias Krause <minipli@googlemail.com>
Subject: [PATCHv3 8/9] x86, mm: e820 - mark __init strings as such
Date: Thu, 21 Aug 2014 14:23:11 +0200
Message-Id: <1408623792-7973-9-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1408623792-7973-1-git-send-email-minipli@googlemail.com>
References: <1408623792-7973-1-git-send-email-minipli@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make use of the pi_<level>() helpers to mark the strings printed during
initialization for automatic release. Do so for the strings used in
command line parsing as well, by using the __init_str() macro.

The debug messages have been converted to printk_init(KERN_DEBUG ...)
instead of pi_debug(...), though. They might have some value beyond
debugging. Moreover, this ensures we won't loose any message by this
conversion.

This moves ~0.8 kB from the .rodata section to .init.rodata, marking it
for release after initialization.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 arch/x86/kernel/e820.c |   87 ++++++++++++++++++++++++------------------------
 1 file changed, 44 insertions(+), 43 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index bfe9238e12..e347a272a9 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -25,6 +25,8 @@
 #include <asm/proto.h>
 #include <asm/setup.h>
 
+#define _(x)	__init_str(x)
+
 /*
  * The e820 map is the map that gets modified e.g. with command line parameters
  * and that is also registered with modifications in the kernel resource tree
@@ -113,7 +115,7 @@ static void __init __e820_add_region(struct e820map *e820x, u64 start, u64 size,
 	int x = e820x->nr_map;
 
 	if (x >= ARRAY_SIZE(e820x->map)) {
-		printk(KERN_ERR "e820: too many entries; ignoring [mem %#010llx-%#010llx]\n",
+		pi_err("e820: too many entries; ignoring [mem %#010llx-%#010llx]\n",
 		       (unsigned long long) start,
 		       (unsigned long long) (start + size - 1));
 		return;
@@ -135,22 +137,22 @@ static void __init e820_print_type(u32 type)
 	switch (type) {
 	case E820_RAM:
 	case E820_RESERVED_KERN:
-		printk(KERN_CONT "usable");
+		pi_cont("usable");
 		break;
 	case E820_RESERVED:
-		printk(KERN_CONT "reserved");
+		pi_cont("reserved");
 		break;
 	case E820_ACPI:
-		printk(KERN_CONT "ACPI data");
+		pi_cont("ACPI data");
 		break;
 	case E820_NVS:
-		printk(KERN_CONT "ACPI NVS");
+		pi_cont("ACPI NVS");
 		break;
 	case E820_UNUSABLE:
-		printk(KERN_CONT "unusable");
+		pi_cont("unusable");
 		break;
 	default:
-		printk(KERN_CONT "type %u", type);
+		pi_cont("type %u", type);
 		break;
 	}
 }
@@ -160,12 +162,12 @@ void __init e820_print_map(const char *who)
 	int i;
 
 	for (i = 0; i < e820.nr_map; i++) {
-		printk(KERN_INFO "%s: [mem %#018Lx-%#018Lx] ", who,
-		       (unsigned long long) e820.map[i].addr,
-		       (unsigned long long)
-		       (e820.map[i].addr + e820.map[i].size - 1));
+		pi_info("%s: [mem %#018Lx-%#018Lx] ", who,
+			(unsigned long long) e820.map[i].addr,
+			(unsigned long long)
+			(e820.map[i].addr + e820.map[i].size - 1));
 		e820_print_type(e820.map[i].type);
-		printk(KERN_CONT "\n");
+		pi_cont("\n");
 	}
 }
 
@@ -430,12 +432,12 @@ static u64 __init __e820_update_range(struct e820map *e820x, u64 start,
 		size = ULLONG_MAX - start;
 
 	end = start + size;
-	printk(KERN_DEBUG "e820: update [mem %#010Lx-%#010Lx] ",
-	       (unsigned long long) start, (unsigned long long) (end - 1));
+	printk_init(KERN_DEBUG "e820: update [mem %#010Lx-%#010Lx] ",
+		    (unsigned long long) start, (unsigned long long) (end - 1));
 	e820_print_type(old_type);
-	printk(KERN_CONT " ==> ");
+	pi_cont(" ==> ");
 	e820_print_type(new_type);
-	printk(KERN_CONT "\n");
+	pi_cont("\n");
 
 	for (i = 0; i < e820x->nr_map; i++) {
 		struct e820entry *ei = &e820x->map[i];
@@ -510,11 +512,11 @@ u64 __init e820_remove_range(u64 start, u64 size, unsigned old_type,
 		size = ULLONG_MAX - start;
 
 	end = start + size;
-	printk(KERN_DEBUG "e820: remove [mem %#010Lx-%#010Lx] ",
-	       (unsigned long long) start, (unsigned long long) (end - 1));
+	printk_init(KERN_DEBUG "e820: remove [mem %#010Lx-%#010Lx] ",
+		    (unsigned long long) start, (unsigned long long) (end - 1));
 	if (checktype)
 		e820_print_type(old_type);
-	printk(KERN_CONT "\n");
+	pi_cont("\n");
 
 	for (i = 0; i < e820.nr_map; i++) {
 		struct e820entry *ei = &e820.map[i];
@@ -567,8 +569,8 @@ void __init update_e820(void)
 	if (sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &nr_map))
 		return;
 	e820.nr_map = nr_map;
-	printk(KERN_INFO "e820: modified physical RAM map:\n");
-	e820_print_map("modified");
+	pi_info("e820: modified physical RAM map:\n");
+	e820_print_map(_("modified"));
 }
 static void __init update_e820_saved(void)
 {
@@ -636,7 +638,7 @@ __init void e820_setup_gap(void)
 #ifdef CONFIG_X86_64
 	if (!found) {
 		gapstart = (max_pfn << PAGE_SHIFT) + 1024*1024;
-		printk(KERN_ERR
+		pi_err(
 	"e820: cannot find a gap in the 32bit address range\n"
 	"e820: PCI devices with unassigned 32bit BARs may break!\n");
 	}
@@ -647,9 +649,8 @@ __init void e820_setup_gap(void)
 	 */
 	pci_mem_start = gapstart;
 
-	printk(KERN_INFO
-	       "e820: [mem %#010lx-%#010lx] available for PCI devices\n",
-	       gapstart, gapstart + gapsize - 1);
+	pi_info("e820: [mem %#010lx-%#010lx] available for PCI devices\n",
+		gapstart, gapstart + gapsize - 1);
 }
 
 /**
@@ -670,8 +671,8 @@ void __init parse_e820_ext(u64 phys_addr, u32 data_len)
 	__append_e820_map(extmap, entries);
 	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
 	early_iounmap(sdata, data_len);
-	printk(KERN_INFO "e820: extended physical RAM map:\n");
-	e820_print_map("extended");
+	pi_info("e820: extended physical RAM map:\n");
+	e820_print_map(_("extended"));
 }
 
 #if defined(CONFIG_X86_64) || \
@@ -737,7 +738,7 @@ u64 __init early_reserve_e820(u64 size, u64 align)
 	addr = __memblock_alloc_base(size, align, MEMBLOCK_ALLOC_ACCESSIBLE);
 	if (addr) {
 		e820_update_range_saved(addr, size, E820_RAM, E820_RESERVED);
-		printk(KERN_INFO "e820: update e820_saved for early_reserve_e820\n");
+		pi_info("e820: update e820_saved for early_reserve_e820\n");
 		update_e820_saved();
 	}
 
@@ -787,8 +788,8 @@ static unsigned long __init e820_end_pfn(unsigned long limit_pfn, unsigned type)
 	if (last_pfn > max_arch_pfn)
 		last_pfn = max_arch_pfn;
 
-	printk(KERN_INFO "e820: last_pfn = %#lx max_arch_pfn = %#lx\n",
-			 last_pfn, max_arch_pfn);
+	pi_info("e820: last_pfn = %#lx max_arch_pfn = %#lx\n", last_pfn,
+		max_arch_pfn);
 	return last_pfn;
 }
 unsigned long __init e820_end_of_ram_pfn(void)
@@ -803,8 +804,8 @@ unsigned long __init e820_end_of_low_ram_pfn(void)
 
 static void early_panic(const char *msg)
 {
-	early_printk("%s", msg);
-	panic("%s", msg);
+	early_printk(_("%s"), msg);
+	panic(_("%s"), msg);
 }
 
 static int userdef __initdata;
@@ -817,12 +818,12 @@ static int __init parse_memopt(char *p)
 	if (!p)
 		return -EINVAL;
 
-	if (!strcmp(p, "nopentium")) {
+	if (!strcmp(p, _("nopentium"))) {
 #ifdef CONFIG_X86_32
 		setup_clear_cpu_cap(X86_FEATURE_PSE);
 		return 0;
 #else
-		printk(KERN_WARNING "mem=nopentium ignored! (only supported on x86_32)\n");
+		pi_warn("mem=nopentium ignored! (only supported on x86_32)\n");
 		return -EINVAL;
 #endif
 	}
@@ -846,7 +847,7 @@ static int __init parse_memmap_one(char *p)
 	if (!p)
 		return -EINVAL;
 
-	if (!strncmp(p, "exactmap", 8)) {
+	if (!strncmp(p, _("exactmap"), 8)) {
 #ifdef CONFIG_CRASH_DUMP
 		/*
 		 * If we are doing a crash dump, we still need to know
@@ -902,11 +903,11 @@ void __init finish_e820_parsing(void)
 		u32 nr = e820.nr_map;
 
 		if (sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &nr) < 0)
-			early_panic("Invalid user supplied memory map");
+			early_panic(_("Invalid user supplied memory map"));
 		e820.nr_map = nr;
 
-		printk(KERN_INFO "e820: user-defined physical RAM map:\n");
-		e820_print_map("user");
+		pi_info("e820: user-defined physical RAM map:\n");
+		e820_print_map(_("user"));
 	}
 }
 
@@ -1013,7 +1014,7 @@ void __init e820_reserve_resources_late(void)
 			end = MAX_RESOURCE_SIZE;
 		if (start >= end)
 			continue;
-		printk(KERN_DEBUG
+		printk_init(KERN_DEBUG
 		       "e820: reserve RAM buffer [mem %#010llx-%#010llx]\n",
 		       start, end);
 		reserve_region_with_split(&iomem_resource, start, end,
@@ -1023,7 +1024,7 @@ void __init e820_reserve_resources_late(void)
 
 const char *__init default_machine_specific_memory_setup(void)
 {
-	const char *who = "BIOS-e820";
+	const char *who = _("BIOS-e820");
 	u32 new_nr;
 	/*
 	 * Try to copy the BIOS-supplied E820-map.
@@ -1044,10 +1045,10 @@ const char *__init default_machine_specific_memory_setup(void)
 		if (boot_params.alt_mem_k
 		    < boot_params.screen_info.ext_mem_k) {
 			mem_size = boot_params.screen_info.ext_mem_k;
-			who = "BIOS-88";
+			who = _("BIOS-88");
 		} else {
 			mem_size = boot_params.alt_mem_k;
-			who = "BIOS-e801";
+			who = _("BIOS-e801");
 		}
 
 		e820.nr_map = 0;
@@ -1065,7 +1066,7 @@ void __init setup_memory_map(void)
 
 	who = x86_init.resources.memory_setup();
 	memcpy(&e820_saved, &e820, sizeof(struct e820map));
-	printk(KERN_INFO "e820: BIOS-provided physical RAM map:\n");
+	pi_info("e820: BIOS-provided physical RAM map:\n");
 	e820_print_map(who);
 }
 
-- 
1.7.10.4

