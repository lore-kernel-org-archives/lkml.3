Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932688AbaJUPI0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 11:08:26 -0400
Received: from ring0.de ([5.45.105.125]:54089 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932471AbaJUPIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 11:08:10 -0400
X-Spam-Report: =?ISO-8859-1?Q?
	*  0.0 URIBL_BLOCKED ADMINISTRATOR NOTICE: The query to URIBL was blocked.
	*       See http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
	*      for more information.
	*      [URIs: constraints.name]
	* -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	*  1.0 UNWANTED_LANGUAGE_BODY BODY: Nachrichtentext in unerw=fcnschter
	*      Sprache
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers?=
From: Sebastian Reichel <sre@kernel.org>
To: Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org
Cc: Tony Lindgren <tony@atomide.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Sebastian Reichel <sre@kernel.org>
Subject: [RFCv2 7/8] ARM: OMAP2: RX-51: update si4713 platform data
Date: Tue, 21 Oct 2014 17:07:06 +0200
Message-Id: <1413904027-16767-8-git-send-email-sre@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413904027-16767-1-git-send-email-sre@kernel.org>
References: <1413904027-16767-1-git-send-email-sre@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This updates platform data related to Si4713, which
has been updated to be compatible with DT interface.

Signed-off-by: Sebastian Reichel <sre@kernel.org>
---
 arch/arm/mach-omap2/board-rx51-peripherals.c | 69 +++++++++++++---------------
 1 file changed, 31 insertions(+), 38 deletions(-)

diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
index ddfc8df..ec2e410 100644
--- a/arch/arm/mach-omap2/board-rx51-peripherals.c
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@ -23,6 +23,7 @@
 #include <linux/regulator/machine.h>
 #include <linux/gpio.h>
 #include <linux/gpio_keys.h>
+#include <linux/gpio/machine.h>
 #include <linux/mmc/host.h>
 #include <linux/power/isp1704_charger.h>
 #include <linux/platform_data/spi-omap2-mcspi.h>
@@ -38,7 +39,6 @@
 
 #include <sound/tlv320aic3x.h>
 #include <sound/tpa6130a2-plat.h>
-#include <media/radio-si4713.h>
 #include <media/si4713.h>
 #include <linux/platform_data/leds-lp55xx.h>
 
@@ -760,46 +760,17 @@ static struct regulator_init_data rx51_vintdig = {
 	},
 };
 
