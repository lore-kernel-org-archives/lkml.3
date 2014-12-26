Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860AbaLZJGo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 04:06:44 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:56424 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751166AbaLZJGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 04:06:36 -0500
X-Listener-Flag: 11101
From: Flora Fu <flora.fu@mediatek.com>
To: Philipp Zabel <p.zabel@pengutronix.de>, Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
CC: Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <srv_heupstream@mediatek.com>, Sascha Hauer <kernel@pengutronix.de>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Flora Fu <flora.fu@mediatek.com>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Dongdong Cheng <dongdong.cheng@mediatek.com>,
        HenryC Chen <henryc.chen@mediatek.com>,
        Menghui Lin <menghui.lin@mediatek.com>,
        Chen Zhong <chen.zhong@mediatek.com>
Subject: [PATCH v4 1/3] reset: mediatek: Add Reset Controller for MediaTek SoC
Date: Fri, 26 Dec 2014 17:05:49 +0800
Message-ID: <1419584751-18149-2-git-send-email-flora.fu@mediatek.com>
X-Mailer: git-send-email 1.8.1.1.dirty
In-Reply-To: <1419584751-18149-1-git-send-email-flora.fu@mediatek.com>
References: <1419584751-18149-1-git-send-email-flora.fu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a driver in reset controller.

Signed-off-by: Flora Fu <flora.fu@mediatek.com>
---
 drivers/reset/Makefile                             |   1 +
 drivers/reset/reset-mtk.c                          | 130 +++++++++++++++++++++
 .../dt-bindings/reset-controller/mt8135-resets.h   |  64 ++++++++++
 .../dt-bindings/reset-controller/mt8173-resets.h   |  63 ++++++++++
 4 files changed, 258 insertions(+)
 create mode 100644 drivers/reset/reset-mtk.c
 create mode 100644 include/dt-bindings/reset-controller/mt8135-resets.h
 create mode 100644 include/dt-bindings/reset-controller/mt8173-resets.h

diff --git a/drivers/reset/Makefile b/drivers/reset/Makefile
index 157d421..d81a60a 100644
--- a/drivers/reset/Makefile
+++ b/drivers/reset/Makefile
@@ -3,3 +3,4 @@ obj-$(CONFIG_ARCH_SOCFPGA) += reset-socfpga.o
 obj-$(CONFIG_ARCH_BERLIN) += reset-berlin.o
 obj-$(CONFIG_ARCH_SUNXI) += reset-sunxi.o
 obj-$(CONFIG_ARCH_STI) += sti/
