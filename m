Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687Ab3IZPBy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 11:01:54 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:35144 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044Ab3IZOz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 10:55:29 -0400
From: Ulf Hansson <ulf.hansson@linaro.org>
To: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Chris Ball <cjb@laptop.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-arm-msm@vger.kernel.org
Subject: [PATCH 08/27] mmc: msm_sdcc: Move away from using deprecated APIs
Date: Thu, 26 Sep 2013 16:54:33 +0200
Message-Id: <1380207292-16968-9-git-send-email-ulf.hansson@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1380207292-16968-1-git-send-email-ulf.hansson@linaro.org>
References: <1380207292-16968-1-git-send-email-ulf.hansson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suspend and resume of cards are being handled from the protocol layer
and consequently the mmc_suspend|resume_host APIs are deprecated.

This means we can simplify the suspend|resume callbacks by removing the
use of the deprecated APIs.

Additionally, remove dead code which also used the deprecated APIs.

Cc: David Brown <davidb@codeaurora.org>
Cc: Daniel Walker <dwalker@fifo99.com>
Cc: Bryan Huntsman <bryanh@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/mmc/host/msm_sdcc.c |   27 ++-------------------------
 1 file changed, 2 insertions(+), 25 deletions(-)

diff --git a/drivers/mmc/host/msm_sdcc.c b/drivers/mmc/host/msm_sdcc.c
index b900de4..9405ecd 100644
--- a/drivers/mmc/host/msm_sdcc.c
+++ b/drivers/mmc/host/msm_sdcc.c
@@ -1416,28 +1416,10 @@ ioremap_free:
 }
 
 #ifdef CONFIG_PM
-#ifdef CONFIG_MMC_MSM7X00A_RESUME_IN_WQ
-static void
-do_resume_work(struct work_struct *work)
-{
-	struct msmsdcc_host *host =
-		container_of(work, struct msmsdcc_host, resume_task);
-	struct mmc_host	*mmc = host->mmc;
-
-	if (mmc) {
-		mmc_resume_host(mmc);
-		if (host->stat_irq)
-			enable_irq(host->stat_irq);
-	}
-}
-#endif
-
-
 static int
 msmsdcc_suspend(struct platform_device *dev, pm_message_t state)
 {
 	struct mmc_host *mmc = mmc_get_drvdata(dev);
-	int rc = 0;
 
 	if (mmc) {
 		struct msmsdcc_host *host = mmc_priv(mmc);
@@ -1445,14 +1427,11 @@ msmsdcc_suspend(struct platform_device *dev, pm_message_t state)
 		if (host->stat_irq)
 			disable_irq(host->stat_irq);
 
-		if (mmc->card && mmc->card->type != MMC_TYPE_SDIO)
-			rc = mmc_suspend_host(mmc);
-		if (!rc)
-			msmsdcc_writel(host, 0, MMCIMASK0);
+		msmsdcc_writel(host, 0, MMCIMASK0);
 		if (host->clks_on)
 			msmsdcc_disable_clocks(host, 0);
 	}
-	return rc;
+	return 0;
 }
 
 static int
@@ -1467,8 +1446,6 @@ msmsdcc_resume(struct platform_device *dev)
 
 		msmsdcc_writel(host, host->saved_irq0mask, MMCIMASK0);
 
-		if (mmc->card && mmc->card->type != MMC_TYPE_SDIO)
-			mmc_resume_host(mmc);
 		if (host->stat_irq)
 			enable_irq(host->stat_irq);
 #if BUSCLK_PWRSAVE
-- 
1.7.9.5

