Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063Ab3DVJ6G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 05:58:06 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52669 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394Ab3DVJ6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 05:58:04 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <balbi@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH] ARM: OMAP2+: omap-usb-host: clean up pin mux setup code
Date: Mon, 22 Apr 2013 12:57:53 +0300
Message-ID: <1366624673-2684-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The USB host pins are named quite differently between OMAP3 and
OMAP4+ SoCs. To make this managable in code, we create a pin mapping
table (pin_names) that maps pin function to pin name.

This pin mapping table is populated at runtime based on a pin
name template. Templates are provided for OMAP3 and 4 SoCs.

The setup_io_mux() function uses the pin mapping table to
setup the pin mux.

The resulting code is a lot more clean, manageable and scalable.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/usb-host.c |  648 ++++++++++++++--------------------------
 1 files changed, 225 insertions(+), 423 deletions(-)

diff --git a/arch/arm/mach-omap2/usb-host.c b/arch/arm/mach-omap2/usb-host.c
index aa27d7f..86cafee 100644
--- a/arch/arm/mach-omap2/usb-host.c
+++ b/arch/arm/mach-omap2/usb-host.c
@@ -10,6 +10,7 @@
  *
  * Generalization by:
  * Felipe Balbi <balbi@ti.com>
+ * Roger Quadros <rogerq@ti.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -41,439 +42,239 @@
 #define	USBHS_UHH_HWMODNAME	"usb_host_hs"
 #define USBHS_TLL_HWMODNAME	"usb_tll_hs"
 
-/* MUX settings for EHCI pins */
+#define MAX_PIN_NAME	20
+
+/* all possible USB pin configurations for one port */
+enum usbhs_pin_function {
+	/* EHCI PHY mode pins */
+	PHY_STP, PHY_CLK, PHY_DIR, PHY_NXT, PHY_DAT0, PHY_DAT1,
+	PHY_DAT2, PHY_DAT3, PHY_DAT4, PHY_DAT5, PHY_DAT6, PHY_DAT7,
+
+	/* EHCI TLL mode pins */
+	TLL_STP, TLL_CLK, TLL_DIR, TLL_NXT, TLL_DAT0, TLL_DAT1,
+	TLL_DAT2, TLL_DAT3, TLL_DAT4, TLL_DAT5, TLL_DAT6, TLL_DAT7,
+
+	/* OHCI mode pins */
+	RXDP, RXDM, RXRCV, TXEN, TXSE0, TXDAT,
+
+	/* Terminator */
+	MAX_PINS,
+};
+
 /*
- * setup_ehci_io_mux - initialize IO pad mux for USBHOST
+ * NOTE: In the pin templates, the pin names must contain %d
+ * where port number is to be inserted.
+ * e.g. hsusb%d_stp becomes hsusb1_stp
  */
