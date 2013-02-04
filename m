Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414Ab3BDNhn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 08:37:43 -0500
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:56105 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752350Ab3BDNhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 08:37:39 -0500
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: linux-kernel@vger.kernel.org
Cc: intel-gfx@lists.freedesktop.org, linux-pm@vger.kernel.org, rjw@sisk.pl
Subject: [PATCH 3/3] drm/i915: support resume without VT switch v2
Date: Mon,  4 Feb 2013 13:37:22 +0000
Message-Id: <1359985042-2610-3-git-send-email-jbarnes@virtuousgeek.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359985042-2610-1-git-send-email-jbarnes@virtuousgeek.org>
References: <1359985042-2610-1-git-send-email-jbarnes@virtuousgeek.org>
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 83.217.123.106 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for resuming the suspend configuration at resume time to
avoid slow and ugly VT switches during suspend and resume.  Also emit a
hotplug event at resume time to make sure any potential configuration
changes (monitors coming and going, dock events) are handled properly.

v2: use new fb flag to indicate we don't need to VT switch

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 drivers/gpu/drm/i915/i915_drv.c      |   28 +++++++++++++++++++++++++---
 drivers/gpu/drm/i915/i915_drv.h      |    1 +
 drivers/gpu/drm/i915/intel_display.c |   25 +++++++++++++++++++++++++
 drivers/gpu/drm/i915/intel_fb.c      |    3 +++
 4 files changed, 54 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
index 1172658..7dbaa01 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -483,8 +483,6 @@ static int i915_drm_freeze(struct drm_device *dev)
 
 		cancel_delayed_work_sync(&dev_priv->rps.delayed_resume_work);
 
-		intel_modeset_disable(dev);
-
 		drm_irq_uninstall(dev);
 	}
 
@@ -544,6 +542,24 @@ void intel_console_resume(struct work_struct *work)
 	console_unlock();
 }
 
+static void intel_resume_hotplug(struct drm_device *dev)
+{
+	struct drm_mode_config *mode_config = &dev->mode_config;
+	struct intel_encoder *encoder;
+
+	mutex_lock(&mode_config->mutex);
+	DRM_DEBUG_KMS("running encoder hotplug functions\n");
+
+	list_for_each_entry(encoder, &mode_config->encoder_list, base.head)
+		if (encoder->hot_plug)
+			encoder->hot_plug(encoder);
+
+	mutex_unlock(&mode_config->mutex);
+
+	/* Just fire off a uevent and let userspace tell us what to do */
+	drm_helper_hpd_irq_event(dev);
+}
+
 static int __i915_drm_thaw(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
@@ -563,8 +579,14 @@ static int __i915_drm_thaw(struct drm_device *dev)
 		mutex_unlock(&dev->struct_mutex);
 
 		intel_modeset_init_hw(dev);
-		intel_modeset_setup_hw_state(dev, false);
 		drm_irq_install(dev);
+
+		/* Resume the modeset for every activated CRTC */
+		mutex_lock(&dev->mode_config.mutex);
+		intel_resume_force_mode(dev);
+		mutex_unlock(&dev->mode_config.mutex);
+
+		intel_resume_hotplug(dev);
 	}
 
 	intel_opregion_init(dev);
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 12ab3bd..c8b1896 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -1680,6 +1680,7 @@ extern void gen6_set_rps(struct drm_device *dev, u8 val);
 extern void intel_detect_pch(struct drm_device *dev);
 extern int intel_trans_dp_port_sel(struct drm_crtc *crtc);
 extern int intel_enable_rc6(const struct drm_device *dev);
+extern int intel_resume_force_mode(struct drm_device *dev);
 
 extern bool i915_semaphore_is_enabled(struct drm_device *dev);
 int i915_reg_read_ioctl(struct drm_device *dev, void *data,
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index da1ad9c..a127877 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -9369,6 +9369,31 @@ void intel_modeset_cleanup(struct drm_device *dev)
 	drm_mode_config_cleanup(dev);
 }
 
+int intel_resume_force_mode(struct drm_device *dev)
+{
+	struct drm_crtc *crtc;
+	struct drm_encoder *encoder;
+	struct drm_encoder_helper_funcs *encoder_funcs;
+	struct drm_crtc_helper_funcs *crtc_funcs;
+	int ret;
+
+	list_for_each_entry(crtc, &dev->mode_config.crtc_list, head) {
+
+		if (!crtc->enabled) {
+			DRM_ERROR("skipping disabled crtc\n");
+			continue;
+		}
+
+		ret = intel_set_mode(crtc, &crtc->mode, crtc->x, crtc->y,
+				     crtc->fb);
+
+		if (ret == false)
+			DRM_ERROR("failed to set mode on crtc %p\n", crtc);
+	}
+
+	return 0;
+}
+
 /*
  * Return which encoder is currently attached for connector.
  */
diff --git a/drivers/gpu/drm/i915/intel_fb.c b/drivers/gpu/drm/i915/intel_fb.c
index 7b30b5c..d4955b5 100644
--- a/drivers/gpu/drm/i915/intel_fb.c
+++ b/drivers/gpu/drm/i915/intel_fb.c
@@ -148,6 +148,9 @@ static int intelfb_create(struct intel_fbdev *ifbdev,
 	}
 	info->screen_size = size;
 
+	/* This driver doesn't need a VT switch to restore the mode on resume */
+	info->skip_vt_switch = true;
+
 //	memset(info->screen_base, 0, size);
 
 	drm_fb_helper_fill_fix(info, fb->pitches[0], fb->depth);
-- 
1.7.9.5

