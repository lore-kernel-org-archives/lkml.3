Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457AbbAMM3P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 07:29:15 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:64284 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115AbbAMM3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 07:29:11 -0500
From: Matthias Brugger <matthias.bgg@gmail.com>
To: wim@iguana.be, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, grant.likely@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, heiko@sntech.de,
        yingjoe.chen@gmail.com, ibanezchen@gmail.com, matthias.bgg@gmail.com,
        greta.zhang@mediatek.com, eddie.huang@mediatek.com, wens@csie.org,
        linux@roeck-us.net, joe@perches.com
Subject: [PATCH v5 1/2] watchdog: Add driver for Mediatek watchdog
Date: Tue, 13 Jan 2015 13:28:55 +0100
Message-Id: <1421152136-5007-2-git-send-email-matthias.bgg@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421152136-5007-1-git-send-email-matthias.bgg@gmail.com>
References: <1421152136-5007-1-git-send-email-matthias.bgg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a driver for the Mediatek SoC integrated
watchdog. This driver supports watchdog and software reset
for mt65xx and mt81xx SoCs.

Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Tested-by: Eddie Huang <eddie.huang@mediatek.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/watchdog/Kconfig   |  10 ++
 drivers/watchdog/Makefile  |   1 +
 drivers/watchdog/mtk_wdt.c | 252 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 263 insertions(+)
 create mode 100644 drivers/watchdog/mtk_wdt.c

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 08f41ad..9957a34 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -505,6 +505,16 @@ config MESON_WATCHDOG
 	  To compile this driver as a module, choose M here: the
 	  module will be called meson_wdt.
 
+config MEDIATEK_WATCHDOG
+	tristate "Mediatek SoCs watchdog support"
+	depends on ARCH_MEDIATEK
+	select WATCHDOG_CORE
+	help
+	  Say Y here to include support for the watchdog timer
+	  in Mediatek SoCs.
+	  To compile this driver as a module, choose M here: the
+	  module will be called mtk_wdt.
+
 # AVR32 Architecture
 
 config AT32AP700X_WDT
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index c569ec8..0d4821f 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -63,6 +63,7 @@ obj-$(CONFIG_QCOM_WDT) += qcom-wdt.o
 obj-$(CONFIG_BCM_KONA_WDT) += bcm_kona_wdt.o
 obj-$(CONFIG_TEGRA_WATCHDOG) += tegra_wdt.o
 obj-$(CONFIG_MESON_WATCHDOG) += meson_wdt.o
+obj-$(CONFIG_MEDIATEK_WATCHDOG) += mtk_wdt.o
 
 # AVR32 Architecture
 obj-$(CONFIG_AT32AP700X_WDT) += at32ap700x_wdt.o
