Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565AbaIVKBV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 06:01:21 -0400
Received: from mail-bn1bbn0104.outbound.protection.outlook.com ([157.56.111.104]:8811
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751894AbaIVKBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 06:01:19 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <wim@iguana.be>, <groeck7@gmail.com>, <linux-watchdog@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH] watchdog: imx2_wdt: Add power management support.
Date: Mon, 22 Sep 2014 18:00:52 +0800
Message-ID: <1411380052-48655-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 2.1.0.27.g96db324
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(85306004)(92726001)(83072002)(88136002)(74662003)(46102003)(36756003)(48376002)(93916002)(92566001)(44976005)(6806004)(19580405001)(86362001)(79102003)(85852003)(77156001)(68736004)(77982003)(74502003)(104016003)(62966002)(80022003)(19580395003)(2201001)(81342003)(26826002)(107046002)(50466002)(69596002)(87286001)(81542003)(90102001)(21056001)(102836001)(97736003)(50226001)(50986999)(81156004)(106466001)(31966008)(95666004)(105606002)(64706001)(84676001)(89996001)(4396001)(99396002)(83322001)(76482002)(20776003)(87936001)(47776003)(120916001)(104166001)(229853001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB0624;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0624;
X-Forefront-PRVS: 034215E98F
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add power management operations(suspend and resume) as part of
dev_pm_ops for IMX2 watchdog driver.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 drivers/watchdog/imx2_wdt.c | 47 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/drivers/watchdog/imx2_wdt.c b/drivers/watchdog/imx2_wdt.c
index 68c3d37..941c36f 100644
--- a/drivers/watchdog/imx2_wdt.c
+++ b/drivers/watchdog/imx2_wdt.c
@@ -295,6 +295,52 @@ static void imx2_wdt_shutdown(struct platform_device *pdev)
 	}
 }
 
+#ifdef CONFIG_PM_SLEEP
+/* Disable watchdog if it is active during suspend */
+static int imx2_wdt_suspend(struct device *dev)
+{
+	struct watchdog_device *wdog = dev_get_drvdata(dev);
+	struct imx2_wdt_device *wdev = watchdog_get_drvdata(wdog);
+
+	imx2_wdt_set_timeout(wdog, IMX2_WDT_MAX_TIME);
+	imx2_wdt_ping(wdog);
+
+	/* Watchdog has been stopped but IP block is still running */
+	if (!watchdog_active(&wdog) && imx2_wdt_is_running(wdev))
+		del_timer_sync(&wdev->timer);
+
+	clk_disable_unprepare(wdev->clk);
+
+	return 0;
+}
+
+/* Enable watchdog and configure it if necessary */
+static int imx2_wdt_resume(struct device *dev)
+{
+	struct watchdog_device *wdog = dev_get_drvdata(dev);
+	struct imx2_wdt_device *wdev = watchdog_get_drvdata(wdog);
+
+	clk_prepare_enable(wdev->clk);
+
+	if (watchdog_active(wdog) && !imx2_wdt_is_running(wdev)) {
+		/* Resumes from deep sleep we need restart
+		 * the watchdog again.
+		 */
+		imx2_wdt_setup(wdog);
+		imx2_wdt_set_timeout(wdog, wdog->timeout);
+		imx2_wdt_ping(wdog);
+	} else if (imx2_wdt_is_running(wdev)) {
+		imx2_wdt_ping(wdog);
+		mod_timer(&wdev->timer, jiffies + wdog->timeout * HZ / 2);
+	}
+
+	return 0;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(imx2_wdt_pm_ops, imx2_wdt_suspend,
+			 imx2_wdt_resume);
+
 static const struct of_device_id imx2_wdt_dt_ids[] = {
 	{ .compatible = "fsl,imx21-wdt", },
 	{ /* sentinel */ }
@@ -307,6 +353,7 @@ static struct platform_driver imx2_wdt_driver = {
 	.driver		= {
 		.name	= DRIVER_NAME,
 		.owner	= THIS_MODULE,
+		.pm     = &imx2_wdt_pm_ops,
 		.of_match_table = imx2_wdt_dt_ids,
 	},
 };
-- 
2.1.0.27.g96db324

