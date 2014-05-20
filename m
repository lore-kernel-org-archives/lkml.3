Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183AbaETODc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 10:03:32 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:33950 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065AbaETN5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 09:57:04 -0400
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: dri-devel@lists.freedesktop.org, airlied@linux.ie,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH v3 05/16] drm: sti: add HDA driver
Date: Tue, 20 May 2014 15:56:15 +0200
Message-Id: <1400594186-8956-6-git-send-email-benjamin.gaignard@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400594186-8956-1-git-send-email-benjamin.gaignard@linaro.org>
References: <1400594186-8956-1-git-send-email-benjamin.gaignard@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add driver to support analog TV ouput.

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
---
 drivers/gpu/drm/sti/Makefile  |   1 +
 drivers/gpu/drm/sti/sti_hda.c | 480 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 481 insertions(+)
 create mode 100644 drivers/gpu/drm/sti/sti_hda.c

diff --git a/drivers/gpu/drm/sti/Makefile b/drivers/gpu/drm/sti/Makefile
index 6c474eb..aa69ea0 100644
--- a/drivers/gpu/drm/sti/Makefile
+++ b/drivers/gpu/drm/sti/Makefile
@@ -3,6 +3,7 @@ ccflags-y := -Iinclude/drm
 stidrm-y := sti_hdmi.o \
 			sti_hdmi_tx3g0c55phy.o \
 			sti_hdmi_tx3g4c28phy.o \
+			sti_hda.o \
 			sti_ddc.o
 
 obj-$(CONFIG_VTAC_STI) += sti_vtac_tx.o sti_vtac_rx.o
