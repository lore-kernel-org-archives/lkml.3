Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758173Ab3CTPtR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 11:49:17 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:54161 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757913Ab3CTPpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 11:45:33 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <balbi@ti.com>, <rogerq@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 13/21] ARM: OMAP3: omap3evm: Adapt to ehci-omap changes
Date: Wed, 20 Mar 2013 17:44:52 +0200
Message-ID: <1363794300-31526-14-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1363794300-31526-1-git-send-email-rogerq@ti.com>
References: <1363794300-31526-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use usbhs_init_phys() to register the PHY's RESET regulator
and the NOP PHY device. VAUX2 supplies the PHY's VCC.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/board-omap3evm.c |   25 +++++++++++++------------
 1 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/arch/arm/mach-omap2/board-omap3evm.c b/arch/arm/mach-omap2/board-omap3evm.c
index 48789e0..2de92fa 100644
--- a/arch/arm/mach-omap2/board-omap3evm.c
+++ b/arch/arm/mach-omap2/board-omap3evm.c
@@ -496,7 +496,7 @@ struct wl12xx_platform_data omap3evm_wlan_data __initdata = {
 static struct regulator_consumer_supply omap3evm_vaux2_supplies[] = {
 	REGULATOR_SUPPLY("VDD_CSIPHY1", "omap3isp"),	/* OMAP ISP */
 	REGULATOR_SUPPLY("VDD_CSIPHY2", "omap3isp"),	/* OMAP ISP */
-	REGULATOR_SUPPLY("hsusb1", "ehci-omap.0"),
+	REGULATOR_SUPPLY("vcc", "nop_usb_xceiv.2"),	/* hsusb port 2 */
 	REGULATOR_SUPPLY("vaux2", NULL),
 };
 
@@ -539,17 +539,16 @@ static int __init omap3_evm_i2c_init(void)
 	return 0;
 }
 
-static struct usbhs_omap_platform_data usbhs_bdata __initdata = {
+static struct usbhs_phy_data phy_data[] __initdata = {
+	{
+		.port = 2,
+		.reset_gpio = -1,	/* set at runtime */
+		.vcc_gpio = -EINVAL,
+	},
+};
 
-	.port_mode[0] = OMAP_USBHS_PORT_MODE_UNUSED,
+static struct usbhs_omap_platform_data usbhs_bdata __initdata = {
 	.port_mode[1] = OMAP_EHCI_PORT_MODE_PHY,
-	.port_mode[2] = OMAP_USBHS_PORT_MODE_UNUSED,
-
-	.phy_reset  = true,
-	/* PHY reset GPIO will be runtime programmed based on EVM version */
-	.reset_gpio_port[0]  = -EINVAL,
-	.reset_gpio_port[1]  = -EINVAL,
-	.reset_gpio_port[2]  = -EINVAL
 };
 
 #ifdef CONFIG_OMAP_MUX
@@ -725,7 +724,7 @@ static void __init omap3_evm_init(void)
 
 		/* setup EHCI phy reset config */
 		omap_mux_init_gpio(21, OMAP_PIN_INPUT_PULLUP);
-		usbhs_bdata.reset_gpio_port[1] = 21;
+		phy_data[0].reset_gpio = 21;
 
 		/* EVM REV >= E can supply 500mA with EXTVBUS programming */
 		musb_board_data.power = 500;
@@ -733,10 +732,12 @@ static void __init omap3_evm_init(void)
 	} else {
 		/* setup EHCI phy reset on MDC */
 		omap_mux_init_gpio(135, OMAP_PIN_OUTPUT);
-		usbhs_bdata.reset_gpio_port[1] = 135;
+		phy_data[0].reset_gpio = 135;
 	}
 	usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
 	usb_musb_init(&musb_board_data);
+
+	usbhs_init_phys(phy_data, ARRAY_SIZE(phy_data));
 	usbhs_init(&usbhs_bdata);
 	board_nand_init(omap3evm_nand_partitions,
 			ARRAY_SIZE(omap3evm_nand_partitions), NAND_CS,
-- 
1.7.4.1

