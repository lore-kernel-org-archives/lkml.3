Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079AbaEOUkA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 16:40:00 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:34105 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209AbaEOUi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 16:38:58 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-watchdog@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Wim Van Sebroeck <wim@iguana.be>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Heiko Stuebner <heiko@sntech.de>,
        Russell King <linux@arm.linux.org.uk>,
        Jonas Jensen <jonas.jensen@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v3 6/6] watchdog: sunxi: Register reboot handler with watchdog subsystem
Date: Thu, 15 May 2014 13:38:24 -0700
Message-Id: <1400186304-1691-7-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400186304-1691-1-git-send-email-linux@roeck-us.net>
References: <1400186304-1691-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The watchdog subsystem now provides an API to trigger a system reboot.
Register with it.

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v3: Drop reboot mode and cmd string parameters from API
v2: Rebased to v2 of Maxime's patch adding reboot support
    to the sunxi watchdog driver.

 drivers/watchdog/sunxi_wdt.c | 22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/watchdog/sunxi_wdt.c b/drivers/watchdog/sunxi_wdt.c
index 60deb9d..d8d4f8c 100644
--- a/drivers/watchdog/sunxi_wdt.c
+++ b/drivers/watchdog/sunxi_wdt.c
@@ -23,12 +23,9 @@
 #include <linux/moduleparam.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
-#include <linux/reboot.h>
 #include <linux/types.h>
 #include <linux/watchdog.h>
 
-#include <asm/system_misc.h>
-
 #define WDT_MAX_TIMEOUT         16
 #define WDT_MIN_TIMEOUT         1
 #define WDT_MODE_TIMEOUT(n)     ((n) << 3)
@@ -74,23 +71,24 @@ static const int wdt_timeout_map[] = {
 	[16] = 0xB, /* 16s */
 };
 
-static void __iomem *reboot_wdt_base;
-
-static void sun4i_wdt_restart(enum reboot_mode mode, const char *cmd)
+static void sunxi_wdt_reboot(struct watchdog_device *wdt_dev)
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
 
@@ -167,6 +165,7 @@ static const struct watchdog_ops sunxi_wdt_ops = {
 	.start		= sunxi_wdt_start,
 	.stop		= sunxi_wdt_stop,
 	.ping		= sunxi_wdt_ping,
+	.reboot		= sunxi_wdt_reboot,
 	.set_timeout	= sunxi_wdt_set_timeout,
 };
 
@@ -205,9 +204,6 @@ static int sunxi_wdt_probe(struct platform_device *pdev)
 	if (unlikely(err))
 		return err;
 
-	reboot_wdt_base = sunxi_wdt->wdt_base;
-	arm_pm_restart = sun4i_wdt_restart;
-
 	dev_info(&pdev->dev, "Watchdog enabled (timeout=%d sec, nowayout=%d)",
 			sunxi_wdt->wdt_dev.timeout, nowayout);
 
@@ -218,8 +214,6 @@ static int sunxi_wdt_remove(struct platform_device *pdev)
 {
 	struct sunxi_wdt_dev *sunxi_wdt = platform_get_drvdata(pdev);
 
-	arm_pm_restart = NULL;
-
 	watchdog_unregister_device(&sunxi_wdt->wdt_dev);
 	watchdog_set_drvdata(&sunxi_wdt->wdt_dev, NULL);
 
-- 
1.9.1

