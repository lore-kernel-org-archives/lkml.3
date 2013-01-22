Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312Ab3AVK1U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 05:27:20 -0500
Received: from mga14.intel.com ([143.182.124.37]:61597 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753920Ab3AVKZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 05:25:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,513,1355126400"; 
   d="scan'208";a="193863016"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, chao.bi@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>, cxie4@marvell.com,
        ytang5@marvell.com, Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v3 05/10] spi/pxa2xx: break out the private DMA API usage into a separate file
Date: Tue, 22 Jan 2013 12:26:28 +0200
Message-Id: <1358850393-23111-6-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358850393-23111-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1358850393-23111-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PXA SPI driver uses PXA platform specific private DMA implementation
which does not work on non-PXA platforms. In order to use this driver on
other platforms we break out the private DMA implementation into a separate
file that gets compiled only when CONFIG_SPI_PXA2XX_PXADMA is set. The DMA
functions are stubbed out if there is no DMA implementation selected (i.e
we are building on non-PXA platform).

While we are there we can kill the dummy DMA bits in pxa2xx_spi.h as they
are not needed anymore for CE4100.

Once this is done we can add the generic DMA engine support to the driver
that allows usage of any DMA controller that implements DMA engine API.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
This patch was already acked by Linus W but since I changed this by
breaking out the PXA private implementation into a separate file, I'm
hoping to get new ack from him ;-)

 drivers/spi/Kconfig             |    6 +
 drivers/spi/Makefile            |    4 +-
 drivers/spi/spi-pxa2xx-pxadma.c |  490 ++++++++++++++++++++++++++++++++
 drivers/spi/spi-pxa2xx.c        |  595 ++-------------------------------------
 drivers/spi/spi-pxa2xx.h        |  185 ++++++++++++
 include/linux/spi/pxa2xx_spi.h  |   80 ------
 6 files changed, 712 insertions(+), 648 deletions(-)
 create mode 100644 drivers/spi/spi-pxa2xx-pxadma.c
 create mode 100644 drivers/spi/spi-pxa2xx.h

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index a90393d..f187866 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -297,6 +297,12 @@ config SPI_PPC4xx
 	help
 	  This selects a driver for the PPC4xx SPI Controller.
 
+config SPI_PXA2XX_PXADMA
+	bool "PXA2xx SSP legacy PXA DMA API support"
+	depends on SPI_PXA2XX && ARCH_PXA
+	help
+	  Enable PXA private legacy DMA API support.
+
 config SPI_PXA2XX
 	tristate "PXA2xx SSP SPI master"
 	depends on ARCH_PXA || PCI
diff --git a/drivers/spi/Makefile b/drivers/spi/Makefile
index 64e970b..2e3cdd3 100644
--- a/drivers/spi/Makefile
+++ b/drivers/spi/Makefile
@@ -47,7 +47,9 @@ obj-$(CONFIG_SPI_OMAP24XX)		+= spi-omap2-mcspi.o
 obj-$(CONFIG_SPI_ORION)			+= spi-orion.o
 obj-$(CONFIG_SPI_PL022)			+= spi-pl022.o
 obj-$(CONFIG_SPI_PPC4xx)		+= spi-ppc4xx.o
-obj-$(CONFIG_SPI_PXA2XX)		+= spi-pxa2xx.o
+spi-pxa2xx-platform-objs		:= spi-pxa2xx.o
+spi-pxa2xx-platform-$(CONFIG_SPI_PXA2XX_PXADMA)	+= spi-pxa2xx-pxadma.o
+obj-$(CONFIG_SPI_PXA2XX)		+= spi-pxa2xx-platform.o
 obj-$(CONFIG_SPI_PXA2XX_PCI)		+= spi-pxa2xx-pci.o
 obj-$(CONFIG_SPI_RSPI)			+= spi-rspi.o
 obj-$(CONFIG_SPI_S3C24XX)		+= spi-s3c24xx-hw.o
