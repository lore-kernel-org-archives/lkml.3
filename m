Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492AbaIIMTH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 08:19:07 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37288 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585AbaIIMTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 08:19:04 -0400
Date: Tue, 9 Sep 2014 14:19:02 +0200
From: Pavel Machek <pavel@ucw.cz>
To: tgih.jun@samsung.com, jh80.chung@samsung.com, chris@printf.net,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: marex@denx.de
Subject: [PATCH] fix mmc hang during boot on socfpga
Message-ID: <20140909121902.GA22965@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Without this patch, boot hangs when trying to mount root filesystem on
socfpga platform in about 50% cases.

Signed-off-by: Pavel Machek <pavel@denx.de>

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index 8f216ed..739ba78 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -42,8 +42,8 @@
 
 /* Common flag combinations */
 #define DW_MCI_DATA_ERROR_FLAGS	(SDMMC_INT_DRTO | SDMMC_INT_DCRC | \
-				 SDMMC_INT_HTO | SDMMC_INT_SBE  | \
-				 SDMMC_INT_EBE)
+				 SDMMC_INT_HTO | SDMMC_INT_FRUN | \
+				 SDMMC_INT_SBE  | SDMMC_INT_EBE)
 #define DW_MCI_CMD_ERROR_FLAGS	(SDMMC_INT_RTO | SDMMC_INT_RCRC | \
 				 SDMMC_INT_RESP_ERR)
 #define DW_MCI_ERROR_FLAGS	(DW_MCI_DATA_ERROR_FLAGS | \
@@ -1302,7 +1302,8 @@ static void dw_mci_tasklet_func(unsigned long priv)
 			if (test_and_clear_bit(EVENT_DATA_ERROR,
 					       &host->pending_events)) {
 				dw_mci_stop_dma(host);
-				send_stop_abort(host, data);
+				if (data->stop)
+					send_stop_abort(host, data);
 				state = STATE_DATA_ERROR;
 				break;
 			}
@@ -1324,6 +1325,11 @@ static void dw_mci_tasklet_func(unsigned long priv)
 			set_bit(EVENT_DATA_COMPLETE, &host->completed_events);
 			err = dw_mci_data_complete(host, data);
 
+			if (!data->stop) {
+				dw_mci_request_end(host, host->mrq);
+				goto unlock;
+			}
+
 			if (!err) {
 				if (!data->stop || mrq->sbc) {
 					if (mrq->sbc && data->stop)
@@ -1872,6 +1878,9 @@ static irqreturn_t dw_mci_interrupt(int irq, void *dev_id)
 			queue_work(host->card_workqueue, &host->card_work);
 		}
 
+		if (pending & SDMMC_INT_HLE)
+			mci_writel(host, RINTSTS, SDMMC_INT_HLE);
+
 		/* Handle SDIO Interrupts */
 		for (i = 0; i < host->num_slots; i++) {
 			struct dw_mci_slot *slot = host->slot[i];
@@ -2361,8 +2370,7 @@ int dw_mci_probe(struct dw_mci *host)
 	}
 
 	if (host->pdata->num_slots > 1) {
-		dev_err(host->dev,
-			"Platform data must supply num_slots.\n");
+		dev_err(host->dev, "Platform data must supply num_slots.\n");
 		return -ENODEV;
 	}
 
@@ -2399,8 +2407,7 @@ int dw_mci_probe(struct dw_mci *host)
 	}
 
 	if (!host->bus_hz) {
-		dev_err(host->dev,
-			"Platform data must supply bus speed\n");
+		dev_err(host->dev, "Platform data must supply bus speed\n");
 		ret = -ENODEV;
 		goto err_clk_ciu;
 	}

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
