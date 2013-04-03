Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407Ab3DCIrE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 04:47:04 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:64676 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932296Ab3DCIqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 04:46:54 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Praveena Nadahally <praveen.nadahally@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Sakethram Bommisetti <sakethram.bommisetti@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 03/12] usb: phy: ab8500-usb: set phy tuning values
Date: Wed,  3 Apr 2013 10:45:04 +0200
Message-Id: <1364978713-19612-4-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1364978713-19612-1-git-send-email-fabio.baltieri@linaro.org>
References: <1364978713-19612-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sakethram Bommisetti <sakethram.bommisetti@stericsson.com>

Set phy tuning values proposed by the hardware teams for AB8500 and
AB8505 to improve USB eye diagram performances.

Signed-off-by: Sakethram Bommisetti <sakethram.bommisetti@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/usb/phy/phy-ab8500-usb.c | 87 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 87 insertions(+)

diff --git a/drivers/usb/phy/phy-ab8500-usb.c b/drivers/usb/phy/phy-ab8500-usb.c
index ab6dd07..5b92a59 100644
--- a/drivers/usb/phy/phy-ab8500-usb.c
+++ b/drivers/usb/phy/phy-ab8500-usb.c
@@ -33,11 +33,22 @@
 #include <linux/mfd/abx500/ab8500.h>
 #include <linux/usb/musb-ux500.h>
 
+/* Bank AB8500_SYS_CTRL2_BLOCK */
 #define AB8500_MAIN_WD_CTRL_REG 0x01
+
+/* Bank AB8500_USB */
 #define AB8500_USB_LINE_STAT_REG 0x80
 #define AB8505_USB_LINE_STAT_REG 0x94
 #define AB8500_USB_PHY_CTRL_REG 0x8A
 
+/* Bank AB8500_DEVELOPMENT */
+#define AB8500_BANK12_ACCESS 0x00
+
+/* Bank AB8500_DEBUG */
+#define AB8500_USB_PHY_TUNE1 0x05
+#define AB8500_USB_PHY_TUNE2 0x06
+#define AB8500_USB_PHY_TUNE3 0x07
+
 #define AB8500_BIT_OTG_STAT_ID (1 << 0)
 #define AB8500_BIT_PHY_CTRL_HOST_EN (1 << 0)
 #define AB8500_BIT_PHY_CTRL_DEVICE_EN (1 << 1)
@@ -671,6 +682,82 @@ static int ab8500_usb_probe(struct platform_device *pdev)
 		return err;
 	}
 
+	/* Phy tuning values for AB8500 */
+	if (!is_ab8500_2p0_or_earlier(ab->ab8500)) {
+		/* Enable the PBT/Bank 0x12 access */
+		err = abx500_set_register_interruptible(ab->dev,
+				AB8500_DEVELOPMENT, AB8500_BANK12_ACCESS, 0x01);
+		if (err < 0)
+			dev_err(ab->dev, "Failed to enable bank12 access err=%d\n",
+					err);
+
+		err = abx500_set_register_interruptible(ab->dev,
+				AB8500_DEBUG, AB8500_USB_PHY_TUNE1, 0xC8);
+		if (err < 0)
+			dev_err(ab->dev, "Failed to set PHY_TUNE1 register err=%d\n",
+					err);
+
+		err = abx500_set_register_interruptible(ab->dev,
+				AB8500_DEBUG, AB8500_USB_PHY_TUNE2, 0x00);
+		if (err < 0)
+			dev_err(ab->dev, "Failed to set PHY_TUNE2 register err=%d\n",
+					err);
+
+		err = abx500_set_register_interruptible(ab->dev,
+				AB8500_DEBUG, AB8500_USB_PHY_TUNE3, 0x78);
+		if (err < 0)
+			dev_err(ab->dev, "Failed to set PHY_TUNE3 regester err=%d\n",
+					err);
+
+		/* Switch to normal mode/disable Bank 0x12 access */
+		err = abx500_set_register_interruptible(ab->dev,
+				AB8500_DEVELOPMENT, AB8500_BANK12_ACCESS, 0x00);
+		if (err < 0)
+			dev_err(ab->dev, "Failed to switch bank12 access err=%d\n",
+					err);
+	}
+
+	/* Phy tuning values for AB8505 */
+	if (is_ab8505(ab->ab8500)) {
+		/* Enable the PBT/Bank 0x12 access */
+		err = abx500_mask_and_set_register_interruptible(ab->dev,
+				AB8500_DEVELOPMENT, AB8500_BANK12_ACCESS,
+				0x01, 0x01);
+		if (err < 0)
+			dev_err(ab->dev, "Failed to enable bank12 access err=%d\n",
+					err);
+
+		err = abx500_mask_and_set_register_interruptible(ab->dev,
+				AB8500_DEBUG, AB8500_USB_PHY_TUNE1,
+				0xC8, 0xC8);
+		if (err < 0)
+			dev_err(ab->dev, "Failed to set PHY_TUNE1 register err=%d\n",
+					err);
+
+		err = abx500_mask_and_set_register_interruptible(ab->dev,
+				AB8500_DEBUG, AB8500_USB_PHY_TUNE2,
+				0x60, 0x60);
+		if (err < 0)
+			dev_err(ab->dev, "Failed to set PHY_TUNE2 register err=%d\n",
+					err);
+
+		err = abx500_mask_and_set_register_interruptible(ab->dev,
+				AB8500_DEBUG, AB8500_USB_PHY_TUNE3,
+				0xFC, 0x80);
+
+		if (err < 0)
+			dev_err(ab->dev, "Failed to set PHY_TUNE3 regester err=%d\n",
+					err);
+
+		/* Switch to normal mode/disable Bank 0x12 access */
+		err = abx500_mask_and_set_register_interruptible(ab->dev,
+				AB8500_DEVELOPMENT, AB8500_BANK12_ACCESS,
+				0x00, 0x00);
+		if (err < 0)
+			dev_err(ab->dev, "Failed to switch bank12 access err=%d\n",
+					err);
+	}
+
 	/* Needed to enable ID detection. */
 	ab8500_usb_wd_workaround(ab);
 
-- 
1.8.1.3

