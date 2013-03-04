Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932702Ab3CDVl5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 16:41:57 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:45817 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932254Ab3CDVlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 16:41:55 -0500
From: Toshi Kani <toshi.kani@hp.com>
To: rjw@sisk.pl
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, jiang.liu@huawei.com,
        isimatu.yasuaki@jp.fujitsu.com, Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH 1/3] ACPI: Remove acpi_device dependency in acpi_device_set_id()
Date: Mon,  4 Mar 2013 14:30:41 -0700
Message-Id: <1362432643-25636-2-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1362432643-25636-1-git-send-email-toshi.kani@hp.com>
References: <1362432643-25636-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates the internal operations of acpi_device_set_id()
to setup acpi_device_pnp without using acpi_device.  There is no
functional change to acpi_device_set_id() in this patch.

acpi_pnp_type is added to acpi_device_pnp, so that PNPID type is
self-contained within acpi_device_pnp.  acpi_add_id(), acpi_bay_match(),
acpi_dock_match(), acpi_ibm_smbus_match() and acpi_is_video_device()
are changed to take acpi_handle as an argument, instead of acpi_device.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 drivers/acpi/scan.c                   |   69 ++++++++++++++++-----------------
 drivers/acpi/video_detect.c           |   25 +++++-------
 drivers/gpu/drm/i915/intel_opregion.c |    4 +-
 include/acpi/acpi_bus.h               |   14 +++++--
 include/linux/acpi.h                  |    4 +-
 5 files changed, 59 insertions(+), 57 deletions(-)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index d69d77a..f9c698d 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -526,7 +526,7 @@ static int acpi_device_setup_files(struct acpi_device *dev)
 			goto end;
 	}
 
-	if (dev->flags.bus_address)
+	if (dev->pnp.type.bus_address)
 		result = device_create_file(&dev->dev, &dev_attr_adr);
 	if (dev->pnp.unique_id)
 		result = device_create_file(&dev->dev, &dev_attr_uid);
@@ -599,7 +599,7 @@ static void acpi_device_remove_files(struct acpi_device *dev)
 
 	if (dev->pnp.unique_id)
 		device_remove_file(&dev->dev, &dev_attr_uid);
-	if (dev->flags.bus_address)
+	if (dev->pnp.type.bus_address)
 		device_remove_file(&dev->dev, &dev_attr_adr);
 	device_remove_file(&dev->dev, &dev_attr_modalias);
 	device_remove_file(&dev->dev, &dev_attr_hid);
@@ -1406,19 +1406,17 @@ static void acpi_device_get_busid(struct acpi_device *device)
 }
 
 /*
- * acpi_bay_match - see if a device is an ejectable driver bay
+ * acpi_bay_match - see if an acpi object is an ejectable driver bay
  *
  * If an acpi object is ejectable and has one of the ACPI ATA methods defined,
  * then we can safely call it an ejectable drive bay
  */
-static int acpi_bay_match(struct acpi_device *device){
+static int acpi_bay_match(acpi_handle handle)
+{
 	acpi_status status;
-	acpi_handle handle;
 	acpi_handle tmp;
 	acpi_handle phandle;
 
-	handle = device->handle;
-
 	status = acpi_get_handle(handle, "_EJ0", &tmp);
 	if (ACPI_FAILURE(status))
 		return -ENODEV;
@@ -1442,12 +1440,12 @@ static int acpi_bay_match(struct acpi_device *device){
 }
 
 /*
- * acpi_dock_match - see if a device has a _DCK method
+ * acpi_dock_match - see if an acpi object has a _DCK method
  */
-static int acpi_dock_match(struct acpi_device *device)
+static int acpi_dock_match(acpi_handle handle)
 {
 	acpi_handle tmp;
-	return acpi_get_handle(device->handle, "_DCK", &tmp);
+	return acpi_get_handle(handle, "_DCK", &tmp);
 }
 
 const char *acpi_device_hid(struct acpi_device *device)
@@ -1462,7 +1460,7 @@ const char *acpi_device_hid(struct acpi_device *device)
 }
 EXPORT_SYMBOL(acpi_device_hid);
 
-static void acpi_add_id(struct acpi_device *device, const char *dev_id)
+static void acpi_add_id(struct acpi_device_pnp *pnp, const char *dev_id)
 {
 	struct acpi_hardware_id *id;
 
@@ -1476,7 +1474,8 @@ static void acpi_add_id(struct acpi_device *device, const char *dev_id)
 		return;
 	}
 
-	list_add_tail(&id->list, &device->pnp.ids);
+	list_add_tail(&id->list, &pnp->ids);
+	pnp->type.hardware_id = 1;
 }
 
 /*
@@ -1484,7 +1483,7 @@ static void acpi_add_id(struct acpi_device *device, const char *dev_id)
  * lacks the SMBUS01 HID and the methods do not have the necessary "_"
  * prefix.  Work around this.
  */
