Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337Ab3FLXUR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 19:20:17 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:35474 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756939Ab3FLXS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 19:18:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "Luck, Tony" <tony.luck@intel.com>,
        Toshi Kani <toshi.kani@hp.com>, Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH 3/5] ACPI / scan: Add hotplug profile pointer to struct acpi_device
Date: Thu, 13 Jun 2013 01:25:15 +0200
Message-ID: <2104764.58TiduhPzb@vostro.rjw.lan>
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

Since it generally make sense to combine different ACPI scan handlers
(that don't have their own hotplug profiles) with the container
hotplug profile, make it possible by adding a hotplug profile pointer
to struct acpi_device (so that the hotplug profile and scan handler
may be set for device objects independently of each other) and make
the generic hotplug code use the device object's hotplug profile
rather than the hotplug profile from its scan handler.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/scan.c     |   24 +++++++++++++-----------
 include/acpi/acpi_bus.h |    1 +
 2 files changed, 14 insertions(+), 11 deletions(-)

Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -296,7 +296,7 @@ static void acpi_bus_device_eject(void *
 {
 	acpi_handle handle = context;
 	struct acpi_device *device = NULL;
-	struct acpi_scan_handler *handler;
+	struct acpi_hotplug_profile *hotplug;
 	u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE;
 
 	mutex_lock(&acpi_scan_lock);
@@ -305,14 +305,14 @@ static void acpi_bus_device_eject(void *
 	if (!device)
 		goto err_out;
 
-	handler = device->handler;
-	if (!handler || !handler->hotplug || !handler->hotplug->enabled) {
+	hotplug = device->hotplug;
+	if (!hotplug || !hotplug->enabled) {
 		ost_code = ACPI_OST_SC_EJECT_NOT_SUPPORTED;
 		goto err_out;
 	}
 	acpi_evaluate_hotplug_ost(handle, ACPI_NOTIFY_EJECT_REQUEST,
 				  ACPI_OST_SC_EJECT_IN_PROGRESS, NULL);
-	if (handler->hotplug->mode == AHM_CONTAINER) {
+	if (hotplug->mode == AHM_CONTAINER) {
 		device->flags.eject_pending = true;
 		kobject_uevent(&device->dev.kobj, KOBJ_OFFLINE);
 	} else {
@@ -361,8 +361,7 @@ static void acpi_scan_bus_device_check(a
 		goto out;
 	}
 	ost_code = ACPI_OST_SC_SUCCESS;
-	if (device->handler && device->handler->hotplug
-	    && device->handler->hotplug->mode == AHM_CONTAINER)
+	if (device->hotplug && device->hotplug->mode == AHM_CONTAINER)
 		kobject_uevent(&device->dev.kobj, KOBJ_ONLINE);
 
  out:
@@ -414,10 +413,10 @@ static void acpi_hotplug_unsupported(acp
 static void acpi_hotplug_notify_cb(acpi_handle handle, u32 type, void *data)
 {
 	acpi_osd_exec_callback callback;
-	struct acpi_scan_handler *handler = data;
+	struct acpi_hotplug_profile *hotplug = data;
 	acpi_status status;
 
-	if (!handler->hotplug || !handler->hotplug->enabled)
+	if (!hotplug || !hotplug->enabled)
 		return acpi_hotplug_unsupported(handle, type);
 
 	switch (type) {
@@ -512,8 +511,8 @@ acpi_eject_store(struct device *d, struc
 	if (!count || buf[0] != '1')
 		return -EINVAL;
 
-	if ((!acpi_device->handler || !acpi_device->handler->hotplug
-	    || !acpi_device->handler->hotplug->enabled) && !acpi_device->driver)
+	if ((!acpi_device->hotplug || !acpi_device->hotplug->enabled)
+	    && !acpi_device->driver)
 		return -ENODEV;
 
 	status = acpi_get_type(acpi_device->handle, &not_used);
@@ -1876,7 +1875,8 @@ static void acpi_scan_init_hotplug(acpi_
 		handler = acpi_scan_match_handler(hwid->id, NULL);
 		if (handler && handler->hotplug) {
 			acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
-					acpi_hotplug_notify_cb, handler);
+						    acpi_hotplug_notify_cb,
+						    handler->hotplug);
 			break;
 		}
 	}
@@ -1948,6 +1948,7 @@ static int acpi_scan_attach_handler(stru
 			ret = handler->attach(device, devid);
 			if (ret > 0) {
 				device->handler = handler;
+				device->hotplug = handler->hotplug;
 				break;
 			} else if (ret < 0) {
 				break;
@@ -2028,6 +2029,7 @@ static acpi_status acpi_bus_device_detac
 				dev_handler->detach(device);
 
 			device->handler = NULL;
+			device->hotplug = NULL;
 		} else {
 			device_release_driver(&device->dev);
 		}
Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -300,6 +300,7 @@ struct acpi_device {
 	struct acpi_device_perf performance;
 	struct acpi_device_dir dir;
 	struct acpi_scan_handler *handler;
+	struct acpi_hotplug_profile *hotplug;
 	struct acpi_driver *driver;
 	void *driver_data;
 	struct device dev;

