Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934506Ab3HJPXJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 11:23:09 -0400
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:54141
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934484Ab3HJPW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 11:22:57 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: g.liakhovetski@gmx.de, ian@mnementh.co.uk, cjb@laptop.org
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Subject: [PATCH] mmc:tmio_mmc change driver to use dev_pm_ops infrastructure
Date: Sat, 10 Aug 2013 09:20:55 -0600
Message-Id: <1376148055-2539-10-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1376148055-2539-1-git-send-email-shuah.kh@samsung.com>
References: <1376148055-2539-1-git-send-email-shuah.kh@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change tmio_mmc platform driver to register pm ops using dev_pm_ops instead of
legacy pm_ops infrastructure.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/mmc/host/tmio_mmc.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/mmc/host/tmio_mmc.c b/drivers/mmc/host/tmio_mmc.c
index 8860d4d..3e3c730 100644
--- a/drivers/mmc/host/tmio_mmc.c
+++ b/drivers/mmc/host/tmio_mmc.c
@@ -24,31 +24,33 @@
 #include "tmio_mmc.h"
 
 #ifdef CONFIG_PM
-static int tmio_mmc_suspend(struct platform_device *dev, pm_message_t state)
+static int tmio_mmc_suspend(struct device *dev)
 {
-	const struct mfd_cell *cell = mfd_get_cell(dev);
+	struct platform_device *pdev = to_platform_device(dev);
+	const struct mfd_cell *cell = mfd_get_cell(pdev);
 	int ret;
 
-	ret = tmio_mmc_host_suspend(&dev->dev);
+	ret = tmio_mmc_host_suspend(dev);
 
 	/* Tell MFD core it can disable us now.*/
 	if (!ret && cell->disable)
-		cell->disable(dev);
+		cell->disable(pdev);
 
 	return ret;
 }
 
-static int tmio_mmc_resume(struct platform_device *dev)
+static int tmio_mmc_resume(struct device *dev)
 {
-	const struct mfd_cell *cell = mfd_get_cell(dev);
+	struct platform_device *pdev = to_platform_device(dev);
+	const struct mfd_cell *cell = mfd_get_cell(pdev);
 	int ret = 0;
 
 	/* Tell the MFD core we are ready to be enabled */
 	if (cell->resume)
-		ret = cell->resume(dev);
+		ret = cell->resume(pdev);
 
 	if (!ret)
-		ret = tmio_mmc_host_resume(&dev->dev);
+		ret = tmio_mmc_host_resume(dev);
 
 	return ret;
 }
@@ -123,17 +125,19 @@ static int tmio_mmc_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static SIMPLE_DEV_PM_OPS(tmio_mmc_dev_pm_ops, tmio_mmc_suspend,
+			  tmio_mmc_resume);
+
 /* ------------------- device registration ----------------------- */
 
 static struct platform_driver tmio_mmc_driver = {
 	.driver = {
 		.name = "tmio-mmc",
 		.owner = THIS_MODULE,
+		.pm = &tmio_mmc_dev_pm_ops,
 	},
 	.probe = tmio_mmc_probe,
 	.remove = tmio_mmc_remove,
-	.suspend = tmio_mmc_suspend,
-	.resume = tmio_mmc_resume,
 };
 
 module_platform_driver(tmio_mmc_driver);
-- 
1.7.10.4

