Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932482Ab3JKLK4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 07:10:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58373 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757521Ab3JKKma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:42:30 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 011/100] drm/radeon: fix panel scaling with eDP and LVDS bridges
Date: Fri, 11 Oct 2013 11:40:41 +0100
Message-Id: <1381488130-30235-12-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
References: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.23 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 855f5f1d882a34e4e9dd27b299737cd3508a5624 upstream.

We were using the wrong set_properly callback so we always
ended up with Full scaling even if something else (Center or
Full aspect) was selected.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_connectors.c | 34 +++++++++++++++++++++++++++---
 1 file changed, 31 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_connectors.c b/drivers/gpu/drm/radeon/radeon_connectors.c
index a7e797c..bfe1f75 100644
--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -1479,6 +1479,24 @@ struct drm_connector_funcs radeon_dp_connector_funcs = {
 	.force = radeon_dvi_force,
 };
 
+static const struct drm_connector_funcs radeon_edp_connector_funcs = {
+	.dpms = drm_helper_connector_dpms,
+	.detect = radeon_dp_detect,
+	.fill_modes = drm_helper_probe_single_connector_modes,
+	.set_property = radeon_lvds_set_property,
+	.destroy = radeon_dp_connector_destroy,
+	.force = radeon_dvi_force,
+};
+
+static const struct drm_connector_funcs radeon_lvds_bridge_connector_funcs = {
+	.dpms = drm_helper_connector_dpms,
+	.detect = radeon_dp_detect,
+	.fill_modes = drm_helper_probe_single_connector_modes,
+	.set_property = radeon_lvds_set_property,
+	.destroy = radeon_dp_connector_destroy,
+	.force = radeon_dvi_force,
+};
+
 void
 radeon_add_atom_connector(struct drm_device *dev,
 			  uint32_t connector_id,
@@ -1570,8 +1588,6 @@ radeon_add_atom_connector(struct drm_device *dev,
 			goto failed;
 		radeon_dig_connector->igp_lane_info = igp_lane_info;
 		radeon_connector->con_priv = radeon_dig_connector;
-		drm_connector_init(dev, &radeon_connector->base, &radeon_dp_connector_funcs, connector_type);
-		drm_connector_helper_add(&radeon_connector->base, &radeon_dp_connector_helper_funcs);
 		if (i2c_bus->valid) {
 			/* add DP i2c bus */
 			if (connector_type == DRM_MODE_CONNECTOR_eDP)
@@ -1588,6 +1604,10 @@ radeon_add_atom_connector(struct drm_device *dev,
 		case DRM_MODE_CONNECTOR_VGA:
 		case DRM_MODE_CONNECTOR_DVIA:
 		default:
+			drm_connector_init(dev, &radeon_connector->base,
+					   &radeon_dp_connector_funcs, connector_type);
+			drm_connector_helper_add(&radeon_connector->base,
+						 &radeon_dp_connector_helper_funcs);
 			connector->interlace_allowed = true;
 			connector->doublescan_allowed = true;
 			radeon_connector->dac_load_detect = true;
@@ -1600,6 +1620,10 @@ radeon_add_atom_connector(struct drm_device *dev,
 		case DRM_MODE_CONNECTOR_HDMIA:
 		case DRM_MODE_CONNECTOR_HDMIB:
 		case DRM_MODE_CONNECTOR_DisplayPort:
+			drm_connector_init(dev, &radeon_connector->base,
+					   &radeon_dp_connector_funcs, connector_type);
+			drm_connector_helper_add(&radeon_connector->base,
+						 &radeon_dp_connector_helper_funcs);
 			drm_connector_attach_property(&radeon_connector->base,
 						      rdev->mode_info.underscan_property,
 						      UNDERSCAN_OFF);
@@ -1624,6 +1648,10 @@ radeon_add_atom_connector(struct drm_device *dev,
 			break;
 		case DRM_MODE_CONNECTOR_LVDS:
 		case DRM_MODE_CONNECTOR_eDP:
+			drm_connector_init(dev, &radeon_connector->base,
+					   &radeon_lvds_bridge_connector_funcs, connector_type);
+			drm_connector_helper_add(&radeon_connector->base,
+						 &radeon_dp_connector_helper_funcs);
 			drm_connector_attach_property(&radeon_connector->base,
 						      dev->mode_config.scaling_mode_property,
 						      DRM_MODE_SCALE_FULLSCREEN);
@@ -1787,7 +1815,7 @@ radeon_add_atom_connector(struct drm_device *dev,
 				goto failed;
 			radeon_dig_connector->igp_lane_info = igp_lane_info;
 			radeon_connector->con_priv = radeon_dig_connector;
-			drm_connector_init(dev, &radeon_connector->base, &radeon_dp_connector_funcs, connector_type);
+			drm_connector_init(dev, &radeon_connector->base, &radeon_edp_connector_funcs, connector_type);
 			drm_connector_helper_add(&radeon_connector->base, &radeon_dp_connector_helper_funcs);
 			if (i2c_bus->valid) {
 				/* add DP i2c bus */
-- 
1.8.3.2

