Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819AbaKYC3r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 21:29:47 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:43319 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbaKYC3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 21:29:45 -0500
From: Azael Avalos <coproscefalo@gmail.com>
To: Darren Hart <dvhart@infradead.org>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Azael Avalos <coproscefalo@gmail.com>
Subject: [PATCH v2] toshiba_acpi: Fix regression caused by backlight extra check code
Date: Mon, 24 Nov 2014 19:29:36 -0700
Message-Id: <1416882576-3203-1-git-send-email-coproscefalo@gmail.com>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bug 86521 uncovered that some TOS6208 devices also return
non zero values on a write call to the backlight method,
thus getting caught and bailed out by the extra check code.

This patch changes the set_lcd_brightness function to its
"original" state by just adapting it to the new function
format.

Signed-off-by: Azael Avalos <coproscefalo@gmail.com>
---
Changes since v1:
- Simply revert the commit to its original state by just
  adapting the code to the new function format

Darren,

This patch simply reverts the commit so the bug can be closed,
I'll send a few patches later which will include the change
needed to block the backlight on TOS1900 devices for review.

 drivers/platform/x86/toshiba_acpi.c | 21 ++++-----------------
 1 file changed, 4 insertions(+), 17 deletions(-)

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index 96076d9..06362b7 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -928,9 +928,7 @@ static int lcd_proc_open(struct inode *inode, struct file *file)
 
 static int set_lcd_brightness(struct toshiba_acpi_dev *dev, int value)
 {
-	u32 in[TCI_WORDS] = { HCI_SET, HCI_LCD_BRIGHTNESS, 0, 0, 0, 0 };
-	u32 out[TCI_WORDS];
-	acpi_status status;
+	u32 hci_result;
 
 	if (dev->tr_backlight_supported) {
 		bool enable = !value;
@@ -941,20 +939,9 @@ static int set_lcd_brightness(struct toshiba_acpi_dev *dev, int value)
 			value--;
 	}
 
-	in[2] = value << HCI_LCD_BRIGHTNESS_SHIFT;
-	status = tci_raw(dev, in, out);
-	if (ACPI_FAILURE(status) || out[0] == TOS_FAILURE) {
-		pr_err("ACPI call to set brightness failed");
-		return -EIO;
-	}
-	/* Extra check for "incomplete" backlight method, where the AML code
-	 * doesn't check for HCI_SET or HCI_GET and returns TOS_SUCCESS,
-	 * the actual brightness, and in some cases the max brightness.
-	 */
-	if (out[2] > 0  || out[3] == 0xE000)
-		return -ENODEV;
-
-	return out[0] == TOS_SUCCESS ? 0 : -EIO;
+	value = value << HCI_LCD_BRIGHTNESS_SHIFT;
+	hci_result = hci_write1(dev, HCI_LCD_BRIGHTNESS, value);
+	return hci_result == TOS_SUCCESS ? 0 : -EIO;
 }
 
 static int set_lcd_status(struct backlight_device *bd)
-- 
2.1.2

