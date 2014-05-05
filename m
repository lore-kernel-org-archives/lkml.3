Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327AbaEEDaJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 23:30:09 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35232 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752122AbaEEDaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 23:30:07 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>, wim@iguana.be, dbaryshkov@gmail.com,
        dwmw2@infradead.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 1/6] wdt: sunxi: Move restart code to the watchdog driver
Date: Sun,  4 May 2014 22:07:59 -0500
Message-Id: <1399259284-6282-2-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399259284-6282-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1399259284-6282-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the watchdog code is duplicated between the machine restart code and
the watchdog driver. Add the restart hook to the watchdog driver, to be able to
remove it from the machine code eventually.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/watchdog/sunxi_wdt.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/watchdog/sunxi_wdt.c b/drivers/watchdog/sunxi_wdt.c
index cd00a7836cdc..0d07855bc88a 100644
--- a/drivers/watchdog/sunxi_wdt.c
+++ b/drivers/watchdog/sunxi_wdt.c
@@ -14,6 +14,7 @@
  */
 
 #include <linux/clk.h>
+#include <linux/delay.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/io.h>
@@ -22,9 +23,12 @@
 #include <linux/moduleparam.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
+#include <linux/reboot.h>
 #include <linux/types.h>
 #include <linux/watchdog.h>
 
+#include <asm/system_misc.h>
+
 #define WDT_MAX_TIMEOUT         16
 #define WDT_MIN_TIMEOUT         1
 #define WDT_MODE_TIMEOUT(n)     ((n) << 3)
@@ -70,6 +74,26 @@ static const int wdt_timeout_map[] = {
 	[16] = 0b1011, /* 16s */
 };
 
+static void __iomem *reboot_wdt_base;
+
+static void sun4i_wdt_restart(enum reboot_mode mode, const char *cmd)
+{
+	/* Enable timer and set reset bit in the watchdog */
+	writel(WDT_MODE_EN | WDT_MODE_RST_EN, reboot_wdt_base + WDT_MODE);
+
+	/*
+	 * Restart the watchdog. The default (and lowest) interval
+	 * value for the watchdog is 0.5s.
+	 */
+	writel(WDT_CTRL_RELOAD, reboot_wdt_base + WDT_CTRL);
+
+	while (1) {
+		mdelay(5);
+		writel(WDT_MODE_EN | WDT_MODE_RST_EN,
+		       reboot_wdt_base + WDT_MODE);
+	}
+}
+
 static int sunxi_wdt_ping(struct watchdog_device *wdt_dev)
 {
 	struct sunxi_wdt_dev *sunxi_wdt = watchdog_get_drvdata(wdt_dev);
@@ -181,6 +205,9 @@ static int sunxi_wdt_probe(struct platform_device *pdev)
 	if (unlikely(err))
 		return err;
 
+	reboot_wdt_base = sunxi_wdt->wdt_base;
+	arm_pm_restart = sun4i_wdt_restart;
+
 	dev_info(&pdev->dev, "Watchdog enabled (timeout=%d sec, nowayout=%d)",
 			sunxi_wdt->wdt_dev.timeout, nowayout);
 
@@ -191,6 +218,8 @@ static int sunxi_wdt_remove(struct platform_device *pdev)
 {
 	struct sunxi_wdt_dev *sunxi_wdt = platform_get_drvdata(pdev);
 
+	arm_pm_restart = NULL;
+
 	watchdog_unregister_device(&sunxi_wdt->wdt_dev);
 	watchdog_set_drvdata(&sunxi_wdt->wdt_dev, NULL);
 
-- 
1.9.1