-static const char * const si4713_supply_names[] = {
-	"vio",
-	"vdd",
-};
-
-static struct si4713_platform_data rx51_si4713_i2c_data __initdata_or_module = {
-	.supplies	= ARRAY_SIZE(si4713_supply_names),
-	.supply_names	= si4713_supply_names,
-	.gpio_reset	= RX51_FMTX_RESET_GPIO,
-};
-
-static struct i2c_board_info rx51_si4713_board_info __initdata_or_module = {
-	I2C_BOARD_INFO("si4713", SI4713_I2C_ADDR_BUSEN_HIGH),
-	.platform_data	= &rx51_si4713_i2c_data,
-};
-
-static struct radio_si4713_platform_data rx51_si4713_data __initdata_or_module = {
-	.i2c_bus	= 2,
-	.subdev_board_info = &rx51_si4713_board_info,
-};
-
-static struct platform_device rx51_si4713_dev __initdata_or_module = {
-	.name	= "radio-si4713",
-	.id	= -1,
-	.dev	= {
-		.platform_data	= &rx51_si4713_data,
+static struct gpiod_lookup_table rx51_fmtx_gpios_table = {
+	.dev_id = "2-0063",
+	.table = {
+		GPIO_LOOKUP("gpio.6", 3, "reset", GPIO_ACTIVE_HIGH), /* 163 */
+		{ },
 	},
 };
 
-static __init void rx51_init_si4713(void)
+static __init void rx51_gpio_init(void)
 {
-	int err;
-
-	err = gpio_request_one(RX51_FMTX_IRQ, GPIOF_DIR_IN, "si4713 irq");
-	if (err) {
-		printk(KERN_ERR "Cannot request si4713 irq gpio. %d\n", err);
-		return;
-	}
-	rx51_si4713_board_info.irq = gpio_to_irq(RX51_FMTX_IRQ);
-	platform_device_register(&rx51_si4713_dev);
+	gpiod_add_lookup_table(&rx51_fmtx_gpios_table);
 }
 
 static int rx51_twlgpio_setup(struct device *dev, unsigned gpio, unsigned n)
@@ -1029,7 +1000,17 @@ static struct aic3x_pdata rx51_aic3x_data2 = {
 	.gpio_reset = 60,
 };
 
+static struct si4713_platform_data rx51_si4713_platform_data = {
+	.is_platform_device = true
+};
+
 static struct i2c_board_info __initdata rx51_peripherals_i2c_board_info_2[] = {
+#if IS_ENABLED(CONFIG_I2C_SI4713) && IS_ENABLED(CONFIG_PLATFORM_SI4713)
+	{
+		I2C_BOARD_INFO("si4713", 0x63),
+		.platform_data = &rx51_si4713_platform_data,
+	},
+#endif
 	{
 		I2C_BOARD_INFO("tlv320aic3x", 0x18),
 		.platform_data = &rx51_aic3x_data,
@@ -1070,6 +1051,10 @@ static struct i2c_board_info __initdata rx51_peripherals_i2c_board_info_3[] = {
 
 static int __init rx51_i2c_init(void)
 {
+#if IS_ENABLED(CONFIG_I2C_SI4713) && IS_ENABLED(CONFIG_PLATFORM_SI4713)
+	int err;
+#endif
+
 	if ((system_rev >= SYSTEM_REV_S_USES_VAUX3 && system_rev < 0x100) ||
 	    system_rev >= SYSTEM_REV_B_USES_VAUX3) {
 		rx51_twldata.vaux3 = &rx51_vaux3_mmc;
@@ -1087,6 +1072,14 @@ static int __init rx51_i2c_init(void)
 	rx51_twldata.vdac->constraints.name = "VDAC";
 
 	omap_pmic_init(1, 2200, "twl5030", 7 + OMAP_INTC_START, &rx51_twldata);
+#if IS_ENABLED(CONFIG_I2C_SI4713) && IS_ENABLED(CONFIG_PLATFORM_SI4713)
+	err = gpio_request_one(RX51_FMTX_IRQ, GPIOF_DIR_IN, "si4713 irq");
+	if (err) {
+		printk(KERN_ERR "Cannot request si4713 irq gpio. %d\n", err);
+		return err;
+	}
+	rx51_peripherals_i2c_board_info_2[0].irq = gpio_to_irq(RX51_FMTX_IRQ);
+#endif
 	omap_register_i2c_bus(2, 100, rx51_peripherals_i2c_board_info_2,
 			      ARRAY_SIZE(rx51_peripherals_i2c_board_info_2));
 #if defined(CONFIG_SENSORS_LIS3_I2C) || defined(CONFIG_SENSORS_LIS3_I2C_MODULE)
@@ -1300,6 +1293,7 @@ static void __init rx51_init_omap3_rom_rng(void)
 
 void __init rx51_peripherals_init(void)
 {
+	rx51_gpio_init();
 	rx51_i2c_init();
 	regulator_has_full_constraints();
 	gpmc_onenand_init(board_onenand_data);
@@ -1307,7 +1301,6 @@ void __init rx51_peripherals_init(void)
 	rx51_add_gpio_keys();
 	rx51_init_wl1251();
 	rx51_init_tsc2005();
-	rx51_init_si4713();
 	rx51_init_lirc();
 	spi_register_board_info(rx51_peripherals_spi_board_info,
 				ARRAY_SIZE(rx51_peripherals_spi_board_info));
-- 
2.1.1

