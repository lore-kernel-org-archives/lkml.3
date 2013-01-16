Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558Ab3APWC1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 17:02:27 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:39325 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757245Ab3APWC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 17:02:26 -0500
From: Luciano Coelho <coelho@ti.com>
To: <tony@atomide.com>
CC: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [RFC] OMAP: 4430sdp: add shared trasport devices to the board file
Date: Thu, 17 Jan 2013 00:01:21 +0200
Message-ID: <1358373682-13536-1-git-send-email-coelho@ti.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the btwilink, nfcwilink and shared transport devices to the board
file, including functions to power things on and off.

Additionally, add the UART2 muxing data, so it's properly configured.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---

This is pretty much the same as the patch I just sent for panda, but
there were a few more things missing in the 4430sdp board file and I
also included NFC support.

I'm sending this as RFC because I'm not sure this is the right thing
to do for 4430sdp.  This configuration works when the WiLink COM8
module is installed.  The WLAN support is already hardcoded in this
file, so adding shared transport (BT/NFC/FM/GPS) support at least
won't make things much worse.

Additionally, only WiLink8 has optional support for NFC and I'm not
sure there is a way to figure that out at runtime.

 arch/arm/mach-omap2/board-4430sdp.c |   76 +++++++++++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)

diff --git a/arch/arm/mach-omap2/board-4430sdp.c b/arch/arm/mach-omap2/board-4430sdp.c
index 1cc6696..7cf273e 100644
--- a/arch/arm/mach-omap2/board-4430sdp.c
+++ b/arch/arm/mach-omap2/board-4430sdp.c
@@ -29,6 +29,8 @@
 #include <linux/platform_data/omap4-keypad.h>
 #include <linux/usb/musb.h>
 
+#include <linux/ti_wilink_st.h>
+
 #include <asm/hardware/gic.h>
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -53,6 +55,7 @@
 #define OMAP4_SFH7741_SENSOR_OUTPUT_GPIO	184
 #define OMAP4_SFH7741_ENABLE_GPIO		188
 
+#define GPIO_BT_EN		55
 #define GPIO_WIFI_PMENA		54
 #define GPIO_WIFI_IRQ		53
 
@@ -408,6 +411,66 @@ static struct platform_device sdp4430_abe_audio = {
 	},
 };
 
+/* TI shared transport for Bluetooth and NFC */
+static int plat_kim_chip_enable(struct kim_data_s *kim_data)
+{
+	gpio_set_value(GPIO_BT_EN, GPIO_LOW);
+	mdelay(5);
+	gpio_set_value(GPIO_BT_EN, GPIO_HIGH);
+	mdelay(100);
+
+	return 0;
+}
+
+static int plat_kim_chip_disable(struct kim_data_s *kim_data)
+{
+	gpio_set_value(GPIO_BT_EN, GPIO_LOW);
+	mdelay(1);
+	gpio_set_value(GPIO_BT_EN, GPIO_HIGH);
+	mdelay(1);
+	gpio_set_value(GPIO_BT_EN, GPIO_LOW);
+
+	return 0;
+}
+
+static struct ti_st_plat_data wilink_pdata = {
+	.dev_name	= "/dev/ttyO1",
+	.flow_cntrl	= 1,
+	.baud_rate	= 3000000,
+	.chip_enable	= plat_kim_chip_enable,
+	.chip_disable	= plat_kim_chip_disable,
+};
+
+static int wilink_st_init(void)
+{
+	int status;
+
+	status = gpio_request_one(GPIO_BT_EN, GPIOF_OUT_INIT_LOW, "kim");
+	if (status)
+		pr_err("%s: failed to request gpio %d\n", __func__,
+		       GPIO_BT_EN);
+
+	return status;
+}
+
+static struct platform_device wl12xx_device = {
+	.name		= "kim",
+	.id		= -1,
+	.dev = {
+		.platform_data = &wilink_pdata,
+	},
+};
+
+static struct platform_device btwilink_device = {
+	.name	= "btwilink",
+	.id	= -1,
+};
+
+static struct platform_device nfcwilink_device = {
+	.name	= "nfcwilink",
+	.id	= -1,
+};
+
 static struct platform_device *sdp4430_devices[] __initdata = {
 	&sdp4430_gpio_keys_device,
 	&sdp4430_leds_gpio,
@@ -416,6 +479,9 @@ static struct platform_device *sdp4430_devices[] __initdata = {
 	&sdp4430_dmic_codec,
 	&sdp4430_abe_audio,
 	&sdp4430_hdmi_audio_codec,
+	&wl12xx_device,
+	&btwilink_device,
+	&nfcwilink_device,
 };
 
 static struct omap_musb_board_data musb_board_data = {
@@ -632,6 +698,12 @@ static struct omap_board_mux board_mux[] __initdata = {
 		  OMAP_PULL_ENA),
 	OMAP4_MUX(ABE_MCBSP2_FSX, OMAP_MUX_MODE0 | OMAP_PIN_INPUT),
 
+	/* UART2 - BT/FM/GPS shared transport */
+	OMAP4_MUX(UART2_CTS,	OMAP_PIN_INPUT	| OMAP_MUX_MODE0),
+	OMAP4_MUX(UART2_RTS,	OMAP_PIN_OUTPUT	| OMAP_MUX_MODE0),
+	OMAP4_MUX(UART2_RX,	OMAP_PIN_INPUT	| OMAP_MUX_MODE0),
+	OMAP4_MUX(UART2_TX,	OMAP_PIN_OUTPUT	| OMAP_MUX_MODE0),
+
 	{ .reg_offset = OMAP_MUX_TERMINATOR },
 };
 
@@ -711,6 +783,10 @@ static void __init omap_4430sdp_init(void)
 	if (status)
 		pr_err("Keypad initialization failed: %d\n", status);
 
+	status = wilink_st_init();
+	if (status)
+		pr_err("WiLink shared transport init failed: %d\n", status);
+
 	omap_4430sdp_display_init();
 }
 
-- 
1.7.10.4

