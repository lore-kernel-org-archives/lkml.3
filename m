Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240Ab3A1Lbf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 06:31:35 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:53266 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932135Ab3A1Lb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 06:31:26 -0500
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <linux@arm.linux.org.uk>, <sameo@linux.intel.com>, <balbi@ti.com>,
        <stern@rowland.harvard.edu>, <gregkh@linuxfoundation.org>,
        <eballetbo@gmail.com>, <javier@dowhile0.org>, <sshtylyov@mvista.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 15/30] ARM: OMAP3: Beagle: Adapt to ehci-omap changes
Date: Mon, 28 Jan 2013 13:30:16 +0200
Message-ID: <1359372631-8180-16-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1359372631-8180-1-git-send-email-rogerq@ti.com>
References: <1359372631-8180-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add platform device for 'nop-usb-xceiv'. This will be used as a
PHY for HS USB Port 2, so provide binding information for it.

Model RESET and Power for HS USB Port 2 as GPIO fixed regulators
and link them to the 'nop-usb-xceiv' PHY.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/board-omap3beagle.c |   93 +++++++++++++++++++++++++++---
 1 files changed, 83 insertions(+), 10 deletions(-)

diff --git a/arch/arm/mach-omap2/board-omap3beagle.c b/arch/arm/mach-omap2/board-omap3beagle.c
index 1cb114e..d8c6993 100644
--- a/arch/arm/mach-omap2/board-omap3beagle.c
+++ b/arch/arm/mach-omap2/board-omap3beagle.c
@@ -32,7 +32,9 @@
 #include <linux/mmc/host.h>
 
 #include <linux/regulator/machine.h>
+#include <linux/regulator/fixed.h>
 #include <linux/i2c/twl.h>
+#include <linux/usb/phy.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -248,6 +250,76 @@ static struct regulator_consumer_supply beagle_vsim_supply[] = {
 
 static struct gpio_led gpio_leds[];
 
+/* PHY device on HS USB Port 2 i.e. nop_usb_xceiv.2 */
+static struct platform_device hsusb2_phy_device = {
+	.name = "nop_usb_xceiv",
+	.id = 2,
+};
+
+/* Regulator for HS USB Port 2 PHY reset */
+static struct regulator_consumer_supply hsusb2_reset_supplies[] = {
+	/* Link PHY device to reset supply so it gets used in the PHY driver */
+	REGULATOR_SUPPLY("reset", "nop_usb_xceiv.2"),
+};
+
+static struct regulator_init_data hsusb2_reset_data = {
+	.constraints = {
+		.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+	},
+	.consumer_supplies = hsusb2_reset_supplies,
+	.num_consumer_supplies = ARRAY_SIZE(hsusb2_reset_supplies),
+};
+
+static struct fixed_voltage_config hsusb2_reset_config = {
+	.supply_name = "hsusb2_reset",
+	.microvolts = 3300000,
+	.gpio = 147,
+	.startup_delay = 70000, /* 70msec */
+	.enable_high = 1,
+	.enabled_at_boot = 0,   /* keep in RESET */
+	.init_data = &hsusb2_reset_data,
+};
+
+static struct platform_device hsusb2_reset_device = {
+	.name = "reg-fixed-voltage",
+	.id = PLATFORM_DEVID_AUTO,
+	.dev = {
+		.platform_data = &hsusb2_reset_config,
+	},
+};
+
+/* Regulator for HS USB Port 2 supply */
+static struct regulator_consumer_supply hsusb2_power_supplies[] = {
+/* Link PHY device to power supply so it gets enabled in the PHY driver */
+	REGULATOR_SUPPLY("vcc", "nop_usb_xceiv.2"),
+};
+
+static struct regulator_init_data hsusb2_power_data = {
+	.constraints = {
+		.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+	},
+	.consumer_supplies = hsusb2_power_supplies,
+	.num_consumer_supplies = ARRAY_SIZE(hsusb2_power_supplies),
+};
+
+static struct fixed_voltage_config hsusb2_power_config = {
+	.supply_name = "hsusb2_vbus",
+	.microvolts = 5000000,
+	.gpio = -1,		/* set at runtime in beagle_twl_gpio_setup */
+	.startup_delay = 70000, /* 70msec */
+	.enable_high = 0,	/* updated in omap3_beagle_init_rev() */
+	.enabled_at_boot = 0,
+	.init_data = &hsusb2_power_data,
+};
+
+static struct platform_device hsusb2_power_device = {
+	.name = "reg-fixed-voltage",
+	.id = PLATFORM_DEVID_AUTO,
+	.dev = {
+		.platform_data = &hsusb2_power_config,
+	},
+};
+
 static int beagle_twl_gpio_setup(struct device *dev,
 		unsigned gpio, unsigned ngpio)
 {
@@ -289,8 +361,11 @@ static int beagle_twl_gpio_setup(struct device *dev,
 	}
 	dvi_panel.power_down_gpio = beagle_config.dvi_pd_gpio;
 
-	gpio_request_one(gpio + TWL4030_GPIO_MAX, beagle_config.usb_pwr_level,
-			"nEN_USB_PWR");
+	/* TWL4030_GPIO_MAX controls HS USB Port 2 power */
+	hsusb2_power_config.gpio = gpio + TWL4030_GPIO_MAX;
+	hsusb2_power_config.enable_high = beagle_config.usb_pwr_level;
+
+	platform_device_register(&hsusb2_power_device);
 
 	/* TWL4030_GPIO_MAX + 1 == ledB, PMU_STAT (out, active low LED) */
 	gpio_leds[2].gpio = gpio + TWL4030_GPIO_MAX + 1;
@@ -428,18 +503,12 @@ static struct platform_device *omap3_beagle_devices[] __initdata = {
 	&leds_gpio,
 	&keys_gpio,
 	&madc_hwmon,
+	&hsusb2_reset_device,
+	&hsusb2_phy_device,
 };
 
 static struct usbhs_omap_platform_data usbhs_bdata __initdata = {
-
-	.port_mode[0] = OMAP_USBHS_PORT_MODE_UNUSED,
 	.port_mode[1] = OMAP_EHCI_PORT_MODE_PHY,
-	.port_mode[2] = OMAP_USBHS_PORT_MODE_UNUSED,
-
-	.phy_reset  = true,
-	.reset_gpio_port[0]  = -EINVAL,
-	.reset_gpio_port[1]  = 147,
-	.reset_gpio_port[2]  = -EINVAL
 };
 
 #ifdef CONFIG_OMAP_MUX
@@ -520,7 +589,11 @@ static void __init omap3_beagle_init(void)
 				  mt46h32m32lf6_sdrc_params);
 
 	usb_musb_init(NULL);
+
+	/* PHY on HSUSB Port 2 i.e. index 1 */
+	usb_bind_phy("ehci-omap.0", 1, "nop_usb_xceiv.2");
 	usbhs_init(&usbhs_bdata);
+
 	board_nand_init(omap3beagle_nand_partitions,
 			ARRAY_SIZE(omap3beagle_nand_partitions), NAND_CS,
 			NAND_BUSWIDTH_16, NULL);
-- 
1.7.4.1

