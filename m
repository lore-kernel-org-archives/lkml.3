Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595AbaH2Gwd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 02:52:33 -0400
Received: from smtp02.online.nl ([194.134.41.32]:41417 "EHLO smtp02.online.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321AbaH2Gwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 02:52:31 -0400
X-Greylist: delayed 649 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Aug 2014 02:52:31 EDT
From: Mike Looijmans <mike.looijmans@topic.nl>
To: linux-mmc@vger.kernel.org
Cc: cjb@laptop.org, ulf.hansson@linaro.org, linux-kernel@vger.kernel.org,
        Mike Looijmans <mike.looijmans@topic.nl>
Subject: [PATCH] davinci-mmc: Use IRQ to detect "card not busy" status change
Date: Fri, 29 Aug 2014 08:41:36 +0200
Message-Id: <1409294496-4220-1-git-send-email-mike.looijmans@topic.nl>
X-Mailer: git-send-email 1.7.9.5
X-Online-Scanned: by Cloudmark authority (on smtp02.online.nl)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The davinci-mmc driver uses a busy wait loop to wait for the card to
become ready (BUSY signal). The MMC card uses this to signal the
controller that it's busy writing and cannot handle new requests yet.
This loop often takes 100k cycles and 10ms to complete.

The controller can raise an interrupt when the BUSY signal is deasserted,
so the routine has been adapted to trigger an interrupt and wait for it
using a wait_event_timeout instead of a busy wait loop.

This reduces the CPU usage of the mmcqd process drastically, from 35% to
2% when writing to SD. No noticable change in performance or reliability.

Tested on a custom board with an OMAP-L138 CPU. Patch originally applied
to a 2.6.37 kernel and ported to 3.14.

Signed-off-by: Mike Looijmans <mike.looijmans@topic.nl>
---
 drivers/mmc/host/davinci_mmc.c |   52 +++++++++++++++++++++++++---------------
 1 file changed, 33 insertions(+), 19 deletions(-)

diff --git a/drivers/mmc/host/davinci_mmc.c b/drivers/mmc/host/davinci_mmc.c
index d615374..50458f4 100644
--- a/drivers/mmc/host/davinci_mmc.c
+++ b/drivers/mmc/host/davinci_mmc.c
@@ -223,6 +223,7 @@ struct mmc_davinci_host {
 #ifdef CONFIG_CPU_FREQ
 	struct notifier_block	freq_transition;
 #endif
+	wait_queue_head_t 	wait_while_busy_queue
 };
 
 static irqreturn_t mmc_davinci_irq(int irq, void *dev_id);
@@ -628,23 +629,28 @@ mmc_davinci_prepare_data(struct mmc_davinci_host *host, struct mmc_request *req)
 static void mmc_davinci_request(struct mmc_host *mmc, struct mmc_request *req)
 {
 	struct mmc_davinci_host *host = mmc_priv(mmc);
-	unsigned long timeout = jiffies + msecs_to_jiffies(900);
-	u32 mmcst1 = 0;
+	unsigned int remaining;
 
 	/* Card may still be sending BUSY after a previous operation,
 	 * typically some kind of write.  If so, we can't proceed yet.
 	 */
-	while (time_before(jiffies, timeout)) {
-		mmcst1  = readl(host->base + DAVINCI_MMCST1);
-		if (!(mmcst1 & MMCST1_BUSY))
-			break;
-		cpu_relax();
-	}
-	if (mmcst1 & MMCST1_BUSY) {
-		dev_err(mmc_dev(host->mmc), "still BUSY? bad ... \n");
-		req->cmd->error = -ETIMEDOUT;
-		mmc_request_done(mmc, req);
-		return;
+	if (readl(host->base + DAVINCI_MMCST1) & MMCST1_BUSY) {
+		/* Arm BSYDNE interrupt and wait for it */
+		writel(MMCST0_BSYDNE, host->base + DAVINCI_MMCIM);
+		remaining = wait_event_timeout(
+				host->wait_while_busy_queue,
+				((readl(host->base + DAVINCI_MMCST1) & MMCST1_BUSY) == 0),
+				msecs_to_jiffies(900));
+		writel(0, host->base + DAVINCI_MMCIM);
+		if (unlikely(remaining == 0))
+		{
+			if (readl(host->base + DAVINCI_MMCST1) & MMCST1_BUSY) {
+				dev_err(mmc_dev(host->mmc), "Timeout waiting for BSYDNE interrupt.\n");
+				req->cmd->error = -ETIMEDOUT;
+				mmc_request_done(mmc, req);
+				return;
+			}
+		}
 	}
 
 	host->do_dma = 0;
@@ -914,18 +920,21 @@ static irqreturn_t mmc_davinci_irq(int irq, void *dev_id)
 	int end_transfer = 0;
 	struct mmc_data *data = host->data;
 
+	status = readl(host->base + DAVINCI_MMCST0);
+	qstatus = status;
+
 	if (host->cmd == NULL && host->data == NULL) {
-		status = readl(host->base + DAVINCI_MMCST0);
-		dev_dbg(mmc_dev(host->mmc),
-			"Spurious interrupt 0x%04x\n", status);
+		/* We may have been waiting for the busy-done signal */
+		if (qstatus & MMCST0_BSYDNE) {
+			wake_up(&host->wait_while_busy_queue);
+			return IRQ_HANDLED;
+		}
+		dev_dbg(mmc_dev(host->mmc), "Spurious interrupt %#x\n", status);
 		/* Disable the interrupt from mmcsd */
 		writel(0, host->base + DAVINCI_MMCIM);
 		return IRQ_NONE;
 	}
 
-	status = readl(host->base + DAVINCI_MMCST0);
-	qstatus = status;
-
 	/* handle FIFO first when using PIO for data.
 	 * bytes_left will decrease to zero as I/O progress and status will
 	 * read zero over iteration because this controller status
@@ -1044,6 +1053,10 @@ static irqreturn_t mmc_davinci_irq(int irq, void *dev_id)
 		end_command = (int) host->cmd;
 	}
 
+	if (qstatus & MMCST0_BSYDNE) {
+		wake_up(&host->wait_while_busy_queue);
+	}
+
 	if (end_command)
 		mmc_davinci_cmd_done(host, host->cmd);
 	if (end_transfer)
@@ -1261,6 +1274,7 @@ static int __init davinci_mmcsd_probe(struct platform_device *pdev)
 
 	host = mmc_priv(mmc);
 	host->mmc = mmc;	/* Important */
+	init_waitqueue_head(&host->wait_while_busy_queue);
 
 	r = platform_get_resource(pdev, IORESOURCE_DMA, 0);
 	if (!r)
-- 
1.7.9.5

