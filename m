Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227AbbAXRiK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 12:38:10 -0500
Received: from spo001.leaseweb.nl ([83.149.101.17]:50647 "EHLO
	spo001.leaseweb.nl" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753368AbbAXRiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 12:38:07 -0500
Date: Sat, 24 Jan 2015 18:38:04 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: linus@spo001.leaseweb.nl, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>, Markus Pargmann <mpa@pengutronix.de>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [GIT PULL REQUEST] watchdog - v3.19-rc5 Fixes
Message-ID: <20150124173803.GA24710@spo001.leaseweb.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://www.linux-watchdog.org/linux-watchdog.git

It will fix reboot issues with the imx2_wdt driver and it also 
drops some forgotten owner assignments from platform_drivers.

This will update the following files:

 cadence_wdt.c |    1 -
 imx2_wdt.c    |   40 +++++++++++++++++++++++++++++++---------
 meson_wdt.c   |    1 -
 3 files changed, 31 insertions(+), 11 deletions(-)

with these Changes:

commit 7a32757eda68a53626f003018733d09f94138334
Author: Wolfram Sang <wsa@the-dreams.de>
Date:   Sun Dec 21 22:14:43 2014 +0100

    watchdog: drop owner assignment from platform_drivers
    
    This platform_driver does not need to set an owner, it will be populated by the
    driver core.
    
    Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 5fe65ce7ccbb47b16e17a88bcdac73cffadb80fa
Author: Markus Pargmann <mpa@pengutronix.de>
Date:   Mon Sep 8 09:14:07 2014 +0200

    watchdog: imx2_wdt: Disable power down counter on boot
    
    Disable power down counter of the watchdog to avoid system resets. The
    watchdog power down counter is set automatically by the chip. If it is
    not set to 0 in the driver, the system resets.
    
    Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
    Acked-by: Shawn Guo <shawn.guo@linaro.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit bbd5900935be8755b6344386373174b20cd474a2
Author: Xiubo Li <Li.Xiubo@freescale.com>
Date:   Thu Oct 16 11:44:15 2014 +0800

    watchdog: imx2_wdt: Improve power management support.
    
    Improve power management operations(suspend and resume) as part of
    dev_pm_ops for IMX2 watchdog driver.
    
    If PM will be supported, please make sure that the wdev->clk
    could disable the watchdog's counter input clock source or can
    mask watchdog's reset request to the core.
    
    If watchdog is still used by consumers and resumes from deep
    sleep state, we need to restart the watchdog again without
    enabling the timer.
    
    If watchdog been has started --> stopped by the consumers and
    resumes from non-deep sleep state, then start the timer again.
    
    If watchdog has been started --> stopped by the consumers and
    resumes from deep sleep state, will do nothing. The watchdog
    will be restarted by consumers next time to be used.
    
    Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/cadence_wdt.c b/drivers/watchdog/cadence_wdt.c
index 5927c0a..bcfd2a2 100644
--- a/drivers/watchdog/cadence_wdt.c
+++ b/drivers/watchdog/cadence_wdt.c
@@ -503,7 +503,6 @@ static struct platform_driver cdns_wdt_driver = {
 	.shutdown	= cdns_wdt_shutdown,
 	.driver		= {
 		.name	= "cdns-wdt",
-		.owner	= THIS_MODULE,
 		.of_match_table = cdns_wdt_of_match,
 		.pm	= &cdns_wdt_pm_ops,
 	},
diff --git a/drivers/watchdog/imx2_wdt.c b/drivers/watchdog/imx2_wdt.c
index d6add51..5142bba 100644
--- a/drivers/watchdog/imx2_wdt.c
+++ b/drivers/watchdog/imx2_wdt.c
@@ -52,6 +52,8 @@
 #define IMX2_WDT_WRSR		0x04		/* Reset Status Register */
 #define IMX2_WDT_WRSR_TOUT	(1 << 1)	/* -> Reset due to Timeout */
 
+#define IMX2_WDT_WMCR		0x08		/* Misc Register */
+
 #define IMX2_WDT_MAX_TIME	128
 #define IMX2_WDT_DEFAULT_TIME	60		/* in seconds */
 
@@ -274,6 +276,13 @@ static int __init imx2_wdt_probe(struct platform_device *pdev)
 
 	imx2_wdt_ping_if_active(wdog);
 
+	/*
+	 * Disable the watchdog power down counter at boot. Otherwise the power
+	 * down counter will pull down the #WDOG interrupt line for one clock
+	 * cycle.
+	 */
+	regmap_write(wdev->regmap, IMX2_WDT_WMCR, 0);
+
 	ret = watchdog_register_device(wdog);
 	if (ret) {
 		dev_err(&pdev->dev, "cannot register watchdog device\n");
@@ -327,18 +336,21 @@ static void imx2_wdt_shutdown(struct platform_device *pdev)
 }
 
 #ifdef CONFIG_PM_SLEEP
-/* Disable watchdog if it is active during suspend */
+/* Disable watchdog if it is active or non-active but still running */
 static int imx2_wdt_suspend(struct device *dev)
 {
 	struct watchdog_device *wdog = dev_get_drvdata(dev);
 	struct imx2_wdt_device *wdev = watchdog_get_drvdata(wdog);
 
-	imx2_wdt_set_timeout(wdog, IMX2_WDT_MAX_TIME);
-	imx2_wdt_ping(wdog);
+	/* The watchdog IP block is running */
+	if (imx2_wdt_is_running(wdev)) {
+		imx2_wdt_set_timeout(wdog, IMX2_WDT_MAX_TIME);
+		imx2_wdt_ping(wdog);
 
-	/* Watchdog has been stopped but IP block is still running */
-	if (!watchdog_active(wdog) && imx2_wdt_is_running(wdev))
-		del_timer_sync(&wdev->timer);
+		/* The watchdog is not active */
+		if (!watchdog_active(wdog))
+			del_timer_sync(&wdev->timer);
+	}
 
 	clk_disable_unprepare(wdev->clk);
 
@@ -354,15 +366,25 @@ static int imx2_wdt_resume(struct device *dev)
 	clk_prepare_enable(wdev->clk);
 
 	if (watchdog_active(wdog) && !imx2_wdt_is_running(wdev)) {
-		/* Resumes from deep sleep we need restart
-		 * the watchdog again.
+		/*
+		 * If the watchdog is still active and resumes
+		 * from deep sleep state, need to restart the
+		 * watchdog again.
 		 */
 		imx2_wdt_setup(wdog);
 		imx2_wdt_set_timeout(wdog, wdog->timeout);
 		imx2_wdt_ping(wdog);
 	} else if (imx2_wdt_is_running(wdev)) {
+		/* Resuming from non-deep sleep state. */
+		imx2_wdt_set_timeout(wdog, wdog->timeout);
 		imx2_wdt_ping(wdog);
-		mod_timer(&wdev->timer, jiffies + wdog->timeout * HZ / 2);
+		/*
+		 * But the watchdog is not active, then start
+		 * the timer again.
+		 */
+		if (!watchdog_active(wdog))
+			mod_timer(&wdev->timer,
+				  jiffies + wdog->timeout * HZ / 2);
 	}
 
 	return 0;
diff --git a/drivers/watchdog/meson_wdt.c b/drivers/watchdog/meson_wdt.c
index ef6a298..1f4155e 100644
--- a/drivers/watchdog/meson_wdt.c
+++ b/drivers/watchdog/meson_wdt.c
@@ -215,7 +215,6 @@ static struct platform_driver meson_wdt_driver = {
 	.remove		= meson_wdt_remove,
 	.shutdown	= meson_wdt_shutdown,
 	.driver		= {
-		.owner		= THIS_MODULE,
 		.name		= DRV_NAME,
 		.of_match_table	= meson_wdt_dt_ids,
 	},
