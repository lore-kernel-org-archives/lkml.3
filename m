Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933168Ab3APQLu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:11:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36974 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933120Ab3APQLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:11:46 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Krzysztof Mazur <krzysiek@podlesie.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Ben Hutchings <ben@decadent.org.uk>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 219/222] i915: ensure that VGA plane is disabled
Date: Wed, 16 Jan 2013 13:56:59 -0200
Message-Id: <1358351822-7675-220-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Mazur <krzysiek@podlesie.net>

commit 0fde901f1ddd2ce0e380a6444f1fb7ca555859e9 upstream.

Some broken systems (like HP nc6120) in some cases, usually after LID
close/open, enable VGA plane, making display unusable (black screen on LVDS,
some strange mode on VGA output). We used to disable VGA plane only once at
startup. Now we also check, if VGA plane is still disabled while changing
mode, and fix that if something changed it.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=57434
Signed-off-by: Krzysztof Mazur <krzysiek@podlesie.net>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[bwh: Backported to 3.2: intel_modeset_setup_hw_state() does not
     exist, so call i915_redisable_vga() directly from intel_lid_notify()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
[ herton: use version for 3.2 which is also valid for 3.5, only had to
  adjust context ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/i915/i915_drv.h      |    1 +
 drivers/gpu/drm/i915/intel_display.c |   17 +++++++++++++++++
 drivers/gpu/drm/i915/intel_lvds.c    |    1 +
 3 files changed, 19 insertions(+)

diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index b0b676a..a2c97bb 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -1467,6 +1467,7 @@ static inline void intel_unregister_dsm_handler(void) { return; }
 
 /* modesetting */
 extern void intel_modeset_init_hw(struct drm_device *dev);
+extern void i915_redisable_vga(struct drm_device *dev);
 extern void intel_modeset_init(struct drm_device *dev);
 extern void intel_modeset_gem_init(struct drm_device *dev);
 extern void intel_modeset_cleanup(struct drm_device *dev);
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 5cd6449..b61bc50 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -6964,6 +6964,23 @@ void intel_modeset_init_hw(struct drm_device *dev)
 	}
 }
 
+void i915_redisable_vga(struct drm_device *dev)
+{
+	struct drm_i915_private *dev_priv = dev->dev_private;
+	u32 vga_reg;
+
+	if (HAS_PCH_SPLIT(dev))
+		vga_reg = CPU_VGACNTRL;
+	else
+		vga_reg = VGACNTRL;
+
+	if (I915_READ(vga_reg) != VGA_DISP_DISABLE) {
+		DRM_DEBUG_KMS("Something enabled VGA plane, disabling it\n");
+		I915_WRITE(vga_reg, VGA_DISP_DISABLE);
+		POSTING_READ(vga_reg);
+	}
+}
+
 void intel_modeset_init(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index f85e2b1..37d7243 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -541,6 +541,7 @@ static int intel_lid_notify(struct notifier_block *nb, unsigned long val,
 
 	mutex_lock(&dev->mode_config.mutex);
 	drm_helper_resume_force_mode(dev);
+	i915_redisable_vga(dev);
 	mutex_unlock(&dev->mode_config.mutex);
 
 	return NOTIFY_OK;
-- 
1.7.9.5

