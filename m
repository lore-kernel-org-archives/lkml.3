Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935182Ab3GWWfJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:35:09 -0400
Received: from 10.mo5.mail-out.ovh.net ([46.105.52.148]:38248 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934671Ab3GWWfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:35:03 -0400
Message-ID: <51EF03CC.2080303@overkiz.com>
Date: Wed, 24 Jul 2013 00:29:32 +0200
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Boris BREZILLON <b.brezillon@overkiz.com>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Mike Turquette <mturquette@linaro.org>,
        Andrew Victor <linux@maxim.org.za>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: Re: [PATCH v2 17/42] ARM: at91: move at91sam9g45 SoC to new at91
 clk implem
References: <1374068069-13496-1-git-send-email-b.brezillon@overkiz.com> <1374072548-19702-1-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1374072548-19702-1-git-send-email-b.brezillon@overkiz.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 289919226067581049
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -85
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrfeekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenogetfedtuddqtdduucdludehmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -85
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrfeekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenogetfedtuddqtdduucdludehmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 17/07/2013 16:49, Boris BREZILLON a écrit :
> This patch removes all references to the old at91 clks implementation and
> make use of the new at91 clk implem for at91sam9g45 SoC.
>
> All dt specific lookups are removed (handled in clk device tree binding).
>
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
> ---
>   arch/arm/mach-at91/at91sam9g45.c         |  702 ++++++++++++++++++------------
>   arch/arm/mach-at91/at91sam9g45_devices.c |    1 -
>   2 files changed, 424 insertions(+), 279 deletions(-)
>
> diff --git a/arch/arm/mach-at91/at91sam9g45.c b/arch/arm/mach-at91/at91sam9g45.c
> index 29ba2ca..a24915a 100644
> --- a/arch/arm/mach-at91/at91sam9g45.c
> +++ b/arch/arm/mach-at91/at91sam9g45.c
> @@ -24,7 +24,6 @@
>   #include "at91_aic.h"
>   #include "soc.h"
>   #include "generic.h"
> -#include "clock.h"
>   #include "sam9_smc.h"
>   
>   /* --------------------------------------------------------------------
> @@ -34,299 +33,446 @@
>   /*
>    * The peripheral clocks.
>    */
> -static struct clk pioA_clk = {
> -	.name		= "pioA_clk",
> -	.pmc_mask	= 1 << AT91SAM9G45_ID_PIOA,
> -	.type		= CLK_TYPE_PERIPHERAL,
> -};
> -static struct clk pioB_clk = {
> -	.name		= "pioB_clk",
> -	.pmc_mask	= 1 << AT91SAM9G45_ID_PIOB,
> -	.type		= CLK_TYPE_PERIPHERAL,
> -};
> -static struct clk pioC_clk = {
> -	.name		= "pioC_clk",
> -	.pmc_mask	= 1 << AT91SAM9G45_ID_PIOC,
> -	.type		= CLK_TYPE_PERIPHERAL,
> -};
> -static struct clk pioDE_clk = {
> -	.name		= "pioDE_clk",
> -	.pmc_mask	= 1 << AT91SAM9G45_ID_PIODE,
> -	.type		= CLK_TYPE_PERIPHERAL,
> -};
> -static struct clk trng_clk = {
> -	.name		= "trng_clk",
> -	.pmc_mask	= 1 << AT91SAM9G45_ID_TRNG,
> -	.type		= CLK_TYPE_PERIPHERAL,
> -};
> -static struct clk usart0_clk = {
> -	.name		= "usart0_clk",
> -	.pmc_mask	= 1 << AT91SAM9G45_ID_US0,
> -	.type		= CLK_TYPE_PERIPHERAL,
> -};
> -static struct clk usart1_clk = {
> -	.name		= "usart1_clk",
> -	.pmc_mask	= 1 << AT91SAM9G45_ID_US1,
> -	.type		= CLK_TYPE_PERIPHERAL,
> -};
> -static struct clk usart2_clk = {
> -	.name		= "usart2_clk",
> -	.pmc_mask	= 1 << AT91SAM9G45_ID_US2,
> -	.type		= CLK_TYPE_PERIPHERAL,
> -};
> -static struct clk usart3_clk = {
> -	.name		= "usart3_clk",
> -	.pmc_mask	= 1 << AT91SAM9G45_ID_US3,
> -	.type		= CLK_TYPE_PERIPHERAL,
> -};
> -static struct clk mmc0_clk = {
> -	.name		= "mci0_clk",
> -	.pmc_mask	= 1 << AT91SAM9G45_ID_MCI0,
> -	.type		= CLK_TYPE_PERIPHERAL,
> -};
> -static struct clk twi0_clk = {
> -	.name		= "twi0_clk",
> -	.pmc_mask	= 1 << AT91SAM9G45_ID_TWI0,
> -	.type		= CLK_TYPE_PERIPHERAL,
> -};
> -static struct clk twi1_clk = {
> -	.name		= "twi1_clk",
> -	.pmc_mask	= 1 << AT91SAM9G45_ID_TWI1,
> -	.type		= CLK_TYPE_PERIPHERAL,
> -};
> -static struct clk spi0_clk = {
> -	.name		= "spi0_clk",
> -	.pmc_mask	= 1 << AT91SAM9G45_ID_SPI0,
> -	.type		= CLK_TYPE_PERIPHERAL,
> -};
> -static struct clk spi1_clk = {
> -	.name		= "spi1_clk",
> -	.pmc_mask	= 1 << AT91SAM9G45_ID_SPI1,
> -	.type		= CLK_TYPE_PERIPHERAL,
> -};
> -static struct clk ssc0_clk = {
> -	.name		= "ssc0_clk",
> -	.pmc_mask	= 1 << AT91SAM9G45_ID_SSC0,
> -	.type		= CLK_TYPE_PERIPHERAL,
> -};
> -static struct clk ssc1_clk = {
> -	.name		= "ssc1_clk",
> -	.pmc_mask	= 1 << AT91SAM9G45_ID_SSC1,
> -	.type		= CLK_TYPE_PERIPHERAL,
> -};
> -static struct clk tcb0_clk = {
> -	.name		= "tcb0_clk",
> -	.pmc_mask	= 1 << AT91SAM9G45_ID_TCB,
> -	.type		= CLK_TYPE_PERIPHERAL,
> -};
> -static struct clk pwm_clk = {
> -	.name		= "pwm_clk",
> -	.pmc_mask	= 1 << AT91SAM9G45_ID_PWMC,
> -	.type		= CLK_TYPE_PERIPHERAL,
> -};
> -static struct clk tsc_clk = {
> -	.name		= "tsc_clk",
> -	.pmc_mask	= 1 << AT91SAM9G45_ID_TSC,
> -	.type		= CLK_TYPE_PERIPHERAL,
> -};
> -static struct clk dma_clk = {
> -	.name		= "dma_clk",
> -	.pmc_mask	= 1 << AT91SAM9G45_ID_DMA,
> -	.type		= CLK_TYPE_PERIPHERAL,
> -};
> -static struct clk uhphs_clk = {
> -	.name		= "uhphs_clk",
> -	.pmc_mask	= 1 << AT91SAM9G45_ID_UHPHS,
> -	.type		= CLK_TYPE_PERIPHERAL,
> -};
> -static struct clk lcdc_clk = {
> -	.name		= "lcdc_clk",
> -	.pmc_mask	= 1 << AT91SAM9G45_ID_LCDC,
> -	.type		= CLK_TYPE_PERIPHERAL,
> -};
> -static struct clk ac97_clk = {
> -	.name		= "ac97_clk",
> -	.pmc_mask	= 1 << AT91SAM9G45_ID_AC97C,
> -	.type		= CLK_TYPE_PERIPHERAL,
> -};
> -static struct clk macb_clk = {
> -	.name		= "pclk",
> -	.pmc_mask	= 1 << AT91SAM9G45_ID_EMAC,
> -	.type		= CLK_TYPE_PERIPHERAL,
> -};
> -static struct clk isi_clk = {
> -	.name		= "isi_clk",
> -	.pmc_mask	= 1 << AT91SAM9G45_ID_ISI,
> -	.type		= CLK_TYPE_PERIPHERAL,
> -};
> -static struct clk udphs_clk = {
> -	.name		= "udphs_clk",
> -	.pmc_mask	= 1 << AT91SAM9G45_ID_UDPHS,
> -	.type		= CLK_TYPE_PERIPHERAL,
> -};
> -static struct clk mmc1_clk = {
> -	.name		= "mci1_clk",
> -	.pmc_mask	= 1 << AT91SAM9G45_ID_MCI1,
> -	.type		= CLK_TYPE_PERIPHERAL,
> -};
> -
> -/* Video decoder clock - Only for sam9m10/sam9m11 */
> -static struct clk vdec_clk = {
> -	.name		= "vdec_clk",
> -	.pmc_mask	= 1 << AT91SAM9G45_ID_VDEC,
> -	.type		= CLK_TYPE_PERIPHERAL,
> -};
> -
> -static struct clk adc_op_clk = {
> -	.name		= "adc_op_clk",
> -	.type		= CLK_TYPE_PERIPHERAL,
> -	.rate_hz	= 13200000,
> -};
> -
> -/* AES/TDES/SHA clock - Only for sam9m11/sam9g56 */
> -static struct clk aestdessha_clk = {
> -	.name		= "aestdessha_clk",
> -	.pmc_mask	= 1 << AT91SAM9G45_ID_AESTDESSHA,
> -	.type		= CLK_TYPE_PERIPHERAL,
> -};
> -
> -static struct clk *periph_clocks[] __initdata = {
> -	&pioA_clk,
> -	&pioB_clk,
> -	&pioC_clk,
> -	&pioDE_clk,
> -	&trng_clk,
> -	&usart0_clk,
> -	&usart1_clk,
> -	&usart2_clk,
> -	&usart3_clk,
> -	&mmc0_clk,
> -	&twi0_clk,
> -	&twi1_clk,
> -	&spi0_clk,
> -	&spi1_clk,
> -	&ssc0_clk,
> -	&ssc1_clk,
> -	&tcb0_clk,
> -	&pwm_clk,
> -	&tsc_clk,
> -	&dma_clk,
> -	&uhphs_clk,
> -	&lcdc_clk,
> -	&ac97_clk,
> -	&macb_clk,
> -	&isi_clk,
> -	&udphs_clk,
> -	&mmc1_clk,
> -	&adc_op_clk,
> -	&aestdessha_clk,
> -	// irq0
> -};
> -
> -static struct clk_lookup periph_clocks_lookups[] = {
> -	/* One additional fake clock for macb_hclk */
> -	CLKDEV_CON_ID("hclk", &macb_clk),
> -	/* One additional fake clock for ohci */
> -	CLKDEV_CON_ID("ohci_clk", &uhphs_clk),
> -	CLKDEV_CON_DEV_ID("hclk", "at91sam9g45-lcdfb.0", &lcdc_clk),
> -	CLKDEV_CON_DEV_ID("hclk", "at91sam9g45es-lcdfb.0", &lcdc_clk),
> -	CLKDEV_CON_DEV_ID("ehci_clk", "atmel-ehci", &uhphs_clk),
> -	CLKDEV_CON_DEV_ID("hclk", "atmel_usba_udc", &utmi_clk),
> -	CLKDEV_CON_DEV_ID("pclk", "atmel_usba_udc", &udphs_clk),
> -	CLKDEV_CON_DEV_ID("mci_clk", "atmel_mci.0", &mmc0_clk),
> -	CLKDEV_CON_DEV_ID("mci_clk", "atmel_mci.1", &mmc1_clk),
> -	CLKDEV_CON_DEV_ID("spi_clk", "atmel_spi.0", &spi0_clk),
> -	CLKDEV_CON_DEV_ID("spi_clk", "atmel_spi.1", &spi1_clk),
> -	CLKDEV_CON_DEV_ID("t0_clk", "atmel_tcb.0", &tcb0_clk),
> -	CLKDEV_CON_DEV_ID("t0_clk", "atmel_tcb.1", &tcb0_clk),
> -	CLKDEV_CON_DEV_ID(NULL, "i2c-at91sam9g10.0", &twi0_clk),
> -	CLKDEV_CON_DEV_ID(NULL, "i2c-at91sam9g10.1", &twi1_clk),
> -	CLKDEV_CON_DEV_ID("pclk", "at91sam9g45_ssc.0", &ssc0_clk),
> -	CLKDEV_CON_DEV_ID("pclk", "at91sam9g45_ssc.1", &ssc1_clk),
> -	CLKDEV_CON_DEV_ID("pclk", "fff9c000.ssc", &ssc0_clk),
> -	CLKDEV_CON_DEV_ID("pclk", "fffa0000.ssc", &ssc1_clk),
> -	CLKDEV_CON_DEV_ID(NULL, "atmel-trng", &trng_clk),
> -	CLKDEV_CON_DEV_ID(NULL, "atmel_sha", &aestdessha_clk),
> -	CLKDEV_CON_DEV_ID(NULL, "atmel_tdes", &aestdessha_clk),
> -	CLKDEV_CON_DEV_ID(NULL, "atmel_aes", &aestdessha_clk),
> -	/* more usart lookup table for DT entries */
> -	CLKDEV_CON_DEV_ID("usart", "ffffee00.serial", &mck),
> -	CLKDEV_CON_DEV_ID("usart", "fff8c000.serial", &usart0_clk),
> -	CLKDEV_CON_DEV_ID("usart", "fff90000.serial", &usart1_clk),
> -	CLKDEV_CON_DEV_ID("usart", "fff94000.serial", &usart2_clk),
> -	CLKDEV_CON_DEV_ID("usart", "fff98000.serial", &usart3_clk),
> -	/* more tc lookup table for DT entries */
> -	CLKDEV_CON_DEV_ID("t0_clk", "fff7c000.timer", &tcb0_clk),
> -	CLKDEV_CON_DEV_ID("t0_clk", "fffd4000.timer", &tcb0_clk),
> -	CLKDEV_CON_DEV_ID("hclk", "700000.ohci", &uhphs_clk),
> -	CLKDEV_CON_DEV_ID("ehci_clk", "800000.ehci", &uhphs_clk),
> -	CLKDEV_CON_DEV_ID("mci_clk", "fff80000.mmc", &mmc0_clk),
> -	CLKDEV_CON_DEV_ID("mci_clk", "fffd0000.mmc", &mmc1_clk),
> -	CLKDEV_CON_DEV_ID(NULL, "fff84000.i2c", &twi0_clk),
> -	CLKDEV_CON_DEV_ID(NULL, "fff88000.i2c", &twi1_clk),
> -	CLKDEV_CON_DEV_ID("spi_clk", "fffa4000.spi", &spi0_clk),
> -	CLKDEV_CON_DEV_ID("spi_clk", "fffa8000.spi", &spi1_clk),
> -	CLKDEV_CON_DEV_ID("hclk", "600000.gadget", &utmi_clk),
> -	CLKDEV_CON_DEV_ID("pclk", "600000.gadget", &udphs_clk),
> -	/* fake hclk clock */
> -	CLKDEV_CON_DEV_ID("hclk", "at91_ohci", &uhphs_clk),
> -	CLKDEV_CON_DEV_ID(NULL, "fffff200.gpio", &pioA_clk),
> -	CLKDEV_CON_DEV_ID(NULL, "fffff400.gpio", &pioB_clk),
> -	CLKDEV_CON_DEV_ID(NULL, "fffff600.gpio", &pioC_clk),
> -	CLKDEV_CON_DEV_ID(NULL, "fffff800.gpio", &pioDE_clk),
> -	CLKDEV_CON_DEV_ID(NULL, "fffffa00.gpio", &pioDE_clk),
> -
> -	CLKDEV_CON_ID("pioA", &pioA_clk),
> -	CLKDEV_CON_ID("pioB", &pioB_clk),
> -	CLKDEV_CON_ID("pioC", &pioC_clk),
> -	CLKDEV_CON_ID("pioD", &pioDE_clk),
> -	CLKDEV_CON_ID("pioE", &pioDE_clk),
> -	/* Fake adc clock */
> -	CLKDEV_CON_ID("adc_clk", &tsc_clk),
> -};
> -
> -static struct clk_lookup usart_clocks_lookups[] = {
> -	CLKDEV_CON_DEV_ID("usart", "atmel_usart.0", &mck),
> -	CLKDEV_CON_DEV_ID("usart", "atmel_usart.1", &usart0_clk),
> -	CLKDEV_CON_DEV_ID("usart", "atmel_usart.2", &usart1_clk),
> -	CLKDEV_CON_DEV_ID("usart", "atmel_usart.3", &usart2_clk),
> -	CLKDEV_CON_DEV_ID("usart", "atmel_usart.4", &usart3_clk),
> +static struct clk_lookup pioA_clk_lookup[] = {
> +	CLKDEV_INIT(NULL, "pioA_clk", NULL),
> +	CLKDEV_INIT(NULL, "pioA", NULL),
> +};
> +
> +static struct clk_lookup pioB_clk_lookup[] = {
> +	CLKDEV_INIT(NULL, "pioB_clk", NULL),
> +	CLKDEV_INIT(NULL, "pioB", NULL),
> +};
> +
> +static struct clk_lookup pioC_clk_lookup[] = {
> +	CLKDEV_INIT(NULL, "pioC_clk", NULL),
> +	CLKDEV_INIT(NULL, "pioC", NULL),
> +};
> +
> +static struct clk_lookup pioDE_clk_lookup[] = {
> +	CLKDEV_INIT(NULL, "pioDE_clk", NULL),
> +	CLKDEV_INIT(NULL, "pioD", NULL),
> +	CLKDEV_INIT(NULL, "pioE", NULL),
> +};
> +
> +static struct clk_lookup trng_clk_lookup[] = {
> +	CLKDEV_INIT(NULL, "trng_clk", NULL),
> +	CLKDEV_INIT("atmel-trng", NULL, NULL),
> +};
> +
> +static struct clk_lookup usart0_clk_lookup[] = {
> +	CLKDEV_INIT(NULL, "usart0_clk", NULL),
> +	CLKDEV_INIT("atmel_usart.1", "usart", NULL),
> +};
> +
> +static struct clk_lookup usart1_clk_lookup[] = {
> +	CLKDEV_INIT(NULL, "usart1_clk", NULL),
> +	CLKDEV_INIT("atmel_usart.2", "usart", NULL),
> +};
> +
> +static struct clk_lookup usart2_clk_lookup[] = {
> +	CLKDEV_INIT(NULL, "usart2_clk", NULL),
> +	CLKDEV_INIT("atmel_usart.3", "usart", NULL),
> +};
> +
> +static struct clk_lookup usart3_clk_lookup[] = {
> +	CLKDEV_INIT(NULL, "usart3_clk", NULL),
> +	CLKDEV_INIT("atmel_usart.4", "usart", NULL),
> +};
> +
> +static struct clk_lookup mci0_clk_lookup[] = {
> +	CLKDEV_INIT(NULL, "mci0_clk", NULL),
> +	CLKDEV_INIT("atmel_mci.0", "mci_clk", NULL),
> +};
> +
> +static struct clk_lookup twi0_clk_lookup[] = {
> +	CLKDEV_INIT(NULL, "twi0_clk", NULL),
> +	CLKDEV_INIT("i2c-at91sam9g10.0", NULL, NULL),
> +};
> +
> +static struct clk_lookup twi1_clk_lookup[] = {
> +	CLKDEV_INIT(NULL, "twi1_clk", NULL),
> +	CLKDEV_INIT("i2c-at91sam9g10.1", NULL, NULL),
> +};
> +
> +static struct clk_lookup spi0_clk_lookup[] = {
> +	CLKDEV_INIT(NULL, "spi0_clk", NULL),
> +	CLKDEV_INIT("atmel_spi.0", "spi_clk", NULL),
> +};
> +
> +static struct clk_lookup spi1_clk_lookup[] = {
> +	CLKDEV_INIT(NULL, "spi0_clk", NULL),
> +	CLKDEV_INIT("atmel_spi.1", "spi_clk", NULL),
> +};
> +
> +static struct clk_lookup ssc0_clk_lookup[] = {
> +	CLKDEV_INIT(NULL, "ssc0_clk", NULL),
> +	CLKDEV_INIT("at91sam9g45_ssc.0", "pclk", NULL),
> +};
> +
> +static struct clk_lookup ssc1_clk_lookup[] = {
> +	CLKDEV_INIT(NULL, "ssc1_clk", NULL),
> +	CLKDEV_INIT("at91sam9g45_ssc.0", "pclk", NULL),
> +};
> +
> +static struct clk_lookup tcb0_clk_lookup[] = {
> +	CLKDEV_INIT(NULL, "tcb0_clk", NULL),
> +	CLKDEV_INIT("atmel_tcb.0", "t0_clk", NULL),
> +	CLKDEV_INIT("atmel_tcb.1", "t0_clk", NULL),
> +};
> +
> +static struct clk_lookup pwm_clk_lookup[] = {
> +	CLKDEV_INIT(NULL, "pwm_clk", NULL),
> +};
> +
> +static struct clk_lookup tsc_clk_lookup[] = {
> +	CLKDEV_INIT(NULL, "tsc_clk", NULL),
> +	CLKDEV_INIT("adc_clk", NULL, NULL),
> +};
> +
> +static struct clk_lookup dma_clk_lookup[] = {
> +	CLKDEV_INIT(NULL, "dma_clk", NULL),
> +};
> +
> +static struct clk_lookup uhphs_clk_lookup[] = {
> +	CLKDEV_INIT(NULL, "uhphs_clk", NULL),
> +	CLKDEV_INIT(NULL, "ohci_clk", NULL),
> +	CLKDEV_INIT("atmel-ehci", "ehci_clk", NULL),
> +	CLKDEV_INIT("at91_ohci", "hclk", NULL),
> +};
> +
> +static struct clk_lookup lcdc_clk_lookup[] = {
> +	CLKDEV_INIT(NULL, "lcdc_clk", NULL),
> +	CLKDEV_INIT("hclk", "at91sam9g45-lcdfb.0", NULL),
> +	CLKDEV_INIT("hclk", "at91sam9g45es-lcdfb.0", NULL),
> +};
> +
> +static struct clk_lookup ac97_clk_lookup[] = {
> +	CLKDEV_INIT(NULL, "ac97_clk", NULL),
> +};
> +
> +static struct clk_lookup macb_clk_lookup[] = {
> +	CLKDEV_INIT(NULL, "pclk", NULL),
> +	CLKDEV_INIT(NULL, "hclk", NULL),
> +};
> +
> +static struct clk_lookup isi_clk_lookup[] = {
> +	CLKDEV_INIT(NULL, "isi_clk", NULL),
> +};
> +
> +static struct clk_lookup udphs_clk_lookup[] = {
> +	CLKDEV_INIT(NULL, "udphs_clk", NULL),
> +	CLKDEV_INIT("atmel_usba_udc", "pclk", NULL),
> +};
> +
> +static struct clk_lookup aestdessha_clk_lookup[] = {
> +	CLKDEV_INIT("atmel_sha", NULL, NULL),
> +	CLKDEV_INIT("atmel_tdes", NULL, NULL),
> +	CLKDEV_INIT("atmel_aes", NULL, NULL),
> +};
> +
> +static struct clk_lookup mci1_clk_lookup[] = {
> +	CLKDEV_INIT(NULL, "mci1_clk", NULL),
> +	CLKDEV_INIT("atmel_mci.1", "mci_clk", NULL),
> +};
> +
> +static struct clk_lookup vdec_clk_lookup[] = {
> +	CLKDEV_INIT(NULL, "vdec_clk", NULL),
> +};
> +
> +static size_t periph_clock_lookup_sizes[] __initdata = {
> +	0,
> +	0,
> +	ARRAY_SIZE(pioA_clk_lookup),
> +	ARRAY_SIZE(pioB_clk_lookup),
> +	ARRAY_SIZE(pioC_clk_lookup),
> +	ARRAY_SIZE(pioDE_clk_lookup),
> +	ARRAY_SIZE(trng_clk_lookup),
> +	ARRAY_SIZE(usart0_clk_lookup),
> +	ARRAY_SIZE(usart1_clk_lookup),
> +	ARRAY_SIZE(usart2_clk_lookup),
> +	ARRAY_SIZE(usart3_clk_lookup),
> +	ARRAY_SIZE(mci0_clk_lookup),
> +	ARRAY_SIZE(twi0_clk_lookup),
> +	ARRAY_SIZE(twi1_clk_lookup),
> +	ARRAY_SIZE(spi0_clk_lookup),
> +	ARRAY_SIZE(spi1_clk_lookup),
> +	ARRAY_SIZE(ssc0_clk_lookup),
> +	ARRAY_SIZE(ssc1_clk_lookup),
> +	ARRAY_SIZE(tcb0_clk_lookup),
> +	ARRAY_SIZE(pwm_clk_lookup),
> +	ARRAY_SIZE(tsc_clk_lookup),
> +	ARRAY_SIZE(dma_clk_lookup),
> +	ARRAY_SIZE(uhphs_clk_lookup),
> +	ARRAY_SIZE(lcdc_clk_lookup),
> +	ARRAY_SIZE(ac97_clk_lookup),
> +	ARRAY_SIZE(macb_clk_lookup),
> +	ARRAY_SIZE(isi_clk_lookup),
> +	ARRAY_SIZE(udphs_clk_lookup),
> +	0,
> +	ARRAY_SIZE(mci1_clk_lookup),
> +};
> +
> +static struct clk_lookup *periph_clock_lookups[] __initdata = {
> +	NULL,
> +	NULL,
> +	pioA_clk_lookup,
> +	pioB_clk_lookup,
> +	pioC_clk_lookup,
> +	pioDE_clk_lookup,
> +	trng_clk_lookup,
> +	usart0_clk_lookup,
> +	usart1_clk_lookup,
> +	usart2_clk_lookup,
> +	usart3_clk_lookup,
> +	mci0_clk_lookup,
> +	twi0_clk_lookup,
> +	twi1_clk_lookup,
> +	spi0_clk_lookup,
> +	spi1_clk_lookup,
> +	ssc0_clk_lookup,
> +	ssc1_clk_lookup,
> +	tcb0_clk_lookup,
> +	pwm_clk_lookup,
> +	tsc_clk_lookup,
> +	dma_clk_lookup,
> +	uhphs_clk_lookup,
> +	lcdc_clk_lookup,
> +	ac97_clk_lookup,
> +	macb_clk_lookup,
> +	isi_clk_lookup,
> +	udphs_clk_lookup,
> +	NULL,
> +	mci1_clk_lookup,
> +};
> +
> +
> +/*
> + * The system clocks.
> + */
> +static struct clk_lookup ddr_clk_lookup[] = {
> +	CLKDEV_INIT(NULL, "ddrck", NULL),
> +};
> +
> +static struct clk_lookup uhp_clk_lookup[] = {
> +	CLKDEV_INIT(NULL, "uhpck", NULL),
> +};
> +
> +static struct clk_lookup pck0_clk_lookup[] = {
> +	CLKDEV_INIT(NULL, "pck0", NULL),
> +};
> +
> +static struct clk_lookup pck1_clk_lookup[] = {
> +	CLKDEV_INIT(NULL, "pck1", NULL),
> +};
> +
> +static size_t system_clock_lookup_sizes[] __initdata = {
> +	0,
> +	0,
> +	ARRAY_SIZE(ddr_clk_lookup),
> +	0,
> +	0,
> +	0,
> +	ARRAY_SIZE(uhp_clk_lookup),
> +	0,
> +	ARRAY_SIZE(pck0_clk_lookup),
> +	ARRAY_SIZE(pck1_clk_lookup),
> +};
> +
> +static struct clk_lookup *system_clock_lookups[] __initdata = {
> +	NULL,
> +	NULL,
> +	ddr_clk_lookup,
> +	NULL,
> +	NULL,
> +	NULL,
> +	uhp_clk_lookup,
> +	NULL,
> +	pck0_clk_lookup,
> +	pck1_clk_lookup,
>   };
>   
>   /*
>    * The two programmable clocks.
>    * You must configure pin multiplexing to bring these signals out.
>    */
> -static struct clk pck0 = {
> -	.name		= "pck0",
> -	.pmc_mask	= AT91_PMC_PCK0,
> -	.type		= CLK_TYPE_PROGRAMMABLE,
> -	.id		= 0,
> +static const char *prog_clock_parent_names[] __initdata = {
> +	"clk32k",
> +	"main",
> +	"plladiv",
> +	"utmi_clk",
> +	"mck",
>   };
> -static struct clk pck1 = {
> -	.name		= "pck1",
> -	.pmc_mask	= AT91_PMC_PCK1,
> -	.type		= CLK_TYPE_PROGRAMMABLE,
> -	.id		= 1,
> +
> +static const char *prog_clock_names[] __initdata = {
> +	"prog0",
> +	"prog1",
> +};
> +
> +/*
> + * The pll clocks.
> + */
> +static struct clk_lookup pll_clk_lookup[] = {
> +	CLKDEV_INIT(NULL, "plla", NULL),
> +};
> +
> +static struct clk_range at91sam9g45_plla_output[] = {
> +	CLK_RANGE(745000000, 800000000),
> +	CLK_RANGE(695000000, 750000000),
> +	CLK_RANGE(645000000, 700000000),
> +	CLK_RANGE(595000000, 650000000),
> +	CLK_RANGE(545000000, 600000000),
> +	CLK_RANGE(495000000, 550000000),
> +	CLK_RANGE(445000000, 500000000),
> +	CLK_RANGE(400000000, 450000000),
> +};
> +static u8 at91sam9g45_plla_out[] = {0, 1, 2, 3, 0, 1, 2, 3};
> +static u16 at91sam9g45_plla_icpll[] = {0, 0, 0, 0, 1, 1, 1, 1};
> +
> +struct clk_pll_characteristics at91sam9g45_plla_characteristics = {
> +	.input = CLK_RANGE(2000000, 32000000),
> +	.num_output = ARRAY_SIZE(at91sam9g45_plla_output),
> +	.output = at91sam9g45_plla_output,
> +	.out = at91sam9g45_plla_out,
> +	.icpll = at91sam9g45_plla_icpll,
> +};
> +
> +
> +/*
> + * The master clock.
> + */
> +static struct clk_lookup mck_clk_lookup[] = {
> +	CLKDEV_INIT(NULL, "mck", NULL),
> +	CLKDEV_INIT("atmel_usart.0", "usart", NULL),
> +};
> +
> +struct clk_master_characteristics at91sam9g45_master_characteristics = {
> +	.output = CLK_RANGE(0, 133000000),
> +	.have_div3_pres = 0,
> +	.divisors = {1, 2, 4, 3},
> +};
> +
> +static const char *master_clock_parent_names[] __initdata = {
> +	"clk32k",
> +	"main",
> +	"plladiv",
> +	"utmi_clk",
> +};
> +
> +/*
> + * UTMI clock.
> + */
> +static struct clk_lookup utmi_clk_lookup[] = {
> +	CLKDEV_INIT(NULL, "utmi_clk", NULL),
> +	CLKDEV_INIT("atmel_usba_udc", "hclk", NULL),
> +};
> +
> +/*
> + * USB clock.
> + */
> +static const char *usb_clock_parent_names[] __initdata = {
> +	"plladiv",
> +	"utmi_clk",
> +};
> +
> +static struct clk_lookup usb_clk_lookup[] = {
> +	CLKDEV_INIT(NULL, "usb_clk", NULL),
>   };
>   
>   static void __init at91sam9g45_register_clocks(void)
>   {
>   	int i;
> +	int k;
> +	size_t size;
> +	struct clk *clk;
> +	const char *name;
> +	struct clk_lookup *lookup;
> +
> +	clk = at91_clk_register_pll("plla", "main", 0,
> +				    &at91sam9g45_pll_layout,
> +				    &at91sam9g45_plla_characteristics);
> +	for (i = 0; i < ARRAY_SIZE(pll_clk_lookup); i++)
> +		pll_clk_lookup[i].clk = clk;
> +	clkdev_add_table(pll_clk_lookup, ARRAY_SIZE(pll_clk_lookup));
> +	clk = at91_clk_register_plldiv("plladiv", "plla");
>   
> -	for (i = 0; i < ARRAY_SIZE(periph_clocks); i++)
> -		clk_register(periph_clocks[i]);
> +	clk = at91_clk_register_utmi("utmi_clk", "main");
> +	for (i = 0; i < ARRAY_SIZE(utmi_clk_lookup); i++)
> +		utmi_clk_lookup[i].clk = clk;
> +	clkdev_add_table(utmi_clk_lookup, ARRAY_SIZE(utmi_clk_lookup));
>   
> -	clkdev_add_table(periph_clocks_lookups,
> -			 ARRAY_SIZE(periph_clocks_lookups));
> -	clkdev_add_table(usart_clocks_lookups,
> -			 ARRAY_SIZE(usart_clocks_lookups));
> +	clk = at91_clk_register_master("mck",
> +				       ARRAY_SIZE(master_clock_parent_names),
> +				       master_clock_parent_names,
> +				       &at91rm9200_master_layout,
> +				       &at91sam9g45_master_characteristics);
> +	for (i = 0; i < ARRAY_SIZE(mck_clk_lookup); i++)
> +		mck_clk_lookup[i].clk = clk;
> +	clkdev_add_table(mck_clk_lookup, ARRAY_SIZE(mck_clk_lookup));
>   
> -	if (cpu_is_at91sam9m10() || cpu_is_at91sam9m11())
> -		clk_register(&vdec_clk);
> +	for (i = 0; i < ARRAY_SIZE(periph_clock_lookup_sizes); i++) {
> +		size = periph_clock_lookup_sizes[i];
> +		lookup = periph_clock_lookups[i];
> +		if (!size || !lookup)
> +			continue;
> +		name = periph_clock_lookups[i][0].con_id;
> +		if (!name)
> +			continue;
> +		clk = at91_clk_register_peripheral(name, "mck", i);
> +
> +		for (k = 0; k < size; k++)
> +			lookup[k].clk = clk;
> +		clkdev_add_table(lookup, size);
> +	}
> +
> +	if (cpu_is_at91sam9m10() || cpu_is_at91sam9m11()) {
> +		clk = at91_clk_register_peripheral(vdec_clk_lookup[0].con_id,
> +						   "mck",
> +						   AT91SAM9G45_ID_VDEC);
> +		for (k = 0; k < ARRAY_SIZE(vdec_clk_lookup); k++)
> +			vdec_clk_lookup[k].clk = clk;
> +		clkdev_add_table(vdec_clk_lookup, ARRAY_SIZE(vdec_clk_lookup));
> +	}
> +
> +	if (cpu_is_at91sam9m11() || cpu_is_at91sam9g46()) {
> +		clk = at91_clk_register_peripheral(vdec_clk_lookup[0].con_id,
> +						   "mck",
> +						   AT91SAM9G45_ID_AESTDESSHA);
There is a bug here. It should be:
clk = at91_clk_register_peripheral(aestdessha_clk_lookup[0].con_id, 
"mck", AT91SAM9G45_ID_AESTDESSHA);
> +		for (k = 0; k < ARRAY_SIZE(aestdessha_clk_lookup); k++)
> +			aestdessha_clk_lookup[k].clk = clk;
> +		clkdev_add_table(vdec_clk_lookup,
> +				 ARRAY_SIZE(aestdessha_clk_lookup));
Same bug here:

clkdev_add_table(aestdessha_clk_lookup, ARRAY_SIZE(aestdessha_clk_lookup));


These bugs will be fixed in next version.
> +	}
> +
> +	for (i = 0; i < ARRAY_SIZE(prog_clock_names); i++) {
> +		name = prog_clock_names[i];
> +		clk = at91_clk_register_programmable(name,
> +					prog_clock_parent_names,
> +					ARRAY_SIZE(prog_clock_parent_names),
> +					i, &at91sam9g45_programmable_layout);
> +	}
> +
> +	clk = at91sam9x5_clk_register_usb("usbck", usb_clock_parent_names,
> +					  ARRAY_SIZE(usb_clock_parent_names),
> +					  0);
> +	for (i = 0; i < ARRAY_SIZE(usb_clk_lookup); i++)
> +		usb_clk_lookup[i].clk = clk;
> +	clkdev_add_table(usb_clk_lookup, ARRAY_SIZE(usb_clk_lookup));
> +
> +	for (i = 0; i < ARRAY_SIZE(system_clock_lookup_sizes); i++) {
> +		size = system_clock_lookup_sizes[i];
> +		lookup = system_clock_lookups[i];
> +		if (!size || !lookup)
> +			continue;
> +		name = system_clock_lookups[i][0].con_id;
> +		if (!name)
> +			continue;
> +		clk = at91_clk_register_system(name, i);
> +		for (k = 0; k < size; k++)
> +			lookup[k].clk = clk;
> +		clkdev_add_table(lookup, size);
> +	}
>   
> -	clk_register(&pck0);
> -	clk_register(&pck1);
> +	clk_register_fixed_rate(NULL, "adc_op_clk", "mck", 0, 13200000);
>   }
>   
>   /* --------------------------------------------------------------------
> diff --git a/arch/arm/mach-at91/at91sam9g45_devices.c b/arch/arm/mach-at91/at91sam9g45_devices.c
> index cb36fa8..13c650c 100644
> --- a/arch/arm/mach-at91/at91sam9g45_devices.c
> +++ b/arch/arm/mach-at91/at91sam9g45_devices.c
> @@ -37,7 +37,6 @@
>   
>   #include "board.h"
>   #include "generic.h"
> -#include "clock.h"
>   
>   
>   /* --------------------------------------------------------------------

