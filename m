Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230AbaJWPTY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 11:19:24 -0400
Received: from mail-yh0-f42.google.com ([209.85.213.42]:40424 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715AbaJWPTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 11:19:14 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        wim@iguana.be, linux-watchdog@vger.kernel.org, linux@roeck-us.net
Cc: lee.jones@linaro.org, kernel@stlinux.com, David Paris <david.paris@st.com>
Subject: [PATCH 4/4] watchdog: st_wdt: Add new driver for ST's LPC Watchdog
Date: Thu, 23 Oct 2014 16:18:44 +0100
Message-Id: <1414077524-6469-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414077524-6469-1-git-send-email-lee.jones@linaro.org>
References: <1414077524-6469-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Paris <david.paris@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/watchdog/Kconfig  |  16 +++
 drivers/watchdog/Makefile |   1 +
 drivers/watchdog/st_wdt.c | 317 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 334 insertions(+)
 create mode 100644 drivers/watchdog/st_wdt.c

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index f57312f..c8abf57 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -432,6 +432,22 @@ config SIRFSOC_WATCHDOG
 	  Support for CSR SiRFprimaII and SiRFatlasVI watchdog. When
 	  the watchdog triggers the system will be reset.
 
+config ST_WATCHDOG
+       tristate "STMicroelectronics LPC Watchdog"
+       depends on ARCH_STI && OF
+       depends on !RTC_DRV_ST_LPC
+       select WATCHDOG_CORE
+       help
+	 Say Y here to include Watchdog timer support for the watchdog
+	 existing in the LPC of STMicroelectronics SOCs.
+	 !!! BE CARREFUL !!!
+	 This driver shares hardware resources with RTC Alarm part of the
+	 LPC. Both LPC Watchdog driver and LPC RTC driver cannot be
+	 used together.
+
+	 To compile this driver as a module, choose M here: the
+	 module will be called st-wdt.
+
 config TEGRA_WATCHDOG
 	tristate "Tegra watchdog"
 	depends on ARCH_TEGRA || COMPILE_TEST
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index 468c320..eb19937 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -57,6 +57,7 @@ obj-$(CONFIG_RETU_WATCHDOG) += retu_wdt.o
 obj-$(CONFIG_BCM2835_WDT) += bcm2835_wdt.o
 obj-$(CONFIG_MOXART_WDT) += moxart_wdt.o
 obj-$(CONFIG_SIRFSOC_WATCHDOG) += sirfsoc_wdt.o
+obj-$(CONFIG_ST_WATCHDOG) += st_wdt.o
 obj-$(CONFIG_BCM_KONA_WDT) += bcm_kona_wdt.o
 obj-$(CONFIG_TEGRA_WATCHDOG) += tegra_wdt.o
 
diff --git a/drivers/watchdog/st_wdt.c b/drivers/watchdog/st_wdt.c
new file mode 100644
index 0000000..017974b
--- /dev/null
+++ b/drivers/watchdog/st_wdt.c
@@ -0,0 +1,317 @@
+/*
+ * st-wdt.c - ST's LPC Watchdog
+ *
+ * Copyright (C) 2014 STMicroelectronics -- All Rights Reserved
+ *
+ * Author: David Paris <david.paris@st.com> for STMicroelectronics
+ * Contributor: Lee Jones <lee.jones@linaro.org> for STMicroelectronics
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
+/* Low Power Alarm */
+#define LPC_LPA_LSB_OFF			0x410
+#define LPC_LPA_START_OFF		0x418
+
+/* LPC as WDT */
+#define LPC_WDT_OFF			0x510
+
+#define WATCHDOG_MIN			1
+#define WATCHDOG_MAX32			4294967 /* 32bit resolution */
+
+struct st_wdog_syscfg {
+	struct regmap *regmap;
+	unsigned int type_reg;
+	unsigned int type_mask;
+	unsigned int enable_reg;
+	unsigned int enable_mask;
+};
+
+struct st_wdog {
+	void __iomem *base;
+	struct device *dev;
+	struct st_wdog_syscfg *syscfg;
+	struct clk *clk;
+	int warm_reset;
+};
+
+static struct st_wdog_syscfg stid127_syscfg = {
+	.type_mask	= BIT(2),
+	.enable_mask	= BIT(2),
+};
+
+static struct st_wdog_syscfg stih415_syscfg = {
+	.type_mask	= BIT(6),
+	.enable_mask	= BIT(7),
+};
+
+static struct st_wdog_syscfg stih416_syscfg = {
+	.type_mask	= BIT(6),
+	.enable_mask	= BIT(7),
+};
+
+static struct st_wdog_syscfg stih407_syscfg = {
+	.enable_mask	= BIT(19),
+};
+
+static struct of_device_id st_wdog_match[] = {
+	{
+		.compatible = "st,stih407-watchdog",
+		.data = (void *)&stih407_syscfg,
+	},
+	{
+		.compatible = "st,stih416-watchdog",
+		.data = (void *)&stih416_syscfg,
+	},
+	{
+		.compatible = "st,stih415-watchdog",
+		.data = (void *)&stih415_syscfg,
+	},
+	{
+		.compatible = "st,stid127-watchdog",
+		.data = (void *)&stid127_syscfg,
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(of, st_wdog_match);
+
+static void st_wdog_setup(struct st_wdog *st_wdog, bool enable)
+{
+	/* Type of watchdog reset - 0: Cold 1: Warm */
+	if (st_wdog->syscfg->type_reg)
+		regmap_update_bits(st_wdog->syscfg->regmap,
+				   st_wdog->syscfg->type_reg,
+				   st_wdog->syscfg->type_mask,
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
+	unsigned long clkrate = clk_get_rate(st_wdog->clk);
+	unsigned int maxtimeout = 0xFFFFFFFF / clkrate;
+
+	if (timeout > maxtimeout) {
+		dev_warn(st_wdog->dev,
+			 "timer overrun detected at current freq (%luHz)\n"
+			 "wdog timeout set for %ds instead of requested %uis",
+			 clkrate, maxtimeout, timeout);
+		timeout = maxtimeout;
+	}
+	timeout *= clkrate;
+
+	writel_relaxed(timeout, st_wdog->base + LPC_LPA_LSB_OFF);
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
+	int ret;
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
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "base");
+	base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(base)) {
+		dev_err(&pdev->dev, "Failed to ioremap base\n");
+		return PTR_ERR(base);
+	}
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "syscfg-en");
+	if (!res) {
+		dev_err(&pdev->dev, "Failed to get enable register address\n");
+		return -EINVAL;
+	}
+	st_wdog->syscfg->enable_reg = res->start;
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "syscfg-type");
+	if (res)
+		st_wdog->syscfg->type_reg = res->start;
+
+	regmap = syscon_regmap_lookup_by_phandle(np, "st,syscfg");
+	if (IS_ERR(regmap)) {
+		dev_err(&pdev->dev, "No syscfg phandle specified\n");
+		return PTR_ERR(regmap);
+	}
+
+	clk = of_clk_get_by_name(np, "st_wdog");
+	if (IS_ERR(clk)) {
+		dev_err(&pdev->dev, "Unable to request clock\n");
+		return PTR_ERR(clk);
+	}
+	clk_prepare_enable(st_wdog->clk);
+
+	st_wdog->dev		= &pdev->dev;
+	st_wdog->base		= base;
+	st_wdog->clk		= clk;
+	st_wdog->warm_reset	= of_property_read_bool(np, "st,warm_reset");
+	st_wdog->syscfg->regmap = regmap;
+
+	watchdog_set_drvdata(&st_wdog_dev, st_wdog);
+	watchdog_set_nowayout(&st_wdog_dev, WATCHDOG_NOWAYOUT);
+
+	/* Init Watchdog timeout with value in DT */
+	ret = watchdog_init_timeout(&st_wdog_dev, 0, &pdev->dev);
+	if (ret) {
+		dev_err(&pdev->dev, "Unable to initialise watchdog timeout\n");
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
+#ifdef CONFIG_PM
+static int st_wdog_suspend(struct device *dev)
+{
+	if (watchdog_active(&st_wdog_dev))
+		st_wdog_stop(&st_wdog_dev);
+
+	return 0;
+}
+
+static int st_wdog_resume(struct device *dev)
+{
+	struct st_wdog *st_wdog = watchdog_get_drvdata(&st_wdog_dev);
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
+		.name = "st-wdt",
+		.pm = &st_wdog_pm_ops,
+		.of_match_table = st_wdog_match,
+	},
+	.probe = st_wdog_probe,
+	.remove = st_wdog_remove,
+};
+module_platform_driver(st_wdog_driver);
+
+MODULE_AUTHOR("David PARIS <david.paris@st.com>");
+MODULE_DESCRIPTION("ST LPC Watchdog Driver");
+MODULE_LICENSE("GPL v2");
-- 
1.9.1

