Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912Ab3EJOV4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:21:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57253 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755601Ab3EJOVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:21:54 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Peter Verthez" <peter.verthez@skynet.be>,
        "Daniel Vetter" <daniel.vetter@ffwll.ch>,
        "Jani Nikula" <jani.nikula@intel.com>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.21785252@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [041/118] drm/i915: ensure single initialization and cleanup of
 backlight device
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2:
 - Adjust context
 - s/dev_priv->backlight\.device/dev_priv->backlight/]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -9093,6 +9093,9 @@ void intel_modeset_cleanup(struct drm_de
 	del_timer_sync(&dev_priv->idle_timer);
 	cancel_work_sync(&dev_priv->idle_work);
 
+	/* destroy backlight, if any, before the connectors */
+	intel_panel_destroy_backlight(dev);
+
 	drm_mode_config_cleanup(dev);
 }
 
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -2274,11 +2274,6 @@ done:
 static void
 intel_dp_destroy(struct drm_connector *connector)
 {
-	struct drm_device *dev = connector->dev;
-
-	if (intel_dpd_is_edp(dev))
-		intel_panel_destroy_backlight(dev);
-
 	drm_sysfs_connector_remove(connector);
 	drm_connector_cleanup(connector);
 	kfree(connector);
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -553,8 +553,6 @@ static void intel_lvds_destroy(struct dr
 	struct drm_device *dev = connector->dev;
 	struct drm_i915_private *dev_priv = dev->dev_private;
 
-	intel_panel_destroy_backlight(dev);
-
 	if (dev_priv->lid_notifier.notifier_call)
 		acpi_lid_notifier_unregister(&dev_priv->lid_notifier);
 	drm_sysfs_connector_remove(connector);
--- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@ -361,6 +361,9 @@ int intel_panel_setup_backlight(struct d
 
 	intel_panel_init_backlight(dev);
 
+	if (WARN_ON(dev_priv->backlight))
+		return -ENODEV;
+
 	if (dev_priv->int_lvds_connector)
 		connector = dev_priv->int_lvds_connector;
 	else if (dev_priv->int_edp_connector)
@@ -388,8 +391,10 @@ int intel_panel_setup_backlight(struct d
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
 int intel_panel_setup_backlight(struct drm_device *dev)

