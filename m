Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741AbaETN5P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 09:57:15 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54698 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932083AbaETN5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 09:57:07 -0400
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: dri-devel@lists.freedesktop.org, airlied@linux.ie,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH v3 06/16] drm: sti: add TVOut driver
Date: Tue, 20 May 2014 15:56:16 +0200
Message-Id: <1400594186-8956-7-git-send-email-benjamin.gaignard@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400594186-8956-1-git-send-email-benjamin.gaignard@linaro.org>
References: <1400594186-8956-1-git-send-email-benjamin.gaignard@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TVout hardware block is responsible to dispatch the data flow coming
from compositor block to any of the output (HDMI or Analog TV).
It control when output are start/stop and configure according the
require flow path.

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
---
 drivers/gpu/drm/sti/Makefile    |   3 +-
 drivers/gpu/drm/sti/sti_hda.c   | 372 +++++++++++++++++++++
 drivers/gpu/drm/sti/sti_hda.h   |  14 +
 drivers/gpu/drm/sti/sti_hdmi.c  | 542 +++++++++++++++++++++++++++++++
 drivers/gpu/drm/sti/sti_hdmi.h  |   3 +
 drivers/gpu/drm/sti/sti_tvout.c | 702 ++++++++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/sti/sti_tvout.h | 105 ++++++
 7 files changed, 1740 insertions(+), 1 deletion(-)
 create mode 100644 drivers/gpu/drm/sti/sti_hda.h
 create mode 100644 drivers/gpu/drm/sti/sti_tvout.c
 create mode 100644 drivers/gpu/drm/sti/sti_tvout.h

diff --git a/drivers/gpu/drm/sti/Makefile b/drivers/gpu/drm/sti/Makefile
index aa69ea0..45536c3 100644
--- a/drivers/gpu/drm/sti/Makefile
+++ b/drivers/gpu/drm/sti/Makefile
@@ -1,6 +1,7 @@
 ccflags-y := -Iinclude/drm
 
-stidrm-y := sti_hdmi.o \
+stidrm-y :=	sti_tvout.o \
+			sti_hdmi.o \
 			sti_hdmi_tx3g0c55phy.o \
 			sti_hdmi_tx3g4c28phy.o \
 			sti_hda.o \
diff --git a/drivers/gpu/drm/sti/sti_hda.c b/drivers/gpu/drm/sti/sti_hda.c
index 315aa0e..dc55ed7 100644
--- a/drivers/gpu/drm/sti/sti_hda.c
+++ b/drivers/gpu/drm/sti/sti_hda.c
@@ -11,6 +11,8 @@
 
 #include <drm/drmP.h>
 
+#include "sti_hda.h"
+
 /* HDformatter registers */
 #define HDA_ANA_CFG                     0x0000
 #define HDA_ANA_SCALE_CTRL_Y            0x0004
@@ -372,6 +374,376 @@ static int sti_hda_get_modes(struct drm_connector *drm_connector)
 	return count;
 }
 
