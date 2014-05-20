Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652AbaETN5A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 09:57:00 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:40410 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506AbaETN46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 09:56:58 -0400
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: dri-devel@lists.freedesktop.org, airlied@linux.ie,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH v3 02/16] drm: sti: add VTAC drivers
Date: Tue, 20 May 2014 15:56:12 +0200
Message-Id: <1400594186-8956-3-git-send-email-benjamin.gaignard@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400594186-8956-1-git-send-email-benjamin.gaignard@linaro.org>
References: <1400594186-8956-1-git-send-email-benjamin.gaignard@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Video Trafic Advance Communication Rx and Tx drivers are designed
for inter-die communication.

Both Tx and Rx must share the same configuration to communicate
that is why vtac_mode[] is shared in sti_vtac_utils.h.

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
---
 drivers/gpu/drm/sti/Kconfig          |   6 ++
 drivers/gpu/drm/sti/Makefile         |   1 +
 drivers/gpu/drm/sti/sti_vtac_rx.c    | 169 ++++++++++++++++++++++++++++++++
 drivers/gpu/drm/sti/sti_vtac_tx.c    | 182 +++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/sti/sti_vtac_utils.h |  52 ++++++++++
 5 files changed, 410 insertions(+)
 create mode 100644 drivers/gpu/drm/sti/sti_vtac_rx.c
 create mode 100644 drivers/gpu/drm/sti/sti_vtac_tx.c
 create mode 100644 drivers/gpu/drm/sti/sti_vtac_utils.h

diff --git a/drivers/gpu/drm/sti/Kconfig b/drivers/gpu/drm/sti/Kconfig
index 3fff278..87e6128 100644
--- a/drivers/gpu/drm/sti/Kconfig
+++ b/drivers/gpu/drm/sti/Kconfig
@@ -4,6 +4,12 @@ config DRM_STI
 	help
 	  Choose this option to enable DRM on STM stiH41x chipset
 
+config VTAC_STI
+	bool "Video Trafic Advance Communication Rx and Tx for STMicroelectronics SoC stiH41x Series"
+	depends on DRM_STI
+	help
+	  Choose this option to enable VTAC on STM stiH41x chipset
+
 config VTG_STI
 	bool "Video Timing Generator for STMicroelectronics SoC stiH41x Series"
 	depends on DRM_STI
diff --git a/drivers/gpu/drm/sti/Makefile b/drivers/gpu/drm/sti/Makefile
index 33216e1..79fdcb6 100644
--- a/drivers/gpu/drm/sti/Makefile
+++ b/drivers/gpu/drm/sti/Makefile
@@ -1,3 +1,4 @@
 ccflags-y := -Iinclude/drm
 
+obj-$(CONFIG_VTAC_STI) += sti_vtac_tx.o sti_vtac_rx.o
 obj-$(CONFIG_VTG_STI) += sti_vtg.o sti_vtg_utils.o
