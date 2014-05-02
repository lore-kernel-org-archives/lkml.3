Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178AbaEBPyM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:54:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44266 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933AbaEBPpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:45:46 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Imre Deak <imre.deak@intel.com>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 131/151] drm/i915: move power domain init earlier during system resume
Date: Fri,  2 May 2014 08:38:39 -0700
Message-Id: <1399045139-4531-132-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Deak <imre.deak@intel.com>

commit 76c4b250080fff6e4befaa3619942422fd0ea380 upstream.

During resume the intel hda audio driver depends on the i915 driver
reinitializing the audio power domain. Since the order of calling the
i915 resume handler wrt. that of the audio driver is not guaranteed,
move the power domain reinitialization step to the resume_early
handler. This is guaranteed to run before the resume handler of any
other driver.

The power domain initialization in turn requires us to enable the i915
pci device first, so move that part earlier too.

Accordingly disabling of the i915 pci device should happen after the
audio suspend handler ran. So move the disabling later from the i915
resume handler to the resume_late handler.

v2:
- move intel_uncore_sanitize/early_sanitize earlier too, so they don't
  get reordered wrt. intel_power_domains_init_hw()

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=76152
Signed-off-by: Imre Deak <imre.deak@intel.com>
Reviewed-by: Takashi Iwai <tiwai@suse.de>
[danvet: Add cc: stable and loud comments that this is just a hack.]
[danvet: Fix "Should it be static?" sparse warning reported by Wu
Fengguang's kbuilder.]
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[ kamal: backport to 3.13: intel_power_domains_init_hw(dev) not (dev_priv) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/i915_drv.c | 90 ++++++++++++++++++++++++++++++++++-------
 1 file changed, 75 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
index 197bb83..e09a314 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -610,15 +610,20 @@ static void intel_resume_hotplug(struct drm_device *dev)
 	drm_helper_hpd_irq_event(dev);
 }
 
+static int i915_drm_thaw_early(struct drm_device *dev)
+{
+	intel_uncore_early_sanitize(dev);
+	intel_uncore_sanitize(dev);
+	intel_power_domains_init_hw(dev);
+
+	return 0;
+}
+
 static int __i915_drm_thaw(struct drm_device *dev, bool restore_gtt_mappings)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	int error = 0;
 
-	intel_uncore_early_sanitize(dev);
-
-	intel_uncore_sanitize(dev);
-
 	if (drm_core_check_feature(dev, DRIVER_MODESET) &&
 	    restore_gtt_mappings) {
 		mutex_lock(&dev->struct_mutex);
@@ -626,8 +631,6 @@ static int __i915_drm_thaw(struct drm_device *dev, bool restore_gtt_mappings)
 		mutex_unlock(&dev->struct_mutex);
 	}
 
-	intel_power_domains_init_hw(dev);
-
 	i915_restore_state(dev);
 	intel_opregion_setup(dev);
 
@@ -694,19 +697,33 @@ static int i915_drm_thaw(struct drm_device *dev)
 	return __i915_drm_thaw(dev, true);
 }
 
-int i915_resume(struct drm_device *dev)
+static int i915_resume_early(struct drm_device *dev)
 {
-	struct drm_i915_private *dev_priv = dev->dev_private;
-	int ret;
-
 	if (dev->switch_power_state == DRM_SWITCH_POWER_OFF)
 		return 0;
 
+	/*
+	 * We have a resume ordering issue with the snd-hda driver also
+	 * requiring our device to be power up. Due to the lack of a
+	 * parent/child relationship we currently solve this with an early
+	 * resume hook.
+	 *
+	 * FIXME: This should be solved with a special hdmi sink device or
+	 * similar so that power domains can be employed.
+	 */
 	if (pci_enable_device(dev->pdev))
 		return -EIO;
 
 	pci_set_master(dev->pdev);
 
+	return i915_drm_thaw_early(dev);
+}
+
+int i915_resume(struct drm_device *dev)
+{
+	struct drm_i915_private *dev_priv = dev->dev_private;
+	int ret;
+
 	/*
 	 * Platforms with opregion should have sane BIOS, older ones (gen3 and
 	 * earlier) need to restore the GTT mappings since the BIOS might clear
@@ -720,6 +737,14 @@ int i915_resume(struct drm_device *dev)
 	return 0;
 }
 
+static int i915_resume_legacy(struct drm_device *dev)
+{
+	i915_resume_early(dev);
+	i915_resume(dev);
+
+	return 0;
+}
+
 /**
  * i915_reset - reset chip after a hang
  * @dev: drm device to reset
@@ -853,7 +878,6 @@ static int i915_pm_suspend(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct drm_device *drm_dev = pci_get_drvdata(pdev);
-	int error;
 
 	if (!drm_dev || !drm_dev->dev_private) {
 		dev_err(dev, "DRM not initialized, aborting suspend.\n");
@@ -863,9 +887,25 @@ static int i915_pm_suspend(struct device *dev)
 	if (drm_dev->switch_power_state == DRM_SWITCH_POWER_OFF)
 		return 0;
 
-	error = i915_drm_freeze(drm_dev);
-	if (error)
-		return error;
+	return i915_drm_freeze(drm_dev);
+}
+
+static int i915_pm_suspend_late(struct device *dev)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct drm_device *drm_dev = pci_get_drvdata(pdev);
+
+	/*
+	 * We have a suspedn ordering issue with the snd-hda driver also
+	 * requiring our device to be power up. Due to the lack of a
+	 * parent/child relationship we currently solve this with an late
+	 * suspend hook.
+	 *
+	 * FIXME: This should be solved with a special hdmi sink device or
+	 * similar so that power domains can be employed.
+	 */
+	if (drm_dev->switch_power_state == DRM_SWITCH_POWER_OFF)
+		return 0;
 
 	pci_disable_device(pdev);
 	pci_set_power_state(pdev, PCI_D3hot);
@@ -873,6 +913,14 @@ static int i915_pm_suspend(struct device *dev)
 	return 0;
 }
 
+static int i915_pm_resume_early(struct device *dev)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct drm_device *drm_dev = pci_get_drvdata(pdev);
+
+	return i915_resume_early(drm_dev);
+}
+
 static int i915_pm_resume(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
@@ -894,6 +942,14 @@ static int i915_pm_freeze(struct device *dev)
 	return i915_drm_freeze(drm_dev);
 }
 
+static int i915_pm_thaw_early(struct device *dev)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct drm_device *drm_dev = pci_get_drvdata(pdev);
+
+	return i915_drm_thaw_early(drm_dev);
+}
+
 static int i915_pm_thaw(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
@@ -912,10 +968,14 @@ static int i915_pm_poweroff(struct device *dev)
 
 static const struct dev_pm_ops i915_pm_ops = {
 	.suspend = i915_pm_suspend,
+	.suspend_late = i915_pm_suspend_late,
+	.resume_early = i915_pm_resume_early,
 	.resume = i915_pm_resume,
 	.freeze = i915_pm_freeze,
+	.thaw_early = i915_pm_thaw_early,
 	.thaw = i915_pm_thaw,
 	.poweroff = i915_pm_poweroff,
+	.restore_early = i915_pm_resume_early,
 	.restore = i915_pm_resume,
 };
 
@@ -956,7 +1016,7 @@ static struct drm_driver driver = {
 
 	/* Used in place of i915_pm_ops for non-DRIVER_MODESET */
 	.suspend = i915_suspend,
-	.resume = i915_resume,
+	.resume = i915_resume_legacy,
 
 	.device_is_agp = i915_driver_device_is_agp,
 	.master_create = i915_master_create,
-- 
1.9.1

