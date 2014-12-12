Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966898AbaLLTlp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 14:41:45 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:53427 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932581AbaLLTlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 14:41:44 -0500
From: Hai Li <hali@codeaurora.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        robdclark@gmail.com, Hai Li <hali@codeaurora.org>
Subject: [PATCH 2/2] drm/msm: Add the eDP connector in msm drm driver (V2)
Date: Fri, 12 Dec 2014 14:41:17 -0500
Message-Id: <1418413277-30894-1-git-send-email-hali@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1418405718-20181-2-git-send-email-hali@codeaurora.org>
References: <1418405718-20181-2-git-send-email-hali@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modified the hard-coded hdmi connector/encoder implementations in msm drm
driver to support both edp and hdmi.

V1: Initial change

V2: Address Thierry's change

Signed-off-by: Hai Li <hali@codeaurora.org>
---
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_encoder.c | 38 +++++++++++++++++++++++--
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c     | 43 ++++++++++++++++++++---------
 drivers/gpu/drm/msm/msm_drv.c               |  2 ++
 drivers/gpu/drm/msm/msm_drv.h               |  6 ++++
 4 files changed, 74 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_encoder.c b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_encoder.c
index 3ce82be..dd2e5fa 100644
--- a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_encoder.c
+++ b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_encoder.c
@@ -1,4 +1,5 @@
 /*
+ * Copyright (c) 2014, The Linux Foundation. All rights reserved.
  * Copyright (C) 2013 Red Hat
  * Author: Rob Clark <robdclark@gmail.com>
  *
@@ -162,11 +163,13 @@ static void mdp5_encoder_mode_set(struct drm_encoder *encoder,
 {
 	struct mdp5_encoder *mdp5_encoder = to_mdp5_encoder(encoder);
 	struct mdp5_kms *mdp5_kms = get_kms(encoder);
+	struct drm_device *dev = encoder->dev;
+	struct drm_connector *connector;
 	int intf = mdp5_encoder->intf;
 	uint32_t dtv_hsync_skew, vsync_period, vsync_len, ctrl_pol;
 	uint32_t display_v_start, display_v_end;
 	uint32_t hsync_start_x, hsync_end_x;
-	uint32_t format;
+	uint32_t format = 0x2100;
 	unsigned long flags;
 
 	mode = adjusted_mode;
@@ -188,7 +191,28 @@ static void mdp5_encoder_mode_set(struct drm_encoder *encoder,
 	/* probably need to get DATA_EN polarity from panel.. */
 
 	dtv_hsync_skew = 0;  /* get this from panel? */
-	format = 0x213f;     /* get this from panel? */
+
+	/* Get color format from panel, default is 8bpc */
+	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
+		if (connector->encoder == encoder) {
+			switch (connector->display_info.bpc) {
+			case 4:
+				format |= 0;
+				break;
+			case 5:
+				format |= 0x15;
+				break;
+			case 6:
+				format |= 0x2A;
+				break;
+			case 8:
+			default:
+				format |= 0x3F;
+				break;
+			}
+			break;
+		}
+	}
 
 	hsync_start_x = (mode->htotal - mode->hsync_start);
 	hsync_end_x = mode->htotal - (mode->hsync_start - mode->hdisplay) - 1;
@@ -198,6 +222,16 @@ static void mdp5_encoder_mode_set(struct drm_encoder *encoder,
 	display_v_start = (mode->vtotal - mode->vsync_start) * mode->htotal + dtv_hsync_skew;
 	display_v_end = vsync_period - ((mode->vsync_start - mode->vdisplay) * mode->htotal) + dtv_hsync_skew - 1;
 
+	/*
+	 * For edp only:
+	 * DISPLAY_V_START = (VBP * HCYCLE) + HBP
+	 * DISPLAY_V_END = (VBP + VACTIVE) * HCYCLE - 1 - HFP
+	 */
+	if (mdp5_encoder->intf_id == INTF_eDP) {
+		display_v_start += mode->htotal - mode->hsync_start;
+		display_v_end -= mode->hsync_start - mode->hdisplay;
+	}
+
 	spin_lock_irqsave(&mdp5_encoder->intf_lock, flags);
 
 	mdp5_write(mdp5_kms, REG_MDP5_INTF_HSYNC_CTL(intf),
diff --git a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c
index d6f7e42..5b50f06 100644
--- a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c
+++ b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c
@@ -210,14 +210,6 @@ static int modeset_init(struct mdp5_kms *mdp5_kms)
 		}
 	}
 
