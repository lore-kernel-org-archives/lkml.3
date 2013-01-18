Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976Ab3ARLla (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 06:41:30 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:57509 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711Ab3ARLl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 06:41:27 -0500
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: linux-watchdog@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Wim Van Sebroeck <wim@iguana.be>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 3/4] watchdog: add support for ux500_wdt watchdog
Date: Fri, 18 Jan 2013 12:40:13 +0100
Message-Id: <1358509214-22407-4-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1358509214-22407-1-git-send-email-fabio.baltieri@linaro.org>
References: <1358509214-22407-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the ux500_wdt watchdog that is found in
ST-Ericsson Ux500 platform.  The driver is based on PRCMU APIs.

Acked-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/watchdog/Kconfig                |  12 +++
 drivers/watchdog/Makefile               |   1 +
 drivers/watchdog/ux500_wdt.c            | 171 ++++++++++++++++++++++++++++++++
 include/linux/platform_data/ux500_wdt.h |  19 ++++
 4 files changed, 203 insertions(+)
 create mode 100644 drivers/watchdog/ux500_wdt.c
 create mode 100644 include/linux/platform_data/ux500_wdt.h

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 7f809fd..26e1fdb 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -364,6 +364,18 @@ config IMX2_WDT
 	  To compile this driver as a module, choose M here: the
 	  module will be called imx2_wdt.
 
+config UX500_WATCHDOG
+	tristate "ST-Ericsson Ux500 watchdog"
+	depends on MFD_DB8500_PRCMU
+	select WATCHDOG_CORE
+	default y
+	help
+	  Say Y here to include Watchdog timer support for the watchdog
+	  existing in the prcmu of ST-Ericsson Ux500 series platforms.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called ux500_wdt.
+
 # AVR32 Architecture
 
 config AT32AP700X_WDT
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index 97bbdb3a..bec86ee 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -52,6 +52,7 @@ obj-$(CONFIG_STMP3XXX_WATCHDOG) += stmp3xxx_wdt.o
 obj-$(CONFIG_NUC900_WATCHDOG) += nuc900_wdt.o
 obj-$(CONFIG_TS72XX_WATCHDOG) += ts72xx_wdt.o
 obj-$(CONFIG_IMX2_WDT) += imx2_wdt.o
+obj-$(CONFIG_UX500_WATCHDOG) += ux500_wdt.o
 
 # AVR32 Architecture
 obj-$(CONFIG_AT32AP700X_WDT) += at32ap700x_wdt.o
