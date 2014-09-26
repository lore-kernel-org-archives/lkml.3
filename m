Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070AbaIZJdy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:33:54 -0400
Received: from mga01.intel.com ([192.55.52.88]:32201 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753291AbaIZJdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:33:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="391931402"
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
Subject: [PATCH] SPI: spi-pxa2xx: SPI support for Intel Quark X1000
Date: Fri, 26 Sep 2014 10:25:49 -0700
Message-Id: <1411752349-31490-2-git-send-email-alvin.chen@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411752349-31490-1-git-send-email-alvin.chen@intel.com>
References: <1411752349-31490-1-git-send-email-alvin.chen@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two SPI controllers exported by PCI subsystem for Intel Quark X1000.
The SPI memory mapped I/O registers supported by Quark are different from
the current implementation, and Quark only supports the registers of 'SSCR0',
'SSCR1', 'SSSR', 'SSDR', and 'DDS_RATE'. This patch is to enable the SPI for
Intel Quark X1000.

This piece of work is derived from Dan O'Donovan's initial work for Intel Quark
X1000 SPI enabling.

Signed-off-by: Weike Chen <alvin.chen@intel.com>
---
 drivers/spi/spi-pxa2xx-pci.c |    8 ++
 drivers/spi/spi-pxa2xx.c     |  251 +++++++++++++++++++++++++++++++++++-------
 drivers/spi/spi-pxa2xx.h     |    8 +-
 include/linux/pxa2xx_ssp.h   |   21 ++++
 4 files changed, 249 insertions(+), 39 deletions(-)

diff --git a/drivers/spi/spi-pxa2xx-pci.c b/drivers/spi/spi-pxa2xx-pci.c
index b285294..b888aeb 100644
--- a/drivers/spi/spi-pxa2xx-pci.c
+++ b/drivers/spi/spi-pxa2xx-pci.c
@@ -19,6 +19,7 @@ enum {
 	PORT_BSW0,
 	PORT_BSW1,
 	PORT_BSW2,
+	PORT_QUARK_X1000,
 };
 
 struct pxa_spi_info {
@@ -92,6 +93,12 @@ static struct pxa_spi_info spi_info_configs[] = {
 		.tx_param = &bsw2_tx_param,
 		.rx_param = &bsw2_rx_param,
 	},
+	[PORT_QUARK_X1000] = {
+		.type = QUARK_X1000_SSP,
+		.port_id = -1,
+		.num_chipselect = 4,
+		.max_clk_rate = 50000000,
+	},
 };
 
 static int pxa2xx_spi_pci_probe(struct pci_dev *dev,
@@ -192,6 +199,7 @@ static void pxa2xx_spi_pci_remove(struct pci_dev *dev)
 
 static const struct pci_device_id pxa2xx_spi_pci_devices[] = {
 	{ PCI_VDEVICE(INTEL, 0x2e6a), PORT_CE4100 },
+	{ PCI_VDEVICE(INTEL, 0x0935), PORT_QUARK_X1000 },
 	{ PCI_VDEVICE(INTEL, 0x0f0e), PORT_BYT },
 	{ PCI_VDEVICE(INTEL, 0x228e), PORT_BSW0 },
 	{ PCI_VDEVICE(INTEL, 0x2290), PORT_BSW1 },
diff --git a/drivers/spi/spi-pxa2xx.c b/drivers/spi/spi-pxa2xx.c
index 256c0ab..9a49da4 100644
--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -63,10 +63,60 @@ MODULE_ALIAS("platform:pxa2xx-spi");
 				| SSCR1_RFT | SSCR1_TFT | SSCR1_MWDS \
 				| SSCR1_SPH | SSCR1_SPO | SSCR1_LBM)
 
+#define QUARK_X1000_SSCR1_CHANGE_MASK (QUARK_X1000_SSCR1_STRF	\
+				| QUARK_X1000_SSCR1_EFWR	\
+				| QUARK_X1000_SSCR1_RFT		\
+				| QUARK_X1000_SSCR1_TFT		\
+				| SSCR1_SPH | SSCR1_SPO | SSCR1_LBM)
+
 #define LPSS_RX_THRESH_DFLT	64
 #define LPSS_TX_LOTHRESH_DFLT	160
 #define LPSS_TX_HITHRESH_DFLT	224
 
+struct quark_spi_rate {
+	u32 bitrate;
+	u32 dds_clk_rate;
+	u32 clk_div;
+};
+
+static const struct quark_spi_rate quark_spi_rate_table[] = {
+/*	bitrate,	dds_clk_rate,	clk_div */
+	{50000000,	0x800000,	0},
+	{40000000,	0x666666,	0},
+	{25000000,	0x400000,	0},
+	{20000000,	0x666666,	1},
+	{16667000,	0x800000,	2},
+	{13333000,	0x666666,	2},
+	{12500000,	0x200000,	0},
+	{10000000,	0x800000,	4},
+	{8000000,	0x666666,	4},
+	{6250000,	0x400000,	3},
+	{5000000,	0x400000,	4},
+	{4000000,	0x666666,	9},
+	{3125000,	0x80000,	0},
+	{2500000,	0x400000,	9},
+	{2000000,	0x666666,	19},
+	{1563000,	0x40000,	0},
+	{1250000,	0x200000,	9},
+	{1000000,	0x400000,	24},
+	{800000,	0x666666,	49},
+	{781250,	0x20000,	0},
+	{625000,	0x200000,	19},
+	{500000,	0x400000,	49},
+	{400000,	0x666666,	99},
+	{390625,	0x10000,	0},
+	{250000,	0x400000,	99},
+	{200000,	0x666666,	199},
+	{195313,	0x8000,		0},
+	{125000,	0x100000,	49},
+	{100000,	0x200000,	124},
+	{50000,		0x100000,	124},
+	{25000,		0x80000,	124},
+	{10016,		0x20000,	77},
+	{5040,		0x20000,	154},
+	{1002,		0x8000,		194},
+};
+
 /* Offset from drv_data->lpss_base */
 #define GENERAL_REG		0x08
 #define GENERAL_REG_RXTO_HOLDOFF_DISABLE BIT(24)
@@ -80,6 +130,67 @@ static bool is_lpss_ssp(const struct driver_data *drv_data)
 	return drv_data->ssp_type == LPSS_SSP;
 }
 
