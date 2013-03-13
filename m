Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932503Ab3CMGoN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 02:44:13 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:48637 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932228Ab3CMGn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 02:43:57 -0400
From: Girish K S <girishks2000@gmail.com>
To: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: grant.likely@secretlab.ca, t.figa@samsung.com,
        broonie@opensource.wolfsonmicro.com,
        Girish K S <girishks2000@gmail.com>
Subject: [PATCH V3 1/5] spi: s3c64xx: modified error interrupt handling and init
Date: Wed, 13 Mar 2013 12:13:30 +0530
Message-Id: <1363157014-9615-2-git-send-email-ks.giri@samsung.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1363157014-9615-1-git-send-email-ks.giri@samsung.com>
References: <1363157014-9615-1-git-send-email-ks.giri@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Girish K S <girishks2000@gmail.com>

The status of the interrupt is available in the status register,
so reading the clear pending register and writing back the same
value will not actually clear the pending interrupts. This patch
modifies the interrupt handler to read the status register and
clear the corresponding pending bit in the clear pending register.

Modified the hwInit function to clear all the pending interrupts.

Signed-off-by: Girish K S <ks.giri@samsung.com>
---
 drivers/spi/spi-s3c64xx.c | 41 +++++++++++++++++++++++++----------------
 1 file changed, 25 insertions(+), 16 deletions(-)

diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
index e862ab8..4188b2f 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -994,25 +994,30 @@ static irqreturn_t s3c64xx_spi_irq(int irq, void *data)
 {
 	struct s3c64xx_spi_driver_data *sdd = data;
 	struct spi_master *spi = sdd->master;
-	unsigned int val;
+	unsigned int val, clr = 0;
 
-	val = readl(sdd->regs + S3C64XX_SPI_PENDING_CLR);
+	val = readl(sdd->regs + S3C64XX_SPI_STATUS);
 
-	val &= S3C64XX_SPI_PND_RX_OVERRUN_CLR |
-		S3C64XX_SPI_PND_RX_UNDERRUN_CLR |
-		S3C64XX_SPI_PND_TX_OVERRUN_CLR |
-		S3C64XX_SPI_PND_TX_UNDERRUN_CLR;
-
-	writel(val, sdd->regs + S3C64XX_SPI_PENDING_CLR);
-
-	if (val & S3C64XX_SPI_PND_RX_OVERRUN_CLR)
+	if (val & S3C64XX_SPI_ST_RX_OVERRUN_ERR) {
+		clr = S3C64XX_SPI_PND_RX_OVERRUN_CLR;
 		dev_err(&spi->dev, "RX overrun\n");
-	if (val & S3C64XX_SPI_PND_RX_UNDERRUN_CLR)
+	}
+	if (val & S3C64XX_SPI_ST_RX_UNDERRUN_ERR) {
+		clr |= S3C64XX_SPI_PND_RX_UNDERRUN_CLR;
 		dev_err(&spi->dev, "RX underrun\n");
-	if (val & S3C64XX_SPI_PND_TX_OVERRUN_CLR)
+	}
+	if (val & S3C64XX_SPI_ST_TX_OVERRUN_ERR) {
+		clr |= S3C64XX_SPI_PND_TX_OVERRUN_CLR;
 		dev_err(&spi->dev, "TX overrun\n");
-	if (val & S3C64XX_SPI_PND_TX_UNDERRUN_CLR)
+	}
+	if (val & S3C64XX_SPI_ST_TX_UNDERRUN_ERR) {
+		clr |= S3C64XX_SPI_PND_TX_UNDERRUN_CLR;
 		dev_err(&spi->dev, "TX underrun\n");
+	}
+
+	/* Clear the pending irq by setting and then clearing it */
+	writel(clr, sdd->regs + S3C64XX_SPI_PENDING_CLR);
+	writel(0, sdd->regs + S3C64XX_SPI_PENDING_CLR);
 
 	return IRQ_HANDLED;
 }
@@ -1036,9 +1041,13 @@ static void s3c64xx_spi_hwinit(struct s3c64xx_spi_driver_data *sdd, int channel)
 	writel(0, regs + S3C64XX_SPI_MODE_CFG);
 	writel(0, regs + S3C64XX_SPI_PACKET_CNT);
 
-	/* Clear any irq pending bits */
-	writel(readl(regs + S3C64XX_SPI_PENDING_CLR),
-				regs + S3C64XX_SPI_PENDING_CLR);
+	/* Clear any irq pending bits, should set and clear the bits */
+	val = S3C64XX_SPI_PND_RX_OVERRUN_CLR |
+		S3C64XX_SPI_PND_RX_UNDERRUN_CLR |
+		S3C64XX_SPI_PND_TX_OVERRUN_CLR |
+		S3C64XX_SPI_PND_TX_UNDERRUN_CLR;
+	writel(val, regs + S3C64XX_SPI_PENDING_CLR);
+	writel(0, regs + S3C64XX_SPI_PENDING_CLR);
 
 	writel(0, regs + S3C64XX_SPI_SWAP_CFG);
 
-- 
1.8.0

