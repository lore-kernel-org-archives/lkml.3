Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934465Ab3HJPWt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 11:22:49 -0400
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:38503 "EHLO
	qmta03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934426Ab3HJPWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 11:22:46 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: mirq-linux@rere.qmqm.pl, cjb@laptop.org
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Subject: [PATCH] mmc:cb710_mmc change driver to use dev_pm_ops infrastructure
Date: Sat, 10 Aug 2013 09:20:50 -0600
Message-Id: <1376148055-2539-5-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1376148055-2539-1-git-send-email-shuah.kh@samsung.com>
References: <1376148055-2539-1-git-send-email-shuah.kh@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change cb710_mmc platform driver register pm ops using dev_pm_ops instead of
legacy pm_ops infrastructure.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/mmc/host/cb710-mmc.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/cb710-mmc.c b/drivers/mmc/host/cb710-mmc.c
index 9d6e2b8..e79ac0d 100644
--- a/drivers/mmc/host/cb710-mmc.c
+++ b/drivers/mmc/host/cb710-mmc.c
@@ -664,8 +664,9 @@ static const struct mmc_host_ops cb710_mmc_host = {
 
 #ifdef CONFIG_PM
 
-static int cb710_mmc_suspend(struct platform_device *pdev, pm_message_t state)
+static int cb710_mmc_suspend(struct device *dev)
 {
+	struct platform_device *pdev = to_platform_device(dev);
 	struct cb710_slot *slot = cb710_pdev_to_slot(pdev);
 	struct mmc_host *mmc = cb710_slot_to_mmc(slot);
 	int err;
@@ -678,8 +679,9 @@ static int cb710_mmc_suspend(struct platform_device *pdev, pm_message_t state)
 	return 0;
 }
 
-static int cb710_mmc_resume(struct platform_device *pdev)
+static int cb710_mmc_resume(struct device *dev)
 {
+	struct platform_device *pdev = to_platform_device(dev);
 	struct cb710_slot *slot = cb710_pdev_to_slot(pdev);
 	struct mmc_host *mmc = cb710_slot_to_mmc(slot);
 
@@ -688,6 +690,8 @@ static int cb710_mmc_resume(struct platform_device *pdev)
 	return mmc_resume_host(mmc);
 }
 
+static SIMPLE_DEV_PM_OPS(cb710_mmc_dev_pm_ops, cb710_mmc_suspend,
+			 cb710_mmc_resume);
 #endif /* CONFIG_PM */
 
 static int cb710_mmc_init(struct platform_device *pdev)
@@ -775,8 +779,7 @@ static struct platform_driver cb710_mmc_driver = {
 	.probe = cb710_mmc_init,
 	.remove = cb710_mmc_exit,
 #ifdef CONFIG_PM
-	.suspend = cb710_mmc_suspend,
-	.resume = cb710_mmc_resume,
+	.driver.pm = &cb710_mmc_dev_pm_ops,
 #endif
 };
 
-- 
1.7.10.4

