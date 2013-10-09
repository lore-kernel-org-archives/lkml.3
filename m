Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831Ab3JIMMx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 08:12:53 -0400
Received: from exprod5og113.obsmtp.com ([64.18.0.26]:58470 "EHLO
	exprod5og113.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584Ab3JIMMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 08:12:52 -0400
X-Greylist: delayed 458 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Oct 2013 08:12:51 EDT
From: Illia Smyrnov <illia.smyrnov@globallogic.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Illia Smyrnov <illia.smyrnov@ti.com>
Subject: [PATCH] spi: omap2-mcspi: Fix FIFO support for transmit-and-receive mode
Date: Wed,  9 Oct 2013 15:05:08 +0300
Message-Id: <1381320308-25258-1-git-send-email-illia.smyrnov@globallogic.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes MCSPI FIFO buffer support when transmit-and-receive
(full duplex) mode is used. In this mode FIFO can be used for RX or
for TX or for both directions. If FIFO used for both directions the buffer
is split into two 32-byte buffers - one for each direction.
Also for full duplex mode both AEL and AFL need to be set in CHCONF0 register.

Signed-off-by: Illia Smyrnov <illia.smyrnov@globallogic.com>
---
 drivers/spi/spi-omap2-mcspi.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index ed4af47..32dca0c 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -276,7 +276,7 @@ static void omap2_mcspi_set_fifo(const struct spi_device *spi,
 	struct omap2_mcspi_cs *cs = spi->controller_state;
 	struct omap2_mcspi *mcspi;
 	unsigned int wcnt;
-	int fifo_depth, bytes_per_word;
+	int max_fifo_depth, fifo_depth, bytes_per_word;
 	u32 chconf, xferlevel;
 
 	mcspi = spi_master_get_devdata(master);
@@ -287,7 +287,12 @@ static void omap2_mcspi_set_fifo(const struct spi_device *spi,
 		if (t->len % bytes_per_word != 0)
 			goto disable_fifo;
 
-		fifo_depth = gcd(t->len, OMAP2_MCSPI_MAX_FIFODEPTH);
+		if (t->rx_buf != NULL && t->tx_buf != NULL)
+			max_fifo_depth = OMAP2_MCSPI_MAX_FIFODEPTH / 2;
+		else
+			max_fifo_depth = OMAP2_MCSPI_MAX_FIFODEPTH;
+
+		fifo_depth = gcd(t->len, max_fifo_depth);
 		if (fifo_depth < 2 || fifo_depth % bytes_per_word != 0)
 			goto disable_fifo;
 
@@ -299,7 +304,8 @@ static void omap2_mcspi_set_fifo(const struct spi_device *spi,
 		if (t->rx_buf != NULL) {
 			chconf |= OMAP2_MCSPI_CHCONF_FFER;
 			xferlevel |= (fifo_depth - 1) << 8;
-		} else {
+		}
+		if (t->tx_buf != NULL) {
 			chconf |= OMAP2_MCSPI_CHCONF_FFET;
 			xferlevel |= fifo_depth - 1;
 		}
-- 
1.7.9.5

