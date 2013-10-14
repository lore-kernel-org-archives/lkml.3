Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643Ab3JNMvc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 08:51:32 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:57807 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756427Ab3JNMv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 08:51:29 -0400
From: George Cherian <george.cherian@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>
CC: <tony@atomide.com>, <rogerq@ti.com>, <kishon@ti.com>,
        <gregkh@linuxfoundation.org>, <balbi@ti.com>, <rob@landley.net>,
        <ijc+devicetree@hellion.org.uk>, <swarren@wwwdotorg.org>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>,
        <rob.herring@calxeda.com>, George Cherian <george.cherian@ti.com>
Subject: [PATCH] usb: phy: omap: Add omap-control Support for AM437x
Date: Mon, 14 Oct 2013 18:21:11 +0530
Message-ID: <1381755071-11931-1-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds omap control module support for USBSS in AM437x SoC.
Update DT binding information to reflect these changes.

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 Documentation/devicetree/bindings/usb/omap-usb.txt |  2 ++
 drivers/usb/phy/phy-omap-control.c                 | 17 +++++++++++++++++
 include/linux/usb/omap_control_usb.h               |  6 ++++++
 3 files changed, 25 insertions(+)

diff --git a/Documentation/devicetree/bindings/usb/omap-usb.txt b/Documentation/devicetree/bindings/usb/omap-usb.txt
index 090e5e2..c495135 100644
--- a/Documentation/devicetree/bindings/usb/omap-usb.txt
+++ b/Documentation/devicetree/bindings/usb/omap-usb.txt
@@ -87,6 +87,8 @@ Required properties:
 			e.g. USB3 PHY and SATA PHY on OMAP5.
  "ti,control-phy-dra7usb2" - if it has power down register like USB2 PHY on
 			DRA7 platform.
+ "ti,control-phy-am437usb2" - if it has power down register like USB2 PHY on
+			AM437 platform.
  - reg : Address and length of the register set for the device. It contains
    the address of "otghs_control" for control-phy-otghs or "power" register
    for other types.
diff --git a/drivers/usb/phy/phy-omap-control.c b/drivers/usb/phy/phy-omap-control.c
index 09c5ace..c453b81 100644
--- a/drivers/usb/phy/phy-omap-control.c
+++ b/drivers/usb/phy/phy-omap-control.c
@@ -84,6 +84,18 @@ void omap_control_usb_phy_power(struct device *dev, int on)
 		else
 			val |= OMAP_CTRL_USB2_PHY_PD;
 		break;
+
+	case OMAP_CTRL_TYPE_AM437USB2:
+		if (on) {
+			val &= ~(AM437X_CTRL_USB2_PHY_PD |
+					AM437X_CTRL_USB2_OTG_PD);
+			val |= (AM437X_CTRL_USB2_OTGVDET_EN |
+					AM437X_CTRL_USB2_OTGSESSEND_EN);
+		} else {
+			val |= (AM437X_CTRL_USB2_PHY_PD |
+					 AM437X_CTRL_USB2_OTG_PD);
+		}
+		break;
 	default:
 		dev_err(dev, "%s: type %d not recognized\n",
 					__func__, control_usb->type);
@@ -197,6 +209,7 @@ static const enum omap_control_usb_type otghs_data = OMAP_CTRL_TYPE_OTGHS;
 static const enum omap_control_usb_type usb2_data = OMAP_CTRL_TYPE_USB2;
 static const enum omap_control_usb_type pipe3_data = OMAP_CTRL_TYPE_PIPE3;
 static const enum omap_control_usb_type dra7usb2_data = OMAP_CTRL_TYPE_DRA7USB2;
+static const enum omap_control_usb_type am437usb2_data = OMAP_CTRL_TYPE_AM437USB2;
 
 static const struct of_device_id omap_control_usb_id_table[] = {
 	{
@@ -215,6 +228,10 @@ static const struct of_device_id omap_control_usb_id_table[] = {
 		.compatible = "ti,control-phy-dra7usb2",
 		.data = &dra7usb2_data,
 	},
+	{
+		.compatible = "ti,control-phy-am437usb2",
+		.data = &am437usb2_data,
+	},
 	{},
 };
 MODULE_DEVICE_TABLE(of, omap_control_usb_id_table);
diff --git a/include/linux/usb/omap_control_usb.h b/include/linux/usb/omap_control_usb.h
index 596b019..69ae383 100644
--- a/include/linux/usb/omap_control_usb.h
+++ b/include/linux/usb/omap_control_usb.h
@@ -24,6 +24,7 @@ enum omap_control_usb_type {
 	OMAP_CTRL_TYPE_USB2,	/* USB2_PHY, power down in CONTROL_DEV_CONF */
 	OMAP_CTRL_TYPE_PIPE3,	/* PIPE3 PHY, DPLL & seperate Rx/Tx power */
 	OMAP_CTRL_TYPE_DRA7USB2, /* USB2 PHY, power and power_aux e.g. DRA7 */
+	OMAP_CTRL_TYPE_AM437USB2, /* USB2 PHY, power e.g. AM437x */
 };
 
 struct omap_control_usb {
@@ -64,6 +65,11 @@ enum omap_control_usb_mode {
 
 #define OMAP_CTRL_USB2_PHY_PD		BIT(28)
 
+#define AM437X_CTRL_USB2_PHY_PD		BIT(0)
+#define AM437X_CTRL_USB2_OTG_PD		BIT(1)
+#define AM437X_CTRL_USB2_OTGVDET_EN	BIT(19)
+#define AM437X_CTRL_USB2_OTGSESSEND_EN	BIT(20)
+
 #if IS_ENABLED(CONFIG_OMAP_CONTROL_USB)
 extern void omap_control_usb_phy_power(struct device *dev, int on);
 extern void omap_control_usb_set_mode(struct device *dev,
-- 
1.8.1