diff --git a/drivers/spi/spi-pxa2xx-pxadma.c b/drivers/spi/spi-pxa2xx-pxadma.c
new file mode 100644
index 0000000..2916efc
--- /dev/null
+++ b/drivers/spi/spi-pxa2xx-pxadma.c
@@ -0,0 +1,490 @@
+/*
+ * PXA2xx SPI private DMA support.
+ *
+ * Copyright (C) 2005 Stephen Street / StreetFire Sound Labs
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/init.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/dma-mapping.h>
+#include <linux/pxa2xx_ssp.h>
+#include <linux/spi/spi.h>
+#include <linux/spi/pxa2xx_spi.h>
+
+#include "spi-pxa2xx.h"
+
+#define DMA_INT_MASK		(DCSR_ENDINTR | DCSR_STARTINTR | DCSR_BUSERR)
+#define RESET_DMA_CHANNEL	(DCSR_NODESC | DMA_INT_MASK)
+
+bool pxa2xx_spi_dma_is_possible(size_t len)
+{
+	/* Try to map dma buffer and do a dma transfer if successful, but
+	 * only if the length is non-zero and less than MAX_DMA_LEN.
+	 *
+	 * Zero-length non-descriptor DMA is illegal on PXA2xx; force use
+	 * of PIO instead.  Care is needed above because the transfer may
+	 * have have been passed with buffers that are already dma mapped.
+	 * A zero-length transfer in PIO mode will not try to write/read
+	 * to/from the buffers
+	 *
+	 * REVISIT large transfers are exactly where we most want to be
+	 * using DMA.  If this happens much, split those transfers into
+	 * multiple DMA segments rather than forcing PIO.
+	 */
+	return len > 0 && len <= MAX_DMA_LEN;
+}
+
+int pxa2xx_spi_map_dma_buffers(struct driver_data *drv_data)
+{
+	struct spi_message *msg = drv_data->cur_msg;
+	struct device *dev = &msg->spi->dev;
+
+	if (!drv_data->cur_chip->enable_dma)
+		return 0;
+
+	if (msg->is_dma_mapped)
+		return  drv_data->rx_dma && drv_data->tx_dma;
+
+	if (!IS_DMA_ALIGNED(drv_data->rx) || !IS_DMA_ALIGNED(drv_data->tx))
+		return 0;
+
+	/* Modify setup if rx buffer is null */
+	if (drv_data->rx == NULL) {
+		*drv_data->null_dma_buf = 0;
+		drv_data->rx = drv_data->null_dma_buf;
+		drv_data->rx_map_len = 4;
+	} else
+		drv_data->rx_map_len = drv_data->len;
+
+
+	/* Modify setup if tx buffer is null */
+	if (drv_data->tx == NULL) {
+		*drv_data->null_dma_buf = 0;
+		drv_data->tx = drv_data->null_dma_buf;
+		drv_data->tx_map_len = 4;
+	} else
+		drv_data->tx_map_len = drv_data->len;
+
+	/* Stream map the tx buffer. Always do DMA_TO_DEVICE first
+	 * so we flush the cache *before* invalidating it, in case
+	 * the tx and rx buffers overlap.
+	 */
+	drv_data->tx_dma = dma_map_single(dev, drv_data->tx,
+					drv_data->tx_map_len, DMA_TO_DEVICE);
+	if (dma_mapping_error(dev, drv_data->tx_dma))
+		return 0;
+
+	/* Stream map the rx buffer */
+	drv_data->rx_dma = dma_map_single(dev, drv_data->rx,
+					drv_data->rx_map_len, DMA_FROM_DEVICE);
+	if (dma_mapping_error(dev, drv_data->rx_dma)) {
+		dma_unmap_single(dev, drv_data->tx_dma,
+					drv_data->tx_map_len, DMA_TO_DEVICE);
+		return 0;
+	}
+
+	return 1;
+}
+
+static void pxa2xx_spi_unmap_dma_buffers(struct driver_data *drv_data)
+{
+	struct device *dev;
+
+	if (!drv_data->dma_mapped)
+		return;
+
+	if (!drv_data->cur_msg->is_dma_mapped) {
+		dev = &drv_data->cur_msg->spi->dev;
+		dma_unmap_single(dev, drv_data->rx_dma,
+					drv_data->rx_map_len, DMA_FROM_DEVICE);
+		dma_unmap_single(dev, drv_data->tx_dma,
+					drv_data->tx_map_len, DMA_TO_DEVICE);
+	}
+
+	drv_data->dma_mapped = 0;
+}
+
+static int wait_ssp_rx_stall(void const __iomem *ioaddr)
+{
+	unsigned long limit = loops_per_jiffy << 1;
+
+	while ((read_SSSR(ioaddr) & SSSR_BSY) && --limit)
+		cpu_relax();
+
+	return limit;
+}
+
+static int wait_dma_channel_stop(int channel)
+{
+	unsigned long limit = loops_per_jiffy << 1;
+
+	while (!(DCSR(channel) & DCSR_STOPSTATE) && --limit)
+		cpu_relax();
+
+	return limit;
+}
+
+static void pxa2xx_spi_dma_error_stop(struct driver_data *drv_data,
+				      const char *msg)
+{
+	void __iomem *reg = drv_data->ioaddr;
+
+	/* Stop and reset */
+	DCSR(drv_data->rx_channel) = RESET_DMA_CHANNEL;
+	DCSR(drv_data->tx_channel) = RESET_DMA_CHANNEL;
+	write_SSSR_CS(drv_data, drv_data->clear_sr);
+	write_SSCR1(read_SSCR1(reg) & ~drv_data->dma_cr1, reg);
+	if (!pxa25x_ssp_comp(drv_data))
+		write_SSTO(0, reg);
+	pxa2xx_spi_flush(drv_data);
+	write_SSCR0(read_SSCR0(reg) & ~SSCR0_SSE, reg);
+
+	pxa2xx_spi_unmap_dma_buffers(drv_data);
+
+	dev_err(&drv_data->pdev->dev, "%s\n", msg);
+
+	drv_data->cur_msg->state = ERROR_STATE;
+	tasklet_schedule(&drv_data->pump_transfers);
+}
+
+static void pxa2xx_spi_dma_transfer_complete(struct driver_data *drv_data)
+{
+	void __iomem *reg = drv_data->ioaddr;
+	struct spi_message *msg = drv_data->cur_msg;
+
+	/* Clear and disable interrupts on SSP and DMA channels*/
+	write_SSCR1(read_SSCR1(reg) & ~drv_data->dma_cr1, reg);
+	write_SSSR_CS(drv_data, drv_data->clear_sr);
+	DCSR(drv_data->tx_channel) = RESET_DMA_CHANNEL;
+	DCSR(drv_data->rx_channel) = RESET_DMA_CHANNEL;
+
+	if (wait_dma_channel_stop(drv_data->rx_channel) == 0)
+		dev_err(&drv_data->pdev->dev,
+			"dma_handler: dma rx channel stop failed\n");
+
+	if (wait_ssp_rx_stall(drv_data->ioaddr) == 0)
+		dev_err(&drv_data->pdev->dev,
+			"dma_transfer: ssp rx stall failed\n");
+
+	pxa2xx_spi_unmap_dma_buffers(drv_data);
+
+	/* update the buffer pointer for the amount completed in dma */
+	drv_data->rx += drv_data->len -
+			(DCMD(drv_data->rx_channel) & DCMD_LENGTH);
+
+	/* read trailing data from fifo, it does not matter how many
+	 * bytes are in the fifo just read until buffer is full
+	 * or fifo is empty, which ever occurs first */
+	drv_data->read(drv_data);
+
+	/* return count of what was actually read */
+	msg->actual_length += drv_data->len -
+				(drv_data->rx_end - drv_data->rx);
+
+	/* Transfer delays and chip select release are
+	 * handled in pump_transfers or giveback
+	 */
+
+	/* Move to next transfer */
+	msg->state = pxa2xx_spi_next_transfer(drv_data);
+
+	/* Schedule transfer tasklet */
+	tasklet_schedule(&drv_data->pump_transfers);
+}
+
+void pxa2xx_spi_dma_handler(int channel, void *data)
+{
+	struct driver_data *drv_data = data;
+	u32 irq_status = DCSR(channel) & DMA_INT_MASK;
+
+	if (irq_status & DCSR_BUSERR) {
+
+		if (channel == drv_data->tx_channel)
+			pxa2xx_spi_dma_error_stop(drv_data,
+				"dma_handler: bad bus address on tx channel");
+		else
+			pxa2xx_spi_dma_error_stop(drv_data,
+				"dma_handler: bad bus address on rx channel");
+		return;
+	}
+
+	/* PXA255x_SSP has no timeout interrupt, wait for tailing bytes */
+	if ((channel == drv_data->tx_channel)
+		&& (irq_status & DCSR_ENDINTR)
+		&& (drv_data->ssp_type == PXA25x_SSP)) {
+
+		/* Wait for rx to stall */
+		if (wait_ssp_rx_stall(drv_data->ioaddr) == 0)
+			dev_err(&drv_data->pdev->dev,
+				"dma_handler: ssp rx stall failed\n");
+
+		/* finish this transfer, start the next */
+		pxa2xx_spi_dma_transfer_complete(drv_data);
+	}
+}
+
+irqreturn_t pxa2xx_spi_dma_transfer(struct driver_data *drv_data)
+{
+	u32 irq_status;
+	void __iomem *reg = drv_data->ioaddr;
+
+	irq_status = read_SSSR(reg) & drv_data->mask_sr;
+	if (irq_status & SSSR_ROR) {
+		pxa2xx_spi_dma_error_stop(drv_data,
+					  "dma_transfer: fifo overrun");
+		return IRQ_HANDLED;
+	}
+
+	/* Check for false positive timeout */
+	if ((irq_status & SSSR_TINT)
+		&& (DCSR(drv_data->tx_channel) & DCSR_RUN)) {
+		write_SSSR(SSSR_TINT, reg);
+		return IRQ_HANDLED;
+	}
+
+	if (irq_status & SSSR_TINT || drv_data->rx == drv_data->rx_end) {
+
+		/* Clear and disable timeout interrupt, do the rest in
+		 * dma_transfer_complete */
+		if (!pxa25x_ssp_comp(drv_data))
+			write_SSTO(0, reg);
+
+		/* finish this transfer, start the next */
+		pxa2xx_spi_dma_transfer_complete(drv_data);
+
+		return IRQ_HANDLED;
+	}
+
+	/* Opps problem detected */
+	return IRQ_NONE;
+}
+
+int pxa2xx_spi_dma_prepare(struct driver_data *drv_data, u32 dma_burst)
+{
+	u32 dma_width;
+
+	switch (drv_data->n_bytes) {
+	case 1:
+		dma_width = DCMD_WIDTH1;
+		break;
+	case 2:
+		dma_width = DCMD_WIDTH2;
+		break;
+	default:
+		dma_width = DCMD_WIDTH4;
+		break;
+	}
+
+	/* Setup rx DMA Channel */
+	DCSR(drv_data->rx_channel) = RESET_DMA_CHANNEL;
+	DSADR(drv_data->rx_channel) = drv_data->ssdr_physical;
+	DTADR(drv_data->rx_channel) = drv_data->rx_dma;
+	if (drv_data->rx == drv_data->null_dma_buf)
+		/* No target address increment */
+		DCMD(drv_data->rx_channel) = DCMD_FLOWSRC
+						| dma_width
+						| dma_burst
+						| drv_data->len;
+	else
+		DCMD(drv_data->rx_channel) = DCMD_INCTRGADDR
+						| DCMD_FLOWSRC
+						| dma_width
+						| dma_burst
+						| drv_data->len;
+
+	/* Setup tx DMA Channel */
+	DCSR(drv_data->tx_channel) = RESET_DMA_CHANNEL;
+	DSADR(drv_data->tx_channel) = drv_data->tx_dma;
+	DTADR(drv_data->tx_channel) = drv_data->ssdr_physical;
+	if (drv_data->tx == drv_data->null_dma_buf)
+		/* No source address increment */
+		DCMD(drv_data->tx_channel) = DCMD_FLOWTRG
+						| dma_width
+						| dma_burst
+						| drv_data->len;
+	else
+		DCMD(drv_data->tx_channel) = DCMD_INCSRCADDR
+						| DCMD_FLOWTRG
+						| dma_width
+						| dma_burst
+						| drv_data->len;
+
+	/* Enable dma end irqs on SSP to detect end of transfer */
+	if (drv_data->ssp_type == PXA25x_SSP)
+		DCMD(drv_data->tx_channel) |= DCMD_ENDIRQEN;
+
+	return 0;
+}
+
+void pxa2xx_spi_dma_start(struct driver_data *drv_data)
+{
+	DCSR(drv_data->rx_channel) |= DCSR_RUN;
+	DCSR(drv_data->tx_channel) |= DCSR_RUN;
+}
+
+int pxa2xx_spi_dma_setup(struct driver_data *drv_data)
+{
+	struct device *dev = &drv_data->pdev->dev;
+	struct ssp_device *ssp = drv_data->ssp;
+
+	/* Get two DMA channels	(rx and tx) */
+	drv_data->rx_channel = pxa_request_dma("pxa2xx_spi_ssp_rx",
+						DMA_PRIO_HIGH,
+						pxa2xx_spi_dma_handler,
+						drv_data);
+	if (drv_data->rx_channel < 0) {
+		dev_err(dev, "problem (%d) requesting rx channel\n",
+			drv_data->rx_channel);
+		return -ENODEV;
+	}
+	drv_data->tx_channel = pxa_request_dma("pxa2xx_spi_ssp_tx",
+						DMA_PRIO_MEDIUM,
+						pxa2xx_spi_dma_handler,
+						drv_data);
+	if (drv_data->tx_channel < 0) {
+		dev_err(dev, "problem (%d) requesting tx channel\n",
+			drv_data->tx_channel);
+		pxa_free_dma(drv_data->rx_channel);
+		return -ENODEV;
+	}
+
+	DRCMR(ssp->drcmr_rx) = DRCMR_MAPVLD | drv_data->rx_channel;
+	DRCMR(ssp->drcmr_tx) = DRCMR_MAPVLD | drv_data->tx_channel;
+
+	return 0;
+}
+
+void pxa2xx_spi_dma_release(struct driver_data *drv_data)
+{
+	struct ssp_device *ssp = drv_data->ssp;
+
+	DRCMR(ssp->drcmr_rx) = 0;
+	DRCMR(ssp->drcmr_tx) = 0;
+
+	if (drv_data->tx_channel != 0)
+		pxa_free_dma(drv_data->tx_channel);
+	if (drv_data->rx_channel != 0)
+		pxa_free_dma(drv_data->rx_channel);
+}
+
+void pxa2xx_spi_dma_resume(struct driver_data *drv_data)
+{
+	if (drv_data->rx_channel != -1)
+		DRCMR(drv_data->ssp->drcmr_rx) =
+			DRCMR_MAPVLD | drv_data->rx_channel;
+	if (drv_data->tx_channel != -1)
+		DRCMR(drv_data->ssp->drcmr_tx) =
+			DRCMR_MAPVLD | drv_data->tx_channel;
+}
+
+int pxa2xx_spi_set_dma_burst_and_threshold(struct chip_data *chip,
+					   struct spi_device *spi,
+					   u8 bits_per_word, u32 *burst_code,
+					   u32 *threshold)
+{
+	struct pxa2xx_spi_chip *chip_info =
+			(struct pxa2xx_spi_chip *)spi->controller_data;
+	int bytes_per_word;
+	int burst_bytes;
+	int thresh_words;
+	int req_burst_size;
+	int retval = 0;
+
+	/* Set the threshold (in registers) to equal the same amount of data
+	 * as represented by burst size (in bytes).  The computation below
+	 * is (burst_size rounded up to nearest 8 byte, word or long word)
+	 * divided by (bytes/register); the tx threshold is the inverse of
+	 * the rx, so that there will always be enough data in the rx fifo
+	 * to satisfy a burst, and there will always be enough space in the
+	 * tx fifo to accept a burst (a tx burst will overwrite the fifo if
+	 * there is not enough space), there must always remain enough empty
+	 * space in the rx fifo for any data loaded to the tx fifo.
+	 * Whenever burst_size (in bytes) equals bits/word, the fifo threshold
+	 * will be 8, or half the fifo;
+	 * The threshold can only be set to 2, 4 or 8, but not 16, because
+	 * to burst 16 to the tx fifo, the fifo would have to be empty;
+	 * however, the minimum fifo trigger level is 1, and the tx will
+	 * request service when the fifo is at this level, with only 15 spaces.
+	 */
+
+	/* find bytes/word */
+	if (bits_per_word <= 8)
+		bytes_per_word = 1;
+	else if (bits_per_word <= 16)
+		bytes_per_word = 2;
+	else
+		bytes_per_word = 4;
+
+	/* use struct pxa2xx_spi_chip->dma_burst_size if available */
+	if (chip_info)
+		req_burst_size = chip_info->dma_burst_size;
+	else {
+		switch (chip->dma_burst_size) {
+		default:
+			/* if the default burst size is not set,
+			 * do it now */
+			chip->dma_burst_size = DCMD_BURST8;
+		case DCMD_BURST8:
+			req_burst_size = 8;
+			break;
+		case DCMD_BURST16:
+			req_burst_size = 16;
+			break;
+		case DCMD_BURST32:
+			req_burst_size = 32;
+			break;
+		}
+	}
+	if (req_burst_size <= 8) {
+		*burst_code = DCMD_BURST8;
+		burst_bytes = 8;
+	} else if (req_burst_size <= 16) {
+		if (bytes_per_word == 1) {
+			/* don't burst more than 1/2 the fifo */
+			*burst_code = DCMD_BURST8;
+			burst_bytes = 8;
+			retval = 1;
+		} else {
+			*burst_code = DCMD_BURST16;
+			burst_bytes = 16;
+		}
+	} else {
+		if (bytes_per_word == 1) {
+			/* don't burst more than 1/2 the fifo */
+			*burst_code = DCMD_BURST8;
+			burst_bytes = 8;
+			retval = 1;
+		} else if (bytes_per_word == 2) {
+			/* don't burst more than 1/2 the fifo */
+			*burst_code = DCMD_BURST16;
+			burst_bytes = 16;
+			retval = 1;
+		} else {
+			*burst_code = DCMD_BURST32;
+			burst_bytes = 32;
+		}
+	}
+
+	thresh_words = burst_bytes / bytes_per_word;
+
+	/* thresh_words will be between 2 and 8 */
+	*threshold = (SSCR1_RxTresh(thresh_words) & SSCR1_RFT)
+			| (SSCR1_TxTresh(16-thresh_words) & SSCR1_TFT);
+
+	return retval;
+}
diff --git a/drivers/spi/spi-pxa2xx.c b/drivers/spi/spi-pxa2xx.c
index 304cf6e..5b7c2a4 100644
--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -24,7 +24,6 @@
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
 #include <linux/spi/pxa2xx_spi.h>
