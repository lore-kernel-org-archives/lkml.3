Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab3FZQeG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 12:34:06 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:44209 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab3FZQeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 12:34:01 -0400
From: Jiang Liu <liuj97@gmail.com>
To: "Rafael J . Wysocki" <rjw@sisk.pl>
Cc: liuj97@gmail.com, Jiang Liu <jiang.liu@huawei.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>
Subject: [PATCH v2 6/9] ACPI: change acpi_[bay|dock]_match() in scan.c as global functions
Date: Thu, 27 Jun 2013 00:30:58 +0800
Message-Id: <1372264261-17442-7-git-send-email-liuj97@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372264261-17442-1-git-send-email-liuj97@gmail.com>
References: <1372264261-17442-1-git-send-email-liuj97@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Function acpi_[bay|dock]_match() in scan.c could be shared with dock.c
to reduce duplicated code, so refine and change them as global functions.
Also add a new function acpi_ata_match() to check whether an ACPI object
device is an ATA device.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Jiang Liu <liuj97@gmail.com>
Cc: Len Brown <lenb@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/acpi/scan.c     | 82 ++++++++++++++++++++++---------------------------
 include/acpi/acpi_bus.h |  3 ++
 2 files changed, 40 insertions(+), 45 deletions(-)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index dfe76f1..3ddba74 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -1532,46 +1532,45 @@ static void acpi_device_get_busid(struct acpi_device *device)
 }
 
 /*
+ * acpi_ata_match - see if an acpi object is an ATA device
+ *
+ * If an acpi object has one of the ACPI ATA methods defined,
+ * then we can safely call it an ATA device.
+ */
+bool acpi_ata_match(acpi_handle handle)
+{
+	return acpi_has_method(handle, "_GTF") ||
+	       acpi_has_method(handle, "_GTM") ||
+	       acpi_has_method(handle, "_STM") ||
+	       acpi_has_method(handle, "_SDD");
+}
+
+/*
  * acpi_bay_match - see if an acpi object is an ejectable driver bay
  *
  * If an acpi object is ejectable and has one of the ACPI ATA methods defined,
  * then we can safely call it an ejectable drive bay
  */
-static int acpi_bay_match(acpi_handle handle)
+bool acpi_bay_match(acpi_handle handle)
 {
-	acpi_status status;
-	acpi_handle tmp;
 	acpi_handle phandle;
 
-	status = acpi_get_handle(handle, "_EJ0", &tmp);
-	if (ACPI_FAILURE(status))
-		return -ENODEV;
-
-	if ((ACPI_SUCCESS(acpi_get_handle(handle, "_GTF", &tmp))) ||
-		(ACPI_SUCCESS(acpi_get_handle(handle, "_GTM", &tmp))) ||
-		(ACPI_SUCCESS(acpi_get_handle(handle, "_STM", &tmp))) ||
-		(ACPI_SUCCESS(acpi_get_handle(handle, "_SDD", &tmp))))
-		return 0;
-
-	if (acpi_get_parent(handle, &phandle))
-		return -ENODEV;
-
-        if ((ACPI_SUCCESS(acpi_get_handle(phandle, "_GTF", &tmp))) ||
-                (ACPI_SUCCESS(acpi_get_handle(phandle, "_GTM", &tmp))) ||
-                (ACPI_SUCCESS(acpi_get_handle(phandle, "_STM", &tmp))) ||
-                (ACPI_SUCCESS(acpi_get_handle(phandle, "_SDD", &tmp))))
-                return 0;
+	if (!acpi_has_method(handle, "_EJ0"))
+		return false;
+	if (acpi_ata_match(handle))
+		return true;
+	if (ACPI_FAILURE(acpi_get_parent(handle, &phandle)))
+		return false;
 
-	return -ENODEV;
+	return acpi_ata_match(phandle);
 }
 
 /*
  * acpi_dock_match - see if an acpi object has a _DCK method
  */
