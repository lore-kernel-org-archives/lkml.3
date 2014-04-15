Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbaDOKbJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 06:31:09 -0400
Received: from top.free-electrons.com ([176.31.233.9]:39067 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754516AbaDOK2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 06:28:22 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv3 10/15] ARM: at91: sam9g45: switch from atmel_tsadcc to at91_adc
Date: Tue, 15 Apr 2014 12:28:05 +0200
Message-Id: <1397557690-5650-11-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397557690-5650-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1397557690-5650-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

atmel_tsadcc is not allowing to use the remaining ADC channels while at91_adc
does. Completely switch to at91_adc and remove the tsadcc platform_data for
at91sam9g45 and at91sam9g45 based boards.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/configs/at91sam9g45_defconfig   |  3 +-
 arch/arm/mach-at91/at91sam9g45_devices.c | 53 +-------------------------------
 arch/arm/mach-at91/board-sam9m10g45ek.c  | 15 ++-------
 3 files changed, 5 insertions(+), 66 deletions(-)

diff --git a/arch/arm/configs/at91sam9g45_defconfig b/arch/arm/configs/at91sam9g45_defconfig
index e181a50fd65a..c6661a60025d 100644
--- a/arch/arm/configs/at91sam9g45_defconfig
+++ b/arch/arm/configs/at91sam9g45_defconfig
@@ -83,7 +83,6 @@ CONFIG_KEYBOARD_GPIO=y
 # CONFIG_INPUT_MOUSE is not set
 CONFIG_INPUT_TOUCHSCREEN=y
 CONFIG_TOUCHSCREEN_ATMEL_MXT=m
-CONFIG_TOUCHSCREEN_ATMEL_TSADCC=y
 # CONFIG_SERIO is not set
 # CONFIG_LEGACY_PTYS is not set
 CONFIG_SERIAL_ATMEL=y
@@ -146,6 +145,8 @@ CONFIG_DMADEVICES=y
 CONFIG_AT_HDMAC=y
 CONFIG_DMATEST=m
 # CONFIG_IOMMU_SUPPORT is not set
+CONFIG_IIO=y
+CONFIG_AT91_ADC=y
 CONFIG_EXT4_FS=y
 CONFIG_FANOTIFY=y
 CONFIG_VFAT_FS=y
diff --git a/arch/arm/mach-at91/at91sam9g45_devices.c b/arch/arm/mach-at91/at91sam9g45_devices.c
index d186f474b83c..3cec148bad5a 100644
--- a/arch/arm/mach-at91/at91sam9g45_devices.c
+++ b/arch/arm/mach-at91/at91sam9g45_devices.c
@@ -1132,58 +1132,7 @@ static void __init at91_add_device_rtc(void) {}
 
 
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
-		.start	= AT91SAM9G45_BASE_TSC,
-		.end	= AT91SAM9G45_BASE_TSC + SZ_16K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[1] = {
-		.start	= NR_IRQS_LEGACY + AT91SAM9G45_ID_TSC,
-		.end	= NR_IRQS_LEGACY + AT91SAM9G45_ID_TSC,
-		.flags	= IORESOURCE_IRQ,
-	}
-};
-
-static struct platform_device at91sam9g45_tsadcc_device = {
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
-	at91_set_gpio_input(AT91_PIN_PD20, 0);	/* AD0_XR */
-	at91_set_gpio_input(AT91_PIN_PD21, 0);	/* AD1_XL */
-	at91_set_gpio_input(AT91_PIN_PD22, 0);	/* AD2_YT */
-	at91_set_gpio_input(AT91_PIN_PD23, 0);	/* AD3_TB */
-
-	tsadcc_data = *data;
-	platform_device_register(&at91sam9g45_tsadcc_device);
-}
-#else
-void __init at91_add_device_tsadcc(struct at91_tsadcc_data *data) {}
-#endif
-
-
-/* --------------------------------------------------------------------
- *  ADC
+ *  ADC and touchscreen
  * -------------------------------------------------------------------- */
 
 #if IS_ENABLED(CONFIG_AT91_ADC)
diff --git a/arch/arm/mach-at91/board-sam9m10g45ek.c b/arch/arm/mach-at91/board-sam9m10g45ek.c
index 4d775b796ce4..f2f7ce9643ce 100644
--- a/arch/arm/mach-at91/board-sam9m10g45ek.c
+++ b/arch/arm/mach-at91/board-sam9m10g45ek.c
@@ -300,16 +300,7 @@ static struct atmel_lcdfb_pdata __initdata ek_lcdc_data;
 
 
 /*
- * Touchscreen
- */
-static struct at91_tsadcc_data ek_tsadcc_data = {
-	.adc_clock		= 300000,
-	.pendet_debounce	= 0x0d,
-	.ts_sample_hold_time	= 0x0a,
-};
-
-/*
- * ADCs
+ * ADCs and touchscreen
  */
 static struct at91_adc_data ek_adc_data = {
 	.channels_used = BIT(0) | BIT(1) | BIT(2) | BIT(3) | BIT(4) | BIT(5) | BIT(6) | BIT(7),
@@ -486,9 +477,7 @@ static void __init ek_board_init(void)
 	at91_add_device_isi(&isi_data, true);
 	/* LCD Controller */
 	at91_add_device_lcdc(&ek_lcdc_data);
-	/* Touch Screen */
-	at91_add_device_tsadcc(&ek_tsadcc_data);
-	/* ADC */
+	/* ADC and touchscreen */
 	at91_add_device_adc(&ek_adc_data);
 	/* Push Buttons */
 	ek_add_device_buttons();
-- 
1.8.3.2

