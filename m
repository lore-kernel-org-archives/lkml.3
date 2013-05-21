Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065Ab3EURCH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 13:02:07 -0400
Received: from mail-da0-f48.google.com ([209.85.210.48]:42801 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754296Ab3EURCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 13:02:05 -0400
From: Dongjin Kim <tobetter@gmail.com>
Cc: Dongjin Kim <tobetter@gmail.com>, Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] usb: phy: samsung: Add support HSIC on Exynos4X12
Date: Wed, 22 May 2013 02:01:46 +0900
Message-Id: <1369155706-14299-1-git-send-email-tobetter@gmail.com>
X-Mailer: git-send-email 1.7.9.5
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds to enable High Speed Inter Chip on Exynos4X12. Both channels
are controlled by usbphy driver based on the patch series of usbphy driver
submitted by Tomasz Figa.

[1] https://patchwork.kernel.org/patch/2576121
[2] https://patchwork.kernel.org/patch/2576131
[3] https://patchwork.kernel.org/patch/2576141
[4] https://patchwork.kernel.org/patch/2576151
[5] https://patchwork.kernel.org/patch/2576161
[6] https://patchwork.kernel.org/patch/2576171

Signed-off-by: Dongjin Kim <tobetter@gmail.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/usb/phy/phy-samsung-usb.c  |    5 +++++
 drivers/usb/phy/phy-samsung-usb.h  |   10 ++++++++++
 drivers/usb/phy/phy-samsung-usb2.c |   13 +++++++++++--
 3 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/phy/phy-samsung-usb.c b/drivers/usb/phy/phy-samsung-usb.c
index 7a1ed90..ac025ca 100644
--- a/drivers/usb/phy/phy-samsung-usb.c
+++ b/drivers/usb/phy/phy-samsung-usb.c
@@ -100,6 +100,11 @@ void samsung_usbphy_set_isolation_4210(struct samsung_usbphy *sphy, bool on)
 		reg_val |= en_mask;
 
 	writel(reg_val, reg);
+
+	if (sphy->drv_data->cpu_type == TYPE_EXYNOS4X12) {
+		writel(reg_val, sphy->pmuregs + EXYNOS4X12_PHY_HSIC_CTRL0);
+		writel(reg_val, sphy->pmuregs + EXYNOS4X12_PHY_HSIC_CTRL1);
+	}
 }
 EXPORT_SYMBOL_GPL(samsung_usbphy_set_isolation_4210);
 
diff --git a/drivers/usb/phy/phy-samsung-usb.h b/drivers/usb/phy/phy-samsung-usb.h
index 585d12f..68771bf 100644
--- a/drivers/usb/phy/phy-samsung-usb.h
+++ b/drivers/usb/phy/phy-samsung-usb.h
@@ -47,6 +47,16 @@
 #define RSTCON_HLINK_SWRST			(0x1 << 1)
 #define RSTCON_SWRST				(0x1 << 0)
 
+/* EXYNOS4X12 */
+#define EXYNOS4X12_PHY_HSIC_CTRL0		(0x04)
+#define EXYNOS4X12_PHY_HSIC_CTRL1		(0x08)
+
+#define PHYPWR_NORMAL_MASK_HSIC1		(0x7 << 12)
+#define PHYPWR_NORMAL_MASK_HSIC0		(0x7 << 9)
+#define PHYPWR_NORMAL_MASK_PHY1			(0x7 << 6)
+
+#define RSTCON_HOSTPHY_SWRST			(0xf << 3)
+
 /* EXYNOS5 */
 #define EXYNOS5_PHY_HOST_CTRL0			(0x00)
 
diff --git a/drivers/usb/phy/phy-samsung-usb2.c b/drivers/usb/phy/phy-samsung-usb2.c
index 03180c0..1011c16 100644
--- a/drivers/usb/phy/phy-samsung-usb2.c
+++ b/drivers/usb/phy/phy-samsung-usb2.c
@@ -176,8 +176,12 @@ static void samsung_usb2phy_enable(struct samsung_usbphy *sphy)
 		phypwr &= ~PHYPWR_NORMAL_MASK;
 		rstcon |= RSTCON_SWRST;
 		break;
-	case TYPE_EXYNOS4210:
 	case TYPE_EXYNOS4X12:
+		phypwr &= ~(PHYPWR_NORMAL_MASK_HSIC0 |
+				PHYPWR_NORMAL_MASK_HSIC1 |
+				PHYPWR_NORMAL_MASK_PHY1);
+		rstcon |= RSTCON_HOSTPHY_SWRST;
+	case TYPE_EXYNOS4210:
 		phypwr &= ~PHYPWR_NORMAL_MASK_PHY0;
 		rstcon |= RSTCON_SWRST;
 	default:
@@ -190,6 +194,8 @@ static void samsung_usb2phy_enable(struct samsung_usbphy *sphy)
 	/* reset all ports of PHY and Link */
 	writel(rstcon, regs + SAMSUNG_RSTCON);
 	udelay(10);
+	if (sphy->drv_data->cpu_type == TYPE_EXYNOS4X12)
+		rstcon &= ~RSTCON_HOSTPHY_SWRST;
 	rstcon &= ~RSTCON_SWRST;
 	writel(rstcon, regs + SAMSUNG_RSTCON);
 }
@@ -240,8 +246,11 @@ static void samsung_usb2phy_disable(struct samsung_usbphy *sphy)
 	case TYPE_S3C64XX:
 		phypwr |= PHYPWR_NORMAL_MASK;
 		break;
-	case TYPE_EXYNOS4210:
 	case TYPE_EXYNOS4X12:
+		phypwr |= (PHYPWR_NORMAL_MASK_HSIC0 |
+				PHYPWR_NORMAL_MASK_HSIC1 |
+				PHYPWR_NORMAL_MASK_PHY1);
+	case TYPE_EXYNOS4210:
 		phypwr |= PHYPWR_NORMAL_MASK_PHY0;
 	default:
 		break;
-- 
1.7.9.5

