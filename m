Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655AbaGKQBj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 12:01:39 -0400
Received: from baptiste.telenet-ops.be ([195.130.132.51]:52986 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584AbaGKQBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 12:01:25 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Mark Brown <broonie@kernel.org>
Cc: Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        linux-spi@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH v2 2/2] spi: sh-msiof: Handle dmaengine_prep_slave_single() failures gracefully
Date: Fri, 11 Jul 2014 18:01:17 +0200
Message-Id: <1405094477-14192-2-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1405094477-14192-1-git-send-email-geert+renesas@glider.be>
References: <1405094477-14192-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As typically a shmobile SoC has less DMA channels than devices that can use
DMA, we may want to prioritize access to the DMA channels in the future.
This means that dmaengine_prep_slave_single() may start failing
arbitrarily.

Handle dmaengine_prep_slave_single() failures gracefully by falling back to
PIO. This requires moving DMA-specific configuration of the MSIOF device
after the call(s) to dmaengine_prep_slave_single().

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
v2:
  - Add Acked-by
---
 drivers/spi/spi-sh-msiof.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/spi/spi-sh-msiof.c b/drivers/spi/spi-sh-msiof.c
index 6f449b24704a..2a4354dcd661 100644
--- a/drivers/spi/spi-sh-msiof.c
+++ b/drivers/spi/spi-sh-msiof.c
@@ -636,12 +636,6 @@ static int sh_msiof_dma_once(struct sh_msiof_spi_priv *p, const void *tx,
 	dma_cookie_t cookie;
 	int ret;
 
-	/* 1 stage FIFO watermarks for DMA */
-	sh_msiof_write(p, FCTR, FCTR_TFWM_1 | FCTR_RFWM_1);
-
-	/* setup msiof transfer mode registers (32-bit words) */
-	sh_msiof_spi_set_mode_regs(p, tx, rx, 32, len / 4);
-
 	if (tx) {
 		ier_bits |= IER_TDREQE | IER_TDMAE;
 		dma_sync_single_for_device(p->master->dma_tx->device->dev,
@@ -650,7 +644,7 @@ static int sh_msiof_dma_once(struct sh_msiof_spi_priv *p, const void *tx,
 					p->tx_dma_addr, len, DMA_TO_DEVICE,
 					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
 		if (!desc_tx)
-			return -EIO;
+			return -EAGAIN;
 	}
 
 	if (rx) {
@@ -659,8 +653,15 @@ static int sh_msiof_dma_once(struct sh_msiof_spi_priv *p, const void *tx,
 					p->rx_dma_addr, len, DMA_FROM_DEVICE,
 					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
 		if (!desc_rx)
-			return -EIO;
+			return -EAGAIN;
 	}
+
+	/* 1 stage FIFO watermarks for DMA */
+	sh_msiof_write(p, FCTR, FCTR_TFWM_1 | FCTR_RFWM_1);
+
+	/* setup msiof transfer mode registers (32-bit words) */
+	sh_msiof_spi_set_mode_regs(p, tx, rx, 32, len / 4);
+
 	sh_msiof_write(p, IER, ier_bits);
 
 	reinit_completion(&p->done);
@@ -823,6 +824,12 @@ static int sh_msiof_transfer_one(struct spi_master *master,
 			copy32(p->tx_dma_page, tx_buf, l / 4);
 
 		ret = sh_msiof_dma_once(p, tx_buf, rx_buf, l);
+		if (ret == -EAGAIN) {
+			pr_warn_once("%s %s: DMA not available, falling back to PIO\n",
+				     dev_driver_string(&p->pdev->dev),
+				     dev_name(&p->pdev->dev));
+			break;
+		}
 		if (ret)
 			return ret;
 
-- 
1.9.1