diff --git a/drivers/watchdog/ux500_wdt.c b/drivers/watchdog/ux500_wdt.c
new file mode 100644
index 0000000..dd608db
--- /dev/null
+++ b/drivers/watchdog/ux500_wdt.c
@@ -0,0 +1,171 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2011-2013
+ *
+ * License Terms: GNU General Public License v2
+ *
+ * Author: Mathieu Poirier <mathieu.poirier@linaro.org> for ST-Ericsson
+ * Author: Jonas Aaberg <jonas.aberg@stericsson.com> for ST-Ericsson
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/moduleparam.h>
+#include <linux/miscdevice.h>
+#include <linux/err.h>
+#include <linux/uaccess.h>
+#include <linux/watchdog.h>
+#include <linux/platform_device.h>
+#include <linux/platform_data/ux500_wdt.h>
+
+#include <linux/mfd/dbx500-prcmu.h>
+
+#define WATCHDOG_TIMEOUT 600 /* 10 minutes */
+
+#define WATCHDOG_MIN	0
+#define WATCHDOG_MAX28	268435  /* 28 bit resolution in ms == 268435.455 s */
+#define WATCHDOG_MAX32	4294967 /* 32 bit resolution in ms == 4294967.295 s */
+
+static int timeout = WATCHDOG_TIMEOUT;
+module_param(timeout, int, 0);
+MODULE_PARM_DESC(timeout,
+	"Watchdog timeout in seconds. default="
+				__MODULE_STRING(WATCHDOG_TIMEOUT) ".");
+
+static int nowayout = WATCHDOG_NOWAYOUT;
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout,
+	"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+
+static int ux500_wdt_start(struct watchdog_device *wdd)
+{
+	return prcmu_enable_a9wdog(PRCMU_WDOG_ALL);
+}
+
+static int ux500_wdt_stop(struct watchdog_device *wdd)
+{
+	return prcmu_disable_a9wdog(PRCMU_WDOG_ALL);
+}
+
+static int ux500_wdt_keepalive(struct watchdog_device *wdd)
+{
+	return prcmu_kick_a9wdog(PRCMU_WDOG_ALL);
+}
+
+static int ux500_wdt_set_timeout(struct watchdog_device *wdd,
+				 unsigned int timeout)
+{
+	ux500_wdt_stop(wdd);
+	prcmu_load_a9wdog(PRCMU_WDOG_ALL, timeout * 1000);
+	ux500_wdt_start(wdd);
+
+	return 0;
+}
+
+static const struct watchdog_info ux500_wdt_info = {
+	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE,
+	.identity = "Ux500 WDT",
+	.firmware_version = 1,
+};
+
+static const struct watchdog_ops ux500_wdt_ops = {
+	.owner = THIS_MODULE,
+	.start = ux500_wdt_start,
+	.stop  = ux500_wdt_stop,
+	.ping  = ux500_wdt_keepalive,
+	.set_timeout = ux500_wdt_set_timeout,
+};
+
+static struct watchdog_device ux500_wdt = {
+	.info = &ux500_wdt_info,
+	.ops = &ux500_wdt_ops,
+	.min_timeout = WATCHDOG_MIN,
+	.max_timeout = WATCHDOG_MAX32,
+};
+
+static int ux500_wdt_probe(struct platform_device *pdev)
+{
+	int ret;
+	struct ux500_wdt_data *pdata = pdev->dev.platform_data;
+
+	if (pdata) {
+		if (pdata->timeout > 0)
+			timeout = pdata->timeout;
+		if (pdata->has_28_bits_resolution)
+			ux500_wdt.max_timeout = WATCHDOG_MAX28;
+	}
+
+	watchdog_set_nowayout(&ux500_wdt, nowayout);
+
+	/* disable auto off on sleep */
+	prcmu_config_a9wdog(PRCMU_WDOG_CPU1, false);
+
+	/* set HW initial value */
+	prcmu_load_a9wdog(PRCMU_WDOG_ALL, timeout * 1000);
+
+	ret = watchdog_register_device(&ux500_wdt);
+	if (ret)
+		return ret;
+
+	dev_info(&pdev->dev, "initialized\n");
+
+	return 0;
+}
+
+static int ux500_wdt_remove(struct platform_device *dev)
+{
+	watchdog_unregister_device(&ux500_wdt);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int ux500_wdt_suspend(struct platform_device *pdev,
+			     pm_message_t state)
+{
+	if (watchdog_active(&ux500_wdt)) {
+		ux500_wdt_stop(&ux500_wdt);
+		prcmu_config_a9wdog(PRCMU_WDOG_CPU1, true);
+
+		prcmu_load_a9wdog(PRCMU_WDOG_ALL, timeout * 1000);
+		ux500_wdt_start(&ux500_wdt);
+	}
+	return 0;
+}
+
+static int ux500_wdt_resume(struct platform_device *pdev)
+{
+	if (watchdog_active(&ux500_wdt)) {
+		ux500_wdt_stop(&ux500_wdt);
+		prcmu_config_a9wdog(PRCMU_WDOG_CPU1, false);
+
+		prcmu_load_a9wdog(PRCMU_WDOG_ALL, timeout * 1000);
+		ux500_wdt_start(&ux500_wdt);
+	}
+	return 0;
+}
+#else
+#define ux500_wdt_suspend NULL
+#define ux500_wdt_resume NULL
+#endif
+
+static struct platform_driver ux500_wdt_driver = {
+	.probe		= ux500_wdt_probe,
+	.remove		= ux500_wdt_remove,
+	.suspend	= ux500_wdt_suspend,
+	.resume		= ux500_wdt_resume,
+	.driver		= {
+		.owner	= THIS_MODULE,
+		.name	= "ux500_wdt",
+	},
+};
+
+module_platform_driver(ux500_wdt_driver);
+
+MODULE_AUTHOR("Jonas Aaberg <jonas.aberg@stericsson.com>");
+MODULE_DESCRIPTION("Ux500 Watchdog Driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
+MODULE_ALIAS("platform:ux500_wdt");
diff --git a/include/linux/platform_data/ux500_wdt.h b/include/linux/platform_data/ux500_wdt.h
new file mode 100644
index 0000000..aa2dfe7
--- /dev/null
+++ b/include/linux/platform_data/ux500_wdt.h
@@ -0,0 +1,19 @@
+/*
+ * Copyright (C) ST Ericsson SA 2011
+ *
+ * License Terms: GNU General Public License v2
+ *
+ * STE Ux500 Watchdog platform data
+ */
+#ifndef __UX500_WDT_H
+#define __UX500_WDT_H
+
+/**
+ * struct ux500_wdt_data
+ */
+struct ux500_wdt_data {
+	int timeout;
+	bool has_28_bits_resolution;
+};
+
+#endif /* __UX500_WDT_H */
-- 
1.7.12.1

