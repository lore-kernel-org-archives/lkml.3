Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893AbaD2Xzo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 19:55:44 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:38915 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755474AbaD2Xzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 19:55:40 -0400
Subject: [PATCH v2 2/2] x86/gart: Tidy messages and add bridge device info
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: David Airlie <airlied@linux.ie>, x86@kernel.org,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Date: Tue, 29 Apr 2014 17:55:38 -0600
Message-ID: <20140429235538.11112.41112.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140429235015.11112.79459.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140429235015.11112.79459.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Print the AGP bridge info the same way as the rest of the kernel, e.g.,
"0000:00:04.0" instead of "00:04:00".

Also print the AGP aperture address range the same way we print resources,
and label it explicitly as a bus address range.

No functional change except the message changes.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 arch/x86/kernel/aperture_64.c |   39 ++++++++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index b11edf2b656d..6e2283423887 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -77,13 +77,13 @@ static u32 __init allocate_aperture(void)
 	addr = memblock_find_in_range(GART_MIN_ADDR, GART_MAX_ADDR,
 				      aper_size, aper_size);
 	if (!addr) {
-		pr_err("Cannot allocate aperture memory hole (%lx,%uK)\n",
-		       addr, aper_size>>10);
+		pr_err("Cannot allocate aperture memory hole [mem %#010lx-%#010lx] (%uKB)\n",
+		       addr, addr + aper_size - 1, aper_size >> 10);
 		return 0;
 	}
 	memblock_reserve(addr, aper_size);
-	pr_info("Mapping aperture over %d KB of RAM @ %lx\n", aper_size >> 10,
-		addr);
+	pr_info("Mapping aperture over RAM [mem %#010%lx-%#010lx] (%uKB)\n",
+		addr, addr + aper_size - 1, aper_size >> 10);
 	register_nosave_region(addr >> PAGE_SHIFT,
 			       (addr+aper_size) >> PAGE_SHIFT);
 
@@ -127,10 +127,11 @@ static u32 __init read_agp(int bus, int slot, int func, int cap, u32 *order)
 	u64 aper;
 	u32 old_order;
 
-	pr_info("AGP bridge at %02x:%02x:%02x\n", bus, slot, func);
+	pr_info("pci 0000:%02x:%02x:%02x: AGP bridge\n", bus, slot, func);
 	apsizereg = read_pci_config_16(bus, slot, func, cap + 0x14);
 	if (apsizereg == 0xffffffff) {
-		pr_err("APSIZE in AGP bridge unreadable\n");
+		pr_err("pci 0000:%02x:%02x.d: APSIZE unreadable\n",
+		       bus, slot, func);
 		return 0;
 	}
 
@@ -154,16 +155,18 @@ static u32 __init read_agp(int bus, int slot, int func, int cap, u32 *order)
 	 * On some sick chips, APSIZE is 0. It means it wants 4G
 	 * so let double check that order, and lets trust AMD NB settings:
 	 */
-	pr_info("Aperture from AGP @ %Lx old size %u MB\n",
-		aper, 32 << old_order);
+	pr_info("pci 0000:%02x:%02x.%d: AGP aperture [bus addr %#010Lx-%#010Lx] (old size %uMB)\n",
+		bus, slot, func, aper, aper + (32ULL << (old_order + 20)) - 1,
+		32 << old_order);
 	if (aper + (32ULL<<(20 + *order)) > 0x100000000ULL) {
-		pr_info("Aperture size %u MB (APSIZE %x) is not right, using settings from NB\n",
-			32 << *order, apsizereg);
+		pr_info("pci 0000:%02x:%02x.%d: AGP aperture size %uMB (APSIZE %#x) is not right, using settings from NB\n",
+			bus, slot, func, 32 << *order, apsizereg);
 		*order = old_order;
 	}
 
-	pr_info("Aperture from AGP @ %Lx size %u MB (APSIZE %x)\n", aper,
-		32 << *order, apsizereg);
+	pr_info("pci 0000:%02x:%02x.%d: AGP aperture [bus addr %#010Lx-%#010Lx] (%uMB, APSIZE %#x)\n",
+		bus, slot, func, aper, aper + (32ULL << (*order + 20)) - 1,
+		32ULL << *order, apsizereg);
 
 	if (!aperture_valid(aper, (32*1024*1024) << *order, 32<<20))
 		return 0;
@@ -311,7 +314,8 @@ void __init early_gart_iommu_check(void)
 		if (e820_any_mapped(aper_base, aper_base + aper_size,
 				    E820_RAM)) {
 			/* reserve it, so we can reuse it in second kernel */
-			pr_info("update e820 for GART\n");
+			pr_info("e820: reserve [mem %#010Lx-%#010Lx] for GART\n",
+				aper_base, aper_base + aper_size - 1);
 			e820_add_region(aper_base, aper_size, E820_RESERVED);
 			update_e820();
 		}
@@ -396,8 +400,9 @@ int __init gart_iommu_hole_init(void)
 			aper_base = read_pci_config(bus, slot, 3, AMD64_GARTAPERTUREBASE) & 0x7fff;
 			aper_base <<= 25;
 
-			pr_info("Node %d: aperture @ %Lx size %u MB\n",
-				node, aper_base, aper_size >> 20);
+			pr_info("Node %d: aperture [bus addr %#010Lx-%#010Lx] (%uMB)\n",
+				node, aper_base, aper_base + aper_size - 1,
+				aper_size >> 20);
 			node++;
 
 			if (!aperture_valid(aper_base, aper_size, 64<<20)) {
@@ -408,7 +413,7 @@ int __init gart_iommu_hole_init(void)
 					if (!no_iommu &&
 					    max_pfn > MAX_DMA32_PFN &&
 					    !printed_gart_size_msg) {
-						pr_err("you are using iommu with agp, but GART size is less than 64M\n");
+						pr_err("you are using iommu with agp, but GART size is less than 64MB\n");
 						pr_err("please increase GART size in your BIOS setup\n");
 						pr_err("if BIOS doesn't have that option, contact your HW vendor!\n");
 						printed_gart_size_msg = 1;
@@ -449,7 +454,7 @@ out:
 		   fallback_aper_force) {
 		pr_info("Your BIOS doesn't leave a aperture memory hole\n");
 		pr_info("Please enable the IOMMU option in the BIOS setup\n");
-		pr_info("This costs you %d MB of RAM\n",
+		pr_info("This costs you %dMB of RAM\n",
 			32 << fallback_aper_order);
 
 		aper_order = fallback_aper_order;

