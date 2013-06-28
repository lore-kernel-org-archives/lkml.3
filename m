Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482Ab3F1Soj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 14:44:39 -0400
Received: from mail1.bemta7.messagelabs.com ([216.82.254.109]:24255 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752407Ab3F1Soi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:44:38 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-209.messagelabs.com!1372445076!6021990!1
X-Originating-IP: [216.166.12.180]
X-StarScan-Received: 
X-StarScan-Version: 6.9.9; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/8] spi: spi-ep93xx: remove bits_per_word() helper
Date: Fri, 28 Jun 2013 11:44:04 -0700
User-Agent: KMail/1.9.9
CC: <spi-devel-general@lists.sourceforge.net>, Ryan Mallon <rmallon@gmail.com>,
        <mika.westerberg@iki.fi>, <broonie@kernel.org>,
        <grant.likely@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201306281144.04549.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This inline helper function is only used to determine the bus width
of the current transfer (8 or 16 bit). Add a bool flag to the private
structure and set it appropriately for each transfer.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ryan Mallon <rmallon@gmail.com>
Cc: Mika Westerberg <mika.westerberg@iki.fi>
Cc: Mark Brown <broonie@kernel.org>
Cc: Grant Likely <grant.likely@linaro.org>
---
 drivers/spi/spi-ep93xx.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/spi/spi-ep93xx.c b/drivers/spi/spi-ep93xx.c
index bcfd35a..4fab3bb 100644
--- a/drivers/spi/spi-ep93xx.c
+++ b/drivers/spi/spi-ep93xx.c
@@ -116,6 +116,7 @@ struct ep93xx_spi {
 	unsigned long			min_rate;
 	unsigned long			max_rate;
 	bool				running;
+	bool				word_xfer;
 	struct workqueue_struct		*wq;
 	struct work_struct		msg_work;
 	struct completion		wait;
@@ -407,17 +408,9 @@ static void ep93xx_spi_chip_setup(const struct ep93xx_spi *espi,
 	writew(cr0, espi->regs_base + SSPCR0);
 }
 
-static inline int bits_per_word(const struct ep93xx_spi *espi)
-{
-	struct spi_message *msg = espi->current_msg;
-	struct spi_transfer *t = msg->state;
-
-	return t->bits_per_word;
-}
-
 static void ep93xx_do_write(struct ep93xx_spi *espi, struct spi_transfer *t)
 {
-	if (bits_per_word(espi) > 8) {
+	if (espi->word_xfer) {
 		u16 tx_val = 0;
 
 		if (t->tx_buf)
@@ -436,7 +429,7 @@ static void ep93xx_do_write(struct ep93xx_spi *espi, struct spi_transfer *t)
 
 static void ep93xx_do_read(struct ep93xx_spi *espi, struct spi_transfer *t)
 {
-	if (bits_per_word(espi) > 8) {
+	if (espi->word_xfer) {
 		u16 rx_val;
 
 		rx_val = readw(espi->regs_base + SSPDR);
@@ -522,7 +515,7 @@ ep93xx_spi_dma_prepare(struct ep93xx_spi *espi, enum dma_transfer_direction dir)
 	size_t len = t->len;
 	int i, ret, nents;
 
-	if (bits_per_word(espi) > 8)
+	if (espi->word_xfer)
 		buswidth = DMA_SLAVE_BUSWIDTH_2_BYTES;
 	else
 		buswidth = DMA_SLAVE_BUSWIDTH_1_BYTE;
@@ -699,6 +692,7 @@ static void ep93xx_spi_process_transfer(struct ep93xx_spi *espi,
 
 	ep93xx_spi_chip_setup(espi, chip);
 
+	espi->word_xfer = (t->bits_per_word > 8) ? true : false;
 	espi->rx = 0;
 	espi->tx = 0;
 
-- 
1.8.1.4