+obj-$(CONFIG_ARCH_MEDIATEK) += reset-mtk.o
diff --git a/drivers/reset/reset-mtk.c b/drivers/reset/reset-mtk.c
new file mode 100644
index 0000000..ccdd4bb
--- /dev/null
+++ b/drivers/reset/reset-mtk.c
@@ -0,0 +1,130 @@
+/*
+ * Copyright (c) 2014 MediaTek Inc.
+ * Author: Flora Fu <flora.fu@mediatek.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/mfd/syscon.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+#include <linux/reset-controller.h>
+
+struct mtk_reset_data {
+	struct regmap *regmap;
+	u32 resetbase;
+	u32 num_regs;
+	struct reset_controller_dev rcdev;
+};
+
+static int mtk_reset_assert(struct reset_controller_dev *rcdev,
+			      unsigned long id)
+{
+	struct regmap *regmap;
+	u32 addr;
+	u32 mask;
+	struct mtk_reset_data *data = container_of(rcdev,
+						     struct mtk_reset_data,
+						     rcdev);
+	regmap = data->regmap;
+	addr = data->resetbase + ((id / 32) << 2);
+	mask = BIT(id % 32);
+
+	return regmap_update_bits(regmap, addr, mask, mask);
+}
+
+static int mtk_reset_deassert(struct reset_controller_dev *rcdev,
+				unsigned long id)
+{
+	struct regmap *regmap;
+	u32 addr;
+	u32 mask;
+	struct mtk_reset_data *data = container_of(rcdev,
+						     struct mtk_reset_data,
+						     rcdev);
+
+	regmap = data->regmap;
+	addr = data->resetbase + ((id / 32) << 2);
+	mask = BIT(id % 32);
+
+	return regmap_update_bits(regmap, addr, mask, ~mask);
+}
+
+static struct reset_control_ops mtk_reset_ops = {
+	.assert = mtk_reset_assert,
+	.deassert = mtk_reset_deassert,
+};
+
+static int mtk_reset_probe(struct platform_device *pdev)
+{
+	struct mtk_reset_data *data;
+	struct device_node *np = pdev->dev.of_node;
+	struct device_node *syscon_np;
+	u32 reg[2];
+	int ret;
+
+	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	syscon_np = of_get_parent(np);
+	data->regmap = syscon_node_to_regmap(syscon_np);
+	of_node_put(syscon_np);
+	if (IS_ERR(data->regmap)) {
+		dev_err(&pdev->dev, "couldn't get syscon-reset regmap\n");
+		return PTR_ERR(data->regmap);
+	}
+	ret = of_property_read_u32_array(np, "reg", reg, 2);
+	if (ret) {
+		dev_err(&pdev->dev, "couldn't read reset base from syscon!\n");
+		return -EINVAL;
+	}
+
+	data->resetbase = reg[0];
+	data->num_regs = reg[1] >> 2;
+	data->rcdev.owner = THIS_MODULE;
+	data->rcdev.nr_resets = data->num_regs * 32;
+	data->rcdev.ops = &mtk_reset_ops;
+	data->rcdev.of_node = pdev->dev.of_node;
+
+	return reset_controller_register(&data->rcdev);
+}
+
+static int mtk_reset_remove(struct platform_device *pdev)
+{
+	struct mtk_reset_data *data = platform_get_drvdata(pdev);
+
+	reset_controller_unregister(&data->rcdev);
+
+	return 0;
+}
+
+static const struct of_device_id mtk_reset_dt_ids[] = {
+	{ .compatible = "mediatek,reset", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, mtk_reset_dt_ids);
+
+static struct platform_driver mtk_reset_driver = {
+	.probe = mtk_reset_probe,
+	.remove = mtk_reset_remove,
+	.driver = {
+		.name = "mtk-reset",
+		.of_match_table = mtk_reset_dt_ids,
+	},
+};
+
+module_platform_driver(mtk_reset_driver);
+
+MODULE_AUTHOR("Flora Fu <flora.fu@mediatek.com>");
+MODULE_DESCRIPTION("MediaTek SoC Generic Reset Controller");
+MODULE_LICENSE("GPL");
diff --git a/include/dt-bindings/reset-controller/mt8135-resets.h b/include/dt-bindings/reset-controller/mt8135-resets.h
new file mode 100644
index 0000000..701532e
--- /dev/null
+++ b/include/dt-bindings/reset-controller/mt8135-resets.h
@@ -0,0 +1,64 @@
+/*
+ * Copyright (c) 2014 MediaTek Inc.
+ * Author: Flora Fu <flora.fu@mediatek.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _DT_BINDINGS_RESET_CONTROLLER_MT8135
+#define _DT_BINDINGS_RESET_CONTROLLER_MT8135
+
+/* INFRACFG RESETS */
+#define MT8135_INFRA_EMI_REG_RST        0
+#define MT8135_INFRA_DRAMC0_A0_RST      1
+#define MT8135_INFRA_CCIF0_RST          2
+#define MT8135_INFRA_APCIRQ_EINT_RST    3
+#define MT8135_INFRA_APXGPT_RST         4
+#define MT8135_INFRA_SCPSYS_RST         5
+#define MT8135_INFRA_CCIF1_RST          6
+#define MT8135_INFRA_PMIC_WRAP_RST      7
+#define MT8135_INFRA_KP_RST             8
+#define MT8135_INFRA_EMI_RST            32
+#define MT8135_INFRA_DRAMC0_RST         34
+#define MT8135_INFRA_SMI_RST            35
+#define MT8135_INFRA_M4U_RST            36
+
+/*  PERICFG RESETS */
+#define MT8135_PERI_UART0_SW_RST        0
+#define MT8135_PERI_UART1_SW_RST        1
+#define MT8135_PERI_UART2_SW_RST        2
+#define MT8135_PERI_UART3_SW_RST        3
+#define MT8135_PERI_IRDA_SW_RST         4
+#define MT8135_PERI_PTP_SW_RST          5
+#define MT8135_PERI_AP_HIF_SW_RST       6
+#define MT8135_PERI_GPCU_SW_RST         7
+#define MT8135_PERI_MD_HIF_SW_RST       8
+#define MT8135_PERI_NLI_SW_RST          9
+#define MT8135_PERI_AUXADC_SW_RST       10
+#define MT8135_PERI_DMA_SW_RST          11
+#define MT8135_PERI_NFI_SW_RST          14
+#define MT8135_PERI_PWM_SW_RST          15
+#define MT8135_PERI_THERM_SW_RST        16
+#define MT8135_PERI_MSDC0_SW_RST        17
+#define MT8135_PERI_MSDC1_SW_RST        18
+#define MT8135_PERI_MSDC2_SW_RST        19
+#define MT8135_PERI_MSDC3_SW_RST        20
+#define MT8135_PERI_I2C0_SW_RST         22
+#define MT8135_PERI_I2C1_SW_RST         23
+#define MT8135_PERI_I2C2_SW_RST         24
+#define MT8135_PERI_I2C3_SW_RST         25
+#define MT8135_PERI_I2C4_SW_RST         26
+#define MT8135_PERI_I2C5_SW_RST         27
+#define MT8135_PERI_I2C6_SW_RST         28
+#define MT8135_PERI_USB_SW_RST          29
+#define MT8135_PERI_SPI1_SW_RST         33
+#define MT8135_PERI_PWRAP_BRIDGE_SW_RST 34
+
+#endif  /* _DT_BINDINGS_RESET_CONTROLLER_MT8135 */
diff --git a/include/dt-bindings/reset-controller/mt8173-resets.h b/include/dt-bindings/reset-controller/mt8173-resets.h
new file mode 100644
index 0000000..62103e4
--- /dev/null
+++ b/include/dt-bindings/reset-controller/mt8173-resets.h
@@ -0,0 +1,63 @@
+/*
+ * Copyright (c) 2014 MediaTek Inc.
+ * Author: Flora Fu <flora.fu@mediatek.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _DT_BINDINGS_RESET_CONTROLLER_MT8173
+#define _DT_BINDINGS_RESET_CONTROLLER_MT8173
+
+/* INFRACFG RESETS */
+#define MT8173_INFRA_EMI_REG_RST        0
+#define MT8173_INFRA_DRAMC0_A0_RST      1
+#define MT8173_INFRA_APCIRQ_EINT_RST    3
+#define MT8173_INFRA_APXGPT_RST         4
+#define MT8173_INFRA_SCPSYS_RST         5
+#define MT8173_INFRA_KP_RST             6
+#define MT8173_INFRA_PMIC_WRAP_RST      7
+#define MT8173_INFRA_MPIP_RST           8
+#define MT8173_INFRA_CEC_RST            9
+#define MT8173_INFRA_EMI_RST            32
+#define MT8173_INFRA_DRAMC0_RST         34
+#define MT8173_INFRA_APMIXEDSYS_RST     35
+#define MT8173_INFRA_MIPI_DSI_RST       36
+#define MT8173_INFRA_TRNG_RST           37
+#define MT8173_INFRA_SYSIRQ_RST         38
+#define MT8173_INFRA_MIPI_CSI_RST       39
+#define MT8173_INFRA_GCE_FAXI_RST       40
+#define MT8173_INFRA_MMIOMMURST         47
+
+
+/*  PERICFG RESETS */
+#define MT8173_PERI_UART0_SW_RST        0
+#define MT8173_PERI_UART1_SW_RST        1
+#define MT8173_PERI_UART2_SW_RST        2
+#define MT8173_PERI_UART3_SW_RST        3
+#define MT8173_PERI_IRRX_SW_RST         4
+#define MT8173_PERI_PWM_SW_RST          8
+#define MT8173_PERI_AUXADC_SW_RST       10
+#define MT8173_PERI_DMA_SW_RST          11
+#define MT8173_PERI_I2C6_SW_RST         13
+#define MT8173_PERI_NFI_SW_RST          14
+#define MT8173_PERI_THERM_SW_RST        16
+#define MT8173_PERI_MSDC2_SW_RST        17
+#define MT8173_PERI_MSDC3_SW_RST        18
+#define MT8173_PERI_MSDC0_SW_RST        19
+#define MT8173_PERI_MSDC1_SW_RST        20
+#define MT8173_PERI_I2C0_SW_RST         22
+#define MT8173_PERI_I2C1_SW_RST         23
+#define MT8173_PERI_I2C2_SW_RST         24
+#define MT8173_PERI_I2C3_SW_RST         25
+#define MT8173_PERI_I2C4_SW_RST         26
+#define MT8173_PERI_HDMI_SW_RST         29
+#define MT8173_PERI_SPI0_SW_RST         33
+
+#endif  /* _DT_BINDINGS_RESET_CONTROLLER_MT8173 */
-- 
1.8.1.1.dirty