+static bool is_quark_x1000_ssp(const struct driver_data *drv_data)
+{
+	return drv_data->ssp_type == QUARK_X1000_SSP;
+}
+
+static u32 pxa2xx_spi_get_ssrc1_change_mask(const struct driver_data *drv_data)
+{
+	if (!is_quark_x1000_ssp(drv_data))
+		return SSCR1_CHANGE_MASK;
+
+	return QUARK_X1000_SSCR1_CHANGE_MASK;
+}
+
+static u32
+pxa2xx_spi_get_rx_default_threshold(const struct driver_data *drv_data)
+{
+	if (!is_quark_x1000_ssp(drv_data))
+		return RX_THRESH_DFLT;
+
+	return RX_THRESH_QUARK_X1000_DFLT;
+}
+
+static bool pxa2xx_spi_txfifo_full(const struct driver_data *drv_data)
+{
+	void __iomem *reg = drv_data->ioaddr;
+	u32 tfl_mask = !is_quark_x1000_ssp(drv_data) ? SSSR_TFL_MASK :
+						QUARK_X1000_SSSR_TFL_MASK;
+
+	return (read_SSSR(reg) & tfl_mask) == tfl_mask;
+}
+
+static void pxa2xx_spi_clear_rx_threshold(const struct driver_data *drv_data,
+					  u32 *sccr1_reg)
+{
+	u32 rft_mask = !is_quark_x1000_ssp(drv_data) ?
+				SSCR1_RFT : QUARK_X1000_SSCR1_RFT;
+
+	*sccr1_reg &= ~rft_mask;
+}
+
+static void pxa2xx_spi_set_rx_threshold(const struct driver_data *drv_data,
+					u32 *sccr1_reg, u32 threshold)
+{
+	if (!is_quark_x1000_ssp(drv_data))
+		*sccr1_reg |= SSCR1_RxTresh(threshold);
+	else
+		*sccr1_reg |= QUARK_X1000_SSCR1_RxTresh(threshold);
+}
+
+static u32 pxa2xx_configure_sscr0(const struct driver_data *drv_data,
+				  u32 clk_div, u8 bits)
+{
+	if (!is_quark_x1000_ssp(drv_data))
+		return clk_div | SSCR0_Motorola
+			| SSCR0_DataSize(bits > 16 ? bits - 16 : bits)
+			| SSCR0_SSE | (bits > 16 ? SSCR0_EDSS : 0);
+
+	return clk_div | QUARK_X1000_SSCR0_Motorola
+		| QUARK_X1000_SSCR0_DataSize(bits > 32 ? 8 : bits) | SSCR0_SSE;
+}
+
 /*
  * Read and write LPSS SSP private registers. Caller must first check that
  * is_lpss_ssp() returns true before these can be called.
@@ -234,7 +345,7 @@ static int null_writer(struct driver_data *drv_data)
 	void __iomem *reg = drv_data->ioaddr;
 	u8 n_bytes = drv_data->n_bytes;
 
-	if (((read_SSSR(reg) & SSSR_TFL_MASK) == SSSR_TFL_MASK)
+	if (pxa2xx_spi_txfifo_full(drv_data)
 		|| (drv_data->tx == drv_data->tx_end))
 		return 0;
 
@@ -262,7 +373,7 @@ static int u8_writer(struct driver_data *drv_data)
 {
 	void __iomem *reg = drv_data->ioaddr;
 
-	if (((read_SSSR(reg) & SSSR_TFL_MASK) == SSSR_TFL_MASK)
+	if (pxa2xx_spi_txfifo_full(drv_data)
 		|| (drv_data->tx == drv_data->tx_end))
 		return 0;
 
@@ -289,7 +400,7 @@ static int u16_writer(struct driver_data *drv_data)
 {
 	void __iomem *reg = drv_data->ioaddr;
 
-	if (((read_SSSR(reg) & SSSR_TFL_MASK) == SSSR_TFL_MASK)
+	if (pxa2xx_spi_txfifo_full(drv_data)
 		|| (drv_data->tx == drv_data->tx_end))
 		return 0;
 
@@ -316,7 +427,7 @@ static int u32_writer(struct driver_data *drv_data)
 {
 	void __iomem *reg = drv_data->ioaddr;
 
-	if (((read_SSSR(reg) & SSSR_TFL_MASK) == SSSR_TFL_MASK)
+	if (pxa2xx_spi_txfifo_full(drv_data)
 		|| (drv_data->tx == drv_data->tx_end))
 		return 0;
 
@@ -508,8 +619,9 @@ static irqreturn_t interrupt_transfer(struct driver_data *drv_data)
 		 * remaining RX bytes.
 		 */
 		if (pxa25x_ssp_comp(drv_data)) {
+			u32 rx_thre;
 
-			sccr1_reg &= ~SSCR1_RFT;
+			pxa2xx_spi_clear_rx_threshold(drv_data, &sccr1_reg);
 
 			bytes_left = drv_data->rx_end - drv_data->rx;
 			switch (drv_data->n_bytes) {
@@ -519,10 +631,12 @@ static irqreturn_t interrupt_transfer(struct driver_data *drv_data)
 				bytes_left >>= 1;
 			}
 
-			if (bytes_left > RX_THRESH_DFLT)
-				bytes_left = RX_THRESH_DFLT;
+			rx_thre = pxa2xx_spi_get_rx_default_threshold(drv_data);
+			if (rx_thre > bytes_left)
+				rx_thre = bytes_left;
 
-			sccr1_reg |= SSCR1_RxTresh(bytes_left);
+			pxa2xx_spi_set_rx_threshold(drv_data, &sccr1_reg,
+						    rx_thre);
 		}
 		write_SSCR1(sccr1_reg, reg);
 	}
