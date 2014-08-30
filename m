Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792AbaH3MwE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 08:52:04 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:45792 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbaH3Mvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 08:51:33 -0400
From: Beniamino Galvani <b.galvani@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Wim Van Sebroeck <wim@iguana.be>, Guenter Roeck <linux@roeck-us.net>,
        linux-watchdog@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Carlo Caione <carlo@caione.org>,
        Beniamino Galvani <b.galvani@gmail.com>
Subject: [PATCH v2 3/4] watchdog: add driver for Ricoh RN5T618 watchdog
Date: Sat, 30 Aug 2014 14:50:25 +0200
Message-Id: <1409403026-28818-4-git-send-email-b.galvani@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1409403026-28818-1-git-send-email-b.galvani@gmail.com>
References: <1409403026-28818-1-git-send-email-b.galvani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a driver for the watchdog timer available in Ricoh RN5T618
PMIC. The device supports a programmable expiration time of 1, 8, 32
or 128 seconds.

Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
---
 drivers/watchdog/Kconfig       |   11 +++
 drivers/watchdog/Makefile      |    1 +
 drivers/watchdog/rn5t618_wdt.c |  198 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 210 insertions(+)
 create mode 100644 drivers/watchdog/rn5t618_wdt.c

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index f57312f..9eba6af 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -309,6 +309,17 @@ config ORION_WATCHDOG
 	  To compile this driver as a module, choose M here: the
 	  module will be called orion_wdt.
 
+config RN5T618_WATCHDOG
+	tristate "Ricoh RN5T618 watchdog"
+	depends on MFD_RN5T618
+	select WATCHDOG_CORE
+	help
+	  If you say yes here you get support for watchdog on the Ricoh
+	  RN5T618 PMIC.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called rn5t618_wdt.
+
 config SUNXI_WATCHDOG
 	tristate "Allwinner SoCs watchdog support"
 	depends on ARCH_SUNXI
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index 468c320..0afa343 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -47,6 +47,7 @@ obj-$(CONFIG_IOP_WATCHDOG) += iop_wdt.o
 obj-$(CONFIG_DAVINCI_WATCHDOG) += davinci_wdt.o
 obj-$(CONFIG_ORION_WATCHDOG) += orion_wdt.o
 obj-$(CONFIG_SUNXI_WATCHDOG) += sunxi_wdt.o
+obj-$(CONFIG_RN5T618_WATCHDOG) += rn5t618_wdt.o
 obj-$(CONFIG_COH901327_WATCHDOG) += coh901327_wdt.o
 obj-$(CONFIG_STMP3XXX_RTC_WATCHDOG) += stmp3xxx_rtc_wdt.o
 obj-$(CONFIG_NUC900_WATCHDOG) += nuc900_wdt.o
