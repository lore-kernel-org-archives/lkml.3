Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398AbaBZMoo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 07:44:44 -0500
Received: from moutng.kundenserver.de ([212.227.126.131]:54211 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbaBZMok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 07:44:40 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Sekhar Nori <nsekhar@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        davinci-linux-open-source@linux.davincidsp.com,
        Cyril Chemparathy <cyril@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH 3/5] spi: remove obsolete spi-ti-ssp driver
Date: Wed, 26 Feb 2014 13:43:32 +0100
Message-Id: <1393418614-3968549-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393418614-3968549-1-git-send-email-arnd@arndb.de>
References: <1393418614-3968549-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:QGdfE3ppCorwIB2aiJMyvMvY7FcxCpHP7QBlN+d+gNB
 vNpNdifpGJGjR5k96sN3QVfLO4tcXulOT3Ygrf/oSdEP+XtJq3
 BjCCut/zTtonRRGAVamnudOGSoKOLNz7VmHhyXcjrZIJDcQpRx
 bDljbkAwIPn7BYQaJG729CJPjFoi4pPMA8Au45cQvMxo9T/T17
 mX91NcZbpBiqs6DRxpF9LAyqM/06fuQ7KEqh2QTPYAoBa3G+li
 WPo73HRvb5ftSPwXD6EDgjWwNztqkuF4KB3e8qJH/SzV8MNJjq
 IvZVw2hrTwwKsBumUlpa9WFQtOBotmWIQ17sWtPEvmr9l7VYVV
 CFFePvcn9oWrJ3qtP6+/4+hdpsLcb5OGEQWAFezNg
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tnetv107x platform is getting removed, so this driver
will not be needed any more.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org
---
 drivers/spi/Kconfig      |   7 -
 drivers/spi/Makefile     |   1 -
 drivers/spi/spi-ti-ssp.c | 378 -----------------------------------------------
 3 files changed, 386 deletions(-)
 delete mode 100644 drivers/spi/spi-ti-ssp.c

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index ba9310b..fc940f1 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -478,13 +478,6 @@ config SPI_TEGRA20_SLINK
 	help
 	  SPI driver for Nvidia Tegra20/Tegra30 SLINK Controller interface.
 
-config SPI_TI_SSP
-	tristate "TI Sequencer Serial Port - SPI Support"
-	depends on MFD_TI_SSP
-	help
-	  This selects an SPI master implementation using a TI sequencer
-	  serial port.
-
 config SPI_TOPCLIFF_PCH
 	tristate "Intel EG20T PCH/LAPIS Semicon IOH(ML7213/ML7223/ML7831) SPI"
 	depends on PCI
diff --git a/drivers/spi/Makefile b/drivers/spi/Makefile
index 95af48d..7da53af 100644
--- a/drivers/spi/Makefile
+++ b/drivers/spi/Makefile
@@ -73,7 +73,6 @@ obj-$(CONFIG_SPI_SIRF)		+= spi-sirf.o
 obj-$(CONFIG_SPI_TEGRA114)		+= spi-tegra114.o
 obj-$(CONFIG_SPI_TEGRA20_SFLASH)	+= spi-tegra20-sflash.o
 obj-$(CONFIG_SPI_TEGRA20_SLINK)		+= spi-tegra20-slink.o
-obj-$(CONFIG_SPI_TI_SSP)		+= spi-ti-ssp.o
 obj-$(CONFIG_SPI_TLE62X0)		+= spi-tle62x0.o
 obj-$(CONFIG_SPI_TOPCLIFF_PCH)		+= spi-topcliff-pch.o
 obj-$(CONFIG_SPI_TXX9)			+= spi-txx9.o