+/*
+ * Start hd analog
+ *
+ * @connector: pointer on the tvout HD analog connector
+ *
+ * Return 0 on success
+ */
+static int sti_hda_start(struct sti_tvout_connector *connector)
+{
+	struct sti_hda *hda = (struct sti_hda *)connector->priv;
+	u32 val, i, mode_idx;
+	u32 src_filter_y, src_filter_c;
+	u32 *coef_y, *coef_c;
+	u32 filter_mode;
+
+	DRM_DEBUG_DRIVER("\n");
+
+	/* Prepare/enable clocks */
+	if (clk_prepare_enable(hda->clk_pix))
+		DRM_ERROR("Failed to prepare/enable hda_pix clk\n");
+	if (clk_prepare_enable(hda->clk_hddac))
+		DRM_ERROR("Failed to prepare/enable hda_hddac clk\n");
+
+	hda->enabled = true;
+
+	if (!hda_get_mode_idx(hda->mode, &mode_idx)) {
+		DRM_ERROR("Undefined mode\n");
+		return 1;
+	}
+
+	switch (hda_supported_modes[mode_idx].vid_cat) {
+	case VID_HD_148M:
+		DRM_ERROR("Beyond HD analog capabilities\n");
+		return 1;
+	case VID_HD_74M:
+		/* HD use alternate 2x filter */
+		filter_mode = CFG_AWG_FLTR_MODE_HD;
+		src_filter_y = HDA_ANA_SRC_Y_CFG_ALT_2X;
+		src_filter_c = HDA_ANA_SRC_C_CFG_ALT_2X;
+		coef_y = coef_y_alt_2x;
+		coef_c = coef_c_alt_2x;
+		break;
+	case VID_ED:
+		/* ED uses 4x filter */
+		filter_mode = CFG_AWG_FLTR_MODE_ED;
+		src_filter_y = HDA_ANA_SRC_Y_CFG_4X;
+		src_filter_c = HDA_ANA_SRC_C_CFG_4X;
+		coef_y = coef_yc_4x;
+		coef_c = coef_yc_4x;
+		break;
+	case VID_SD:
+		DRM_ERROR("Not supported\n");
+		return 1;
+	default:
+		DRM_ERROR("Undefined resolution\n");
+		return 1;
+	}
+	DRM_DEBUG_DRIVER("Using HDA mode #%d\n", mode_idx);
+
+	/* Enable HD Video DACs */
+	hda_enable_hd_dacs(hda, true);
+
+	/* Configure scaler */
+	writel(SCALE_CTRL_Y_DFLT, hda->regs + HDA_ANA_SCALE_CTRL_Y);
+	writel(SCALE_CTRL_CB_DFLT, hda->regs + HDA_ANA_SCALE_CTRL_CB);
+	writel(SCALE_CTRL_CR_DFLT, hda->regs + HDA_ANA_SCALE_CTRL_CR);
+
+	/* Configure sampler */
+	writel(src_filter_y, hda->regs + HDA_ANA_SRC_Y_CFG);
+	writel(src_filter_c, hda->regs + HDA_ANA_SRC_C_CFG);
+	for (i = 0; i < SAMPLER_COEF_NB; i++) {
+		writel(coef_y[i], hda->regs + HDA_COEFF_Y_PH1_TAP123 + i * 4);
+		writel(coef_c[i], hda->regs + HDA_COEFF_C_PH1_TAP123 + i * 4);
+	}
+
+	/* Configure main HDFormatter */
+	val = 0;
+	val |= (hda->mode.flags & DRM_MODE_FLAG_INTERLACE) ?
+	    0 : CFG_AWG_ASYNC_VSYNC_MTD;
+	val |= (CFG_PBPR_SYNC_OFF_VAL << CFG_PBPR_SYNC_OFF_SHIFT);
+	val |= filter_mode;
+	writel(val, hda->regs + HDA_ANA_CFG);
+
+	/* Configure AWG */
+	sti_hda_configure_awg(hda, hda_supported_modes[mode_idx].awg_instr,
+			      hda_supported_modes[mode_idx].nb_instr);
+
+	/* Enable AWG */
+	hda_reg_writemask(hda->regs + HDA_ANA_CFG, 1, CFG_AWG_ASYNC_EN);
+
+	return 0;
+}
+
+/*
+ * Stop HD analog
+ *
+ * @connector: pointer on the tvout HD analog connector
+ */
+static void sti_hda_stop(struct sti_tvout_connector *connector)
+{
+	struct sti_hda *hda = (struct sti_hda *)connector->priv;
+
+	if (!hda->enabled)
+		return;
+
+	DRM_DEBUG_DRIVER("\n");
+
+	/* Disable HD DAC and AWG */
+	hda_reg_writemask(hda->regs + HDA_ANA_CFG, 0, CFG_AWG_ASYNC_EN);
+	hda_enable_hd_dacs(hda, false);
+
+	/* Disable/unprepare hda clock */
+	clk_disable_unprepare(hda->clk_hddac);
+	clk_disable_unprepare(hda->clk_pix);
+
+	hda->enabled = false;
+}
+
+/*
+ * Check if the drm display mode in supported by the HD analog
+ *
+ * @connector: pointer on the tvout HD analog connector
+ * @mode: drm display mode
+ *
+ * Return 0 if supported
+ */
+#define CLK_TOLERANCE_HZ 50
+static int sti_hda_check_mode(struct sti_tvout_connector *connector,
+			      struct drm_display_mode *mode)
+{
+	struct sti_hda *hda = (struct sti_hda *)connector->priv;
+	int target = mode->clock * 1000;
+	int target_min = target - CLK_TOLERANCE_HZ;
+	int target_max = target + CLK_TOLERANCE_HZ;
+	int result;
+	int idx;
+
+	if (!hda_get_mode_idx(*mode, &idx)) {
+		return 1;
+	} else {
+		result = clk_round_rate(hda->clk_pix, target);
+
+		DRM_DEBUG_DRIVER("target rate = %d => available rate = %d\n",
+				 target, result);
+
+		if ((result < target_min) || (result > target_max)) {
+			DRM_DEBUG_DRIVER("hda pixclk=%d not supported\n",
+					 target);
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * Set the drm display mode in the local structure
+ *
+ * @connector: pointer on the tvout HD analog connector
+ * @mode: drm display mode
+ *
+ * Return 0 on success
+ */
+static int sti_hda_set_mode(struct sti_tvout_connector *connector,
+			    struct drm_display_mode *mode)
+{
+	struct sti_hda *hda = (struct sti_hda *)connector->priv;
+	u32 mode_idx;
+	int hddac_rate;
+	int ret;
+
+	DRM_DEBUG_DRIVER("\n");
+
+	memcpy(&hda->mode, mode, sizeof(struct drm_display_mode));
+
+	if (!hda_get_mode_idx(hda->mode, &mode_idx)) {
+		DRM_ERROR("Undefined mode\n");
+		return 1;
+	}
+
+	switch (hda_supported_modes[mode_idx].vid_cat) {
+	case VID_HD_74M:
+		/* HD use alternate 2x filter */
+		hddac_rate = mode->clock * 1000 * 2;
+		break;
+	case VID_ED:
+		/* ED uses 4x filter */
+		hddac_rate = mode->clock * 1000 * 4;
+		break;
+	default:
+		DRM_ERROR("Undefined mode\n");
+		return 1;
+	}
+
+	/* HD DAC = 148.5Mhz or 108 Mhz */
+	ret = clk_set_rate(hda->clk_hddac, hddac_rate);
+	if (ret < 0) {
+		DRM_ERROR("Cannot set rate (%dHz) for hda_hddac clk\n",
+			  hddac_rate);
+		return ret;
+	}
+
+	/* HDformatter clock = compositor clock */
+	ret = clk_set_rate(hda->clk_pix, mode->clock * 1000);
+	if (ret < 0) {
+		DRM_ERROR("Cannot set rate (%dHz) for hda_pix clk\n",
+			  mode->clock * 1000);
+		return ret;
+	}
+
+	return 0;
+}
+
+/*
+ * Detect if HD analog is connected
+ *
+ * @connector: pointer on the tvout HD analog connector
+ *
+ * Return true if HD analog cable is connected which is assumed to be always
+ * the case
+ */
+static bool sti_hda_detect(struct sti_tvout_connector *connector)
+{
+	DRM_DEBUG_DRIVER("\n");
+
+	return true;
+}
+
+/*
+ * Check if HD analog is enabled
+ *
+ * @connector: pointer on the tvout HD analog connector
+ *
+ * Return true if HD analog is enabled
+ */
+static bool sti_hda_is_enabled(struct sti_tvout_connector *connector)
+{
+	struct sti_hda *hda = (struct sti_hda *)connector->priv;
+
+	return hda->enabled;
+}
+
+/*
+ * Prepare/configure HD analog
+ *
+ * @connector: pointer on the tvout HD analog connector
+ */
+static void sti_hda_prepare(struct sti_tvout_connector *connector)
+{
+	struct sti_hda *hda = (struct sti_hda *)connector->priv;
+
+	DRM_DEBUG_DRIVER("\n");
+
+	/* reset HDF  */
+	writel(0x00000000, hda->regs + HDA_ANA_CFG);
+	writel(0x00000000, hda->regs + HDA_ANA_ANC_CTRL);
+}
+
+/*
+ * Debugfs
+ */
+
+#define HDA_DBG_DUMP(reg) seq_printf(m, "\n %-25s 0x%08X", #reg, \
+		readl(hda->regs + reg))
+
+static void hda_dbg_cfg(struct seq_file *m, int val)
+{
+	seq_puts(m, "\t AWG ");
+	seq_puts(m, val & CFG_AWG_ASYNC_EN ? "enabled" : "disabled");
+}
+
+static void hda_dbg_awgi(struct seq_file *m, void __iomem *reg)
+{
+	int i;
+
+	seq_puts(m, "\n HDA_SYNC_AWGI             ");
+	for (i = 0; i < 10; i++)
+		seq_printf(m, "%04X ", readl(reg + i * 4));
+	seq_puts(m, "...");
+}
+
+static void hda_dbg_video_dacs_ctrl(struct seq_file *m, void __iomem *reg)
+{
+	u32 val = readl(reg);
+	u32 mask;
+
+	switch ((u32)reg & VIDEO_DACS_CONTROL_MASK) {
+	case VIDEO_DACS_CONTROL_SYSCFG2535:
+		mask = DAC_CFG_HD_OFF_MASK;
+		break;
+	case VIDEO_DACS_CONTROL_SYSCFG5072:
+		mask = DAC_CFG_HD_HZUVW_OFF_MASK;
+		break;
+	default:
+		DRM_INFO("Video DACS control register not supported!");
+		return;
+	}
+
+	seq_puts(m, "\n");
+
+	seq_printf(m, "\n %-25s 0x%08X", "VIDEO_DACS_CONTROL", val);
+	seq_puts(m, "\tHD DACs ");
+	seq_puts(m, val & mask ? "disabled" : "enabled");
+}
+
+static void sti_hda_dbg_show(struct sti_tvout_connector *connector,
+			     struct seq_file *m)
+{
+	struct sti_hda *hda = (struct sti_hda *)connector->priv;
+
+	seq_puts(m, "\n");
+	seq_printf(m, "\nHD Analog: (virt base addr = 0x%p)", hda->regs);
+	HDA_DBG_DUMP(HDA_ANA_CFG);
+	hda_dbg_cfg(m, readl(hda->regs + HDA_ANA_CFG));
+	HDA_DBG_DUMP(HDA_ANA_SCALE_CTRL_Y);
+	HDA_DBG_DUMP(HDA_ANA_SCALE_CTRL_CB);
+	HDA_DBG_DUMP(HDA_ANA_SCALE_CTRL_CR);
+	HDA_DBG_DUMP(HDA_ANA_ANC_CTRL);
+	HDA_DBG_DUMP(HDA_ANA_SRC_Y_CFG);
+	HDA_DBG_DUMP(HDA_ANA_SRC_C_CFG);
+	hda_dbg_awgi(m, hda->regs + HDA_SYNC_AWGI);
+	if (hda->video_dacs_ctrl)
+		hda_dbg_video_dacs_ctrl(m, hda->video_dacs_ctrl);
+}
+
+/*
+ * create the HD analog output
+ *
+ * @tvout: pointer on the tvout information
+ *
+ * Return pointer on the created tvout connector or NULL if error occurs
+ */
+struct sti_tvout_connector *sti_hda_create(struct sti_tvout *tvout)
+{
+	struct sti_hda *hda = container_of(hda_dev, struct sti_hda, dev);
+	struct device *dev = &hda->dev;
+	struct sti_tvout_connector *connector;
+
+	DRM_DEBUG_DRIVER("\n");
+
+	if (!hda) {
+		DRM_INFO("%s: No hda device probed\n", __func__);
+		return NULL;
+	}
+
+	connector = devm_kzalloc(dev, sizeof(*connector), GFP_KERNEL);
+	if (!connector) {
+		DRM_ERROR("Failed to allocate memory for connector\n");
+		goto connector_alloc_failed;
+	}
+
+	/* Set the drm device handle */
+	hda->drm_dev = tvout->drm_dev;
+
+	connector->priv = (void *)hda;
+	connector->start = sti_hda_start;
+	connector->stop = sti_hda_stop;
+	connector->get_modes = sti_hda_get_modes;
+	connector->check_mode = sti_hda_check_mode;
+	connector->set_mode = sti_hda_set_mode;
+	connector->detect = sti_hda_detect;
+	connector->is_enabled = sti_hda_is_enabled;
+	connector->prepare = sti_hda_prepare;
+	connector->dbg_show = sti_hda_dbg_show;
+
+	return connector;
+
+connector_alloc_failed:
+	return NULL;
+}
 
 static int sti_hda_bind(struct device *dev, struct device *master, void *data)
 {
diff --git a/drivers/gpu/drm/sti/sti_hda.h b/drivers/gpu/drm/sti/sti_hda.h
new file mode 100644
index 0000000..e88b30e
--- /dev/null
+++ b/drivers/gpu/drm/sti/sti_hda.h
@@ -0,0 +1,14 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2014
+ * Authors: Fabien Dessenne <fabien.dessenne@st.com> for STMicroelectronics.
+ * License terms: GNU General Public License (GPL), version 2
+ */
+
+#ifndef _STI_HDA_H_
+#define _STI_HDA_H_
+
+#include "sti_tvout.h"
+
+struct sti_tvout_connector *sti_hda_create(struct sti_tvout *tvout);
+
+#endif
diff --git a/drivers/gpu/drm/sti/sti_hdmi.c b/drivers/gpu/drm/sti/sti_hdmi.c
index 02b0524..1cb79d5 100644
--- a/drivers/gpu/drm/sti/sti_hdmi.c
+++ b/drivers/gpu/drm/sti/sti_hdmi.c
@@ -380,6 +380,548 @@ fail:
 	return -1;
 }
 
+/*
+ * Start hdmi
+ *
+ * @connector: pointer on the tvout hdmi connector
+ *
+ * Return -1 if error occurs
+ */
+static int sti_hdmi_start(struct sti_tvout_connector *connector)
+{
+	struct sti_hdmi *hdmi = (struct sti_hdmi *)connector->priv;
+	int ret = 0;
+
+	DRM_DEBUG_DRIVER("\n");
+
+	/* Prepare/enable clocks */
+	if (clk_prepare_enable(hdmi->clk_pix))
+		DRM_ERROR("Failed to prepare/enable hdmi_pix clk\n");
+	if (clk_prepare_enable(hdmi->clk_tmds))
+		DRM_ERROR("Failed to prepare/enable hdmi_tmds clk\n");
+	if (clk_prepare_enable(hdmi->clk_phy))
+		DRM_ERROR("Failed to prepare/enable hdmi_rejec_pll clk\n");
+
+	hdmi->enabled = true;
+
+	/* Program hdmi serializer and start phy */
+	ret = hdmi_phy_start(hdmi);
+	if (ret) {
+		DRM_ERROR("Unable to start hdmi phy\n");
+		return ret;
+	}
+
+	/* Program hdmi active area */
+	hdmi_active_area(hdmi);
+
+	/* Enable working interrupts */
+	writel(HDMI_WORKING_INT, hdmi->regs + HDMI_INT_EN);
+
+	/* Program hdmi config */
+	hdmi_config(hdmi);
+
+	/* Program AVI infoframe */
+	ret = hdmi_avi_infoframe_config(hdmi);
+	if (ret)
+		DRM_ERROR("Unable to configure AVI infoframe\n");
+
+	/* Sw reset */
+	ret = hdmi_swreset(hdmi);
+	if (ret)
+		DRM_ERROR("Unable to perform the hdmi sw reset\n");
+
+	return ret;
+}
+
+/*
+ * Stop hdmi
+ *
+ * @connector: pointer on the tvout hdmi connector
+ */
+static void sti_hdmi_stop(struct sti_tvout_connector *connector)
+{
+	struct sti_hdmi *hdmi = (struct sti_hdmi *)connector->priv;
+	u32 val;
+	u32 mask;
+
+	if (!hdmi->enabled)
+		return;
+
+	DRM_DEBUG_DRIVER("\n");
+
+	/* Disable HDMI */
+	mask = HDMI_CFG_DEVICE_EN;
+	val = ~HDMI_CFG_DEVICE_EN;
+
+	hdmi_reg_writemask(hdmi->regs + HDMI_CFG, val, mask);
+
+	/* Stop the phy */
+	hdmi_phy_stop(hdmi);
+
+	/* Disable/unprepare hdmi clock */
+	clk_disable_unprepare(hdmi->clk_phy);
+	clk_disable_unprepare(hdmi->clk_tmds);
+	clk_disable_unprepare(hdmi->clk_pix);
+
+	hdmi->enabled = false;
+}
+
+/*
+ * Check if the drm display mode in supported by the hdmi
+ *
+ * @connector: pointer on the tvout hdmi connector
+ * @mode: drm display mode
+ *
+ * Return -1 if not supported
+ */
+#define CLK_TOLERANCE_HZ 50
+static int sti_hdmi_check_mode(struct sti_tvout_connector *connector,
+			       struct drm_display_mode *mode)
+{
+	struct sti_hdmi *hdmi = (struct sti_hdmi *)connector->priv;
+	int target = mode->clock * 1000;
+	int target_min = target - CLK_TOLERANCE_HZ;
+	int target_max = target + CLK_TOLERANCE_HZ;
+	int result;
+
+	result = clk_round_rate(hdmi->clk_pix, target);
+
+	DRM_DEBUG_DRIVER("target rate = %d => available rate = %d\n",
+			 target, result);
+
+	if ((result < target_min) || (result > target_max)) {
+		DRM_DEBUG_DRIVER("hdmi pixclk=%d not supported\n", target);
+		return -1;
+	}
+
+	return 0;
+}
+
+/*
+ * Set the drm display mode in the local structure
+ *
+ * @connector: pointer on the tvout hdmi connector
+ * @mode: drm display mode
+ *
+ * Return -1 if error occurs
+ */
+/* FS bits */
+static int sti_hdmi_set_mode(struct sti_tvout_connector *connector,
+			     struct drm_display_mode *mode)
+{
+	struct sti_hdmi *hdmi = (struct sti_hdmi *)connector->priv;
+	int ret;
+
+	DRM_DEBUG_DRIVER("\n");
+
+	/* Copy the drm display mode in the connector local structure */
+	memcpy(&hdmi->mode, mode, sizeof(struct drm_display_mode));
+
+	/* Update clock framerate according to the selected mode */
+	ret = clk_set_rate(hdmi->clk_pix, mode->clock * 1000);
+	if (ret < 0) {
+		DRM_ERROR("Cannot set rate (%dHz) for hdmi_pix clk\n",
+			  mode->clock * 1000);
+		return ret;
+	}
+	ret = clk_set_rate(hdmi->clk_phy, mode->clock * 1000);
+	if (ret < 0) {
+		DRM_ERROR("Cannot set rate (%dHz) for hdmi_rejection_pll clk\n",
+			  mode->clock * 1000);
+		return ret;
+	}
+
+	return 0;
+}
+
+/*
+ * Detect if hdmi is connected
+ *
+ * @connector: pointer on the tvout hdmi connector
+ *
+ * Return true if hdmi cable is connected
+ */
+static bool sti_hdmi_detect(struct sti_tvout_connector *connector)
+{
+	struct sti_hdmi *hdmi = (struct sti_hdmi *)connector->priv;
+
+	DRM_DEBUG_DRIVER("\n");
+
+	if (hdmi->hpd) {
+		DRM_DEBUG_DRIVER("hdmi cable connected\n");
+		return true;
+	} else
+		DRM_DEBUG_DRIVER("hdmi cable disconnected\n");
+
+	return false;
+}
+
+/*
+ * Check if hdmi is enabled
+ *
+ * @connector: pointer on the tvout hdmi connector
+ *
+ * Return true if hdmi is enabled
+ */
+static bool sti_hdmi_is_enabled(struct sti_tvout_connector *connector)
+{
+	struct sti_hdmi *hdmi = (struct sti_hdmi *)connector->priv;
+
+	return hdmi->enabled;
+}
+
+/*
+ * Prepare/configure hdmi
+ *
+ * @connector: pointer on the tvout hdmi connector
+ */
+static void sti_hdmi_prepare(struct sti_tvout_connector *connector)
+{
+	struct sti_hdmi *hdmi = (struct sti_hdmi *)connector->priv;
+
+	DRM_DEBUG_DRIVER("\n");
+
+	/* HDMI initialisation */
+	writel(0x00000000, hdmi->regs + HDMI_CFG);
+	writel(0xffffffff, hdmi->regs + HDMI_INT_CLR);
+
+	/* Ensure the PHY is completely powered down */
+	hdmi_phy_stop(hdmi);
+
+	/* Set the default channel data to be a dark red */
+	writel(0x0000, hdmi->regs + HDMI_DFLT_CHL0_DAT);
+	writel(0x0000, hdmi->regs + HDMI_DFLT_CHL1_DAT);
+	writel(0x0060, hdmi->regs + HDMI_DFLT_CHL2_DAT);
+}
+
+/*
+ * Debugfs
+ */
+#define HDMI_DBG_DUMP(reg) seq_printf(m, "\n %-25s 0x%08X", #reg, \
+		readl(hdmi->regs + reg))
+#define HDMI_DBG_DUMP_DI(reg, slot) HDMI_DBG_DUMP(reg(slot))
+#define MAX_STRING_LENGTH 40
+
+static void hdmi_dbg_cfg(struct seq_file *m, int val)
+{
+	int tmp;
+	char str[MAX_STRING_LENGTH];
+	static const char *const mode[] = { "DVI", "HDMI" };
+	static const char *const enable[] = { "disable", "enable" };
+	static const char *const oess_ess[] = { "OESS enable", "ESS enable" };
+	static const char *const polarity[] = { "normal", "inverted" };
+
+	seq_puts(m, "\t");
+
+	tmp = (val & HDMI_CFG_HDMI_NOT_DVI) >> HDMI_CFG_HDMI_NOT_DVI_SHIFT;
+	snprintf(str, MAX_STRING_LENGTH, "mode: %s", mode[tmp]);
+	seq_printf(m, "%-40s", str);
+
+	tmp = (val & HDMI_CFG_HDCP_EN) >> HDMI_CFG_HDCP_EN_SHIFT;
+	snprintf(str, MAX_STRING_LENGTH, "HDCP: %s", enable[tmp]);
+	seq_printf(m, "%-40s", str);
+
+	tmp = (val & HDMI_CFG_ESS_NOT_OESS) >> HDMI_CFG_ESS_NOT_OESS_SHIFT;
+	snprintf(str, MAX_STRING_LENGTH, "HDCP mode: %s", oess_ess[tmp]);
+	seq_printf(m, "%-40s", str);
+
+	seq_printf(m, "\n%-40s", "");
+
+	tmp = (val & HDMI_CFG_SINK_TERM_DET_EN) >>
+	    HDMI_CFG_SINK_TERM_DET_EN_SHIFT;
+	snprintf(str, MAX_STRING_LENGTH,
+		 "Sink term detection: %s", enable[tmp]);
+	seq_printf(m, "%-40s", str);
+
+	tmp = (val & HDMI_CFG_H_SYNC_POL_NEG) >> HDMI_CFG_H_SYNC_POL_NEG_SHIFT;
+	snprintf(str, MAX_STRING_LENGTH, "Hsync polarity: %s", polarity[tmp]);
+	seq_printf(m, "%-40s", str);
+
+	tmp = (val & HDMI_CFG_V_SYNC_POL_NEG) >> HDMI_CFG_V_SYNC_POL_NEG_SHIFT;
+	snprintf(str, MAX_STRING_LENGTH, "Vsync polarity: %s", polarity[tmp]);
+	seq_printf(m, "%-40s", str);
+
+	seq_printf(m, "\n%-40s", "");
+
+	tmp = (val & HDMI_CFG_422_EN) >> HDMI_CFG_422_EN_SHIFT;
+	snprintf(str, MAX_STRING_LENGTH, "YUV422 format: %s", enable[tmp]);
+	seq_printf(m, "%-40s", str);
+}
+
+static void hdmi_dbg_sta(struct seq_file *m, int val)
+{
+	int tmp;
+	char str[MAX_STRING_LENGTH];
+	static const char *const sink_term[] = { "not present", "present" };
+	static const char *const pll_lck[] = { "not locked", "locked" };
+	static const char *const hot_plug[] = { "not connected", "connected" };
+
+	seq_puts(m, "\t");
+
+	tmp = (val & HDMI_STA_FIFO_SAMPLES) >> HDMI_STA_FIFO_SAMPLES_SHIFT;
+	snprintf(str, MAX_STRING_LENGTH, "fifo: %d samples", tmp);
+	seq_printf(m, "%-40s", str);
+
+	tmp = (val & HDMI_STA_SINK_TERM) >> HDMI_STA_SINK_TERM_SHIFT;
+	snprintf(str, MAX_STRING_LENGTH, "sink term: %s", sink_term[tmp]);
+	seq_printf(m, "%-40s", str);
+
+	tmp = (val & HDMI_STA_DLL_LCK) >> HDMI_STA_DLL_LCK_SHIFT;
+	snprintf(str, MAX_STRING_LENGTH, "pll: %s", pll_lck[tmp]);
+	seq_printf(m, "%-40s", str);
+
+	seq_printf(m, "\n%-40s", "");
+
+	tmp = (val & HDMI_STA_HOT_PLUG) >> HDMI_STA_HOT_PLUG_SHIFT;
+	snprintf(str, MAX_STRING_LENGTH, "hdmi cable: %s", hot_plug[tmp]);
+	seq_printf(m, "%-40s", str);
+}
+
+static void hdmi_dbg_sw_di_cfg(struct seq_file *m, int val)
+{
+	int tmp;
+	char str[MAX_STRING_LENGTH];
+	static const char *const en_di[] = { "no transmission",
+		"single transmission", "once every field", "once every frame"
+	};
+
+	seq_puts(m, "\t");
+
+	tmp = (val & HDMI_IFRAME_CFG_DI_N(HDMI_IFRAME_MASK, 1));
+	snprintf(str, MAX_STRING_LENGTH, "Data island 1: %s", en_di[tmp]);
+	seq_printf(m, "%-40s", str);
+
+	tmp = (val & HDMI_IFRAME_CFG_DI_N(HDMI_IFRAME_MASK, 2)) >> 4;
+	snprintf(str, MAX_STRING_LENGTH, "Data island 2: %s", en_di[tmp]);
+	seq_printf(m, "%-40s", str);
+
+	tmp = (val & HDMI_IFRAME_CFG_DI_N(HDMI_IFRAME_MASK, 3)) >> 8;
+	snprintf(str, MAX_STRING_LENGTH, "Data island 3: %s", en_di[tmp]);
+	seq_printf(m, "%-40s", str);
+
+	seq_printf(m, "\n%-40s", "");
+
+	tmp = (val & HDMI_IFRAME_CFG_DI_N(HDMI_IFRAME_MASK, 4)) >> 12;
+	snprintf(str, MAX_STRING_LENGTH, "Data island 4: %s", en_di[tmp]);
+	seq_printf(m, "%-40s", str);
+
+	tmp = (val & HDMI_IFRAME_CFG_DI_N(HDMI_IFRAME_MASK, 5)) >> 16;
+	snprintf(str, MAX_STRING_LENGTH, "Data island 5: %s", en_di[tmp]);
+	seq_printf(m, "%-40s", str);
+
+	tmp = (val & HDMI_IFRAME_CFG_DI_N(HDMI_IFRAME_MASK, 6)) >> 20;
+	snprintf(str, MAX_STRING_LENGTH, "Data island 6: %s", en_di[tmp]);
+	seq_printf(m, "%-40s", str);
+}
+
+static void hdmi_dbg_xmin(struct seq_file *m, int val)
+{
+	seq_printf(m, "\tXmin: %4d", val & 0x0FFF);
+}
+
+static void hdmi_dbg_xmax(struct seq_file *m, int val)
+{
+	seq_printf(m, "\tXmax: %4d", val & 0x0FFF);
+}
+
+static void hdmi_dbg_ymin(struct seq_file *m, int val)
+{
+	seq_printf(m, "\tYmin: %4d", val & 0x0FFF);
+}
+
+static void hdmi_dbg_ymax(struct seq_file *m, int val)
+{
+	seq_printf(m, "\tYmax: %4d", val & 0x0FFF);
+}
+
+static void sti_hdmi_dbg_show(struct sti_tvout_connector *connector,
+			      struct seq_file *m)
+{
+	struct sti_hdmi *hdmi = (struct sti_hdmi *)connector->priv;
+	struct drm_display_mode *mode = &hdmi->mode;
+	struct hdmi_avi_infoframe info;
+	char str[MAX_STRING_LENGTH];
+
+	seq_puts(m, "\n");
+	seq_printf(m, "\nHDMI: (virt base addr = 0x%p)", hdmi->regs);
+	HDMI_DBG_DUMP(HDMI_CFG);
+	hdmi_dbg_cfg(m, readl(hdmi->regs + HDMI_CFG));
+	HDMI_DBG_DUMP(HDMI_INT_EN);
+	HDMI_DBG_DUMP(HDMI_INT_STA);
+	HDMI_DBG_DUMP(HDMI_INT_CLR);
+	HDMI_DBG_DUMP(HDMI_STA);
+	hdmi_dbg_sta(m, readl(hdmi->regs + HDMI_STA));
+	HDMI_DBG_DUMP(HDMI_ACTIVE_VID_XMIN);
+	hdmi_dbg_xmin(m, readl(hdmi->regs + HDMI_ACTIVE_VID_XMIN));
+	HDMI_DBG_DUMP(HDMI_ACTIVE_VID_XMAX);
+	hdmi_dbg_xmax(m, readl(hdmi->regs + HDMI_ACTIVE_VID_XMAX));
+	HDMI_DBG_DUMP(HDMI_ACTIVE_VID_YMIN);
+	hdmi_dbg_ymin(m, readl(hdmi->regs + HDMI_ACTIVE_VID_YMIN));
+	HDMI_DBG_DUMP(HDMI_ACTIVE_VID_YMAX);
+	hdmi_dbg_ymax(m, readl(hdmi->regs + HDMI_ACTIVE_VID_YMAX));
+	HDMI_DBG_DUMP(HDMI_DFLT_CHL0_DAT);
+	HDMI_DBG_DUMP(HDMI_DFLT_CHL1_DAT);
+	HDMI_DBG_DUMP(HDMI_DFLT_CHL2_DAT);
+	HDMI_DBG_DUMP(HDMI_SW_DI_CFG);
+	hdmi_dbg_sw_di_cfg(m, readl(hdmi->regs + HDMI_SW_DI_CFG));
+	if (hdmi->tx3g0c55phy)
+		sti_hdmi_tx3g0c55phy_show(hdmi, m);
+	else
+		sti_hdmi_tx3g4c28phy_show(hdmi, m);
+	seq_puts(m, "\n");
+
+	seq_printf(m, "\nAVI Infoframe (Data Island slot N=%d):",
+		   HDMI_IFRAME_SLOT_AVI);
+	HDMI_DBG_DUMP_DI(HDMI_SW_DI_N_HEAD_WORD, HDMI_IFRAME_SLOT_AVI);
+	HDMI_DBG_DUMP_DI(HDMI_SW_DI_N_PKT_WORD0, HDMI_IFRAME_SLOT_AVI);
+	HDMI_DBG_DUMP_DI(HDMI_SW_DI_N_PKT_WORD1, HDMI_IFRAME_SLOT_AVI);
+	HDMI_DBG_DUMP_DI(HDMI_SW_DI_N_PKT_WORD2, HDMI_IFRAME_SLOT_AVI);
+	HDMI_DBG_DUMP_DI(HDMI_SW_DI_N_PKT_WORD3, HDMI_IFRAME_SLOT_AVI);
+	HDMI_DBG_DUMP_DI(HDMI_SW_DI_N_PKT_WORD4, HDMI_IFRAME_SLOT_AVI);
+	HDMI_DBG_DUMP_DI(HDMI_SW_DI_N_PKT_WORD5, HDMI_IFRAME_SLOT_AVI);
+	HDMI_DBG_DUMP_DI(HDMI_SW_DI_N_PKT_WORD6, HDMI_IFRAME_SLOT_AVI);
+	seq_puts(m, "\n");
+	if (drm_hdmi_avi_infoframe_from_display_mode(&info, mode) == 0) {
+		static const char *const colorspace[] = {
+			"RGB", "YUV422", "YUV444" };
+		static const char *const scan_mode[] = {
+			"none", "overscan", "underscan" };
+		static const char *const colorimetry[] = {
+			"none", "ITU 601", "ITU 709", "extended" };
+		static const char *const ext_colorimetry[] = {
+			"xvYCC 601", "xvYCC 709", "S YCC 601", "Adobe YCC 601",
+			"Adobe RGB" };
+		static const char *const pict_aspect[] = {
+			"none", "4:3", "16:9" };
+		static const char *const active_aspect[] = {
+			"", "", "16:9 top", "14:9 top", "16:9 center", "", "",
+			"", "picture", "4:3", "16:9", "14:9", "", "4:3 SP 14:9",
+			"16:9 SP 14:9", "16:9 SP 4:3" };
+		static const char *const quant_range[] = {
+			"default", "4:3", "16:9" };
+		static const char *const nups[] = {
+			"unknown", "horizontal", "vertical", "both" };
+		static const char *const ycc_quant_range[] = {
+			"limited", "full" };
+		static const char *const content_type[] = {
+			"none", "photo", "cinema", "game" };
+
+		snprintf(str, MAX_STRING_LENGTH, "\tversion:");
+		seq_printf(m, "%-25s %d\n", str, info.version);
+		snprintf(str, MAX_STRING_LENGTH, "\tlength:");
+		seq_printf(m, "%-25s %d\n", str, info.length);
+		snprintf(str, MAX_STRING_LENGTH, "\tcolorspace:");
+		seq_printf(m, "%-25s %s\n", str, colorspace[info.colorspace]);
+		snprintf(str, MAX_STRING_LENGTH, "\tscan mode:");
+		seq_printf(m, "%-25s %s\n", str, scan_mode[info.scan_mode]);
+		snprintf(str, MAX_STRING_LENGTH, "\tcolorimetry:");
+		seq_printf(m, "%-25s %s\n", str, colorimetry[info.colorimetry]);
+		if (info.colorimetry == HDMI_COLORIMETRY_EXTENDED) {
+			snprintf(str, MAX_STRING_LENGTH,
+				 " extended colorimetry:");
+			seq_printf(m, "%-25s %s\n", str,
+				   ext_colorimetry[info.extended_colorimetry]);
+		}
+		snprintf(str, MAX_STRING_LENGTH, "\tpicture aspect:");
+		seq_printf(m, "%-25s %s\n", str,
+			   pict_aspect[info.picture_aspect]);
+		snprintf(str, MAX_STRING_LENGTH, "\tactive aspect:");
+		seq_printf(m, "%-25s %s\n", str,
+			   active_aspect[info.active_aspect]);
+		snprintf(str, MAX_STRING_LENGTH, "\tquantization range:");
+		seq_printf(m, "%-25s %s\n", str,
+			   quant_range[info.quantization_range]);
+		snprintf(str, MAX_STRING_LENGTH, "\tycc quantization range:");
+		seq_printf(m, "%-25s %s\n", str,
+			   ycc_quant_range[info.ycc_quantization_range]);
+		snprintf(str, MAX_STRING_LENGTH, "\tnups:");
+		seq_printf(m, "%-25s %s\n", str, nups[info.nups]);
+		snprintf(str, MAX_STRING_LENGTH, "\tpixel repeat:");
+		seq_printf(m, "%-25s %d\n", str, info.pixel_repeat);
+		snprintf(str, MAX_STRING_LENGTH, "\tactive info valid:");
+		seq_printf(m, "%-25s %s\n", str,
+			   info.pixel_repeat ? "true" : "false");
+		snprintf(str, MAX_STRING_LENGTH, "\titc:");
+		seq_printf(m, "%-25s %s\n", str, info.itc ? "true" : "false");
+		snprintf(str, MAX_STRING_LENGTH, "\ttop bar:");
+		seq_printf(m, "%-25s %d\n", str, info.top_bar);
+		snprintf(str, MAX_STRING_LENGTH, "\tbottom bar:");
+		seq_printf(m, "%-25s %d\n", str, info.bottom_bar);
+		snprintf(str, MAX_STRING_LENGTH, "\tleft bar:");
+		seq_printf(m, "%-25s %d\n", str, info.left_bar);
+		snprintf(str, MAX_STRING_LENGTH, "\tright bar:");
+		seq_printf(m, "%-25s %d\n", str, info.right_bar);
+		snprintf(str, MAX_STRING_LENGTH, "\tcontent type:");
+		seq_printf(m, "%-25s %s\n", str,
+			   content_type[info.content_type]);
+		snprintf(str, MAX_STRING_LENGTH, "\tCEA video code:");
+		seq_printf(m, "%-25s %d\n", str, info.video_code);
+	}
+
+	seq_printf(m, "\nHDMI mode: %dx%d%s @%d",
+		   hdmi->mode.hdisplay,
+		   hdmi->mode.vdisplay,
+		   (hdmi->mode.flags & DRM_MODE_FLAG_INTERLACE) ?
+		   "i" : "p", hdmi->mode.vrefresh);
+}
+
+/*
+ * create the hdmi output
+ *
+ * @tvout: pointer on the tvout information
+ *
+ * Return pointer on the created tvout connector or NULL if error occurs
+ */
+struct sti_tvout_connector *sti_hdmi_create(struct sti_tvout *tvout)
+{
+	struct sti_hdmi *hdmi = container_of(hdmi_dev, struct sti_hdmi, dev);
+	struct device *dev = &hdmi->dev;
+	struct sti_tvout_connector *connector;
+
+	DRM_DEBUG_DRIVER("\n");
+
+	if (!hdmi) {
+		DRM_INFO("%s: No hdmi device probed\n", __func__);
+		return NULL;
+	}
+
+	connector = devm_kzalloc(dev, sizeof(*connector), GFP_KERNEL);
+	if (!connector) {
+		DRM_ERROR("Failed to allocate memory for connector\n");
+		goto connector_alloc_failed;
+	}
+
+	/* Set the drm device handle */
+	hdmi->drm_dev = tvout->drm_dev;
+
+	/* DDC i2c driver */
+	if (i2c_add_driver(&ddc_driver)) {
+		DRM_ERROR("Failed to register ddc i2c driver\n");
+		goto i2c_failed;
+	}
+
+	/* Enable default interrupts */
+	writel(HDMI_DEFAULT_INT, hdmi->regs + HDMI_INT_EN);
+
+	connector->priv = (void *)hdmi;
+	connector->start = sti_hdmi_start;
+	connector->stop = sti_hdmi_stop;
+	connector->get_modes = sti_hdmi_get_modes;
+	connector->check_mode = sti_hdmi_check_mode;
+	connector->set_mode = sti_hdmi_set_mode;
+	connector->detect = sti_hdmi_detect;
+	connector->is_enabled = sti_hdmi_is_enabled;
+	connector->prepare = sti_hdmi_prepare;
+	connector->dbg_show = sti_hdmi_dbg_show;
+
+	return connector;
+
+i2c_failed:
+	devm_kfree(dev, connector);
+connector_alloc_failed:
+	return NULL;
+}
+
 static int sti_hdmi_bind(struct device *dev, struct device *master, void *data)
 {
 	return 0;
diff --git a/drivers/gpu/drm/sti/sti_hdmi.h b/drivers/gpu/drm/sti/sti_hdmi.h
index c14c683..ed90a2c 100644
--- a/drivers/gpu/drm/sti/sti_hdmi.h
+++ b/drivers/gpu/drm/sti/sti_hdmi.h
@@ -11,6 +11,8 @@
 
 #include <drm/drmP.h>
 
+#include "sti_tvout.h"
+
 /* HDMI v2.9 macro cell */
 #define HDMI_CFG                        0x0000
 #define HDMI_INT_EN                     0x0004
@@ -181,6 +183,7 @@ struct hdmi_phy_config {
 	u32 config[4];
 };
 
+struct sti_tvout_connector *sti_hdmi_create(struct sti_tvout *tvout);
 void sti_hdmi_attach_ddc_client(struct i2c_client *ddc);
 
 int sti_hdmi_tx3g0c55phy_start(struct sti_hdmi *hdmi);
diff --git a/drivers/gpu/drm/sti/sti_tvout.c b/drivers/gpu/drm/sti/sti_tvout.c
new file mode 100644
index 0000000..3e679a0
--- /dev/null
+++ b/drivers/gpu/drm/sti/sti_tvout.c
@@ -0,0 +1,702 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2013
+ * Author: Benjamin Gaignard <benjamin.gaignard@st.com> for STMicroelectronics.
+ * Author: Vincent Abriou <vincent.abriou@st.com> for STMicroelectronics
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#include <linux/clk.h>
+#include <linux/component.h>
+#include <linux/module.h>
+#include <linux/of_platform.h>
+#include <linux/platform_device.h>
+#include <linux/reset.h>
+
+#include <drm/drmP.h>
+#include <drm/drm_crtc_helper.h>
+
+#include "sti_tvout.h"
+#include "sti_hdmi.h"
+#include "sti_hda.h"
+
+/* glue regsiters */
+#define TVO_CSC_MAIN_M0                  0x000
+#define TVO_CSC_MAIN_M1                  0x004
+#define TVO_CSC_MAIN_M2                  0x008
+#define TVO_CSC_MAIN_M3                  0x00c
+#define TVO_CSC_MAIN_M4                  0x010
+#define TVO_CSC_MAIN_M5                  0x014
+#define TVO_CSC_MAIN_M6                  0x018
+#define TVO_CSC_MAIN_M7                  0x01c
+#define TVO_MAIN_IN_VID_FORMAT           0x030
+#define TVO_CSC_AUX_M0                   0x100
+#define TVO_CSC_AUX_M1                   0x104
+#define TVO_CSC_AUX_M2                   0x108
+#define TVO_CSC_AUX_M3                   0x10c
+#define TVO_CSC_AUX_M4                   0x110
+#define TVO_CSC_AUX_M5                   0x114
+#define TVO_CSC_AUX_M6                   0x118
+#define TVO_CSC_AUX_M7                   0x11c
+#define TVO_AUX_IN_VID_FORMAT            0x130
+#define TVO_VIP_HDF                      0x400
+#define TVO_HD_SYNC_SEL                  0x418
+#define TVO_HD_DAC_CFG_OFF               0x420
+#define TVO_VIP_HDMI                     0x500
+#define TVO_HDMI_FORCE_COLOR_0           0x504
+#define TVO_HDMI_FORCE_COLOR_1           0x508
+#define TVO_HDMI_CLIP_VALUE_B_CB         0x50c
+#define TVO_HDMI_CLIP_VALUE_Y_G          0x510
+#define TVO_HDMI_CLIP_VALUE_R_CR         0x514
+#define TVO_HDMI_SYNC_SEL                0x518
+#define TVO_HDMI_DFV_OBS                 0x540
+
+#define TVO_IN_FMT_SIGNED                (1 << 0)
+#define TVO_SYNC_EXT                     (1 << 4)
+
+#define TVO_VIP_REORDER_R_SHIFT          24
+#define TVO_VIP_REORDER_G_SHIFT          20
+#define TVO_VIP_REORDER_B_SHIFT          16
+#define TVO_VIP_REORDER_MASK             0x3
+#define TVO_VIP_REORDER_Y_G_SEL          0
+#define TVO_VIP_REORDER_CB_B_SEL         1
+#define TVO_VIP_REORDER_CR_R_SEL         2
+
+#define TVO_VIP_CLIP_SHIFT               8
+#define TVO_VIP_CLIP_MASK                0x7
+#define TVO_VIP_CLIP_DISABLED            0
+#define TVO_VIP_CLIP_EAV_SAV             1
+#define TVO_VIP_CLIP_LIMITED_RANGE_RGB_Y 2
+#define TVO_VIP_CLIP_LIMITED_RANGE_CB_CR 3
+#define TVO_VIP_CLIP_PROG_RANGE          4
+
+#define TVO_VIP_RND_SHIFT                4
+#define TVO_VIP_RND_MASK                 0x3
+#define TVO_VIP_RND_8BIT_ROUNDED         0
+#define TVO_VIP_RND_10BIT_ROUNDED        1
+#define TVO_VIP_RND_12BIT_ROUNDED        2
+
+#define TVO_VIP_SEL_INPUT_MASK           0xf
+#define TVO_VIP_SEL_INPUT_MAIN           0x0
+#define TVO_VIP_SEL_INPUT_AUX            0x8
+#define TVO_VIP_SEL_INPUT_FORCE_COLOR    0xf
+#define TVO_VIP_SEL_INPUT_BYPASS_MASK    0x1
+#define TVO_VIP_SEL_INPUT_BYPASSED       1
+
+#define TVO_SYNC_MAIN_VTG_SET_REF        0x00
+#define TVO_SYNC_MAIN_VTG_SET_1          0x01
+#define TVO_SYNC_MAIN_VTG_SET_2          0x02
+#define TVO_SYNC_MAIN_VTG_SET_3          0x03
+#define TVO_SYNC_MAIN_VTG_SET_4          0x04
+#define TVO_SYNC_MAIN_VTG_SET_5          0x05
+#define TVO_SYNC_MAIN_VTG_SET_6          0x06
+#define TVO_SYNC_AUX_VTG_SET_REF         0x10
+#define TVO_SYNC_AUX_VTG_SET_1           0x11
+#define TVO_SYNC_AUX_VTG_SET_2           0x12
+#define TVO_SYNC_AUX_VTG_SET_3           0x13
+#define TVO_SYNC_AUX_VTG_SET_4           0x14
+#define TVO_SYNC_AUX_VTG_SET_5           0x15
+#define TVO_SYNC_AUX_VTG_SET_6           0x16
+
+#define TVO_SYNC_HD_DCS_SHIFT            8
+
+/* Preformatter conversion matrix */
+static const u32 rgb_to_ycbcr_601[8] = {
+	0xF927082E, 0x04C9FEAB, 0x01D30964, 0xFA95FD3D,
+	0x0000082E, 0x00002000, 0x00002000, 0x00000000
+};
+
+/* 709 RGB to YCbCr */
+static const u32 rgb_to_ycbcr_709[8] = {
+	0xF891082F, 0x0367FF40, 0x01280B71, 0xF9B1FE20,
+	0x0000082F, 0x00002000, 0x00002000, 0x00000000
+};
+
+/*
+ * Helper to write bit field
+ *
+ * @addr: register to update
+ * @val: value to write
+ * @mask: bit field mask to use
+ */
+static inline void tvout_reg_writemask(void __iomem *addr, u32 val, u32 mask)
+{
+	u32 old = readl(addr);
+
+	val = (val & mask) | (old & ~mask);
+	writel(val, addr);
+}
+
+/*
+ * Set the Channel order of a VIP
+ *
+ * @vip_reg: VIP regsiter
+ * @cr_r
+ * @y_g
+ * @cb_c : values for each output
+ */
+static void tvout_vip_set_color_order(void __iomem *vip_reg,
+				      u32 cr_r, u32 y_g, u32 cb_b)
+{
+	u32 val, mask;
+
+	mask = TVO_VIP_REORDER_MASK << TVO_VIP_REORDER_R_SHIFT;
+	mask |= TVO_VIP_REORDER_MASK << TVO_VIP_REORDER_G_SHIFT;
+	mask |= TVO_VIP_REORDER_MASK << TVO_VIP_REORDER_B_SHIFT;
+	val = cr_r << TVO_VIP_REORDER_R_SHIFT;
+	val |= y_g << TVO_VIP_REORDER_G_SHIFT;
+	val |= cb_b << TVO_VIP_REORDER_B_SHIFT;
+	tvout_reg_writemask(vip_reg, val, mask);
+}
+
+/*
+ * Set the clipping mode of a VIP
+ *
+ * @vip_reg: VIP regsiter
+ * @range  : clipping range
+ */
+static void tvout_vip_set_clip_mode(void __iomem *vip_reg, u32 range)
+{
+	tvout_reg_writemask(vip_reg,
+			    range << TVO_VIP_CLIP_SHIFT,
+			    TVO_VIP_CLIP_MASK << TVO_VIP_CLIP_SHIFT);
+}
+
+/*
+ * Set the rounded value of a VIP
+ *
+ * @vip_reg: VIP regsiter
+ * @rnd: rounded val per component
+ */
+static void tvout_vip_set_rnd(void __iomem *vip_reg, u32 rnd)
+{
+	tvout_reg_writemask(vip_reg,
+			    rnd << TVO_VIP_RND_SHIFT,
+			    TVO_VIP_RND_MASK << TVO_VIP_RND_SHIFT);
+}
+
+/*
+ * Select the VIP input
+ *
+ * @vip_reg: VIP regsiter
+ * @sel_input: selected_input (main/aux + conv)
+ */
+static void tvout_vip_set_sel_input(void __iomem *vip_reg,
+				    bool main_path,
+				    bool sel_input_logic_inverted,
+				    enum sti_tvout_video_out_type video_out)
+{
+	u32 sel_input;
+
+	if (main_path)
+		sel_input = TVO_VIP_SEL_INPUT_MAIN;
+	else
+		sel_input = TVO_VIP_SEL_INPUT_AUX;
+
+	switch (video_out) {
+	case STI_TVOUT_VIDEO_OUT_RGB:
+		sel_input |= TVO_VIP_SEL_INPUT_BYPASSED;
+		break;
+	case STI_TVOUT_VIDEO_OUT_YUV:
+		sel_input &= ~TVO_VIP_SEL_INPUT_BYPASSED;
+		break;
+	}
+
+	/* On stih407 chip the sel_input bypass mode logic is inverted */
+	if (sel_input_logic_inverted)
+		sel_input = sel_input ^ TVO_VIP_SEL_INPUT_BYPASS_MASK;
+
+	tvout_reg_writemask(vip_reg, sel_input, TVO_VIP_SEL_INPUT_MASK);
+}
+
+/*
+ * Select the input video signed or unsigned
+ *
+ * @vip_reg: VIP regsiter
+ * @in_vid_signed: used video input format
+ */
+static void tvout_vip_set_in_vid_fmt(void __iomem *vip_reg, u32 in_vid_fmt)
+{
+	tvout_reg_writemask(vip_reg, in_vid_fmt, TVO_IN_FMT_SIGNED);
+}
+
+/*
+ * Start VIP block for HDMI output
+ *
+ * @tvout: pointer on tvout structure
+ * @main_path: true if main path has to be used in the vip configuration
+ *	  else aux path is used.
+ */
+static void tvout_hdmi_start(struct sti_tvout *tvout, bool main_path)
+{
+	struct device_node *node = tvout->dev->of_node;
+	bool sel_input_logic_inverted = false;
+
+	dev_dbg(tvout->dev, "%s\n", __func__);
+
+	if (main_path) {
+		DRM_DEBUG_DRIVER("main vip for hdmi\n");
+		/* Select the input sync for hdmi = VTG set 1 */
+		writel(TVO_SYNC_MAIN_VTG_SET_1,
+		       tvout->regs + TVO_HDMI_SYNC_SEL);
+	} else {
+		DRM_DEBUG_DRIVER("aux vip for hdmi\n");
+		/* Select the input sync for hdmi = VTG set 1 */
+		writel(TVO_SYNC_AUX_VTG_SET_1, tvout->regs + TVO_HDMI_SYNC_SEL);
+	}
+
+	/* Set color channel order */
+	tvout_vip_set_color_order(tvout->regs + TVO_VIP_HDMI,
+				  TVO_VIP_REORDER_CR_R_SEL,
+				  TVO_VIP_REORDER_Y_G_SEL,
+				  TVO_VIP_REORDER_CB_B_SEL);
+
+	/* Set clipping mode (Limited range RGB/Y) */
+	tvout_vip_set_clip_mode(tvout->regs + TVO_VIP_HDMI,
+				TVO_VIP_CLIP_LIMITED_RANGE_RGB_Y);
+
+	/* Set round mode (rounded to 8-bit per component) */
+	tvout_vip_set_rnd(tvout->regs + TVO_VIP_HDMI, TVO_VIP_RND_8BIT_ROUNDED);
+
+	if (of_device_is_compatible(node, "st,stih407-tvout")) {
+		/* Set input video format */
+		tvout_vip_set_in_vid_fmt(tvout->regs + TVO_MAIN_IN_VID_FORMAT,
+					 TVO_IN_FMT_SIGNED);
+		sel_input_logic_inverted = true;
+	}
+
+	/* Input selection */
+	tvout_vip_set_sel_input(tvout->regs + TVO_VIP_HDMI,
+				main_path,
+				sel_input_logic_inverted,
+				STI_TVOUT_VIDEO_OUT_RGB);
+}
+
+/*
+ * Prepare/configure VIP block for HDMI output
+ *
+ * @tvout: pointer on tvout structure
+ */
+static void tvout_hdmi_prepare(struct sti_tvout *tvout)
+{
+	dev_dbg(tvout->dev, "%s\n", __func__);
+
+	/* Reset VIP register */
+	writel(0x00000000, tvout->regs + TVO_VIP_HDMI);
+}
+
+/*
+ * Disable HDMI VIP
+ *
+ * @tvout: pointer on tvout structure
+ */
+static void tvout_hdmi_stop(struct sti_tvout *tvout)
+{
+	dev_dbg(tvout->dev, "%s\n", __func__);
+
+	/* Reset VIP register */
+	writel(0x00000000, tvout->regs + TVO_VIP_HDMI);
+}
+
+/*
+ * Start HDF VIP and HD DAC
+ *
+ * @tvout: pointer on tvout structure
+ * @main_path: true if main path has to be used in the vip configuration
+ *	  else aux path is used.
+ */
+static void tvout_hda_start(struct sti_tvout *tvout, bool main_path)
+{
+	struct device_node *node = tvout->dev->of_node;
+	bool sel_input_logic_inverted = false;
+
+	dev_dbg(tvout->dev, "%s\n", __func__);
+
+	if (!main_path) {
+		DRM_ERROR("HD Analog on aux not implemented\n");
+		return;
+	}
+
+	DRM_DEBUG_DRIVER("main vip for HDF\n");
+
+	/* Set color channel order */
+	tvout_vip_set_color_order(tvout->regs + TVO_VIP_HDF,
+				  TVO_VIP_REORDER_CR_R_SEL,
+				  TVO_VIP_REORDER_Y_G_SEL,
+				  TVO_VIP_REORDER_CB_B_SEL);
+
+	/* Set clipping mode (Limited range RGB/Y) */
+	tvout_vip_set_clip_mode(tvout->regs + TVO_VIP_HDF,
+				TVO_VIP_CLIP_LIMITED_RANGE_CB_CR);
+
+	/* Set round mode (rounded to 10-bit per component) */
+	tvout_vip_set_rnd(tvout->regs + TVO_VIP_HDF, TVO_VIP_RND_10BIT_ROUNDED);
+
+	if (of_device_is_compatible(node, "st,stih407-tvout")) {
+		/* Set input video format */
+		tvout_vip_set_in_vid_fmt(tvout->regs + TVO_MAIN_IN_VID_FORMAT,
+					 TVO_IN_FMT_SIGNED);
+		sel_input_logic_inverted = true;
+	}
+
+	/* Input selection */
+	tvout_vip_set_sel_input(tvout->regs + TVO_VIP_HDF,
+				main_path,
+				sel_input_logic_inverted,
+				STI_TVOUT_VIDEO_OUT_YUV);
+
+	/* Select the input sync for HD analog = VTG set 3
+	 * and HD DCS = VTG set 2 */
+	writel((TVO_SYNC_MAIN_VTG_SET_2 << TVO_SYNC_HD_DCS_SHIFT) |
+	       TVO_SYNC_MAIN_VTG_SET_3, tvout->regs + TVO_HD_SYNC_SEL);
+
+	/* Power up HD DAC */
+	writel(0, tvout->regs + TVO_HD_DAC_CFG_OFF);
+}
+
+/*
+ * Prepare/configure HDF VIP and HD DAC
+ *
+ * @tvout: pointer on tvout structure
+ */
+static void tvout_hda_prepare(struct sti_tvout *tvout)
+{
+	dev_dbg(tvout->dev, "%s\n", __func__);
+
+	/* Reset VIP register */
+	writel(0x00000000, tvout->regs + TVO_VIP_HDF);
+
+	/* Power down HD DAC */
+	writel(1, tvout->regs + TVO_HD_DAC_CFG_OFF);
+}
+
+/*
+ * Stop HDF VIP and HD DAC
+ *
+ * @tvout: pointer on tvout structure
+ */
+static void tvout_hda_stop(struct sti_tvout *tvout)
+{
+	dev_dbg(tvout->dev, "%s\n", __func__);
+
+	/* Reset VIP register */
+	writel(0x00000000, tvout->regs + TVO_VIP_HDF);
+
+	/* Power down HD DAC */
+	writel(1, tvout->regs + TVO_HD_DAC_CFG_OFF);
+}
+
+/*
+ * Check if the connector is connected
+ *
+ * @tvout: pointer on tvout structure
+ * @type: type of connector
+ *
+ * Return true if connected
+ */
+bool sti_tvout_connector_detect(struct sti_tvout *tvout,
+				enum sti_tvout_connector_type type)
+{
+	struct sti_tvout_connector *connector = tvout->connector[type];
+
+	dev_dbg(tvout->dev, "%s\n", __func__);
+
+	if (connector)
+		if (connector->detect)
+			return connector->detect(connector);
+
+	return false;
+}
+
+/*
+ * Forward drm display mode information to the connector
+ *
+ * @tvout: pointer on tvout structure
+ * @mode: selected display mode
+ * @type: type of connector
+ *
+ * Return -1 if error occurs
+ */
+int sti_tvout_set_mode(struct sti_tvout *tvout, struct drm_display_mode *mode,
+		       enum sti_tvout_connector_type type)
+{
+	struct sti_tvout_connector *connector = tvout->connector[type];
+
+	dev_dbg(tvout->dev, "%s\n", __func__);
+
+	if (connector)
+		if (connector->set_mode)
+			return connector->set_mode(connector, mode);
+
+	return -1;
+}
+
+/*
+ * Get modes
+ *
+ * @tvout: pointer on tvout structure
+ * @type: type of connector
+ * @drm_connector: pointer on the connector
+ *
+ * Return Nb of modes, -1 if error
+ */
+int sti_tvout_get_modes(struct sti_tvout *tvout,
+			enum sti_tvout_connector_type type,
+			struct drm_connector *drm_connector)
+{
+	struct sti_tvout_connector *connector = tvout->connector[type];
+
+	dev_dbg(tvout->dev, "%s\n", __func__);
+
+	if (connector)
+		if (connector->get_modes)
+			return connector->get_modes(drm_connector);
+
+	return -1;
+}
+
+/*
+ * Check if the mode is supported
+ *
+ * function used to filter unsupported mode
+ *
+ * @tvout: pointer on tvout structure
+ * @type: type of connector
+ * @mode: drm display mode
+ *
+ * Return -1 if error occurs
+ */
+int sti_tvout_check_mode(struct sti_tvout *tvout,
+			 enum sti_tvout_connector_type type,
+			 struct drm_display_mode *mode)
+{
+	struct sti_tvout_connector *connector = tvout->connector[type];
+
+	dev_dbg(tvout->dev, "%s\n", __func__);
+
+	if (connector)
+		if (connector->check_mode)
+			return connector->check_mode(connector, mode);
+
+	return -1;
+}
+
+/*
+ * Prepare / initialize depending on the connector type
+ *
+ * @tvout: pointer on tvout structure
+ * @type: type of connector
+ *
+ * Return -1 if error occurs
+ */
+int sti_tvout_prepare(struct sti_tvout *tvout,
+		      enum sti_tvout_connector_type type)
+{
+	struct sti_tvout_connector *connector = tvout->connector[type];
+	int ret = -1;
+
+	dev_dbg(tvout->dev, "%s\n", __func__);
+
+	if (connector)
+		if (connector->prepare)
+			connector->prepare(connector);
+
+	switch (type) {
+	case STI_TVOUT_CONNECTOR_HDMI:
+		tvout_hdmi_prepare(tvout);
+		ret = 0;
+		break;
+	case STI_TVOUT_CONNECTOR_HDA:
+		tvout_hda_prepare(tvout);
+		ret = 0;
+		break;
+	case STI_TVOUT_CONNECTOR_DVO:
+	case STI_TVOUT_CONNECTOR_DENC:
+	default:
+		/* Not yet supported */
+		ret = -1;
+		break;
+	}
+
+	return ret;
+}
+
+/*
+ * Commit / start depending on the connector type
+ *
+ * @tvout: pointer on tvout structure
+ * @type: type of connector
+ * @main_path: true if main path need to be use (false for aux path)
+ *
+ * Return -1 if error occurs
+ */
+int sti_tvout_commit(struct sti_tvout *tvout,
+		     enum sti_tvout_connector_type type, bool main_path)
+{
+	struct sti_tvout_connector *connector = tvout->connector[type];
+	int ret = 0;
+	u32 matrix_offset;
+	int i;
+
+	dev_dbg(tvout->dev, "%s\n", __func__);
+
+	if (!connector)
+		return -1;
+
+	connector->main_path = main_path;
+
+	if (connector->start) {
+		ret = connector->start(connector);
+		if (ret) {
+			DRM_ERROR("Unable to properly start connector\n");
+			return -1;
+		}
+	}
+
+	/* Set preformatter matrix */
+	matrix_offset = main_path ? TVO_CSC_MAIN_M0 : TVO_CSC_AUX_M0;
+	for (i = 0; i < 8; i++)
+		writel(rgb_to_ycbcr_601[i],
+		       tvout->regs + matrix_offset + (i * 4));
+
+	switch (type) {
+	case STI_TVOUT_CONNECTOR_HDMI:
+		tvout_hdmi_start(tvout, main_path);
+		return 0;
+	case STI_TVOUT_CONNECTOR_HDA:
+		tvout_hda_start(tvout, main_path);
+		return 0;
+	case STI_TVOUT_CONNECTOR_DVO:
+	case STI_TVOUT_CONNECTOR_DENC:
+	default:
+		/* Not yet supported */
+		return -1;
+	}
+}
+
+/*
+ * Disable / stop the tvout depending on the connector type
+ *
+ * @tvout: pointer on tvout structure
+ * @type: type of connector
+ */
+void sti_tvout_disable(struct sti_tvout *tvout,
+		       enum sti_tvout_connector_type type)
+{
+	struct sti_tvout_connector *connector = tvout->connector[type];
+
+	dev_dbg(tvout->dev, "%s\n", __func__);
+
+	switch (type) {
+	case STI_TVOUT_CONNECTOR_HDMI:
+		tvout_hdmi_stop(tvout);
+		break;
+	case STI_TVOUT_CONNECTOR_HDA:
+		tvout_hda_stop(tvout);
+		break;
+	case STI_TVOUT_CONNECTOR_DVO:
+	case STI_TVOUT_CONNECTOR_DENC:
+	default:
+		/* Not yet supported */
+		return;
+	}
+
+	if (connector)
+		if (connector->stop)
+			connector->stop(connector);
+}
+
+static int sti_tvout_bind(struct device *dev, struct device *master, void *data)
+{
+	return 0;
+}
+
+static void sti_tvout_unbind(struct device *dev, struct device *master,
+	void *data)
+{
+	/* do nothing */
+}
+
+static const struct component_ops sti_tvout_ops = {
+	.bind	= sti_tvout_bind,
+	.unbind	= sti_tvout_unbind,
+};
+
+static int sti_tvout_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct device_node *node = dev->of_node;
+	struct sti_tvout *tvout;
+	struct resource *res;
+
+	DRM_INFO("%s\n", __func__);
+
+	if (!node) {
+		DRM_ERROR("no device node\n");
+		return -ENODEV;
+	}
+
+	tvout = devm_kzalloc(dev, sizeof(*tvout), GFP_KERNEL);
+	if (!tvout) {
+		DRM_ERROR("failed to allocate compositor context\n");
+		return -ENOMEM;
+	}
+	DRM_DEBUG_DRIVER("tvout %p\n", tvout);
+	tvout->dev = dev;
+
+	/* Get Memory ressources */
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "tvout-reg");
+	if (!res) {
+		DRM_ERROR("Invalid glue resource\n");
+		return -ENOMEM;
+	}
+	tvout->regs = devm_ioremap_nocache(dev, res->start, resource_size(res));
+	if (IS_ERR(tvout->regs))
+		return PTR_ERR(tvout->regs);
+
+	/* Get reset resources */
+	tvout->reset = devm_reset_control_get(dev, "tvout");
+	/* Take tvout out of reset */
+	if (!IS_ERR(tvout->reset))
+		reset_control_deassert(tvout->reset);
+
+	/* List supported tvout connector */
+	tvout->connector_create[STI_TVOUT_CONNECTOR_HDMI] = sti_hdmi_create;
+	tvout->connector_create[STI_TVOUT_CONNECTOR_HDA] = sti_hda_create;
+	tvout->connector_create[STI_TVOUT_CONNECTOR_DVO] = NULL;
+	tvout->connector_create[STI_TVOUT_CONNECTOR_DENC] = NULL;
+
+	platform_set_drvdata(pdev, tvout);
+
+	return component_add(&pdev->dev, &sti_tvout_ops);
+}
+
+static int sti_tvout_remove(struct platform_device *pdev)
+{
+	component_del(&pdev->dev, &sti_tvout_ops);
+	return 0;
+}
+
+static struct of_device_id tvout_match_types[] = {
+	{
+	 .compatible = "st,stih416-tvout",
+	 },
+	{
+	 .compatible = "st,stih407-tvout",
+	 },
+	{ /* end node */ }
+};
+MODULE_DEVICE_TABLE(of, tvout_match_types);
+
+struct platform_driver sti_tvout_driver = {
+	.driver = {
+		   .name = "sti-tvout",
+		   .owner = THIS_MODULE,
+		   .of_match_table = tvout_match_types,
+		   },
+	.probe = sti_tvout_probe,
+	.remove = sti_tvout_remove,
+};
+
+module_platform_driver(sti_tvout_driver);
+
+MODULE_LICENSE("GPL");
diff --git a/drivers/gpu/drm/sti/sti_tvout.h b/drivers/gpu/drm/sti/sti_tvout.h
new file mode 100644
index 0000000..f61a49c
--- /dev/null
+++ b/drivers/gpu/drm/sti/sti_tvout.h
@@ -0,0 +1,105 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2013
+ * Author: Vincent Abriou <vincent.abriou@st.com> for STMicroelectronics.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#ifndef _STI_TVOUT_H_
+#define _STI_TVOUT_H_
+
+#include <linux/clk.h>
+
+/*
+ * STI TVout connector structure
+ *
+ * @priv: private structure associated to the connector type
+ * @start: start the connector
+ * @stop: stop the connector
+ * @get_modes: get modes potentially supported
+ * @check_mode: check if a mode is really supported
+ * @set_mode: set the drm display mode in the specific connector structure
+ * @detect: detect if connector is connected
+ * @prepare: prepare the connector
+ * @is_enabled: is the connector enabled
+ * @dbg_show: dump debug information
+ */
+struct sti_tvout_connector {
+	void *priv;
+	bool main_path;
+	int (*start)(struct sti_tvout_connector *connector);
+	void (*stop)(struct sti_tvout_connector *connector);
+	int (*get_modes)(struct drm_connector *drm_connector);
+	int (*check_mode)(struct sti_tvout_connector *connector,
+			struct drm_display_mode *mode);
+	int (*set_mode)(struct sti_tvout_connector *connector,
+			struct drm_display_mode *mode);
+	bool (*detect)(struct sti_tvout_connector *connector);
+	void (*prepare)(struct sti_tvout_connector *connector);
+	bool (*is_enabled)(struct sti_tvout_connector *connector);
+	void (*dbg_show)(struct sti_tvout_connector *connector,
+			struct seq_file *m);
+};
+
+/*
+ * enum listing the supported connector
+ */
+enum sti_tvout_connector_type {
+	STI_TVOUT_CONNECTOR_HDMI,
+	STI_TVOUT_CONNECTOR_HDA,
+	STI_TVOUT_CONNECTOR_DVO,
+	STI_TVOUT_CONNECTOR_DENC,
+	STI_TVOUT_CONNECTOR_MAX,
+};
+
+/*
+ * enum listing the supported output data format
+ */
+enum sti_tvout_video_out_type {
+	STI_TVOUT_VIDEO_OUT_RGB,
+	STI_TVOUT_VIDEO_OUT_YUV,
+};
+
+/*
+ * STI TVout structure
+ *
+ * @dev: pointer to driver device
+ * @regs: registers
+ * @reset: reset control of the tvout
+ * @hw_id: HW revision of the IP
+ * @connector_create: list of function to register a connector
+ * @connector: list of registered connector
+ */
+struct sti_tvout {
+	struct device *dev;
+	struct drm_device *drm_dev;
+	void __iomem *regs;
+	struct reset_control *reset;
+	int hw_id;
+	struct sti_tvout_connector *(*connector_create[STI_TVOUT_CONNECTOR_MAX])
+		(struct sti_tvout *tvout);
+	struct sti_tvout_connector *connector[STI_TVOUT_CONNECTOR_MAX];
+};
+
+bool sti_tvout_connector_detect(struct sti_tvout *tvout,
+		enum sti_tvout_connector_type type);
+int  sti_tvout_set_mode(struct sti_tvout *tvout,
+		struct drm_display_mode *mode,
+		enum sti_tvout_connector_type type);
+int  sti_tvout_get_modes(struct sti_tvout *tvout,
+		enum sti_tvout_connector_type type,
+		struct drm_connector *drm_connector);
+int  sti_tvout_check_mode(struct sti_tvout *tvout,
+		enum sti_tvout_connector_type type,
+		struct drm_display_mode *mode);
+int  sti_tvout_prepare(struct sti_tvout *tvout,
+		enum sti_tvout_connector_type type);
+int  sti_tvout_commit(struct sti_tvout *tvout,
+		enum sti_tvout_connector_type type,
+		bool main_path);
+void  sti_tvout_disable(struct sti_tvout *tvout,
+		enum sti_tvout_connector_type type);
+
+int sti_tvout_hdmi_dbg_show(struct seq_file *m, void *arg);
+int sti_tvout_hda_dbg_show(struct seq_file *m, void *arg);
+
+#endif
-- 
1.9.1

