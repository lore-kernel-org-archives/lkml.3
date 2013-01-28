Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260Ab3A1LcK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 06:32:10 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:42815 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932235Ab3A1LcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 06:32:04 -0500
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <linux@arm.linux.org.uk>, <sameo@linux.intel.com>, <balbi@ti.com>,
        <stern@rowland.harvard.edu>, <gregkh@linuxfoundation.org>,
        <eballetbo@gmail.com>, <javier@dowhile0.org>, <sshtylyov@mvista.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 29/30] ARM: OMAP: zoom: Adapt to ehci-omap changes
Date: Mon, 28 Jan 2013 13:30:30 +0200
Message-ID: <1359372631-8180-30-git-send-email-rogerq@ti.com>
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
 arch/arm/mach-omap2/board-zoom.c |   56 +++++++++++++++++++++++++++++++++----
 1 files changed, 50 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-omap2/board-zoom.c b/arch/arm/mach-omap2/board-zoom.c
index 2d7a457..d258632 100644
--- a/arch/arm/mach-omap2/board-zoom.c
+++ b/arch/arm/mach-omap2/board-zoom.c
@@ -17,6 +17,9 @@
 #include <linux/gpio.h>
 #include <linux/i2c/twl.h>
 #include <linux/mtd/nand.h>
+#include <linux/regulator/machine.h>
+#include <linux/regulator/fixed.h>
+#include <linux/usb/phy.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -92,14 +95,51 @@ static struct mtd_partition zoom_nand_partitions[] = {
 	},
 };
 
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
+	.gpio = ZOOM3_EHCI_RESET_GPIO,
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
+static struct platform_device *zoom3_devices[] __initdata = {
+	&hsusb2_phy_device,
+	&hsusb2_reset_device,
+};
+
 static struct usbhs_omap_platform_data usbhs_bdata __initdata = {
-	.port_mode[0]		= OMAP_USBHS_PORT_MODE_UNUSED,
 	.port_mode[1]		= OMAP_EHCI_PORT_MODE_PHY,
-	.port_mode[2]		= OMAP_USBHS_PORT_MODE_UNUSED,
-	.phy_reset		= true,
-	.reset_gpio_port[0]	= -EINVAL,
-	.reset_gpio_port[1]	= ZOOM3_EHCI_RESET_GPIO,
-	.reset_gpio_port[2]	= -EINVAL,
 };
 
 static void __init omap_zoom_init(void)
@@ -109,6 +149,10 @@ static void __init omap_zoom_init(void)
 	} else if (machine_is_omap_zoom3()) {
 		omap3_mux_init(board_mux, OMAP_PACKAGE_CBP);
 		omap_mux_init_gpio(ZOOM3_EHCI_RESET_GPIO, OMAP_PIN_OUTPUT);
+
+		platform_add_devices(zoom3_devices, ARRAY_SIZE(zoom3_devices));
+		/* PHY on HSUSB Port 2 i.e. index 1 */
+		usb_bind_phy("ehci-omap.0", 1, "nop_usb_xceiv.2");
 		usbhs_init(&usbhs_bdata);
 	}
 
-- 
1.7.4.1

