Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124Ab3A1LbY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 06:31:24 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:49652 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757214Ab3A1LbU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 06:31:20 -0500
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <linux@arm.linux.org.uk>, <sameo@linux.intel.com>, <balbi@ti.com>,
        <stern@rowland.harvard.edu>, <gregkh@linuxfoundation.org>,
        <eballetbo@gmail.com>, <javier@dowhile0.org>, <sshtylyov@mvista.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v2 13/30] ARM: OMAP2+: omap4panda: Provide USB Host's PHY platform data
Date: Mon, 28 Jan 2013 13:30:14 +0200
Message-ID: <1359372631-8180-14-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1359372631-8180-1-git-send-email-rogerq@ti.com>
References: <1359372631-8180-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add platform device and data for 'nop-usb-xceiv'. This will be used
as PHY for HS USB port 1, so provide binding information for it.

Get rid of managing the PHY clock as it will be done by the PHY driver.
For that to work we create a clock alias that links the PHY clock name
to the PHY device name.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/board-omap4panda.c |   34 ++++++++++++++++++++++---------
 1 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/arch/arm/mach-omap2/board-omap4panda.c b/arch/arm/mach-omap2/board-omap4panda.c
index 1351489..2641752 100644
--- a/arch/arm/mach-omap2/board-omap4panda.c
+++ b/arch/arm/mach-omap2/board-omap4panda.c
@@ -30,6 +30,7 @@
 #include <linux/regulator/fixed.h>
 #include <linux/ti_wilink_st.h>
 #include <linux/usb/musb.h>
+#include <linux/usb/nop-usb-xceiv.h>
 #include <linux/wl12xx.h>
 #include <linux/platform_data/omap-abe-twl6040.h>
 
@@ -131,12 +132,27 @@ static struct platform_device btwilink_device = {
 	.id	= -1,
 };
 
+/* PHY device on HS USB Port 1 i.e. nop_usb_xceiv.1 */
+static struct nop_usb_xceiv_platform_data hsusb1_phy_data = {
+	/* FREF_CLK3 provides the 19.2 MHz reference clock to the PHY */
+	.clk_rate = 19200000,
+};
+
+static struct platform_device hsusb1_phy_device = {
+	.name	= "nop_usb_xceiv",
+	.id	= 1,
+	.dev	= {
+		.platform_data = &hsusb1_phy_data,
+	},
+};
+
 static struct platform_device *panda_devices[] __initdata = {
 	&leds_gpio,
 	&wl1271_device,
 	&panda_abe_audio,
 	&panda_hdmi_audio_codec,
 	&btwilink_device,
+	&hsusb1_phy_device,
 };
 
 static struct usbhs_omap_platform_data usbhs_bdata __initdata = {
@@ -157,16 +173,6 @@ static struct gpio panda_ehci_gpios[] __initdata = {
 static void __init omap4_ehci_init(void)
 {
 	int ret;
-	struct clk *phy_ref_clk;
-
-	/* FREF_CLK3 provides the 19.2 MHz reference clock to the PHY */
-	phy_ref_clk = clk_get(NULL, "auxclk3_ck");
-	if (IS_ERR(phy_ref_clk)) {
-		pr_err("Cannot request auxclk3\n");
-		return;
-	}
-	clk_set_rate(phy_ref_clk, 19200000);
-	clk_prepare_enable(phy_ref_clk);
 
 	/* disable the power to the usb hub prior to init and reset phy+hub */
 	ret = gpio_request_array(panda_ehci_gpios,
@@ -180,6 +186,14 @@ static void __init omap4_ehci_init(void)
 	gpio_export(GPIO_HUB_NRESET, 0);
 	gpio_set_value(GPIO_HUB_NRESET, 1);
 
+	/* FREF_CLK3 provides the 19.2 MHz reference clock to the PHY */
+	ret = clk_add_alias("main_clk", "nop_usb_xceiv.1", "auxclk3_ck", NULL);
+	if (ret)
+		pr_err("Failed to add main_clk alias to auxclk3_ck\n");
+
+	/* PHY on HS USB Port 1 i.e. index 0 */
+	usb_bind_phy("ehci-omap.0", 0, "nop_usb_xceiv.1");
+
 	usbhs_init(&usbhs_bdata);
 
 	/* enable power to hub */
-- 
1.7.4.1

