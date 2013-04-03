Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762754Ab3DCODT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 10:03:19 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:35949 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758816Ab3DCODQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 10:03:16 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>, Hema HK <hemahk@ti.com>
Subject: [PATCH 3/3] usb: phy: twl6030-usb: check regulator_enable return value
Date: Wed,  3 Apr 2013 16:02:27 +0200
Message-Id: <1364997747-20830-4-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1364997747-20830-1-git-send-email-fabio.baltieri@linaro.org>
References: <1364997747-20830-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since regulator_enable() is going to be marked as __must_check in the
next merge window, always check regulator_enable() return value and
print a warning if it fails.

Cc: Hema HK <hemahk@ti.com>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/usb/phy/phy-twl6030-usb.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/phy/phy-twl6030-usb.c b/drivers/usb/phy/phy-twl6030-usb.c
index 8cd6cf4..e841474 100644
--- a/drivers/usb/phy/phy-twl6030-usb.c
+++ b/drivers/usb/phy/phy-twl6030-usb.c
@@ -211,6 +211,7 @@ static irqreturn_t twl6030_usb_irq(int irq, void *_twl)
 	struct twl6030_usb *twl = _twl;
 	enum omap_musb_vbus_id_status status = OMAP_MUSB_UNKNOWN;
 	u8 vbus_state, hw_state;
+	int ret;
 
 	hw_state = twl6030_readb(twl, TWL6030_MODULE_ID0, STS_HW_CONDITIONS);
 
@@ -218,7 +219,10 @@ static irqreturn_t twl6030_usb_irq(int irq, void *_twl)
 						CONTROLLER_STAT1);
 	if (!(hw_state & STS_USB_ID)) {
 		if (vbus_state & VBUS_DET) {
-			regulator_enable(twl->usb3v3);
+			ret = regulator_enable(twl->usb3v3);
+			if (ret)
+				dev_err(twl->dev, "Failed to enable usb3v3\n");
+
 			twl->asleep = 1;
 			status = OMAP_MUSB_VBUS_VALID;
 			twl->linkstat = status;
@@ -245,12 +249,15 @@ static irqreturn_t twl6030_usbotg_irq(int irq, void *_twl)
 	struct twl6030_usb *twl = _twl;
 	enum omap_musb_vbus_id_status status = OMAP_MUSB_UNKNOWN;
 	u8 hw_state;
+	int ret;
 
 	hw_state = twl6030_readb(twl, TWL6030_MODULE_ID0, STS_HW_CONDITIONS);
 
 	if (hw_state & STS_USB_ID) {
+		ret = regulator_enable(twl->usb3v3);
+		if (ret)
+			dev_err(twl->dev, "Failed to enable usb3v3\n");
 
-		regulator_enable(twl->usb3v3);
 		twl->asleep = 1;
 		twl6030_writeb(twl, TWL_MODULE_USB, 0x1, USB_ID_INT_EN_HI_CLR);
 		twl6030_writeb(twl, TWL_MODULE_USB, 0x10, USB_ID_INT_EN_HI_SET);
-- 
1.8.1.3

