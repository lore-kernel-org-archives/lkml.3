Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232Ab3IZOzq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 10:55:46 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:57696 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015Ab3IZOzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 10:55:37 -0400
From: Ulf Hansson <ulf.hansson@linaro.org>
To: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Chris Ball <cjb@laptop.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 11/27] mmc: sdhci: Move away from using deprecated APIs
Date: Thu, 26 Sep 2013 16:54:36 +0200
Message-Id: <1380207292-16968-12-git-send-email-ulf.hansson@linaro.org>
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

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/mmc/host/sdhci.c |   20 ++------------------
 1 file changed, 2 insertions(+), 18 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 7a7fb4f..bdb7598 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -2546,8 +2546,6 @@ EXPORT_SYMBOL_GPL(sdhci_disable_irq_wakeups);
 
 int sdhci_suspend_host(struct sdhci_host *host)
 {
-	int ret;
-
 	if (host->ops->platform_suspend)
 		host->ops->platform_suspend(host);
 
@@ -2559,19 +2557,6 @@ int sdhci_suspend_host(struct sdhci_host *host)
 		host->flags &= ~SDHCI_NEEDS_RETUNING;
 	}
 
-	ret = mmc_suspend_host(host->mmc);
-	if (ret) {
-		if (host->flags & SDHCI_USING_RETUNING_TIMER) {
-			host->flags |= SDHCI_NEEDS_RETUNING;
-			mod_timer(&host->tuning_timer, jiffies +
-					host->tuning_count * HZ);
-		}
-
-		sdhci_enable_card_detection(host);
-
-		return ret;
-	}
-
 	if (!device_may_wakeup(mmc_dev(host->mmc))) {
 		sdhci_mask_irqs(host, SDHCI_INT_ALL_MASK);
 		free_irq(host->irq, host);
@@ -2579,14 +2564,14 @@ int sdhci_suspend_host(struct sdhci_host *host)
 		sdhci_enable_irq_wakeups(host);
 		enable_irq_wake(host->irq);
 	}
-	return ret;
+	return 0;
 }
 
 EXPORT_SYMBOL_GPL(sdhci_suspend_host);
 
 int sdhci_resume_host(struct sdhci_host *host)
 {
-	int ret;
+	int ret = 0;
 
 	if (host->flags & (SDHCI_USE_SDMA | SDHCI_USE_ADMA)) {
 		if (host->ops->enable_dma)
@@ -2615,7 +2600,6 @@ int sdhci_resume_host(struct sdhci_host *host)
 		mmiowb();
 	}
 
-	ret = mmc_resume_host(host->mmc);
 	sdhci_enable_card_detection(host);
 
 	if (host->ops->platform_resume)
-- 
1.7.9.5

