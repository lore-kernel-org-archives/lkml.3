Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863AbaILRal (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 13:30:41 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:55648 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbaILR36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 13:29:58 -0400
From: Andy Gross <agross@codeaurora.org>
To: Felipe Balbi <balbi@ti.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Jack Pham <jackp@codeaurora.org>, Kumar Gala <galak@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, linux-usb@vger.kernel.org,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Andy Gross <agross@codeaurora.org>
Subject: [PATCH v8 2/3] usb: dwc3: Add Qualcomm DWC3 glue layer driver
Date: Fri, 12 Sep 2014 12:29:45 -0500
Message-Id: <1410542986-24419-3-git-send-email-agross@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1410542986-24419-1-git-send-email-agross@codeaurora.org>
References: <1410542986-24419-1-git-send-email-agross@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

DWC3 glue layer is hardware layer around Synopsys DesignWare
USB3 core. Its purpose is to supply Synopsys IP with required
clocks, voltages and interface it with the rest of the SoC.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
Signed-off-by: Andy Gross <agross@codeaurora.org>
---
 drivers/usb/dwc3/Kconfig     |    9 +++
 drivers/usb/dwc3/Makefile    |    1 +
 drivers/usb/dwc3/dwc3-qcom.c |  133 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 143 insertions(+)
 create mode 100644 drivers/usb/dwc3/dwc3-qcom.c

diff --git a/drivers/usb/dwc3/Kconfig b/drivers/usb/dwc3/Kconfig
index 785510a..e9f258e 100644
--- a/drivers/usb/dwc3/Kconfig
+++ b/drivers/usb/dwc3/Kconfig
@@ -80,6 +80,15 @@ config USB_DWC3_KEYSTONE
 	  Support of USB2/3 functionality in TI Keystone2 platforms.
 	  Say 'Y' or 'M' here if you have one such device
 
+config USB_DWC3_QCOM
+	tristate "Qualcomm Platforms"
+	depends on ARCH_QCOM || COMPILE_TEST
+	default USB_DWC3
+	select PHY_QCOM_DWC3
+	help
+	  Recent Qualcomm SoCs ship with one DesignWare Core USB3 IP inside,
+	  say 'Y' or 'M' if you have one such device.
+
 comment "Debugging features"
 
 config USB_DWC3_DEBUG
diff --git a/drivers/usb/dwc3/Makefile b/drivers/usb/dwc3/Makefile
index 10ac3e7..0da8e75 100644
--- a/drivers/usb/dwc3/Makefile
+++ b/drivers/usb/dwc3/Makefile
@@ -33,3 +33,4 @@ obj-$(CONFIG_USB_DWC3_OMAP)		+= dwc3-omap.o
 obj-$(CONFIG_USB_DWC3_EXYNOS)		+= dwc3-exynos.o
 obj-$(CONFIG_USB_DWC3_PCI)		+= dwc3-pci.o
 obj-$(CONFIG_USB_DWC3_KEYSTONE)		+= dwc3-keystone.o
+obj-$(CONFIG_USB_DWC3_QCOM)		+= dwc3-qcom.o
diff --git a/drivers/usb/dwc3/dwc3-qcom.c b/drivers/usb/dwc3/dwc3-qcom.c
new file mode 100644
index 0000000..2067c04
--- /dev/null
+++ b/drivers/usb/dwc3/dwc3-qcom.c
@@ -0,0 +1,133 @@
+/* Copyright (c) 2013-2014, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/consumer.h>
+#include <linux/usb/phy.h>
+
+struct dwc3_qcom {
+	struct device		*dev;
+
+	struct clk		*core_clk;
+	struct clk		*iface_clk;
+	struct clk		*sleep_clk;
+};
+
+static int dwc3_qcom_probe(struct platform_device *pdev)
+{
+	struct device_node *node = pdev->dev.of_node;
+	struct dwc3_qcom *qdwc;
+	int ret = 0;
+
+	qdwc = devm_kzalloc(&pdev->dev, sizeof(*qdwc), GFP_KERNEL);
+	if (!qdwc)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, qdwc);
+
+	qdwc->dev = &pdev->dev;
+
+	qdwc->core_clk = devm_clk_get(qdwc->dev, "core");
+	if (IS_ERR(qdwc->core_clk)) {
+		dev_dbg(qdwc->dev, "failed to get core clock\n");
+		return PTR_ERR(qdwc->core_clk);
+	}
+
+	qdwc->iface_clk = devm_clk_get(qdwc->dev, "iface");
+	if (IS_ERR(qdwc->iface_clk)) {
+		dev_dbg(qdwc->dev, "failed to get optional iface clock\n");
+		qdwc->iface_clk = NULL;
+	}
+
+	qdwc->sleep_clk = devm_clk_get(qdwc->dev, "sleep");
+	if (IS_ERR(qdwc->sleep_clk)) {
+		dev_dbg(qdwc->dev, "failed to get optional sleep clock\n");
+		qdwc->sleep_clk = NULL;
+	}
+
+	ret = clk_prepare_enable(qdwc->core_clk);
+	if (ret) {
+		dev_err(qdwc->dev, "failed to enable core clock\n");
+		goto err_core;
+	}
+
+	ret = clk_prepare_enable(qdwc->iface_clk);
+	if (ret) {
+		dev_err(qdwc->dev, "failed to enable optional iface clock\n");
+		goto err_iface;
+	}
+
+	ret = clk_prepare_enable(qdwc->sleep_clk);
+	if (ret) {
+		dev_err(qdwc->dev, "failed to enable optional sleep clock\n");
+		goto err_sleep;
+	}
+
+	ret = of_platform_populate(node, NULL, NULL, qdwc->dev);
+	if (ret) {
+		dev_err(qdwc->dev, "failed to register core - %d\n", ret);
+		goto err_clks;
+	}
+
+	return 0;
+
+err_clks:
+	clk_disable_unprepare(qdwc->sleep_clk);
+err_sleep:
+	clk_disable_unprepare(qdwc->iface_clk);
+err_iface:
+	clk_disable_unprepare(qdwc->core_clk);
+err_core:
+	return ret;
+}
+
+static int dwc3_qcom_remove(struct platform_device *pdev)
+{
+	struct dwc3_qcom *qdwc = platform_get_drvdata(pdev);
+
+	of_platform_depopulate(&pdev->dev);
+
+	clk_disable_unprepare(qdwc->sleep_clk);
+	clk_disable_unprepare(qdwc->iface_clk);
+	clk_disable_unprepare(qdwc->core_clk);
+
+	return 0;
+}
+
+static const struct of_device_id of_dwc3_match[] = {
+	{ .compatible = "qcom,dwc3" },
+	{ /* Sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, of_dwc3_match);
+
+static struct platform_driver dwc3_qcom_driver = {
+	.probe		= dwc3_qcom_probe,
+	.remove		= dwc3_qcom_remove,
+	.driver		= {
+		.name	= "qcom-dwc3",
+		.owner	= THIS_MODULE,
+		.of_match_table	= of_dwc3_match,
+	},
+};
+
+module_platform_driver(dwc3_qcom_driver);
+
+MODULE_ALIAS("platform:qcom-dwc3");
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("DesignWare USB3 QCOM Glue Layer");
+MODULE_AUTHOR("Ivan T. Ivanov <iivanov@mm-sol.com>");
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

