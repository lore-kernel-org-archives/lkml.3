Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932621AbaHYM3Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 08:29:24 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:64212 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932332AbaHYM0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 08:26:35 -0400
From: Ulf Hansson <ulf.hansson@linaro.org>
To: linux-mmc@vger.kernel.org, Ian Molton <ian.molton@codethink.co.uk>,
        Chris Ball <chris@printf.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux-sh list <linux-sh@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 05/12] mmc: tmio: Handle clock gating from runtime PM functions
Date: Mon, 25 Aug 2014 14:25:57 +0200
Message-Id: <1408969564-6335-6-git-send-email-ulf.hansson@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408969564-6335-1-git-send-email-ulf.hansson@linaro.org>
References: <1408969564-6335-1-git-send-email-ulf.hansson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add clock gating control as a part of the tmio library functions for
runtime PM.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/mmc/host/tmio_mmc.h     |  3 ++-
 drivers/mmc/host/tmio_mmc_pio.c | 28 ++++++++++++++++++++++++----
 2 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/drivers/mmc/host/tmio_mmc.h b/drivers/mmc/host/tmio_mmc.h
index f837723..f1ee3e4 100644
--- a/drivers/mmc/host/tmio_mmc.h
+++ b/drivers/mmc/host/tmio_mmc.h
@@ -73,9 +73,10 @@ struct tmio_mmc_host {
 	struct delayed_work	delayed_reset_work;
 	struct work_struct	done;
 
-	/* Cache IRQ mask */
+	/* Cache */
 	u32			sdcard_irq_mask;
 	u32			sdio_irq_mask;
+	unsigned int		clk_cache;
 
 	spinlock_t		lock;		/* protect host private data */
 	unsigned long		last_req_ts;
diff --git a/drivers/mmc/host/tmio_mmc_pio.c b/drivers/mmc/host/tmio_mmc_pio.c
index e573a15..2345177 100644
--- a/drivers/mmc/host/tmio_mmc_pio.c
+++ b/drivers/mmc/host/tmio_mmc_pio.c
@@ -149,7 +149,8 @@ static void tmio_mmc_enable_sdio_irq(struct mmc_host *mmc, int enable)
 	}
 }
 
-static void tmio_mmc_set_clock(struct tmio_mmc_host *host, int new_clock)
+static void tmio_mmc_set_clock(struct tmio_mmc_host *host,
+				unsigned int new_clock)
 {
 	u32 clk = 0, clock;
 
@@ -767,9 +768,9 @@ fail:
 	pm_runtime_put_autosuspend(mmc_dev(mmc));
 }
 
-static int tmio_mmc_clk_update(struct mmc_host *mmc)
+static int tmio_mmc_clk_update(struct tmio_mmc_host *host)
 {
-	struct tmio_mmc_host *host = mmc_priv(mmc);
+	struct mmc_host *mmc = host->mmc;
 	struct tmio_mmc_data *pdata = host->pdata;
 	int ret;
 
@@ -911,6 +912,8 @@ static void tmio_mmc_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 			ios->clock, ios->power_mode);
 	host->mrq = NULL;
 
+	host->clk_cache = ios->clock;
+
 	mutex_unlock(&host->ios_lock);
 
 	pm_runtime_mark_last_busy(mmc_dev(mmc));
@@ -1036,7 +1039,7 @@ int tmio_mmc_host_probe(struct tmio_mmc_host **host,
 				  mmc->caps & MMC_CAP_NONREMOVABLE ||
 				  mmc->slot.cd_irq >= 0);
 
-	if (tmio_mmc_clk_update(mmc) < 0) {
+	if (tmio_mmc_clk_update(_host) < 0) {
 		mmc->f_max = pdata->hclk;
 		mmc->f_min = mmc->f_max / 512;
 	}
@@ -1162,6 +1165,15 @@ EXPORT_SYMBOL(tmio_mmc_host_resume);
 #ifdef CONFIG_PM_RUNTIME
 int tmio_mmc_host_runtime_suspend(struct device *dev)
 {
+	struct mmc_host *mmc = dev_get_drvdata(dev);
+	struct tmio_mmc_host *host = mmc_priv(mmc);
+
+	if (host->clk_cache)
+		tmio_mmc_clk_stop(host);
+
+	if (host->pdata->clk_disable)
+		host->pdata->clk_disable(host->pdev);
+
 	return 0;
 }
 EXPORT_SYMBOL(tmio_mmc_host_runtime_suspend);
@@ -1171,6 +1183,14 @@ int tmio_mmc_host_runtime_resume(struct device *dev)
 	struct mmc_host *mmc = dev_get_drvdata(dev);
 	struct tmio_mmc_host *host = mmc_priv(mmc);
 
+	tmio_mmc_reset(host);
+	tmio_mmc_clk_update(host);
+
+	if (host->clk_cache) {
+		tmio_mmc_set_clock(host, host->clk_cache);
+		tmio_mmc_clk_start(host);
+	}
+
 	tmio_mmc_enable_dma(host, true);
 
 	return 0;
-- 
1.9.1

