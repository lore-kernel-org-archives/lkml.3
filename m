Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397Ab3AWKj5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 05:39:57 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:42504 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755310Ab3AWKjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 05:39:20 -0500
From: Roger Quadros <rogerq@ti.com>
To: <sameo@linux.intel.com>
CC: <balbi@ti.com>, <tony@atomide.com>, <kishon@ti.com>,
        <sshtylyov@mvista.com>, <bjorn@mork.no>, <linux@arm.linux.org.uk>,
        <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <rogerq@ti.com>
Subject: [PATCH v9 18/20] mfd: omap-usb-host: clean up omap_usbhs_init()
Date: Wed, 23 Jan 2013 12:38:10 +0200
Message-ID: <1358937492-8129-19-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1358937492-8129-1-git-send-email-rogerq@ti.com>
References: <1358937492-8129-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We split initializing revision 1 and revision 2 into different
functions. Initialization is now done dynamically so that only
the number of ports available on the system are initialized.

Signed-off-by: Roger Quadros <rogerq@ti.com>
Reviewed-by: Felipe Balbi <balbi@ti.com>
---
 drivers/mfd/omap-usb-host.c |  129 +++++++++++++++++++++++++++----------------
 1 files changed, 81 insertions(+), 48 deletions(-)

diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index 0740c68..7f9c386 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -358,6 +358,75 @@ static int usbhs_runtime_suspend(struct device *dev)
 	return 0;
 }
 
