Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799AbbAFKDT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 05:03:19 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:52648 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775AbbAFKDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 05:03:15 -0500
From: esben.haabendal@gmail.com
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Esben Haabendal <eha@deif.com>
Subject: [PATCH] spi: fsl-(e)spi: Support compile as module
Date: Tue,  6 Jan 2015 11:03:06 +0100
Message-Id: <1420538586-15867-1-git-send-email-esben.haabendal@gmail.com>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Esben Haabendal <eha@deif.com>

Signed-off-by: Esben Haabendal <eha@deif.com>
---
 drivers/spi/Kconfig       |  4 ++--
 drivers/spi/spi-fsl-cpm.c |  9 +++++++++
 drivers/spi/spi-fsl-lib.c | 14 ++++++++++++--
 drivers/spi/spi-fsl-lib.h |  4 ++--
 4 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index 9982998..468d13c 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -279,7 +279,7 @@ config SPI_FSL_CPM
 	depends on FSL_SOC
 
 config SPI_FSL_SPI
-	bool "Freescale SPI controller and Aeroflex Gaisler GRLIB SPI controller"
+	tristate "Freescale SPI controller and Aeroflex Gaisler GRLIB SPI controller"
 	depends on OF
 	select SPI_FSL_LIB
 	select SPI_FSL_CPM if FSL_SOC
@@ -300,7 +300,7 @@ config SPI_FSL_DSPI
 	  mode. VF610 platform uses the controller.
 
 config SPI_FSL_ESPI
-	bool "Freescale eSPI controller"
+	tristate "Freescale eSPI controller"
 	depends on FSL_SOC
 	select SPI_FSL_LIB
 	help
diff --git a/drivers/spi/spi-fsl-cpm.c b/drivers/spi/spi-fsl-cpm.c
index e85ab1c..9c46a30 100644
--- a/drivers/spi/spi-fsl-cpm.c
+++ b/drivers/spi/spi-fsl-cpm.c
@@ -20,6 +20,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/fsl_devices.h>
 #include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/of_address.h>
 #include <linux/spi/spi.h>
 #include <linux/types.h>
@@ -68,6 +69,7 @@ void fsl_spi_cpm_reinit_txrx(struct mpc8xxx_spi *mspi)
 		}
 	}
 }
+EXPORT_SYMBOL_GPL(fsl_spi_cpm_reinit_txrx);
 
 static void fsl_spi_cpm_bufs_start(struct mpc8xxx_spi *mspi)
 {
@@ -162,6 +164,7 @@ err_rx_dma:
 		dma_unmap_single(dev, mspi->tx_dma, t->len, DMA_TO_DEVICE);
 	return -ENOMEM;
 }
+EXPORT_SYMBOL_GPL(fsl_spi_cpm_bufs);
 
 void fsl_spi_cpm_bufs_complete(struct mpc8xxx_spi *mspi)
 {
@@ -174,6 +177,7 @@ void fsl_spi_cpm_bufs_complete(struct mpc8xxx_spi *mspi)
 		dma_unmap_single(dev, mspi->rx_dma, t->len, DMA_FROM_DEVICE);
 	mspi->xfer_in_progress = NULL;
 }
+EXPORT_SYMBOL_GPL(fsl_spi_cpm_bufs_complete);
 
 void fsl_spi_cpm_irq(struct mpc8xxx_spi *mspi, u32 events)
 {
@@ -198,6 +202,7 @@ void fsl_spi_cpm_irq(struct mpc8xxx_spi *mspi, u32 events)
 	else
 		complete(&mspi->done);
 }
+EXPORT_SYMBOL_GPL(fsl_spi_cpm_irq);
 
 static void *fsl_spi_alloc_dummy_rx(void)
 {
@@ -375,6 +380,7 @@ err_pram:
 	fsl_spi_free_dummy_rx();
 	return -ENOMEM;
 }
+EXPORT_SYMBOL_GPL(fsl_spi_cpm_init);
 
 void fsl_spi_cpm_free(struct mpc8xxx_spi *mspi)
 {
@@ -389,3 +395,6 @@ void fsl_spi_cpm_free(struct mpc8xxx_spi *mspi)
 	cpm_muram_free(cpm_muram_offset(mspi->pram));
 	fsl_spi_free_dummy_rx();
 }
