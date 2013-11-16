Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432Ab3KPAGX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:06:23 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:35422 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686Ab3KPABs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 19:01:48 -0500
From: Taras Kondratiuk <taras.kondratiuk@linaro.org>
To: linux-omap@vger.kernel.org
Cc: linaro-networking@linaro.org, Victor Kamensky <victor.kamensky@linaro.org>,
        Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC 13/23] spi: omap2-mcspi: raw read and write endian fix
Date: Sat, 16 Nov 2013 02:01:16 +0200
Message-Id: <1384560086-11994-14-git-send-email-taras.kondratiuk@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384560086-11994-1-git-send-email-taras.kondratiuk@linaro.org>
References: <1384560086-11994-1-git-send-email-taras.kondratiuk@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Victor Kamensky <victor.kamensky@linaro.org>

All OMAP IP blocks expect LE data, but CPU may operate in BE mode.
Need to use endian neutral functions to read/write h/w registers.
I.e instead of __raw_read[lw] and __raw_write[lw] functions code
need to use read[lw]_relaxed and write[lw]_relaxed functions.
If the first simply reads/writes register, the second will byteswap
it if host operates in BE mode.

Changes are trivial sed like replacement of __raw_xxx functions
with xxx_relaxed variant.

Signed-off-by: Victor Kamensky <victor.kamensky@linaro.org>
Signed-off-by: Taras Kondratiuk <taras.kondratiuk@linaro.org>
---
 drivers/spi/spi-omap2-mcspi.c |   38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index ed4af47..c9471b7 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -157,14 +157,14 @@ static inline void mcspi_write_reg(struct spi_master *master,
 {
 	struct omap2_mcspi *mcspi = spi_master_get_devdata(master);
 
-	__raw_writel(val, mcspi->base + idx);
+	writel_relaxed(val, mcspi->base + idx);
 }
 
 static inline u32 mcspi_read_reg(struct spi_master *master, int idx)
 {
 	struct omap2_mcspi *mcspi = spi_master_get_devdata(master);
 
-	return __raw_readl(mcspi->base + idx);
+	return readl_relaxed(mcspi->base + idx);
 }
 
 static inline void mcspi_write_cs_reg(const struct spi_device *spi,
@@ -172,14 +172,14 @@ static inline void mcspi_write_cs_reg(const struct spi_device *spi,
 {
 	struct omap2_mcspi_cs	*cs = spi->controller_state;
 
-	__raw_writel(val, cs->base +  idx);
+	writel_relaxed(val, cs->base +  idx);
 }
 
 static inline u32 mcspi_read_cs_reg(const struct spi_device *spi, int idx)
 {
 	struct omap2_mcspi_cs	*cs = spi->controller_state;
 
-	return __raw_readl(cs->base + idx);
+	return readl_relaxed(cs->base + idx);
 }
 
 static inline u32 mcspi_cached_chconf0(const struct spi_device *spi)
@@ -332,7 +332,7 @@ static void omap2_mcspi_restore_ctx(struct omap2_mcspi *mcspi)
 	mcspi_write_reg(spi_cntrl, OMAP2_MCSPI_WAKEUPENABLE, ctx->wakeupenable);
 
 	list_for_each_entry(cs, &ctx->cs, node)
-		__raw_writel(cs->chconf0, cs->base + OMAP2_MCSPI_CHCONF0);
+		writel_relaxed(cs->chconf0, cs->base + OMAP2_MCSPI_CHCONF0);
 }
 
 static int mcspi_wait_for_reg_bit(void __iomem *reg, unsigned long bit)
@@ -340,9 +340,9 @@ static int mcspi_wait_for_reg_bit(void __iomem *reg, unsigned long bit)
 	unsigned long timeout;
 
 	timeout = jiffies + msecs_to_jiffies(1000);
-	while (!(__raw_readl(reg) & bit)) {
+	while (!(readl_relaxed(reg) & bit)) {
 		if (time_after(jiffies, timeout)) {
-			if (!(__raw_readl(reg) & bit))
+			if (!(readl_relaxed(reg) & bit))
 				return -ETIMEDOUT;
 			else
 				return 0;
@@ -669,7 +669,7 @@ omap2_mcspi_txrx_pio(struct spi_device *spi, struct spi_transfer *xfer)
 				}
 				dev_vdbg(&spi->dev, "write-%d %02x\n",
 						word_len, *tx);
-				__raw_writel(*tx++, tx_reg);
+				writel_relaxed(*tx++, tx_reg);
 			}
 			if (rx != NULL) {
 				if (mcspi_wait_for_reg_bit(chstat_reg,
@@ -681,7 +681,7 @@ omap2_mcspi_txrx_pio(struct spi_device *spi, struct spi_transfer *xfer)
 				if (c == 1 && tx == NULL &&
 				    (l & OMAP2_MCSPI_CHCONF_TURBO)) {
 					omap2_mcspi_set_enable(spi, 0);
-					*rx++ = __raw_readl(rx_reg);
+					*rx++ = readl_relaxed(rx_reg);
 					dev_vdbg(&spi->dev, "read-%d %02x\n",
 						    word_len, *(rx - 1));
 					if (mcspi_wait_for_reg_bit(chstat_reg,
@@ -695,7 +695,7 @@ omap2_mcspi_txrx_pio(struct spi_device *spi, struct spi_transfer *xfer)
 					omap2_mcspi_set_enable(spi, 0);
 				}
 
-				*rx++ = __raw_readl(rx_reg);
+				*rx++ = readl_relaxed(rx_reg);
 				dev_vdbg(&spi->dev, "read-%d %02x\n",
 						word_len, *(rx - 1));
 			}
@@ -716,7 +716,7 @@ omap2_mcspi_txrx_pio(struct spi_device *spi, struct spi_transfer *xfer)
 				}
 				dev_vdbg(&spi->dev, "write-%d %04x\n",
 						word_len, *tx);
-				__raw_writel(*tx++, tx_reg);
+				writel_relaxed(*tx++, tx_reg);
 			}
 			if (rx != NULL) {
 				if (mcspi_wait_for_reg_bit(chstat_reg,
@@ -728,7 +728,7 @@ omap2_mcspi_txrx_pio(struct spi_device *spi, struct spi_transfer *xfer)
 				if (c == 2 && tx == NULL &&
 				    (l & OMAP2_MCSPI_CHCONF_TURBO)) {
 					omap2_mcspi_set_enable(spi, 0);
-					*rx++ = __raw_readl(rx_reg);
+					*rx++ = readl_relaxed(rx_reg);
 					dev_vdbg(&spi->dev, "read-%d %04x\n",
 						    word_len, *(rx - 1));
 					if (mcspi_wait_for_reg_bit(chstat_reg,
@@ -742,7 +742,7 @@ omap2_mcspi_txrx_pio(struct spi_device *spi, struct spi_transfer *xfer)
 					omap2_mcspi_set_enable(spi, 0);
 				}
 
-				*rx++ = __raw_readl(rx_reg);
+				*rx++ = readl_relaxed(rx_reg);
 				dev_vdbg(&spi->dev, "read-%d %04x\n",
 						word_len, *(rx - 1));
 			}
@@ -763,7 +763,7 @@ omap2_mcspi_txrx_pio(struct spi_device *spi, struct spi_transfer *xfer)
 				}
 				dev_vdbg(&spi->dev, "write-%d %08x\n",
 						word_len, *tx);
-				__raw_writel(*tx++, tx_reg);
+				writel_relaxed(*tx++, tx_reg);
 			}
 			if (rx != NULL) {
 				if (mcspi_wait_for_reg_bit(chstat_reg,
@@ -775,7 +775,7 @@ omap2_mcspi_txrx_pio(struct spi_device *spi, struct spi_transfer *xfer)
 				if (c == 4 && tx == NULL &&
 				    (l & OMAP2_MCSPI_CHCONF_TURBO)) {
 					omap2_mcspi_set_enable(spi, 0);
-					*rx++ = __raw_readl(rx_reg);
+					*rx++ = readl_relaxed(rx_reg);
 					dev_vdbg(&spi->dev, "read-%d %08x\n",
 						    word_len, *(rx - 1));
 					if (mcspi_wait_for_reg_bit(chstat_reg,
@@ -789,7 +789,7 @@ omap2_mcspi_txrx_pio(struct spi_device *spi, struct spi_transfer *xfer)
 					omap2_mcspi_set_enable(spi, 0);
 				}
 
-				*rx++ = __raw_readl(rx_reg);
+				*rx++ = readl_relaxed(rx_reg);
 				dev_vdbg(&spi->dev, "read-%d %08x\n",
 						word_len, *(rx - 1));
 			}
@@ -1101,7 +1101,7 @@ static void omap2_mcspi_work(struct omap2_mcspi *mcspi, struct spi_message *m)
 
 			/* RX_ONLY mode needs dummy data in TX reg */
 			if (t->tx_buf == NULL)
-				__raw_writel(0, cs->base
+				writel_relaxed(0, cs->base
 						+ OMAP2_MCSPI_TX0);
 
 			if ((mcspi_dma->dma_rx && mcspi_dma->dma_tx) &&
@@ -1465,9 +1465,9 @@ static int omap2_mcspi_resume(struct device *dev)
 			 * change in account.
 			 */
 			cs->chconf0 |= OMAP2_MCSPI_CHCONF_FORCE;
-			__raw_writel(cs->chconf0, cs->base + OMAP2_MCSPI_CHCONF0);
+			writel_relaxed(cs->chconf0, cs->base + OMAP2_MCSPI_CHCONF0);
 			cs->chconf0 &= ~OMAP2_MCSPI_CHCONF_FORCE;
-			__raw_writel(cs->chconf0, cs->base + OMAP2_MCSPI_CHCONF0);
+			writel_relaxed(cs->chconf0, cs->base + OMAP2_MCSPI_CHCONF0);
 		}
 	}
 	pm_runtime_mark_last_busy(mcspi->dev);
-- 
1.7.9.5

