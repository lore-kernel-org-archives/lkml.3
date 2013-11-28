Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759190Ab3K1OwW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 09:52:22 -0500
Received: from 10.mo6.mail-out.ovh.net ([87.98.157.236]:44232 "EHLO
	mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751712Ab3K1OwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 09:52:21 -0500
X-Greylist: delayed 7907 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Nov 2013 09:52:21 EST
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Russell King <linux@arm.linux.org.uk>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Mike Turquette <mturquette@linaro.org>
Cc: Boris BREZILLON <b.brezillon@overkiz.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 6/6] ARM: at91/dt: remove old clk material
Date: Thu, 28 Nov 2013 15:52:14 +0100
Message-Id: <1385650334-9020-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385650171-8756-1-git-send-email-b.brezillon@overkiz.com>
References: <1385650171-8756-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 6389481973478226099
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrjeelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrjeelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the old main clk node which is now useless as sama5d3
SoCs and boards are no longer compatible with the old at91 clk
implementations.

It also remove old clock definitions (clock definitions using at91 old clk
framework).

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/boot/dts/sama5d3xcm.dtsi |   11 --
 arch/arm/mach-at91/sama5d3.c      |  346 -------------------------------------
 2 files changed, 357 deletions(-)

diff --git a/arch/arm/boot/dts/sama5d3xcm.dtsi b/arch/arm/boot/dts/sama5d3xcm.dtsi
index dce5419..f55ed07 100644
--- a/arch/arm/boot/dts/sama5d3xcm.dtsi
+++ b/arch/arm/boot/dts/sama5d3xcm.dtsi
@@ -18,17 +18,6 @@
 		reg = <0x20000000 0x20000000>;
 	};
 
