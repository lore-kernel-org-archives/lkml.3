Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210AbaETODd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 10:03:33 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:56468 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbaETN5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 09:57:01 -0400
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: dri-devel@lists.freedesktop.org, airlied@linux.ie,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH v3 03/16] drm: sti: add HDMI driver
Date: Tue, 20 May 2014 15:56:13 +0200
Message-Id: <1400594186-8956-4-git-send-email-benjamin.gaignard@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400594186-8956-1-git-send-email-benjamin.gaignard@linaro.org>
References: <1400594186-8956-1-git-send-email-benjamin.gaignard@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add driver for HDMI ouput

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
---
 drivers/gpu/drm/sti/Makefile               |   5 +
 drivers/gpu/drm/sti/sti_hdmi.c             | 529 +++++++++++++++++++++++++++++
 drivers/gpu/drm/sti/sti_hdmi.h             | 195 +++++++++++
 drivers/gpu/drm/sti/sti_hdmi_tx3g0c55phy.c | 398 ++++++++++++++++++++++
 drivers/gpu/drm/sti/sti_hdmi_tx3g4c28phy.c | 224 ++++++++++++
 5 files changed, 1351 insertions(+)
 create mode 100644 drivers/gpu/drm/sti/sti_hdmi.c
 create mode 100644 drivers/gpu/drm/sti/sti_hdmi.h
 create mode 100644 drivers/gpu/drm/sti/sti_hdmi_tx3g0c55phy.c
 create mode 100644 drivers/gpu/drm/sti/sti_hdmi_tx3g4c28phy.c

diff --git a/drivers/gpu/drm/sti/Makefile b/drivers/gpu/drm/sti/Makefile
index 79fdcb6..5295fc7 100644
--- a/drivers/gpu/drm/sti/Makefile
+++ b/drivers/gpu/drm/sti/Makefile
@@ -1,4 +1,9 @@
 ccflags-y := -Iinclude/drm
 
+stidrm-y := sti_hdmi.o \
+			sti_hdmi_tx3g0c55phy.o \
+			sti_hdmi_tx3g4c28phy.o
+
 obj-$(CONFIG_VTAC_STI) += sti_vtac_tx.o sti_vtac_rx.o
 obj-$(CONFIG_VTG_STI) += sti_vtg.o sti_vtg_utils.o
