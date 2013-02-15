Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161656Ab3BOMx1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:53:27 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45341 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161308Ab3BOMqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:46:23 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, cbouatmailru@gmail.com,
        sameo@linux.intel.com, Hakan Berg <hakan.berg@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 18/40] ab8500-charger: Add AB8505_USB_LINK_STATUS
Date: Fri, 15 Feb 2013 12:44:48 +0000
Message-Id: <1360932310-30065-19-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
References: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hakan Berg <hakan.berg@stericsson.com>

The AB8505 does not have the same address for USB link-status
as has ab8500. Add AB8505_USB_LINK_STATUS and code to switch
to correct constant.

Signed-off-by: Hakan Berg <hakan.berg@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Mian Yousaf KAUKAB <mian.yousaf.kaukab@stericsson.com>
Reviewed-by: Marcus COOPER <marcus.xm.cooper@stericsson.com>
Reviewed-by: Rabin VINCENT <rabin.vincent@stericsson.com>
---
 drivers/power/ab8500_charger.c |   43 ++++++++++++++++++++++++++++++++--------
 1 file changed, 35 insertions(+), 8 deletions(-)

diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index 547f6ea..b5c7a39 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -80,6 +80,7 @@
 
 /* UsbLineStatus register bit masks */
 #define AB8500_USB_LINK_STATUS		0x78
+#define AB8505_USB_LINK_STATUS		0xF8
 #define AB8500_STD_HOST_SUSP		0x18
 
 /* Watchdog timeout constant */
@@ -809,10 +810,12 @@ static int ab8500_charger_read_usb_type(struct ab8500_charger *di)
 	if (is_ab8500(di->parent)) {
 		ret = abx500_get_register_interruptible(di->dev, AB8500_USB,
 				AB8500_USB_LINE_STAT_REG, &val);
-	} else {
-		if (is_ab9540(di->parent) || is_ab8505(di->parent))
+	} else if (is_ab9540(di->parent) || is_ab8505(di->parent)) {
 			ret = abx500_get_register_interruptible(di->dev,
 				AB8500_USB, AB8500_USB_LINK1_STAT_REG, &val);
+	} else {
+		dev_err(di->dev, "%s unsupported analog baseband\n", __func__);
+		return -ENXIO;
 	}
 	if (ret < 0) {
 		dev_err(di->dev, "%s ab8500 read failed\n", __func__);
@@ -820,7 +823,14 @@ static int ab8500_charger_read_usb_type(struct ab8500_charger *di)
 	}
 
 	/* get the USB type */
-	val = (val & AB8500_USB_LINK_STATUS) >> 3;
+	if (is_ab8500(di->parent)) {
+		val = (val & AB8500_USB_LINK_STATUS) >> 3;
+	} else if (is_ab9540(di->parent) || is_ab8505(di->parent)) {
+			val = (val & AB8505_USB_LINK_STATUS) >> 3;
+	} else {
+		dev_err(di->dev, "%s unsupported analog baseband\n", __func__);
+		return -ENXIO;
+	}
 	ret = ab8500_charger_max_usb_curr(di,
 		(enum ab8500_charger_link_status) val);
 
@@ -856,12 +866,16 @@ static int ab8500_charger_detect_usb_type(struct ab8500_charger *di)
 			return ret;
 		}
 
-		if (is_ab8500(di->parent))
+		if (is_ab8500(di->parent)) {
 			ret = abx500_get_register_interruptible(di->dev,
 				AB8500_USB, AB8500_USB_LINE_STAT_REG, &val);
-		else
+		} else if (is_ab9540(di->parent) || is_ab8505(di->parent)) {
 			ret = abx500_get_register_interruptible(di->dev,
 				AB8500_USB, AB8500_USB_LINK1_STAT_REG, &val);
+		} else {
+			dev_err(di->dev, "%s unsupported analog baseband\n", __func__);
+			return -ENXIO;
+		}
 		if (ret < 0) {
 			dev_err(di->dev, "%s ab8500 read failed\n", __func__);
 			return ret;
@@ -875,7 +889,14 @@ static int ab8500_charger_detect_usb_type(struct ab8500_charger *di)
 		 */
 
 		/* get the USB type */
-		val = (val & AB8500_USB_LINK_STATUS) >> 3;
+		if (is_ab8500(di->parent)) {
+			val = (val & AB8500_USB_LINK_STATUS) >> 3;
+		} else if (is_ab9540(di->parent) || is_ab8505(di->parent)) {
+				val = (val & AB8505_USB_LINK_STATUS) >> 3;
+		} else {
+			dev_err(di->dev, "%s unsupported analog baseband\n", __func__);
+			return -ENXIO;
+		}
 		if (val)
 			break;
 	}
@@ -2287,6 +2308,7 @@ static void ab8500_charger_usb_link_status_work(struct work_struct *work)
 	int detected_chargers;
 	int ret;
 	u8 val;
+	u8 link_status;
 
 	struct ab8500_charger *di = container_of(work,
 		struct ab8500_charger, usb_link_status_work);
@@ -2313,8 +2335,13 @@ static void ab8500_charger_usb_link_status_work(struct work_struct *work)
 	else
 		dev_dbg(di->dev, "Error reading USB link status\n");
 
+	if (is_ab9540(di->parent) || is_ab8505(di->parent))
+		link_status = AB8505_USB_LINK_STATUS;
+	else
+		link_status = AB8500_USB_LINK_STATUS;
+
 	if (detected_chargers & USB_PW_CONN) {
-		if (((val & AB8500_USB_LINK_STATUS) >> 3) == USB_STAT_NOT_VALID_LINK &&
+		if (((val & link_status) >> 3) == USB_STAT_NOT_VALID_LINK &&
 				di->invalid_charger_detect_state == 0) {
 			dev_dbg(di->dev, "Invalid charger detected, state= 0\n");
 			/*Enable charger*/
@@ -2337,7 +2364,7 @@ static void ab8500_charger_usb_link_status_work(struct work_struct *work)
 			ret = abx500_get_register_interruptible(di->dev, AB8500_USB,
 					AB8500_USB_LINE_STAT_REG, &val);
 			dev_dbg(di->dev, "USB link status= 0x%02x\n",
-					(val & AB8500_USB_LINK_STATUS) >> 3);
+					(val & link_status) >> 3);
 			di->invalid_charger_detect_state = 2;
 		}
 	} else {
-- 
1.7.10.4

