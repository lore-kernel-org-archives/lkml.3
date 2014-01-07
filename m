Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366AbaAGOz0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 09:55:26 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:52375 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbaAGOyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 09:54:37 -0500
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, Andreas Heider <andreas@meetr.de>,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH v2 4/4] drm/i915: introduce intel_connector->reprobe
Date: Tue,  7 Jan 2014 20:24:32 +0530
Message-Id: <1389106472-11389-5-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.5.2.229.g4448466
In-Reply-To: <1389106472-11389-1-git-send-email-artagnon@gmail.com>
References: <1389106472-11389-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a struct edid *(*reprobe)(struct drm_connector *, struct
i2c_adapter *) in struct intel_connector to point to various get_edid()
functions.

Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Andreas Heider <andreas@meetr.de>
Cc: Seth Forshee <seth.forshee@canonical.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 drivers/gpu/drm/i915/intel_crt.c  | 1 +
 drivers/gpu/drm/i915/intel_dp.c   | 1 +
 drivers/gpu/drm/i915/intel_drv.h  | 6 ++++++
 drivers/gpu/drm/i915/intel_lvds.c | 1 +
 drivers/gpu/drm/i915/intel_sdvo.c | 4 ++++
 5 files changed, 13 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_crt.c b/drivers/gpu/drm/i915/intel_crt.c
index b5b1b9b..4e678fe 100644
--- a/drivers/gpu/drm/i915/intel_crt.c
+++ b/drivers/gpu/drm/i915/intel_crt.c
@@ -832,6 +832,7 @@ void intel_crt_init(struct drm_device *dev)
 		crt->base.get_hw_state = intel_crt_get_hw_state;
 	}
 	intel_connector->get_hw_state = intel_connector_get_hw_state;
+	intel_connector->reprobe = intel_crt_get_edid;
 
 	drm_connector_helper_add(connector, &intel_crt_connector_helper_funcs);
 
diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index 30c627c..2f4491c 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -3657,6 +3657,7 @@ intel_dp_init_connector(struct intel_digital_port *intel_dig_port,
 		intel_connector->get_hw_state = intel_ddi_connector_get_hw_state;
 	else
 		intel_connector->get_hw_state = intel_connector_get_hw_state;
+	intel_connector->reprobe = intel_dp_get_edid;
 
 	intel_dp->aux_ch_ctl_reg = intel_dp->output_reg + 0x10;
 	if (HAS_DDI(dev)) {
diff --git a/drivers/gpu/drm/i915/intel_drv.h b/drivers/gpu/drm/i915/intel_drv.h
index 79f91f2..6ff89da 100644
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -175,6 +175,12 @@ struct intel_connector {
 	 * and active (i.e. dpms ON state). */
 	bool (*get_hw_state)(struct intel_connector *);
 
+	/*
+	 * Points to the corresponding get_edid() functions for
+	 * LVDS, CRT, SDVO, and DP
+	 */
+	struct edid *(*reprobe)(struct drm_connector *, struct i2c_adapter *);
+
 	/* Panel info for eDP and LVDS */
 	struct intel_panel panel;
 
diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index e7aa285..6a7078e 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -1050,6 +1050,7 @@ void intel_lvds_init(struct drm_device *dev)
 	intel_encoder->get_hw_state = intel_lvds_get_hw_state;
 	intel_encoder->get_config = intel_lvds_get_config;
 	intel_connector->get_hw_state = intel_connector_get_hw_state;
+	intel_connector->reprobe = intel_lvds_get_edid;
 
 	intel_connector_attach_encoder(intel_connector, intel_encoder);
 	intel_encoder->type = INTEL_OUTPUT_LVDS;
diff --git a/drivers/gpu/drm/i915/intel_sdvo.c b/drivers/gpu/drm/i915/intel_sdvo.c
index beb40e5..2083993 100644
--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -2420,6 +2420,7 @@ intel_sdvo_dvi_init(struct intel_sdvo *intel_sdvo, int device)
 	}
 
 	intel_connector = &intel_sdvo_connector->base;
+	intel_connector->reprobe = intel_sdvo_get_edid;
 	connector = &intel_connector->base;
 	if (intel_sdvo_get_hotplug_support(intel_sdvo) &
 		intel_sdvo_connector->output_flag) {
@@ -2462,6 +2463,7 @@ intel_sdvo_tv_init(struct intel_sdvo *intel_sdvo, int type)
 		return false;
 
 	intel_connector = &intel_sdvo_connector->base;
+	intel_connector->reprobe = intel_sdvo_get_edid;
 	connector = &intel_connector->base;
 	encoder->encoder_type = DRM_MODE_ENCODER_TVDAC;
 	connector->connector_type = DRM_MODE_CONNECTOR_SVIDEO;
@@ -2502,6 +2504,7 @@ intel_sdvo_analog_init(struct intel_sdvo *intel_sdvo, int device)
 		return false;
 
 	intel_connector = &intel_sdvo_connector->base;
+	intel_connector->reprobe = intel_sdvo_get_edid;
 	connector = &intel_connector->base;
 	intel_connector->polled = DRM_CONNECTOR_POLL_CONNECT;
 	encoder->encoder_type = DRM_MODE_ENCODER_DAC;
@@ -2535,6 +2538,7 @@ intel_sdvo_lvds_init(struct intel_sdvo *intel_sdvo, int device)
 		return false;
 
 	intel_connector = &intel_sdvo_connector->base;
+	intel_connector->reprobe = intel_sdvo_get_edid;
 	connector = &intel_connector->base;
 	encoder->encoder_type = DRM_MODE_ENCODER_LVDS;
 	connector->connector_type = DRM_MODE_CONNECTOR_LVDS;
-- 
1.8.5.2.229.g4448466

