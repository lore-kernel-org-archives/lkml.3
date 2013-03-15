Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580Ab3COPRM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 11:17:12 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:59286 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754561Ab3COPRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 11:17:08 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <balbi@ti.com>, <linux-omap@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <rogerq@ti.com>
Subject: [PATCH v2 08/23] ARM: OMAP: AM3517crane: Adapt to ehci-omap changes
Date: Fri, 15 Mar 2013 17:16:29 +0200
Message-ID: <1363360604-21368-9-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1363360604-21368-1-git-send-email-rogerq@ti.com>
References: <1363360604-21368-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add platform device for 'nop-usb-xceiv'. This will be used as a
PHY for HS USB Port 1, so provide binding information for it.

Use usbhs_init_phys() to register the PHY's VCC and RESET
regulators.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/board-am3517crane.c |   38 +++++++++++++++++++++---------
 1 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/arch/arm/mach-omap2/board-am3517crane.c b/arch/arm/mach-omap2/board-am3517crane.c
index 7d3358b..f6ec36a 100644
--- a/arch/arm/mach-omap2/board-am3517crane.c
+++ b/arch/arm/mach-omap2/board-am3517crane.c
@@ -24,6 +24,7 @@
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/nand.h>
 #include <linux/mtd/partitions.h>
+#include <linux/usb/phy.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -47,15 +48,28 @@ static struct omap_board_mux board_mux[] __initdata = {
 };
 #endif
 
+/* PHY device on HS USB Port 1 i.e. nop_usb_xceiv.1 */
+static struct platform_device hsusb1_phy_device = {
+	.name = "nop_usb_xceiv",
+	.id = 1,
+};
+
+static struct usbhs_phy_data phy_data[] __initdata = {
+	{
+		.port = 1,
+		.reset_gpio = GPIO_HUB_NRESET,
+		.vcc_gpio = GPIO_HUB_POWER,
+		.vcc_polarity = 1,
+		.phy_id = "nop_usb_xceiv.1",
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
 };
 
 static struct mtd_partition crane_nand_partitions[] = {
@@ -131,13 +145,13 @@ static void __init am3517_crane_init(void)
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
 
+	usbhs_init_phys(phy_data, ARRAY_SIZE(phy_data));
 	usbhs_init(&usbhs_bdata);
 	am35xx_emac_init(AM35XX_DEFAULT_MDIO_FREQUENCY, 1);
 }
-- 
1.7.4.1

