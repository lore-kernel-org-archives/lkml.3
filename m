Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751270AbaDAI2H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 04:28:07 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:61015 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbaDAI2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 04:28:02 -0400
Date: Tue, 1 Apr 2014 10:27:57 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/platforms for v3.15
Message-ID: <20140401082757.GA23451@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-platform-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-platform-for-linus

   # HEAD: 936329de1e6bf3dfa8c056074e6fc6b673e7b1d0 x86, calgary: Use 8M TCE table size by default

Intel IOSF updates, Intel GPU memory init updates, Calgary update.

  out-of-topic modifications in x86-platform-for-linus:
  -------------------------------------------------------
  include/drm/i915_drm.h             # a4dff76: x86/gpu: Add Intel graphics stole

 Thanks,

	Ingo

------------------>
David E. Box (2):
      x86, iosf: Add dummy functions for loadable modules
      x86, iosf: Change IOSF_MBI Kconfig to default y

Ville Syrjälä (3):
      x86/gpu: Add vfunc for Intel graphics stolen memory base address
      x86/gpu: Add Intel graphics stolen memory quirk for gen2 platforms
      x86/gpu: Print the Intel graphics stolen memory range

WANG Chao (1):
      x86, calgary: Use 8M TCE table size by default


 arch/x86/Kconfig                 |   5 +-
 arch/x86/include/asm/iosf_mbi.h  |  33 ++++++
 arch/x86/kernel/early-quirks.c   | 211 +++++++++++++++++++++++++++++++++------
 arch/x86/kernel/iosf_mbi.c       |   6 ++
 arch/x86/kernel/pci-calgary_64.c |  31 +++---
 include/drm/i915_drm.h           |  20 ++++
 6 files changed, 263 insertions(+), 43 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0af5250..1487fdd 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2413,11 +2413,12 @@ config X86_DMA_REMAP
 	depends on STA2X11
 
 config IOSF_MBI
-	bool
+	bool "IOSF MBI support" if EXPERT
+	default y
 	depends on PCI
 	---help---
 	  To be selected by modules requiring access to the Intel OnChip System
-	  Fabric (IOSF) Sideband MailBox Interface (MBI). For MBI platforms
+	  Fabric (IOSF) Sideband MailBox Interface (MBI). For IOSF platforms
 	  enumerable by PCI.
 
 source "net/Kconfig"
diff --git a/arch/x86/include/asm/iosf_mbi.h b/arch/x86/include/asm/iosf_mbi.h
index 8e71c79..9fc5402 100644
--- a/arch/x86/include/asm/iosf_mbi.h
+++ b/arch/x86/include/asm/iosf_mbi.h
@@ -5,6 +5,8 @@
 #ifndef IOSF_MBI_SYMS_H
 #define IOSF_MBI_SYMS_H
 
+#ifdef CONFIG_IOSF_MBI
+
 #define MBI_MCR_OFFSET		0xD0
 #define MBI_MDR_OFFSET		0xD4
 #define MBI_MCRX_OFFSET		0xD8
@@ -50,6 +52,8 @@
 #define BT_MBI_PCIE_READ	0x00
 #define BT_MBI_PCIE_WRITE	0x01
 
+bool iosf_mbi_available(void);
+
 /**
  * iosf_mbi_read() - MailBox Interface read command
  * @port:	port indicating subunit being accessed
@@ -87,4 +91,33 @@ int iosf_mbi_write(u8 port, u8 opcode, u32 offset, u32 mdr);
  */
 int iosf_mbi_modify(u8 port, u8 opcode, u32 offset, u32 mdr, u32 mask);
 
+#else /* CONFIG_IOSF_MBI is not enabled */
+static inline
+bool iosf_mbi_available(void)
+{
+	return false;
+}
+
+static inline
+int iosf_mbi_read(u8 port, u8 opcode, u32 offset, u32 *mdr)
+{
+	WARN();
+	return -EPERM;
+}
+
+static inline
+int iosf_mbi_write(u8 port, u8 opcode, u32 offset, u32 mdr)
+{
+	WARN();
+	return -EPERM;
+}
+
+static inline
+int iosf_mbi_modify(u8 port, u8 opcode, u32 offset, u32 mdr, u32 mask)
+{
+	WARN();
+	return -EPERM;
+}
+#endif /* CONFIG_IOSF_MBI */
+
 #endif /* IOSF_MBI_SYMS_H */
diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index bc4a088..52f36e6 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -228,7 +228,7 @@ static void __init intel_remapping_check(int num, int slot, int func)
  *
  * And yes, so far on current devices the base addr is always under 4G.
  */
-static u32 __init intel_stolen_base(int num, int slot, int func)
+static u32 __init intel_stolen_base(int num, int slot, int func, size_t stolen_size)
 {
 	u32 base;
 
@@ -247,6 +247,114 @@ static u32 __init intel_stolen_base(int num, int slot, int func)
 #define MB(x)	(KB (KB (x)))
 #define GB(x)	(MB (KB (x)))
 
+static size_t __init i830_tseg_size(void)
+{
+	u8 tmp = read_pci_config_byte(0, 0, 0, I830_ESMRAMC);
+
+	if (!(tmp & TSEG_ENABLE))
+		return 0;
+
+	if (tmp & I830_TSEG_SIZE_1M)
+		return MB(1);
+	else
+		return KB(512);
+}
+
+static size_t __init i845_tseg_size(void)
+{
+	u8 tmp = read_pci_config_byte(0, 0, 0, I845_ESMRAMC);
+
+	if (!(tmp & TSEG_ENABLE))
+		return 0;
+
+	switch (tmp & I845_TSEG_SIZE_MASK) {
+	case I845_TSEG_SIZE_512K:
+		return KB(512);
+	case I845_TSEG_SIZE_1M:
+		return MB(1);
+	default:
+		WARN_ON(1);
+		return 0;
+	}
+}
+
+static size_t __init i85x_tseg_size(void)
+{
+	u8 tmp = read_pci_config_byte(0, 0, 0, I85X_ESMRAMC);
+
+	if (!(tmp & TSEG_ENABLE))
+		return 0;
+
+	return MB(1);
+}
+
+static size_t __init i830_mem_size(void)
+{
+	return read_pci_config_byte(0, 0, 0, I830_DRB3) * MB(32);
+}
+
+static size_t __init i85x_mem_size(void)
+{
+	return read_pci_config_byte(0, 0, 1, I85X_DRB3) * MB(32);
+}
+
+/*
+ * On 830/845/85x the stolen memory base isn't available in any
+ * register. We need to calculate it as TOM-TSEG_SIZE-stolen_size.
+ */
+static u32 __init i830_stolen_base(int num, int slot, int func, size_t stolen_size)
+{
+	return i830_mem_size() - i830_tseg_size() - stolen_size;
+}
+
+static u32 __init i845_stolen_base(int num, int slot, int func, size_t stolen_size)
+{
+	return i830_mem_size() - i845_tseg_size() - stolen_size;
+}
+
+static u32 __init i85x_stolen_base(int num, int slot, int func, size_t stolen_size)
+{
+	return i85x_mem_size() - i85x_tseg_size() - stolen_size;
+}
+
+static u32 __init i865_stolen_base(int num, int slot, int func, size_t stolen_size)
+{
+	/*
+	 * FIXME is the graphics stolen memory region
+	 * always at TOUD? Ie. is it always the last
+	 * one to be allocated by the BIOS?
+	 */
+	return read_pci_config_16(0, 0, 0, I865_TOUD) << 16;
+}
+
+static size_t __init i830_stolen_size(int num, int slot, int func)
+{
+	size_t stolen_size;
+	u16 gmch_ctrl;
+
+	gmch_ctrl = read_pci_config_16(0, 0, 0, I830_GMCH_CTRL);
+
+	switch (gmch_ctrl & I830_GMCH_GMS_MASK) {
+	case I830_GMCH_GMS_STOLEN_512:
+		stolen_size = KB(512);
+		break;
+	case I830_GMCH_GMS_STOLEN_1024:
+		stolen_size = MB(1);
+		break;
+	case I830_GMCH_GMS_STOLEN_8192:
+		stolen_size = MB(8);
+		break;
+	case I830_GMCH_GMS_LOCAL:
+		/* local memory isn't part of the normal address space */
+		stolen_size = 0;
+		break;
+	default:
+		return 0;
+	}
+
+	return stolen_size;
+}
+
 static size_t __init gen3_stolen_size(int num, int slot, int func)
 {
 	size_t stolen_size;
@@ -313,7 +421,7 @@ static size_t __init gen6_stolen_size(int num, int slot, int func)
 	return gmch_ctrl << 25; /* 32 MB units */
 }
 
-static inline size_t gen8_stolen_size(int num, int slot, int func)
+static size_t gen8_stolen_size(int num, int slot, int func)
 {
 	u16 gmch_ctrl;
 
@@ -323,31 +431,74 @@ static inline size_t gen8_stolen_size(int num, int slot, int func)
 	return gmch_ctrl << 25; /* 32 MB units */
 }
 
-typedef size_t (*stolen_size_fn)(int num, int slot, int func);
+
+struct intel_stolen_funcs {
+	size_t (*size)(int num, int slot, int func);
+	u32 (*base)(int num, int slot, int func, size_t size);
+};
+
+static const struct intel_stolen_funcs i830_stolen_funcs = {
+	.base = i830_stolen_base,
+	.size = i830_stolen_size,
+};
+
+static const struct intel_stolen_funcs i845_stolen_funcs = {
+	.base = i845_stolen_base,
+	.size = i830_stolen_size,
+};
+
+static const struct intel_stolen_funcs i85x_stolen_funcs = {
+	.base = i85x_stolen_base,
+	.size = gen3_stolen_size,
+};
+
+static const struct intel_stolen_funcs i865_stolen_funcs = {
+	.base = i865_stolen_base,
+	.size = gen3_stolen_size,
+};
+
+static const struct intel_stolen_funcs gen3_stolen_funcs = {
+	.base = intel_stolen_base,
+	.size = gen3_stolen_size,
+};
+
+static const struct intel_stolen_funcs gen6_stolen_funcs = {
+	.base = intel_stolen_base,
+	.size = gen6_stolen_size,
+};
+
+static const struct intel_stolen_funcs gen8_stolen_funcs = {
+	.base = intel_stolen_base,
+	.size = gen8_stolen_size,
+};
 
 static struct pci_device_id intel_stolen_ids[] __initdata = {
-	INTEL_I915G_IDS(gen3_stolen_size),
-	INTEL_I915GM_IDS(gen3_stolen_size),
-	INTEL_I945G_IDS(gen3_stolen_size),
-	INTEL_I945GM_IDS(gen3_stolen_size),
-	INTEL_VLV_M_IDS(gen6_stolen_size),
-	INTEL_VLV_D_IDS(gen6_stolen_size),
-	INTEL_PINEVIEW_IDS(gen3_stolen_size),
-	INTEL_I965G_IDS(gen3_stolen_size),
-	INTEL_G33_IDS(gen3_stolen_size),
-	INTEL_I965GM_IDS(gen3_stolen_size),
-	INTEL_GM45_IDS(gen3_stolen_size),
-	INTEL_G45_IDS(gen3_stolen_size),
-	INTEL_IRONLAKE_D_IDS(gen3_stolen_size),
-	INTEL_IRONLAKE_M_IDS(gen3_stolen_size),
-	INTEL_SNB_D_IDS(gen6_stolen_size),
-	INTEL_SNB_M_IDS(gen6_stolen_size),
-	INTEL_IVB_M_IDS(gen6_stolen_size),
-	INTEL_IVB_D_IDS(gen6_stolen_size),
-	INTEL_HSW_D_IDS(gen6_stolen_size),
-	INTEL_HSW_M_IDS(gen6_stolen_size),
-	INTEL_BDW_M_IDS(gen8_stolen_size),
-	INTEL_BDW_D_IDS(gen8_stolen_size)
+	INTEL_I830_IDS(&i830_stolen_funcs),
+	INTEL_I845G_IDS(&i845_stolen_funcs),
+	INTEL_I85X_IDS(&i85x_stolen_funcs),
+	INTEL_I865G_IDS(&i865_stolen_funcs),
+	INTEL_I915G_IDS(&gen3_stolen_funcs),
+	INTEL_I915GM_IDS(&gen3_stolen_funcs),
+	INTEL_I945G_IDS(&gen3_stolen_funcs),
+	INTEL_I945GM_IDS(&gen3_stolen_funcs),
+	INTEL_VLV_M_IDS(&gen6_stolen_funcs),
+	INTEL_VLV_D_IDS(&gen6_stolen_funcs),
+	INTEL_PINEVIEW_IDS(&gen3_stolen_funcs),
+	INTEL_I965G_IDS(&gen3_stolen_funcs),
+	INTEL_G33_IDS(&gen3_stolen_funcs),
+	INTEL_I965GM_IDS(&gen3_stolen_funcs),
+	INTEL_GM45_IDS(&gen3_stolen_funcs),
+	INTEL_G45_IDS(&gen3_stolen_funcs),
+	INTEL_IRONLAKE_D_IDS(&gen3_stolen_funcs),
+	INTEL_IRONLAKE_M_IDS(&gen3_stolen_funcs),
+	INTEL_SNB_D_IDS(&gen6_stolen_funcs),
+	INTEL_SNB_M_IDS(&gen6_stolen_funcs),
+	INTEL_IVB_M_IDS(&gen6_stolen_funcs),
+	INTEL_IVB_D_IDS(&gen6_stolen_funcs),
+	INTEL_HSW_D_IDS(&gen6_stolen_funcs),
+	INTEL_HSW_M_IDS(&gen6_stolen_funcs),
+	INTEL_BDW_M_IDS(&gen8_stolen_funcs),
+	INTEL_BDW_D_IDS(&gen8_stolen_funcs)
 };
 
 static void __init intel_graphics_stolen(int num, int slot, int func)
@@ -364,11 +515,13 @@ static void __init intel_graphics_stolen(int num, int slot, int func)
 
 	for (i = 0; i < ARRAY_SIZE(intel_stolen_ids); i++) {
 		if (intel_stolen_ids[i].device == device) {
-			stolen_size_fn stolen_size =
-				(stolen_size_fn)intel_stolen_ids[i].driver_data;
-			size = stolen_size(num, slot, func);
-			start = intel_stolen_base(num, slot, func);
+			const struct intel_stolen_funcs *stolen_funcs =
+				(const struct intel_stolen_funcs *)intel_stolen_ids[i].driver_data;
+			size = stolen_funcs->size(num, slot, func);
+			start = stolen_funcs->base(num, slot, func, size);
 			if (size && start) {
+				printk(KERN_INFO "Reserving Intel graphics stolen memory at 0x%x-0x%x\n",
+				       start, start + (u32)size - 1);
 				/* Mark this space as reserved */
 				e820_add_region(start, size, E820_RESERVED);
 				sanitize_e820_map(e820.map,
diff --git a/arch/x86/kernel/iosf_mbi.c b/arch/x86/kernel/iosf_mbi.c
index c3aae66..d3803c6 100644
--- a/arch/x86/kernel/iosf_mbi.c
+++ b/arch/x86/kernel/iosf_mbi.c
@@ -177,6 +177,12 @@ int iosf_mbi_modify(u8 port, u8 opcode, u32 offset, u32 mdr, u32 mask)
 }
 EXPORT_SYMBOL(iosf_mbi_modify);
 
+bool iosf_mbi_available(void)
+{
+	return mbi_pdev;
+}
+EXPORT_SYMBOL(iosf_mbi_available);
+
 static int iosf_mbi_probe(struct pci_dev *pdev,
 			  const struct pci_device_id *unused)
 {
diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index 299d493..0497f71 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -1207,23 +1207,31 @@ error:
 	return ret;
 }
 
-static inline int __init determine_tce_table_size(u64 ram)
+static inline int __init determine_tce_table_size(void)
 {
 	int ret;
 
 	if (specified_table_size != TCE_TABLE_SIZE_UNSPECIFIED)
 		return specified_table_size;
 
-	/*
-	 * Table sizes are from 0 to 7 (TCE_TABLE_SIZE_64K to
-	 * TCE_TABLE_SIZE_8M). Table size 0 has 8K entries and each
-	 * larger table size has twice as many entries, so shift the
-	 * max ram address by 13 to divide by 8K and then look at the
-	 * order of the result to choose between 0-7.
-	 */
-	ret = get_order(ram >> 13);
-	if (ret > TCE_TABLE_SIZE_8M)
+	if (is_kdump_kernel() && saved_max_pfn) {
+		/*
+		 * Table sizes are from 0 to 7 (TCE_TABLE_SIZE_64K to
+		 * TCE_TABLE_SIZE_8M). Table size 0 has 8K entries and each
+		 * larger table size has twice as many entries, so shift the
+		 * max ram address by 13 to divide by 8K and then look at the
+		 * order of the result to choose between 0-7.
+		 */
+		ret = get_order((saved_max_pfn * PAGE_SIZE) >> 13);
+		if (ret > TCE_TABLE_SIZE_8M)
+			ret = TCE_TABLE_SIZE_8M;
+	} else {
+		/*
+		 * Use 8M by default (suggested by Muli) if it's not
+		 * kdump kernel and saved_max_pfn isn't set.
+		 */
 		ret = TCE_TABLE_SIZE_8M;
+	}
 
 	return ret;
 }
@@ -1418,8 +1426,7 @@ int __init detect_calgary(void)
 		return -ENOMEM;
 	}
 
-	specified_table_size = determine_tce_table_size((is_kdump_kernel() ?
-					saved_max_pfn : max_pfn) * PAGE_SIZE);
+	specified_table_size = determine_tce_table_size();
 
 	for (bus = 0; bus < MAX_PHB_BUS_NUM; bus++) {
 		struct calgary_bus_info *info = &bus_info[bus];
diff --git a/include/drm/i915_drm.h b/include/drm/i915_drm.h
index 97d5497..595f85c 100644
--- a/include/drm/i915_drm.h
+++ b/include/drm/i915_drm.h
@@ -56,6 +56,12 @@ extern bool i915_gpu_turbo_disable(void);
 
 #define I830_GMCH_CTRL			0x52
 
+#define I830_GMCH_GMS_MASK		0x70
+#define I830_GMCH_GMS_LOCAL		0x10
+#define I830_GMCH_GMS_STOLEN_512	0x20
+#define I830_GMCH_GMS_STOLEN_1024	0x30
+#define I830_GMCH_GMS_STOLEN_8192	0x40
+
 #define I855_GMCH_GMS_MASK		0xF0
 #define I855_GMCH_GMS_STOLEN_0M		0x0
 #define I855_GMCH_GMS_STOLEN_1M		(0x1 << 4)
@@ -72,4 +78,18 @@ extern bool i915_gpu_turbo_disable(void);
 #define INTEL_GMCH_GMS_STOLEN_224M	(0xc << 4)
 #define INTEL_GMCH_GMS_STOLEN_352M	(0xd << 4)
 
+#define I830_DRB3		0x63
+#define I85X_DRB3		0x43
+#define I865_TOUD		0xc4
+
+#define I830_ESMRAMC		0x91
+#define I845_ESMRAMC		0x9e
+#define I85X_ESMRAMC		0x61
+#define    TSEG_ENABLE		(1 << 0)
+#define    I830_TSEG_SIZE_512K	(0 << 1)
+#define    I830_TSEG_SIZE_1M	(1 << 1)
+#define    I845_TSEG_SIZE_MASK	(3 << 1)
+#define    I845_TSEG_SIZE_512K	(2 << 1)
+#define    I845_TSEG_SIZE_1M	(3 << 1)
+
 #endif				/* _I915_DRM_H_ */
