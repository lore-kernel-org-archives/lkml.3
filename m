Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789AbaAXIsy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 03:48:54 -0500
Received: from andre.telenet-ops.be ([195.130.132.53]:38963 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415AbaAXIoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 03:44:17 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH 04/14] spi: rspi: Add rspi_data_{out,in,out_in}() helpers
Date: Fri, 24 Jan 2014 09:43:54 +0100
Message-Id: <1390553044-11860-5-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1390553044-11860-1-git-send-email-geert@linux-m68k.org>
References: <1390553044-11860-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Add helpers rspi_data_{out,in,out_in}() to write, read, or write and
read data to/from the Data Register, taking care of waiting until data
or space is available in the buffers.

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
 drivers/spi/spi-rspi.c |  117 +++++++++++++++++++++++-------------------------
 1 file changed, 56 insertions(+), 61 deletions(-)

diff --git a/drivers/spi/spi-rspi.c b/drivers/spi/spi-rspi.c
index a0bb3c28ae91..4b27513e7204 100644
--- a/drivers/spi/spi-rspi.c
+++ b/drivers/spi/spi-rspi.c
@@ -356,22 +356,51 @@ static int rspi_wait_for_interrupt(struct rspi_data *rspi, u8 wait_mask,
 	return 0;
 }
 
+static int rspi_data_out(struct rspi_data *rspi, u8 data)
+{
+	if (rspi_wait_for_interrupt(rspi, SPSR_SPTEF, SPCR_SPTIE) < 0) {
+		dev_err(&rspi->master->dev, "transmit timeout\n");
+		return -ETIMEDOUT;
+	}
+	rspi_write_data(rspi, data);
+	return 0;
+}
+
+static int rspi_data_in(struct rspi_data *rspi)
+{
+	u8 data;
+
+	if (rspi_wait_for_interrupt(rspi, SPSR_SPRF, SPCR_SPRIE) < 0) {
+		dev_err(&rspi->master->dev, "receive timeout\n");
+		return -ETIMEDOUT;
+	}
+	data = rspi_read_data(rspi);
+	return data;
+}
+
+static int rspi_data_out_in(struct rspi_data *rspi, u8 data)
+{
+	int ret;
+
+	ret = rspi_data_out(rspi, data);
+	if (ret < 0)
+		return ret;
+
+	return rspi_data_in(rspi);
+}
+
 static int rspi_send_pio(struct rspi_data *rspi, struct spi_transfer *t)
 {
-	int remain = t->len;
+	int remain = t->len, ret;
 	const u8 *data = t->tx_buf;
+
 	while (remain > 0) {
 		rspi_write8(rspi, rspi_read8(rspi, RSPI_SPCR) | SPCR_TXMD,
 			    RSPI_SPCR);
 
-		if (rspi_wait_for_interrupt(rspi, SPSR_SPTEF, SPCR_SPTIE) < 0) {
-			dev_err(&rspi->master->dev,
-				"%s: tx empty timeout\n", __func__);
-			return -ETIMEDOUT;
-		}
-
-		rspi_write_data(rspi, *data);
-		data++;
+		ret = rspi_data_out(rspi, *data++);
+		if (ret < 0)
+			return ret;
 		remain--;
 	}
 
@@ -383,28 +412,17 @@ static int rspi_send_pio(struct rspi_data *rspi, struct spi_transfer *t)
 
 static int qspi_send_pio(struct rspi_data *rspi, struct spi_transfer *t)
 {
-	int remain = t->len;
+	int remain = t->len, ret;
 	const u8 *data = t->tx_buf;
 
 	rspi_write8(rspi, SPBFCR_TXRST, QSPI_SPBFCR);
 	rspi_write8(rspi, 0x00, QSPI_SPBFCR);
 
 	while (remain > 0) {
-
-		if (rspi_wait_for_interrupt(rspi, SPSR_SPTEF, SPCR_SPTIE) < 0) {
-			dev_err(&rspi->master->dev,
-				"%s: tx empty timeout\n", __func__);
-			return -ETIMEDOUT;
-		}
-		rspi_write_data(rspi, *data++);
-
-		if (rspi_wait_for_interrupt(rspi, SPSR_SPRF, SPCR_SPRIE) < 0) {
-			dev_err(&rspi->master->dev,
-				"%s: receive timeout\n", __func__);
-			return -ETIMEDOUT;
-		}
-		rspi_read_data(rspi);
-
+		/* dummy read */
+		ret = rspi_data_out_in(rspi, *data++);
+		if (ret < 0)
+			return ret;
 		remain--;
 	}
 
@@ -549,32 +567,20 @@ static void rspi_receive_init(const struct rspi_data *rspi)
 
 static int rspi_receive_pio(struct rspi_data *rspi, struct spi_transfer *t)
 {
-	int remain = t->len;
-	u8 *data;
+	int remain = t->len, ret;
+	u8 *data = t->rx_buf;
 
 	rspi_receive_init(rspi);
 
-	data = t->rx_buf;
 	while (remain > 0) {
 		rspi_write8(rspi, rspi_read8(rspi, RSPI_SPCR) & ~SPCR_TXMD,
 			    RSPI_SPCR);
 
-		if (rspi_wait_for_interrupt(rspi, SPSR_SPTEF, SPCR_SPTIE) < 0) {
-			dev_err(&rspi->master->dev,
-				"%s: tx empty timeout\n", __func__);
-			return -ETIMEDOUT;
-		}
-		/* dummy write for generate clock */
-		rspi_write_data(rspi, DUMMY_DATA);
-
-		if (rspi_wait_for_interrupt(rspi, SPSR_SPRF, SPCR_SPRIE) < 0) {
-			dev_err(&rspi->master->dev,
-				"%s: receive timeout\n", __func__);
-			return -ETIMEDOUT;
-		}
-		*data = rspi_read_data(rspi);
-
-		data++;
+		/* dummy write data for generate clock */
+		ret = rspi_data_out_in(rspi, DUMMY_DATA);
+		if (ret < 0)
+			return ret;
+		*data++ = ret;
 		remain--;
 	}
 
@@ -594,28 +600,17 @@ static void qspi_receive_init(const struct rspi_data *rspi)
 
 static int qspi_receive_pio(struct rspi_data *rspi, struct spi_transfer *t)
 {
-	int remain = t->len;
-	u8 *data;
+	int remain = t->len, ret;
+	u8 *data = t->rx_buf;
 
 	qspi_receive_init(rspi);
 
-	data = t->rx_buf;
 	while (remain > 0) {
-
-		if (rspi_wait_for_interrupt(rspi, SPSR_SPTEF, SPCR_SPTIE) < 0) {
-			dev_err(&rspi->master->dev,
-				"%s: tx empty timeout\n", __func__);
-			return -ETIMEDOUT;
-		}
 		/* dummy write for generate clock */
-		rspi_write_data(rspi, DUMMY_DATA);
-
-		if (rspi_wait_for_interrupt(rspi, SPSR_SPRF, SPCR_SPRIE) < 0) {
-			dev_err(&rspi->master->dev,
-				"%s: receive timeout\n", __func__);
-			return -ETIMEDOUT;
-		}
-		*data++ = rspi_read_data(rspi);
+		ret = rspi_data_out_in(rspi, DUMMY_DATA);
+		if (ret < 0)
+			return ret;
+		*data++ = ret;
 		remain--;
 	}
 
-- 
1.7.9.5

