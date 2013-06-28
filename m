Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165Ab3F1SnO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 14:43:14 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.206]:29016 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751930Ab3F1SnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:43:11 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-132.messagelabs.com!1372444989!11557709!1
X-Originating-IP: [216.166.12.180]
X-StarScan-Received: 
X-StarScan-Version: 6.9.9; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/8] spi: spi-ep93xx: use read,write instead of __raw_* variants
Date: Fri, 28 Jun 2013 11:42:36 -0700
User-Agent: KMail/1.9.9
CC: <spi-devel-general@lists.sourceforge.net>, Ryan Mallon <rmallon@gmail.com>,
        <mika.westerberg@iki.fi>, <broonie@kernel.org>,
        <grant.likely@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201306281142.36525.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The memory resource used by this driver is ioremap()'d and the normal
read,write calls can be used instead of the __raw_* variants.

Remove the inline read,write helpers and just do the read,write
directly in the callers.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ryan Mallon <rmallon@gmail.com>
Cc: Mika Westerberg <mika.westerberg@iki.fi>
Cc: Mark Brown <broonie@kernel.org>
Cc: Grant Likely <grant.likely@linaro.org>
---
 drivers/spi/spi-ep93xx.c | 64 +++++++++++++++---------------------------------
 1 file changed, 20 insertions(+), 44 deletions(-)

