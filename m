Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751593AbaFXEHz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 00:07:55 -0400
Received: from regular1.263xmail.com ([211.150.99.135]:36450 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbaFXEHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 00:07:53 -0400
X-Greylist: delayed 523 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Jun 2014 00:07:51 EDT
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: addy.ke@rock-chips.com
X-FST-TO: broonie@kernel.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: addy.ke@rock-chips.com
X-UNIQUE-TAG: <60a693557fe0983ad36a0e1b5b1d5461>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: addy ke <addy.ke@rock-chips.com>
To: broonie@kernel.org, heiko@sntech.de, grant.likely@linaro.org,
        robh+dt@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        olof@lixom.net, hj@rock-chips.com, kever.yang@rock-chips.com,
        xjq@rock-chips.com, huangtao@rock-chips.com, zyw@rock-chips.com,
        yzq@rock-chips.com, zhenfu.fang@rock-chips.com, cf@rock-chips.com,
        addy ke <addy.ke@rock-chips.com>
Subject: [PATCH 2/2] spi: add driver for Rockchip RK3xxx SoCs integrated SPI
Date: Tue, 24 Jun 2014 12:07:32 +0800
Message-Id: <1403582852-9751-1-git-send-email-addy.ke@rock-chips.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1403582324-9485-1-git-send-email-addy.ke@rock-chips.com>
References: <1403582324-9485-1-git-send-email-addy.ke@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to facilitate understanding,rockchip SPI controller IP design looks
similar in its registers to designware. But IC implementation is different from
designware, such as dma request line, register offset, register configuration,
and so on.So we need a dedicated driver for Rockchip RK3XXX SoCs integrated SPI.

Signed-off-by: addy ke <addy.ke@rock-chips.com>
---
 drivers/spi/Kconfig        |  11 +
 drivers/spi/Makefile       |   1 +
 drivers/spi/spi-rockchip.c | 894 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 906 insertions(+)
 create mode 100644 drivers/spi/spi-rockchip.c

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index 60f2b41..5b51ab2 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -375,6 +375,17 @@ config SPI_PXA2XX
 config SPI_PXA2XX_PCI
 	def_tristate SPI_PXA2XX && PCI
 
+config SPI_ROCKCHIP
+	tristate "Rockchip SPI controller driver"
+	help
+	  This selects a driver for Rockchip SPI controller.
+
+	  If you say yes to this option, support will be included for
+	  RK3066, RK3188 and RK3288 families of SPI controller.
+	  Rockchip SPI controller support DMA transport and PIO mode.
+	  The main usecase of this controller is to use spi flash as boot
+	  device.
+
 config SPI_RSPI
 	tristate "Renesas RSPI/QSPI controller"
 	depends on (SUPERH && SH_DMAE_BASE) || ARCH_SHMOBILE
diff --git a/drivers/spi/Makefile b/drivers/spi/Makefile
index bd79266..361fbf3 100644
--- a/drivers/spi/Makefile
+++ b/drivers/spi/Makefile
@@ -60,6 +60,7 @@ spi-pxa2xx-platform-$(CONFIG_SPI_PXA2XX_DMA)	+= spi-pxa2xx-dma.o
 obj-$(CONFIG_SPI_PXA2XX)		+= spi-pxa2xx-platform.o
 obj-$(CONFIG_SPI_PXA2XX_PCI)		+= spi-pxa2xx-pci.o
 obj-$(CONFIG_SPI_QUP)			+= spi-qup.o
+obj-$(CONFIG_SPI_ROCKCHIP)		+= spi-rockchip.o
 obj-$(CONFIG_SPI_RSPI)			+= spi-rspi.o
 obj-$(CONFIG_SPI_S3C24XX)		+= spi-s3c24xx-hw.o
 spi-s3c24xx-hw-y			:= spi-s3c24xx.o
diff --git a/drivers/spi/spi-rockchip.c b/drivers/spi/spi-rockchip.c
new file mode 100644
index 0000000..bd7c218
--- /dev/null
+++ b/drivers/spi/spi-rockchip.c
@@ -0,0 +1,894 @@
+/*
+ * Copyright (c) 2014, Fuzhou Rockchip Electronics Co., Ltd
+ * Author: addy ke <addy.ke@rock-chips.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/spi/spi.h>
+#include <linux/scatterlist.h>
+#include <linux/of.h>
+#include <linux/pm_runtime.h>
+#include <linux/io.h>
+#include <linux/scatterlist.h>
+#include <linux/dmaengine.h>
+
+#define DRIVER_NAME "rockchip-spi"
+
+/* SPI register offsets */
+#define ROCKCHIP_SPI_CTRLR0			0x0000
+#define ROCKCHIP_SPI_CTRLR1			0x0004
+#define ROCKCHIP_SPI_SSIENR			0x0008
+#define ROCKCHIP_SPI_SER			0x000c
+#define ROCKCHIP_SPI_BAUDR			0x0010
+#define ROCKCHIP_SPI_TXFTLR			0x0014
+#define ROCKCHIP_SPI_RXFTLR			0x0018
+#define ROCKCHIP_SPI_TXFLR			0x001c
+#define ROCKCHIP_SPI_RXFLR			0x0020
+#define ROCKCHIP_SPI_SR				0x0024
+#define ROCKCHIP_SPI_IPR			0x0028
+#define ROCKCHIP_SPI_IMR			0x002c
+#define ROCKCHIP_SPI_ISR			0x0030
+#define ROCKCHIP_SPI_RISR			0x0034
+#define ROCKCHIP_SPI_ICR			0x0038
+#define ROCKCHIP_SPI_DMACR			0x003c
+#define ROCKCHIP_SPI_DMATDLR		0x0040
+#define ROCKCHIP_SPI_DMARDLR		0x0044
+#define ROCKCHIP_SPI_TXDR			0x0400
+#define ROCKCHIP_SPI_RXDR			0x0800
+
+/* Bit fields in CTRLR0 */
+#define CR0_DFS_OFFSET				0
+
+#define CR0_CFS_OFFSET				2
+
+#define CR0_SCPH_OFFSET				6
+
+#define CR0_SCPOL_OFFSET			7
+
+#define CR0_CSM_OFFSET				8
+#define CR0_CSM_KEEP				0x0
+/* ss_n be high for half sclk_out cycles */
+#define CR0_CSM_HALF				0X1
+/* ss_n be high for one sclk_out cycle */
+#define CR0_CSM_ONE					0x2
+
+/* ss_n to sclk_out delay */
+#define CR0_SSD_OFFSET				10
+/*
+ * The period between ss_n active and
+ * sclk_out active is half sclk_out cycles
+ */
+#define CR0_SSD_HALF				0x0
+/*
+ * The period between ss_n active and
+ * sclk_out active is one sclk_out cycle
+ */
+#define CR0_SSD_ONE					0x1
+
+#define CR0_EM_OFFSET				11
+#define CR0_EM_LITTLE				0x0
+#define CR0_EM_BIG					0x1
+
+#define CR0_FBM_OFFSET				12
+#define CR0_FBM_MSB					0x0
+#define CR0_FBM_LSB					0x1
+
+#define CR0_BHT_OFFSET				13
+#define CR0_BHT_16BIT				0x0
+#define CR0_BHT_8BIT				0x1
+
+#define CR0_RSD_OFFSET				14
+
+#define CR0_FRF_OFFSET				16
+#define CR0_FRF_SPI					0x0
+#define CR0_FRF_SSP					0x1
+#define CR0_FRF_MICROWIRE			0x2
+
+#define CR0_XFM_OFFSET				18
+#define CR0_XFM_MASK				(0x03 << SPI_XFM_OFFSET)
+#define CR0_XFM_TR					0x0
+#define CR0_XFM_TO					0x1
+#define CR0_XFM_RO					0x2
+
+#define CR0_OPM_OFFSET				20
+#define CR0_OPM_MASTER				0x0
+#define CR0_OPM_SLAVE				0x1
+
+#define CR0_MTM_OFFSET				0x21
+
+/* Bit fields in SR, 5bit */
+#define SR_MASK						0x1f
+#define SR_BUSY						(1 << 0)
+#define SR_TF_FULL					(1 << 1)
+#define SR_TF_EMPTY					(1 << 2)
+#define SR_RF_EMPTY					(1 << 3)
+#define SR_RF_FULL					(1 << 4)
+
+/* Bit fields in ISR, IMR, ISR, RISR, 5bit */
+#define INT_MASK					0x1f
+#define INT_TF_EMPTY				(1 << 0)
+#define INT_TF_OVERFLOW				(1 << 1)
+#define INT_RF_UNDERFLOW			(1 << 2)
+#define INT_RF_OVERFLOW				(1 << 3)
+#define INT_RF_FULL					(1 << 4)
+
+/* Bit fields in ICR, 4bit */
+#define ICR_MASK					0x0f
+#define ICR_ALL						(1 << 0)
+#define ICR_RF_UNDERFLOW			(1 << 1)
+#define ICR_RF_OVERFLOW				(1 << 2)
+#define ICR_TF_OVERFLOW				(1 << 3)
+
+/* Bit fields in DMACR */
+#define RF_DMA_EN					(1 << 0)
+#define TF_DMA_EN					(1 << 1)
+
+#define RXBUSY						(1<<2)
+#define TXBUSY						(1<<3)
+
+#define msecs_to_loops(t)	(loops_per_jiffy / 1000 * HZ * t)
+
+enum rockchip_ssi_type {
+	SSI_MOTO_SPI = 0,
+	SSI_TI_SSP,
+	SSI_NS_MICROWIRE,
+};
+
+struct rockchip_spi_dma_data {
+	struct dma_chan *ch;
+	enum dma_transfer_direction direction;
+	dma_addr_t addr;
+};
+
+struct rockchip_spi {
+	struct device			*dev;
+	struct spi_master		*master;
+
+	struct clk				*spiclk;
+	struct clk				*apb_pclk;
+
+	void __iomem			*regs;
+	int						irq;
+	/*depth of the FIFO buffer */
+	u32						fifo_len;
+	/* max bus freq supported */
+	u32						max_freq;
+	u16						bus_num;
+	/* supported slave numbers */
+	u16						num_cs;
+	enum rockchip_ssi_type	type;
+
+	u32						use_dma;
+
+	u8						cs;
+	u16						mode;
+
+	u8						tmode;
+
+	u8						bits_per_word;
+	u8						n_bytes;
+	unsigned				len;
+	u32						speed;
+
+	void					*tx;
+	void					*tx_end;
+	void					*rx;
+	void					*rx_end;
+
+	struct sg_table			tx_sg;
+	struct sg_table			rx_sg;
+
+	u32						state;
+
+	spinlock_t				lock;
+	struct completion		xfer_completion;
+
+	struct rockchip_spi_dma_data dma_rx;
+	struct rockchip_spi_dma_data dma_tx;
+};
+
+static inline void spi_enable_chip(struct rockchip_spi *rs, int enable)
+{
+	writel_relaxed((enable ? 1 : 0), rs->regs + ROCKCHIP_SPI_SSIENR);
+}
+
+static inline void spi_set_clk(struct rockchip_spi *rs, u16 div)
+{
+	writel_relaxed(div, rs->regs + ROCKCHIP_SPI_BAUDR);
+}
+
+static inline void spi_chip_sel(struct rockchip_spi *rs, u16 cs)
+{
+	writel_relaxed(1 << cs, rs->regs + ROCKCHIP_SPI_SER);
+}
+
+/* Disable IRQ bits */
+static inline void spi_mask_intr(struct rockchip_spi *rs, u32 mask)
+{
+	u32 new_mask;
+
+	new_mask = readl_relaxed(rs->regs + ROCKCHIP_SPI_IMR) & ~mask;
+	writel_relaxed(new_mask, rs->regs + ROCKCHIP_SPI_IMR);
+}
+
+/* Enable IRQ bits */
+static inline void spi_umask_intr(struct rockchip_spi *rs, u32 mask)
+{
+	u32 new_mask;
+
+	new_mask = readl_relaxed(rs->regs + ROCKCHIP_SPI_IMR) | mask;
+	writel_relaxed(new_mask, rs->regs + ROCKCHIP_SPI_IMR);
+}
+
+static inline void flush_fifo(struct rockchip_spi *rs)
+{
+	u32 rxflr = readl_relaxed(rs->regs + ROCKCHIP_SPI_RXFLR);
+
+	while (rxflr != 0) {
+		rxflr = readl_relaxed(rs->regs + ROCKCHIP_SPI_RXFLR);
+		cpu_relax();
+	}
+}
+
+static void rockchip_spi_hw_init(struct rockchip_spi *rs)
+{
+	u32 fifo;
+
+	spi_enable_chip(rs, 0);
+	spi_mask_intr(rs, INT_MASK);
+
+	for (fifo = 2; fifo < 32; fifo++) {
+		writel_relaxed(fifo, rs->regs + ROCKCHIP_SPI_TXFTLR);
+		if (fifo != readl_relaxed(rs->regs + ROCKCHIP_SPI_TXFTLR))
+			break;
+
+	}
+	rs->fifo_len = (fifo == 31) ? 0 : fifo;
+	writel_relaxed(0, rs->regs + ROCKCHIP_SPI_TXFTLR);
+}
+
+static int rockchip_spi_setup(struct spi_device *spi)
+{
+	struct rockchip_spi *rs;
+
+	rs = spi_master_get_devdata(spi->master);
+
+	pm_runtime_get_sync(rs->dev);
+
+	if (spi->max_speed_hz > rs->max_freq)
+		spi->max_speed_hz = rs->max_freq;
+
+	pm_runtime_put(rs->dev);
+
+	return 0;
+}
+
+static void rockchip_spi_cleanup(struct spi_device *spi)
+{
+	struct rockchip_spi *rs;
+
+	rs = spi_master_get_devdata(spi->master);
+
+	spi_set_ctldata(spi, NULL);
+}
+
+static int rockchip_spi_prepare_message(struct spi_master *master,
+		struct spi_message *msg)
+{
+	struct rockchip_spi *rs = spi_master_get_devdata(master);
+	struct spi_device *spi = msg->spi;
+
+	if (spi->chip_select >= rs->num_cs) {
+		dev_err(rs->dev, "chip_select %d is invalide, max is %d\n",
+				spi->chip_select, rs->num_cs - 1);
+		return -EINVAL;
+	}
+	rs->mode = spi->mode;
+	rs->cs = spi->chip_select;
+
+	return 0;
+}
+
+static void wait_for_not_busy(struct rockchip_spi *rs)
+{
+	u32 status;
+	unsigned long tmo;
+	int ms;
+
+	ms = rs->len * 8 * 1000 / rs->speed;
+	ms += 10;
+
+	tmo = msecs_to_loops(ms);
+	do {
+		status = readl_relaxed(rs->regs + ROCKCHIP_SPI_SR);
+	} while ((status & SR_BUSY) && tmo--);
+
+	BUG_ON(!tmo);
+}
+
+static inline u32 tx_max(struct rockchip_spi *rs)
+{
+	u32 tx_left, tx_room;
+
+	tx_left = (rs->tx_end - rs->tx) / rs->n_bytes;
+	tx_room = rs->fifo_len - readl_relaxed(rs->regs + ROCKCHIP_SPI_TXFLR);
+
+	return min(tx_left, tx_room);
+}
+
+static inline u32 rx_max(struct rockchip_spi *rs)
+{
+	u32 rx_left = (rs->rx_end - rs->rx) / rs->n_bytes;
+	u32 rx_room = (u32)readl_relaxed(rs->regs + ROCKCHIP_SPI_RXFLR);
+
+	return min(rx_left, rx_room);
+}
+
+static void rockchip_spi_pio_writer(struct rockchip_spi *rs)
+{
+	u32 max = tx_max(rs);
+	u32 txw = 0;
+
+	while (max--) {
+		if (rs->n_bytes == 1)
+			txw = *(u8 *)(rs->tx);
+		else
+			txw = *(u16 *)(rs->tx);
+
+		writel_relaxed(txw, rs->regs + ROCKCHIP_SPI_TXDR);
+		rs->tx += rs->n_bytes;
+	}
+	wait_for_not_busy(rs);
+}
+
+static int rockchip_spi_pio_reader(struct rockchip_spi *rs)
+{
+	u32 max = rx_max(rs);
+	u32 rxw;
+
+	while (max--) {
+		rxw = readl_relaxed(rs->regs + ROCKCHIP_SPI_RXDR);
+		if (rs->n_bytes == 1)
+			*(u8 *)(rs->rx) = (u8)rxw;
+		else
+			*(u16 *)(rs->rx) = (u16)rxw;
+		rs->rx += rs->n_bytes;
+	};
+
+	return 0;
+}
+
+static int rockchip_spi_pio_transfer(struct rockchip_spi *rs)
+{
+	int remain = 0;
+
+	do {
+		if (rs->tx) {
+			remain = rs->tx_end - rs->tx;
+			rockchip_spi_pio_writer(rs);
+		}
+
+		if (rs->rx) {
+			remain = rs->rx_end - rs->rx;
+			rockchip_spi_pio_reader(rs);
+		}
+
+		cpu_relax();
+	} while (remain);
+
+	return 0;
+}
+
+static int wait_for_dma(struct rockchip_spi *rs)
+{
+	unsigned long tmo;
+	int ms;
+
+	ms = rs->len * 8 * 1000 / rs->speed;
+	ms += 10;
+
+	tmo = msecs_to_jiffies(ms) + 10;
+	tmo = wait_for_completion_timeout(&rs->xfer_completion, tmo);
+
+	if (!tmo) {
+		if (rs->state & RXBUSY) {
+			dmaengine_terminate_all(rs->dma_rx.ch);
+			flush_fifo(rs);
+		}
+		if (rs->state & TXBUSY)
+			dmaengine_terminate_all(rs->dma_tx.ch);
+
+		return -ETIMEDOUT;
+	}
+
+	wait_for_not_busy(rs);
+
+	return 0;
+}
+
+static void rockchip_spi_dma_rxcb(void *data)
+{
+	unsigned long flags;
+	struct rockchip_spi *rs = data;
+
+	spin_lock_irqsave(&rs->lock, flags);
+	rs->state &= ~RXBUSY;
+	if (!(rs->state & TXBUSY))
+		complete(&rs->xfer_completion);
+	spin_unlock_irqrestore(&rs->lock, flags);
+}
+
+static void rockchip_spi_dma_txcb(void *data)
+{
+	unsigned long flags;
+	struct rockchip_spi *rs = data;
+
+	spin_lock_irqsave(&rs->lock, flags);
+	rs->state &= ~TXBUSY;
+	if (!(rs->state & RXBUSY))
+		complete(&rs->xfer_completion);
+	spin_unlock_irqrestore(&rs->lock, flags);
+}
+
+static int rockchip_spi_dma_transfer(struct rockchip_spi *rs)
+{
+	unsigned long flags;
+	struct dma_slave_config rxconf, txconf;
+	struct dma_async_tx_descriptor *rxdesc, *txdesc;
+
+
+	spin_lock_irqsave(&rs->lock, flags);
+	rs->state &= ~RXBUSY;
+	rs->state &= ~TXBUSY;
+	spin_unlock_irqrestore(&rs->lock, flags);
+
+	reinit_completion(&rs->xfer_completion);
+
+	if (rs->rx) {
+		rxconf.direction = rs->dma_rx.direction;
+		rxconf.src_addr = rs->dma_rx.addr;
+		rxconf.src_addr_width = rs->n_bytes;
+		rxconf.src_maxburst = rs->n_bytes;
+		dmaengine_slave_config(rs->dma_rx.ch, &rxconf);
+
+		rxdesc = dmaengine_prep_slave_sg(rs->dma_rx.ch,
+				rs->rx_sg.sgl, rs->rx_sg.nents,
+				rs->dma_rx.direction, DMA_PREP_INTERRUPT);
+
+		rxdesc->callback = rockchip_spi_dma_rxcb;
+		rxdesc->callback_param = rs;
+	}
+
+	if (rs->tx) {
+		txconf.direction = rs->dma_tx.direction;
+		txconf.dst_addr = rs->dma_tx.addr;
+		txconf.dst_addr_width = rs->n_bytes;
+		txconf.dst_maxburst = rs->n_bytes;
+		dmaengine_slave_config(rs->dma_tx.ch, &txconf);
+
+		txdesc = dmaengine_prep_slave_sg(rs->dma_tx.ch,
+				rs->tx_sg.sgl, rs->tx_sg.nents,
+				rs->dma_tx.direction, DMA_PREP_INTERRUPT);
+
+		txdesc->callback = rockchip_spi_dma_txcb;
+		txdesc->callback_param = rs;
+	}
+
+	/* rx must be started before tx due to spi instinct */
+	if (rs->rx) {
+		spin_lock_irqsave(&rs->lock, flags);
+		rs->state |= RXBUSY;
+		spin_unlock_irqrestore(&rs->lock, flags);
+		dmaengine_submit(rxdesc);
+		dma_async_issue_pending(rs->dma_rx.ch);
+	}
+
+	if (rs->tx) {
+		spin_lock_irqsave(&rs->lock, flags);
+		rs->state |= TXBUSY;
+		spin_unlock_irqrestore(&rs->lock, flags);
+		dmaengine_submit(txdesc);
+		dma_async_issue_pending(rs->dma_tx.ch);
+	}
+
+	return wait_for_dma(rs);
+}
+
+static void rockchip_spi_config(struct rockchip_spi *rs)
+{
+	u32 div = 0;
+	u32 dmacr = 0;
+
+	u32 cr0 = (CR0_BHT_8BIT << CR0_BHT_OFFSET)
+		| (CR0_SSD_ONE << CR0_SSD_OFFSET);
+
+	cr0 |= (rs->n_bytes << CR0_DFS_OFFSET);
+	cr0 |= ((rs->mode & 0x3) << CR0_SCPH_OFFSET);
+	cr0 |= (rs->tmode << CR0_XFM_OFFSET);
+	cr0 |= (rs->type << CR0_FRF_OFFSET);
+
+	if (rs->use_dma) {
+		if (rs->tx)
+			dmacr |= TF_DMA_EN;
+		if (rs->rx)
+			dmacr |= RF_DMA_EN;
+	}
+
+	/* div doesn't support odd number */
+	div = rs->max_freq / rs->speed;
+	div = (div + 1) & 0xfffe;
+
+	spi_enable_chip(rs, 0);
+
+	writel_relaxed(cr0, rs->regs + ROCKCHIP_SPI_CTRLR0);
+
+	writel_relaxed(rs->len - 1, rs->regs + ROCKCHIP_SPI_CTRLR1);
+	writel_relaxed(rs->fifo_len / 2 - 1, rs->regs + ROCKCHIP_SPI_TXFTLR);
+	writel_relaxed(rs->fifo_len / 2 - 1, rs->regs + ROCKCHIP_SPI_RXFTLR);
+
+	writel_relaxed(0, rs->regs + ROCKCHIP_SPI_DMATDLR);
+	writel_relaxed(0, rs->regs + ROCKCHIP_SPI_DMARDLR);
+	writel_relaxed(dmacr, rs->regs + ROCKCHIP_SPI_DMACR);
+
+	spi_mask_intr(rs, INT_MASK);
+
+	spi_chip_sel(rs, rs->cs);
+
+	spi_set_clk(rs, div);
+
+	dev_dbg(rs->dev, "cr0 0x%x, cs %d, div %d\n",
+			cr0, rs->cs, div);
+
+	spi_enable_chip(rs, 1);
+}
+
+static int rockchip_spi_transfer_one(struct spi_master *master,
+		struct spi_device *spi,
+		struct spi_transfer *xfer)
+{
+	int ret = 0;
+	struct rockchip_spi *rs = spi_master_get_devdata(master);
+
+	if (!xfer->tx_buf && !xfer->rx_buf) {
+		dev_err(rs->dev, "No buffer for transfer\n");
+		return -EINVAL;
+	}
+
+	rs->speed = xfer->speed_hz?:spi->max_speed_hz;
+	rs->bits_per_word = xfer->bits_per_word;
+	rs->n_bytes = xfer->bits_per_word >> 3;
+
+	rs->tx = (void *)xfer->tx_buf;
+	rs->tx_end = rs->tx + xfer->len;
+	rs->rx = xfer->rx_buf;
+	rs->rx_end = rs->rx + xfer->len;
+	rs->len = xfer->len;
+
+	rs->tx_sg = xfer->tx_sg;
+	rs->rx_sg = xfer->rx_sg;
+
+	if (rs->tx && rs->rx)
+		rs->tmode = CR0_XFM_TR;
+	else if (rs->tx)
+		rs->tmode = CR0_XFM_TO;
+	else if (rs->rx)
+		rs->tmode = CR0_XFM_RO;
+
+	if (master->can_dma && master->can_dma(master, spi, xfer))
+		rs->use_dma = 1;
+	else
+		rs->use_dma = 0;
+
+	rockchip_spi_config(rs);
+
+	if (rs->use_dma)
+		ret = rockchip_spi_dma_transfer(rs);
+	else
+		ret = rockchip_spi_pio_transfer(rs);
+
+	return ret;
+}
+
+static irqreturn_t rockchip_spi_irq(int irq, void *data)
+{
+	struct rockchip_spi *rs = data;
+	u32 isr = readl_relaxed(rs->regs + ROCKCHIP_SPI_ISR);
+
+	dev_dbg(rs->dev, "isr 0x%x\n", isr);
+
+	return IRQ_HANDLED;
+}
+
+static bool rockchip_spi_can_dma(struct spi_master *master,
+		struct spi_device *spi,
+		struct spi_transfer *xfer)
+{
+	struct rockchip_spi *rs = spi_master_get_devdata(master);
+
+	return (xfer->len > rs->fifo_len);
+}
+
+static int rockchip_spi_probe(struct platform_device *pdev)
+{
+	int ret = 0;
+	struct rockchip_spi *rs;
+	struct spi_master *master;
+	struct resource *mem;
+
+	master = spi_alloc_master(&pdev->dev, sizeof(struct rockchip_spi));
+	if (!master) {
+		dev_err(&pdev->dev, "No memory for spi_master\n");
+		return -ENOMEM;
+	}
+	platform_set_drvdata(pdev, master);
+
+	rs = spi_master_get_devdata(master);
+	memset(rs, 0, sizeof(struct rockchip_spi));
+
+	/* Get basic io resource and map it */
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!mem) {
+		dev_err(&pdev->dev, "Failed to get mem resource\n");
+		ret = -EINVAL;
+		goto err_get_resource;
+	}
+
+	rs->regs = devm_ioremap_resource(&pdev->dev, mem);
+	if (IS_ERR(rs->regs)) {
+		dev_err(&pdev->dev, "Failed to map SPI region\n");
+		ret =  PTR_ERR(rs->regs);
+		goto err_get_resource;
+	}
+
+	rs->irq = platform_get_irq(pdev, 0);
+	if (rs->irq < 0) {
+		dev_err(&pdev->dev, "Failed to get irq resource\n");
+		ret = rs->irq;
+		goto err_get_resource;
+	}
+
+	rs->apb_pclk = devm_clk_get(&pdev->dev, "apb_pclk");
+	if (IS_ERR(rs->apb_pclk)) {
+		dev_err(&pdev->dev, "Failed to get apb_pclk\n");
+		ret = PTR_ERR(rs->apb_pclk);
+		goto err_get_resource;
+	}
+
+	rs->spiclk = devm_clk_get(&pdev->dev, "spiclk");
+	if (IS_ERR(rs->spiclk)) {
+		dev_err(&pdev->dev, "Failed to get spi_pclk\n");
+		ret = PTR_ERR(rs->spiclk);
+		goto err_get_resource;
+	}
+
+	ret = clk_prepare_enable(rs->apb_pclk);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to enable apb_pclk\n");
+		goto err_get_resource;
+	}
+
+	ret = clk_prepare_enable(rs->spiclk);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to enable spi_clk\n");
+		goto err_spiclk_enable;
+	}
+
+	rs->type = SSI_MOTO_SPI;
+	rs->master = master;
+	rs->dev = &pdev->dev;
+	rs->bus_num = pdev->id;
+	rs->num_cs = 2;
+	rs->max_freq = clk_get_rate(rs->spiclk);
+
+	rockchip_spi_hw_init(rs);
+
+	spin_lock_init(&rs->lock);
+	init_completion(&rs->xfer_completion);
+
+	ret = devm_request_irq(&pdev->dev, rs->irq, rockchip_spi_irq, 0,
+			DRIVER_NAME, rs);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to request IRQ %d\n", rs->irq);
+		goto err_request_irq;
+	}
+
+	pm_runtime_set_active(&pdev->dev);
+	pm_runtime_enable(&pdev->dev);
+
+	master->auto_runtime_pm = true;
+	master->bus_num = pdev->id;
+	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_CS_HIGH | SPI_LOOP;
+	master->num_chipselect = rs->num_cs;
+	master->dev.of_node = pdev->dev.of_node;
+	master->bits_per_word_mask = SPI_BPW_MASK(16) | SPI_BPW_MASK(8);
+
+	master->setup = rockchip_spi_setup;
+	master->cleanup = rockchip_spi_cleanup;
+	master->prepare_message = rockchip_spi_prepare_message;
+	master->transfer_one = rockchip_spi_transfer_one;
+
+	rs->dma_tx.ch = dma_request_slave_channel(rs->dev, "tx");
+	if (!rs->dma_tx.ch)
+		dev_warn(rs->dev, "Failed to request TX DMA channel\n");
+
+	rs->dma_rx.ch = dma_request_slave_channel(rs->dev, "rx");
+	if (!rs->dma_rx.ch) {
+		if (rs->dma_tx.ch) {
+			dma_release_channel(rs->dma_tx.ch);
+			rs->dma_tx.ch = NULL;
+		}
+		dev_warn(rs->dev, "Failed to request RX DMA channel\n");
+	}
+
+	if (rs->dma_tx.ch && rs->dma_rx.ch) {
+		rs->dma_tx.addr = (dma_addr_t)(mem->start + ROCKCHIP_SPI_TXDR);
+		rs->dma_rx.addr = (dma_addr_t)(mem->start + ROCKCHIP_SPI_RXDR);
+		rs->dma_tx.direction = DMA_MEM_TO_DEV;
+		rs->dma_tx.direction = DMA_DEV_TO_MEM;
+
+		master->can_dma = rockchip_spi_can_dma;
+		master->dma_tx = rs->dma_tx.ch;
+		master->dma_rx = rs->dma_rx.ch;
+	}
+
+	ret = devm_spi_register_master(&pdev->dev, master);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to register master\n");
+		goto err_register_master;
+	}
+
+	dev_info(&pdev->dev, "Rockchip SPI controller initialized\n");
+
+	return 0;
+
+err_register_master:
+	if (rs->dma_tx.ch)
+		dma_release_channel(rs->dma_tx.ch);
+	if (rs->dma_rx.ch)
+		dma_release_channel(rs->dma_rx.ch);
+err_request_irq:
+	clk_disable_unprepare(rs->spiclk);
+err_spiclk_enable:
+	clk_disable_unprepare(rs->apb_pclk);
+err_get_resource:
+	spi_master_put(master);
+
+	return ret;
+}
+
+static int rockchip_spi_remove(struct platform_device *pdev)
+{
+	struct spi_master *master = spi_master_get(platform_get_drvdata(pdev));
+	struct rockchip_spi *rs = spi_master_get_devdata(master);
+
+	pm_runtime_disable(&pdev->dev);
+
+	clk_disable_unprepare(rs->spiclk);
+	clk_disable_unprepare(rs->apb_pclk);
+
+	if (rs->dma_tx.ch)
+		dma_release_channel(rs->dma_tx.ch);
+	if (rs->dma_rx.ch)
+		dma_release_channel(rs->dma_rx.ch);
+
+	spi_master_put(master);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int rockchip_spi_suspend(struct device *dev)
+{
+	int ret = 0;
+	struct spi_master *master = dev_get_drvdata(dev);
+	struct rockchip_spi *rs = spi_master_get_devdata(master);
+
+	ret = spi_master_suspend(rs->master);
+	if (ret)
+		return ret;
+
+	if (!pm_runtime_suspended(dev)) {
+		clk_disable_unprepare(rs->spiclk);
+		clk_disable_unprepare(rs->apb_pclk);
+	}
+
+	return ret;
+}
+
+static int rockchip_spi_resume(struct device *dev)
+{
+	int ret = 0;
+	struct spi_master *master = dev_get_drvdata(dev);
+	struct rockchip_spi *rs = spi_master_get_devdata(master);
+
+	if (!pm_runtime_suspended(dev)) {
+		ret = clk_prepare_enable(rs->apb_pclk);
+		if (ret < 0)
+			return ret;
+		ret = clk_prepare_enable(rs->spiclk);
+
+		if (ret < 0) {
+			clk_disable_unprepare(rs->apb_pclk);
+			return ret;
+		}
+	}
+
+	return spi_master_resume(rs->master);
+}
+#endif /* CONFIG_PM_SLEEP */
+
+#ifdef CONFIG_PM_RUNTIME
+static int rockchip_spi_runtime_suspend(struct device *dev)
+{
+	struct spi_master *master = dev_get_drvdata(dev);
+	struct rockchip_spi *rs = spi_master_get_devdata(master);
+
+	clk_disable_unprepare(rs->spiclk);
+	clk_disable_unprepare(rs->apb_pclk);
+
+	return 0;
+}
+
+static int rockchip_spi_runtime_resume(struct device *dev)
+{
+	int ret;
+	struct spi_master *master = dev_get_drvdata(dev);
+	struct rockchip_spi *rs = spi_master_get_devdata(master);
+
+	ret = clk_prepare_enable(rs->apb_pclk);
+	if (ret)
+		return ret;
+
+	ret = clk_prepare_enable(rs->spiclk);
+	if (ret)
+		clk_disable_unprepare(rs->apb_pclk);
+
+	return ret;
+}
+#endif /* CONFIG_PM_RUNTIME */
+
+static const struct dev_pm_ops rockchip_spi_pm = {
+	SET_SYSTEM_SLEEP_PM_OPS(rockchip_spi_suspend, rockchip_spi_resume)
+	SET_RUNTIME_PM_OPS(rockchip_spi_runtime_suspend,
+			   rockchip_spi_runtime_resume, NULL)
+};
+
+static const struct of_device_id rockchip_spi_dt_match[] = {
+	{ .compatible = "rockchip,rk3066-spi", },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, rockchip_spi_dt_match);
+
+static struct platform_driver rockchip_spi_driver = {
+	.driver = {
+		.name	= DRIVER_NAME,
+		.owner = THIS_MODULE,
+		.pm = &rockchip_spi_pm,
+		.of_match_table = of_match_ptr(rockchip_spi_dt_match),
+	},
+	.probe = rockchip_spi_probe,
+	.remove = rockchip_spi_remove,
+};
+
+module_platform_driver(rockchip_spi_driver);
+
+MODULE_AUTHOR("addy ke <addy.ke@rock-chips.com>");
+MODULE_DESCRIPTION("ROCKCHIP SPI Controller Driver");
+MODULE_LICENSE("GPL v2");
-- 
1.8.3.2


