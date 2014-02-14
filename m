Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbaBNUCA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 15:02:00 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:5685 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481AbaBNUB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 15:01:57 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 14 Feb 2014 11:59:56 -0800
From: Andrew Chew <achew@nvidia.com>
To: <linux@roeck-us.net>, <wim@iguana.be>, <rob@landley.net>,
        <swarren@wwwdotorg.org>, <thierry.reding@gmail.com>,
        <grant.likely@linaro.org>, <robh+dt@kernel.org>,
        <abrestic@chromium.org>, <dgreid@chromium.org>, <katierh@chromium.org>
CC: <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <linux-watchdog@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        Andrew Chew <achew@nvidia.com>
Subject: [PATCH v7 1/1] watchdog: Add tegra watchdog
Date: Fri, 14 Feb 2014 12:03:05 -0800
Message-ID: <1392408185-15387-1-git-send-email-achew@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a driver for the hardware watchdogs in NVIDIA Tegra SoCs (Tegra30 and
later).  This driver will configure one watchdog timer that will reset the
system in the case of a watchdog timeout.

This driver binds to the nvidia,tegra30-timer device node and gets its
register base from there.

Signed-off-by: Andrew Chew <achew@nvidia.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Stephen Warren <swarren@nvidia.com>
Reviewed-by: Stephen Warren <swarren@nvidia.com>
---
Changes from v6:

Removed kref stuff.  We can't think of why it's needed here.

Changes from v5:

Changed license to GPL v2 per Stephen Warren's guidance.

Changes from v4:

Skip the error check from the platform_get_resources() call, because
devm_ioremap_resource() correctly handles the case when res is NULL.

Changes from v3:

Applied Cuenter Roeck <linux@roeck-us.net>'s comments.  In particular,
since tegra_wdt_start() and tegra_wdt_stop() always return success, skip
error checking for these calls.  Also, removed some unnecessarily verbose
logging around which watchdog and timer ID is being used.  Fixed typo
regarding the ref and unref callback setup.  Removed miscdev stuff.

Cuenter was right in that the watchdog doesn't need to be stopped prior
to changing the timeout.  It is sufficient to just reprogram the watchdog
with the new timeout.

Tested on T124.

To do a simple test, "echo 0 > /dev/watchdog0".  The target will reset when
two minutes (the default heartbeat interval) have expired since the last
write to /dev/watchdog0.

 Documentation/watchdog/watchdog-parameters.txt |   5 +
 drivers/watchdog/Kconfig                       |  11 +
 drivers/watchdog/Makefile                      |   1 +
 drivers/watchdog/tegra_wdt.c                   | 302 +++++++++++++++++++++++++
 4 files changed, 319 insertions(+)
 create mode 100644 drivers/watchdog/tegra_wdt.c

diff --git a/Documentation/watchdog/watchdog-parameters.txt b/Documentation/watchdog/watchdog-parameters.txt
index f9492fe..b39f355 100644
--- a/Documentation/watchdog/watchdog-parameters.txt
+++ b/Documentation/watchdog/watchdog-parameters.txt
@@ -325,6 +325,11 @@ soft_noboot: Softdog action, set to 1 to ignore reboots, 0 to reboot
 stmp3xxx_wdt:
 heartbeat: Watchdog heartbeat period in seconds from 1 to 4194304, default 19
 -------------------------------------------------
+tegra_wdt:
+heartbeat: Watchdog heartbeats in seconds. (default = 120)
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
 ts72xx_wdt:
 timeout: Watchdog timeout in seconds. (1 <= timeout <= 8, default=8)
 nowayout: Disable watchdog shutdown on close
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 4c4c566..3aae2da 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -420,6 +420,17 @@ config SIRFSOC_WATCHDOG
 	  Support for CSR SiRFprimaII and SiRFatlasVI watchdog. When
 	  the watchdog triggers the system will be reset.
 
