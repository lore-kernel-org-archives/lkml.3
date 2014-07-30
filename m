Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975AbaG3RpX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 13:45:23 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:53823 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755580AbaG3Rmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 13:42:32 -0400
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org, airlied@linux.ie
Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH v8 02/11] drm: sti: add VTG driver
Date: Wed, 30 Jul 2014 19:41:58 +0200
Message-Id: <1406742127-27654-3-git-send-email-benjamin.gaignard@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406742127-27654-1-git-send-email-benjamin.gaignard@linaro.org>
References: <1406742127-27654-1-git-send-email-benjamin.gaignard@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Video Time Generator drivers are used to synchronize the compositor
and tvout hardware IPs by providing line count, sample count,
synchronization signals (HSYNC, VSYNC) and top and bottom fields
indication.
VTG are used by pair for each data path (main or auxiliary)
one for master and one for slave.

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Reviewed-by: Rob Clark <robdclark@gmail.com>
---
 drivers/gpu/drm/Kconfig       |   2 +
 drivers/gpu/drm/Makefile      |   1 +
 drivers/gpu/drm/sti/Kconfig   |   5 +
 drivers/gpu/drm/sti/Makefile  |   2 +
 drivers/gpu/drm/sti/sti_vtg.c | 366 ++++++++++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/sti/sti_vtg.h |  28 ++++
 6 files changed, 404 insertions(+)
 create mode 100644 drivers/gpu/drm/sti/Kconfig
 create mode 100644 drivers/gpu/drm/sti/Makefile
 create mode 100644 drivers/gpu/drm/sti/sti_vtg.c
 create mode 100644 drivers/gpu/drm/sti/sti_vtg.h

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index f512004..31894c8 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -201,3 +201,5 @@ source "drivers/gpu/drm/msm/Kconfig"
 source "drivers/gpu/drm/tegra/Kconfig"
 
 source "drivers/gpu/drm/panel/Kconfig"
+
+source "drivers/gpu/drm/sti/Kconfig"
diff --git a/drivers/gpu/drm/Makefile b/drivers/gpu/drm/Makefile
index 61d9e9c..60eb5d4 100644
--- a/drivers/gpu/drm/Makefile
+++ b/drivers/gpu/drm/Makefile
@@ -64,6 +64,7 @@ obj-$(CONFIG_DRM_QXL) += qxl/
 obj-$(CONFIG_DRM_BOCHS) += bochs/
 obj-$(CONFIG_DRM_MSM) += msm/
 obj-$(CONFIG_DRM_TEGRA) += tegra/
+obj-$(CONFIG_DRM_STI) += sti/
 obj-y			+= i2c/
 obj-y			+= panel/
 obj-y			+= bridge/
