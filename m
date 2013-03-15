Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111Ab3COPRZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 11:17:25 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:59315 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932065Ab3COPRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 11:17:23 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <balbi@ti.com>, <linux-omap@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <rogerq@ti.com>
Subject: [PATCH v2 15/23] ARM: OMAP3: omap3pandora: Adapt to ehci-omap changes
Date: Fri, 15 Mar 2013 17:16:36 +0200
Message-ID: <1363360604-21368-16-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1363360604-21368-1-git-send-email-rogerq@ti.com>
References: <1363360604-21368-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add platform device for 'nop-usb-xceiv'. This will be used as a
PHY for HS USB Port 2, so provide binding information for it.

Use usbhs_init_phys() to register the PHY's RESET regulator.
VAUX2 supplies the PHY's VCC.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/board-omap3pandora.c |   31 +++++++++++++++++++++--------
 1 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-omap2/board-omap3pandora.c b/arch/arm/mach-omap2/board-omap3pandora.c
index 2bba362..82a4fe3 100644
--- a/arch/arm/mach-omap2/board-omap3pandora.c
+++ b/arch/arm/mach-omap2/board-omap3pandora.c
@@ -23,6 +23,7 @@
 
 #include <linux/spi/spi.h>
 #include <linux/regulator/machine.h>
+#include <linux/usb/phy.h>
 #include <linux/i2c/twl.h>
 #include <linux/wl12xx.h>
 #include <linux/mtd/partitions.h>
@@ -346,7 +347,7 @@ static struct regulator_consumer_supply pandora_vcc_lcd_supply[] = {
 };
 
 static struct regulator_consumer_supply pandora_usb_phy_supply[] = {
-	REGULATOR_SUPPLY("hsusb1", "ehci-omap.0"),
+	REGULATOR_SUPPLY("vcc", "nop_usb_xceiv.2"),	/* hsusb port 2 */
 };
 
 /* ads7846 on SPI and 2 nub controllers on I2C */
@@ -561,23 +562,31 @@ fail:
 	printk(KERN_ERR "wl1251 board initialisation failed\n");
 }
 
+/* PHY device on HS USB Port 2 i.e. nop_usb_xceiv.2 */
+static struct platform_device hsusb2_phy_device = {
+	.name = "nop_usb_xceiv",
+	.id = 2,
+};
+
+static struct usbhs_phy_data phy_data[] __initdata = {
+	{
+		.port = 2,
+		.reset_gpio = 16,
+		.vcc_gpio = -EINVAL,
+		.phy_id = "nop_usb_xceiv.2",
+	},
+};
+
 static struct platform_device *omap3pandora_devices[] __initdata = {
 	&pandora_leds_gpio,
 	&pandora_keys_gpio,
 	&pandora_vwlan_device,
 	&pandora_backlight,
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
-	.reset_gpio_port[1]  = 16,
-	.reset_gpio_port[2]  = -EINVAL
 };
 
 #ifdef CONFIG_OMAP_MUX
@@ -601,7 +610,11 @@ static void __init omap3pandora_init(void)
 	spi_register_board_info(omap3pandora_spi_board_info,
 			ARRAY_SIZE(omap3pandora_spi_board_info));
 	omap_ads7846_init(1, OMAP3_PANDORA_TS_GPIO, 0, NULL);
+	/* PHY on HSUSB Port 2 i.e. index 1 */
+	usb_bind_phy("ehci-omap.0", 1, "nop_usb_xceiv.2");
+	usbhs_init_phys(phy_data, ARRAY_SIZE(phy_data));
 	usbhs_init(&usbhs_bdata);
+
 	usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
 	usb_musb_init(NULL);
 	gpmc_nand_init(&pandora_nand_data, NULL);
-- 
1.7.4.1

