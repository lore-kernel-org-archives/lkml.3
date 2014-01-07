Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226AbaAGOyy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 09:54:54 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:42043 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092AbaAGOye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 09:54:34 -0500
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, Andreas Heider <andreas@meetr.de>,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH v2 3/4] drm/i915: change intel_sdvo_get_edid() prototype
Date: Tue,  7 Jan 2014 20:24:31 +0530
Message-Id: <1389106472-11389-4-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.5.2.229.g4448466
In-Reply-To: <1389106472-11389-1-git-send-email-artagnon@gmail.com>
References: <1389106472-11389-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In future patches, we intend to introduce a generic interface to the
various get_edid() functions. All the other get_edid() functions accept
two arguments: a struct drm_connector *, and a struct i2c_adapter *. So,
introduce a second dummy variable in intel_sdvo_get_edid().

Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Andreas Heider <andreas@meetr.de>
Cc: Seth Forshee <seth.forshee@canonical.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 drivers/gpu/drm/i915/intel_sdvo.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_sdvo.c b/drivers/gpu/drm/i915/intel_sdvo.c
index a583e8f..beb40e5 100644
--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -1612,7 +1612,8 @@ intel_sdvo_multifunc_encoder(struct intel_sdvo *intel_sdvo)
 }
 
 static struct edid *
-intel_sdvo_get_edid(struct drm_connector *connector)
+intel_sdvo_get_edid(struct drm_connector *connector,
+		struct i2c_adapter __maybe_unused *dummy)
 {
 	struct intel_sdvo *sdvo = intel_attached_sdvo(connector);
 	return drm_get_edid(connector, &sdvo->ddc);
@@ -1636,7 +1637,7 @@ intel_sdvo_tmds_sink_detect(struct drm_connector *connector)
 	enum drm_connector_status status;
 	struct edid *edid;
 
-	edid = intel_sdvo_get_edid(connector);
+	edid = intel_sdvo_get_edid(connector, NULL);
 
 	if (edid == NULL && intel_sdvo_multifunc_encoder(intel_sdvo)) {
 		u8 ddc, saved_ddc = intel_sdvo->ddc_bus;
@@ -1647,7 +1648,7 @@ intel_sdvo_tmds_sink_detect(struct drm_connector *connector)
 		 */
 		for (ddc = intel_sdvo->ddc_bus >> 1; ddc > 1; ddc >>= 1) {
 			intel_sdvo->ddc_bus = ddc;
-			edid = intel_sdvo_get_edid(connector);
+			edid = intel_sdvo_get_edid(connector, NULL);
 			if (edid)
 				break;
 		}
@@ -1740,7 +1741,7 @@ intel_sdvo_detect(struct drm_connector *connector, bool force)
 		struct edid *edid;
 
 		/* if we have an edid check it matches the connection */
-		edid = intel_sdvo_get_edid(connector);
+		edid = intel_sdvo_get_edid(connector, NULL);
 		if (edid == NULL)
 			edid = intel_sdvo_get_analog_edid(connector);
 		if (edid != NULL) {
@@ -1777,7 +1778,7 @@ static void intel_sdvo_get_ddc_modes(struct drm_connector *connector)
 		      connector->base.id, drm_get_connector_name(connector));
 
 	/* set the bus switch and get the modes */
-	edid = intel_sdvo_get_edid(connector);
+	edid = intel_sdvo_get_edid(connector, NULL);
 
 	/*
 	 * Mac mini hack.  On this device, the DVI-I connector shares one DDC
@@ -2022,7 +2023,7 @@ static bool intel_sdvo_detect_hdmi_audio(struct drm_connector *connector)
 	if (!intel_sdvo->is_hdmi)
 		return false;
 
-	edid = intel_sdvo_get_edid(connector);
+	edid = intel_sdvo_get_edid(connector, NULL);
 	if (edid != NULL && edid->input & DRM_EDID_INPUT_DIGITAL)
 		has_audio = drm_detect_monitor_audio(edid);
 	kfree(edid);
-- 
1.8.5.2.229.g4448466

