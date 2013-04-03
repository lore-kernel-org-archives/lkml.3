Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762702Ab3DCODI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 10:03:08 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:37012 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760497Ab3DCODE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 10:03:04 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>,
        Kalle Jokiniemi <kalle.jokiniemi@jollamobile.com>
Subject: [PATCH 2/3] usb: phy: twl4030-usb: check regulator_enable return value
Date: Wed,  3 Apr 2013 16:02:26 +0200
Message-Id: <1364997747-20830-3-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1364997747-20830-1-git-send-email-fabio.baltieri@linaro.org>
References: <1364997747-20830-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since regulator_enable() is going to be marked as __must_check in the
next merge window, always check regulator_enable() return value and
print a warning if it fails.

Cc: Kalle Jokiniemi <kalle.jokiniemi@jollamobile.com>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/usb/phy/phy-twl4030-usb.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/phy/phy-twl4030-usb.c b/drivers/usb/phy/phy-twl4030-usb.c
index 3f9858f..13e17ae 100644
--- a/drivers/usb/phy/phy-twl4030-usb.c
+++ b/drivers/usb/phy/phy-twl4030-usb.c
@@ -384,9 +384,17 @@ static void __twl4030_phy_power(struct twl4030_usb *twl, int on)
 
 static void twl4030_phy_power(struct twl4030_usb *twl, int on)
 {
+	int ret;
+
 	if (on) {
-		regulator_enable(twl->usb3v1);
-		regulator_enable(twl->usb1v8);
+		ret = regulator_enable(twl->usb3v1);
+		if (ret)
+			dev_err(twl->dev, "Failed to enable usb3v1\n");
+
+		ret = regulator_enable(twl->usb1v8);
+		if (ret)
+			dev_err(twl->dev, "Failed to enable usb1v8\n");
+
 		/*
 		 * Disabling usb3v1 regulator (= writing 0 to VUSB3V1_DEV_GRP
 		 * in twl4030) resets the VUSB_DEDICATED2 register. This reset
@@ -395,7 +403,11 @@ static void twl4030_phy_power(struct twl4030_usb *twl, int on)
 		 * is re-activated. This ensures that VUSB3V1 is really active.
 		 */
 		twl_i2c_write_u8(TWL_MODULE_PM_RECEIVER, 0, VUSB_DEDICATED2);
-		regulator_enable(twl->usb1v5);
+
+		ret = regulator_enable(twl->usb1v5);
+		if (ret)
+			dev_err(twl->dev, "Failed to enable usb1v5\n");
+
 		__twl4030_phy_power(twl, 1);
 		twl4030_usb_write(twl, PHY_CLK_CTRL,
 				  twl4030_usb_read(twl, PHY_CLK_CTRL) |
-- 
1.8.1.3

