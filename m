Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012AbaHUMYW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 08:24:22 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:52677 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754871AbaHUMXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 08:23:47 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Joe Perches <joe@perches.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-kernel@vger.kernel.org, Mathias Krause <minipli@googlemail.com>
Subject: [PATCHv3 9/9] x86: setup - mark __init strings as such
Date: Thu, 21 Aug 2014 14:23:12 +0200
Message-Id: <1408623792-7973-10-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1408623792-7973-1-git-send-email-minipli@googlemail.com>
References: <1408623792-7973-1-git-send-email-minipli@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make use of the pi_<level>() helpers to mark the strings printed during
initialization for automatic release. Do so for the strings used in boot
parameters parsing as well, by using the __init_str() macro.

The debug messages have been converted to printk_init(KERN_DEBUG ...)
instead of pi_debug(...), though. They might have some value beyond
debugging. Moreover, this ensures we won't loose any message by this
conversion.

This moves ~0.5 kB from the .rodata section to .init.rodata, marking it
for release after initialization.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 arch/x86/kernel/setup.c |   70 +++++++++++++++++++++++------------------------
 1 file changed, 34 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 41ead8d3bc..82f211a310 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -111,6 +111,8 @@
 #include <asm/alternative.h>
 #include <asm/prom.h>
 
+#define _(x)	__init_str(x)
+
 /*
  * max_low_pfn_mapped: highest direct mapped pfn under 4GB
  * max_pfn_mapped:     highest direct mapped pfn over 4GB
@@ -331,7 +333,7 @@ static void __init relocate_initrd(void)
 						   area_size, PAGE_SIZE);
 
 	if (!relocated_ramdisk)
-		panic("Cannot find place for new RAMDISK of size %lld\n",
+		panic(_("Cannot find place for new RAMDISK of size %lld\n"),
 		      ramdisk_size);
 
 	/* Note: this includes all the mem currently occupied by
@@ -339,8 +341,8 @@ static void __init relocate_initrd(void)
 	memblock_reserve(relocated_ramdisk, area_size);
 	initrd_start = relocated_ramdisk + PAGE_OFFSET;
 	initrd_end   = initrd_start + ramdisk_size;
-	printk(KERN_INFO "Allocated new RAMDISK: [mem %#010llx-%#010llx]\n",
-	       relocated_ramdisk, relocated_ramdisk + ramdisk_size - 1);
+	pi_info("Allocated new RAMDISK: [mem %#010llx-%#010llx]\n",
+		relocated_ramdisk, relocated_ramdisk + ramdisk_size - 1);
 
 	q = (char *)initrd_start;
 
@@ -361,8 +363,7 @@ static void __init relocate_initrd(void)
 
 	ramdisk_image = get_ramdisk_image();
 	ramdisk_size  = get_ramdisk_size();
-	printk(KERN_INFO "Move RAMDISK from [mem %#010llx-%#010llx] to"
-		" [mem %#010llx-%#010llx]\n",
+	pi_info("Move RAMDISK from [mem %#010llx-%#010llx] to [mem %#010llx-%#010llx]\n",
 		ramdisk_image, ramdisk_image + ramdisk_size - 1,
 		relocated_ramdisk, relocated_ramdisk + ramdisk_size - 1);
 }
@@ -396,12 +397,12 @@ static void __init reserve_initrd(void)
 
 	mapped_size = memblock_mem_size(max_pfn_mapped);
 	if (ramdisk_size >= (mapped_size>>1))
-		panic("initrd too large to handle, "
-		       "disabling initrd (%lld needed, %lld available)\n",
-		       ramdisk_size, mapped_size>>1);
+		panic(_("initrd too large to handle, "
+			"disabling initrd (%lld needed, %lld available)\n"),
+		      ramdisk_size, mapped_size>>1);
 
-	printk(KERN_INFO "RAMDISK: [mem %#010llx-%#010llx]\n", ramdisk_image,
-			ramdisk_end - 1);
+	pi_info("RAMDISK: [mem %#010llx-%#010llx]\n", ramdisk_image,
+		ramdisk_end - 1);
 
 	if (pfn_range_is_mapped(PFN_DOWN(ramdisk_image),
 				PFN_DOWN(ramdisk_end))) {
@@ -478,8 +479,8 @@ static void __init e820_reserve_setup_data(void)
 
 	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
 	memcpy(&e820_saved, &e820, sizeof(struct e820map));
-	printk(KERN_INFO "extended physical RAM map:\n");
-	e820_print_map("reserve setup_data");
+	pi_info("extended physical RAM map:\n");
+	e820_print_map(_("reserve setup_data"));
 }
 
 static void __init memblock_x86_reserve_range_setup_data(void)
@@ -550,16 +551,16 @@ static void __init reserve_crashkernel_low(void)
 
 	if (!low_base) {
 		if (!auto_set)
-			pr_info("crashkernel low reservation failed - No suitable area found.\n");
+			pi_info("crashkernel low reservation failed - No suitable area found.\n");
 
 		return;
 	}
 
 	memblock_reserve(low_base, low_size);
-	pr_info("Reserving %ldMB of low memory at %ldMB for crashkernel (System low RAM: %ldMB)\n",
-			(unsigned long)(low_size >> 20),
-			(unsigned long)(low_base >> 20),
-			(unsigned long)(total_low_mem >> 20));
+	pi_info("Reserving %ldMB of low memory at %ldMB for crashkernel (System low RAM: %ldMB)\n",
+		(unsigned long)(low_size >> 20),
+		(unsigned long)(low_base >> 20),
+		(unsigned long)(total_low_mem >> 20));
 	crashk_low_res.start = low_base;
 	crashk_low_res.end   = low_base + low_size - 1;
 	insert_resource(&iomem_resource, &crashk_low_res);
@@ -599,7 +600,7 @@ static void __init reserve_crashkernel(void)
 					crash_size, alignment);
 
 		if (!crash_base) {
-			pr_info("crashkernel reservation failed - No suitable area found.\n");
+			pi_info("crashkernel reservation failed - No suitable area found.\n");
 			return;
 		}
 
@@ -609,17 +610,16 @@ static void __init reserve_crashkernel(void)
 		start = memblock_find_in_range(crash_base,
 				 crash_base + crash_size, crash_size, 1<<20);
 		if (start != crash_base) {
-			pr_info("crashkernel reservation failed - memory is in use.\n");
+			pi_info("crashkernel reservation failed - memory is in use.\n");
 			return;
 		}
 	}
 	memblock_reserve(crash_base, crash_size);
 
-	printk(KERN_INFO "Reserving %ldMB of memory at %ldMB "
-			"for crashkernel (System RAM: %ldMB)\n",
-			(unsigned long)(crash_size >> 20),
-			(unsigned long)(crash_base >> 20),
-			(unsigned long)(total_mem >> 20));
+	pi_info("Reserving %ldMB of memory at %ldMB for crashkernel (System RAM: %ldMB)\n",
+		(unsigned long)(crash_size >> 20),
+		(unsigned long)(crash_base >> 20),
+		(unsigned long)(total_mem >> 20));
 
 	crashk_res.start = crash_base;
 	crashk_res.end   = crash_base + crash_size - 1;
@@ -727,7 +727,7 @@ static void __init trim_snb_memory(void)
 	if (!snb_gfx_workaround_needed())
 		return;
 
-	printk(KERN_DEBUG "reserving inaccessible SNB gfx pages\n");
+	printk_init(KERN_DEBUG "reserving inaccessible SNB gfx pages\n");
 
 	/*
 	 * Reserve all memory below the 1 MB mark that has not
@@ -737,8 +737,7 @@ static void __init trim_snb_memory(void)
 	
 	for (i = 0; i < ARRAY_SIZE(bad_pages); i++) {
 		if (memblock_reserve(bad_pages[i], PAGE_SIZE))
-			printk(KERN_WARNING "failed to reserve 0x%08lx\n",
-			       bad_pages[i]);
+			pi_warn("failed to reserve 0x%08lx\n", bad_pages[i]);
 	}
 }
 
@@ -793,7 +792,7 @@ static void __init e820_add_kernel_range(void)
 	if (e820_all_mapped(start, start + size, E820_RAM))
 		return;
 
-	pr_warn(".text .data .bss are not marked as E820_RAM!\n");
+	pi_warn(".text .data .bss are not marked as E820_RAM!\n");
 	e820_remove_range(start, size, E820_RAM, 0);
 	e820_add_region(start, size, E820_RAM);
 }
@@ -819,7 +818,6 @@ static int __init parse_reservelow(char *p)
 
 	return 0;
 }
-
 early_param("reservelow", parse_reservelow);
 
 static void __init trim_low_memory_range(void)
@@ -881,7 +879,7 @@ void __init setup_arch(char **cmdline_p)
 	load_cr3(swapper_pg_dir);
 	__flush_tlb_all();
 #else
-	printk(KERN_INFO "Command line: %s\n", boot_command_line);
+	pi_info("Command line: %s\n", boot_command_line);
 #endif
 
 	/*
@@ -924,10 +922,10 @@ void __init setup_arch(char **cmdline_p)
 #endif
 #ifdef CONFIG_EFI
 	if (!strncmp((char *)&boot_params.efi_info.efi_loader_signature,
-		     EFI32_LOADER_SIGNATURE, 4)) {
+		     _(EFI32_LOADER_SIGNATURE), 4)) {
 		set_bit(EFI_BOOT, &efi.flags);
 	} else if (!strncmp((char *)&boot_params.efi_info.efi_loader_signature,
-		     EFI64_LOADER_SIGNATURE, 4)) {
+			    _(EFI64_LOADER_SIGNATURE), 4)) {
 		set_bit(EFI_BOOT, &efi.flags);
 		set_bit(EFI_64BIT, &efi.flags);
 	}
@@ -1033,8 +1031,8 @@ void __init setup_arch(char **cmdline_p)
 		e820_update_range(0x70000000ULL, 0x40000ULL, E820_RAM,
 				  E820_RESERVED);
 		sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
-		printk(KERN_INFO "fixed physical RAM map:\n");
-		e820_print_map("bad_ppro");
+		pi_info("fixed physical RAM map:\n");
+		e820_print_map(_("bad_ppro"));
 	}
 #else
 	early_gart_iommu_check();
@@ -1103,8 +1101,8 @@ void __init setup_arch(char **cmdline_p)
 #endif
 
 #ifdef CONFIG_X86_32
-	printk(KERN_DEBUG "initial memory mapped: [mem 0x00000000-%#010lx]\n",
-			(max_pfn_mapped<<PAGE_SHIFT) - 1);
+	printk_init(KERN_DEBUG "initial memory mapped: [mem 0x00000000-%#010lx]\n",
+		    (max_pfn_mapped<<PAGE_SHIFT) - 1);
 #endif
 
 	reserve_real_mode();
-- 
1.7.10.4

