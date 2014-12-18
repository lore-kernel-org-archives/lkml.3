Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751165AbaLRPHG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 10:07:06 -0500
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:19598 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751062AbaLRPHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 10:07:04 -0500
Message-Id: <681c51$op4mt8@relay.skynet.be>
Date: 18 Dec 2014 16:05:28 +0100
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqUQAPzrklRR9Aqz/2dsb2JhbABagwZSWIIiFLRPAY8ahXIodRcBAQEBAX2EOi8jGBdrJBOIMAEI1GyPUE6CfIE0BZgHgmGHR4YNIoFFgmUxAYECI4EdAQID
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [GIT PULL REQUEST] watchdog - v3.19 merge window
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
        git://www.linux-watchdog.org/linux-watchdog.git

It will:
* fix the argument of watchdog_active() in imx2_wdt
* Add power management support to the imx2_wdt watchdog.

This will update the following files:

 imx2_wdt.c |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 47 insertions(+)

with these Changes:

commit ba90f261cdcbf5535bb46381b1849815268daa3f
Author: Fabio Estevam <fabio.estevam@freescale.com>
Date:   Mon Dec 15 22:49:59 2014 -0200

    watchdog: imx2_wdt: Fix the argument of watchdog_active()

    Fix the following build warning by passing the expected argument type to
    watchdog_active():

    drivers/watchdog/imx2_wdt.c: In function 'imx2_wdt_suspend':
    drivers/watchdog/imx2_wdt.c:340:2: warning: passing argument 1 of 'watchdog_active' from incompatible pointer type [enabled by default]
    In file included from drivers/watchdog/imx2_wdt.c:38:0:
    include/linux/watchdog.h:104:20: note: expected 'struct watchdog_device *' but argument is of type 'struct watchdog_device **'

    Reported-by: Olof's autobuilder <build@lixom.net>
    Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit aefbaf3a3fa030ed7ef3cc9456ed82e6611c1dcb
Author: Xiubo Li <Li.Xiubo@freescale.com>
Date:   Mon Sep 22 18:00:52 2014 +0800

    watchdog: imx2_wdt: Add power management support.

    Add power management operations(suspend and resume) as part of
    dev_pm_ops for IMX2 watchdog driver.

    Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/imx2_wdt.c b/drivers/watchdog/imx2_wdt.c
index 65b84d8..d6add51 100644
--- a/drivers/watchdog/imx2_wdt.c
+++ b/drivers/watchdog/imx2_wdt.c
@@ -326,6 +326,52 @@ static void imx2_wdt_shutdown(struct platform_device *pdev)
        }
 }

+#ifdef CONFIG_PM_SLEEP
+/* Disable watchdog if it is active during suspend */
+static int imx2_wdt_suspend(struct device *dev)
+{
+       struct watchdog_device *wdog = dev_get_drvdata(dev);
+       struct imx2_wdt_device *wdev = watchdog_get_drvdata(wdog);
+
+       imx2_wdt_set_timeout(wdog, IMX2_WDT_MAX_TIME);
+       imx2_wdt_ping(wdog);
+
+       /* Watchdog has been stopped but IP block is still running */
+       if (!watchdog_active(wdog) && imx2_wdt_is_running(wdev))
+               del_timer_sync(&wdev->timer);
+
+       clk_disable_unprepare(wdev->clk);
+
+       return 0;
+}
+
+/* Enable watchdog and configure it if necessary */
+static int imx2_wdt_resume(struct device *dev)
+{
+       struct watchdog_device *wdog = dev_get_drvdata(dev);
+       struct imx2_wdt_device *wdev = watchdog_get_drvdata(wdog);
+
+       clk_prepare_enable(wdev->clk);
+
+       if (watchdog_active(wdog) && !imx2_wdt_is_running(wdev)) {
+               /* Resumes from deep sleep we need restart
+                * the watchdog again.
+                */
+               imx2_wdt_setup(wdog);
+               imx2_wdt_set_timeout(wdog, wdog->timeout);
+               imx2_wdt_ping(wdog);
+       } else if (imx2_wdt_is_running(wdev)) {
+               imx2_wdt_ping(wdog);
+               mod_timer(&wdev->timer, jiffies + wdog->timeout * HZ / 2);
+       }
+
+       return 0;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(imx2_wdt_pm_ops, imx2_wdt_suspend,
+                        imx2_wdt_resume);
+
 static const struct of_device_id imx2_wdt_dt_ids[] = {
        { .compatible = "fsl,imx21-wdt", },
        { /* sentinel */ }
@@ -337,6 +383,7 @@ static struct platform_driver imx2_wdt_driver = {
        .shutdown       = imx2_wdt_shutdown,
        .driver         = {
                .name   = DRIVER_NAME,
+               .pm     = &imx2_wdt_pm_ops,
                .of_match_table = imx2_wdt_dt_ids,
        },
 };