diff --git a/drivers/gpu/drm/sti/sti_hda.c b/drivers/gpu/drm/sti/sti_hda.c
new file mode 100644
index 0000000..315aa0e
--- /dev/null
+++ b/drivers/gpu/drm/sti/sti_hda.c
@@ -0,0 +1,480 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2014
+ * Author: Fabien Dessenne <fabien.dessenne@st.com> for STMicroelectronics.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#include <linux/clk.h>
+#include <linux/component.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+
+#include <drm/drmP.h>
+
+/* HDformatter registers */
+#define HDA_ANA_CFG                     0x0000
+#define HDA_ANA_SCALE_CTRL_Y            0x0004
+#define HDA_ANA_SCALE_CTRL_CB           0x0008
+#define HDA_ANA_SCALE_CTRL_CR           0x000C
+#define HDA_ANA_ANC_CTRL                0x0010
+#define HDA_ANA_SRC_Y_CFG               0x0014
+#define HDA_COEFF_Y_PH1_TAP123          0x0018
+#define HDA_COEFF_Y_PH1_TAP456          0x001C
+#define HDA_COEFF_Y_PH2_TAP123          0x0020
+#define HDA_COEFF_Y_PH2_TAP456          0x0024
+#define HDA_COEFF_Y_PH3_TAP123          0x0028
+#define HDA_COEFF_Y_PH3_TAP456          0x002C
+#define HDA_COEFF_Y_PH4_TAP123          0x0030
+#define HDA_COEFF_Y_PH4_TAP456          0x0034
+#define HDA_ANA_SRC_C_CFG               0x0040
+#define HDA_COEFF_C_PH1_TAP123          0x0044
+#define HDA_COEFF_C_PH1_TAP456          0x0048
+#define HDA_COEFF_C_PH2_TAP123          0x004C
+#define HDA_COEFF_C_PH2_TAP456          0x0050
+#define HDA_COEFF_C_PH3_TAP123          0x0054
+#define HDA_COEFF_C_PH3_TAP456          0x0058
+#define HDA_COEFF_C_PH4_TAP123          0x005C
+#define HDA_COEFF_C_PH4_TAP456          0x0060
+#define HDA_SYNC_AWGI                   0x0300
+
+/* HDA_ANA_CFG */
+#define CFG_AWG_ASYNC_EN                (1 << 0)
+#define CFG_AWG_ASYNC_HSYNC_MTD         (1 << 1)
+#define CFG_AWG_ASYNC_VSYNC_MTD         (1 << 2)
+#define CFG_AWG_SYNC_DEL                (1 << 3)
+#define CFG_AWG_FLTR_MODE_SHIFT         4
+#define CFG_AWG_FLTR_MODE_MASK          (0xF << CFG_AWG_FLTR_MODE_SHIFT)
+#define CFG_AWG_FLTR_MODE_SD            (0 << CFG_AWG_FLTR_MODE_SHIFT)
+#define CFG_AWG_FLTR_MODE_ED            (1 << CFG_AWG_FLTR_MODE_SHIFT)
+#define CFG_AWG_FLTR_MODE_HD            (2 << CFG_AWG_FLTR_MODE_SHIFT)
+#define CFG_SYNC_ON_PBPR_MASK           (1 << 8)
+#define CFG_PREFILTER_EN_MASK           (1 << 9)
+#define CFG_PBPR_SYNC_OFF_SHIFT         16
+#define CFG_PBPR_SYNC_OFF_MASK          (0x7FF << CFG_PBPR_SYNC_OFF_SHIFT)
+#define CFG_PBPR_SYNC_OFF_VAL           0x117	/* Voltage dependent. stiH416 */
+
+/* Default scaling values */
+#define SCALE_CTRL_Y_DFLT               0x00C50256
+#define SCALE_CTRL_CB_DFLT              0x00DB0249
+#define SCALE_CTRL_CR_DFLT              0x00DB0249
+
+/* Video DACs control */
+#define VIDEO_DACS_CONTROL_MASK         0x0FFF
+#define VIDEO_DACS_CONTROL_SYSCFG2535   0x085C /* for stih416 */
+#define DAC_CFG_HD_OFF_SHIFT            5
+#define DAC_CFG_HD_OFF_MASK             (0x7 << DAC_CFG_HD_OFF_SHIFT)
+#define VIDEO_DACS_CONTROL_SYSCFG5072   0x0120 /* for stih407 */
+#define DAC_CFG_HD_HZUVW_OFF_SHIFT      1
+#define DAC_CFG_HD_HZUVW_OFF_MASK       (0x1 << DAC_CFG_HD_HZUVW_OFF_SHIFT)
+
+
+/* Upsampler values for the alternative 2X Filter */
+#define SAMPLER_COEF_NB                 8
+#define HDA_ANA_SRC_Y_CFG_ALT_2X        0x01130000
+static u32 coef_y_alt_2x[] = {
+	0x00FE83FB, 0x1F900401, 0x00000000, 0x00000000,
+	0x00F408F9, 0x055F7C25, 0x00000000, 0x00000000
+};
+
+#define HDA_ANA_SRC_C_CFG_ALT_2X        0x01750004
+static u32 coef_c_alt_2x[] = {
+	0x001305F7, 0x05274BD0, 0x00000000, 0x00000000,
+	0x0004907C, 0x09C80B9D, 0x00000000, 0x00000000
+};
+
+/* Upsampler values for the 4X Filter */
+#define HDA_ANA_SRC_Y_CFG_4X            0x01ED0005
+#define HDA_ANA_SRC_C_CFG_4X            0x01ED0004
+static u32 coef_yc_4x[] = {
+	0x00FC827F, 0x008FE20B, 0x00F684FC, 0x050F7C24,
+	0x00F4857C, 0x0A1F402E, 0x00FA027F, 0x0E076E1D
+};
+
+/* AWG instructions for some video modes */
+#define AWG_MAX_INST                    64
+
+/* 720p@50 */
+static u32 AWGi_720p_50[] = {
+	0x00000971, 0x00000C26, 0x0000013B, 0x00000CDA,
+	0x00000104, 0x00000E7E, 0x00000E7F, 0x0000013B,
+	0x00000D8E, 0x00000104, 0x00001804, 0x00000971,
+	0x00000C26, 0x0000003B, 0x00000FB4, 0x00000FB5,
+	0x00000104, 0x00001AE8
+};
+
+#define NN_720p_50 ARRAY_SIZE(AWGi_720p_50)
+
+/* 720p@60 */
+static u32 AWGi_720p_60[] = {
+	0x00000971, 0x00000C26, 0x0000013B, 0x00000CDA,
+	0x00000104, 0x00000E7E, 0x00000E7F, 0x0000013B,
+	0x00000C44, 0x00000104, 0x00001804, 0x00000971,
+	0x00000C26, 0x0000003B, 0x00000F0F, 0x00000F10,
+	0x00000104, 0x00001AE8
+};
+
+#define NN_720p_60 ARRAY_SIZE(AWGi_720p_60)
+
+/* 1080p@30 */
+static u32 AWGi_1080p_30[] = {
+	0x00000971, 0x00000C2A, 0x0000013B, 0x00000C56,
+	0x00000104, 0x00000FDC, 0x00000FDD, 0x0000013B,
+	0x00000C2A, 0x00000104, 0x00001804, 0x00000971,
+	0x00000C2A, 0x0000003B, 0x00000EBE, 0x00000EBF,
+	0x00000EBF, 0x00000104, 0x00001A2F, 0x00001C4B,
+	0x00001C52
+};
+
+#define NN_1080p_30 ARRAY_SIZE(AWGi_1080p_30)
+
+/* 1080p@25 */
+static u32 AWGi_1080p_25[] = {
+	0x00000971, 0x00000C2A, 0x0000013B, 0x00000C56,
+	0x00000104, 0x00000FDC, 0x00000FDD, 0x0000013B,
+	0x00000DE2, 0x00000104, 0x00001804, 0x00000971,
+	0x00000C2A, 0x0000003B, 0x00000F51, 0x00000F51,
+	0x00000F52, 0x00000104, 0x00001A2F, 0x00001C4B,
+	0x00001C52
+};
+
+#define NN_1080p_25 ARRAY_SIZE(AWGi_1080p_25)
+
+/* 1080p@24 */
+static u32 AWGi_1080p_24[] = {
+	0x00000971, 0x00000C2A, 0x0000013B, 0x00000C56,
+	0x00000104, 0x00000FDC, 0x00000FDD, 0x0000013B,
+	0x00000E50, 0x00000104, 0x00001804, 0x00000971,
+	0x00000C2A, 0x0000003B, 0x00000F76, 0x00000F76,
+	0x00000F76, 0x00000104, 0x00001A2F, 0x00001C4B,
+	0x00001C52
+};
+
+#define NN_1080p_24 ARRAY_SIZE(AWGi_1080p_24)
+
+/* 720x480p@60 */
+static u32 AWGi_720x480p_60[] = {
+	0x00000904, 0x00000F18, 0x0000013B, 0x00001805,
+	0x00000904, 0x00000C3D, 0x0000003B, 0x00001A06
+};
+
+#define NN_720x480p_60 ARRAY_SIZE(AWGi_720x480p_60)
+
+/* Video mode category */
+enum sti_hda_vid_cat {
+	VID_SD,
+	VID_ED,
+	VID_HD_74M,
+	VID_HD_148M
+};
+
+struct sti_hda_video_config {
+	struct drm_display_mode mode;
+	u32 *awg_instr;
+	int nb_instr;
+	enum sti_hda_vid_cat vid_cat;
+};
+
+/* HD analog supported modes */
+/* Interlaced modes may be added when supported by the whole display chain */
+static const struct sti_hda_video_config hda_supported_modes[] = {
+	/* 1080p30 74.250Mhz */
+	{{DRM_MODE("1920x1080", DRM_MODE_TYPE_DRIVER, 74250, 1920, 2008,
+		   2052, 2200, 0, 1080, 1084, 1089, 1125, 0,
+		   DRM_MODE_FLAG_PHSYNC | DRM_MODE_FLAG_PVSYNC)},
+	 AWGi_1080p_30, NN_1080p_30, VID_HD_74M},
+	/* 1080p30 74.176Mhz */
+	{{DRM_MODE("1920x1080", DRM_MODE_TYPE_DRIVER, 74176, 1920, 2008,
+		   2052, 2200, 0, 1080, 1084, 1089, 1125, 0,
+		   DRM_MODE_FLAG_PHSYNC | DRM_MODE_FLAG_PVSYNC)},
+	 AWGi_1080p_30, NN_1080p_30, VID_HD_74M},
+	/* 1080p24 74.250Mhz */
+	{{DRM_MODE("1920x1080", DRM_MODE_TYPE_DRIVER, 74250, 1920, 2558,
+		   2602, 2750, 0, 1080, 1084, 1089, 1125, 0,
+		   DRM_MODE_FLAG_PHSYNC | DRM_MODE_FLAG_PVSYNC)},
+	 AWGi_1080p_24, NN_1080p_24, VID_HD_74M},
+	/* 1080p24 74.176Mhz */
+	{{DRM_MODE("1920x1080", DRM_MODE_TYPE_DRIVER, 74176, 1920, 2558,
+		   2602, 2750, 0, 1080, 1084, 1089, 1125, 0,
+		   DRM_MODE_FLAG_PHSYNC | DRM_MODE_FLAG_PVSYNC)},
+	 AWGi_1080p_24, NN_1080p_24, VID_HD_74M},
+	/* 1080p25 74.250Mhz */
+	{{DRM_MODE("1920x1080", DRM_MODE_TYPE_DRIVER, 74250, 1920, 2448,
+		   2492, 2640, 0, 1080, 1084, 1089, 1125, 0,
+		   DRM_MODE_FLAG_PHSYNC | DRM_MODE_FLAG_PVSYNC)},
+	 AWGi_1080p_25, NN_1080p_25, VID_HD_74M},
+	/* 720p60 74.250Mhz */
+	{{DRM_MODE("1280x720", DRM_MODE_TYPE_DRIVER, 74250, 1280, 1390,
+		   1430, 1650, 0, 720, 725, 730, 750, 0,
+		   DRM_MODE_FLAG_PHSYNC | DRM_MODE_FLAG_PVSYNC)},
+	 AWGi_720p_60, NN_720p_60, VID_HD_74M},
+	/* 720p60 74.176Mhz */
+	{{DRM_MODE("1280x720", DRM_MODE_TYPE_DRIVER, 74176, 1280, 1390,
+		   1430, 1650, 0, 720, 725, 730, 750, 0,
+		   DRM_MODE_FLAG_PHSYNC | DRM_MODE_FLAG_PVSYNC)},
+	 AWGi_720p_60, NN_720p_60, VID_HD_74M},
+	/* 720p50 74.250Mhz */
+	{{DRM_MODE("1280x720", DRM_MODE_TYPE_DRIVER, 74250, 1280, 1720,
+		   1760, 1980, 0, 720, 725, 730, 750, 0,
+		   DRM_MODE_FLAG_PHSYNC | DRM_MODE_FLAG_PVSYNC)},
+	 AWGi_720p_50, NN_720p_50, VID_HD_74M},
+	/* 720x480p60 27.027Mhz */
+	{{DRM_MODE("720x480", DRM_MODE_TYPE_DRIVER, 27027, 720, 736,
+		   798, 858, 0, 480, 489, 495, 525, 0,
+		   DRM_MODE_FLAG_NHSYNC | DRM_MODE_FLAG_NVSYNC)},
+	 AWGi_720x480p_60, NN_720x480p_60, VID_ED},
+	/* 720x480p60 27.000Mhz */
+	{{DRM_MODE("720x480", DRM_MODE_TYPE_DRIVER, 27000, 720, 736,
+		   798, 858, 0, 480, 489, 495, 525, 0,
+		   DRM_MODE_FLAG_NHSYNC | DRM_MODE_FLAG_NVSYNC)},
+	 AWGi_720x480p_60, NN_720x480p_60, VID_ED}
+};
+
+/* Index (in supported modes table) of the preferred video mode */
+#define HDA_PREF_MODE_IDX               0
+
+/*
+ * STI hd analog structure
+ *
+ * @dev: driver device
+ * @drm_dev: pointer to drm device
+ * @mode: current display mode selected
+ * @regs: HD analog register
+ * @video_dacs_ctrl: video DACS control register
+ * @enabled: true if HD analog is enabled else false
+ */
+struct sti_hda {
+	struct device dev;
+	struct drm_device *drm_dev;
+	struct drm_display_mode mode;
+	void __iomem *regs;
+	void __iomem *video_dacs_ctrl;
+	struct clk *clk_pix;
+	struct clk *clk_hddac;
+	bool enabled;
+};
+
+/* Reference to the hda device */
+struct device *hda_dev;
+
+/*
+ * Helper to write bit field
+ *
+ * @addr: register to update
+ * @val: value to write
+ * @mask: bit field mask to use
+ */
+static inline void hda_reg_writemask(void __iomem *addr, u32 val, u32 mask)
+{
+	u32 old = readl(addr);
+
+	val = (val & mask) | (old & ~mask);
+	writel(val, addr);
+}
+
+/* Search for a video mode in the supported modes table
+ *
+ * @mode: mode being searched
+ * @idx: index of the found mode
+ *
+ * Return true if mode is found
+ */
+static bool hda_get_mode_idx(struct drm_display_mode mode, int *idx)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(hda_supported_modes); i++)
+		if (drm_mode_equal(&hda_supported_modes[i].mode, &mode)) {
+			*idx = i;
+			return true;
+		}
+	return false;
+}
+
+/* Enable the HD DACS
+ *
+ * @hda: pointer to HD analog structure
+ * @enable: true if HD DACS need to be enabled, else false
+ */
+static void hda_enable_hd_dacs(struct sti_hda *hda, bool enable)
+{
+	u32 mask;
+
+	if (hda->video_dacs_ctrl) {
+		switch ((u32)hda->video_dacs_ctrl & VIDEO_DACS_CONTROL_MASK) {
+		case VIDEO_DACS_CONTROL_SYSCFG2535:
+			mask = DAC_CFG_HD_OFF_MASK;
+			break;
+		case VIDEO_DACS_CONTROL_SYSCFG5072:
+			mask = DAC_CFG_HD_HZUVW_OFF_MASK;
+			break;
+		default:
+			DRM_INFO("Video DACS control register not supported!");
+			return;
+		}
+
+		if (enable)
+			hda_reg_writemask(hda->video_dacs_ctrl, 0x000000, mask);
+		else
+			hda_reg_writemask(hda->video_dacs_ctrl, 0xFFFFFF, mask);
+	}
+
+}
+
+/* Configure AWG, writing instructions
+ *
+ * @hda: pointer to HD analog structure
+ * @awg_instr: pointer to AWG instructions table
+ * @nb: nb of AWG instructions
+ */
+static void sti_hda_configure_awg(struct sti_hda *hda, u32 *awg_instr, int nb)
+{
+	int i;
+
+	DRM_DEBUG_DRIVER("\n");
+
+	for (i = 0; i < nb; i++)
+		writel(awg_instr[i], hda->regs + HDA_SYNC_AWGI + i * 4);
+	for (i = nb; i < AWG_MAX_INST; i++)
+		writel(0, hda->regs + HDA_SYNC_AWGI + i * 4);
+}
+
+/*
+ * Get modes
+ *
+ * @drm_connector: pointer on the drm connector
+ *
+ * Return number of modes
+ */
+static int sti_hda_get_modes(struct drm_connector *drm_connector)
+{
+	struct drm_device *dev = drm_connector->dev;
+	struct drm_display_mode *mode;
+	int i, count;
+
+	DRM_DEBUG_DRIVER("\n");
+
+	for (i = 0, count = 0; i < ARRAY_SIZE(hda_supported_modes); i++) {
+		mode = drm_mode_duplicate(dev, &hda_supported_modes[i].mode);
+		if (!mode)
+			continue;
+		mode->vrefresh = drm_mode_vrefresh(mode);
+
+		/* Set the preferred mode */
+		if (i == HDA_PREF_MODE_IDX)
+			mode->type |= DRM_MODE_TYPE_PREFERRED;
+
+		drm_mode_probed_add(drm_connector, mode);
+		count++;
+	}
+
+	drm_mode_sort(&drm_connector->modes);
+
+	return count;
+}
+
+
+static int sti_hda_bind(struct device *dev, struct device *master, void *data)
+{
+	return 0;
+}
+
+static void sti_hda_unbind(struct device *dev, struct device *master,
+	void *data)
+{
+	/* do nothing */
+}
+
+static const struct component_ops sti_hda_ops = {
+	.bind	= sti_hda_bind,
+	.unbind	= sti_hda_unbind,
+};
+
+static int sti_hda_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;;
+	struct sti_hda *hda;
+	struct resource *res;
+
+	DRM_INFO("%s\n", __func__);
+
+	hda = devm_kzalloc(dev, sizeof(*hda), GFP_KERNEL);
+	if (!hda) {
+		DRM_ERROR("Failed to allocate memory for HD analog\n");
+		return -ENOMEM;
+	}
+
+	hda->dev = pdev->dev;
+
+	/* Get resources */
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "hda-reg");
+	if (!res) {
+		DRM_ERROR("Invalid hda resource\n");
+		return -ENOMEM;
+	}
+	hda->regs = devm_ioremap_nocache(dev, res->start, resource_size(res));
+	if (IS_ERR(hda->regs))
+		return PTR_ERR(hda->regs);
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
+			"video-dacs-ctrl");
+	if (res) {
+		hda->video_dacs_ctrl = devm_ioremap_nocache(dev, res->start,
+				resource_size(res));
+		if (IS_ERR(hda->video_dacs_ctrl))
+			return PTR_ERR(hda->video_dacs_ctrl);
+	} else {
+		/* If no existing video-dacs-ctrl resource continue the probe */
+		DRM_DEBUG_DRIVER("No video-dacs-ctrl resource\n");
+		hda->video_dacs_ctrl = NULL;
+	}
+
+	/* Get clock resources */
+	hda->clk_pix = devm_clk_get(dev, "hda_pix");
+	if (IS_ERR(hda->clk_pix)) {
+		DRM_ERROR("Cannot get hda_pix clock\n");
+		return PTR_ERR(hda->clk_pix);
+	}
+
+	hda->clk_hddac = devm_clk_get(dev, "hda_hddac");
+	if (IS_ERR(hda->clk_hddac)) {
+		DRM_ERROR("Cannot get hda_hddac clock\n");
+		return PTR_ERR(hda->clk_hddac);
+	}
+
+	hda_dev = &hda->dev;
+
+	platform_set_drvdata(pdev, hda);
+
+	return component_add(&pdev->dev, &sti_hda_ops);
+}
+
+static int sti_hda_remove(struct platform_device *pdev)
+{
+	component_del(&pdev->dev, &sti_hda_ops);
+	return 0;
+}
+
+static struct of_device_id hda_match_types[] = {
+	{
+	 .compatible = "st,stih416-hda",
+	 },
+	{
+	 .compatible = "st,stih407-hda",
+	 },
+	{ /* end node */ }
+};
+MODULE_DEVICE_TABLE(of, hda_match_types);
+
+struct platform_driver sti_hda_driver = {
+	.driver = {
+		   .name = "sti-hda",
+		   .owner = THIS_MODULE,
+		   .of_match_table = hda_match_types,
+		   },
+	.probe = sti_hda_probe,
+	.remove = sti_hda_remove,
+};
+
+module_platform_driver(sti_hda_driver);
+
+MODULE_LICENSE("GPL");
-- 
1.9.1

