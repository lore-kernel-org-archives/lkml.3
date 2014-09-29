Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811AbaI2Gcd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 02:32:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:61106 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639AbaI2Gcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 02:32:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,618,1406617200"; 
   d="scan'208";a="598134379"
From: Weike Chen <alvin.chen@intel.com>
To: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@intel.com>,
        Hock Leong Kweh <hock.leong.kweh@intel.com>,
        Boon Leong Ong <boon.leong.ong@intel.com>,
        Raymond Tan <raymond.tan@intel.com>, Alvin Chen <alvin.chen@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 1/2 v2] SPI: spi-pxa2xx: Add helpers for regiseters' accessing
Date: Mon, 29 Sep 2014 07:22:27 -0700
Message-Id: <1412000548-9908-2-git-send-email-alvin.chen@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1412000548-9908-1-git-send-email-alvin.chen@intel.com>
References: <1412000548-9908-1-git-send-email-alvin.chen@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce helper functions to access the 'SSCR0' and 'SSCR1'.

Signed-off-by: Weike Chen <alvin.chen@intel.com>
---
 drivers/spi/spi-pxa2xx.c |  108 ++++++++++++++++++++++++++++++++++++----------
 1 file changed, 85 insertions(+), 23 deletions(-)

diff --git a/drivers/spi/spi-pxa2xx.c b/drivers/spi/spi-pxa2xx.c
index 256c0ab..e7ff9c5 100644
--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -80,6 +80,73 @@ static bool is_lpss_ssp(const struct driver_data *drv_data)
 	return drv_data->ssp_type == LPSS_SSP;
 }
 
+static u32 pxa2xx_spi_get_ssrc1_change_mask(const struct driver_data *drv_data)
+{
+	switch (drv_data->ssp_type) {
+	default:
+		return SSCR1_CHANGE_MASK;
+	}
+}
+
+static u32
+pxa2xx_spi_get_rx_default_thre(const struct driver_data *drv_data)
+{
+	switch (drv_data->ssp_type) {
+	default:
+		return RX_THRESH_DFLT;
+	}
+}
+
+static bool pxa2xx_spi_txfifo_full(const struct driver_data *drv_data)
+{
+	void __iomem *reg = drv_data->ioaddr;
+	u32 mask;
+
+	switch (drv_data->ssp_type) {
+	default:
+		mask = SSSR_TFL_MASK;
+		break;
+	}
+
+	return (read_SSSR(reg) & mask) == mask;
+}
+
+static void pxa2xx_spi_clear_rx_thre(const struct driver_data *drv_data,
+				     u32 *sccr1_reg)
+{
+	u32 mask;
+
+	switch (drv_data->ssp_type) {
+	default:
+		mask = SSCR1_RFT;
+		break;
+	}
+	*sccr1_reg &= ~mask;
+}
+
+static void pxa2xx_spi_set_rx_thre(const struct driver_data *drv_data,
+				   u32 *sccr1_reg, u32 threshold)
+{
+	switch (drv_data->ssp_type) {
+	default:
+		*sccr1_reg |= SSCR1_RxTresh(threshold);
+		break;
+	}
+}
+
+static u32 pxa2xx_configure_sscr0(const struct driver_data *drv_data,
+				  u32 clk_div, u8 bits)
+{
+	switch (drv_data->ssp_type) {
+	default:
+		return clk_div
+			| SSCR0_Motorola
+			| SSCR0_DataSize(bits > 16 ? bits - 16 : bits)
+			| SSCR0_SSE
+			| (bits > 16 ? SSCR0_EDSS : 0);
+	}
+}
+
 /*
  * Read and write LPSS SSP private registers. Caller must first check that
  * is_lpss_ssp() returns true before these can be called.
@@ -234,7 +301,7 @@ static int null_writer(struct driver_data *drv_data)
 	void __iomem *reg = drv_data->ioaddr;
 	u8 n_bytes = drv_data->n_bytes;
 
-	if (((read_SSSR(reg) & SSSR_TFL_MASK) == SSSR_TFL_MASK)
+	if (pxa2xx_spi_txfifo_full(drv_data)
 		|| (drv_data->tx == drv_data->tx_end))
 		return 0;
 
@@ -262,7 +329,7 @@ static int u8_writer(struct driver_data *drv_data)
 {
 	void __iomem *reg = drv_data->ioaddr;
 
-	if (((read_SSSR(reg) & SSSR_TFL_MASK) == SSSR_TFL_MASK)
+	if (pxa2xx_spi_txfifo_full(drv_data)
 		|| (drv_data->tx == drv_data->tx_end))
 		return 0;
 
@@ -289,7 +356,7 @@ static int u16_writer(struct driver_data *drv_data)
 {
 	void __iomem *reg = drv_data->ioaddr;
 
-	if (((read_SSSR(reg) & SSSR_TFL_MASK) == SSSR_TFL_MASK)
+	if (pxa2xx_spi_txfifo_full(drv_data)
 		|| (drv_data->tx == drv_data->tx_end))
 		return 0;
 
@@ -316,7 +383,7 @@ static int u32_writer(struct driver_data *drv_data)
 {
 	void __iomem *reg = drv_data->ioaddr;
 
-	if (((read_SSSR(reg) & SSSR_TFL_MASK) == SSSR_TFL_MASK)
+	if (pxa2xx_spi_txfifo_full(drv_data)
 		|| (drv_data->tx == drv_data->tx_end))
 		return 0;
 
@@ -508,8 +575,9 @@ static irqreturn_t interrupt_transfer(struct driver_data *drv_data)
 		 * remaining RX bytes.
 		 */
 		if (pxa25x_ssp_comp(drv_data)) {
+			u32 rx_thre;
 
-			sccr1_reg &= ~SSCR1_RFT;
+			pxa2xx_spi_clear_rx_thre(drv_data, &sccr1_reg);
 
 			bytes_left = drv_data->rx_end - drv_data->rx;
 			switch (drv_data->n_bytes) {
@@ -519,10 +587,12 @@ static irqreturn_t interrupt_transfer(struct driver_data *drv_data)
 				bytes_left >>= 1;
 			}
 
-			if (bytes_left > RX_THRESH_DFLT)
-				bytes_left = RX_THRESH_DFLT;
+			rx_thre = pxa2xx_spi_get_rx_default_thre(drv_data);
+			if (rx_thre > bytes_left)
+				rx_thre = bytes_left;
 
-			sccr1_reg |= SSCR1_RxTresh(bytes_left);
+			pxa2xx_spi_set_rx_thre(drv_data, &sccr1_reg,
+					       rx_thre);
 		}
 		write_SSCR1(sccr1_reg, reg);
 	}
