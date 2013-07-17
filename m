Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665Ab3GQOlP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 10:41:15 -0400
Received: from 5.mo1.mail-out.ovh.net ([178.33.45.107]:37098 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755361Ab3GQOlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 10:41:13 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Mike Turquette <mturquette@linaro.org>,
        Andrew Victor <linux@maxim.org.za>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: [PATCH v2 13/42] ARM: at91: move at91rm9200 SoC to new at91 clk implem
Date: Wed, 17 Jul 2013 16:41:04 +0200
Message-Id: <1374072064-19461-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374068069-13496-1-git-send-email-b.brezillon@overkiz.com>
References: <1374068069-13496-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 12459208370599065708
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrvdegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrvdegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes all references to the old at91 clks implementation and
make use of the new at91 clk implem for at91rm9200 SoC.

All dt specific lookups are removed (handled in clk device tree binding).

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 arch/arm/mach-at91/Kconfig      |    1 +
 arch/arm/mach-at91/at91rm9200.c |  566 +++++++++++++++++++++++----------------
 2 files changed, 341 insertions(+), 226 deletions(-)

diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index c8e02ca..3253373 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -85,6 +85,7 @@ endif
 if SOC_SAM_V4_V5
 config SOC_AT91RM9200
 	bool "AT91RM9200"
+	select COMMON_CLK
 	select CPU_ARM920T
 	select GENERIC_CLOCKEVENTS
 	select HAVE_AT91_DBGU0
diff --git a/arch/arm/mach-at91/at91rm9200.c b/arch/arm/mach-at91/at91rm9200.c
index 8de5b02..3454c8b 100644
--- a/arch/arm/mach-at91/at91rm9200.c
+++ b/arch/arm/mach-at91/at91rm9200.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/reboot.h>
 #include <linux/clk/at91.h>
+#include <linux/clkdev.h>
 
 #include <asm/irq.h>
 #include <asm/mach/arch.h>
@@ -25,7 +26,6 @@
 #include "at91_aic.h"
 #include "soc.h"
 #include "generic.h"
-#include "clock.h"
 #include "sam9_smc.h"
 
 /* --------------------------------------------------------------------
@@ -35,245 +35,359 @@
 /*
  * The peripheral clocks.
  */
-static struct clk udc_clk = {
-	.name		= "udc_clk",
-	.pmc_mask	= 1 << AT91RM9200_ID_UDP,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk ohci_clk = {
-	.name		= "ohci_clk",
-	.pmc_mask	= 1 << AT91RM9200_ID_UHP,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk ether_clk = {
-	.name		= "ether_clk",
-	.pmc_mask	= 1 << AT91RM9200_ID_EMAC,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk mmc_clk = {
-	.name		= "mci_clk",
-	.pmc_mask	= 1 << AT91RM9200_ID_MCI,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk twi_clk = {
-	.name		= "twi_clk",
-	.pmc_mask	= 1 << AT91RM9200_ID_TWI,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk usart0_clk = {
-	.name		= "usart0_clk",
-	.pmc_mask	= 1 << AT91RM9200_ID_US0,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk usart1_clk = {
-	.name		= "usart1_clk",
-	.pmc_mask	= 1 << AT91RM9200_ID_US1,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk usart2_clk = {
-	.name		= "usart2_clk",
-	.pmc_mask	= 1 << AT91RM9200_ID_US2,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk usart3_clk = {
-	.name		= "usart3_clk",
-	.pmc_mask	= 1 << AT91RM9200_ID_US3,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk spi_clk = {
-	.name		= "spi_clk",
-	.pmc_mask	= 1 << AT91RM9200_ID_SPI,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk pioA_clk = {
-	.name		= "pioA_clk",
-	.pmc_mask	= 1 << AT91RM9200_ID_PIOA,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk pioB_clk = {
-	.name		= "pioB_clk",
-	.pmc_mask	= 1 << AT91RM9200_ID_PIOB,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk pioC_clk = {
-	.name		= "pioC_clk",
-	.pmc_mask	= 1 << AT91RM9200_ID_PIOC,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk pioD_clk = {
-	.name		= "pioD_clk",
-	.pmc_mask	= 1 << AT91RM9200_ID_PIOD,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk ssc0_clk = {
-	.name		= "ssc0_clk",
-	.pmc_mask	= 1 << AT91RM9200_ID_SSC0,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk ssc1_clk = {
-	.name		= "ssc1_clk",
-	.pmc_mask	= 1 << AT91RM9200_ID_SSC1,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk ssc2_clk = {
-	.name		= "ssc2_clk",
-	.pmc_mask	= 1 << AT91RM9200_ID_SSC2,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk tc0_clk = {
-	.name		= "tc0_clk",
-	.pmc_mask	= 1 << AT91RM9200_ID_TC0,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk tc1_clk = {
-	.name		= "tc1_clk",
-	.pmc_mask	= 1 << AT91RM9200_ID_TC1,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk tc2_clk = {
-	.name		= "tc2_clk",
-	.pmc_mask	= 1 << AT91RM9200_ID_TC2,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk tc3_clk = {
-	.name		= "tc3_clk",
-	.pmc_mask	= 1 << AT91RM9200_ID_TC3,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk tc4_clk = {
-	.name		= "tc4_clk",
-	.pmc_mask	= 1 << AT91RM9200_ID_TC4,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk tc5_clk = {
-	.name		= "tc5_clk",
-	.pmc_mask	= 1 << AT91RM9200_ID_TC5,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-
-static struct clk *periph_clocks[] __initdata = {
-	&pioA_clk,
-	&pioB_clk,
-	&pioC_clk,
-	&pioD_clk,
-	&usart0_clk,
-	&usart1_clk,
-	&usart2_clk,
-	&usart3_clk,
-	&mmc_clk,
-	&udc_clk,
-	&twi_clk,
-	&spi_clk,
-	&ssc0_clk,
-	&ssc1_clk,
-	&ssc2_clk,
-	&tc0_clk,
-	&tc1_clk,
-	&tc2_clk,
-	&tc3_clk,
-	&tc4_clk,
-	&tc5_clk,
-	&ohci_clk,
-	&ether_clk,
-	// irq0 .. irq6
-};
-
-static struct clk_lookup periph_clocks_lookups[] = {
-	CLKDEV_CON_DEV_ID("t0_clk", "atmel_tcb.0", &tc0_clk),
-	CLKDEV_CON_DEV_ID("t1_clk", "atmel_tcb.0", &tc1_clk),
-	CLKDEV_CON_DEV_ID("t2_clk", "atmel_tcb.0", &tc2_clk),
-	CLKDEV_CON_DEV_ID("t0_clk", "atmel_tcb.1", &tc3_clk),
-	CLKDEV_CON_DEV_ID("t1_clk", "atmel_tcb.1", &tc4_clk),
-	CLKDEV_CON_DEV_ID("t2_clk", "atmel_tcb.1", &tc5_clk),
-	CLKDEV_CON_DEV_ID("pclk", "at91rm9200_ssc.0", &ssc0_clk),
-	CLKDEV_CON_DEV_ID("pclk", "at91rm9200_ssc.1", &ssc1_clk),
-	CLKDEV_CON_DEV_ID("pclk", "at91rm9200_ssc.2", &ssc2_clk),
-	CLKDEV_CON_DEV_ID("pclk", "fffd0000.ssc", &ssc0_clk),
-	CLKDEV_CON_DEV_ID("pclk", "fffd4000.ssc", &ssc1_clk),
-	CLKDEV_CON_DEV_ID("pclk", "fffd8000.ssc", &ssc2_clk),
-	CLKDEV_CON_DEV_ID(NULL, "i2c-at91rm9200.0", &twi_clk),
-	/* fake hclk clock */
-	CLKDEV_CON_DEV_ID("hclk", "at91_ohci", &ohci_clk),
-	CLKDEV_CON_ID("pioA", &pioA_clk),
-	CLKDEV_CON_ID("pioB", &pioB_clk),
-	CLKDEV_CON_ID("pioC", &pioC_clk),
-	CLKDEV_CON_ID("pioD", &pioD_clk),
-	/* usart lookup table for DT entries */
-	CLKDEV_CON_DEV_ID("usart", "fffff200.serial", &mck),
-	CLKDEV_CON_DEV_ID("usart", "fffc0000.serial", &usart0_clk),
-	CLKDEV_CON_DEV_ID("usart", "fffc4000.serial", &usart1_clk),
-	CLKDEV_CON_DEV_ID("usart", "fffc8000.serial", &usart2_clk),
-	CLKDEV_CON_DEV_ID("usart", "fffcc000.serial", &usart3_clk),
-	/* tc lookup table for DT entries */
-	CLKDEV_CON_DEV_ID("t0_clk", "fffa0000.timer", &tc0_clk),
-	CLKDEV_CON_DEV_ID("t1_clk", "fffa0000.timer", &tc1_clk),
-	CLKDEV_CON_DEV_ID("t2_clk", "fffa0000.timer", &tc2_clk),
-	CLKDEV_CON_DEV_ID("t0_clk", "fffa4000.timer", &tc3_clk),
-	CLKDEV_CON_DEV_ID("t1_clk", "fffa4000.timer", &tc4_clk),
-	CLKDEV_CON_DEV_ID("t2_clk", "fffa4000.timer", &tc5_clk),
-	CLKDEV_CON_DEV_ID("mci_clk", "fffb4000.mmc", &mmc_clk),
-	CLKDEV_CON_DEV_ID("emac_clk", "fffbc000.ethernet", &ether_clk),
-	CLKDEV_CON_DEV_ID(NULL, "fffb8000.i2c", &twi_clk),
-	CLKDEV_CON_DEV_ID("hclk", "300000.ohci", &ohci_clk),
-	CLKDEV_CON_DEV_ID(NULL, "fffff400.gpio", &pioA_clk),
-	CLKDEV_CON_DEV_ID(NULL, "fffff600.gpio", &pioB_clk),
-	CLKDEV_CON_DEV_ID(NULL, "fffff800.gpio", &pioC_clk),
-	CLKDEV_CON_DEV_ID(NULL, "fffffa00.gpio", &pioD_clk),
-};
-
-static struct clk_lookup usart_clocks_lookups[] = {
-	CLKDEV_CON_DEV_ID("usart", "atmel_usart.0", &mck),
-	CLKDEV_CON_DEV_ID("usart", "atmel_usart.1", &usart0_clk),
-	CLKDEV_CON_DEV_ID("usart", "atmel_usart.2", &usart1_clk),
-	CLKDEV_CON_DEV_ID("usart", "atmel_usart.3", &usart2_clk),
-	CLKDEV_CON_DEV_ID("usart", "atmel_usart.4", &usart3_clk),
+static struct clk_lookup pioA_clk_lookup[] = {
+	CLKDEV_INIT(NULL, "pioA_clk", NULL),
+	CLKDEV_INIT(NULL, "pioA", NULL),
+};
+
+static struct clk_lookup pioB_clk_lookup[] = {
+	CLKDEV_INIT(NULL, "pioB_clk", NULL),
+	CLKDEV_INIT(NULL, "pioB", NULL),
+};
+
+static struct clk_lookup pioC_clk_lookup[] = {
+	CLKDEV_INIT(NULL, "pioC_clk", NULL),
+	CLKDEV_INIT(NULL, "pioC", NULL),
+};
+
+static struct clk_lookup pioD_clk_lookup[] = {
+	CLKDEV_INIT(NULL, "pioD_clk", NULL),
+	CLKDEV_INIT(NULL, "pioD", NULL),
+};
+
+static struct clk_lookup usart0_clk_lookup[] = {
+	CLKDEV_INIT(NULL, "usart0_clk", NULL),
+	CLKDEV_INIT("atmel_usart.1", "usart", NULL),
+};
+
+static struct clk_lookup usart1_clk_lookup[] = {
+	CLKDEV_INIT(NULL, "usart1_clk", NULL),
+	CLKDEV_INIT("atmel_usart.2", "usart", NULL),
+};
+
+static struct clk_lookup usart2_clk_lookup[] = {
+	CLKDEV_INIT(NULL, "usart2_clk", NULL),
+	CLKDEV_INIT("atmel_usart.3", "usart", NULL),
+};
+
+static struct clk_lookup usart3_clk_lookup[] = {
+	CLKDEV_INIT(NULL, "usart3_clk", NULL),
+	CLKDEV_INIT("atmel_usart.4", "usart", NULL),
+};
+
+static struct clk_lookup mci_clk_lookup[] = {
+	CLKDEV_INIT(NULL, "mci_clk", NULL),
+};
+
+static struct clk_lookup udc_clk_lookup[] = {
+	CLKDEV_INIT(NULL, "udc_clk", NULL),
+};
+
+static struct clk_lookup twi_clk_lookup[] = {
+	CLKDEV_INIT(NULL, "twi_clk", NULL),
+	CLKDEV_INIT("i2c-at91rm9200.0", NULL, NULL),
+};
+
+static struct clk_lookup ssc0_clk_lookup[] = {
+	CLKDEV_INIT(NULL, "ssc0_clk", NULL),
+	CLKDEV_INIT("at91rm9200_ssc.0", "pclk", NULL),
+};
+
+static struct clk_lookup ssc1_clk_lookup[] = {
+	CLKDEV_INIT(NULL, "ssc1_clk", NULL),
+	CLKDEV_INIT("at91rm9200_ssc.1", "pclk", NULL),
+};
+
+static struct clk_lookup ssc2_clk_lookup[] = {
+	CLKDEV_INIT(NULL, "ssc2_clk", NULL),
+	CLKDEV_INIT("at91rm9200_ssc.2", "pclk", NULL),
+};
+
+static struct clk_lookup tc0_clk_lookup[] = {
+	CLKDEV_INIT(NULL, "tc0_clk", NULL),
+	CLKDEV_INIT("atmel_tcb.0", "t0_clk", NULL),
+};
+
+static struct clk_lookup tc1_clk_lookup[] = {
+	CLKDEV_INIT(NULL, "tc1_clk", NULL),
+	CLKDEV_INIT("atmel_tcb.0", "t1_clk", NULL),
+};
+
+static struct clk_lookup tc2_clk_lookup[] = {
+	CLKDEV_INIT(NULL, "tc2_clk", NULL),
+	CLKDEV_INIT("atmel_tcb.0", "t2_clk", NULL),
+};
+
+static struct clk_lookup tc3_clk_lookup[] = {
+	CLKDEV_INIT(NULL, "tc3_clk", NULL),
+	CLKDEV_INIT("atmel_tcb.1", "t0_clk", NULL),
+};
+
+static struct clk_lookup tc4_clk_lookup[] = {
+	CLKDEV_INIT(NULL, "tc4_clk", NULL),
+	CLKDEV_INIT("atmel_tcb.1", "t1_clk", NULL),
+};
+
+static struct clk_lookup tc5_clk_lookup[] = {
+	CLKDEV_INIT(NULL, "tc5_clk", NULL),
+	CLKDEV_INIT("atmel_tcb.1", "t2_clk", NULL),
+};
+
+static struct clk_lookup ohci_clk_lookup[] = {
+	CLKDEV_INIT(NULL, "ohci_clk", NULL),
+	CLKDEV_INIT("at91_ohci", "hclk", NULL),
+};
+
+static struct clk_lookup ether_clk_lookup[] = {
+	CLKDEV_INIT(NULL, "ether_clk", NULL),
+	CLKDEV_INIT("emac_clk", "fffbc000.ethernet", NULL),
+};
+
+static size_t periph_clock_lookup_sizes[] __initdata = {
+	0,
+	0,
+	ARRAY_SIZE(pioA_clk_lookup),
+	ARRAY_SIZE(pioB_clk_lookup),
+	ARRAY_SIZE(pioC_clk_lookup),
+	ARRAY_SIZE(pioD_clk_lookup),
+	ARRAY_SIZE(usart0_clk_lookup),
+	ARRAY_SIZE(usart1_clk_lookup),
+	ARRAY_SIZE(usart2_clk_lookup),
+	ARRAY_SIZE(usart3_clk_lookup),
+	ARRAY_SIZE(mci_clk_lookup),
+	ARRAY_SIZE(udc_clk_lookup),
+	ARRAY_SIZE(twi_clk_lookup),
+	0,
+	ARRAY_SIZE(ssc0_clk_lookup),
+	ARRAY_SIZE(ssc1_clk_lookup),
+	ARRAY_SIZE(ssc2_clk_lookup),
+	ARRAY_SIZE(tc0_clk_lookup),
+	ARRAY_SIZE(tc1_clk_lookup),
+	ARRAY_SIZE(tc2_clk_lookup),
+	ARRAY_SIZE(tc3_clk_lookup),
+	ARRAY_SIZE(tc4_clk_lookup),
+	ARRAY_SIZE(tc5_clk_lookup),
+	ARRAY_SIZE(ohci_clk_lookup),
+	ARRAY_SIZE(ether_clk_lookup),
+};
+
+static struct clk_lookup *periph_clock_lookups[] __initdata = {
+	NULL,
+	NULL,
+	pioA_clk_lookup,
+	pioB_clk_lookup,
+	pioC_clk_lookup,
+	pioD_clk_lookup,
+	usart0_clk_lookup,
+	usart1_clk_lookup,
+	usart2_clk_lookup,
+	usart3_clk_lookup,
+	mci_clk_lookup,
+	udc_clk_lookup,
+	twi_clk_lookup,
+	NULL,
+	ssc0_clk_lookup,
+	ssc1_clk_lookup,
+	ssc2_clk_lookup,
+	tc0_clk_lookup,
+	tc1_clk_lookup,
+	tc2_clk_lookup,
+	tc3_clk_lookup,
+	tc4_clk_lookup,
+	tc5_clk_lookup,
+	ohci_clk_lookup,
+	ether_clk_lookup,
+};
+
+/*
+ * The system clocks.
+ */
+static struct clk_lookup udp_clk_lookup[] = {
+	CLKDEV_INIT(NULL, "udpck", NULL),
+};
+
+static struct clk_lookup uhp_clk_lookup[] = {
+	CLKDEV_INIT(NULL, "uhpck", NULL),
+};
+
+static struct clk_lookup pck0_clk_lookup[] = {
+	CLKDEV_INIT(NULL, "pck0", NULL),
+};
+
+static struct clk_lookup pck1_clk_lookup[] = {
+	CLKDEV_INIT(NULL, "pck1", NULL),
+};
+
+static struct clk_lookup pck2_clk_lookup[] = {
+	CLKDEV_INIT(NULL, "pck2", NULL),
+};
+
+static struct clk_lookup pck3_clk_lookup[] = {
+	CLKDEV_INIT(NULL, "pck3", NULL),
+};
+
+static size_t system_clock_lookup_sizes[] __initdata = {
+	0,
+	ARRAY_SIZE(udp_clk_lookup),
+	0,
+	0,
+	ARRAY_SIZE(uhp_clk_lookup),
+	0,
+	0,
+	0,
+	ARRAY_SIZE(pck0_clk_lookup),
+	ARRAY_SIZE(pck1_clk_lookup),
+	ARRAY_SIZE(pck2_clk_lookup),
+	ARRAY_SIZE(pck3_clk_lookup),
+};
+
+static struct clk_lookup *system_clock_lookups[] __initdata = {
+	NULL,
+	udp_clk_lookup,
+	NULL,
+	NULL,
+	uhp_clk_lookup,
+	NULL,
+	NULL,
+	NULL,
+	pck0_clk_lookup,
+	pck1_clk_lookup,
+	pck2_clk_lookup,
+	pck3_clk_lookup,
 };
 
 /*
  * The four programmable clocks.
  * You must configure pin multiplexing to bring these signals out.
  */
-static struct clk pck0 = {
-	.name		= "pck0",
-	.pmc_mask	= AT91_PMC_PCK0,
-	.type		= CLK_TYPE_PROGRAMMABLE,
-	.id		= 0,
-};
-static struct clk pck1 = {
-	.name		= "pck1",
-	.pmc_mask	= AT91_PMC_PCK1,
-	.type		= CLK_TYPE_PROGRAMMABLE,
-	.id		= 1,
-};
-static struct clk pck2 = {
-	.name		= "pck2",
-	.pmc_mask	= AT91_PMC_PCK2,
-	.type		= CLK_TYPE_PROGRAMMABLE,
-	.id		= 2,
-};
-static struct clk pck3 = {
-	.name		= "pck3",
-	.pmc_mask	= AT91_PMC_PCK3,
-	.type		= CLK_TYPE_PROGRAMMABLE,
-	.id		= 3,
+static const char *prog_clock_parent_names[] __initdata = {
+	"clk32k",
+	"main",
+	"plla",
+	"pllb",
+};
+
+static const char *prog_clock_names[] __initdata = {
+	"prog0",
+	"prog1",
+	"prog2",
+	"prog3",
+};
+
+/*
+ * The pll clocks.
+ */
+static struct clk_lookup pll_clk_lookup[] __initdata = {
+	CLKDEV_INIT(NULL, "plla", NULL),
+	CLKDEV_INIT(NULL, "pllb", NULL),
+};
+
+static struct clk_range at91rm9200_pll_output[] = {
+	CLK_RANGE(80000000, 160000000),
+	CLK_RANGE(150000000, 180000000),
 };
+static u8 at91rm9200_pll_out[] = {0, 2};
+
+struct clk_pll_characteristics at91rm9200_pll_characteristics = {
+	.input = CLK_RANGE(1000000, 32000000),
+	.num_output = ARRAY_SIZE(at91rm9200_pll_output),
+	.output = at91rm9200_pll_output,
+	.out = at91rm9200_pll_out,
+};
+
+
+/*
+ * The master clock.
+ */
+static struct clk_lookup mck_clk_lookup[] = {
+	CLKDEV_INIT(NULL, "mck", NULL),
+	CLKDEV_INIT("atmel_usart.0", "usart", NULL),
+};
+
+struct clk_master_characteristics at91rm9200_master_characteristics = {
+	.output = CLK_RANGE(0, 80000000),
+	.have_div3_pres = 0,
+	.divisors = {1, 2, 3, 4},
+};
+
+static const char *master_clock_parent_names[] __initdata = {
+	"clk32k",
+	"main",
+	"plla",
+	"pllb",
+};
+
+/*
+ * The USB clock.
+ */
+static u32 usb_divisors[] = {1, 2, 0, 0};
 
 static void __init at91rm9200_register_clocks(void)
 {
 	int i;
+	int k;
+	size_t size;
+	struct clk *clk;
+	const char *name;
+	struct clk_lookup *lookup;
+
+	for (i = 0; i < ARRAY_SIZE(pll_clk_lookup); i++) {
+		name = pll_clk_lookup[i].con_id;
+		clk = at91_clk_register_pll(name, "main", i,
+					    &at91rm9200_pll_layout,
+					    &at91rm9200_pll_characteristics);
+		pll_clk_lookup[i].clk = clk;
+	}
+	clkdev_add_table(pll_clk_lookup, ARRAY_SIZE(pll_clk_lookup));
+
+	clk = at91_clk_register_master("mck",
+				       ARRAY_SIZE(master_clock_parent_names),
+				       master_clock_parent_names,
+				       &at91rm9200_master_layout,
+				       &at91rm9200_master_characteristics);
 
-	for (i = 0; i < ARRAY_SIZE(periph_clocks); i++)
-		clk_register(periph_clocks[i]);
+	for (i = 0; i < ARRAY_SIZE(mck_clk_lookup); i++)
+		mck_clk_lookup[i].clk = clk;
+	clkdev_add_table(mck_clk_lookup, ARRAY_SIZE(mck_clk_lookup));
 
-	clkdev_add_table(periph_clocks_lookups,
-			 ARRAY_SIZE(periph_clocks_lookups));
-	clkdev_add_table(usart_clocks_lookups,
-			 ARRAY_SIZE(usart_clocks_lookups));
+	for (i = 0; i < ARRAY_SIZE(periph_clock_lookup_sizes); i++) {
+		size = periph_clock_lookup_sizes[i];
+		lookup = periph_clock_lookups[i];
+		if (!size || !lookup)
+			continue;
+		name = periph_clock_lookups[i][0].con_id;
+		if (!name)
+			continue;
+		clk = at91_clk_register_peripheral(name, "mck", i);
 
-	clk_register(&pck0);
-	clk_register(&pck1);
-	clk_register(&pck2);
-	clk_register(&pck3);
+		for (k = 0; k < size; k++)
+			lookup[k].clk = clk;
+		clkdev_add_table(lookup, size);
+	}
+
+	for (i = 0; i < ARRAY_SIZE(prog_clock_names); i++) {
+		name = prog_clock_names[i];
+		clk = at91_clk_register_programmable(name,
+					prog_clock_parent_names,
+					ARRAY_SIZE(prog_clock_parent_names),
+					i, &at91rm9200_programmable_layout);
+	}
+
+	clk = at91rm9200_clk_register_usb("usbck", "pllb", usb_divisors);
+
+	for (i = 0; i < ARRAY_SIZE(system_clock_lookup_sizes); i++) {
+		size = system_clock_lookup_sizes[i];
+		lookup = system_clock_lookups[i];
+		if (!size || !lookup)
+			continue;
+		name = system_clock_lookups[i][0].con_id;
+		if (!name)
+			continue;
+		clk = at91_clk_register_system(name, i);
+		for (k = 0; k < size; k++)
+			lookup[k].clk = clk;
+		clkdev_add_table(lookup, size);
+	}
 }
 
 /* --------------------------------------------------------------------
-- 
1.7.9.5

