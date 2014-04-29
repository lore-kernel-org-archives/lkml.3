Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565AbaD2Xzk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 19:55:40 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:58128 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755330AbaD2Xze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 19:55:34 -0400
Subject: [PATCH v2 1/2] x86/gart: Replace printk() with pr_info()
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: David Airlie <airlied@linux.ie>, x86@kernel.org,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Date: Tue, 29 Apr 2014 17:55:32 -0600
Message-ID: <20140429235532.11112.48857.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140429235015.11112.79459.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140429235015.11112.79459.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace printk() with pr_info(), pr_err(), etc.  Define pr_fmt() to prefix
output with "AGP: ".

No functional change except the addition of "AGP: " prefix in dmesg output.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 arch/x86/kernel/aperture_64.c |   54 ++++++++++++++++++++---------------------
 1 file changed, 26 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index 9fa8aa051f54..b11edf2b656d 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -10,6 +10,8 @@
  *
  * Copyright 2002 Andi Kleen, SuSE Labs.
  */
+#define pr_fmt(fmt) "AGP: " fmt
+
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/init.h>
@@ -75,14 +77,13 @@ static u32 __init allocate_aperture(void)
 	addr = memblock_find_in_range(GART_MIN_ADDR, GART_MAX_ADDR,
 				      aper_size, aper_size);
 	if (!addr) {
-		printk(KERN_ERR
-			"Cannot allocate aperture memory hole (%lx,%uK)\n",
-				addr, aper_size>>10);
+		pr_err("Cannot allocate aperture memory hole (%lx,%uK)\n",
+		       addr, aper_size>>10);
 		return 0;
 	}
 	memblock_reserve(addr, aper_size);
-	printk(KERN_INFO "Mapping aperture over %d KB of RAM @ %lx\n",
-			aper_size >> 10, addr);
+	pr_info("Mapping aperture over %d KB of RAM @ %lx\n", aper_size >> 10,
+		addr);
 	register_nosave_region(addr >> PAGE_SHIFT,
 			       (addr+aper_size) >> PAGE_SHIFT);
 
@@ -126,10 +127,10 @@ static u32 __init read_agp(int bus, int slot, int func, int cap, u32 *order)
 	u64 aper;
 	u32 old_order;
 
-	printk(KERN_INFO "AGP bridge at %02x:%02x:%02x\n", bus, slot, func);
+	pr_info("AGP bridge at %02x:%02x:%02x\n", bus, slot, func);
 	apsizereg = read_pci_config_16(bus, slot, func, cap + 0x14);
 	if (apsizereg == 0xffffffff) {
-		printk(KERN_ERR "APSIZE in AGP bridge unreadable\n");
+		pr_err("APSIZE in AGP bridge unreadable\n");
 		return 0;
 	}
 
@@ -153,16 +154,16 @@ static u32 __init read_agp(int bus, int slot, int func, int cap, u32 *order)
 	 * On some sick chips, APSIZE is 0. It means it wants 4G
 	 * so let double check that order, and lets trust AMD NB settings:
 	 */
-	printk(KERN_INFO "Aperture from AGP @ %Lx old size %u MB\n",
-			aper, 32 << old_order);
+	pr_info("Aperture from AGP @ %Lx old size %u MB\n",
+		aper, 32 << old_order);
 	if (aper + (32ULL<<(20 + *order)) > 0x100000000ULL) {
-		printk(KERN_INFO "Aperture size %u MB (APSIZE %x) is not right, using settings from NB\n",
-				32 << *order, apsizereg);
+		pr_info("Aperture size %u MB (APSIZE %x) is not right, using settings from NB\n",
+			32 << *order, apsizereg);
 		*order = old_order;
 	}
 
-	printk(KERN_INFO "Aperture from AGP @ %Lx size %u MB (APSIZE %x)\n",
-			aper, 32 << *order, apsizereg);
+	pr_info("Aperture from AGP @ %Lx size %u MB (APSIZE %x)\n", aper,
+		32 << *order, apsizereg);
 
 	if (!aperture_valid(aper, (32*1024*1024) << *order, 32<<20))
 		return 0;
@@ -218,7 +219,7 @@ static u32 __init search_agp_bridge(u32 *order, int *valid_agp)
 			}
 		}
 	}
-	printk(KERN_INFO "No AGP bridge found\n");
+	pr_info("No AGP bridge found\n");
 
 	return 0;
 }
@@ -310,7 +311,7 @@ void __init early_gart_iommu_check(void)
 		if (e820_any_mapped(aper_base, aper_base + aper_size,
 				    E820_RAM)) {
 			/* reserve it, so we can reuse it in second kernel */
-			printk(KERN_INFO "update e820 for GART\n");
+			pr_info("update e820 for GART\n");
 			e820_add_region(aper_base, aper_size, E820_RESERVED);
 			update_e820();
 		}
@@ -354,7 +355,7 @@ int __init gart_iommu_hole_init(void)
 	    !early_pci_allowed())
 		return -ENODEV;
 
-	printk(KERN_INFO  "Checking aperture...\n");
+	pr_info("Checking aperture...\n");
 
 	if (!fallback_aper_force)
 		agp_aper_base = search_agp_bridge(&agp_aper_order, &valid_agp);
@@ -395,8 +396,8 @@ int __init gart_iommu_hole_init(void)
 			aper_base = read_pci_config(bus, slot, 3, AMD64_GARTAPERTUREBASE) & 0x7fff;
 			aper_base <<= 25;
 
-			printk(KERN_INFO "Node %d: aperture @ %Lx size %u MB\n",
-					node, aper_base, aper_size >> 20);
+			pr_info("Node %d: aperture @ %Lx size %u MB\n",
+				node, aper_base, aper_size >> 20);
 			node++;
 
 			if (!aperture_valid(aper_base, aper_size, 64<<20)) {
@@ -407,9 +408,9 @@ int __init gart_iommu_hole_init(void)
 					if (!no_iommu &&
 					    max_pfn > MAX_DMA32_PFN &&
 					    !printed_gart_size_msg) {
-						printk(KERN_ERR "you are using iommu with agp, but GART size is less than 64M\n");
-						printk(KERN_ERR "please increase GART size in your BIOS setup\n");
-						printk(KERN_ERR "if BIOS doesn't have that option, contact your HW vendor!\n");
+						pr_err("you are using iommu with agp, but GART size is less than 64M\n");
+						pr_err("please increase GART size in your BIOS setup\n");
+						pr_err("if BIOS doesn't have that option, contact your HW vendor!\n");
 						printed_gart_size_msg = 1;
 					}
 				} else {
@@ -446,13 +447,10 @@ out:
 		   force_iommu ||
 		   valid_agp ||
 		   fallback_aper_force) {
-		printk(KERN_INFO
-			"Your BIOS doesn't leave a aperture memory hole\n");
-		printk(KERN_INFO
-			"Please enable the IOMMU option in the BIOS setup\n");
-		printk(KERN_INFO
-			"This costs you %d MB of RAM\n",
-				32 << fallback_aper_order);
+		pr_info("Your BIOS doesn't leave a aperture memory hole\n");
+		pr_info("Please enable the IOMMU option in the BIOS setup\n");
+		pr_info("This costs you %d MB of RAM\n",
+			32 << fallback_aper_order);
 
 		aper_order = fallback_aper_order;
 		aper_alloc = allocate_aperture();

