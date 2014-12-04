Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124AbaLDGm3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 01:42:29 -0500
Received: from mail-oi0-f41.google.com ([209.85.218.41]:43176 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbaLDGmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 01:42:12 -0500
From: Azael Avalos <coproscefalo@gmail.com>
To: Darren Hart <dvhart@infradead.org>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Azael Avalos <coproscefalo@gmail.com>
Subject: [PATCH v2 1/3] toshiba_acpi: Move hotkey enabling code to own function
Date: Wed,  3 Dec 2014 23:42:03 -0700
Message-Id: <1417675325-14921-2-git-send-email-coproscefalo@gmail.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1417675325-14921-1-git-send-email-coproscefalo@gmail.com>
References: <1417675325-14921-1-git-send-email-coproscefalo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hotkey enabling code is being used by toshiba_acpi_setup_keyboard
and also by toshiba_acpi_resume.

This patch creates a new function called toshiba_acpi_enable_hotkeys
to be used by these two functions to avoid duplicating code.

Signed-off-by: Azael Avalos <coproscefalo@gmail.com>
---
 drivers/platform/x86/toshiba_acpi.c | 40 +++++++++++++++++++++++++------------
 1 file changed, 27 insertions(+), 13 deletions(-)

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index a329469..8bb07c7 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -1573,6 +1573,28 @@ static umode_t toshiba_sysfs_is_visible(struct kobject *kobj,
 	return exists ? attr->mode : 0;
 }
 
+/*
+ * Hotkeys
+ */
+static int toshiba_acpi_enable_hotkeys(struct toshiba_acpi_dev *dev)
+{
+	acpi_status status;
+	u32 result;
+
+	status = acpi_evaluate_object(dev->acpi_dev->handle,
+				      "ENAB", NULL, NULL);
+	if (ACPI_FAILURE(status))
+		return -ENODEV;
+
+	result = hci_write1(dev, HCI_HOTKEY_EVENT, HCI_HOTKEY_ENABLE);
+	if (result == TOS_FAILURE)
+		return -EIO;
+	else if (result == TOS_NOT_SUPPORTED)
+		return -ENODEV;
+
+	return 0;
+}
+
 static bool toshiba_acpi_i8042_filter(unsigned char data, unsigned char str,
 				      struct serio *port)
 {
@@ -1637,7 +1659,6 @@ static void toshiba_acpi_report_hotkey(struct toshiba_acpi_dev *dev,
 
 static int toshiba_acpi_setup_keyboard(struct toshiba_acpi_dev *dev)
 {
-	acpi_status status;
 	acpi_handle ec_handle;
 	int error;
 	u32 hci_result;
@@ -1664,7 +1685,6 @@ static int toshiba_acpi_setup_keyboard(struct toshiba_acpi_dev *dev)
 	 * supported, so if it's present set up an i8042 key filter
 	 * for this purpose.
 	 */
-	status = AE_ERROR;
 	ec_handle = ec_get_handle();
 	if (ec_handle && acpi_has_method(ec_handle, "NTFY")) {
 		INIT_WORK(&dev->hotkey_work, toshiba_acpi_hotkey_work);
@@ -1695,10 +1715,9 @@ static int toshiba_acpi_setup_keyboard(struct toshiba_acpi_dev *dev)
 		goto err_remove_filter;
 	}
 
-	status = acpi_evaluate_object(dev->acpi_dev->handle, "ENAB", NULL, NULL);
-	if (ACPI_FAILURE(status)) {
+	error = toshiba_acpi_enable_hotkeys(dev);
+	if (error) {
 		pr_info("Unable to enable hotkeys\n");
-		error = -ENODEV;
 		goto err_remove_filter;
 	}
 
@@ -1708,7 +1727,6 @@ static int toshiba_acpi_setup_keyboard(struct toshiba_acpi_dev *dev)
 		goto err_remove_filter;
 	}
 
-	hci_result = hci_write1(dev, HCI_HOTKEY_EVENT, HCI_HOTKEY_ENABLE);
 	return 0;
 
  err_remove_filter:
@@ -2006,16 +2024,12 @@ static int toshiba_acpi_suspend(struct device *device)
 static int toshiba_acpi_resume(struct device *device)
 {
 	struct toshiba_acpi_dev *dev = acpi_driver_data(to_acpi_device(device));
-	u32 result;
-	acpi_status status;
+	int error;
 
 	if (dev->hotkey_dev) {
-		status = acpi_evaluate_object(dev->acpi_dev->handle, "ENAB",
-				NULL, NULL);
-		if (ACPI_FAILURE(status))
+		error = toshiba_acpi_enable_hotkeys(dev);
+		if (error)
 			pr_info("Unable to re-enable hotkeys\n");
-
-		result = hci_write1(dev, HCI_HOTKEY_EVENT, HCI_HOTKEY_ENABLE);
 	}
 
 	return 0;
-- 
2.1.2

