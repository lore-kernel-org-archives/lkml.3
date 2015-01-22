Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761AbbAVL6m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 06:58:42 -0500
Received: from mail-ig0-f176.google.com ([209.85.213.176]:43505 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174AbbAVL5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 06:57:04 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, rtc-linux@googlegroups.com,
        wim@iguana.be, linux-watchdog@vger.kernel.org,
        devicetree@vger.kernel.org, linux@roeck-us.net, david.paris@st.com
Subject: [PATCH v2 6/9] watchdog: st_wdt: Add new driver for ST's LPC Watchdog
Date: Thu, 22 Jan 2015 11:56:04 +0000
Message-Id: <1421927767-28889-7-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421927767-28889-1-git-send-email-lee.jones@linaro.org>
References: <1421927767-28889-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Paris <david.paris@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/watchdog/Kconfig      |  13 ++
 drivers/watchdog/Makefile     |   1 +
 drivers/watchdog/st_lpc_wdt.c | 335 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 349 insertions(+)
 create mode 100644 drivers/watchdog/st_lpc_wdt.c

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 08f41ad..a3b483c 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -471,6 +471,19 @@ config SIRFSOC_WATCHDOG
 	  Support for CSR SiRFprimaII and SiRFatlasVI watchdog. When
 	  the watchdog triggers the system will be reset.
 
+config ST_LPC_WATCHDOG
+	tristate "STMicroelectronics LPC Watchdog"
+	depends on ARCH_STI
+	depends on OF
+	select WATCHDOG_CORE
+	select MFD_ST_LPC
+	help
+	  Say Y here to include STMicroelectronics Low Power Controller
+	  (LPC) based Watchdog timer support.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called st_wdt.
+
 config TEGRA_WATCHDOG
 	tristate "Tegra watchdog"
 	depends on (ARCH_TEGRA || COMPILE_TEST) && HAS_IOMEM
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index c569ec8..31dd6a0 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -59,6 +59,7 @@ obj-$(CONFIG_RETU_WATCHDOG) += retu_wdt.o
 obj-$(CONFIG_BCM2835_WDT) += bcm2835_wdt.o
 obj-$(CONFIG_MOXART_WDT) += moxart_wdt.o
 obj-$(CONFIG_SIRFSOC_WATCHDOG) += sirfsoc_wdt.o
+obj-$(CONFIG_ST_LPC_WATCHDOG) += st_lpc_wdt.o
 obj-$(CONFIG_QCOM_WDT) += qcom-wdt.o
 obj-$(CONFIG_BCM_KONA_WDT) += bcm_kona_wdt.o
 obj-$(CONFIG_TEGRA_WATCHDOG) += tegra_wdt.o
diff --git a/drivers/watchdog/st_lpc_wdt.c b/drivers/watchdog/st_lpc_wdt.c
new file mode 100644
index 0000000..19a7e889
--- /dev/null
+++ b/drivers/watchdog/st_lpc_wdt.c
@@ -0,0 +1,335 @@
+/*
+ * st-wdt.c - ST's LPC Watchdog
+ *
+ * Copyright (C) 2014 STMicroelectronics -- All Rights Reserved
+ *
+ * Author: David Paris <david.paris@st.com> for STMicroelectronics
+ *         Lee Jones <lee.jones@linaro.org> for STMicroelectronics
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#include <linux/clk.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/mfd/syscon.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+#include <linux/watchdog.h>
+
+#include <dt-bindings/mfd/st-lpc.h>
+
+/* Low Power Alarm */
+#define LPC_LPA_LSB_OFF			0x410
+#define LPC_LPA_START_OFF		0x418
+
+/* LPC as WDT */
+#define LPC_WDT_OFF			0x510
+
+static struct watchdog_device st_wdog_dev;
+
+struct st_wdog_syscfg {
+	struct regmap *regmap;
+	unsigned int reset_type_reg;
+	unsigned int reset_type_mask;
+	unsigned int enable_reg;
+	unsigned int enable_mask;
+};
+
+struct st_wdog {
+	void __iomem *base;
+	struct device *dev;
+	struct st_wdog_syscfg *syscfg;
+	struct clk *clk;
+	unsigned long clkrate;
+	bool warm_reset;
+};
+
+static struct st_wdog_syscfg stid127_syscfg = {
+	.reset_type_reg		= 0x004,
+	.reset_type_mask	= BIT(2),
+	.enable_reg		= 0x000,
+	.enable_mask		= BIT(2),
+};
+
+static struct st_wdog_syscfg stih415_syscfg = {
+	.reset_type_reg		= 0x0B8,
+	.reset_type_mask	= BIT(6),
+	.enable_reg		= 0x0B4,
+	.enable_mask		= BIT(7),
+};
+
+static struct st_wdog_syscfg stih416_syscfg = {
+	.reset_type_reg		= 0x88C,
+	.reset_type_mask	= BIT(6),
+	.enable_reg		= 0x888,
+	.enable_mask		= BIT(7),
+};
+
+static struct st_wdog_syscfg stih407_syscfg = {
+	.enable_reg		= 0x204,
+	.enable_mask		= BIT(19),
+};
+
+static struct of_device_id st_wdog_match[] = {
+	{
+		.compatible = "st,stih407-lpc",
+		.data = &stih407_syscfg,
+	},
+	{
+		.compatible = "st,stih416-lpc",
+		.data = &stih416_syscfg,
+	},
+	{
+		.compatible = "st,stih415-lpc",
+		.data = &stih415_syscfg,
+	},
+	{
+		.compatible = "st,stid127-lpc",
+		.data = &stid127_syscfg,
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(of, st_wdog_match);
+
+static void st_wdog_setup(struct st_wdog *st_wdog, bool enable)
+{
+	/* Type of watchdog reset - 0: Cold 1: Warm */
+	if (st_wdog->syscfg->reset_type_reg)
+		regmap_update_bits(st_wdog->syscfg->regmap,
+				   st_wdog->syscfg->reset_type_reg,
+				   st_wdog->syscfg->reset_type_mask,
+				   st_wdog->warm_reset);
+
+	/* Mask/unmask watchdog reset */
+	regmap_update_bits(st_wdog->syscfg->regmap,
+			   st_wdog->syscfg->enable_reg,
+			   st_wdog->syscfg->enable_mask,
+			   enable ? 0 : st_wdog->syscfg->enable_mask);
+}
+
+static void st_wdog_load_timer(struct st_wdog *st_wdog, unsigned int timeout)
+{
+	unsigned long clkrate = st_wdog->clkrate;
+
+	writel_relaxed(timeout * clkrate, st_wdog->base + LPC_LPA_LSB_OFF);
+	writel_relaxed(1, st_wdog->base + LPC_LPA_START_OFF);
+}
+
+static int st_wdog_start(struct watchdog_device *wdd)
+{
+	struct st_wdog *st_wdog = watchdog_get_drvdata(wdd);
+
+	writel_relaxed(1, st_wdog->base + LPC_WDT_OFF);
+
+	return 0;
+}
+
+static int st_wdog_stop(struct watchdog_device *wdd)
+{
+	struct st_wdog *st_wdog = watchdog_get_drvdata(wdd);
+
+	writel_relaxed(0, st_wdog->base + LPC_WDT_OFF);
+
+	return 0;
+}
+
+static int st_wdog_set_timeout(struct watchdog_device *wdd,
+			       unsigned int timeout)
+{
+	struct st_wdog *st_wdog = watchdog_get_drvdata(wdd);
+
+	wdd->timeout = timeout;
+	st_wdog_load_timer(st_wdog, timeout);
+
+	return 0;
+}
+
+static int st_wdog_keepalive(struct watchdog_device *wdd)
+{
+	struct st_wdog *st_wdog = watchdog_get_drvdata(wdd);
+
+	st_wdog_load_timer(st_wdog, wdd->timeout);
+
+	return 0;
+}
+
+static const struct watchdog_info st_wdog_info = {
+	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE,
+	.identity = "ST LPC WDT",
+};
+
+static const struct watchdog_ops st_wdog_ops = {
+	.owner		= THIS_MODULE,
+	.start		= st_wdog_start,
+	.stop		= st_wdog_stop,
+	.ping		= st_wdog_keepalive,
+	.set_timeout	= st_wdog_set_timeout,
+};
+
+static struct watchdog_device st_wdog_dev = {
+	.info		= &st_wdog_info,
+	.ops		= &st_wdog_ops,
+};
+
+static int st_wdog_probe(struct platform_device *pdev)
+{
+	const struct of_device_id *match;
+	struct device_node *np = pdev->dev.of_node;
+	struct st_wdog *st_wdog;
+	struct regmap *regmap;
+	struct resource *res;
+	struct clk *clk;
+	void __iomem *base;
+	uint32_t mode;
+	int ret;
+
+	ret = of_property_read_u32(np, "st,lpc-mode", &mode);
+	if (ret) {
+		dev_err(&pdev->dev, "An LPC mode must be provided\n");
+		return -EINVAL;
+	}
+
+	/* LPC can either run in RTC or WDT mode */
+	if (mode != ST_LPC_MODE_WDT)
+		return -ENODEV;
+
+	st_wdog = devm_kzalloc(&pdev->dev, sizeof(*st_wdog), GFP_KERNEL);
+	if (!st_wdog)
+		return -ENOMEM;
+
+	match = of_match_device(st_wdog_match, &pdev->dev);
+	if (!match) {
+		dev_err(&pdev->dev, "Couldn't match device\n");
+		return -ENODEV;
+	}
+	st_wdog->syscfg	= (struct st_wdog_syscfg *)match->data;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(base)) {
+		dev_err(&pdev->dev, "Failed to ioremap base\n");
+		return PTR_ERR(base);
+	}
+
+	regmap = syscon_regmap_lookup_by_phandle(np, "st,syscfg");
+	if (IS_ERR(regmap)) {
+		dev_err(&pdev->dev, "No syscfg phandle specified\n");
+		return PTR_ERR(regmap);
+	}
+
+	clk = devm_clk_get(&pdev->dev, NULL);
+	if (IS_ERR(clk)) {
+		dev_err(&pdev->dev, "Unable to request clock\n");
+		return PTR_ERR(clk);
+	}
+
+	st_wdog->dev		= &pdev->dev;
+	st_wdog->base		= base;
+	st_wdog->clk		= clk;
+	st_wdog->syscfg->regmap = regmap;
+	st_wdog->warm_reset	= of_property_read_bool(np, "st,warm_reset");
+	st_wdog->clkrate	= clk_get_rate(st_wdog->clk);
+
+	if (!st_wdog->clkrate) {
+		dev_err(&pdev->dev, "Unable to fetch clock rate\n");
+		return -EINVAL;
+	}
+	st_wdog_dev.max_timeout = 0xFFFFFFFF / st_wdog->clkrate;
+
+	ret = clk_prepare_enable(clk);
+	if (ret) {
+		dev_err(&pdev->dev, "Unable to enable clock\n");
+		return ret;
+	}
+
+	watchdog_set_drvdata(&st_wdog_dev, st_wdog);
+	watchdog_set_nowayout(&st_wdog_dev, WATCHDOG_NOWAYOUT);
+
+	/* Init Watchdog timeout with value in DT */
+	ret = watchdog_init_timeout(&st_wdog_dev, 0, &pdev->dev);
+	if (ret) {
+		dev_err(&pdev->dev, "Unable to initialise watchdog timeout\n");
+		clk_disable_unprepare(clk);
+		return ret;
+	}
+
+	ret = watchdog_register_device(&st_wdog_dev);
+	if (ret) {
+		dev_err(&pdev->dev, "Unable to register watchdog\n");
+		clk_disable_unprepare(clk);
+		return ret;
+	}
+
+	st_wdog_setup(st_wdog, true);
+
+	dev_info(&pdev->dev, "LPC Watchdog driver registered, reset type is %s",
+		 st_wdog->warm_reset ? "warm" : "cold");
+
+	return ret;
+}
+
+static int st_wdog_remove(struct platform_device *pdev)
+{
+	struct st_wdog *st_wdog = watchdog_get_drvdata(&st_wdog_dev);
+
+	st_wdog_setup(st_wdog, false);
+	watchdog_unregister_device(&st_wdog_dev);
+	clk_disable_unprepare(st_wdog->clk);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int st_wdog_suspend(struct device *dev)
+{
+	struct st_wdog *st_wdog = watchdog_get_drvdata(&st_wdog_dev);
+
+	if (watchdog_active(&st_wdog_dev))
+		st_wdog_stop(&st_wdog_dev);
+
+	st_wdog_setup(st_wdog, false);
+
+	return 0;
+}
+
+static int st_wdog_resume(struct device *dev)
+{
+	struct st_wdog *st_wdog = watchdog_get_drvdata(&st_wdog_dev);
+
+	st_wdog_setup(st_wdog, true);
+
+	if (watchdog_active(&st_wdog_dev)) {
+		st_wdog_load_timer(st_wdog, st_wdog_dev.timeout);
+		st_wdog_start(&st_wdog_dev);
+	}
+
+	return 0;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(st_wdog_pm_ops,
+			 st_wdog_suspend,
+			 st_wdog_resume);
+
+static struct platform_driver st_wdog_driver = {
+	.driver	= {
+		.name = "st-lpc-wdt",
+		.pm = &st_wdog_pm_ops,
+		.of_match_table = st_wdog_match,
+	},
+	.probe = st_wdog_probe,
+	.remove = st_wdog_remove,
+};
+module_platform_driver(st_wdog_driver);
+
+MODULE_AUTHOR("David Paris <david.paris@st.com>");
+MODULE_DESCRIPTION("ST LPC Watchdog Driver");
+MODULE_LICENSE("GPL v2");
-- 
1.9.1