@@ -613,6 +683,7 @@ static void pump_transfers(unsigned long data)
 	u32 cr1;
 	u32 dma_thresh = drv_data->cur_chip->dma_threshold;
 	u32 dma_burst = drv_data->cur_chip->dma_burst_size;
+	u32 change_mask = pxa2xx_spi_get_ssrc1_change_mask(drv_data);
 
 	/* Get current state information */
 	message = drv_data->cur_msg;
@@ -731,11 +802,7 @@ static void pump_transfers(unsigned long data)
 						     "pump_transfers: DMA burst size reduced to match bits_per_word\n");
 		}
 
-		cr0 = clk_div
-			| SSCR0_Motorola
-			| SSCR0_DataSize(bits > 16 ? bits - 16 : bits)
-			| SSCR0_SSE
-			| (bits > 16 ? SSCR0_EDSS : 0);
+		cr0 = pxa2xx_configure_sscr0(drv_data, clk_div, bits);
 	}
 
 	message->state = RUNNING_STATE;
@@ -772,16 +839,15 @@ static void pump_transfers(unsigned long data)
 	}
 
 	/* see if we need to reload the config registers */
-	if ((read_SSCR0(reg) != cr0)
-		|| (read_SSCR1(reg) & SSCR1_CHANGE_MASK) !=
-			(cr1 & SSCR1_CHANGE_MASK)) {
+	if ((read_SSCR0(reg) != cr0) ||
+	    (read_SSCR1(reg) & change_mask) != (cr1 & change_mask)) {
 
 		/* stop the SSP, and update the other bits */
 		write_SSCR0(cr0 & ~SSCR0_SSE, reg);
 		if (!pxa25x_ssp_comp(drv_data))
 			write_SSTO(chip->timeout, reg);
 		/* first set CR1 without interrupt and service enables */
-		write_SSCR1(cr1 & SSCR1_CHANGE_MASK, reg);
+		write_SSCR1(cr1 & change_mask, reg);
 		/* restart the SSP */
 		write_SSCR0(cr0, reg);
 
@@ -959,12 +1025,8 @@ static int setup(struct spi_device *spi)
 	clk_div = ssp_get_clk_div(drv_data, spi->max_speed_hz);
 	chip->speed_hz = spi->max_speed_hz;
 
-	chip->cr0 = clk_div
-			| SSCR0_Motorola
-			| SSCR0_DataSize(spi->bits_per_word > 16 ?
-				spi->bits_per_word - 16 : spi->bits_per_word)
-			| SSCR0_SSE
-			| (spi->bits_per_word > 16 ? SSCR0_EDSS : 0);
+	chip->cr0 = pxa2xx_configure_sscr0(drv_data, clk_div,
+					   spi->bits_per_word);
 	chip->cr1 &= ~(SSCR1_SPO | SSCR1_SPH);
 	chip->cr1 |= (((spi->mode & SPI_CPHA) != 0) ? SSCR1_SPH : 0)
 			| (((spi->mode & SPI_CPOL) != 0) ? SSCR1_SPO : 0);
-- 
1.7.9.5

