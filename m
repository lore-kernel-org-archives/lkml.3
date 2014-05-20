Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261AbaETOEh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 10:04:37 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:65132 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbaETN44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 09:56:56 -0400
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: dri-devel@lists.freedesktop.org, airlied@linux.ie,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH v3 01/16] drm: sti: add VTG driver
Date: Tue, 20 May 2014 15:56:11 +0200
Message-Id: <1400594186-8956-2-git-send-email-benjamin.gaignard@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400594186-8956-1-git-send-email-benjamin.gaignard@linaro.org>
References: <1400594186-8956-1-git-send-email-benjamin.gaignard@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Video Time Generator drivers are used to synchronize the compositor
and tvout hardware IPs by providing line count, sample count,
synchronization signals (HSYNC, VSYNC) and top and bottom fields indication.
VTG are used by pair for each data path (main or auxiliary): one for master and one for slave.

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
---
 drivers/gpu/drm/Kconfig             |   2 +
 drivers/gpu/drm/Makefile            |   1 +
 drivers/gpu/drm/sti/Kconfig         |  11 +
 drivers/gpu/drm/sti/Makefile        |   3 +
 drivers/gpu/drm/sti/sti_vtg.c       | 468 ++++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/sti/sti_vtg.h       |  20 ++
 drivers/gpu/drm/sti/sti_vtg_utils.c |  99 ++++++++
 drivers/gpu/drm/sti/sti_vtg_utils.h |  29 +++
 8 files changed, 633 insertions(+)
 create mode 100644 drivers/gpu/drm/sti/Kconfig
 create mode 100644 drivers/gpu/drm/sti/Makefile
 create mode 100644 drivers/gpu/drm/sti/sti_vtg.c
 create mode 100644 drivers/gpu/drm/sti/sti_vtg.h
 create mode 100644 drivers/gpu/drm/sti/sti_vtg_utils.c
 create mode 100644 drivers/gpu/drm/sti/sti_vtg_utils.h

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index d1cc2f6..0e30029 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -201,3 +201,5 @@ source "drivers/gpu/drm/tegra/Kconfig"
 source "drivers/gpu/drm/panel/Kconfig"
 
 source "drivers/gpu/drm/bridge/Kconfig"
+
+source "drivers/gpu/drm/sti/Kconfig"
diff --git a/drivers/gpu/drm/Makefile b/drivers/gpu/drm/Makefile
index 5e792b0..44f7b17 100644
--- a/drivers/gpu/drm/Makefile
+++ b/drivers/gpu/drm/Makefile
@@ -61,6 +61,7 @@ obj-$(CONFIG_DRM_QXL) += qxl/
 obj-$(CONFIG_DRM_BOCHS) += bochs/
 obj-$(CONFIG_DRM_MSM) += msm/
 obj-$(CONFIG_DRM_TEGRA) += tegra/
+obj-$(CONFIG_DRM_STI) += sti/
 obj-y			+= i2c/
 obj-y			+= panel/
 obj-y			+= bridge/
