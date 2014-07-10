Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639AbaGJN3j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 09:29:39 -0400
Received: from albert.telenet-ops.be ([195.130.137.90]:52086 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbaGJN3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 09:29:36 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 2/2] [RFC] spi: core: Pass correct device to dma_map_sg()
Date: Thu, 10 Jul 2014 15:29:33 +0200
Message-Id: <1404998973-19425-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404998973-19425-1-git-send-email-geert@linux-m68k.org>
References: <1404998973-19425-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

According to Documentation/dmaengine.txt, scatterlists must be mapped
using the DMA struct device.

However, "dma_chan.dev->device" is the sysfs class device's device.
Use "dma_chan.device->dev" instead, which is the real DMA device's device.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
It seems very few drivers pass the right device.  Most drivers pass the
platform device's device, cfr. Documentation/DMA-API-HOWTO.txt, which
suggests to use "&my_dev->dev".

Question: If dma_map_*() is called with the DMA struct device, I assume
          dma_sync_() should also be called with the same DMA struct
	  device?
---
 drivers/spi/spi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 3aac0e885cd9..eef58cec2210 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -647,8 +647,8 @@ static int __spi_map_msg(struct spi_master *master, struct spi_message *msg)
 	if (!master->can_dma)
 		return 0;
 
-	tx_dev = &master->dma_tx->dev->device;
-	rx_dev = &master->dma_rx->dev->device;
+	tx_dev = master->dma_tx->device->dev;
+	rx_dev = master->dma_rx->device->dev;
 
 	list_for_each_entry(xfer, &msg->transfers, transfer_list) {
 		if (!master->can_dma(master, msg->spi, xfer))
@@ -687,8 +687,8 @@ static int spi_unmap_msg(struct spi_master *master, struct spi_message *msg)
 	if (!master->cur_msg_mapped || !master->can_dma)
 		return 0;
 
-	tx_dev = &master->dma_tx->dev->device;
-	rx_dev = &master->dma_rx->dev->device;
+	tx_dev = master->dma_tx->device->dev;
+	rx_dev = master->dma_rx->device->dev;
 
 	list_for_each_entry(xfer, &msg->transfers, transfer_list) {
 		if (!master->can_dma(master, msg->spi, xfer))
-- 
1.9.1

