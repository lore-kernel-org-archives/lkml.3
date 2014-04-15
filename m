Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbaDOKag (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 06:30:36 -0400
Received: from top.free-electrons.com ([176.31.233.9]:39070 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754521AbaDOK2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 06:28:23 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv3 11/15] ARM: at91: sam9rl: switch from atmel_tsadcc to at91_adc
Date: Tue, 15 Apr 2014 12:28:06 +0200
Message-Id: <1397557690-5650-12-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397557690-5650-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1397557690-5650-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

atmel_tsadcc is not allowing to use the remaining ADC channels while at91_adc
does. Completely switch to at91_adc and remove the tsadcc platform_data for
at91sam9rl and at91sam9rl based boards.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/configs/at91sam9rl_defconfig   |  3 +-
 arch/arm/mach-at91/at91sam9rl_devices.c | 50 ---------------------------------
 arch/arm/mach-at91/board-sam9rlek.c     | 12 --------
 3 files changed, 2 insertions(+), 63 deletions(-)

diff --git a/arch/arm/configs/at91sam9rl_defconfig b/arch/arm/configs/at91sam9rl_defconfig
index 85f846ae9ff2..5d7797d43d23 100644
--- a/arch/arm/configs/at91sam9rl_defconfig
+++ b/arch/arm/configs/at91sam9rl_defconfig
@@ -45,7 +45,6 @@ CONFIG_INPUT_EVDEV=y
 # CONFIG_INPUT_KEYBOARD is not set
 # CONFIG_INPUT_MOUSE is not set
 CONFIG_INPUT_TOUCHSCREEN=y
-CONFIG_TOUCHSCREEN_ATMEL_TSADCC=y
 # CONFIG_SERIO is not set
 CONFIG_SERIAL_ATMEL=y
 CONFIG_SERIAL_ATMEL_CONSOLE=y
@@ -65,6 +64,8 @@ CONFIG_MMC=y
 CONFIG_MMC_ATMELMCI=m
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_AT91SAM9=y
+CONFIG_IIO=y
+CONFIG_AT91_ADC=y
 CONFIG_EXT2_FS=y
 CONFIG_MSDOS_FS=y
 CONFIG_VFAT_FS=y
diff --git a/arch/arm/mach-at91/at91sam9rl_devices.c b/arch/arm/mach-at91/at91sam9rl_devices.c
index 5731633bca33..f03ce109d31f 100644
--- a/arch/arm/mach-at91/at91sam9rl_devices.c
+++ b/arch/arm/mach-at91/at91sam9rl_devices.c
@@ -609,56 +609,6 @@ static void __init at91_add_device_tc(void) { }
 
 
 /* --------------------------------------------------------------------
- *  Touchscreen
- * -------------------------------------------------------------------- */
-
-#if defined(CONFIG_TOUCHSCREEN_ATMEL_TSADCC) || defined(CONFIG_TOUCHSCREEN_ATMEL_TSADCC_MODULE)
-static u64 tsadcc_dmamask = DMA_BIT_MASK(32);
-static struct at91_tsadcc_data tsadcc_data;
-
-static struct resource tsadcc_resources[] = {
-	[0] = {
-		.start	= AT91SAM9RL_BASE_TSC,
-		.end	= AT91SAM9RL_BASE_TSC + SZ_16K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[1] = {
-		.start	= NR_IRQS_LEGACY + AT91SAM9RL_ID_TSC,
-		.end	= NR_IRQS_LEGACY + AT91SAM9RL_ID_TSC,
-		.flags	= IORESOURCE_IRQ,
-	}
-};
-
-static struct platform_device at91sam9rl_tsadcc_device = {
-	.name		= "atmel_tsadcc",
-	.id		= -1,
-	.dev		= {
-				.dma_mask		= &tsadcc_dmamask,
-				.coherent_dma_mask	= DMA_BIT_MASK(32),
-				.platform_data		= &tsadcc_data,
-	},
-	.resource	= tsadcc_resources,
-	.num_resources	= ARRAY_SIZE(tsadcc_resources),
-};
-
-void __init at91_add_device_tsadcc(struct at91_tsadcc_data *data)
-{
-	if (!data)
-		return;
-
-	at91_set_A_periph(AT91_PIN_PA17, 0);	/* AD0_XR */
-	at91_set_A_periph(AT91_PIN_PA18, 0);	/* AD1_XL */
-	at91_set_A_periph(AT91_PIN_PA19, 0);	/* AD2_YT */
-	at91_set_A_periph(AT91_PIN_PA20, 0);	/* AD3_TB */
-
-	tsadcc_data = *data;
-	platform_device_register(&at91sam9rl_tsadcc_device);
-}
-#else
-void __init at91_add_device_tsadcc(struct at91_tsadcc_data *data) {}
-#endif
-
-/* --------------------------------------------------------------------
  *  ADC and Touchscreen
  * -------------------------------------------------------------------- */
 
diff --git a/arch/arm/mach-at91/board-sam9rlek.c b/arch/arm/mach-at91/board-sam9rlek.c
index 35d420247e25..6ae90e312ce0 100644
--- a/arch/arm/mach-at91/board-sam9rlek.c
+++ b/arch/arm/mach-at91/board-sam9rlek.c
@@ -230,16 +230,6 @@ static struct gpio_led ek_leds[] = {
 
 
 /*
- * Touchscreen
- */
-static struct at91_tsadcc_data ek_tsadcc_data = {
-	.adc_clock		= 1000000,
-	.pendet_debounce	= 0x0f,
-	.ts_sample_hold_time	= 0x03,
-};
-
-
-/*
  * ADC + Touchscreen
  */
 static struct at91_adc_data ek_adc_data = {
@@ -322,8 +312,6 @@ static void __init ek_board_init(void)
 	at91_add_device_lcdc(&ek_lcdc_data);
 	/* AC97 */
 	at91_add_device_ac97(&ek_ac97_data);
-	/* Touch Screen Controller */
-	at91_add_device_tsadcc(&ek_tsadcc_data);
 	/* Touch Screen Controller + ADC */
 	at91_add_device_adc(&ek_adc_data);
 	/* LEDs */
-- 
1.8.3.2

