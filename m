Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932322Ab3FLXTx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 19:19:53 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:35477 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758106Ab3FLXS6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 19:18:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "Luck, Tony" <tony.luck@intel.com>,
        Toshi Kani <toshi.kani@hp.com>, Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH 2/5] ACPI / scan: Separate hotplug profiles from scan handlers
Date: Thu, 13 Jun 2013 01:24:37 +0200
Message-ID: <8869893.4ZGKqUiYjc@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1417592.vuSG0cUIGo@vostro.rjw.lan>
References: <1417592.vuSG0cUIGo@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Commit a33ec39 (ACPI / scan: Introduce common code for ACPI-based
device hotplug) decided to embed struct acpi_hotplug_profile into
struct acpi_scan_handler, because it looked like having a hotplug
profile without a scan handler wouldn't make sense.

While that still appears to be the case, it actually does make sense
to combine the container hotplug profile (that kind of plays the role
of a generic hotplug profile) with multiple different scan handlers.

To allow that to be done, replace the hotplug field of struct
acpi_scan_handler with a pointer and modify the code using that
field accordingly.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/acpi_memhotplug.c |   11 +++++++----
 drivers/acpi/acpi_processor.c  |   13 +++++++++----
 drivers/acpi/container.c       |   14 ++++++++------
 drivers/acpi/internal.h        |    5 +----
 drivers/acpi/scan.c            |   29 ++++++++++-------------------
 drivers/acpi/sysfs.c           |   10 ++++++----
 include/acpi/acpi_bus.h        |    3 ++-
 7 files changed, 43 insertions(+), 42 deletions(-)

