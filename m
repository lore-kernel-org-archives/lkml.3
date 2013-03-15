Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088Ab3COPRW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 11:17:22 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:59301 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932065Ab3COPRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 11:17:19 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <balbi@ti.com>, <linux-omap@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <rogerq@ti.com>
Subject: [PATCH v2 13/23] ARM: OMAP3: igep0020: Adapt to ehci-omap changes
Date: Fri, 15 Mar 2013 17:16:34 +0200
Message-ID: <1363360604-21368-14-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1363360604-21368-1-git-send-email-rogerq@ti.com>
References: <1363360604-21368-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add 2 platform devices for 'nop-usb-xceiv'. These will be used
as PHYs for HS USB ports 1 and 2 so provide binding information
for them.

Use usbhs_init_phys() to register the PHY's RESET regulators.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/board-igep0020.c |   66 ++++++++++++++++++++++++++-------
 1 files changed, 52 insertions(+), 14 deletions(-)

diff --git a/arch/arm/mach-omap2/board-igep0020.c b/arch/arm/mach-omap2/board-igep0020.c
index bf92678..8b0b2fb 100644
--- a/arch/arm/mach-omap2/board-igep0020.c
+++ b/arch/arm/mach-omap2/board-igep0020.c
@@ -22,6 +22,7 @@
 
 #include <linux/regulator/machine.h>
 #include <linux/regulator/fixed.h>
+#include <linux/usb/phy.h>
 #include <linux/i2c/twl.h>
 #include <linux/mmc/host.h>
 
@@ -527,26 +528,50 @@ static void __init igep_i2c_init(void)
 	omap3_pmic_init("twl4030", &igep_twldata);
 }
 
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
+static struct usbhs_phy_data igep2_phy_data[] __initdata = {
+	{
+		.port = 1,
+		.reset_gpio = IGEP2_GPIO_USBH_NRESET,
+		.vcc_gpio = -EINVAL,
+		.phy_id = "nop_usb_xceiv.1",
+	},
+};
+
+static struct usbhs_phy_data igep3_phy_data[] __initdata = {
+	{
+		.port = 2,
+		.reset_gpio = IGEP3_GPIO_USBH_NRESET,
+		.vcc_gpio = -EINVAL,
+		.phy_id = "nop_usb_xceiv.2",
+	},
+};
+
+static struct platform_device *igep2_devices[] __initdata = {
+	&hsusb1_phy_device,
+};
+
+static struct platform_device *igep3_devices[] __initdata = {
+	&hsusb2_phy_device,
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
@@ -642,8 +667,21 @@ static void __init igep_init(void)
 	if (machine_is_igep0020()) {
 		omap_display_init(&igep2_dss_data);
 		igep2_init_smsc911x();
+
+		platform_add_devices(igep2_devices, ARRAY_SIZE(igep2_devices));
+
+		/* PHY on HSUSB Port 1 i.e. index 0 */
+		usb_bind_phy("ehci-omap.0", 0, "nop_usb_xceiv.1");
+
+		usbhs_init_phys(igep2_phy_data, ARRAY_SIZE(igep2_phy_data));
 		usbhs_init(&igep2_usbhs_bdata);
 	} else {
+		platform_add_devices(igep3_devices, ARRAY_SIZE(igep3_devices));
+
+		/* PHY on HSUSB Port 2 i.e. index 1 */
+		usb_bind_phy("ehci-omap.0", 1, "nop_usb_xceiv.2");
+
+		usbhs_init_phys(igep3_phy_data, ARRAY_SIZE(igep3_phy_data));
 		usbhs_init(&igep3_usbhs_bdata);
 	}
 }
-- 
1.7.4.1

