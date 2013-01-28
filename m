Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238Ab3A1Lgi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 06:36:38 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:35471 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932108Ab3A1LbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 06:31:22 -0500
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <linux@arm.linux.org.uk>, <sameo@linux.intel.com>, <balbi@ti.com>,
        <stern@rowland.harvard.edu>, <gregkh@linuxfoundation.org>,
        <eballetbo@gmail.com>, <javier@dowhile0.org>, <sshtylyov@mvista.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v2 14/30] ARM: OMAP2+: omap4panda: Adapt to ehci-omap changes
Date: Mon, 28 Jan 2013 13:30:15 +0200
Message-ID: <1359372631-8180-15-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1359372631-8180-1-git-send-email-rogerq@ti.com>
References: <1359372631-8180-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Model RESET and Power for HS USB Port 1 as GPIO fixed regulators
and link them to the 'nop-usb-xceiv' PHY by making them as "reset"
and "vcc" supplies.

The RESET and Power will then be managed by the PHY driver.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/board-omap4panda.c |   93 +++++++++++++++++++++++---------
 1 files changed, 67 insertions(+), 26 deletions(-)

diff --git a/arch/arm/mach-omap2/board-omap4panda.c b/arch/arm/mach-omap2/board-omap4panda.c
index 2641752..8c85e05 100644
--- a/arch/arm/mach-omap2/board-omap4panda.c
+++ b/arch/arm/mach-omap2/board-omap4panda.c
@@ -30,6 +30,7 @@
 #include <linux/regulator/fixed.h>
 #include <linux/ti_wilink_st.h>
 #include <linux/usb/musb.h>
+#include <linux/usb/phy.h>
 #include <linux/usb/nop-usb-xceiv.h>
 #include <linux/wl12xx.h>
 #include <linux/platform_data/omap-abe-twl6040.h>
@@ -146,6 +147,70 @@ static struct platform_device hsusb1_phy_device = {
 	},
 };
 
+/* Regulator for USB HUB/PHY reset */
+static struct regulator_consumer_supply hsusb1_reset_supplies[] = {
+/* Link PHY device to reset supply so it gets used in the PHY driver */
+	REGULATOR_SUPPLY("reset", "nop_usb_xceiv.1"),
+};
+
+static struct regulator_init_data hsusb1_reset_data = {
+	.constraints = {
+		.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+	},
+	.consumer_supplies	= hsusb1_reset_supplies,
+	.num_consumer_supplies	= ARRAY_SIZE(hsusb1_reset_supplies),
+};
+
+static struct fixed_voltage_config hsusb1_reset_config = {
+	.supply_name    = "hsusb1_reset",
+	.microvolts = 3300000,
+	.gpio = GPIO_HUB_NRESET,
+	.startup_delay = 70000, /* 70msec */
+	.enable_high = 1,
+	.enabled_at_boot = 0,	/* keep in RESET */
+	.init_data = &hsusb1_reset_data,
+};
+
+static struct platform_device hsusb1_reset_device = {
+	.name	= "reg-fixed-voltage",
+	.id	= PLATFORM_DEVID_AUTO,
+	.dev = {
+		.platform_data = &hsusb1_reset_config,
+	},
+};
+
+/* Regulator for USB HUB supply */
+static struct regulator_consumer_supply hsusb1_power_supplies[] = {
+/* Link PHY device to USB HUB supply so it gets enabled in the PHY driver */
+	REGULATOR_SUPPLY("vcc", "nop_usb_xceiv.1"),
+};
+
+static struct regulator_init_data hsusb1_power_data = {
+	.constraints = {
+		.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+	},
+	.consumer_supplies	= hsusb1_power_supplies,
+	.num_consumer_supplies	= ARRAY_SIZE(hsusb1_power_supplies),
+};
+
+static struct fixed_voltage_config hsusb1_power_config = {
+	.supply_name    = "hsusb1_vbus",
+	.microvolts = 3300000,
+	.gpio = GPIO_HUB_POWER,
+	.startup_delay = 70000, /* 70msec */
+	.enable_high = 1,
+	.enabled_at_boot = 0,
+	.init_data = &hsusb1_power_data,
+};
+
+static struct platform_device hsusb1_power_device = {
+	.name	= "reg-fixed-voltage",
+	.id	= PLATFORM_DEVID_AUTO,
+	.dev = {
+		.platform_data = &hsusb1_power_config,
+	},
+};
+
 static struct platform_device *panda_devices[] __initdata = {
 	&leds_gpio,
 	&wl1271_device,
@@ -153,39 +218,18 @@ static struct platform_device *panda_devices[] __initdata = {
 	&panda_hdmi_audio_codec,
 	&btwilink_device,
 	&hsusb1_phy_device,
+	&hsusb1_power_device,
+	&hsusb1_reset_device,
 };
 
 static struct usbhs_omap_platform_data usbhs_bdata __initdata = {
 	.port_mode[0] = OMAP_EHCI_PORT_MODE_PHY,
-	.port_mode[1] = OMAP_USBHS_PORT_MODE_UNUSED,
-	.port_mode[2] = OMAP_USBHS_PORT_MODE_UNUSED,
-	.phy_reset  = false,
-	.reset_gpio_port[0]  = -EINVAL,
-	.reset_gpio_port[1]  = -EINVAL,
-	.reset_gpio_port[2]  = -EINVAL
-};
-
-static struct gpio panda_ehci_gpios[] __initdata = {
-	{ GPIO_HUB_POWER,	GPIOF_OUT_INIT_LOW,  "hub_power"  },
-	{ GPIO_HUB_NRESET,	GPIOF_OUT_INIT_LOW,  "hub_nreset" },
 };
 
 static void __init omap4_ehci_init(void)
 {
 	int ret;
 
-	/* disable the power to the usb hub prior to init and reset phy+hub */
-	ret = gpio_request_array(panda_ehci_gpios,
-				 ARRAY_SIZE(panda_ehci_gpios));
-	if (ret) {
-		pr_err("Unable to initialize EHCI power/reset\n");
-		return;
-	}
-
-	gpio_export(GPIO_HUB_POWER, 0);
-	gpio_export(GPIO_HUB_NRESET, 0);
-	gpio_set_value(GPIO_HUB_NRESET, 1);
-
 	/* FREF_CLK3 provides the 19.2 MHz reference clock to the PHY */
 	ret = clk_add_alias("main_clk", "nop_usb_xceiv.1", "auxclk3_ck", NULL);
 	if (ret)
@@ -195,9 +239,6 @@ static void __init omap4_ehci_init(void)
 	usb_bind_phy("ehci-omap.0", 0, "nop_usb_xceiv.1");
 
 	usbhs_init(&usbhs_bdata);
-
-	/* enable power to hub */
-	gpio_set_value(GPIO_HUB_POWER, 1);
 }
 
 static struct omap_musb_board_data musb_board_data = {
-- 
1.7.4.1

