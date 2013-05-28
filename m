Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759363Ab3E1D4m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 23:56:42 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52482 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758767Ab3E1DyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:54:25 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Yves-Alexis Perez" <corsac@debian.org>
Date: Tue, 28 May 2013 04:49:53 +0100
Message-ID: <lsq.1369712993.139965978@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [01/94] Revert "drm/i915: Fix detection of base of stolen memory"
In-Reply-To: <lsq.1369712992.755341692@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.46-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

This reverts commit 53e587aa5ca81497d0ea6e340320ec5778d1f311.
Yves-Alexis Perez reported that it broke the driver on two machines
with GMA4500 and i965 chips.  Only the backported version in 3.2.45
had this effect; the fix in mainline is fine.

Daniel Vetter stated that the fix is not needed in 3.2 anyway.

Reported-by: Yves-Alexis Perez <corsac@debian.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/i915_dma.c |   81 +++++++++++++++++++--------------------
 drivers/gpu/drm/i915/i915_drv.h |    1 -
 2 files changed, 40 insertions(+), 42 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index c77fc67..ca67338 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1007,50 +1007,56 @@ intel_teardown_mchbar(struct drm_device *dev)
 		release_resource(&dev_priv->mch_res);
 }
 
-static unsigned long i915_stolen_to_physical(struct drm_device *dev)
+#define PTE_ADDRESS_MASK		0xfffff000
+#define PTE_ADDRESS_MASK_HIGH		0x000000f0 /* i915+ */
+#define PTE_MAPPING_TYPE_UNCACHED	(0 << 1)
+#define PTE_MAPPING_TYPE_DCACHE		(1 << 1) /* i830 only */
+#define PTE_MAPPING_TYPE_CACHED		(3 << 1)
+#define PTE_MAPPING_TYPE_MASK		(3 << 1)
+#define PTE_VALID			(1 << 0)
+
+/**
+ * i915_stolen_to_phys - take an offset into stolen memory and turn it into
+ *                       a physical one
+ * @dev: drm device
+ * @offset: address to translate
+ *
+ * Some chip functions require allocations from stolen space and need the
+ * physical address of the memory in question.
+ */
+static unsigned long i915_stolen_to_phys(struct drm_device *dev, u32 offset)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	struct pci_dev *pdev = dev_priv->bridge_dev;
 	u32 base;
 
+#if 0
 	/* On the machines I have tested the Graphics Base of Stolen Memory
-	 * is unreliable, so on those compute the base by subtracting the
-	 * stolen memory from the Top of Low Usable DRAM which is where the
-	 * BIOS places the graphics stolen memory.
-	 *
-	 * On gen2, the layout is slightly different with the Graphics Segment
-	 * immediately following Top of Memory (or Top of Usable DRAM). Note
-	 * it appears that TOUD is only reported by 865g, so we just use the
-	 * top of memory as determined by the e820 probe.
-	 *
-	 * XXX gen2 requires an unavailable symbol and 945gm fails with
-	 * its value of TOLUD.
+	 * is unreliable, so compute the base by subtracting the stolen memory
+	 * from the Top of Low Usable DRAM which is where the BIOS places
+	 * the graphics stolen memory.
 	 */
-	base = 0;
-	if (INTEL_INFO(dev)->gen >= 6) {
-		/* Read Base Data of Stolen Memory Register (BDSM) directly.
-		 * Note that there is also a MCHBAR miror at 0x1080c0 or
-		 * we could use device 2:0x5c instead.
-		*/
-		pci_read_config_dword(pdev, 0xB0, &base);
-		base &= ~4095; /* lower bits used for locking register */
-	} else if (INTEL_INFO(dev)->gen > 3 || IS_G33(dev)) {
-		/* Read Graphics Base of Stolen Memory directly */
+	if (INTEL_INFO(dev)->gen > 3 || IS_G33(dev)) {
+		/* top 32bits are reserved = 0 */
 		pci_read_config_dword(pdev, 0xA4, &base);
-#if 0
-	} else if (IS_GEN3(dev)) {
+	} else {
+		/* XXX presume 8xx is the same as i915 */
+		pci_bus_read_config_dword(pdev->bus, 2, 0x5C, &base);
+	}
+#else
+	if (INTEL_INFO(dev)->gen > 3 || IS_G33(dev)) {
+		u16 val;
+		pci_read_config_word(pdev, 0xb0, &val);
+		base = val >> 4 << 20;
+	} else {
 		u8 val;
-		/* Stolen is immediately below Top of Low Usable DRAM */
 		pci_read_config_byte(pdev, 0x9c, &val);
 		base = val >> 3 << 27;
-		base -= dev_priv->mm.gtt->stolen_size;
-	} else {
-		/* Stolen is immediately above Top of Memory */
-		base = max_low_pfn_mapped << PAGE_SHIFT;
-#endif
 	}
+	base -= dev_priv->mm.gtt->stolen_size;
+#endif
 
-	return base;
+	return base + offset;
 }
 
 static void i915_warn_stolen(struct drm_device *dev)
@@ -1075,7 +1081,7 @@ static void i915_setup_compression(struct drm_device *dev, int size)
 	if (!compressed_fb)
 		goto err;
 
-	cfb_base = dev_priv->mm.stolen_base + compressed_fb->start;
+	cfb_base = i915_stolen_to_phys(dev, compressed_fb->start);
 	if (!cfb_base)
 		goto err_fb;
 
@@ -1088,7 +1094,7 @@ static void i915_setup_compression(struct drm_device *dev, int size)
 		if (!compressed_llb)
 			goto err_fb;
 
-		ll_base = dev_priv->mm.stolen_base + compressed_llb->start;
+		ll_base = i915_stolen_to_phys(dev, compressed_llb->start);
 		if (!ll_base)
 			goto err_llb;
 	}
@@ -1107,7 +1113,7 @@ static void i915_setup_compression(struct drm_device *dev, int size)
 	}
 
 	DRM_DEBUG_KMS("FBC base 0x%08lx, ll base 0x%08lx, size %dM\n",
-		      (long)cfb_base, (long)ll_base, size >> 20);
+		      cfb_base, ll_base, size >> 20);
 	return;
 
 err_llb:
@@ -1181,13 +1187,6 @@ static int i915_load_gem_init(struct drm_device *dev)
 	gtt_size = dev_priv->mm.gtt->gtt_total_entries << PAGE_SHIFT;
 	mappable_size = dev_priv->mm.gtt->gtt_mappable_entries << PAGE_SHIFT;
 
-	dev_priv->mm.stolen_base = i915_stolen_to_physical(dev);
-	if (dev_priv->mm.stolen_base == 0)
-		return 0;
-
-	DRM_DEBUG_KMS("found %d bytes of stolen memory at %08lx\n",
-		      dev_priv->mm.gtt->stolen_size, dev_priv->mm.stolen_base);
-
 	/* Basic memrange allocator for stolen space */
 	drm_mm_init(&dev_priv->mm.stolen, 0, prealloc_size);
 
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 20cd295..144d37c 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -581,7 +581,6 @@ typedef struct drm_i915_private {
 		unsigned long gtt_start;
 		unsigned long gtt_mappable_end;
 		unsigned long gtt_end;
-		unsigned long stolen_base; /* limited to low memory (32-bit) */
 
 		struct io_mapping *gtt_mapping;
 		int gtt_mtrr;

