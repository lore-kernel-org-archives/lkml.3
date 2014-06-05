Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552AbaFEEWO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:22:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44434 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435AbaFEEWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:22:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jani Nikula <jani.nikula@intel.com>,
        Peter Verthez <peter.verthez@skynet.be>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Ben Hutchings <ben@decadent.org.uk>,
        Weng Meiling <wengmeiling.weng@huawei.com>
Subject: [PATCH 3.4 180/214] drm/i915: ensure single initialization and cleanup of backlight device
Date: Wed,  4 Jun 2014 21:19:03 -0700
Message-Id: <20140605041703.670097769@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Weng Meiling <wengmeiling.weng@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_display.c |    3 +++
 drivers/gpu/drm/i915/intel_dp.c      |    5 -----
 drivers/gpu/drm/i915/intel_lvds.c    |    2 --
 drivers/gpu/drm/i915/intel_panel.c   |    7 ++++++-
 4 files changed, 9 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -9471,6 +9471,9 @@ void intel_modeset_cleanup(struct drm_de
 	del_timer_sync(&dev_priv->idle_timer);
 	cancel_work_sync(&dev_priv->idle_work);
 
+	/* destroy backlight, if any, before the connectors */
+	intel_panel_destroy_backlight(dev);
+
 	drm_mode_config_cleanup(dev);
 }
 
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -2289,11 +2289,6 @@ done:
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
@@ -359,6 +359,9 @@ int intel_panel_setup_backlight(struct d
 
 	intel_panel_init_backlight(dev);
 
+	if (WARN_ON(dev_priv->backlight))
+		return -ENODEV;
+
 	if (dev_priv->int_lvds_connector)
 		connector = dev_priv->int_lvds_connector;
 	else if (dev_priv->int_edp_connector)
@@ -386,8 +389,10 @@ int intel_panel_setup_backlight(struct d
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


