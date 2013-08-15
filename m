Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336Ab3HOWnq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 18:43:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63863 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637Ab3HOWno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 18:43:44 -0400
Subject: [PATCH] i915: Update VGA arbiter support for newer devices
To: intel-gfx@lists.freedesktop.org
From: Alex Williamson <alex.williamson@redhat.com>
Cc: airlied@redhat.com, linux-kernel@vger.kernel.org,
        ville.syrjala@linux.intel.com
Date: Thu, 15 Aug 2013 16:43:42 -0600
Message-ID: <20130815223917.27890.28003.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is intended to add VGA arbiter support for Intel HD graphics on
Core processors.  The old GMCH registers no longer exist, so even
though it appears that i915 participates in VGA arbitration, it doesn't
work.  On Intel HD graphics we already attempt to disable VGA regions
of the device.  This makes registering as a VGA client unnecessary since
we don't intend to operate differently depending on how many VGA devices
are present.  We can disable VGA memory regions by clearing a memory
enable bit in the VGA MSR.  That only leaves VGA IO, which we update
the VGA arbiter to know that we don't participate in VGA memory
arbitration.  We also add a hook on unload to re-enable memory and
reinstate VGA memory arbitration.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

This patch depends on series "vgaarb: Fixes for partial VGA opt-out".

Is HAS_PCH_SPLIT() the right test to identify newer graphics devices?

I've tried not to disturb the old code since I can't test it, but
welcome feedback whether we should just remove it.  I also don't know
what most of i915_disable_vga() is doing and whether it's still
relevant.

 drivers/gpu/drm/i915/i915_dma.c      |    9 ++++++---
 drivers/gpu/drm/i915/intel_display.c |   26 ++++++++++++++++++++++++++
 2 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index f466980..d9cf216 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1287,9 +1287,12 @@ static int i915_load_modeset_init(struct drm_device *dev)
 	 * then we do not take part in VGA arbitration and the
 	 * vga_client_register() fails with -ENODEV.
 	 */
-	ret = vga_client_register(dev->pdev, dev, NULL, i915_vga_set_decode);
-	if (ret && ret != -ENODEV)
-		goto out;
+	if (!HAS_PCH_SPLIT(dev)) {
+		ret = vga_client_register(dev->pdev, dev, NULL,
+					  i915_vga_set_decode);
+		if (ret && ret != -ENODEV)
+			goto out;
+	}
 
 	intel_register_dsm_handler();
 
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 5fb3058..759ad7e 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -9519,6 +9519,16 @@ static void i915_disable_vga(struct drm_device *dev)
 	outb(SR01, VGA_SR_INDEX);
 	sr1 = inb(VGA_SR_DATA);
 	outb(sr1 | 1<<5, VGA_SR_DATA);
+
+	/* Disable VGA memory on Intel HD */
+	if (HAS_PCH_SPLIT(dev)) {
+		I915_WRITE8(VGA_MSR_WRITE,
+			    I915_READ8(VGA_MSR_READ) & ~VGA_MSR_MEM_EN);
+		vga_set_legacy_decoding(dev->pdev, VGA_RSRC_LEGACY_IO |
+						   VGA_RSRC_NORMAL_IO |
+						   VGA_RSRC_NORMAL_MEM);
+	}
+
 	vga_put(dev->pdev, VGA_RSRC_LEGACY_IO);
 	udelay(300);
 
@@ -9526,6 +9536,20 @@ static void i915_disable_vga(struct drm_device *dev)
 	POSTING_READ(vga_reg);
 }
 
+static void i915_enable_vga(struct drm_device *dev)
+{
+	struct drm_i915_private *dev_priv = dev->dev_private;
+
+	/* Disable VGA memory on Intel HD */
+	if (HAS_PCH_SPLIT(dev)) {
+		I915_WRITE8(VGA_MSR_WRITE,
+			    I915_READ8(VGA_MSR_READ) | VGA_MSR_MEM_EN);
+		vga_set_legacy_decoding(dev->pdev, VGA_RSRC_LEGACY_MASK |
+						   VGA_RSRC_NORMAL_IO |
+						   VGA_RSRC_NORMAL_MEM);
+	}
+}
+
 void intel_modeset_init_hw(struct drm_device *dev)
 {
 	intel_init_power_well(dev);
@@ -9983,6 +10007,8 @@ void intel_modeset_cleanup(struct drm_device *dev)
 
 	intel_disable_fbc(dev);
 
+	i915_enable_vga(dev);
+
 	intel_disable_gt_powersave(dev);
 
 	ironlake_teardown_rc6(dev);

