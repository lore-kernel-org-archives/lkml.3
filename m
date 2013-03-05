Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575Ab3CEWom (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 17:44:42 -0500
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:22331 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755831Ab3CEWoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 17:44:38 -0500
From: Toshi Kani <toshi.kani@hp.com>
To: rjw@sisk.pl
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, jiang.liu@huawei.com,
        isimatu.yasuaki@jp.fujitsu.com, Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH] ACPI: Update _OST handling for notify
Date: Tue,  5 Mar 2013 15:33:31 -0700
Message-Id: <1362522811-29063-1-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the kernel calls _OSC with OSC_SB_HOTPLUG_OST_SUPPORT bit
set at boot-time, the OS is responsible for calling _OST for
ACPI hotplug events.  However, when hotplug.enabled attribute
is unset for ACPI scan drivers, their notify handlers are removed
and _OST is not called for ACPI hotplug events as a result.

This patch keeps the notify handler of ACPI scan drivers,
acpi_hotplug_notify_cb(), installed regardless of the state of
hotplug.enabled.  The notify handler then checks if hotplug.enabled
is set for the associated scan handler.  If unset, the notify
handler calls _OST with a proper error code.  The patch also
eliminates ACPI namespace walk when hotplug.enabled is changed
via sysfs.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---

This patch applies on top of the following patchset.
https://lkml.org/lkml/2013/3/4/455

---
 drivers/acpi/scan.c |   87 +++++++++++++++++++++------------------------------
 1 file changed, 35 insertions(+), 52 deletions(-)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 3f6ec0d..dfdbcfd 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -259,11 +259,43 @@ static void acpi_scan_device_check(void *context)
 				   ACPI_NOTIFY_DEVICE_CHECK);
 }
 
-static void acpi_hotplug_notify_cb(acpi_handle handle, u32 type, void *not_used)
+static void acpi_hotplug_unsupported(acpi_handle handle, u32 type)
+{
+	u32 ost_status;
+
+	switch (type) {
+	case ACPI_NOTIFY_BUS_CHECK:
+		acpi_handle_debug(handle,
+			"ACPI_NOTIFY_BUS_CHECK event: unsupported\n");
+		ost_status = ACPI_OST_SC_INSERT_NOT_SUPPORTED;
+		break;
+	case ACPI_NOTIFY_DEVICE_CHECK:
+		acpi_handle_debug(handle,
+			"ACPI_NOTIFY_DEVICE_CHECK event: unsupported\n");
+		ost_status = ACPI_OST_SC_INSERT_NOT_SUPPORTED;
+		break;
+	case ACPI_NOTIFY_EJECT_REQUEST:
+		acpi_handle_debug(handle,
+			"ACPI_NOTIFY_EJECT_REQUEST event: unsupported\n");
+		ost_status = ACPI_OST_SC_EJECT_NOT_SUPPORTED;
+		break;
+	default:
+		/* non-hotplug event; possibly handled by other handler */
+		return;
+	}
+
+	acpi_evaluate_hotplug_ost(handle, type, ost_status, NULL);
+}
+
+static void acpi_hotplug_notify_cb(acpi_handle handle, u32 type, void *data)
 {
 	acpi_osd_exec_callback callback;
+	struct acpi_scan_handler *handler = data;
 	acpi_status status;
 
+	if (!handler->hotplug.enabled)
+		return acpi_hotplug_unsupported(handle, type);
+
 	switch (type) {
 	case ACPI_NOTIFY_BUS_CHECK:
 		acpi_handle_debug(handle, "ACPI_NOTIFY_BUS_CHECK event\n");
@@ -1715,61 +1747,14 @@ static struct acpi_scan_handler *acpi_scan_match_handler(char *idstr,
 	return NULL;
 }
 
-static acpi_status acpi_scan_hotplug_modify(acpi_handle handle,
-					    u32 lvl_not_used, void *data,
-					    void **ret_not_used)
-{
-	struct acpi_device_pnp pnp = {};
-	struct acpi_scan_handler *tgt_handler = data, *handler;
-	struct acpi_hardware_id *hwid;
-	unsigned long long sta_not_used;
-	int type;
-	bool match = false;
-
-	if (acpi_bus_type_and_status(handle, &type, &sta_not_used))
-		return AE_OK;
-
-	INIT_LIST_HEAD(&pnp.ids);
-	acpi_set_pnp_ids(handle, &pnp, type);
-
-	if (!pnp.type.hardware_id)
-		return AE_OK;
-
-	list_for_each_entry(hwid, &pnp.ids, list) {
-		handler = acpi_scan_match_handler(hwid->id, NULL);
-		if (handler && handler == tgt_handler) {
-			match = true;
-			break;
-		}
-	}
-	if (!match)
-		goto out;
-
-	if (handler->hotplug.enabled)
-		acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
-					    acpi_hotplug_notify_cb, NULL);
-	else
-		acpi_remove_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
-					   acpi_hotplug_notify_cb);
-
-out:
-	acpi_free_pnp_ids(&pnp);
-	return AE_OK;
-}
-
 void acpi_scan_hotplug_enabled(struct acpi_hotplug_profile *hotplug, bool val)
 {
-	struct acpi_scan_handler *handler;
-
 	if (!!hotplug->enabled == !!val)
 		return;
 
 	mutex_lock(&acpi_scan_lock);
 
 	hotplug->enabled = val;
-	handler = container_of(hotplug, struct acpi_scan_handler, hotplug);
-	acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT, ACPI_UINT32_MAX,
-			    acpi_scan_hotplug_modify, NULL, handler, NULL);
 
 	mutex_unlock(&acpi_scan_lock);
 }
@@ -1793,10 +1778,8 @@ static void acpi_scan_init_hotplug(acpi_handle handle, int type)
 	list_for_each_entry(hwid, &pnp.ids, list) {
 		handler = acpi_scan_match_handler(hwid->id, NULL);
 		if (handler) {
-			if (handler->hotplug.enabled)
-				acpi_install_notify_handler(handle,
-					ACPI_SYSTEM_NOTIFY,
-					acpi_hotplug_notify_cb, NULL);
+			acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
+					acpi_hotplug_notify_cb, handler);
 			break;
 		}
 	}