+static unsigned omap_usbhs_rev1_hostconfig(struct usbhs_hcd_omap *omap,
+						unsigned reg)
+{
+	struct usbhs_omap_platform_data	*pdata = omap->pdata;
+	int i;
+
+	for (i = 0; i < omap->nports; i++) {
+		switch (pdata->port_mode[i]) {
+		case OMAP_USBHS_PORT_MODE_UNUSED:
+			reg &= ~(OMAP_UHH_HOSTCONFIG_P1_CONNECT_STATUS << i);
+			break;
+		case OMAP_EHCI_PORT_MODE_PHY:
+			if (pdata->single_ulpi_bypass)
+				break;
+
+			if (i == 0)
+				reg &= ~OMAP_UHH_HOSTCONFIG_ULPI_P1_BYPASS;
+			else
+				reg &= ~(OMAP_UHH_HOSTCONFIG_ULPI_P2_BYPASS
+								<< (i-1));
+			break;
+		default:
+			if (pdata->single_ulpi_bypass)
+				break;
+
+			if (i == 0)
+				reg |= OMAP_UHH_HOSTCONFIG_ULPI_P1_BYPASS;
+			else
+				reg |= OMAP_UHH_HOSTCONFIG_ULPI_P2_BYPASS
+								<< (i-1);
+			break;
+		}
+	}
+
+	if (pdata->single_ulpi_bypass) {
+		/* bypass ULPI only if none of the ports use PHY mode */
+		reg |= OMAP_UHH_HOSTCONFIG_ULPI_BYPASS;
+
+		for (i = 0; i < omap->nports; i++) {
+			if (is_ehci_phy_mode(pdata->port_mode[i])) {
+				reg &= OMAP_UHH_HOSTCONFIG_ULPI_BYPASS;
+				break;
+			}
+		}
+	}
+
+	return reg;
+}
+
+static unsigned omap_usbhs_rev2_hostconfig(struct usbhs_hcd_omap *omap,
+						unsigned reg)
+{
+	struct usbhs_omap_platform_data	*pdata = omap->pdata;
+	int i;
+
+	for (i = 0; i < omap->nports; i++) {
+		/* Clear port mode fields for PHY mode */
+		reg &= ~(OMAP4_P1_MODE_CLEAR << 2 * i);
+
+		if (is_ehci_tll_mode(pdata->port_mode[i]) ||
+				(is_ohci_port(pdata->port_mode[i])))
+			reg |= OMAP4_P1_MODE_TLL << 2 * i;
+		else if (is_ehci_hsic_mode(pdata->port_mode[i]))
+			reg |= OMAP4_P1_MODE_HSIC << 2 * i;
+	}
+
+	return reg;
+}
+
 static void omap_usbhs_init(struct device *dev)
 {
 	struct usbhs_hcd_omap		*omap = dev_get_drvdata(dev);
@@ -389,54 +458,18 @@ static void omap_usbhs_init(struct device *dev)
 	reg |= OMAP4_UHH_HOSTCONFIG_APP_START_CLK;
 	reg &= ~OMAP_UHH_HOSTCONFIG_INCRX_ALIGN_EN;
 
-	if (is_omap_usbhs_rev1(omap)) {
-		if (pdata->port_mode[0] == OMAP_USBHS_PORT_MODE_UNUSED)
-			reg &= ~OMAP_UHH_HOSTCONFIG_P1_CONNECT_STATUS;
-		if (pdata->port_mode[1] == OMAP_USBHS_PORT_MODE_UNUSED)
-			reg &= ~OMAP_UHH_HOSTCONFIG_P2_CONNECT_STATUS;
-		if (pdata->port_mode[2] == OMAP_USBHS_PORT_MODE_UNUSED)
-			reg &= ~OMAP_UHH_HOSTCONFIG_P3_CONNECT_STATUS;
-
-		/* Bypass the TLL module for PHY mode operation */
-		if (pdata->single_ulpi_bypass) {
-			dev_dbg(dev, "OMAP3 ES version <= ES2.1\n");
-			if (is_ehci_phy_mode(pdata->port_mode[0]) ||
-				is_ehci_phy_mode(pdata->port_mode[1]) ||
-					is_ehci_phy_mode(pdata->port_mode[2]))
-				reg &= ~OMAP_UHH_HOSTCONFIG_ULPI_BYPASS;
-			else
-				reg |= OMAP_UHH_HOSTCONFIG_ULPI_BYPASS;
-		} else {
-			dev_dbg(dev, "OMAP3 ES version > ES2.1\n");
-			if (is_ehci_phy_mode(pdata->port_mode[0]))
-				reg &= ~OMAP_UHH_HOSTCONFIG_ULPI_P1_BYPASS;
-			else
-				reg |= OMAP_UHH_HOSTCONFIG_ULPI_P1_BYPASS;
-			if (is_ehci_phy_mode(pdata->port_mode[1]))
-				reg &= ~OMAP_UHH_HOSTCONFIG_ULPI_P2_BYPASS;
-			else
-				reg |= OMAP_UHH_HOSTCONFIG_ULPI_P2_BYPASS;
-			if (is_ehci_phy_mode(pdata->port_mode[2]))
-				reg &= ~OMAP_UHH_HOSTCONFIG_ULPI_P3_BYPASS;
-			else
-				reg |= OMAP_UHH_HOSTCONFIG_ULPI_P3_BYPASS;
-		}
-	} else if (is_omap_usbhs_rev2(omap)) {
-		/* Clear port mode fields for PHY mode*/
-		reg &= ~OMAP4_P1_MODE_CLEAR;
-		reg &= ~OMAP4_P2_MODE_CLEAR;
-
-		if (is_ehci_tll_mode(pdata->port_mode[0]) ||
-			(is_ohci_port(pdata->port_mode[0])))
-			reg |= OMAP4_P1_MODE_TLL;
-		else if (is_ehci_hsic_mode(pdata->port_mode[0]))
-			reg |= OMAP4_P1_MODE_HSIC;
-
-		if (is_ehci_tll_mode(pdata->port_mode[1]) ||
-			(is_ohci_port(pdata->port_mode[1])))
-			reg |= OMAP4_P2_MODE_TLL;
-		else if (is_ehci_hsic_mode(pdata->port_mode[1]))
-			reg |= OMAP4_P2_MODE_HSIC;
+	switch (omap->usbhs_rev) {
+	case OMAP_USBHS_REV1:
+		omap_usbhs_rev1_hostconfig(omap, reg);
+		break;
+
+	case OMAP_USBHS_REV2:
+		omap_usbhs_rev2_hostconfig(omap, reg);
+		break;
+
+	default:	/* newer revisions */
+		omap_usbhs_rev2_hostconfig(omap, reg);
+		break;
 	}
 
 	usbhs_write(omap->uhh_base, OMAP_UHH_HOSTCONFIG, reg);
-- 
1.7.4.1

