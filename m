Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736Ab3COPV3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 11:21:29 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:50666 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755588Ab3COPRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 11:17:15 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <balbi@ti.com>, <linux-omap@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <rogerq@ti.com>
Subject: [PATCH v2 11/23] ARM: OMAP3: cm-t3517: Adapt to ehci-omap changes
Date: Fri, 15 Mar 2013 17:16:32 +0200
Message-ID: <1363360604-21368-12-git-send-email-rogerq@ti.com>
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
 arch/arm/mach-omap2/board-cm-t3517.c |   45 ++++++++++++++++++++++++++++++----
 1 files changed, 40 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-omap2/board-cm-t3517.c b/arch/arm/mach-omap2/board-cm-t3517.c
index a66da80..5e64be1 100644
--- a/arch/arm/mach-omap2/board-cm-t3517.c
+++ b/arch/arm/mach-omap2/board-cm-t3517.c
@@ -34,6 +34,7 @@
 #include <linux/mtd/partitions.h>
 #include <linux/mmc/host.h>
 #include <linux/can/platform/ti_hecc.h>
+#include <linux/usb/phy.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -188,15 +189,41 @@ static inline void cm_t3517_init_rtc(void) {}
 #define HSUSB2_RESET_GPIO	(147)
 #define USB_HUB_RESET_GPIO	(152)
 
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
+		.reset_gpio = HSUSB1_RESET_GPIO,
+		.vcc_gpio = -EINVAL,
+		.phy_id = "nop_usb_xceiv.1",
+	},
+	{
+		.port = 2,
+		.reset_gpio = HSUSB2_RESET_GPIO,
+		.vcc_gpio = -EINVAL,
+		.phy_id = "nop_usb_xceiv.2",
+	},
+};
+
 static struct usbhs_omap_platform_data cm_t3517_ehci_pdata __initdata = {
 	.port_mode[0] = OMAP_EHCI_PORT_MODE_PHY,
 	.port_mode[1] = OMAP_EHCI_PORT_MODE_PHY,
-	.port_mode[2] = OMAP_USBHS_PORT_MODE_UNUSED,
+};
 
-	.phy_reset  = true,
-	.reset_gpio_port[0]  = HSUSB1_RESET_GPIO,
-	.reset_gpio_port[1]  = HSUSB2_RESET_GPIO,
-	.reset_gpio_port[2]  = -EINVAL,
+static struct platform_device *usbhs_devices[] = {
+	&hsusb1_phy_device,
+	&hsusb2_phy_device,
 };
 
 static int __init cm_t3517_init_usbh(void)
@@ -213,6 +240,14 @@ static int __init cm_t3517_init_usbh(void)
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
 	usbhs_init(&cm_t3517_ehci_pdata);
 
 	return 0;
-- 
1.7.4.1

