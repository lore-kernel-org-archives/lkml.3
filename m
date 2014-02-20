Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168AbaBTOt4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 09:49:56 -0500
Received: from albert.telenet-ops.be ([195.130.137.90]:53976 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbaBTOtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 09:49:53 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Cc: linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH 05/11] ARM: shmobile: koelsch legacy: Add MSIOF support
Date: Thu, 20 Feb 2014 15:49:33 +0100
Message-Id: <1392907779-22053-6-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392907779-22053-1-git-send-email-geert@linux-m68k.org>
References: <1392907779-22053-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Add MSIOF resources, platform data, platform device, pinctrl, and SPI
child device.

  - Platform device numbering is 1-based for compatibility with the BSP,
    as QSPI uses zero.
  - Only MSIOF0 is in use, and thus registered. Its bus contains a single
    device (a Renesas R2A11302FT PMIC).

Based on patches from Takashi Yoshii <takasi-y@ops.dti.ne.jp>

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
 arch/arm/mach-shmobile/board-koelsch.c |   59 ++++++++++++++++++++++++++++----
 1 file changed, 53 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-shmobile/board-koelsch.c b/arch/arm/mach-shmobile/board-koelsch.c
index 5a034ff405d0..47bf588fc5ce 100644
--- a/arch/arm/mach-shmobile/board-koelsch.c
+++ b/arch/arm/mach-shmobile/board-koelsch.c
@@ -44,6 +44,7 @@
 #include <linux/sh_eth.h>
 #include <linux/spi/flash.h>
 #include <linux/spi/rspi.h>
+#include <linux/spi/sh_msiof.h>
 #include <linux/spi/spi.h>
 #include <mach/common.h>
 #include <mach/irqs.h>
@@ -184,6 +185,35 @@ static const struct rspi_plat_data qspi_pdata __initconst = {
 	.num_chipselect = 1,
 };
 
+/* MSIOF */
+static const struct resource sh_msiof0_resources[] __initconst = {
+	DEFINE_RES_MEM(0xe6e20000, 0x0064),
+	DEFINE_RES_IRQ(gic_spi(156)),
+};
+
+static const struct resource sh_msiof1_resources[] __initconst = {
+	DEFINE_RES_MEM(0xe6e10000, 0x0064),
+	DEFINE_RES_IRQ(gic_spi(157)),
+};
+
+static const struct resource sh_msiof2_resources[] __initconst = {
+	DEFINE_RES_MEM(0xe6e00000, 0x0064),
+	DEFINE_RES_IRQ(gic_spi(158)),
+};
+
+static const struct sh_msiof_spi_info sh_msiof_info __initconst = {
+	.rx_fifo_override	= 256,
+	.num_chipselect		= 1,
+};
+
+#define r8a7791_register_msiof(idx)					\
+	platform_device_register_resndata(&platform_bus,		\
+				"spi_r8a7791_msiof",			\
+				(idx+1), sh_msiof##idx##_resources,	\
+				ARRAY_SIZE(sh_msiof##idx##_resources),	\
+				&sh_msiof_info,				\
+				sizeof(struct sh_msiof_spi_info))
+
 /* SPI Flash memory (Spansion S25FL512SAGMFIG11 64 MiB) */
 static struct mtd_partition spi_flash_part[] = {
 	{
@@ -214,12 +244,19 @@ static const struct flash_platform_data spi_flash_data = {
 
 static const struct spi_board_info spi_info[] __initconst = {
 	{
-		.modalias	= "m25p80",
-		.platform_data	= &spi_flash_data,
-		.mode		= SPI_MODE_0,
-		.max_speed_hz	= 30000000,
-		.bus_num	= 0,
-		.chip_select	= 0,
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
+		.bus_num	 = 1,
+		.mode		 = SPI_MODE_3,
+		.controller_data = (void *)-ENOENT, /* HW controlled CS */
 	},
 };
 
@@ -384,6 +421,15 @@ static const struct pinctrl_map koelsch_pinctrl_map[] = {
 				  "eth_rmii", "eth"),
 	PIN_MAP_MUX_GROUP_DEFAULT("r8a7791-ether", "pfc-r8a7791",
 				  "intc_irq0", "intc"),
+	/* MSIOF0 */
+	PIN_MAP_MUX_GROUP_DEFAULT("spi_r8a7791_msiof.1", "pfc-r8a7791",
+				  "msiof0_clk", "msiof0"),
+	PIN_MAP_MUX_GROUP_DEFAULT("spi_r8a7791_msiof.1", "pfc-r8a7791",
+				  "msiof0_sync", "msiof0"),
+	PIN_MAP_MUX_GROUP_DEFAULT("spi_r8a7791_msiof.1", "pfc-r8a7791",
+				  "msiof0_rx", "msiof0"),
+	PIN_MAP_MUX_GROUP_DEFAULT("spi_r8a7791_msiof.1", "pfc-r8a7791",
+				  "msiof0_tx", "msiof0"),
 	/* QSPI */
 	PIN_MAP_MUX_GROUP_DEFAULT("qspi.0", "pfc-r8a7791",
 				  "qspi_ctrl", "qspi"),
@@ -449,6 +495,7 @@ static void __init koelsch_add_standard_devices(void)
 					  qspi_resources,
 					  ARRAY_SIZE(qspi_resources),
 					  &qspi_pdata, sizeof(qspi_pdata));
+	r8a7791_register_msiof(0);
 	spi_register_board_info(spi_info, ARRAY_SIZE(spi_info));
 
 	koelsch_add_du_device();
-- 
1.7.9.5

