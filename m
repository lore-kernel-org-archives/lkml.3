Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab3IQVHt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 17:07:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:42226 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753343Ab3IQVHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 17:07:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,926,1371106800"; 
   d="scan'208";a="379701042"
From: ville.syrjala@linux.intel.com
To: intel-gfx@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Dave Airlie <airlied@redhat.com>
Subject: [RFC][PATCH] drm/i915: Fix VGA handling using stop_machine() or mmio
Date: Wed, 18 Sep 2013 00:07:29 +0300
Message-Id: <1379452049-3748-1-git-send-email-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 1.8.1.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

We have several problems with out VGA handling:
- We try to use the GMCH control VGA disable bit even though it may
  be locked
- If we manage to disable VGA throuh GMCH control, we're no longer
  able to correctly disable the VGA plane
- Taking part in the VGA arbitration is too expensive for X [1]

So let's treat the GMCH control VGA disable bit as read-only and leave
it for the BIOS to set, as it was intended. To disable VGA we will use
the VGA misc register, and to disable VGA IO we will disable IO space
completely via the PCI command register.

But we still need VGA register access during resume (and possibly during
lid event on insane BIOSen) to disable the VGA plane. Also we need to
re-disable VGA memory decode via the VGA misc register on resume.

Luckily up to gen4, VGA registers can be accessed through MMIO.
Unfortunately from gen5 onwards only the legacy VGA IO port range
works. So on gen5+ we still need IO space to be enabled during those
few special moments when we need to access VGA registers.

We still want to opt out of VGA arbitration on gen5+, so we have keep
IO space disabled most of the time. And when we do need to poke at VGA
registers, we enable IO space briefly while no one is looking. To
guarantee that no one is looking we will use stop_machine().

[1] http://lists.x.org/archives/xorg-devel/2013-September/037763.html

Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Dave Airlie <airlied@redhat.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/gpu/drm/i915/i915_dma.c      |  37 +-----
 drivers/gpu/drm/i915/i915_suspend.c  |   4 +-
 drivers/gpu/drm/i915/intel_display.c | 247 +++++++++++++++++++++++++++++------
 drivers/gpu/drm/i915/intel_drv.h     |   1 -
 4 files changed, 215 insertions(+), 74 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index be5120f7..0fd86c2 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1225,19 +1225,6 @@ intel_teardown_mchbar(struct drm_device *dev)
 		release_resource(&dev_priv->mch_res);
 }
 
-/* true = enable decode, false = disable decoder */
-static unsigned int i915_vga_set_decode(void *cookie, bool state)
-{
-	struct drm_device *dev = cookie;
-
-	intel_modeset_vga_set_state(dev, state);
-	if (state)
-		return VGA_RSRC_LEGACY_IO | VGA_RSRC_LEGACY_MEM |
-		       VGA_RSRC_NORMAL_IO | VGA_RSRC_NORMAL_MEM;
-	else
-		return VGA_RSRC_NORMAL_IO | VGA_RSRC_NORMAL_MEM;
-}
-
 static void i915_switcheroo_set_state(struct pci_dev *pdev, enum vga_switcheroo_state state)
 {
 	struct drm_device *dev = pci_get_drvdata(pdev);
@@ -1283,25 +1270,11 @@ static int i915_load_modeset_init(struct drm_device *dev)
 	if (ret)
 		DRM_INFO("failed to find VBIOS tables\n");
 
-	/* If we have > 1 VGA cards, then we need to arbitrate access
-	 * to the common VGA resources.
-	 *
-	 * If we are a secondary display controller (!PCI_DISPLAY_CLASS_VGA),
-	 * then we do not take part in VGA arbitration and the
-	 * vga_client_register() fails with -ENODEV.
-	 */
-	if (!HAS_PCH_SPLIT(dev)) {
-		ret = vga_client_register(dev->pdev, dev, NULL,
-					  i915_vga_set_decode);
-		if (ret && ret != -ENODEV)
-			goto out;
-	}
-
 	intel_register_dsm_handler();
 
 	ret = vga_switcheroo_register_client(dev->pdev, &i915_switcheroo_ops, false);
 	if (ret)
-		goto cleanup_vga_client;
+		goto out;
 
 	/* Initialise stolen first so that we may reserve preallocated
 	 * objects for the BIOS to KMS transition.
@@ -1352,10 +1325,13 @@ static int i915_load_modeset_init(struct drm_device *dev)
 	intel_fbdev_initial_config(dev);
 
 	/*
+	 * Disable VGA IO and memory, and
+	 * tell the arbiter to ignore us.
+	 *
 	 * Must do this after fbcon init so that
 	 * vgacon_save_screen() works during the handover.
 	 */
-	i915_disable_vga_mem(dev);
+	intel_modeset_vga_set_state(dev, false);
 
 	/* Only enable hotplug handling once the fbdev is fully set up. */
 	dev_priv->enable_hotplug_processing = true;
@@ -1377,8 +1353,6 @@ cleanup_gem_stolen:
 	i915_gem_cleanup_stolen(dev);
 cleanup_vga_switcheroo:
 	vga_switcheroo_unregister_client(dev->pdev);
-cleanup_vga_client:
-	vga_client_register(dev->pdev, NULL, NULL, NULL);
 out:
 	return ret;
 }