-static int acpi_dock_match(acpi_handle handle)
+bool acpi_dock_match(acpi_handle handle)
 {
-	acpi_handle tmp;
-	return acpi_get_handle(handle, "_DCK", &tmp);
+	return acpi_has_method(handle, "_DCK");
 }
 
 const char *acpi_device_hid(struct acpi_device *device)
@@ -1609,34 +1608,27 @@ static void acpi_add_id(struct acpi_device_pnp *pnp, const char *dev_id)
  * lacks the SMBUS01 HID and the methods do not have the necessary "_"
  * prefix.  Work around this.
  */
-static int acpi_ibm_smbus_match(acpi_handle handle)
+static bool acpi_ibm_smbus_match(acpi_handle handle)
 {
 	acpi_handle h_dummy;
-	struct acpi_buffer path = {ACPI_ALLOCATE_BUFFER, NULL};
-	int result;
+	char node_name[ACPI_PATH_SEGMENT_LENGTH];
+	struct acpi_buffer path = { sizeof(node_name), node_name };
 
 	if (!dmi_name_in_vendors("IBM"))
-		return -ENODEV;
+		return false;
 
 	/* Look for SMBS object */
-	result = acpi_get_name(handle, ACPI_SINGLE_NAME, &path);
-	if (result)
-		return result;
-
-	if (strcmp("SMBS", path.pointer)) {
-		result = -ENODEV;
-		goto out;
-	}
+	if (ACPI_FAILURE(acpi_get_name(handle, ACPI_SINGLE_NAME, &path)) ||
+	    strcmp("SMBS", path.pointer))
+		return false;
 
 	/* Does it have the necessary (but misnamed) methods? */
-	result = -ENODEV;
 	if (ACPI_SUCCESS(acpi_get_handle(handle, "SBI", &h_dummy)) &&
 	    ACPI_SUCCESS(acpi_get_handle(handle, "SBR", &h_dummy)) &&
 	    ACPI_SUCCESS(acpi_get_handle(handle, "SBW", &h_dummy)))
-		result = 0;
-out:
-	kfree(path.pointer);
-	return result;
+		return true;
+
+	return false;
 }
 
 static void acpi_set_pnp_ids(acpi_handle handle, struct acpi_device_pnp *pnp,
@@ -1684,11 +1676,11 @@ static void acpi_set_pnp_ids(acpi_handle handle, struct acpi_device_pnp *pnp,
 		 */
 		if (acpi_is_video_device(handle))
 			acpi_add_id(pnp, ACPI_VIDEO_HID);
-		else if (ACPI_SUCCESS(acpi_bay_match(handle)))
+		else if (acpi_bay_match(handle))
 			acpi_add_id(pnp, ACPI_BAY_HID);
-		else if (ACPI_SUCCESS(acpi_dock_match(handle)))
+		else if (acpi_dock_match(handle))
 			acpi_add_id(pnp, ACPI_DOCK_HID);
-		else if (!acpi_ibm_smbus_match(handle))
+		else if (acpi_ibm_smbus_match(handle))
 			acpi_add_id(pnp, ACPI_SMBUS_IBM_HID);
 		else if (list_empty(&pnp->ids) && handle == ACPI_ROOT_OBJECT) {
 			acpi_add_id(pnp, ACPI_BUS_HID); /* \_SB, LNXSYBUS */
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index 3db3b97..a4e4427 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -60,6 +60,9 @@ acpi_get_physical_device_location(acpi_handle handle, struct acpi_pld_info **pld
 acpi_status acpi_evaluate_ej0(acpi_handle handle);
 acpi_status acpi_evaluate_lck(acpi_handle handle, int lock);
 bool acpi_has_method(acpi_handle handle, char *name);
+bool acpi_ata_match(acpi_handle handle);
+bool acpi_bay_match(acpi_handle handle);
+bool acpi_dock_match(acpi_handle handle);
 
 #ifdef CONFIG_ACPI
 
-- 
1.8.1.2