-static int acpi_ibm_smbus_match(struct acpi_device *device)
+static int acpi_ibm_smbus_match(acpi_handle handle)
 {
 	acpi_handle h_dummy;
 	struct acpi_buffer path = {ACPI_ALLOCATE_BUFFER, NULL};
@@ -1494,7 +1493,7 @@ static int acpi_ibm_smbus_match(struct acpi_device *device)
 		return -ENODEV;
 
 	/* Look for SMBS object */
-	result = acpi_get_name(device->handle, ACPI_SINGLE_NAME, &path);
+	result = acpi_get_name(handle, ACPI_SINGLE_NAME, &path);
 	if (result)
 		return result;
 
@@ -1505,9 +1504,9 @@ static int acpi_ibm_smbus_match(struct acpi_device *device)
 
 	/* Does it have the necessary (but misnamed) methods? */
 	result = -ENODEV;
-	if (ACPI_SUCCESS(acpi_get_handle(device->handle, "SBI", &h_dummy)) &&
-	    ACPI_SUCCESS(acpi_get_handle(device->handle, "SBR", &h_dummy)) &&
-	    ACPI_SUCCESS(acpi_get_handle(device->handle, "SBW", &h_dummy)))
+	if (ACPI_SUCCESS(acpi_get_handle(handle, "SBI", &h_dummy)) &&
+	    ACPI_SUCCESS(acpi_get_handle(handle, "SBR", &h_dummy)) &&
+	    ACPI_SUCCESS(acpi_get_handle(handle, "SBW", &h_dummy)))
 		result = 0;
 out:
 	kfree(path.pointer);
@@ -1524,7 +1523,7 @@ static void acpi_device_set_id(struct acpi_device *device)
 	switch (device->device_type) {
 	case ACPI_BUS_TYPE_DEVICE:
 		if (ACPI_IS_ROOT_DEVICE(device)) {
-			acpi_add_id(device, ACPI_SYSTEM_HID);
+			acpi_add_id(&device->pnp, ACPI_SYSTEM_HID);
 			break;
 		}
 
@@ -1535,15 +1534,15 @@ static void acpi_device_set_id(struct acpi_device *device)
 		}
 
 		if (info->valid & ACPI_VALID_HID)
-			acpi_add_id(device, info->hardware_id.string);
+			acpi_add_id(&device->pnp, info->hardware_id.string);
 		if (info->valid & ACPI_VALID_CID) {
 			cid_list = &info->compatible_id_list;
 			for (i = 0; i < cid_list->count; i++)
-				acpi_add_id(device, cid_list->ids[i].string);
+				acpi_add_id(&device->pnp, cid_list->ids[i].string);
 		}
 		if (info->valid & ACPI_VALID_ADR) {
 			device->pnp.bus_address = info->address;
-			device->flags.bus_address = 1;
+			device->pnp.type.bus_address = 1;
 		}
 		if (info->valid & ACPI_VALID_UID)
 			device->pnp.unique_id = kstrdup(info->unique_id.string,
@@ -1555,36 +1554,36 @@ static void acpi_device_set_id(struct acpi_device *device)
 		 * Some devices don't reliably have _HIDs & _CIDs, so add
 		 * synthetic HIDs to make sure drivers can find them.
 		 */
-		if (acpi_is_video_device(device))
-			acpi_add_id(device, ACPI_VIDEO_HID);
-		else if (ACPI_SUCCESS(acpi_bay_match(device)))
-			acpi_add_id(device, ACPI_BAY_HID);
-		else if (ACPI_SUCCESS(acpi_dock_match(device)))
-			acpi_add_id(device, ACPI_DOCK_HID);
-		else if (!acpi_ibm_smbus_match(device))
-			acpi_add_id(device, ACPI_SMBUS_IBM_HID);
+		if (acpi_is_video_device(device->handle))
+			acpi_add_id(&device->pnp, ACPI_VIDEO_HID);
+		else if (ACPI_SUCCESS(acpi_bay_match(device->handle)))
+			acpi_add_id(&device->pnp, ACPI_BAY_HID);
+		else if (ACPI_SUCCESS(acpi_dock_match(device->handle)))
+			acpi_add_id(&device->pnp, ACPI_DOCK_HID);
+		else if (!acpi_ibm_smbus_match(device->handle))
+			acpi_add_id(&device->pnp, ACPI_SMBUS_IBM_HID);
 		else if (list_empty(&device->pnp.ids) &&
 			 ACPI_IS_ROOT_DEVICE(device->parent)) {
-			acpi_add_id(device, ACPI_BUS_HID); /* \_SB, LNXSYBUS */
+			acpi_add_id(&device->pnp, ACPI_BUS_HID); /* \_SB, LNXSYBUS */
 			strcpy(device->pnp.device_name, ACPI_BUS_DEVICE_NAME);
 			strcpy(device->pnp.device_class, ACPI_BUS_CLASS);
 		}
 
 		break;
 	case ACPI_BUS_TYPE_POWER:
-		acpi_add_id(device, ACPI_POWER_HID);
+		acpi_add_id(&device->pnp, ACPI_POWER_HID);
 		break;
 	case ACPI_BUS_TYPE_PROCESSOR:
-		acpi_add_id(device, ACPI_PROCESSOR_OBJECT_HID);
+		acpi_add_id(&device->pnp, ACPI_PROCESSOR_OBJECT_HID);
 		break;
 	case ACPI_BUS_TYPE_THERMAL:
-		acpi_add_id(device, ACPI_THERMAL_HID);
+		acpi_add_id(&device->pnp, ACPI_THERMAL_HID);
 		break;
 	case ACPI_BUS_TYPE_POWER_BUTTON:
-		acpi_add_id(device, ACPI_BUTTON_HID_POWERF);
+		acpi_add_id(&device->pnp, ACPI_BUTTON_HID_POWERF);
 		break;
 	case ACPI_BUS_TYPE_SLEEP_BUTTON:
-		acpi_add_id(device, ACPI_BUTTON_HID_SLEEPF);
+		acpi_add_id(&device->pnp, ACPI_BUTTON_HID_SLEEPF);
 		break;
 	}
 }
diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 4ac2593..66f6762 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -67,40 +67,37 @@ acpi_backlight_cap_match(acpi_handle handle, u32 level, void *context,
 	return 0;
 }
 
-/* Returns true if the device is a video device which can be handled by
- * video.ko.
+/* Returns true if the ACPI object is a video device which can be
+ * handled by video.ko.
  * The device will get a Linux specific CID added in scan.c to
  * identify the device as an ACPI graphics device
  * Be aware that the graphics device may not be physically present
  * Use acpi_video_get_capabilities() to detect general ACPI video
  * capabilities of present cards
  */
-long acpi_is_video_device(struct acpi_device *device)
+long acpi_is_video_device(acpi_handle handle)
 {
 	acpi_handle h_dummy;
 	long video_caps = 0;
 
-	if (!device)
-		return 0;
-
 	/* Is this device able to support video switching ? */
-	if (ACPI_SUCCESS(acpi_get_handle(device->handle, "_DOD", &h_dummy)) ||
-	    ACPI_SUCCESS(acpi_get_handle(device->handle, "_DOS", &h_dummy)))
+	if (ACPI_SUCCESS(acpi_get_handle(handle, "_DOD", &h_dummy)) ||
+	    ACPI_SUCCESS(acpi_get_handle(handle, "_DOS", &h_dummy)))
 		video_caps |= ACPI_VIDEO_OUTPUT_SWITCHING;
 
 	/* Is this device able to retrieve a video ROM ? */
-	if (ACPI_SUCCESS(acpi_get_handle(device->handle, "_ROM", &h_dummy)))
+	if (ACPI_SUCCESS(acpi_get_handle(handle, "_ROM", &h_dummy)))
 		video_caps |= ACPI_VIDEO_ROM_AVAILABLE;
 
 	/* Is this device able to configure which video head to be POSTed ? */
-	if (ACPI_SUCCESS(acpi_get_handle(device->handle, "_VPO", &h_dummy)) &&
-	    ACPI_SUCCESS(acpi_get_handle(device->handle, "_GPD", &h_dummy)) &&
-	    ACPI_SUCCESS(acpi_get_handle(device->handle, "_SPD", &h_dummy)))
+	if (ACPI_SUCCESS(acpi_get_handle(handle, "_VPO", &h_dummy)) &&
+	    ACPI_SUCCESS(acpi_get_handle(handle, "_GPD", &h_dummy)) &&
+	    ACPI_SUCCESS(acpi_get_handle(handle, "_SPD", &h_dummy)))
 		video_caps |= ACPI_VIDEO_DEVICE_POSTING;
 
 	/* Only check for backlight functionality if one of the above hit. */
 	if (video_caps)
-		acpi_walk_namespace(ACPI_TYPE_DEVICE, device->handle,
+		acpi_walk_namespace(ACPI_TYPE_DEVICE, handle,
 				    ACPI_UINT32_MAX, acpi_backlight_cap_match, NULL,
 				    &video_caps, NULL);
 
@@ -127,7 +124,7 @@ find_video(acpi_handle handle, u32 lvl, void *context, void **rv)
 		if (!dev)
 			return AE_OK;
 		pci_dev_put(dev);
-		*cap |= acpi_is_video_device(acpi_dev);
+		*cap |= acpi_is_video_device(handle);
 	}
 	return AE_OK;
 }
