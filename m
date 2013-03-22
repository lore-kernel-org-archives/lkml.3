Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933226Ab3CVNix (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 09:38:53 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:59590 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753929Ab3CVNgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 09:36:12 -0400
From: Ian Lartey <ian@slimlogic.co.uk>
To: linux-kernel@vger.kernel.org
Cc: linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-leds@vger.kernel.org, linux-watchdog@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, swarren@wwwdotorg.org,
        grant.likely@secretlab.ca, broonie@opensource.wolfsonmicro.com,
        rob.herring@calxeda.com, rob@landley.net, mturquette@linaro.org,
        linus.walleij@linaro.org, cooloney@gmail.com, sfr@canb.auug.org.au,
        rpurdie@rpsys.net, akpm@linux-foundation.org, sameo@linux.intel.com,
        wim@iguana.be, lgirdwood@gmail.com, gg@slimlogic.co.uk,
        j-keerthy@ti.com, ldewangan@nvidia.com, t-kristo@ti.com
Subject: [PATCH v9 03/11] watchdog: add Palmas Watchdog support
Date: Fri, 22 Mar 2013 13:36:05 +0000
Message-Id: <1363959373-10671-4-git-send-email-ian@slimlogic.co.uk>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1363959373-10671-1-git-send-email-ian@slimlogic.co.uk>
References: <1363959373-10671-1-git-send-email-ian@slimlogic.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graeme Gregory <gg@slimlogic.co.uk>

Add support for the Palmas watchdog timer which has a timeout configurable
from 1s to 128s.

Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
Signed-off-by: Ian Lartey <ian@slimlogic.co.uk>
---
 drivers/watchdog/palmas_wdt.c |  169 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 169 insertions(+), 0 deletions(-)
 create mode 100644 drivers/watchdog/palmas_wdt.c

diff --git a/drivers/watchdog/palmas_wdt.c b/drivers/watchdog/palmas_wdt.c
new file mode 100644
index 0000000..da7e379
--- /dev/null
+++ b/drivers/watchdog/palmas_wdt.c
@@ -0,0 +1,169 @@
+/*
+ * Driver for Watchdog part of Palmas PMIC Chips
+ *
+ * Copyright 2011-2013 Texas Instruments Inc.
+ *
+ * Author: Graeme Gregory <gg@slimlogic.co.uk>
+ * Author: Ian Lartey <ian@slimlogic.co.uk>
+ *
+ * Based on twl4030_wdt.c
+ *
+ * Author: Timo Kokkonen <timo.t.kokkonen at nokia.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify it
+ *  under  the terms of the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/slab.h>
+#include <linux/kernel.h>
+#include <linux/fs.h>
+#include <linux/watchdog.h>
+#include <linux/platform_device.h>
+#include <linux/watchdog.h>
+#include <linux/mfd/palmas.h>
+
+struct palmas_wdt {
+	struct palmas *palmas;
+	struct watchdog_device wdt;
+	struct device *dev;
+
+	int timer_margin;
+};
+
+
+static int nowayout = WATCHDOG_NOWAYOUT;
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started "
+	"(default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+
+static int palmas_wdt_write(struct palmas *palmas, unsigned int data)
+{
+	unsigned int addr;
+
+	addr = PALMAS_BASE_TO_REG(PALMAS_PMU_CONTROL_BASE, PALMAS_WATCHDOG);
+
+	return palmas_write(palmas, PALMAS_PMU_CONTROL_BASE, addr, addr);
+}
+
+static int palmas_wdt_enable(struct watchdog_device *wdt)
+{
+	struct palmas_wdt *driver_data = watchdog_get_drvdata(wdt);
+	struct palmas *palmas = driver_data->palmas;
+
+	return palmas_wdt_write(palmas, driver_data->timer_margin |
+				PALMAS_WATCHDOG_ENABLE);
+}
+
+static int palmas_wdt_disable(struct watchdog_device *wdt)
+{
+	struct palmas_wdt *driver_data = watchdog_get_drvdata(wdt);
+	struct palmas *palmas = driver_data->palmas;
+
+	return palmas_wdt_write(palmas, driver_data->timer_margin);
+}
+
+static int palmas_wdt_set_timeout(struct watchdog_device *wdt, unsigned timeout)
+{
+	struct palmas_wdt *driver_data = watchdog_get_drvdata(wdt);
+
+	if (timeout < 1 || timeout > 128) {
+		dev_warn(driver_data->dev,
+			"Timeout can only be in the range [1-128] seconds");
+		return -EINVAL;
+	}
+	driver_data->timer_margin = fls(timeout) - 1;
+	return 0;
+}
+
+static const struct watchdog_info palmas_wdt_info = {
+	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE,
+	.identity = "Palmas Watchdog",
+	.firmware_version = 0,
+};
+
+static const struct watchdog_ops palmas_wdt_ops = {
+	.owner = THIS_MODULE,
+	.start = palmas_wdt_enable,
+	.stop = palmas_wdt_disable,
+	.ping = palmas_wdt_enable,
+	.set_timeout = palmas_wdt_set_timeout,
+};
+
+static int palmas_wdt_probe(struct platform_device *pdev)
+{
+	struct palmas *palmas = dev_get_drvdata(pdev->dev.parent);
+	struct palmas_wdt *driver_data;
+	struct watchdog_device *palmas_wdt;
+	int ret = 0;
+
+	driver_data = devm_kzalloc(&pdev->dev, sizeof(*driver_data),
+				   GFP_KERNEL);
+	if (!driver_data) {
+		dev_err(&pdev->dev, "Unable to alloacate watchdog device\n");
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	driver_data->palmas = palmas;
+
+	palmas_wdt = &driver_data->wdt;
+
+	palmas_wdt->info = &palmas_wdt_info;
+	palmas_wdt->ops = &palmas_wdt_ops;
+	watchdog_set_nowayout(palmas_wdt, nowayout);
+	watchdog_set_drvdata(palmas_wdt, driver_data);
+
+	ret = watchdog_register_device(&driver_data->wdt);
+	if (ret) {
+		platform_set_drvdata(pdev, NULL);
+		goto err;
+	}
+
+	dev_set_drvdata(&pdev->dev, driver_data);
+
+	return 0;
+err:
+	return ret;
+}
+
+static int palmas_wdt_remove(struct platform_device *pdev)
+{
+	struct palmas_wdt *driver_data = dev_get_drvdata(&pdev->dev);
+
+	watchdog_unregister_device(&driver_data->wdt);
+
+	return 0;
+}
+
+static struct of_device_id of_palmas_match_tbl[] = {
+	{ .compatible = "ti,palmas-wdt", },
+	{ .compatible = "ti,twl6035-wdt", },
+	{ .compatible = "ti,twl6036-wdt", },
+	{ .compatible = "ti,twl6037-wdt", },
+	{ .compatible = "ti,tps65913-wdt", },
+	{ .compatible = "ti,tps65914-wdt", },
+	{ .compatible = "ti,tps80036-wdt", },
+	{ /* end */ }
+};
+
+static struct platform_driver palmas_wdt_driver = {
+	.probe = palmas_wdt_probe,
+	.remove = palmas_wdt_remove,
+	.driver = {
+		.owner = THIS_MODULE,
+		.of_match_table = of_palmas_match_tbl,
+		.name = "palmas-wdt",
+	},
+};
+
+module_platform_driver(palmas_wdt_driver);
+
+MODULE_AUTHOR("Graeme Gregory <gg@slimlogic.co.uk>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:palmas-wdt");
+MODULE_DEVICE_TABLE(of, of_palmas_match_tbl);
-- 
1.7.0.4