diff --git a/drivers/spi/spi-ti-ssp.c b/drivers/spi/spi-ti-ssp.c
deleted file mode 100644
index 7d20e12..0000000
--- a/drivers/spi/spi-ti-ssp.c
+++ /dev/null
@@ -1,378 +0,0 @@
-/*
- * Sequencer Serial Port (SSP) based SPI master driver
- *
- * Copyright (C) 2010 Texas Instruments Inc
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- */
-
-#include <linux/kernel.h>
-#include <linux/err.h>
-#include <linux/completion.h>
-#include <linux/delay.h>
-#include <linux/module.h>
-#include <linux/platform_device.h>
-#include <linux/spi/spi.h>
-#include <linux/mfd/ti_ssp.h>
-
-#define MODE_BITS	(SPI_CPHA | SPI_CPOL | SPI_CS_HIGH)
-
-struct ti_ssp_spi {
-	struct spi_master		*master;
-	struct device			*dev;
-	spinlock_t			lock;
-	struct list_head		msg_queue;
-	struct completion		complete;
-	bool				shutdown;
-	struct workqueue_struct		*workqueue;
-	struct work_struct		work;
-	u8				mode, bpw;
-	int				cs_active;
-	u32				pc_en, pc_dis, pc_wr, pc_rd;
-	void				(*select)(int cs);
-};
-
-static u32 ti_ssp_spi_rx(struct ti_ssp_spi *hw)
-{
-	u32 ret;
-
-	ti_ssp_run(hw->dev, hw->pc_rd, 0, &ret);
-	return ret;
-}
-
-static void ti_ssp_spi_tx(struct ti_ssp_spi *hw, u32 data)
-{
-	ti_ssp_run(hw->dev, hw->pc_wr, data << (32 - hw->bpw), NULL);
-}
-
-static int ti_ssp_spi_txrx(struct ti_ssp_spi *hw, struct spi_message *msg,
-		       struct spi_transfer *t)
-{
-	int count;
-
-	if (hw->bpw <= 8) {
-		u8		*rx = t->rx_buf;
-		const u8	*tx = t->tx_buf;
-
-		for (count = 0; count < t->len; count += 1) {
-			if (t->tx_buf)
-				ti_ssp_spi_tx(hw, *tx++);
-			if (t->rx_buf)
-				*rx++ = ti_ssp_spi_rx(hw);
-		}
-	} else if (hw->bpw <= 16) {
-		u16		*rx = t->rx_buf;
-		const u16	*tx = t->tx_buf;
-
-		for (count = 0; count < t->len; count += 2) {
-			if (t->tx_buf)
-				ti_ssp_spi_tx(hw, *tx++);
-			if (t->rx_buf)
-				*rx++ = ti_ssp_spi_rx(hw);
-		}
-	} else {
-		u32		*rx = t->rx_buf;
-		const u32	*tx = t->tx_buf;
-
-		for (count = 0; count < t->len; count += 4) {
-			if (t->tx_buf)
-				ti_ssp_spi_tx(hw, *tx++);
-			if (t->rx_buf)
-				*rx++ = ti_ssp_spi_rx(hw);
-		}
-	}
-
-	msg->actual_length += count; /* bytes transferred */
-
-	dev_dbg(&msg->spi->dev, "xfer %s%s, %d bytes, %d bpw, count %d%s\n",
-		t->tx_buf ? "tx" : "", t->rx_buf ? "rx" : "", t->len,
-		hw->bpw, count, (count < t->len) ? " (under)" : "");
-
-	return (count < t->len) ? -EIO : 0; /* left over data */
-}
-
-static void ti_ssp_spi_chip_select(struct ti_ssp_spi *hw, int cs_active)
-{
-	cs_active = !!cs_active;
-	if (cs_active == hw->cs_active)
-		return;
-	ti_ssp_run(hw->dev, cs_active ? hw->pc_en : hw->pc_dis, 0, NULL);
-	hw->cs_active = cs_active;
-}
-
-#define __SHIFT_OUT(bits)	(SSP_OPCODE_SHIFT | SSP_OUT_MODE | \
-				 cs_en | clk | SSP_COUNT((bits) * 2 - 1))
-#define __SHIFT_IN(bits)	(SSP_OPCODE_SHIFT | SSP_IN_MODE  | \
-				 cs_en | clk | SSP_COUNT((bits) * 2 - 1))
-
-static int ti_ssp_spi_setup_transfer(struct ti_ssp_spi *hw, u8 bpw, u8 mode)
-{
-	int error, idx = 0;
-	u32 seqram[16];
-	u32 cs_en, cs_dis, clk;
-	u32 topbits, botbits;
-
-	mode &= MODE_BITS;
-	if (mode == hw->mode && bpw == hw->bpw)
-		return 0;
-
-	cs_en  = (mode & SPI_CS_HIGH) ? SSP_CS_HIGH : SSP_CS_LOW;
-	cs_dis = (mode & SPI_CS_HIGH) ? SSP_CS_LOW  : SSP_CS_HIGH;
-	clk    = (mode & SPI_CPOL)    ? SSP_CLK_HIGH : SSP_CLK_LOW;
-
-	/* Construct instructions */
-
-	/* Disable Chip Select */
-	hw->pc_dis = idx;
-	seqram[idx++] = SSP_OPCODE_DIRECT | SSP_OUT_MODE | cs_dis | clk;
-	seqram[idx++] = SSP_OPCODE_STOP   | SSP_OUT_MODE | cs_dis | clk;
-
-	/* Enable Chip Select */
-	hw->pc_en = idx;
-	seqram[idx++] = SSP_OPCODE_DIRECT | SSP_OUT_MODE | cs_en | clk;
-	seqram[idx++] = SSP_OPCODE_STOP   | SSP_OUT_MODE | cs_en | clk;
-
-	/* Reads and writes need to be split for bpw > 16 */
-	topbits = (bpw > 16) ? 16 : bpw;
-	botbits = bpw - topbits;
-
-	/* Write */
-	hw->pc_wr = idx;
-	seqram[idx++] = __SHIFT_OUT(topbits) | SSP_ADDR_REG;
-	if (botbits)
-		seqram[idx++] = __SHIFT_OUT(botbits)  | SSP_DATA_REG;
-	seqram[idx++] = SSP_OPCODE_STOP | SSP_OUT_MODE | cs_en | clk;
-
-	/* Read */
-	hw->pc_rd = idx;
-	if (botbits)
-		seqram[idx++] = __SHIFT_IN(botbits) | SSP_ADDR_REG;
-	seqram[idx++] = __SHIFT_IN(topbits) | SSP_DATA_REG;
-	seqram[idx++] = SSP_OPCODE_STOP | SSP_OUT_MODE | cs_en | clk;
-
-	error = ti_ssp_load(hw->dev, 0, seqram, idx);
-	if (error < 0)
-		return error;
-
-	error = ti_ssp_set_mode(hw->dev, ((mode & SPI_CPHA) ?
-					  0 : SSP_EARLY_DIN));
-	if (error < 0)
-		return error;
-
-	hw->bpw = bpw;
-	hw->mode = mode;
-
-	return error;
-}
-
-static void ti_ssp_spi_work(struct work_struct *work)
-{
-	struct ti_ssp_spi *hw = container_of(work, struct ti_ssp_spi, work);
-
-	spin_lock(&hw->lock);
-
-	 while (!list_empty(&hw->msg_queue)) {
-		struct spi_message	*m;
-		struct spi_device	*spi;
-		struct spi_transfer	*t = NULL;
-		int			status = 0;
-
-		m = container_of(hw->msg_queue.next, struct spi_message,
-				 queue);
-
-		list_del_init(&m->queue);
-
-		spin_unlock(&hw->lock);
-
-		spi = m->spi;
-
-		if (hw->select)
-			hw->select(spi->chip_select);
-
-		list_for_each_entry(t, &m->transfers, transfer_list) {
-			int bpw = spi->bits_per_word;
-			int xfer_status;
-
-			if (t->bits_per_word)
-				bpw = t->bits_per_word;
-
-			if (ti_ssp_spi_setup_transfer(hw, bpw, spi->mode) < 0)
-				break;
-
-			ti_ssp_spi_chip_select(hw, 1);
-
-			xfer_status = ti_ssp_spi_txrx(hw, m, t);
-			if (xfer_status < 0)
-				status = xfer_status;
-
-			if (t->delay_usecs)
-				udelay(t->delay_usecs);
-
-			if (t->cs_change)
-				ti_ssp_spi_chip_select(hw, 0);
-		}
-
-		ti_ssp_spi_chip_select(hw, 0);
-		m->status = status;
-		m->complete(m->context);
-
-		spin_lock(&hw->lock);
-	}
-
-	if (hw->shutdown)
-		complete(&hw->complete);
-
-	spin_unlock(&hw->lock);
-}
-
-static int ti_ssp_spi_transfer(struct spi_device *spi, struct spi_message *m)
-{
-	struct ti_ssp_spi	*hw;
-	struct spi_transfer	*t;
-	int			error = 0;
-
-	m->actual_length = 0;
-	m->status = -EINPROGRESS;
-
-	hw = spi_master_get_devdata(spi->master);
-
-	if (list_empty(&m->transfers) || !m->complete)
-		return -EINVAL;
-
-	list_for_each_entry(t, &m->transfers, transfer_list) {
-		if (t->len && !(t->rx_buf || t->tx_buf)) {
-			dev_err(&spi->dev, "invalid xfer, no buffer\n");
-			return -EINVAL;
-		}
-
-		if (t->len && t->rx_buf && t->tx_buf) {
-			dev_err(&spi->dev, "invalid xfer, full duplex\n");
-			return -EINVAL;
-		}
-	}
-
-	spin_lock(&hw->lock);
-	if (hw->shutdown) {
-		error = -ESHUTDOWN;
-		goto error_unlock;
-	}
-	list_add_tail(&m->queue, &hw->msg_queue);
-	queue_work(hw->workqueue, &hw->work);
-error_unlock:
-	spin_unlock(&hw->lock);
-	return error;
-}
-
-static int ti_ssp_spi_probe(struct platform_device *pdev)
-{
-	const struct ti_ssp_spi_data *pdata;
-	struct ti_ssp_spi *hw;
-	struct spi_master *master;
-	struct device *dev = &pdev->dev;
-	int error = 0;
-
-	pdata = dev_get_platdata(dev);
-	if (!pdata) {
-		dev_err(dev, "platform data not found\n");
-		return -EINVAL;
-	}
-
-	master = spi_alloc_master(dev, sizeof(struct ti_ssp_spi));
-	if (!master) {
-		dev_err(dev, "cannot allocate SPI master\n");
-		return -ENOMEM;
-	}
-
-	hw = spi_master_get_devdata(master);
-	platform_set_drvdata(pdev, hw);
-
-	hw->master = master;
-	hw->dev = dev;
-	hw->select = pdata->select;
-
-	spin_lock_init(&hw->lock);
-	init_completion(&hw->complete);
-	INIT_LIST_HEAD(&hw->msg_queue);
-	INIT_WORK(&hw->work, ti_ssp_spi_work);
-
-	hw->workqueue = create_singlethread_workqueue(dev_name(dev));
-	if (!hw->workqueue) {
-		error = -ENOMEM;
-		dev_err(dev, "work queue creation failed\n");
-		goto error_wq;
-	}
-
-	error = ti_ssp_set_iosel(hw->dev, pdata->iosel);
-	if (error < 0) {
-		dev_err(dev, "io setup failed\n");
-		goto error_iosel;
-	}
-
-	master->bus_num		= pdev->id;
-	master->num_chipselect	= pdata->num_cs;
-	master->mode_bits	= MODE_BITS;
-	master->bits_per_word_mask = SPI_BPW_RANGE_MASK(1, 32);
-	master->flags		= SPI_MASTER_HALF_DUPLEX;
-	master->transfer	= ti_ssp_spi_transfer;
-
-	error = spi_register_master(master);
-	if (error) {
-		dev_err(dev, "master registration failed\n");
-		goto error_reg;
-	}
-
-	return 0;
-
-error_reg:
-error_iosel:
-	destroy_workqueue(hw->workqueue);
-error_wq:
-	spi_master_put(master);
-	return error;
-}
-
-static int ti_ssp_spi_remove(struct platform_device *pdev)
-{
-	struct ti_ssp_spi *hw = platform_get_drvdata(pdev);
-	int error;
-
-	hw->shutdown = 1;
-	while (!list_empty(&hw->msg_queue)) {
-		error = wait_for_completion_interruptible(&hw->complete);
-		if (error < 0) {
-			hw->shutdown = 0;
-			return error;
-		}
-	}
-	destroy_workqueue(hw->workqueue);
-	spi_unregister_master(hw->master);
-
-	return 0;
-}
-
-static struct platform_driver ti_ssp_spi_driver = {
-	.probe		= ti_ssp_spi_probe,
-	.remove		= ti_ssp_spi_remove,
-	.driver		= {
-		.name	= "ti-ssp-spi",
-		.owner	= THIS_MODULE,
-	},
-};
-module_platform_driver(ti_ssp_spi_driver);
-
-MODULE_DESCRIPTION("SSP SPI Master");
-MODULE_AUTHOR("Cyril Chemparathy");
-MODULE_LICENSE("GPL");
-MODULE_ALIAS("platform:ti-ssp-spi");
-- 
1.8.3.2

