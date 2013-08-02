Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab3HBAxo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 20:53:44 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:41755 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160Ab3HBAxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 20:53:07 -0400
From: Julius Werner <jwerner@chromium.org>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, Tomasz Figa <t.figa@samsung.com>,
        Vivek Gautam <gautam.vivek@samsung.com>, devicetree@vger.kernel.org,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Julius Werner <jwerner@chromium.org>
Subject: [PATCH 3/3] usb: phy-samsung-usb: Remove USB_PHY_TYPE from Samsung PHY driver
Date: Thu,  1 Aug 2013 17:52:06 -0700
Message-Id: <1375404726-26264-4-git-send-email-jwerner@chromium.org>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1375404726-26264-1-git-send-email-jwerner@chromium.org>
References: <1375404726-26264-1-git-send-email-jwerner@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the PMU register handling was simplified, the last reason to
differentiate between HOST and DEVICE PHYs in the Samsung USB PHY driver
has disappeared. This patch removes that variable and reworks
surrounding code to live without it to make the driver a little smaller
and cleaner.

Signed-off-by: Julius Werner <jwerner@chromium.org>
---
 drivers/usb/phy/phy-samsung-usb.c  | 23 +++--------------------
 drivers/usb/phy/phy-samsung-usb.h  |  7 +------
 drivers/usb/phy/phy-samsung-usb2.c | 19 +++----------------
 drivers/usb/phy/phy-samsung-usb3.c |  7 -------
 4 files changed, 7 insertions(+), 49 deletions(-)

diff --git a/drivers/usb/phy/phy-samsung-usb.c b/drivers/usb/phy/phy-samsung-usb.c
index fa382c9..32c5264 100644
--- a/drivers/usb/phy/phy-samsung-usb.c
+++ b/drivers/usb/phy/phy-samsung-usb.c
@@ -27,7 +27,6 @@
 #include <linux/io.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
-#include <linux/usb/samsung_usb_phy.h>
 
 #include "phy-samsung-usb.h"
 
@@ -101,7 +100,7 @@ EXPORT_SYMBOL_GPL(samsung_usbphy_set_isolation_4210);
 /*
  * Configure the mode of working of usb-phy here: HOST/DEVICE.
  */
-void samsung_usbphy_cfg_sel(struct samsung_usbphy *sphy)
+void samsung_usbphy_cfg_sel(struct samsung_usbphy *sphy, bool device_mode)
 {
 	u32 reg;
 
@@ -112,31 +111,15 @@ void samsung_usbphy_cfg_sel(struct samsung_usbphy *sphy)
 
 	reg = readl(sphy->sysreg);
 
-	if (sphy->phy_type == USB_PHY_TYPE_DEVICE)
+	if (device_mode)
 		reg &= ~EXYNOS_USB20PHY_CFG_HOST_LINK;
-	else if (sphy->phy_type == USB_PHY_TYPE_HOST)
+	else
 		reg |= EXYNOS_USB20PHY_CFG_HOST_LINK;
 
 	writel(reg, sphy->sysreg);
 }
 EXPORT_SYMBOL_GPL(samsung_usbphy_cfg_sel);
 
