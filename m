Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932335AbaHYM0f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 08:26:35 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:44059 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932295AbaHYM0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 08:26:30 -0400
From: Ulf Hansson <ulf.hansson@linaro.org>
To: linux-mmc@vger.kernel.org, Ian Molton <ian.molton@codethink.co.uk>,
        Chris Ball <chris@printf.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux-sh list <linux-sh@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 01/12] mmc: tmio: Keep host active while SDIO IRQ is enabled
Date: Mon, 25 Aug 2014 14:25:53 +0200
Message-Id: <1408969564-6335-2-git-send-email-ulf.hansson@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408969564-6335-1-git-send-email-ulf.hansson@linaro.org>
References: <1408969564-6335-1-git-send-email-ulf.hansson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The host must be kept active to be able to serve SDIO IRQs, thus let's
prevent it from going inactive while SDIO IRQ is enabled.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/mmc/host/tmio_mmc.h     |  1 +
 drivers/mmc/host/tmio_mmc_pio.c | 19 +++++++++++++++----
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/tmio_mmc.h b/drivers/mmc/host/tmio_mmc.h
index 100ffe0..d6ceb1a 100644
--- a/drivers/mmc/host/tmio_mmc.h
+++ b/drivers/mmc/host/tmio_mmc.h
@@ -101,6 +101,7 @@ struct tmio_mmc_host {
 	struct mutex		ios_lock;	/* protect set_ios() context */
 	bool			native_hotplug;
 	bool			resuming;
+	bool			sdio_irq_enabled;
 };
 
 int tmio_mmc_host_probe(struct tmio_mmc_host **host,
diff --git a/drivers/mmc/host/tmio_mmc_pio.c b/drivers/mmc/host/tmio_mmc_pio.c
index faf0924..5c2e5a3 100644
--- a/drivers/mmc/host/tmio_mmc_pio.c
+++ b/drivers/mmc/host/tmio_mmc_pio.c
@@ -129,15 +129,22 @@ static void tmio_mmc_enable_sdio_irq(struct mmc_host *mmc, int enable)
 {
 	struct tmio_mmc_host *host = mmc_priv(mmc);
 
-	if (enable) {
+	if (enable && !host->sdio_irq_enabled) {
+		/* Keep device active while SDIO irq is enabled */
+		pm_runtime_get_sync(mmc_dev(mmc));
+		host->sdio_irq_enabled = true;
+
 		host->sdio_irq_mask = TMIO_SDIO_MASK_ALL &
 					~TMIO_SDIO_STAT_IOIRQ;
 		sd_ctrl_write16(host, CTL_TRANSACTION_CTL, 0x0001);
 		sd_ctrl_write16(host, CTL_SDIO_IRQ_MASK, host->sdio_irq_mask);
-	} else {
+	} else if (!enable && host->sdio_irq_enabled) {
 		host->sdio_irq_mask = TMIO_SDIO_MASK_ALL;
 		sd_ctrl_write16(host, CTL_SDIO_IRQ_MASK, host->sdio_irq_mask);
 		sd_ctrl_write16(host, CTL_TRANSACTION_CTL, 0x0000);
+
+		host->sdio_irq_enabled = false;
+		pm_runtime_put(mmc_dev(mmc));
 	}
 }
 
@@ -1074,8 +1081,12 @@ int tmio_mmc_host_probe(struct tmio_mmc_host **host,
 
 	_host->sdcard_irq_mask &= ~irq_mask;
 
-	if (pdata->flags & TMIO_MMC_SDIO_IRQ)
-		tmio_mmc_enable_sdio_irq(mmc, 0);
+	_host->sdio_irq_enabled = false;
+	if (pdata->flags & TMIO_MMC_SDIO_IRQ) {
+		_host->sdio_irq_mask = TMIO_SDIO_MASK_ALL;
+		sd_ctrl_write16(_host, CTL_SDIO_IRQ_MASK, _host->sdio_irq_mask);
+		sd_ctrl_write16(_host, CTL_TRANSACTION_CTL, 0x0000);
+	}
 
 	spin_lock_init(&_host->lock);
 	mutex_init(&_host->ios_lock);
-- 
1.9.1

