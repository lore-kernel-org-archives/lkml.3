Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759319AbbA0SIK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 13:08:10 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:10623 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759273AbbA0SIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 13:08:07 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>, Arnd Bergmann <arnd@arndb.de>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 3/7] ARM: at91: move alternative initial mapping to board-dt-sama5.c
Date: Tue, 27 Jan 2015 19:07:22 +0100
Message-ID: <bcb42758c3937810176853e784eb963cb54bbca6.1422381280.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <cover.1422381280.git.nicolas.ferre@atmel.com>
References: <cover.1422381280.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For sama5d4, remove an indirection and the remaining need for at91_boot_soc
structure.
This will allow further cleanup.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/board-dt-sama5.c | 37 ++++++++++++++++++++++++++++++++++++-
 arch/arm/mach-at91/sama5d4.c        | 33 ---------------------------------
 arch/arm/mach-at91/setup.c          |  6 ------
 3 files changed, 36 insertions(+), 40 deletions(-)

diff --git a/arch/arm/mach-at91/board-dt-sama5.c b/arch/arm/mach-at91/board-dt-sama5.c
index 86cffcdef145..7806f58c7e4d 100644
--- a/arch/arm/mach-at91/board-dt-sama5.c
+++ b/arch/arm/mach-at91/board-dt-sama5.c
@@ -18,6 +18,8 @@
 #include <linux/phy.h>
 #include <linux/clk-provider.h>
 
+#include <mach/hardware.h>
+
 #include <asm/setup.h>
 #include <asm/irq.h>
 #include <asm/mach/arch.h>
@@ -45,6 +47,39 @@ DT_MACHINE_START(sama5_dt, "Atmel SAMA5 (Device Tree)")
 	.dt_compat	= sama5_dt_board_compat,
 MACHINE_END
 
+static struct map_desc at91_io_desc[] __initdata = {
+	{
+	.virtual        = (unsigned long)AT91_ALT_IO_P2V(SAMA5D4_BASE_MPDDRC),
+	.pfn            = __phys_to_pfn(SAMA5D4_BASE_MPDDRC),
+	.length         = SZ_512,
+	.type           = MT_DEVICE,
+	},
+	{
+	.virtual        = (unsigned long)AT91_ALT_IO_P2V(SAMA5D4_BASE_PMC),
+	.pfn            = __phys_to_pfn(SAMA5D4_BASE_PMC),
+	.length         = SZ_512,
+	.type           = MT_DEVICE,
+	},
+	{ /* On sama5d4, we use USART3 as serial console */
+	.virtual        = (unsigned long)AT91_ALT_IO_P2V(SAMA5D4_BASE_USART3),
+	.pfn            = __phys_to_pfn(SAMA5D4_BASE_USART3),
+	.length         = SZ_256,
+	.type           = MT_DEVICE,
+	},
+	{ /* A bunch of peripheral with fine grained IO space */
+	.virtual        = (unsigned long)AT91_ALT_IO_P2V(SAMA5D4_BASE_SYS2),
+	.pfn            = __phys_to_pfn(SAMA5D4_BASE_SYS2),
+	.length         = SZ_2K,
+	.type           = MT_DEVICE,
+	},
+};
+
+static void __init sama5_alt_map_io(void)
+{
+	at91_alt_map_io();
+	iotable_init(at91_io_desc, ARRAY_SIZE(at91_io_desc));
+}
+
 static const char *sama5_alt_dt_board_compat[] __initconst = {
 	"atmel,sama5d4",
 	NULL
@@ -52,7 +87,7 @@ static const char *sama5_alt_dt_board_compat[] __initconst = {
 
 DT_MACHINE_START(sama5_alt_dt, "Atmel SAMA5 (Device Tree)")
 	/* Maintainer: Atmel */
-	.map_io		= at91_alt_map_io,
+	.map_io		= sama5_alt_map_io,
 	.init_early	= at91_dt_initialize,
 	.init_machine	= sama5_dt_device_init,
 	.dt_compat	= sama5_alt_dt_board_compat,
diff --git a/arch/arm/mach-at91/sama5d4.c b/arch/arm/mach-at91/sama5d4.c
index fa127fb79221..268f2d238f80 100644
--- a/arch/arm/mach-at91/sama5d4.c
+++ b/arch/arm/mach-at91/sama5d4.c
@@ -25,39 +25,6 @@
 /* --------------------------------------------------------------------
  *  Processor initialization
  * -------------------------------------------------------------------- */
-static struct map_desc at91_io_desc[] __initdata = {
-	{
-	.virtual        = (unsigned long)AT91_ALT_IO_P2V(SAMA5D4_BASE_MPDDRC),
-	.pfn            = __phys_to_pfn(SAMA5D4_BASE_MPDDRC),
-	.length         = SZ_512,
-	.type           = MT_DEVICE,
-	},
-	{
-	.virtual        = (unsigned long)AT91_ALT_IO_P2V(SAMA5D4_BASE_PMC),
-	.pfn            = __phys_to_pfn(SAMA5D4_BASE_PMC),
-	.length         = SZ_512,
-	.type           = MT_DEVICE,
-	},
-	{ /* On sama5d4, we use USART3 as serial console */
-	.virtual        = (unsigned long)AT91_ALT_IO_P2V(SAMA5D4_BASE_USART3),
-	.pfn            = __phys_to_pfn(SAMA5D4_BASE_USART3),
-	.length         = SZ_256,
-	.type           = MT_DEVICE,
-	},
-	{ /* A bunch of peripheral with fine grained IO space */
-	.virtual        = (unsigned long)AT91_ALT_IO_P2V(SAMA5D4_BASE_SYS2),
-	.pfn            = __phys_to_pfn(SAMA5D4_BASE_SYS2),
-	.length         = SZ_2K,
-	.type           = MT_DEVICE,
-	},
-};
-
-
-static void __init sama5d4_map_io(void)
-{
-	iotable_init(at91_io_desc, ARRAY_SIZE(at91_io_desc));
-}
 
 AT91_SOC_START(sama5d4)
-	.map_io = sama5d4_map_io,
 AT91_SOC_END
diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
index 41abd1708496..af6086b69bb1 100644
--- a/arch/arm/mach-at91/setup.c
+++ b/arch/arm/mach-at91/setup.c
@@ -327,12 +327,6 @@ void __init at91_alt_map_io(void)
 	if (at91_soc_initdata.subtype != AT91_SOC_SUBTYPE_NONE)
 		pr_info("AT91: Detected soc subtype: %s\n",
 			at91_get_soc_subtype(&at91_soc_initdata));
-
-	if (!at91_soc_is_enabled())
-		panic("AT91: Soc not enabled");
-
-	if (at91_boot_soc.map_io)
-		at91_boot_soc.map_io();
 }
 
 void __iomem *at91_matrix_base;
-- 
2.1.3

