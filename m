Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427AbaBDP2E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 10:28:04 -0500
Received: from michel.telenet-ops.be ([195.130.137.88]:38895 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832AbaBDPYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 10:24:14 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Cc: linux-spi@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH v5 02/11] ARM: shmobile: genmai legacy: Add RSPI support
Date: Tue,  4 Feb 2014 16:23:56 +0100
Message-Id: <1391527445-14881-3-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391527445-14881-1-git-send-email-geert@linux-m68k.org>
References: <1391527445-14881-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Add RSPI platform device, resources, platform data, and SPI child.

On this board, only rspi4 is in use. Its bus contains a single device
(a wm8978 audio codec).

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
v5:
  - Rebased on top of renesas-devel-v3.14-rc1-20140204
v4:
  - The platform device basename was changed from "rspi" to "rspi-rz",
    dropping the platform data flags in the process
  - Switch to named IRQs
v3:
  - Move platform devices from setup-r7s72100.c to board-genmai.c, as
    genmai-reference will use devices instantiated from DT
  - Merge with "ARM: shmobile: genmai: Add RSPI children", as this now
    touches the same file
  - Instantiate SPI children in C on genmai only, as genmai-reference will
    instantiate them from DT
v2:
  - Correct platform device names ("rspi%u.0" -> "rspi.%u")
  - Add missing platform data
  - Correct summary (resources -> platform devices)

 arch/arm/mach-shmobile/board-genmai.c |   44 +++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/arch/arm/mach-shmobile/board-genmai.c b/arch/arm/mach-shmobile/board-genmai.c
index 3e92e3c62d4c..c4064610e223 100644
--- a/arch/arm/mach-shmobile/board-genmai.c
+++ b/arch/arm/mach-shmobile/board-genmai.c
@@ -20,15 +20,59 @@
 
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
+#include <linux/spi/rspi.h>
+#include <linux/spi/spi.h>
 #include <mach/common.h>
+#include <mach/irqs.h>
 #include <mach/r7s72100.h>
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 
+/* RSPI */
+#define RSPI_RESOURCE(idx, baseaddr, irq)				\
+static const struct resource rspi##idx##_resources[] __initconst = {	\
+	DEFINE_RES_MEM(baseaddr, 0x24),					\
+	DEFINE_RES_IRQ_NAMED(irq, "error"),				\
+	DEFINE_RES_IRQ_NAMED(irq + 1, "rx"),				\
+	DEFINE_RES_IRQ_NAMED(irq + 2, "tx"),				\
+}
+
+RSPI_RESOURCE(0, 0xe800c800, gic_iid(270));
+RSPI_RESOURCE(1, 0xe800d000, gic_iid(273));
+RSPI_RESOURCE(2, 0xe800d800, gic_iid(276));
+RSPI_RESOURCE(3, 0xe800e000, gic_iid(279));
+RSPI_RESOURCE(4, 0xe800e800, gic_iid(282));
+
+static const struct rspi_plat_data rspi_pdata __initconst = {
+	.num_chipselect	= 1,
+};
+
+#define r7s72100_register_rspi(idx)					   \
+	platform_device_register_resndata(&platform_bus, "rspi-rz", idx,   \
+					rspi##idx##_resources,		   \
+					ARRAY_SIZE(rspi##idx##_resources), \
+					&rspi_pdata, sizeof(rspi_pdata))
+
+static const struct spi_board_info spi_info[] __initconst = {
+	{
+		.modalias               = "wm8978",
+		.max_speed_hz           = 5000000,
+		.bus_num                = 4,
+		.chip_select            = 0,
+	},
+};
+
 static void __init genmai_add_standard_devices(void)
 {
 	r7s72100_clock_init();
 	r7s72100_add_dt_devices();
+
+	r7s72100_register_rspi(0);
+	r7s72100_register_rspi(1);
+	r7s72100_register_rspi(2);
+	r7s72100_register_rspi(3);
+	r7s72100_register_rspi(4);
+	spi_register_board_info(spi_info, ARRAY_SIZE(spi_info));
 }
 
 static const char * const genmai_boards_compat_dt[] __initconst = {
-- 
1.7.9.5

