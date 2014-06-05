Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbaFEEuo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:50:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44086 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898AbaFEEVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:21:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Krzysztof Mazur <krzysiek@podlesie.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Ben Hutchings <ben@decadent.org.uk>,
        Qiang Huang <h.huangqiang@huawei.com>
Subject: [PATCH 3.4 113/214] i915: ensure that VGA plane is disabled
Date: Wed,  4 Jun 2014 21:17:56 -0700
Message-Id: <20140605041654.874735081@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Qiang Huang <h.huangqiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_drv.h      |    1 +
 drivers/gpu/drm/i915/intel_display.c |   17 +++++++++++++++++
 drivers/gpu/drm/i915/intel_lvds.c    |    1 +
 3 files changed, 19 insertions(+)

--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -1397,6 +1397,7 @@ static inline void intel_unregister_dsm_
 #endif /* CONFIG_ACPI */
 
 /* modesetting */
+extern void i915_redisable_vga(struct drm_device *dev);
 extern void intel_modeset_init(struct drm_device *dev);
 extern void intel_modeset_gem_init(struct drm_device *dev);
 extern void intel_modeset_cleanup(struct drm_device *dev);
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -9254,6 +9254,23 @@ static void i915_disable_vga(struct drm_
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
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -535,6 +535,7 @@ static int intel_lid_notify(struct notif
 
 	mutex_lock(&dev->mode_config.mutex);
 	drm_helper_resume_force_mode(dev);
+	i915_redisable_vga(dev);
 	mutex_unlock(&dev->mode_config.mutex);
 
 	return NOTIFY_OK;


