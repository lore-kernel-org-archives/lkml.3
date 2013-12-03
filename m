Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab3LCPuw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 10:50:52 -0500
Received: from mga11.intel.com ([192.55.52.93]:40148 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753557Ab3LCPuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 10:50:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,818,1378882800"; 
   d="scan'208";a="443880035"
From: ville.syrjala@linux.intel.com
To: intel-gfx@lists.freedesktop.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/6] x86: Add Intel graphics stolen memory quirk for gen2 platforms
Date: Tue,  3 Dec 2013 17:49:49 +0200
Message-Id: <1386085793-317-3-git-send-email-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386085793-317-1-git-send-email-ville.syrjala@linux.intel.com>
References: <1386085793-317-1-git-send-email-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

There isn't an explicit stolen memory base register on gen2.
Some old comment in the i915 code suggests we should get it via
max_low_pfn_mapped, but that's clearly a bad idea on my MGM.

The e820 map in said machine looks like this:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009f7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009f800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000ce000-0x00000000000cffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000dc000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001f6effff] usable
[    0.000000] BIOS-e820: [mem 0x000000001f6f0000-0x000000001f6f7fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000001f6f8000-0x000000001f6fffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000001f700000-0x000000001fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec10000-0x00000000fec1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffb00000-0x00000000ffbfffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fff00000-0x00000000ffffffff] reserved

That makes max_low_pfn_mapped = 1f6f0000, so assuming our stolen memory
would start there would place it on top of some ACPI memory regions.
So not a good idea as already stated.

The 9MB region after the ACPI regions at 0x1f700000 however looks
promising given that the macine reports the stolen memory size to be
8MB. Looking at the PGTBL_CTL register, the GTT entries are at offset
0x1fee00000, and given that the GTT entries occupy 128KB, it looks like
the stolen memory could start at 0x1f700000 and the GTT entries would
occupy the last 128KB of the stolen memory.

After some more digging through chipset documentation, I've determined
the BIOS first allocates space for something called TSEG (something to
do with SMM) from the top of memory, and then it allocates the graphics
stolen memory below that. Accordind to the chipset documentation TSEG
has a fixed size of 1MB on 855. So that explains the top 1MB in the
e820 region. And it also confirms that the GTT entries are in fact at
the end of the the stolen memory region.

Derive the stolen memory base address on gen2 the same as the BIOS does
(TOM-TSEG_SIZE-stolen_size). There are a few differences between the
registers on various gen2 chipsets, so a few different codepaths are
required.

865G is again bit more special since it seems to support enough memory
to hit 4GB address space issues. This means the PCI allocations will
also affect the location of the stolen memory. Fortunately there
appears to be the TOUD register which may give us the correct answer
directly. But the chipset docs are a bit unclear, so I'm not 100%
sure that the graphics stolen memory is always the last thing the
BIOS steals. Someone would need to verify it on a real system.

I tested this on the my 855 machine, and so far everything looks
peachy.

v2: Rewrite to use the TOM-TSEG_SIZE-stolen_size and TOUD methods

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 arch/x86/kernel/early-quirks.c | 139 +++++++++++++++++++++++++++++++++++++++++
 include/drm/i915_drm.h         |  18 ++++++
 2 files changed, 157 insertions(+)

diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index fddd4d0..66357bf 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -247,6 +247,121 @@ static u32 __init intel_stolen_base(int num, int slot, int func, size_t stolen_s
 #define MB(x)	(KB (KB (x)))
 #define GB(x)	(MB (KB (x)))
 
+/* FIXME is this actually correct for 830? */
+static size_t __init i830_tseg_size(void)
+{
+	u8 tmp = read_pci_config_byte(0, 0, 0, I830_ESMRAMC);
+
+	if (!(tmp & TSEG_ENABLE))
+		return 0;
+
+	switch (tmp & TSEG_SIZE_MASK) {
+	case TSEG_SIZE_512K:
+		return KB(512);
+	case TSEG_SIZE_1M:
+		return MB(1);
+	default:
+		WARN_ON(1);
+		return 0;
+	}
+}
+
+static size_t __init i845_tseg_size(void)
+{
+	u8 tmp = read_pci_config_byte(0, 0, 0, I845_ESMRAMC);
+
+	if (!(tmp & TSEG_ENABLE))
+		return 0;
+
+	switch (tmp & TSEG_SIZE_MASK) {
+	case TSEG_SIZE_512K:
+		return KB(512);
+	case TSEG_SIZE_1M:
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
+/* FIXME is this actually correct for 830? */
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
@@ -329,6 +444,26 @@ struct intel_stolen_funcs {
 	u32 (*base)(int num, int slot, int func, size_t size);
 };
 
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
 static const struct intel_stolen_funcs gen3_stolen_funcs = {
 	.base = intel_stolen_base,
 	.size = gen3_stolen_size,
@@ -345,6 +480,10 @@ static const struct intel_stolen_funcs gen8_stolen_funcs = {
 };
 
 static struct pci_device_id intel_stolen_ids[] __initdata = {
+	INTEL_I830_IDS(&i830_stolen_funcs),
+	INTEL_I845G_IDS(&i845_stolen_funcs),
+	INTEL_I85X_IDS(&i85x_stolen_funcs),
+	INTEL_I865G_IDS(&i865_stolen_funcs),
 	INTEL_I915G_IDS(&gen3_stolen_funcs),
 	INTEL_I915GM_IDS(&gen3_stolen_funcs),
 	INTEL_I945G_IDS(&gen3_stolen_funcs),
diff --git a/include/drm/i915_drm.h b/include/drm/i915_drm.h
index 97d5497..ebfa5168 100644
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
@@ -72,4 +78,16 @@ extern bool i915_gpu_turbo_disable(void);
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
+#define    TSEG_SIZE_MASK	(3 << 1)
+#define    TSEG_SIZE_512K	(2 << 1)
+#define    TSEG_SIZE_1M		(3 << 1)
+
 #endif				/* _I915_DRM_H_ */
-- 
1.8.3.2