diff --git a/drivers/watchdog/mtk_wdt.c b/drivers/watchdog/mtk_wdt.c
new file mode 100644
index 0000000..2d0a59e
--- /dev/null
+++ b/drivers/watchdog/mtk_wdt.c
@@ -0,0 +1,252 @@
+/*
+ * Mediatek Watchdog Driver
+ *
+ * Copyright (C) 2014 Matthias Brugger
+ *
+ * Matthias Brugger <matthias.bgg@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * Based on sunxi_wdt.c
+ */
+
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/types.h>
+#include <linux/watchdog.h>
+#include <linux/notifier.h>
+#include <linux/reboot.h>
+#include <linux/delay.h>
+
+#define WDT_MAX_TIMEOUT		31
+#define WDT_MIN_TIMEOUT		1
+#define WDT_LENGTH_TIMEOUT(n)	((n) << 5)
+
+#define WDT_LENGTH		0x04
+#define WDT_LENGTH_KEY		0x8
+
+#define WDT_RST			0x08
+#define WDT_RST_RELOAD		0x1971
+
+#define WDT_MODE		0x00
+#define WDT_MODE_EN		(1 << 0)
+#define WDT_MODE_EXT_POL_LOW	(0 << 1)
+#define WDT_MODE_EXT_POL_HIGH	(1 << 1)
+#define WDT_MODE_EXRST_EN	(1 << 2)
+#define WDT_MODE_IRQ_EN		(1 << 3)
+#define WDT_MODE_AUTO_START	(1 << 4)
+#define WDT_MODE_DUAL_EN	(1 << 6)
+#define WDT_MODE_KEY		0x22000000
+
+#define WDT_SWRST		0x14
+#define WDT_SWRST_KEY		0x1209
+
+#define DRV_NAME		"mtk-wdt"
+#define DRV_VERSION		"1.0"
+
+static bool nowayout = WATCHDOG_NOWAYOUT;
+static unsigned int timeout = WDT_MAX_TIMEOUT;
+
+struct mtk_wdt_dev {
+	struct watchdog_device wdt_dev;
+	void __iomem *wdt_base;
+	struct notifier_block restart_handler;
+};
+
+static int mtk_reset_handler(struct notifier_block *this, unsigned long mode,
+				void *cmd)
+{
+	struct mtk_wdt_dev *mtk_wdt;
+	void __iomem *wdt_base;
+
+	mtk_wdt = container_of(this, struct mtk_wdt_dev, restart_handler);
+	wdt_base = mtk_wdt->wdt_base;
+
+	while (1) {
+		writel(WDT_SWRST_KEY, wdt_base + WDT_SWRST);
+		mdelay(5);
+	}
+
+	return NOTIFY_DONE;
+}
+
+static int mtk_wdt_ping(struct watchdog_device *wdt_dev)
+{
+	struct mtk_wdt_dev *mtk_wdt = watchdog_get_drvdata(wdt_dev);
+	void __iomem *wdt_base = mtk_wdt->wdt_base;
+
+	iowrite32(WDT_RST_RELOAD, wdt_base + WDT_RST);
+
+	return 0;
+}
+
+static int mtk_wdt_set_timeout(struct watchdog_device *wdt_dev,
+				unsigned int timeout)
+{
+	struct mtk_wdt_dev *mtk_wdt = watchdog_get_drvdata(wdt_dev);
+	void __iomem *wdt_base = mtk_wdt->wdt_base;
+	u32 reg;
+
+	wdt_dev->timeout = timeout;
+
+	/*
+	 * One bit is the value of 512 ticks
+	 * The clock has 32 KHz
+	 */
+	reg = WDT_LENGTH_TIMEOUT(timeout << 6) | WDT_LENGTH_KEY;
+	iowrite32(reg, wdt_base + WDT_LENGTH);
+
+	mtk_wdt_ping(wdt_dev);
+
+	return 0;
+}
+
+static int mtk_wdt_stop(struct watchdog_device *wdt_dev)
+{
+	struct mtk_wdt_dev *mtk_wdt = watchdog_get_drvdata(wdt_dev);
+	void __iomem *wdt_base = mtk_wdt->wdt_base;
+	u32 reg;
+
+	reg = readl(wdt_base + WDT_MODE);
+	reg &= ~WDT_MODE_EN;
+	iowrite32(reg, wdt_base + WDT_MODE);
+
+	return 0;
+}
+
+static int mtk_wdt_start(struct watchdog_device *wdt_dev)
+{
+	u32 reg;
+	struct mtk_wdt_dev *mtk_wdt = watchdog_get_drvdata(wdt_dev);
+	void __iomem *wdt_base = mtk_wdt->wdt_base;
+	u32 ret;
+
+	ret = mtk_wdt_set_timeout(wdt_dev, wdt_dev->timeout);
+	if (ret < 0)
+		return ret;
+
+	reg = ioread32(wdt_base + WDT_MODE);
+	reg &= ~(WDT_MODE_IRQ_EN | WDT_MODE_DUAL_EN);
+	reg |= (WDT_MODE_EN | WDT_MODE_KEY);
+	iowrite32(reg, wdt_base + WDT_MODE);
+
+	return 0;
+}
+
+static const struct watchdog_info mtk_wdt_info = {
+	.identity	= DRV_NAME,
+	.options	= WDIOF_SETTIMEOUT |
+			  WDIOF_KEEPALIVEPING |
+			  WDIOF_MAGICCLOSE,
+};
+
+static const struct watchdog_ops mtk_wdt_ops = {
+	.owner		= THIS_MODULE,
+	.start		= mtk_wdt_start,
+	.stop		= mtk_wdt_stop,
+	.ping		= mtk_wdt_ping,
+	.set_timeout	= mtk_wdt_set_timeout,
+};
+
+static int mtk_wdt_probe(struct platform_device *pdev)
+{
+	struct mtk_wdt_dev *mtk_wdt;
+	struct resource *res;
+	int err;
+
+	mtk_wdt = devm_kzalloc(&pdev->dev, sizeof(*mtk_wdt), GFP_KERNEL);
+	if (!mtk_wdt)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, mtk_wdt);
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	mtk_wdt->wdt_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(mtk_wdt->wdt_base))
+		return PTR_ERR(mtk_wdt->wdt_base);
+
+	mtk_wdt->wdt_dev.info = &mtk_wdt_info;
+	mtk_wdt->wdt_dev.ops = &mtk_wdt_ops;
+	mtk_wdt->wdt_dev.timeout = WDT_MAX_TIMEOUT;
+	mtk_wdt->wdt_dev.max_timeout = WDT_MAX_TIMEOUT;
+	mtk_wdt->wdt_dev.min_timeout = WDT_MIN_TIMEOUT;
+	mtk_wdt->wdt_dev.parent = &pdev->dev;
+
+	watchdog_init_timeout(&mtk_wdt->wdt_dev, timeout, &pdev->dev);
+	watchdog_set_nowayout(&mtk_wdt->wdt_dev, nowayout);
+
+	watchdog_set_drvdata(&mtk_wdt->wdt_dev, mtk_wdt);
+
+	mtk_wdt_stop(&mtk_wdt->wdt_dev);
+
+	err = watchdog_register_device(&mtk_wdt->wdt_dev);
+	if (unlikely(err))
+		return err;
+
+	mtk_wdt->restart_handler.notifier_call = mtk_reset_handler;
+	mtk_wdt->restart_handler.priority = 128;
+	err = register_restart_handler(&mtk_wdt->restart_handler);
+	if (err)
+		dev_warn(&pdev->dev,
+			"cannot register restart handler (err=%d)\n", err);
+
+	dev_info(&pdev->dev, "Watchdog enabled (timeout=%d sec, nowayout=%d)\n",
+			mtk_wdt->wdt_dev.timeout, nowayout);
+
+	return 0;
+}
+
+static int mtk_wdt_remove(struct platform_device *pdev)
+{
+	struct mtk_wdt_dev *mtk_wdt = platform_get_drvdata(pdev);
+
+	unregister_restart_handler(&mtk_wdt->restart_handler);
+
+	watchdog_unregister_device(&mtk_wdt->wdt_dev);
+
+	return 0;
+}
+
+static const struct of_device_id mtk_wdt_dt_ids[] = {
+	{ .compatible = "mediatek,mt6589-wdt" },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, mtk_wdt_dt_ids);
+
+static struct platform_driver mtk_wdt_driver = {
+	.probe		= mtk_wdt_probe,
+	.remove		= mtk_wdt_remove,
+	.driver		= {
+		.owner		= THIS_MODULE,
+		.name		= DRV_NAME,
+		.of_match_table	= mtk_wdt_dt_ids,
+	},
+};
+
+module_platform_driver(mtk_wdt_driver);
+
+module_param(timeout, uint, 0);
+MODULE_PARM_DESC(timeout, "Watchdog heartbeat in seconds");
+
+module_param(nowayout, bool, 0);
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
+			__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Matthias Brugger <matthias.bgg@gmail.com>");
+MODULE_DESCRIPTION("Mediatek WatchDog Timer Driver");
+MODULE_VERSION(DRV_VERSION);
-- 
1.9.1