diff --git a/drivers/gpu/drm/sti/Kconfig b/drivers/gpu/drm/sti/Kconfig
new file mode 100644
index 0000000..a18df02
--- /dev/null
+++ b/drivers/gpu/drm/sti/Kconfig
@@ -0,0 +1,5 @@
+config DRM_STI
+	tristate "DRM Support for STMicroelectronics SoC stiH41x Series"
+	depends on DRM && (SOC_STIH415 || SOC_STIH416 || ARCH_MULTIPLATFORM)
+	help
+	  Choose this option to enable DRM on STM stiH41x chipset
diff --git a/drivers/gpu/drm/sti/Makefile b/drivers/gpu/drm/sti/Makefile
new file mode 100644
index 0000000..1759c20
--- /dev/null
+++ b/drivers/gpu/drm/sti/Makefile
@@ -0,0 +1,2 @@
+obj-$(CONFIG_DRM_STI) = \
+	sti_vtg.o
diff --git a/drivers/gpu/drm/sti/sti_vtg.c b/drivers/gpu/drm/sti/sti_vtg.c
new file mode 100644
index 0000000..740d6e3
--- /dev/null
+++ b/drivers/gpu/drm/sti/sti_vtg.c
@@ -0,0 +1,366 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2014
+ * Authors: Benjamin Gaignard <benjamin.gaignard@st.com>
+ *          Fabien Dessenne <fabien.dessenne@st.com>
+ *          Vincent Abriou <vincent.abriou@st.com>
+ *          for STMicroelectronics.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#include <linux/module.h>
+#include <linux/notifier.h>
+#include <linux/platform_device.h>
+
+#include <drm/drmP.h>
+
+#include "sti_vtg.h"
+
+#define VTG_TYPE_MASTER         0
+#define VTG_TYPE_SLAVE_BY_EXT0  1
+
+/* registers offset */
+#define VTG_MODE            0x0000
+#define VTG_CLKLN           0x0008
+#define VTG_HLFLN           0x000C
+#define VTG_DRST_AUTOC      0x0010
+#define VTG_VID_TFO         0x0040
+#define VTG_VID_TFS         0x0044
+#define VTG_VID_BFO         0x0048
+#define VTG_VID_BFS         0x004C
+
+#define VTG_HOST_ITS        0x0078
+#define VTG_HOST_ITS_BCLR   0x007C
+#define VTG_HOST_ITM_BCLR   0x0088
+#define VTG_HOST_ITM_BSET   0x008C
+
+#define VTG_H_HD_1          0x00C0
+#define VTG_TOP_V_VD_1      0x00C4
+#define VTG_BOT_V_VD_1      0x00C8
+#define VTG_TOP_V_HD_1      0x00CC
+#define VTG_BOT_V_HD_1      0x00D0
+
+#define VTG_H_HD_2          0x00E0
+#define VTG_TOP_V_VD_2      0x00E4
+#define VTG_BOT_V_VD_2      0x00E8
+#define VTG_TOP_V_HD_2      0x00EC
+#define VTG_BOT_V_HD_2      0x00F0
+
+#define VTG_H_HD_3          0x0100
+#define VTG_TOP_V_VD_3      0x0104
+#define VTG_BOT_V_VD_3      0x0108
+#define VTG_TOP_V_HD_3      0x010C
+#define VTG_BOT_V_HD_3      0x0110
+
+#define VTG_IRQ_BOTTOM      BIT(0)
+#define VTG_IRQ_TOP         BIT(1)
+#define VTG_IRQ_MASK        (VTG_IRQ_TOP | VTG_IRQ_BOTTOM)
+
+/* delay introduced by the Arbitrary Waveform Generator in nb of pixels */
+#define AWG_DELAY_HD        (-9)
+#define AWG_DELAY_ED        (-8)
+#define AWG_DELAY_SD        (-7)
+
+LIST_HEAD(vtg_lookup);
+
+/**
+ * STI VTG structure
+ *
+ * @dev: pointer to device driver
+ * @data: data associated to the device
+ * @irq: VTG irq
+ * @type: VTG type (main or aux)
+ * @notifier_list: notifier callback
+ * @crtc_id: the crtc id for vblank event
+ * @slave: slave vtg
+ * @link: List node to link the structure in lookup list
+ */
+struct sti_vtg {
+	struct device *dev;
+	struct device_node *np;
+	void __iomem *regs;
+	int irq;
+	u32 irq_status;
+	struct raw_notifier_head notifier_list;
+	int crtc_id;
+	struct sti_vtg *slave;
+	struct list_head link;
+};
+
+static void vtg_register(struct sti_vtg *vtg)
+{
+	list_add_tail(&vtg->link, &vtg_lookup);
+}
+
+struct sti_vtg *of_vtg_find(struct device_node *np)
+{
+	struct sti_vtg *vtg;
+
+	list_for_each_entry(vtg, &vtg_lookup, link) {
+		if (vtg->np == np)
+			return vtg;
+	}
+	return NULL;
+}
+EXPORT_SYMBOL(of_vtg_find);
+
+static void vtg_reset(struct sti_vtg *vtg)
+{
+	/* reset slave and then master */
+	if (vtg->slave)
+		vtg_reset(vtg->slave);
+
+	writel(1, vtg->regs + VTG_DRST_AUTOC);
+}
+
+static void vtg_set_mode(struct sti_vtg *vtg,
+			 int type, const struct drm_display_mode *mode)
+{
+	u32 tmp;
+
+	if (vtg->slave)
+		vtg_set_mode(vtg->slave, VTG_TYPE_SLAVE_BY_EXT0, mode);
+
+	writel(mode->htotal, vtg->regs + VTG_CLKLN);
+	writel(mode->vtotal * 2, vtg->regs + VTG_HLFLN);
+
+	tmp = (mode->vtotal - mode->vsync_start + 1) << 16;
+	tmp |= mode->htotal - mode->hsync_start;
+	writel(tmp, vtg->regs + VTG_VID_TFO);
+	writel(tmp, vtg->regs + VTG_VID_BFO);
+
+	tmp = (mode->vdisplay + mode->vtotal - mode->vsync_start + 1) << 16;
+	tmp |= mode->hdisplay + mode->htotal - mode->hsync_start;
+	writel(tmp, vtg->regs + VTG_VID_TFS);
+	writel(tmp, vtg->regs + VTG_VID_BFS);
+
+	/* prepare VTG set 1 and 2 for HDMI and VTG set 3 for HD DAC */
+	tmp = (mode->hsync_end - mode->hsync_start) << 16;
+	writel(tmp, vtg->regs + VTG_H_HD_1);
+	writel(tmp, vtg->regs + VTG_H_HD_2);
+
+	tmp = (mode->vsync_end - mode->vsync_start + 1) << 16;
+	tmp |= 1;
+	writel(tmp, vtg->regs + VTG_TOP_V_VD_1);
+	writel(tmp, vtg->regs + VTG_BOT_V_VD_1);
+	writel(0, vtg->regs + VTG_TOP_V_HD_1);
+	writel(0, vtg->regs + VTG_BOT_V_HD_1);
+
+	/* prepare VTG set 2 for for HD DCS */
+	writel(tmp, vtg->regs + VTG_TOP_V_VD_2);
+	writel(tmp, vtg->regs + VTG_BOT_V_VD_2);
+	writel(0, vtg->regs + VTG_TOP_V_HD_2);
+	writel(0, vtg->regs + VTG_BOT_V_HD_2);
+
+	/* prepare VTG set 3 for HD Analog in HD mode */
+	tmp = (mode->hsync_end - mode->hsync_start + AWG_DELAY_HD) << 16;
+	tmp |= mode->htotal + AWG_DELAY_HD;
+	writel(tmp, vtg->regs + VTG_H_HD_3);
+
+	tmp = (mode->vsync_end - mode->vsync_start) << 16;
+	tmp |= mode->vtotal;
+	writel(tmp, vtg->regs + VTG_TOP_V_VD_3);
+	writel(tmp, vtg->regs + VTG_BOT_V_VD_3);
+
+	tmp = (mode->htotal + AWG_DELAY_HD) << 16;
+	tmp |= mode->htotal + AWG_DELAY_HD;
+	writel(tmp, vtg->regs + VTG_TOP_V_HD_3);
+	writel(tmp, vtg->regs + VTG_BOT_V_HD_3);
+
+	/* mode */
+	writel(type, vtg->regs + VTG_MODE);
+}
+
+static void vtg_enable_irq(struct sti_vtg *vtg)
+{
+	/* clear interrupt status and mask */
+	writel(0xFFFF, vtg->regs + VTG_HOST_ITS_BCLR);
+	writel(0xFFFF, vtg->regs + VTG_HOST_ITM_BCLR);
+	writel(VTG_IRQ_MASK, vtg->regs + VTG_HOST_ITM_BSET);
+}
+
+void sti_vtg_set_config(struct sti_vtg *vtg,
+		const struct drm_display_mode *mode)
+{
+	/* write configuration */
+	vtg_set_mode(vtg, VTG_TYPE_MASTER, mode);
+
+	vtg_reset(vtg);
+
+	/* enable irq for the vtg vblank synchro */
+	if (vtg->slave)
+		vtg_enable_irq(vtg->slave);
+	else
+		vtg_enable_irq(vtg);
+}
+EXPORT_SYMBOL(sti_vtg_set_config);
+
+/**
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
+	u32 start_line = mode.vtotal - mode.vsync_start + 1;
+
+	if (mode.flags & DRM_MODE_FLAG_INTERLACE)
+		start_line *= 2;
+
+	return start_line + y;
+}
+EXPORT_SYMBOL(sti_vtg_get_line_number);
+
+/**
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
+EXPORT_SYMBOL(sti_vtg_get_pixel_number);
+
+int sti_vtg_register_client(struct sti_vtg *vtg,
+		struct notifier_block *nb, int crtc_id)
+{
+	if (vtg->slave)
+		return sti_vtg_register_client(vtg->slave, nb, crtc_id);
+
+	vtg->crtc_id = crtc_id;
+	return raw_notifier_chain_register(&vtg->notifier_list, nb);
+}
+EXPORT_SYMBOL(sti_vtg_register_client);
+
+int sti_vtg_unregister_client(struct sti_vtg *vtg, struct notifier_block *nb)
+{
+	if (vtg->slave)
+		return sti_vtg_unregister_client(vtg->slave, nb);
+
+	return raw_notifier_chain_unregister(&vtg->notifier_list, nb);
+}
+EXPORT_SYMBOL(sti_vtg_unregister_client);
+
+static irqreturn_t vtg_irq_thread(int irq, void *arg)
+{
+	struct sti_vtg *vtg = arg;
+	u32 event;
+
+	event = (vtg->irq_status & VTG_IRQ_TOP) ?
+		VTG_TOP_FIELD_EVENT : VTG_BOTTOM_FIELD_EVENT;
+
+	raw_notifier_call_chain(&vtg->notifier_list, event, &vtg->crtc_id);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t vtg_irq(int irq, void *arg)
+{
+	struct sti_vtg *vtg = arg;
+
+	vtg->irq_status = readl(vtg->regs + VTG_HOST_ITS);
+
+	writel(vtg->irq_status, vtg->regs + VTG_HOST_ITS_BCLR);
+
+	/* force sync bus write */
+	readl(vtg->regs + VTG_HOST_ITS);
+
+	return IRQ_WAKE_THREAD;
+}
+
+static int vtg_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct device_node *np;
+	struct sti_vtg *vtg;
+	struct resource *res;
+	char irq_name[32];
+	int ret;
+
+	vtg = devm_kzalloc(dev, sizeof(*vtg), GFP_KERNEL);
+	if (!vtg)
+		return -ENOMEM;
+
+	vtg->dev = dev;
+	vtg->np = pdev->dev.of_node;
+
+	/* Get Memory ressources */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		DRM_ERROR("Get memory resource failed\n");
+		return -ENOMEM;
+	}
+	vtg->regs = devm_ioremap_nocache(dev, res->start, resource_size(res));
+
+	np = of_parse_phandle(pdev->dev.of_node, "st,slave", 0);
+	if (np) {
+		vtg->slave = of_vtg_find(np);
+
+		if (!vtg->slave)
+			return -EPROBE_DEFER;
+	} else {
+		vtg->irq = platform_get_irq(pdev, 0);
+		if (IS_ERR_VALUE(vtg->irq)) {
+			DRM_ERROR("Failed to get VTG interrupt\n");
+			return vtg->irq;
+		}
+
+		snprintf(irq_name, sizeof(irq_name), "vsync-%s",
+				dev_name(vtg->dev));
+
+		RAW_INIT_NOTIFIER_HEAD(&vtg->notifier_list);
+
+		ret = devm_request_threaded_irq(dev, vtg->irq, vtg_irq,
+				vtg_irq_thread, IRQF_ONESHOT, irq_name, vtg);
+		if (IS_ERR_VALUE(ret)) {
+			DRM_ERROR("Failed to register VTG interrupt\n");
+			return ret;
+		}
+	}
+
+	vtg_register(vtg);
+	platform_set_drvdata(pdev, vtg);
+
+	DRM_INFO("%s %s\n", __func__, dev_name(vtg->dev));
+
+	return 0;
+}
+
+static int vtg_remove(struct platform_device *pdev)
+{
+	return 0;
+}
+
+static const struct of_device_id vtg_of_match[] = {
+	{ .compatible = "st,vtg", },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, vtg_of_match);
+
+struct platform_driver sti_vtg_driver = {
+	.driver = {
+		.name = "sti-vtg",
+		.owner = THIS_MODULE,
+		.of_match_table = vtg_of_match,
+	},
+	.probe	= vtg_probe,
+	.remove = vtg_remove,
+};
+
+module_platform_driver(sti_vtg_driver);
+
+MODULE_AUTHOR("Benjamin Gaignard <benjamin.gaignard@st.com>");
+MODULE_DESCRIPTION("STMicroelectronics SoC DRM driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/gpu/drm/sti/sti_vtg.h b/drivers/gpu/drm/sti/sti_vtg.h
new file mode 100644
index 0000000..e84d23f
--- /dev/null
+++ b/drivers/gpu/drm/sti/sti_vtg.h
@@ -0,0 +1,28 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2014
+ * Author: Benjamin Gaignard <benjamin.gaignard@st.com> for STMicroelectronics.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#ifndef _STI_VTG_H_
+#define _STI_VTG_H_
+
+#define VTG_TOP_FIELD_EVENT     1
+#define VTG_BOTTOM_FIELD_EVENT  2
+
+struct sti_vtg;
+struct drm_display_mode;
+struct notifier_block;
+
+struct sti_vtg *of_vtg_find(struct device_node *np);
+void sti_vtg_set_config(struct sti_vtg *vtg,
+		const struct drm_display_mode *mode);
+int sti_vtg_register_client(struct sti_vtg *vtg,
+		struct notifier_block *nb, int crtc_id);
+int sti_vtg_unregister_client(struct sti_vtg *vtg,
+		struct notifier_block *nb);
+
+u32 sti_vtg_get_line_number(struct drm_display_mode mode, int y);
+u32 sti_vtg_get_pixel_number(struct drm_display_mode mode, int x);
+
+#endif
-- 
1.9.1

