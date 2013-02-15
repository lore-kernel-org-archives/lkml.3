Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161585Ab3BOMva (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:51:30 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:35011 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161486Ab3BOMqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:46:40 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, cbouatmailru@gmail.com,
        sameo@linux.intel.com, Marcus Cooper <marcus.xm.cooper@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 26/40] ab8500-charger: Add UsbLineCtrl2 reference
Date: Fri, 15 Feb 2013 12:44:56 +0000
Message-Id: <1360932310-30065-27-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
References: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcus Cooper <marcus.xm.cooper@stericsson.com>

When the state of USB Charge detection is changed then the calls
use a define for another register in other bank. This change
creates a new define for the correct register and removes the
magic numbers that are present.

Signed-off-by: Marcus Cooper <marcus.xm.cooper@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Hakan BERG <hakan.berg@stericsson.com>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 drivers/power/ab8500_charger.c       |   11 +++++++----
 include/linux/mfd/abx500/ab8500-bm.h |    1 +
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index bf8b479..64accb2 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -54,6 +54,7 @@
 #define VBUS_DET_DBNC1			0x01
 #define OTP_ENABLE_WD			0x01
 #define DROP_COUNT_RESET		0x01
+#define USB_CH_DET			0x01
 
 #define MAIN_CH_INPUT_CURR_SHIFT	4
 #define VBUS_IN_CURR_LIM_SHIFT		4
@@ -2348,8 +2349,9 @@ static void ab8500_charger_usb_link_status_work(struct work_struct *work)
 					AB8500_CHARGER, AB8500_USBCH_CTRL1_REG,
 					USB_CH_ENA, USB_CH_ENA);
 			/*Enable charger detection*/
-			abx500_mask_and_set_register_interruptible(di->dev, AB8500_USB,
-					AB8500_MCH_IPT_CURLVL_REG, 0x01, 0x01);
+			abx500_mask_and_set_register_interruptible(di->dev,
+					AB8500_USB, AB8500_USB_LINE_CTRL2_REG,
+					USB_CH_DET, USB_CH_DET);
 			di->invalid_charger_detect_state = 1;
 			/*exit and wait for new link status interrupt.*/
 			return;
@@ -2359,8 +2361,9 @@ static void ab8500_charger_usb_link_status_work(struct work_struct *work)
 			dev_dbg(di->dev,
 					"Invalid charger detected, state= 1\n");
 			/*Stop charger detection*/
-			abx500_mask_and_set_register_interruptible(di->dev, AB8500_USB,
-					AB8500_MCH_IPT_CURLVL_REG, 0x01, 0x00);
+			abx500_mask_and_set_register_interruptible(di->dev,
+					AB8500_USB, AB8500_USB_LINE_CTRL2_REG,
+					USB_CH_DET, 0x00);
 			/*Check link status*/
 			if (is_ab8500(di->parent))
 				ret = abx500_get_register_interruptible(di->dev,
diff --git a/include/linux/mfd/abx500/ab8500-bm.h b/include/linux/mfd/abx500/ab8500-bm.h
index faccdbd..829c352 100644
--- a/include/linux/mfd/abx500/ab8500-bm.h
+++ b/include/linux/mfd/abx500/ab8500-bm.h
@@ -23,6 +23,7 @@
  * Bank : 0x5
  */
 #define AB8500_USB_LINE_STAT_REG	0x80
+#define AB8500_USB_LINE_CTRL2_REG	0x82
 #define AB8500_USB_LINK1_STAT_REG	0x94
 
 /*
-- 
1.7.10.4

