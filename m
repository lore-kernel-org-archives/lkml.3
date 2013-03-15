Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621Ab3COPRS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 11:17:18 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40435 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754561Ab3COPRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 11:17:13 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <balbi@ti.com>, <linux-omap@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <rogerq@ti.com>
Subject: [PATCH v2 10/23] ARM: OMAP3: cm-t35: Adapt to ehci-omap changes
Date: Fri, 15 Mar 2013 17:16:31 +0200
Message-ID: <1363360604-21368-11-git-send-email-rogerq@ti.com>
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
 arch/arm/mach-omap2/board-cm-t35.c |   45 ++++++++++++++++++++++++++++++++----
 1 files changed, 40 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-omap2/board-cm-t35.c b/arch/arm/mach-omap2/board-cm-t35.c
index af2bb21..50a6517 100644
--- a/arch/arm/mach-omap2/board-cm-t35.c
+++ b/arch/arm/mach-omap2/board-cm-t35.c
@@ -29,6 +29,7 @@
 #include <linux/i2c/twl.h>
 #include <linux/regulator/fixed.h>
 #include <linux/regulator/machine.h>
+#include <linux/usb/phy.h>
 #include <linux/mmc/host.h>
 #include <linux/usb/phy.h>
 
@@ -419,15 +420,41 @@ static struct omap2_hsmmc_info mmc[] = {
 	{}	/* Terminator */
 };
 
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
+		.port = 1,
+		.reset_gpio = OMAP_MAX_GPIO_LINES + 6,
+		.vcc_gpio = -EINVAL,
+		.phy_id = "nop_usb_xceiv.1",
+	},
+	{
+		.port = 2,
+		.reset_gpio = OMAP_MAX_GPIO_LINES + 7,
+		.vcc_gpio = -EINVAL,
+		.phy_id = "nop_usb_xceiv.2",
+	},
+};
+
 static struct usbhs_omap_platform_data usbhs_bdata __initdata = {
 	.port_mode[0] = OMAP_EHCI_PORT_MODE_PHY,
 	.port_mode[1] = OMAP_EHCI_PORT_MODE_PHY,
-	.port_mode[2] = OMAP_USBHS_PORT_MODE_UNUSED,
+};
 
-	.phy_reset  = true,
-	.reset_gpio_port[0]  = OMAP_MAX_GPIO_LINES + 6,
-	.reset_gpio_port[1]  = OMAP_MAX_GPIO_LINES + 7,
-	.reset_gpio_port[2]  = -EINVAL
+static struct platform_device *usbhs_devices[] = {
+	&hsusb1_phy_device,
+	&hsusb2_phy_device,
 };
 
 static void  __init cm_t35_init_usbh(void)
@@ -444,6 +471,14 @@ static void  __init cm_t35_init_usbh(void)
 		msleep(1);
 	}
 
+	platform_add_devices(usbhs_devices, ARRAY_SIZE(usbhs_devices));
+
+	/* PHY on HSUSB Port 1 i.e. index 0 */
+	usb_bind_phy("ehci-omap.0", 0, "nop_usb_xceiv.1");
+	/* PHY on HSUSB Port 2 i.e. index 1 */
+	usb_bind_phy("ehci-omap.0", 1, "nop_usb_xceiv.2");
+
+	usbhs_init_phys(phy_data, ARRAY_SIZE(phy_data));
 	usbhs_init(&usbhs_bdata);
 }
 
-- 
1.7.4.1

