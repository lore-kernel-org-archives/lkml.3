Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932170Ab3A1Lfq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 06:35:46 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:42775 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754517Ab3A1Lbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 06:31:34 -0500
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <linux@arm.linux.org.uk>, <sameo@linux.intel.com>, <balbi@ti.com>,
        <stern@rowland.harvard.edu>, <gregkh@linuxfoundation.org>,
        <eballetbo@gmail.com>, <javier@dowhile0.org>, <sshtylyov@mvista.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 18/30] ARM: OMAP: AM3517crane: Adapt to ehci-omap changes
Date: Mon, 28 Jan 2013 13:30:19 +0200
Message-ID: <1359372631-8180-19-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1359372631-8180-1-git-send-email-rogerq@ti.com>
References: <1359372631-8180-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add platform device for 'nop-usb-xceiv'. This will be used as a
PHY for HS USB Port 1, so provide binding information for it.

Model RESET and Power for HS USB Port 1 as GPIO fixed regulators
and link them to the 'nop-usb-xceiv' PHY.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/board-am3517crane.c |   95 +++++++++++++++++++++++++++----
 1 files changed, 83 insertions(+), 12 deletions(-)

diff --git a/arch/arm/mach-omap2/board-am3517crane.c b/arch/arm/mach-omap2/board-am3517crane.c
index 26f1916..1d25af6 100644
--- a/arch/arm/mach-omap2/board-am3517crane.c
+++ b/arch/arm/mach-omap2/board-am3517crane.c
@@ -20,6 +20,9 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/gpio.h>
+#include <linux/regulator/machine.h>
+#include <linux/regulator/fixed.h>
+#include <linux/usb/phy.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -40,15 +43,84 @@ static struct omap_board_mux board_mux[] __initdata = {
 };
 #endif
 
+/* PHY device on HS USB Port 1 i.e. nop_usb_xceiv.1 */
+static struct platform_device hsusb1_phy_device = {
+	.name = "nop_usb_xceiv",
+	.id = 1,
+};
+
+/* Regulator for HS USB Port 1 PHY reset */
+static struct regulator_consumer_supply hsusb1_reset_supplies[] = {
+	/* Link PHY device to reset supply so it gets used in the PHY driver */
+	REGULATOR_SUPPLY("reset", "nop_usb_xceiv.1"),
+};
+
+static struct regulator_init_data hsusb1_reset_data = {
+	.constraints = {
+		.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+	},
+	.consumer_supplies = hsusb1_reset_supplies,
+	.num_consumer_supplies = ARRAY_SIZE(hsusb1_reset_supplies),
+};
+
+static struct fixed_voltage_config hsusb1_reset_config = {
+	.supply_name = "hsusb1_reset",
+	.microvolts = 3300000,
+	.gpio = GPIO_USB_NRESET,
+	.startup_delay = 70000, /* 70msec */
+	.enable_high = 1,
+	.enabled_at_boot = 0,   /* keep in RESET */
+	.init_data = &hsusb1_reset_data,
+};
+
+static struct platform_device hsusb1_reset_device = {
+	.name = "reg-fixed-voltage",
+	.id = PLATFORM_DEVID_AUTO,
+	.dev = {
+		.platform_data = &hsusb1_reset_config,
+	},
+};
+
+/* Regulator for HS USB Port 1 supply */
+static struct regulator_consumer_supply hsusb1_power_supplies[] = {
+/* Link PHY device to power supply so it gets enabled in the PHY driver */
+	REGULATOR_SUPPLY("vcc", "nop_usb_xceiv.1"),
+};
+
+static struct regulator_init_data hsusb1_power_data = {
+	.constraints = {
+		.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+	},
+	.consumer_supplies = hsusb1_power_supplies,
+	.num_consumer_supplies  = ARRAY_SIZE(hsusb1_power_supplies),
+};
+
+static struct fixed_voltage_config hsusb1_power_config = {
+	.supply_name = "hsusb1_vbus",
+	.microvolts = 5000000,
+	.gpio = GPIO_USB_POWER,
+	.startup_delay = 70000, /* 70msec */
+	.enable_high = 1,
+	.enabled_at_boot = 0,
+	.init_data = &hsusb1_power_data,
+};
+
+static struct platform_device hsusb1_power_device = {
+	.name = "reg-fixed-voltage",
+	.id = PLATFORM_DEVID_AUTO,
+	.dev = {
+		.platform_data = &hsusb1_power_config,
+	},
+};
+
 static struct usbhs_omap_platform_data usbhs_bdata __initdata = {
 	.port_mode[0] = OMAP_EHCI_PORT_MODE_PHY,
-	.port_mode[1] = OMAP_USBHS_PORT_MODE_UNUSED,
-	.port_mode[2] = OMAP_USBHS_PORT_MODE_UNUSED,
+};
 
-	.phy_reset  = true,
-	.reset_gpio_port[0]  = GPIO_USB_NRESET,
-	.reset_gpio_port[1]  = -EINVAL,
-	.reset_gpio_port[2]  = -EINVAL
+static struct platform_device *am3517_crane_devices[] __initdata = {
+	&hsusb1_phy_device,
+	&hsusb1_reset_device,
+	&hsusb1_power_device,
 };
 
 static void __init am3517_crane_init(void)
@@ -72,12 +144,11 @@ static void __init am3517_crane_init(void)
 		return;
 	}
 
-	ret = gpio_request_one(GPIO_USB_POWER, GPIOF_OUT_INIT_HIGH,
-			       "usb_ehci_enable");
-	if (ret < 0) {
-		pr_err("Can not request GPIO %d\n", GPIO_USB_POWER);
-		return;
-	}
+	platform_add_devices(am3517_crane_devices,
+				ARRAY_SIZE(am3517_crane_devices));
+
+	/* PHY on HSUSB Port 1 i.e. index 0 */
+	usb_bind_phy("ehci-omap.0", 0, "nop_usb_xceiv.1");
 
 	usbhs_init(&usbhs_bdata);
 	am35xx_emac_init(AM35XX_DEFAULT_MDIO_FREQUENCY, 1);
-- 
1.7.4.1

