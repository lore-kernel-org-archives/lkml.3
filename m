Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932999Ab3AOWgq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:36:46 -0500
Received: from mail.kernel.org ([198.145.19.201]:44098 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932984Ab3AOWgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:36:43 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Krzysztof Mazur <krzysiek@podlesie.net>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, CAI Qian <caiqian@redhat.com>
Subject: [ 219/221] drm/i915: force restore on lid open
Date: Tue, 15 Jan 2013 10:52:26 -0800
Message-Id: <20130115185013.856740069@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 45e2b5f640b3766da3eda48f6c35f088155c06f3 upstream.

There seem to be indeed some awkwards machines around, mostly those
without OpRegion support, where the firmware changes the display hw
state behind our backs when closing the lid.

This force-restore logic has been originally introduced in

commit c1c7af60892070e4b82ad63bbfb95ae745056de0
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Thu Sep 10 15:28:03 2009 -0700

    drm/i915: force mode set at lid open time

but after the modeset-rework we've disabled it in the vain hope that
it's no longer required:

commit 3b7a89fce3e3dc96b549d6d829387b4439044d0d
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Mon Sep 17 22:27:21 2012 +0200

    drm/i915: fix OOPS in lid_notify

Alas, no.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=54677
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=57434
Tested-by: Krzysztof Mazur <krzysiek@podlesie.net>
Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: CAI Qian <caiqian@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_drv.c      |    2 +-
 drivers/gpu/drm/i915/i915_drv.h      |    3 ++-
 drivers/gpu/drm/i915/intel_display.c |   15 ++++++++++++---
 drivers/gpu/drm/i915/intel_lvds.c    |    2 +-
 4 files changed, 16 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -552,7 +552,7 @@ static int i915_drm_thaw(struct drm_devi
 		mutex_unlock(&dev->struct_mutex);
 
 		intel_modeset_init_hw(dev);
-		intel_modeset_setup_hw_state(dev);
+		intel_modeset_setup_hw_state(dev, false);
 		drm_mode_config_reset(dev);
 		drm_irq_install(dev);
 	}
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -1595,7 +1595,8 @@ extern void intel_modeset_init(struct dr
 extern void intel_modeset_gem_init(struct drm_device *dev);
 extern void intel_modeset_cleanup(struct drm_device *dev);
 extern int intel_modeset_vga_set_state(struct drm_device *dev, bool state);
-extern void intel_modeset_setup_hw_state(struct drm_device *dev);
+extern void intel_modeset_setup_hw_state(struct drm_device *dev,
+					 bool force_restore);
 extern bool intel_fbc_enabled(struct drm_device *dev);
 extern void intel_disable_fbc(struct drm_device *dev);
 extern bool ironlake_set_drps(struct drm_device *dev, u8 val);
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -8250,7 +8250,8 @@ static void intel_sanitize_encoder(struc
 
 /* Scan out the current hw modeset state, sanitizes it and maps it into the drm
  * and i915 state tracking structures. */
-void intel_modeset_setup_hw_state(struct drm_device *dev)
+void intel_modeset_setup_hw_state(struct drm_device *dev,
+				  bool force_restore)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	enum pipe pipe;
@@ -8321,7 +8322,15 @@ void intel_modeset_setup_hw_state(struct
 		intel_sanitize_crtc(crtc);
 	}
 
-	intel_modeset_update_staged_output_state(dev);
+	if (force_restore) {
+		for_each_pipe(pipe) {
+			crtc = to_intel_crtc(dev_priv->pipe_to_crtc_mapping[pipe]);
+			intel_set_mode(&crtc->base, &crtc->base.mode,
+				       crtc->base.x, crtc->base.y, crtc->base.fb);
+		}
+	} else {
+		intel_modeset_update_staged_output_state(dev);
+	}
 
 	intel_modeset_check_state(dev);
 }
@@ -8332,7 +8341,7 @@ void intel_modeset_gem_init(struct drm_d
 
 	intel_setup_overlay(dev);
 
-	intel_modeset_setup_hw_state(dev);
+	intel_modeset_setup_hw_state(dev, false);
 }
 
 void intel_modeset_cleanup(struct drm_device *dev)
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -526,7 +526,7 @@ static int intel_lid_notify(struct notif
 	dev_priv->modeset_on_lid = 0;
 
 	mutex_lock(&dev->mode_config.mutex);
-	intel_modeset_check_state(dev);
+	intel_modeset_setup_hw_state(dev, true);
 	mutex_unlock(&dev->mode_config.mutex);
 
 	return NOTIFY_OK;