-#include <linux/dma-mapping.h>
 #include <linux/spi/spi.h>
 #include <linux/workqueue.h>
 #include <linux/delay.h>
@@ -36,6 +35,7 @@
 #include <asm/irq.h>
 #include <asm/delay.h>
 
+#include "spi-pxa2xx.h"
 
 MODULE_AUTHOR("Stephen Street");
 MODULE_DESCRIPTION("PXA2xx SSP SPI Controller");
@@ -46,12 +46,6 @@ MODULE_ALIAS("platform:pxa2xx-spi");
 
 #define TIMOUT_DFLT		1000
 
-#define DMA_INT_MASK		(DCSR_ENDINTR | DCSR_STARTINTR | DCSR_BUSERR)
-#define RESET_DMA_CHANNEL	(DCSR_NODESC | DMA_INT_MASK)
-#define IS_DMA_ALIGNED(x)	IS_ALIGNED((unsigned long)(x), DMA_ALIGNMENT)
-#define MAX_DMA_LEN		8191
-#define DMA_ALIGNMENT		8
-
 /*
  * for testing SSCR1 changes that require SSP restart, basically
  * everything except the service and interrupt enables, the pxa270 developer
@@ -66,106 +60,6 @@ MODULE_ALIAS("platform:pxa2xx-spi");
 				| SSCR1_RFT | SSCR1_TFT | SSCR1_MWDS \
 				| SSCR1_SPH | SSCR1_SPO | SSCR1_LBM)
 
-#define DEFINE_SSP_REG(reg, off) \
-static inline u32 read_##reg(void const __iomem *p) \
-{ return __raw_readl(p + (off)); } \
-\
-static inline void write_##reg(u32 v, void __iomem *p) \
-{ __raw_writel(v, p + (off)); }
-
-DEFINE_SSP_REG(SSCR0, 0x00)
-DEFINE_SSP_REG(SSCR1, 0x04)
-DEFINE_SSP_REG(SSSR, 0x08)
-DEFINE_SSP_REG(SSITR, 0x0c)
-DEFINE_SSP_REG(SSDR, 0x10)
-DEFINE_SSP_REG(SSTO, 0x28)
-DEFINE_SSP_REG(SSPSP, 0x2c)
-
-#define START_STATE ((void*)0)
-#define RUNNING_STATE ((void*)1)
-#define DONE_STATE ((void*)2)
-#define ERROR_STATE ((void*)-1)
-
-struct driver_data {
-	/* Driver model hookup */
-	struct platform_device *pdev;
-
-	/* SSP Info */
-	struct ssp_device *ssp;
-
-	/* SPI framework hookup */
-	enum pxa_ssp_type ssp_type;
-	struct spi_master *master;
-
-	/* PXA hookup */
-	struct pxa2xx_spi_master *master_info;
-
-	/* DMA setup stuff */
-	int rx_channel;
-	int tx_channel;
-	u32 *null_dma_buf;
-
-	/* SSP register addresses */
-	void __iomem *ioaddr;
-	u32 ssdr_physical;
-
-	/* SSP masks*/
-	u32 dma_cr1;
-	u32 int_cr1;
-	u32 clear_sr;
-	u32 mask_sr;
-
-	/* Maximun clock rate */
-	unsigned long max_clk_rate;
-
-	/* Message Transfer pump */
-	struct tasklet_struct pump_transfers;
-
-	/* Current message transfer state info */
-	struct spi_message* cur_msg;
-	struct spi_transfer* cur_transfer;
-	struct chip_data *cur_chip;
-	size_t len;
-	void *tx;
-	void *tx_end;
-	void *rx;
-	void *rx_end;
-	int dma_mapped;
-	dma_addr_t rx_dma;
-	dma_addr_t tx_dma;
-	size_t rx_map_len;
-	size_t tx_map_len;
-	u8 n_bytes;
-	u32 dma_width;
-	int (*write)(struct driver_data *drv_data);
-	int (*read)(struct driver_data *drv_data);
-	irqreturn_t (*transfer_handler)(struct driver_data *drv_data);
-	void (*cs_control)(u32 command);
-};
-
-struct chip_data {
-	u32 cr0;
-	u32 cr1;
-	u32 psp;
-	u32 timeout;
-	u8 n_bytes;
-	u32 dma_width;
-	u32 dma_burst_size;
-	u32 threshold;
-	u32 dma_threshold;
-	u8 enable_dma;
-	u8 bits_per_word;
-	u32 speed_hz;
-	union {
-		int gpio_cs;
-		unsigned int frm;
-	};
-	int gpio_cs_inverted;
-	int (*write)(struct driver_data *drv_data);
-	int (*read)(struct driver_data *drv_data);
-	void (*cs_control)(u32 command);
-};
-
 static void cs_assert(struct driver_data *drv_data)
 {
 	struct chip_data *chip = drv_data->cur_chip;
@@ -200,26 +94,7 @@ static void cs_deassert(struct driver_data *drv_data)
 		gpio_set_value(chip->gpio_cs, !chip->gpio_cs_inverted);
 }
 
