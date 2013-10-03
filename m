Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361Ab3JCKAI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 06:00:08 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:59986 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753317Ab3JCKAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 06:00:01 -0400
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>, <bcousson@baylibre.com>
CC: <tony@atomide.com>, <george.cherian@ti.com>, <kishon@ti.com>,
        <bigeasy@linutronix.de>, <sergei.shtylyov@cogentembedded.com>,
        <thomas.langer@lantiq.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH v8 5/8] usb: musb: omap2430: Don't use omap_get_control_dev()
Date: Thu, 3 Oct 2013 12:59:03 +0300
Message-ID: <1380794346-30185-6-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1380794346-30185-1-git-send-email-rogerq@ti.com>
References: <1380794346-30185-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

omap_get_control_dev() is being deprecated as it doesn't support
multiple instances. As control device is present only from OMAP4
onwards which supports DT only, we use phandles to get the
reference to the control device.

Also get rid of "ti,has-mailbox" property as it is redundant and
we can determine that from whether "ctrl-module" property is present
or not. Get rid of has_mailbox from musb_hdrc_platform_data as well.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 Documentation/devicetree/bindings/usb/omap-usb.txt |    4 ---
 drivers/usb/musb/omap2430.c                        |   25 +++++++++++--------
 include/linux/usb/musb.h                           |    2 -
 3 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/Documentation/devicetree/bindings/usb/omap-usb.txt b/Documentation/devicetree/bindings/usb/omap-usb.txt
index 9add35c..090e5e2 100644
--- a/Documentation/devicetree/bindings/usb/omap-usb.txt
+++ b/Documentation/devicetree/bindings/usb/omap-usb.txt
@@ -3,9 +3,6 @@ OMAP GLUE AND OTHER OMAP SPECIFIC COMPONENTS
 OMAP MUSB GLUE
  - compatible : Should be "ti,omap4-musb" or "ti,omap3-musb"
  - ti,hwmods : must be "usb_otg_hs"
- - ti,has-mailbox : to specify that omap uses an external mailbox
-   (in control module) to communicate with the musb core during device connect
-   and disconnect.
  - multipoint : Should be "1" indicating the musb controller supports
    multipoint. This is a MUSB configuration-specific setting.
  - num-eps : Specifies the number of endpoints. This is also a
@@ -31,7 +28,6 @@ SOC specific device node entry
 usb_otg_hs: usb_otg_hs@4a0ab000 {
 	compatible = "ti,omap4-musb";
 	ti,hwmods = "usb_otg_hs";
-	ti,has-mailbox;
 	multipoint = <1>;
 	num-eps = <16>;
 	ram-bits = <12>;
diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
index d0fc4d9..9eab645 100644
--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -38,6 +38,7 @@
 #include <linux/delay.h>
 #include <linux/usb/musb-omap.h>
 #include <linux/usb/omap_control_usb.h>
+#include <linux/of_platform.h>
 
 #include "musb_core.h"
 #include "omap2430.h"
@@ -524,8 +525,12 @@ static int omap2430_probe(struct platform_device *pdev)
 	glue->dev			= &pdev->dev;
 	glue->musb			= musb;
 	glue->status			= OMAP_MUSB_UNKNOWN;
+	glue->control_otghs = ERR_PTR(-ENODEV);
 
 	if (np) {
+		struct device_node *control_node;
+		struct platform_device *control_pdev;
+
 		pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
 		if (!pdata) {
 			dev_err(&pdev->dev,
@@ -554,22 +559,20 @@ static int omap2430_probe(struct platform_device *pdev)
 		of_property_read_u32(np, "ram-bits", (u32 *)&config->ram_bits);
 		of_property_read_u32(np, "power", (u32 *)&pdata->power);
 		config->multipoint = of_property_read_bool(np, "multipoint");
-		pdata->has_mailbox = of_property_read_bool(np,
-		    "ti,has-mailbox");
 
 		pdata->board_data	= data;
 		pdata->config		= config;
-	}
 
-	if (pdata->has_mailbox) {
-		glue->control_otghs = omap_get_control_dev();
-		if (IS_ERR(glue->control_otghs)) {
-			dev_vdbg(&pdev->dev, "Failed to get control device\n");
-			ret = PTR_ERR(glue->control_otghs);
-			goto err2;
+		control_node = of_parse_phandle(np, "ctrl-module", 0);
+		if (control_node) {
+			control_pdev = of_find_device_by_node(control_node);
+			if (!control_pdev) {
+				dev_err(&pdev->dev, "Failed to get control device\n");
+				ret = -EINVAL;
+				goto err2;
+			}
+			glue->control_otghs = &control_pdev->dev;
 		}
-	} else {
-		glue->control_otghs = ERR_PTR(-ENODEV);
 	}
 	pdata->platform_ops		= &omap2430_ops;
 
diff --git a/include/linux/usb/musb.h b/include/linux/usb/musb.h
index 053c268..eb50525 100644
--- a/include/linux/usb/musb.h
+++ b/include/linux/usb/musb.h
@@ -99,8 +99,6 @@ struct musb_hdrc_platform_data {
 	/* MUSB_HOST, MUSB_PERIPHERAL, or MUSB_OTG */
 	u8		mode;
 
-	u8		has_mailbox:1;
-
 	/* for clk_get() */
 	const char	*clock;
 
-- 
1.7.4.1

