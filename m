Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897Ab3F1Q2J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 12:28:09 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:48159 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755736Ab3F1Q2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 12:28:06 -0400
From: Jiang Liu <liuj97@gmail.com>
To: "Rafael J . Wysocki" <rjw@sisk.pl>
Cc: liuj97@gmail.com, Jiang Liu <jiang.liu@huawei.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>
Subject: [PATCH v3 08/10] ACPI: change acpi_[bay|dock]_match() in scan.c as global functions
Date: Sat, 29 Jun 2013 00:24:41 +0800
Message-Id: <1372436683-31711-9-git-send-email-liuj97@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372436683-31711-1-git-send-email-liuj97@gmail.com>
References: <1372436683-31711-1-git-send-email-liuj97@gmail.com>
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
 drivers/acpi/scan.c     | 77 +++++++++++++++++++++++--------------------------
 include/acpi/acpi_bus.h |  3 ++
 2 files changed, 39 insertions(+), 41 deletions(-)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 101a267..e7fd101 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -1481,43 +1481,45 @@ static void acpi_device_get_busid(struct acpi_device *device)
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
 	acpi_handle phandle;
 
 	if (!acpi_has_method(handle, "_EJ0"))
-		return -ENODEV;
+		return false;
+	if (acpi_ata_match(handle))
+		return true;
+	if (ACPI_FAILURE(acpi_get_parent(handle, &phandle)))
+		return false;
 
-	if (acpi_has_method(handle, "_GTF") ||
-	    acpi_has_method(handle, "_GTM") ||
-	    acpi_has_method(handle, "_STM") ||
-	    acpi_has_method(handle, "_SDD"))
-		return 0;
-
-	if (acpi_get_parent(handle, &phandle))
-		return -ENODEV;
-
-	if (acpi_has_method(phandle, "_GTF") ||
-	    acpi_has_method(phandle, "_GTM") ||
-	    acpi_has_method(phandle, "_STM") ||
-	    acpi_has_method(phandle, "_SDD"))
-                return 0;
-
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
@@ -1555,33 +1557,26 @@ static void acpi_add_id(struct acpi_device_pnp *pnp, const char *dev_id)
  * lacks the SMBUS01 HID and the methods do not have the necessary "_"
  * prefix.  Work around this.
  */
-static int acpi_ibm_smbus_match(acpi_handle handle)
+static bool acpi_ibm_smbus_match(acpi_handle handle)
 {
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
 	if (acpi_has_method(handle, "SBI") &&
 	    acpi_has_method(handle, "SBR") &&
 	    acpi_has_method(handle, "SBW"))
-		result = 0;
-out:
-	kfree(path.pointer);
-	return result;
+		return true;
+
+	return false;
 }
 
 static void acpi_set_pnp_ids(acpi_handle handle, struct acpi_device_pnp *pnp,
@@ -1629,11 +1624,11 @@ static void acpi_set_pnp_ids(acpi_handle handle, struct acpi_device_pnp *pnp,
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
index 6c378d9..60fff75 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -62,6 +62,9 @@ acpi_status acpi_execute_simple_method(acpi_handle handle, char *method,
 				       u64 arg);
 acpi_status acpi_evaluate_ej0(acpi_handle handle);
 acpi_status acpi_evaluate_lck(acpi_handle handle, int lock);
+bool acpi_ata_match(acpi_handle handle);
+bool acpi_bay_match(acpi_handle handle);
+bool acpi_dock_match(acpi_handle handle);
 
 #ifdef CONFIG_ACPI
 
-- 
1.8.1.2