-	clocks {
-		#address-cells = <1>;
-		#size-cells = <1>;
-		ranges;
-
-		main_clock: clock@0 {
-			compatible = "atmel,osc", "fixed-clock";
-			clock-frequency = <12000000>;
-		};
-	};
-
 	ahb {
 		apb {
 			spi0: spi@f0004000 {
diff --git a/arch/arm/mach-at91/sama5d3.c b/arch/arm/mach-at91/sama5d3.c
index 3426098..ae58fea 100644
--- a/arch/arm/mach-at91/sama5d3.c
+++ b/arch/arm/mach-at91/sama5d3.c
@@ -21,349 +21,6 @@
 #include "generic.h"
 #include "sam9_smc.h"
 
-#if defined(CONFIG_OLD_CLK_AT91)
-#include "clock.h"
-/* --------------------------------------------------------------------
- *  Clocks
- * -------------------------------------------------------------------- */
-
-/*
- * The peripheral clocks.
- */
-
-static struct clk pioA_clk = {
-	.name		= "pioA_clk",
-	.pid		= SAMA5D3_ID_PIOA,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk pioB_clk = {
-	.name		= "pioB_clk",
-	.pid		= SAMA5D3_ID_PIOB,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk pioC_clk = {
-	.name		= "pioC_clk",
-	.pid		= SAMA5D3_ID_PIOC,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk pioD_clk = {
-	.name		= "pioD_clk",
-	.pid		= SAMA5D3_ID_PIOD,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk pioE_clk = {
-	.name		= "pioE_clk",
-	.pid		= SAMA5D3_ID_PIOE,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk usart0_clk = {
-	.name		= "usart0_clk",
-	.pid		= SAMA5D3_ID_USART0,
-	.type		= CLK_TYPE_PERIPHERAL,
-	.div		= AT91_PMC_PCR_DIV2,
-};
-static struct clk usart1_clk = {
-	.name		= "usart1_clk",
-	.pid		= SAMA5D3_ID_USART1,
-	.type		= CLK_TYPE_PERIPHERAL,
-	.div		= AT91_PMC_PCR_DIV2,
-};
-static struct clk usart2_clk = {
-	.name		= "usart2_clk",
-	.pid		= SAMA5D3_ID_USART2,
-	.type		= CLK_TYPE_PERIPHERAL,
-	.div		= AT91_PMC_PCR_DIV2,
-};
-static struct clk usart3_clk = {
-	.name		= "usart3_clk",
-	.pid		= SAMA5D3_ID_USART3,
-	.type		= CLK_TYPE_PERIPHERAL,
-	.div		= AT91_PMC_PCR_DIV2,
-};
-static struct clk uart0_clk = {
-	.name		= "uart0_clk",
-	.pid		= SAMA5D3_ID_UART0,
-	.type		= CLK_TYPE_PERIPHERAL,
-	.div		= AT91_PMC_PCR_DIV2,
-};
-static struct clk uart1_clk = {
-	.name		= "uart1_clk",
-	.pid		= SAMA5D3_ID_UART1,
-	.type		= CLK_TYPE_PERIPHERAL,
-	.div		= AT91_PMC_PCR_DIV2,
-};
-static struct clk twi0_clk = {
-	.name		= "twi0_clk",
-	.pid		= SAMA5D3_ID_TWI0,
-	.type		= CLK_TYPE_PERIPHERAL,
-	.div		= AT91_PMC_PCR_DIV2,
-};
-static struct clk twi1_clk = {
-	.name		= "twi1_clk",
-	.pid		= SAMA5D3_ID_TWI1,
-	.type		= CLK_TYPE_PERIPHERAL,
-	.div		= AT91_PMC_PCR_DIV2,
-};
-static struct clk twi2_clk = {
-	.name		= "twi2_clk",
-	.pid		= SAMA5D3_ID_TWI2,
-	.type		= CLK_TYPE_PERIPHERAL,
-	.div		= AT91_PMC_PCR_DIV2,
-};
-static struct clk mmc0_clk = {
-	.name		= "mci0_clk",
-	.pid		= SAMA5D3_ID_HSMCI0,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk mmc1_clk = {
-	.name		= "mci1_clk",
-	.pid		= SAMA5D3_ID_HSMCI1,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk mmc2_clk = {
-	.name		= "mci2_clk",
-	.pid		= SAMA5D3_ID_HSMCI2,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk spi0_clk = {
-	.name		= "spi0_clk",
-	.pid		= SAMA5D3_ID_SPI0,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk spi1_clk = {
-	.name		= "spi1_clk",
-	.pid		= SAMA5D3_ID_SPI1,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk tcb0_clk = {
-	.name		= "tcb0_clk",
-	.pid		= SAMA5D3_ID_TC0,
-	.type		= CLK_TYPE_PERIPHERAL,
-	.div		= AT91_PMC_PCR_DIV2,
-};
-static struct clk tcb1_clk = {
-	.name		= "tcb1_clk",
-	.pid		= SAMA5D3_ID_TC1,
-	.type		= CLK_TYPE_PERIPHERAL,
-	.div		= AT91_PMC_PCR_DIV2,
-};
-static struct clk adc_clk = {
-	.name		= "adc_clk",
-	.pid		= SAMA5D3_ID_ADC,
-	.type		= CLK_TYPE_PERIPHERAL,
-	.div		= AT91_PMC_PCR_DIV2,
-};
-static struct clk adc_op_clk = {
-	.name		= "adc_op_clk",
-	.type		= CLK_TYPE_PERIPHERAL,
-	.rate_hz	= 5000000,
-};
-static struct clk dma0_clk = {
-	.name		= "dma0_clk",
-	.pid		= SAMA5D3_ID_DMA0,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk dma1_clk = {
-	.name		= "dma1_clk",
-	.pid		= SAMA5D3_ID_DMA1,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk uhphs_clk = {
-	.name		= "uhphs",
-	.pid		= SAMA5D3_ID_UHPHS,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk udphs_clk = {
-	.name		= "udphs_clk",
-	.pid		= SAMA5D3_ID_UDPHS,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-/* gmac only for sama5d33, sama5d34, sama5d35 */
-static struct clk macb0_clk = {
-	.name		= "macb0_clk",
-	.pid		= SAMA5D3_ID_GMAC,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-/* emac only for sama5d31, sama5d35 */
-static struct clk macb1_clk = {
-	.name		= "macb1_clk",
-	.pid		= SAMA5D3_ID_EMAC,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-/* lcd only for sama5d31, sama5d33, sama5d34 */
-static struct clk lcdc_clk = {
-	.name		= "lcdc_clk",
-	.pid		= SAMA5D3_ID_LCDC,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-/* isi only for sama5d33, sama5d35 */
-static struct clk isi_clk = {
-	.name		= "isi_clk",
-	.pid		= SAMA5D3_ID_ISI,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk can0_clk = {
-	.name		= "can0_clk",
-	.pid		= SAMA5D3_ID_CAN0,
-	.type		= CLK_TYPE_PERIPHERAL,
-	.div		= AT91_PMC_PCR_DIV2,
-};
-static struct clk can1_clk = {
-	.name		= "can1_clk",
-	.pid		= SAMA5D3_ID_CAN1,
-	.type		= CLK_TYPE_PERIPHERAL,
-	.div		= AT91_PMC_PCR_DIV2,
-};
-static struct clk ssc0_clk = {
-	.name		= "ssc0_clk",
-	.pid		= SAMA5D3_ID_SSC0,
-	.type		= CLK_TYPE_PERIPHERAL,
-	.div		= AT91_PMC_PCR_DIV2,
-};
-static struct clk ssc1_clk = {
-	.name		= "ssc1_clk",
-	.pid		= SAMA5D3_ID_SSC1,
-	.type		= CLK_TYPE_PERIPHERAL,
-	.div		= AT91_PMC_PCR_DIV2,
-};
-static struct clk sha_clk = {
-	.name		= "sha_clk",
-	.pid		= SAMA5D3_ID_SHA,
-	.type		= CLK_TYPE_PERIPHERAL,
-	.div		= AT91_PMC_PCR_DIV8,
-};
-static struct clk aes_clk = {
-	.name		= "aes_clk",
-	.pid		= SAMA5D3_ID_AES,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-static struct clk tdes_clk = {
-	.name		= "tdes_clk",
-	.pid		= SAMA5D3_ID_TDES,
-	.type		= CLK_TYPE_PERIPHERAL,
-};
-
-static struct clk *periph_clocks[] __initdata = {
-	&pioA_clk,
-	&pioB_clk,
-	&pioC_clk,
-	&pioD_clk,
-	&pioE_clk,
-	&usart0_clk,
-	&usart1_clk,
-	&usart2_clk,
-	&usart3_clk,
-	&uart0_clk,
-	&uart1_clk,
-	&twi0_clk,
-	&twi1_clk,
-	&twi2_clk,
-	&mmc0_clk,
-	&mmc1_clk,
-	&mmc2_clk,
-	&spi0_clk,
-	&spi1_clk,
-	&tcb0_clk,
-	&tcb1_clk,
-	&adc_clk,
-	&adc_op_clk,
-	&dma0_clk,
-	&dma1_clk,
-	&uhphs_clk,
-	&udphs_clk,
-	&macb0_clk,
-	&macb1_clk,
-	&lcdc_clk,
-	&isi_clk,
-	&can0_clk,
-	&can1_clk,
-	&ssc0_clk,
-	&ssc1_clk,
-	&sha_clk,
-	&aes_clk,
-	&tdes_clk,
-};
-
-static struct clk pck0 = {
-	.name		= "pck0",
-	.pmc_mask	= AT91_PMC_PCK0,
-	.type		= CLK_TYPE_PROGRAMMABLE,
-	.id		= 0,
-};
-
-static struct clk pck1 = {
-	.name		= "pck1",
-	.pmc_mask	= AT91_PMC_PCK1,
-	.type		= CLK_TYPE_PROGRAMMABLE,
-	.id		= 1,
-};
-
-static struct clk pck2 = {
-	.name		= "pck2",
-	.pmc_mask	= AT91_PMC_PCK2,
-	.type		= CLK_TYPE_PROGRAMMABLE,
-	.id		= 2,
-};
-
-static struct clk_lookup periph_clocks_lookups[] = {
-	/* lookup table for DT entries */
-	CLKDEV_CON_DEV_ID("usart", "ffffee00.serial", &mck),
-	CLKDEV_CON_DEV_ID(NULL, "fffff200.gpio", &pioA_clk),
-	CLKDEV_CON_DEV_ID(NULL, "fffff400.gpio", &pioB_clk),
-	CLKDEV_CON_DEV_ID(NULL, "fffff600.gpio", &pioC_clk),
-	CLKDEV_CON_DEV_ID(NULL, "fffff800.gpio", &pioD_clk),
-	CLKDEV_CON_DEV_ID(NULL, "fffffa00.gpio", &pioE_clk),
-	CLKDEV_CON_DEV_ID("usart", "f001c000.serial", &usart0_clk),
-	CLKDEV_CON_DEV_ID("usart", "f0020000.serial", &usart1_clk),
-	CLKDEV_CON_DEV_ID("usart", "f8020000.serial", &usart2_clk),
-	CLKDEV_CON_DEV_ID("usart", "f8024000.serial", &usart3_clk),
-	CLKDEV_CON_DEV_ID(NULL, "f0014000.i2c", &twi0_clk),
-	CLKDEV_CON_DEV_ID(NULL, "f0018000.i2c", &twi1_clk),
-	CLKDEV_CON_DEV_ID(NULL, "f801c000.i2c", &twi2_clk),
-	CLKDEV_CON_DEV_ID("mci_clk", "f0000000.mmc", &mmc0_clk),
-	CLKDEV_CON_DEV_ID("mci_clk", "f8000000.mmc", &mmc1_clk),
-	CLKDEV_CON_DEV_ID("mci_clk", "f8004000.mmc", &mmc2_clk),
-	CLKDEV_CON_DEV_ID("spi_clk", "f0004000.spi", &spi0_clk),
-	CLKDEV_CON_DEV_ID("spi_clk", "f8008000.spi", &spi1_clk),
-	CLKDEV_CON_DEV_ID("t0_clk", "f0010000.timer", &tcb0_clk),
-	CLKDEV_CON_DEV_ID("t0_clk", "f8014000.timer", &tcb1_clk),
-	CLKDEV_CON_DEV_ID("tsc_clk", "f8018000.tsadcc", &adc_clk),
-	CLKDEV_CON_DEV_ID("dma_clk", "ffffe600.dma-controller", &dma0_clk),
-	CLKDEV_CON_DEV_ID("dma_clk", "ffffe800.dma-controller", &dma1_clk),
-	CLKDEV_CON_DEV_ID("hclk", "600000.ohci", &uhphs_clk),
-	CLKDEV_CON_DEV_ID("ohci_clk", "600000.ohci", &uhphs_clk),
-	CLKDEV_CON_DEV_ID("ehci_clk", "700000.ehci", &uhphs_clk),
-	CLKDEV_CON_DEV_ID("pclk", "500000.gadget", &udphs_clk),
-	CLKDEV_CON_DEV_ID("hclk", "500000.gadget", &utmi_clk),
-	CLKDEV_CON_DEV_ID("hclk", "f0028000.ethernet", &macb0_clk),
-	CLKDEV_CON_DEV_ID("pclk", "f0028000.ethernet", &macb0_clk),
-	CLKDEV_CON_DEV_ID("hclk", "f802c000.ethernet", &macb1_clk),
-	CLKDEV_CON_DEV_ID("pclk", "f802c000.ethernet", &macb1_clk),
-	CLKDEV_CON_DEV_ID("pclk", "f0008000.ssc", &ssc0_clk),
-	CLKDEV_CON_DEV_ID("pclk", "f000c000.ssc", &ssc1_clk),
-	CLKDEV_CON_DEV_ID("can_clk", "f000c000.can", &can0_clk),
-	CLKDEV_CON_DEV_ID("can_clk", "f8010000.can", &can1_clk),
-	CLKDEV_CON_DEV_ID("sha_clk", "f8034000.sha", &sha_clk),
-	CLKDEV_CON_DEV_ID("aes_clk", "f8038000.aes", &aes_clk),
-	CLKDEV_CON_DEV_ID("tdes_clk", "f803c000.tdes", &tdes_clk),
-};
-
-static void __init sama5d3_register_clocks(void)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(periph_clocks); i++)
-		clk_register(periph_clocks[i]);
-
-	clkdev_add_table(periph_clocks_lookups,
-			 ARRAY_SIZE(periph_clocks_lookups));
-
-	clk_register(&pck0);
-	clk_register(&pck1);
-	clk_register(&pck2);
-}
-#endif
-
 /* --------------------------------------------------------------------
  *  AT91SAM9x5 processor initialization
  * -------------------------------------------------------------------- */
@@ -375,7 +32,4 @@ static void __init sama5d3_map_io(void)
 
 AT91_SOC_START(sama5d3)
 	.map_io = sama5d3_map_io,
-#if defined(CONFIG_OLD_CLK_AT91)
-	.register_clocks = sama5d3_register_clocks,
-#endif
 AT91_SOC_END
-- 
1.7.9.5

