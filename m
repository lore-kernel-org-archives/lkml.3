Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095AbaIRWdT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 18:33:19 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:38915 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755370AbaIRWdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 18:33:15 -0400
From: Josh Cartwright <joshc@codeaurora.org>
To: Wim Van Sebroeck <wim@iguana.be>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kumar Gala <galak@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH 1/3] watchdog: qcom: add support for KPSS WDT
Date: Thu, 18 Sep 2014 17:26:59 -0500
Message-Id: <32d17907ad1dfdcafe4e76f33adc2ff22631cd28.1411078425.git.joshc@codeaurora.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <cover.1411078425.git.joshc@codeaurora.org>
References: <cover.1411078425.git.joshc@codeaurora.org>
In-Reply-To: <cover.1411078425.git.joshc@codeaurora.org>
References: <cover.1411078425.git.joshc@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a driver for the watchdog timer block found in the Krait Processor
Subsystem (KPSS) on the MSM8960, APQ8064, and IPQ8064.

Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
---
 drivers/watchdog/Kconfig    |  10 +++
 drivers/watchdog/Makefile   |   1 +
 drivers/watchdog/qcom-wdt.c | 145 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 156 insertions(+)
 create mode 100644 drivers/watchdog/qcom-wdt.c

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 1d1330a..5ccb963 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -443,6 +443,16 @@ config TEGRA_WATCHDOG
 	  To compile this driver as a module, choose M here: the
 	  module will be called tegra_wdt.
 
+config QCOM_WDT
+	bool "QCOM watchdog"
+	depends on HAS_IOMEM
+	depends on ARCH_QCOM
+	select WATCHDOG_CORE
+	help
+	  Say Y here to include Watchdog timer support for the watchdog found
+	  on QCOM chipsets.  Currently supported targets are the MSM8960,
+	  APQ8064, and IPQ8064.
+
 # AVR32 Architecture
 
 config AT32AP700X_WDT
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index 468c320..d645448 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -57,6 +57,7 @@ obj-$(CONFIG_RETU_WATCHDOG) += retu_wdt.o
 obj-$(CONFIG_BCM2835_WDT) += bcm2835_wdt.o
 obj-$(CONFIG_MOXART_WDT) += moxart_wdt.o
 obj-$(CONFIG_SIRFSOC_WATCHDOG) += sirfsoc_wdt.o
+obj-$(CONFIG_QCOM_WDT) += qcom-wdt.o
 obj-$(CONFIG_BCM_KONA_WDT) += bcm_kona_wdt.o
 obj-$(CONFIG_TEGRA_WATCHDOG) += tegra_wdt.o
 
diff --git a/drivers/watchdog/qcom-wdt.c b/drivers/watchdog/qcom-wdt.c
new file mode 100644
index 0000000..e9409f5
--- /dev/null
+++ b/drivers/watchdog/qcom-wdt.c
@@ -0,0 +1,145 @@
+/* Copyright (c) 2014, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/watchdog.h>
+
+#define WDT_RST		0x0
+#define WDT_EN		0x8
+#define WDT_BITE_TIME	0x24
+
+struct qcom_wdt {
+	struct watchdog_device	wdd;
+	unsigned long		freq;
+	void __iomem		*base;
+};
+
+static inline
+struct qcom_wdt *to_qcom_wdt(struct watchdog_device *wdd)
+{
+	return container_of(wdd, struct qcom_wdt, wdd);
+}
+
+static int qcom_wdt_start(struct watchdog_device *wdd)
+{
+	struct qcom_wdt *wdt = to_qcom_wdt(wdd);
+
+	writel(0, wdt->base + WDT_EN);
+	writel(1, wdt->base + WDT_RST);
+	writel(wdd->timeout * wdt->freq, wdt->base + WDT_BITE_TIME);
+	writel(1, wdt->base + WDT_EN);
+	return 0;
+}
+
+static int qcom_wdt_stop(struct watchdog_device *wdd)
+{
+	struct qcom_wdt *wdt = to_qcom_wdt(wdd);
+
+	writel(0, wdt->base + WDT_EN);
+	return 0;
+}
+
+static int qcom_wdt_ping(struct watchdog_device *wdd)
+{
+	struct qcom_wdt *wdt = to_qcom_wdt(wdd);
+
+	writel(1, wdt->base + WDT_RST);
+	return 0;
+}
+
+static int qcom_wdt_set_timeout(struct watchdog_device *wdd,
+				unsigned int timeout)
+{
+	wdd->timeout = timeout;
+	return qcom_wdt_start(wdd);
+}
+
+static const struct watchdog_ops qcom_wdt_ops = {
+	.start		= qcom_wdt_start,
+	.stop		= qcom_wdt_stop,
+	.ping		= qcom_wdt_ping,
+	.set_timeout	= qcom_wdt_set_timeout,
+	.owner		= THIS_MODULE,
+};
+
+static const struct watchdog_info qcom_wdt_info = {
+	.options	= WDIOF_KEEPALIVEPING
+			| WDIOF_MAGICCLOSE
+			| WDIOF_SETTIMEOUT,
+	.identity	= KBUILD_MODNAME,
+};
+
+static int qcom_watchdog_probe(struct platform_device *pdev)
+{
+	struct qcom_wdt *wdt;
+	struct resource *res;
+	u32 tmp;
+	int ret;
+
+	wdt = devm_kzalloc(&pdev->dev, sizeof(*wdt), GFP_KERNEL);
+	if (!wdt)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, wdt);
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	wdt->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(wdt->base))
+		return PTR_ERR(wdt->base);
+
+	ret = of_property_read_u32(pdev->dev.of_node, "clock-frequency", &tmp);
+	if (ret) {
+		dev_err(&pdev->dev, "unable to get clock-frequency\n");
+		return ret;
+	}
+
+	wdt->freq = tmp;
+
+	wdt->wdd.dev = &pdev->dev;
+	wdt->wdd.info = &qcom_wdt_info;
+	wdt->wdd.ops = &qcom_wdt_ops;
+	wdt->wdd.min_timeout = 1;
+	wdt->wdd.max_timeout = 0x10000000U / wdt->freq;
+	watchdog_init_timeout(&wdt->wdd, 0, &pdev->dev);
+
+	ret = watchdog_register_device(&wdt->wdd);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to register watchdog\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static const struct of_device_id qcom_wdt_of_table[] = {
+	{ .compatible = "qcom,kpss-wdt-msm8960", },
+	{ .compatible = "qcom,kpss-wdt-apq8064", },
+	{ .compatible = "qcom,kpss-wdt-ipq8064", },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, qcom_wdt_of_table);
+
+static struct platform_driver qcom_watchdog_driver = {
+	.probe	= qcom_watchdog_probe,
+	.driver	= {
+		.name		= KBUILD_MODNAME,
+		.of_match_table	= qcom_wdt_of_table,
+	},
+};
+module_platform_driver(qcom_watchdog_driver);
+
+MODULE_DESCRIPTION("QCOM KPSS Watchdog Driver");
+MODULE_LICENSE("GPL v2");
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

