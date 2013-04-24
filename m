Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308Ab3DXK6x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 06:58:53 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:57155 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932107Ab3DXK6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 06:58:51 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Chris Ball <cjb@laptop.org>,
        linux-mmc@vger.kernel.org
Subject: [PATCH] mmc: mmci: Allow MMCI to request channels with information acquired from DT
Date: Wed, 24 Apr 2013 11:58:42 +0100
Message-Id: <1366801122-13302-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, if DMA information isn't passed from platform data, then DMA
will not be used. This patch allows DMA information obtained though Device
Tree to be used as well.

Cc: Russell King <linux@arm.linux.org.uk>
Cc: Chris Ball <cjb@laptop.org>
Cc: linux-mmc@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mmc/host/mmci.c |   43 ++++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index 372e921..ecd256b 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -304,10 +304,8 @@ static void mmci_dma_setup(struct mmci_host *host)
 	const char *rxname, *txname;
 	dma_cap_mask_t mask;
 
-	if (!plat || !plat->dma_filter) {
-		dev_info(mmc_dev(host->mmc), "no DMA platform data\n");
-		return;
-	}
+	host->dma_rx_channel = dma_request_slave_channel(dev, "rx");
+	host->dma_tx_channel = dma_request_slave_channel(dev, "tx");
 
 	/* initialize pre request cookie */
 	host->next_data.cookie = 1;
@@ -316,30 +314,33 @@ static void mmci_dma_setup(struct mmci_host *host)
 	dma_cap_zero(mask);
 	dma_cap_set(DMA_SLAVE, mask);
 
-	/*
-	 * If only an RX channel is specified, the driver will
-	 * attempt to use it bidirectionally, however if it is
-	 * is specified but cannot be located, DMA will be disabled.
-	 */
-	if (plat->dma_rx_param) {
-		host->dma_rx_channel = dma_request_channel(mask,
+	if (plat && plat->dma_filter) {
+		if (!host->dma_rx_channel && plat->dma_rx_param) {
+			host->dma_rx_channel = dma_request_channel(mask,
 							   plat->dma_filter,
 							   plat->dma_rx_param);
-		/* E.g if no DMA hardware is present */
-		if (!host->dma_rx_channel)
-			dev_err(mmc_dev(host->mmc), "no RX DMA channel\n");
-	}
+			/* E.g if no DMA hardware is present */
+			if (!host->dma_rx_channel)
+				dev_err(mmc_dev(host->mmc), "no RX DMA channel\n");
+		}
 
-	if (plat->dma_tx_param) {
-		host->dma_tx_channel = dma_request_channel(mask,
+		if (!host->dma_tx_channel && plat->dma_tx_param) {
+			host->dma_tx_channel = dma_request_channel(mask,
 							   plat->dma_filter,
 							   plat->dma_tx_param);
-		if (!host->dma_tx_channel)
-			dev_warn(mmc_dev(host->mmc), "no TX DMA channel\n");
-	} else {
-		host->dma_tx_channel = host->dma_rx_channel;
+			if (!host->dma_tx_channel)
+				dev_warn(mmc_dev(host->mmc), "no TX DMA channel\n");
+		}
 	}
 
+	/*
+	 * If only an RX channel is specified, the driver will
+	 * attempt to use it bidirectionally, however if it is
+	 * is specified but cannot be located, DMA will be disabled.
+	 */
+	if (host->dma_rx_channel && !host->dma_tx_channel)
+		host->dma_tx_channel = host->dma_rx_channel;
+
 	if (host->dma_rx_channel)
 		rxname = dma_chan_name(host->dma_rx_channel);
 	else
-- 
1.7.10.4