@@ -1749,7 +1723,6 @@ int i915_driver_unload(struct drm_device *dev)
 		}
 
 		vga_switcheroo_unregister_client(dev->pdev);
-		vga_client_register(dev->pdev, NULL, NULL, NULL);
 	}
 
 	/* Free error state after interrupts are fully disabled. */
diff --git a/drivers/gpu/drm/i915/i915_suspend.c b/drivers/gpu/drm/i915/i915_suspend.c
index 70db618..c5e8958 100644
--- a/drivers/gpu/drm/i915/i915_suspend.c
+++ b/drivers/gpu/drm/i915/i915_suspend.c
@@ -331,8 +331,10 @@ static void i915_restore_display(struct drm_device *dev)
 
 	if (!drm_core_check_feature(dev, DRIVER_MODESET))
 		i915_restore_vga(dev);
-	else
+	else {
 		i915_redisable_vga(dev);
+		intel_modeset_vga_set_state(dev, false);
+	}
 }
 
 int i915_save_state(struct drm_device *dev)
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index b0f1837..0fac88a 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -40,6 +40,7 @@
 #include <drm/drm_dp_helper.h>
 #include <drm/drm_crtc_helper.h>
 #include <linux/dma_remapping.h>
+#include <linux/stop_machine.h>
 
 bool intel_pipe_has_type(struct drm_crtc *crtc, int type);
 static void intel_increase_pllclock(struct drm_crtc *crtc);
@@ -10162,51 +10163,195 @@ static void intel_init_quirks(struct drm_device *dev)
 	}
 }
 
