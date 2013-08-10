Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934451Ab3HJPWo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 11:22:44 -0400
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:58683 "EHLO
	qmta10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934426Ab3HJPWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 11:22:41 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: sonic.zhang@analog.com, cjb@laptop.org
Cc: Shuah Khan <shuah.kh@samsung.com>, uclinux-dist-devel@blackfin.uclinux.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com
Subject: [PATCH] mmc:bfin_sdh change driver to use dev_pm_ops infrastructure
Date: Sat, 10 Aug 2013 09:20:48 -0600
Message-Id: <1376148055-2539-3-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1376148055-2539-1-git-send-email-shuah.kh@samsung.com>
References: <1376148055-2539-1-git-send-email-shuah.kh@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change bfin sdh platform driver to register pm ops using dev_pm_ops instead of
legacy pm_ops infrastructure.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/mmc/host/bfin_sdh.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/mmc/host/bfin_sdh.c b/drivers/mmc/host/bfin_sdh.c
index 94fae2f..7b3e12f 100644
--- a/drivers/mmc/host/bfin_sdh.c
+++ b/drivers/mmc/host/bfin_sdh.c
@@ -638,10 +638,11 @@ static int sdh_remove(struct platform_device *pdev)
 }
 
 #ifdef CONFIG_PM
-static int sdh_suspend(struct platform_device *dev, pm_message_t state)
+static int sdh_suspend(struct device *dev)
 {
-	struct mmc_host *mmc = platform_get_drvdata(dev);
-	struct bfin_sd_host *drv_data = get_sdh_data(dev);
+	struct platform_device *pdev = to_platform_device(dev);
+	struct mmc_host *mmc = platform_get_drvdata(pdev);
+	struct bfin_sd_host *drv_data = get_sdh_data(pdev);
 	int ret = 0;
 
 	if (mmc)
@@ -652,15 +653,16 @@ static int sdh_suspend(struct platform_device *dev, pm_message_t state)
 	return ret;
 }
 
-static int sdh_resume(struct platform_device *dev)
+static int sdh_resume(struct device *dev)
 {
-	struct mmc_host *mmc = platform_get_drvdata(dev);
-	struct bfin_sd_host *drv_data = get_sdh_data(dev);
+	struct platform_device *pdev = to_platform_device(dev);
+	struct mmc_host *mmc = platform_get_drvdata(pdev);
+	struct bfin_sd_host *drv_data = get_sdh_data(pdev);
 	int ret = 0;
 
 	ret = peripheral_request_list(drv_data->pin_req, DRIVER_NAME);
 	if (ret) {
-		dev_err(&dev->dev, "unable to request peripheral pins\n");
+		dev_err(dev, "unable to request peripheral pins\n");
 		return ret;
 	}
 
@@ -676,13 +678,14 @@ static int sdh_resume(struct platform_device *dev)
 # define sdh_resume  NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(sdh_dev_pm_ops, sdh_suspend, sdh_resume);
+
 static struct platform_driver sdh_driver = {
 	.probe   = sdh_probe,
 	.remove  = sdh_remove,
-	.suspend = sdh_suspend,
-	.resume  = sdh_resume,
 	.driver  = {
 		.name = DRIVER_NAME,
+		.pm = &sdh_dev_pm_ops,
 	},
 };
 
-- 
1.7.10.4