-static void write_SSSR_CS(struct driver_data *drv_data, u32 val)
-{
-	void __iomem *reg = drv_data->ioaddr;
-
-	if (drv_data->ssp_type == CE4100_SSP)
-		val |= read_SSSR(reg) & SSSR_ALT_FRM_MASK;
-
-	write_SSSR(val, reg);
-}
-
-static int pxa25x_ssp_comp(struct driver_data *drv_data)
-{
-	if (drv_data->ssp_type == PXA25x_SSP)
-		return 1;
-	if (drv_data->ssp_type == CE4100_SSP)
-		return 1;
-	return 0;
-}
-
-static int flush(struct driver_data *drv_data)
+int pxa2xx_spi_flush(struct driver_data *drv_data)
 {
 	unsigned long limit = loops_per_jiffy << 1;
 
@@ -345,7 +220,7 @@ static int u32_reader(struct driver_data *drv_data)
 	return drv_data->rx == drv_data->rx_end;
 }
 
-static void *next_transfer(struct driver_data *drv_data)
+void *pxa2xx_spi_next_transfer(struct driver_data *drv_data)
 {
 	struct spi_message *msg = drv_data->cur_msg;
 	struct spi_transfer *trans = drv_data->cur_transfer;
@@ -361,76 +236,6 @@ static void *next_transfer(struct driver_data *drv_data)
 		return DONE_STATE;
 }
 
-static int map_dma_buffers(struct driver_data *drv_data)
-{
-	struct spi_message *msg = drv_data->cur_msg;
-	struct device *dev = &msg->spi->dev;
-
-	if (!drv_data->cur_chip->enable_dma)
-		return 0;
-
-	if (msg->is_dma_mapped)
-		return  drv_data->rx_dma && drv_data->tx_dma;
-
-	if (!IS_DMA_ALIGNED(drv_data->rx) || !IS_DMA_ALIGNED(drv_data->tx))
-		return 0;
-
-	/* Modify setup if rx buffer is null */
-	if (drv_data->rx == NULL) {
-		*drv_data->null_dma_buf = 0;
-		drv_data->rx = drv_data->null_dma_buf;
-		drv_data->rx_map_len = 4;
-	} else
-		drv_data->rx_map_len = drv_data->len;
-
-
-	/* Modify setup if tx buffer is null */
-	if (drv_data->tx == NULL) {
-		*drv_data->null_dma_buf = 0;
-		drv_data->tx = drv_data->null_dma_buf;
-		drv_data->tx_map_len = 4;
-	} else
-		drv_data->tx_map_len = drv_data->len;
-
-	/* Stream map the tx buffer. Always do DMA_TO_DEVICE first
-	 * so we flush the cache *before* invalidating it, in case
-	 * the tx and rx buffers overlap.
-	 */
-	drv_data->tx_dma = dma_map_single(dev, drv_data->tx,
-					drv_data->tx_map_len, DMA_TO_DEVICE);
-	if (dma_mapping_error(dev, drv_data->tx_dma))
-		return 0;
-
-	/* Stream map the rx buffer */
-	drv_data->rx_dma = dma_map_single(dev, drv_data->rx,
-					drv_data->rx_map_len, DMA_FROM_DEVICE);
-	if (dma_mapping_error(dev, drv_data->rx_dma)) {
-		dma_unmap_single(dev, drv_data->tx_dma,
-					drv_data->tx_map_len, DMA_TO_DEVICE);
-		return 0;
-	}
-
-	return 1;
-}
-
-static void unmap_dma_buffers(struct driver_data *drv_data)
-{
-	struct device *dev;
-
-	if (!drv_data->dma_mapped)
-		return;
-
-	if (!drv_data->cur_msg->is_dma_mapped) {
-		dev = &drv_data->cur_msg->spi->dev;
-		dma_unmap_single(dev, drv_data->rx_dma,
-					drv_data->rx_map_len, DMA_FROM_DEVICE);
-		dma_unmap_single(dev, drv_data->tx_dma,
-					drv_data->tx_map_len, DMA_TO_DEVICE);
-	}
-
-	drv_data->dma_mapped = 0;
-}
-
 /* caller already set message->status; dma and pio irqs are blocked */
 static void giveback(struct driver_data *drv_data)
 {
@@ -483,161 +288,6 @@ static void giveback(struct driver_data *drv_data)
 	drv_data->cur_chip = NULL;
 }
 
