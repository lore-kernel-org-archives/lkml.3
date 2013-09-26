Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab3IZPBH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 11:01:07 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:47053 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169Ab3IZOzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 10:55:43 -0400
From: Ulf Hansson <ulf.hansson@linaro.org>
To: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Chris Ball <cjb@laptop.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>,
        Jarkko Lavinen <jarkko.lavinen@nokia.com>, linux-omap@vger.kernel.org
Subject: [PATCH 13/27] mmc: omap: Remove redundant suspend and resume callbacks
Date: Thu, 26 Sep 2013 16:54:38 +0200
Message-Id: <1380207292-16968-14-git-send-email-ulf.hansson@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1380207292-16968-1-git-send-email-ulf.hansson@linaro.org>
References: <1380207292-16968-1-git-send-email-ulf.hansson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suspend and resume of cards are handled by the protocol layer and
consequently the mmc_suspend|resume_host APIs are marked as deprecated.

While moving away from using the deprecated APIs, there are nothing
left to be done for the suspend and resume callbacks, so remove them.

Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Cc: linux-omap@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/mmc/host/omap.c |   53 -----------------------------------------------
 1 file changed, 53 deletions(-)

diff --git a/drivers/mmc/host/omap.c b/drivers/mmc/host/omap.c
index b94f38e..0b10a90 100644
--- a/drivers/mmc/host/omap.c
+++ b/drivers/mmc/host/omap.c
@@ -128,7 +128,6 @@ struct mmc_omap_slot {
 
 struct mmc_omap_host {
 	int			initialized;
-	int			suspended;
 	struct mmc_request *	mrq;
 	struct mmc_command *	cmd;
 	struct mmc_data *	data;
@@ -1513,61 +1512,9 @@ static int mmc_omap_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int mmc_omap_suspend(struct platform_device *pdev, pm_message_t mesg)
-{
-	int i, ret = 0;
-	struct mmc_omap_host *host = platform_get_drvdata(pdev);
-
-	if (host == NULL || host->suspended)
-		return 0;
-
-	for (i = 0; i < host->nr_slots; i++) {
-		struct mmc_omap_slot *slot;
-
-		slot = host->slots[i];
-		ret = mmc_suspend_host(slot->mmc);
-		if (ret < 0) {
-			while (--i >= 0) {
-				slot = host->slots[i];
-				mmc_resume_host(slot->mmc);
-			}
-			return ret;
-		}
-	}
-	host->suspended = 1;
-	return 0;
-}
-
-static int mmc_omap_resume(struct platform_device *pdev)
-{
-	int i, ret = 0;
-	struct mmc_omap_host *host = platform_get_drvdata(pdev);
-
-	if (host == NULL || !host->suspended)
-		return 0;
-
-	for (i = 0; i < host->nr_slots; i++) {
-		struct mmc_omap_slot *slot;
-		slot = host->slots[i];
-		ret = mmc_resume_host(slot->mmc);
-		if (ret < 0)
-			return ret;
-
-		host->suspended = 0;
-	}
-	return 0;
-}
-#else
-#define mmc_omap_suspend	NULL
-#define mmc_omap_resume		NULL
-#endif
-
 static struct platform_driver mmc_omap_driver = {
 	.probe		= mmc_omap_probe,
 	.remove		= mmc_omap_remove,
-	.suspend	= mmc_omap_suspend,
-	.resume		= mmc_omap_resume,
 	.driver		= {
 		.name	= DRIVER_NAME,
 		.owner	= THIS_MODULE,
-- 
1.7.9.5

