Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932734Ab3CDVmO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 16:42:14 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:9762 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932254Ab3CDVl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 16:41:58 -0500
From: Toshi Kani <toshi.kani@hp.com>
To: rjw@sisk.pl
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, jiang.liu@huawei.com,
        isimatu.yasuaki@jp.fujitsu.com, Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH 3/3] ACPI: Update PNPID match handling for notify
Date: Mon,  4 Mar 2013 14:30:43 -0700
Message-Id: <1362432643-25636-4-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1362432643-25636-1-git-send-email-toshi.kani@hp.com>
References: <1362432643-25636-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When installing/removing a notify handler to/from an ACPI device
object, ACPI core tries to match its associated scan handler to
see if it supports hotplug.  However, the matching logic of the
notify handler is different from the matching logic of attaching
a scan handler to an ACPI device object.  This patch updates the
matching logic of the notify handlers to be consistent with the
attach handling.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 drivers/acpi/scan.c |   85 +++++++++++++++++++++++++++++++--------------------
 1 file changed, 52 insertions(+), 33 deletions(-)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index e9a71ed..3f6ec0d 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -1703,24 +1703,47 @@ static bool acpi_scan_handler_matching(struct acpi_scan_handler *handler,
 	return false;
 }
 
+static struct acpi_scan_handler *acpi_scan_match_handler(char *idstr,
+					const struct acpi_device_id **matchid)
+{
+	struct acpi_scan_handler *handler;
+
+	list_for_each_entry(handler, &acpi_scan_handlers_list, list_node)
+		if (acpi_scan_handler_matching(handler, idstr, matchid))
+			return handler;
+
+	return NULL;
+}
+
 static acpi_status acpi_scan_hotplug_modify(acpi_handle handle,
 					    u32 lvl_not_used, void *data,
 					    void **ret_not_used)
 {
-	struct acpi_scan_handler *handler = data;
-	struct acpi_device_info *info;
+	struct acpi_device_pnp pnp = {};
+	struct acpi_scan_handler *tgt_handler = data, *handler;
+	struct acpi_hardware_id *hwid;
+	unsigned long long sta_not_used;
+	int type;
 	bool match = false;
 
-	if (ACPI_FAILURE(acpi_get_object_info(handle, &info)))
+	if (acpi_bus_type_and_status(handle, &type, &sta_not_used))
+		return AE_OK;
+
+	INIT_LIST_HEAD(&pnp.ids);
+	acpi_set_pnp_ids(handle, &pnp, type);
+
+	if (!pnp.type.hardware_id)
 		return AE_OK;
 
-	if (info->valid & ACPI_VALID_HID) {
-		char *idstr = info->hardware_id.string;
-		match = acpi_scan_handler_matching(handler, idstr, NULL);
+	list_for_each_entry(hwid, &pnp.ids, list) {
+		handler = acpi_scan_match_handler(hwid->id, NULL);
+		if (handler && handler == tgt_handler) {
+			match = true;
+			break;
+		}
 	}
-	kfree(info);
 	if (!match)
-		return AE_OK;
+		goto out;
 
 	if (handler->hotplug.enabled)
 		acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
@@ -1729,6 +1752,8 @@ static acpi_status acpi_scan_hotplug_modify(acpi_handle handle,
 		acpi_remove_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
 					   acpi_hotplug_notify_cb);
 
+out:
+	acpi_free_pnp_ids(&pnp);
 	return AE_OK;
 }
 
@@ -1749,40 +1774,34 @@ void acpi_scan_hotplug_enabled(struct acpi_hotplug_profile *hotplug, bool val)
 	mutex_unlock(&acpi_scan_lock);
 }
 
-static struct acpi_scan_handler *acpi_scan_match_handler(char *idstr,
-					const struct acpi_device_id **matchid)
-{
-	struct acpi_scan_handler *handler;
-
-	list_for_each_entry(handler, &acpi_scan_handlers_list, list_node)
-		if (acpi_scan_handler_matching(handler, idstr, matchid))
-			return handler;
-
-	return NULL;
-}
-
-static void acpi_scan_init_hotplug(acpi_handle handle)
+static void acpi_scan_init_hotplug(acpi_handle handle, int type)
 {
-	struct acpi_device_info *info;
+	struct acpi_device_pnp pnp = {};
+	struct acpi_hardware_id *hwid;
 	struct acpi_scan_handler *handler;
 
-	if (ACPI_FAILURE(acpi_get_object_info(handle, &info)))
-		return;
+	INIT_LIST_HEAD(&pnp.ids);
+	acpi_set_pnp_ids(handle, &pnp, type);
 
-	if (!(info->valid & ACPI_VALID_HID)) {
-		kfree(info);
+	if (!pnp.type.hardware_id)
 		return;
-	}
 
 	/*
 	 * This relies on the fact that acpi_install_notify_handler() will not
 	 * install the same notify handler routine twice for the same handle.
 	 */
-	handler = acpi_scan_match_handler(info->hardware_id.string, NULL);
-	kfree(info);
-	if (handler && handler->hotplug.enabled)
-		acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
-					    acpi_hotplug_notify_cb, NULL);
+	list_for_each_entry(hwid, &pnp.ids, list) {
+		handler = acpi_scan_match_handler(hwid->id, NULL);
+		if (handler) {
+			if (handler->hotplug.enabled)
+				acpi_install_notify_handler(handle,
+					ACPI_SYSTEM_NOTIFY,
+					acpi_hotplug_notify_cb, NULL);
+			break;
+		}
+	}
+
+	acpi_free_pnp_ids(&pnp);
 }
 
 static acpi_status acpi_bus_check_add(acpi_handle handle, u32 lvl_not_used,
@@ -1807,7 +1826,7 @@ static acpi_status acpi_bus_check_add(acpi_handle handle, u32 lvl_not_used,
 		return AE_OK;
 	}
 
-	acpi_scan_init_hotplug(handle);
+	acpi_scan_init_hotplug(handle, type);
 
 	if (!(sta & ACPI_STA_DEVICE_PRESENT) &&
 	    !(sta & ACPI_STA_DEVICE_FUNCTIONING)) {