-	/* Construct encoder for HDMI: */
-	encoder = mdp5_encoder_init(dev, 3, INTF_HDMI);
-	if (IS_ERR(encoder)) {
-		dev_err(dev->dev, "failed to construct encoder\n");
-		ret = PTR_ERR(encoder);
-		goto fail;
-	}
-
 	/* NOTE: the vsync and error irq's are actually associated with
 	 * the INTF/encoder.. the easiest way to deal with this (ie. what
 	 * we do now) is assume a fixed relationship between crtc's and
@@ -226,13 +218,18 @@ static int modeset_init(struct mdp5_kms *mdp5_kms)
 	 * care of error and vblank irq's that the crtc has registered,
 	 * and also update user-requested vblank_mask.
 	 */
-	encoder->possible_crtcs = BIT(0);
-	mdp5_crtc_set_intf(priv->crtcs[0], 3, INTF_HDMI);
+	if (priv->hdmi) {
+		/* Construct encoder for HDMI: */
+		encoder = mdp5_encoder_init(dev, 3, INTF_HDMI);
+		if (IS_ERR(encoder)) {
+			dev_err(dev->dev, "failed to construct encoder\n");
+			ret = PTR_ERR(encoder);
+			goto fail;
+		}
 
-	priv->encoders[priv->num_encoders++] = encoder;
+		encoder->possible_crtcs = (1 << priv->num_crtcs) - 1;
+		priv->encoders[priv->num_encoders++] = encoder;
 
-	/* Construct bridge/connector for HDMI: */
-	if (priv->hdmi) {
 		ret = hdmi_modeset_init(priv->hdmi, dev, encoder);
 		if (ret) {
 			dev_err(dev->dev, "failed to initialize HDMI: %d\n", ret);
@@ -240,6 +237,26 @@ static int modeset_init(struct mdp5_kms *mdp5_kms)
 		}
 	}
 
+	if (priv->edp) {
+		/* Construct encoder for eDP: */
+		encoder = mdp5_encoder_init(dev, 0, INTF_eDP);
+		if (IS_ERR(encoder)) {
+			dev_err(dev->dev, "failed to construct eDP encoder\n");
+			ret = PTR_ERR(encoder);
+			goto fail;
+		}
+
+		encoder->possible_crtcs = (1 << priv->num_crtcs) - 1;
+		priv->encoders[priv->num_encoders++] = encoder;
+
+		ret = msm_edp_modeset_init(priv->edp, dev, encoder);
+		if (ret) {
+			dev_err(dev->dev, "failed to initialize eDP: %d\n",
+									ret);
+			goto fail;
+		}
+	}
+
 	return 0;
 
 fail:
diff --git a/drivers/gpu/drm/msm/msm_drv.c b/drivers/gpu/drm/msm/msm_drv.c
index d2e0a73..6f8aaea 100644
--- a/drivers/gpu/drm/msm/msm_drv.c
+++ b/drivers/gpu/drm/msm/msm_drv.c
@@ -1023,6 +1023,7 @@ static struct platform_driver msm_platform_driver = {
 static int __init msm_drm_register(void)
 {
 	DBG("init");
+	msm_edp_register();
 	hdmi_register();
 	adreno_register();
 	return platform_driver_register(&msm_platform_driver);
@@ -1034,6 +1035,7 @@ static void __exit msm_drm_unregister(void)
 	platform_driver_unregister(&msm_platform_driver);
 	hdmi_unregister();
 	adreno_unregister();
+	msm_edp_unregister();
 }
 
 module_init(msm_drm_register);
diff --git a/drivers/gpu/drm/msm/msm_drv.h b/drivers/gpu/drm/msm/msm_drv.h
index 3b25dd8..c83abf3 100644
--- a/drivers/gpu/drm/msm/msm_drv.h
+++ b/drivers/gpu/drm/msm/msm_drv.h
@@ -224,6 +224,12 @@ int hdmi_modeset_init(struct hdmi *hdmi, struct drm_device *dev,
 void __init hdmi_register(void);
 void __exit hdmi_unregister(void);
 
+struct msm_edp;
+void __init msm_edp_register(void);
+void __exit msm_edp_unregister(void);
+int msm_edp_modeset_init(struct msm_edp *edp, struct drm_device *dev,
+		struct drm_encoder *encoder);
+
 #ifdef CONFIG_DEBUG_FS
 void msm_gem_describe(struct drm_gem_object *obj, struct seq_file *m);
 void msm_gem_describe_objects(struct list_head *list, struct seq_file *m);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

