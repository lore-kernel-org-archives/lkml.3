Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137Ab3CTPs4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 11:48:56 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50579 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757927Ab3CTPpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 11:45:33 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <balbi@ti.com>, <rogerq@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 12/21] ARM: OMAP3: igep0020: Adapt to ehci-omap changes
Date: Wed, 20 Mar 2013 17:44:51 +0200
Message-ID: <1363794300-31526-13-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1363794300-31526-1-git-send-email-rogerq@ti.com>
References: <1363794300-31526-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use usbhs_init_phys() to register the PHY's RESET regulators
and the NOP PHY devices.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/board-igep0020.c |   32 ++++++++++++++++++--------------
 1 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/arch/arm/mach-omap2/board-igep0020.c b/arch/arm/mach-omap2/board-igep0020.c
index bf92678..95ccec0 100644
--- a/arch/arm/mach-omap2/board-igep0020.c
+++ b/arch/arm/mach-omap2/board-igep0020.c
@@ -527,26 +527,28 @@ static void __init igep_i2c_init(void)
 	omap3_pmic_init("twl4030", &igep_twldata);
 }
 
+static struct usbhs_phy_data igep2_phy_data[] __initdata = {
+	{
+		.port = 1,
+		.reset_gpio = IGEP2_GPIO_USBH_NRESET,
+		.vcc_gpio = -EINVAL,
+	},
+};
+
+static struct usbhs_phy_data igep3_phy_data[] __initdata = {
+	{
+		.port = 2,
+		.reset_gpio = IGEP3_GPIO_USBH_NRESET,
+		.vcc_gpio = -EINVAL,
+	},
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
@@ -642,8 +644,10 @@ static void __init igep_init(void)
 	if (machine_is_igep0020()) {
 		omap_display_init(&igep2_dss_data);
 		igep2_init_smsc911x();
+		usbhs_init_phys(igep2_phy_data, ARRAY_SIZE(igep2_phy_data));
 		usbhs_init(&igep2_usbhs_bdata);
 	} else {
+		usbhs_init_phys(igep3_phy_data, ARRAY_SIZE(igep3_phy_data));
 		usbhs_init(&igep3_usbhs_bdata);
 	}
 }
-- 
1.7.4.1

