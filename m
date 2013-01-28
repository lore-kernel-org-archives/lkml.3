Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203Ab3A1LeH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 06:34:07 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:35508 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754160Ab3A1Lbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 06:31:51 -0500
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <linux@arm.linux.org.uk>, <sameo@linux.intel.com>, <balbi@ti.com>,
        <stern@rowland.harvard.edu>, <gregkh@linuxfoundation.org>,
        <eballetbo@gmail.com>, <javier@dowhile0.org>, <sshtylyov@mvista.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 24/30] ARM: OMAP3: omap3evm: Adapt to ehci-omap changes
Date: Mon, 28 Jan 2013 13:30:25 +0200
Message-ID: <1359372631-8180-25-git-send-email-rogerq@ti.com>
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

Model RESET for HS USB Port 2 as GPIO fixed regulator and link
it to the 'nop-usb-xceiv' PHY.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/board-omap3evm.c |   63 ++++++++++++++++++++++++++++------
 1 files changed, 52 insertions(+), 11 deletions(-)

diff --git a/arch/arm/mach-omap2/board-omap3evm.c b/arch/arm/mach-omap2/board-omap3evm.c
index 7bdc8a4..9f3550e 100644
--- a/arch/arm/mach-omap2/board-omap3evm.c
+++ b/arch/arm/mach-omap2/board-omap3evm.c
@@ -34,6 +34,7 @@
 #include <linux/usb/otg.h>
 #include <linux/usb/musb.h>
 #include <linux/usb/nop-usb-xceiv.h>
+#include <linux/usb/phy.h>
 #include <linux/smsc911x.h>
 
 #include <linux/wl12xx.h>
@@ -538,17 +539,51 @@ static int __init omap3_evm_i2c_init(void)
 	return 0;
 }
 
-static struct usbhs_omap_platform_data usbhs_bdata __initdata = {
+/* PHY device on HS USB Port 2 i.e. nop_usb_xceiv.2 */
+static struct platform_device hsusb2_phy_device = {
+	.name = "nop_usb_xceiv",
+	.id = 2,
+};
 
-	.port_mode[0] = OMAP_USBHS_PORT_MODE_UNUSED,
-	.port_mode[1] = OMAP_EHCI_PORT_MODE_PHY,
-	.port_mode[2] = OMAP_USBHS_PORT_MODE_UNUSED,
+/* Regulator for HS USB Port 2 PHY reset */
+static struct regulator_consumer_supply hsusb2_reset_supplies[] = {
+	/* Link PHY device to reset supply so it gets used in the PHY driver */
+	REGULATOR_SUPPLY("reset", "nop_usb_xceiv.2"),
+};
 
-	.phy_reset  = true,
-	/* PHY reset GPIO will be runtime programmed based on EVM version */
-	.reset_gpio_port[0]  = -EINVAL,
-	.reset_gpio_port[1]  = -EINVAL,
-	.reset_gpio_port[2]  = -EINVAL
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
+	.gpio = -1,		/* set at runtime */
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
+static struct platform_device *omap3evm_devices[] __initdata = {
+	&hsusb2_phy_device,
+	&hsusb2_reset_device,
+};
+
+static struct usbhs_omap_platform_data usbhs_bdata __initdata = {
+	.port_mode[1] = OMAP_EHCI_PORT_MODE_PHY,
 };
 
 #ifdef CONFIG_OMAP_MUX
@@ -724,7 +759,7 @@ static void __init omap3_evm_init(void)
 
 		/* setup EHCI phy reset config */
 		omap_mux_init_gpio(21, OMAP_PIN_INPUT_PULLUP);
-		usbhs_bdata.reset_gpio_port[1] = 21;
+		hsusb2_reset_config.gpio = 21;
 
 		/* EVM REV >= E can supply 500mA with EXTVBUS programming */
 		musb_board_data.power = 500;
@@ -732,9 +767,15 @@ static void __init omap3_evm_init(void)
 	} else {
 		/* setup EHCI phy reset on MDC */
 		omap_mux_init_gpio(135, OMAP_PIN_OUTPUT);
-		usbhs_bdata.reset_gpio_port[1] = 135;
+		hsusb2_reset_config.gpio = 135;
 	}
+
+	platform_add_devices(omap3evm_devices, ARRAY_SIZE(omap3evm_devices));
 	usb_musb_init(&musb_board_data);
+
+	/* PHY on HSUSB Port 2 i.e. index 1 */
+	usb_bind_phy("ehci-omap.0", 1, "nop_usb_xceiv.2");
+
 	usbhs_init(&usbhs_bdata);
 	board_nand_init(omap3evm_nand_partitions,
 			ARRAY_SIZE(omap3evm_nand_partitions), NAND_CS,
-- 
1.7.4.1

