Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751628Ab3EJKFT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 06:05:19 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:19686 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab3EJKFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 06:05:18 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-mmc@vger.kernel.org>, Chris Ball <cjb@laptop.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: [PATCH] mmc: atmel-mci: convert to dma_request_slave_channel_compat()
Date: Fri, 10 May 2013 12:05:14 +0200
Message-ID: <1368180314-13665-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <517F7B6F.4070907@atmel.com>
References: <517F7B6F.4070907@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ludovic Desroches <ludovic.desroches@atmel.com>

Use generic DMA DT helper. Platforms booting with or without DT populated are
both supported.

Signed-off-by: Ludovic Desroches <ludovic.desroches@atmel.com>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
Hi Chris,

This patch is part of a series by Ludovic and is adding the generic slave
DMA request channel function, as we now have the support for DMA bindings.

This is the only patch of the series that should go through your tree. And it
seems that my little reminder didn't catch your attention in time for 3.10 merge
window but I still hope that we can make it for 3.10-final... It is also true
that we didn't put you in copy of the original message and that the subject
line was somehow malformed ;-)

Here is the Linux arm kernel patchwork reference of previous discussion:
https://patchwork.kernel.org/patch/2463641/

Thanks, best regards,

 drivers/mmc/host/atmel-mci.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index e75774f..aca59d9 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -2230,10 +2230,15 @@ static void __exit atmci_cleanup_slot(struct atmel_mci_slot *slot,
 	mmc_free_host(slot->mmc);
 }
 
-static bool atmci_filter(struct dma_chan *chan, void *slave)
+static bool atmci_filter(struct dma_chan *chan, void *pdata)
 {
-	struct mci_dma_data	*sl = slave;
+	struct mci_platform_data *sl_pdata = pdata;
+	struct mci_dma_data *sl;
 
+	if (!sl_pdata)
+		return false;
+
+	sl = sl_pdata->dma_slave;
 	if (sl && find_slave_dev(sl) == chan->device->dev) {
 		chan->private = slave_data_ptr(sl);
 		return true;
@@ -2245,24 +2250,18 @@ static bool atmci_filter(struct dma_chan *chan, void *slave)
 static bool atmci_configure_dma(struct atmel_mci *host)
 {
 	struct mci_platform_data	*pdata;
+	dma_cap_mask_t mask;
 
 	if (host == NULL)
 		return false;
 
 	pdata = host->pdev->dev.platform_data;
 
-	if (!pdata)
-		return false;
+	dma_cap_zero(mask);
+	dma_cap_set(DMA_SLAVE, mask);
 
-	if (pdata->dma_slave && find_slave_dev(pdata->dma_slave)) {
-		dma_cap_mask_t mask;
-
-		/* Try to grab a DMA channel */
-		dma_cap_zero(mask);
-		dma_cap_set(DMA_SLAVE, mask);
-		host->dma.chan =
-			dma_request_channel(mask, atmci_filter, pdata->dma_slave);
-	}
+	host->dma.chan = dma_request_slave_channel_compat(mask, atmci_filter, pdata,
+							  &host->pdev->dev, "rxtx");
 	if (!host->dma.chan) {
 		dev_warn(&host->pdev->dev, "no DMA channel available\n");
 		return false;
-- 
1.8.0

