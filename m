Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883AbaH2QKe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 12:10:34 -0400
Received: from andre.telenet-ops.be ([195.130.132.53]:45634 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065AbaH2QKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 12:10:33 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH v2] spi/drivers: Restrict COMPILE_TEST by HAS_DMA where needed
Date: Fri, 29 Aug 2014 18:10:31 +0200
Message-Id: <1409328631-1420-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit dd1053a93fdc11d4 ("spi/drivers: Enable build of drivers with
COMPILE_TEST") allows compile-testing drivers on platforms they're not
meant for.

However, adding "|| COMPILE_TEST" bypasses all other implicit dependencies
assumed by the platform dependencies before, like HAS_DMA.

If NO_DMA=y:

drivers/built-in.o: In function `atmel_spi_dma_unmap_xfer':
drivers/spi/spi-atmel.c:915: undefined reference to `dma_unmap_single'
drivers/spi/spi-atmel.c:918: undefined reference to `dma_unmap_single'
drivers/built-in.o: In function `atmel_spi_next_xfer_data':
drivers/spi/spi-atmel.c:690: undefined reference to `dma_sync_single_for_cpu'
drivers/built-in.o: In function `atmel_spi_dma_map_xfer':
drivers/spi/spi-atmel.c:890: undefined reference to `dma_map_single'
drivers/spi/spi-atmel.c:893: undefined reference to `dma_mapping_error'
drivers/spi/spi-atmel.c:897: undefined reference to `dma_map_single'
drivers/spi/spi-atmel.c:900: undefined reference to `dma_mapping_error'
drivers/spi/spi-atmel.c:902: undefined reference to `dma_unmap_single'
drivers/built-in.o: In function `atmel_spi_probe':
drivers/spi/spi-atmel.c:1540: undefined reference to `dma_alloc_coherent'
drivers/spi/spi-atmel.c:1623: undefined reference to `dma_free_coherent'
drivers/built-in.o: In function `atmel_spi_remove':
drivers/spi/spi-atmel.c:1665: undefined reference to `dma_free_coherent'
drivers/built-in.o: In function `ep93xx_spi_dma_finish':
drivers/spi/spi-ep93xx.c:550: undefined reference to `dma_unmap_sg'
drivers/built-in.o: In function `ep93xx_spi_dma_prepare':
drivers/spi/spi-ep93xx.c:516: undefined reference to `dma_map_sg'
drivers/spi/spi-ep93xx.c:522: undefined reference to `dma_unmap_sg'
drivers/built-in.o: In function `omap2_mcspi_rx_dma':
drivers/spi/spi-omap2-mcspi.c:475: undefined reference to `dma_unmap_single'
drivers/built-in.o: In function `omap2_mcspi_txrx_dma':
drivers/spi/spi-omap2-mcspi.c:589: undefined reference to `dma_unmap_single'
drivers/built-in.o: In function `omap2_mcspi_transfer_one_message':
drivers/spi/spi-omap2-mcspi.c:1202: undefined reference to `dma_map_single'
drivers/spi/spi-omap2-mcspi.c:1204: undefined reference to `dma_mapping_error'
drivers/spi/spi-omap2-mcspi.c:1211: undefined reference to `dma_map_single'
drivers/spi/spi-omap2-mcspi.c:1213: undefined reference to `dma_mapping_error'
drivers/spi/spi-omap2-mcspi.c:1217: undefined reference to `dma_unmap_single'
drivers/built-in.o: In function `tegra_spi_deinit_dma_param':
drivers/spi/spi-tegra114.c:675: undefined reference to `dma_free_coherent'
drivers/built-in.o: In function `tegra_spi_copy_spi_rxbuf_to_client_rxbuf':
drivers/spi/spi-tegra114.c:415: undefined reference to `dma_sync_single_for_cpu'
drivers/spi/spi-tegra114.c:440: undefined reference to `dma_sync_single_for_cpu'
drivers/built-in.o: In function `tegra_spi_copy_client_txbuf_to_spi_txbuf':
drivers/spi/spi-tegra114.c:381: undefined reference to `dma_sync_single_for_cpu'
drivers/spi/spi-tegra114.c:405: undefined reference to `dma_sync_single_for_cpu'
drivers/built-in.o: In function `tegra_spi_start_dma_based_transfer':
drivers/spi/spi-tegra114.c:543: undefined reference to `dma_sync_single_for_cpu'
drivers/built-in.o: In function `tegra_slink_deinit_dma_param':
drivers/spi/spi-tegra20-slink.c:705: undefined reference to `dma_free_coherent'
drivers/built-in.o: In function `tegra_slink_copy_spi_rxbuf_to_client_rxbuf':
drivers/spi/spi-tegra20-slink.c:427: undefined reference to `dma_sync_single_for_cpu'
drivers/spi/spi-tegra20-slink.c:452: undefined reference to `dma_sync_single_for_cpu'
drivers/built-in.o: In function `tegra_slink_copy_client_txbuf_to_spi_txbuf':
drivers/spi/spi-tegra20-slink.c:393: undefined reference to `dma_sync_single_for_cpu'
drivers/spi/spi-tegra20-slink.c:417: undefined reference to `dma_sync_single_for_cpu'
drivers/built-in.o: In function `tegra_slink_start_dma_based_transfer':
drivers/spi/spi-tegra20-slink.c:561: undefined reference to `dma_sync_single_for_cpu'

Add dependencies on HAS_DMA to fix this.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
v2: Use sparate "depends on HAS_DMA" instead of "COMPILE_TEST && HAS_DMA"
---
 drivers/spi/Kconfig | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index bdd20c1707e5..1a5965539efd 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -69,6 +69,7 @@ config SPI_ATH79
 
 config SPI_ATMEL
 	tristate "Atmel SPI Controller"
+	depends on HAS_DMA
 	depends on (ARCH_AT91 || AVR32 || COMPILE_TEST)
 	help
 	  This selects a driver for the Atmel SPI Controller, present on
@@ -185,6 +186,7 @@ config SPI_EFM32
 
 config SPI_EP93XX
 	tristate "Cirrus Logic EP93xx SPI controller"
+	depends on HAS_DMA
 	depends on ARCH_EP93XX || COMPILE_TEST
 	help
 	  This enables using the Cirrus EP93xx SPI controller in master
@@ -320,6 +322,7 @@ config SPI_OMAP_UWIRE
 
 config SPI_OMAP24XX
 	tristate "McSPI driver for OMAP"
+	depends on HAS_DMA
 	depends on ARM || ARM64 || AVR32 || HEXAGON || MIPS || SUPERH
 	depends on ARCH_OMAP2PLUS || COMPILE_TEST
 	help
@@ -506,7 +509,7 @@ config SPI_MXS
 config SPI_TEGRA114
 	tristate "NVIDIA Tegra114 SPI Controller"
 	depends on (ARCH_TEGRA && TEGRA20_APB_DMA) || COMPILE_TEST
-	depends on RESET_CONTROLLER
+	depends on RESET_CONTROLLER && HAS_DMA
 	help
 	  SPI driver for NVIDIA Tegra114 SPI Controller interface. This controller
 	  is different than the older SoCs SPI controller and also register interface
@@ -524,7 +527,7 @@ config SPI_TEGRA20_SFLASH
 config SPI_TEGRA20_SLINK
 	tristate "Nvidia Tegra20/Tegra30 SLINK Controller"
 	depends on (ARCH_TEGRA && TEGRA20_APB_DMA) || COMPILE_TEST
-	depends on RESET_CONTROLLER
+	depends on RESET_CONTROLLER && HAS_DMA
 	help
 	  SPI driver for Nvidia Tegra20/Tegra30 SLINK Controller interface.
 
-- 
1.9.1

