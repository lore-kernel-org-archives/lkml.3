Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751730AbaDUFcN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 01:32:13 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:44424 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbaDUFbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 01:31:32 -0400
From: Andy Gross <agross@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Gross <agross@codeaurora.org>
Subject: [PATCH 2/4] soc: qcom: Add GSBI driver
Date: Mon, 21 Apr 2014 00:30:42 -0500
Message-Id: <1398058244-14099-3-git-send-email-agross@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398058244-14099-1-git-send-email-agross@codeaurora.org>
References: <1398058244-14099-1-git-send-email-agross@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The GSBI (General Serial Bus Interface) driver controls the overarching
configuration of the shared serial bus infrastructure on APQ8064, IPQ8064, and
earlier QCOM processors.  The GSBI supports UART, I2C, SPI, and UIM
functionality in various combinations.

Signed-off-by: Andy Gross <agross@codeaurora.org>
---
 drivers/soc/Kconfig          |    3 +-
 drivers/soc/Makefile         |    5 +++
 drivers/soc/qcom/Kconfig     |   11 +++++
 drivers/soc/qcom/Makefile    |    1 +
 drivers/soc/qcom/qcom_gsbi.c |  101 ++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 120 insertions(+), 1 deletion(-)
 create mode 100644 drivers/soc/Makefile
 create mode 100644 drivers/soc/qcom/Kconfig
 create mode 100644 drivers/soc/qcom/Makefile
 create mode 100644 drivers/soc/qcom/qcom_gsbi.c

diff --git a/drivers/soc/Kconfig b/drivers/soc/Kconfig
index 58bd962..07a11be 100644
--- a/drivers/soc/Kconfig
+++ b/drivers/soc/Kconfig
@@ -1,4 +1,5 @@
 menu "SOC specific Drivers"
 
+source "drivers/soc/qcom/Kconfig"
+
 endmenu
-`
diff --git a/drivers/soc/Makefile b/drivers/soc/Makefile
new file mode 100644
index 0000000..0f7c447
--- /dev/null
+++ b/drivers/soc/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile for the Linux Kernel SOC specific device drivers.
+#
+
+obj-$(CONFIG_ARCH_QCOM)		+= qcom/
diff --git a/drivers/soc/qcom/Kconfig b/drivers/soc/qcom/Kconfig
new file mode 100644
index 0000000..7bd2c94
--- /dev/null
+++ b/drivers/soc/qcom/Kconfig
@@ -0,0 +1,11 @@
+#
+# QCOM Soc drivers
+#
+config QCOM_GSBI
+        tristate "QCOM General Serial Bus Interface"
+        depends on ARCH_QCOM
+        help
+          Say y here to enable GSBI support.  The GSBI provides control
+          functions for connecting the underlying serial UART, SPI, and I2C
+          devices to the output pins.
+
diff --git a/drivers/soc/qcom/Makefile b/drivers/soc/qcom/Makefile
new file mode 100644
index 0000000..4389012
--- /dev/null
+++ b/drivers/soc/qcom/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_QCOM_GSBI)	+=	qcom_gsbi.o
diff --git a/drivers/soc/qcom/qcom_gsbi.c b/drivers/soc/qcom/qcom_gsbi.c
new file mode 100644
index 0000000..e8451a3
--- /dev/null
+++ b/drivers/soc/qcom/qcom_gsbi.c
@@ -0,0 +1,101 @@
+/*
+ * Copyright (c) 2014, The Linux foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License rev 2 and
+ * only rev 2 as published by the free Software foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or fITNESS fOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
+#include <linux/platform_device.h>
+
+#define GSBI_CTRL_REG		0x0000
+#define GSBI_PROTOCOL_SHIFT	4
+
+struct gsbi_dev {
+	struct device	*dev;
+	void __iomem	*base;
+
+	struct clk	*hclk;
+};
+
+static int gsbi_probe(struct platform_device *pdev)
+{
+	struct device_node *node = pdev->dev.of_node;
+	struct gsbi_dev *gsbi;
+	struct resource *res;
+	u32 mode;
+
+	gsbi = devm_kzalloc(&pdev->dev, sizeof(*gsbi), GFP_KERNEL);
+	if (!gsbi)
+		return -ENOMEM;
+
+	gsbi->dev = &pdev->dev;
+	platform_set_drvdata(pdev, gsbi);
+
+	if (of_property_read_u32(node, "qcom,mode", &mode)) {
+		dev_err(gsbi->dev, "missing mode configuration\n");
+		return -EINVAL;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	gsbi->base = devm_ioremap_resource(gsbi->dev, res);
+	if (IS_ERR(gsbi->base))
+		return PTR_ERR(gsbi->base);
+
+	gsbi->hclk = devm_clk_get(gsbi->dev, "iface");
+	if (IS_ERR(gsbi->hclk)) {
+		dev_err(gsbi->dev, "Could not get core clock\n");
+		return PTR_ERR(gsbi->hclk);
+	}
+	clk_prepare_enable(gsbi->hclk);
+
+	writel_relaxed((mode << GSBI_PROTOCOL_SHIFT), gsbi + GSBI_CTRL_REG);
+
+	/* make sure the gsbi control write is not reordered */
+	wmb();
+
+	return of_platform_populate(pdev->dev.of_node, NULL, NULL, &pdev->dev);
+}
+
+static int gsbi_remove(struct platform_device *pdev)
+{
+	struct gsbi_dev *gsbi = platform_get_drvdata(pdev);
+
+	clk_disable_unprepare(gsbi->hclk);
+
+	return 0;
+}
+
+static struct of_device_id gsbi_dt_match[] = {
+	{ .compatible = "qcom,gsbi-v1.0.0", },
+};
+
+MODULE_DEVICE_TABLE(of, gsbi_dt_match);
+
+static struct platform_driver gsbi_driver = {
+	.driver = {
+		.name		= "gsbi",
+		.owner		= THIS_MODULE,
+		.of_match_table	= gsbi_dt_match,
+	},
+	.probe = gsbi_probe,
+	.remove = gsbi_remove,
+};
+
+module_platform_driver(gsbi_driver);
+
+MODULE_AUTHOR("Andy Gross <agross@codeaurora.org>");
+MODULE_DESCRIPTION("QCOM GSBI driver");
+MODULE_LICENSE("GPL v2");
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

