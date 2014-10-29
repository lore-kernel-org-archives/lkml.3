Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443AbaJ2CTZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 22:19:25 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:41164 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbaJ2CTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 22:19:23 -0400
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <ulf.hansson@linaro.org>, <chris@printf.net>
CC: <khilman@kernel.org>, <nicolas.ferre@atmel.com>,
        <ludovic.desroches@atmel.com>, <linux-mmc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <wenyou.yang@atmel.com>
Subject: [PATCH] mmc: atmel-mci: add pm runtime support
Date: Wed, 29 Oct 2014 10:15:57 +0800
Message-ID: <1414548958-10537-1-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
---
 drivers/mmc/host/atmel-mci.c |  116 ++++++++++++++++++++++++++++++++++--------
 1 file changed, 94 insertions(+), 22 deletions(-)

diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index 0b9ddf8..e9d32d0 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -37,6 +37,8 @@
 
 #include <linux/atmel-mci.h>
 #include <linux/atmel_pdc.h>
+#include <linux/pm.h>
+#include <linux/pm_runtime.h>
 
 #include <asm/cacheflush.h>
 #include <asm/io.h>
@@ -44,6 +46,8 @@
 
 #include "atmel-mci-regs.h"
 
+#define AUTOSUSPEND_DELAY	50
+
 #define ATMCI_DATA_ERROR_FLAGS	(ATMCI_DCRCE | ATMCI_DTOE | ATMCI_OVRE | ATMCI_UNRE)
 #define ATMCI_DMA_THRESHOLD	16
 
@@ -386,20 +390,19 @@ static int atmci_regs_show(struct seq_file *s, void *v)
 	if (!buf)
 		return -ENOMEM;
 
+	pm_runtime_get_sync(&host->pdev->dev);
+
 	/*
 	 * Grab a more or less consistent snapshot. Note that we're
 	 * not disabling interrupts, so IMR and SR may not be
 	 * consistent.
 	 */
-	ret = clk_prepare_enable(host->mck);
-	if (ret)
-		goto out;
-
 	spin_lock_bh(&host->lock);
 	memcpy_fromio(buf, host->regs, ATMCI_REGS_SIZE);
 	spin_unlock_bh(&host->lock);
 
-	clk_disable_unprepare(host->mck);
+	pm_runtime_mark_last_busy(&host->pdev->dev);
+	pm_runtime_put_autosuspend(&host->pdev->dev);
 
 	seq_printf(s, "MR:\t0x%08x%s%s ",
 			buf[ATMCI_MR / 4],
@@ -449,7 +452,6 @@ static int atmci_regs_show(struct seq_file *s, void *v)
 				val & ATMCI_CFG_LSYNC ? " LSYNC" : "");
 	}
 
-out:
 	kfree(buf);
 
 	return ret;
@@ -1252,6 +1254,8 @@ static void atmci_request(struct mmc_host *mmc, struct mmc_request *mrq)
 	WARN_ON(slot->mrq);
 	dev_dbg(&host->pdev->dev, "MRQ: cmd %u\n", mrq->cmd->opcode);
 
+	pm_runtime_get_sync(&host->pdev->dev);
+
 	/*
 	 * We may "know" the card is gone even though there's still an
 	 * electrical connection. If so, we really need to communicate
@@ -1281,7 +1285,8 @@ static void atmci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 	struct atmel_mci_slot	*slot = mmc_priv(mmc);
 	struct atmel_mci	*host = slot->host;
 	unsigned int		i;
-	bool			unprepare_clk;
+
+	pm_runtime_get_sync(&host->pdev->dev);
 
 	slot->sdc_reg &= ~ATMCI_SDCBUS_MASK;
 	switch (ios->bus_width) {
@@ -1297,13 +1302,8 @@ static void atmci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 		unsigned int clock_min = ~0U;
 		u32 clkdiv;
 
-		clk_prepare(host->mck);
-		unprepare_clk = true;
-
 		spin_lock_bh(&host->lock);
 		if (!host->mode_reg) {
-			clk_enable(host->mck);
-			unprepare_clk = false;
 			atmci_writel(host, ATMCI_CR, ATMCI_CR_SWRST);
 			atmci_writel(host, ATMCI_CR, ATMCI_CR_MCIEN);
 			if (host->caps.has_cfg_reg)
@@ -1371,8 +1371,6 @@ static void atmci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 	} else {
 		bool any_slot_active = false;
 
-		unprepare_clk = false;
-
 		spin_lock_bh(&host->lock);
 		slot->clock = 0;
 		for (i = 0; i < ATMCI_MAX_NR_SLOTS; i++) {
@@ -1385,17 +1383,12 @@ static void atmci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 			atmci_writel(host, ATMCI_CR, ATMCI_CR_MCIDIS);
 			if (host->mode_reg) {
 				atmci_readl(host, ATMCI_MR);
-				clk_disable(host->mck);
-				unprepare_clk = true;
 			}
 			host->mode_reg = 0;
 		}
 		spin_unlock_bh(&host->lock);
 	}
 
-	if (unprepare_clk)
-		clk_unprepare(host->mck);
-
 	switch (ios->power_mode) {
 	case MMC_POWER_OFF:
 		if (!IS_ERR(mmc->supply.vmmc))
@@ -1421,6 +1414,9 @@ static void atmci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 		 */
 		break;
 	}
+
+	pm_runtime_mark_last_busy(&host->pdev->dev);
+	pm_runtime_put_autosuspend(&host->pdev->dev);
 }
 
 static int atmci_get_ro(struct mmc_host *mmc)
