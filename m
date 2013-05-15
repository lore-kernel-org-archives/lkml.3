Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932640Ab3EOMFI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 08:05:08 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:37761 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932620Ab3EOMFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 08:05:04 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        Praveena Nadahally <praveen.nadahally@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 07/10] usb: phy: ab8500-usb: move phy tuning values on separate functions
Date: Wed, 15 May 2013 14:03:30 +0200
Message-Id: <1368619413-24647-8-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1368619413-24647-1-git-send-email-fabio.baltieri@linaro.org>
References: <1368619413-24647-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move each chip's PHY tuning value set code to a separate function to
improve code readability.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Maxime Coquelin <maxime.coquelin@st.com>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/usb/phy/phy-ab8500-usb.c | 161 +++++++++++++++++++++------------------
 1 file changed, 86 insertions(+), 75 deletions(-)

diff --git a/drivers/usb/phy/phy-ab8500-usb.c b/drivers/usb/phy/phy-ab8500-usb.c
index 2e8db60..9b9a975 100644
--- a/drivers/usb/phy/phy-ab8500-usb.c
+++ b/drivers/usb/phy/phy-ab8500-usb.c
@@ -771,6 +771,86 @@ static int ab8500_usb_irq_setup(struct platform_device *pdev,
 	return 0;
 }
 
+static void ab8500_usb_set_ab8500_tuning_values(struct ab8500_usb *ab)
+{
+	int err;
+
+	/* Enable the PBT/Bank 0x12 access */
+	err = abx500_set_register_interruptible(ab->dev,
+			AB8500_DEVELOPMENT, AB8500_BANK12_ACCESS, 0x01);
+	if (err < 0)
+		dev_err(ab->dev, "Failed to enable bank12 access err=%d\n",
+				err);
+
+	err = abx500_set_register_interruptible(ab->dev,
+			AB8500_DEBUG, AB8500_USB_PHY_TUNE1, 0xC8);
+	if (err < 0)
+		dev_err(ab->dev, "Failed to set PHY_TUNE1 register err=%d\n",
+				err);
+
+	err = abx500_set_register_interruptible(ab->dev,
+			AB8500_DEBUG, AB8500_USB_PHY_TUNE2, 0x00);
+	if (err < 0)
+		dev_err(ab->dev, "Failed to set PHY_TUNE2 register err=%d\n",
+				err);
+
+	err = abx500_set_register_interruptible(ab->dev,
+			AB8500_DEBUG, AB8500_USB_PHY_TUNE3, 0x78);
+	if (err < 0)
+		dev_err(ab->dev, "Failed to set PHY_TUNE3 regester err=%d\n",
+				err);
+
+	/* Switch to normal mode/disable Bank 0x12 access */
+	err = abx500_set_register_interruptible(ab->dev,
+			AB8500_DEVELOPMENT, AB8500_BANK12_ACCESS, 0x00);
+	if (err < 0)
+		dev_err(ab->dev, "Failed to switch bank12 access err=%d\n",
+				err);
+}
+
+static void ab8500_usb_set_ab8505_tuning_values(struct ab8500_usb *ab)
+{
+	int err;
+
+	/* Enable the PBT/Bank 0x12 access */
+	err = abx500_mask_and_set_register_interruptible(ab->dev,
+			AB8500_DEVELOPMENT, AB8500_BANK12_ACCESS,
+			0x01, 0x01);
+	if (err < 0)
+		dev_err(ab->dev, "Failed to enable bank12 access err=%d\n",
+				err);
+
+	err = abx500_mask_and_set_register_interruptible(ab->dev,
+			AB8500_DEBUG, AB8500_USB_PHY_TUNE1,
+			0xC8, 0xC8);
+	if (err < 0)
+		dev_err(ab->dev, "Failed to set PHY_TUNE1 register err=%d\n",
+				err);
+
+	err = abx500_mask_and_set_register_interruptible(ab->dev,
+			AB8500_DEBUG, AB8500_USB_PHY_TUNE2,
+			0x60, 0x60);
+	if (err < 0)
+		dev_err(ab->dev, "Failed to set PHY_TUNE2 register err=%d\n",
+				err);
+
+	err = abx500_mask_and_set_register_interruptible(ab->dev,
+			AB8500_DEBUG, AB8500_USB_PHY_TUNE3,
+			0xFC, 0x80);
+
+	if (err < 0)
+		dev_err(ab->dev, "Failed to set PHY_TUNE3 regester err=%d\n",
+				err);
+
+	/* Switch to normal mode/disable Bank 0x12 access */
+	err = abx500_mask_and_set_register_interruptible(ab->dev,
+			AB8500_DEVELOPMENT, AB8500_BANK12_ACCESS,
+			0x00, 0x00);
+	if (err < 0)
+		dev_err(ab->dev, "Failed to switch bank12 access err=%d\n",
+				err);
+}
+
 static int ab8500_usb_probe(struct platform_device *pdev)
 {
 	struct ab8500_usb	*ab;
@@ -835,81 +915,12 @@ static int ab8500_usb_probe(struct platform_device *pdev)
 		return err;
 	}
 
