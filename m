Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412AbaIPOUs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 10:20:48 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:52074 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023AbaIPOUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 10:20:47 -0400
From: Rostislav Lisovy <lisovy@gmail.com>
X-Google-Original-From: Rostislav Lisovy <lisovy@merica.cz>
To: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Cc: sojkam1@fel.cvut.cz, michal.vokac@comap.cz, lisovy@gmail.com,
        Rostislav Lisovy <lisovy@merica.cz>
Subject: [PATCH v2] watchdog: omap_wdt: Add 'early_disable' module parameter
Date: Tue, 16 Sep 2014 16:20:28 +0200
Message-Id: <1410877228-20925-1-git-send-email-lisovy@merica.cz>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This parameter makes it possible to control if the watchdog
is being disabled during initialization or will stay enabled
in case it was previously initialized in the bootloader.

To maintain the existing behavior, the default value is 'true',
thus the watchdog is disabled during initialization.

This new feature is highly inspired by the w83627hf_wdt.c

Signed-off-by: Rostislav Lisovy <lisovy@merica.cz>
---
Changes since v1:
 * Fix Runtime PM device usage counter leaking (Guenter Roeck)
 * Remove the unnecessary message informing about "stopping the watchdog"
   (Guenter Roeck)
 * Fix proper setting of "omap_wdt_users"

 drivers/watchdog/omap_wdt.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
index 3691b15..abf3b62 100644
--- a/drivers/watchdog/omap_wdt.c
+++ b/drivers/watchdog/omap_wdt.c
@@ -53,6 +53,10 @@ static unsigned timer_margin;
 module_param(timer_margin, uint, 0);
 MODULE_PARM_DESC(timer_margin, "initial watchdog timeout (in seconds)");
 
+static bool early_disable = true;
+module_param(early_disable, bool, 0);
+MODULE_PARM_DESC(early_disable, "Disable watchdog at boot time (default=1)");
+
 struct omap_wdt_dev {
 	void __iomem    *base;          /* physical */
 	struct device   *dev;
@@ -128,9 +132,11 @@ static int omap_wdt_start(struct watchdog_device *wdog)
 
 	mutex_lock(&wdev->lock);
 
-	wdev->omap_wdt_users = true;
-
-	pm_runtime_get_sync(wdev->dev);
+	/* The watchdog was disabled in probe function */
+	if (early_disable) {
+		wdev->omap_wdt_users = true;
+		pm_runtime_get_sync(wdev->dev);
+	}
 
 	/* initialize prescaler */
 	while (readl_relaxed(base + OMAP_WATCHDOG_WPS) & 0x01)
@@ -218,7 +224,7 @@ static int omap_wdt_probe(struct platform_device *pdev)
 	if (!wdev)
 		return -ENOMEM;
 
-	wdev->omap_wdt_users	= false;
+	wdev->omap_wdt_users	= (early_disable) ? false : true;
 	wdev->dev		= &pdev->dev;
 	wdev->wdt_trgr_pattern	= 0x1234;
 	mutex_init(&wdev->lock);
@@ -255,7 +261,14 @@ static int omap_wdt_probe(struct platform_device *pdev)
 	omap_wdt->bootstatus = (rs & (1 << OMAP_MPU_WD_RST_SRC_ID_SHIFT)) ?
 				WDIOF_CARDRESET : 0;
 
-	omap_wdt_disable(wdev);
+	if (early_disable) {
+		omap_wdt_disable(wdev);
+	} else {
+		pr_info("Watchdog already running. Resetting timeout to %d sec\n",
+			omap_wdt->timeout);
+		omap_wdt_set_timeout(omap_wdt, omap_wdt->timeout);
+		omap_wdt_ping(omap_wdt);
+	}
 
 	ret = watchdog_register_device(omap_wdt);
 	if (ret) {
@@ -267,7 +280,8 @@ static int omap_wdt_probe(struct platform_device *pdev)
 		readl_relaxed(wdev->base + OMAP_WATCHDOG_REV) & 0xFF,
 		omap_wdt->timeout);
 
-	pm_runtime_put_sync(wdev->dev);
+	if (early_disable)
+		pm_runtime_put_sync(wdev->dev);
 
 	return 0;
 }
-- 
1.9.1