+EXPORT_SYMBOL_GPL(fsl_spi_cpm_free);
+
+MODULE_LICENSE("GPL");
diff --git a/drivers/spi/spi-fsl-lib.c b/drivers/spi/spi-fsl-lib.c
index 9d3f9e0..cb35d2f 100644
--- a/drivers/spi/spi-fsl-lib.c
+++ b/drivers/spi/spi-fsl-lib.c
@@ -21,6 +21,7 @@
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
+#include <linux/module.h>
 #include <linux/of_platform.h>
 #include <linux/spi/spi.h>
 #ifdef CONFIG_FSL_SOC
@@ -35,7 +36,8 @@ void mpc8xxx_spi_rx_buf_##type(u32 data, struct mpc8xxx_spi *mpc8xxx_spi) \
 	type *rx = mpc8xxx_spi->rx;					  \
 	*rx++ = (type)(data >> mpc8xxx_spi->rx_shift);			  \
 	mpc8xxx_spi->rx = rx;						  \
-}
+}									  \
+EXPORT_SYMBOL_GPL(mpc8xxx_spi_rx_buf_##type);
 
 #define MPC8XXX_SPI_TX_BUF(type)				\
 u32 mpc8xxx_spi_tx_buf_##type(struct mpc8xxx_spi *mpc8xxx_spi)	\
@@ -47,7 +49,8 @@ u32 mpc8xxx_spi_tx_buf_##type(struct mpc8xxx_spi *mpc8xxx_spi)	\
 	data = *tx++ << mpc8xxx_spi->tx_shift;			\
 	mpc8xxx_spi->tx = tx;					\
 	return data;						\
-}
+}								\
+EXPORT_SYMBOL_GPL(mpc8xxx_spi_tx_buf_##type);
 
 MPC8XXX_SPI_RX_BUF(u8)
 MPC8XXX_SPI_RX_BUF(u16)
@@ -60,6 +63,7 @@ struct mpc8xxx_spi_probe_info *to_of_pinfo(struct fsl_spi_platform_data *pdata)
 {
 	return container_of(pdata, struct mpc8xxx_spi_probe_info, pdata);
 }
+EXPORT_SYMBOL_GPL(to_of_pinfo);
 
 const char *mpc8xxx_spi_strmode(unsigned int flags)
 {
@@ -75,6 +79,7 @@ const char *mpc8xxx_spi_strmode(unsigned int flags)
 	}
 	return "CPU";
 }
+EXPORT_SYMBOL_GPL(mpc8xxx_spi_strmode);
 
 void mpc8xxx_spi_probe(struct device *dev, struct resource *mem,
 			unsigned int irq)
@@ -107,6 +112,7 @@ void mpc8xxx_spi_probe(struct device *dev, struct resource *mem,
 
 	init_completion(&mpc8xxx_spi->done);
 }
+EXPORT_SYMBOL_GPL(mpc8xxx_spi_probe);
 
 int mpc8xxx_spi_remove(struct device *dev)
 {
@@ -125,6 +131,7 @@ int mpc8xxx_spi_remove(struct device *dev)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(mpc8xxx_spi_remove);
 
 int of_mpc8xxx_spi_probe(struct platform_device *ofdev)
 {
@@ -171,3 +178,6 @@ int of_mpc8xxx_spi_probe(struct platform_device *ofdev)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(of_mpc8xxx_spi_probe);
+
+MODULE_LICENSE("GPL");
diff --git a/drivers/spi/spi-fsl-lib.h b/drivers/spi/spi-fsl-lib.h
index b4ed04e..94698e1 100644
--- a/drivers/spi/spi-fsl-lib.h
+++ b/drivers/spi/spi-fsl-lib.h
@@ -28,7 +28,7 @@ struct mpc8xxx_spi {
 	/* rx & tx bufs from the spi_transfer */
 	const void *tx;
 	void *rx;
-#ifdef CONFIG_SPI_FSL_ESPI
+#if defined(CONFIG_SPI_FSL_ESPI) || defined(CONFIG_SPI_FSL_ESPI_MODULE)
 	int len;
 #endif
 
@@ -68,7 +68,7 @@ struct mpc8xxx_spi {
 
 	unsigned int flags;
 
-#ifdef CONFIG_SPI_FSL_SPI
+#if defined(CONFIG_SPI_FSL_SPI) || defined(CONFIG_SPI_FSL_SPI_MODULE)
 	int type;
 	int native_chipselects;
 	u8 max_bits_per_word;
-- 
2.1.4

