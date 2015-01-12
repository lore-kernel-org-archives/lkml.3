Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947AbbALS34 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:29:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58007 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754913AbbALS3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:29:51 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Jani Nikula <jani.nikula@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 124/216] drm/i915: save/restore GMBUS freq across suspend/resume on gen4
Date: Mon, 12 Jan 2015 18:28:22 +0000
Message-Id: <1421087394-2712-12-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/i915/i915_drv.h     | 1 +
 drivers/gpu/drm/i915/i915_reg.h     | 1 +
 drivers/gpu/drm/i915/i915_suspend.c | 8 ++++++++
 3 files changed, 10 insertions(+)

diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 374f964323ad..bc47ba421fc8 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -817,6 +817,7 @@ struct i915_suspend_saved_registers {
 	u32 savePIPEB_LINK_N1;
 	u32 saveMCHBAR_RENDER_STANDBY;
 	u32 savePCH_PORT_HOTPLUG;
+	u16 saveGCDGMBUS;
 };
 
 struct vlv_s0ix_state {
diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index a5bab61bfc00..6b9626567cfa 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -74,6 +74,7 @@
 #define   I915_GC_RENDER_CLOCK_166_MHZ	(0 << 0)
 #define   I915_GC_RENDER_CLOCK_200_MHZ	(1 << 0)
 #define   I915_GC_RENDER_CLOCK_333_MHZ	(4 << 0)
+#define GCDGMBUS 0xcc
 #define PCI_LBPC 0xf4 /* legacy/combination backlight modes, also called LBB */
 
 
diff --git a/drivers/gpu/drm/i915/i915_suspend.c b/drivers/gpu/drm/i915/i915_suspend.c
index 043123c77a1f..e22b0e825de2 100644
--- a/drivers/gpu/drm/i915/i915_suspend.c
+++ b/drivers/gpu/drm/i915/i915_suspend.c
@@ -328,6 +328,10 @@ int i915_save_state(struct drm_device *dev)
 		}
 	}
 
+	if (IS_GEN4(dev))
+		pci_read_config_word(dev->pdev, GCDGMBUS,
+				     &dev_priv->regfile.saveGCDGMBUS);
+
 	/* Cache mode state */
 	if (INTEL_INFO(dev)->gen < 7)
 		dev_priv->regfile.saveCACHE_MODE_0 = I915_READ(CACHE_MODE_0);
@@ -356,6 +360,10 @@ int i915_restore_state(struct drm_device *dev)
 	mutex_lock(&dev->struct_mutex);
 
 	i915_gem_restore_fences(dev);
+
+	if (IS_GEN4(dev))
+		pci_write_config_word(dev->pdev, GCDGMBUS,
+				      dev_priv->regfile.saveGCDGMBUS);
 	i915_restore_display(dev);
 
 	if (!drm_core_check_feature(dev, DRIVER_MODESET)) {
-- 
2.1.4

