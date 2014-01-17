Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464AbaAQUEX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 15:04:23 -0500
Received: from mail-qa0-f74.google.com ([209.85.216.74]:45026 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbaAQUEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 15:04:21 -0500
From: Andrew Bresticker <abrestic@chromium.org>
To: Chris Ball <chris@printf.net>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH] mmc: sdhci: fix possible scheduling while atomic
Date: Fri, 17 Jan 2014 11:57:10 -0800
Message-Id: <1389988630-9481-1-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sdhci_execute_tuning() takes host->lock without disabling interrupts.
Use spin_lock_irq{save,restore} instead so that we avoid taking an
interrupt and scheduling while holding host->lock.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 drivers/mmc/host/sdhci.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index ec3eb30..84c80e7 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1857,12 +1857,13 @@ static int sdhci_execute_tuning(struct mmc_host *mmc, u32 opcode)
 	unsigned long timeout;
 	int err = 0;
 	bool requires_tuning_nonuhs = false;
+	unsigned long flags;
 
 	host = mmc_priv(mmc);
 
 	sdhci_runtime_pm_get(host);
 	disable_irq(host->irq);
-	spin_lock(&host->lock);
+	spin_lock_irqsave(&host->lock, flags);
 
 	ctrl = sdhci_readw(host, SDHCI_HOST_CONTROL2);
 
@@ -1882,14 +1883,14 @@ static int sdhci_execute_tuning(struct mmc_host *mmc, u32 opcode)
 	    requires_tuning_nonuhs)
 		ctrl |= SDHCI_CTRL_EXEC_TUNING;
 	else {
-		spin_unlock(&host->lock);
+		spin_unlock_irqrestore(&host->lock, flags);
 		enable_irq(host->irq);
 		sdhci_runtime_pm_put(host);
 		return 0;
 	}
 
 	if (host->ops->platform_execute_tuning) {
-		spin_unlock(&host->lock);
+		spin_unlock_irqrestore(&host->lock, flags);
 		enable_irq(host->irq);
 		err = host->ops->platform_execute_tuning(host, opcode);
 		sdhci_runtime_pm_put(host);
@@ -1963,7 +1964,7 @@ static int sdhci_execute_tuning(struct mmc_host *mmc, u32 opcode)
 		host->cmd = NULL;
 		host->mrq = NULL;
 
-		spin_unlock(&host->lock);
+		spin_unlock_irqrestore(&host->lock, flags);
 		enable_irq(host->irq);
 
 		/* Wait for Buffer Read Ready interrupt */
@@ -1971,7 +1972,7 @@ static int sdhci_execute_tuning(struct mmc_host *mmc, u32 opcode)
 					(host->tuning_done == 1),
 					msecs_to_jiffies(50));
 		disable_irq(host->irq);
-		spin_lock(&host->lock);
+		spin_lock_irqsave(&host->lock, flags);
 
 		if (!host->tuning_done) {
 			pr_info(DRIVER_NAME ": Timeout waiting for "
@@ -2046,7 +2047,7 @@ out:
 		err = 0;
 
 	sdhci_clear_set_irqs(host, SDHCI_INT_DATA_AVAIL, ier);
-	spin_unlock(&host->lock);
+	spin_unlock_irqrestore(&host->lock, flags);
 	enable_irq(host->irq);
 	sdhci_runtime_pm_put(host);
 
-- 
1.8.5.2

