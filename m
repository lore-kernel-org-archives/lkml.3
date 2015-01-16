Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbbAPOhQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 09:37:16 -0500
Received: from mail.savoirfairelinux.com ([209.172.62.77]:59825 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbbAPOhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 09:37:14 -0500
X-Greylist: delayed 456 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Jan 2015 09:37:13 EST
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: platform-driver-x86@vger.kernel.org
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Darren Hart <dvhart@infradead.org>,
        Corentin Chary <corentin.chary@gmail.com>,
        acpi4asus-user@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] asus-laptop: is_visible should not return a bool
Date: Fri, 16 Jan 2015 09:29:19 -0500
Message-Id: <1421418559-2058-1-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Mailer: git-send-email 2.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With a Lucid platform, asus_sysfs_is_visible() returns a boolean for
ls_switch and ls_level attributes. Fix that and also s/supported/ok/ and
s/asus->handle/handle/ to avoid lines wider than 80 chars.

Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
---
 drivers/platform/x86/asus-laptop.c | 46 ++++++++++++++++----------------------
 1 file changed, 19 insertions(+), 27 deletions(-)

diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index f71700e..c7d1655 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -1605,55 +1605,47 @@ static umode_t asus_sysfs_is_visible(struct kobject *kobj,
 	struct platform_device *pdev = to_platform_device(dev);
 	struct asus_laptop *asus = platform_get_drvdata(pdev);
 	acpi_handle handle = asus->handle;
-	bool supported;
+	bool ok;
 
-	if (asus->is_pega_lucid) {
-		/* no ls_level interface on the Lucid */
-		if (attr == &dev_attr_ls_switch.attr)
-			supported = true;
-		else if (attr == &dev_attr_ls_level.attr)
-			supported = false;
-		else
-			goto normal;
+	if (asus->is_pega_lucid && attr == &dev_attr_ls_switch.attr) {
+		ok = true;
 
-		return supported;
-	}
+	} else if (asus->is_pega_lucid && attr == &dev_attr_ls_level.attr) {
+		ok = false; /* no ls_level interface on the Lucid */
 
-normal:
-	if (attr == &dev_attr_wlan.attr) {
-		supported = !acpi_check_handle(handle, METHOD_WLAN, NULL);
+	} else if (attr == &dev_attr_wlan.attr) {
+		ok = !acpi_check_handle(handle, METHOD_WLAN, NULL);
 
 	} else if (attr == &dev_attr_bluetooth.attr) {
-		supported = !acpi_check_handle(handle, METHOD_BLUETOOTH, NULL);
+		ok = !acpi_check_handle(handle, METHOD_BLUETOOTH, NULL);
 
 	} else if (attr == &dev_attr_display.attr) {
-		supported = !acpi_check_handle(handle, METHOD_SWITCH_DISPLAY, NULL);
+		ok = !acpi_check_handle(handle, METHOD_SWITCH_DISPLAY, NULL);
 
 	} else if (attr == &dev_attr_wimax.attr) {
-		supported =
-			!acpi_check_handle(asus->handle, METHOD_WIMAX, NULL);
+		ok = !acpi_check_handle(handle, METHOD_WIMAX, NULL);
 
 	} else if (attr == &dev_attr_wwan.attr) {
-		supported = !acpi_check_handle(asus->handle, METHOD_WWAN, NULL);
+		ok = !acpi_check_handle(handle, METHOD_WWAN, NULL);
 
 	} else if (attr == &dev_attr_ledd.attr) {
-		supported = !acpi_check_handle(handle, METHOD_LEDD, NULL);
+		ok = !acpi_check_handle(handle, METHOD_LEDD, NULL);
 
 	} else if (attr == &dev_attr_ls_switch.attr ||
 		   attr == &dev_attr_ls_level.attr) {
-		supported = !acpi_check_handle(handle, METHOD_ALS_CONTROL, NULL) &&
+		ok = !acpi_check_handle(handle, METHOD_ALS_CONTROL, NULL) &&
 			!acpi_check_handle(handle, METHOD_ALS_LEVEL, NULL);
 	} else if (attr == &dev_attr_ls_value.attr) {
-		supported = asus->is_pega_lucid;
+		ok = asus->is_pega_lucid;
 	} else if (attr == &dev_attr_gps.attr) {
-		supported = !acpi_check_handle(handle, METHOD_GPS_ON, NULL) &&
-			    !acpi_check_handle(handle, METHOD_GPS_OFF, NULL) &&
-			    !acpi_check_handle(handle, METHOD_GPS_STATUS, NULL);
+		ok = !acpi_check_handle(handle, METHOD_GPS_ON, NULL) &&
+			!acpi_check_handle(handle, METHOD_GPS_OFF, NULL) &&
+			!acpi_check_handle(handle, METHOD_GPS_STATUS, NULL);
 	} else {
-		supported = true;
+		ok = true;
 	}
 
-	return supported ? attr->mode : 0;
+	return ok ? attr->mode : 0;
 }
 
 
-- 
2.2.2

