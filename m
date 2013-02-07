Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758640Ab3BGNMo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 08:12:44 -0500
Received: from vsp-authed02.binero.net ([195.74.38.226]:23543 "HELO
	vsp-authed-02-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758536Ab3BGNMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 08:12:35 -0500
From: Andreas Larsson <andreas@gaisler.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        spi-devel-general@lists.sourceforge.net,
        Mingkai Hu <Mingkai.hu@freescale.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Joakim Tjernlund <Joakim.Tjernlund@transmode.se>,
        Kumar Gala <galak@kernel.crashing.org>,
        Peter Korsgaard <jacmet@sunsite.dk>, linux-kernel@vger.kernel.org,
        software@gaisler.com
Subject: [PATCH v2 1/7] spi: spi-fsl-spi: Make driver usable in CPU mode outside of an FSL_SOC environment
Date: Thu,  7 Feb 2013 14:12:05 +0100
Message-Id: <1360242731-13700-2-git-send-email-andreas@gaisler.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1360242731-13700-1-git-send-email-andreas@gaisler.com>
References: <1360242731-13700-1-git-send-email-andreas@gaisler.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes the spi-fsl-spi driver usable in CPU mode outside of an FSL_SOC and
even an powerpc environment by moving CPM mode functionality to a separate file
that is only compiled and linked in an FSL_SOC environment and adding some
ifdefs to hide types and functions or provide alternatives.

For devicetree probing a "clock-frequency" property is used for clock frequency
instead of calls to FSL_SOC-specific functions.

Signed-off-by: Andreas Larsson <andreas@gaisler.com>
---

This introduces a lot of line changes, but to illustrate that large
parts of is just moving between files you can run the following script
at this commit standing in the source root directory:

#!/bin/bash

ORIG=$(mktemp)
CPM=$(mktemp)

git show HEAD~:drivers/spi/spi-fsl-spi.c > $ORIG

sed -n "42,+8 p" $ORIG >> $CPM
sed -n "90,+12 p" $ORIG >> $CPM
sed -n "122,+12 p" $ORIG | sed 's/^\t//'  >> $CPM
sed -n "298,+105 p" $ORIG >> $CPM
sed -n "571,+23 p" $ORIG >> $CPM
sed -n "649,+190 p" $ORIG >> $CPM

diff -u $CPM drivers/spi/spi-fsl-cpm.c

sed -n "51,+38 p" $ORIG  | diff -u -- - drivers/spi/spi-fsl-spi.h

rm $ORIG $CPM


 Documentation/devicetree/bindings/spi/fsl-spi.txt |    1 +
 drivers/spi/Kconfig                               |    7 +-
 drivers/spi/Makefile                              |    1 +
 drivers/spi/spi-fsl-cpm.c                         |  387 +++++++++++++++++++
 drivers/spi/spi-fsl-cpm.h                         |   43 +++
 drivers/spi/spi-fsl-lib.c                         |    8 +
 drivers/spi/spi-fsl-lib.h                         |    6 +-
 drivers/spi/spi-fsl-spi.c                         |  411 +--------------------
 drivers/spi/spi-fsl-spi.h                         |   61 +++
 9 files changed, 520 insertions(+), 405 deletions(-)
 create mode 100644 drivers/spi/spi-fsl-cpm.c
 create mode 100644 drivers/spi/spi-fsl-cpm.h
 create mode 100644 drivers/spi/spi-fsl-spi.h

diff --git a/Documentation/devicetree/bindings/spi/fsl-spi.txt b/Documentation/devicetree/bindings/spi/fsl-spi.txt
index 777abd7..4f2ea94 100644
--- a/Documentation/devicetree/bindings/spi/fsl-spi.txt
+++ b/Documentation/devicetree/bindings/spi/fsl-spi.txt
@@ -14,6 +14,7 @@ Required properties:
   controller you have.
 - interrupt-parent : the phandle for the interrupt controller that
   services interrupts for this device.
+- clock-frequency : input clock frequency to non FSL_SOC cores
 
 Optional properties:
 - gpios : specifies the gpio pins to be used for chipselects.
diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index a90393d..da5968e 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -218,12 +218,17 @@ config SPI_MPC512x_PSC
 
 config SPI_FSL_LIB
 	tristate
+	depends on OF
+
+config SPI_FSL_CPM
+	tristate
 	depends on FSL_SOC
 
 config SPI_FSL_SPI
 	bool "Freescale SPI controller"
-	depends on FSL_SOC
+	depends on OF
 	select SPI_FSL_LIB
+	select SPI_FSL_CPM if FSL_SOC
 	help
 	  This enables using the Freescale SPI controllers in master mode.
 	  MPC83xx platform uses the controller in cpu mode or CPM/QE mode.
diff --git a/drivers/spi/Makefile b/drivers/spi/Makefile
index 64e970b..818d5c1 100644
--- a/drivers/spi/Makefile
+++ b/drivers/spi/Makefile
@@ -28,6 +28,7 @@ obj-$(CONFIG_SPI_DW_PCI)		+= spi-dw-midpci.o
 spi-dw-midpci-objs			:= spi-dw-pci.o spi-dw-mid.o
 obj-$(CONFIG_SPI_EP93XX)		+= spi-ep93xx.o
 obj-$(CONFIG_SPI_FALCON)		+= spi-falcon.o
+obj-$(CONFIG_SPI_FSL_CPM)		+= spi-fsl-cpm.o
 obj-$(CONFIG_SPI_FSL_LIB)		+= spi-fsl-lib.o
 obj-$(CONFIG_SPI_FSL_ESPI)		+= spi-fsl-espi.o
 obj-$(CONFIG_SPI_FSL_SPI)		+= spi-fsl-spi.o
diff --git a/drivers/spi/spi-fsl-cpm.c b/drivers/spi/spi-fsl-cpm.c
new file mode 100644
index 0000000..a39fda4
--- /dev/null
+++ b/drivers/spi/spi-fsl-cpm.c
@@ -0,0 +1,387 @@
+/*
+ * Freescale SPI controller driver cpm functions.
+ *
+ * Maintainer: Kumar Gala
+ *
+ * Copyright (C) 2006 Polycom, Inc.
+ * Copyright 2010 Freescale Semiconductor, Inc.
+ *
+ * CPM SPI and QE buffer descriptors mode support:
+ * Copyright (c) 2009  MontaVista Software, Inc.
+ * Author: Anton Vorontsov <avorontsov@ru.mvista.com>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/spi/spi.h>
+#include <linux/fsl_devices.h>
+#include <linux/dma-mapping.h>
+#include <asm/cpm.h>
+#include <asm/qe.h>
+
+#include "spi-fsl-lib.h"
+#include "spi-fsl-cpm.h"
+#include "spi-fsl-spi.h"
+
+/* CPM1 and CPM2 are mutually exclusive. */
+#ifdef CONFIG_CPM1
+#include <asm/cpm1.h>
+#define CPM_SPI_CMD mk_cr_cmd(CPM_CR_CH_SPI, 0)
+#else
+#include <asm/cpm2.h>
+#define CPM_SPI_CMD mk_cr_cmd(CPM_CR_SPI_PAGE, CPM_CR_SPI_SBLOCK, 0, 0)
+#endif
+
+#define	SPIE_TXB	0x00000200	/* Last char is written to tx fifo */
+#define	SPIE_RXB	0x00000100	/* Last char is written to rx buf */
+
+/* SPCOM register values */
+#define	SPCOM_STR	(1 << 23)	/* Start transmit */
+
+#define	SPI_PRAM_SIZE	0x100
+#define	SPI_MRBLR	((unsigned int)PAGE_SIZE)
+
+static void *fsl_dummy_rx;
+static DEFINE_MUTEX(fsl_dummy_rx_lock);
+static int fsl_dummy_rx_refcnt;
+
+void fsl_spi_cpm_reinit_txrx(struct mpc8xxx_spi *mspi)
+{
+	if (mspi->flags & SPI_QE) {
+		qe_issue_cmd(QE_INIT_TX_RX, mspi->subblock,
+			     QE_CR_PROTOCOL_UNSPECIFIED, 0);
+	} else {
+		cpm_command(CPM_SPI_CMD, CPM_CR_INIT_TRX);
+		if (mspi->flags & SPI_CPM1) {
+			out_be16(&mspi->pram->rbptr,
+				 in_be16(&mspi->pram->rbase));
+			out_be16(&mspi->pram->tbptr,
+				 in_be16(&mspi->pram->tbase));
+		}
+	}
+}
+
+static void fsl_spi_cpm_bufs_start(struct mpc8xxx_spi *mspi)
+{
+	struct cpm_buf_desc __iomem *tx_bd = mspi->tx_bd;
+	struct cpm_buf_desc __iomem *rx_bd = mspi->rx_bd;
+	unsigned int xfer_len = min(mspi->count, SPI_MRBLR);
+	unsigned int xfer_ofs;
+	struct fsl_spi_reg *reg_base = mspi->reg_base;
+
+	xfer_ofs = mspi->xfer_in_progress->len - mspi->count;
+
+	if (mspi->rx_dma == mspi->dma_dummy_rx)
+		out_be32(&rx_bd->cbd_bufaddr, mspi->rx_dma);
+	else
+		out_be32(&rx_bd->cbd_bufaddr, mspi->rx_dma + xfer_ofs);
+	out_be16(&rx_bd->cbd_datlen, 0);
+	out_be16(&rx_bd->cbd_sc, BD_SC_EMPTY | BD_SC_INTRPT | BD_SC_WRAP);
+
+	if (mspi->tx_dma == mspi->dma_dummy_tx)
+		out_be32(&tx_bd->cbd_bufaddr, mspi->tx_dma);
+	else
+		out_be32(&tx_bd->cbd_bufaddr, mspi->tx_dma + xfer_ofs);
+	out_be16(&tx_bd->cbd_datlen, xfer_len);
+	out_be16(&tx_bd->cbd_sc, BD_SC_READY | BD_SC_INTRPT | BD_SC_WRAP |
+				 BD_SC_LAST);
+
+	/* start transfer */
+	mpc8xxx_spi_write_reg(&reg_base->command, SPCOM_STR);
+}
+
+int fsl_spi_cpm_bufs(struct mpc8xxx_spi *mspi,
+			    struct spi_transfer *t, bool is_dma_mapped)
+{
+	struct device *dev = mspi->dev;
+	struct fsl_spi_reg *reg_base = mspi->reg_base;
+
+	if (is_dma_mapped) {
+		mspi->map_tx_dma = 0;
+		mspi->map_rx_dma = 0;
+	} else {
+		mspi->map_tx_dma = 1;
+		mspi->map_rx_dma = 1;
+	}
+
+	if (!t->tx_buf) {
+		mspi->tx_dma = mspi->dma_dummy_tx;
+		mspi->map_tx_dma = 0;
+	}
+
+	if (!t->rx_buf) {
+		mspi->rx_dma = mspi->dma_dummy_rx;
+		mspi->map_rx_dma = 0;
+	}
+
+	if (mspi->map_tx_dma) {
+		void *nonconst_tx = (void *)mspi->tx; /* shut up gcc */
+
+		mspi->tx_dma = dma_map_single(dev, nonconst_tx, t->len,
+					      DMA_TO_DEVICE);
+		if (dma_mapping_error(dev, mspi->tx_dma)) {
+			dev_err(dev, "unable to map tx dma\n");
+			return -ENOMEM;
+		}
+	} else if (t->tx_buf) {
+		mspi->tx_dma = t->tx_dma;
+	}
+
+	if (mspi->map_rx_dma) {
+		mspi->rx_dma = dma_map_single(dev, mspi->rx, t->len,
+					      DMA_FROM_DEVICE);
+		if (dma_mapping_error(dev, mspi->rx_dma)) {
+			dev_err(dev, "unable to map rx dma\n");
+			goto err_rx_dma;
+		}
+	} else if (t->rx_buf) {
+		mspi->rx_dma = t->rx_dma;
+	}
+
+	/* enable rx ints */
+	mpc8xxx_spi_write_reg(&reg_base->mask, SPIE_RXB);
+
+	mspi->xfer_in_progress = t;
+	mspi->count = t->len;
+
+	/* start CPM transfers */
+	fsl_spi_cpm_bufs_start(mspi);
+
+	return 0;
+
+err_rx_dma:
+	if (mspi->map_tx_dma)
+		dma_unmap_single(dev, mspi->tx_dma, t->len, DMA_TO_DEVICE);
+	return -ENOMEM;
+}
+
+void fsl_spi_cpm_bufs_complete(struct mpc8xxx_spi *mspi)
+{
+	struct device *dev = mspi->dev;
+	struct spi_transfer *t = mspi->xfer_in_progress;
+
+	if (mspi->map_tx_dma)
+		dma_unmap_single(dev, mspi->tx_dma, t->len, DMA_TO_DEVICE);
+	if (mspi->map_rx_dma)
+		dma_unmap_single(dev, mspi->rx_dma, t->len, DMA_FROM_DEVICE);
+	mspi->xfer_in_progress = NULL;
+}
+
+void fsl_spi_cpm_irq(struct mpc8xxx_spi *mspi, u32 events)
+{
+	u16 len;
+	struct fsl_spi_reg *reg_base = mspi->reg_base;
+
+	dev_dbg(mspi->dev, "%s: bd datlen %d, count %d\n", __func__,
+		in_be16(&mspi->rx_bd->cbd_datlen), mspi->count);
+
+	len = in_be16(&mspi->rx_bd->cbd_datlen);
+	if (len > mspi->count) {
+		WARN_ON(1);
+		len = mspi->count;
+	}
+
+	/* Clear the events */
+	mpc8xxx_spi_write_reg(&reg_base->event, events);
+
+	mspi->count -= len;
+	if (mspi->count)
+		fsl_spi_cpm_bufs_start(mspi);
+	else
+		complete(&mspi->done);
+}
+
+static void *fsl_spi_alloc_dummy_rx(void)
+{
+	mutex_lock(&fsl_dummy_rx_lock);
+
+	if (!fsl_dummy_rx)
+		fsl_dummy_rx = kmalloc(SPI_MRBLR, GFP_KERNEL);
+	if (fsl_dummy_rx)
+		fsl_dummy_rx_refcnt++;
+
+	mutex_unlock(&fsl_dummy_rx_lock);
+
+	return fsl_dummy_rx;
+}
+
+static void fsl_spi_free_dummy_rx(void)
+{
+	mutex_lock(&fsl_dummy_rx_lock);
+
+	switch (fsl_dummy_rx_refcnt) {
+	case 0:
+		WARN_ON(1);
+		break;
+	case 1:
+		kfree(fsl_dummy_rx);
+		fsl_dummy_rx = NULL;
+		/* fall through */
+	default:
+		fsl_dummy_rx_refcnt--;
+		break;
+	}
+
+	mutex_unlock(&fsl_dummy_rx_lock);
+}
+
+static unsigned long fsl_spi_cpm_get_pram(struct mpc8xxx_spi *mspi)
+{
+	struct device *dev = mspi->dev;
+	struct device_node *np = dev->of_node;
+	const u32 *iprop;
+	int size;
+	void __iomem *spi_base;
+	unsigned long pram_ofs = -ENOMEM;
+
+	/* Can't use of_address_to_resource(), QE muram isn't at 0. */
+	iprop = of_get_property(np, "reg", &size);
+
+	/* QE with a fixed pram location? */
+	if (mspi->flags & SPI_QE && iprop && size == sizeof(*iprop) * 4)
+		return cpm_muram_alloc_fixed(iprop[2], SPI_PRAM_SIZE);
+
+	/* QE but with a dynamic pram location? */
+	if (mspi->flags & SPI_QE) {
+		pram_ofs = cpm_muram_alloc(SPI_PRAM_SIZE, 64);
+		qe_issue_cmd(QE_ASSIGN_PAGE_TO_DEVICE, mspi->subblock,
+			     QE_CR_PROTOCOL_UNSPECIFIED, pram_ofs);
+		return pram_ofs;
+	}
+
+	spi_base = of_iomap(np, 1);
+	if (spi_base == NULL)
+		return -EINVAL;
+
+	if (mspi->flags & SPI_CPM2) {
+		pram_ofs = cpm_muram_alloc(SPI_PRAM_SIZE, 64);
+		out_be16(spi_base, pram_ofs);
+	} else {
+		struct spi_pram __iomem *pram = spi_base;
+		u16 rpbase = in_be16(&pram->rpbase);
+
+		/* Microcode relocation patch applied? */
+		if (rpbase) {
+			pram_ofs = rpbase;
+		} else {
+			pram_ofs = cpm_muram_alloc(SPI_PRAM_SIZE, 64);
+			out_be16(spi_base, pram_ofs);
+		}
+	}
+
+	iounmap(spi_base);
+	return pram_ofs;
+}
+
+int fsl_spi_cpm_init(struct mpc8xxx_spi *mspi)
+{
+	struct device *dev = mspi->dev;
+	struct device_node *np = dev->of_node;
+	const u32 *iprop;
+	int size;
+	unsigned long pram_ofs;
+	unsigned long bds_ofs;
+
+	if (!(mspi->flags & SPI_CPM_MODE))
+		return 0;
+
+	if (!fsl_spi_alloc_dummy_rx())
+		return -ENOMEM;
+
+	if (mspi->flags & SPI_QE) {
+		iprop = of_get_property(np, "cell-index", &size);
+		if (iprop && size == sizeof(*iprop))
+			mspi->subblock = *iprop;
+
+		switch (mspi->subblock) {
+		default:
+			dev_warn(dev, "cell-index unspecified, assuming SPI1");
+			/* fall through */
+		case 0:
+			mspi->subblock = QE_CR_SUBBLOCK_SPI1;
+			break;
+		case 1:
+			mspi->subblock = QE_CR_SUBBLOCK_SPI2;
+			break;
+		}
+	}
+
+	pram_ofs = fsl_spi_cpm_get_pram(mspi);
+	if (IS_ERR_VALUE(pram_ofs)) {
+		dev_err(dev, "can't allocate spi parameter ram\n");
+		goto err_pram;
+	}
+
+	bds_ofs = cpm_muram_alloc(sizeof(*mspi->tx_bd) +
+				  sizeof(*mspi->rx_bd), 8);
+	if (IS_ERR_VALUE(bds_ofs)) {
+		dev_err(dev, "can't allocate bds\n");
+		goto err_bds;
+	}
+
+	mspi->dma_dummy_tx = dma_map_single(dev, empty_zero_page, PAGE_SIZE,
+					    DMA_TO_DEVICE);
+	if (dma_mapping_error(dev, mspi->dma_dummy_tx)) {
+		dev_err(dev, "unable to map dummy tx buffer\n");
+		goto err_dummy_tx;
+	}
+
+	mspi->dma_dummy_rx = dma_map_single(dev, fsl_dummy_rx, SPI_MRBLR,
+					    DMA_FROM_DEVICE);
+	if (dma_mapping_error(dev, mspi->dma_dummy_rx)) {
+		dev_err(dev, "unable to map dummy rx buffer\n");
+		goto err_dummy_rx;
+	}
+
+	mspi->pram = cpm_muram_addr(pram_ofs);
+
+	mspi->tx_bd = cpm_muram_addr(bds_ofs);
+	mspi->rx_bd = cpm_muram_addr(bds_ofs + sizeof(*mspi->tx_bd));
+
+	/* Initialize parameter ram. */
+	out_be16(&mspi->pram->tbase, cpm_muram_offset(mspi->tx_bd));
+	out_be16(&mspi->pram->rbase, cpm_muram_offset(mspi->rx_bd));
+	out_8(&mspi->pram->tfcr, CPMFCR_EB | CPMFCR_GBL);
+	out_8(&mspi->pram->rfcr, CPMFCR_EB | CPMFCR_GBL);
+	out_be16(&mspi->pram->mrblr, SPI_MRBLR);
+	out_be32(&mspi->pram->rstate, 0);
+	out_be32(&mspi->pram->rdp, 0);
+	out_be16(&mspi->pram->rbptr, 0);
+	out_be16(&mspi->pram->rbc, 0);
+	out_be32(&mspi->pram->rxtmp, 0);
+	out_be32(&mspi->pram->tstate, 0);
+	out_be32(&mspi->pram->tdp, 0);
+	out_be16(&mspi->pram->tbptr, 0);
+	out_be16(&mspi->pram->tbc, 0);
+	out_be32(&mspi->pram->txtmp, 0);
+
+	return 0;
+
+err_dummy_rx:
+	dma_unmap_single(dev, mspi->dma_dummy_tx, PAGE_SIZE, DMA_TO_DEVICE);
+err_dummy_tx:
+	cpm_muram_free(bds_ofs);
+err_bds:
+	cpm_muram_free(pram_ofs);
+err_pram:
+	fsl_spi_free_dummy_rx();
+	return -ENOMEM;
+}
+
+void fsl_spi_cpm_free(struct mpc8xxx_spi *mspi)
+{
+	struct device *dev = mspi->dev;
+
+	if (!(mspi->flags & SPI_CPM_MODE))
+		return;
+
+	dma_unmap_single(dev, mspi->dma_dummy_rx, SPI_MRBLR, DMA_FROM_DEVICE);
+	dma_unmap_single(dev, mspi->dma_dummy_tx, PAGE_SIZE, DMA_TO_DEVICE);
+	cpm_muram_free(cpm_muram_offset(mspi->tx_bd));
+	cpm_muram_free(cpm_muram_offset(mspi->pram));
+	fsl_spi_free_dummy_rx();
+}
diff --git a/drivers/spi/spi-fsl-cpm.h b/drivers/spi/spi-fsl-cpm.h
new file mode 100644
index 0000000..c711158
--- /dev/null
+++ b/drivers/spi/spi-fsl-cpm.h
@@ -0,0 +1,43 @@
+/*
+ * Freescale SPI controller driver cpm functions.
+ *
+ * Maintainer: Kumar Gala
+ *
+ * Copyright (C) 2006 Polycom, Inc.
+ * Copyright 2010 Freescale Semiconductor, Inc.
+ *
+ * CPM SPI and QE buffer descriptors mode support:
+ * Copyright (c) 2009  MontaVista Software, Inc.
+ * Author: Anton Vorontsov <avorontsov@ru.mvista.com>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#ifndef __SPI_FSL_CPM_H__
+#define __SPI_FSL_CPM_H__
+
+#include "spi-fsl-lib.h"
+
+#ifdef CONFIG_FSL_SOC
+extern void fsl_spi_cpm_reinit_txrx(struct mpc8xxx_spi *mspi);
+extern int fsl_spi_cpm_bufs(struct mpc8xxx_spi *mspi,
+			    struct spi_transfer *t, bool is_dma_mapped);
+extern void fsl_spi_cpm_bufs_complete(struct mpc8xxx_spi *mspi);
+extern void fsl_spi_cpm_irq(struct mpc8xxx_spi *mspi, u32 events);
+extern int fsl_spi_cpm_init(struct mpc8xxx_spi *mspi);
+extern void fsl_spi_cpm_free(struct mpc8xxx_spi *mspi);
+#else
+static inline void fsl_spi_cpm_reinit_txrx(struct mpc8xxx_spi *mspi) { }
+static inline int fsl_spi_cpm_bufs(struct mpc8xxx_spi *mspi,
+				   struct spi_transfer *t,
+				   bool is_dma_mapped) { return 0; }
+static inline void fsl_spi_cpm_bufs_complete(struct mpc8xxx_spi *mspi) { }
+static inline void fsl_spi_cpm_irq(struct mpc8xxx_spi *mspi, u32 events) { }
+static inline int fsl_spi_cpm_init(struct mpc8xxx_spi *mspi) { return 0; }
+static inline void fsl_spi_cpm_free(struct mpc8xxx_spi *mspi) { }
+#endif
+
+#endif /* __SPI_FSL_CPM_H__ */
diff --git a/drivers/spi/spi-fsl-lib.c b/drivers/spi/spi-fsl-lib.c
index 8ade675..a91db0e 100644
--- a/drivers/spi/spi-fsl-lib.c
+++ b/drivers/spi/spi-fsl-lib.c
@@ -23,7 +23,9 @@
 #include <linux/mm.h>
 #include <linux/of_platform.h>
 #include <linux/spi/spi.h>
+#ifdef CONFIG_FSL_SOC
 #include <sysdev/fsl_soc.h>
+#endif
 
 #include "spi-fsl-lib.h"
 
@@ -208,6 +210,7 @@ int of_mpc8xxx_spi_probe(struct platform_device *ofdev)
 	/* Allocate bus num dynamically. */
 	pdata->bus_num = -1;
 
+#ifdef CONFIG_FSL_SOC
 	/* SPI controller is either clocked from QE or SoC clock. */
 	pdata->sysclk = get_brgfreq();
 	if (pdata->sysclk == -1) {
@@ -217,6 +220,11 @@ int of_mpc8xxx_spi_probe(struct platform_device *ofdev)
 			goto err;
 		}
 	}