-static int wait_ssp_rx_stall(void const __iomem *ioaddr)
-{
-	unsigned long limit = loops_per_jiffy << 1;
-
-	while ((read_SSSR(ioaddr) & SSSR_BSY) && --limit)
-		cpu_relax();
-
-	return limit;
-}
-
-static int wait_dma_channel_stop(int channel)
-{
-	unsigned long limit = loops_per_jiffy << 1;
-
-	while (!(DCSR(channel) & DCSR_STOPSTATE) && --limit)
-		cpu_relax();
-
-	return limit;
-}
-
-static void dma_error_stop(struct driver_data *drv_data, const char *msg)
-{
-	void __iomem *reg = drv_data->ioaddr;
-
-	/* Stop and reset */
-	DCSR(drv_data->rx_channel) = RESET_DMA_CHANNEL;
-	DCSR(drv_data->tx_channel) = RESET_DMA_CHANNEL;
-	write_SSSR_CS(drv_data, drv_data->clear_sr);
-	write_SSCR1(read_SSCR1(reg) & ~drv_data->dma_cr1, reg);
-	if (!pxa25x_ssp_comp(drv_data))
-		write_SSTO(0, reg);
-	flush(drv_data);
-	write_SSCR0(read_SSCR0(reg) & ~SSCR0_SSE, reg);
-
-	unmap_dma_buffers(drv_data);
-
-	dev_err(&drv_data->pdev->dev, "%s\n", msg);
-
-	drv_data->cur_msg->state = ERROR_STATE;
-	tasklet_schedule(&drv_data->pump_transfers);
-}
-
-static void dma_transfer_complete(struct driver_data *drv_data)
-{
-	void __iomem *reg = drv_data->ioaddr;
-	struct spi_message *msg = drv_data->cur_msg;
-
-	/* Clear and disable interrupts on SSP and DMA channels*/
-	write_SSCR1(read_SSCR1(reg) & ~drv_data->dma_cr1, reg);
-	write_SSSR_CS(drv_data, drv_data->clear_sr);
-	DCSR(drv_data->tx_channel) = RESET_DMA_CHANNEL;
-	DCSR(drv_data->rx_channel) = RESET_DMA_CHANNEL;
-
-	if (wait_dma_channel_stop(drv_data->rx_channel) == 0)
-		dev_err(&drv_data->pdev->dev,
-			"dma_handler: dma rx channel stop failed\n");
-
-	if (wait_ssp_rx_stall(drv_data->ioaddr) == 0)
-		dev_err(&drv_data->pdev->dev,
-			"dma_transfer: ssp rx stall failed\n");
-
-	unmap_dma_buffers(drv_data);
-
-	/* update the buffer pointer for the amount completed in dma */
-	drv_data->rx += drv_data->len -
-			(DCMD(drv_data->rx_channel) & DCMD_LENGTH);
-
-	/* read trailing data from fifo, it does not matter how many
-	 * bytes are in the fifo just read until buffer is full
-	 * or fifo is empty, which ever occurs first */
-	drv_data->read(drv_data);
-
-	/* return count of what was actually read */
-	msg->actual_length += drv_data->len -
-				(drv_data->rx_end - drv_data->rx);
-
-	/* Transfer delays and chip select release are
-	 * handled in pump_transfers or giveback
-	 */
-
-	/* Move to next transfer */
-	msg->state = next_transfer(drv_data);
-
-	/* Schedule transfer tasklet */
-	tasklet_schedule(&drv_data->pump_transfers);
-}
-
-static void dma_handler(int channel, void *data)
-{
-	struct driver_data *drv_data = data;
-	u32 irq_status = DCSR(channel) & DMA_INT_MASK;
-
-	if (irq_status & DCSR_BUSERR) {
-
-		if (channel == drv_data->tx_channel)
-			dma_error_stop(drv_data,
-					"dma_handler: "
-					"bad bus address on tx channel");
-		else
-			dma_error_stop(drv_data,
-					"dma_handler: "
-					"bad bus address on rx channel");
-		return;
-	}
-
-	/* PXA255x_SSP has no timeout interrupt, wait for tailing bytes */
-	if ((channel == drv_data->tx_channel)
-		&& (irq_status & DCSR_ENDINTR)
-		&& (drv_data->ssp_type == PXA25x_SSP)) {
-
-		/* Wait for rx to stall */
-		if (wait_ssp_rx_stall(drv_data->ioaddr) == 0)
-			dev_err(&drv_data->pdev->dev,
-				"dma_handler: ssp rx stall failed\n");
-
-		/* finish this transfer, start the next */
-		dma_transfer_complete(drv_data);
-	}
-}
-
-static irqreturn_t dma_transfer(struct driver_data *drv_data)
-{
-	u32 irq_status;
-	void __iomem *reg = drv_data->ioaddr;
-
-	irq_status = read_SSSR(reg) & drv_data->mask_sr;
-	if (irq_status & SSSR_ROR) {
-		dma_error_stop(drv_data, "dma_transfer: fifo overrun");
-		return IRQ_HANDLED;
-	}
-
-	/* Check for false positive timeout */
-	if ((irq_status & SSSR_TINT)
-		&& (DCSR(drv_data->tx_channel) & DCSR_RUN)) {
-		write_SSSR(SSSR_TINT, reg);
-		return IRQ_HANDLED;
-	}
-
-	if (irq_status & SSSR_TINT || drv_data->rx == drv_data->rx_end) {
-
-		/* Clear and disable timeout interrupt, do the rest in
-		 * dma_transfer_complete */
-		if (!pxa25x_ssp_comp(drv_data))
-			write_SSTO(0, reg);
-
-		/* finish this transfer, start the next */
-		dma_transfer_complete(drv_data);
-
-		return IRQ_HANDLED;
-	}
-
-	/* Opps problem detected */
-	return IRQ_NONE;
-}
-
 static void reset_sccr1(struct driver_data *drv_data)
 {
 	void __iomem *reg = drv_data->ioaddr;
@@ -659,7 +309,7 @@ static void int_error_stop(struct driver_data *drv_data, const char* msg)
 	reset_sccr1(drv_data);
 	if (!pxa25x_ssp_comp(drv_data))
 		write_SSTO(0, reg);
-	flush(drv_data);
+	pxa2xx_spi_flush(drv_data);
 	write_SSCR0(read_SSCR0(reg) & ~SSCR0_SSE, reg);
 
 	dev_err(&drv_data->pdev->dev, "%s\n", msg);
@@ -687,7 +337,7 @@ static void int_transfer_complete(struct driver_data *drv_data)
 	 */
 
 	/* Move to next transfer */
-	drv_data->cur_msg->state = next_transfer(drv_data);
+	drv_data->cur_msg->state = pxa2xx_spi_next_transfer(drv_data);
 
 	/* Schedule transfer tasklet */
 	tasklet_schedule(&drv_data->pump_transfers);
@@ -798,103 +448,6 @@ static irqreturn_t ssp_int(int irq, void *dev_id)
 	return drv_data->transfer_handler(drv_data);
 }
 
-static int set_dma_burst_and_threshold(struct chip_data *chip,
-				struct spi_device *spi,
-				u8 bits_per_word, u32 *burst_code,
-				u32 *threshold)
-{
-	struct pxa2xx_spi_chip *chip_info =
-			(struct pxa2xx_spi_chip *)spi->controller_data;
-	int bytes_per_word;
-	int burst_bytes;
-	int thresh_words;
-	int req_burst_size;
-	int retval = 0;
-
-	/* Set the threshold (in registers) to equal the same amount of data
-	 * as represented by burst size (in bytes).  The computation below
-	 * is (burst_size rounded up to nearest 8 byte, word or long word)
-	 * divided by (bytes/register); the tx threshold is the inverse of
-	 * the rx, so that there will always be enough data in the rx fifo
-	 * to satisfy a burst, and there will always be enough space in the
-	 * tx fifo to accept a burst (a tx burst will overwrite the fifo if
-	 * there is not enough space), there must always remain enough empty
-	 * space in the rx fifo for any data loaded to the tx fifo.
-	 * Whenever burst_size (in bytes) equals bits/word, the fifo threshold
-	 * will be 8, or half the fifo;
-	 * The threshold can only be set to 2, 4 or 8, but not 16, because
-	 * to burst 16 to the tx fifo, the fifo would have to be empty;
-	 * however, the minimum fifo trigger level is 1, and the tx will
-	 * request service when the fifo is at this level, with only 15 spaces.
-	 */
-
-	/* find bytes/word */
-	if (bits_per_word <= 8)
-		bytes_per_word = 1;
-	else if (bits_per_word <= 16)
-		bytes_per_word = 2;
-	else
-		bytes_per_word = 4;
-
-	/* use struct pxa2xx_spi_chip->dma_burst_size if available */
-	if (chip_info)
-		req_burst_size = chip_info->dma_burst_size;
-	else {
-		switch (chip->dma_burst_size) {
-		default:
-			/* if the default burst size is not set,
-			 * do it now */
-			chip->dma_burst_size = DCMD_BURST8;
-		case DCMD_BURST8:
-			req_burst_size = 8;
-			break;
-		case DCMD_BURST16:
-			req_burst_size = 16;
-			break;
-		case DCMD_BURST32:
-			req_burst_size = 32;
-			break;
-		}
-	}
-	if (req_burst_size <= 8) {
-		*burst_code = DCMD_BURST8;
-		burst_bytes = 8;
-	} else if (req_burst_size <= 16) {
-		if (bytes_per_word == 1) {
-			/* don't burst more than 1/2 the fifo */
-			*burst_code = DCMD_BURST8;
-			burst_bytes = 8;
-			retval = 1;
-		} else {
-			*burst_code = DCMD_BURST16;
-			burst_bytes = 16;
-		}
-	} else {
-		if (bytes_per_word == 1) {
-			/* don't burst more than 1/2 the fifo */
-			*burst_code = DCMD_BURST8;
-			burst_bytes = 8;
-			retval = 1;
-		} else if (bytes_per_word == 2) {
-			/* don't burst more than 1/2 the fifo */
-			*burst_code = DCMD_BURST16;
-			burst_bytes = 16;
-			retval = 1;
-		} else {
-			*burst_code = DCMD_BURST32;
-			burst_bytes = 32;
-		}
-	}
-
-	thresh_words = burst_bytes / bytes_per_word;
-
-	/* thresh_words will be between 2 and 8 */
-	*threshold = (SSCR1_RxTresh(thresh_words) & SSCR1_RFT)
-			| (SSCR1_TxTresh(16-thresh_words) & SSCR1_TFT);
-
-	return retval;
-}
-
 static unsigned int ssp_get_clk_div(struct driver_data *drv_data, int rate)
 {
 	unsigned long ssp_clk = drv_data->max_clk_rate;
@@ -956,8 +509,8 @@ static void pump_transfers(unsigned long data)
 			cs_deassert(drv_data);
 	}
 
