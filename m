Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756408Ab3APUf7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 15:35:59 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:57977 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064Ab3APUf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 15:35:57 -0500
From: Luciano Coelho <coelho@ti.com>
To: <tony@atomide.com>
CC: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] OMAP: omap4-panda: add WiLink shared transport power functions
Date: Wed, 16 Jan 2013 22:34:55 +0200
Message-ID: <1358368495-10499-1-git-send-email-coelho@ti.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code to enable and disable the WiLink shared transport has been
removed from the TI-ST driver, so it must be implemented in the board
files instead.  Add the relevant operations to Panda's board file.

Additionally, add the UART2 muxing data, so it's properly configured.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 arch/arm/mach-omap2/board-omap4panda.c |   57 +++++++++++++++++++++++++++++---
 1 file changed, 53 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-omap2/board-omap4panda.c b/arch/arm/mach-omap2/board-omap4panda.c
index 5c8e9ce..97a274b 100644
--- a/arch/arm/mach-omap2/board-omap4panda.c
+++ b/arch/arm/mach-omap2/board-omap4panda.c
@@ -51,18 +51,57 @@
 #define GPIO_HUB_NRESET		62
 #define GPIO_WIFI_PMENA		43
 #define GPIO_WIFI_IRQ		53
+#define GPIO_BT_EN		46
 
 /* wl127x BT, FM, GPS connectivity chip */
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
 static struct ti_st_plat_data wilink_platform_data = {
-	.nshutdown_gpio	= 46,
 	.dev_name	= "/dev/ttyO1",
 	.flow_cntrl	= 1,
 	.baud_rate	= 3000000,
-	.chip_enable	= NULL,
-	.suspend	= NULL,
-	.resume		= NULL,
+	.chip_enable	= plat_kim_chip_enable,
+	.chip_disable	= plat_kim_chip_disable,
 };
 
+static int wilink_st_init(void)
+{
+	int status;
+
+	status = gpio_request(GPIO_BT_EN, "kim");
+	if (status) {
+		pr_err("%s: failed to request gpio %d\n", __func__,
+		       GPIO_BT_EN);
+		return status;
+	}
+
+	status = gpio_direction_output(GPIO_BT_EN, 0);
+	if (status)
+		pr_err("%s: unable to configure gpio %d", __func__,
+		       GPIO_BT_EN);
+
+	return status;
+}
+
 static struct platform_device wl1271_device = {
 	.name	= "kim",
 	.id	= -1,
@@ -397,6 +436,12 @@ static struct omap_board_mux board_mux[] __initdata = {
 		  OMAP_PULL_ENA),
 	OMAP4_MUX(ABE_MCBSP1_FSX, OMAP_MUX_MODE0 | OMAP_PIN_INPUT),
 
+	/* UART2 - BT/FM/GPS shared transport */
+	OMAP4_MUX(UART2_CTS,	OMAP_PIN_INPUT	| OMAP_MUX_MODE0),
+	OMAP4_MUX(UART2_RTS,	OMAP_PIN_OUTPUT	| OMAP_MUX_MODE0),
+	OMAP4_MUX(UART2_RX,	OMAP_PIN_INPUT	| OMAP_MUX_MODE0),
+	OMAP4_MUX(UART2_TX,	OMAP_PIN_OUTPUT	| OMAP_MUX_MODE0),
+
 	{ .reg_offset = OMAP_MUX_TERMINATOR },
 };
 
@@ -433,6 +478,10 @@ static void __init omap4_panda_init(void)
 	if (ret)
 		pr_err("error setting wl12xx data: %d\n", ret);
 
+	ret = wilink_st_init();
+	if (ret)
+		pr_err("WiLink shared transport init failed: %d\n", ret);
+
 	omap4_panda_init_rev();
 	omap4_panda_i2c_init();
 	platform_add_devices(panda_devices, ARRAY_SIZE(panda_devices));
-- 
1.7.10.4

