Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187Ab3EIW0k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:26:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45797 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756016Ab3EIW0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:26:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jani Nikula <jani.nikula@intel.com>,
        Peter Verthez <peter.verthez@skynet.be>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 39/73] drm/i915: ensure single initialization and cleanup of backlight device
Date: Thu,  9 May 2013 15:25:29 -0700
Message-Id: <20130509222530.428133924@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130509222526.480204972@linuxfoundation.org>
References: <20130509222526.480204972@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

commit dc652f90e088798bfa31f496ba994ddadd5d5680 upstream.

Backlight cleanup in the eDP connector destroy callback caused the
backlight device to be removed on some systems that first initialized LVDS
and then attempted to initialize eDP. Prevent multiple backlight
initializations, and ensure backlight cleanup is only done once by moving
it to modeset cleanup.

A small wrinkle is the introduced asymmetry in backlight
setup/cleanup. This could be solved by adding refcounting, but it seems
overkill considering that there should only ever be one backlight device.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=55701
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Tested-by: Peter Verthez <peter.verthez@skynet.be>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_display.c |    3 +++
 drivers/gpu/drm/i915/intel_dp.c      |    5 +----
 drivers/gpu/drm/i915/intel_lvds.c    |    1 -
 drivers/gpu/drm/i915/intel_panel.c   |    7 ++++++-
 4 files changed, 10 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -9256,6 +9256,9 @@ void intel_modeset_cleanup(struct drm_de
 	/* flush any delayed tasks or pending work */
 	flush_scheduled_work();
 
+	/* destroy backlight, if any, before the connectors */
+	intel_panel_destroy_backlight(dev);
+
 	drm_mode_config_cleanup(dev);
 
 	intel_cleanup_overlay(dev);
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -2538,17 +2538,14 @@ done:
 static void
 intel_dp_destroy(struct drm_connector *connector)
 {
-	struct drm_device *dev = connector->dev;
 	struct intel_dp *intel_dp = intel_attached_dp(connector);
 	struct intel_connector *intel_connector = to_intel_connector(connector);
 
 	if (!IS_ERR_OR_NULL(intel_connector->edid))
 		kfree(intel_connector->edid);
 
-	if (is_edp(intel_dp)) {
-		intel_panel_destroy_backlight(dev);
+	if (is_edp(intel_dp))
 		intel_panel_fini(&intel_connector->panel);
-	}
 
 	drm_sysfs_connector_remove(connector);
 	drm_connector_cleanup(connector);
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -618,7 +618,6 @@ static void intel_lvds_destroy(struct dr
 	if (!IS_ERR_OR_NULL(lvds_connector->base.edid))
 		kfree(lvds_connector->base.edid);
 
-	intel_panel_destroy_backlight(connector->dev);
 	intel_panel_fini(&lvds_connector->base.panel);
 
 	drm_sysfs_connector_remove(connector);
--- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@ -422,6 +422,9 @@ int intel_panel_setup_backlight(struct d
 
 	intel_panel_init_backlight(dev);
 
+	if (WARN_ON(dev_priv->backlight))
+		return -ENODEV;
+
 	memset(&props, 0, sizeof(props));
 	props.type = BACKLIGHT_RAW;
 	props.max_brightness = _intel_panel_get_max_backlight(dev);
@@ -447,8 +450,10 @@ int intel_panel_setup_backlight(struct d
 void intel_panel_destroy_backlight(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
-	if (dev_priv->backlight)
+	if (dev_priv->backlight) {
 		backlight_device_unregister(dev_priv->backlight);
+		dev_priv->backlight = NULL;
+	}
 }
 #else
 int intel_panel_setup_backlight(struct drm_connector *connector)


