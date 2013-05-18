Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758780Ab3ERDAY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:00:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26211 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758495Ab3ERDAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:16 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=2yDWLqmzAYIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=mBJG7oRgEikA:10 a=taGs_qngAAAA:8 a=FIGD3-XparafySyNnDUA:9 a=n7Cch7CHiCMA:10 a=jeBq3FmKZ4MA:10 a=od1YTsnorB7X38UH:21 a=hmo0dDnLwZqtIKLv:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021659.342201420@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:17:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 110/136 ] drm/i915: Fix detection of base of stolen memory
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0110-drm-i915-Fix-detection-of-base-of-stolen-memory.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

[ Upstream commit e12a2d53ae45a69aea499b64f75e7222cca0f12f ]

The routine to query the base of stolen memory was using the wrong
registers and the wrong encodings on virtually every platform.

It was not until the G33 refresh, that a PCI config register was
introduced that explicitly said where the stolen memory was. Prior to
865G there was not even a register that said where the end of usable
low memory was and where the stolen memory began (or ended depending
upon chipset). Before then, one has to look at the BIOS memory maps to
find the Top of Memory. Alas that is not exported by arch/x86 and so we
have to resort to disabling stolen memory on gen2 for the time being.

Then SandyBridge enlarged the PCI register to a full 32-bits and change
the encoding of the address, so even though we happened to be querying
the right register, we read the wrong bits and ended up using address 0
for our stolen data, i.e. notably FBC.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/gpu/drm/i915/i915_drv.h        |    1 +
 drivers/gpu/drm/i915/i915_gem_stolen.c |   81 ++++++++++++++++----------------
 2 files changed, 42 insertions(+), 40 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 627fe35..ae85929 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -672,6 +672,7 @@ typedef struct drm_i915_private {
 		unsigned long gtt_start;
 		unsigned long gtt_mappable_end;
 		unsigned long gtt_end;
+		unsigned long stolen_base; /* limited to low memory (32-bit) */
 
 		struct io_mapping *gtt_mapping;
 		phys_addr_t gtt_base_addr;
diff --git a/drivers/gpu/drm/i915/i915_gem_stolen.c b/drivers/gpu/drm/i915/i915_gem_stolen.c
index ada2e90..d023ed6 100644
--- a/drivers/gpu/drm/i915/i915_gem_stolen.c
+++ b/drivers/gpu/drm/i915/i915_gem_stolen.c
@@ -43,56 +43,50 @@
  * for is a boon.
  */
 
-#define PTE_ADDRESS_MASK		0xfffff000
-#define PTE_ADDRESS_MASK_HIGH		0x000000f0 /* i915+ */
-#define PTE_MAPPING_TYPE_UNCACHED	(0 << 1)
-#define PTE_MAPPING_TYPE_DCACHE		(1 << 1) /* i830 only */
-#define PTE_MAPPING_TYPE_CACHED		(3 << 1)
-#define PTE_MAPPING_TYPE_MASK		(3 << 1)
-#define PTE_VALID			(1 << 0)
-
-/**
- * i915_stolen_to_phys - take an offset into stolen memory and turn it into
- *                       a physical one
- * @dev: drm device
- * @offset: address to translate
- *
- * Some chip functions require allocations from stolen space and need the
- * physical address of the memory in question.
- */
-static unsigned long i915_stolen_to_phys(struct drm_device *dev, u32 offset)
+static unsigned long i915_stolen_to_physical(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	struct pci_dev *pdev = dev_priv->bridge_dev;
 	u32 base;
 
-#if 0
 	/* On the machines I have tested the Graphics Base of Stolen Memory
-	 * is unreliable, so compute the base by subtracting the stolen memory
-	 * from the Top of Low Usable DRAM which is where the BIOS places
-	 * the graphics stolen memory.
+	 * is unreliable, so on those compute the base by subtracting the
+	 * stolen memory from the Top of Low Usable DRAM which is where the
+	 * BIOS places the graphics stolen memory.
+	 *
+	 * On gen2, the layout is slightly different with the Graphics Segment
+	 * immediately following Top of Memory (or Top of Usable DRAM). Note
+	 * it appears that TOUD is only reported by 865g, so we just use the
+	 * top of memory as determined by the e820 probe.
+	 *
+	 * XXX gen2 requires an unavailable symbol and 945gm fails with
+	 * its value of TOLUD.
 	 */
-	if (INTEL_INFO(dev)->gen > 3 || IS_G33(dev)) {
-		/* top 32bits are reserved = 0 */
+	base = 0;
+	if (INTEL_INFO(dev)->gen >= 6) {
+		/* Read Base Data of Stolen Memory Register (BDSM) directly.
+		 * Note that there is also a MCHBAR miror at 0x1080c0 or
+		 * we could use device 2:0x5c instead.
+		*/
+		pci_read_config_dword(pdev, 0xB0, &base);
+		base &= ~4095; /* lower bits used for locking register */
+	} else if (INTEL_INFO(dev)->gen > 3 || IS_G33(dev)) {
+		/* Read Graphics Base of Stolen Memory directly */
 		pci_read_config_dword(pdev, 0xA4, &base);
-	} else {
-		/* XXX presume 8xx is the same as i915 */
-		pci_bus_read_config_dword(pdev->bus, 2, 0x5C, &base);
-	}
-#else
-	if (INTEL_INFO(dev)->gen > 3 || IS_G33(dev)) {
-		u16 val;
-		pci_read_config_word(pdev, 0xb0, &val);
-		base = val >> 4 << 20;
-	} else {
+#if 0
+	} else if (IS_GEN3(dev)) {
 		u8 val;
+		/* Stolen is immediately below Top of Low Usable DRAM */
 		pci_read_config_byte(pdev, 0x9c, &val);
 		base = val >> 3 << 27;
-	}
-	base -= dev_priv->mm.gtt->stolen_size;
+		base -= dev_priv->mm.gtt->stolen_size;
+	} else {
+		/* Stolen is immediately above Top of Memory */
+		base = max_low_pfn_mapped << PAGE_SHIFT;
 #endif
+	}
 
-	return base + offset;
+	return base;
 }
 
 static void i915_warn_stolen(struct drm_device *dev)
@@ -117,7 +111,7 @@ static void i915_setup_compression(struct drm_device *dev, int size)
 	if (!compressed_fb)
 		goto err;
 
-	cfb_base = i915_stolen_to_phys(dev, compressed_fb->start);
+	cfb_base = dev_priv->mm.stolen_base + compressed_fb->start;
 	if (!cfb_base)
 		goto err_fb;
 
@@ -130,7 +124,7 @@ static void i915_setup_compression(struct drm_device *dev, int size)
 		if (!compressed_llb)
 			goto err_fb;
 
-		ll_base = i915_stolen_to_phys(dev, compressed_llb->start);
+		ll_base = dev_priv->mm.stolen_base + compressed_llb->start;
 		if (!ll_base)
 			goto err_llb;
 	}
@@ -149,7 +143,7 @@ static void i915_setup_compression(struct drm_device *dev, int size)
 	}
 
 	DRM_DEBUG_KMS("FBC base 0x%08lx, ll base 0x%08lx, size %dM\n",
-		      cfb_base, ll_base, size >> 20);
+		      (long)cfb_base, (long)ll_base, size >> 20);
 	return;
 
 err_llb:
@@ -181,6 +175,13 @@ int i915_gem_init_stolen(struct drm_device *dev)
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	unsigned long prealloc_size = dev_priv->mm.gtt->stolen_size;
 
+	dev_priv->mm.stolen_base = i915_stolen_to_physical(dev);
+	if (dev_priv->mm.stolen_base == 0)
+		return 0;
+
+	DRM_DEBUG_KMS("found %d bytes of stolen memory at %08lx\n",
+		      dev_priv->mm.gtt->stolen_size, dev_priv->mm.stolen_base);
+
 	/* Basic memrange allocator for stolen space */
 	drm_mm_init(&dev_priv->mm.stolen, 0, prealloc_size);
 
-- 
1.7.10.4


