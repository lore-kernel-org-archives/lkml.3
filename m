Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355Ab3AVK1y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 05:27:54 -0500
Received: from mga02.intel.com ([134.134.136.20]:18400 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753783Ab3AVKZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 05:25:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,513,1355126400"; 
   d="scan'208";a="275104111"
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
Subject: [PATCH v3 06/10] spi/pxa2xx: add support for DMA engine
Date: Tue, 22 Jan 2013 12:26:29 +0200
Message-Id: <1358850393-23111-7-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358850393-23111-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1358850393-23111-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To be able to use DMA with this driver on non-PXA platforms we implement
support for the generic DMA engine API. This lets user to use different DMA
engines with little or no modification to the driver.

Request lines and channel numbers can be passed to the driver from the
platform specific data.

The DMA engine implementation will be selected by default even on PXA
platform. User can select the legacy DMA API by enabling Kconfig option
CONFIG_SPI_PXA2XX_PXADMA.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
Linus W, there haven't been any comments from Vinod/Dan about the alignment
thing so I added a comment 'REVISIT: ..' so that we remember to change this
once it has been sorted out. I hope that is OK for you.

 drivers/spi/Kconfig            |    7 +-
 drivers/spi/Makefile           |    1 +
 drivers/spi/spi-pxa2xx-dma.c   |  392 ++++++++++++++++++++++++++++++++++++++++
 drivers/spi/spi-pxa2xx.c       |    2 +-
 drivers/spi/spi-pxa2xx.h       |   32 +++-
 include/linux/spi/pxa2xx_spi.h |    6 +
 6 files changed, 437 insertions(+), 3 deletions(-)
 create mode 100644 drivers/spi/spi-pxa2xx-dma.c

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index f187866..8913d3d 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -301,7 +301,12 @@ config SPI_PXA2XX_PXADMA
 	bool "PXA2xx SSP legacy PXA DMA API support"
 	depends on SPI_PXA2XX && ARCH_PXA
 	help
-	  Enable PXA private legacy DMA API support.
+	  Enable PXA private legacy DMA API support. Note that this is
+	  deprecated in favor of generic DMA engine API.
+
+config SPI_PXA2XX_DMA
+	def_bool y
+	depends on SPI_PXA2XX && !SPI_PXA2XX_PXADMA
 
 config SPI_PXA2XX
 	tristate "PXA2xx SSP SPI master"
diff --git a/drivers/spi/Makefile b/drivers/spi/Makefile
index 2e3cdd3..e53c309 100644
--- a/drivers/spi/Makefile
+++ b/drivers/spi/Makefile
@@ -49,6 +49,7 @@ obj-$(CONFIG_SPI_PL022)			+= spi-pl022.o
 obj-$(CONFIG_SPI_PPC4xx)		+= spi-ppc4xx.o
 spi-pxa2xx-platform-objs		:= spi-pxa2xx.o
 spi-pxa2xx-platform-$(CONFIG_SPI_PXA2XX_PXADMA)	+= spi-pxa2xx-pxadma.o
+spi-pxa2xx-platform-$(CONFIG_SPI_PXA2XX_DMA)	+= spi-pxa2xx-dma.o
 obj-$(CONFIG_SPI_PXA2XX)		+= spi-pxa2xx-platform.o
 obj-$(CONFIG_SPI_PXA2XX_PCI)		+= spi-pxa2xx-pci.o
 obj-$(CONFIG_SPI_RSPI)			+= spi-rspi.o
diff --git a/drivers/spi/spi-pxa2xx-dma.c b/drivers/spi/spi-pxa2xx-dma.c
new file mode 100644
index 0000000..c735c5a
--- /dev/null
+++ b/drivers/spi/spi-pxa2xx-dma.c
@@ -0,0 +1,392 @@
+/*
+ * PXA2xx SPI DMA engine support.
+ *
+ * Copyright (C) 2013, Intel Corporation
+ * Author: Mika Westerberg <mika.westerberg@linux.intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/dma-mapping.h>
+#include <linux/dmaengine.h>
+#include <linux/pxa2xx_ssp.h>
+#include <linux/scatterlist.h>
+#include <linux/sizes.h>
+#include <linux/spi/spi.h>
+#include <linux/spi/pxa2xx_spi.h>
+
+#include "spi-pxa2xx.h"
+
+static int pxa2xx_spi_map_dma_buffer(struct driver_data *drv_data,
+				     enum dma_data_direction dir)
+{
+	int i, nents, len = drv_data->len;
+	struct scatterlist *sg;
+	struct device *dmadev;
+	struct sg_table *sgt;
+	void *buf, *pbuf;
+
+	/*
+	 * Some DMA controllers have problems transferring buffers that are
+	 * not multiple of 4 bytes. So we truncate the transfer so that it
+	 * is suitable for such controllers, and handle the trailing bytes
+	 * manually after the DMA completes.
+	 *
+	 * REVISIT: It would be better if this information could be
+	 * retrieved directly from the DMA device in a similar way than
+	 * ->copy_align etc. is done.
+	 */
+	len = ALIGN(drv_data->len, 4);
+
+	if (dir == DMA_TO_DEVICE) {
+		dmadev = drv_data->tx_chan->device->dev;
+		sgt = &drv_data->tx_sgt;
+		buf = drv_data->tx;
+		drv_data->tx_map_len = len;
+	} else {
+		dmadev = drv_data->rx_chan->device->dev;
+		sgt = &drv_data->rx_sgt;
+		buf = drv_data->rx;
+		drv_data->rx_map_len = len;
+	}
+
+	nents = DIV_ROUND_UP(len, SZ_2K);
+	if (nents != sgt->nents) {
+		int ret;
+
+		sg_free_table(sgt);
+		ret = sg_alloc_table(sgt, nents, GFP_KERNEL);
+		if (ret)
+			return ret;
+	}
+
+	pbuf = buf;
+	for_each_sg(sgt->sgl, sg, sgt->nents, i) {
+		size_t bytes = min_t(size_t, len, SZ_2K);
+
+		if (buf)
+			sg_set_buf(sg, pbuf, bytes);
+		else
+			sg_set_buf(sg, drv_data->dummy, bytes);
+
+		pbuf += bytes;
+		len -= bytes;
+	}
+
+	nents = dma_map_sg(dmadev, sgt->sgl, sgt->nents, dir);
+	if (!nents)
+		return -ENOMEM;
+
+	return nents;
+}
+
+static void pxa2xx_spi_unmap_dma_buffer(struct driver_data *drv_data,
+					enum dma_data_direction dir)
+{
+	struct device *dmadev;
+	struct sg_table *sgt;
+
+	if (dir == DMA_TO_DEVICE) {
+		dmadev = drv_data->tx_chan->device->dev;
+		sgt = &drv_data->tx_sgt;
+	} else {
+		dmadev = drv_data->rx_chan->device->dev;
+		sgt = &drv_data->rx_sgt;
+	}
+
+	dma_unmap_sg(dmadev, sgt->sgl, sgt->nents, dir);
+}
+
+static void pxa2xx_spi_unmap_dma_buffers(struct driver_data *drv_data)
+{
+	if (!drv_data->dma_mapped)
+		return;
+
+	pxa2xx_spi_unmap_dma_buffer(drv_data, DMA_FROM_DEVICE);
+	pxa2xx_spi_unmap_dma_buffer(drv_data, DMA_TO_DEVICE);
+
+	drv_data->dma_mapped = 0;
+}
+
+static void pxa2xx_spi_dma_transfer_complete(struct driver_data *drv_data,
+					     bool error)
+{
+	struct spi_message *msg = drv_data->cur_msg;
+
+	/*
+	 * It is possible that one CPU is handling ROR interrupt and other
+	 * just gets DMA completion. Calling pump_transfers() twice for the
+	 * same transfer leads to problems thus we prevent concurrent calls
+	 * by using ->dma_running.
+	 */
+	if (atomic_dec_and_test(&drv_data->dma_running)) {
+		void __iomem *reg = drv_data->ioaddr;
+
+		/*
+		 * If the other CPU is still handling the ROR interrupt we
+		 * might not know about the error yet. So we re-check the
+		 * ROR bit here before we clear the status register.
+		 */
+		if (!error) {
+			u32 status = read_SSSR(reg) & drv_data->mask_sr;
+			error = status & SSSR_ROR;
+		}
+
+		/* Clear status & disable interrupts */
+		write_SSCR1(read_SSCR1(reg) & ~drv_data->dma_cr1, reg);
+		write_SSSR_CS(drv_data, drv_data->clear_sr);
+		if (!pxa25x_ssp_comp(drv_data))
+			write_SSTO(0, reg);
+
+		if (!error) {
+			pxa2xx_spi_unmap_dma_buffers(drv_data);
+
+			/* Handle the last bytes of unaligned transfer */
+			drv_data->tx += drv_data->tx_map_len;
+			drv_data->write(drv_data);
+
+			drv_data->rx += drv_data->rx_map_len;
+			drv_data->read(drv_data);
+
+			msg->actual_length += drv_data->len;
+			msg->state = pxa2xx_spi_next_transfer(drv_data);
+		} else {
+			/* In case we got an error we disable the SSP now */
+			write_SSCR0(read_SSCR0(reg) & ~SSCR0_SSE, reg);
+
+			msg->state = ERROR_STATE;
+		}
+
+		tasklet_schedule(&drv_data->pump_transfers);
+	}
+}
+
+static void pxa2xx_spi_dma_callback(void *data)
+{
+	pxa2xx_spi_dma_transfer_complete(data, false);
+}
+
+static struct dma_async_tx_descriptor *
+pxa2xx_spi_dma_prepare_one(struct driver_data *drv_data,
+			   enum dma_transfer_direction dir)
+{
+	struct pxa2xx_spi_master *pdata = drv_data->master_info;
+	struct chip_data *chip = drv_data->cur_chip;
+	enum dma_slave_buswidth width;
+	struct dma_slave_config cfg;
+	struct dma_chan *chan;
+	struct sg_table *sgt;
+	int nents, ret;
+
+	switch (drv_data->n_bytes) {
+	case 1:
+		width = DMA_SLAVE_BUSWIDTH_1_BYTE;
+		break;
+	case 2:
+		width = DMA_SLAVE_BUSWIDTH_2_BYTES;
+		break;
+	default:
+		width = DMA_SLAVE_BUSWIDTH_4_BYTES;
+		break;
+	}
+
+	memset(&cfg, 0, sizeof(cfg));
+	cfg.direction = dir;
+
+	if (dir == DMA_MEM_TO_DEV) {
+		cfg.dst_addr = drv_data->ssdr_physical;
+		cfg.dst_addr_width = width;
+		cfg.dst_maxburst = chip->dma_burst_size;
+		cfg.slave_id = pdata->tx_slave_id;
+
+		sgt = &drv_data->tx_sgt;
+		nents = drv_data->tx_nents;
+		chan = drv_data->tx_chan;
+	} else {
+		cfg.src_addr = drv_data->ssdr_physical;
+		cfg.src_addr_width = width;
+		cfg.src_maxburst = chip->dma_burst_size;
+		cfg.slave_id = pdata->rx_slave_id;
+
+		sgt = &drv_data->rx_sgt;
+		nents = drv_data->rx_nents;
+		chan = drv_data->rx_chan;
+	}
+
+	ret = dmaengine_slave_config(chan, &cfg);
+	if (ret) {
+		dev_warn(&drv_data->pdev->dev, "DMA slave config failed\n");
+		return NULL;
+	}
+
+	return dmaengine_prep_slave_sg(chan, sgt->sgl, nents, dir,
+				       DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+}
+
+static bool pxa2xx_spi_dma_filter(struct dma_chan *chan, void *param)
+{
+	const struct pxa2xx_spi_master *pdata = param;
+
+	return chan->chan_id == pdata->tx_chan_id ||
+	       chan->chan_id == pdata->rx_chan_id;
+}
+
+bool pxa2xx_spi_dma_is_possible(size_t len)
+{
+	return len <= MAX_DMA_LEN;
+}
+
+int pxa2xx_spi_map_dma_buffers(struct driver_data *drv_data)
+{
+	const struct chip_data *chip = drv_data->cur_chip;
+	int ret;
+
+	if (!chip->enable_dma)
+		return 0;
+
+	/* Don't bother with DMA if we can't do even a single burst */
+	if (drv_data->len < chip->dma_burst_size)
+		return 0;
+
+	ret = pxa2xx_spi_map_dma_buffer(drv_data, DMA_TO_DEVICE);
+	if (ret <= 0) {
+		dev_warn(&drv_data->pdev->dev, "failed to DMA map TX\n");
+		return 0;
+	}
+
+	drv_data->tx_nents = ret;
+
+	ret = pxa2xx_spi_map_dma_buffer(drv_data, DMA_FROM_DEVICE);
+	if (ret <= 0) {
+		pxa2xx_spi_unmap_dma_buffer(drv_data, DMA_TO_DEVICE);
+		dev_warn(&drv_data->pdev->dev, "failed to DMA map RX\n");
+		return 0;
+	}
+
+	drv_data->rx_nents = ret;
+	return 1;
+}
+
+irqreturn_t pxa2xx_spi_dma_transfer(struct driver_data *drv_data)
+{
+	u32 status;
+
+	status = read_SSSR(drv_data->ioaddr) & drv_data->mask_sr;
+	if (status & SSSR_ROR) {
+		dev_err(&drv_data->pdev->dev, "FIFO overrun\n");
+
+		dmaengine_terminate_all(drv_data->rx_chan);
+		dmaengine_terminate_all(drv_data->tx_chan);
+
+		pxa2xx_spi_dma_transfer_complete(drv_data, true);
+		return IRQ_HANDLED;
+	}
+
+	return IRQ_NONE;
+}
+
+int pxa2xx_spi_dma_prepare(struct driver_data *drv_data, u32 dma_burst)
+{
+	struct dma_async_tx_descriptor *tx_desc, *rx_desc;
+
+	tx_desc = pxa2xx_spi_dma_prepare_one(drv_data, DMA_MEM_TO_DEV);
+	if (!tx_desc) {
+		dev_err(&drv_data->pdev->dev,
+			"failed to get DMA TX descriptor\n");
+		return -EBUSY;
+	}
+
+	rx_desc = pxa2xx_spi_dma_prepare_one(drv_data, DMA_DEV_TO_MEM);
+	if (!rx_desc) {
+		dev_err(&drv_data->pdev->dev,
+			"failed to get DMA RX descriptor\n");
+		return -EBUSY;
+	}
+
+	/* We are ready when RX completes */
+	rx_desc->callback = pxa2xx_spi_dma_callback;
+	rx_desc->callback_param = drv_data;
+
+	dmaengine_submit(rx_desc);
+	dmaengine_submit(tx_desc);
+	return 0;
+}
+
+void pxa2xx_spi_dma_start(struct driver_data *drv_data)
+{
+	dma_async_issue_pending(drv_data->rx_chan);
+	dma_async_issue_pending(drv_data->tx_chan);
+
+	atomic_set(&drv_data->dma_running, 1);
+}
+
+int pxa2xx_spi_dma_setup(struct driver_data *drv_data)
+{
+	struct pxa2xx_spi_master *pdata = drv_data->master_info;
+	dma_cap_mask_t mask;
+
+	dma_cap_zero(mask);
+	dma_cap_set(DMA_SLAVE, mask);
+
+	drv_data->dummy = devm_kzalloc(&drv_data->pdev->dev, SZ_2K, GFP_KERNEL);
+	if (!drv_data->dummy)
+		return -ENOMEM;
+
+	drv_data->tx_chan = dma_request_channel(mask, pxa2xx_spi_dma_filter,
+						pdata);
+	if (!drv_data->tx_chan)
+		return -ENODEV;
+
+	drv_data->rx_chan = dma_request_channel(mask, pxa2xx_spi_dma_filter,
+						pdata);
+	if (!drv_data->rx_chan) {
+		dma_release_channel(drv_data->tx_chan);
+		drv_data->tx_chan = NULL;
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+void pxa2xx_spi_dma_release(struct driver_data *drv_data)
+{
+	if (drv_data->rx_chan) {
+		dmaengine_terminate_all(drv_data->rx_chan);
+		dma_release_channel(drv_data->rx_chan);
+		sg_free_table(&drv_data->rx_sgt);
+		drv_data->rx_chan = NULL;
+	}
+	if (drv_data->tx_chan) {
+		dmaengine_terminate_all(drv_data->tx_chan);
+		dma_release_channel(drv_data->tx_chan);
+		sg_free_table(&drv_data->tx_sgt);
+		drv_data->tx_chan = NULL;
+	}
+}
+
+void pxa2xx_spi_dma_resume(struct driver_data *drv_data)
+{
+}
+
+int pxa2xx_spi_set_dma_burst_and_threshold(struct chip_data *chip,
+					   struct spi_device *spi,
+					   u8 bits_per_word, u32 *burst_code,
+					   u32 *threshold)
+{
+	struct pxa2xx_spi_chip *chip_info = spi->controller_data;
+
+	/*
+	 * If the DMA burst size is given in chip_info we use that,
+	 * otherwise we use the default. Also we use the default FIFO
+	 * thresholds for now.
+	 */
+	*burst_code = chip_info ? chip_info->dma_burst_size : 16;
+	*threshold = SSCR1_RxTresh(RX_THRESH_DFLT)
+		   | SSCR1_TxTresh(TX_THRESH_DFLT);
+
+	return 0;
+}
diff --git a/drivers/spi/spi-pxa2xx.c b/drivers/spi/spi-pxa2xx.c
index 5b7c2a4..c3d7807 100644
--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -928,7 +928,7 @@ static int pxa2xx_spi_probe(struct platform_device *pdev)
 		drv_data->mask_sr = SSSR_RFS | SSSR_TFS | SSSR_ROR;
 	} else {
 		drv_data->int_cr1 = SSCR1_TIE | SSCR1_RIE | SSCR1_TINTE;
-		drv_data->dma_cr1 = SSCR1_TSRE | SSCR1_RSRE | SSCR1_TINTE;
+		drv_data->dma_cr1 = DEFAULT_DMA_CR1;
 		drv_data->clear_sr = SSSR_ROR | SSSR_TINT;
 		drv_data->mask_sr = SSSR_TINT | SSSR_RFS | SSSR_TFS | SSSR_ROR;
 	}
diff --git a/drivers/spi/spi-pxa2xx.h b/drivers/spi/spi-pxa2xx.h
index 0a98905..97ff471 100644
--- a/drivers/spi/spi-pxa2xx.h
+++ b/drivers/spi/spi-pxa2xx.h
@@ -10,11 +10,15 @@
 #ifndef SPI_PXA2XX_H
 #define SPI_PXA2XX_H
 
+#include <linux/atomic.h>
+#include <linux/dmaengine.h>
 #include <linux/errno.h>
 #include <linux/io.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
 #include <linux/pxa2xx_ssp.h>
+#include <linux/scatterlist.h>
+#include <linux/sizes.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/pxa2xx_spi.h>
 
@@ -53,6 +57,16 @@ struct driver_data {
 	/* Message Transfer pump */
 	struct tasklet_struct pump_transfers;
 
+	/* DMA engine support */
+	struct dma_chan *rx_chan;
+	struct dma_chan *tx_chan;
+	struct sg_table rx_sgt;
+	struct sg_table tx_sgt;
+	int rx_nents;
+	int tx_nents;
+	void *dummy;
+	atomic_t dma_running;
+
 	/* Current message transfer state info */
 	struct spi_message *cur_msg;
 	struct spi_transfer *cur_transfer;
@@ -116,7 +130,6 @@ DEFINE_SSP_REG(SSPSP, 0x2c)
 #define DONE_STATE ((void *)2)
 #define ERROR_STATE ((void *)-1)
 
-#define MAX_DMA_LEN		8191
 #define IS_DMA_ALIGNED(x)	IS_ALIGNED((unsigned long)(x), DMA_ALIGNMENT)
 #define DMA_ALIGNMENT		8
 
@@ -142,7 +155,24 @@ static inline void write_SSSR_CS(struct driver_data *drv_data, u32 val)
 extern int pxa2xx_spi_flush(struct driver_data *drv_data);
 extern void *pxa2xx_spi_next_transfer(struct driver_data *drv_data);
 
+/*
+ * Select the right DMA implementation.
+ */
 #if defined(CONFIG_SPI_PXA2XX_PXADMA)
+#define SPI_PXA2XX_USE_DMA	1
+#define MAX_DMA_LEN		8191
+#define DEFAULT_DMA_CR1		(SSCR1_TSRE | SSCR1_RSRE | SSCR1_TINTE)
+#elif defined(CONFIG_SPI_PXA2XX_DMA)
+#define SPI_PXA2XX_USE_DMA	1
+#define MAX_DMA_LEN		SZ_64K
+#define DEFAULT_DMA_CR1		(SSCR1_TSRE | SSCR1_RSRE | SSCR1_TRAIL)
+#else
+#undef SPI_PXA2XX_USE_DMA
+#define MAX_DMA_LEN		0
+#define DEFAULT_DMA_CR1		0
+#endif
+
+#ifdef SPI_PXA2XX_USE_DMA
 extern bool pxa2xx_spi_dma_is_possible(size_t len);
 extern int pxa2xx_spi_map_dma_buffers(struct driver_data *drv_data);
 extern irqreturn_t pxa2xx_spi_dma_transfer(struct driver_data *drv_data);
diff --git a/include/linux/spi/pxa2xx_spi.h b/include/linux/spi/pxa2xx_spi.h
index d6d2b4d..e5cbbc4 100644
--- a/include/linux/spi/pxa2xx_spi.h
+++ b/include/linux/spi/pxa2xx_spi.h
@@ -29,6 +29,12 @@ struct pxa2xx_spi_master {
 	u16 num_chipselect;
 	u8 enable_dma;
 
+	/* DMA engine specific config */
+	int rx_chan_id;
+	int tx_chan_id;
+	int rx_slave_id;
+	int tx_slave_id;
+
 	/* For non-PXA arches */
 	struct ssp_device ssp;
 };
-- 
1.7.10.4

