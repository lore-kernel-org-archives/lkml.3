Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934462Ab3HJPjv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 11:39:51 -0400
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:52502 "EHLO
	qmta03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934415Ab3HJPjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 11:39:49 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: jarkko.lavinen@nokia.com, cjb@laptop.org
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-omap@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com
Subject: [PATCH] mmc:omap change driver to use dev_pm_ops infrastructure
Date: Sat, 10 Aug 2013 09:39:41 -0600
Message-Id: <1376149181-2761-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change mmc_omap platform driver to register pm ops using dev_pm_ops instead of
legacy pm_ops infrastructure.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/mmc/host/omap.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/mmc/host/omap.c b/drivers/mmc/host/omap.c
index b94f38e..3251df2 100644
--- a/drivers/mmc/host/omap.c
+++ b/drivers/mmc/host/omap.c
@@ -1514,10 +1514,11 @@ static int mmc_omap_remove(struct platform_device *pdev)
 }
 
 #ifdef CONFIG_PM
-static int mmc_omap_suspend(struct platform_device *pdev, pm_message_t mesg)
+static int mmc_omap_suspend(struct device *dev)
 {
 	int i, ret = 0;
-	struct mmc_omap_host *host = platform_get_drvdata(pdev);
+	struct mmc_omap_host *host = platform_get_drvdata(to_platform_device(
+							  dev));
 
 	if (host == NULL || host->suspended)
 		return 0;
@@ -1539,10 +1540,11 @@ static int mmc_omap_suspend(struct platform_device *pdev, pm_message_t mesg)
 	return 0;
 }
 
-static int mmc_omap_resume(struct platform_device *pdev)
+static int mmc_omap_resume(struct device *dev)
 {
 	int i, ret = 0;
-	struct mmc_omap_host *host = platform_get_drvdata(pdev);
+	struct mmc_omap_host *host = platform_get_drvdata(to_platform_device(
+							  dev));
 
 	if (host == NULL || !host->suspended)
 		return 0;
@@ -1563,14 +1565,16 @@ static int mmc_omap_resume(struct platform_device *pdev)
 #define mmc_omap_resume		NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(mmc_omap_dev_pm_ops, mmc_omap_suspend,
+			 mmc_omap_resume);
+
 static struct platform_driver mmc_omap_driver = {
 	.probe		= mmc_omap_probe,
 	.remove		= mmc_omap_remove,
-	.suspend	= mmc_omap_suspend,
-	.resume		= mmc_omap_resume,
 	.driver		= {
 		.name	= DRIVER_NAME,
 		.owner	= THIS_MODULE,
+		.pm	= &mmc_omap_dev_pm_ops,
 	},
 };
 
-- 
1.7.10.4

