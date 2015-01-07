Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbbAGV1z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 16:27:55 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:57137 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755239AbbAGV1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 16:27:52 -0500
From: Stephane Viau <sviau@codeaurora.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        robdclark@gmail.com, Stephane Viau <sviau@codeaurora.org>
Subject: [PATCH 3/3] drm/msm/hdmi: rework hdmi configurations, using dt_match[]
Date: Wed,  7 Jan 2015 16:27:27 -0500
Message-Id: <1420666047-3690-4-git-send-email-sviau@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1420666047-3690-1-git-send-email-sviau@codeaurora.org>
References: <1420666047-3690-1-git-send-email-sviau@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the same idea mdp5_cfg was added, this change allows us to quickly
add new instances, such as apq8084's HDMI in this case.

Signed-off-by: Stephane Viau <sviau@codeaurora.org>
---
 Documentation/devicetree/bindings/drm/msm/hdmi.txt |   1 +
 drivers/gpu/drm/msm/hdmi/hdmi.c                    | 128 +++++++++++----------
 2 files changed, 71 insertions(+), 58 deletions(-)

diff --git a/Documentation/devicetree/bindings/drm/msm/hdmi.txt b/Documentation/devicetree/bindings/drm/msm/hdmi.txt
index c25d5aa..a29a55f 100644
--- a/Documentation/devicetree/bindings/drm/msm/hdmi.txt
+++ b/Documentation/devicetree/bindings/drm/msm/hdmi.txt
@@ -3,6 +3,7 @@ Qualcomm adreno/snapdragon hdmi output
 Required properties:
 - compatible: one of the following
    * "qcom,hdmi-tx-8084"
+   * "qcom,hdmi-tx-8074"
    * "qcom,hdmi-tx-8660"
    * "qcom,hdmi-tx-8960"
 - reg: Physical base address and length of the controller's registers
