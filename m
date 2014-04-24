Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142AbaDXQcQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 12:32:16 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:59772 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756693AbaDXQcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 12:32:08 -0400
From: Andy Gross <agross@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Gross <agross@codeaurora.org>
Subject: [Patch v2 3/4] soc: qcom: Add GSBI driver
Date: Thu, 24 Apr 2014 11:31:21 -0500
Message-Id: <1398357082-5102-4-git-send-email-agross@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398357082-5102-1-git-send-email-agross@codeaurora.org>
References: <1398357082-5102-1-git-send-email-agross@codeaurora.org>
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
 drivers/soc/qcom/Kconfig     |   11 ++++++
 drivers/soc/qcom/Makefile    |    1 +
 drivers/soc/qcom/qcom_gsbi.c |   84 ++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 103 insertions(+), 1 deletion(-)
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
index 0000000..061dd06
--- /dev/null
+++ b/drivers/soc/qcom/qcom_gsbi.c
@@ -0,0 +1,84 @@
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
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
+#include <linux/platform_device.h>
+
+#define GSBI_CTRL_REG		0x0000
+#define GSBI_PROTOCOL_SHIFT	4
+
+static int gsbi_probe(struct platform_device *pdev)
+{
+	struct device_node *node = pdev->dev.of_node;
+	struct resource *res;
+	void __iomem *base;
+	struct clk *hclk;
+	u32 mode, crci = 0;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(base))
+		return PTR_ERR(base);
+
+	if (of_property_read_u32(node, "qcom,mode", &mode)) {
+		dev_err(&pdev->dev, "missing mode configuration\n");
+		return -EINVAL;
+	}
+
+	/* not required, so default to 0 if not present */
+	of_property_read_u32(node, "qcom,crci", &crci);
+
+	dev_info(&pdev->dev, "GSBI port protocol: %d crci: %d\n", mode, crci);
+
+	hclk = devm_clk_get(&pdev->dev, "iface");
+	if (IS_ERR(hclk))
+		return PTR_ERR(hclk);
+
+	clk_prepare_enable(hclk);
+
+	writel_relaxed((mode << GSBI_PROTOCOL_SHIFT) | crci,
+				base + GSBI_CTRL_REG);
+
+	/* make sure the gsbi control write is not reordered */
+	wmb();
+
+	clk_disable_unprepare(hclk);
+
+	return of_platform_populate(pdev->dev.of_node, NULL, NULL, &pdev->dev);
+}
+
+static const struct of_device_id gsbi_dt_match[] = {
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