@@ -585,6 +699,25 @@ static irqreturn_t ssp_int(int irq, void *dev_id)
 	return drv_data->transfer_handler(drv_data);
 }
 
+/*  see Quark SPI data sheet for implementation rationale */
+static u32 quark_x1000_set_clk_regvals(u32 rate, u32 *dds, u32 *clk_div)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(quark_spi_rate_table); i++) {
+		if (rate >= quark_spi_rate_table[i].bitrate) {
+			*dds = quark_spi_rate_table[i].dds_clk_rate;
+			*clk_div = quark_spi_rate_table[i].clk_div;
+			return quark_spi_rate_table[i].bitrate;
+		}
+	}
+
+	*dds = quark_spi_rate_table[i-1].dds_clk_rate;
+	*clk_div = quark_spi_rate_table[i-1].clk_div;
+
+	return quark_spi_rate_table[i-1].bitrate;
+}
+
 static unsigned int ssp_get_clk_div(struct driver_data *drv_data, int rate)
 {
 	unsigned long ssp_clk = drv_data->max_clk_rate;
@@ -598,6 +731,19 @@ static unsigned int ssp_get_clk_div(struct driver_data *drv_data, int rate)
 		return ((ssp_clk / rate - 1) & 0xfff) << 8;
 }
 
+static unsigned int pxa2xx_ssp_get_clk_div(struct driver_data *drv_data,
+					   struct chip_data *chip, int rate)
+{
+	u32 clk_div = 0;
+
+	if (!is_quark_x1000_ssp(drv_data))
+		return ssp_get_clk_div(drv_data, rate);
+
+	quark_x1000_set_clk_regvals(rate, &chip->dds_rate, &clk_div);
+
+	return clk_div << 8;
+}
+
 static void pump_transfers(unsigned long data)
 {
 	struct driver_data *drv_data = (struct driver_data *)data;
@@ -613,6 +759,8 @@ static void pump_transfers(unsigned long data)
 	u32 cr1;
 	u32 dma_thresh = drv_data->cur_chip->dma_threshold;
 	u32 dma_burst = drv_data->cur_chip->dma_burst_size;
+	u32 change_mask = pxa2xx_spi_get_ssrc1_change_mask(drv_data);
+
 
 	/* Get current state information */
 	message = drv_data->cur_msg;
@@ -699,7 +847,7 @@ static void pump_transfers(unsigned long data)
 		if (transfer->bits_per_word)
 			bits = transfer->bits_per_word;
 
-		clk_div = ssp_get_clk_div(drv_data, speed);
+		clk_div = pxa2xx_ssp_get_clk_div(drv_data, chip, speed);
 
 		if (bits <= 8) {
 			drv_data->n_bytes = 1;
@@ -731,11 +879,7 @@ static void pump_transfers(unsigned long data)
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
@@ -771,17 +915,20 @@ static void pump_transfers(unsigned long data)
 			write_SSITF(chip->lpss_tx_threshold, reg);
 	}
 
+	if (is_quark_x1000_ssp(drv_data) &&
+	    (read_DDS_RATE(reg) != chip->dds_rate))
+		write_DDS_RATE(chip->dds_rate, reg);
+
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
 
@@ -879,6 +1026,10 @@ static int setup(struct spi_device *spi)
 		tx_thres = LPSS_TX_LOTHRESH_DFLT;
 		tx_hi_thres = LPSS_TX_HITHRESH_DFLT;
 		rx_thres = LPSS_RX_THRESH_DFLT;
+	} else if (is_quark_x1000_ssp(drv_data)) {
+		tx_thres = TX_THRESH_QUARK_X1000_DFLT;
+		tx_hi_thres = 0;
+		rx_thres = RX_THRESH_QUARK_X1000_DFLT;
 	} else {
 		tx_thres = TX_THRESH_DFLT;
 		tx_hi_thres = 0;
@@ -935,9 +1086,6 @@ static int setup(struct spi_device *spi)
 		chip->enable_dma = drv_data->master_info->enable_dma;
 	}
 
