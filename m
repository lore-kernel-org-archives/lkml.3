Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183Ab3COPU7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 11:20:59 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:50669 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755617Ab3COPRR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 11:17:17 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <balbi@ti.com>, <linux-omap@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <rogerq@ti.com>
Subject: [PATCH v2 12/23] ARM: OMAP: devkit8000: Adapt to ehci-omap changes
Date: Fri, 15 Mar 2013 17:16:33 +0200
Message-ID: <1363360604-21368-13-git-send-email-rogerq@ti.com>
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

Signed-off-by: Roger Quadros <rogerq@ti.com>
Acked-by: Felipe Balbi <balbi@ti.com>
---
 arch/arm/mach-omap2/board-devkit8000.c |   20 ++++++++++++--------
 1 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-omap2/board-devkit8000.c b/arch/arm/mach-omap2/board-devkit8000.c
index 53056c3..922ca91 100644
--- a/arch/arm/mach-omap2/board-devkit8000.c
+++ b/arch/arm/mach-omap2/board-devkit8000.c
@@ -33,6 +33,7 @@
 
 #include <linux/regulator/machine.h>
 #include <linux/i2c/twl.h>
+#include <linux/usb/phy.h>
 #include "id.h"
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -430,22 +431,21 @@ static void __init omap_dm9000_init(void)
 	eth_addr[5] = (odi.id_0 & 0x000000ff);
 }
 
+/* PHY device on HS USB Port 1 i.e. nop_usb_xceiv.1 */
+static struct platform_device hsusb1_phy_device = {
+	.name = "nop_usb_xceiv",
+	.id = 1,
+};
+
 static struct platform_device *devkit8000_devices[] __initdata = {
 	&leds_gpio,
 	&keys_gpio,
 	&omap_dm9000_dev,
+	&hsusb1_phy_device,
 };
 
 static struct usbhs_omap_platform_data usbhs_bdata __initdata = {
-
 	.port_mode[0] = OMAP_EHCI_PORT_MODE_PHY,
-	.port_mode[1] = OMAP_USBHS_PORT_MODE_UNUSED,
-	.port_mode[2] = OMAP_USBHS_PORT_MODE_UNUSED,
-
-	.phy_reset  = true,
-	.reset_gpio_port[0]  = -EINVAL,
-	.reset_gpio_port[1]  = -EINVAL,
-	.reset_gpio_port[2]  = -EINVAL
 };
 
 #ifdef CONFIG_OMAP_MUX
@@ -625,6 +625,10 @@ static void __init devkit8000_init(void)
 
 	usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
 	usb_musb_init(NULL);
+
+	/* PHY on HSUSB Port 1 i.e. index 0 */
+	usb_bind_phy("ehci-omap.0", 0, "nop_usb_xceiv.1");
+
 	usbhs_init(&usbhs_bdata);
 	board_nand_init(devkit8000_nand_partitions,
 			ARRAY_SIZE(devkit8000_nand_partitions), NAND_CS,
-- 
1.7.4.1