diff --git a/drivers/watchdog/rn5t618_wdt.c b/drivers/watchdog/rn5t618_wdt.c
new file mode 100644
index 0000000..b6d62ac
--- /dev/null
+++ b/drivers/watchdog/rn5t618_wdt.c
@@ -0,0 +1,198 @@
+/*
+ * Watchdog driver for Ricoh RN5T618 PMIC
+ *
+ * Copyright (C) 2014 Beniamino Galvani <b.galvani@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program. If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/device.h>
+#include <linux/mfd/rn5t618.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/watchdog.h>
+
+#define DRIVER_NAME "rn5t618-wdt"
+
+static bool nowayout = WATCHDOG_NOWAYOUT;
+static unsigned int heartbeat;
+
+module_param(heartbeat, int, 0);
+MODULE_PARM_DESC(heartbeat, "Initial watchdog heartbeat in seconds");
+
+module_param(nowayout, bool, 0);
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
+		 __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+
+struct rn5t618_wdt {
+	struct watchdog_device wdt_dev;
+	struct rn5t618 *rn5t618;
+};
+
+/*
+ * This array encodes the values of WDOGTIM field for the supported
+ * watchdog expiration times. If the watchdog is not accessed before
+ * the timer expiration, the PMU generates an interrupt and if the CPU
+ * doesn't clear it within one second the system is restarted.
+ */
+static const struct {
+	u8 reg_val;
+	unsigned int time;
+} rn5t618_wdt_map[] = {
+	{ 0, 1 },
+	{ 1, 8 },
+	{ 2, 32 },
+	{ 3, 128 },
+};
+
+static int rn5t618_wdt_set_timeout(struct watchdog_device *wdt_dev,
+				   unsigned int timeout)
+{
+	struct rn5t618_wdt *wdt = watchdog_get_drvdata(wdt_dev);
+	int ret, i;
+
+	for (i = 0; i < ARRAY_SIZE(rn5t618_wdt_map); i++) {
+		if (rn5t618_wdt_map[i].time + 1 >= timeout)
+			break;
+	}
+
+	if (i == ARRAY_SIZE(rn5t618_wdt_map))
+		return -EINVAL;
+
+	ret = regmap_update_bits(wdt->rn5t618->regmap, RN5T618_WATCHDOG,
+				 RN5T618_WATCHDOG_WDOGTIM_M,
+				 rn5t618_wdt_map[i].reg_val);
+	if (!ret)
+		wdt_dev->timeout = rn5t618_wdt_map[i].time;
+
+	return ret;
+}
+
+static int rn5t618_wdt_start(struct watchdog_device *wdt_dev)
+{
+	struct rn5t618_wdt *wdt = watchdog_get_drvdata(wdt_dev);
+	int ret;
+
+	ret = rn5t618_wdt_set_timeout(wdt_dev, wdt_dev->timeout);
+	if (ret)
+		return ret;
+
+	/* enable repower-on */
+	ret = regmap_update_bits(wdt->rn5t618->regmap, RN5T618_REPCNT,
+				 RN5T618_REPCNT_REPWRON,
+				 RN5T618_REPCNT_REPWRON);
+	if (ret)
+		return ret;
+
+	/* enable watchdog */
+	ret = regmap_update_bits(wdt->rn5t618->regmap, RN5T618_WATCHDOG,
+				 RN5T618_WATCHDOG_WDOGEN,
+				 RN5T618_WATCHDOG_WDOGEN);
+	if (ret)
+		return ret;
+
+	/* enable watchdog interrupt */
+	return regmap_update_bits(wdt->rn5t618->regmap, RN5T618_PWRIREN,
+				  RN5T618_PWRIRQ_IR_WDOG,
+				  RN5T618_PWRIRQ_IR_WDOG);
+}
+
+static int rn5t618_wdt_stop(struct watchdog_device *wdt_dev)
+{
+	struct rn5t618_wdt *wdt = watchdog_get_drvdata(wdt_dev);
+
+	return regmap_update_bits(wdt->rn5t618->regmap, RN5T618_WATCHDOG,
+				  RN5T618_WATCHDOG_WDOGEN, 0);
+}
+
+static int rn5t618_wdt_ping(struct watchdog_device *wdt_dev)
+{
+	struct rn5t618_wdt *wdt = watchdog_get_drvdata(wdt_dev);
+	unsigned int val;
+	int ret;
+
+	/* The counter is restarted after a R/W access to watchdog register */
+	ret = regmap_read(wdt->rn5t618->regmap, RN5T618_WATCHDOG, &val);
+	if (ret)
+		return ret;
+
+	ret = regmap_write(wdt->rn5t618->regmap, RN5T618_WATCHDOG, val);
+	if (ret)
+		return ret;
+
+	/* Clear pending watchdog interrupt */
+	return regmap_update_bits(wdt->rn5t618->regmap, RN5T618_PWRIRQ,
+				  RN5T618_PWRIRQ_IR_WDOG, 0);
+}
+
+static struct watchdog_info rn5t618_wdt_info = {
+	.options	= WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE |
+			  WDIOF_KEEPALIVEPING,
+	.identity	= DRIVER_NAME,
+};
+
+static struct watchdog_ops rn5t618_wdt_ops = {
+	.owner          = THIS_MODULE,
+	.start          = rn5t618_wdt_start,
+	.stop           = rn5t618_wdt_stop,
+	.ping           = rn5t618_wdt_ping,
+	.set_timeout    = rn5t618_wdt_set_timeout,
+};
+
+static int rn5t618_wdt_probe(struct platform_device *pdev)
+{
+	struct rn5t618 *rn5t618 = dev_get_drvdata(pdev->dev.parent);
+	struct rn5t618_wdt *wdt;
+	int min_timeout, max_timeout;
+
+	wdt = devm_kzalloc(&pdev->dev, sizeof(struct rn5t618_wdt), GFP_KERNEL);
+	if (!wdt)
+		return -ENOMEM;
+
+	min_timeout = rn5t618_wdt_map[0].time;
+	max_timeout = rn5t618_wdt_map[ARRAY_SIZE(rn5t618_wdt_map) - 1].time;
+
+	wdt->rn5t618 = rn5t618;
+	wdt->wdt_dev.info = &rn5t618_wdt_info;
+	wdt->wdt_dev.ops = &rn5t618_wdt_ops;
+	wdt->wdt_dev.min_timeout = min_timeout;
+	wdt->wdt_dev.max_timeout = max_timeout;
+	wdt->wdt_dev.timeout = max_timeout;
+	wdt->wdt_dev.parent = &pdev->dev;
+
+	watchdog_set_drvdata(&wdt->wdt_dev, wdt);
+	watchdog_init_timeout(&wdt->wdt_dev, heartbeat, &pdev->dev);
+	watchdog_set_nowayout(&wdt->wdt_dev, nowayout);
+
+	platform_set_drvdata(pdev, wdt);
+
+	return watchdog_register_device(&wdt->wdt_dev);
+}
+
+static int rn5t618_wdt_remove(struct platform_device *pdev)
+{
+	struct rn5t618_wdt *wdt = platform_get_drvdata(pdev);
+
+	watchdog_unregister_device(&wdt->wdt_dev);
+
+	return 0;
+}
+
+static struct platform_driver rn5t618_wdt_driver = {
+	.probe = rn5t618_wdt_probe,
+	.remove = rn5t618_wdt_remove,
+	.driver = {
+		.name	= DRIVER_NAME,
+	},
+};
+
+module_platform_driver(rn5t618_wdt_driver);
+
+MODULE_AUTHOR("Beniamino Galvani <b.galvani@gmail.com>");
+MODULE_DESCRIPTION("RN5T618 watchdog driver");
+MODULE_LICENSE("GPL v2");
-- 
1.7.10.4