+#else
+	ret = of_property_read_u32(np, "clock-frequency", &pdata->sysclk);
+	if (ret)
+		goto err;
+#endif
 
 	prop = of_get_property(np, "mode", NULL);
 	if (prop && !strcmp(prop, "cpu-qe"))
diff --git a/drivers/spi/spi-fsl-lib.h b/drivers/spi/spi-fsl-lib.h
index cbe881b..d785595 100644
--- a/drivers/spi/spi-fsl-lib.h
+++ b/drivers/spi/spi-fsl-lib.h
@@ -34,8 +34,10 @@ struct mpc8xxx_spi {
 
 	int subblock;
 	struct spi_pram __iomem *pram;
+#ifdef CONFIG_FSL_SOC
 	struct cpm_buf_desc __iomem *tx_bd;
 	struct cpm_buf_desc __iomem *rx_bd;
+#endif
 
 	struct spi_transfer *xfer_in_progress;
 
@@ -87,12 +89,12 @@ struct spi_mpc8xxx_cs {
 
 static inline void mpc8xxx_spi_write_reg(__be32 __iomem *reg, u32 val)
 {
-	out_be32(reg, val);
+	iowrite32be(val, reg);
 }
 
 static inline u32 mpc8xxx_spi_read_reg(__be32 __iomem *reg)
 {
-	return in_be32(reg);
+	return ioread32be(reg);
 }
 
 struct mpc8xxx_spi_probe_info {
diff --git a/drivers/spi/spi-fsl-spi.c b/drivers/spi/spi-fsl-spi.c
index 9dcfeed..e9ae1d8 100644
--- a/drivers/spi/spi-fsl-spi.c
+++ b/drivers/spi/spi-fsl-spi.c
@@ -30,75 +30,14 @@
 #include <linux/mutex.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
 #include <linux/gpio.h>
 #include <linux/of_gpio.h>
 
-#include <sysdev/fsl_soc.h>
-#include <asm/cpm.h>
-#include <asm/qe.h>
-
 #include "spi-fsl-lib.h"
-
-/* CPM1 and CPM2 are mutually exclusive. */
-#ifdef CONFIG_CPM1
-#include <asm/cpm1.h>
-#define CPM_SPI_CMD mk_cr_cmd(CPM_CR_CH_SPI, 0)
-#else
-#include <asm/cpm2.h>
-#define CPM_SPI_CMD mk_cr_cmd(CPM_CR_SPI_PAGE, CPM_CR_SPI_SBLOCK, 0, 0)
-#endif
-
-/* SPI Controller registers */
-struct fsl_spi_reg {
-	u8 res1[0x20];
-	__be32 mode;
-	__be32 event;
-	__be32 mask;
-	__be32 command;
-	__be32 transmit;
-	__be32 receive;
-};
-
-/* SPI Controller mode register definitions */
-#define	SPMODE_LOOP		(1 << 30)
-#define	SPMODE_CI_INACTIVEHIGH	(1 << 29)
-#define	SPMODE_CP_BEGIN_EDGECLK	(1 << 28)
-#define	SPMODE_DIV16		(1 << 27)
-#define	SPMODE_REV		(1 << 26)
-#define	SPMODE_MS		(1 << 25)
-#define	SPMODE_ENABLE		(1 << 24)
-#define	SPMODE_LEN(x)		((x) << 20)
-#define	SPMODE_PM(x)		((x) << 16)
-#define	SPMODE_OP		(1 << 14)
-#define	SPMODE_CG(x)		((x) << 7)
-
-/*
- * Default for SPI Mode:
- *	SPI MODE 0 (inactive low, phase middle, MSB, 8-bit length, slow clk
- */
-#define	SPMODE_INIT_VAL (SPMODE_CI_INACTIVEHIGH | SPMODE_DIV16 | SPMODE_REV | \
-			 SPMODE_MS | SPMODE_LEN(7) | SPMODE_PM(0xf))
-
-/* SPIE register values */
-#define	SPIE_NE		0x00000200	/* Not empty */
-#define	SPIE_NF		0x00000100	/* Not full */
-
-/* SPIM register values */
-#define	SPIM_NE		0x00000200	/* Not empty */
-#define	SPIM_NF		0x00000100	/* Not full */
-
-#define	SPIE_TXB	0x00000200	/* Last char is written to tx fifo */
-#define	SPIE_RXB	0x00000100	/* Last char is written to rx buf */
-
-/* SPCOM register values */
-#define	SPCOM_STR	(1 << 23)	/* Start transmit */
-
-#define	SPI_PRAM_SIZE	0x100
-#define	SPI_MRBLR	((unsigned int)PAGE_SIZE)
-
-static void *fsl_dummy_rx;
-static DEFINE_MUTEX(fsl_dummy_rx_lock);
-static int fsl_dummy_rx_refcnt;
+#include "spi-fsl-cpm.h"
+#include "spi-fsl-spi.h"
 
 static void fsl_spi_change_mode(struct spi_device *spi)
 {
@@ -119,18 +58,7 @@ static void fsl_spi_change_mode(struct spi_device *spi)
 
 	/* When in CPM mode, we need to reinit tx and rx. */
 	if (mspi->flags & SPI_CPM_MODE) {
-		if (mspi->flags & SPI_QE) {
-			qe_issue_cmd(QE_INIT_TX_RX, mspi->subblock,
-				     QE_CR_PROTOCOL_UNSPECIFIED, 0);
-		} else {
-			cpm_command(CPM_SPI_CMD, CPM_CR_INIT_TRX);
-			if (mspi->flags & SPI_CPM1) {
-				out_be16(&mspi->pram->rbptr,
-					 in_be16(&mspi->pram->rbase));
-				out_be16(&mspi->pram->tbptr,
-					 in_be16(&mspi->pram->tbase));
-			}
-		}
+		fsl_spi_cpm_reinit_txrx(mspi);
 	}
 	mpc8xxx_spi_write_reg(mode, cs->hw_mode);
 	local_irq_restore(flags);
@@ -295,112 +223,6 @@ static int fsl_spi_setup_transfer(struct spi_device *spi,
 	return 0;
 }
 
-static void fsl_spi_cpm_bufs_start(struct mpc8xxx_spi *mspi)
-{
-	struct cpm_buf_desc __iomem *tx_bd = mspi->tx_bd;
-	struct cpm_buf_desc __iomem *rx_bd = mspi->rx_bd;
-	unsigned int xfer_len = min(mspi->count, SPI_MRBLR);
-	unsigned int xfer_ofs;
-	struct fsl_spi_reg *reg_base = mspi->reg_base;
-
-	xfer_ofs = mspi->xfer_in_progress->len - mspi->count;
-
-	if (mspi->rx_dma == mspi->dma_dummy_rx)
-		out_be32(&rx_bd->cbd_bufaddr, mspi->rx_dma);
-	else
-		out_be32(&rx_bd->cbd_bufaddr, mspi->rx_dma + xfer_ofs);
-	out_be16(&rx_bd->cbd_datlen, 0);
-	out_be16(&rx_bd->cbd_sc, BD_SC_EMPTY | BD_SC_INTRPT | BD_SC_WRAP);
-
-	if (mspi->tx_dma == mspi->dma_dummy_tx)
-		out_be32(&tx_bd->cbd_bufaddr, mspi->tx_dma);
-	else
-		out_be32(&tx_bd->cbd_bufaddr, mspi->tx_dma + xfer_ofs);
-	out_be16(&tx_bd->cbd_datlen, xfer_len);
-	out_be16(&tx_bd->cbd_sc, BD_SC_READY | BD_SC_INTRPT | BD_SC_WRAP |
-				 BD_SC_LAST);
-
-	/* start transfer */
-	mpc8xxx_spi_write_reg(&reg_base->command, SPCOM_STR);
-}
-
-static int fsl_spi_cpm_bufs(struct mpc8xxx_spi *mspi,
-				struct spi_transfer *t, bool is_dma_mapped)
-{
-	struct device *dev = mspi->dev;
-	struct fsl_spi_reg *reg_base = mspi->reg_base;
-
-	if (is_dma_mapped) {
-		mspi->map_tx_dma = 0;
-		mspi->map_rx_dma = 0;
-	} else {
-		mspi->map_tx_dma = 1;
-		mspi->map_rx_dma = 1;
-	}
-
-	if (!t->tx_buf) {
-		mspi->tx_dma = mspi->dma_dummy_tx;
-		mspi->map_tx_dma = 0;
-	}
-
-	if (!t->rx_buf) {
-		mspi->rx_dma = mspi->dma_dummy_rx;
-		mspi->map_rx_dma = 0;
-	}
-
-	if (mspi->map_tx_dma) {
-		void *nonconst_tx = (void *)mspi->tx; /* shut up gcc */
-
-		mspi->tx_dma = dma_map_single(dev, nonconst_tx, t->len,
-					      DMA_TO_DEVICE);
-		if (dma_mapping_error(dev, mspi->tx_dma)) {
-			dev_err(dev, "unable to map tx dma\n");
-			return -ENOMEM;
-		}
-	} else if (t->tx_buf) {
-		mspi->tx_dma = t->tx_dma;
-	}
-
-	if (mspi->map_rx_dma) {
-		mspi->rx_dma = dma_map_single(dev, mspi->rx, t->len,
-					      DMA_FROM_DEVICE);
-		if (dma_mapping_error(dev, mspi->rx_dma)) {
-			dev_err(dev, "unable to map rx dma\n");
-			goto err_rx_dma;
-		}
-	} else if (t->rx_buf) {
-		mspi->rx_dma = t->rx_dma;
-	}
-
-	/* enable rx ints */
-	mpc8xxx_spi_write_reg(&reg_base->mask, SPIE_RXB);
-
-	mspi->xfer_in_progress = t;
-	mspi->count = t->len;
-
-	/* start CPM transfers */
-	fsl_spi_cpm_bufs_start(mspi);
-
-	return 0;
-
-err_rx_dma:
-	if (mspi->map_tx_dma)
-		dma_unmap_single(dev, mspi->tx_dma, t->len, DMA_TO_DEVICE);
-	return -ENOMEM;
-}
-
-static void fsl_spi_cpm_bufs_complete(struct mpc8xxx_spi *mspi)
-{
-	struct device *dev = mspi->dev;
-	struct spi_transfer *t = mspi->xfer_in_progress;
-
-	if (mspi->map_tx_dma)
-		dma_unmap_single(dev, mspi->tx_dma, t->len, DMA_TO_DEVICE);
-	if (mspi->map_rx_dma)
-		dma_unmap_single(dev, mspi->rx_dma, t->len, DMA_FROM_DEVICE);
-	mspi->xfer_in_progress = NULL;
-}
-
 static int fsl_spi_cpu_bufs(struct mpc8xxx_spi *mspi,
 				struct spi_transfer *t, unsigned int len)
 {
@@ -568,30 +390,6 @@ static int fsl_spi_setup(struct spi_device *spi)
 	return 0;
 }
 
-static void fsl_spi_cpm_irq(struct mpc8xxx_spi *mspi, u32 events)
-{
-	u16 len;
-	struct fsl_spi_reg *reg_base = mspi->reg_base;
-
-	dev_dbg(mspi->dev, "%s: bd datlen %d, count %d\n", __func__,
-		in_be16(&mspi->rx_bd->cbd_datlen), mspi->count);
-
-	len = in_be16(&mspi->rx_bd->cbd_datlen);
-	if (len > mspi->count) {
-		WARN_ON(1);
-		len = mspi->count;
-	}
-
-	/* Clear the events */
-	mpc8xxx_spi_write_reg(&reg_base->event, events);
-
-	mspi->count -= len;
-	if (mspi->count)
-		fsl_spi_cpm_bufs_start(mspi);
-	else
-		complete(&mspi->done);
-}
-
 static void fsl_spi_cpu_irq(struct mpc8xxx_spi *mspi, u32 events)
 {
 	struct fsl_spi_reg *reg_base = mspi->reg_base;
@@ -646,197 +444,6 @@ static irqreturn_t fsl_spi_irq(s32 irq, void *context_data)
 	return ret;
 }
 
-static void *fsl_spi_alloc_dummy_rx(void)
-{
-	mutex_lock(&fsl_dummy_rx_lock);
-
-	if (!fsl_dummy_rx)
-		fsl_dummy_rx = kmalloc(SPI_MRBLR, GFP_KERNEL);
-	if (fsl_dummy_rx)
-		fsl_dummy_rx_refcnt++;
-
-	mutex_unlock(&fsl_dummy_rx_lock);
-
-	return fsl_dummy_rx;
-}
-
-static void fsl_spi_free_dummy_rx(void)
-{
-	mutex_lock(&fsl_dummy_rx_lock);
-
-	switch (fsl_dummy_rx_refcnt) {
-	case 0:
-		WARN_ON(1);
-		break;
-	case 1:
-		kfree(fsl_dummy_rx);
-		fsl_dummy_rx = NULL;
-		/* fall through */
-	default:
-		fsl_dummy_rx_refcnt--;
-		break;
-	}
-
-	mutex_unlock(&fsl_dummy_rx_lock);
-}
-
-static unsigned long fsl_spi_cpm_get_pram(struct mpc8xxx_spi *mspi)
-{
-	struct device *dev = mspi->dev;
-	struct device_node *np = dev->of_node;
-	const u32 *iprop;
-	int size;
-	void __iomem *spi_base;
-	unsigned long pram_ofs = -ENOMEM;
-
-	/* Can't use of_address_to_resource(), QE muram isn't at 0. */
-	iprop = of_get_property(np, "reg", &size);
-
-	/* QE with a fixed pram location? */
-	if (mspi->flags & SPI_QE && iprop && size == sizeof(*iprop) * 4)
-		return cpm_muram_alloc_fixed(iprop[2], SPI_PRAM_SIZE);
-
-	/* QE but with a dynamic pram location? */
-	if (mspi->flags & SPI_QE) {
-		pram_ofs = cpm_muram_alloc(SPI_PRAM_SIZE, 64);
-		qe_issue_cmd(QE_ASSIGN_PAGE_TO_DEVICE, mspi->subblock,
-				QE_CR_PROTOCOL_UNSPECIFIED, pram_ofs);
-		return pram_ofs;
-	}
-
-	spi_base = of_iomap(np, 1);
-	if (spi_base == NULL)
-		return -EINVAL;
-
-	if (mspi->flags & SPI_CPM2) {
-		pram_ofs = cpm_muram_alloc(SPI_PRAM_SIZE, 64);
-		out_be16(spi_base, pram_ofs);
-	} else {
-		struct spi_pram __iomem *pram = spi_base;
-		u16 rpbase = in_be16(&pram->rpbase);
-
-		/* Microcode relocation patch applied? */
-		if (rpbase)
-			pram_ofs = rpbase;
-		else {
-			pram_ofs = cpm_muram_alloc(SPI_PRAM_SIZE, 64);
-			out_be16(spi_base, pram_ofs);
-		}
-	}
-
-	iounmap(spi_base);
-	return pram_ofs;
-}
-
-static int fsl_spi_cpm_init(struct mpc8xxx_spi *mspi)
-{
-	struct device *dev = mspi->dev;
-	struct device_node *np = dev->of_node;
-	const u32 *iprop;
-	int size;
-	unsigned long pram_ofs;
-	unsigned long bds_ofs;
-
-	if (!(mspi->flags & SPI_CPM_MODE))
-		return 0;
-
-	if (!fsl_spi_alloc_dummy_rx())
-		return -ENOMEM;
-
-	if (mspi->flags & SPI_QE) {
-		iprop = of_get_property(np, "cell-index", &size);
-		if (iprop && size == sizeof(*iprop))
-			mspi->subblock = *iprop;
-
-		switch (mspi->subblock) {
-		default:
-			dev_warn(dev, "cell-index unspecified, assuming SPI1");
-			/* fall through */
-		case 0:
-			mspi->subblock = QE_CR_SUBBLOCK_SPI1;
-			break;
-		case 1:
-			mspi->subblock = QE_CR_SUBBLOCK_SPI2;
-			break;
-		}
-	}
-
-	pram_ofs = fsl_spi_cpm_get_pram(mspi);
-	if (IS_ERR_VALUE(pram_ofs)) {
-		dev_err(dev, "can't allocate spi parameter ram\n");
-		goto err_pram;
-	}
-
-	bds_ofs = cpm_muram_alloc(sizeof(*mspi->tx_bd) +
-				  sizeof(*mspi->rx_bd), 8);
-	if (IS_ERR_VALUE(bds_ofs)) {
-		dev_err(dev, "can't allocate bds\n");
-		goto err_bds;
-	}
-
-	mspi->dma_dummy_tx = dma_map_single(dev, empty_zero_page, PAGE_SIZE,
-					    DMA_TO_DEVICE);
-	if (dma_mapping_error(dev, mspi->dma_dummy_tx)) {
-		dev_err(dev, "unable to map dummy tx buffer\n");
-		goto err_dummy_tx;
-	}
-
-	mspi->dma_dummy_rx = dma_map_single(dev, fsl_dummy_rx, SPI_MRBLR,
-					    DMA_FROM_DEVICE);
-	if (dma_mapping_error(dev, mspi->dma_dummy_rx)) {
-		dev_err(dev, "unable to map dummy rx buffer\n");
-		goto err_dummy_rx;
-	}
-
-	mspi->pram = cpm_muram_addr(pram_ofs);
-
-	mspi->tx_bd = cpm_muram_addr(bds_ofs);
-	mspi->rx_bd = cpm_muram_addr(bds_ofs + sizeof(*mspi->tx_bd));
-
-	/* Initialize parameter ram. */
-	out_be16(&mspi->pram->tbase, cpm_muram_offset(mspi->tx_bd));
-	out_be16(&mspi->pram->rbase, cpm_muram_offset(mspi->rx_bd));
-	out_8(&mspi->pram->tfcr, CPMFCR_EB | CPMFCR_GBL);
-	out_8(&mspi->pram->rfcr, CPMFCR_EB | CPMFCR_GBL);
-	out_be16(&mspi->pram->mrblr, SPI_MRBLR);
-	out_be32(&mspi->pram->rstate, 0);
-	out_be32(&mspi->pram->rdp, 0);
-	out_be16(&mspi->pram->rbptr, 0);
-	out_be16(&mspi->pram->rbc, 0);
-	out_be32(&mspi->pram->rxtmp, 0);
-	out_be32(&mspi->pram->tstate, 0);
-	out_be32(&mspi->pram->tdp, 0);
-	out_be16(&mspi->pram->tbptr, 0);
-	out_be16(&mspi->pram->tbc, 0);
-	out_be32(&mspi->pram->txtmp, 0);
-
-	return 0;
-
-err_dummy_rx:
-	dma_unmap_single(dev, mspi->dma_dummy_tx, PAGE_SIZE, DMA_TO_DEVICE);
-err_dummy_tx:
-	cpm_muram_free(bds_ofs);
-err_bds:
-	cpm_muram_free(pram_ofs);
-err_pram:
-	fsl_spi_free_dummy_rx();
-	return -ENOMEM;
-}
-
-static void fsl_spi_cpm_free(struct mpc8xxx_spi *mspi)
-{
-	struct device *dev = mspi->dev;
-
-	if (!(mspi->flags & SPI_CPM_MODE))
-		return;
-
-	dma_unmap_single(dev, mspi->dma_dummy_rx, SPI_MRBLR, DMA_FROM_DEVICE);
-	dma_unmap_single(dev, mspi->dma_dummy_tx, PAGE_SIZE, DMA_TO_DEVICE);
-	cpm_muram_free(cpm_muram_offset(mspi->tx_bd));
-	cpm_muram_free(cpm_muram_offset(mspi->pram));
-	fsl_spi_free_dummy_rx();
-}
-
 static void fsl_spi_remove(struct mpc8xxx_spi *mspi)
 {
 	iounmap(mspi->reg_base);
@@ -1049,7 +656,7 @@ static int of_fsl_spi_probe(struct platform_device *ofdev)
 	struct device_node *np = ofdev->dev.of_node;
 	struct spi_master *master;
 	struct resource mem;
-	struct resource irq;
+	int irq;
 	int ret = -ENOMEM;
 
 	ret = of_mpc8xxx_spi_probe(ofdev);
@@ -1064,13 +671,13 @@ static int of_fsl_spi_probe(struct platform_device *ofdev)
 	if (ret)
 		goto err;
 
-	ret = of_irq_to_resource(np, 0, &irq);
-	if (!ret) {
+	irq = irq_of_parse_and_map(np, 0);
+	if (!irq) {
 		ret = -EINVAL;
 		goto err;
 	}
 
-	master = fsl_spi_probe(dev, &mem, irq.start);
+	master = fsl_spi_probe(dev, &mem, irq);
 	if (IS_ERR(master)) {
 		ret = PTR_ERR(master);
 		goto err;
diff --git a/drivers/spi/spi-fsl-spi.h b/drivers/spi/spi-fsl-spi.h
new file mode 100644
index 0000000..8bd73a4
--- /dev/null
+++ b/drivers/spi/spi-fsl-spi.h
@@ -0,0 +1,61 @@
+/*
+ * Freescale SPI controller driver.
+ *
+ * Maintainer: Kumar Gala
+ *
+ * Copyright (C) 2006 Polycom, Inc.
+ * Copyright 2010 Freescale Semiconductor, Inc.
+ *
+ * CPM SPI and QE buffer descriptors mode support:
+ * Copyright (c) 2009  MontaVista Software, Inc.
+ * Author: Anton Vorontsov <avorontsov@ru.mvista.com>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#ifndef __SPI_FSL_SPI_H__
+#define __SPI_FSL_SPI_H__
+
+/* SPI Controller registers */
+struct fsl_spi_reg {
+	u8 res1[0x20];
+	__be32 mode;
+	__be32 event;
+	__be32 mask;
+	__be32 command;
+	__be32 transmit;
+	__be32 receive;
+};
+
+/* SPI Controller mode register definitions */
+#define	SPMODE_LOOP		(1 << 30)
+#define	SPMODE_CI_INACTIVEHIGH	(1 << 29)
+#define	SPMODE_CP_BEGIN_EDGECLK	(1 << 28)
+#define	SPMODE_DIV16		(1 << 27)
+#define	SPMODE_REV		(1 << 26)
+#define	SPMODE_MS		(1 << 25)
+#define	SPMODE_ENABLE		(1 << 24)
+#define	SPMODE_LEN(x)		((x) << 20)
+#define	SPMODE_PM(x)		((x) << 16)
+#define	SPMODE_OP		(1 << 14)
+#define	SPMODE_CG(x)		((x) << 7)
+
+/*
+ * Default for SPI Mode:
+ *	SPI MODE 0 (inactive low, phase middle, MSB, 8-bit length, slow clk
+ */
+#define	SPMODE_INIT_VAL (SPMODE_CI_INACTIVEHIGH | SPMODE_DIV16 | SPMODE_REV | \
+			 SPMODE_MS | SPMODE_LEN(7) | SPMODE_PM(0xf))
+
+/* SPIE register values */
+#define	SPIE_NE		0x00000200	/* Not empty */
+#define	SPIE_NF		0x00000100	/* Not full */
+
+/* SPIM register values */
+#define	SPIM_NE		0x00000200	/* Not empty */
+#define	SPIM_NF		0x00000100	/* Not full */
+
+#endif /* __SPI_FSL_SPI_H__ */
-- 
1.7.0.4