-/*
- * PHYs are different for USB Device and USB Host.
- * This make sure that correct PHY type is selected before
- * any operation on PHY.
- */
-int samsung_usbphy_set_type(struct usb_phy *phy,
-				enum samsung_usb_phy_type phy_type)
-{
-	struct samsung_usbphy *sphy = phy_to_sphy(phy);
-
-	sphy->phy_type = phy_type;
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(samsung_usbphy_set_type);
-
 int samsung_usbphy_rate_to_clksel_64xx(struct samsung_usbphy *sphy,
 							unsigned long rate)
 {
diff --git a/drivers/usb/phy/phy-samsung-usb.h b/drivers/usb/phy/phy-samsung-usb.h
index f2e9c4a..0c0d7d1 100644
--- a/drivers/usb/phy/phy-samsung-usb.h
+++ b/drivers/usb/phy/phy-samsung-usb.h
@@ -285,8 +285,6 @@ struct samsung_usbphy_drvdata {
  * @sysreg: USB2.0 PHY_CFG register memory base
  * @ref_clk_freq: reference clock frequency selection
  * @drv_data: driver data available for different SoCs
- * @phy_type: Samsung SoCs specific phy types:	#HOST
- *						#DEVICE
  * @phy_usage: usage count for phy
  * @lock: lock for phy operations
  */
@@ -300,7 +298,6 @@ struct samsung_usbphy {
 	void __iomem	*sysreg;
 	int		ref_clk_freq;
 	const struct samsung_usbphy_drvdata *drv_data;
-	enum samsung_usb_phy_type phy_type;
 	atomic_t	phy_usage;
 	spinlock_t	lock;
 };
@@ -326,9 +323,7 @@ static inline const struct samsung_usbphy_drvdata
 extern int samsung_usbphy_parse_dt(struct samsung_usbphy *sphy);
 extern void samsung_usbphy_set_isolation_4210(struct samsung_usbphy *sphy,
 								bool on);
-extern void samsung_usbphy_cfg_sel(struct samsung_usbphy *sphy);
-extern int samsung_usbphy_set_type(struct usb_phy *phy,
-					enum samsung_usb_phy_type phy_type);
+extern void samsung_usbphy_cfg_sel(struct samsung_usbphy *sphy, bool dev_mode);
 extern int samsung_usbphy_get_refclk_freq(struct samsung_usbphy *sphy);
 extern int samsung_usbphy_rate_to_clksel_64xx(struct samsung_usbphy *sphy,
 							unsigned long rate);
diff --git a/drivers/usb/phy/phy-samsung-usb2.c b/drivers/usb/phy/phy-samsung-usb2.c
index c2c83d4..eb215a1 100644
--- a/drivers/usb/phy/phy-samsung-usb2.c
+++ b/drivers/usb/phy/phy-samsung-usb2.c
@@ -27,7 +27,6 @@
 #include <linux/io.h>
 #include <linux/of.h>
 #include <linux/usb/otg.h>
-#include <linux/usb/samsung_usb_phy.h>
 #include <linux/platform_data/samsung-usbphy.h>
 
 #include "phy-samsung-usb.h"
@@ -283,13 +282,13 @@ static int samsung_usb2phy_init(struct usb_phy *phy)
 
 	spin_lock_irqsave(&sphy->lock, flags);
 
+	/* Selecting Host/OTG mode; After reset USB2.0PHY_CFG: HOST */
 	if (host) {
-		/* setting default phy-type for USB 2.0 */
 		if (!strstr(dev_name(host->controller), "ehci") ||
 				!strstr(dev_name(host->controller), "ohci"))
-			samsung_usbphy_set_type(&sphy->phy, USB_PHY_TYPE_HOST);
+			samsung_usbphy_cfg_sel(sphy, false);
 	} else {
-		samsung_usbphy_set_type(&sphy->phy, USB_PHY_TYPE_DEVICE);
+		samsung_usbphy_cfg_sel(sphy, true);
 	}
 
 	/* Disable phy isolation */
@@ -298,9 +297,6 @@ static int samsung_usb2phy_init(struct usb_phy *phy)
 	else if (sphy->drv_data->set_isolation)
 		sphy->drv_data->set_isolation(sphy, false);
 
-	/* Selecting Host/OTG mode; After reset USB2.0PHY_CFG: HOST */
-	samsung_usbphy_cfg_sel(sphy);
-
 	/* Initialize usb phy registers */
 	sphy->drv_data->phy_enable(sphy);
 
@@ -332,15 +328,6 @@ static void samsung_usb2phy_shutdown(struct usb_phy *phy)
 
 	spin_lock_irqsave(&sphy->lock, flags);
 
-	if (host) {
-		/* setting default phy-type for USB 2.0 */
-		if (!strstr(dev_name(host->controller), "ehci") ||
-				!strstr(dev_name(host->controller), "ohci"))
-			samsung_usbphy_set_type(&sphy->phy, USB_PHY_TYPE_HOST);
-	} else {
-		samsung_usbphy_set_type(&sphy->phy, USB_PHY_TYPE_DEVICE);
-	}
-
 	/* De-initialize usb phy registers */
 	sphy->drv_data->phy_disable(sphy);
 
diff --git a/drivers/usb/phy/phy-samsung-usb3.c b/drivers/usb/phy/phy-samsung-usb3.c
index 6259a35..ac05d91 100644
--- a/drivers/usb/phy/phy-samsung-usb3.c
+++ b/drivers/usb/phy/phy-samsung-usb3.c
@@ -24,7 +24,6 @@
 #include <linux/err.h>
 #include <linux/io.h>
 #include <linux/of.h>
-#include <linux/usb/samsung_usb_phy.h>
 #include <linux/platform_data/samsung-usbphy.h>
 
 #include "phy-samsung-usb.h"
@@ -178,9 +177,6 @@ static int samsung_usb3phy_init(struct usb_phy *phy)
 
 	spin_lock_irqsave(&sphy->lock, flags);
 
-	/* setting default phy-type for USB 3.0 */
-	samsung_usbphy_set_type(&sphy->phy, USB_PHY_TYPE_DEVICE);
-
 	/* Disable phy isolation */
 	if (sphy->drv_data->set_isolation)
 		sphy->drv_data->set_isolation(sphy, false);
@@ -213,9 +209,6 @@ static void samsung_usb3phy_shutdown(struct usb_phy *phy)
 
 	spin_lock_irqsave(&sphy->lock, flags);
 
-	/* setting default phy-type for USB 3.0 */
-	samsung_usbphy_set_type(&sphy->phy, USB_PHY_TYPE_DEVICE);
-
 	/* De-initialize usb phy registers */
 	sphy->drv_data->phy_disable(sphy);
 
-- 
1.7.12.4

