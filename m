Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571Ab3COPXa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 11:23:30 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40413 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755501Ab3COPRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 11:17:02 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <balbi@ti.com>, <linux-omap@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <rogerq@ti.com>
Subject: [PATCH v2 05/23] ARM: OMAP3: Beagle: Adapt to ehci-omap changes
Date: Fri, 15 Mar 2013 17:16:26 +0200
Message-ID: <1363360604-21368-6-git-send-email-rogerq@ti.com>
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

Use usbhs_init_phys() to register the PHY's VCC and RESET
regulators.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/board-omap3beagle.c |   44 ++++++++++++++++++++++++-------
 1 files changed, 34 insertions(+), 10 deletions(-)

diff --git a/arch/arm/mach-omap2/board-omap3beagle.c b/arch/arm/mach-omap2/board-omap3beagle.c
index c3558f9..566c434 100644
--- a/arch/arm/mach-omap2/board-omap3beagle.c
+++ b/arch/arm/mach-omap2/board-omap3beagle.c
@@ -33,6 +33,7 @@
 #include <linux/mtd/nand.h>
 #include <linux/mmc/host.h>
 #include <linux/usb/phy.h>
+#include <linux/usb/nop-usb-xceiv.h>
 
 #include <linux/regulator/machine.h>
 #include <linux/i2c/twl.h>
@@ -277,6 +278,30 @@ static struct regulator_consumer_supply beagle_vsim_supply[] = {
 
 static struct gpio_led gpio_leds[];
 
+/* PHY's VCC regulator might be added later, so flag that we need it */
+static struct nop_usb_xceiv_platform_data hsusb2_phy_data = {
+	.needs_vcc = true,
+};
+
+/* PHY device on HS USB Port 2 i.e. nop_usb_xceiv.2 */
+static struct platform_device hsusb2_phy_device = {
+	.name = "nop_usb_xceiv",
+	.id = 2,
+	.dev = {
+		.platform_data = &hsusb2_phy_data,
+	},
+};
+
+static struct usbhs_phy_data phy_data[] = {
+	{
+		.port = 2,
+		.reset_gpio = 147,
+		.vcc_gpio = -1,		/* updated in beagle_twl_gpio_setup */
+		.vcc_polarity = 1,	/* updated in beagle_twl_gpio_setup */
+		.phy_id = "nop_usb_xceiv.2",
+	},
+};
+
 static int beagle_twl_gpio_setup(struct device *dev,
 		unsigned gpio, unsigned ngpio)
 {
@@ -318,9 +343,11 @@ static int beagle_twl_gpio_setup(struct device *dev,
 	}
 	dvi_panel.power_down_gpio = beagle_config.dvi_pd_gpio;
 
-	gpio_request_one(gpio + TWL4030_GPIO_MAX, beagle_config.usb_pwr_level,
-			"nEN_USB_PWR");
+	/* TWL4030_GPIO_MAX i.e. LED_GPO controls HS USB Port 2 power */
+	phy_data[0].vcc_gpio = gpio + TWL4030_GPIO_MAX;
+	phy_data[0].vcc_polarity = beagle_config.usb_pwr_level;
 
+	usbhs_init_phys(phy_data, ARRAY_SIZE(phy_data));
 	return 0;
 }
 
@@ -450,18 +477,11 @@ static struct platform_device *omap3_beagle_devices[] __initdata = {
 	&keys_gpio,
 	&madc_hwmon,
 	&leds_pwm,
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
@@ -543,7 +563,11 @@ static void __init omap3_beagle_init(void)
 
 	usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
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

