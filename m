Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab3JUJQa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 05:16:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39584 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753815Ab3JUIvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:51:40 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Alex Deucher" <alexander.deucher@amd.com>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.937888156@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 075/149] drm/radeon: fix panel scaling with eDP and
 LVDS bridges
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 855f5f1d882a34e4e9dd27b299737cd3508a5624 upstream.

We were using the wrong set_properly callback so we always
ended up with Full scaling even if something else (Center or
Full aspect) was selected.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/radeon_connectors.c | 34 +++++++++++++++++++++++++++---
 1 file changed, 31 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -1387,6 +1387,24 @@ struct drm_connector_funcs radeon_dp_con
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
@@ -1478,8 +1496,6 @@ radeon_add_atom_connector(struct drm_dev
 			goto failed;
 		radeon_dig_connector->igp_lane_info = igp_lane_info;
 		radeon_connector->con_priv = radeon_dig_connector;
-		drm_connector_init(dev, &radeon_connector->base, &radeon_dp_connector_funcs, connector_type);
-		drm_connector_helper_add(&radeon_connector->base, &radeon_dp_connector_helper_funcs);
 		if (i2c_bus->valid) {
 			/* add DP i2c bus */
 			if (connector_type == DRM_MODE_CONNECTOR_eDP)
@@ -1496,6 +1512,10 @@ radeon_add_atom_connector(struct drm_dev
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
@@ -1508,6 +1528,10 @@ radeon_add_atom_connector(struct drm_dev
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
@@ -1532,6 +1556,10 @@ radeon_add_atom_connector(struct drm_dev
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
@@ -1695,7 +1723,7 @@ radeon_add_atom_connector(struct drm_dev
 				goto failed;
 			radeon_dig_connector->igp_lane_info = igp_lane_info;
 			radeon_connector->con_priv = radeon_dig_connector;
-			drm_connector_init(dev, &radeon_connector->base, &radeon_dp_connector_funcs, connector_type);
+			drm_connector_init(dev, &radeon_connector->base, &radeon_edp_connector_funcs, connector_type);
 			drm_connector_helper_add(&radeon_connector->base, &radeon_dp_connector_helper_funcs);
 			if (i2c_bus->valid) {
 				/* add DP i2c bus */

