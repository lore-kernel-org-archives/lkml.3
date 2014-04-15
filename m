Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679AbaDOKbi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 06:31:38 -0400
Received: from top.free-electrons.com ([176.31.233.9]:39038 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754493AbaDOK2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 06:28:20 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv3 08/15] ARM: at91: sam9rl: add at91_adc to support adc and touchscreen
Date: Tue, 15 Apr 2014 12:28:03 +0200
Message-Id: <1397557690-5650-9-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397557690-5650-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1397557690-5650-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ADC clock needs to be defined to enable the at91_adc driver. It is defined
to the same speed that is used for atmel_tsadcc.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/mach-at91/at91sam9rl.c         |  7 +++
 arch/arm/mach-at91/at91sam9rl_devices.c | 85 +++++++++++++++++++++++++++++++++
 2 files changed, 92 insertions(+)

diff --git a/arch/arm/mach-at91/at91sam9rl.c b/arch/arm/mach-at91/at91sam9rl.c
index 57f12d86c0e6..a79960f57e6a 100644
--- a/arch/arm/mach-at91/at91sam9rl.c
+++ b/arch/arm/mach-at91/at91sam9rl.c
@@ -153,6 +153,11 @@ static struct clk ac97_clk = {
 	.pmc_mask	= 1 << AT91SAM9RL_ID_AC97C,
 	.type		= CLK_TYPE_PERIPHERAL,
 };
+static struct clk adc_op_clk = {
+	.name		= "adc_op_clk",
+	.type		= CLK_TYPE_PERIPHERAL,
+	.rate_hz	= 1000000,
+};
 
 static struct clk *periph_clocks[] __initdata = {
 	&pioA_clk,
@@ -178,6 +183,7 @@ static struct clk *periph_clocks[] __initdata = {
 	&udphs_clk,
 	&lcdc_clk,
 	&ac97_clk,
+	&adc_op_clk,
 	// irq0
 };
 
@@ -216,6 +222,7 @@ static struct clk_lookup periph_clocks_lookups[] = {
 	CLKDEV_CON_DEV_ID(NULL, "fffff600.gpio", &pioB_clk),
 	CLKDEV_CON_DEV_ID(NULL, "fffff800.gpio", &pioC_clk),
 	CLKDEV_CON_DEV_ID(NULL, "fffffa00.gpio", &pioD_clk),
+	CLKDEV_CON_ID("adc_clk", &tsc_clk),
 };
 
 static struct clk_lookup usart_clocks_lookups[] = {
diff --git a/arch/arm/mach-at91/at91sam9rl_devices.c b/arch/arm/mach-at91/at91sam9rl_devices.c
index 428fc412aaf1..5731633bca33 100644
--- a/arch/arm/mach-at91/at91sam9rl_devices.c
+++ b/arch/arm/mach-at91/at91sam9rl_devices.c
@@ -23,6 +23,7 @@
 #include <mach/at91sam9_smc.h>
 #include <mach/hardware.h>
 #include <linux/platform_data/dma-atmel.h>
+#include <linux/platform_data/at91_adc.h>
 
 #include "board.h"
 #include "generic.h"
@@ -657,6 +658,90 @@ void __init at91_add_device_tsadcc(struct at91_tsadcc_data *data)
 void __init at91_add_device_tsadcc(struct at91_tsadcc_data *data) {}
 #endif
 
+/* --------------------------------------------------------------------
+ *  ADC and Touchscreen
+ * -------------------------------------------------------------------- */
+
+#if IS_ENABLED(CONFIG_AT91_ADC)
+static struct at91_adc_data adc_data;
+
+static struct resource adc_resources[] = {
+	[0] = {
+		.start	= AT91SAM9RL_BASE_TSC,
+		.end	= AT91SAM9RL_BASE_TSC + SZ_16K - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= NR_IRQS_LEGACY + AT91SAM9RL_ID_TSC,
+		.end	= NR_IRQS_LEGACY + AT91SAM9RL_ID_TSC,
+		.flags	= IORESOURCE_IRQ,
+	}
+};
+
+static struct platform_device at91_adc_device = {
+	.name           = "at91sam9rl-adc",
+	.id             = -1,
+	.dev            = {
+		.platform_data  = &adc_data,
+	},
+	.resource       = adc_resources,
+	.num_resources  = ARRAY_SIZE(adc_resources),
+};
+
+static struct at91_adc_trigger at91_adc_triggers[] = {
+	[0] = {
+		.name = "external-rising",
+		.value = 1,
+		.is_external = true,
+	},
+	[1] = {
+		.name = "external-falling",
+		.value = 2,
+		.is_external = true,
+	},
+	[2] = {
+		.name = "external-any",
+		.value = 3,
+		.is_external = true,
+	},
+	[3] = {
+		.name = "continuous",
+		.value = 6,
+		.is_external = false,
+	},
+};
+
+void __init at91_add_device_adc(struct at91_adc_data *data)
+{
+	if (!data)
+		return;
+
+	if (test_bit(0, &data->channels_used))
+		at91_set_A_periph(AT91_PIN_PA17, 0);
+	if (test_bit(1, &data->channels_used))
+		at91_set_A_periph(AT91_PIN_PA18, 0);
+	if (test_bit(2, &data->channels_used))
+		at91_set_A_periph(AT91_PIN_PA19, 0);
+	if (test_bit(3, &data->channels_used))
+		at91_set_A_periph(AT91_PIN_PA20, 0);
+	if (test_bit(4, &data->channels_used))
+		at91_set_A_periph(AT91_PIN_PD6, 0);
+	if (test_bit(5, &data->channels_used))
+		at91_set_A_periph(AT91_PIN_PD7, 0);
+
+	if (data->use_external_triggers)
+		at91_set_A_periph(AT91_PIN_PB15, 0);
+
+	data->startup_time = 40;
+	data->trigger_number = 4;
+	data->trigger_list = at91_adc_triggers;
+
+	adc_data = *data;
+	platform_device_register(&at91_adc_device);
+}
+#else
+void __init at91_add_device_adc(struct at91_adc_data *data) {}
+#endif
 
 /* --------------------------------------------------------------------
  *  RTC
-- 
1.8.3.2

