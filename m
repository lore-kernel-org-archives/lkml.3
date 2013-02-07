Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758678Ab3BGNMp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 08:12:45 -0500
Received: from vsp-authed02.binero.net ([195.74.38.226]:30954 "HELO
	vsp-authed-03-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758578Ab3BGNMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 08:12:37 -0500
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
Subject: [PATCH v2 6/7] spi: spi-fsl-spi: Add support for Aeroflex Gaisler GRLIB cores normally running on SPARC
Date: Thu,  7 Feb 2013 14:12:10 +0100
Message-Id: <1360242731-13700-7-git-send-email-andreas@gaisler.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1360242731-13700-1-git-send-email-andreas@gaisler.com>
References: <1360242731-13700-1-git-send-email-andreas@gaisler.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for the mostly register-compatible SPICTRL cores from the
GRLIB VHDL IP core library from Aeroflex Gaisler. They are normally running on
SPARC. A different entry in of_fsl_spi_match matches this core and indicates a
different hardware type that is used to set up different function pointers and
special cases.

The GRLIB core operates in cpu mode. The number of bits per word might be
limited. There might be native chipselects selected via a slave select
register. These differences to the FSL type cores, if present, are indicated by
a capabilities register. Other register and function differences exists but are
not relevant to the driver.

Signed-off-by: Andreas Larsson <andreas@gaisler.com>
---
 Documentation/devicetree/bindings/spi/fsl-spi.txt  |    2 +-
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 drivers/spi/Kconfig                                |    4 +-
 drivers/spi/spi-fsl-spi.c                          |   98 +++++++++++++++++---
 drivers/spi/spi-fsl-spi.h                          |   13 +++-
 5 files changed, 103 insertions(+), 15 deletions(-)

diff --git a/Documentation/devicetree/bindings/spi/fsl-spi.txt b/Documentation/devicetree/bindings/spi/fsl-spi.txt
index 4f2ea94..b032dd7 100644
--- a/Documentation/devicetree/bindings/spi/fsl-spi.txt
+++ b/Documentation/devicetree/bindings/spi/fsl-spi.txt
@@ -4,7 +4,7 @@ Required properties:
 - cell-index : QE SPI subblock index.
 		0: QE subblock SPI1
 		1: QE subblock SPI2
-- compatible : should be "fsl,spi".
+- compatible : should be "fsl,spi" or "aeroflexgaisler,spictrl".
 - mode : the SPI operation mode, it can be "cpu" or "cpu-qe".
 - reg : Offset and length of the register set for the device
 - interrupts : <a b> where a is the interrupt number and b is a
diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index 902b1b1..fee5232 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -5,6 +5,7 @@ using them to avoid name-space collisions.
 
 ad	Avionic Design GmbH
 adi	Analog Devices, Inc.
+aeroflexgaisler	Aeroflex Gaisler AB
 ak	Asahi Kasei Corp.
 amcc	Applied Micro Circuits Corporation (APM, formally AMCC)
 apm	Applied Micro Circuits Corporation (APM)
diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index da5968e..3b5b928 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -225,7 +225,7 @@ config SPI_FSL_CPM
 	depends on FSL_SOC
 
 config SPI_FSL_SPI
-	bool "Freescale SPI controller"
+	bool "Freescale SPI controller and Aeroflex Gaisler GRLIB SPI controller"
 	depends on OF
 	select SPI_FSL_LIB
 	select SPI_FSL_CPM if FSL_SOC
@@ -233,6 +233,8 @@ config SPI_FSL_SPI
 	  This enables using the Freescale SPI controllers in master mode.
 	  MPC83xx platform uses the controller in cpu mode or CPM/QE mode.
 	  MPC8569 uses the controller in QE mode, MPC8610 in cpu mode.
+	  This also enables using the Aeroflex Gaisler GRLIB SPI controller in
+	  master mode.
 
 config SPI_FSL_ESPI
 	bool "Freescale eSPI controller"
diff --git a/drivers/spi/spi-fsl-spi.c b/drivers/spi/spi-fsl-spi.c
index 437319f..55652e6 100644
--- a/drivers/spi/spi-fsl-spi.c
+++ b/drivers/spi/spi-fsl-spi.c
@@ -10,6 +10,10 @@
  * Copyright (c) 2009  MontaVista Software, Inc.
  * Author: Anton Vorontsov <avorontsov@ru.mvista.com>
  *
+ * GRLIB support:
+ * Copyright (c) 2012 Aeroflex Gaisler AB.
+ * Author: Andreas Larsson <andreas@gaisler.com>
+ *
  * This program is free software; you can redistribute  it and/or modify it
  * under  the terms of  the GNU General  Public License as published by the
  * Free Software Foundation;  either version 2 of the  License, or (at your
@@ -40,6 +44,7 @@
 #include "spi-fsl-spi.h"
 
 #define TYPE_FSL	0
+#define TYPE_GRLIB	1
 
 struct fsl_spi_match_data {
 	int type;
@@ -49,11 +54,19 @@ static struct fsl_spi_match_data of_fsl_spi_fsl_config = {
 	.type = TYPE_FSL,
 };
 
+static struct fsl_spi_match_data of_fsl_spi_grlib_config = {
+	.type = TYPE_GRLIB,
+};
+
 static struct of_device_id of_fsl_spi_match[] = {
 	{
 		.compatible = "fsl,spi",
 		.data = &of_fsl_spi_fsl_config,
 	},
+	{
+		.compatible = "aeroflexgaisler,spictrl",
+		.data = &of_fsl_spi_grlib_config,
+	},
 	{}
 };
 MODULE_DEVICE_TABLE(of, of_fsl_spi_match);
@@ -141,6 +154,21 @@ static void fsl_spi_qe_cpu_set_shifts(u32 *rx_shift, u32 *tx_shift,
 	}
 }
 
+static void fsl_spi_grlib_set_shifts(u32 *rx_shift, u32 *tx_shift,
+				     int bits_per_word, int msb_first)
+{
+	*rx_shift = 0;
+	*tx_shift = 0;
+	if (bits_per_word <= 16) {
+		if (msb_first) {
+			*rx_shift = 16; /* LSB in bit 16 */
+			*tx_shift = 32 - bits_per_word; /* MSB in bit 31 */
+		} else {
+			*rx_shift = 16 - bits_per_word; /* MSB in bit 15 */
+		}
+	}
+}
+
 static int mspi_apply_cpu_mode_quirks(struct spi_mpc8xxx_cs *cs,
 				struct spi_device *spi,
 				struct mpc8xxx_spi *mpc8xxx_spi,
@@ -494,6 +522,42 @@ static void fsl_spi_remove(struct mpc8xxx_spi *mspi)
 	fsl_spi_cpm_free(mspi);
 }
 
+static void fsl_spi_grlib_cs_control(struct spi_device *spi, bool on)
+{
+	struct mpc8xxx_spi *mpc8xxx_spi = spi_master_get_devdata(spi->master);
+	struct fsl_spi_reg *reg_base = mpc8xxx_spi->reg_base;
+	u32 slvsel;
+	u16 cs = spi->chip_select;
+
+	slvsel = mpc8xxx_spi_read_reg(&reg_base->slvsel);
+	slvsel = on ? (slvsel | (1 << cs)) : (slvsel & ~(1 << cs));
+	mpc8xxx_spi_write_reg(&reg_base->slvsel, slvsel);
+}
+
+static void fsl_spi_grlib_probe(struct device *dev)
+{
+	struct fsl_spi_platform_data *pdata = dev->platform_data;
+	struct spi_master *master = dev_get_drvdata(dev);
+	struct mpc8xxx_spi *mpc8xxx_spi = spi_master_get_devdata(master);
+	struct fsl_spi_reg *reg_base = mpc8xxx_spi->reg_base;
+	int mbits;
+	u32 capabilities;
+
+	capabilities = mpc8xxx_spi_read_reg(&reg_base->cap);
+
+	mpc8xxx_spi->set_shifts = fsl_spi_grlib_set_shifts;
+	mbits = SPCAP_MAXWLEN(capabilities);
+	if (mbits)
+		mpc8xxx_spi->max_bits_per_word = mbits + 1;
+
+	master->num_chipselect = 1; /* Allow for an always selected chip */
+	if (SPCAP_SSEN(capabilities)) {
+		master->num_chipselect = SPCAP_SSSZ(capabilities);
+		mpc8xxx_spi_write_reg(&reg_base->slvsel, 0xffffffff);
+	}
+	pdata->cs_control = fsl_spi_grlib_cs_control;
+}
+
 static struct spi_master * fsl_spi_probe(struct device *dev,
 		struct resource *mem, unsigned int irq)
 {
@@ -528,6 +592,15 @@ static struct spi_master * fsl_spi_probe(struct device *dev,
 	if (ret)
 		goto err_cpm_init;
 
+	mpc8xxx_spi->reg_base = ioremap(mem->start, resource_size(mem));
+	if (mpc8xxx_spi->reg_base == NULL) {
+		ret = -ENOMEM;
+		goto err_ioremap;
+	}
+
+	if (mpc8xxx_spi->type == TYPE_GRLIB)
+		fsl_spi_grlib_probe(dev);
+
 	if (mpc8xxx_spi->flags & SPI_QE_CPU_MODE)
 		mpc8xxx_spi->set_shifts = fsl_spi_qe_cpu_set_shifts;
 
@@ -536,12 +609,6 @@ static struct spi_master * fsl_spi_probe(struct device *dev,
 		mpc8xxx_spi->set_shifts(&mpc8xxx_spi->rx_shift,
 					&mpc8xxx_spi->tx_shift, 8, 1);
 
-	mpc8xxx_spi->reg_base = ioremap(mem->start, resource_size(mem));
-	if (mpc8xxx_spi->reg_base == NULL) {
-		ret = -ENOMEM;
-		goto err_ioremap;
-	}
-
 	/* Register for SPI Interrupt */
 	ret = request_irq(mpc8xxx_spi->irq, fsl_spi_irq,
 			  0, "fsl_spi", mpc8xxx_spi);
@@ -708,16 +775,19 @@ static int of_fsl_spi_probe(struct platform_device *ofdev)
 	struct device_node *np = ofdev->dev.of_node;
 	struct spi_master *master;
 	struct resource mem;
-	int irq;
+	int irq, type;
 	int ret = -ENOMEM;
 
 	ret = of_mpc8xxx_spi_probe(ofdev);
 	if (ret)
 		return ret;
 
-	ret = of_fsl_spi_get_chipselects(dev);
-	if (ret)
-		goto err;
+	type = fsl_spi_get_type(&ofdev->dev);
+	if (type == TYPE_FSL) {
+		ret = of_fsl_spi_get_chipselects(dev);
+		if (ret)
+			goto err;
+	}
 
 	ret = of_address_to_resource(np, 0, &mem);
 	if (ret)
@@ -738,18 +808,22 @@ static int of_fsl_spi_probe(struct platform_device *ofdev)
 	return 0;
 
 err:
-	of_fsl_spi_free_chipselects(dev);
+	if (type == TYPE_FSL)
+		of_fsl_spi_free_chipselects(dev);
 	return ret;
 }
 
 static int of_fsl_spi_remove(struct platform_device *ofdev)
 {
+	struct spi_master *master = dev_get_drvdata(&ofdev->dev);
+	struct mpc8xxx_spi *mpc8xxx_spi = spi_master_get_devdata(master);
 	int ret;
 
 	ret = mpc8xxx_spi_remove(&ofdev->dev);
 	if (ret)
 		return ret;
-	of_fsl_spi_free_chipselects(&ofdev->dev);
+	if (mpc8xxx_spi->type == TYPE_FSL)
+		of_fsl_spi_free_chipselects(&ofdev->dev);
 	return 0;
 }
 
diff --git a/drivers/spi/spi-fsl-spi.h b/drivers/spi/spi-fsl-spi.h
index 8bd73a4..9a6dae0 100644
--- a/drivers/spi/spi-fsl-spi.h
+++ b/drivers/spi/spi-fsl-spi.h
@@ -10,6 +10,10 @@
  * Copyright (c) 2009  MontaVista Software, Inc.
  * Author: Anton Vorontsov <avorontsov@ru.mvista.com>
  *
+ * GRLIB support:
+ * Copyright (c) 2012 Aeroflex Gaisler AB.
+ * Author: Andreas Larsson <andreas@gaisler.com>
+ *
  * This program is free software; you can redistribute  it and/or modify it
  * under  the terms of  the GNU General  Public License as published by the
  * Free Software Foundation;  either version 2 of the  License, or (at your
@@ -21,13 +25,15 @@
 
 /* SPI Controller registers */
 struct fsl_spi_reg {
-	u8 res1[0x20];
+	__be32 cap; /* TYPE_GRLIB specific */
+	u8 res1[0x1C];
 	__be32 mode;
 	__be32 event;
 	__be32 mask;
 	__be32 command;
 	__be32 transmit;
 	__be32 receive;
+	__be32 slvsel; /* TYPE_GRLIB specific */
 };
 
 /* SPI Controller mode register definitions */
@@ -43,6 +49,11 @@ struct fsl_spi_reg {
 #define	SPMODE_OP		(1 << 14)
 #define	SPMODE_CG(x)		((x) << 7)
 
+/* TYPE_GRLIB SPI Controller capability register definitions */
+#define SPCAP_SSEN(x)		(((x) >> 16) & 0x1)
+#define SPCAP_SSSZ(x)		(((x) >> 24) & 0xff)
+#define SPCAP_MAXWLEN(x)	(((x) >> 20) & 0xf)
+
 /*
  * Default for SPI Mode:
  *	SPI MODE 0 (inactive low, phase middle, MSB, 8-bit length, slow clk
-- 
1.7.0.4

