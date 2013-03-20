Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932772Ab3CTPpZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 11:45:25 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53847 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757561Ab3CTPpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 11:45:18 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <balbi@ti.com>, <rogerq@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 04/21] ARM: OMAP3: Beagle: Adapt to ehci-omap changes
Date: Wed, 20 Mar 2013 17:44:43 +0200
Message-ID: <1363794300-31526-5-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1363794300-31526-1-git-send-email-rogerq@ti.com>
References: <1363794300-31526-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use usbhs_init_phys() to register the PHY's VCC and RESET
regulators and the NOP PHY device.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/board-omap3beagle.c |   32 +++++++++++++++++++++---------
 1 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/arch/arm/mach-omap2/board-omap3beagle.c b/arch/arm/mach-omap2/board-omap3beagle.c
index c3558f9..5382215 100644
--- a/arch/arm/mach-omap2/board-omap3beagle.c
+++ b/arch/arm/mach-omap2/board-omap3beagle.c
@@ -33,6 +33,7 @@
 #include <linux/mtd/nand.h>
 #include <linux/mmc/host.h>
 #include <linux/usb/phy.h>
+#include <linux/usb/nop-usb-xceiv.h>
 
 #include <linux/regulator/machine.h>
 #include <linux/i2c/twl.h>
@@ -277,6 +278,21 @@ static struct regulator_consumer_supply beagle_vsim_supply[] = {
 
 static struct gpio_led gpio_leds[];
 
+/* PHY's VCC regulator might be added later, so flag that we need it */
+static struct nop_usb_xceiv_platform_data hsusb2_phy_data = {
+	.needs_vcc = true,
+};
+
+static struct usbhs_phy_data phy_data[] = {
+	{
+		.port = 2,
+		.reset_gpio = 147,
+		.vcc_gpio = -1,		/* updated in beagle_twl_gpio_setup */
+		.vcc_polarity = 1,	/* updated in beagle_twl_gpio_setup */
+		.platform_data = &hsusb2_phy_data,
+	},
+};
+
 static int beagle_twl_gpio_setup(struct device *dev,
 		unsigned gpio, unsigned ngpio)
 {
@@ -318,9 +334,11 @@ static int beagle_twl_gpio_setup(struct device *dev,
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
 
@@ -453,15 +471,7 @@ static struct platform_device *omap3_beagle_devices[] __initdata = {
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
@@ -543,7 +553,9 @@ static void __init omap3_beagle_init(void)
 
 	usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
 	usb_musb_init(NULL);
+
 	usbhs_init(&usbhs_bdata);
+
 	board_nand_init(omap3beagle_nand_partitions,
 			ARRAY_SIZE(omap3beagle_nand_partitions), NAND_CS,
 			NAND_BUSWIDTH_16, NULL);
-- 
1.7.4.1

