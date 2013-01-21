Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842Ab3AUMIB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 07:08:01 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:57907 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389Ab3AUMEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 07:04:51 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, anton.vorontsov@linaro.org,
        cbou@mail.ru, Nicolas Guion <nicolas.guion@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Marcus Cooper <marcus.xm.cooper@stericsson.com>
Subject: [PATCH 14/24] ab8500-charger: Add support for autopower on AB8505 and AB9540
Date: Mon, 21 Jan 2013 12:03:50 +0000
Message-Id: <1358769840-4763-15-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358769840-4763-1-git-send-email-lee.jones@linaro.org>
References: <1358769840-4763-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Guion <nicolas.guion@stericsson.com>

Accessing autopower register fails on the AB8505 and ab9540 as
the fallback software control register has moved.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Marcus Cooper <marcus.xm.cooper@stericsson.com>
Reviewed-by: Mattias WALLIN <mattias.wallin@stericsson.com>
Reviewed-by: Nicolas GUION <nicolas.guion@stericsson.com>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
Tested-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 drivers/power/ab8500_charger.c |   52 +++++++++++++++++++++++++++-------------
 1 file changed, 35 insertions(+), 17 deletions(-)

diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index d834566..da965ee 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -95,6 +95,8 @@
 
 #define CHG_WD_INTERVAL			(60 * HZ)
 
+#define AB8500_SW_CONTROL_FALLBACK	0x03
+
 /* UsbLineStatus register - usb types */
 enum ab8500_charger_link_status {
 	USB_STAT_NOT_CONFIGURED,
@@ -312,42 +314,58 @@ static enum power_supply_property ab8500_charger_usb_props[] = {
 static void ab8500_enable_disable_sw_fallback(struct ab8500_charger *di,
 		bool fallback)
 {
+	u8 val;
 	u8 reg;
+	u8 bank;
+	u8 bit;
 	int ret;
 
 	dev_dbg(di->dev, "SW Fallback: %d\n", fallback);
 
+	if (is_ab8500(di->parent)) {
+		bank = 0x15;
+		reg = 0x0;
+		bit = 3;
+	} else {
+		bank = AB8500_SYS_CTRL1_BLOCK;
+		reg = AB8500_SW_CONTROL_FALLBACK;
+		bit = 0;
+	}
+
 	/* read the register containing fallback bit */
-	ret = abx500_get_register_interruptible(di->dev, 0x15, 0x00, &reg);
-	if (ret) {
-		dev_err(di->dev, "%d write failed\n", __LINE__);
+	ret = abx500_get_register_interruptible(di->dev, bank, reg, &val);
+	if (ret < 0) {
+		dev_err(di->dev, "%d read failed\n", __LINE__);
 		return;
 	}
 
-	/* enable the OPT emulation registers */
-	ret = abx500_set_register_interruptible(di->dev, 0x11, 0x00, 0x2);
-	if (ret) {
-		dev_err(di->dev, "%d write failed\n", __LINE__);
-		return;
+	if (is_ab8500(di->parent)) {
+		/* enable the OPT emulation registers */
+		ret = abx500_set_register_interruptible(di->dev, 0x11, 0x00, 0x2);
+		if (ret) {
+			dev_err(di->dev, "%d write failed\n", __LINE__);
+			goto disable_otp;
+		}
 	}
 
 	if (fallback)
-		reg |= 0x8;
+		val |= (1 << bit);
 	else
-		reg &= ~0x8;
+		val &= ~(1 << bit);
 
 	/* write back the changed fallback bit value to register */
-	ret = abx500_set_register_interruptible(di->dev, 0x15, 0x00, reg);
+	ret = abx500_set_register_interruptible(di->dev, bank, reg, val);
 	if (ret) {
 		dev_err(di->dev, "%d write failed\n", __LINE__);
-		return;
 	}
 
-	/* disable the set OTP registers again */
-	ret = abx500_set_register_interruptible(di->dev, 0x11, 0x00, 0x0);
-	if (ret) {
-		dev_err(di->dev, "%d write failed\n", __LINE__);
-		return;
+disable_otp:
+	if (is_ab8500(di->parent)) {
+		/* disable the set OTP registers again */
+		ret = abx500_set_register_interruptible(di->dev, 0x11, 0x00, 0x0);
+		if (ret) {
+			dev_err(di->dev, "%d write failed\n", __LINE__);
+		}
 	}
 }
 
-- 
1.7.9.5

