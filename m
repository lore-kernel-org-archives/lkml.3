Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932987Ab3APQKr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:10:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36884 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932946Ab3APQKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:10:40 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Niels Ole Salscheider <niels_ole@salscheider-online.de>,
        Alex Deucher <alexander.deucher@amd.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 203/222] drm/radeon: Properly handle DDC probe for DP bridges
Date: Wed, 16 Jan 2013 13:56:43 -0200
Message-Id: <1358351822-7675-204-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niels Ole Salscheider <niels_ole@salscheider-online.de>

commit 0a9069d34918659bc8a89e21e69e60b2b83291a3 upstream.

DDC information can be accessed using AUX CH

Fixes failure to probe monitors on some systems with
DP bridge chips.

agd5f: minor fixes

Signed-off-by: Niels Ole Salscheider <niels_ole@salscheider-online.de>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_connectors.c |   10 ++++++----
 drivers/gpu/drm/radeon/radeon_display.c    |   13 +++++++++----
 drivers/gpu/drm/radeon/radeon_i2c.c        |   10 ++++++++--
 drivers/gpu/drm/radeon/radeon_mode.h       |    2 +-
 4 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_connectors.c b/drivers/gpu/drm/radeon/radeon_connectors.c
index 895e628..a7e797c 100644
--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -745,7 +745,7 @@ radeon_vga_detect(struct drm_connector *connector, bool force)
 		ret = connector_status_disconnected;
 
 	if (radeon_connector->ddc_bus)
-		dret = radeon_ddc_probe(radeon_connector);
+		dret = radeon_ddc_probe(radeon_connector, false);
 	if (dret) {
 		radeon_connector->detected_by_load = false;
 		if (radeon_connector->edid) {
@@ -951,7 +951,7 @@ radeon_dvi_detect(struct drm_connector *connector, bool force)
 		return connector->status;
 
 	if (radeon_connector->ddc_bus)
-		dret = radeon_ddc_probe(radeon_connector);
+		dret = radeon_ddc_probe(radeon_connector, false);
 	if (dret) {
 		radeon_connector->detected_by_load = false;
 		if (radeon_connector->edid) {
@@ -1391,7 +1391,8 @@ radeon_dp_detect(struct drm_connector *connector, bool force)
 		if (encoder) {
 			/* setup ddc on the bridge */
 			radeon_atom_ext_encoder_setup_ddc(encoder);
-			if (radeon_ddc_probe(radeon_connector)) /* try DDC */
+			/* bridge chips are always aux */
+			if (radeon_ddc_probe(radeon_connector, true)) /* try DDC */
 				ret = connector_status_connected;
 			else if (radeon_connector->dac_load_detect) { /* try load detection */
 				struct drm_encoder_helper_funcs *encoder_funcs = encoder->helper_private;
@@ -1409,7 +1410,8 @@ radeon_dp_detect(struct drm_connector *connector, bool force)
 				if (radeon_dp_getdpcd(radeon_connector))
 					ret = connector_status_connected;
 			} else {
-				if (radeon_ddc_probe(radeon_connector))
+				/* try non-aux ddc (DP to DVI/HMDI/etc. adapter) */
+				if (radeon_ddc_probe(radeon_connector, false))
 					ret = connector_status_connected;
 			}
 		}
diff --git a/drivers/gpu/drm/radeon/radeon_display.c b/drivers/gpu/drm/radeon/radeon_display.c
index 64a008d1..cf6085b 100644
--- a/drivers/gpu/drm/radeon/radeon_display.c
+++ b/drivers/gpu/drm/radeon/radeon_display.c
@@ -695,10 +695,15 @@ int radeon_ddc_get_modes(struct radeon_connector *radeon_connector)
 	if (radeon_connector->router.ddc_valid)
 		radeon_router_select_ddc_port(radeon_connector);
 
-	if ((radeon_connector->base.connector_type == DRM_MODE_CONNECTOR_DisplayPort) ||
-	    (radeon_connector->base.connector_type == DRM_MODE_CONNECTOR_eDP) ||
-	    (radeon_connector_encoder_get_dp_bridge_encoder_id(&radeon_connector->base) !=
-	     ENCODER_OBJECT_ID_NONE)) {
+	if (radeon_connector_encoder_get_dp_bridge_encoder_id(&radeon_connector->base) !=
+	    ENCODER_OBJECT_ID_NONE) {
+		struct radeon_connector_atom_dig *dig = radeon_connector->con_priv;
+
+		if (dig->dp_i2c_bus)
+			radeon_connector->edid = drm_get_edid(&radeon_connector->base,
+							      &dig->dp_i2c_bus->adapter);
+	} else if ((radeon_connector->base.connector_type == DRM_MODE_CONNECTOR_DisplayPort) ||
+		   (radeon_connector->base.connector_type == DRM_MODE_CONNECTOR_eDP)) {
 		struct radeon_connector_atom_dig *dig = radeon_connector->con_priv;
 
 		if ((dig->dp_sink_type == CONNECTOR_OBJECT_ID_DISPLAYPORT ||
diff --git a/drivers/gpu/drm/radeon/radeon_i2c.c b/drivers/gpu/drm/radeon/radeon_i2c.c
index 3edec1c..6076e85 100644
--- a/drivers/gpu/drm/radeon/radeon_i2c.c
+++ b/drivers/gpu/drm/radeon/radeon_i2c.c
@@ -39,7 +39,7 @@ extern u32 radeon_atom_hw_i2c_func(struct i2c_adapter *adap);
  * radeon_ddc_probe
  *
  */
-bool radeon_ddc_probe(struct radeon_connector *radeon_connector)
+bool radeon_ddc_probe(struct radeon_connector *radeon_connector, bool use_aux)
 {
 	u8 out = 0x0;
 	u8 buf[8];
@@ -63,7 +63,13 @@ bool radeon_ddc_probe(struct radeon_connector *radeon_connector)
 	if (radeon_connector->router.ddc_valid)
 		radeon_router_select_ddc_port(radeon_connector);
 
-	ret = i2c_transfer(&radeon_connector->ddc_bus->adapter, msgs, 2);
+	if (use_aux) {
+		struct radeon_connector_atom_dig *dig = radeon_connector->con_priv;
+		ret = i2c_transfer(&dig->dp_i2c_bus->adapter, msgs, 2);
+	} else {
+		ret = i2c_transfer(&radeon_connector->ddc_bus->adapter, msgs, 2);
+	}
+
 	if (ret != 2)
 		/* Couldn't find an accessible DDC on this connector */
 		return false;
diff --git a/drivers/gpu/drm/radeon/radeon_mode.h b/drivers/gpu/drm/radeon/radeon_mode.h
index 7a9ac40..5db26e1 100644
--- a/drivers/gpu/drm/radeon/radeon_mode.h
+++ b/drivers/gpu/drm/radeon/radeon_mode.h
@@ -535,7 +535,7 @@ extern void radeon_i2c_put_byte(struct radeon_i2c_chan *i2c,
 				u8 val);
 extern void radeon_router_select_ddc_port(struct radeon_connector *radeon_connector);
 extern void radeon_router_select_cd_port(struct radeon_connector *radeon_connector);
-extern bool radeon_ddc_probe(struct radeon_connector *radeon_connector);
+extern bool radeon_ddc_probe(struct radeon_connector *radeon_connector, bool use_aux);
 extern int radeon_ddc_get_modes(struct radeon_connector *radeon_connector);
 
 extern struct drm_encoder *radeon_best_encoder(struct drm_connector *connector);
-- 
1.7.9.5

