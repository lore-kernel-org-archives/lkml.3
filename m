Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766Ab3FKRJj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 13:09:39 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48186 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755695Ab3FKRJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 13:09:34 -0400
From: Illia Smyrnov <illia.smyrnov@ti.com>
To: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Mark Brown <broonie@kernel.org>
CC: Illia Smyrnov <illia.smyrnov@ti.com>, Daniel Mack <zonque@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <spi-devel-general@lists.sourceforge.net>,
        <linux-omap@vger.kernel.org>
Subject: [PATCH v2 1/2] spi: omap2-mcspi: Move bytes per word calculation to the function
Date: Tue, 11 Jun 2013 20:09:14 +0300
Message-ID: <1370970556-11713-2-git-send-email-illia.smyrnov@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1370970556-11713-1-git-send-email-illia.smyrnov@ti.com>
References: <1370970556-11713-1-git-send-email-illia.smyrnov@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce mcspi_bytes_per_word function as replacement for the next code
fragment:

int c = (word_len <= 8)  ? 1 :
	(word_len <= 16) ? 2 :
	/* word_len <= 32 */ 4;

This code used 2 times in current driver code and will be used 2 times in
the next FIFO buffer support patch. Replace it with inline function with clear
name to improve code legibility.

Signed-off-by: Illia Smyrnov <illia.smyrnov@ti.com>
---
 drivers/spi/spi-omap2-mcspi.c |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index 86d2158..707f1db 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -187,6 +187,16 @@ static inline void mcspi_write_chconf0(const struct spi_device *spi, u32 val)
 	mcspi_read_cs_reg(spi, OMAP2_MCSPI_CHCONF0);
 }
 
+static inline int mcspi_bytes_per_word(int word_len)
+{
+	if (word_len <= 8)
+		return 1;
+	else if (word_len <= 16)
+		return 2;
+	else /* word_len <= 32 */
+		return 4;
+}
+
 static void omap2_mcspi_set_dma_req(const struct spi_device *spi,
 		int is_read, int enable)
 {
@@ -433,10 +443,9 @@ omap2_mcspi_rx_dma(struct spi_device *spi, struct spi_transfer *xfer,
 			else /* word_len <= 32 */
 				((u32 *)xfer->rx_buf)[elements++] = w;
 		} else {
+			int bytes_per_word = mcspi_bytes_per_word(word_len);
 			dev_err(&spi->dev, "DMA RX penultimate word empty");
-			count -= (word_len <= 8)  ? 2 :
-				(word_len <= 16) ? 4 :
-				/* word_len <= 32 */ 8;
+			count -= (bytes_per_word << 1);
 			omap2_mcspi_set_enable(spi, 1);
 			return count;
 		}
@@ -454,9 +463,7 @@ omap2_mcspi_rx_dma(struct spi_device *spi, struct spi_transfer *xfer,
 			((u32 *)xfer->rx_buf)[elements] = w;
 	} else {
 		dev_err(&spi->dev, "DMA RX last word empty");
-		count -= (word_len <= 8)  ? 1 :
-			 (word_len <= 16) ? 2 :
-		       /* word_len <= 32 */ 4;
+		count -= mcspi_bytes_per_word(word_len);
 	}
 	omap2_mcspi_set_enable(spi, 1);
 	return count;
-- 
1.7.0.4

