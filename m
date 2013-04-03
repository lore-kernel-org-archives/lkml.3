Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932638Ab3DCIri (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 04:47:38 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:36609 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932580Ab3DCIrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 04:47:33 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Praveena Nadahally <praveen.nadahally@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 06/12] usb: phy: ab8500-usb: split ab8500_usb_phy_ctrl
Date: Wed,  3 Apr 2013 10:45:07 +0200
Message-Id: <1364978713-19612-7-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1364978713-19612-1-git-send-email-fabio.baltieri@linaro.org>
References: <1364978713-19612-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split ab8500_usb_phy_ctrl into separate enable/disable functions to make
the code more linear and readable.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/usb/phy/phy-ab8500-usb.c | 55 +++++++++++++++++++---------------------
 1 file changed, 26 insertions(+), 29 deletions(-)

diff --git a/drivers/usb/phy/phy-ab8500-usb.c b/drivers/usb/phy/phy-ab8500-usb.c
index 4caa820..1c6eec9 100644
--- a/drivers/usb/phy/phy-ab8500-usb.c
+++ b/drivers/usb/phy/phy-ab8500-usb.c
@@ -172,40 +172,37 @@ static void ab8500_usb_wd_linkstatus(struct ab8500_usb *ab, u8 bit)
 	}
 }
 
-static void ab8500_usb_phy_ctrl(struct ab8500_usb *ab, bool sel_host,
-					bool enable)
+static void ab8500_usb_phy_enable(struct ab8500_usb *ab, bool sel_host)
 {
-	u8 ctrl_reg;
-	abx500_get_register_interruptible(ab->dev,
-				AB8500_USB,
-				AB8500_USB_PHY_CTRL_REG,
-				&ctrl_reg);
-	if (sel_host) {
-		if (enable)
-			ctrl_reg |= AB8500_BIT_PHY_CTRL_HOST_EN;
-		else
-			ctrl_reg &= ~AB8500_BIT_PHY_CTRL_HOST_EN;
-	} else {
-		if (enable)
-			ctrl_reg |= AB8500_BIT_PHY_CTRL_DEVICE_EN;
-		else
-			ctrl_reg &= ~AB8500_BIT_PHY_CTRL_DEVICE_EN;
-	}
+	u8 bit;
+	bit = sel_host ? AB8500_BIT_PHY_CTRL_HOST_EN :
+		AB8500_BIT_PHY_CTRL_DEVICE_EN;
 
-	abx500_set_register_interruptible(ab->dev,
-				AB8500_USB,
-				AB8500_USB_PHY_CTRL_REG,
-				ctrl_reg);
+	abx500_mask_and_set_register_interruptible(ab->dev,
+			AB8500_USB, AB8500_USB_PHY_CTRL_REG,
+			bit, bit);
+}
 
-	/* Needed to enable the phy.*/
-	if (enable)
-		ab8500_usb_wd_workaround(ab);
+static void ab8500_usb_phy_disable(struct ab8500_usb *ab, bool sel_host)
+{
+	u8 bit;
+	bit = sel_host ? AB8500_BIT_PHY_CTRL_HOST_EN :
+		AB8500_BIT_PHY_CTRL_DEVICE_EN;
+
+	ab8500_usb_wd_linkstatus(ab, bit);
+
+	abx500_mask_and_set_register_interruptible(ab->dev,
+			AB8500_USB, AB8500_USB_PHY_CTRL_REG,
+			bit, 0);
+
+	/* Needed to disable the phy.*/
+	ab8500_usb_wd_workaround(ab);
 }
 
-#define ab8500_usb_host_phy_en(ab)	ab8500_usb_phy_ctrl(ab, true, true)
-#define ab8500_usb_host_phy_dis(ab)	ab8500_usb_phy_ctrl(ab, true, false)
-#define ab8500_usb_peri_phy_en(ab)	ab8500_usb_phy_ctrl(ab, false, true)
-#define ab8500_usb_peri_phy_dis(ab)	ab8500_usb_phy_ctrl(ab, false, false)
+#define ab8500_usb_host_phy_en(ab)	ab8500_usb_phy_enable(ab, true)
+#define ab8500_usb_host_phy_dis(ab)	ab8500_usb_phy_disable(ab, true)
+#define ab8500_usb_peri_phy_en(ab)	ab8500_usb_phy_enable(ab, false)
+#define ab8500_usb_peri_phy_dis(ab)	ab8500_usb_phy_disable(ab, false)
 
 static int ab8505_usb_link_status_update(struct ab8500_usb *ab,
 		enum ab8505_usb_link_status lsts)
-- 
1.8.1.3

