Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336AbaHNOYi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 10:24:38 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:63515 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755312AbaHNOYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 10:24:33 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, balbi@ti.com
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        grant.likely@linaro.org, gregkh@linuxfoundation.org,
        stern@rowland.harvard.edu, jg1.han@samsung.com, s.nawrocki@samsung.com,
        k.debski@samsung.com, Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH RFC 4/7] usb-phy: samsung-usb2: Remove support for Exynos4210
Date: Thu, 14 Aug 2014 19:53:57 +0530
Message-Id: <1408026240-28365-5-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1408026240-28365-1-git-send-email-gautam.vivek@samsung.com>
References: <1408026240-28365-1-git-send-email-gautam.vivek@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have moved to new PHY driver for Exynos4210's USB 2.0
controller, which is based on generic phy framework; so removing
the code for Exyno4210.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 drivers/usb/phy/phy-samsung-usb.c  |   35 -----------------------------------
 drivers/usb/phy/phy-samsung-usb.h  |    4 ----
 drivers/usb/phy/phy-samsung-usb2.c |   23 -----------------------
 3 files changed, 62 deletions(-)

diff --git a/drivers/usb/phy/phy-samsung-usb.c b/drivers/usb/phy/phy-samsung-usb.c
index 0e40db1..51c4102 100644
--- a/drivers/usb/phy/phy-samsung-usb.c
+++ b/drivers/usb/phy/phy-samsung-usb.c
@@ -69,41 +69,6 @@ err0:
 EXPORT_SYMBOL_GPL(samsung_usbphy_parse_dt);
 
 /*
- * Set isolation here for phy.
- * Here 'on = true' would mean USB PHY block is isolated, hence
- * de-activated and vice-versa.
- */
-void samsung_usbphy_set_isolation_4210(struct samsung_usbphy *sphy, bool on)
-{
-	void __iomem *reg = NULL;
-	u32 reg_val;
-	u32 en_mask = 0;
-
-	if (!sphy->pmuregs) {
-		dev_warn(sphy->dev, "Can't set pmu isolation\n");
-		return;
-	}
-
-	if (sphy->phy_type == USB_PHY_TYPE_DEVICE) {
-		reg = sphy->pmuregs + sphy->drv_data->devphy_reg_offset;
-		en_mask = sphy->drv_data->devphy_en_mask;
-	} else if (sphy->phy_type == USB_PHY_TYPE_HOST) {
-		reg = sphy->pmuregs + sphy->drv_data->hostphy_reg_offset;
-		en_mask = sphy->drv_data->hostphy_en_mask;
-	}
-
-	reg_val = readl(reg);
-
-	if (on)
-		reg_val &= ~en_mask;
-	else
-		reg_val |= en_mask;
-
-	writel(reg_val, reg);
-}
-EXPORT_SYMBOL_GPL(samsung_usbphy_set_isolation_4210);
-
-/*
  * Configure the mode of working of usb-phy here: HOST/DEVICE.
  */
 void samsung_usbphy_cfg_sel(struct samsung_usbphy *sphy)
diff --git a/drivers/usb/phy/phy-samsung-usb.h b/drivers/usb/phy/phy-samsung-usb.h
index 9d03e3b..b36fd88 100644
--- a/drivers/usb/phy/phy-samsung-usb.h
+++ b/drivers/usb/phy/phy-samsung-usb.h
@@ -52,12 +52,10 @@
 #endif
 
 #define S3C64XX_USBPHY_ENABLE			(0x1 << 16)
-#define EXYNOS_USBPHY_ENABLE			(0x1 << 0)
 #define EXYNOS_USB20PHY_CFG_HOST_LINK		(0x1 << 0)
 
 enum samsung_cpu_type {
 	TYPE_S3C64XX,
-	TYPE_EXYNOS4210,
 };
 
 struct samsung_usbphy;
@@ -142,8 +140,6 @@ static inline const struct samsung_usbphy_drvdata
 }
 
 extern int samsung_usbphy_parse_dt(struct samsung_usbphy *sphy);
-extern void samsung_usbphy_set_isolation_4210(struct samsung_usbphy *sphy,
-								bool on);
 extern void samsung_usbphy_cfg_sel(struct samsung_usbphy *sphy);
 extern int samsung_usbphy_set_type(struct usb_phy *phy,
 					enum samsung_usb_phy_type phy_type);
diff --git a/drivers/usb/phy/phy-samsung-usb2.c b/drivers/usb/phy/phy-samsung-usb2.c
index 6b5ce21..2bcc948 100644
--- a/drivers/usb/phy/phy-samsung-usb2.c
+++ b/drivers/usb/phy/phy-samsung-usb2.c
@@ -60,10 +60,6 @@ static void samsung_usb2phy_enable(struct samsung_usbphy *sphy)
 		phyclk &= ~PHYCLK_COMMON_ON_N;
 		phypwr &= ~PHYPWR_NORMAL_MASK;
 		rstcon |= RSTCON_SWRST;
-		break;
-	case TYPE_EXYNOS4210:
-		phypwr &= ~PHYPWR_NORMAL_MASK_PHY0;
-		rstcon |= RSTCON_SWRST;
 	default:
 		break;
 	}
@@ -88,9 +84,6 @@ static void samsung_usb2phy_disable(struct samsung_usbphy *sphy)
 	switch (sphy->drv_data->cpu_type) {
 	case TYPE_S3C64XX:
 		phypwr |= PHYPWR_NORMAL_MASK;
-		break;
-	case TYPE_EXYNOS4210:
-		phypwr |= PHYPWR_NORMAL_MASK_PHY0;
 	default:
 		break;
 	}
@@ -289,24 +282,11 @@ static const struct samsung_usbphy_drvdata usb2phy_s3c64xx = {
 	.phy_disable		= samsung_usb2phy_disable,
 };
 
-static const struct samsung_usbphy_drvdata usb2phy_exynos4 = {
-	.cpu_type		= TYPE_EXYNOS4210,
-	.devphy_en_mask		= EXYNOS_USBPHY_ENABLE,
-	.hostphy_en_mask	= EXYNOS_USBPHY_ENABLE,
-	.rate_to_clksel		= samsung_usbphy_rate_to_clksel_64xx,
-	.set_isolation		= samsung_usbphy_set_isolation_4210,
-	.phy_enable		= samsung_usb2phy_enable,
-	.phy_disable		= samsung_usb2phy_disable,
-};
-
 #ifdef CONFIG_OF
 static const struct of_device_id samsung_usbphy_dt_match[] = {
 	{
 		.compatible = "samsung,s3c64xx-usb2phy",
 		.data = &usb2phy_s3c64xx,
-	}, {
-		.compatible = "samsung,exynos4210-usb2phy",
-		.data = &usb2phy_exynos4,
 	},
 	{},
 };
@@ -317,9 +297,6 @@ static struct platform_device_id samsung_usbphy_driver_ids[] = {
 	{
 		.name		= "s3c64xx-usb2phy",
 		.driver_data	= (unsigned long)&usb2phy_s3c64xx,
-	}, {
-		.name		= "exynos4210-usb2phy",
-		.driver_data	= (unsigned long)&usb2phy_exynos4,
 	},
 	{},
 };
-- 
1.7.10.4

