Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987AbaKDD67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 22:58:59 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:45803 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbaKDD64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 22:58:56 -0500
From: Azael Avalos <coproscefalo@gmail.com>
To: Darren Hart <dvhart@infradead.org>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Nuno Lopes <nunoplopes@sapo.pt>, Azael Avalos <coproscefalo@gmail.com>
Subject: [PATCH] toshiba_acpi: Fix regression caused by backlight extra  check code
Date: Mon,  3 Nov 2014 20:58:34 -0700
Message-Id: <1415073514-12555-1-git-send-email-coproscefalo@gmail.com>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bug 86521 uncovered that some TOS6208 devices also return
non zero values on a write call to the backlight method,
thus getting caught and bailed out by the extra check code.

This patch makes sure that the extra check is being done
on a TOS1900 device and then make the check for the broken
backlight code.

Signed-off-by: Azael Avalos <coproscefalo@gmail.com>
---
 drivers/platform/x86/toshiba_acpi.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index ef3a190..e3fed12 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -944,9 +944,13 @@ static int set_lcd_brightness(struct toshiba_acpi_dev *dev, int value)
 	/* Extra check for "incomplete" backlight method, where the AML code
 	 * doesn't check for HCI_SET or HCI_GET and returns TOS_SUCCESS,
 	 * the actual brightness, and in some cases the max brightness.
+	 * Use the SPFC method as an indicator that we're on a TOS1900 device,
+	 * otherwise some TOS6208 devices might get bailed out, see bug 86521
 	 */
-	if (out[2] > 0  || out[3] == 0xE000)
-		return -ENODEV;
+	if (acpi_has_method(dev->acpi_dev->handle, "SPFC")) {
+		if (out[2] > 0  || out[3] == 0xE000)
+			return -ENODEV;
+	}
 
 	return out[0] == TOS_SUCCESS ? 0 : -EIO;
 }
-- 
2.1.1