+enum vga_op {
+	VGA_OP_MEM_DISABLE,
+	VGA_OP_MEM_ENABLE,
+	VGA_OP_SCREEN_OFF,
+};
+
+struct i915_vga_op {
+	enum vga_op op;
+	struct drm_device *dev;
+};
+
+/* FIXME how many devices/bridges can be on the same bus? */
+/* We don't need locking for these due to stop_machine() */
+static u16 vga_cmd[64];
+static u16 vga_ctl[64];
+
+/*
+ * Disable IO decode and VGA bridge forwarding
+ * for everyone else on the same bus.
+ */
+static void i915_vga_bus_disable(struct drm_device *dev)
+{
+	struct pci_dev *pdev, *self = dev->pdev;
+	struct pci_bus *bus;
+	int i;
+
+	i = 0;
+	list_for_each_entry(bus, &self->bus->children, node) {
+		pci_read_config_word(bus->self, PCI_BRIDGE_CONTROL, &vga_ctl[i]);
+		pci_write_config_word(bus->self, PCI_BRIDGE_CONTROL, vga_ctl[i] & ~PCI_BRIDGE_CTL_VGA);
+
+		if (WARN_ON(++i >= ARRAY_SIZE(vga_ctl)))
+			break;
+	}
+
+	i = 0;
+	list_for_each_entry(pdev, &self->bus->devices, bus_list) {
+		if (pdev == self)
+			continue;
+
+		pci_read_config_word(pdev, PCI_COMMAND, &vga_cmd[i]);
+		pci_write_config_word(pdev, PCI_COMMAND, vga_cmd[i] & ~PCI_COMMAND_IO);
+
+		if (WARN_ON(++i >= ARRAY_SIZE(vga_cmd)))
+			break;
+	}
+}
+
+/*
+ * Restore IO decode and VGA bridge forwarding
+ * for everyone else on the same bus.
+ */
+static void i915_vga_bus_restore(struct drm_device *dev)
+{
+	struct pci_dev *pdev, *self = dev->pdev;
+	struct pci_bus *bus;
+	int i;
+
+	i = 0;
+	list_for_each_entry(pdev, &self->bus->devices, bus_list) {
+		if (pdev == self)
+			continue;
+
+		pci_write_config_word(pdev, PCI_COMMAND, vga_cmd[i]);
+
+		if (WARN_ON(++i >= ARRAY_SIZE(vga_cmd)))
+			break;
+	}
+
+	i = 0;
+	list_for_each_entry(bus, &self->bus->children, node) {
+		pci_write_config_word(bus->self, PCI_BRIDGE_CONTROL, vga_ctl[i]);
+
+		if (WARN_ON(++i >= ARRAY_SIZE(vga_ctl)))
+			break;
+	}
+}
+
+/*
+ * Hide our VGA IO access from the rest of the system
+ * using stop_machine().
+ *
+ * Note that we assume that the IGD is on the root bus.
+ */
+static int i915_vga_stop_machine_cb(void *data)
+{
+	struct i915_vga_op *op = data;
+	struct drm_device *dev = op->dev;
+	u16 cmd;
+	u8 tmp;
+
+	i915_vga_bus_disable(dev);
+
+	pci_read_config_word(dev->pdev, PCI_COMMAND, &cmd);
+	pci_write_config_word(dev->pdev, PCI_COMMAND, cmd | PCI_COMMAND_IO);
+
+	switch (op->op) {
+	case VGA_OP_MEM_DISABLE:
+		tmp = inb(VGA_MSR_READ);
+		tmp &= ~VGA_MSR_MEM_EN;
+		outb(tmp, VGA_MSR_WRITE);
+		break;
+	case VGA_OP_MEM_ENABLE:
+		tmp = inb(VGA_MSR_READ);
+		tmp |= VGA_MSR_MEM_EN;
+		outb(tmp, VGA_MSR_WRITE);
+		break;
+	case VGA_OP_SCREEN_OFF:
+		outb(SR01, VGA_SR_INDEX);
+		tmp = inb(VGA_SR_DATA);
+		tmp |= 1 << 5;
+		outb(tmp, VGA_SR_DATA);
+		break;
+	}
+
+	pci_write_config_word(dev->pdev, PCI_COMMAND, cmd);
+
+	i915_vga_bus_restore(dev);
+
+	return 0;
+}
+
+/* MMIO based VGA register access, pre-Gen5 only */
+static void i915_vga_execute_mmio(struct drm_device *dev, enum vga_op op)
+{
+	struct drm_i915_private *dev_priv = dev->dev_private;
+	u8 tmp;
+
+	switch (op) {
+	case VGA_OP_MEM_DISABLE:
+		tmp = I915_READ8(VGA_MSR_READ);
+		tmp &= ~VGA_MSR_MEM_EN;
+		I915_WRITE8(VGA_MSR_WRITE, tmp);
+		break;
+	case VGA_OP_MEM_ENABLE:
+		tmp = I915_READ8(VGA_MSR_READ);
+		tmp |= VGA_MSR_MEM_EN;
+		I915_WRITE8(VGA_MSR_WRITE, tmp);
+		break;
+	case VGA_OP_SCREEN_OFF:
+		I915_WRITE8(VGA_SR_INDEX, SR01);
+		tmp = I915_READ8(VGA_SR_DATA);
+		tmp |= 1 << 5;
+		I915_WRITE8(VGA_SR_DATA, tmp);
+		break;
+	}
+}
+
+static void i915_vga_execute(struct drm_device *dev, enum vga_op op)
+{
+	/*
+	 * FIXME which way w/ CTG/ELK?
+	 * Workaround database is conflicted on the subject.
+	 */
+	if (INTEL_INFO(dev)->gen >= 5) {
+		struct i915_vga_op vga_op = {
+			.op = op,
+			.dev = dev,
+		};
+
+		stop_machine(i915_vga_stop_machine_cb, &vga_op, NULL);
+	} else {
+		i915_vga_execute_mmio(dev, op);
+	}
+}
+
 /* Disable the VGA plane that we never use */
 static void i915_disable_vga(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
-	u8 sr1;
 	u32 vga_reg = i915_vgacntrl_reg(dev);
+	u16 gmch_ctrl;
+
+	/* already disabled? */
+	if (I915_READ(vga_reg) & VGA_DISP_DISABLE)
+		return;
+
+	pci_read_config_word(dev_priv->bridge_dev, INTEL_GMCH_CTRL, &gmch_ctrl);
+	if (gmch_ctrl & INTEL_GMCH_VGA_DISABLE)
+		DRM_ERROR("VGA plane enabled while VGA disabled via GMCH control\n");
+
+	i915_vga_execute(dev, VGA_OP_SCREEN_OFF);
 
-	vga_get_uninterruptible(dev->pdev, VGA_RSRC_LEGACY_IO);
-	outb(SR01, VGA_SR_INDEX);
-	sr1 = inb(VGA_SR_DATA);
-	outb(sr1 | 1<<5, VGA_SR_DATA);
-	vga_put(dev->pdev, VGA_RSRC_LEGACY_IO);
 	udelay(300);
 
 	I915_WRITE(vga_reg, VGA_DISP_DISABLE);
 	POSTING_READ(vga_reg);
 }
 