-static void __init setup_ehci_io_mux(const enum usbhs_omap_port_mode *port_mode)
-{
-	switch (port_mode[0]) {
-	case OMAP_EHCI_PORT_MODE_PHY:
-		omap_mux_init_signal("hsusb1_stp", OMAP_PIN_OUTPUT);
-		omap_mux_init_signal("hsusb1_clk", OMAP_PIN_OUTPUT);
-		omap_mux_init_signal("hsusb1_dir", OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb1_nxt", OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb1_data0", OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb1_data1", OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb1_data2", OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb1_data3", OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb1_data4", OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb1_data5", OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb1_data6", OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb1_data7", OMAP_PIN_INPUT_PULLDOWN);
-		break;
-	case OMAP_EHCI_PORT_MODE_TLL:
-		omap_mux_init_signal("hsusb1_tll_stp",
-			OMAP_PIN_INPUT_PULLUP);
-		omap_mux_init_signal("hsusb1_tll_clk",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb1_tll_dir",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb1_tll_nxt",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb1_tll_data0",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb1_tll_data1",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb1_tll_data2",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb1_tll_data3",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb1_tll_data4",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb1_tll_data5",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb1_tll_data6",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb1_tll_data7",
-			OMAP_PIN_INPUT_PULLDOWN);
-		break;
-	case OMAP_USBHS_PORT_MODE_UNUSED:
-		/* FALLTHROUGH */
-	default:
-		break;
-	}
 
-	switch (port_mode[1]) {
-	case OMAP_EHCI_PORT_MODE_PHY:
-		omap_mux_init_signal("hsusb2_stp", OMAP_PIN_OUTPUT);
-		omap_mux_init_signal("hsusb2_clk", OMAP_PIN_OUTPUT);
-		omap_mux_init_signal("hsusb2_dir", OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb2_nxt", OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb2_data0",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb2_data1",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb2_data2",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb2_data3",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb2_data4",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb2_data5",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb2_data6",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb2_data7",
-			OMAP_PIN_INPUT_PULLDOWN);
-		break;
-	case OMAP_EHCI_PORT_MODE_TLL:
-		omap_mux_init_signal("hsusb2_tll_stp",
-			OMAP_PIN_INPUT_PULLUP);
-		omap_mux_init_signal("hsusb2_tll_clk",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb2_tll_dir",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb2_tll_nxt",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb2_tll_data0",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb2_tll_data1",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb2_tll_data2",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb2_tll_data3",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb2_tll_data4",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb2_tll_data5",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb2_tll_data6",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb2_tll_data7",
-			OMAP_PIN_INPUT_PULLDOWN);
-		break;
-	case OMAP_USBHS_PORT_MODE_UNUSED:
-		/* FALLTHROUGH */
-	default:
-		break;
-	}
+/* Pin template for OMAP3 SoCs */
+static const char __initdata omap3_pin_template[MAX_PINS][MAX_PIN_NAME] = {
+	[PHY_STP] = "hsusb%d_stp",
+	[PHY_CLK] = "hsusb%d_clk",
+	[PHY_DIR] = "hsusb%d_dir",
+	[PHY_NXT] = "hsusb%d_nxt",
+	[PHY_DAT0] = "hsusb%d_data0",
+	[PHY_DAT1] = "hsusb%d_data1",
+	[PHY_DAT2] = "hsusb%d_data2",
+	[PHY_DAT3] = "hsusb%d_data3",
+	[PHY_DAT4] = "hsusb%d_data4",
+	[PHY_DAT5] = "hsusb%d_data5",
+	[PHY_DAT6] = "hsusb%d_data6",
+	[PHY_DAT7] = "hsusb%d_data7",
+
+	[TLL_STP] = "hsusb%d_tll_stp",
+	[TLL_CLK] = "hsusb%d_tll_clk",
+	[TLL_DIR] = "hsusb%d_tll_dir",
+	[TLL_NXT] = "hsusb%d_tll_nxt",
+	[TLL_DAT0] = "hsusb%d_tll_data0",
+	[TLL_DAT1] = "hsusb%d_tll_data1",
+	[TLL_DAT2] = "hsusb%d_tll_data2",
+	[TLL_DAT3] = "hsusb%d_tll_data3",
+	[TLL_DAT4] = "hsusb%d_tll_data4",
+	[TLL_DAT5] = "hsusb%d_tll_data5",
+	[TLL_DAT6] = "hsusb%d_tll_data6",
+	[TLL_DAT7] = "hsusb%d_tll_data7",
+
+	[RXDP] = "mm%d_rxdp",
+	[RXDM] = "mm%d_rxdm",
+	[RXRCV] = "mm%d_rxrcv",
+	[TXEN] = "mm%d_txen_n",
+	[TXSE0] = "mm%d_txse0",
+	[TXDAT] = "mm%d_txdat",
+};
 
-	switch (port_mode[2]) {
-	case OMAP_EHCI_PORT_MODE_PHY:
-		printk(KERN_WARNING "Port3 can't be used in PHY mode\n");
-		break;
-	case OMAP_EHCI_PORT_MODE_TLL:
-		omap_mux_init_signal("hsusb3_tll_stp",
-			OMAP_PIN_INPUT_PULLUP);
-		omap_mux_init_signal("hsusb3_tll_clk",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb3_tll_dir",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb3_tll_nxt",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb3_tll_data0",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb3_tll_data1",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb3_tll_data2",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb3_tll_data3",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb3_tll_data4",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb3_tll_data5",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb3_tll_data6",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("hsusb3_tll_data7",
-			OMAP_PIN_INPUT_PULLDOWN);
-		break;
-	case OMAP_USBHS_PORT_MODE_UNUSED:
-		/* FALLTHROUGH */
-	default:
-		break;
-	}
+/* Pin template for OMAP4+ SoCs */
+static const char __initdata omap4_pin_template[MAX_PINS][MAX_PIN_NAME] = {
+	[PHY_STP] = "usbb%d_ulpiphy_stp",
+	[PHY_CLK] = "usbb%d_ulpiphy_clk",
+	[PHY_DIR] = "usbb%d_ulpiphy_dir",
+	[PHY_NXT] = "usbb%d_ulpiphy_nxt",
+	[PHY_DAT0] = "usbb%d_ulpiphy_dat0",
+	[PHY_DAT1] = "usbb%d_ulpiphy_dat1",
+	[PHY_DAT2] = "usbb%d_ulpiphy_dat2",
+	[PHY_DAT3] = "usbb%d_ulpiphy_dat3",
+	[PHY_DAT4] = "usbb%d_ulpiphy_dat4",
+	[PHY_DAT5] = "usbb%d_ulpiphy_dat5",
+	[PHY_DAT6] = "usbb%d_ulpiphy_dat6",
+	[PHY_DAT7] = "usbb%d_ulpiphy_dat7",
+
+	[TLL_STP] = "usbb%d_ulpitll_stp",
+	[TLL_CLK] = "usbb%d_ulpitll_clk",
+	[TLL_DIR] = "usbb%d_ulpitll_dir",
+	[TLL_NXT] = "usbb%d_ulpitll_nxt",
+	[TLL_DAT0] = "usbb%d_ulpitll_dat0",
+	[TLL_DAT1] = "usbb%d_ulpitll_dat1",
+	[TLL_DAT2] = "usbb%d_ulpitll_dat2",
+	[TLL_DAT3] = "usbb%d_ulpitll_dat3",
+	[TLL_DAT4] = "usbb%d_ulpitll_dat4",
+	[TLL_DAT5] = "usbb%d_ulpitll_dat5",
+	[TLL_DAT6] = "usbb%d_ulpitll_dat6",
+	[TLL_DAT7] = "usbb%d_ulpitll_dat7",
+
+	[RXDP] = "usbb%d_mm_rxdp",
+	[RXDM] = "usbb%d_mm_rxdm",
+	[RXRCV] = "usbb%d_mm_rxrcv",
+	[TXEN] = "usbb%d_mm_txen",
+	[TXSE0] = "usbb%d_mm_txse0",
+	[TXDAT] = "usbb%d_mm_txdat",
+};
 
-	return;
+/**
+ * populate_pin_names - populate the pin names based on the given template
+ * @template: the name template for the pins
+ * @pin_names: the table where the pin names will be stored
+ *
+ * This function populates the pin names into the pin_names table.
+ */
+static void __init populate_pin_names(const char (*template)[MAX_PIN_NAME],
+				char (*pin_names)[MAX_PINS][MAX_PIN_NAME])
+{
+	int i, j;
+
+	for (i = 0; i < OMAP3_HS_USB_PORTS; i++) {
+		for (j = 0; j < MAX_PINS; j++) {
+			/* template contains %d */
+			snprintf(pin_names[i][j], MAX_PIN_NAME,
+						template[j], i + 1);
+		}
+	}
 }
 
+/**
+ * usbhs_setup_io_mux - Setup IO mux for USB Host pins based on port_mode
+ * @port_mode: port mode list
+ * @template: pin name template for the SoC
+ */
 static
-void __init setup_4430ehci_io_mux(const enum usbhs_omap_port_mode *port_mode)
+void __init usbhs_setup_io_mux(const enum usbhs_omap_port_mode *port_mode,
+					const char (*template)[MAX_PIN_NAME])
 {
-	switch (port_mode[0]) {
-	case OMAP_EHCI_PORT_MODE_PHY:
-		omap_mux_init_signal("usbb1_ulpiphy_stp",
-			OMAP_PIN_OUTPUT);
-		omap_mux_init_signal("usbb1_ulpiphy_clk",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb1_ulpiphy_dir",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb1_ulpiphy_nxt",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb1_ulpiphy_dat0",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb1_ulpiphy_dat1",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb1_ulpiphy_dat2",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb1_ulpiphy_dat3",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb1_ulpiphy_dat4",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb1_ulpiphy_dat5",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb1_ulpiphy_dat6",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb1_ulpiphy_dat7",
-			OMAP_PIN_INPUT_PULLDOWN);
-			break;
-	case OMAP_EHCI_PORT_MODE_TLL:
-		omap_mux_init_signal("usbb1_ulpitll_stp",
-			OMAP_PIN_INPUT_PULLUP);
-		omap_mux_init_signal("usbb1_ulpitll_clk",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb1_ulpitll_dir",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb1_ulpitll_nxt",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb1_ulpitll_dat0",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb1_ulpitll_dat1",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb1_ulpitll_dat2",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb1_ulpitll_dat3",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb1_ulpitll_dat4",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb1_ulpitll_dat5",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb1_ulpitll_dat6",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb1_ulpitll_dat7",
-			OMAP_PIN_INPUT_PULLDOWN);
-			break;
-	case OMAP_USBHS_PORT_MODE_UNUSED:
-	default:
-			break;
+	int i;
+
+	char (*pin_names)[MAX_PINS][MAX_PIN_NAME];
+
+	pin_names  = kmalloc(sizeof(char [OMAP3_HS_USB_PORTS][MAX_PINS][MAX_PIN_NAME]),
+						GFP_KERNEL);
+	if (!pin_names) {
+		pr_err("%s: memory allocation failed\n", __func__);
+		return;
 	}
-	switch (port_mode[1]) {
-	case OMAP_EHCI_PORT_MODE_PHY:
-		omap_mux_init_signal("usbb2_ulpiphy_stp",
-			OMAP_PIN_OUTPUT);
-		omap_mux_init_signal("usbb2_ulpiphy_clk",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb2_ulpiphy_dir",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb2_ulpiphy_nxt",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb2_ulpiphy_dat0",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb2_ulpiphy_dat1",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb2_ulpiphy_dat2",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb2_ulpiphy_dat3",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb2_ulpiphy_dat4",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb2_ulpiphy_dat5",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb2_ulpiphy_dat6",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb2_ulpiphy_dat7",
-			OMAP_PIN_INPUT_PULLDOWN);
-			break;
-	case OMAP_EHCI_PORT_MODE_TLL:
-		omap_mux_init_signal("usbb2_ulpitll_stp",
-			OMAP_PIN_INPUT_PULLUP);
-		omap_mux_init_signal("usbb2_ulpitll_clk",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb2_ulpitll_dir",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb2_ulpitll_nxt",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb2_ulpitll_dat0",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb2_ulpitll_dat1",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb2_ulpitll_dat2",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb2_ulpitll_dat3",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb2_ulpitll_dat4",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb2_ulpitll_dat5",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb2_ulpitll_dat6",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb2_ulpitll_dat7",
-			OMAP_PIN_INPUT_PULLDOWN);
+
+	populate_pin_names(template, pin_names);
+
+	for (i = 0; i < OMAP3_HS_USB_PORTS; i++) {
+		switch (port_mode[i]) {
+		/* EHCI cases */
+		case OMAP_EHCI_PORT_MODE_PHY:
+			omap_mux_init_signal(pin_names[i][PHY_STP],
+				OMAP_PIN_OUTPUT);
+			omap_mux_init_signal(pin_names[i][PHY_CLK],
+				OMAP_PIN_INPUT_PULLDOWN);
+			omap_mux_init_signal(pin_names[i][PHY_DIR],
+				OMAP_PIN_INPUT_PULLDOWN);
+			omap_mux_init_signal(pin_names[i][PHY_NXT],
+				OMAP_PIN_INPUT_PULLDOWN);
+			omap_mux_init_signal(pin_names[i][PHY_DAT0],
+				OMAP_PIN_INPUT_PULLDOWN);
+			omap_mux_init_signal(pin_names[i][PHY_DAT1],
+				OMAP_PIN_INPUT_PULLDOWN);
+			omap_mux_init_signal(pin_names[i][PHY_DAT2],
+				OMAP_PIN_INPUT_PULLDOWN);
+			omap_mux_init_signal(pin_names[i][PHY_DAT3],
+				OMAP_PIN_INPUT_PULLDOWN);
+			omap_mux_init_signal(pin_names[i][PHY_DAT4],
+				OMAP_PIN_INPUT_PULLDOWN);
+			omap_mux_init_signal(pin_names[i][PHY_DAT5],
+				OMAP_PIN_INPUT_PULLDOWN);
+			omap_mux_init_signal(pin_names[i][PHY_DAT6],
+				OMAP_PIN_INPUT_PULLDOWN);
+			omap_mux_init_signal(pin_names[i][PHY_DAT7],
+				OMAP_PIN_INPUT_PULLDOWN);
 			break;
-	case OMAP_USBHS_PORT_MODE_UNUSED:
-	default:
+
+		case OMAP_EHCI_PORT_MODE_TLL:
+			omap_mux_init_signal(pin_names[i][TLL_STP],
+				OMAP_PIN_OUTPUT);
+			omap_mux_init_signal(pin_names[i][TLL_CLK],
+				OMAP_PIN_INPUT_PULLDOWN);
+			omap_mux_init_signal(pin_names[i][TLL_DIR],
+				OMAP_PIN_INPUT_PULLDOWN);
+			omap_mux_init_signal(pin_names[i][TLL_NXT],
+				OMAP_PIN_INPUT_PULLDOWN);
+			omap_mux_init_signal(pin_names[i][TLL_DAT0],
+				OMAP_PIN_INPUT_PULLDOWN);
+			omap_mux_init_signal(pin_names[i][TLL_DAT1],
+				OMAP_PIN_INPUT_PULLDOWN);
+			omap_mux_init_signal(pin_names[i][TLL_DAT2],
+				OMAP_PIN_INPUT_PULLDOWN);
+			omap_mux_init_signal(pin_names[i][TLL_DAT3],
+				OMAP_PIN_INPUT_PULLDOWN);
+			omap_mux_init_signal(pin_names[i][TLL_DAT4],
+				OMAP_PIN_INPUT_PULLDOWN);
+			omap_mux_init_signal(pin_names[i][TLL_DAT5],
+				OMAP_PIN_INPUT_PULLDOWN);
+			omap_mux_init_signal(pin_names[i][TLL_DAT6],
+				OMAP_PIN_INPUT_PULLDOWN);
+			omap_mux_init_signal(pin_names[i][TLL_DAT7],
+				OMAP_PIN_INPUT_PULLDOWN);
 			break;
-	}
-}
 
-static void __init setup_ohci_io_mux(const enum usbhs_omap_port_mode *port_mode)
-{
-	switch (port_mode[0]) {
-	case OMAP_OHCI_PORT_MODE_PHY_6PIN_DATSE0:
-	case OMAP_OHCI_PORT_MODE_PHY_6PIN_DPDM:
-	case OMAP_OHCI_PORT_MODE_TLL_6PIN_DATSE0:
-	case OMAP_OHCI_PORT_MODE_TLL_6PIN_DPDM:
-		omap_mux_init_signal("mm1_rxdp",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("mm1_rxdm",
-			OMAP_PIN_INPUT_PULLDOWN);
-		/* FALLTHROUGH */
-	case OMAP_OHCI_PORT_MODE_PHY_4PIN_DPDM:
-	case OMAP_OHCI_PORT_MODE_TLL_4PIN_DPDM:
-		omap_mux_init_signal("mm1_rxrcv",
-			OMAP_PIN_INPUT_PULLDOWN);
-		/* FALLTHROUGH */
-	case OMAP_OHCI_PORT_MODE_PHY_3PIN_DATSE0:
-	case OMAP_OHCI_PORT_MODE_TLL_3PIN_DATSE0:
-		omap_mux_init_signal("mm1_txen_n", OMAP_PIN_OUTPUT);
-		/* FALLTHROUGH */
-	case OMAP_OHCI_PORT_MODE_TLL_2PIN_DATSE0:
-	case OMAP_OHCI_PORT_MODE_TLL_2PIN_DPDM:
-		omap_mux_init_signal("mm1_txse0",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("mm1_txdat",
-			OMAP_PIN_INPUT_PULLDOWN);
-		break;
-	case OMAP_USBHS_PORT_MODE_UNUSED:
-		/* FALLTHROUGH */
-	default:
-		break;
-	}
-	switch (port_mode[1]) {
-	case OMAP_OHCI_PORT_MODE_PHY_6PIN_DATSE0:
-	case OMAP_OHCI_PORT_MODE_PHY_6PIN_DPDM:
-	case OMAP_OHCI_PORT_MODE_TLL_6PIN_DATSE0:
-	case OMAP_OHCI_PORT_MODE_TLL_6PIN_DPDM:
-		omap_mux_init_signal("mm2_rxdp",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("mm2_rxdm",
-			OMAP_PIN_INPUT_PULLDOWN);
-		/* FALLTHROUGH */
-	case OMAP_OHCI_PORT_MODE_PHY_4PIN_DPDM:
-	case OMAP_OHCI_PORT_MODE_TLL_4PIN_DPDM:
-		omap_mux_init_signal("mm2_rxrcv",
-			OMAP_PIN_INPUT_PULLDOWN);
-		/* FALLTHROUGH */
-	case OMAP_OHCI_PORT_MODE_PHY_3PIN_DATSE0:
-	case OMAP_OHCI_PORT_MODE_TLL_3PIN_DATSE0:
-		omap_mux_init_signal("mm2_txen_n", OMAP_PIN_OUTPUT);
-		/* FALLTHROUGH */
-	case OMAP_OHCI_PORT_MODE_TLL_2PIN_DATSE0:
-	case OMAP_OHCI_PORT_MODE_TLL_2PIN_DPDM:
-		omap_mux_init_signal("mm2_txse0",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("mm2_txdat",
-			OMAP_PIN_INPUT_PULLDOWN);
-		break;
-	case OMAP_USBHS_PORT_MODE_UNUSED:
-		/* FALLTHROUGH */
-	default:
-		break;
-	}
-	switch (port_mode[2]) {
-	case OMAP_OHCI_PORT_MODE_PHY_6PIN_DATSE0:
-	case OMAP_OHCI_PORT_MODE_PHY_6PIN_DPDM:
-	case OMAP_OHCI_PORT_MODE_TLL_6PIN_DATSE0:
-	case OMAP_OHCI_PORT_MODE_TLL_6PIN_DPDM:
-		omap_mux_init_signal("mm3_rxdp",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("mm3_rxdm",
-			OMAP_PIN_INPUT_PULLDOWN);
-		/* FALLTHROUGH */
-	case OMAP_OHCI_PORT_MODE_PHY_4PIN_DPDM:
-	case OMAP_OHCI_PORT_MODE_TLL_4PIN_DPDM:
-		omap_mux_init_signal("mm3_rxrcv",
-			OMAP_PIN_INPUT_PULLDOWN);
-		/* FALLTHROUGH */
-	case OMAP_OHCI_PORT_MODE_PHY_3PIN_DATSE0:
-	case OMAP_OHCI_PORT_MODE_TLL_3PIN_DATSE0:
-		omap_mux_init_signal("mm3_txen_n", OMAP_PIN_OUTPUT);
-		/* FALLTHROUGH */
-	case OMAP_OHCI_PORT_MODE_TLL_2PIN_DATSE0:
-	case OMAP_OHCI_PORT_MODE_TLL_2PIN_DPDM:
-		omap_mux_init_signal("mm3_txse0",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("mm3_txdat",
-			OMAP_PIN_INPUT_PULLDOWN);
-		break;
-	case OMAP_USBHS_PORT_MODE_UNUSED:
-		/* FALLTHROUGH */
-	default:
-		break;
-	}
-}
+		/* OHCI cases */
+		case OMAP_OHCI_PORT_MODE_PHY_6PIN_DATSE0:
+		case OMAP_OHCI_PORT_MODE_PHY_6PIN_DPDM:
+		case OMAP_OHCI_PORT_MODE_TLL_6PIN_DATSE0:
+		case OMAP_OHCI_PORT_MODE_TLL_6PIN_DPDM:
+			omap_mux_init_signal(pin_names[i][RXDP],
+					OMAP_PIN_INPUT_PULLDOWN);
+			omap_mux_init_signal(pin_names[i][RXDM],
+					OMAP_PIN_INPUT_PULLDOWN);
+
+		case OMAP_OHCI_PORT_MODE_PHY_4PIN_DPDM:
+		case OMAP_OHCI_PORT_MODE_TLL_4PIN_DPDM:
+			omap_mux_init_signal(pin_names[i][RXRCV],
+					OMAP_PIN_INPUT_PULLDOWN);
+
+		case OMAP_OHCI_PORT_MODE_PHY_3PIN_DATSE0:
+		case OMAP_OHCI_PORT_MODE_TLL_3PIN_DATSE0:
+			omap_mux_init_signal(pin_names[i][TXEN],
+					OMAP_PIN_INPUT_PULLDOWN);
+
+		case OMAP_OHCI_PORT_MODE_TLL_2PIN_DATSE0:
+		case OMAP_OHCI_PORT_MODE_TLL_2PIN_DPDM:
+			omap_mux_init_signal(pin_names[i][TXDAT],
+					OMAP_PIN_INPUT_PULLDOWN);
+			omap_mux_init_signal(pin_names[i][TXSE0],
+					OMAP_PIN_INPUT_PULLDOWN);
+			break;
 
-static
-void __init setup_4430ohci_io_mux(const enum usbhs_omap_port_mode *port_mode)
-{
-	switch (port_mode[0]) {
-	case OMAP_OHCI_PORT_MODE_PHY_6PIN_DATSE0:
-	case OMAP_OHCI_PORT_MODE_PHY_6PIN_DPDM:
-	case OMAP_OHCI_PORT_MODE_TLL_6PIN_DATSE0:
-	case OMAP_OHCI_PORT_MODE_TLL_6PIN_DPDM:
-		omap_mux_init_signal("usbb1_mm_rxdp",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb1_mm_rxdm",
-			OMAP_PIN_INPUT_PULLDOWN);
-
-	case OMAP_OHCI_PORT_MODE_PHY_4PIN_DPDM:
-	case OMAP_OHCI_PORT_MODE_TLL_4PIN_DPDM:
-		omap_mux_init_signal("usbb1_mm_rxrcv",
-			OMAP_PIN_INPUT_PULLDOWN);
-
-	case OMAP_OHCI_PORT_MODE_PHY_3PIN_DATSE0:
-	case OMAP_OHCI_PORT_MODE_TLL_3PIN_DATSE0:
-		omap_mux_init_signal("usbb1_mm_txen",
-			OMAP_PIN_INPUT_PULLDOWN);
-
-
-	case OMAP_OHCI_PORT_MODE_TLL_2PIN_DATSE0:
-	case OMAP_OHCI_PORT_MODE_TLL_2PIN_DPDM:
-		omap_mux_init_signal("usbb1_mm_txdat",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb1_mm_txse0",
-			OMAP_PIN_INPUT_PULLDOWN);
-		break;
-
-	case OMAP_USBHS_PORT_MODE_UNUSED:
-	default:
-		break;
+		/* unused */
+		case OMAP_USBHS_PORT_MODE_UNUSED:
+		default:
+			break;
+		}
 	}
 
-	switch (port_mode[1]) {
-	case OMAP_OHCI_PORT_MODE_PHY_6PIN_DATSE0:
-	case OMAP_OHCI_PORT_MODE_PHY_6PIN_DPDM:
-	case OMAP_OHCI_PORT_MODE_TLL_6PIN_DATSE0:
-	case OMAP_OHCI_PORT_MODE_TLL_6PIN_DPDM:
-		omap_mux_init_signal("usbb2_mm_rxdp",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb2_mm_rxdm",
-			OMAP_PIN_INPUT_PULLDOWN);
-
-	case OMAP_OHCI_PORT_MODE_PHY_4PIN_DPDM:
-	case OMAP_OHCI_PORT_MODE_TLL_4PIN_DPDM:
-		omap_mux_init_signal("usbb2_mm_rxrcv",
-			OMAP_PIN_INPUT_PULLDOWN);
-
-	case OMAP_OHCI_PORT_MODE_PHY_3PIN_DATSE0:
-	case OMAP_OHCI_PORT_MODE_TLL_3PIN_DATSE0:
-		omap_mux_init_signal("usbb2_mm_txen",
-			OMAP_PIN_INPUT_PULLDOWN);
-
-
-	case OMAP_OHCI_PORT_MODE_TLL_2PIN_DATSE0:
-	case OMAP_OHCI_PORT_MODE_TLL_2PIN_DPDM:
-		omap_mux_init_signal("usbb2_mm_txdat",
-			OMAP_PIN_INPUT_PULLDOWN);
-		omap_mux_init_signal("usbb2_mm_txse0",
-			OMAP_PIN_INPUT_PULLDOWN);
-		break;
-
-	case OMAP_USBHS_PORT_MODE_UNUSED:
-	default:
-		break;
-	}
+	kfree(pin_names);
 }
 
 void __init usbhs_init(struct usbhs_omap_platform_data *pdata)
@@ -482,18 +283,19 @@ void __init usbhs_init(struct usbhs_omap_platform_data *pdata)
 	struct platform_device	*pdev;
 	int			bus_id = -1;
 
-	if (cpu_is_omap34xx()) {
-		setup_ehci_io_mux(pdata->port_mode);
-		setup_ohci_io_mux(pdata->port_mode);
+	const char (*pin_template)[MAX_PIN_NAME];
+
+	pin_template = omap4_pin_template;
 
+	if (cpu_is_omap34xx()) {
 		if (omap_rev() <= OMAP3430_REV_ES2_1)
 			pdata->single_ulpi_bypass = true;
 
-	} else if (cpu_is_omap44xx()) {
-		setup_4430ehci_io_mux(pdata->port_mode);
-		setup_4430ohci_io_mux(pdata->port_mode);
+		pin_template = omap3_pin_template;
 	}
 
+	usbhs_setup_io_mux(pdata->port_mode, pin_template);
+
 	uhh_hwm = omap_hwmod_lookup(USBHS_UHH_HWMODNAME);
 	if (!uhh_hwm) {
 		pr_err("Could not look up %s\n", USBHS_UHH_HWMODNAME);
-- 
1.7.4.1

