Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133Ab3AMRxr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 12:53:47 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34972 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754593Ab3AMRp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 12:45:27 -0500
Message-Id: <20130113174256.260437966@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 13 Jan 2013 17:42:57 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Krzysztof Mazur <krzysiek@podlesie.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 02/49] i915: ensure that VGA plane is disabled
In-Reply-To: <20130113174255.736888844@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
---
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -8898,6 +8898,23 @@ static void i915_disable_vga(struct drm_
 	POSTING_READ(vga_reg);
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
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -1305,6 +1305,7 @@ static inline void intel_unregister_dsm_
 #endif /* CONFIG_ACPI */
 
 /* modesetting */
+extern void i915_redisable_vga(struct drm_device *dev);
 extern void intel_modeset_init(struct drm_device *dev);
 extern void intel_modeset_gem_init(struct drm_device *dev);
 extern void intel_modeset_cleanup(struct drm_device *dev);
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -535,6 +535,7 @@ static int intel_lid_notify(struct notif
 
 	mutex_lock(&dev->mode_config.mutex);
 	drm_helper_resume_force_mode(dev);
+	i915_redisable_vga(dev);
 	mutex_unlock(&dev->mode_config.mutex);
 
 	return NOTIFY_OK;