diff --git a/drivers/gpu/drm/sti/Kconfig b/drivers/gpu/drm/sti/Kconfig
new file mode 100644
index 0000000..3fff278
--- /dev/null
+++ b/drivers/gpu/drm/sti/Kconfig
@@ -0,0 +1,11 @@
+config DRM_STI
+	bool "DRM Support for STMicroelectronics SoC stiH41x Series"
+	depends on DRM && (SOC_STIH415 || SOC_STIH416 || ARCH_MULTIPLATFORM)
+	help
+	  Choose this option to enable DRM on STM stiH41x chipset
+
+config VTG_STI
+	bool "Video Timing Generator for STMicroelectronics SoC stiH41x Series"
+	depends on DRM_STI
+	help
+	  Choose this option to enable VTG on STM stiH41x chipset
diff --git a/drivers/gpu/drm/sti/Makefile b/drivers/gpu/drm/sti/Makefile
new file mode 100644
index 0000000..33216e1
--- /dev/null
+++ b/drivers/gpu/drm/sti/Makefile
@@ -0,0 +1,3 @@
+ccflags-y := -Iinclude/drm
+
+obj-$(CONFIG_VTG_STI) += sti_vtg.o sti_vtg_utils.o
diff --git a/drivers/gpu/drm/sti/sti_vtg.c b/drivers/gpu/drm/sti/sti_vtg.c
new file mode 100644
index 0000000..75d7125
--- /dev/null
+++ b/drivers/gpu/drm/sti/sti_vtg.c
@@ -0,0 +1,468 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2013
+ * Authors: Benjamin Gaignard <benjamin.gaignard@st.com>
+ *          Fabien Dessenne <fabien.dessenne@st.com>
+ *          Vincent Abriou <vincent.abriou@st.com>
+ *          for STMicroelectronics.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#include <linux/component.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/notifier.h>
+
+#include "sti_vtg_utils.h"
+#include "sti_vtg.h"
+
+#define VTG_TYPE_MASTER         0
+#define VTG_TYPE_SLAVE_BY_EXT0  1
+
+/* registers offset */
+#define VTG_MODE		0x0000
+#define VTG_CLKLN		0x0008
+#define VTG_HLFLN		0x000C
+#define VTG_DRST_AUTOC		0x0010
+#define VTG_VID_TFO		0x0040
+#define VTG_VID_TFS		0x0044
+#define VTG_VID_BFO		0x0048
+#define VTG_VID_BFS		0x004C
+
+#define VTG_HOST_ITS		0x0078
+#define VTG_HOST_ITS_BCLR	0x007C
+#define VTG_HOST_ITM_BCLR	0x0088
+#define VTG_HOST_ITM_BSET	0x008C
+
+#define VTG_H_HD_1		0x00C0
+#define VTG_TOP_V_VD_1		0x00C4
+#define VTG_BOT_V_VD_1		0x00C8
+#define VTG_TOP_V_HD_1		0x00CC
+#define VTG_BOT_V_HD_1		0x00D0
+
+#define VTG_H_HD_2		0x00E0
+#define VTG_TOP_V_VD_2		0x00E4
+#define VTG_BOT_V_VD_2		0x00E8
+#define VTG_TOP_V_HD_2		0x00EC
+#define VTG_BOT_V_HD_2		0x00F0
+
+#define VTG_H_HD_3		0x0100
+#define VTG_TOP_V_VD_3		0x0104
+#define VTG_BOT_V_VD_3		0x0108
+#define VTG_TOP_V_HD_3		0x010C
+#define VTG_BOT_V_HD_3		0x0110
+
+/* IRQ mask */
+#define VTG_IRQ_TOP_FIELD_MASK     (1L << 1)
+#define VTG_IRQ_BOTTOM_FIELD_MASK  (1L << 0)
+#define VTG_IRQ_MASK		   (VTG_IRQ_TOP_FIELD_MASK | \
+				    VTG_IRQ_BOTTOM_FIELD_MASK)
+
+/* Delay introduced by the AWG in nb of pixels */
+#define AWG_DELAY_HD            (-9)
+#define AWG_DELAY_ED            (-8)
+#define AWG_DELAY_SD            (-7)
+
+static const struct of_device_id vtg_match_types[];
+
+/*
+ * STI VTG data structure
+ *
+ * @nb_reg: number of memory resources to register
+ * @reg_names: names of the memory resources to register
+ * @regs: ioremapped registers
+ */
+#define MAX_MEM_REGION 2
+#define VTG_MASTER  0
+#define VTG_SLAVE   1
+struct sti_vtg_data {
+	int nb_reg;
+	char *reg_names[MAX_MEM_REGION];
+	void __iomem *regs[MAX_MEM_REGION];
+};
+
+/*
+ * STI VTG structure
+ *
+ * @dev: pointer to device driver
+ * @data: data associated to the device
+ * @irq: VTG irq
+ * @type: VTG type (main or aux)
+ * @notifier_list: notifier callback
+ */
+struct sti_vtg {
+	struct device *dev;
+	struct sti_vtg_data data;
+	int irq;
+	int type;
+	struct raw_notifier_head notifier_list;
+};
+
+/*
+ * STiH416:
+ * --------
+ * VTG slave is connected to the VTG master by the ext0 input (ext1 input is
+ * left unconnected).
+ *
+ *                  MPE               !   !             SAS
+ *    ________                        !   !                        ________
+ *   |        |                       !   !                  ext0 |        |
+ *   |        |              _________!   !_________        ----->|        |
+ *   |  VTG   |    hsync    |         !   !         | hsync |     |  VTG   |
+ *   |        |------------>| VTAC Tx !==>! VTAC Rx |--------     |        |
+ *   | master |    vsync    |_________!   !_________| vsync       | slave  |
+ *   |        |                       !   !                  ---->|        |
+ *   |________|                       !   !                  ext1 |________|
+ *                                    !   !                            |
+ *                                    !   !                       synchro_irq
+ * */
+struct sti_vtg_data stih416_vtg_data = {
+	.nb_reg = 2,
+	.reg_names = {"master", "slave"},
+};
+
+/*
+ * STiH407:
+ * --------
+ * Only VTG master is used. There is no MPE and SAS domain => only one domain.
+ *
+ *                  MPE
+ *    ________
+ *   |        |
+ *   |        |
+ *   |  VTG   |    hsync
+ *   |        |------------>
+ *   | master |    vsync
+ *   |        |
+ *   |________|
+ *        |
+ *  synchro_irq
+ * */
+struct sti_vtg_data stih407_vtg_data = {
+	.nb_reg = 1,
+	.reg_names = {"master"},
+};
+
+static int vtg_reset(void __iomem *regs)
+{
+	writel(1, regs + VTG_DRST_AUTOC);
+	return 0;
+}
+
+static int vtg_reg_dump(struct device *dev, void __iomem *regs)
+{
+	dev_dbg(dev, "regs %p\n", regs);
+	dev_dbg(dev, "VTG_MODE 0x%x\n", readl(regs + VTG_MODE));
+	dev_dbg(dev, "VTG_CLKLN 0x%x\n", readl(regs + VTG_CLKLN));
+	dev_dbg(dev, "VTG_HLFLN 0x%x\n", readl(regs + VTG_HLFLN));
+	dev_dbg(dev, "VTG_VID_TFO 0x%x\n", readl(regs + VTG_VID_TFO));
+	dev_dbg(dev, "VTG_VID_BFO 0x%x\n", readl(regs + VTG_VID_BFO));
+	dev_dbg(dev, "VTG_VID_TFS 0x%x\n", readl(regs + VTG_VID_TFS));
+	dev_dbg(dev, "VTG_VID_BFS 0x%x\n", readl(regs + VTG_VID_BFS));
+	dev_dbg(dev, "VTG_H_HD_1 0x%x\n", readl(regs + VTG_H_HD_1));
+	dev_dbg(dev, "VTG_TOP_V_VD_1 0x%x\n", readl(regs + VTG_TOP_V_VD_1));
+	dev_dbg(dev, "VTG_BOT_V_VD_1 0x%x\n", readl(regs + VTG_BOT_V_VD_1));
+	dev_dbg(dev, "VTG_TOP_V_HD_1 0x%x\n", readl(regs + VTG_TOP_V_HD_1));
+	dev_dbg(dev, "VTG_BOT_V_HD_1 0x%x\n", readl(regs + VTG_BOT_V_HD_1));
+	dev_dbg(dev, "VTG_H_HD_2 0x%x\n", readl(regs + VTG_H_HD_2));
+	dev_dbg(dev, "VTG_TOP_V_VD_2 0x%x\n", readl(regs + VTG_TOP_V_VD_2));
+	dev_dbg(dev, "VTG_BOT_V_VD_2 0x%x\n", readl(regs + VTG_BOT_V_VD_2));
+	dev_dbg(dev, "VTG_TOP_V_HD_2 0x%x\n", readl(regs + VTG_TOP_V_HD_2));
+	dev_dbg(dev, "VTG_BOT_V_HD_2 0x%x\n", readl(regs + VTG_BOT_V_HD_2));
+	dev_dbg(dev, "VTG_H_HD_3 0x%x\n", readl(regs + VTG_H_HD_3));
+	dev_dbg(dev, "VTG_TOP_V_VD_3 0x%x\n", readl(regs + VTG_TOP_V_VD_3));
+	dev_dbg(dev, "VTG_BOT_V_VD_3 0x%x\n", readl(regs + VTG_BOT_V_VD_3));
+	dev_dbg(dev, "VTG_TOP_V_HD_3 0x%x\n", readl(regs + VTG_TOP_V_HD_3));
+	dev_dbg(dev, "VTG_BOT_V_HD_3 0x%x\n", readl(regs + VTG_BOT_V_HD_3));
+	return 0;
+}
+
+static int vtg_write_reg(void __iomem *regs,
+			 int type, const struct drm_display_mode *mode)
+{
+	int fo, fs, h_hd, v_vd, v_hd;
+
+	writel(mode->htotal, regs + VTG_CLKLN);
+	writel(mode->vtotal * 2, regs + VTG_HLFLN);
+
+	fo = (mode->vtotal - mode->vsync_start + 1) << 16;
+	fo |= mode->htotal - mode->hsync_start;
+	writel(fo, regs + VTG_VID_TFO);
+	writel(fo, regs + VTG_VID_BFO);
+
+	fs = (mode->vdisplay + mode->vtotal - mode->vsync_start + 1) << 16;
+	fs |= mode->hdisplay + mode->htotal - mode->hsync_start;
+	writel(fs, regs + VTG_VID_TFS);
+	writel(fs, regs + VTG_VID_BFS);
+
+	/* Prepare VTG set 1 for HDMI and VTG set 3 for HD DAC */
+	h_hd = (mode->hsync_end - mode->hsync_start) << 16;
+	writel(h_hd, regs + VTG_H_HD_1);
+
+	v_vd = (mode->vsync_end - mode->vsync_start + 1) << 16;
+	v_vd |= 1;
+	writel(v_vd, regs + VTG_TOP_V_VD_1);
+	writel(v_vd, regs + VTG_BOT_V_VD_1);
+	writel(0, regs + VTG_TOP_V_HD_1);
+	writel(0, regs + VTG_BOT_V_HD_1);
+
+	/* Prepare VTG set 2 for for HD DCS */
+	writel(h_hd, regs + VTG_H_HD_2);
+	writel(v_vd, regs + VTG_TOP_V_VD_2);
+	writel(v_vd, regs + VTG_BOT_V_VD_2);
+	writel(0, regs + VTG_TOP_V_HD_2);
+	writel(0, regs + VTG_BOT_V_HD_2);
+
+	/* Prepare VTG set 3 for HD Analog in HD mode */
+	h_hd = (mode->hsync_end - mode->hsync_start + AWG_DELAY_HD) << 16;
+	h_hd |= mode->htotal + AWG_DELAY_HD;
+	writel(h_hd, regs + VTG_H_HD_3);
+
+	v_vd = (mode->vsync_end - mode->vsync_start) << 16;
+	v_vd |= mode->vtotal;
+	writel(v_vd, regs + VTG_TOP_V_VD_3);
+	writel(v_vd, regs + VTG_BOT_V_VD_3);
+
+	v_hd = (mode->htotal + AWG_DELAY_HD) << 16;
+	v_hd |= mode->htotal + AWG_DELAY_HD;
+	writel(v_hd, regs + VTG_TOP_V_HD_3);
+	writel(v_hd, regs + VTG_BOT_V_HD_3);
+
+	/* Mode */
+	writel(type, regs + VTG_MODE);
+	return 0;
+}
+
+static int vtg_disable_irq(void __iomem *regs)
+{
+	/* Clear interrupt status and mask */
+	writel(0xFFFF, regs + VTG_HOST_ITS_BCLR);
+	writel(0xFFFF, regs + VTG_HOST_ITM_BCLR);
+	return 0;
+}
+
+static int vtg_enable_irq(void __iomem *regs)
+{
+	vtg_disable_irq(regs);
+	writel(VTG_IRQ_MASK, regs + VTG_HOST_ITM_BSET);
+	return 0;
+}
+
+int vtg_set_config(struct device *dev, const struct drm_display_mode *mode)
+{
+	struct sti_vtg *vtg = dev_get_drvdata(dev);
+	struct sti_vtg_data *data = &vtg->data;
+
+	if (!vtg)
+		return 1;
+
+	if (!data->regs[VTG_MASTER])
+		return 1;
+
+	/* write slave / master configuration */
+	if (data->regs[VTG_SLAVE])
+		vtg_write_reg(data->regs[VTG_SLAVE],
+			      VTG_TYPE_SLAVE_BY_EXT0, mode);
+
+	vtg_write_reg(data->regs[VTG_MASTER], VTG_TYPE_MASTER, mode);
+
+	/* reset slave and then master */
+	if (data->regs[VTG_SLAVE])
+		vtg_reset(data->regs[VTG_SLAVE]);
+
+	vtg_reset(data->regs[VTG_MASTER]);
+
+	/* Enable irq for the vtg vblank synchro */
+	if (data->regs[VTG_SLAVE])
+		vtg_enable_irq(data->regs[VTG_SLAVE]);
+	else
+		vtg_enable_irq(data->regs[VTG_MASTER]);
+
+	if (data->regs[VTG_SLAVE])
+		vtg_reg_dump(dev, data->regs[VTG_SLAVE]);
+
+	vtg_reg_dump(dev, data->regs[VTG_MASTER]);
+
+	return 0;
+}
+
+int vtg_register_client(struct device *dev, struct notifier_block *nb)
+{
+	struct sti_vtg *vtg = dev_get_drvdata(dev);
+	return raw_notifier_chain_register(&vtg->notifier_list, nb);
+}
+
+int vtg_unregister_client(struct device *dev, struct notifier_block *nb)
+{
+	struct sti_vtg *vtg = dev_get_drvdata(dev);
+	return raw_notifier_chain_unregister(&vtg->notifier_list, nb);
+}
+
+static irqreturn_t vtg_irq_thread(int irq, void *arg)
+{
+	struct sti_vtg *vtg = arg;
+	struct sti_vtg_data *data = &vtg->data;
+	void __iomem *regs;
+	u32 status;
+
+	if (data->regs[VTG_SLAVE])
+		regs = data->regs[VTG_SLAVE];
+	else
+		regs = data->regs[VTG_MASTER];
+
+	status = readl(regs + VTG_HOST_ITS);
+
+	writel(status, regs + VTG_HOST_ITS_BCLR);
+	/* TODO: check why this sync bus write solves the problem which
+	 * is that without this line, the handler is sometimes called twice,
+	 * first with status = 1 or 2, and immediately after with status=0
+	 */
+	/* sync bus write */
+	readl(regs + VTG_HOST_ITS);
+
+	if (status & VTG_IRQ_TOP_FIELD_MASK) {
+		raw_notifier_call_chain(&vtg->notifier_list,
+					VTG_TOP_FIELD_EVENT, &vtg->type);
+	} else {
+		raw_notifier_call_chain(&vtg->notifier_list,
+					VTG_BOTTOM_FIELD_EVENT, &vtg->type);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static const char *vtg_get_name(struct sti_vtg *vtg)
+{
+	if (vtg->type == VTG_MAIN)
+		return "main";
+	else if (vtg->type == VTG_AUX)
+		return "aux";
+	else
+		return "?";
+}
+
+static int vtg_compositor_bind(struct device *dev, struct device *master,
+	void *d)
+{
+	return 0;
+}
+
+static void vtg_compositor_unbind(struct device *dev, struct device *master,
+	void *data)
+{
+	/* do nothing */
+}
+
+static const struct component_ops vtg_compositor_ops = {
+	.bind	= vtg_compositor_bind,
+	.unbind	= vtg_compositor_unbind,
+};
+
+static int vtg_compositor_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct device_node *np = dev->of_node;
+	struct sti_vtg *vtg;
+	struct resource *res;
+	char irq_name[32];
+	struct sti_vtg_data *data;
+	int i;
+	int ret;
+
+	DRM_INFO("%s\n", __func__);
+
+	if (!np)
+		return -ENXIO;
+
+	vtg = devm_kzalloc(dev, sizeof(*vtg), GFP_KERNEL);
+	if (!vtg) {
+		DRM_ERROR("Failed to allocate VTG context\n");
+		return -ENOMEM;
+	}
+
+	vtg->dev = dev;
+
+	/* populate data structure depending on compatibility */
+	BUG_ON(!of_match_node(vtg_match_types, np)->data);
+
+	memcpy(&vtg->data, of_match_node(vtg_match_types, np)->data,
+	       sizeof(struct sti_vtg_data));
+
+	data = &vtg->data;
+
+	/* Get resources */
+	for (i = 0; i < data->nb_reg; i++) {
+		res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
+						   data->reg_names[i]);
+		if (!res) {
+			DRM_ERROR("Invalid resource\n");
+			return -ENOMEM;
+		}
+		data->regs[i] = devm_ioremap_nocache(dev,
+						     res->start,
+						     resource_size(res));
+		if (IS_ERR(data->regs[i]))
+			return PTR_ERR(data->regs[i]);
+	}
+
+	vtg->irq = platform_get_irq_byname(pdev, "synchro_irq");
+	if (IS_ERR_VALUE(vtg->irq)) {
+		DRM_ERROR("Failed to get VTG interrupt\n");
+		return vtg->irq;
+	}
+
+	snprintf(irq_name, sizeof(irq_name), "vsync-%s", vtg_get_name(vtg));
+
+	RAW_INIT_NOTIFIER_HEAD(&vtg->notifier_list);
+
+	ret = devm_request_threaded_irq(dev, vtg->irq, NULL, vtg_irq_thread,
+					IRQF_ONESHOT, irq_name, vtg);
+	if (IS_ERR_VALUE(ret)) {
+		DRM_ERROR("Failed to register VTG interrupt\n");
+		return ret;
+	}
+
+	if (of_property_read_bool(np, "vtg-aux")) {
+		vtg->type = VTG_AUX;
+		vtg_aux = dev;
+	} else {
+		vtg->type = VTG_MAIN;
+		vtg_main = dev;
+	}
+
+	platform_set_drvdata(pdev, vtg);
+
+	DRM_INFO("%s VTG %s\n", __func__, vtg_get_name(vtg));
+
+	return component_add(&pdev->dev, &vtg_compositor_ops);
+}
+
+static int vtg_compositor_remove(struct platform_device *pdev)
+{
+	component_del(&pdev->dev, &vtg_compositor_ops);
+	return 0;
+}
+
+static const struct of_device_id vtg_match_types[] = {
+	{
+	 .compatible = "st,stih416-vtg",
+	 .data = &stih416_vtg_data,
+	 },
+	{
+	 .compatible = "st,stih407-vtg",
+	 .data = &stih407_vtg_data,
+	 },
+	{ /* end node */ }
+};
+MODULE_DEVICE_TABLE(of, vtg_match_types);
+
+struct platform_driver sti_vtg_driver = {
+	.driver = {
+		   .name = "sti-vtg",
+		   .owner = THIS_MODULE,
+		   .of_match_table = vtg_match_types,
+		   },
+	.probe = vtg_compositor_probe,
+	.remove = vtg_compositor_remove,
+};
+
+module_platform_driver(sti_vtg_driver);
diff --git a/drivers/gpu/drm/sti/sti_vtg.h b/drivers/gpu/drm/sti/sti_vtg.h
new file mode 100644
index 0000000..da67eb3
--- /dev/null
+++ b/drivers/gpu/drm/sti/sti_vtg.h
@@ -0,0 +1,20 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2013
+ * Author: Benjamin Gaignard <benjamin.gaignard@st.com> for STMicroelectronics.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#ifndef _STI_VTG_H_
+#define _STI_VTG_H_
+
+#include <linux/platform_device.h>
+#include <drm/drmP.h>
+
+extern struct device *vtg_main;
+extern struct device *vtg_aux;
+
+int vtg_set_config(struct device *dev, const struct drm_display_mode *mode);
+int vtg_register_client(struct device *dev, struct notifier_block *nb);
+int vtg_unregister_client(struct device *dev, struct notifier_block *nb);
+
+#endif
diff --git a/drivers/gpu/drm/sti/sti_vtg_utils.c b/drivers/gpu/drm/sti/sti_vtg_utils.c
new file mode 100644
index 0000000..06bb4b4
--- /dev/null
+++ b/drivers/gpu/drm/sti/sti_vtg_utils.c
@@ -0,0 +1,99 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2013
+ * Author: Benjamin Gaignard <benjamin.gaignard@st.com> for STMicroelectronics.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#include <linux/platform_device.h>
+
+#include "sti_vtg_utils.h"
+#include "sti_vtg.h"
+
+struct device *vtg_main;
+struct device *vtg_aux;
+
+int sti_vtg_setconfig(int main_aux, const struct drm_display_mode *mode)
+{
+	if (main_aux == VTG_MAIN && vtg_main)
+		return vtg_set_config(vtg_main, mode);
+
+	if (main_aux == VTG_AUX && vtg_aux)
+		return vtg_set_config(vtg_aux, mode);
+
+	return 1;
+}
+
+int sti_vtg_register_client(int main_aux, struct notifier_block *nb)
+{
+	if (main_aux == VTG_MAIN && vtg_main)
+		return vtg_register_client(vtg_main, nb);
+
+	if (main_aux == VTG_AUX && vtg_aux)
+		return vtg_register_client(vtg_aux, nb);
+
+	return 1;
+}
+
+int sti_vtg_unregister_client(int main_aux, struct notifier_block *nb)
+{
+	if (main_aux == VTG_MAIN && vtg_main)
+		return vtg_unregister_client(vtg_main, nb);
+
+	if (main_aux == VTG_AUX && vtg_aux)
+		return vtg_unregister_client(vtg_aux, nb);
+
+	return 1;
+}
+
+/*
+ *       Active        Front        Sync       Back          Active
+ *       Region        Porch                  Porch          Region
+ * <---------------><-------->0<---------><--------><----------------->
+ *
+ *   ///////////////|                               |  ///////////////|
+ *  /////////////// |                               | /////////////// |
+ * ///////////////  |.........            ..........|///////////////  |
+ *                            0___________      x/ymin           x/ymax
+ *
+ * <--[hv]display-->                                 <--[hv]display-->
+ * <--[hv]sync_start--------->                       <--[hv]sync_start-
+ * <--[hv]sync_end----------------------->           <--[hv]sync_end---
+ * <--[hv]total------------------------------------> <--[hv]total------
+ */
+
+/*
+ * sti_vtg_get_line_number
+ *
+ * @mode: display mode to be used
+ * @y:    line
+ *
+ * Return the line number according to the display mode taking
+ * into account the Sync and Back Porch information.
+ * Video frame line numbers start at 1, y starts at 0.
+ * In interlaced modes the start line is the field line number of the odd
+ * field, but y is still defined as a progressive frame.
+ */
+u32 sti_vtg_get_line_number(struct drm_display_mode mode, int y)
+{
+	int start_line = mode.vtotal - mode.vsync_start + 1;
+
+	if (mode.flags & DRM_MODE_FLAG_INTERLACE)
+		start_line *= 2;
+
+	return start_line + y;
+}
+
+/*
+ * sti_vtg_get_pixel_number
+ *
+ * @mode: display mode to be used
+ * @x:    row
+ *
+ * Return the pixel number according to the display mode taking
+ * into account the Sync and Back Porch information.
+ * Pixels are counted from 0.
+ */
+u32 sti_vtg_get_pixel_number(struct drm_display_mode mode, int x)
+{
+	return mode.htotal - mode.hsync_start + x;
+}
diff --git a/drivers/gpu/drm/sti/sti_vtg_utils.h b/drivers/gpu/drm/sti/sti_vtg_utils.h
new file mode 100644
index 0000000..fea2852
--- /dev/null
+++ b/drivers/gpu/drm/sti/sti_vtg_utils.h
@@ -0,0 +1,29 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2013
+ * Authors: Benjamin Gaignard <benjamin.gaignard@st.com>
+ *          Fabien Dessenne <fabien.dessenne@st.com>
+ *          for STMicroelectronics.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#ifndef _STI_VTG_UTILS_H_
+#define _STI_VTG_UTILS_H_
+
+#include <drm/drmP.h>
+
+#define WAIT_NEXT_VSYNC_MS      50 /*ms*/
+
+#define VTG_MAIN                0
+#define VTG_AUX                 1
+
+#define VTG_TOP_FIELD_EVENT     1
+#define VTG_BOTTOM_FIELD_EVENT  2
+
+int sti_vtg_setconfig(int main_aux, const struct drm_display_mode *mode);
+int sti_vtg_register_client(int main_aux, struct notifier_block *nb);
+int sti_vtg_unregister_client(int main_aux, struct notifier_block *nb);
+
+u32 sti_vtg_get_line_number(struct drm_display_mode mode, int y);
+u32 sti_vtg_get_pixel_number(struct drm_display_mode mode, int x);
+
+#endif
-- 
1.9.1

