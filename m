Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954AbbASCRp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 21:17:45 -0500
Received: from mail-oi0-f43.google.com ([209.85.218.43]:49684 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbbASCRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 21:17:44 -0500
From: Azael Avalos <coproscefalo@gmail.com>
To: Darren Hart <dvhart@infradead.org>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Azael Avalos <coproscefalo@gmail.com>
Subject: [PATCH] toshiba_acpi: Add a check for TOS_NOT_SUPPORTED in the sci_open function
Date: Sun, 18 Jan 2015 19:17:12 -0700
Message-Id: <1421633832-28490-1-git-send-email-coproscefalo@gmail.com>
X-Mailer: git-send-email 2.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was "toshiba_acpi: Change sci_open function return value"

Some Toshiba laptops have "poorly implemented" SCI calls on their
BIOSes and are not checking for sci_{open, close} calls, therefore,
the sci_open function is failing and making some of the supported
features unavailable (kbd backlight, touchpad, illumination, etc.).

This patch checks wheter we receive TOS_NOT_SUPPORTED and returns
1, making the supported features work on such laptops.

In the case that some laptops really do not support the SCI, all the
SCI dependent functions check for TOS_NOT_SUPPORTED, and thus, not
registering support for the queried feature.

Signed-off-by: Azael Avalos <coproscefalo@gmail.com>
---
Darren,

Hopefully this new patch eases some of the concerns of the previous
patch, and this time I added a comment block explaining a bit, but of
course, let me know if there is something else that needs change.

Cheers
Azael

 drivers/platform/x86/toshiba_acpi.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index fc34a71..899ead6b 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -389,6 +389,19 @@ static int sci_open(struct toshiba_acpi_dev *dev)
 	} else if (out[0] == TOS_ALREADY_OPEN) {
 		pr_info("Toshiba SCI already opened\n");
 		return 1;
+	} else if (out[0] == TOS_NOT_SUPPORTED) {
+		/* Some BIOSes do not have the SCI open/close functions
+		 * implemented and return 0x8000 (Not Supported), failing to
+		 * register some supported features.
+		 *
+		 * Simply return 1 if we hit those affected laptops to make the
+		 * supported features work.
+		 *
+		 * In the case that some laptops really do not support the SCI,
+		 * all the SCI dependent functions check for TOS_NOT_SUPPORTED,
+		 * and thus, not registering support for the queried feature.
+		 */
+		return 1;
 	} else if (out[0] == TOS_NOT_PRESENT) {
 		pr_info("Toshiba SCI is not present\n");
 	}
-- 
2.2.1