-	chip->threshold = (SSCR1_RxTresh(rx_thres) & SSCR1_RFT) |
-			(SSCR1_TxTresh(tx_thres) & SSCR1_TFT);
-
 	chip->lpss_rx_threshold = SSIRF_RxThresh(rx_thres);
 	chip->lpss_tx_threshold = SSITF_TxLoThresh(tx_thres)
 				| SSITF_TxHiThresh(tx_hi_thres);
@@ -956,15 +1104,21 @@ static int setup(struct spi_device *spi)
 		}
 	}
 
-	clk_div = ssp_get_clk_div(drv_data, spi->max_speed_hz);
+	clk_div = pxa2xx_ssp_get_clk_div(drv_data, chip, spi->max_speed_hz);
 	chip->speed_hz = spi->max_speed_hz;
 
-	chip->cr0 = clk_div
-			| SSCR0_Motorola
-			| SSCR0_DataSize(spi->bits_per_word > 16 ?
-				spi->bits_per_word - 16 : spi->bits_per_word)
-			| SSCR0_SSE
-			| (spi->bits_per_word > 16 ? SSCR0_EDSS : 0);
+	chip->cr0 = pxa2xx_configure_sscr0(drv_data, clk_div,
+					   spi->bits_per_word);
+	if (!is_quark_x1000_ssp(drv_data)) {
+		chip->threshold = (SSCR1_RxTresh(rx_thres) & SSCR1_RFT) |
+			(SSCR1_TxTresh(tx_thres) & SSCR1_TFT);
+	} else {
+		chip->threshold = (QUARK_X1000_SSCR1_RxTresh(rx_thres)
+				   & QUARK_X1000_SSCR1_RFT)
+				   | (QUARK_X1000_SSCR1_TxTresh(tx_thres)
+				   & QUARK_X1000_SSCR1_TFT);
+	}
+
 	chip->cr1 &= ~(SSCR1_SPO | SSCR1_SPH);
 	chip->cr1 |= (((spi->mode & SPI_CPHA) != 0) ? SSCR1_SPH : 0)
 			| (((spi->mode & SPI_CPOL) != 0) ? SSCR1_SPO : 0);
