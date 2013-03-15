Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682Ab3COPRc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 11:17:32 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:59317 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932105Ab3COPRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 11:17:25 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <balbi@ti.com>, <linux-omap@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <rogerq@ti.com>
Subject: [PATCH v2 16/23] ARM: OMAP3: omap3stalker: Adapt to ehci-omap changes
Date: Fri, 15 Mar 2013 17:16:37 +0200
Message-ID: <1363360604-21368-17-git-send-email-rogerq@ti.com>
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

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/board-omap3stalker.c |   29 ++++++++++++++++++++++-------
 1 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-omap2/board-omap3stalker.c b/arch/arm/mach-omap2/board-omap3stalker.c
index 95c10b3..bf6a108 100644
--- a/arch/arm/mach-omap2/board-omap3stalker.c
+++ b/arch/arm/mach-omap2/board-omap3stalker.c
@@ -26,6 +26,7 @@
 
 #include <linux/regulator/fixed.h>
 #include <linux/regulator/machine.h>
+#include <linux/usb/phy.h>
 #include <linux/i2c/twl.h>
 #include <linux/mmc/host.h>
 #include <linux/input/matrix_keypad.h>
@@ -358,19 +359,28 @@ static int __init omap3_stalker_i2c_init(void)
 
 #define OMAP3_STALKER_TS_GPIO	175
 
+/* PHY device on HS USB Port 2 i.e. nop_usb_xceiv.2 */
+static struct platform_device hsusb2_phy_device = {
+	.name = "nop_usb_xceiv",
+	.id = 2,
+};
+
+static struct usbhs_phy_data phy_data[] __initdata = {
+	{
+		.port = 2,
+		.reset_gpio = 21,
+		.vcc_gpio = -EINVAL,
+		.phy_id = "nop_usb_xceiv.2",
+	},
+};
+
 static struct platform_device *omap3_stalker_devices[] __initdata = {
 	&keys_gpio,
+	&hsusb2_phy_device,
 };
 
 static struct usbhs_omap_platform_data usbhs_bdata __initdata = {
-	.port_mode[0] = OMAP_USBHS_PORT_MODE_UNUSED,
 	.port_mode[1] = OMAP_EHCI_PORT_MODE_PHY,
-	.port_mode[2] = OMAP_USBHS_PORT_MODE_UNUSED,
-
-	.phy_reset = true,
-	.reset_gpio_port[0] = -EINVAL,
-	.reset_gpio_port[1] = 21,
-	.reset_gpio_port[2] = -EINVAL,
 };
 
 #ifdef CONFIG_OMAP_MUX
@@ -407,6 +417,11 @@ static void __init omap3_stalker_init(void)
 	omap_sdrc_init(mt46h32m32lf6_sdrc_params, NULL);
 	usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
 	usb_musb_init(NULL);
+
+	/* PHY on HSUSB Port 2 i.e. index 1 */
+	usb_bind_phy("ehci-omap.0", 1, "nop_usb_xceiv.2");
+
+	usbhs_init_phys(phy_data, ARRAY_SIZE(phy_data));
 	usbhs_init(&usbhs_bdata);
 	omap_ads7846_init(1, OMAP3_STALKER_TS_GPIO, 310, NULL);
 
-- 
1.7.4.1

