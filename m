Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933588AbaLEDW7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 22:22:59 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58868 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933474AbaLEDW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 22:22:57 -0500
From: Azael Avalos <coproscefalo@gmail.com>
To: Darren Hart <dvhart@infradead.org>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Azael Avalos <coproscefalo@gmail.com>
Subject: [PATCH v3 3/3] toshiba_acpi: Add keyboard backlight mode change event
Date: Thu,  4 Dec 2014 20:22:47 -0700
Message-Id: <1417749767-3898-4-git-send-email-coproscefalo@gmail.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1417749767-3898-1-git-send-email-coproscefalo@gmail.com>
References: <1417749767-3898-1-git-send-email-coproscefalo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A previous patch added support to handle more events.

This patch adds support to update the sysfs group whenever we receive
a 0x92 event, which indicates a change in the keyboard backlight mode,
removing the update group code from toshiba_kbd_bl_mode_store, as it is
no longer needed there.

Signed-off-by: Azael Avalos <coproscefalo@gmail.com>
---
 drivers/platform/x86/toshiba_acpi.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index 99db763..5e9b298 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -1393,12 +1393,6 @@ static ssize_t toshiba_kbd_bl_mode_store(struct device *dev,
 		if (ret)
 			return ret;
 
-		/* Update sysfs entries on successful mode change*/
-		ret = sysfs_update_group(&toshiba->acpi_dev->dev.kobj,
-					 &toshiba_attr_group);
-		if (ret)
-			return ret;
-
 		toshiba->kbd_mode = mode;
 	}
 
@@ -2008,11 +2002,19 @@ error:
 static void toshiba_acpi_notify(struct acpi_device *acpi_dev, u32 event)
 {
 	struct toshiba_acpi_dev *dev = acpi_driver_data(acpi_dev);
+	int ret;
 
 	switch (event) {
 	case 0x80: /* Hotkeys and some system events */
 		toshiba_acpi_process_hotkeys(dev);
 		break;
+	case 0x92: /* Keyboard backlight mode changed */
+		/* Update sysfs entries */
+		ret = sysfs_update_group(&acpi_dev->dev.kobj,
+					 &toshiba_attr_group);
+		if (ret)
+			pr_err("Unable to update sysfs entries\n");
+		break;
 	case 0x81: /* Unknown */
 	case 0x82: /* Unknown */
 	case 0x83: /* Unknown */
-- 
2.1.2

