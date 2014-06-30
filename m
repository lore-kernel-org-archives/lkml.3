Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756422AbaF3QEL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 12:04:11 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:51378 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754AbaF3QEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 12:04:07 -0400
From: Andy Gross <agross@codeaurora.org>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        linux-arm-kernel@lists.infradead.org,
        Kumar Gala <galak@codeaurora.org>, jackp@codeaurora.org,
        linux-arm-msm@vger.kernel.org, Andy Gross <agross@codeaurora.org>
Subject: [Patch v7 1/3] usb: dwc3: Add Qualcomm DWC3 glue layer driver
Date: Mon, 30 Jun 2014 11:03:51 -0500
Message-Id: <1404144233-17222-2-git-send-email-agross@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404144233-17222-1-git-send-email-agross@codeaurora.org>
References: <1404144233-17222-1-git-send-email-agross@codeaurora.org>
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
 drivers/usb/dwc3/dwc3-qcom.c |  153 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 163 insertions(+)
 create mode 100644 drivers/usb/dwc3/dwc3-qcom.c

diff --git a/drivers/usb/dwc3/Kconfig b/drivers/usb/dwc3/Kconfig
index 8eb996e..29fcbfd 100644
--- a/drivers/usb/dwc3/Kconfig
+++ b/drivers/usb/dwc3/Kconfig
@@ -79,6 +79,15 @@ config USB_DWC3_KEYSTONE
 	  Support of USB2/3 functionality in TI Keystone2 platforms.
 	  Say 'Y' or 'M' here if you have one such device
 
+config USB_DWC3_QCOM
+       tristate "Qualcomm Platforms"
+       default USB_DWC3
+       select USB_QCOM_DWC3_PHY
+       help
+         Recent Qualcomm SoCs ship with one DesignWare Core USB3 IP inside,
+         say 'Y' or 'M' if you have one such device.
+
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
index 0000000..e99764a
--- /dev/null
+++ b/drivers/usb/dwc3/dwc3-qcom.c
@@ -0,0 +1,153 @@
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
+#include "core.h"
+
+
+struct dwc3_qcom {
+	struct device		*dev;
+
+	struct clk		*core_clk;
+	struct clk		*iface_clk;
+	struct clk		*sleep_clk;
+
+	struct regulator	*gdsc;
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
+	qdwc->gdsc = devm_regulator_get(qdwc->dev, "gdsc");
+
+	qdwc->core_clk = devm_clk_get(qdwc->dev, "core");
+	if (IS_ERR(qdwc->core_clk)) {
+		dev_dbg(qdwc->dev, "failed to get core clock\n");
+		return PTR_ERR(qdwc->core_clk);
+	}
+
+	qdwc->iface_clk = devm_clk_get(qdwc->dev, "iface");
+	if (IS_ERR(qdwc->iface_clk)) {
+		dev_dbg(qdwc->dev, "failed to get iface clock, skipping\n");
+		qdwc->iface_clk = NULL;
+	}
+
+	qdwc->sleep_clk = devm_clk_get(qdwc->dev, "sleep");
+	if (IS_ERR(qdwc->sleep_clk)) {
+		dev_dbg(qdwc->dev, "failed to get sleep clock, skipping\n");
+		qdwc->sleep_clk = NULL;
+	}
+
+	if (!IS_ERR(qdwc->gdsc)) {
+		ret = regulator_enable(qdwc->gdsc);
+		if (ret)
+			dev_err(qdwc->dev, "cannot enable gdsc\n");
+	}
+
+	clk_prepare_enable(qdwc->core_clk);
+
+	if (qdwc->iface_clk)
+		clk_prepare_enable(qdwc->iface_clk);
+
+	if (qdwc->sleep_clk)
+		clk_prepare_enable(qdwc->sleep_clk);
+
+	ret = of_platform_populate(node, NULL, NULL, qdwc->dev);
+	if (ret) {
+		dev_err(qdwc->dev, "failed to register core - %d\n", ret);
+		dev_dbg(qdwc->dev, "failed to add create dwc3 core\n");
+		goto dis_clks;
+	}
+
+	return 0;
+
+dis_clks:
+	if (qdwc->sleep_clk)
+		clk_disable_unprepare(qdwc->sleep_clk);
+
+	if (qdwc->iface_clk)
+		clk_disable_unprepare(qdwc->iface_clk);
+
+	clk_disable_unprepare(qdwc->core_clk);
+
+	if (!IS_ERR(qdwc->gdsc)) {
+		ret = regulator_disable(qdwc->gdsc);
+		if (ret)
+			dev_dbg(qdwc->dev, "cannot disable gdsc\n");
+	}
+
+	return ret;
+}
+
+static int dwc3_qcom_remove(struct platform_device *pdev)
+{
+	int ret = 0;
+
+	struct dwc3_qcom *qdwc = platform_get_drvdata(pdev);
+
+	if (qdwc->sleep_clk)
+		clk_disable_unprepare(qdwc->sleep_clk);
+
+	if (qdwc->iface_clk)
+		clk_disable_unprepare(qdwc->iface_clk);
+
+	clk_disable_unprepare(qdwc->core_clk);
+
+	if (!IS_ERR(qdwc->gdsc)) {
+		ret = regulator_disable(qdwc->gdsc);
+		if (ret)
+			dev_dbg(qdwc->dev, "cannot disable gdsc\n");
+	}
+	return ret;
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
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

