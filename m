Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbbAWOBd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 09:01:33 -0500
Received: from mail.savoirfairelinux.com ([209.172.62.77]:61471 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbbAWOB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 09:01:28 -0500
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: platform-driver-x86@vger.kernel.org
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Darren Hart <dvhart@infradead.org>,
        Corentin Chary <corentin.chary@gmail.com>,
        acpi4asus-user@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        kernel@savoirfairelinux.com
Subject: [PATCH v3 2/2] asus-laptop: cleanup is_visible
Date: Fri, 23 Jan 2015 09:01:11 -0500
Message-Id: <1422021671-31861-2-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1422021671-31861-1-git-send-email-vivien.didelot@savoirfairelinux.com>
References: <1422021671-31861-1-git-send-email-vivien.didelot@savoirfairelinux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the "normal" label, use one if-statement per attribute for
maintainability and change s/supported/ret/ and s/asus->handle/handle/
to fix a coding style issue (lines with 80+ chars).

Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
---
 drivers/platform/x86/asus-laptop.c | 61 ++++++++++++++------------------------
 1 file changed, 22 insertions(+), 39 deletions(-)

diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index 46b2746..37a3a1f 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -1602,55 +1602,38 @@ static umode_t asus_sysfs_is_visible(struct kobject *kobj,
 	struct platform_device *pdev = to_platform_device(dev);
 	struct asus_laptop *asus = platform_get_drvdata(pdev);
 	acpi_handle handle = asus->handle;
-	bool supported;
+	bool ret = true;
 
-	if (asus->is_pega_lucid) {
-		/* no ls_level interface on the Lucid */
-		if (attr == &dev_attr_ls_switch.attr)
-			supported = true;
-		else if (attr == &dev_attr_ls_level.attr)
-			supported = false;
-		else
-			goto normal;
-
-		return supported ? attr->mode : 0;
-	}
-
-normal:
 	if (attr == &dev_attr_wlan.attr) {
-		supported = !acpi_check_handle(handle, METHOD_WLAN, NULL);
-
+		ret = !acpi_check_handle(handle, METHOD_WLAN, NULL);
 	} else if (attr == &dev_attr_bluetooth.attr) {
-		supported = !acpi_check_handle(handle, METHOD_BLUETOOTH, NULL);
-
-	} else if (attr == &dev_attr_display.attr) {
-		supported = !acpi_check_handle(handle, METHOD_SWITCH_DISPLAY, NULL);
-
+		ret = !acpi_check_handle(handle, METHOD_BLUETOOTH, NULL);
 	} else if (attr == &dev_attr_wimax.attr) {
-		supported =
-			!acpi_check_handle(asus->handle, METHOD_WIMAX, NULL);
-
+		ret = !acpi_check_handle(handle, METHOD_WIMAX, NULL);
 	} else if (attr == &dev_attr_wwan.attr) {
-		supported = !acpi_check_handle(asus->handle, METHOD_WWAN, NULL);
-
+		ret = !acpi_check_handle(handle, METHOD_WWAN, NULL);
+	} else if (attr == &dev_attr_display.attr) {
+		ret = !acpi_check_handle(handle, METHOD_SWITCH_DISPLAY, NULL);
 	} else if (attr == &dev_attr_ledd.attr) {
-		supported = !acpi_check_handle(handle, METHOD_LEDD, NULL);
-
-	} else if (attr == &dev_attr_ls_switch.attr ||
-		   attr == &dev_attr_ls_level.attr) {
-		supported = !acpi_check_handle(handle, METHOD_ALS_CONTROL, NULL) &&
-			!acpi_check_handle(handle, METHOD_ALS_LEVEL, NULL);
+		ret = !acpi_check_handle(handle, METHOD_LEDD, NULL);
 	} else if (attr == &dev_attr_ls_value.attr) {
-		supported = asus->is_pega_lucid;
+		ret = asus->is_pega_lucid;
+	} else if (attr == &dev_attr_ls_level.attr) {
+		/* no ls_level interface on the Lucid */
+		ret = !asus->is_pega_lucid &&
+			!acpi_check_handle(handle, METHOD_ALS_CONTROL, NULL) &&
+			!acpi_check_handle(handle, METHOD_ALS_LEVEL, NULL);
+	} else if (attr == &dev_attr_ls_switch.attr) {
+		ret = asus->is_pega_lucid ||
+			(!acpi_check_handle(handle, METHOD_ALS_CONTROL, NULL) &&
+			 !acpi_check_handle(handle, METHOD_ALS_LEVEL, NULL));
 	} else if (attr == &dev_attr_gps.attr) {
-		supported = !acpi_check_handle(handle, METHOD_GPS_ON, NULL) &&
-			    !acpi_check_handle(handle, METHOD_GPS_OFF, NULL) &&
-			    !acpi_check_handle(handle, METHOD_GPS_STATUS, NULL);
-	} else {
-		supported = true;
+		ret = !acpi_check_handle(handle, METHOD_GPS_ON, NULL) &&
+			!acpi_check_handle(handle, METHOD_GPS_OFF, NULL) &&
+			!acpi_check_handle(handle, METHOD_GPS_STATUS, NULL);
 	}
 
-	return supported ? attr->mode : 0;
+	return ret ? attr->mode : 0;
 }
 
 
-- 
2.2.2

