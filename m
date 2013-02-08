Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946985Ab3BHTiK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 14:38:10 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:42799 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946957Ab3BHTiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 14:38:07 -0500
From: Ruslan Bilovol <ruslan.bilovol@ti.com>
To: tony@atomide.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] ARM: OMAP4: Add OMAP4 Blaze Tablet support
Date: Fri,  8 Feb 2013 21:37:49 +0200
Message-Id: <1360352269-14922-2-git-send-email-ruslan.bilovol@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360352269-14922-1-git-send-email-ruslan.bilovol@ti.com>
References: <1360352269-14922-1-git-send-email-ruslan.bilovol@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The OMAP4 Blaze Tablet is TI OMAP4 processor-based
development platform in a tablet formfactor.
The platform contains many of the features found in
present-day handsets (such as audio, video, wireless
functions and user interfaces) and in addition
contains features for software development and test.

This patch adds initial support for the OMAP4 Blaze
Tablet development platform. Additional functionality
depends on different drivers and code modifications that
are not upstreamed yet so will be added later.

Signed-off-by: Ruslan Bilovol <ruslan.bilovol@ti.com>
---
 arch/arm/mach-omap2/Kconfig                  |    7 +
 arch/arm/mach-omap2/Makefile                 |    1 +
 arch/arm/mach-omap2/board-omap4blazetablet.c |  433 ++++++++++++++++++++++++++
 3 files changed, 441 insertions(+)
 create mode 100644 arch/arm/mach-omap2/board-omap4blazetablet.c

diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index d932963..6dbf91a 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -393,6 +393,13 @@ config MACH_OMAP4_PANDA
 	select OMAP_PACKAGE_CBS
 	select REGULATOR_FIXED_VOLTAGE if REGULATOR
 
+config MACH_OMAP4_BLAZETABLET
+	bool "OMAP4 Blaze Tablet"
+	depends on ARCH_OMAP4
+	select OMAP_PACKAGE_CBL
+	select OMAP_PACKAGE_CBS
+	select REGULATOR_FIXED_VOLTAGE if REGULATOR
+
 config OMAP3_EMU
 	bool "OMAP3 debugging peripherals"
 	depends on ARCH_OMAP3
diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index 3643c0b..c466e45 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -254,6 +254,7 @@ obj-$(CONFIG_MACH_IGEP0020)		+= board-igep0020.o
 obj-$(CONFIG_MACH_TOUCHBOOK)		+= board-omap3touchbook.o
 obj-$(CONFIG_MACH_OMAP_4430SDP)		+= board-4430sdp.o
 obj-$(CONFIG_MACH_OMAP4_PANDA)		+= board-omap4panda.o
+obj-$(CONFIG_MACH_OMAP4_BLAZETABLET)	+= board-omap4blazetablet.o
 
 obj-$(CONFIG_MACH_PCM049)		+= board-omap4pcm049.o
 
