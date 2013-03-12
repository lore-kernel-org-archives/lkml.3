Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932656Ab3CLLsk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 07:48:40 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:39586 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755327Ab3CLLoD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 07:44:03 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <balbi@ti.com>, <b-cousson@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <rogerq@ti.com>
Subject: [PATCH 12/24] ARM: OMAP3: igep0020: Adapt to ehci-omap changes
Date: Tue, 12 Mar 2013 13:43:14 +0200
Message-ID: <1363088606-2692-13-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1363088606-2692-1-git-send-email-rogerq@ti.com>
References: <1363088606-2692-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add 2 platform devices for 'nop-usb-xceiv'. These will be used
as PHYs for HS USB ports 1 and 2 so provide binding information
for them.

Model RESET for HS USB Ports 1 and 2 as GPIO fixed regulators and
link them to the 2 PHYs we just created.

Signed-off-by: Roger Quadros <rogerq@ti.com>
Acked-by: Felipe Balbi <balbi@ti.com>
---
 arch/arm/mach-omap2/board-igep0020.c |  112 +++++++++++++++++++++++++++++----
 1 files changed, 98 insertions(+), 14 deletions(-)

diff --git a/arch/arm/mach-omap2/board-igep0020.c b/arch/arm/mach-omap2/board-igep0020.c
index bf92678..c4730c6 100644
--- a/arch/arm/mach-omap2/board-igep0020.c
+++ b/arch/arm/mach-omap2/board-igep0020.c
@@ -22,6 +22,7 @@
 
 #include <linux/regulator/machine.h>
 #include <linux/regulator/fixed.h>
+#include <linux/usb/phy.h>
 #include <linux/i2c/twl.h>
 #include <linux/mmc/host.h>
 
@@ -527,26 +528,98 @@ static void __init igep_i2c_init(void)
 	omap3_pmic_init("twl4030", &igep_twldata);
 }
 
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
+	.gpio = IGEP2_GPIO_USBH_NRESET,
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
+	.gpio = IGEP3_GPIO_USBH_NRESET,
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
+static struct platform_device *igep2_devices[] __initdata = {
+	&hsusb1_phy_device,
+	&hsusb1_reset_device,
+};
+
+static struct platform_device *igep3_devices[] __initdata = {
+	&hsusb2_phy_device,
+	&hsusb2_reset_device,
+};
+
 static struct usbhs_omap_platform_data igep2_usbhs_bdata __initdata = {
 	.port_mode[0] = OMAP_EHCI_PORT_MODE_PHY,
-	.port_mode[1] = OMAP_USBHS_PORT_MODE_UNUSED,
-	.port_mode[2] = OMAP_USBHS_PORT_MODE_UNUSED,
-
-	.phy_reset = true,
-	.reset_gpio_port[0] = IGEP2_GPIO_USBH_NRESET,
-	.reset_gpio_port[1] = -EINVAL,
-	.reset_gpio_port[2] = -EINVAL,
 };
 
 static struct usbhs_omap_platform_data igep3_usbhs_bdata __initdata = {
-	.port_mode[0] = OMAP_USBHS_PORT_MODE_UNUSED,
 	.port_mode[1] = OMAP_EHCI_PORT_MODE_PHY,
-	.port_mode[2] = OMAP_USBHS_PORT_MODE_UNUSED,
-
-	.phy_reset = true,
-	.reset_gpio_port[0] = -EINVAL,
-	.reset_gpio_port[1] = IGEP3_GPIO_USBH_NRESET,
-	.reset_gpio_port[2] = -EINVAL,
 };
 
 #ifdef CONFIG_OMAP_MUX
@@ -642,8 +715,19 @@ static void __init igep_init(void)
 	if (machine_is_igep0020()) {
 		omap_display_init(&igep2_dss_data);
 		igep2_init_smsc911x();
+
+		platform_add_devices(igep2_devices, ARRAY_SIZE(igep2_devices));
+
+		/* PHY on HSUSB Port 1 i.e. index 0 */
+		usb_bind_phy("ehci-omap.0", 0, "nop_usb_xceiv.1");
+
 		usbhs_init(&igep2_usbhs_bdata);
 	} else {
+		platform_add_devices(igep3_devices, ARRAY_SIZE(igep3_devices));
+
+		/* PHY on HSUSB Port 2 i.e. index 1 */
+		usb_bind_phy("ehci-omap.0", 1, "nop_usb_xceiv.2");
+
 		usbhs_init(&igep3_usbhs_bdata);
 	}
 }
-- 
1.7.4.1