-	/* Phy tuning values for AB8500 > v2.0 */
-	if (is_ab8500(ab->ab8500) && !is_ab8500_2p0_or_earlier(ab->ab8500)) {
-		/* Enable the PBT/Bank 0x12 access */
-		err = abx500_set_register_interruptible(ab->dev,
-				AB8500_DEVELOPMENT, AB8500_BANK12_ACCESS, 0x01);
-		if (err < 0)
-			dev_err(ab->dev, "Failed to enable bank12 access err=%d\n",
-					err);
-
-		err = abx500_set_register_interruptible(ab->dev,
-				AB8500_DEBUG, AB8500_USB_PHY_TUNE1, 0xC8);
-		if (err < 0)
-			dev_err(ab->dev, "Failed to set PHY_TUNE1 register err=%d\n",
-					err);
-
-		err = abx500_set_register_interruptible(ab->dev,
-				AB8500_DEBUG, AB8500_USB_PHY_TUNE2, 0x00);
-		if (err < 0)
-			dev_err(ab->dev, "Failed to set PHY_TUNE2 register err=%d\n",
-					err);
-
-		err = abx500_set_register_interruptible(ab->dev,
-				AB8500_DEBUG, AB8500_USB_PHY_TUNE3, 0x78);
-		if (err < 0)
-			dev_err(ab->dev, "Failed to set PHY_TUNE3 regester err=%d\n",
-					err);
-
-		/* Switch to normal mode/disable Bank 0x12 access */
-		err = abx500_set_register_interruptible(ab->dev,
-				AB8500_DEVELOPMENT, AB8500_BANK12_ACCESS, 0x00);
-		if (err < 0)
-			dev_err(ab->dev, "Failed to switch bank12 access err=%d\n",
-					err);
-	}
-
-	/* Phy tuning values for AB8505 */
-	if (is_ab8505(ab->ab8500)) {
-		/* Enable the PBT/Bank 0x12 access */
-		err = abx500_mask_and_set_register_interruptible(ab->dev,
-				AB8500_DEVELOPMENT, AB8500_BANK12_ACCESS,
-				0x01, 0x01);
-		if (err < 0)
-			dev_err(ab->dev, "Failed to enable bank12 access err=%d\n",
-					err);
-
-		err = abx500_mask_and_set_register_interruptible(ab->dev,
-				AB8500_DEBUG, AB8500_USB_PHY_TUNE1,
-				0xC8, 0xC8);
-		if (err < 0)
-			dev_err(ab->dev, "Failed to set PHY_TUNE1 register err=%d\n",
-					err);
-
-		err = abx500_mask_and_set_register_interruptible(ab->dev,
-				AB8500_DEBUG, AB8500_USB_PHY_TUNE2,
-				0x60, 0x60);
-		if (err < 0)
-			dev_err(ab->dev, "Failed to set PHY_TUNE2 register err=%d\n",
-					err);
-
-		err = abx500_mask_and_set_register_interruptible(ab->dev,
-				AB8500_DEBUG, AB8500_USB_PHY_TUNE3,
-				0xFC, 0x80);
-
-		if (err < 0)
-			dev_err(ab->dev, "Failed to set PHY_TUNE3 regester err=%d\n",
-					err);
-
-		/* Switch to normal mode/disable Bank 0x12 access */
-		err = abx500_mask_and_set_register_interruptible(ab->dev,
-				AB8500_DEVELOPMENT, AB8500_BANK12_ACCESS,
-				0x00, 0x00);
-		if (err < 0)
-			dev_err(ab->dev, "Failed to switch bank12 access err=%d\n",
-					err);
-	}
+	if (is_ab8500(ab->ab8500) && !is_ab8500_2p0_or_earlier(ab->ab8500))
+		/* Phy tuning values for AB8500 > v2.0 */
+		ab8500_usb_set_ab8500_tuning_values(ab);
+	else if (is_ab8505(ab->ab8500))
+		/* Phy tuning values for AB8505 */
+		ab8500_usb_set_ab8505_tuning_values(ab);
 
 	/* Needed to enable ID detection. */
 	ab8500_usb_wd_workaround(ab);
-- 
1.8.2