diff --git a/drivers/gpu/drm/sti/sti_vtac_rx.c b/drivers/gpu/drm/sti/sti_vtac_rx.c
new file mode 100644
index 0000000..77eae19
--- /dev/null
+++ b/drivers/gpu/drm/sti/sti_vtac_rx.c
@@ -0,0 +1,169 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2013
+ * Author: Benjamin Gaignard <benjamin.gaignard@st.com> for STMicroelectronics.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+#include <linux/clk.h>
+#include <linux/component.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+
+#include <drm/drmP.h>
+
+#include "sti_vtac_utils.h"
+
+#define VTAC_RX_CONFIG		0x00
+#define VTAC_RX_FIFO_CONFIG	0x04
+
+#define VTAC_SW_RST_AUTOC	0x02
+#define VTAC_FIFO_CONFIG_VAL	0x04
+
+/*
+ * VTAC RX structure
+ *
+ * @dev: pointer to device structure
+ * @regs: ioremapped regsiters
+ * @clk: clock
+ * @type: main or aux device
+ */
+struct sti_vtac_rx {
+	struct device *dev;
+	void __iomem *regs;
+	struct clk *clk;
+	int type;
+};
+
+static void sti_vtac_rx_reg_dump(struct sti_vtac_rx *vtac_rx)
+{
+	dev_dbg(vtac_rx->dev, "vtac_rx->regs %p\n", vtac_rx->regs);
+	dev_dbg(vtac_rx->dev, "VTAC_RX_CONFIG 0x%x\n",
+		readl(vtac_rx->regs + VTAC_RX_CONFIG));
+	dev_dbg(vtac_rx->dev, "VTAC_RX_FIFO_CONFIG 0x%x\n",
+		readl(vtac_rx->regs + VTAC_RX_FIFO_CONFIG));
+}
+
+static void sti_vtac_rx_set_config(struct sti_vtac_rx *vtac_rx)
+{
+	int i;
+	u32 rx_config = EVEN_PARITY | ODD_PARITY | SW_RST_AUTOC | ENABLE;
+
+	/* Enable VTAC clock */
+	if (clk_prepare_enable(vtac_rx->clk))
+		DRM_ERROR("Failed to prepare/enable vtac_rx clock.\n");
+
+	for (i = 0; i < ARRAY_SIZE(vtac_modes); i++) {
+		if (vtac_modes[i].type == vtac_rx->type) {
+			writel(VTAC_FIFO_CONFIG_VAL,
+			       vtac_rx->regs + VTAC_RX_FIFO_CONFIG);
+			rx_config |= vtac_modes[i].vid_in_width << 4;
+			rx_config |= vtac_modes[i].phyts_width << 16;
+			rx_config |= vtac_modes[i].phyts_per_pixel << 23;
+			rx_config |= VTAC_SW_RST_AUTOC;
+			writel(rx_config, vtac_rx->regs + VTAC_RX_CONFIG);
+		}
+	}
+}
+
+static int vtac_rx_bind(struct device *dev, struct device *master, void *data)
+{
+	return 0;
+}
+
+static void vtac_rx_unbind(struct device *dev, struct device *master,
+	void *data)
+{
+	/* do nothing */
+}
+
+static const struct component_ops vtac_rx_ops = {
+	.bind	= vtac_rx_bind,
+	.unbind	= vtac_rx_unbind,
+};
+
+static int sti_vtac_rx_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct device_node *np = dev->of_node;
+	struct sti_vtac_rx *vtac_rx;
+	struct resource *res;
+
+	DRM_INFO("%s\n", __func__);
+
+	vtac_rx = devm_kzalloc(dev, sizeof(*vtac_rx), GFP_KERNEL);
+	if (!vtac_rx) {
+		DRM_ERROR("Failed to allocate VTAC RX context\n");
+		return -ENOMEM;
+	}
+	vtac_rx->dev = dev;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		DRM_ERROR("Invalid resource\n");
+		return -ENOMEM;
+	}
+	vtac_rx->regs = devm_ioremap_resource(dev, res);
+	if (IS_ERR(vtac_rx->regs))
+		return PTR_ERR(vtac_rx->regs);
+
+	vtac_rx->type = VTAC_MAIN;
+	if (np)
+		if (of_property_read_bool(np, "vtac-rx-aux"))
+			vtac_rx->type = VTAC_AUX;
+
+	if (vtac_rx->type == VTAC_MAIN) {
+		vtac_rx->clk = devm_clk_get(dev, "vtac_main_phy");
+		if (IS_ERR(vtac_rx->clk)) {
+			DRM_ERROR("Cannot get vtac_main_phy clock\n");
+			return PTR_ERR(vtac_rx->clk);
+		}
+	} else {
+		vtac_rx->clk = devm_clk_get(dev, "vtac_aux_phy");
+		if (IS_ERR(vtac_rx->clk)) {
+			DRM_ERROR("Cannot get vtac_aux_phy clock\n");
+			return PTR_ERR(vtac_rx->clk);
+		}
+	}
+
+	sti_vtac_rx_set_config(vtac_rx);
+	sti_vtac_rx_reg_dump(vtac_rx);
+
+	platform_set_drvdata(pdev, vtac_rx);
+	DRM_INFO("%s VTAC RX %s\n", __func__,
+		 vtac_rx->type == VTAC_MAIN ? "main" : "aux");
+
+	return component_add(&pdev->dev, &vtac_rx_ops);
+}
+
+static int sti_vtac_rx_remove(struct platform_device *pdev)
+{
+	component_del(&pdev->dev, &vtac_rx_ops);
+	return 0;
+}
+
+static struct of_device_id vtac_rx_match_types[] = {
+	{
+	 .compatible = "st,stih416-vtac-rx",
+	 }, {
+	     /* end node */
+	     }
+};
+
+MODULE_DEVICE_TABLE(of, vtac_rx_match_types);
+
+struct platform_driver sti_vtac_rx_driver = {
+	.driver = {
+		   .name = "sti-vtac-rx",
+		   .owner = THIS_MODULE,
+		   .of_match_table = vtac_rx_match_types,
+		   },
+	.probe = sti_vtac_rx_probe,
+	.remove = sti_vtac_rx_remove,
+};
+
+module_platform_driver(sti_vtac_rx_driver);
+
+MODULE_AUTHOR("Benjamin Gaignard <benjamin.gaignard@st.com>");
+MODULE_DESCRIPTION("STMicroelectronics SoC VTAC_RX driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/gpu/drm/sti/sti_vtac_tx.c b/drivers/gpu/drm/sti/sti_vtac_tx.c
new file mode 100644
index 0000000..3c0a152
--- /dev/null
+++ b/drivers/gpu/drm/sti/sti_vtac_tx.c
@@ -0,0 +1,182 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2013
+ * Author: Benjamin Gaignard <benjamin.gaignard@st.com> for STMicroelectronics.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+#include <linux/clk.h>
+#include <linux/component.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <drm/drmP.h>
+
+#include "sti_vtac_utils.h"
+
+#define VTAC_TX_CONFIG		0x00
+
+#define VTAC_SW_RST_AUTOC	0x02
+
+#define VTAC_TX_PHY_ENABLE_CLK_PHY	(0x01 << 0)
+#define VTAC_TX_PHY_PROG_N3		(0x04 << 7)
+#define VTAC_TX_PHY_ENABLE_CLK_DLL	(0x01 << 1)
+#define VTAC_TX_PHY_RST_N_DLL_SWITCH	(0x01 << 4)
+#define VTAC_TX_PHY_PLL_NOT_OSC_MODE	(0x01 << 3)
+
+/*
+ * VTAC TX structure
+ *
+ * @dev: pointer to device structure
+ * @regs: ioremapped regsiters
+ * @clk: clock
+ * @type: main or aux device
+ */
+struct sti_vtac_tx {
+	struct device *dev;
+	void __iomem *tx_regs;
+	void __iomem *phy_regs;
+	struct clk *clk;
+	int type;
+};
+
+static void sti_vtac_tx_set_config(struct sti_vtac_tx *vtac_tx)
+{
+	int i;
+	u32 phy_config;
+	u32 tx_config = EVEN_PARITY | ODD_PARITY | SW_RST_AUTOC | ENABLE;
+
+	/* Enable VTAC clock */
+	if (clk_prepare_enable(vtac_tx->clk))
+		DRM_ERROR("Failed to prepare/enable vtac_tx clock.\n");
+
+	/* Configure vtac phy */
+	phy_config = 0x00000000;
+	writel(phy_config, vtac_tx->phy_regs + 0x828);	/* SYS_CFG8522 */
+	phy_config = VTAC_TX_PHY_ENABLE_CLK_PHY;
+	writel(phy_config, vtac_tx->phy_regs + 0x824);	/* SYS_CFG8521 */
+	phy_config = readl(vtac_tx->phy_regs + 0x824);
+	phy_config |= VTAC_TX_PHY_PROG_N3;
+	writel(phy_config, vtac_tx->phy_regs + 0x824);	/* SYS_CFG8521 */
+	phy_config = readl(vtac_tx->phy_regs + 0x824);
+	phy_config |= VTAC_TX_PHY_ENABLE_CLK_DLL;
+	writel(phy_config, vtac_tx->phy_regs + 0x824);	/* SYS_CFG8521 */
+	phy_config = readl(vtac_tx->phy_regs + 0x824);
+	phy_config |= VTAC_TX_PHY_RST_N_DLL_SWITCH;
+	writel(phy_config, vtac_tx->phy_regs + 0x824);	/* SYS_CFG8521 */
+	phy_config = readl(vtac_tx->phy_regs + 0x824);
+	phy_config |= VTAC_TX_PHY_PLL_NOT_OSC_MODE;
+	writel(phy_config, vtac_tx->phy_regs + 0x824);	/* SYS_CFG8521 */
+
+	/* Configure vtac tx */
+	for (i = 0; i < ARRAY_SIZE(vtac_modes); i++) {
+		if (vtac_modes[i].type == vtac_tx->type) {
+			tx_config |= vtac_modes[i].vid_in_width << 4;
+			tx_config |= vtac_modes[i].phyts_width << 16;
+			tx_config |= vtac_modes[i].phyts_per_pixel << 23;
+			tx_config |= VTAC_SW_RST_AUTOC;
+			writel(tx_config, vtac_tx->tx_regs + VTAC_TX_CONFIG);
+		}
+	}
+}
+
+static int vtac_tx_bind(struct device *dev, struct device *master, void *data)
+{
+	return 0;
+}
+
+static void vtac_tx_unbind(struct device *dev, struct device *master,
+	void *data)
+{
+	/* do nothing */
+}
+
+static const struct component_ops vtac_tx_ops = {
+	.bind	= vtac_tx_bind,
+	.unbind	= vtac_tx_unbind,
+};
+
+static int sti_vtac_tx_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct device_node *np = dev->of_node;
+	struct sti_vtac_tx *vtac_tx;
+	struct resource *res;
+
+	DRM_INFO("%s\n", __func__);
+
+	vtac_tx = devm_kzalloc(dev, sizeof(*vtac_tx), GFP_KERNEL);
+	if (!vtac_tx) {
+		DRM_ERROR("Failed to allocate VTAC TX context\n");
+		return -ENOMEM;
+	}
+	vtac_tx->dev = dev;
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "vtac-tx");
+	if (!res) {
+		DRM_ERROR("Invalid resource 'vtac-tx'\n");
+		return -ENOMEM;
+	}
+	vtac_tx->tx_regs = devm_ioremap_resource(dev, res);
+	if (IS_ERR(vtac_tx->tx_regs))
+		return PTR_ERR(vtac_tx->tx_regs);
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "vtac-phy");
+	if (!res) {
+		DRM_ERROR("Invalid resource 'vtac-phy'\n");
+		return -ENOMEM;
+	}
+	vtac_tx->phy_regs = devm_ioremap_nocache(dev, res->start,
+						 resource_size(res));
+	if (IS_ERR(vtac_tx->phy_regs))
+		return PTR_ERR(vtac_tx->phy_regs);
+
+	vtac_tx->type = VTAC_MAIN;
+	if (np)
+		if (of_property_read_bool(np, "vtac-tx-aux"))
+			vtac_tx->type = VTAC_AUX;
+
+	vtac_tx->clk = devm_clk_get(dev, "vtac_tx_phy");
+	if (IS_ERR(vtac_tx->clk)) {
+		DRM_ERROR("Cannot get vtac_tx_phy clock\n");
+		return PTR_ERR(vtac_tx->clk);
+	}
+
+	sti_vtac_tx_set_config(vtac_tx);
+
+	platform_set_drvdata(pdev, vtac_tx);
+	DRM_INFO("%s VTAC TX %s\n", __func__,
+		 vtac_tx->type == VTAC_MAIN ? "main" : "aux");
+
+	return component_add(&pdev->dev, &vtac_tx_ops);
+}
+
+static int sti_vtac_tx_remove(struct platform_device *pdev)
+{
+	component_del(&pdev->dev, &vtac_tx_ops);
+	return 0;
+}
+
+static struct of_device_id vtac_tx_match_types[] = {
+	{
+	 .compatible = "st,stih416-vtac-tx",
+	 }, {
+	     /* end node */
+	     }
+};
+MODULE_DEVICE_TABLE(of, vtac_tx_match_types);
+
+struct platform_driver sti_vtac_tx_driver = {
+	.driver = {
+		   .name = "sti-vtac-tx",
+		   .owner = THIS_MODULE,
+		   .of_match_table = vtac_tx_match_types,
+		   },
+	.probe = sti_vtac_tx_probe,
+	.remove = sti_vtac_tx_remove,
+};
+
+module_platform_driver(sti_vtac_tx_driver);
+
+MODULE_AUTHOR("Benjamin Gaignard <benjamin.gaignard@st.com>");
+MODULE_DESCRIPTION("STMicroelectronics SoC VTAC_TX driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/gpu/drm/sti/sti_vtac_utils.h b/drivers/gpu/drm/sti/sti_vtac_utils.h
new file mode 100644
index 0000000..ce549de
--- /dev/null
+++ b/drivers/gpu/drm/sti/sti_vtac_utils.h
@@ -0,0 +1,52 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2013
+ * Author: Benjamin Gaignard <benjamin.gaignard@st.com> for STMicroelectronics.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#ifndef _STI_VTAC_UTILS_H_
+#define _STI_VTAC_UTILS_H_
+
+#define VTAC_MAIN	0x8000
+#define VTAC_AUX	0x4000
+
+/* Number of phyts per pixel */
+#define VTAC_2_5_PPP	0x0005
+#define VTAC_3_PPP	0x0006
+#define VTAC_4_PPP	0x0008
+#define VTAC_5_PPP	0x000A
+#define VTAC_6_PPP	0x000C
+#define VTAC_13_PPP	0x001A
+#define VTAC_14_PPP	0x001C
+#define VTAC_15_PPP	0x001E
+#define VTAC_16_PPP	0x0020
+#define VTAC_17_PPP	0x0022
+#define VTAC_18_PPP	0x0024
+
+/* enable bits */
+#define EVEN_PARITY	(1 << 13)
+#define ODD_PARITY	(1 << 12)
+#define SW_RST_AUTOC	(1 << 1)
+#define ENABLE		(1 << 0)
+
+/*
+ * VTAC mode structure
+ *
+ * @type: main, aux or dvo device
+ * @vid_in_width: Video Data Resolution
+ * @phyts_width: Width of phyt buses(phyt low and phyt high).
+ * @phyts_per_pixel: Number of phyts sent per pixel
+ */
+struct sti_vtac_mode {
+	int type;
+	int vid_in_width;
+	int phyts_width;
+	int phyts_per_pixel;
+};
+
+static struct sti_vtac_mode vtac_modes[] = {
+	{VTAC_MAIN, 0x2, 0x2, VTAC_5_PPP}, /* Main RGB 12 */
+	{VTAC_AUX, 0x1, 0x0, VTAC_17_PPP}, /* Aux 10 */
+};
+
+#endif
-- 
1.9.1

