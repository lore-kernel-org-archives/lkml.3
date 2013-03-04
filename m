Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932721Ab3CDVl7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 16:41:59 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:9751 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932705Ab3CDVl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 16:41:57 -0500
From: Toshi Kani <toshi.kani@hp.com>
To: rjw@sisk.pl
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, jiang.liu@huawei.com,
        isimatu.yasuaki@jp.fujitsu.com, Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH 2/3] ACPI: Update PNPID set/free interfaces
Date: Mon,  4 Mar 2013 14:30:42 -0700
Message-Id: <1362432643-25636-3-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1362432643-25636-1-git-send-email-toshi.kani@hp.com>
References: <1362432643-25636-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces acpi_set_pnp_ids() and acpi_free_pnp_ids(),
which are updated from acpi_device_set_id() and acpi_free_ids(),
to setup and free acpi_device_pnp for a given acpi_handle.  They
can be called without acpi_device.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 drivers/acpi/internal.h |    2 +
 drivers/acpi/power.c    |    2 +
 drivers/acpi/scan.c     |   85 ++++++++++++++++++++++++-----------------------
 3 files changed, 45 insertions(+), 44 deletions(-)

diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
index 7215821..7f094ad 100644
--- a/drivers/acpi/internal.h
+++ b/drivers/acpi/internal.h
@@ -71,7 +71,7 @@ int acpi_device_add(struct acpi_device *device,
 void acpi_init_device_object(struct acpi_device *device, acpi_handle handle,
 			     int type, unsigned long long sta);
 void acpi_device_add_finalize(struct acpi_device *device);
-void acpi_free_ids(struct acpi_device *device);
+void acpi_free_pnp_ids(struct acpi_device_pnp *pnp);
 
 /* --------------------------------------------------------------------------
                                   Power Resource
diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
index 34f5ef1..0481b1b 100644
--- a/drivers/acpi/power.c
+++ b/drivers/acpi/power.c
@@ -824,7 +824,7 @@ static void acpi_release_power_resource(struct device *dev)
 	list_del(&resource->list_node);
 	mutex_unlock(&power_resource_list_lock);
 
-	acpi_free_ids(device);
+	acpi_free_pnp_ids(&device->pnp);
 	kfree(resource);
 }
 
diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index f9c698d..e9a71ed 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -662,17 +662,6 @@ int acpi_match_device_ids(struct acpi_device *device,
 }
 EXPORT_SYMBOL(acpi_match_device_ids);
 
-void acpi_free_ids(struct acpi_device *device)
-{
-	struct acpi_hardware_id *id, *tmp;
-
-	list_for_each_entry_safe(id, tmp, &device->pnp.ids, list) {
-		kfree(id->id);
-		kfree(id);
-	}
-	kfree(device->pnp.unique_id);
-}
-
 static void acpi_free_power_resources_lists(struct acpi_device *device)
 {
 	int i;
@@ -693,7 +682,7 @@ static void acpi_device_release(struct device *dev)
 {
 	struct acpi_device *acpi_dev = to_acpi_device(dev);
 
-	acpi_free_ids(acpi_dev);
+	acpi_free_pnp_ids(&acpi_dev->pnp);
 	acpi_free_power_resources_lists(acpi_dev);
 	kfree(acpi_dev);
 }
@@ -1513,39 +1502,41 @@ out:
 	return result;
 }
 
-static void acpi_device_set_id(struct acpi_device *device)
+static void acpi_set_pnp_ids(acpi_handle handle, struct acpi_device_pnp *pnp,
+				int device_type)
 {
 	acpi_status status;
 	struct acpi_device_info *info;
 	struct acpi_pnp_device_id_list *cid_list;
 	int i;
 
-	switch (device->device_type) {
+	switch (device_type) {
 	case ACPI_BUS_TYPE_DEVICE:
-		if (ACPI_IS_ROOT_DEVICE(device)) {
-			acpi_add_id(&device->pnp, ACPI_SYSTEM_HID);
+		if (handle == ACPI_ROOT_OBJECT) {
+			acpi_add_id(pnp, ACPI_SYSTEM_HID);
 			break;
 		}
 
-		status = acpi_get_object_info(device->handle, &info);
+		status = acpi_get_object_info(handle, &info);
 		if (ACPI_FAILURE(status)) {
-			printk(KERN_ERR PREFIX "%s: Error reading device info\n", __func__);
+			pr_err(PREFIX "%s: Error reading device info\n",
+					__func__);
 			return;
 		}
 
 		if (info->valid & ACPI_VALID_HID)
-			acpi_add_id(&device->pnp, info->hardware_id.string);
+			acpi_add_id(pnp, info->hardware_id.string);
 		if (info->valid & ACPI_VALID_CID) {
 			cid_list = &info->compatible_id_list;
 			for (i = 0; i < cid_list->count; i++)
-				acpi_add_id(&device->pnp, cid_list->ids[i].string);
+				acpi_add_id(pnp, cid_list->ids[i].string);
 		}
 		if (info->valid & ACPI_VALID_ADR) {
-			device->pnp.bus_address = info->address;
-			device->pnp.type.bus_address = 1;
+			pnp->bus_address = info->address;
+			pnp->type.bus_address = 1;
 		}
 		if (info->valid & ACPI_VALID_UID)
-			device->pnp.unique_id = kstrdup(info->unique_id.string,
+			pnp->unique_id = kstrdup(info->unique_id.string,
 							GFP_KERNEL);
 
 		kfree(info);
@@ -1554,40 +1545,50 @@ static void acpi_device_set_id(struct acpi_device *device)
 		 * Some devices don't reliably have _HIDs & _CIDs, so add
 		 * synthetic HIDs to make sure drivers can find them.
 		 */
-		if (acpi_is_video_device(device->handle))
-			acpi_add_id(&device->pnp, ACPI_VIDEO_HID);
-		else if (ACPI_SUCCESS(acpi_bay_match(device->handle)))
-			acpi_add_id(&device->pnp, ACPI_BAY_HID);
-		else if (ACPI_SUCCESS(acpi_dock_match(device->handle)))
-			acpi_add_id(&device->pnp, ACPI_DOCK_HID);
-		else if (!acpi_ibm_smbus_match(device->handle))
-			acpi_add_id(&device->pnp, ACPI_SMBUS_IBM_HID);
-		else if (list_empty(&device->pnp.ids) &&
-			 ACPI_IS_ROOT_DEVICE(device->parent)) {
-			acpi_add_id(&device->pnp, ACPI_BUS_HID); /* \_SB, LNXSYBUS */
-			strcpy(device->pnp.device_name, ACPI_BUS_DEVICE_NAME);
-			strcpy(device->pnp.device_class, ACPI_BUS_CLASS);
+		if (acpi_is_video_device(handle))
+			acpi_add_id(pnp, ACPI_VIDEO_HID);
+		else if (ACPI_SUCCESS(acpi_bay_match(handle)))
+			acpi_add_id(pnp, ACPI_BAY_HID);
+		else if (ACPI_SUCCESS(acpi_dock_match(handle)))
+			acpi_add_id(pnp, ACPI_DOCK_HID);
+		else if (!acpi_ibm_smbus_match(handle))
+			acpi_add_id(pnp, ACPI_SMBUS_IBM_HID);
+		else if (list_empty(&pnp->ids) && handle == ACPI_ROOT_OBJECT) {
+			acpi_add_id(pnp, ACPI_BUS_HID); /* \_SB, LNXSYBUS */
+			strcpy(pnp->device_name, ACPI_BUS_DEVICE_NAME);
+			strcpy(pnp->device_class, ACPI_BUS_CLASS);
 		}
 
 		break;
 	case ACPI_BUS_TYPE_POWER:
-		acpi_add_id(&device->pnp, ACPI_POWER_HID);
+		acpi_add_id(pnp, ACPI_POWER_HID);
 		break;
 	case ACPI_BUS_TYPE_PROCESSOR:
-		acpi_add_id(&device->pnp, ACPI_PROCESSOR_OBJECT_HID);
+		acpi_add_id(pnp, ACPI_PROCESSOR_OBJECT_HID);
 		break;
 	case ACPI_BUS_TYPE_THERMAL:
-		acpi_add_id(&device->pnp, ACPI_THERMAL_HID);
+		acpi_add_id(pnp, ACPI_THERMAL_HID);
 		break;
 	case ACPI_BUS_TYPE_POWER_BUTTON:
-		acpi_add_id(&device->pnp, ACPI_BUTTON_HID_POWERF);
+		acpi_add_id(pnp, ACPI_BUTTON_HID_POWERF);
 		break;
 	case ACPI_BUS_TYPE_SLEEP_BUTTON:
-		acpi_add_id(&device->pnp, ACPI_BUTTON_HID_SLEEPF);
+		acpi_add_id(pnp, ACPI_BUTTON_HID_SLEEPF);
 		break;
 	}
 }
 
+void acpi_free_pnp_ids(struct acpi_device_pnp *pnp)
+{
+	struct acpi_hardware_id *id, *tmp;
+
+	list_for_each_entry_safe(id, tmp, &pnp->ids, list) {
+		kfree(id->id);
+		kfree(id);
+	}
+	kfree(pnp->unique_id);
+}
+
 void acpi_init_device_object(struct acpi_device *device, acpi_handle handle,
 			     int type, unsigned long long sta)
 {
@@ -1597,7 +1598,7 @@ void acpi_init_device_object(struct acpi_device *device, acpi_handle handle,
 	device->parent = acpi_bus_get_parent(handle);
 	STRUCT_TO_INT(device->status) = sta;
 	acpi_device_get_busid(device);
-	acpi_device_set_id(device);
+	acpi_set_pnp_ids(handle, &device->pnp, type);
 	acpi_bus_get_flags(device);
 	device->flags.match_driver = false;
 	device_initialize(&device->dev);
