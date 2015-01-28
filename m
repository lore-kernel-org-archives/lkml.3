Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760695AbbA2Css (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:48:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47042 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762291AbbA2Ci1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:38:27 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Jani Nikula <jani.nikula@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 108/139] drm/i915: save/restore GMBUS freq across suspend/resume on gen4
Date: Wed, 28 Jan 2015 14:20:51 -0800
Message-Id: <1422483682-15393-109-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Barnes <jbarnes@virtuousgeek.org>

commit 9f49c37635d5c2a801f7670d5fbf0b25ec461f2c upstream.

Should probably just init this in the GMbus code all the time, based on
the cdclk and HPLL like we do on newer platforms.  Ville has code for
that in a rework branch, but until then we can fix this bug fairly
easily.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=76301
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Tested-by: Nikolay <mar.kolya@gmail.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/i915_drv.h     | 1 +
 drivers/gpu/drm/i915/i915_reg.h     | 1 +
 drivers/gpu/drm/i915/i915_suspend.c | 8 ++++++++
 3 files changed, 10 insertions(+)

diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 221ac62..73d7bd7 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -876,6 +876,7 @@ struct i915_suspend_saved_registers {
 	u32 savePIPEB_LINK_N1;
 	u32 saveMCHBAR_RENDER_STANDBY;
 	u32 savePCH_PORT_HOTPLUG;
+	u16 saveGCDGMBUS;
 };
 
 struct intel_gen6_power_mgmt {
diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 6d637e7..8d30b80 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -74,6 +74,7 @@
 #define   I915_GC_RENDER_CLOCK_200_MHZ	(1 << 0)
 #define   I915_GC_RENDER_CLOCK_333_MHZ	(4 << 0)
 #define LBB	0xf4
+#define GCDGMBUS 0xcc
 
 /* Graphics reset regs */
 #define I965_GDRST 0xc0 /* PCI config register */
diff --git a/drivers/gpu/drm/i915/i915_suspend.c b/drivers/gpu/drm/i915/i915_suspend.c
index 98790c7..0653f26 100644
--- a/drivers/gpu/drm/i915/i915_suspend.c
+++ b/drivers/gpu/drm/i915/i915_suspend.c
@@ -397,6 +397,10 @@ int i915_save_state(struct drm_device *dev)
 
 	intel_disable_gt_powersave(dev);
 
+	if (IS_GEN4(dev))
+		pci_read_config_word(dev->pdev, GCDGMBUS,
+				     &dev_priv->regfile.saveGCDGMBUS);
+
 	/* Cache mode state */
 	if (INTEL_INFO(dev)->gen < 7)
 		dev_priv->regfile.saveCACHE_MODE_0 = I915_READ(CACHE_MODE_0);
@@ -429,6 +433,10 @@ int i915_restore_state(struct drm_device *dev)
 	mutex_lock(&dev->struct_mutex);
 
 	i915_gem_restore_fences(dev);
+
+	if (IS_GEN4(dev))
+		pci_write_config_word(dev->pdev, GCDGMBUS,
+				      dev_priv->regfile.saveGCDGMBUS);
 	i915_restore_display(dev);
 
 	if (!drm_core_check_feature(dev, DRIVER_MODESET)) {
-- 
1.9.1

