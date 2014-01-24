Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473AbaAXIoR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 03:44:17 -0500
Received: from baptiste.telenet-ops.be ([195.130.132.51]:37754 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371AbaAXIoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 03:44:14 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH 01/14] spi: rspi: Remove unused mesg parameter from {send,receive}_pio()
Date: Fri, 24 Jan 2014 09:43:51 +0100
Message-Id: <1390553044-11860-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1390553044-11860-1-git-send-email-geert@linux-m68k.org>
References: <1390553044-11860-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
 drivers/spi/spi-rspi.c |   27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

diff --git a/drivers/spi/spi-rspi.c b/drivers/spi/spi-rspi.c
index 28987d9fcfe5..ccd5cf201d04 100644
--- a/drivers/spi/spi-rspi.c
+++ b/drivers/spi/spi-rspi.c
@@ -228,11 +228,8 @@ static u16 rspi_read16(const struct rspi_data *rspi, u16 offset)
 struct spi_ops {
 	int (*set_config_register)(const struct rspi_data *rspi,
 				   int access_size);
-	int (*send_pio)(struct rspi_data *rspi, struct spi_message *mesg,
-			struct spi_transfer *t);
-	int (*receive_pio)(struct rspi_data *rspi, struct spi_message *mesg,
-			   struct spi_transfer *t);
-
+	int (*send_pio)(struct rspi_data *rspi, struct spi_transfer *t);
+	int (*receive_pio)(struct rspi_data *rspi, struct spi_transfer *t);
 };
 
 /*
@@ -358,8 +355,7 @@ static void rspi_negate_ssl(const struct rspi_data *rspi)
 	rspi_write8(rspi, rspi_read8(rspi, RSPI_SPCR) & ~SPCR_SPE, RSPI_SPCR);
 }
 
-static int rspi_send_pio(struct rspi_data *rspi, struct spi_message *mesg,
-			 struct spi_transfer *t)
+static int rspi_send_pio(struct rspi_data *rspi, struct spi_transfer *t)
 {
 	int remain = t->len;
 	const u8 *data = t->tx_buf;
@@ -384,8 +380,7 @@ static int rspi_send_pio(struct rspi_data *rspi, struct spi_message *mesg,
 	return 0;
 }
 
-static int qspi_send_pio(struct rspi_data *rspi, struct spi_message *mesg,
-			 struct spi_transfer *t)
+static int qspi_send_pio(struct rspi_data *rspi, struct spi_transfer *t)
 {
 	int remain = t->len;
 	const u8 *data = t->tx_buf;
@@ -418,7 +413,7 @@ static int qspi_send_pio(struct rspi_data *rspi, struct spi_message *mesg,
 	return 0;
 }
 
-#define send_pio(spi, mesg, t) spi->ops->send_pio(spi, mesg, t)
+#define send_pio(spi, t) spi->ops->send_pio(spi, t)
 
 static void rspi_dma_complete(void *arg)
 {
@@ -551,8 +546,7 @@ static void rspi_receive_init(const struct rspi_data *rspi)
 			    RSPI_SPSR);
 }
 
-static int rspi_receive_pio(struct rspi_data *rspi, struct spi_message *mesg,
-			    struct spi_transfer *t)
+static int rspi_receive_pio(struct rspi_data *rspi, struct spi_transfer *t)
 {
 	int remain = t->len;
 	u8 *data;
@@ -598,8 +592,7 @@ static void qspi_receive_init(const struct rspi_data *rspi)
 	rspi_write8(rspi, 0x00, QSPI_SPBFCR);
 }
 
-static int qspi_receive_pio(struct rspi_data *rspi, struct spi_message *mesg,
-			    struct spi_transfer *t)
+static int qspi_receive_pio(struct rspi_data *rspi, struct spi_transfer *t)
 {
 	int remain = t->len;
 	u8 *data;
@@ -630,7 +623,7 @@ static int qspi_receive_pio(struct rspi_data *rspi, struct spi_message *mesg,
 	return 0;
 }
 
-#define receive_pio(spi, mesg, t) spi->ops->receive_pio(spi, mesg, t)
+#define receive_pio(spi, t) spi->ops->receive_pio(spi, t)
 
 static int rspi_receive_dma(struct rspi_data *rspi, struct spi_transfer *t)
 {
@@ -771,7 +764,7 @@ static void rspi_work(struct work_struct *work)
 				if (rspi_is_dma(rspi, t))
 					ret = rspi_send_dma(rspi, t);
 				else
-					ret = send_pio(rspi, mesg, t);
+					ret = send_pio(rspi, t);
 				if (ret < 0)
 					goto error;
 			}
@@ -779,7 +772,7 @@ static void rspi_work(struct work_struct *work)
 				if (rspi_is_dma(rspi, t))
 					ret = rspi_receive_dma(rspi, t);
 				else
-					ret = receive_pio(rspi, mesg, t);
+					ret = receive_pio(rspi, t);
 				if (ret < 0)
 					goto error;
 			}
-- 
1.7.9.5

