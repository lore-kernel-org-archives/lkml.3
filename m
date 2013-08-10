Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934481Ab3HJPWz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 11:22:55 -0400
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:56847 "EHLO
	qmta08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934426Ab3HJPWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 11:22:52 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: nico@fluxnic.net, cjb@laptop.org, thomas.petazzoni@free-electrons.com,
        jason@lakedaemon.net, andrew@lunn.ch, jg1.han@samsung.com,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Shuah Khan <shuah.kh@samsung.com>, shuahkhan@gmail.com
Subject: [PATCH] mmc:mvsdio change driver to use dev_pm_ops infrastructure
Date: Sat, 10 Aug 2013 09:20:52 -0600
Message-Id: <1376148055-2539-7-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1376148055-2539-1-git-send-email-shuah.kh@samsung.com>
References: <1376148055-2539-1-git-send-email-shuah.kh@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change mvsd platform driver to register pm ops using dev_pm_ops instead of
legacy pm_ops infrastructure.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/mmc/host/mvsdio.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/mmc/host/mvsdio.c b/drivers/mmc/host/mvsdio.c
index 4ddd83f..800a7fd 100644
--- a/drivers/mmc/host/mvsdio.c
+++ b/drivers/mmc/host/mvsdio.c
@@ -838,9 +838,9 @@ static int __exit mvsd_remove(struct platform_device *pdev)
 }
 
 #ifdef CONFIG_PM
-static int mvsd_suspend(struct platform_device *dev, pm_message_t state)
+static int mvsd_suspend(struct device *dev)
 {
-	struct mmc_host *mmc = platform_get_drvdata(dev);
+	struct mmc_host *mmc = platform_get_drvdata(to_platform_device(dev));
 	int ret = 0;
 
 	if (mmc)
@@ -849,9 +849,9 @@ static int mvsd_suspend(struct platform_device *dev, pm_message_t state)
 	return ret;
 }
 
-static int mvsd_resume(struct platform_device *dev)
+static int mvsd_resume(struct device *dev)
 {
-	struct mmc_host *mmc = platform_get_drvdata(dev);
+	struct mmc_host *mmc = platform_get_drvdata(to_platform_device(dev));
 	int ret = 0;
 
 	if (mmc)
@@ -870,13 +870,14 @@ static const struct of_device_id mvsdio_dt_ids[] = {
 };
 MODULE_DEVICE_TABLE(of, mvsdio_dt_ids);
 
+static SIMPLE_DEV_PM_OPS(mvsd_dev_pm_ops, mvsd_suspend, mvsd_resume);
+
 static struct platform_driver mvsd_driver = {
 	.remove		= __exit_p(mvsd_remove),
-	.suspend	= mvsd_suspend,
-	.resume		= mvsd_resume,
 	.driver		= {
 		.name	= DRIVER_NAME,
 		.of_match_table = mvsdio_dt_ids,
+		.pm = &mvsd_dev_pm_ops,
 	},
 };
 
-- 
1.7.10.4

