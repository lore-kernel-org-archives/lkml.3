Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab3IZO4D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 10:56:03 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:56771 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219Ab3IZOzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 10:55:46 -0400
From: Ulf Hansson <ulf.hansson@linaro.org>
To: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Chris Ball <cjb@laptop.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, Balaji T K <balajitk@ti.com>,
        linux-omap@vger.kernel.org
Subject: [PATCH 14/27] mmc: omap_hsmmc: Move away from using deprecated APIs
Date: Thu, 26 Sep 2013 16:54:39 +0200
Message-Id: <1380207292-16968-15-git-send-email-ulf.hansson@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1380207292-16968-1-git-send-email-ulf.hansson@linaro.org>
References: <1380207292-16968-1-git-send-email-ulf.hansson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suspend and resume of cards are being handled from the protocol layer
and consequently the mmc_suspend|resume_host APIs are deprecated.

This means we can simplify the suspend|resume callbacks by removing the
use of the deprecated APIs. Additional cleanup done for keeping track
suspended state.

Cc: Balaji T K <balajitk@ti.com>
Cc: linux-omap@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/mmc/host/omap_hsmmc.c |   37 +++----------------------------------
 1 file changed, 3 insertions(+), 34 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 6ac63df..eb6fb28 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -170,7 +170,6 @@ struct omap_hsmmc_host {
 	unsigned int		dma_sg_idx;
 	unsigned char		bus_mode;
 	unsigned char		power_mode;
-	int			suspended;
 	int			irq;
 	int			use_dma, dma_ch;
 	struct dma_chan		*tx_chan;
@@ -1178,9 +1177,6 @@ static irqreturn_t omap_hsmmc_detect(int irq, void *dev_id)
 	struct omap_mmc_slot_data *slot = &mmc_slot(host);
 	int carddetect;
 
-	if (host->suspended)
-		return IRQ_HANDLED;
-
 	sysfs_notify(&host->mmc->class_dev.kobj, NULL, "cover_switch");
 
 	if (slot->card_detect)
@@ -1643,11 +1639,6 @@ static int omap_hsmmc_regs_show(struct seq_file *s, void *data)
 	seq_printf(s, "mmc%d:\n ctx_loss:\t%d:%d\n\nregs:\n",
 			mmc->index, host->context_loss, context_loss);
 
-	if (host->suspended) {
-		seq_printf(s, "host suspended, can't read registers\n");
-		return 0;
-	}
-
 	pm_runtime_get_sync(host->dev);
 
 	seq_printf(s, "CON:\t\t0x%08x\n",
@@ -2119,23 +2110,12 @@ static void omap_hsmmc_complete(struct device *dev)
 
 static int omap_hsmmc_suspend(struct device *dev)
 {
-	int ret = 0;
 	struct omap_hsmmc_host *host = dev_get_drvdata(dev);
 
 	if (!host)
 		return 0;
 
-	if (host && host->suspended)
-		return 0;
-
 	pm_runtime_get_sync(host->dev);
-	host->suspended = 1;
-	ret = mmc_suspend_host(host->mmc);
-
-	if (ret) {
-		host->suspended = 0;
-		goto err;
-	}
 
 	if (!(host->mmc->pm_flags & MMC_PM_KEEP_POWER)) {
 		omap_hsmmc_disable_irq(host);
@@ -2145,23 +2125,19 @@ static int omap_hsmmc_suspend(struct device *dev)
 
 	if (host->dbclk)
 		clk_disable_unprepare(host->dbclk);
-err:
+
 	pm_runtime_put_sync(host->dev);
-	return ret;
+	return 0;
 }
 
 /* Routine to resume the MMC device */
 static int omap_hsmmc_resume(struct device *dev)
 {
-	int ret = 0;
 	struct omap_hsmmc_host *host = dev_get_drvdata(dev);
 
 	if (!host)
 		return 0;
 
-	if (host && !host->suspended)
-		return 0;
-
 	pm_runtime_get_sync(host->dev);
 
 	if (host->dbclk)
@@ -2172,16 +2148,9 @@ static int omap_hsmmc_resume(struct device *dev)
 
 	omap_hsmmc_protect_card(host);
 
-	/* Notify the core to resume the host */
-	ret = mmc_resume_host(host->mmc);
-	if (ret == 0)
-		host->suspended = 0;
-
 	pm_runtime_mark_last_busy(host->dev);
 	pm_runtime_put_autosuspend(host->dev);
-
-	return ret;
-
+	return 0;
 }
 
 #else
-- 
1.7.9.5

