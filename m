Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751644AbaLCFgw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 00:36:52 -0500
Received: from mail-oi0-f48.google.com ([209.85.218.48]:42099 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbaLCFgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 00:36:41 -0500
From: Azael Avalos <coproscefalo@gmail.com>
To: Darren Hart <dvhart@infradead.org>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Azael Avalos <coproscefalo@gmail.com>
Subject: [PATCH 2/2] toshiba_acpi: Change notify funtion to handle more events
Date: Tue,  2 Dec 2014 22:36:32 -0700
Message-Id: <1417584992-2524-3-git-send-email-coproscefalo@gmail.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1417584992-2524-1-git-send-email-coproscefalo@gmail.com>
References: <1417584992-2524-1-git-send-email-coproscefalo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the function toshiba_acpi_notify only
takes care of hotkeys, however, the TOSXXXX
devices receive more events that can be useful.

This patch changes the function to be able to
handle more events, and in the process, move all
hotkey related code residing in it to a new
function called toshiba_acpi_process_hotkeys,
and also update the sysfs group whenever we
receive a 0x92 event, which indicates a change
in the keyboard backlight mode.

Signed-off-by: Azael Avalos <coproscefalo@gmail.com>
---
 drivers/platform/x86/toshiba_acpi.c | 99 ++++++++++++++++++++++---------------
 1 file changed, 59 insertions(+), 40 deletions(-)

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index 8bb07c7..5e9b298 100644
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
 
@@ -1657,6 +1651,43 @@ static void toshiba_acpi_report_hotkey(struct toshiba_acpi_dev *dev,
 		pr_info("Unknown key %x\n", scancode);
 }
 
+static void toshiba_acpi_process_hotkeys(struct toshiba_acpi_dev *dev)
+{
+	u32 hci_result, value;
+	int retries = 3;
+	int scancode;
+
+	if (dev->info_supported) {
+		scancode = toshiba_acpi_query_hotkey(dev);
+		if (scancode < 0)
+			pr_err("Failed to query hotkey event\n");
+		else if (scancode != 0)
+			toshiba_acpi_report_hotkey(dev, scancode);
+	} else if (dev->system_event_supported) {
+		do {
+			hci_result = hci_read1(dev, HCI_SYSTEM_EVENT, &value);
+			switch (hci_result) {
+			case TOS_SUCCESS:
+				toshiba_acpi_report_hotkey(dev, (int)value);
+				break;
+			case TOS_NOT_SUPPORTED:
+				/*
+				 * This is a workaround for an unresolved
+				 * issue on some machines where system events
+				 * sporadically become disabled.
+				 */
+				hci_result =
+					hci_write1(dev, HCI_SYSTEM_EVENT, 1);
+				pr_notice("Re-enabled hotkeys\n");
+				/* fall through */
+			default:
+				retries--;
+				break;
+			}
+		} while (retries && hci_result != TOS_FIFO_EMPTY);
+	}
+}
+
 static int toshiba_acpi_setup_keyboard(struct toshiba_acpi_dev *dev)
 {
 	acpi_handle ec_handle;
@@ -1971,41 +2002,29 @@ error:
 static void toshiba_acpi_notify(struct acpi_device *acpi_dev, u32 event)
 {
 	struct toshiba_acpi_dev *dev = acpi_driver_data(acpi_dev);
-	u32 hci_result, value;
-	int retries = 3;
-	int scancode;
-
-	if (event != 0x80)
-		return;
+	int ret;
 
-	if (dev->info_supported) {
-		scancode = toshiba_acpi_query_hotkey(dev);
-		if (scancode < 0)
-			pr_err("Failed to query hotkey event\n");
-		else if (scancode != 0)
-			toshiba_acpi_report_hotkey(dev, scancode);
-	} else if (dev->system_event_supported) {
-		do {
-			hci_result = hci_read1(dev, HCI_SYSTEM_EVENT, &value);
-			switch (hci_result) {
-			case TOS_SUCCESS:
-				toshiba_acpi_report_hotkey(dev, (int)value);
-				break;
-			case TOS_NOT_SUPPORTED:
-				/*
-				 * This is a workaround for an unresolved
-				 * issue on some machines where system events
-				 * sporadically become disabled.
-				 */
-				hci_result =
-					hci_write1(dev, HCI_SYSTEM_EVENT, 1);
-				pr_notice("Re-enabled hotkeys\n");
-				/* fall through */
-			default:
-				retries--;
-				break;
-			}
-		} while (retries && hci_result != TOS_FIFO_EMPTY);
+	switch (event) {
+	case 0x80: /* Hotkeys and some system events */
+		toshiba_acpi_process_hotkeys(dev);
+		break;
+	case 0x92: /* Keyboard backlight mode changed */
+		/* Update sysfs entries */
+		ret = sysfs_update_group(&acpi_dev->dev.kobj,
+					 &toshiba_attr_group);
+		if (ret)
+			pr_err("Unable to update sysfs entries\n");
+		break;
+	case 0x81: /* Unknown */
+	case 0x82: /* Unknown */
+	case 0x83: /* Unknown */
+	case 0x8c: /* Unknown */
+	case 0x8e: /* Unknown */
+	case 0x8f: /* Unknown */
+	case 0x90: /* Unknown */
+	default:
+		pr_info("Unknown event received %x\n", event);
+		break;
 	}
 }
 
-- 
2.1.2