Index: linux-pm/drivers/acpi/internal.h
===================================================================
--- linux-pm.orig/drivers/acpi/internal.h
+++ linux-pm/drivers/acpi/internal.h
@@ -64,10 +64,7 @@ static inline void acpi_cmos_rtc_init(vo
 
 extern bool acpi_force_hot_remove;
 
-void acpi_sysfs_add_hotplug_profile(struct acpi_hotplug_profile *hotplug,
-				    const char *name);
-int acpi_scan_add_handler_with_hotplug(struct acpi_scan_handler *handler,
-				       const char *hotplug_profile_name);
+void acpi_sysfs_add_hotplug_profile(struct acpi_hotplug_profile *hotplug);
 void acpi_scan_hotplug_enabled(struct acpi_hotplug_profile *hotplug, bool val);
 
 #ifdef CONFIG_DEBUG_FS
Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -66,19 +66,9 @@ int acpi_scan_add_handler(struct acpi_sc
 		return -EINVAL;
 
 	list_add_tail(&handler->list_node, &acpi_scan_handlers_list);
-	return 0;
-}
-
-int acpi_scan_add_handler_with_hotplug(struct acpi_scan_handler *handler,
-				       const char *hotplug_profile_name)
-{
-	int error;
-
-	error = acpi_scan_add_handler(handler);
-	if (error)
-		return error;
+	if (handler->hotplug)
+		acpi_sysfs_add_hotplug_profile(handler->hotplug);
 
-	acpi_sysfs_add_hotplug_profile(&handler->hotplug, hotplug_profile_name);
 	return 0;
 }
 
@@ -316,13 +306,13 @@ static void acpi_bus_device_eject(void *
 		goto err_out;
 
 	handler = device->handler;
-	if (!handler || !handler->hotplug.enabled) {
+	if (!handler || !handler->hotplug || !handler->hotplug->enabled) {
 		ost_code = ACPI_OST_SC_EJECT_NOT_SUPPORTED;
 		goto err_out;
 	}
 	acpi_evaluate_hotplug_ost(handle, ACPI_NOTIFY_EJECT_REQUEST,
 				  ACPI_OST_SC_EJECT_IN_PROGRESS, NULL);
-	if (handler->hotplug.mode == AHM_CONTAINER) {
+	if (handler->hotplug->mode == AHM_CONTAINER) {
 		device->flags.eject_pending = true;
 		kobject_uevent(&device->dev.kobj, KOBJ_OFFLINE);
 	} else {
@@ -371,7 +361,8 @@ static void acpi_scan_bus_device_check(a
 		goto out;
 	}
 	ost_code = ACPI_OST_SC_SUCCESS;
-	if (device->handler && device->handler->hotplug.mode == AHM_CONTAINER)
+	if (device->handler && device->handler->hotplug
+	    && device->handler->hotplug->mode == AHM_CONTAINER)
 		kobject_uevent(&device->dev.kobj, KOBJ_ONLINE);
 
  out:
@@ -426,7 +417,7 @@ static void acpi_hotplug_notify_cb(acpi_
 	struct acpi_scan_handler *handler = data;
 	acpi_status status;
 
-	if (!handler->hotplug.enabled)
+	if (!handler->hotplug || !handler->hotplug->enabled)
 		return acpi_hotplug_unsupported(handle, type);
 
 	switch (type) {
@@ -521,8 +512,8 @@ acpi_eject_store(struct device *d, struc
 	if (!count || buf[0] != '1')
 		return -EINVAL;
 
-	if ((!acpi_device->handler || !acpi_device->handler->hotplug.enabled)
-	    && !acpi_device->driver)
+	if ((!acpi_device->handler || !acpi_device->handler->hotplug
+	    || !acpi_device->handler->hotplug->enabled) && !acpi_device->driver)
 		return -ENODEV;
 
 	status = acpi_get_type(acpi_device->handle, &not_used);
@@ -1883,7 +1874,7 @@ static void acpi_scan_init_hotplug(acpi_
 	 */
 	list_for_each_entry(hwid, &pnp.ids, list) {
 		handler = acpi_scan_match_handler(hwid->id, NULL);
-		if (handler) {
+		if (handler && handler->hotplug) {
 			acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
 					acpi_hotplug_notify_cb, handler);
 			break;
Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -88,6 +88,7 @@ enum acpi_hotplug_mode {
 };
 
 struct acpi_hotplug_profile {
+	const char *name;
 	struct kobject kobj;
 	bool enabled:1;
 	enum acpi_hotplug_mode mode;
@@ -104,7 +105,7 @@ struct acpi_scan_handler {
 	struct list_head list_node;
 	int (*attach)(struct acpi_device *dev, const struct acpi_device_id *id);
 	void (*detach)(struct acpi_device *dev);
-	struct acpi_hotplug_profile hotplug;
+	struct acpi_hotplug_profile *hotplug;
 };
 
 /*
Index: linux-pm/drivers/acpi/container.c
===================================================================
--- linux-pm.orig/drivers/acpi/container.c
+++ linux-pm/drivers/acpi/container.c
@@ -51,17 +51,19 @@ static int container_device_attach(struc
 	return 1;
 }
 
+static struct acpi_hotplug_profile container_hotplug_profile = {
+	.name = "container",
+	.enabled = true,
+	.mode = AHM_CONTAINER,
+};
+
 struct acpi_scan_handler container_scan_handler = {
 	.ids = container_device_ids,
 	.attach = container_device_attach,
-	.hotplug = {
-		.enabled = true,
-		.mode = AHM_CONTAINER,
-	},
+	.hotplug = &container_hotplug_profile,
 };
 
 void __init acpi_container_init(void)
 {
-	acpi_scan_add_handler_with_hotplug(&container_scan_handler,
-					   "container");
+	acpi_scan_add_handler(&container_scan_handler);
 }
Index: linux-pm/drivers/acpi/sysfs.c
===================================================================
--- linux-pm.orig/drivers/acpi/sysfs.c
+++ linux-pm/drivers/acpi/sysfs.c
@@ -755,16 +755,18 @@ static struct kobj_type acpi_hotplug_pro
 	.default_attrs = hotplug_profile_attrs,
 };
 
-void acpi_sysfs_add_hotplug_profile(struct acpi_hotplug_profile *hotplug,
-				    const char *name)
+void acpi_sysfs_add_hotplug_profile(struct acpi_hotplug_profile *hotplug)
 {
 	int error;
 
+	if (!hotplug || !hotplug->name)
+		return;
+
 	if (!hotplug_kobj)
 		goto err_out;
 
 	kobject_init(&hotplug->kobj, &acpi_hotplug_profile_ktype);
-	error = kobject_set_name(&hotplug->kobj, "%s", name);
+	error = kobject_set_name(&hotplug->kobj, "%s", hotplug->name);
 	if (error)
 		goto err_out;
 
@@ -777,7 +779,7 @@ void acpi_sysfs_add_hotplug_profile(stru
 	return;
 
  err_out:
-	pr_err(PREFIX "Unable to add hotplug profile '%s'\n", name);
+	pr_err(PREFIX "Unable to add hotplug profile '%s'\n", hotplug->name);
 }
 
 static ssize_t force_remove_show(struct kobject *kobj,
Index: linux-pm/drivers/acpi/acpi_memhotplug.c
===================================================================
--- linux-pm.orig/drivers/acpi/acpi_memhotplug.c
+++ linux-pm/drivers/acpi/acpi_memhotplug.c
@@ -58,13 +58,16 @@ static const struct acpi_device_id memor
 	{"", 0},
 };
 
+static struct acpi_hotplug_profile memory_hotplug_profile = {
+	.name = "memory",
+	.enabled = true,
+};
+
 static struct acpi_scan_handler memory_device_handler = {
 	.ids = memory_device_ids,
 	.attach = acpi_memory_device_add,
 	.detach = acpi_memory_device_remove,
-	.hotplug = {
-		.enabled = true,
-	},
+	.hotplug = &memory_hotplug_profile,
 };
 
 struct acpi_memory_info {
@@ -361,5 +364,5 @@ static void acpi_memory_device_remove(st
 
 void __init acpi_memory_hotplug_init(void)
 {
-	acpi_scan_add_handler_with_hotplug(&memory_device_handler, "memory");
+	acpi_scan_add_handler(&memory_device_handler);
 }
Index: linux-pm/drivers/acpi/acpi_processor.c
===================================================================
--- linux-pm.orig/drivers/acpi/acpi_processor.c
+++ linux-pm/drivers/acpi/acpi_processor.c
@@ -477,18 +477,23 @@ static const struct acpi_device_id proce
 	{ }
 };
 
+#ifdef CONFIG_ACPI_HOTPLUG_CPU
+static struct acpi_hotplug_profile processor_hotplug_profile = {
+	.name = "processor",
+	.enabled = true,
+};
+#endif
+
 static struct acpi_scan_handler __refdata processor_handler = {
 	.ids = processor_device_ids,
 	.attach = acpi_processor_add,
 #ifdef CONFIG_ACPI_HOTPLUG_CPU
 	.detach = acpi_processor_remove,
+	.hotplug = &processor_hotplug_profile,
 #endif
-	.hotplug = {
-		.enabled = true,
-	},
 };
 
 void __init acpi_processor_init(void)
 {
-	acpi_scan_add_handler_with_hotplug(&processor_handler, "processor");
+	acpi_scan_add_handler(&processor_handler);
 }

