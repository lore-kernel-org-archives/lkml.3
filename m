Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934498Ab3HJPXt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 11:23:49 -0400
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96]:50913 "EHLO
	qmta09.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934454Ab3HJPWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 11:22:48 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: davidb@codeaurora.org, dwalker@fifo99.com, bryanh@codeaurora.org,
        cjb@laptop.org
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-arm-msm@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com
Subject: [PATCH] mmc:msmsdcc change driver to use dev_pm_ops infrastructure
Date: Sat, 10 Aug 2013 09:20:51 -0600
Message-Id: <1376148055-2539-6-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1376148055-2539-1-git-send-email-shuah.kh@samsung.com>
References: <1376148055-2539-1-git-send-email-shuah.kh@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change msmsdcc platform driver to register pm ops using dev_pm_ops instead of
legacy pm_ops infrastructure.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/mmc/host/msm_sdcc.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/mmc/host/msm_sdcc.c b/drivers/mmc/host/msm_sdcc.c
index b900de4..017c9d7 100644
--- a/drivers/mmc/host/msm_sdcc.c
+++ b/drivers/mmc/host/msm_sdcc.c
@@ -1434,9 +1434,9 @@ do_resume_work(struct work_struct *work)
 
 
 static int
-msmsdcc_suspend(struct platform_device *dev, pm_message_t state)
+msmsdcc_suspend(struct device *dev)
 {
-	struct mmc_host *mmc = mmc_get_drvdata(dev);
+	struct mmc_host *mmc = mmc_get_drvdata(to_platform_device(dev));
 	int rc = 0;
 
 	if (mmc) {
@@ -1456,9 +1456,9 @@ msmsdcc_suspend(struct platform_device *dev, pm_message_t state)
 }
 
 static int
-msmsdcc_resume(struct platform_device *dev)
+msmsdcc_resume(struct device *dev)
 {
-	struct mmc_host *mmc = mmc_get_drvdata(dev);
+	struct mmc_host *mmc = mmc_get_drvdata(to_platform_device(dev));
 
 	if (mmc) {
 		struct msmsdcc_host *host = mmc_priv(mmc);
@@ -1482,12 +1482,13 @@ msmsdcc_resume(struct platform_device *dev)
 #define msmsdcc_resume 0
 #endif
 
+static SIMPLE_DEV_PM_OPS(msmdcc_dev_pm_ops, msmsdcc_suspend, msmsdcc_resume);
+
 static struct platform_driver msmsdcc_driver = {
 	.probe		= msmsdcc_probe,
-	.suspend	= msmsdcc_suspend,
-	.resume		= msmsdcc_resume,
 	.driver		= {
 		.name	= "msm_sdcc",
+		.pm	= &msmdcc_dev_pm_ops,
 	},
 };
 
-- 
1.7.10.4

