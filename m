Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637Ab3I2Tgv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 15:36:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59797 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756105Ab3I2T3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:29:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 56/71] drm/radeon: fix panel scaling with eDP and LVDS bridges
Date: Sun, 29 Sep 2013 12:28:08 -0700
Message-Id: <20130929192647.369006331@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130929192643.539596256@linuxfoundation.org>
References: <20130929192643.539596256@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 855f5f1d882a34e4e9dd27b299737cd3508a5624 upstream.

We were using the wrong set_properly callback so we always
ended up with Full scaling even if something else (Center or
Full aspect) was selected.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_connectors.c |   34 ++++++++++++++++++++++++++---
 1 file changed, 31 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -1489,6 +1489,24 @@ static const struct drm_connector_funcs
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
@@ -1580,8 +1598,6 @@ radeon_add_atom_connector(struct drm_dev
 			goto failed;
 		radeon_dig_connector->igp_lane_info = igp_lane_info;
 		radeon_connector->con_priv = radeon_dig_connector;
-		drm_connector_init(dev, &radeon_connector->base, &radeon_dp_connector_funcs, connector_type);
-		drm_connector_helper_add(&radeon_connector->base, &radeon_dp_connector_helper_funcs);
 		if (i2c_bus->valid) {
 			/* add DP i2c bus */
 			if (connector_type == DRM_MODE_CONNECTOR_eDP)
@@ -1598,6 +1614,10 @@ radeon_add_atom_connector(struct drm_dev
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
@@ -1610,6 +1630,10 @@ radeon_add_atom_connector(struct drm_dev
 		case DRM_MODE_CONNECTOR_HDMIA:
 		case DRM_MODE_CONNECTOR_HDMIB:
 		case DRM_MODE_CONNECTOR_DisplayPort:
+			drm_connector_init(dev, &radeon_connector->base,
+					   &radeon_dp_connector_funcs, connector_type);
+			drm_connector_helper_add(&radeon_connector->base,
+						 &radeon_dp_connector_helper_funcs);
 			drm_object_attach_property(&radeon_connector->base.base,
 						      rdev->mode_info.underscan_property,
 						      UNDERSCAN_OFF);
@@ -1634,6 +1658,10 @@ radeon_add_atom_connector(struct drm_dev
 			break;
 		case DRM_MODE_CONNECTOR_LVDS:
 		case DRM_MODE_CONNECTOR_eDP:
+			drm_connector_init(dev, &radeon_connector->base,
+					   &radeon_lvds_bridge_connector_funcs, connector_type);
+			drm_connector_helper_add(&radeon_connector->base,
+						 &radeon_dp_connector_helper_funcs);
 			drm_object_attach_property(&radeon_connector->base.base,
 						      dev->mode_config.scaling_mode_property,
 						      DRM_MODE_SCALE_FULLSCREEN);
@@ -1797,7 +1825,7 @@ radeon_add_atom_connector(struct drm_dev
 				goto failed;
 			radeon_dig_connector->igp_lane_info = igp_lane_info;
 			radeon_connector->con_priv = radeon_dig_connector;
-			drm_connector_init(dev, &radeon_connector->base, &radeon_dp_connector_funcs, connector_type);
+			drm_connector_init(dev, &radeon_connector->base, &radeon_edp_connector_funcs, connector_type);
 			drm_connector_helper_add(&radeon_connector->base, &radeon_dp_connector_helper_funcs);
 			if (i2c_bus->valid) {
 				/* add DP i2c bus */


