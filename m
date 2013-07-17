Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818Ab3GQOqI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 10:46:08 -0400
Received: from 3.mo1.mail-out.ovh.net ([46.105.60.232]:47999 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755660Ab3GQOqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 10:46:05 -0400
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
Subject: [PATCH v2 16/42] ARM: at91: move at91sam9263 SoC to new at91 clk implem
Date: Wed, 17 Jul 2013 16:45:54 +0200
Message-Id: <1374072354-19624-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374068069-13496-1-git-send-email-b.brezillon@overkiz.com>
References: <1374068069-13496-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 12540836112880662636
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
make use of the new at91 clk implem for at91sam9263 SoC.

All dt specific lookups are removed (handled in clk device tree binding).

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 arch/arm/mach-at91/at91sam9263.c |  593 +++++++++++++++++++++++---------------
 1 file changed, 364 insertions(+), 229 deletions(-)

diff --git a/arch/arm/mach-at91/at91sam9263.c b/arch/arm/mach-at91/at91sam9263.c
index e0a1a68..339b9ef 100644
--- a/arch/arm/mach-at91/at91sam9263.c
+++ b/arch/arm/mach-at91/at91sam9263.c
@@ -24,7 +24,6 @@
 #include "at91_rstc.h"
 #include "soc.h"
 #include "generic.h"
-#include "clock.h"
 #include "sam9_smc.h"
 
 /* --------------------------------------------------------------------
@@ -34,248 +33,384 @@
 /*
  * The peripheral clocks.
  */
-static struct clk pioA_clk = {
-	.name		= "pioA_clk",
-	.pmc_mask	= 1 << AT91SAM9263_ID_PIOA,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk pioB_clk = {
-	.name		= "pioB_clk",
-	.pmc_mask	= 1 << AT91SAM9263_ID_PIOB,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk pioCDE_clk = {
-	.name		= "pioCDE_clk",
-	.pmc_mask	= 1 << AT91SAM9263_ID_PIOCDE,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk usart0_clk = {
-	.name		= "usart0_clk",
-	.pmc_mask	= 1 << AT91SAM9263_ID_US0,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk usart1_clk = {
-	.name		= "usart1_clk",
-	.pmc_mask	= 1 << AT91SAM9263_ID_US1,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk usart2_clk = {
-	.name		= "usart2_clk",
-	.pmc_mask	= 1 << AT91SAM9263_ID_US2,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk mmc0_clk = {
-	.name		= "mci0_clk",
-	.pmc_mask	= 1 << AT91SAM9263_ID_MCI0,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk mmc1_clk = {
-	.name		= "mci1_clk",
-	.pmc_mask	= 1 << AT91SAM9263_ID_MCI1,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk can_clk = {
-	.name		= "can_clk",
-	.pmc_mask	= 1 << AT91SAM9263_ID_CAN,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk twi_clk = {
-	.name		= "twi_clk",
-	.pmc_mask	= 1 << AT91SAM9263_ID_TWI,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk spi0_clk = {
-	.name		= "spi0_clk",
-	.pmc_mask	= 1 << AT91SAM9263_ID_SPI0,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk spi1_clk = {
-	.name		= "spi1_clk",
-	.pmc_mask	= 1 << AT91SAM9263_ID_SPI1,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk ssc0_clk = {
-	.name		= "ssc0_clk",
-	.pmc_mask	= 1 << AT91SAM9263_ID_SSC0,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk ssc1_clk = {
-	.name		= "ssc1_clk",
-	.pmc_mask	= 1 << AT91SAM9263_ID_SSC1,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk ac97_clk = {
-	.name		= "ac97_clk",
-	.pmc_mask	= 1 << AT91SAM9263_ID_AC97C,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk tcb_clk = {
-	.name		= "tcb_clk",
-	.pmc_mask	= 1 << AT91SAM9263_ID_TCB,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk pwm_clk = {
-	.name		= "pwm_clk",
-	.pmc_mask	= 1 << AT91SAM9263_ID_PWMC,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk macb_clk = {
-	.name		= "pclk",
-	.pmc_mask	= 1 << AT91SAM9263_ID_EMAC,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk dma_clk = {
-	.name		= "dma_clk",
-	.pmc_mask	= 1 << AT91SAM9263_ID_DMA,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk twodge_clk = {
-	.name		= "2dge_clk",
-	.pmc_mask	= 1 << AT91SAM9263_ID_2DGE,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk udc_clk = {
-	.name		= "udc_clk",
-	.pmc_mask	= 1 << AT91SAM9263_ID_UDP,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk isi_clk = {
-	.name		= "isi_clk",
-	.pmc_mask	= 1 << AT91SAM9263_ID_ISI,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk lcdc_clk = {
-	.name		= "lcdc_clk",
-	.pmc_mask	= 1 << AT91SAM9263_ID_LCDC,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk ohci_clk = {
-	.name		= "ohci_clk",
-	.pmc_mask	= 1 << AT91SAM9263_ID_UHP,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-
-static struct clk *periph_clocks[] __initdata = {
-	&pioA_clk,
-	&pioB_clk,
-	&pioCDE_clk,
-	&usart0_clk,
-	&usart1_clk,
-	&usart2_clk,
-	&mmc0_clk,
-	&mmc1_clk,
-	&can_clk,
-	&twi_clk,
-	&spi0_clk,
-	&spi1_clk,
-	&ssc0_clk,
-	&ssc1_clk,
-	&ac97_clk,
-	&tcb_clk,
-	&pwm_clk,
-	&macb_clk,
-	&twodge_clk,
-	&udc_clk,
-	&isi_clk,
-	&lcdc_clk,
-	&dma_clk,
-	&ohci_clk,
-	// irq0 .. irq1
-};
-
-static struct clk_lookup periph_clocks_lookups[] = {
-	/* One additional fake clock for macb_hclk */
-	CLKDEV_CON_ID("hclk", &macb_clk),
-	CLKDEV_CON_DEV_ID("pclk", "at91rm9200_ssc.0", &ssc0_clk),
-	CLKDEV_CON_DEV_ID("pclk", "at91rm9200_ssc.1", &ssc1_clk),
-	CLKDEV_CON_DEV_ID("pclk", "fff98000.ssc", &ssc0_clk),
-	CLKDEV_CON_DEV_ID("pclk", "fff9c000.ssc", &ssc1_clk),
-	CLKDEV_CON_DEV_ID("hclk", "at91sam9263-lcdfb.0", &lcdc_clk),
-	CLKDEV_CON_DEV_ID("mci_clk", "atmel_mci.0", &mmc0_clk),
-	CLKDEV_CON_DEV_ID("mci_clk", "atmel_mci.1", &mmc1_clk),
-	CLKDEV_CON_DEV_ID("spi_clk", "atmel_spi.0", &spi0_clk),
-	CLKDEV_CON_DEV_ID("spi_clk", "atmel_spi.1", &spi1_clk),
-	CLKDEV_CON_DEV_ID("t0_clk", "atmel_tcb.0", &tcb_clk),
-	CLKDEV_CON_DEV_ID(NULL, "i2c-at91sam9260.0", &twi_clk),
-	/* fake hclk clock */
-	CLKDEV_CON_DEV_ID("hclk", "at91_ohci", &ohci_clk),
-	CLKDEV_CON_ID("pioA", &pioA_clk),
-	CLKDEV_CON_ID("pioB", &pioB_clk),
-	CLKDEV_CON_ID("pioC", &pioCDE_clk),
-	CLKDEV_CON_ID("pioD", &pioCDE_clk),
-	CLKDEV_CON_ID("pioE", &pioCDE_clk),
-	/* more usart lookup table for DT entries */
-	CLKDEV_CON_DEV_ID("usart", "ffffee00.serial", &mck),
-	CLKDEV_CON_DEV_ID("usart", "fff8c000.serial", &usart0_clk),
-	CLKDEV_CON_DEV_ID("usart", "fff90000.serial", &usart1_clk),
-	CLKDEV_CON_DEV_ID("usart", "fff94000.serial", &usart2_clk),
-	/* more tc lookup table for DT entries */
-	CLKDEV_CON_DEV_ID("t0_clk", "fff7c000.timer", &tcb_clk),
-	CLKDEV_CON_DEV_ID("hclk", "a00000.ohci", &ohci_clk),
-	CLKDEV_CON_DEV_ID("spi_clk", "fffa4000.spi", &spi0_clk),
-	CLKDEV_CON_DEV_ID("spi_clk", "fffa8000.spi", &spi1_clk),
-	CLKDEV_CON_DEV_ID("mci_clk", "fff80000.mmc", &mmc0_clk),
-	CLKDEV_CON_DEV_ID("mci_clk", "fff84000.mmc", &mmc1_clk),
-	CLKDEV_CON_DEV_ID(NULL, "fff88000.i2c", &twi_clk),
-	CLKDEV_CON_DEV_ID(NULL, "fffff200.gpio", &pioA_clk),
-	CLKDEV_CON_DEV_ID(NULL, "fffff400.gpio", &pioB_clk),
-	CLKDEV_CON_DEV_ID(NULL, "fffff600.gpio", &pioCDE_clk),
-	CLKDEV_CON_DEV_ID(NULL, "fffff800.gpio", &pioCDE_clk),
-	CLKDEV_CON_DEV_ID(NULL, "fffffa00.gpio", &pioCDE_clk),
-};
-
-static struct clk_lookup usart_clocks_lookups[] = {
-	CLKDEV_CON_DEV_ID("usart", "atmel_usart.0", &mck),
-	CLKDEV_CON_DEV_ID("usart", "atmel_usart.1", &usart0_clk),
-	CLKDEV_CON_DEV_ID("usart", "atmel_usart.2", &usart1_clk),
-	CLKDEV_CON_DEV_ID("usart", "atmel_usart.3", &usart2_clk),
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
+static struct clk_lookup pioCDE_clk_lookup[] = {
+	CLKDEV_INIT(NULL, "pioCDE_clk", NULL),
+	CLKDEV_INIT(NULL, "pioC", NULL),
+	CLKDEV_INIT(NULL, "pioD", NULL),
+	CLKDEV_INIT(NULL, "pioE", NULL),
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
+static struct clk_lookup mci0_clk_lookup[] = {
+	CLKDEV_INIT(NULL, "mci0_clk", NULL),
+	CLKDEV_INIT("atmel_mci.0", "mci_clk", NULL),
+};
+
+static struct clk_lookup mci1_clk_lookup[] = {
+	CLKDEV_INIT(NULL, "mci1_clk", NULL),
+	CLKDEV_INIT("atmel_mci.1", "mci_clk", NULL),
+};
+
+static struct clk_lookup can_clk_lookup[] = {
+	CLKDEV_INIT(NULL, "can_clk", NULL),
+};
+
+static struct clk_lookup twi_clk_lookup[] = {
+	CLKDEV_INIT(NULL, "twi_clk", NULL),
+	CLKDEV_INIT("i2c-at91sam9260.0", NULL, NULL),
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
+static struct clk_lookup ac97_clk_lookup[] = {
+	CLKDEV_INIT(NULL, "ac97_clk", NULL),
+};
+
+static struct clk_lookup tcb_clk_lookup[] = {
+	CLKDEV_INIT(NULL, "tcb_clk", NULL),
+	CLKDEV_INIT("atmel_tcb.0", "t0_clk", NULL),
+};
+
+static struct clk_lookup pwm_clk_lookup[] = {
+	CLKDEV_INIT(NULL, "pwm_clk", NULL),
+};
+
+static struct clk_lookup macb_clk_lookup[] = {
+	CLKDEV_INIT(NULL, "pclk", NULL),
+	CLKDEV_INIT(NULL, "hclk", NULL),
+};
+
+static struct clk_lookup twodge_clk_lookup[] = {
+	CLKDEV_INIT(NULL, "2dge_clk", NULL),
+};
+
+static struct clk_lookup udc_clk_lookup[] = {
+	CLKDEV_INIT(NULL, "udc_clk", NULL),
+};
+
+static struct clk_lookup isi_clk_lookup[] = {
+	CLKDEV_INIT(NULL, "isi_clk", NULL),
+};
+
+static struct clk_lookup lcdc_clk_lookup[] = {
+	CLKDEV_INIT(NULL, "lcdc_clk", NULL),
+	CLKDEV_INIT("at91sam9263-lcdfb.0", "hclk", NULL),
+};
+
+static struct clk_lookup dma_clk_lookup[] = {
+	CLKDEV_INIT(NULL, "dma_clk", NULL),
+};
+
+static struct clk_lookup ohci_clk_lookup[] = {
+	CLKDEV_INIT(NULL, "ohci_clk", NULL),
+	CLKDEV_INIT("at91_ohci", "hclk", NULL),
+};
+
+static size_t periph_clock_lookup_sizes[] __initdata = {
+	0,
+	0,
+	ARRAY_SIZE(pioA_clk_lookup),
+	ARRAY_SIZE(pioB_clk_lookup),
+	ARRAY_SIZE(pioCDE_clk_lookup),
+	0,
+	0,
+	ARRAY_SIZE(usart0_clk_lookup),
+	ARRAY_SIZE(usart1_clk_lookup),
+	ARRAY_SIZE(usart2_clk_lookup),
+	ARRAY_SIZE(mci0_clk_lookup),
+	ARRAY_SIZE(mci1_clk_lookup),
+	ARRAY_SIZE(can_clk_lookup),
+	ARRAY_SIZE(twi_clk_lookup),
+	ARRAY_SIZE(spi0_clk_lookup),
+	ARRAY_SIZE(spi1_clk_lookup),
+	ARRAY_SIZE(ssc0_clk_lookup),
+	ARRAY_SIZE(ssc1_clk_lookup),
+	ARRAY_SIZE(ac97_clk_lookup),
+	ARRAY_SIZE(tcb_clk_lookup),
+	ARRAY_SIZE(pwm_clk_lookup),
+	ARRAY_SIZE(macb_clk_lookup),
+	0,
+	ARRAY_SIZE(twodge_clk_lookup),
+	ARRAY_SIZE(udc_clk_lookup),
+	ARRAY_SIZE(isi_clk_lookup),
+	ARRAY_SIZE(lcdc_clk_lookup),
+	ARRAY_SIZE(dma_clk_lookup),
+	0,
+	ARRAY_SIZE(ohci_clk_lookup),
+};
+
+static struct clk_lookup *periph_clock_lookups[] __initdata = {
+	NULL,
+	NULL,
+	pioA_clk_lookup,
+	pioB_clk_lookup,
+	pioCDE_clk_lookup,
+	NULL,
+	NULL,
+	usart0_clk_lookup,
+	usart1_clk_lookup,
+	usart2_clk_lookup,
+	mci0_clk_lookup,
+	mci1_clk_lookup,
+	can_clk_lookup,
+	twi_clk_lookup,
+	spi0_clk_lookup,
+	spi1_clk_lookup,
+	ssc0_clk_lookup,
+	ssc1_clk_lookup,
+	ac97_clk_lookup,
+	tcb_clk_lookup,
+	pwm_clk_lookup,
+	macb_clk_lookup,
+	NULL,
+	twodge_clk_lookup,
+	udc_clk_lookup,
+	isi_clk_lookup,
+	lcdc_clk_lookup,
+	dma_clk_lookup,
+	NULL,
+	ohci_clk_lookup,
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
+	0,
+	0,
+	0,
+	0,
+	0,
+	ARRAY_SIZE(uhp_clk_lookup),
+	ARRAY_SIZE(udp_clk_lookup),
+	ARRAY_SIZE(pck0_clk_lookup),
+	ARRAY_SIZE(pck1_clk_lookup),
+	ARRAY_SIZE(pck2_clk_lookup),
+	ARRAY_SIZE(pck3_clk_lookup),
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
+static struct clk_lookup pll_clk_lookup[] = {
+	CLKDEV_INIT(NULL, "plla", NULL),
+	CLKDEV_INIT(NULL, "pllb", NULL),
+};
+
+static struct clk_range at91sam9263_pll_output[] = {
+	CLK_RANGE(80000000, 200000000),
+	CLK_RANGE(190000000, 240000000),
+};
+static u8 at91sam9263_pll_out[] = {0, 2};
+
+struct clk_pll_characteristics at91sam9263_pll_characteristics = {
+	.input = CLK_RANGE(2000000, 32000000),
+	.num_output = ARRAY_SIZE(at91sam9263_pll_output),
+	.output = at91sam9263_pll_output,
+	.out = at91sam9263_pll_out,
+};
+
+struct clk_master_characteristics at91sam9263_master_characteristics = {
+	.output = CLK_RANGE(0, 120000000),
+	.have_div3_pres = 0,
+	.divisors = {1, 2, 4, 0},
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
+static const char *master_clock_parent_names[] __initdata = {
+	"clk32k",
+	"main",
+	"plla",
+	"pllb",
+};
+
+
+/*
+ * The USB clock.
+ */
+static u32 usb_divisors[] = {1, 2, 4, 0};
+
+static struct clk_lookup usb_clk_lookup[] = {
+	CLKDEV_INIT(NULL, "usb_clk", NULL),
 };
 
 static void __init at91sam9263_register_clocks(void)
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
+					    &at91sam9263_pll_characteristics);
+		pll_clk_lookup[i].clk = clk;
+	}
+	clkdev_add_table(pll_clk_lookup, ARRAY_SIZE(pll_clk_lookup));
+
+	clk = at91_clk_register_master("mck",
+				       ARRAY_SIZE(master_clock_parent_names),
+				       master_clock_parent_names,
+				       &at91rm9200_master_layout,
+				       &at91sam9263_master_characteristics);
+	for (i = 0; i < ARRAY_SIZE(mck_clk_lookup); i++)
+		mck_clk_lookup[i].clk = clk;
+	clkdev_add_table(mck_clk_lookup, ARRAY_SIZE(mck_clk_lookup));
 
-	for (i = 0; i < ARRAY_SIZE(periph_clocks); i++)
-		clk_register(periph_clocks[i]);
+	for (i = 0; i < ARRAY_SIZE(periph_clock_lookup_sizes); i++) {
+		size = periph_clock_lookup_sizes[i];
+		lookup = periph_clock_lookups[i];
+		if (!size || !lookup)
+			continue;
+		name = periph_clock_lookups[i][0].con_id;
+		if (!name)
+			continue;
+		clk = at91_clk_register_peripheral(name, "mck", i);
 
-	clkdev_add_table(periph_clocks_lookups,
-			 ARRAY_SIZE(periph_clocks_lookups));
-	clkdev_add_table(usart_clocks_lookups,
-			 ARRAY_SIZE(usart_clocks_lookups));
+		for (k = 0; k < size; k++)
+			lookup[k].clk = clk;
+		clkdev_add_table(lookup, size);
+	}
 
-	clk_register(&pck0);
-	clk_register(&pck1);
-	clk_register(&pck2);
-	clk_register(&pck3);
+	for (i = 0; i < ARRAY_SIZE(prog_clock_names); i++) {
+		name = prog_clock_names[i];
+		clk = at91_clk_register_programmable(name,
+					prog_clock_parent_names,
+					ARRAY_SIZE(prog_clock_parent_names),
+					i, &at91rm9200_programmable_layout);
+	}
+
+	clk = at91rm9200_clk_register_usb("usbck", "pllb", usb_divisors);
+	for (i = 0; i < ARRAY_SIZE(usb_clk_lookup); i++)
+		usb_clk_lookup[i].clk = clk;
+	clkdev_add_table(usb_clk_lookup, ARRAY_SIZE(usb_clk_lookup));
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

