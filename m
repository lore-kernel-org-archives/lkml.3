Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659Ab3GQOmR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 10:42:17 -0400
Received: from 20.mo1.mail-out.ovh.net ([188.165.45.168]:53689 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755506Ab3GQOmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 10:42:16 -0400
X-Greylist: delayed 4054 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Jul 2013 10:42:15 EDT
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
Subject: [PATCH v2 14/42] ARM: at91: move at91sam9260 SoC to new at91 clk implem
Date: Wed, 17 Jul 2013 16:42:07 +0200
Message-Id: <1374072127-19501-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374068069-13496-1-git-send-email-b.brezillon@overkiz.com>
References: <1374068069-13496-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 12476941294390769772
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
make use of the new at91 clk implem for at91sam9260 SoC.

All dt specific lookups are removed (handled in clk device tree binding).

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 arch/arm/mach-at91/at91sam9260.c |  687 +++++++++++++++++++++++++-------------
 1 file changed, 452 insertions(+), 235 deletions(-)

diff --git a/arch/arm/mach-at91/at91sam9260.c b/arch/arm/mach-at91/at91sam9260.c
index db9d89a..3becd5a 100644
--- a/arch/arm/mach-at91/at91sam9260.c
+++ b/arch/arm/mach-at91/at91sam9260.c
@@ -26,7 +26,6 @@
 #include "at91_rstc.h"
 #include "soc.h"
 #include "generic.h"
-#include "clock.h"
 #include "sam9_smc.h"
 
 /* --------------------------------------------------------------------
@@ -36,255 +35,473 @@
 /*
  * The peripheral clocks.
  */
-static struct clk pioA_clk = {
-	.name		= "pioA_clk",
-	.pmc_mask	= 1 << AT91SAM9260_ID_PIOA,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk pioB_clk = {
-	.name		= "pioB_clk",
-	.pmc_mask	= 1 << AT91SAM9260_ID_PIOB,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk pioC_clk = {
-	.name		= "pioC_clk",
-	.pmc_mask	= 1 << AT91SAM9260_ID_PIOC,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk adc_clk = {
-	.name		= "adc_clk",
-	.pmc_mask	= 1 << AT91SAM9260_ID_ADC,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-
-static struct clk adc_op_clk = {
-	.name		= "adc_op_clk",
-	.type		= CLK_TYPE_PERIPHERAL,
-	.rate_hz	= 5000000,
-};
-
-static struct clk usart0_clk = {
-	.name		= "usart0_clk",
-	.pmc_mask	= 1 << AT91SAM9260_ID_US0,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk usart1_clk = {
-	.name		= "usart1_clk",
-	.pmc_mask	= 1 << AT91SAM9260_ID_US1,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk usart2_clk = {
-	.name		= "usart2_clk",
-	.pmc_mask	= 1 << AT91SAM9260_ID_US2,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk mmc_clk = {
-	.name		= "mci_clk",
-	.pmc_mask	= 1 << AT91SAM9260_ID_MCI,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk udc_clk = {
-	.name		= "udc_clk",
-	.pmc_mask	= 1 << AT91SAM9260_ID_UDP,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk twi_clk = {
-	.name		= "twi_clk",
-	.pmc_mask	= 1 << AT91SAM9260_ID_TWI,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk spi0_clk = {
-	.name		= "spi0_clk",
-	.pmc_mask	= 1 << AT91SAM9260_ID_SPI0,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk spi1_clk = {
-	.name		= "spi1_clk",
-	.pmc_mask	= 1 << AT91SAM9260_ID_SPI1,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk ssc_clk = {
-	.name		= "ssc_clk",
-	.pmc_mask	= 1 << AT91SAM9260_ID_SSC,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk tc0_clk = {
-	.name		= "tc0_clk",
-	.pmc_mask	= 1 << AT91SAM9260_ID_TC0,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk tc1_clk = {
-	.name		= "tc1_clk",
-	.pmc_mask	= 1 << AT91SAM9260_ID_TC1,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk tc2_clk = {
-	.name		= "tc2_clk",
-	.pmc_mask	= 1 << AT91SAM9260_ID_TC2,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk ohci_clk = {
-	.name		= "ohci_clk",
-	.pmc_mask	= 1 << AT91SAM9260_ID_UHP,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk macb_clk = {
-	.name		= "pclk",
-	.pmc_mask	= 1 << AT91SAM9260_ID_EMAC,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk isi_clk = {
-	.name		= "isi_clk",
-	.pmc_mask	= 1 << AT91SAM9260_ID_ISI,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk usart3_clk = {
-	.name		= "usart3_clk",
-	.pmc_mask	= 1 << AT91SAM9260_ID_US3,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk usart4_clk = {
-	.name		= "usart4_clk",
-	.pmc_mask	= 1 << AT91SAM9260_ID_US4,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk usart5_clk = {
-	.name		= "usart5_clk",
-	.pmc_mask	= 1 << AT91SAM9260_ID_US5,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk tc3_clk = {
-	.name		= "tc3_clk",
-	.pmc_mask	= 1 << AT91SAM9260_ID_TC3,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk tc4_clk = {
-	.name		= "tc4_clk",
-	.pmc_mask	= 1 << AT91SAM9260_ID_TC4,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk tc5_clk = {
-	.name		= "tc5_clk",
-	.pmc_mask	= 1 << AT91SAM9260_ID_TC5,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-
-static struct clk *periph_clocks[] __initdata = {
-	&pioA_clk,
-	&pioB_clk,
-	&pioC_clk,
-	&adc_clk,
-	&adc_op_clk,
-	&usart0_clk,
-	&usart1_clk,
-	&usart2_clk,
-	&mmc_clk,
-	&udc_clk,
-	&twi_clk,
-	&spi0_clk,
-	&spi1_clk,
-	&ssc_clk,
-	&tc0_clk,
-	&tc1_clk,
-	&tc2_clk,
-	&ohci_clk,
-	&macb_clk,
-	&isi_clk,
-	&usart3_clk,
-	&usart4_clk,
-	&usart5_clk,
-	&tc3_clk,
-	&tc4_clk,
-	&tc5_clk,
-	// irq0 .. irq2
-};
-
-static struct clk_lookup periph_clocks_lookups[] = {
-	/* One additional fake clock for macb_hclk */
-	CLKDEV_CON_ID("hclk", &macb_clk),
-	CLKDEV_CON_DEV_ID("spi_clk", "atmel_spi.0", &spi0_clk),
-	CLKDEV_CON_DEV_ID("spi_clk", "atmel_spi.1", &spi1_clk),
-	CLKDEV_CON_DEV_ID("t0_clk", "atmel_tcb.0", &tc0_clk),
-	CLKDEV_CON_DEV_ID("t1_clk", "atmel_tcb.0", &tc1_clk),
-	CLKDEV_CON_DEV_ID("t2_clk", "atmel_tcb.0", &tc2_clk),
-	CLKDEV_CON_DEV_ID("t0_clk", "atmel_tcb.1", &tc3_clk),
-	CLKDEV_CON_DEV_ID("t1_clk", "atmel_tcb.1", &tc4_clk),
-	CLKDEV_CON_DEV_ID("t2_clk", "atmel_tcb.1", &tc5_clk),
-	CLKDEV_CON_DEV_ID("pclk", "at91rm9200_ssc.0", &ssc_clk),
-	CLKDEV_CON_DEV_ID("pclk", "fffbc000.ssc", &ssc_clk),
-	CLKDEV_CON_DEV_ID(NULL, "i2c-at91sam9260.0", &twi_clk),
-	CLKDEV_CON_DEV_ID(NULL, "i2c-at91sam9g20.0", &twi_clk),
-	/* more usart lookup table for DT entries */
-	CLKDEV_CON_DEV_ID("usart", "fffff200.serial", &mck),
-	CLKDEV_CON_DEV_ID("usart", "fffb0000.serial", &usart0_clk),
-	CLKDEV_CON_DEV_ID("usart", "fffb4000.serial", &usart1_clk),
-	CLKDEV_CON_DEV_ID("usart", "fffb8000.serial", &usart2_clk),
-	CLKDEV_CON_DEV_ID("usart", "fffd0000.serial", &usart3_clk),
-	CLKDEV_CON_DEV_ID("usart", "fffd4000.serial", &usart4_clk),
-	CLKDEV_CON_DEV_ID("usart", "fffd8000.serial", &usart5_clk),
-	CLKDEV_CON_DEV_ID(NULL, "fffac000.i2c", &twi_clk),
-	/* more tc lookup table for DT entries */
-	CLKDEV_CON_DEV_ID("t0_clk", "fffa0000.timer", &tc0_clk),
-	CLKDEV_CON_DEV_ID("t1_clk", "fffa0000.timer", &tc1_clk),
-	CLKDEV_CON_DEV_ID("t2_clk", "fffa0000.timer", &tc2_clk),
-	CLKDEV_CON_DEV_ID("t0_clk", "fffdc000.timer", &tc3_clk),
-	CLKDEV_CON_DEV_ID("t1_clk", "fffdc000.timer", &tc4_clk),
-	CLKDEV_CON_DEV_ID("t2_clk", "fffdc000.timer", &tc5_clk),
-	CLKDEV_CON_DEV_ID("hclk", "500000.ohci", &ohci_clk),
-	CLKDEV_CON_DEV_ID("mci_clk", "fffa8000.mmc", &mmc_clk),
-	CLKDEV_CON_DEV_ID("spi_clk", "fffc8000.spi", &spi0_clk),
-	CLKDEV_CON_DEV_ID("spi_clk", "fffcc000.spi", &spi1_clk),
-	/* fake hclk clock */
-	CLKDEV_CON_DEV_ID("hclk", "at91_ohci", &ohci_clk),
-	CLKDEV_CON_ID("pioA", &pioA_clk),
-	CLKDEV_CON_ID("pioB", &pioB_clk),
-	CLKDEV_CON_ID("pioC", &pioC_clk),
-	CLKDEV_CON_DEV_ID(NULL, "fffff400.gpio", &pioA_clk),
-	CLKDEV_CON_DEV_ID(NULL, "fffff600.gpio", &pioB_clk),
-	CLKDEV_CON_DEV_ID(NULL, "fffff800.gpio", &pioC_clk),
-};
-
-static struct clk_lookup usart_clocks_lookups[] = {
-	CLKDEV_CON_DEV_ID("usart", "atmel_usart.0", &mck),
-	CLKDEV_CON_DEV_ID("usart", "atmel_usart.1", &usart0_clk),
-	CLKDEV_CON_DEV_ID("usart", "atmel_usart.2", &usart1_clk),
-	CLKDEV_CON_DEV_ID("usart", "atmel_usart.3", &usart2_clk),
-	CLKDEV_CON_DEV_ID("usart", "atmel_usart.4", &usart3_clk),
-	CLKDEV_CON_DEV_ID("usart", "atmel_usart.5", &usart4_clk),
-	CLKDEV_CON_DEV_ID("usart", "atmel_usart.6", &usart5_clk),
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
+static struct clk_lookup adc_clk_lookup[] = {
+	CLKDEV_INIT(NULL, "adc_clk", NULL),
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
+	CLKDEV_INIT("i2c-at91sam9260.0", NULL, NULL),
+	CLKDEV_INIT("i2c-at91sam9g20.0", NULL, NULL),
+};
+
+static struct clk_lookup spi0_clk_lookup[] = {
+	CLKDEV_INIT(NULL, "spi0_clk", NULL),
+	CLKDEV_INIT("atmel_spi.0", "spi_clk", NULL),
+};
+
+static struct clk_lookup spi1_clk_lookup[] = {
+	CLKDEV_INIT(NULL, "spi1_clk", NULL),
+	CLKDEV_INIT("atmel_spi.1", "spi_clk", NULL),
+};
+
+static struct clk_lookup ssc_clk_lookup[] = {
+	CLKDEV_INIT(NULL, "ssc_clk", NULL),
+	CLKDEV_INIT("at91rm9200_ssc.0", "pclk", NULL),
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
+static struct clk_lookup ohci_clk_lookup[] = {
+	CLKDEV_INIT(NULL, "ohci_clk", NULL),
+	CLKDEV_INIT("at91_ohci", "hclk", NULL),
+};
+
+static struct clk_lookup macb_clk_lookup[] = {
+	CLKDEV_INIT(NULL, "pclk", NULL),
+	CLKDEV_INIT(NULL, "hclk", NULL),
+};
+
+static struct clk_lookup usart3_clk_lookup[] = {
+	CLKDEV_INIT(NULL, "usart3_clk", NULL),
+	CLKDEV_INIT("atmel_usart.4", "usart", NULL),
+};
+
+static struct clk_lookup usart4_clk_lookup[] = {
+	CLKDEV_INIT(NULL, "usart4_clk", NULL),
+	CLKDEV_INIT("atmel_usart.5", "usart", NULL),
+};
+
+static struct clk_lookup usart5_clk_lookup[] = {
+	CLKDEV_INIT(NULL, "usart5_clk", NULL),
+	CLKDEV_INIT("atmel_usart.6", "usart", NULL),
+};
+
+static struct clk_lookup tc3_clk_lookup[] = {
+	CLKDEV_INIT(NULL, "tc3_clk", NULL),
+	CLKDEV_INIT("t0_clk", "atmel_tcb.1", NULL),
+};
+
+static struct clk_lookup tc4_clk_lookup[] = {
+	CLKDEV_INIT(NULL, "tc4_clk", NULL),
+	CLKDEV_INIT("t1_clk", "atmel_tcb.1", NULL),
+};
+
+static struct clk_lookup tc5_clk_lookup[] = {
+	CLKDEV_INIT(NULL, "tc5_clk", NULL),
+	CLKDEV_INIT("t2_clk", "atmel_tcb.1", NULL),
+};
+
+static size_t periph_clock_lookup_sizes[] __initdata = {
+	0,
+	0,
+	ARRAY_SIZE(pioA_clk_lookup),
+	ARRAY_SIZE(pioB_clk_lookup),
+	ARRAY_SIZE(pioC_clk_lookup),
+	ARRAY_SIZE(adc_clk_lookup),
+	ARRAY_SIZE(usart0_clk_lookup),
+	ARRAY_SIZE(usart1_clk_lookup),
+	ARRAY_SIZE(usart2_clk_lookup),
+	ARRAY_SIZE(mci_clk_lookup),
+	ARRAY_SIZE(udc_clk_lookup),
+	ARRAY_SIZE(twi_clk_lookup),
+	0,
+	ARRAY_SIZE(spi0_clk_lookup),
+	ARRAY_SIZE(spi1_clk_lookup),
+	ARRAY_SIZE(ssc_clk_lookup),
+	0,
+	0,
+	ARRAY_SIZE(tc0_clk_lookup),
+	ARRAY_SIZE(tc1_clk_lookup),
+	ARRAY_SIZE(tc2_clk_lookup),
+	ARRAY_SIZE(ohci_clk_lookup),
+	ARRAY_SIZE(macb_clk_lookup),
+	0,
+	ARRAY_SIZE(usart3_clk_lookup),
+	ARRAY_SIZE(usart4_clk_lookup),
+	ARRAY_SIZE(usart5_clk_lookup),
+	ARRAY_SIZE(tc3_clk_lookup),
+	ARRAY_SIZE(tc4_clk_lookup),
+	ARRAY_SIZE(tc5_clk_lookup),
+};
+
+static struct clk_lookup *periph_clock_lookups[] __initdata = {
+	NULL,
+	NULL,
+	pioA_clk_lookup,
+	pioB_clk_lookup,
+	pioC_clk_lookup,
+	adc_clk_lookup,
+	usart0_clk_lookup,
+	usart1_clk_lookup,
+	usart2_clk_lookup,
+	mci_clk_lookup,
+	udc_clk_lookup,
+	twi_clk_lookup,
+	NULL,
+	spi0_clk_lookup,
+	spi1_clk_lookup,
+	ssc_clk_lookup,
+	NULL,
+	NULL,
+	tc0_clk_lookup,
+	tc1_clk_lookup,
+	tc2_clk_lookup,
+	ohci_clk_lookup,
+	macb_clk_lookup,
+	NULL,
+	usart3_clk_lookup,
+	usart4_clk_lookup,
+	usart5_clk_lookup,
+	tc3_clk_lookup,
+	tc4_clk_lookup,
+	tc5_clk_lookup,
+};
+
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
+static size_t system_clock_lookup_sizes[] __initdata = {
+	0,
+	0,
+	0,
+	0,
+	0,
+	0,
+	ARRAY_SIZE(uhp_clk_lookup),
+	ARRAY_SIZE(udp_clk_lookup),
+	ARRAY_SIZE(pck0_clk_lookup),
+	ARRAY_SIZE(pck1_clk_lookup),
+};
+
+static struct clk_lookup *system_clock_lookups[] __initdata = {
+	NULL,
+	NULL,
+	NULL,
+	NULL,
+	NULL,
+	NULL,
+	uhp_clk_lookup,
+	udp_clk_lookup,
+	pck0_clk_lookup,
+	pck1_clk_lookup,
 };
 
 /*
  * The two programmable clocks.
  * You must configure pin multiplexing to bring these signals out.
  */
-static struct clk pck0 = {
-	.name		= "pck0",
-	.pmc_mask	= AT91_PMC_PCK0,
-	.type		= CLK_TYPE_PROGRAMMABLE,
-	.id		= 0,
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
+};
+
+/*
+ * The pll clocks.
+ */
+static struct clk_lookup pll_clk_lookup[] = {
+	CLKDEV_INIT(NULL, "plla", NULL),
+	CLKDEV_INIT(NULL, "pllb", NULL),
+};
+
+static struct clk_range at91sam9260_plla_output[] = {
+	CLK_RANGE(80000000, 160000000),
+	CLK_RANGE(150000000, 240000000),
+};
+static u8 at91sam9260_plla_out[] = {0, 2};
+
+static struct clk_range at91sam9260_pllb_output[] = {
+	CLK_RANGE(70000000, 130000000),
+};
+static u8 at91sam9260_pllb_out[] = {1,};
+
+struct clk_pll_characteristics at91sam9260_pll_characteristics[] = {
+	{
+		.input = CLK_RANGE(1000000, 32000000),
+		.num_output = ARRAY_SIZE(at91sam9260_plla_output),
+		.output = at91sam9260_plla_output,
+		.out = at91sam9260_plla_out,
+	},
+	{
+		.input = CLK_RANGE(1000000, 5000000),
+		.num_output = ARRAY_SIZE(at91sam9260_pllb_output),
+		.output = at91sam9260_pllb_output,
+		.out = at91sam9260_pllb_out,
+	},
+};
+
+static struct clk_range at91sam9xe_plla_output[] = {
+	CLK_RANGE(80000000, 160000000),
+	CLK_RANGE(150000000, 220000000),
+};
+
+struct clk_pll_characteristics at91sam9xe_pll_characteristics[] = {
+	{
+		.input = CLK_RANGE(1000000, 32000000),
+		.num_output = ARRAY_SIZE(at91sam9xe_plla_output),
+		.output = at91sam9xe_plla_output,
+		.out = at91sam9260_plla_out,
+	},
+	{
+		.input = CLK_RANGE(1000000, 5000000),
+		.num_output = ARRAY_SIZE(at91sam9260_pllb_output),
+		.output = at91sam9260_pllb_output,
+		.out = at91sam9260_pllb_out,
+	},
+};
+
+static struct clk_range at91sam9g20_plla_output[] = {
+	CLK_RANGE(745000000, 800000000),
+	CLK_RANGE(695000000, 750000000),
+	CLK_RANGE(645000000, 700000000),
+	CLK_RANGE(595000000, 650000000),
+	CLK_RANGE(545000000, 600000000),
+	CLK_RANGE(495000000, 550000000),
+	CLK_RANGE(445000000, 500000000),
+	CLK_RANGE(400000000, 450000000),
+};
+static u8 at91sam9g20_plla_out[] = {0, 1, 2, 3, 0, 1, 2, 3};
+static u16 at91sam9g20_plla_icpll[] = {0, 0, 0, 0, 1, 1, 1, 1};
+
+static struct clk_range at91sam9g20_pllb_output[] = {
+	CLK_RANGE(30000000, 100000000),
+};
+static u8 at91sam9g20_pllb_out[] = {0};
+
+struct clk_pll_characteristics at91sam9g20_pll_characteristics[] = {
+	{
+		.input = CLK_RANGE(2000000, 32000000),
+		.num_output = ARRAY_SIZE(at91sam9g20_plla_output),
+		.output = at91sam9g20_plla_output,
+		.out = at91sam9g20_plla_out,
+		.icpll = at91sam9g20_plla_icpll,
+	},
+	{
+		.input = CLK_RANGE(2000000, 32000000),
+		.num_output = ARRAY_SIZE(at91sam9g20_pllb_output),
+		.output = at91sam9g20_pllb_output,
+		.out = at91sam9g20_pllb_out,
+	},
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
+struct clk_master_characteristics at91sam9260_master_characteristics = {
+	.output = CLK_RANGE(0, 105000000),
+	.have_div3_pres = 0,
+	.divisors = {1, 2, 4, 0},
+};
+
+struct clk_master_characteristics at91sam9xe_master_characteristics = {
+	.output = CLK_RANGE(0, 90000000),
+	.have_div3_pres = 0,
+	.divisors = {1, 2, 4, 0},
+};
+
+struct clk_master_characteristics at91sam9g20_master_characteristics = {
+	.output = CLK_RANGE(0, 133000000),
+	.have_div3_pres = 0,
+	.divisors = {1, 2, 4, 6},
 };
-static struct clk pck1 = {
-	.name		= "pck1",
-	.pmc_mask	= AT91_PMC_PCK1,
-	.type		= CLK_TYPE_PROGRAMMABLE,
-	.id		= 1,
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
+static u32 usb_divisors[] = {1, 2, 4, 0};
+
+static struct clk_lookup usb_clk_lookup[] = {
+	CLKDEV_INIT(NULL, "usb_clk", NULL),
 };
 
 static void __init at91sam9260_register_clocks(void)
 {
 	int i;
+	int k;
+	size_t size;
+	struct clk *clk;
+	const char *name;
+	struct clk_lookup *lookup;
+	struct clk_pll_characteristics *pll_characteristics;
+	struct clk_pll_layout *pll_layout;
+	struct clk_master_characteristics *master_characteristics;
+
+	if (cpu_is_at91sam9xe()) {
+		pll_characteristics = at91sam9xe_pll_characteristics;
+		master_characteristics = &at91sam9xe_master_characteristics;
+	} else if (cpu_is_at91sam9g20()) {
+		pll_characteristics = at91sam9g20_pll_characteristics;
+		master_characteristics = &at91sam9g20_master_characteristics;
+	} else {
+		pll_characteristics = at91sam9260_pll_characteristics;
+		master_characteristics = &at91sam9260_master_characteristics;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(pll_clk_lookup); i++) {
+		name = pll_clk_lookup[i].con_id;
+		pll_layout = &at91rm9200_pll_layout;
+		if (cpu_is_at91sam9g20()) {
+			if (!i)
+				pll_layout = &at91sam9g45_pll_layout;
+			else
+				pll_layout = &at91sam9g20_pllb_layout;
+		}
+		clk = at91_clk_register_pll(name, "main", i, pll_layout,
+					    &pll_characteristics[i]);
+		pll_clk_lookup[i].clk = clk;
+	}
+	clkdev_add_table(pll_clk_lookup, ARRAY_SIZE(pll_clk_lookup));
+
+	clk = at91_clk_register_master("mck",
+				       ARRAY_SIZE(master_clock_parent_names),
+				       master_clock_parent_names,
+				       &at91rm9200_master_layout,
+				       master_characteristics);
+	for (i = 0; i < ARRAY_SIZE(mck_clk_lookup); i++)
+		mck_clk_lookup[i].clk = clk;
+	clkdev_add_table(mck_clk_lookup, ARRAY_SIZE(mck_clk_lookup));
+
+	for (i = 0; i < ARRAY_SIZE(periph_clock_lookup_sizes); i++) {
+		size = periph_clock_lookup_sizes[i];
+		lookup = periph_clock_lookups[i];
+		if (!size || !lookup)
+			continue;
+		name = periph_clock_lookups[i][0].con_id;
+		if (!name)
+			continue;
+		clk = at91_clk_register_peripheral(name, "mck", i);
+
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
 
-	for (i = 0; i < ARRAY_SIZE(periph_clocks); i++)
-		clk_register(periph_clocks[i]);
+	clk = at91rm9200_clk_register_usb("usbck", "pllb", usb_divisors);
+	for (i = 0; i < ARRAY_SIZE(usb_clk_lookup); i++)
+		usb_clk_lookup[i].clk = clk;
+	clkdev_add_table(usb_clk_lookup, ARRAY_SIZE(usb_clk_lookup));
 
-	clkdev_add_table(periph_clocks_lookups,
-			 ARRAY_SIZE(periph_clocks_lookups));
-	clkdev_add_table(usart_clocks_lookups,
-			 ARRAY_SIZE(usart_clocks_lookups));
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
 
-	clk_register(&pck0);
-	clk_register(&pck1);
+	clk_register_fixed_rate(NULL, "adc_op_clk", "mck", 0, 5000000);
 }
 
 /* --------------------------------------------------------------------
-- 
1.7.9.5

