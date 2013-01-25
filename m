Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858Ab3AYDPM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 22:15:12 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:49310 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756132Ab3AYDMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 22:12:53 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <rob.herring@calxeda.com>, <rob@landley.net>, <balbi@ti.com>,
        <sameo@linux.intel.com>, <gg@slimlogic.co.uk>, <s-guiriec@ti.com>,
        <broonie@opensource.wolfsonmicro.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>
CC: <grant.likely@secretlab.ca>, <gregkh@linuxfoundation.org>, <kishon@ti.com>
Subject: [PATCH v1 5/8] usb: otg: palmas-usb: use bool to read property instead of u32
Date: Fri, 25 Jan 2013 08:42:28 +0530
Message-ID: <1359083551-8524-6-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359083551-8524-1-git-send-email-kishon@ti.com>
References: <1359083551-8524-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

properies like wakeup and no_control_vbus can be represented in boolean,
so read those properties using of_property_read_bool.

Also updated the documentation with device tree binding information for
palmas-usb.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 .../devicetree/bindings/usb/twlxxxx-usb.txt        |   24 ++++++++++++++++++++
 drivers/usb/otg/palmas-usb.c                       |   15 +++---------
 2 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/Documentation/devicetree/bindings/usb/twlxxxx-usb.txt b/Documentation/devicetree/bindings/usb/twlxxxx-usb.txt
index 36b9aed..fa037ad 100644
--- a/Documentation/devicetree/bindings/usb/twlxxxx-usb.txt
+++ b/Documentation/devicetree/bindings/usb/twlxxxx-usb.txt
@@ -38,3 +38,27 @@ twl4030-usb {
 	usb3v1-supply = <&vusb3v1>;
 	usb_mode = <1>;
 };
+
+PALMAS USB COMPARATOR
+Required Properties:
+ - compatible : Should be "ti,palmas-usb"
+ - interrupts : Four interrupt numbers to the cpu should be specified. First
+   interrupt number is the otg interrupt number that raises ID interrupts when
+   the controller has to act as host and the second interrupt number is the
+   ID wakeup interrupt number, third interrupt is VBUS interrupt and fourth
+   interrupt is VBUS wakeup interrupt.
+-  interrupt-name : the name corresponding to each interrupt populated in
+   interrupts property.
+ - vbus-supply : phandle to the regulator device tree node.
+
+Optional Properties:
+ - ti,wakeup : To enable the wakeup comparator in probe
+ - ti,no_control_vbus: if the platform wishes its own vbus control
+
+palmas-usb {
+	compatible = "ti,palmas-usb";
+	interrupts = <20 0>, <21 0>, <22 0>, <23 0>;
+	interrupt-names = "ID", "ID_WAKEUP", "VBUS", "VBUS_WAKEUP";
+	vbus-supply = <&smps10_reg>;
+	ti,wakeup;
+};
diff --git a/drivers/usb/otg/palmas-usb.c b/drivers/usb/otg/palmas-usb.c
index 1bd8b15..2377836 100644
--- a/drivers/usb/otg/palmas-usb.c
+++ b/drivers/usb/otg/palmas-usb.c
@@ -235,18 +235,9 @@ static int palmas_start_srp(struct phy_companion *comparator)
 static void palmas_dt_to_pdata(struct device_node *node,
 		struct palmas_usb_platform_data *pdata)
 {
-	int ret;
-	u32 prop;
-
-	ret = of_property_read_u32(node, "ti,no_control_vbus", &prop);
-	if (!ret) {
-		pdata->no_control_vbus = prop;
-	}
-
-	ret = of_property_read_u32(node, "ti,wakeup", &prop);
-	if (!ret) {
-		pdata->wakeup = prop;
-	}
+	pdata->no_control_vbus = of_property_read_bool(node,
+					"ti,no_control_vbus");
+	pdata->wakeup = of_property_read_bool(node, "ti,wakeup");
 }
 
 static int palmas_usb_probe(struct platform_device *pdev)
-- 
1.7.9.5