diff --git a/drivers/gpu/drm/msm/hdmi/hdmi.c b/drivers/gpu/drm/msm/hdmi/hdmi.c
index c2fe4fa..36a12ee 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi.c
@@ -1,4 +1,5 @@
 /*
+ * Copyright (c) 2014 The Linux Foundation. All rights reserved.
  * Copyright (C) 2013 Red Hat
  * Author: Rob Clark <robdclark@gmail.com>
  *
@@ -291,6 +292,57 @@ fail:
 
 #include <linux/of_gpio.h>
 
+#define HDMI_CFG(item, entry) \
+	.item ## _names = item ##_names_ ## entry, \
+	.item ## _cnt   = ARRAY_SIZE(item ## _names_ ## entry)
+
+static struct hdmi_platform_config hdmi_tx_8660_config = {
+		.phy_init = hdmi_phy_8x60_init,
+};
+
+static const char *hpd_reg_names_8960[] = {"core-vdda", "hdmi-mux"};
+static const char *hpd_clk_names_8960[] = {"core_clk", "master_iface_clk", "slave_iface_clk"};
+
+static struct hdmi_platform_config hdmi_tx_8960_config = {
+		.phy_init = hdmi_phy_8960_init,
+		HDMI_CFG(hpd_reg, 8960),
+		HDMI_CFG(hpd_clk, 8960),
+};
+
+static const char *pwr_reg_names_8x74[] = {"core-vdda", "core-vcc"};
+static const char *hpd_reg_names_8x74[] = {"hpd-gdsc", "hpd-5v"};
+static const char *pwr_clk_names_8x74[] = {"extp_clk", "alt_iface_clk"};
+static const char *hpd_clk_names_8x74[] = {"iface_clk", "core_clk", "mdp_core_clk"};
+static unsigned long hpd_clk_freq_8x74[] = {0, 19200000, 0};
+
+static struct hdmi_platform_config hdmi_tx_8074_config = {
+		.phy_init = hdmi_phy_8x74_init,
+		HDMI_CFG(pwr_reg, 8x74),
+		HDMI_CFG(hpd_reg, 8x74),
+		HDMI_CFG(pwr_clk, 8x74),
+		HDMI_CFG(hpd_clk, 8x74),
+		.hpd_freq      = hpd_clk_freq_8x74,
+};
+
+static const char *hpd_reg_names_8084[] = {"hpd-gdsc", "hpd-5v", "hpd-5v-en"};
+
+static struct hdmi_platform_config hdmi_tx_8084_config = {
+		.phy_init = hdmi_phy_8x74_init,
+		HDMI_CFG(pwr_reg, 8x74),
+		HDMI_CFG(hpd_reg, 8084),
+		HDMI_CFG(pwr_clk, 8x74),
+		HDMI_CFG(hpd_clk, 8x74),
+		.hpd_freq      = hpd_clk_freq_8x74,
+};
+
+static const struct of_device_id dt_match[] = {
+	{ .compatible = "qcom,hdmi-tx-8084", .data = &hdmi_tx_8084_config },
+	{ .compatible = "qcom,hdmi-tx-8074", .data = &hdmi_tx_8074_config },
+	{ .compatible = "qcom,hdmi-tx-8960", .data = &hdmi_tx_8960_config },
+	{ .compatible = "qcom,hdmi-tx-8660", .data = &hdmi_tx_8660_config },
+	{}
+};
+
 #ifdef CONFIG_OF
 static int get_gpio(struct device *dev, struct device_node *of_node, const char *name)
 {
@@ -314,63 +366,28 @@ static int hdmi_bind(struct device *dev, struct device *master, void *data)
 	struct drm_device *drm = dev_get_drvdata(master);
 	struct msm_drm_private *priv = drm->dev_private;
 	static struct hdmi_platform_config config = {};
+	static struct hdmi_platform_config *hdmi_cfg;
 	struct hdmi *hdmi;
 #ifdef CONFIG_OF
 	struct device_node *of_node = dev->of_node;
+	const struct of_device_id *match;
 
-	if (of_device_is_compatible(of_node, "qcom,hdmi-tx-8074")) {
-		static const char *hpd_reg_names[] = {"hpd-gdsc", "hpd-5v"};
-		static const char *pwr_reg_names[] = {"core-vdda", "core-vcc"};
-		static const char *hpd_clk_names[] = {"iface_clk", "core_clk", "mdp_core_clk"};
-		static unsigned long hpd_clk_freq[] = {0, 19200000, 0};
-		static const char *pwr_clk_names[] = {"extp_clk", "alt_iface_clk"};
-		config.phy_init      = hdmi_phy_8x74_init;
-		config.hpd_reg_names = hpd_reg_names;
-		config.hpd_reg_cnt   = ARRAY_SIZE(hpd_reg_names);
-		config.pwr_reg_names = pwr_reg_names;
-		config.pwr_reg_cnt   = ARRAY_SIZE(pwr_reg_names);
-		config.hpd_clk_names = hpd_clk_names;
-		config.hpd_freq      = hpd_clk_freq;
-		config.hpd_clk_cnt   = ARRAY_SIZE(hpd_clk_names);
-		config.pwr_clk_names = pwr_clk_names;
-		config.pwr_clk_cnt   = ARRAY_SIZE(pwr_clk_names);
-	} else if (of_device_is_compatible(of_node, "qcom,hdmi-tx-8084")) {
-		static const char *hpd_reg_names[] = {"hpd-gdsc", "hpd-5v", "hpd-5v-en"};
-		static const char *pwr_reg_names[] = {"core-vdda", "core-vcc"};
-		static const char *hpd_clk_names[] = {"iface_clk", "core_clk", "mdp_core_clk"};
-		static unsigned long hpd_clk_freq[] = {0, 19200000, 0};
-		static const char *pwr_clk_names[] = {"extp_clk", "alt_iface_clk"};
-		config.phy_init      = hdmi_phy_8x74_init;
-		config.hpd_reg_names = hpd_reg_names;
-		config.hpd_reg_cnt   = ARRAY_SIZE(hpd_reg_names);
-		config.pwr_reg_names = pwr_reg_names;
-		config.pwr_reg_cnt   = ARRAY_SIZE(pwr_reg_names);
-		config.hpd_clk_names = hpd_clk_names;
-		config.hpd_freq      = hpd_clk_freq;
-		config.hpd_clk_cnt   = ARRAY_SIZE(hpd_clk_names);
-		config.pwr_clk_names = pwr_clk_names;
-		config.pwr_clk_cnt   = ARRAY_SIZE(pwr_clk_names);
-	} else if (of_device_is_compatible(of_node, "qcom,hdmi-tx-8960")) {
-		static const char *hpd_clk_names[] = {"core_clk", "master_iface_clk", "slave_iface_clk"};
-		static const char *hpd_reg_names[] = {"core-vdda", "hdmi-mux"};
-		config.phy_init      = hdmi_phy_8960_init;
-		config.hpd_reg_names = hpd_reg_names;
-		config.hpd_reg_cnt   = ARRAY_SIZE(hpd_reg_names);
-		config.hpd_clk_names = hpd_clk_names;
-		config.hpd_clk_cnt   = ARRAY_SIZE(hpd_clk_names);
-	} else if (of_device_is_compatible(of_node, "qcom,hdmi-tx-8660")) {
-		config.phy_init      = hdmi_phy_8x60_init;
+	match = of_match_node(dt_match, of_node);
+	if (match && match->data) {
+		hdmi_cfg = (struct hdmi_platform_config *)match->data;
+		DBG("hdmi phy: %s", match->compatible);
 	} else {
+		hdmi_cfg = &config;
 		dev_err(dev, "unknown phy: %s\n", of_node->name);
 	}
 
-	config.mmio_name     = "core_physical";
-	config.ddc_clk_gpio  = get_gpio(dev, of_node, "qcom,hdmi-tx-ddc-clk");
-	config.ddc_data_gpio = get_gpio(dev, of_node, "qcom,hdmi-tx-ddc-data");
-	config.hpd_gpio      = get_gpio(dev, of_node, "qcom,hdmi-tx-hpd");
-	config.mux_en_gpio   = get_gpio(dev, of_node, "qcom,hdmi-tx-mux-en");
-	config.mux_sel_gpio  = get_gpio(dev, of_node, "qcom,hdmi-tx-mux-sel");
-	config.mux_lpm_gpio  = get_gpio(dev, of_node, "qcom,hdmi-tx-mux-lpm");
+	hdmi_cfg->mmio_name     = "core_physical";
+	hdmi_cfg->ddc_clk_gpio  = get_gpio(dev, of_node, "qcom,hdmi-tx-ddc-clk");
+	hdmi_cfg->ddc_data_gpio = get_gpio(dev, of_node, "qcom,hdmi-tx-ddc-data");
+	hdmi_cfg->hpd_gpio      = get_gpio(dev, of_node, "qcom,hdmi-tx-hpd");
+	hdmi_cfg->mux_en_gpio   = get_gpio(dev, of_node, "qcom,hdmi-tx-mux-en");
+	hdmi_cfg->mux_sel_gpio  = get_gpio(dev, of_node, "qcom,hdmi-tx-mux-sel");
+	hdmi_cfg->mux_lpm_gpio  = get_gpio(dev, of_node, "qcom,hdmi-tx-mux-lpm");
 
 #else
 	static const char *hpd_clk_names[] = {
@@ -418,12 +435,15 @@ static int hdmi_bind(struct device *dev, struct device *master, void *data)
 		config.mux_en_gpio   = -1;
 		config.mux_sel_gpio  = -1;
 	}
+	hdmi_cfg = &config;
 #endif
-	dev->platform_data = &config;
+	dev->platform_data = hdmi_cfg;
+
 	hdmi = hdmi_init(to_platform_device(dev));
 	if (IS_ERR(hdmi))
 		return PTR_ERR(hdmi);
 	priv->hdmi = hdmi;
+
 	return 0;
 }
 
@@ -454,14 +474,6 @@ static int hdmi_dev_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static const struct of_device_id dt_match[] = {
-	{ .compatible = "qcom,hdmi-tx-8084" },
-	{ .compatible = "qcom,hdmi-tx-8074" },
-	{ .compatible = "qcom,hdmi-tx-8960" },
-	{ .compatible = "qcom,hdmi-tx-8660" },
-	{}
-};
-
 static struct platform_driver hdmi_driver = {
 	.probe = hdmi_dev_probe,
 	.remove = hdmi_dev_remove,
-- 
Qualcomm Innovation Center, Inc.

The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project

