Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650Ab3COPRa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 11:17:30 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:59092 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932065Ab3COPR1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 11:17:27 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <balbi@ti.com>, <linux-omap@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <rogerq@ti.com>
Subject: [PATCH v2 17/23] ARM: OMAP3: omap3touchbook: Adapt to ehci-omap changes
Date: Fri, 15 Mar 2013 17:16:38 +0200
Message-ID: <1363360604-21368-18-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1363360604-21368-1-git-send-email-rogerq@ti.com>
References: <1363360604-21368-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add 2 platform devices for 'nop-usb-xceiv'. These will be used as a
PHY for HS USB Ports 1 and 2, so provide binding information for them.

Use usbhs_init_phys() to register the PHY's RESET regulator.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/board-omap3touchbook.c |   38 ++++++++++++++++++++++-----
 1 files changed, 31 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-omap2/board-omap3touchbook.c b/arch/arm/mach-omap2/board-omap3touchbook.c
index bcd44fb..e8fa884 100644
--- a/arch/arm/mach-omap2/board-omap3touchbook.c
+++ b/arch/arm/mach-omap2/board-omap3touchbook.c
@@ -36,6 +36,7 @@
 #include <linux/spi/ads7846.h>
 
 #include <linux/regulator/machine.h>
+#include <linux/usb/phy.h>
 #include <linux/i2c/twl.h>
 
 #include <asm/mach-types.h>
@@ -305,21 +306,37 @@ static struct omap_board_mux board_mux[] __initdata = {
 };
 #endif
 
+/* PHY device on HS USB Port 1 i.e. nop_usb_xceiv.1 */
+static struct platform_device hsusb1_phy_device = {
+	.name = "nop_usb_xceiv",
+	.id = 1,
+};
+
+/* PHY device on HS USB Port 2 i.e. nop_usb_xceiv.2 */
+static struct platform_device hsusb2_phy_device = {
+	.name = "nop_usb_xceiv",
+	.id = 2,
+};
+
+static struct usbhs_phy_data phy_data[] __initdata = {
+	{
+		.port = 2,
+		.reset_gpio = 147,
+		.vcc_gpio = -EINVAL,
+		.phy_id = "nop_usb_xceiv.2",
+	},
+};
+
 static struct platform_device *omap3_touchbook_devices[] __initdata = {
 	&leds_gpio,
 	&keys_gpio,
+	&hsusb1_phy_device,
+	&hsusb2_phy_device,
 };
 
 static struct usbhs_omap_platform_data usbhs_bdata __initdata = {
-
 	.port_mode[0] = OMAP_EHCI_PORT_MODE_PHY,
 	.port_mode[1] = OMAP_EHCI_PORT_MODE_PHY,
-	.port_mode[2] = OMAP_USBHS_PORT_MODE_UNUSED,
-
-	.phy_reset  = true,
-	.reset_gpio_port[0]  = -EINVAL,
-	.reset_gpio_port[1]  = 147,
-	.reset_gpio_port[2]  = -EINVAL
 };
 
 static void omap3_touchbook_poweroff(void)
@@ -368,6 +385,13 @@ static void __init omap3_touchbook_init(void)
 	omap_ads7846_init(4, OMAP3_TS_GPIO, 310, &ads7846_pdata);
 	usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
 	usb_musb_init(NULL);
+
+	/* PHY on HSUSB Port 1 i.e. index 0 */
+	usb_bind_phy("ehci-omap.0", 0, "nop_usb_xceiv.1");
+	/* PHY on HSUSB Port 2 i.e. index 1 */
+	usb_bind_phy("ehci-omap.0", 1, "nop_usb_xceiv.2");
+
+	usbhs_init_phys(phy_data, ARRAY_SIZE(phy_data));
 	usbhs_init(&usbhs_bdata);
 	board_nand_init(omap3touchbook_nand_partitions,
 			ARRAY_SIZE(omap3touchbook_nand_partitions), NAND_CS,
-- 
1.7.4.1

