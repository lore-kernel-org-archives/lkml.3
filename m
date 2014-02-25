Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbaBYKah (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 05:30:37 -0500
Received: from michel.telenet-ops.be ([195.130.137.88]:59404 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbaBYKa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 05:30:26 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Cc: linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH v2 03/11] ARM: shmobile: lager legacy: Add MSIOF support
Date: Tue, 25 Feb 2014 11:30:11 +0100
Message-Id: <1393324219-3317-4-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1393324219-3317-1-git-send-email-geert@linux-m68k.org>
References: <1393324219-3317-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Add MSIOF resources, platform data, platform device, pinctrl, and SPI
child device.

  - Only MSIOF1 is in use, and thus registered. Its bus contains a single
    device (a Renesas R2A11302FT PMIC).
  - Platform device numbering is 1-based for compatibility with the BSP,
    as QSPI uses zero, so MSIOF1's device name is "spi_r8a7790_msiof.2".

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
v2:
  - Removed resources for unused MSIOF channels.

 arch/arm/mach-shmobile/board-lager.c |   46 +++++++++++++++++++++++++++++-----
 1 file changed, 40 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-shmobile/board-lager.c b/arch/arm/mach-shmobile/board-lager.c
index f0104bfe544e..9d2d3b03af99 100644
--- a/arch/arm/mach-shmobile/board-lager.c
+++ b/arch/arm/mach-shmobile/board-lager.c
@@ -55,6 +55,7 @@
 #include <linux/mtd/mtd.h>
 #include <linux/spi/flash.h>
 #include <linux/spi/rspi.h>
+#include <linux/spi/sh_msiof.h>
 #include <linux/spi/spi.h>
 #include <sound/rcar_snd.h>
 #include <sound/simple_card.h>
@@ -287,6 +288,17 @@ static const struct platform_device_info ether_info __initconst = {
 	.dma_mask	= DMA_BIT_MASK(32),
 };
 
+/* MSIOF1 */
+static const struct resource sh_msiof1_resources[] __initconst = {
+	DEFINE_RES_MEM(0xe6e10000, 0x0064),
+	DEFINE_RES_IRQ(gic_spi(157)),
+};
+
+static const struct sh_msiof_spi_info sh_msiof_info __initconst = {
+	.rx_fifo_override	= 256,
+	.num_chipselect		= 1,
+};
+
 /* SPI Flash memory (Spansion S25FL512SAGMFIG11 64Mb) */
 static struct mtd_partition spi_flash_part[] = {
 	/* Reserved for user loader program, read-only */
@@ -325,12 +337,19 @@ static const struct rspi_plat_data qspi_pdata __initconst = {
 
 static const struct spi_board_info spi_info[] __initconst = {
 	{
-		.modalias               = "m25p80",
-		.platform_data          = &spi_flash_data,
-		.mode                   = SPI_MODE_0,
-		.max_speed_hz           = 30000000,
-		.bus_num                = 0,
-		.chip_select            = 0,
+		.modalias	 = "m25p80",
+		.platform_data	 = &spi_flash_data,
+		.mode		 = SPI_MODE_0,
+		.max_speed_hz	 = 30000000,
+		.bus_num	 = 0,
+		.chip_select	 = 0,
+	}, {
+		.modalias	 = "r2a1130x",
+		.max_speed_hz	 = 6000000,
+		.chip_select	 = 0,
+		.bus_num	 = 2,
+		.mode		 = SPI_MODE_3,
+		.controller_data = (void *)-ENOENT, /* HW controlled CS */
 	},
 };
 
@@ -703,6 +722,15 @@ static const struct pinctrl_map lager_pinctrl_map[] = {
 	/* I2C2 */
 	PIN_MAP_MUX_GROUP_DEFAULT("i2c-rcar.2", "pfc-r8a7790",
 				  "i2c2", "i2c2"),
+	/* MSIOF1 */
+	PIN_MAP_MUX_GROUP_DEFAULT("spi_r8a7790_msiof.2", "pfc-r8a7790",
+				  "msiof1_clk", "msiof1"),
+	PIN_MAP_MUX_GROUP_DEFAULT("spi_r8a7790_msiof.2", "pfc-r8a7790",
+				  "msiof1_sync", "msiof1"),
+	PIN_MAP_MUX_GROUP_DEFAULT("spi_r8a7790_msiof.2", "pfc-r8a7790",
+				  "msiof1_rx", "msiof1"),
+	PIN_MAP_MUX_GROUP_DEFAULT("spi_r8a7790_msiof.2", "pfc-r8a7790",
+				  "msiof1_tx", "msiof1"),
 	/* QSPI */
 	PIN_MAP_MUX_GROUP_DEFAULT("qspi.0", "pfc-r8a7790",
 				  "qspi_ctrl", "qspi"),
@@ -811,6 +839,12 @@ static void __init lager_add_standard_devices(void)
 					  qspi_resources,
 					  ARRAY_SIZE(qspi_resources),
 					  &qspi_pdata, sizeof(qspi_pdata));
+	platform_device_register_resndata(&platform_bus, "spi_r8a7790_msiof",
+					  1 + 1, sh_msiof1_resources,
+					  ARRAY_SIZE(sh_msiof1_resources),
+					  &sh_msiof_info,
+					  sizeof(struct sh_msiof_spi_info));
+
 	spi_register_board_info(spi_info, ARRAY_SIZE(spi_info));
 
 	platform_device_register_data(&platform_bus, "reg-fixed-voltage", fixed_regulator_idx++,
-- 
1.7.9.5

