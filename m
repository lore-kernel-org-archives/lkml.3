Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169Ab3ETLMn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 07:12:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56142 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755361Ab3ETKxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:53:03 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 050/115] drm/i915: ensure single initialization and cleanup of backlight device
Date: Mon, 20 May 2013 11:50:50 +0100
Message-Id: <1369047116-9378-51-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: Backported to 3.5 (based on bwh's backport to 3.2):
  - Adjust context
  - - s/dev_priv->backlight\.device/dev_priv->backlight/ ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/i915/intel_display.c | 3 +++
 drivers/gpu/drm/i915/intel_dp.c      | 5 -----
 drivers/gpu/drm/i915/intel_lvds.c    | 2 --
 drivers/gpu/drm/i915/intel_panel.c   | 7 ++++++-
 4 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 2ec0617..290d89d 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -7146,6 +7146,9 @@ void intel_modeset_cleanup(struct drm_device *dev)
 	del_timer_sync(&dev_priv->idle_timer);
 	cancel_work_sync(&dev_priv->idle_work);
 
+	/* destroy backlight, if any, before the connectors */
+	intel_panel_destroy_backlight(dev);
+
 	drm_mode_config_cleanup(dev);
 }
 
diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index 0abe7ec..b6f6963 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -2336,11 +2336,6 @@ done:
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
diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index 2aff20f..6d6bf60 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -559,8 +559,6 @@ static void intel_lvds_destroy(struct drm_connector *connector)
 	struct drm_device *dev = connector->dev;
 	struct drm_i915_private *dev_priv = dev->dev_private;
 
-	intel_panel_destroy_backlight(dev);
-
 	if (dev_priv->lid_notifier.notifier_call)
 		acpi_lid_notifier_unregister(&dev_priv->lid_notifier);
 	drm_sysfs_connector_remove(connector);
diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/intel_panel.c
index 2a1625d..d5fd67e 100644
--- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@ -361,6 +361,9 @@ int intel_panel_setup_backlight(struct drm_device *dev)
 
 	intel_panel_init_backlight(dev);
 
+	if (WARN_ON(dev_priv->backlight))
+		return -ENODEV;
+
 	if (dev_priv->int_lvds_connector)
 		connector = dev_priv->int_lvds_connector;
 	else if (dev_priv->int_edp_connector)
@@ -389,8 +392,10 @@ int intel_panel_setup_backlight(struct drm_device *dev)
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
-- 
1.8.1.2