@@ -993,7 +1147,8 @@ static int setup(struct spi_device *spi)
 		chip->read = u16_reader;
 		chip->write = u16_writer;
 	} else if (spi->bits_per_word <= 32) {
-		chip->cr0 |= SSCR0_EDSS;
+		if (!is_quark_x1000_ssp(drv_data))
+			chip->cr0 |= SSCR0_EDSS;
 		chip->n_bytes = 4;
 		chip->read = u32_reader;
 		chip->write = u32_writer;
@@ -1143,7 +1298,11 @@ static int pxa2xx_spi_probe(struct platform_device *pdev)
 	drv_data->ioaddr = ssp->mmio_base;
 	drv_data->ssdr_physical = ssp->phys_base + SSDR;
 	if (pxa25x_ssp_comp(drv_data)) {
-		master->bits_per_word_mask = SPI_BPW_RANGE_MASK(4, 16);
+		if (!is_quark_x1000_ssp(drv_data))
+			master->bits_per_word_mask = SPI_BPW_RANGE_MASK(4, 16);
+		else
+			master->bits_per_word_mask = SPI_BPW_RANGE_MASK(4, 32);
+
 		drv_data->int_cr1 = SSCR1_TIE | SSCR1_RIE;
 		drv_data->dma_cr1 = 0;
 		drv_data->clear_sr = SSSR_ROR;
@@ -1181,16 +1340,32 @@ static int pxa2xx_spi_probe(struct platform_device *pdev)
 
 	/* Load default SSP configuration */
 	write_SSCR0(0, drv_data->ioaddr);
-	write_SSCR1(SSCR1_RxTresh(RX_THRESH_DFLT) |
-				SSCR1_TxTresh(TX_THRESH_DFLT),
-				drv_data->ioaddr);
-	write_SSCR0(SSCR0_SCR(2)
-			| SSCR0_Motorola
-			| SSCR0_DataSize(8),
-			drv_data->ioaddr);
+	if (!is_quark_x1000_ssp(drv_data)) {
+		write_SSCR1(SSCR1_RxTresh(RX_THRESH_DFLT) |
+			    SSCR1_TxTresh(TX_THRESH_DFLT),
+			    drv_data->ioaddr);
+		write_SSCR0(SSCR0_SCR(2)
+			    | SSCR0_Motorola
+			    | SSCR0_DataSize(8),
+			    drv_data->ioaddr);
+	} else {
+		write_SSCR1(QUARK_X1000_SSCR1_RxTresh(
+					RX_THRESH_QUARK_X1000_DFLT) |
+			    QUARK_X1000_SSCR1_TxTresh(
+					TX_THRESH_QUARK_X1000_DFLT),
+			    drv_data->ioaddr);
+
+		/* using the Motorola SPI protocol and use 8 bit frame */
+		write_SSCR0(QUARK_X1000_SSCR0_Motorola
+			    | QUARK_X1000_SSCR0_DataSize(8),
+			    drv_data->ioaddr);
+	}
+
 	if (!pxa25x_ssp_comp(drv_data))
 		write_SSTO(0, drv_data->ioaddr);
-	write_SSPSP(0, drv_data->ioaddr);
+
+	if (!is_quark_x1000_ssp(drv_data))
+		write_SSPSP(0, drv_data->ioaddr);
 
 	lpss_ssp_setup(drv_data);
 
diff --git a/drivers/spi/spi-pxa2xx.h b/drivers/spi/spi-pxa2xx.h
index 5adc2a1..810440b 100644
--- a/drivers/spi/spi-pxa2xx.h
+++ b/drivers/spi/spi-pxa2xx.h
@@ -93,6 +93,7 @@ struct driver_data {
 struct chip_data {
 	u32 cr0;
 	u32 cr1;
+	u32 dds_rate;
 	u32 psp;
 	u32 timeout;
 	u8 n_bytes;
@@ -126,6 +127,7 @@ DEFINE_SSP_REG(SSCR1, 0x04)
 DEFINE_SSP_REG(SSSR, 0x08)
 DEFINE_SSP_REG(SSITR, 0x0c)
 DEFINE_SSP_REG(SSDR, 0x10)
+DEFINE_SSP_REG(DDS_RATE, 0x28)  /* DDS Clock Rate */
 DEFINE_SSP_REG(SSTO, 0x28)
 DEFINE_SSP_REG(SSPSP, 0x2c)
 DEFINE_SSP_REG(SSITF, SSITF)
@@ -145,6 +147,9 @@ static inline int pxa25x_ssp_comp(struct driver_data *drv_data)
 		return 1;
 	if (drv_data->ssp_type == CE4100_SSP)
 		return 1;
+	if (drv_data->ssp_type == QUARK_X1000_SSP)
+		return 1;
+
 	return 0;
 }
 
@@ -152,7 +157,8 @@ static inline void write_SSSR_CS(struct driver_data *drv_data, u32 val)
 {
 	void __iomem *reg = drv_data->ioaddr;
 
-	if (drv_data->ssp_type == CE4100_SSP)
+	if (drv_data->ssp_type == CE4100_SSP ||
+	    drv_data->ssp_type == QUARK_X1000_SSP)
 		val |= read_SSSR(reg) & SSSR_ALT_FRM_MASK;
 
 	write_SSSR(val, reg);
diff --git a/include/linux/pxa2xx_ssp.h b/include/linux/pxa2xx_ssp.h
index f2b4051..a4668e6 100644
--- a/include/linux/pxa2xx_ssp.h
+++ b/include/linux/pxa2xx_ssp.h
@@ -106,6 +106,26 @@
 #define SSCR1_TxTresh(x) (((x) - 1) << 6) /* level [1..4] */
 #define SSCR1_RFT	(0x00000c00)	/* Receive FIFO Threshold (mask) */
 #define SSCR1_RxTresh(x) (((x) - 1) << 10) /* level [1..4] */
+
+/* QUARK_X1000 SSCR0 bit definition */
+#define QUARK_X1000_SSCR0_DSS	(0x1F)		/* Data Size Select (mask) */
+#define QUARK_X1000_SSCR0_DataSize(x)  ((x) - 1)	/* Data Size Select [4..32] */
+#define QUARK_X1000_SSCR0_FRF	(0x3 << 5)	/* FRame Format (mask) */
+#define QUARK_X1000_SSCR0_Motorola	(0x0 << 5)	/* Motorola's Serial Peripheral Interface (SPI) */
+
+#define RX_THRESH_QUARK_X1000_DFLT	1
+#define TX_THRESH_QUARK_X1000_DFLT	16
+
+#define QUARK_X1000_SSSR_TFL_MASK	(0x1F << 8)	/* Transmit FIFO Level mask */
+#define QUARK_X1000_SSSR_RFL_MASK	(0x1F << 13)	/* Receive FIFO Level mask */
+
+#define QUARK_X1000_SSCR1_TFT	(0x1F << 6)	/* Transmit FIFO Threshold (mask) */
+#define QUARK_X1000_SSCR1_TxTresh(x) (((x) - 1) << 6)	/* level [1..32] */
+#define QUARK_X1000_SSCR1_RFT	(0x1F << 11)	/* Receive FIFO Threshold (mask) */
+#define QUARK_X1000_SSCR1_RxTresh(x) (((x) - 1) << 11)	/* level [1..32] */
+#define QUARK_X1000_SSCR1_STRF       (1 << 17)		/* Select FIFO or EFWR */
+#define QUARK_X1000_SSCR1_EFWR	(1 << 16)		/* Enable FIFO Write/Read */
+
 #endif
 
 /* extra bits in PXA255, PXA26x and PXA27x SSP ports */
@@ -175,6 +195,7 @@ enum pxa_ssp_type {
 	PXA910_SSP,
 	CE4100_SSP,
 	LPSS_SSP,
+	QUARK_X1000_SSP,
 };
 
 struct ssp_device {
-- 
1.7.9.5