+obj-$(CONFIG_DRM_STI) += stidrm.o
\ No newline at end of file
diff --git a/drivers/gpu/drm/sti/sti_hdmi.c b/drivers/gpu/drm/sti/sti_hdmi.c
new file mode 100644
index 0000000..02b0524
--- /dev/null
+++ b/drivers/gpu/drm/sti/sti_hdmi.c
@@ -0,0 +1,529 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2013
+ * Author: Vincent Abriou <vincent.abriou@st.com> for STMicroelectronics.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#include <linux/clk.h>
+#include <linux/component.h>
+#include <linux/hdmi.h>
+#include <linux/module.h>
+#include <linux/of_gpio.h>
+#include <linux/platform_device.h>
+#include <linux/reset.h>
+
+#include <drm/drmP.h>
+#include <drm/drm_crtc_helper.h>
+#include <drm/drm_edid.h>
+
+#include "sti_hdmi.h"
+#include "sti_vtg_utils.h"
+
+/* Reference to the hdmi device */
+struct device *hdmi_dev;
+
+/*
+ * Helper to write bit field
+ *
+ * @addr: register to update
+ * @val: value to write
+ * @mask: bit field mask to use
+ */
+static inline void hdmi_reg_writemask(void __iomem *addr, u32 val, u32 mask)
+{
+	u32 old = readl(addr);
+
+	val = (val & mask) | (old & ~mask);
+	writel(val, addr);
+}
+
+/*
+ * HDMI interrupt handler
+ *
+ * @irq: irq number
+ * @arg: connector structure
+ */
+static irqreturn_t hdmi_irq_thread(int irq, void *arg)
+{
+	struct sti_hdmi *hdmi = arg;
+	u32 status;
+
+	/* read interrupt status */
+	status = readl(hdmi->regs + HDMI_INT_STA);
+
+	/* PLL lock interrupt */
+	if (status & HDMI_INT_DLL_LCK) {
+		hdmi->event_received = true;
+		wake_up_interruptible(&hdmi->wait_event);
+	}
+
+	/* Hot plug detection */
+	if (status & HDMI_INT_HOT_PLUG) {
+		hdmi->hpd = gpio_get_value(hdmi->hpd_gpio);
+		if (hdmi->drm_dev)
+			drm_helper_hpd_irq_event(hdmi->drm_dev);
+	}
+
+	/* Sw reset completed */
+	if (status & HDMI_INT_SW_RST) {
+		hdmi->event_received = true;
+		wake_up_interruptible(&hdmi->wait_event);
+	}
+
+	/* clear interrupt status */
+	writel(status, hdmi->regs + HDMI_INT_CLR);
+
+	/* TODO: check why this sync bus write solves the problem which
+	 * is that without this line, the handler is sometimes called twice
+	 */
+	/* sync bus write */
+	readl(hdmi->regs + HDMI_INT_STA);
+
+	return IRQ_HANDLED;
+}
+
+/*
+ * Start hdmi phy interface
+ *
+ * @hdmi: pointer on the hdmi internal structure
+ *
+ * Return -1 if error occurs
+ */
+static int hdmi_phy_start(struct sti_hdmi *hdmi)
+{
+	DRM_DEBUG_DRIVER("\n");
+
+	if (hdmi->tx3g0c55phy)
+		return sti_hdmi_tx3g0c55phy_start(hdmi);
+
+	return sti_hdmi_tx3g4c28phy_start(hdmi);
+}
+
+/*
+ * Stop hdmi phy interface
+ *
+ * @hdmi: pointer on the hdmi internal structure
+ */
+static void hdmi_phy_stop(struct sti_hdmi *hdmi)
+{
+	DRM_DEBUG_DRIVER("\n");
+
+	if (hdmi->tx3g0c55phy)
+		sti_hdmi_tx3g0c55phy_stop(hdmi);
+	else
+		sti_hdmi_tx3g4c28phy_stop(hdmi);
+}
+
+/*
+ * Set hdmi active area depending on the drm display mode selected
+ *
+ * @hdmi: pointer on the hdmi internal structure
+ */
+static void hdmi_active_area(struct sti_hdmi *hdmi)
+{
+	u32 xmin, xmax;
+	u32 ymin, ymax;
+
+	DRM_DEBUG_DRIVER("\n");
+
+	/*
+	 *       Active        Front        Sync       Back          Active
+	 *       Region        Porch                  Porch          Region
+	 * <---------------><-------->0<---------><--------><----------------->
+	 *
+	 *   ///////////////|                               |  ///////////////|
+	 *  /////////////// |                               | /////////////// |
+	 * ///////////////  |.........            ..........|///////////////  |
+	 *                            0___________      x/ymin           x/ymax
+	 *
+	 * <--[hv]display-->                                 <--[hv]display-->
+	 * <--[hv]sync_start--------->                       <--[hv]sync_start-
+	 * <--[hv]sync_end----------------------->           <--[hv]sync_end---
+	 * <--[hv]total------------------------------------> <--[hv]total------
+	 */
+
+	xmin = sti_vtg_get_pixel_number(hdmi->mode, 0);
+	xmax = sti_vtg_get_pixel_number(hdmi->mode, hdmi->mode.hdisplay - 1);
+	ymin = sti_vtg_get_line_number(hdmi->mode, 0);
+	ymax = sti_vtg_get_line_number(hdmi->mode, hdmi->mode.vdisplay - 1);
+
+	writel(xmin, hdmi->regs + HDMI_ACTIVE_VID_XMIN);
+	writel(xmax, hdmi->regs + HDMI_ACTIVE_VID_XMAX);
+	writel(ymin, hdmi->regs + HDMI_ACTIVE_VID_YMIN);
+	writel(ymax, hdmi->regs + HDMI_ACTIVE_VID_YMAX);
+
+	DRM_DEBUG_DRIVER("xmin=%d xmax=%d ymin=%d ymax=%d\n",
+			 xmin, xmax, ymin, ymax);
+}
+
+/*
+ * Overall hdmi configuration
+ *
+ * @hdmi: pointer on the hdmi internal structure
+ */
+static void hdmi_config(struct sti_hdmi *hdmi)
+{
+	u32 val;
+	u32 mask;
+
+	DRM_DEBUG_DRIVER("\n");
+
+	/* Clear overrun and underrun fifo */
+	mask = HDMI_CFG_FIFO_OVERRUN_CLR | HDMI_CFG_FIFO_UNDERRUN_CLR;
+	val = HDMI_CFG_FIFO_OVERRUN_CLR | HDMI_CFG_FIFO_UNDERRUN_CLR;
+
+	/* Enable HDMI mode not DVI */
+	mask |= HDMI_CFG_HDMI_NOT_DVI | HDMI_CFG_ESS_NOT_OESS;
+	val |= HDMI_CFG_HDMI_NOT_DVI | HDMI_CFG_ESS_NOT_OESS;
+
+	/* Enable sink term detection */
+	mask |= HDMI_CFG_SINK_TERM_DET_EN;
+	val |= HDMI_CFG_SINK_TERM_DET_EN;
+
+	/* Set Hsync polarity */
+	if ((hdmi->mode.flags && DRM_MODE_FLAG_NHSYNC)
+	    == DRM_MODE_FLAG_NHSYNC) {
+		DRM_DEBUG_DRIVER("H Sync Negative\n");
+		mask |= HDMI_CFG_H_SYNC_POL_NEG;
+		val |= HDMI_CFG_H_SYNC_POL_NEG;
+	}
+
+	/* Set Vsync polarity */
+	if ((hdmi->mode.flags && DRM_MODE_FLAG_NVSYNC)
+	    == DRM_MODE_FLAG_NVSYNC) {
+		DRM_DEBUG_DRIVER("V Sync Negative\n");
+		mask |= HDMI_CFG_V_SYNC_POL_NEG;
+		val |= HDMI_CFG_V_SYNC_POL_NEG;
+	}
+
+	/* Enable HDMI */
+	mask |= HDMI_CFG_DEVICE_EN;
+	val |= HDMI_CFG_DEVICE_EN;
+
+	hdmi_reg_writemask(hdmi->regs + HDMI_CFG, val, mask);
+}
+
+/*
+ * Prepare and configure the AVI infoframe
+ *
+ * AVI infoframe are transmitted at least once per two video field and
+ * contains information about HDMI transmission mode such as color space,
+ * colorimetry, ...
+ *
+ * @hdmi: pointer on the hdmi internal structure
+ *
+ * Return negative value if error occurs
+ */
+static int hdmi_avi_infoframe_config(struct sti_hdmi *hdmi)
+{
+	struct drm_display_mode *mode = &hdmi->mode;
+	struct hdmi_avi_infoframe infoframe;
+	u8 buffer[HDMI_INFOFRAME_HEADER_SIZE + HDMI_AVI_INFOFRAME_SIZE];
+	u8 *frame = buffer + HDMI_INFOFRAME_HEADER_SIZE - 1;
+	u32 val;
+	u32 mask;
+	int ret;
+
+	DRM_DEBUG_DRIVER("\n");
+
+	ret = drm_hdmi_avi_infoframe_from_display_mode(&infoframe, mode);
+	if (ret < 0) {
+		DRM_ERROR("failed to setup AVI infoframe: %d\n", ret);
+		return ret;
+	}
+
+	/* TODO: remove static infoframe configuration */
+	infoframe.colorspace = HDMI_COLORSPACE_RGB;
+	infoframe.quantization_range = HDMI_QUANTIZATION_RANGE_DEFAULT;
+	infoframe.colorimetry = HDMI_COLORIMETRY_NONE;
+	infoframe.pixel_repeat = 0;
+
+	ret = hdmi_avi_infoframe_pack(&infoframe, buffer, sizeof(buffer));
+	if (ret < 0) {
+		DRM_ERROR("failed to pack AVI infoframe: %d\n", ret);
+		return ret;
+	}
+
+	/* Disable transmission slot for AVI infoframe */
+	val = HDMI_IFRAME_DISABLED;
+	mask = HDMI_IFRAME_CFG_DI_N(HDMI_IFRAME_MASK, HDMI_IFRAME_SLOT_AVI);
+	hdmi_reg_writemask(hdmi->regs + HDMI_SW_DI_CFG, val, mask);
+
+	/* Infoframe header */
+	val = buffer[0x0];
+	val |= buffer[0x1] << 8;
+	val |= buffer[0x2] << 16;
+	writel(val, hdmi->regs + HDMI_SW_DI_N_HEAD_WORD(HDMI_IFRAME_SLOT_AVI));
+	/* Infoframe packet bytes */
+	val = frame[0x0];
+	val |= frame[0x1] << 8;
+	val |= frame[0x2] << 16;
+	val |= frame[0x3] << 24;
+	writel(val, hdmi->regs + HDMI_SW_DI_N_PKT_WORD0(HDMI_IFRAME_SLOT_AVI));
+	val = frame[0x4];
+	val |= frame[0x5] << 8;
+	val |= frame[0x6] << 16;
+	val |= frame[0x7] << 24;
+	writel(val, hdmi->regs + HDMI_SW_DI_N_PKT_WORD1(HDMI_IFRAME_SLOT_AVI));
+	val = frame[0x8];
+	val |= frame[0x9] << 8;
+	val |= frame[0xA] << 16;
+	val |= frame[0xB] << 24;
+	writel(val, hdmi->regs + HDMI_SW_DI_N_PKT_WORD2(HDMI_IFRAME_SLOT_AVI));
+	val = frame[0xC];
+	val |= frame[0xD] << 8;
+	writel(val, hdmi->regs + HDMI_SW_DI_N_PKT_WORD3(HDMI_IFRAME_SLOT_AVI));
+
+	/* Enable transmission slot for AVI infoframe */
+	/* According to the hdmi specification, AVI infoframe should be
+	 * transmitted at least once per two video fields */
+	val = HDMI_IFRAME_CFG_DI_N(HDMI_IFRAME_FIELD, HDMI_IFRAME_SLOT_AVI);
+	mask = HDMI_IFRAME_CFG_DI_N(HDMI_IFRAME_MASK, HDMI_IFRAME_SLOT_AVI);
+	hdmi_reg_writemask(hdmi->regs + HDMI_SW_DI_CFG, val, mask);
+
+	return 0;
+}
+
+/*
+ * Software reset of the hdmi subsystem
+ *
+ * @hdmi: pointer on the hdmi internal structure
+ *
+ * Return -1 if error occurs
+ */
+#define HDMI_TIMEOUT_SWRESET  100	/*milliseconds */
+static int hdmi_swreset(struct sti_hdmi *hdmi)
+{
+	u32 val;
+	u32 mask;
+
+	DRM_DEBUG_DRIVER("\n");
+
+	/* Enable hdmi_audio clock only during hdmi reset */
+	if (clk_prepare_enable(hdmi->clk_audio))
+		DRM_INFO("Failed to prepare/enable hdmi_audio clk\n");
+
+	/* Sw reset */
+	mask = HDMI_CFG_SW_RST_EN;
+	val = HDMI_CFG_SW_RST_EN;
+
+	hdmi->event_received = false;
+	hdmi_reg_writemask(hdmi->regs + HDMI_CFG, val, mask);
+
+	/* Wait reset completed */
+	wait_event_interruptible_timeout(hdmi->wait_event,
+					 hdmi->event_received == true,
+					 msecs_to_jiffies
+					 (HDMI_TIMEOUT_SWRESET));
+
+	/*
+	 * HDMI_STA_SW_RST bit is set to '1' when SW_RST bit in HDMI_CFG is
+	 * set to '1' and clk_audio is running.
+	 */
+	if ((readl(hdmi->regs + HDMI_STA) & HDMI_STA_SW_RST) == 0)
+		DRM_INFO("Warning: HDMI sw reset timeout occurs\n");
+
+	mask = HDMI_CFG_SW_RST_EN;
+	val = ~HDMI_CFG_SW_RST_EN;
+	hdmi_reg_writemask(hdmi->regs + HDMI_CFG, val, mask);
+
+	/* Disable hdmi_audio clock. Not used anymore for drm purpose. */
+	clk_disable_unprepare(hdmi->clk_audio);
+
+	return 0;
+}
+
+/*
+ * Attach the I2C ddc client to allow hdmi i2c communication
+ *
+ * @ddc: i2c client
+ */
+static struct i2c_client *hdmi_ddc;
+void sti_hdmi_attach_ddc_client(struct i2c_client *ddc)
+{
+	DRM_DEBUG_DRIVER("\n");
+
+	if (ddc)
+		hdmi_ddc = ddc;
+}
+
+/*
+ * Get modes from edid
+ *
+ * @drm_connector: pointer on the drm connector
+ */
+static int sti_hdmi_get_modes(struct drm_connector *drm_connector)
+{
+	struct edid *edid;
+	int count;
+
+	DRM_DEBUG_DRIVER("\n");
+
+	if ((!hdmi_ddc) || (!hdmi_ddc->adapter))
+		goto fail;
+
+	edid = drm_get_edid(drm_connector, hdmi_ddc->adapter);
+	if (!edid)
+		goto fail;
+
+	count = drm_add_edid_modes(drm_connector, edid);
+	if (count)
+		drm_mode_connector_update_edid_property(drm_connector, edid);
+	else
+		DRM_ERROR("Add edid modes failed\n");
+
+	kfree(edid);
+	return count;
+
+fail:
+	DRM_ERROR("Can not read HDMI EDID\n");
+	return -1;
+}
+
+static int sti_hdmi_bind(struct device *dev, struct device *master, void *data)
+{
+	return 0;
+}
+
+static void sti_hdmi_unbind(struct device *dev, struct device *master,
+	void *data)
+{
+	/* do nothing */
+}
+
+static const struct component_ops sti_hdmi_ops = {
+	.bind	= sti_hdmi_bind,
+	.unbind	= sti_hdmi_unbind,
+};
+
+static int sti_hdmi_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct sti_hdmi *hdmi;
+	struct device_node *np = dev->of_node;
+	struct resource *res;
+	int ret;
+
+	DRM_INFO("%s\n", __func__);
+
+	hdmi = devm_kzalloc(dev, sizeof(*hdmi), GFP_KERNEL);
+	if (!hdmi) {
+		DRM_ERROR("Failed to allocate memory for hdmi\n");
+		return -ENOMEM;
+	}
+
+	hdmi->dev = pdev->dev;
+
+	/* Get resources */
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "hdmi-reg");
+	if (!res) {
+		DRM_ERROR("Invalid hdmi resource\n");
+		return -ENOMEM;
+	}
+	hdmi->regs = devm_ioremap_nocache(dev, res->start, resource_size(res));
+	if (IS_ERR(hdmi->regs))
+		return PTR_ERR(hdmi->regs);
+
+	if (of_device_is_compatible(np, "st,stih416-hdmi")) {
+		res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
+						   "syscfg");
+		if (!res) {
+			DRM_ERROR("Invalid syscfg resource\n");
+			return -ENOMEM;
+		}
+		hdmi->syscfg = devm_ioremap_nocache(dev, res->start,
+						    resource_size(res));
+		if (IS_ERR(hdmi->syscfg))
+			return PTR_ERR(hdmi->syscfg);
+
+		hdmi->tx3g0c55phy = true;
+	}
+
+	/* Get clock resources */
+	hdmi->clk_pix = devm_clk_get(dev, "hdmi_pix");
+	if (IS_ERR(hdmi->clk_pix)) {
+		DRM_ERROR("Cannot get hdmi_pix clock\n");
+		return PTR_ERR(hdmi->clk_pix);
+	}
+
+	hdmi->clk_tmds = devm_clk_get(dev, "hdmi_tmds");
+	if (IS_ERR(hdmi->clk_tmds)) {
+		DRM_ERROR("Cannot get hdmi_tmds clock\n");
+		return PTR_ERR(hdmi->clk_tmds);
+	}
+
+	hdmi->clk_phy = devm_clk_get(dev, "hdmi_phy");
+	if (IS_ERR(hdmi->clk_phy)) {
+		DRM_ERROR("Cannot get hdmi_phy clock\n");
+		return PTR_ERR(hdmi->clk_phy);
+	}
+
+	hdmi->clk_audio = devm_clk_get(dev, "hdmi_audio");
+	if (IS_ERR(hdmi->clk_audio)) {
+		DRM_ERROR("Cannot get hdmi_audio clock\n");
+		return PTR_ERR(hdmi->clk_audio);
+	}
+
+	hdmi->hpd_gpio = of_get_named_gpio(np, "hdmi,hpd-gpio", 0);
+	if (hdmi->hpd_gpio < 0) {
+		DRM_ERROR("Failed to get hdmi hpd-gpio\n");
+		return -EIO;
+	}
+
+	hdmi->hpd = gpio_get_value(hdmi->hpd_gpio);
+
+	init_waitqueue_head(&hdmi->wait_event);
+
+	/* Get irq ressources */
+	hdmi->irq = platform_get_irq_byname(pdev, "hdmi_irq");
+
+	ret = devm_request_threaded_irq(dev, hdmi->irq, NULL,
+					hdmi_irq_thread, IRQF_ONESHOT,
+					"hdmi_irq", hdmi);
+	if (ret) {
+		DRM_ERROR("Failed to register hdmi interrupt\n");
+		return ret;
+	}
+
+	/* Get reset resources */
+	hdmi->reset = devm_reset_control_get(dev, "hdmi");
+	/* Take hdmi out of reset */
+	if (!IS_ERR(hdmi->reset))
+		reset_control_deassert(hdmi->reset);
+
+	hdmi_dev = &hdmi->dev;
+
+	platform_set_drvdata(pdev, hdmi);
+
+	return component_add(&pdev->dev, &sti_hdmi_ops);
+}
+
+static int sti_hdmi_remove(struct platform_device *pdev)
+{
+	component_del(&pdev->dev, &sti_hdmi_ops);
+	return 0;
+}
+
+static struct of_device_id hdmi_match_types[] = {
+	{
+	 .compatible = "st,stih416-hdmi",
+	 },
+	{
+	 .compatible = "st,stih407-hdmi",
+	 },
+	{ /* end node */ }
+};
+MODULE_DEVICE_TABLE(of, hdmi_match_types);
+
+struct platform_driver sti_hdmi_driver = {
+	.driver = {
+		   .name = "sti-hdmi",
+		   .owner = THIS_MODULE,
+		   .of_match_table = hdmi_match_types,
+		   },
+	.probe = sti_hdmi_probe,
+	.remove = sti_hdmi_remove,
+};
+module_platform_driver(sti_hdmi_driver);
+
+MODULE_LICENSE("GPL");
diff --git a/drivers/gpu/drm/sti/sti_hdmi.h b/drivers/gpu/drm/sti/sti_hdmi.h
new file mode 100644
index 0000000..c14c683
--- /dev/null
+++ b/drivers/gpu/drm/sti/sti_hdmi.h
@@ -0,0 +1,195 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2013
+ * Authors: Vincent Abriou <vincent.abriou@st.com> for STMicroelectronics.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#ifndef _STI_HDMI_H_
+#define _STI_HDMI_H_
+
+#include <linux/platform_device.h>
+
+#include <drm/drmP.h>
+
+/* HDMI v2.9 macro cell */
+#define HDMI_CFG                        0x0000
+#define HDMI_INT_EN                     0x0004
+#define HDMI_INT_STA                    0x0008
+#define HDMI_INT_CLR                    0x000C
+#define HDMI_STA                        0x0010
+#define HDMI_ACTIVE_VID_XMIN            0x0100
+#define HDMI_ACTIVE_VID_XMAX            0x0104
+#define HDMI_ACTIVE_VID_YMIN            0x0108
+#define HDMI_ACTIVE_VID_YMAX            0x010C
+#define HDMI_DFLT_CHL0_DAT              0x0110
+#define HDMI_DFLT_CHL1_DAT              0x0114
+#define HDMI_DFLT_CHL2_DAT              0x0118
+#define HDMI_SW_DI_1_HEAD_WORD          0x0210
+#define HDMI_SW_DI_1_PKT_WORD0          0x0214
+#define HDMI_SW_DI_1_PKT_WORD1          0x0218
+#define HDMI_SW_DI_1_PKT_WORD2          0x021C
+#define HDMI_SW_DI_1_PKT_WORD3          0x0220
+#define HDMI_SW_DI_1_PKT_WORD4          0x0224
+#define HDMI_SW_DI_1_PKT_WORD5          0x0228
+#define HDMI_SW_DI_1_PKT_WORD6          0x022C
+#define HDMI_SW_DI_CFG                  0x0230
+
+#define HDMI_IFRAME_SLOT_AVI            1
+
+#define  XCAT(prefix, x, suffix)        prefix ## x ## suffix
+#define  HDMI_SW_DI_N_HEAD_WORD(x)      XCAT(HDMI_SW_DI_, x, _HEAD_WORD)
+#define  HDMI_SW_DI_N_PKT_WORD0(x)      XCAT(HDMI_SW_DI_, x, _PKT_WORD0)
+#define  HDMI_SW_DI_N_PKT_WORD1(x)      XCAT(HDMI_SW_DI_, x, _PKT_WORD1)
+#define  HDMI_SW_DI_N_PKT_WORD2(x)      XCAT(HDMI_SW_DI_, x, _PKT_WORD2)
+#define  HDMI_SW_DI_N_PKT_WORD3(x)      XCAT(HDMI_SW_DI_, x, _PKT_WORD3)
+#define  HDMI_SW_DI_N_PKT_WORD4(x)      XCAT(HDMI_SW_DI_, x, _PKT_WORD4)
+#define  HDMI_SW_DI_N_PKT_WORD5(x)      XCAT(HDMI_SW_DI_, x, _PKT_WORD5)
+#define  HDMI_SW_DI_N_PKT_WORD6(x)      XCAT(HDMI_SW_DI_, x, _PKT_WORD6)
+
+#define HDMI_IFRAME_DISABLED            0x0
+#define HDMI_IFRAME_SINGLE_SHOT         0x1
+#define HDMI_IFRAME_FIELD               0x2
+#define HDMI_IFRAME_FRAME               0x3
+#define HDMI_IFRAME_MASK                0x3
+#define HDMI_IFRAME_CFG_DI_N(x, n)      ((x) << ((n-1)*4)) /* n from 1 to 6 */
+
+#define HDMI_CFG_DEVICE_EN_SHIFT         0
+#define HDMI_CFG_DEVICE_EN               (1 << HDMI_CFG_DEVICE_EN_SHIFT)
+#define HDMI_CFG_HDMI_NOT_DVI_SHIFT      1
+#define HDMI_CFG_HDMI_NOT_DVI            (1 << HDMI_CFG_HDMI_NOT_DVI_SHIFT)
+#define HDMI_CFG_HDCP_EN_SHIFT           2
+#define HDMI_CFG_HDCP_EN                 (1 << HDMI_CFG_HDCP_EN_SHIFT)
+#define HDMI_CFG_ESS_NOT_OESS_SHIFT      3
+#define HDMI_CFG_ESS_NOT_OESS            (1 << HDMI_CFG_ESS_NOT_OESS_SHIFT)
+#define HDMI_CFG_H_SYNC_POL_NEG_SHIFT    4
+#define HDMI_CFG_H_SYNC_POL_NEG          (1 << HDMI_CFG_H_SYNC_POL_NEG_SHIFT)
+#define HDMI_CFG_SINK_TERM_DET_EN_SHIFT  5
+#define HDMI_CFG_SINK_TERM_DET_EN        (1 << HDMI_CFG_SINK_TERM_DET_EN_SHIFT)
+#define HDMI_CFG_V_SYNC_POL_NEG_SHIFT    6
+#define HDMI_CFG_V_SYNC_POL_NEG          (1 << HDMI_CFG_V_SYNC_POL_NEG_SHIFT)
+#define HDMI_CFG_422_EN_SHIFT            8
+#define HDMI_CFG_422_EN                  (1 << HDMI_CFG_422_EN_SHIFT)
+#define HDMI_CFG_FIFO_OVERRUN_CLR_SHIFT  12
+#define HDMI_CFG_FIFO_OVERRUN_CLR        (1 << HDMI_CFG_FIFO_OVERRUN_CLR_SHIFT)
+#define HDMI_CFG_FIFO_UNDERRUN_CLR_SHIFT 13
+#define HDMI_CFG_FIFO_UNDERRUN_CLR       (1 << HDMI_CFG_FIFO_UNDERRUN_CLR_SHIFT)
+#define HDMI_CFG_SW_RST_EN_SHIFT         31
+#define HDMI_CFG_SW_RST_EN               (1 << HDMI_CFG_SW_RST_EN_SHIFT)
+
+#define HDMI_INT_GLOBAL		        (1 << 0)
+#define HDMI_INT_SW_RST                 (1 << 1)
+#define HDMI_INT_IFRAME                 (1 << 2)
+#define HDMI_INT_PIX_CAP                (1 << 3)
+#define HDMI_INT_HOT_PLUG               (1 << 4)
+#define HDMI_INT_DLL_LCK                (1 << 5)
+#define HDMI_INT_NEW_FRAME              (1 << 6)
+#define HDMI_INT_GENCTRL_PKT            (1 << 7)
+#define HDMI_INT_SPDIF_FIFO_OVERRUN     (1 << 8)
+#define HDMI_INT_VID_FIFO_UNDERRUN      (1 << 9)
+#define HDMI_INT_VID_FIFO_OVERRUN       (1 << 10)
+#define HDMI_INT_SINK_TERM_PRESENT      (1 << 11)
+#define HDMI_INT_DI_2                   (1 << 16)
+#define HDMI_INT_DI_3                   (1 << 17)
+#define HDMI_INT_DI_4                   (1 << 18)
+#define HDMI_INT_DI_5                   (1 << 19)
+#define HDMI_INT_DI_6                   (1 << 20)
+#define HDMI_INT_DI_DMA_VSYNC_DONE      (1 << 21)
+#define HDMI_INT_DI_VSYNC_DONE          (1 << 22)
+
+#define HDMI_DEFAULT_INT (HDMI_INT_SINK_TERM_PRESENT \
+			| HDMI_INT_DLL_LCK \
+			| HDMI_INT_HOT_PLUG \
+			| HDMI_INT_GLOBAL)
+
+#define HDMI_WORKING_INT (HDMI_INT_SINK_TERM_PRESENT \
+			| HDMI_INT_GENCTRL_PKT \
+			| HDMI_INT_NEW_FRAME \
+			| HDMI_INT_DLL_LCK \
+			| HDMI_INT_HOT_PLUG \
+			| HDMI_INT_PIX_CAP \
+			| HDMI_INT_SW_RST \
+			| HDMI_INT_GLOBAL)
+
+#define HDMI_STA_SW_RST_SHIFT           1
+#define HDMI_STA_SW_RST                 (1 << HDMI_STA_SW_RST_SHIFT)
+#define HDMI_STA_PIX_CAP_SHIFT          3
+#define HDMI_STA_PIX_CAP                (1 << HDMI_STA_PIX_CAP_SHIFT)
+#define HDMI_STA_HOT_PLUG_SHIFT         4
+#define HDMI_STA_HOT_PLUG               (1 << HDMI_STA_HOT_PLUG_SHIFT)
+#define HDMI_STA_DLL_LCK_SHIFT          5
+#define HDMI_STA_DLL_LCK                (1 << HDMI_STA_DLL_LCK_SHIFT)
+#define HDMI_STA_SINK_TERM_SHIFT        6
+#define HDMI_STA_SINK_TERM              (1 << HDMI_STA_SINK_TERM_SHIFT)
+#define HDMI_STA_FIFO_SAMPLES_SHIFT     8
+#define HDMI_STA_FIFO_SAMPLES           (0x1F << HDMI_STA_FIFO_SAMPLES_SHIFT)
+
+/*
+ * STI hdmi structure
+ *
+ * @dev: driver device
+ * @drm_dev: pointer to drm device
+ * @mode: current display mode selected
+ * @regs: hdmi register
+ * @syscfg: syscfg register for pll rejection configuration
+ * @clk_pix: hdmi pixel clock
+ * @clk_tmds: hdmi tmds clock
+ * @clk_phy: hdmi phy clock
+ * @clk_audio: hdmi audio clock
+ * @irq: hdmi interrupt number
+ * @tx3g0c55phy: true if 3g0c55phy is supported
+ * @enabled: true if hdmi is enabled else false
+ * @hpd_gpio: hdmi hot plug detect gpio number
+ * @hpd: hot plug detect status
+ * @wait_event: wait event
+ * @event_received: wait event status
+ * @reset: reset control of the hdmi phy
+ */
+struct sti_hdmi {
+	struct device dev;
+	struct drm_device *drm_dev;
+	struct drm_display_mode mode;
+	void __iomem *regs;
+	void __iomem *syscfg;
+	struct clk *clk_pix;
+	struct clk *clk_tmds;
+	struct clk *clk_phy;
+	struct clk *clk_audio;
+	int irq;
+	bool tx3g0c55phy;
+	bool enabled;
+	int hpd_gpio;
+	bool hpd;
+	wait_queue_head_t wait_event;
+	bool event_received;
+	struct reset_control *reset;
+};
+
+/* hdmi phy config structure
+ *
+ * A pointer to an array of these structures is passed to a TMDS (HDMI) output
+ * via the control interface to provide board and SoC specific
+ * configurations of the HDMI PHY. Each entry in the array specifies a hardware
+ * specific configuration for a given TMDS clock frequency range.
+ *
+ * @min_tmds_freq: Lower bound of TMDS clock frequency this entry applies to
+ * @max_tmds_freq: Upper bound of TMDS clock frequency this entry applies to
+ * @config: SoC specific register configuration
+ */
+struct hdmi_phy_config {
+	u32 min_tmds_freq;
+	u32 max_tmds_freq;
+	u32 config[4];
+};
+
+void sti_hdmi_attach_ddc_client(struct i2c_client *ddc);
+
+int sti_hdmi_tx3g0c55phy_start(struct sti_hdmi *hdmi);
+void sti_hdmi_tx3g0c55phy_stop(struct sti_hdmi *hdmi);
+void sti_hdmi_tx3g0c55phy_show(struct sti_hdmi *hdmi, struct seq_file *m);
+
+int sti_hdmi_tx3g4c28phy_start(struct sti_hdmi *hdmi);
+void sti_hdmi_tx3g4c28phy_stop(struct sti_hdmi *hdmi);
+void sti_hdmi_tx3g4c28phy_show(struct sti_hdmi *hdmi, struct seq_file *m);
+
+extern struct i2c_driver ddc_driver;
+#endif
diff --git a/drivers/gpu/drm/sti/sti_hdmi_tx3g0c55phy.c b/drivers/gpu/drm/sti/sti_hdmi_tx3g0c55phy.c
new file mode 100644
index 0000000..547e9ee
--- /dev/null
+++ b/drivers/gpu/drm/sti/sti_hdmi_tx3g0c55phy.c
@@ -0,0 +1,398 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2013
+ * Author: Vincent Abriou <vincent.abriou@st.com> for STMicroelectronics.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#include "sti_hdmi.h"
+
+#define HDMI_SRZ_PLL_CFG                0x0504
+#define HDMI_SRZ_TAP_1                  0x0508
+#define HDMI_SRZ_TAP_2                  0x050C
+#define HDMI_SRZ_TAP_3                  0x0510
+#define HDMI_SRZ_CTRL                   0x0514
+
+#define HDMI_SRZ_PLL_CFG_POWER_DOWN     (1 << 0)
+#define HDMI_SRZ_PLL_CFG_VCOR_SHIFT     1
+#define HDMI_SRZ_PLL_CFG_VCOR_425MHZ    0
+#define HDMI_SRZ_PLL_CFG_VCOR_850MHZ    1
+#define HDMI_SRZ_PLL_CFG_VCOR_1700MHZ   2
+#define HDMI_SRZ_PLL_CFG_VCOR_3000MHZ   3
+#define HDMI_SRZ_PLL_CFG_VCOR_MASK      3
+#define HDMI_SRZ_PLL_CFG_VCOR(x)        (x << HDMI_SRZ_PLL_CFG_VCOR_SHIFT)
+#define HDMI_SRZ_PLL_CFG_NDIV_SHIFT     8
+#define HDMI_SRZ_PLL_CFG_NDIV_MASK      (0x1F << HDMI_SRZ_PLL_CFG_NDIV_SHIFT)
+#define HDMI_SRZ_PLL_CFG_MODE_SHIFT     16
+#define HDMI_SRZ_PLL_CFG_MODE_13_5_MHZ  0x1
+#define HDMI_SRZ_PLL_CFG_MODE_25_2_MHZ  0x4
+#define HDMI_SRZ_PLL_CFG_MODE_27_MHZ    0x5
+#define HDMI_SRZ_PLL_CFG_MODE_33_75_MHZ 0x6
+#define HDMI_SRZ_PLL_CFG_MODE_40_5_MHZ  0x7
+#define HDMI_SRZ_PLL_CFG_MODE_54_MHZ    0x8
+#define HDMI_SRZ_PLL_CFG_MODE_67_5_MHZ  0x9
+#define HDMI_SRZ_PLL_CFG_MODE_74_25_MHZ 0xA
+#define HDMI_SRZ_PLL_CFG_MODE_81_MHZ    0xB
+#define HDMI_SRZ_PLL_CFG_MODE_82_5_MHZ  0xC
+#define HDMI_SRZ_PLL_CFG_MODE_108_MHZ   0xD
+#define HDMI_SRZ_PLL_CFG_MODE_148_5_MHZ 0xE
+#define HDMI_SRZ_PLL_CFG_MODE_165_MHZ   0xF
+#define HDMI_SRZ_PLL_CFG_MODE_MASK      0xF
+#define HDMI_SRZ_PLL_CFG_MODE(x)        (x << HDMI_SRZ_PLL_CFG_MODE_SHIFT)
+
+#define HDMI_SRZ_CTRL_POWER_DOWN        (1 << 0)
+#define HDMI_SRZ_CTRL_EXTERNAL_DATA_EN  (1 << 1)
+
+/* sysconf registers */
+#define HDMI_REJECTION_PLL_CONFIGURATION 0x0858	/* SYSTEM_CONFIG2534 */
+#define HDMI_REJECTION_PLL_STATUS        0x0948	/* SYSTEM_CONFIG2594 */
+
+#define REJECTION_PLL_HDMI_ENABLE_SHIFT 0
+#define REJECTION_PLL_HDMI_ENABLE_MASK  (0x1 << REJECTION_PLL_HDMI_ENABLE_SHIFT)
+#define REJECTION_PLL_HDMI_PDIV_SHIFT   24
+#define REJECTION_PLL_HDMI_PDIV_MASK    (0x7 << REJECTION_PLL_HDMI_PDIV_SHIFT)
+#define REJECTION_PLL_HDMI_NDIV_SHIFT   16
+#define REJECTION_PLL_HDMI_NDIV_MASK    (0xFF << REJECTION_PLL_HDMI_NDIV_SHIFT)
+#define REJECTION_PLL_HDMI_MDIV_SHIFT   8
+#define REJECTION_PLL_HDMI_MDIV_MASK    (0xFF << REJECTION_PLL_HDMI_MDIV_SHIFT)
+
+#define REJECTION_PLL_HDMI_REJ_PLL_LOCK (0x1 << 0)
+
+#define HDMI_TIMEOUT_PLL_LOCK  50	/*milliseconds */
+
+#define HDMI_WAIT_PLL_REJECTION_STATUS 1000
+
+/* pll mode structure
+ *
+ * A pointer to an array of these structures is passed to a TMDS (HDMI) output
+ * via the control interface to provide board and SoC specific
+ * configurations of the HDMI PHY. Each entry in the array specifies a hardware
+ * specific configuration for a given TMDS clock frequency range. The array
+ * should be terminated with an entry that has all fields set to zero.
+ *
+ * @min: Lower bound of TMDS clock frequency this entry applies to
+ * @max: Upper bound of TMDS clock frequency this entry applies to
+ * @mode: SoC specific register configuration
+ */
+struct pllmode {
+	u32 min;
+	u32 max;
+	u32 mode;
+};
+#define NB_PLL_MODE 7
+static struct pllmode pllmodes[NB_PLL_MODE] = {
+	{13500000, 13513500, HDMI_SRZ_PLL_CFG_MODE_13_5_MHZ},
+	{25174800, 25200000, HDMI_SRZ_PLL_CFG_MODE_25_2_MHZ},
+	{27000000, 27027000, HDMI_SRZ_PLL_CFG_MODE_27_MHZ},
+	{54000000, 54054000, HDMI_SRZ_PLL_CFG_MODE_54_MHZ},
+	{72000000, 74250000, HDMI_SRZ_PLL_CFG_MODE_74_25_MHZ},
+	{108000000, 108108000, HDMI_SRZ_PLL_CFG_MODE_108_MHZ},
+	{148351648, 297000000, HDMI_SRZ_PLL_CFG_MODE_148_5_MHZ}
+};
+
+#define NB_HDMI_PHY_CONFIG 5
+static struct hdmi_phy_config hdmiphy_config[NB_HDMI_PHY_CONFIG] = {
+	{0, 40000000, {0x00101010, 0x00101010, 0x00101010, 0x02} },
+	{40000000, 140000000, {0x00111111, 0x00111111, 0x00111111, 0x02} },
+	{140000000, 160000000, {0x00131313, 0x00101010, 0x00101010, 0x02} },
+	{160000000, 250000000, {0x00131313, 0x00111111, 0x00111111, 0x03FE} },
+	{250000000, 300000000, {0x00151515, 0x00101010, 0x00101010, 0x03FE} },
+};
+
+/*
+ * Helper to write bit field
+ *
+ * @addr: register to update
+ * @val: value to write
+ * @mask: bit field mask to use
+ */
+static inline void reg_writemask(void __iomem *addr, u32 val, u32 mask)
+{
+	u32 old = readl(addr);
+
+	val = (val & mask) | (old & ~mask);
+	writel(val, addr);
+}
+
+/*
+ * Enable the old BCH/rejection PLL is now reused to provide the CLKPXPLL
+ * clock input to the new PHY PLL that generates the serializer clock
+ * (TMDS*10) and the TMDS clock which is now fed back into the HDMI
+ * formatter instead of the TMDS clock line from ClockGenB.
+ *
+ * @hdmi: pointer on the hdmi internal structure
+ *
+ * Return -1 if error occurs
+ */
+static int enable_pll_rejection(struct sti_hdmi *hdmi)
+{
+	int inputclock;
+	u32 mdiv;
+	u32 ndiv;
+	u32 pdiv;
+	u32 mask;
+	u32 val;
+	int i;
+
+	DRM_DEBUG_DRIVER("\n");
+
+	inputclock = hdmi->mode.clock * 1000;
+
+	DRM_DEBUG_DRIVER("hdmi rejection pll input clock = %dHz\n", inputclock);
+
+	/* Force to power down the HDMI rejection PLL */
+	mask = REJECTION_PLL_HDMI_ENABLE_MASK;
+	val = 0x0 << REJECTION_PLL_HDMI_ENABLE_SHIFT;
+	reg_writemask(hdmi->syscfg + HDMI_REJECTION_PLL_CONFIGURATION,
+		      val, mask);
+
+	/* Check the HDMI rejection PLL is really down */
+	for (i = 0; i < HDMI_WAIT_PLL_REJECTION_STATUS; i++) {
+		val = readl(hdmi->syscfg + HDMI_REJECTION_PLL_STATUS);
+		if ((val & REJECTION_PLL_HDMI_REJ_PLL_LOCK) == 0)
+			break;
+	}
+	if (i == HDMI_WAIT_PLL_REJECTION_STATUS) {
+		DRM_ERROR("hdmi rejection pll is not well powered down\n");
+		return -1;
+	}
+
+	/* Power up the HDMI rejection PLL */
+	/*
+	 * Note: On this SoC (stiH416) we are forced to have the input clock
+	 * be equal to the HDMI pixel clock.
+	 *
+	 * The values here have been suggested by validation however they are
+	 * still provisional and subject to change.
+	 *
+	 * PLLout = (Fin*Mdiv) / ((2 * Ndiv) / 2^Pdiv)
+	 */
+	if (inputclock < 50000000) {
+		/*
+		 * For slower clocks we need to multiply more to keep the
+		 * internal VCO frequency within the physical specification
+		 * of the PLL.
+		 */
+		pdiv = 4;
+		ndiv = 240;
+		mdiv = 30;
+	} else {
+		pdiv = 2;
+		ndiv = 60;
+		mdiv = 30;
+	}
+
+	mask = REJECTION_PLL_HDMI_PDIV_MASK |
+	    REJECTION_PLL_HDMI_NDIV_MASK |
+	    REJECTION_PLL_HDMI_MDIV_MASK | REJECTION_PLL_HDMI_ENABLE_MASK;
+	val = (pdiv << REJECTION_PLL_HDMI_PDIV_SHIFT) |
+	    (ndiv << REJECTION_PLL_HDMI_NDIV_SHIFT) |
+	    (mdiv << REJECTION_PLL_HDMI_MDIV_SHIFT) |
+	    (0x1 << REJECTION_PLL_HDMI_ENABLE_SHIFT);
+	reg_writemask(hdmi->syscfg + HDMI_REJECTION_PLL_CONFIGURATION,
+		      val, mask);
+
+	/* Check the HDMI rejection PLL is really up */
+	for (i = 0; i < HDMI_WAIT_PLL_REJECTION_STATUS; i++) {
+		val = readl(hdmi->syscfg + HDMI_REJECTION_PLL_STATUS);
+		if ((val & REJECTION_PLL_HDMI_REJ_PLL_LOCK) != 0)
+			break;
+	}
+	if (i == HDMI_WAIT_PLL_REJECTION_STATUS) {
+		DRM_ERROR("hdmi rejection pll is not well powered up\n");
+		return -1;
+	}
+
+	DRM_DEBUG_DRIVER("hdmi rejection pll locked\n");
+
+	return 0;
+}
+
+/*
+ * Disable the pll rejection
+ *
+ * @hdmi: pointer on the hdmi internal structure
+ */
+static void disable_pll_rejection(struct sti_hdmi *hdmi)
+{
+	int i;
+	u32 val;
+	u32 mask;
+
+	DRM_DEBUG_DRIVER("\n");
+
+	mask = REJECTION_PLL_HDMI_ENABLE_MASK;
+	val = 0x0 << REJECTION_PLL_HDMI_ENABLE_SHIFT;
+	reg_writemask(hdmi->syscfg + HDMI_REJECTION_PLL_CONFIGURATION,
+		      val, mask);
+
+	/* Check the HDMI rejection PLL is really down */
+	for (i = 0; i < HDMI_WAIT_PLL_REJECTION_STATUS; i++) {
+		val = readl(hdmi->syscfg + HDMI_REJECTION_PLL_STATUS);
+		if ((val & REJECTION_PLL_HDMI_REJ_PLL_LOCK) == 0)
+			break;
+	}
+	if (i == HDMI_WAIT_PLL_REJECTION_STATUS)
+		DRM_ERROR("hdmi rejection pll is not well powered down\n");
+	else
+		DRM_DEBUG_DRIVER("hdmi rejection pll is powered down\n");
+}
+
+/*
+ * Start hdmi phy macro cell tx3g0c55
+ *
+ * @hdmi: pointer on the hdmi internal structure
+ *
+ * Return -1 if error occurs
+ */
+int sti_hdmi_tx3g0c55phy_start(struct sti_hdmi *hdmi)
+{
+	u32 ckpxpll = hdmi->mode.clock * 1000;
+	u32 tmdsck;
+	u32 freqvco;
+	u32 pllctrl = 0;
+	u32 val;
+	int i;
+
+	if (enable_pll_rejection(hdmi))
+		return -1;
+
+	DRM_DEBUG_DRIVER("ckpxpll = %dHz\n", ckpxpll);
+
+	/* TODO: manage DeepColor (30, 36 and 48 bits) and pixel repetition */
+
+	/* Assuming no pixel repetition and 24bits color */
+	tmdsck = ckpxpll;
+	pllctrl = 2 << HDMI_SRZ_PLL_CFG_NDIV_SHIFT;
+
+	/*
+	 * Setup the PLL mode parameter based on the ckpxpll. If we haven't got
+	 * a clock frequency supported by one of the specific PLL modes then we
+	 * will end up using the generic mode (0) which only supports a 10x
+	 * multiplier, hence only 24bit color.
+	 */
+	for (i = 0; i < NB_PLL_MODE; i++) {
+		if (ckpxpll >= pllmodes[i].min && ckpxpll <= pllmodes[i].max)
+			pllctrl |= HDMI_SRZ_PLL_CFG_MODE(pllmodes[i].mode);
+	}
+
+	freqvco = tmdsck * 10;
+	if (freqvco <= 425000000UL)
+		pllctrl |= HDMI_SRZ_PLL_CFG_VCOR(HDMI_SRZ_PLL_CFG_VCOR_425MHZ);
+	else if (freqvco <= 850000000UL)
+		pllctrl |= HDMI_SRZ_PLL_CFG_VCOR(HDMI_SRZ_PLL_CFG_VCOR_850MHZ);
+	else if (freqvco <= 1700000000UL)
+		pllctrl |= HDMI_SRZ_PLL_CFG_VCOR(HDMI_SRZ_PLL_CFG_VCOR_1700MHZ);
+	else if (freqvco <= 2970000000UL)
+		pllctrl |= HDMI_SRZ_PLL_CFG_VCOR(HDMI_SRZ_PLL_CFG_VCOR_3000MHZ);
+	else {
+		DRM_ERROR("PHY serializer clock out of range\n");
+		goto err;
+	}
+
+	/*
+	 * Configure and power up the PHY PLL
+	 */
+	hdmi->event_received = false;
+	DRM_DEBUG_DRIVER("pllctrl = 0x%x\n", pllctrl);
+	writel(pllctrl, hdmi->regs + HDMI_SRZ_PLL_CFG);
+
+	/* wait PLL interrupt */
+	wait_event_interruptible_timeout(hdmi->wait_event,
+					 hdmi->event_received == true,
+					 msecs_to_jiffies
+					 (HDMI_TIMEOUT_PLL_LOCK));
+
+	if ((readl(hdmi->regs + HDMI_STA) & HDMI_STA_DLL_LCK) == 0) {
+		DRM_ERROR("hdmi phy pll not locked\n");
+		goto err;
+	}
+
+	DRM_DEBUG_DRIVER("got PHY PLL Lock\n");
+
+	/*
+	 * To configure the source termination and pre-emphasis appropriately
+	 * for different high speed TMDS clock frequencies a phy configuration
+	 * table must be provided, tailored to the SoC and board combination.
+	 */
+	for (i = 0; i < NB_HDMI_PHY_CONFIG; i++) {
+		if ((hdmiphy_config[i].min_tmds_freq <= tmdsck) &&
+		    (hdmiphy_config[i].max_tmds_freq >= tmdsck)) {
+			val = hdmiphy_config[i].config[0];
+			writel(val, hdmi->regs + HDMI_SRZ_TAP_1);
+			val = hdmiphy_config[i].config[1];
+			writel(val, hdmi->regs + HDMI_SRZ_TAP_2);
+			val = hdmiphy_config[i].config[2];
+			writel(val, hdmi->regs + HDMI_SRZ_TAP_3);
+			val = hdmiphy_config[i].config[3];
+			val |= HDMI_SRZ_CTRL_EXTERNAL_DATA_EN;
+			val &= ~HDMI_SRZ_CTRL_POWER_DOWN;
+			writel(val, hdmi->regs + HDMI_SRZ_CTRL);
+
+			DRM_DEBUG_DRIVER("serializer cfg 0x%x 0x%x 0x%x 0x%x\n",
+					 hdmiphy_config[i].config[0],
+					 hdmiphy_config[i].config[1],
+					 hdmiphy_config[i].config[2],
+					 hdmiphy_config[i].config[3]);
+			return 0;
+		}
+	}
+
+	/*
+	 * Default, power up the serializer with no pre-emphasis or source
+	 * termination.
+	 */
+	writel(0x0, hdmi->regs + HDMI_SRZ_TAP_1);
+	writel(0x0, hdmi->regs + HDMI_SRZ_TAP_2);
+	writel(0x0, hdmi->regs + HDMI_SRZ_TAP_3);
+	writel(HDMI_SRZ_CTRL_EXTERNAL_DATA_EN, hdmi->regs + HDMI_SRZ_CTRL);
+
+	return 0;
+
+err:
+	disable_pll_rejection(hdmi);
+
+	return -1;
+}
+
+/*
+ * Stop hdmi phy macro cell tx3g0c55
+ *
+ * @hdmi: pointer on the hdmi internal structure
+ */
+void sti_hdmi_tx3g0c55phy_stop(struct sti_hdmi *hdmi)
+{
+	DRM_DEBUG_DRIVER("\n");
+
+	hdmi->event_received = false;
+
+	writel(HDMI_SRZ_CTRL_POWER_DOWN, hdmi->regs + HDMI_SRZ_CTRL);
+	writel(HDMI_SRZ_PLL_CFG_POWER_DOWN, hdmi->regs + HDMI_SRZ_PLL_CFG);
+
+	/* wait PLL interrupt */
+	wait_event_interruptible_timeout(hdmi->wait_event,
+					 hdmi->event_received == true,
+					 msecs_to_jiffies
+					 (HDMI_TIMEOUT_PLL_LOCK));
+
+	if ((readl(hdmi->regs + HDMI_STA) & HDMI_STA_DLL_LCK) == 1)
+		DRM_ERROR("hdmi phy pll not well disabled\n");
+	else
+		DRM_DEBUG_DRIVER("hdmi phy pll disabled\n");
+
+	disable_pll_rejection(hdmi);
+}
+
+/*
+ * Debugfs
+ */
+#define HDMI_DBG_DUMP(reg) seq_printf(m, "\n %-25s 0x%08X", #reg, \
+		readl(hdmi->regs + reg))
+void sti_hdmi_tx3g0c55phy_show(struct sti_hdmi *hdmi, struct seq_file *m)
+{
+	HDMI_DBG_DUMP(HDMI_SRZ_PLL_CFG);
+	HDMI_DBG_DUMP(HDMI_SRZ_TAP_1);
+	HDMI_DBG_DUMP(HDMI_SRZ_TAP_2);
+	HDMI_DBG_DUMP(HDMI_SRZ_TAP_3);
+	HDMI_DBG_DUMP(HDMI_SRZ_CTRL);
+	seq_puts(m, "\n");
+}
diff --git a/drivers/gpu/drm/sti/sti_hdmi_tx3g4c28phy.c b/drivers/gpu/drm/sti/sti_hdmi_tx3g4c28phy.c
new file mode 100644
index 0000000..6e0bc2c
--- /dev/null
+++ b/drivers/gpu/drm/sti/sti_hdmi_tx3g4c28phy.c
@@ -0,0 +1,224 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2013
+ * Author: Vincent Abriou <vincent.abriou@st.com> for STMicroelectronics.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#include "sti_hdmi.h"
+
+#define HDMI_SRZ_CFG                    0x504
+#define HDMI_SRZ_PLL_CFG                0x510
+#define HDMI_SRZ_ICNTL                  0x518
+#define HDMI_SRZ_CALCODE_EXT            0x520
+
+#define HDMI_SRZ_CFG_EN                          (1L<<0)
+#define HDMI_SRZ_CFG_DISABLE_BYPASS_SINK_CURRENT (1L<<1)
+#define HDMI_SRZ_CFG_EXTERNAL_DATA               (1L<<16)
+#define HDMI_SRZ_CFG_RBIAS_EXT                   (1L<<17)
+#define HDMI_SRZ_CFG_EN_SINK_TERM_DETECTION      (1L<<18)
+#define HDMI_SRZ_CFG_EN_BIASRES_DETECTION        (1L<<19)
+#define HDMI_SRZ_CFG_EN_SRC_TERMINATION          (1L<<24)
+
+#define HDMI_SRZ_CFG_INTERNAL_MASK  (HDMI_SRZ_CFG_EN     | \
+		HDMI_SRZ_CFG_DISABLE_BYPASS_SINK_CURRENT | \
+		HDMI_SRZ_CFG_EXTERNAL_DATA               | \
+		HDMI_SRZ_CFG_RBIAS_EXT                   | \
+		HDMI_SRZ_CFG_EN_SINK_TERM_DETECTION      | \
+		HDMI_SRZ_CFG_EN_BIASRES_DETECTION        | \
+		HDMI_SRZ_CFG_EN_SRC_TERMINATION)
+
+#define PLL_CFG_EN         (1L<<0)
+#define PLL_CFG_NDIV_SHIFT (8)
+#define PLL_CFG_IDF_SHIFT  (16)
+#define PLL_CFG_ODF_SHIFT  (24)
+
+#define ODF_DIV_1          (0)
+#define ODF_DIV_2          (1)
+#define ODF_DIV_4          (2)
+#define ODF_DIV_8          (3)
+
+#define HDMI_TIMEOUT_PLL_LOCK  50	/*milliseconds */
+
+struct plldividers_s {
+	uint32_t min;
+	uint32_t max;
+	uint32_t idf;
+	uint32_t odf;
+};
+
+/*
+ * Functional specification recommended values
+ */
+#define NB_PLL_MODE 5
+static struct plldividers_s plldividers[NB_PLL_MODE] = {
+	{0, 20000000, 1, ODF_DIV_8},
+	{20000000, 42500000, 2, ODF_DIV_8},
+	{42500000, 85000000, 4, ODF_DIV_4},
+	{85000000, 170000000, 8, ODF_DIV_2},
+	{170000000, 340000000, 16, ODF_DIV_1}
+};
+
+#define NB_HDMI_PHY_CONFIG 2
+static struct hdmi_phy_config hdmiphy_config[NB_HDMI_PHY_CONFIG] = {
+	{0, 250000000, {0x0, 0x0, 0x0, 0x0} },
+	{250000000, 300000000, {0x1110, 0x0, 0x0, 0x0} },
+};
+
+/*
+ * Start hdmi phy macro cell tx3g4c28
+ *
+ * @hdmi: pointer on the hdmi internal structure
+ *
+ * Return -1 if error occurs
+ */
+int sti_hdmi_tx3g4c28phy_start(struct sti_hdmi *hdmi)
+{
+	u32 ckpxpll = hdmi->mode.clock * 1000;
+	u32 tmdsck;
+	u32 idf;
+	u32 odf;
+	u32 pllctrl = 0;
+	u32 val;
+	int i;
+	bool foundplldivides = false;
+
+	DRM_DEBUG_DRIVER("ckpxpll = %dHz\n", ckpxpll);
+
+	for (i = 0; i < NB_PLL_MODE; i++) {
+		if (ckpxpll >= plldividers[i].min &&
+		    ckpxpll < plldividers[i].max) {
+			idf = plldividers[i].idf;
+			odf = plldividers[i].odf;
+			foundplldivides = true;
+			break;
+		}
+	}
+
+	if (!foundplldivides) {
+		DRM_ERROR("input TMDS clock speed (%d) not supported\n",
+			  ckpxpll);
+		goto err;
+	}
+
+	/* TODO: manage DeepColor (30, 36 and 48 bits) and pixel repetition */
+
+	/* Assuming no pixel repetition and 24bits color */
+	tmdsck = ckpxpll;
+	pllctrl |= 40 << PLL_CFG_NDIV_SHIFT;
+
+	if (tmdsck > 340000000) {
+		DRM_ERROR("output TMDS clock (%d) out of range\n", tmdsck);
+		goto err;
+	}
+
+	pllctrl |= idf << PLL_CFG_IDF_SHIFT;
+	pllctrl |= odf << PLL_CFG_ODF_SHIFT;
+
+	/*
+	 * Configure and power up the PHY PLL
+	 */
+	hdmi->event_received = false;
+	DRM_DEBUG_DRIVER("pllctrl = 0x%x\n", pllctrl);
+	writel((pllctrl | PLL_CFG_EN), hdmi->regs + HDMI_SRZ_PLL_CFG);
+
+	/* wait PLL interrupt */
+	wait_event_interruptible_timeout(hdmi->wait_event,
+					 hdmi->event_received == true,
+					 msecs_to_jiffies
+					 (HDMI_TIMEOUT_PLL_LOCK));
+
+	if ((readl(hdmi->regs + HDMI_STA) & HDMI_STA_DLL_LCK) == 0) {
+		DRM_ERROR("hdmi phy pll not locked\n");
+		goto err;
+	}
+
+	DRM_DEBUG_DRIVER("got PHY PLL Lock\n");
+
+	val = (HDMI_SRZ_CFG_EN |
+	       HDMI_SRZ_CFG_EXTERNAL_DATA |
+	       HDMI_SRZ_CFG_EN_BIASRES_DETECTION |
+	       HDMI_SRZ_CFG_EN_SINK_TERM_DETECTION);
+
+	if (tmdsck > 165000000)
+		val |= HDMI_SRZ_CFG_EN_SRC_TERMINATION;
+
+	/*
+	 * To configure the source termination and pre-emphasis appropriately
+	 * for different high speed TMDS clock frequencies a phy configuration
+	 * table must be provided, tailored to the SoC and board combination.
+	 */
+	for (i = 0; i < NB_HDMI_PHY_CONFIG; i++) {
+		if ((hdmiphy_config[i].min_tmds_freq <= tmdsck) &&
+		    (hdmiphy_config[i].max_tmds_freq >= tmdsck)) {
+			val |= (hdmiphy_config[i].config[0]
+				& ~HDMI_SRZ_CFG_INTERNAL_MASK);
+			writel(val, hdmi->regs + HDMI_SRZ_CFG);
+			val = hdmiphy_config[i].config[1];
+			writel(val, hdmi->regs + HDMI_SRZ_ICNTL);
+			val = hdmiphy_config[i].config[2];
+			writel(val, hdmi->regs + HDMI_SRZ_CALCODE_EXT);
+			DRM_DEBUG_DRIVER("serializer cfg 0x%x 0x%x 0x%x\n",
+					 hdmiphy_config[i].config[0],
+					 hdmiphy_config[i].config[1],
+					 hdmiphy_config[i].config[2]);
+			return 0;
+		}
+	}
+
+	/*
+	 * Default, power up the serializer with no pre-emphasis or
+	 * output swing correction
+	 */
+	writel(val, hdmi->regs + HDMI_SRZ_CFG);
+	writel(0x0, hdmi->regs + HDMI_SRZ_ICNTL);
+	writel(0x0, hdmi->regs + HDMI_SRZ_CALCODE_EXT);
+
+	return 0;
+
+err:
+	return -1;
+}
+
+/*
+ * Stop hdmi phy macro cell tx3g4c28
+ *
+ * @hdmi: pointer on the hdmi internal structure
+ */
+void sti_hdmi_tx3g4c28phy_stop(struct sti_hdmi *hdmi)
+{
+	int val = 0;
+
+	DRM_DEBUG_DRIVER("\n");
+
+	hdmi->event_received = false;
+
+	val = HDMI_SRZ_CFG_EN_SINK_TERM_DETECTION;
+	val |= HDMI_SRZ_CFG_EN_BIASRES_DETECTION;
+	writel(val, hdmi->regs + HDMI_SRZ_CFG);
+	writel(0, hdmi->regs + HDMI_SRZ_PLL_CFG);
+
+	/* wait PLL interrupt */
+	wait_event_interruptible_timeout(hdmi->wait_event,
+					 hdmi->event_received == true,
+					 msecs_to_jiffies
+					 (HDMI_TIMEOUT_PLL_LOCK));
+
+	if ((readl(hdmi->regs + HDMI_STA) & HDMI_STA_DLL_LCK) == 1)
+		DRM_ERROR("hdmi phy pll not well disabled\n");
+	else
+		DRM_DEBUG_DRIVER("hdmi phy pll disabled\n");
+}
+
+/*
+ * Debugfs
+ */
+#define HDMI_DBG_DUMP(reg) seq_printf(m, "\n %-25s 0x%08X", #reg, \
+		readl(hdmi->regs + reg))
+void sti_hdmi_tx3g4c28phy_show(struct sti_hdmi *hdmi, struct seq_file *m)
+{
+	HDMI_DBG_DUMP(HDMI_SRZ_CFG);
+	HDMI_DBG_DUMP(HDMI_SRZ_PLL_CFG);
+	HDMI_DBG_DUMP(HDMI_SRZ_ICNTL);
+	HDMI_DBG_DUMP(HDMI_SRZ_CALCODE_EXT);
+	seq_puts(m, "\n");
+}
-- 
1.9.1

