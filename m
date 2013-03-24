Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab3CXOXJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 10:23:09 -0400
Received: from norkia.v3.sk ([91.210.183.14]:56570 "EHLO norkia.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753974Ab3CXOXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 10:23:07 -0400
X-Amavis-Alert: BAD HEADER, Duplicate header field: "To"
From: Lubomir Rintel <lkundrak@v3.sk>
To: linux-kernel@vger.kernel.org
Cc: Lubomir Rintel <lkundrak@v3.sk>, Stephen Warren <swarren@wwwdotorg.org>,
        Wim Van Sebroeck <wim@iguana.be>, linux-rpi-kernel@lists.infradead.org,
        linux-watchdog@vger.kernel.org
Subject: [PATCH v2] watchdog: Add Broadcom BCM2835 watchdog timer driver
Date: Sun, 24 Mar 2013 15:22:53 +0100
Message-Id: <1364134973-26592-1-git-send-email-lkundrak@v3.sk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1363956907-5644-1-git-send-email-lkundrak@v3.sk>
References: <1363956907-5644-1-git-send-email-lkundrak@v3.sk>
To: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a driver for watchdog timer hardware present on Broadcom BCM2835 SoC,
used in Raspberry Pi and Roku 2 devices.

Interface to the Broadcom BCM2835 watchdog timer hardware is based on
"bcm2708_wdog" driver written by Luke Diamand that was obtained from branch
"rpi-3.6.y" of git://github.com/raspberrypi/linux.git

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-rpi-kernel@lists.infradead.org
Cc: linux-watchdog@vger.kernel.org
---
Changes for v2:
    - Use per-device structure instead of global variables for lock and memory base
    - Fix default timeout setting
    - Do not leak memory if probe fails
    - Style fixes
    - Split out defconfig into a separate commit
    - Meaningful commit message with credit

 .../bindings/watchdog/brcm,bcm2835-pm-wdog.txt     |    5 +
 drivers/watchdog/Kconfig                           |   11 ++
 drivers/watchdog/Makefile                          |    1 +
 drivers/watchdog/bcm2835_wdt.c                     |  189 ++++++++++++++++++++
 4 files changed, 206 insertions(+), 0 deletions(-)
 create mode 100644 drivers/watchdog/bcm2835_wdt.c

diff --git a/Documentation/devicetree/bindings/watchdog/brcm,bcm2835-pm-wdog.txt b/Documentation/devicetree/bindings/watchdog/brcm,bcm2835-pm-wdog.txt
index d209366..f801d71 100644
--- a/Documentation/devicetree/bindings/watchdog/brcm,bcm2835-pm-wdog.txt
+++ b/Documentation/devicetree/bindings/watchdog/brcm,bcm2835-pm-wdog.txt
@@ -5,9 +5,14 @@ Required properties:
 - compatible : should be "brcm,bcm2835-pm-wdt"
 - reg : Specifies base physical address and size of the registers.
 
+Optional properties:
+
+- timeout-sec   : Contains the watchdog timeout in seconds
+
 Example:
 
 watchdog {
 	compatible = "brcm,bcm2835-pm-wdt";
 	reg = <0x7e100000 0x28>;
+	timeout-sec = <10>;
 };
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 9fcc70c..f4e4a8e 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -1098,6 +1098,17 @@ config BCM63XX_WDT
 	  To compile this driver as a loadable module, choose M here.
 	  The module will be called bcm63xx_wdt.
 
+config BCM2835_WDT
+	tristate "Broadcom BCM2835 hardware watchdog"
+	depends on ARCH_BCM2835
+	select WATCHDOG_CORE
+	help
+	  Watchdog driver for the built in watchdog hardware in Broadcom
+	  BCM2835 SoC.
+
+	  To compile this driver as a loadable module, choose M here.
+	  The module will be called bcm2835_wdt.
+
 config LANTIQ_WDT
 	tristate "Lantiq SoC watchdog"
 	depends on LANTIQ
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index a300b94..1bf5675 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -54,6 +54,7 @@ obj-$(CONFIG_TS72XX_WATCHDOG) += ts72xx_wdt.o
 obj-$(CONFIG_IMX2_WDT) += imx2_wdt.o
 obj-$(CONFIG_UX500_WATCHDOG) += ux500_wdt.o
 obj-$(CONFIG_RETU_WATCHDOG) += retu_wdt.o
+obj-$(CONFIG_BCM2835_WDT) += bcm2835_wdt.o
 
 # AVR32 Architecture
 obj-$(CONFIG_AT32AP700X_WDT) += at32ap700x_wdt.o
diff --git a/drivers/watchdog/bcm2835_wdt.c b/drivers/watchdog/bcm2835_wdt.c
new file mode 100644
index 0000000..3899638
--- /dev/null
+++ b/drivers/watchdog/bcm2835_wdt.c
@@ -0,0 +1,189 @@
+/*
+ *  Watchdog driver for Broadcom BCM2835
+ *
+ *  Copyright (C) 2013 Lubomir Rintel <lkundrak@v3.sk>
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation; either version
+ *  2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/types.h>
+#include <linux/module.h>
+#include <linux/io.h>
+#include <linux/watchdog.h>
+#include <linux/platform_device.h>
+#include <linux/of_address.h>
+#include <linux/miscdevice.h>
+
+#define PM_RSTC				0x1c
+#define PM_RSTS				0x20
+#define PM_WDOG				0x24
+
+#define PM_PASSWORD			0x5a000000
+#define PM_RSTC_WRCFG_MASK		0x00000030
+#define PM_RSTC_WRCFG_FULL_RESET	0x00000020
+#define PM_RSTS_HADWRH_SET		0x00000040
+
+#define PM_WDOG_TIME_SET		0x000fffff
+#define PM_RSTC_WRCFG_CLR		0xffffffcf
+#define PM_RSTC_WRCFG_SET		0x00000030
+#define PM_RSTC_WRCFG_FULL_RESET	0x00000020
+#define PM_RSTC_RESET			0x00000102
+
+#define SECS_TO_WDOG_TICKS(x) ((x) << 16)
+#define WDOG_TICKS_TO_SECS(x) ((x) >> 16)
+
+struct bcm2835_wdt {
+	void __iomem		*base;
+	spinlock_t		lock;
+};
+
+static int heartbeat = -1;
+static bool nowayout = WATCHDOG_NOWAYOUT;
+
+static int bcm2835_wdt_start(struct watchdog_device *wdog)
+{
+	struct bcm2835_wdt *wdt = watchdog_get_drvdata(wdog);
+	uint32_t cur;
+	unsigned long flags;
+
+	spin_lock_irqsave(&wdt->lock, flags);
+
+	writel_relaxed(PM_PASSWORD | (SECS_TO_WDOG_TICKS(wdog->timeout) &
+				PM_WDOG_TIME_SET), wdt->base + PM_WDOG);
+	cur = readl_relaxed(wdt->base + PM_RSTC);
+	writel_relaxed(PM_PASSWORD | (cur & PM_RSTC_WRCFG_CLR) |
+		  PM_RSTC_WRCFG_FULL_RESET, wdt->base + PM_RSTC);
+
+	spin_unlock_irqrestore(&wdt->lock, flags);
+
+	return 0;
+}
+
+static int bcm2835_wdt_stop(struct watchdog_device *wdog)
+{
+	struct bcm2835_wdt *wdt = watchdog_get_drvdata(wdog);
+
+	writel_relaxed(PM_PASSWORD | PM_RSTC_RESET, wdt->base + PM_RSTC);
+	dev_info(wdog->dev, "Watchdog timer stopped");
+	return 0;
+}
+
+static int bcm2835_wdt_set_timeout(struct watchdog_device *wdog, unsigned int t)
+{
+	wdog->timeout = t;
+	return 0;
+}
+
+static unsigned int bcm2835_wdt_get_timeleft(struct watchdog_device *wdog)
+{
+	struct bcm2835_wdt *wdt = watchdog_get_drvdata(wdog);
+
+	uint32_t ret = readl_relaxed(wdt->base + PM_WDOG);
+	return WDOG_TICKS_TO_SECS(ret & PM_WDOG_TIME_SET);
+}
+
+static struct watchdog_ops bcm2835_wdt_ops = {
+	.owner =	THIS_MODULE,
+	.start =	bcm2835_wdt_start,
+	.stop =		bcm2835_wdt_stop,
+	.set_timeout =	bcm2835_wdt_set_timeout,
+	.get_timeleft =	bcm2835_wdt_get_timeleft,
+};
+
+static struct watchdog_info bcm2835_wdt_info = {
+	.options =	WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE |
+			WDIOF_KEEPALIVEPING,
+	.identity =	"Broadcom BCM2835 Watchdog timer",
+};
+
+static struct watchdog_device bcm2835_wdt_wdd = {
+	.info =		&bcm2835_wdt_info,
+	.ops =		&bcm2835_wdt_ops,
+	.min_timeout =	1,
+	.max_timeout =	WDOG_TICKS_TO_SECS(PM_WDOG_TIME_SET),
+	.timeout =	WDOG_TICKS_TO_SECS(PM_WDOG_TIME_SET),
+};
+
+static int bcm2835_wdt_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct device_node *np = dev->of_node;
+	struct bcm2835_wdt *wdt;
+	int err;
+
+	wdt = devm_kzalloc(dev, sizeof(struct bcm2835_wdt), GFP_KERNEL);
+	if (!wdt) {
+		dev_err(dev, "Failed to allocate memory for watchdog device");
+		return -ENOMEM;
+	}
+
+	spin_lock_init(&wdt->lock);
+
+	wdt->base = of_iomap(np, 0);
+	if (!wdt->base) {
+		dev_err(dev, "Failed to remap watchdog regs");
+		return -ENODEV;
+	}
+	dev_info(dev, "Broadcom BCM2835 watchdog timer");
+
+	platform_set_drvdata(pdev, wdt);
+
+	watchdog_set_drvdata(&bcm2835_wdt_wdd, wdt);
+	watchdog_init_timeout(&bcm2835_wdt_wdd, heartbeat, dev);
+	watchdog_set_nowayout(&bcm2835_wdt_wdd, nowayout);
+	err = watchdog_register_device(&bcm2835_wdt_wdd);
+	if (err) {
+		dev_err(dev, "Failed to register watchdog device");
+		iounmap(wdt->base);
+	}
+	return err;
+}
+
+static int bcm2835_wdt_remove(struct platform_device *pdev)
+{
+	struct bcm2835_wdt *wdt = platform_get_drvdata(pdev);
+
+	platform_set_drvdata(pdev, NULL);
+	watchdog_unregister_device(&bcm2835_wdt_wdd);
+	iounmap(wdt->base);
+
+	return 0;
+}
+
+static void bcm2835_wdt_shutdown(struct platform_device *pdev)
+{
+	bcm2835_wdt_stop(&bcm2835_wdt_wdd);
+}
+
+static const struct of_device_id bcm2835_wdt_of_match[] = {
+	{ .compatible = "brcm,bcm2835-pm-wdt", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, bcm2835_wdt_of_match);
+
+static struct platform_driver bcm2835_wdt_driver = {
+	.probe		= bcm2835_wdt_probe,
+	.remove		= bcm2835_wdt_remove,
+	.shutdown	= bcm2835_wdt_shutdown,
+	.driver = {
+		.name =		"bcm2835-wdt",
+		.owner =	THIS_MODULE,
+		.of_match_table = bcm2835_wdt_of_match,
+	},
+};
+module_platform_driver(bcm2835_wdt_driver);
+
+module_param(heartbeat, int, 0);
+MODULE_PARM_DESC(heartbeat, "Initial watchdog heartbeat in seconds");
+
+module_param(nowayout, bool, 0);
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+
+MODULE_AUTHOR("Lubomir Rintel <lkundrak@v3.sk>");
+MODULE_DESCRIPTION("Driver for Broadcom BCM2835 watchdog timer");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
-- 
1.7.1

