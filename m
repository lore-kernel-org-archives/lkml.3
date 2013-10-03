Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab3JCKB0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 06:01:26 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54742 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754032Ab3JCKAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 06:00:05 -0400
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>, <bcousson@baylibre.com>
CC: <tony@atomide.com>, <george.cherian@ti.com>, <kishon@ti.com>,
        <bigeasy@linutronix.de>, <sergei.shtylyov@cogentembedded.com>,
        <thomas.langer@lantiq.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH v8 7/8] usb: phy: omap: get rid of omap_get_control_dev()
Date: Thu, 3 Oct 2013 12:59:05 +0300
Message-ID: <1380794346-30185-8-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1380794346-30185-1-git-send-email-rogerq@ti.com>
References: <1380794346-30185-1-git-send-email-rogerq@ti.com>
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
index 1c8a7c5..09c5ace 100644
--- a/drivers/usb/phy/phy-omap-control.c
+++ b/drivers/usb/phy/phy-omap-control.c
@@ -26,26 +26,6 @@
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
@@ -182,11 +162,19 @@ void omap_control_usb_set_mode(struct device *dev,
 {
 	struct omap_control_usb	*ctrl_usb;
 
-	if (IS_ERR(dev) || control_usb->type != OMAP_CTRL_TYPE_OTGHS)
+	if (IS_ERR(dev) || !dev)
 		return;
 
 	ctrl_usb = dev_get_drvdata(dev);
 
+	if (!ctrl_usb) {
+		dev_err(dev, "Invalid control usb device\n");
+		return;
+	}
+
+	if (ctrl_usb->type != OMAP_CTRL_TYPE_OTGHS)
+		return;
+
 	switch (mode) {
 	case USB_MODE_HOST:
 		omap_control_usb_host_mode(ctrl_usb);
@@ -237,6 +225,7 @@ static int omap_control_usb_probe(struct platform_device *pdev)
 {
 	struct resource	*res;
 	const struct of_device_id *of_id;
+	struct omap_control_usb *control_usb;
 
 	of_id = of_match_device(of_match_ptr(omap_control_usb_id_table),
 								&pdev->dev);
diff --git a/include/linux/usb/omap_control_usb.h b/include/linux/usb/omap_control_usb.h
index 61b889a..596b019 100644
--- a/include/linux/usb/omap_control_usb.h
+++ b/include/linux/usb/omap_control_usb.h
@@ -65,15 +65,10 @@ enum omap_control_usb_mode {
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

