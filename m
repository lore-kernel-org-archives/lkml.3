Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932859Ab3CLLtd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 07:49:33 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:39577 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755402Ab3CLLn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 07:43:56 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <balbi@ti.com>, <b-cousson@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <rogerq@ti.com>
Subject: [PATCH 08/24] ARM: OMAP: AM3517evm: Adapt to ehci-omap changes
Date: Tue, 12 Mar 2013 13:43:10 +0200
Message-ID: <1363088606-2692-9-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1363088606-2692-1-git-send-email-rogerq@ti.com>
References: <1363088606-2692-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add 2 platform devices for 'nop-usb-xceiv'. These will be used as a
PHY for HS USB Port 1 and 2, so provide binding information for them.

Model RESET for HS USB Port 1 as GPIO fixed regulator and link it
to the 'nop-usb-xceiv' PHY on port 1.

Signed-off-by: Roger Quadros <rogerq@ti.com>
Acked-by: Felipe Balbi <balbi@ti.com>
---
 arch/arm/mach-omap2/board-am3517evm.c |   66 ++++++++++++++++++++++++++++++---
 1 files changed, 60 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-omap2/board-am3517evm.c b/arch/arm/mach-omap2/board-am3517evm.c
index 9fb8590..36c00fb 100644
--- a/arch/arm/mach-omap2/board-am3517evm.c
+++ b/arch/arm/mach-omap2/board-am3517evm.c
@@ -25,6 +25,9 @@
 #include <linux/can/platform/ti_hecc.h>
 #include <linux/davinci_emac.h>
 #include <linux/mmc/host.h>
+#include <linux/regulator/machine.h>
+#include <linux/regulator/fixed.h>
+#include <linux/usb/phy.h>
 #include <linux/usb/musb.h>
 #include <linux/platform_data/gpio-omap.h>
 
@@ -274,6 +277,50 @@ static __init void am3517_evm_mcbsp1_init(void)
 	omap_ctrl_writel(devconf0, OMAP2_CONTROL_DEVCONF0);
 }
 
+/* PHY device on HS USB Port 1 i.e. nop_usb_xceiv.1 */
+static struct platform_device hsusb1_phy_device = {
+	.name = "nop_usb_xceiv",
+	.id = 1,
+};
+
+/* Regulator for HS USB Port 1 PHY reset */
+static struct regulator_consumer_supply hsusb1_reset_supplies[] = {
+	/* Link PHY device to reset supply so it gets used in the PHY driver */
+	REGULATOR_SUPPLY("reset", "nop_usb_xceiv.1"),
+};
+
+static struct regulator_init_data hsusb1_reset_data = {
+	.constraints = {
+		.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+	},
+	.consumer_supplies = hsusb1_reset_supplies,
+	.num_consumer_supplies = ARRAY_SIZE(hsusb1_reset_supplies),
+};
+
+static struct fixed_voltage_config hsusb1_reset_config = {
+	.supply_name = "hsusb1_reset",
+	.microvolts = 3300000,
+	.gpio = 57,
+	.startup_delay = 70000, /* 70msec */
+	.enable_high = 1,
+	.enabled_at_boot = 0,   /* keep in RESET */
+	.init_data = &hsusb1_reset_data,
+};
+
+static struct platform_device hsusb1_reset_device = {
+	.name = "reg-fixed-voltage",
+	.id = PLATFORM_DEVID_AUTO,
+	.dev = {
+		.platform_data = &hsusb1_reset_config,
+	},
+};
+
+/* PHY device on HS USB Port 2 i.e. nop_usb_xceiv.2 */
+static struct platform_device hsusb2_phy_device = {
+	.name = "nop_usb_xceiv",
+	.id = 2,
+};
+
 static struct usbhs_omap_platform_data usbhs_bdata __initdata = {
 	.port_mode[0] = OMAP_EHCI_PORT_MODE_PHY,
 #if defined(CONFIG_PANEL_SHARP_LQ043T1DG01) || \
@@ -282,12 +329,6 @@ static struct usbhs_omap_platform_data usbhs_bdata __initdata = {
 #else
 	.port_mode[1] = OMAP_EHCI_PORT_MODE_PHY,
 #endif
-	.port_mode[2] = OMAP_USBHS_PORT_MODE_UNUSED,
-
-	.phy_reset  = true,
-	.reset_gpio_port[0]  = 57,
-	.reset_gpio_port[1]  = -EINVAL,
-	.reset_gpio_port[2]  = -EINVAL
 };
 
 #ifdef CONFIG_OMAP_MUX
@@ -349,6 +390,11 @@ static struct omap2_hsmmc_info mmc[] = {
 	{}      /* Terminator */
 };
 
+static struct platform_device *am3517evm_devices[] __initdata = {
+	&hsusb1_phy_device,
+	&hsusb1_reset_device,
+	&hsusb2_phy_device,
+};
 
 static void __init am3517_evm_init(void)
 {
@@ -361,6 +407,14 @@ static void __init am3517_evm_init(void)
 
 	/* Configure GPIO for EHCI port */
 	omap_mux_init_gpio(57, OMAP_PIN_OUTPUT);
+
+	platform_add_devices(am3517evm_devices, ARRAY_SIZE(am3517evm_devices));
+
+	/* PHY on HSUSB Port 1 i.e. index 0 */
+	usb_bind_phy("ehci-omap.0", 0, "nop_usb_xceiv.1");
+	/* PHY on HSUSB Port 2 i.e. index 1 */
+	usb_bind_phy("ehci-omap.0", 1, "nop_usb_xceiv.2");
+
 	usbhs_init(&usbhs_bdata);
 	am3517_evm_hecc_init(&am3517_evm_hecc_pdata);
 	/* DSS */
-- 
1.7.4.1