-static void i915_enable_vga_mem(struct drm_device *dev)
-{
-	/* Enable VGA memory on Intel HD */
-	if (HAS_PCH_SPLIT(dev)) {
-		vga_get_uninterruptible(dev->pdev, VGA_RSRC_LEGACY_IO);
-		outb(inb(VGA_MSR_READ) | VGA_MSR_MEM_EN, VGA_MSR_WRITE);
-		vga_set_legacy_decoding(dev->pdev, VGA_RSRC_LEGACY_IO |
-						   VGA_RSRC_LEGACY_MEM |
-						   VGA_RSRC_NORMAL_IO |
-						   VGA_RSRC_NORMAL_MEM);
-		vga_put(dev->pdev, VGA_RSRC_LEGACY_IO);
-	}
-}
-
-void i915_disable_vga_mem(struct drm_device *dev)
-{
-	/* Disable VGA memory on Intel HD */
-	if (HAS_PCH_SPLIT(dev)) {
-		vga_get_uninterruptible(dev->pdev, VGA_RSRC_LEGACY_IO);
-		outb(inb(VGA_MSR_READ) & ~VGA_MSR_MEM_EN, VGA_MSR_WRITE);
-		vga_set_legacy_decoding(dev->pdev, VGA_RSRC_LEGACY_IO |
-						   VGA_RSRC_NORMAL_IO |
-						   VGA_RSRC_NORMAL_MEM);
-		vga_put(dev->pdev, VGA_RSRC_LEGACY_IO);
-	}
-}
-
 void intel_modeset_init_hw(struct drm_device *dev)
 {
 	intel_init_power_well(dev);
@@ -10485,7 +10630,6 @@ void i915_redisable_vga(struct drm_device *dev)
 	if (I915_READ(vga_reg) != VGA_DISP_DISABLE) {
 		DRM_DEBUG_KMS("Something enabled VGA plane, disabling it\n");
 		i915_disable_vga(dev);
-		i915_disable_vga_mem(dev);
 	}
 }
 
@@ -10690,7 +10834,7 @@ void intel_modeset_cleanup(struct drm_device *dev)
 
 	intel_disable_fbc(dev);
 
-	i915_enable_vga_mem(dev);
+	intel_modeset_vga_set_state(dev, true);
 
 	intel_disable_gt_powersave(dev);
 
@@ -10733,12 +10877,35 @@ int intel_modeset_vga_set_state(struct drm_device *dev, bool state)
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	u16 gmch_ctrl;
 
+	/* Is VGA totally disabled for the IGD? */
 	pci_read_config_word(dev_priv->bridge_dev, INTEL_GMCH_CTRL, &gmch_ctrl);
-	if (state)
-		gmch_ctrl &= ~INTEL_GMCH_VGA_DISABLE;
-	else
-		gmch_ctrl |= INTEL_GMCH_VGA_DISABLE;
-	pci_write_config_word(dev_priv->bridge_dev, INTEL_GMCH_CTRL, gmch_ctrl);
+	if (gmch_ctrl & INTEL_GMCH_VGA_DISABLE)
+		return 0;
+
+	if (state) {
+		i915_vga_execute(dev, VGA_OP_MEM_ENABLE);
+
+		/*
+		 * Leave PCI_COMMAND_IO alone for now. vgaarb
+		 * should re-enable it if and when needed.
+		 */
+
+		vga_set_legacy_decoding(dev->pdev, VGA_RSRC_LEGACY_IO |
+						   VGA_RSRC_LEGACY_MEM |
+						   VGA_RSRC_NORMAL_IO |
+						   VGA_RSRC_NORMAL_MEM);
+	} else {
+		u16 cmd;
+
+		i915_vga_execute(dev, VGA_OP_MEM_DISABLE);
+
+		pci_read_config_word(dev->pdev, PCI_COMMAND, &cmd);
+		cmd &= ~PCI_COMMAND_IO;
+		pci_write_config_word(dev->pdev, PCI_COMMAND, cmd);
+
+		vga_set_legacy_decoding(dev->pdev, VGA_RSRC_NORMAL_MEM);
+	}
+
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/i915/intel_drv.h b/drivers/gpu/drm/i915/intel_drv.h
index 338222c..ce8bd8b 100644
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -802,7 +802,6 @@ extern void hsw_pc8_disable_interrupts(struct drm_device *dev);
 extern void hsw_pc8_restore_interrupts(struct drm_device *dev);
 extern void intel_aux_display_runtime_get(struct drm_i915_private *dev_priv);
 extern void intel_aux_display_runtime_put(struct drm_i915_private *dev_priv);
-extern void i915_disable_vga_mem(struct drm_device *dev);
 extern void intel_dp_get_m_n(struct intel_crtc *crtc,
 			     struct intel_crtc_config *pipe_config);
 extern int intel_dotclock_calculate(int link_freq,
-- 
1.8.1.5

