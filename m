Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689Ab3HAOHG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 10:07:06 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56926 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756346Ab3HAOFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 10:05:33 -0400
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>
CC: <tony@atomide.com>, <kishon@ti.com>, <george.cherian@ti.com>,
        <dmurphy@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 5/7] usb: phy: omap: get rid of omap_get_control_dev()
Date: Thu, 1 Aug 2013 17:05:13 +0300
Message-ID: <1375365915-21380-6-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1375365915-21380-1-git-send-email-rogerq@ti.com>
References: <1375365915-21380-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function was preventing us from supporting multiple
instances. Get rid of it. Since we support DT boots only,
users can get the control device phandle from the DT node.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/usb/phy/phy-omap-control.c   |   31 ++++++++++---------------------
 include/linux/usb/omap_control_usb.h |    5 -----
 2 files changed, 10 insertions(+), 26 deletions(-)

diff --git a/drivers/usb/phy/phy-omap-control.c b/drivers/usb/phy/phy-omap-control.c
index cf93c5a..015eeef 100644
--- a/drivers/usb/phy/phy-omap-control.c
+++ b/drivers/usb/phy/phy-omap-control.c
@@ -25,26 +25,6 @@
 #include <linux/clk.h>
 #include <linux/usb/omap_control_usb.h>
 
-static struct omap_control_usb *control_usb;
-
-/**
- * omap_get_control_dev - returns the device pointer for this control device
- *
- * This API should be called to get the device pointer for this control
- * module device. This device pointer should be used for called other
- * exported API's in this driver.
- *
- * To be used by PHY driver and glue driver.
- */
-struct device *omap_get_control_dev(void)
-{
-	if (!control_usb)
-		return ERR_PTR(-ENODEV);
-
-	return control_usb->dev;
-}
-EXPORT_SYMBOL_GPL(omap_get_control_dev);
-
 /**
  * omap_control_usb_phy_power - power on/off the phy using control module reg
  * @dev: the control module device
@@ -187,11 +167,19 @@ void omap_control_usb_set_mode(struct device *dev,
 {
 	struct omap_control_usb	*ctrl_usb;
 
-	if (IS_ERR(dev) || control_usb->type != OMAP_CTRL_DEV_TYPE1)
+	if (IS_ERR(dev) || !dev)
 		return;
 
 	ctrl_usb = dev_get_drvdata(dev);
 
+	if (!ctrl_usb) {
+		dev_err(dev, "Invalid control usb device\n");
+		return;
+	}
+
+	if (ctrl_usb->type != OMAP_CTRL_DEV_TYPE1)
+		return;
+
 	switch (mode) {
 	case USB_MODE_HOST:
 		omap_control_usb_host_mode(ctrl_usb);
@@ -214,6 +202,7 @@ static int omap_control_usb_probe(struct platform_device *pdev)
 	struct device_node *np = pdev->dev.of_node;
 	struct omap_control_usb_platform_data *pdata =
 			dev_get_platdata(&pdev->dev);
+	struct omap_control_usb *control_usb;
 
 	control_usb = devm_kzalloc(&pdev->dev, sizeof(*control_usb),
 		GFP_KERNEL);
diff --git a/include/linux/usb/omap_control_usb.h b/include/linux/usb/omap_control_usb.h
index 7f027d3..8b48584 100644
--- a/include/linux/usb/omap_control_usb.h
+++ b/include/linux/usb/omap_control_usb.h
@@ -67,15 +67,10 @@ enum omap_control_usb_mode {
 #define OMAP_CTRL_USB2_PHY_PD		BIT(28)
 
 #if IS_ENABLED(CONFIG_OMAP_CONTROL_USB)
-extern struct device *omap_get_control_dev(void);
 extern void omap_control_usb_phy_power(struct device *dev, int on);
 extern void omap_control_usb_set_mode(struct device *dev,
 	enum omap_control_usb_mode mode);
 #else
-static inline struct device *omap_get_control_dev(void)
-{
-	return ERR_PTR(-ENODEV);
-}
 
 static inline void omap_control_usb_phy_power(struct device *dev, int on)
 {
-- 
1.7.4.1

