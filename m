Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965096Ab3DJWtw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 18:49:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56491 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965050Ab3DJWtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:49:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Girish K S <ks.giri@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 03/29] spi/s3c64xx: modified error interrupt handling and init
Date: Wed, 10 Apr 2013 15:49:21 -0700
Message-Id: <20130410224804.429394648@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130410224804.061806042@linuxfoundation.org>
References: <20130410224804.061806042@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Girish K S <girishks2000@gmail.com>

commit 375981f2e14868be16cafbffd34a4f16a6ee01c6 upstream.

The status of the interrupt is available in the status register,
so reading the clear pending register and writing back the same
value will not actually clear the pending interrupts. This patch
modifies the interrupt handler to read the status register and
clear the corresponding pending bit in the clear pending register.

Modified the hwInit function to clear all the pending interrupts.

Signed-off-by: Girish K S <ks.giri@samsung.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-s3c64xx.c |   41 +++++++++++++++++++++++++----------------
 1 file changed, 25 insertions(+), 16 deletions(-)

--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -889,25 +889,30 @@ static irqreturn_t s3c64xx_spi_irq(int i
 {
 	struct s3c64xx_spi_driver_data *sdd = data;
 	struct spi_master *spi = sdd->master;
-	unsigned int val;
-
-	val = readl(sdd->regs + S3C64XX_SPI_PENDING_CLR);
-
-	val &= S3C64XX_SPI_PND_RX_OVERRUN_CLR |
-		S3C64XX_SPI_PND_RX_UNDERRUN_CLR |
-		S3C64XX_SPI_PND_TX_OVERRUN_CLR |
-		S3C64XX_SPI_PND_TX_UNDERRUN_CLR;
+	unsigned int val, clr = 0;
 
-	writel(val, sdd->regs + S3C64XX_SPI_PENDING_CLR);
+	val = readl(sdd->regs + S3C64XX_SPI_STATUS);
 
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
@@ -931,9 +936,13 @@ static void s3c64xx_spi_hwinit(struct s3
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
 


