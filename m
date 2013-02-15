Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161491Ab3BOMqk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:46:40 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:40400 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161477Ab3BOMqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:46:34 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, cbouatmailru@gmail.com,
        sameo@linux.intel.com, Marcus Cooper <marcus.xm.cooper@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 23/40] ab8500-charger: Use USBLink1Status Register
Date: Fri, 15 Feb 2013 12:44:53 +0000
Message-Id: <1360932310-30065-24-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
References: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcus Cooper <marcus.xm.cooper@stericsson.com>

The newer AB's such as the AB8505, AB9540 etc include a
USBLink1 Status register which detects a larger range of
external devices. This should be used instead of the
USBLine Status register.

Signed-off-by: Marcus Cooper <marcus.xm.cooper@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Hakan BERG <hakan.berg@stericsson.com>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
Tested-by: Yang QU <yang.qu@stericsson.com>
---
 drivers/power/ab8500_charger.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index 6089ee7..bf8b479 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -2320,8 +2320,13 @@ static void ab8500_charger_usb_link_status_work(struct work_struct *work)
 	 * to start the charging process. but by jumping
 	 * thru a few hoops it can be forced to start.
 	 */
-	ret = abx500_get_register_interruptible(di->dev, AB8500_USB,
-			AB8500_USB_LINE_STAT_REG, &val);
+	if (is_ab8500(di->parent))
+		ret = abx500_get_register_interruptible(di->dev, AB8500_USB,
+					AB8500_USB_LINE_STAT_REG, &val);
+	else
+		ret = abx500_get_register_interruptible(di->dev, AB8500_USB,
+					AB8500_USB_LINK1_STAT_REG, &val);
+
 	if (ret >= 0)
 		dev_dbg(di->dev, "UsbLineStatus register = 0x%02x\n", val);
 	else
@@ -2357,9 +2362,15 @@ static void ab8500_charger_usb_link_status_work(struct work_struct *work)
 			abx500_mask_and_set_register_interruptible(di->dev, AB8500_USB,
 					AB8500_MCH_IPT_CURLVL_REG, 0x01, 0x00);
 			/*Check link status*/
-			ret = abx500_get_register_interruptible(di->dev,
-					AB8500_USB,
-					AB8500_USB_LINE_STAT_REG, &val);
+			if (is_ab8500(di->parent))
+				ret = abx500_get_register_interruptible(di->dev,
+					AB8500_USB, AB8500_USB_LINE_STAT_REG,
+					&val);
+			else
+				ret = abx500_get_register_interruptible(di->dev,
+					AB8500_USB, AB8500_USB_LINK1_STAT_REG,
+					&val);
+
 			dev_dbg(di->dev, "USB link status= 0x%02x\n",
 				(val & link_status) >> USB_LINK_STATUS_SHIFT);
 			di->invalid_charger_detect_state = 2;
-- 
1.7.10.4