+config TEGRA_WATCHDOG
+	tristate "Tegra watchdog"
+	depends on ARCH_TEGRA || COMPILE_TEST
+	select WATCHDOG_CORE
+	help
+	  Say Y here to include support for the watchdog timer
+	  embedded in NVIDIA Tegra SoCs.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called tegra_wdt.
+
 # AVR32 Architecture
 
 config AT32AP700X_WDT
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index 985a66c..1b5f3d5 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -58,6 +58,7 @@ obj-$(CONFIG_BCM2835_WDT) += bcm2835_wdt.o
 obj-$(CONFIG_MOXART_WDT) += moxart_wdt.o
 obj-$(CONFIG_SIRFSOC_WATCHDOG) += sirfsoc_wdt.o
 obj-$(CONFIG_BCM_KONA_WDT) += bcm_kona_wdt.o
+obj-$(CONFIG_TEGRA_WATCHDOG) += tegra_wdt.o
 
 # AVR32 Architecture
 obj-$(CONFIG_AT32AP700X_WDT) += at32ap700x_wdt.o
diff --git a/drivers/watchdog/tegra_wdt.c b/drivers/watchdog/tegra_wdt.c
new file mode 100644
index 0000000..750e2a2
--- /dev/null
+++ b/drivers/watchdog/tegra_wdt.c
@@ -0,0 +1,302 @@
+/*
+ * Copyright (c) 2014, NVIDIA CORPORATION.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/watchdog.h>
+
+/* minimum and maximum watchdog trigger timeout, in seconds */
+#define MIN_WDT_TIMEOUT			1
+#define MAX_WDT_TIMEOUT			255
+
+/*
+ * Base of the WDT registers, from the timer base address.  There are
+ * actually 5 watchdogs that can be configured (by pairing with an available
+ * timer), at bases 0x100 + (WDT ID) * 0x20, where WDT ID is 0 through 4.
+ * This driver only configures the first watchdog (WDT ID 0).
+ */
+#define WDT_BASE			0x100
+#define WDT_ID				0
+
+/*
+ * Register base of the timer that's selected for pairing with the watchdog.
+ * This driver arbitrarily uses timer 5, which is currently unused by
+ * other drivers (in particular, the Tegra clocksource driver).  If this
+ * needs to change, take care that the new timer is not used by the
+ * clocksource driver.
+ */
+#define WDT_TIMER_BASE			0x60
+#define WDT_TIMER_ID			5
+
+/* WDT registers */
+#define WDT_CFG				0x0
+#define WDT_CFG_PERIOD_SHIFT		4
+#define WDT_CFG_PERIOD_MASK		0xff
+#define WDT_CFG_INT_EN			(1 << 12)
+#define WDT_CFG_PMC2CAR_RST_EN		(1 << 15)
+#define WDT_STS				0x4
+#define WDT_STS_COUNT_SHIFT		4
+#define WDT_STS_COUNT_MASK		0xff
+#define WDT_STS_EXP_SHIFT		12
+#define WDT_STS_EXP_MASK		0x3
+#define WDT_CMD				0x8
+#define WDT_CMD_START_COUNTER		(1 << 0)
+#define WDT_CMD_DISABLE_COUNTER		(1 << 1)
+#define WDT_UNLOCK			(0xc)
+#define WDT_UNLOCK_PATTERN		(0xc45a << 0)
+
+/* Timer registers */
+#define TIMER_PTV			0x0
+#define TIMER_EN			(1 << 31)
+#define TIMER_PERIODIC			(1 << 30)
+
+struct tegra_wdt {
+	struct watchdog_device	wdd;
+	void __iomem		*wdt_regs;
+	void __iomem		*tmr_regs;
+};
+
+#define WDT_HEARTBEAT 120
+static int heartbeat = WDT_HEARTBEAT;
+module_param(heartbeat, int, 0);
+MODULE_PARM_DESC(heartbeat,
+	"Watchdog heartbeats in seconds. (default = "
+	__MODULE_STRING(WDT_HEARTBEAT) ")");
+
+static bool nowayout = WATCHDOG_NOWAYOUT;
+module_param(nowayout, bool, 0);
+MODULE_PARM_DESC(nowayout,
+	"Watchdog cannot be stopped once started (default="
+	__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+
+static int tegra_wdt_start(struct watchdog_device *wdd)
+{
+	struct tegra_wdt *wdt = watchdog_get_drvdata(wdd);
+	u32 val;
+
+	/*
+	 * This thing has a fixed 1MHz clock.  Normally, we would set the
+	 * period to 1 second by writing 1000000ul, but the watchdog system
+	 * reset actually occurs on the 4th expiration of this counter,
+	 * so we set the period to 1/4 of this amount.
+	 */
+	val = 1000000ul / 4;
+	val |= (TIMER_EN | TIMER_PERIODIC);
+	writel(val, wdt->tmr_regs + TIMER_PTV);
+
+	/*
+	 * Set number of periods and start counter.
+	 *
+	 * Interrupt handler is not required for user space
+	 * WDT accesses, since the caller is responsible to ping the
+	 * WDT to reset the counter before expiration, through ioctls.
+	 */
+	val = WDT_TIMER_ID |
+	      (wdd->timeout << WDT_CFG_PERIOD_SHIFT) |
+	      WDT_CFG_PMC2CAR_RST_EN;
+	writel(val, wdt->wdt_regs + WDT_CFG);
+
+	writel(WDT_CMD_START_COUNTER, wdt->wdt_regs + WDT_CMD);
+
+	return 0;
+}
+
+static int tegra_wdt_stop(struct watchdog_device *wdd)
+{
+	struct tegra_wdt *wdt = watchdog_get_drvdata(wdd);
+
+	writel(WDT_UNLOCK_PATTERN, wdt->wdt_regs + WDT_UNLOCK);
+	writel(WDT_CMD_DISABLE_COUNTER, wdt->wdt_regs + WDT_CMD);
+	writel(0, wdt->tmr_regs + TIMER_PTV);
+
+	return 0;
+}
+
+static int tegra_wdt_ping(struct watchdog_device *wdd)
+{
+	struct tegra_wdt *wdt = watchdog_get_drvdata(wdd);
+
+	writel(WDT_CMD_START_COUNTER, wdt->wdt_regs + WDT_CMD);
+
+	return 0;
+}
+
+static int tegra_wdt_set_timeout(struct watchdog_device *wdd,
+				 unsigned int timeout)
+{
+	wdd->timeout = timeout;
+
+	if (watchdog_active(wdd))
+		return tegra_wdt_start(wdd);
+
+	return 0;
+}
+
+static unsigned int tegra_wdt_get_timeleft(struct watchdog_device *wdd)
+{
+	struct tegra_wdt *wdt = watchdog_get_drvdata(wdd);
+	u32 val;
+	int count;
+	int exp;
+
+	val = readl(wdt->wdt_regs + WDT_STS);
+
+	/* Current countdown (from timeout) */
+	count = (val >> WDT_STS_COUNT_SHIFT) & WDT_STS_COUNT_MASK;
+
+	/* Number of expirations (we are waiting for the 4th expiration) */
+	exp = (val >> WDT_STS_EXP_SHIFT) & WDT_STS_EXP_MASK;
+
+	/*
+	 * The entire thing is divided by 4 because we are ticking down 4 times
+	 * faster due to needing to wait for the 4th expiration.
+	 */
+	return (((3 - exp) * wdd->timeout) + count) / 4;
+}
+
+static const struct watchdog_info tegra_wdt_info = {
+	.options	= WDIOF_SETTIMEOUT |
+			  WDIOF_MAGICCLOSE |
+			  WDIOF_KEEPALIVEPING,
+	.firmware_version = 0,
+	.identity	= "Tegra Watchdog",
+};
+
+static struct watchdog_ops tegra_wdt_ops = {
+	.owner = THIS_MODULE,
+	.start = tegra_wdt_start,
+	.stop = tegra_wdt_stop,
+	.ping = tegra_wdt_ping,
+	.set_timeout = tegra_wdt_set_timeout,
+	.get_timeleft = tegra_wdt_get_timeleft,
+};
+
+static int tegra_wdt_probe(struct platform_device *pdev)
+{
+	struct watchdog_device *wdd;
+	struct tegra_wdt *wdt;
+	struct resource *res;
+	void __iomem *regs;
+	int ret;
+
+	/* This is the timer base. */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	regs = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(regs))
+		return PTR_ERR(regs);
+
+	/*
+	 * Allocate our watchdog driver data, which has the
+	 * struct watchdog_device nested within it.
+	 */
+	wdt = devm_kzalloc(&pdev->dev, sizeof(*wdt), GFP_KERNEL);
+	if (!wdt)
+		return -ENOMEM;
+
+	/* Initialize struct tegra_wdt. */
+	wdt->wdt_regs = regs + WDT_BASE;
+	wdt->tmr_regs = regs + WDT_TIMER_BASE;
+
+	/* Initialize struct watchdog_device. */
+	wdd = &wdt->wdd;
+	wdd->timeout = heartbeat;
+	wdd->info = &tegra_wdt_info;
+	wdd->ops = &tegra_wdt_ops;
+	wdd->min_timeout = MIN_WDT_TIMEOUT;
+	wdd->max_timeout = MAX_WDT_TIMEOUT;
+
+	watchdog_set_drvdata(wdd, wdt);
+
+	watchdog_set_nowayout(wdd, nowayout);
+
+	ret = watchdog_register_device(wdd);
+	if (ret) {
+		dev_err(&pdev->dev,
+			"failed to register watchdog device\n");
+		return ret;
+	}
+
+	platform_set_drvdata(pdev, wdt);
+
+	dev_info(&pdev->dev,
+		 "initialized (heartbeat = %d sec, nowayout = %d)\n",
+		 heartbeat, nowayout);
+
+	return 0;
+}
+
+static int tegra_wdt_remove(struct platform_device *pdev)
+{
+	struct tegra_wdt *wdt = platform_get_drvdata(pdev);
+
+	tegra_wdt_stop(&wdt->wdd);
+
+	watchdog_unregister_device(&wdt->wdd);
+
+	dev_info(&pdev->dev, "removed wdt\n");
+
+	return 0;
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int tegra_wdt_runtime_suspend(struct device *dev)
+{
+	struct tegra_wdt *wdt = dev_get_drvdata(dev);
+
+	if (watchdog_active(&wdt->wdd))
+		tegra_wdt_stop(&wdt->wdd);
+
+	return 0;
+}
+
+static int tegra_wdt_runtime_resume(struct device *dev)
+{
+	struct tegra_wdt *wdt = dev_get_drvdata(dev);
+
+	if (watchdog_active(&wdt->wdd))
+		tegra_wdt_start(&wdt->wdd);
+
+	return 0;
+}
+#endif
+
+static const struct of_device_id tegra_wdt_of_match[] = {
+	{ .compatible = "nvidia,tegra30-timer", },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, tegra_wdt_of_match);
+
+static const struct dev_pm_ops tegra_wdt_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(tegra_wdt_runtime_suspend,
+				tegra_wdt_runtime_resume)
+};
+
+static struct platform_driver tegra_wdt_driver = {
+	.probe		= tegra_wdt_probe,
+	.remove		= tegra_wdt_remove,
+	.driver		= {
+		.owner	= THIS_MODULE,
+		.name	= "tegra-wdt",
+		.pm	= &tegra_wdt_pm_ops,
+		.of_match_table = tegra_wdt_of_match,
+	},
+};
+module_platform_driver(tegra_wdt_driver);
+
+MODULE_AUTHOR("NVIDIA Corporation");
+MODULE_DESCRIPTION("Tegra Watchdog Driver");
+MODULE_LICENSE("GPL v2");
-- 
1.8.1.5

