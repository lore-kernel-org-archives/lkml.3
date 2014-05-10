Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932500AbaEJAby (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 20:31:54 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:47486 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932341AbaEJAbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 20:31:51 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-watchdog@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Wim Van Sebroeck <wim@iguana.be>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Heiko Stuebner <heiko@sntech.de>,
        Russell King <linux@arm.linux.org.uk>,
        Jonas Jensen <jonas.jensen@gmail.com>, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v2 5/5] watchdog: sunxi: Register reboot handler with watchdog subsystem
Date: Fri,  9 May 2014 17:31:23 -0700
Message-Id: <1399681883-891-6-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399681883-891-1-git-send-email-linux@roeck-us.net>
References: <1399681883-891-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The watchdog subsystem now provides an API to trigger a system reboot.
Register with it.

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v2: Rebased to v2 of Maxime's patch adding reboot support
    to the sunxi watchdog driver.

 drivers/watchdog/sunxi_wdt.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/watchdog/sunxi_wdt.c b/drivers/watchdog/sunxi_wdt.c
index 60deb9d..744b6f5 100644
--- a/drivers/watchdog/sunxi_wdt.c
+++ b/drivers/watchdog/sunxi_wdt.c
@@ -27,8 +27,6 @@
 #include <linux/types.h>
 #include <linux/watchdog.h>
 
-#include <asm/system_misc.h>
-
 #define WDT_MAX_TIMEOUT         16
 #define WDT_MIN_TIMEOUT         1
 #define WDT_MODE_TIMEOUT(n)     ((n) << 3)
@@ -74,23 +72,25 @@ static const int wdt_timeout_map[] = {
 	[16] = 0xB, /* 16s */
 };
 
-static void __iomem *reboot_wdt_base;
-
-static void sun4i_wdt_restart(enum reboot_mode mode, const char *cmd)
+static void sunxi_wdt_reboot(struct watchdog_device *wdt_dev,
+			     enum reboot_mode mode, const char *cmd)
 {
+	struct sunxi_wdt_dev *sunxi_wdt = watchdog_get_drvdata(wdt_dev);
+
 	/* Enable timer and set reset bit in the watchdog */
-	writel(WDT_MODE_EN | WDT_MODE_RST_EN, reboot_wdt_base + WDT_MODE);
+	writel(WDT_MODE_EN | WDT_MODE_RST_EN,
+	       sunxi_wdt->wdt_base + WDT_MODE);
 
 	/*
 	 * Restart the watchdog. The default (and lowest) interval
 	 * value for the watchdog is 0.5s.
 	 */
-	writel(WDT_CTRL_RELOAD, reboot_wdt_base + WDT_CTRL);
+	writel(WDT_CTRL_RELOAD, sunxi_wdt->wdt_base + WDT_CTRL);
 
 	while (1) {
 		mdelay(5);
 		writel(WDT_MODE_EN | WDT_MODE_RST_EN,
-		       reboot_wdt_base + WDT_MODE);
+		       sunxi_wdt->wdt_base + WDT_MODE);
 	}
 }
 
@@ -167,6 +167,7 @@ static const struct watchdog_ops sunxi_wdt_ops = {
 	.start		= sunxi_wdt_start,
 	.stop		= sunxi_wdt_stop,
 	.ping		= sunxi_wdt_ping,
+	.reboot		= sunxi_wdt_reboot,
 	.set_timeout	= sunxi_wdt_set_timeout,
 };
 
@@ -205,9 +206,6 @@ static int sunxi_wdt_probe(struct platform_device *pdev)
 	if (unlikely(err))
 		return err;
 
-	reboot_wdt_base = sunxi_wdt->wdt_base;
-	arm_pm_restart = sun4i_wdt_restart;
-
 	dev_info(&pdev->dev, "Watchdog enabled (timeout=%d sec, nowayout=%d)",
 			sunxi_wdt->wdt_dev.timeout, nowayout);
 
@@ -218,8 +216,6 @@ static int sunxi_wdt_remove(struct platform_device *pdev)
 {
 	struct sunxi_wdt_dev *sunxi_wdt = platform_get_drvdata(pdev);
 
-	arm_pm_restart = NULL;
-
 	watchdog_unregister_device(&sunxi_wdt->wdt_dev);
 	watchdog_set_drvdata(&sunxi_wdt->wdt_dev, NULL);
 
-- 
1.9.1