@@ -1512,6 +1508,9 @@ static void atmci_request_end(struct atmel_mci *host, struct mmc_request *mrq)
 	spin_unlock(&host->lock);
 	mmc_request_done(prev_mmc, mrq);
 	spin_lock(&host->lock);
+
+	pm_runtime_mark_last_busy(&host->pdev->dev);
+	pm_runtime_put_autosuspend(&host->pdev->dev);
 }
 
 static void atmci_command_complete(struct atmel_mci *host,
@@ -2417,7 +2416,6 @@ static int __init atmci_probe(struct platform_device *pdev)
 
 	atmci_writel(host, ATMCI_CR, ATMCI_CR_SWRST);
 	host->bus_hz = clk_get_rate(host->mck);
-	clk_disable_unprepare(host->mck);
 
 	host->mapbase = regs->start;
 
@@ -2449,6 +2447,12 @@ static int __init atmci_probe(struct platform_device *pdev)
 
 	setup_timer(&host->timer, atmci_timeout_timer, (unsigned long)host);
 
+	pm_runtime_enable(&pdev->dev);
+	pm_runtime_get_sync(&pdev->dev);
+	pm_runtime_set_autosuspend_delay(&pdev->dev, AUTOSUSPEND_DELAY);
+	pm_runtime_use_autosuspend(&pdev->dev);
+	pm_suspend_ignore_children(&pdev->dev, 1);
+
 	/* We need at least one slot to succeed */
 	nr_slots = 0;
 	ret = -ENODEV;
@@ -2491,6 +2495,9 @@ static int __init atmci_probe(struct platform_device *pdev)
 			"Atmel MCI controller at 0x%08lx irq %d, %u slots\n",
 			host->mapbase, irq, nr_slots);
 
+	pm_runtime_mark_last_busy(&host->pdev->dev);
+	pm_runtime_put_autosuspend(&pdev->dev);
+
 	return 0;
 
 err_dma_alloc:
@@ -2499,6 +2506,9 @@ err_dma_alloc:
 			atmci_cleanup_slot(host->slot[i], i);
 	}
 err_init_slot:
+	pm_runtime_put_sync(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
+
 	del_timer_sync(&host->timer);
 	if (host->dma.chan)
 		dma_release_channel(host->dma.chan);
@@ -2511,6 +2521,8 @@ static int __exit atmci_remove(struct platform_device *pdev)
 	struct atmel_mci	*host = platform_get_drvdata(pdev);
 	unsigned int		i;
 
+	pm_runtime_get_sync(&pdev->dev);
+
 	if (host->buffer)
 		dma_free_coherent(&pdev->dev, host->buf_size,
 		                  host->buffer, host->buf_phys_addr);
@@ -2520,11 +2532,9 @@ static int __exit atmci_remove(struct platform_device *pdev)
 			atmci_cleanup_slot(host->slot[i], i);
 	}
 
-	clk_prepare_enable(host->mck);
 	atmci_writel(host, ATMCI_IDR, ~0UL);
 	atmci_writel(host, ATMCI_CR, ATMCI_CR_MCIDIS);
 	atmci_readl(host, ATMCI_SR);
-	clk_disable_unprepare(host->mck);
 
 	del_timer_sync(&host->timer);
 	if (host->dma.chan)
@@ -2532,14 +2542,76 @@ static int __exit atmci_remove(struct platform_device *pdev)
 
 	free_irq(platform_get_irq(pdev, 0), host);
 
+	pm_runtime_put_sync(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
+
+	clk_disable_unprepare(host->mck);
+
 	return 0;
 }
 
+#ifdef CONFIG_PM
+static int atmci_suspend(struct device *dev)
+{
+	struct atmel_mci *host = dev_get_drvdata(dev);
+
+	pm_runtime_get_sync(dev);
+
+	clk_disable_unprepare(host->mck);
+
+	pm_runtime_mark_last_busy(dev);
+	pm_runtime_put_autosuspend(dev);
+
+	return 0;
+}
+
+static int atmci_resume(struct device *dev)
+{
+	struct atmel_mci *host = dev_get_drvdata(dev);
+	int ret;
+
+	pm_runtime_get_sync(dev);
+
+	ret = clk_prepare_enable(host->mck);
+
+	pm_runtime_mark_last_busy(dev);
+	pm_runtime_put_autosuspend(dev);
+
+	return ret;
+}
+
+static int atmci_runtime_suspend(struct device *dev)
+{
+	struct atmel_mci *host = dev_get_drvdata(dev);
+
+	clk_disable_unprepare(host->mck);
+
+	return 0;
+}
+
+static int atmci_runtime_resume(struct device *dev)
+{
+	struct atmel_mci *host = dev_get_drvdata(dev);
+
+	return clk_prepare_enable(host->mck);
+}
+
+static const struct dev_pm_ops atmci_dev_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(atmci_suspend, atmci_resume)
+	SET_RUNTIME_PM_OPS(atmci_runtime_suspend, atmci_runtime_resume, NULL)
+};
+
+#define ATMCI_PM_OPS	(&atmci_dev_pm_ops)
+#else
+#define ATMCI_PM_OPS	NULL
+#endif
+
 static struct platform_driver atmci_driver = {
 	.remove		= __exit_p(atmci_remove),
 	.driver		= {
 		.name		= "atmel_mci",
 		.of_match_table	= of_match_ptr(atmci_dt_ids),
+		.pm		= ATMCI_PM_OPS,
 	},
 };
 
-- 
1.7.9.5

