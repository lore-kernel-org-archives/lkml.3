Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159AbaBYKbx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 05:31:53 -0500
Received: from albert.telenet-ops.be ([195.130.137.90]:44286 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235AbaBYKa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 05:30:29 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Cc: linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH v2 04/11] ARM: shmobile: koelsch legacy: Add MSIOF support
Date: Tue, 25 Feb 2014 11:30:12 +0100
Message-Id: <1393324219-3317-5-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1393324219-3317-1-git-send-email-geert@linux-m68k.org>
References: <1393324219-3317-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Add MSIOF resources, platform data, platform device, pinctrl, and SPI
child device.

  - Only MSIOF0 is in use, and thus registered. Its bus contains a single
    device (a Renesas R2A11302FT PMIC).
  - Platform device numbering is 1-based for compatibility with the BSP,
    as QSPI uses zero, so MSIOF0's device name is "spi_r8a7791_msiof.1".

Based on patches from Takashi Yoshii <takasi-y@ops.dti.ne.jp>

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
v2:
  - Removed resources for unused MSIOF channels.

 arch/arm/mach-shmobile/board-koelsch.c |   46 +++++++++++++++++++++++++++-----
 1 file changed, 40 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-shmobile/board-koelsch.c b/arch/arm/mach-shmobile/board-koelsch.c
index 5a034ff405d0..618b728cc180 100644
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
@@ -184,6 +185,17 @@ static const struct rspi_plat_data qspi_pdata __initconst = {
 	.num_chipselect = 1,
 };
 
+/* MSIOF0 */
+static const struct resource sh_msiof0_resources[] __initconst = {
+	DEFINE_RES_MEM(0xe6e20000, 0x0064),
+	DEFINE_RES_IRQ(gic_spi(156)),
+};
+
+static const struct sh_msiof_spi_info sh_msiof_info __initconst = {
+	.rx_fifo_override	= 256,
+	.num_chipselect		= 1,
+};
+
 /* SPI Flash memory (Spansion S25FL512SAGMFIG11 64 MiB) */
 static struct mtd_partition spi_flash_part[] = {
 	{
@@ -214,12 +226,19 @@ static const struct flash_platform_data spi_flash_data = {
 
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
 
@@ -384,6 +403,15 @@ static const struct pinctrl_map koelsch_pinctrl_map[] = {
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
@@ -449,6 +477,12 @@ static void __init koelsch_add_standard_devices(void)
 					  qspi_resources,
 					  ARRAY_SIZE(qspi_resources),
 					  &qspi_pdata, sizeof(qspi_pdata));
+	platform_device_register_resndata(&platform_bus, "spi_r8a7791_msiof",
+					  1 + 0, sh_msiof0_resources,
+					  ARRAY_SIZE(sh_msiof0_resources),
+					  &sh_msiof_info,
+					  sizeof(struct sh_msiof_spi_info));
+
 	spi_register_board_info(spi_info, ARRAY_SIZE(spi_info));
 
 	koelsch_add_du_device();
-- 
1.7.9.5