diff --git a/arch/arm/mach-omap2/board-omap4blazetablet.c b/arch/arm/mach-omap2/board-omap4blazetablet.c
new file mode 100644
index 0000000..512a73b
--- /dev/null
+++ b/arch/arm/mach-omap2/board-omap4blazetablet.c
@@ -0,0 +1,433 @@
+/*
+ * Board support file for OMAP4 Blaze Tablet.
+ *
+ * Copyright (C) 2013 Texas Instruments
+ *
+ * Authors:
+ *	Dan Murphy <dmurphy@ti.com>
+ *	Volodymyr Riazantsev <v.riazantsev@ti.com>
+ *	Ruslan Bilovol <ruslan.bilovol@ti.com>
+ *
+ * Based on mach-omap2/board-4430sdp.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/io.h>
+#include <linux/gpio.h>
+#include <linux/usb/otg.h>
+#include <linux/spi/spi.h>
+#include <linux/i2c/twl.h>
+#include <linux/mfd/twl6040.h>
+#include <linux/gpio_keys.h>
+#include <linux/regulator/machine.h>
+#include <linux/regulator/fixed.h>
+#include <linux/leds.h>
+#include <linux/leds_pwm.h>
+#include <linux/usb/musb.h>
+
+#include <asm/hardware/gic.h>
+#include <asm/mach-types.h>
+#include <asm/mach/arch.h>
+#include <asm/mach/map.h>
+
+#include "common.h"
+#include <linux/platform_data/omap-abe-twl6040.h>
+
+#include "soc.h"
+#include "mux.h"
+#include "mmc.h"
+#include "hsmmc.h"
+#include "control.h"
+#include "common-board-devices.h"
+
+#define ETH_KS8851_IRQ			34
+#define ETH_KS8851_POWER_ON		48
+#define ETH_KS8851_QUART		138
+
+#define TABLET2_GREEN_LED_GPIO		174
+#define TABLET2_GREEN_DBG2_LED_GPIO	173
+
+/* Blaze Tablet leds */
+static struct gpio_led blazetablet_gpio_leds[] = {
+	{
+		.name	= "omap4:green:debug2",
+		.gpio	= TABLET2_GREEN_DBG2_LED_GPIO,
+	},
+	{
+		.name	= "omap4:green:debug4",
+		.gpio	= 50,
+	},
+	{
+		.name	= "blue",
+		.default_trigger = "timer",
+		.gpio	= 169,
+	},
+	{
+		.name	= "red",
+		.default_trigger = "timer",
+		.gpio	= 170,
+	},
+	{
+		.name	= "green",
+		.default_trigger = "timer",
+		.gpio	= TABLET2_GREEN_LED_GPIO,
+	},
+
+};
+
+static struct gpio_led_platform_data blazetablet_led_data = {
+	.leds	= blazetablet_gpio_leds,
+	.num_leds = ARRAY_SIZE(blazetablet_gpio_leds),
+};
+
+static struct led_pwm tablet_pwm_leds[] = {
+	{
+		.name		= "omap4:green:chrg",
+		.pwm_id		= 1,
+		.max_brightness	= 255,
+		.pwm_period_ns	= 7812500,
+	},
+};
+
+static struct led_pwm_platform_data blazetablet_pwm_data = {
+	.num_leds	= ARRAY_SIZE(tablet_pwm_leds),
+	.leds		= tablet_pwm_leds,
+};
+
+static struct platform_device blazetablet_leds_pwm = {
+	.name	= "leds_pwm",
+	.id	= -1,
+	.dev	= {
+		.platform_data = &blazetablet_pwm_data,
+	},
+};
+
+static struct platform_device blazetablet_leds_gpio = {
+	.name	= "leds-gpio",
+	.id	= -1,
+	.dev	= {
+		.platform_data = &blazetablet_led_data,
+	},
+};
+
+/* Blaze Tablet gpio buttons */
+static struct gpio_keys_button blazetablet_gpio_buttons[] = {
+	[0] = {
+		.code			= KEY_VOLUMEUP,
+		.gpio			= 43,
+		.desc			= "SW1",
+		.active_low		= 1,
+	},
+	[1] = {
+		.code			= KEY_HOME,
+		.gpio			= 46,
+		.desc			= "SW2",
+		.active_low		= 1,
+		.wakeup			= 1,
+	},
+	[2] = {
+		.code			= KEY_VOLUMEDOWN,
+		.gpio			= 47,
+		.desc			= "SW3",
+		.active_low		= 1,
+	},
+};
+
+static struct gpio_keys_platform_data blazetablet_gpio_keys = {
+	.buttons		= blazetablet_gpio_buttons,
+	.nbuttons		= ARRAY_SIZE(blazetablet_gpio_buttons),
+	.rep			= 0,
+};
+
+static struct platform_device blazetablet_gpio_keys_device = {
+	.name		= "gpio-keys",
+	.id		= -1,
+	.dev		= {
+		.platform_data	= &blazetablet_gpio_keys,
+	},
+};
+
+static struct spi_board_info ethernet_spi_board_info[] __initdata = {
+	{
+		.modalias               = "ks8851",
+		.bus_num                = 1,
+		.chip_select            = 0,
+		.max_speed_hz           = 24000000,
+		/*
+		 * .irq is set to gpio_to_irq(ETH_KS8851_IRQ)
+		 * in omap_blazetablet_init
+		 */
+	},
+};
+
+static struct gpio blazetablet_eth_gpios[] __initdata = {
+	{ ETH_KS8851_POWER_ON,	GPIOF_OUT_INIT_HIGH,	"eth_power"	},
+	{ ETH_KS8851_QUART,	GPIOF_OUT_INIT_HIGH,	"quart"		},
+	{ ETH_KS8851_IRQ,	GPIOF_IN,		"eth_irq"	},
+};
+
+static int __init omap_ethernet_init(void)
+{
+	int status;
+
+	/* Request of GPIO lines */
+	status = gpio_request_array(blazetablet_eth_gpios,
+				    ARRAY_SIZE(blazetablet_eth_gpios));
+	if (status)
+		pr_err("Cannot request ETH GPIOs\n");
+
+	return status;
+}
+
+static struct regulator_consumer_supply blazetablet_vbat_supply[] = {
+	REGULATOR_SUPPLY("vddvibl", "twl6040-vibra"),
+	REGULATOR_SUPPLY("vddvibr", "twl6040-vibra"),
+};
+
+static struct regulator_init_data blazetablet_vbat_data = {
+	.constraints = {
+		.always_on	= 1,
+	},
+	.num_consumer_supplies	= ARRAY_SIZE(blazetablet_vbat_supply),
+	.consumer_supplies	= blazetablet_vbat_supply,
+};
+
+static struct fixed_voltage_config blazetablet_vbat_pdata = {
+	.supply_name	= "VBAT",
+	.microvolts	= 3750000,
+	.init_data	= &blazetablet_vbat_data,
+	.gpio		= -EINVAL,
+};
+
+static struct platform_device blazetablet_vbat = {
+	.name		= "reg-fixed-voltage",
+	.id		= -1,
+	.dev = {
+		.platform_data = &blazetablet_vbat_pdata,
+	},
+};
+
+static struct platform_device blazetablet_hdmi_audio_codec = {
+	.name	= "hdmi-audio-codec",
+	.id	= -1,
+};
+
+static struct omap_abe_twl6040_data blazetablet_abe_audio_data = {
+	.card_name = "BlazeTablet",
+	.has_hs		= ABE_TWL6040_LEFT | ABE_TWL6040_RIGHT,
+	.has_hf		= ABE_TWL6040_LEFT | ABE_TWL6040_RIGHT,
+	.has_ep		= 1,
+	.has_aux	= ABE_TWL6040_LEFT | ABE_TWL6040_RIGHT,
+	.has_vibra	= ABE_TWL6040_LEFT | ABE_TWL6040_RIGHT,
+
+	.has_dmic	= 1,
+	.has_hsmic	= 1,
+	.has_mainmic	= 1,
+	.has_submic	= 1,
+	.has_afm	= ABE_TWL6040_LEFT | ABE_TWL6040_RIGHT,
+
+	.jack_detection = 1,
+	/* MCLK input is 38.4MHz */
+	.mclk_freq	= 38400000,
+};
+
+static struct platform_device blazetablet_abe_audio = {
+	.name		= "omap-abe-twl6040",
+	.id		= -1,
+	.dev = {
+		.platform_data = &blazetablet_abe_audio_data,
+	},
+};
+
+static struct platform_device *blazetablet_devices[] __initdata = {
+	&blazetablet_gpio_keys_device,
+	&blazetablet_leds_gpio,
+	&blazetablet_leds_pwm,
+	&blazetablet_vbat,
+	&blazetablet_abe_audio,
+	&blazetablet_hdmi_audio_codec,
+};
+
+static struct omap_musb_board_data musb_board_data = {
+	.interface_type		= MUSB_INTERFACE_UTMI,
+	.mode			= MUSB_OTG,
+	.power			= 200,
+};
+
+static struct omap2_hsmmc_info mmc[] = {
+	{
+		.mmc		= 2,
+		.caps		=  MMC_CAP_4_BIT_DATA | MMC_CAP_8_BIT_DATA,
+		.gpio_cd	= -EINVAL,
+		.gpio_wp	= -EINVAL,
+		.nonremovable   = true,
+		.ocr_mask	= MMC_VDD_29_30,
+		.no_off_init	= true,
+	},
+	{
+		.mmc		= 1,
+		.caps		= MMC_CAP_4_BIT_DATA | MMC_CAP_8_BIT_DATA,
+		.gpio_cd	= -EINVAL,
+		.gpio_wp	= -EINVAL,
+	},
+	{}	/* Terminator */
+};
+
+static struct regulator_consumer_supply blazetablet_vaux_supply[] = {
+	REGULATOR_SUPPLY("vmmc", "omap_hsmmc.1"),
+};
+
+static struct regulator_init_data blazetablet_vaux1 = {
+	.constraints = {
+		.min_uV			= 1000000,
+		.max_uV			= 3000000,
+		.apply_uV		= true,
+		.valid_modes_mask	= REGULATOR_MODE_NORMAL
+					| REGULATOR_MODE_STANDBY,
+		.valid_ops_mask	 = REGULATOR_CHANGE_VOLTAGE
+					| REGULATOR_CHANGE_MODE
+					| REGULATOR_CHANGE_STATUS,
+	},
+	.num_consumer_supplies  = ARRAY_SIZE(blazetablet_vaux_supply),
+	.consumer_supplies      = blazetablet_vaux_supply,
+};
+
+static struct regulator_init_data blazetablet_vusim = {
+	.constraints = {
+		.min_uV			= 1200000,
+		.max_uV			= 2900000,
+		.apply_uV		= true,
+		.valid_modes_mask	= REGULATOR_MODE_NORMAL
+					| REGULATOR_MODE_STANDBY,
+		.valid_ops_mask	 = REGULATOR_CHANGE_VOLTAGE
+					| REGULATOR_CHANGE_MODE
+					| REGULATOR_CHANGE_STATUS,
+	},
+};
+
+static struct twl6040_codec_data twl6040_codec = {
+	/* single-step ramp for headset and handsfree */
+	.hs_left_step	= 0x0f,
+	.hs_right_step	= 0x0f,
+	.hf_left_step	= 0x1d,
+	.hf_right_step	= 0x1d,
+};
+
+static struct twl6040_vibra_data twl6040_vibra = {
+	.vibldrv_res = 8,
+	.vibrdrv_res = 3,
+	.viblmotor_res = 10,
+	.vibrmotor_res = 10,
+	.vddvibl_uV = 0,	/* fixed volt supply - VBAT */
+	.vddvibr_uV = 0,	/* fixed volt supply - VBAT */
+};
+
+static struct twl6040_platform_data twl6040_data = {
+	.codec		= &twl6040_codec,
+	.vibra		= &twl6040_vibra,
+	.audpwron_gpio	= 127,
+};
+
+static struct i2c_board_info __initdata blazetablet_i2c_1_boardinfo[] = {
+	{
+		I2C_BOARD_INFO("twl6040", 0x4b),
+		.irq = 119 + OMAP44XX_IRQ_GIC_START,
+		.platform_data = &twl6040_data,
+	},
+};
+
+static struct twl4030_platform_data blazetablet_twldata = {
+	/* Regulators */
+	.vusim		= &blazetablet_vusim,
+	.vaux1		= &blazetablet_vaux1,
+};
+
+static int __init omap4_i2c_init(void)
+{
+	omap4_pmic_get_config(&blazetablet_twldata, TWL_COMMON_PDATA_USB,
+			TWL_COMMON_REGULATOR_VDAC |
+			TWL_COMMON_REGULATOR_VAUX2 |
+			TWL_COMMON_REGULATOR_VAUX3 |
+			TWL_COMMON_REGULATOR_VMMC |
+			TWL_COMMON_REGULATOR_VPP |
+			TWL_COMMON_REGULATOR_VANA |
+			TWL_COMMON_REGULATOR_VCXIO |
+			TWL_COMMON_REGULATOR_VUSB |
+			TWL_COMMON_REGULATOR_CLK32KG |
+			TWL_COMMON_REGULATOR_V1V8 |
+			TWL_COMMON_REGULATOR_V2V1);
+	omap4_pmic_init("twl6030", &blazetablet_twldata,
+			blazetablet_i2c_1_boardinfo,
+			ARRAY_SIZE(blazetablet_i2c_1_boardinfo));
+	omap_register_i2c_bus(2, 400, NULL, 0);
+	return 0;
+}
+
+#ifdef CONFIG_OMAP_MUX
+static struct omap_board_mux board_mux[] __initdata = {
+	OMAP4_MUX(USBB2_ULPITLL_CLK, OMAP_MUX_MODE4 | OMAP_PIN_OUTPUT),
+	/* NIRQ1 for twl6030 */
+	OMAP4_MUX(SYS_NIRQ1, OMAP_MUX_MODE0 | OMAP_PIN_INPUT_PULLUP
+					| OMAP_PIN_OFF_WAKEUPENABLE),
+	/* NIRQ2 for twl6040 */
+	OMAP4_MUX(SYS_NIRQ2, OMAP_MUX_MODE0 | OMAP_PIN_INPUT_PULLUP
+					| OMAP_PIN_OFF_WAKEUPENABLE),
+	/* GPIO_127 for twl6040 */
+	OMAP4_MUX(HDQ_SIO, OMAP_MUX_MODE3 | OMAP_PIN_OUTPUT),
+
+	{ .reg_offset = OMAP_MUX_TERMINATOR },
+};
+
+#else
+#define board_mux	NULL
+#endif
+
+
+static void __init omap4_blazetablet_init(void)
+{
+	int status;
+	int package = OMAP_PACKAGE_CBS;
+
+	if (omap_rev() == OMAP4430_REV_ES1_0)
+		package = OMAP_PACKAGE_CBL;
+	omap4_mux_init(board_mux, NULL, package);
+
+	omap4_i2c_init();
+	platform_add_devices(blazetablet_devices,
+			ARRAY_SIZE(blazetablet_devices));
+	omap_serial_init();
+	omap_sdrc_init(NULL, NULL);
+	omap4_twl6030_hsmmc_init(mmc);
+
+	usb_musb_init(&musb_board_data);
+
+	status = omap_ethernet_init();
+	if (status) {
+		pr_err("Ethernet initialization failed: %d\n", status);
+	} else {
+		ethernet_spi_board_info[0].irq = gpio_to_irq(ETH_KS8851_IRQ);
+		spi_register_board_info(ethernet_spi_board_info,
+				ARRAY_SIZE(ethernet_spi_board_info));
+	}
+}
+
+MACHINE_START(OMAP_BLAZETABLET, "OMAP4 Blaze Tablet")
+	/* Maintainer: Ruslan Bilovol */
+	.atag_offset	= 0x100,
+	.smp		= smp_ops(omap4_smp_ops),
+	.reserve	= omap_reserve,
+	.map_io		= omap4_map_io,
+	.init_early	= omap4430_init_early,
+	.init_irq	= gic_init_irq,
+	.handle_irq	= gic_handle_irq,
+	.init_machine	= omap4_blazetablet_init,
+	.init_late	= omap4430_init_late,
+	.timer		= &omap4_timer,
+	.restart	= omap44xx_restart,
+MACHINE_END
-- 
1.7.9.5