-	/* Check for transfers that need multiple DMA segments */
-	if (transfer->len > MAX_DMA_LEN && chip->enable_dma) {
+	/* Check if we can DMA this transfer */
+	if (!pxa2xx_spi_dma_is_possible(transfer->len) && chip->enable_dma) {
 
 		/* reject already-mapped transfers; PIO won't always work */
 		if (message->is_dma_mapped
@@ -980,21 +533,20 @@ static void pump_transfers(unsigned long data)
 	}
 
 	/* Setup the transfer state based on the type of transfer */
-	if (flush(drv_data) == 0) {
+	if (pxa2xx_spi_flush(drv_data) == 0) {
 		dev_err(&drv_data->pdev->dev, "pump_transfers: flush failed\n");
 		message->status = -EIO;
 		giveback(drv_data);
 		return;
 	}
 	drv_data->n_bytes = chip->n_bytes;
-	drv_data->dma_width = chip->dma_width;
 	drv_data->tx = (void *)transfer->tx_buf;
 	drv_data->tx_end = drv_data->tx + transfer->len;
 	drv_data->rx = transfer->rx_buf;
 	drv_data->rx_end = drv_data->rx + transfer->len;
 	drv_data->rx_dma = transfer->rx_dma;
 	drv_data->tx_dma = transfer->tx_dma;
-	drv_data->len = transfer->len & DCMD_LENGTH;
+	drv_data->len = transfer->len;
 	drv_data->write = drv_data->tx ? chip->write : null_writer;
 	drv_data->read = drv_data->rx ? chip->read : null_reader;
 
@@ -1015,21 +567,18 @@ static void pump_transfers(unsigned long data)
 
 		if (bits <= 8) {
 			drv_data->n_bytes = 1;
-			drv_data->dma_width = DCMD_WIDTH1;
 			drv_data->read = drv_data->read != null_reader ?
 						u8_reader : null_reader;
 			drv_data->write = drv_data->write != null_writer ?
 						u8_writer : null_writer;
 		} else if (bits <= 16) {
 			drv_data->n_bytes = 2;
-			drv_data->dma_width = DCMD_WIDTH2;
 			drv_data->read = drv_data->read != null_reader ?
 						u16_reader : null_reader;
 			drv_data->write = drv_data->write != null_writer ?
 						u16_writer : null_writer;
 		} else if (bits <= 32) {
 			drv_data->n_bytes = 4;
-			drv_data->dma_width = DCMD_WIDTH4;
 			drv_data->read = drv_data->read != null_reader ?
 						u32_reader : null_reader;
 			drv_data->write = drv_data->write != null_writer ?
@@ -1038,7 +587,8 @@ static void pump_transfers(unsigned long data)
 		/* if bits/word is changed in dma mode, then must check the
 		 * thresholds and burst also */
 		if (chip->enable_dma) {
-			if (set_dma_burst_and_threshold(chip, message->spi,
+			if (pxa2xx_spi_set_dma_burst_and_threshold(chip,
+							message->spi,
 							bits, &dma_burst,
 							&dma_thresh))
 				if (printk_ratelimit())
@@ -1057,70 +607,21 @@ static void pump_transfers(unsigned long data)
 
 	message->state = RUNNING_STATE;
 
-	/* Try to map dma buffer and do a dma transfer if successful, but
-	 * only if the length is non-zero and less than MAX_DMA_LEN.
-	 *
-	 * Zero-length non-descriptor DMA is illegal on PXA2xx; force use
-	 * of PIO instead.  Care is needed above because the transfer may
-	 * have have been passed with buffers that are already dma mapped.
-	 * A zero-length transfer in PIO mode will not try to write/read
-	 * to/from the buffers
-	 *
-	 * REVISIT large transfers are exactly where we most want to be
-	 * using DMA.  If this happens much, split those transfers into
-	 * multiple DMA segments rather than forcing PIO.
-	 */
 	drv_data->dma_mapped = 0;
-	if (drv_data->len > 0 && drv_data->len <= MAX_DMA_LEN)
-		drv_data->dma_mapped = map_dma_buffers(drv_data);
+	if (pxa2xx_spi_dma_is_possible(drv_data->len))
+		drv_data->dma_mapped = pxa2xx_spi_map_dma_buffers(drv_data);
 	if (drv_data->dma_mapped) {
 
 		/* Ensure we have the correct interrupt handler */
-		drv_data->transfer_handler = dma_transfer;
-
-		/* Setup rx DMA Channel */
-		DCSR(drv_data->rx_channel) = RESET_DMA_CHANNEL;
-		DSADR(drv_data->rx_channel) = drv_data->ssdr_physical;
-		DTADR(drv_data->rx_channel) = drv_data->rx_dma;
-		if (drv_data->rx == drv_data->null_dma_buf)
-			/* No target address increment */
-			DCMD(drv_data->rx_channel) = DCMD_FLOWSRC
-							| drv_data->dma_width
-							| dma_burst
-							| drv_data->len;
-		else
-			DCMD(drv_data->rx_channel) = DCMD_INCTRGADDR
-							| DCMD_FLOWSRC
-							| drv_data->dma_width
-							| dma_burst
-							| drv_data->len;
-
-		/* Setup tx DMA Channel */
-		DCSR(drv_data->tx_channel) = RESET_DMA_CHANNEL;
-		DSADR(drv_data->tx_channel) = drv_data->tx_dma;
-		DTADR(drv_data->tx_channel) = drv_data->ssdr_physical;
-		if (drv_data->tx == drv_data->null_dma_buf)
-			/* No source address increment */
-			DCMD(drv_data->tx_channel) = DCMD_FLOWTRG
-							| drv_data->dma_width
-							| dma_burst
-							| drv_data->len;
-		else
-			DCMD(drv_data->tx_channel) = DCMD_INCSRCADDR
-							| DCMD_FLOWTRG
-							| drv_data->dma_width
-							| dma_burst
-							| drv_data->len;
-
-		/* Enable dma end irqs on SSP to detect end of transfer */
-		if (drv_data->ssp_type == PXA25x_SSP)
-			DCMD(drv_data->tx_channel) |= DCMD_ENDIRQEN;
+		drv_data->transfer_handler = pxa2xx_spi_dma_transfer;
+
+		pxa2xx_spi_dma_prepare(drv_data, dma_burst);
 
 		/* Clear status and start DMA engine */
 		cr1 = chip->cr1 | dma_thresh | drv_data->dma_cr1;
 		write_SSSR(drv_data->clear_sr, reg);
-		DCSR(drv_data->rx_channel) |= DCSR_RUN;
-		DCSR(drv_data->tx_channel) |= DCSR_RUN;
+
+		pxa2xx_spi_dma_start(drv_data);
 	} else {
 		/* Ensure we have the correct interrupt handler	*/
 		drv_data->transfer_handler = interrupt_transfer;
@@ -1262,8 +763,6 @@ static int setup(struct spi_device *spi)
 			chip->gpio_cs = -1;
 		chip->enable_dma = 0;
 		chip->timeout = TIMOUT_DFLT;
-		chip->dma_burst_size = drv_data->master_info->enable_dma ?
-					DCMD_BURST8 : 0;
 	}
 
 	/* protocol drivers may change the chip settings, so...
@@ -1293,7 +792,8 @@ static int setup(struct spi_device *spi)
 	 * burst and threshold can still respond to changes in bits_per_word */
 	if (chip->enable_dma) {
 		/* set up legal burst and threshold for dma */
-		if (set_dma_burst_and_threshold(chip, spi, spi->bits_per_word,
+		if (pxa2xx_spi_set_dma_burst_and_threshold(chip, spi,
+						spi->bits_per_word,
 						&chip->dma_burst_size,
 						&chip->dma_threshold)) {
 			dev_warn(&spi->dev, "in setup: DMA burst size reduced "
@@ -1328,18 +828,15 @@ static int setup(struct spi_device *spi)
 
 	if (spi->bits_per_word <= 8) {
 		chip->n_bytes = 1;
-		chip->dma_width = DCMD_WIDTH1;
 		chip->read = u8_reader;
 		chip->write = u8_writer;
 	} else if (spi->bits_per_word <= 16) {
 		chip->n_bytes = 2;
-		chip->dma_width = DCMD_WIDTH2;
 		chip->read = u16_reader;
 		chip->write = u16_writer;
 	} else if (spi->bits_per_word <= 32) {
 		chip->cr0 |= SSCR0_EDSS;
 		chip->n_bytes = 4;
-		chip->dma_width = DCMD_WIDTH4;
 		chip->read = u32_reader;
 		chip->write = u32_writer;
 	} else {
@@ -1447,31 +944,11 @@ static int pxa2xx_spi_probe(struct platform_device *pdev)
 	drv_data->tx_channel = -1;
 	drv_data->rx_channel = -1;
 	if (platform_info->enable_dma) {
-
-		/* Get two DMA channels	(rx and tx) */
-		drv_data->rx_channel = pxa_request_dma("pxa2xx_spi_ssp_rx",
-							DMA_PRIO_HIGH,
-							dma_handler,
-							drv_data);
-		if (drv_data->rx_channel < 0) {
-			dev_err(dev, "problem (%d) requesting rx channel\n",
-				drv_data->rx_channel);
-			status = -ENODEV;
-			goto out_error_irq_alloc;
+		status = pxa2xx_spi_dma_setup(drv_data);
+		if (status) {
+			dev_warn(dev, "failed to setup DMA, using PIO\n");
+			platform_info->enable_dma = false;
 		}
-		drv_data->tx_channel = pxa_request_dma("pxa2xx_spi_ssp_tx",
-							DMA_PRIO_MEDIUM,
-							dma_handler,
-							drv_data);
-		if (drv_data->tx_channel < 0) {
-			dev_err(dev, "problem (%d) requesting tx channel\n",
-				drv_data->tx_channel);
-			status = -ENODEV;
-			goto out_error_dma_alloc;
-		}
-
-		DRCMR(ssp->drcmr_rx) = DRCMR_MAPVLD | drv_data->rx_channel;
-		DRCMR(ssp->drcmr_tx) = DRCMR_MAPVLD | drv_data->tx_channel;
 	}
 
 	/* Enable SOC clock */
@@ -1507,14 +984,7 @@ static int pxa2xx_spi_probe(struct platform_device *pdev)
 
 out_error_clock_enabled:
 	clk_disable_unprepare(ssp->clk);
-
-out_error_dma_alloc:
-	if (drv_data->tx_channel != -1)
-		pxa_free_dma(drv_data->tx_channel);
-	if (drv_data->rx_channel != -1)
-		pxa_free_dma(drv_data->rx_channel);
-
-out_error_irq_alloc:
+	pxa2xx_spi_dma_release(drv_data);
 	free_irq(ssp->irq, drv_data);
 
 out_error_master_alloc:
@@ -1537,12 +1007,8 @@ static int pxa2xx_spi_remove(struct platform_device *pdev)
 	clk_disable_unprepare(ssp->clk);
 
 	/* Release DMA */
-	if (drv_data->master_info->enable_dma) {
-		DRCMR(ssp->drcmr_rx) = 0;
-		DRCMR(ssp->drcmr_tx) = 0;
-		pxa_free_dma(drv_data->tx_channel);
-		pxa_free_dma(drv_data->rx_channel);
-	}
+	if (drv_data->master_info->enable_dma)
+		pxa2xx_spi_dma_release(drv_data);
 
 	/* Release IRQ */
 	free_irq(ssp->irq, drv_data);
@@ -1589,12 +1055,7 @@ static int pxa2xx_spi_resume(struct device *dev)
 	struct ssp_device *ssp = drv_data->ssp;
 	int status = 0;
 
-	if (drv_data->rx_channel != -1)
-		DRCMR(drv_data->ssp->drcmr_rx) =
-			DRCMR_MAPVLD | drv_data->rx_channel;
-	if (drv_data->tx_channel != -1)
-		DRCMR(drv_data->ssp->drcmr_tx) =
-			DRCMR_MAPVLD | drv_data->tx_channel;
+	pxa2xx_spi_dma_resume(drv_data);
 
 	/* Enable the SSP clock */
 	clk_prepare_enable(ssp->clk);
diff --git a/drivers/spi/spi-pxa2xx.h b/drivers/spi/spi-pxa2xx.h
new file mode 100644
index 0000000..0a98905
--- /dev/null
+++ b/drivers/spi/spi-pxa2xx.h
@@ -0,0 +1,185 @@
+/*
+ * Copyright (C) 2005 Stephen Street / StreetFire Sound Labs
+ * Copyright (C) 2013, Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef SPI_PXA2XX_H
+#define SPI_PXA2XX_H
+
+#include <linux/errno.h>
+#include <linux/io.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/pxa2xx_ssp.h>
+#include <linux/spi/spi.h>
+#include <linux/spi/pxa2xx_spi.h>
+
+struct driver_data {
+	/* Driver model hookup */
+	struct platform_device *pdev;
+
+	/* SSP Info */
+	struct ssp_device *ssp;
+
+	/* SPI framework hookup */
+	enum pxa_ssp_type ssp_type;
+	struct spi_master *master;
+
+	/* PXA hookup */
+	struct pxa2xx_spi_master *master_info;
+
+	/* PXA private DMA setup stuff */
+	int rx_channel;
+	int tx_channel;
+	u32 *null_dma_buf;
+
+	/* SSP register addresses */
+	void __iomem *ioaddr;
+	u32 ssdr_physical;
+
+	/* SSP masks*/
+	u32 dma_cr1;
+	u32 int_cr1;
+	u32 clear_sr;
+	u32 mask_sr;
+
+	/* Maximun clock rate */
+	unsigned long max_clk_rate;
+
+	/* Message Transfer pump */
+	struct tasklet_struct pump_transfers;
+
+	/* Current message transfer state info */
+	struct spi_message *cur_msg;
+	struct spi_transfer *cur_transfer;
+	struct chip_data *cur_chip;
+	size_t len;
+	void *tx;
+	void *tx_end;
+	void *rx;
+	void *rx_end;
+	int dma_mapped;
+	dma_addr_t rx_dma;
+	dma_addr_t tx_dma;
+	size_t rx_map_len;
+	size_t tx_map_len;
+	u8 n_bytes;
+	int (*write)(struct driver_data *drv_data);
+	int (*read)(struct driver_data *drv_data);
+	irqreturn_t (*transfer_handler)(struct driver_data *drv_data);
+	void (*cs_control)(u32 command);
+};
+
+struct chip_data {
+	u32 cr0;
+	u32 cr1;
+	u32 psp;
+	u32 timeout;
+	u8 n_bytes;
+	u32 dma_burst_size;
+	u32 threshold;
+	u32 dma_threshold;
+	u8 enable_dma;
+	u8 bits_per_word;
+	u32 speed_hz;
+	union {
+		int gpio_cs;
+		unsigned int frm;
+	};
+	int gpio_cs_inverted;
+	int (*write)(struct driver_data *drv_data);
+	int (*read)(struct driver_data *drv_data);
+	void (*cs_control)(u32 command);
+};
+
+#define DEFINE_SSP_REG(reg, off) \
+static inline u32 read_##reg(void const __iomem *p) \
+{ return __raw_readl(p + (off)); } \
+\
+static inline void write_##reg(u32 v, void __iomem *p) \
+{ __raw_writel(v, p + (off)); }
+
+DEFINE_SSP_REG(SSCR0, 0x00)
+DEFINE_SSP_REG(SSCR1, 0x04)
+DEFINE_SSP_REG(SSSR, 0x08)
+DEFINE_SSP_REG(SSITR, 0x0c)
+DEFINE_SSP_REG(SSDR, 0x10)
+DEFINE_SSP_REG(SSTO, 0x28)
+DEFINE_SSP_REG(SSPSP, 0x2c)
+
+#define START_STATE ((void *)0)
+#define RUNNING_STATE ((void *)1)
+#define DONE_STATE ((void *)2)
+#define ERROR_STATE ((void *)-1)
+
+#define MAX_DMA_LEN		8191
+#define IS_DMA_ALIGNED(x)	IS_ALIGNED((unsigned long)(x), DMA_ALIGNMENT)
+#define DMA_ALIGNMENT		8
+
+static inline int pxa25x_ssp_comp(struct driver_data *drv_data)
+{
+	if (drv_data->ssp_type == PXA25x_SSP)
+		return 1;
+	if (drv_data->ssp_type == CE4100_SSP)
+		return 1;
+	return 0;
+}
+
+static inline void write_SSSR_CS(struct driver_data *drv_data, u32 val)
+{
+	void __iomem *reg = drv_data->ioaddr;
+
+	if (drv_data->ssp_type == CE4100_SSP)
+		val |= read_SSSR(reg) & SSSR_ALT_FRM_MASK;
+
+	write_SSSR(val, reg);
+}
+
+extern int pxa2xx_spi_flush(struct driver_data *drv_data);
+extern void *pxa2xx_spi_next_transfer(struct driver_data *drv_data);
+
+#if defined(CONFIG_SPI_PXA2XX_PXADMA)
+extern bool pxa2xx_spi_dma_is_possible(size_t len);
+extern int pxa2xx_spi_map_dma_buffers(struct driver_data *drv_data);
+extern irqreturn_t pxa2xx_spi_dma_transfer(struct driver_data *drv_data);
+extern int pxa2xx_spi_dma_prepare(struct driver_data *drv_data, u32 dma_burst);
+extern void pxa2xx_spi_dma_start(struct driver_data *drv_data);
+extern int pxa2xx_spi_dma_setup(struct driver_data *drv_data);
+extern void pxa2xx_spi_dma_release(struct driver_data *drv_data);
+extern void pxa2xx_spi_dma_resume(struct driver_data *drv_data);
+extern int pxa2xx_spi_set_dma_burst_and_threshold(struct chip_data *chip,
+						  struct spi_device *spi,
+						  u8 bits_per_word,
+						  u32 *burst_code,
+						  u32 *threshold);
+#else
+static inline bool pxa2xx_spi_dma_is_possible(size_t len) { return false; }
+static inline int pxa2xx_spi_map_dma_buffers(struct driver_data *drv_data)
+{
+	return 0;
+}
+#define pxa2xx_spi_dma_transfer NULL
+static inline void pxa2xx_spi_dma_prepare(struct driver_data *drv_data,
+					  u32 dma_burst) {}
+static inline void pxa2xx_spi_dma_start(struct driver_data *drv_data) {}
+static inline int pxa2xx_spi_dma_setup(struct driver_data *drv_data)
+{
+	return 0;
+}
+static inline void pxa2xx_spi_dma_release(struct driver_data *drv_data) {}
+static inline void pxa2xx_spi_dma_resume(struct driver_data *drv_data) {}
+static inline int pxa2xx_spi_set_dma_burst_and_threshold(struct chip_data *chip,
+							 struct spi_device *spi,
+							 u8 bits_per_word,
+							 u32 *burst_code,
+							 u32 *threshold)
+{
+	return -ENODEV;
+}
+#endif
+
+#endif /* SPI_PXA2XX_H */
diff --git a/include/linux/spi/pxa2xx_spi.h b/include/linux/spi/pxa2xx_spi.h
index 053b5ba..d6d2b4d 100644
--- a/include/linux/spi/pxa2xx_spi.h
+++ b/include/linux/spi/pxa2xx_spi.h
@@ -53,85 +53,5 @@ struct pxa2xx_spi_chip {
 
 extern void pxa2xx_set_spi_info(unsigned id, struct pxa2xx_spi_master *info);
 
-#else
-/*
- * This is the implemtation for CE4100 on x86. ARM defines them in mach/ or
- * plat/ include path.
- * The CE4100 does not provide DMA support. This bits are here to let the driver
- * compile and will never be used. Maybe we get DMA support at a later point in
- * time.
- */
-
-#define DCSR(n)         (n)
-#define DSADR(n)        (n)
-#define DTADR(n)        (n)
-#define DCMD(n)         (n)
-#define DRCMR(n)        (n)
-
-#define DCSR_RUN	(1 << 31)	/* Run Bit */
-#define DCSR_NODESC	(1 << 30)	/* No-Descriptor Fetch */
-#define DCSR_STOPIRQEN	(1 << 29)	/* Stop Interrupt Enable */
-#define DCSR_REQPEND	(1 << 8)	/* Request Pending (read-only) */
-#define DCSR_STOPSTATE	(1 << 3)	/* Stop State (read-only) */
-#define DCSR_ENDINTR	(1 << 2)	/* End Interrupt */
-#define DCSR_STARTINTR	(1 << 1)	/* Start Interrupt */
-#define DCSR_BUSERR	(1 << 0)	/* Bus Error Interrupt */
-
-#define DCSR_EORIRQEN	(1 << 28)	/* End of Receive Interrupt Enable */
-#define DCSR_EORJMPEN	(1 << 27)	/* Jump to next descriptor on EOR */
-#define DCSR_EORSTOPEN	(1 << 26)	/* STOP on an EOR */
-#define DCSR_SETCMPST	(1 << 25)	/* Set Descriptor Compare Status */
-#define DCSR_CLRCMPST	(1 << 24)	/* Clear Descriptor Compare Status */
-#define DCSR_CMPST	(1 << 10)	/* The Descriptor Compare Status */
-#define DCSR_EORINTR	(1 << 9)	/* The end of Receive */
-
-#define DRCMR_MAPVLD	(1 << 7)	/* Map Valid */
-#define DRCMR_CHLNUM	0x1f		/* mask for Channel Number */
-
-#define DDADR_DESCADDR	0xfffffff0	/* Address of next descriptor */
-#define DDADR_STOP	(1 << 0)	/* Stop */
-
-#define DCMD_INCSRCADDR	(1 << 31)	/* Source Address Increment Setting. */
-#define DCMD_INCTRGADDR	(1 << 30)	/* Target Address Increment Setting. */
-#define DCMD_FLOWSRC	(1 << 29)	/* Flow Control by the source. */
-#define DCMD_FLOWTRG	(1 << 28)	/* Flow Control by the target. */
-#define DCMD_STARTIRQEN	(1 << 22)	/* Start Interrupt Enable */
-#define DCMD_ENDIRQEN	(1 << 21)	/* End Interrupt Enable */
-#define DCMD_ENDIAN	(1 << 18)	/* Device Endian-ness. */
-#define DCMD_BURST8	(1 << 16)	/* 8 byte burst */
-#define DCMD_BURST16	(2 << 16)	/* 16 byte burst */
-#define DCMD_BURST32	(3 << 16)	/* 32 byte burst */
-#define DCMD_WIDTH1	(1 << 14)	/* 1 byte width */
-#define DCMD_WIDTH2	(2 << 14)	/* 2 byte width (HalfWord) */
-#define DCMD_WIDTH4	(3 << 14)	/* 4 byte width (Word) */
-#define DCMD_LENGTH	0x01fff		/* length mask (max = 8K - 1) */
-
-/*
- * Descriptor structure for PXA's DMA engine
- * Note: this structure must always be aligned to a 16-byte boundary.
- */
-
-typedef enum {
-	DMA_PRIO_HIGH = 0,
-	DMA_PRIO_MEDIUM = 1,
-	DMA_PRIO_LOW = 2
-} pxa_dma_prio;
-
-/*
- * DMA registration
- */
-
-static inline int pxa_request_dma(char *name,
-		pxa_dma_prio prio,
-		void (*irq_handler)(int, void *),
-		void *data)
-{
-	return -ENODEV;
-}
-
-static inline void pxa_free_dma(int dma_ch)
-{
-}
-
 #endif
 #endif
-- 
1.7.10.4

