Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932705AbbAHWzE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 17:55:04 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:43602 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757320AbbAHWzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 17:55:00 -0500
From: Andy Gross <agross@codeaurora.org>
To: linux-arm-msm@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        Andy Gross <agross@codeaurora.org>
Subject: [PATCH 1/2] soc: qcom: Add TCSR driver
Date: Thu,  8 Jan 2015 16:52:56 -0600
Message-Id: <1420757577-20425-2-git-send-email-agross@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1420757577-20425-1-git-send-email-agross@codeaurora.org>
References: <1420757577-20425-1-git-send-email-agross@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the TCSR (Top Control and Status Register) IP block
that is present in the Qualcomm IPQ8064, APQ8064, and some later processors.
This block contains additional configuration and mux settings for various
peripherals in the system, including the ADM DMA block and USB controller.

Signed-off-by: Andy Gross <agross@codeaurora.org>
---
 drivers/soc/qcom/Kconfig     |    7 ++++
 drivers/soc/qcom/Makefile    |    1 +
 drivers/soc/qcom/qcom_tcsr.c |   83 ++++++++++++++++++++++++++++++++++++++++++
 include/soc/qcom/qcom_tcsr.h |   21 +++++++++++
 4 files changed, 112 insertions(+)
 create mode 100644 drivers/soc/qcom/qcom_tcsr.c
 create mode 100644 include/soc/qcom/qcom_tcsr.h

diff --git a/drivers/soc/qcom/Kconfig b/drivers/soc/qcom/Kconfig
index 7bd2c94..950c218 100644
--- a/drivers/soc/qcom/Kconfig
+++ b/drivers/soc/qcom/Kconfig
@@ -9,3 +9,10 @@ config QCOM_GSBI
           functions for connecting the underlying serial UART, SPI, and I2C
           devices to the output pins.
 
+config QCOM_TCSR
+	tristate "QCOM Top Control and Status Registers"
+	depends on ARCH_QCOM
+	help
+	  Say y here to enable TCSR support.  The TCSR provides control
+	  functions for various peripherals, like selection of USB port type and
+	  GSBI CRCI muxing.
diff --git a/drivers/soc/qcom/Makefile b/drivers/soc/qcom/Makefile
index 4389012..f0c287c 100644
--- a/drivers/soc/qcom/Makefile
+++ b/drivers/soc/qcom/Makefile
@@ -1 +1,2 @@
 obj-$(CONFIG_QCOM_GSBI)	+=	qcom_gsbi.o
+obj-$(CONFIG_QCOM_TCSR) +=	qcom_tcsr.o
diff --git a/drivers/soc/qcom/qcom_tcsr.c b/drivers/soc/qcom/qcom_tcsr.c
new file mode 100644
index 0000000..f8d5ef8
--- /dev/null
+++ b/drivers/soc/qcom/qcom_tcsr.c
@@ -0,0 +1,83 @@
+/*
+ * Copyright (c) 2014-2015, The Linux foundation. All rights reserved.
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
+#include <soc/qcom/qcom_tcsr.h>
+
+#define TCSR_ADM_A_CRCI_MUX_SEL	0x70
+#define TCSR_ADM_B_CRCI_MUX_SEL	0x74
+#define TCSR_USB_PORT_SEL	0xb0
+
+static int initialized;
+
+int qcom_tcsr_is_initialized(void)
+{
+	return !initialized;
+}
+EXPORT_SYMBOL(qcom_tcsr_is_initialized);
+
+static int qcom_tcsr_probe(struct platform_device *pdev)
+{
+	struct resource *res;
+	const struct device_node *node = pdev->dev.of_node;
+	void __iomem *base;
+	u32 val;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(base))
+		return PTR_ERR(base);
+
+	if (!of_property_read_u32(node, "qcom,usb-ctrl-select", &val)) {
+		dev_info(&pdev->dev, "setting usb port select = %d\n", val);
+		writel(val, base + TCSR_USB_PORT_SEL);
+	}
+
+	if (!of_property_read_u32(node, "qcom,adm-a-crci-mux-sel", &val))
+		writel(val, base + TCSR_ADM_A_CRCI_MUX_SEL);
+
+	if (!of_property_read_u32(node, "qcom,adm-b-crci-mux-sel", &val))
+		writel(val, base + TCSR_ADM_B_CRCI_MUX_SEL);
+
+	initialized = 1;
+
+	return 0;
+}
+
+static const struct of_device_id qcom_tcsr_dt_match[] = {
+	{ .compatible = "qcom,tcsr", },
+	{ },
+};
+
+MODULE_DEVICE_TABLE(of, qcom_tcsr_dt_match);
+
+static struct platform_driver qcom_tcsr_driver = {
+	.driver = {
+		.name		= "tcsr",
+		.owner		= THIS_MODULE,
+		.of_match_table	= qcom_tcsr_dt_match,
+	},
+	.probe = qcom_tcsr_probe,
+};
+
+module_platform_driver(qcom_tcsr_driver);
+
+MODULE_AUTHOR("Andy Gross <agross@codeaurora.org>");
+MODULE_DESCRIPTION("QCOM TCSR driver");
+MODULE_LICENSE("GPL v2");
diff --git a/include/soc/qcom/qcom_tcsr.h b/include/soc/qcom/qcom_tcsr.h
new file mode 100644
index 0000000..cbdd3c8
--- /dev/null
+++ b/include/soc/qcom/qcom_tcsr.h
@@ -0,0 +1,21 @@
+/*
+ * Copyright (c) 2015, The Linux foundation. All rights reserved.
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
+#ifndef _QCOM_TCSR_H
+
+#ifdef CONFIG_QCOM_TCSR
+int qcom_tcsr_is_initialized(void);
+#else
+static inline int qcom_tcsr_is_initialized(void) {return -ENODEV; }
+#endif
+
+#endif
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