diff --git a/drivers/spi/spi-ep93xx.c b/drivers/spi/spi-ep93xx.c
index d7bac60..c633cd0 100644
--- a/drivers/spi/spi-ep93xx.c
+++ b/drivers/spi/spi-ep93xx.c
@@ -158,30 +158,6 @@ struct ep93xx_spi_chip {
 /* converts bits per word to CR0.DSS value */
 #define bits_per_word_to_dss(bpw)	((bpw) - 1)
 
-static inline void
-ep93xx_spi_write_u8(const struct ep93xx_spi *espi, u16 reg, u8 value)
-{
-	__raw_writeb(value, espi->regs_base + reg);
-}
-
-static inline u8
-ep93xx_spi_read_u8(const struct ep93xx_spi *spi, u16 reg)
-{
-	return __raw_readb(spi->regs_base + reg);
-}
-
-static inline void
-ep93xx_spi_write_u16(const struct ep93xx_spi *espi, u16 reg, u16 value)
-{
-	__raw_writew(value, espi->regs_base + reg);
-}
-
-static inline u16
-ep93xx_spi_read_u16(const struct ep93xx_spi *spi, u16 reg)
-{
-	return __raw_readw(spi->regs_base + reg);
-}
-
 static int ep93xx_spi_enable(const struct ep93xx_spi *espi)
 {
 	u8 regval;
@@ -191,9 +167,9 @@ static int ep93xx_spi_enable(const struct ep93xx_spi *espi)
 	if (err)
 		return err;
 
-	regval = ep93xx_spi_read_u8(espi, SSPCR1);
+	regval = readb(espi->regs_base + SSPCR1);
 	regval |= SSPCR1_SSE;
-	ep93xx_spi_write_u8(espi, SSPCR1, regval);
+	writeb(regval, espi->regs_base + SSPCR1);
 
 	return 0;
 }
@@ -202,9 +178,9 @@ static void ep93xx_spi_disable(const struct ep93xx_spi *espi)
 {
 	u8 regval;
 
-	regval = ep93xx_spi_read_u8(espi, SSPCR1);
+	regval = readb(espi->regs_base + SSPCR1);
 	regval &= ~SSPCR1_SSE;
-	ep93xx_spi_write_u8(espi, SSPCR1, regval);
+	writeb(regval, espi->regs_base + SSPCR1);
 
 	clk_disable(espi->clk);
 }
@@ -213,18 +189,18 @@ static void ep93xx_spi_enable_interrupts(const struct ep93xx_spi *espi)
 {
 	u8 regval;
 
-	regval = ep93xx_spi_read_u8(espi, SSPCR1);
+	regval = readb(espi->regs_base + SSPCR1);
 	regval |= (SSPCR1_RORIE | SSPCR1_TIE | SSPCR1_RIE);
-	ep93xx_spi_write_u8(espi, SSPCR1, regval);
+	writeb(regval, espi->regs_base + SSPCR1);
 }
 
 static void ep93xx_spi_disable_interrupts(const struct ep93xx_spi *espi)
 {
 	u8 regval;
 
-	regval = ep93xx_spi_read_u8(espi, SSPCR1);
+	regval = readb(espi->regs_base + SSPCR1);
 	regval &= ~(SSPCR1_RORIE | SSPCR1_TIE | SSPCR1_RIE);
-	ep93xx_spi_write_u8(espi, SSPCR1, regval);
+	writeb(regval, espi->regs_base + SSPCR1);
 }
 
 /**
@@ -437,8 +413,8 @@ static void ep93xx_spi_chip_setup(const struct ep93xx_spi *espi,
 		chip->spi->mode, chip->div_cpsr, chip->div_scr, chip->dss);
 	dev_dbg(&espi->pdev->dev, "setup: cr0 %#x", cr0);
 
-	ep93xx_spi_write_u8(espi, SSPCPSR, chip->div_cpsr);
-	ep93xx_spi_write_u16(espi, SSPCR0, cr0);
+	writeb(chip->div_cpsr, espi->regs_base + SSPCPSR);
+	writew(cr0, espi->regs_base + SSPCR0);
 }
 
 static inline int bits_per_word(const struct ep93xx_spi *espi)
@@ -456,14 +432,14 @@ static void ep93xx_do_write(struct ep93xx_spi *espi, struct spi_transfer *t)
 
 		if (t->tx_buf)
 			tx_val = ((u16 *)t->tx_buf)[espi->tx];
-		ep93xx_spi_write_u16(espi, SSPDR, tx_val);
+		writew(tx_val, espi->regs_base + SSPDR);
 		espi->tx += sizeof(tx_val);
 	} else {
 		u8 tx_val = 0;
 
 		if (t->tx_buf)
 			tx_val = ((u8 *)t->tx_buf)[espi->tx];
-		ep93xx_spi_write_u8(espi, SSPDR, tx_val);
+		writeb(tx_val, espi->regs_base + SSPDR);
 		espi->tx += sizeof(tx_val);
 	}
 }
@@ -473,14 +449,14 @@ static void ep93xx_do_read(struct ep93xx_spi *espi, struct spi_transfer *t)
 	if (bits_per_word(espi) > 8) {
 		u16 rx_val;
 
-		rx_val = ep93xx_spi_read_u16(espi, SSPDR);
+		rx_val = readw(espi->regs_base + SSPDR);
 		if (t->rx_buf)
 			((u16 *)t->rx_buf)[espi->rx] = rx_val;
 		espi->rx += sizeof(rx_val);
 	} else {
 		u8 rx_val;
 
-		rx_val = ep93xx_spi_read_u8(espi, SSPDR);
+		rx_val = readb(espi->regs_base + SSPDR);
 		if (t->rx_buf)
 			((u8 *)t->rx_buf)[espi->rx] = rx_val;
 		espi->rx += sizeof(rx_val);
@@ -504,7 +480,7 @@ static int ep93xx_spi_read_write(struct ep93xx_spi *espi)
 	struct spi_transfer *t = msg->state;
 
 	/* read as long as RX FIFO has frames in it */
-	while ((ep93xx_spi_read_u8(espi, SSPSR) & SSPSR_RNE)) {
+	while ((readb(espi->regs_base + SSPSR) & SSPSR_RNE)) {
 		ep93xx_do_read(espi, t);
 		espi->fifo_level--;
 	}
@@ -831,14 +807,14 @@ static void ep93xx_spi_process_message(struct ep93xx_spi *espi,
 	 * Just to be sure: flush any data from RX FIFO.
 	 */
 	timeout = jiffies + msecs_to_jiffies(SPI_TIMEOUT);
-	while (ep93xx_spi_read_u16(espi, SSPSR) & SSPSR_RNE) {
+	while (readw(espi->regs_base + SSPSR) & SSPSR_RNE) {
 		if (time_after(jiffies, timeout)) {
 			dev_warn(&espi->pdev->dev,
 				 "timeout while flushing RX FIFO\n");
 			msg->status = -ETIMEDOUT;
 			return;
 		}
-		ep93xx_spi_read_u16(espi, SSPDR);
+		readw(espi->regs_base + SSPDR);
 	}
 
 	/*
@@ -917,7 +893,7 @@ static void ep93xx_spi_work(struct work_struct *work)
 static irqreturn_t ep93xx_spi_interrupt(int irq, void *dev_id)
 {
 	struct ep93xx_spi *espi = dev_id;
-	u8 irq_status = ep93xx_spi_read_u8(espi, SSPIIR);
+	u8 irq_status = readb(espi->regs_base + SSPIIR);
 
 	/*
 	 * If we got ROR (receive overrun) interrupt we know that something is
@@ -925,7 +901,7 @@ static irqreturn_t ep93xx_spi_interrupt(int irq, void *dev_id)
 	 */
 	if (unlikely(irq_status & SSPIIR_RORIS)) {
 		/* clear the overrun interrupt */
-		ep93xx_spi_write_u8(espi, SSPICR, 0);
+		writeb(0, espi->regs_base + SSPICR);
 		dev_warn(&espi->pdev->dev,
 			 "receive overrun, aborting the message\n");
 		espi->current_msg->status = -EIO;
@@ -1111,7 +1087,7 @@ static int ep93xx_spi_probe(struct platform_device *pdev)
 	espi->running = true;
 
 	/* make sure that the hardware is disabled */
-	ep93xx_spi_write_u8(espi, SSPCR1, 0);
+	writeb(0, espi->regs_base + SSPCR1);
 
 	error = spi_register_master(master);
 	if (error) {
-- 
1.8.1.4