diff --git a/drivers/gpu/drm/i915/intel_opregion.c b/drivers/gpu/drm/i915/intel_opregion.c
index 4d33874..a8117e6 100644
--- a/drivers/gpu/drm/i915/intel_opregion.c
+++ b/drivers/gpu/drm/i915/intel_opregion.c
@@ -350,11 +350,11 @@ static void intel_didl_outputs(struct drm_device *dev)
 	if (!handle || acpi_bus_get_device(handle, &acpi_dev))
 		return;
 
-	if (acpi_is_video_device(acpi_dev))
+	if (acpi_is_video_device(handle))
 		acpi_video_bus = acpi_dev;
 	else {
 		list_for_each_entry(acpi_cdev, &acpi_dev->children, node) {
-			if (acpi_is_video_device(acpi_cdev)) {
+			if (acpi_is_video_device(acpi_cdev->handle)) {
 				acpi_video_bus = acpi_cdev;
 				break;
 			}
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index e658e33..98db31d 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -161,7 +161,6 @@ struct acpi_device_status {
 
 struct acpi_device_flags {
 	u32 dynamic_status:1;
-	u32 bus_address:1;
 	u32 removable:1;
 	u32 ejectable:1;
 	u32 suprise_removal_ok:1;
@@ -169,7 +168,7 @@ struct acpi_device_flags {
 	u32 performance_manageable:1;
 	u32 eject_pending:1;
 	u32 match_driver:1;
-	u32 reserved:23;
+	u32 reserved:24;
 };
 
 /* File System */
@@ -192,10 +191,17 @@ struct acpi_hardware_id {
 	char *id;
 };
 
+struct acpi_pnp_type {
+	u32 hardware_id:1;
+	u32 bus_address:1;
+	u32 reserved:30;
+};
+
 struct acpi_device_pnp {
-	acpi_bus_id bus_id;	/* Object name */
+	acpi_bus_id bus_id;		/* Object name */
+	struct acpi_pnp_type type;	/* ID type */
 	acpi_bus_address bus_address;	/* _ADR */
-	char *unique_id;	/* _UID */
+	char *unique_id;		/* _UID */
 	struct list_head ids;		/* _HID and _CIDs */
 	acpi_device_name device_name;	/* Driver-determined */
 	acpi_device_class device_class;	/*        "          */
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index bcbdd74..edaf311 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -204,7 +204,7 @@ extern bool wmi_has_guid(const char *guid);
 #if defined(CONFIG_ACPI_VIDEO) || defined(CONFIG_ACPI_VIDEO_MODULE)
 
 extern long acpi_video_get_capabilities(acpi_handle graphics_dev_handle);
-extern long acpi_is_video_device(struct acpi_device *device);
+extern long acpi_is_video_device(acpi_handle handle);
 extern void acpi_video_dmi_promote_vendor(void);
 extern void acpi_video_dmi_demote_vendor(void);
 extern int acpi_video_backlight_support(void);
@@ -217,7 +217,7 @@ static inline long acpi_video_get_capabilities(acpi_handle graphics_dev_handle)
 	return 0;
 }
 
-static inline long acpi_is_video_device(struct acpi_device *device)
+static inline long acpi_is_video_device(acpi_handle handle)
 {
 	return 0;
 }
