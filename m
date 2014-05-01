Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727AbaEAPmY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 11:42:24 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:36627 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755566AbaEAPmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 11:42:06 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-watchdog@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Wim Van Sebroeck <wim@iguana.be>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>,
        Jonas Jensen <jonas.jensen@gmail.com>, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [RFC PATCH 5/5] watchdog: sunxi: Register reboot handler with watchdog subsystem
Date: Thu,  1 May 2014 08:41:33 -0700
Message-Id: <1398958893-30049-6-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1398958893-30049-1-git-send-email-linux@roeck-us.net>
References: <1398958893-30049-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The watchdog subsystem now provides an API to trigger a system reboot.
Register with it.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/watchdog/sunxi_wdt.c |   22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/watchdog/sunxi_wdt.c b/drivers/watchdog/sunxi_wdt.c
index c9ca343..744b6f5 100644
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
@@ -74,27 +72,25 @@ static const int wdt_timeout_map[] = {
 	[16] = 0xB, /* 16s */
 };
 
-static struct sunxi_wdt_dev *sunxi_restart_ctx;
-
-static void sun4i_wdt_restart(enum reboot_mode mode, const char *cmd)
+static void sunxi_wdt_reboot(struct watchdog_device *wdt_dev,
+			     enum reboot_mode mode, const char *cmd)
 {
-	if (!sunxi_restart_ctx)
-		return;
+	struct sunxi_wdt_dev *sunxi_wdt = watchdog_get_drvdata(wdt_dev);
 
 	/* Enable timer and set reset bit in the watchdog */
 	writel(WDT_MODE_EN | WDT_MODE_RST_EN,
-	       sunxi_restart_ctx->wdt_base + WDT_MODE);
+	       sunxi_wdt->wdt_base + WDT_MODE);
 
 	/*
 	 * Restart the watchdog. The default (and lowest) interval
 	 * value for the watchdog is 0.5s.
 	 */
-	writel(WDT_CTRL_RELOAD, sunxi_restart_ctx->wdt_base + WDT_CTRL);
+	writel(WDT_CTRL_RELOAD, sunxi_wdt->wdt_base + WDT_CTRL);
 
 	while (1) {
 		mdelay(5);
 		writel(WDT_MODE_EN | WDT_MODE_RST_EN,
-		       sunxi_restart_ctx->wdt_base + WDT_MODE);
+		       sunxi_wdt->wdt_base + WDT_MODE);
 	}
 }
 
@@ -171,6 +167,7 @@ static const struct watchdog_ops sunxi_wdt_ops = {
 	.start		= sunxi_wdt_start,
 	.stop		= sunxi_wdt_stop,
 	.ping		= sunxi_wdt_ping,
+	.reboot		= sunxi_wdt_reboot,
 	.set_timeout	= sunxi_wdt_set_timeout,
 };
 
@@ -209,9 +206,6 @@ static int sunxi_wdt_probe(struct platform_device *pdev)
 	if (unlikely(err))
 		return err;
 
-	sunxi_restart_ctx = sunxi_wdt;
-	arm_pm_restart = sun4i_wdt_restart;
-
 	dev_info(&pdev->dev, "Watchdog enabled (timeout=%d sec, nowayout=%d)",
 			sunxi_wdt->wdt_dev.timeout, nowayout);
 
@@ -222,8 +216,6 @@ static int sunxi_wdt_remove(struct platform_device *pdev)
 {
 	struct sunxi_wdt_dev *sunxi_wdt = platform_get_drvdata(pdev);
 
-	arm_pm_restart = NULL;
-
 	watchdog_unregister_device(&sunxi_wdt->wdt_dev);
 	watchdog_set_drvdata(&sunxi_wdt->wdt_dev, NULL);
 
-- 
1.7.9.7

