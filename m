Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352Ab3F1WqP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 18:46:15 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:54524 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752705Ab3F1Wpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 18:45:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Jiang Liu <liuj97@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        "Alexander E. Patrakov" <patrakov@gmail.com>
Subject: [PATCH 1/3] ACPI / dock: Rework the handling of notifications
Date: Sat, 29 Jun 2013 00:53:35 +0200
Message-ID: <1771749.8rDXNf8giR@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1515394.L46AJCfCTt@vostro.rjw.lan>
References: <1640211.P0jyS5muX2@vostro.rjw.lan> <1515394.L46AJCfCTt@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The ACPI dock driver uses register_acpi_bus_notifier() which
installs a notifier triggered globally for all system notifications.
That first of all is inefficient, because the dock driver is only
interested in notifications associated with the devices it handles,
but it has to handle all system notifies for all devices.  Moreover,
it does that even if no docking stations are present in the system
(CONFIG_ACPI_DOCK set is sufficient for that to happen).  Besides,
that is inconvenient, because it requires the driver to do extra work
for each notification to find the target dock station object.

For these reasons, rework the dock driver to install a notify
handler individually for each dock station in the system using
acpi_install_notify_handler().  This allows the dock station
object to be passed directly to the notify handler and makes it
possible to simplify the dock driver quite a bit.  It also
reduces the overhead related to the handling of all system
notifies when CONFIG_ACPI_DOCK is set.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/dock.c |   69 ++++++++++++++++++----------------------------------
 1 file changed, 25 insertions(+), 44 deletions(-)

Index: linux-pm/drivers/acpi/dock.c
===================================================================
--- linux-pm.orig/drivers/acpi/dock.c
+++ linux-pm/drivers/acpi/dock.c
@@ -718,18 +718,17 @@ static int handle_eject_request(struct d
 
 /**
  * dock_notify - act upon an acpi dock notification
- * @handle: the dock station handle
+ * @ds: dock station
  * @event: the acpi event
- * @data: our driver data struct
  *
  * If we are notified to dock, then check to see if the dock is
  * present and then dock.  Notify all drivers of the dock event,
  * and then hotplug and devices that may need hotplugging.
  */
-static void dock_notify(acpi_handle handle, u32 event, void *data)
+static void dock_notify(struct dock_station *ds, u32 event)
 {
-	struct dock_station *ds = data;
-	struct acpi_device *tmp;
+	acpi_handle handle = ds->handle;
+	struct acpi_device *ad;
 	int surprise_removal = 0;
 
 	/*
@@ -752,8 +751,7 @@ static void dock_notify(acpi_handle hand
 	switch (event) {
 	case ACPI_NOTIFY_BUS_CHECK:
 	case ACPI_NOTIFY_DEVICE_CHECK:
-		if (!dock_in_progress(ds) && acpi_bus_get_device(ds->handle,
-		   &tmp)) {
+		if (!dock_in_progress(ds) && acpi_bus_get_device(handle, &ad)) {
 			begin_dock(ds);
 			dock(ds);
 			if (!dock_present(ds)) {
@@ -790,9 +788,8 @@ static void dock_notify(acpi_handle hand
 }
 
 struct dock_data {
-	acpi_handle handle;
-	unsigned long event;
 	struct dock_station *ds;
+	u32 event;
 };
 
 static void acpi_dock_deferred_cb(void *context)
@@ -800,52 +797,31 @@ static void acpi_dock_deferred_cb(void *
 	struct dock_data *data = context;
 
 	acpi_scan_lock_acquire();
-	dock_notify(data->handle, data->event, data->ds);
+	dock_notify(data->ds, data->event);
 	acpi_scan_lock_release();
 	kfree(data);
 }
 
-static int acpi_dock_notifier_call(struct notifier_block *this,
-	unsigned long event, void *data)
+static void dock_notify_handler(acpi_handle handle, u32 event, void *data)
 {
-	struct dock_station *dock_station;
-	acpi_handle handle = data;
+	struct dock_data *dd;
 
 	if (event != ACPI_NOTIFY_BUS_CHECK && event != ACPI_NOTIFY_DEVICE_CHECK
 	   && event != ACPI_NOTIFY_EJECT_REQUEST)
-		return 0;
-
-	acpi_scan_lock_acquire();
+		return;
 
-	list_for_each_entry(dock_station, &dock_stations, sibling) {
-		if (dock_station->handle == handle) {
-			struct dock_data *dd;
-			acpi_status status;
-
-			dd = kmalloc(sizeof(*dd), GFP_KERNEL);
-			if (!dd)
-				break;
-
-			dd->handle = handle;
-			dd->event = event;
-			dd->ds = dock_station;
-			status = acpi_os_hotplug_execute(acpi_dock_deferred_cb,
-							 dd);
-			if (ACPI_FAILURE(status))
-				kfree(dd);
-
-			break;
-		}
+	dd = kmalloc(sizeof(*dd), GFP_KERNEL);
+	if (dd) {
+		acpi_status status;
+
+		dd->ds = data;
+		dd->event = event;
+		status = acpi_os_hotplug_execute(acpi_dock_deferred_cb, dd);
+		if (ACPI_FAILURE(status))
+			kfree(dd);
 	}
-
-	acpi_scan_lock_release();
-	return 0;
 }
 
-static struct notifier_block dock_acpi_notifier = {
-	.notifier_call = acpi_dock_notifier_call,
-};
-
 /**
  * find_dock_devices - find devices on the dock station
  * @handle: the handle of the device we are examining
@@ -979,6 +955,7 @@ static int __init dock_add(acpi_handle h
 	int ret, id;
 	struct dock_station ds, *dock_station;
 	struct platform_device *dd;
+	acpi_status status;
 
 	id = dock_station_count;
 	memset(&ds, 0, sizeof(ds));
@@ -1021,6 +998,11 @@ static int __init dock_add(acpi_handle h
 	if (ret)
 		goto err_rmgroup;
 
+	status = acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
+					     dock_notify_handler, dock_station);
+	if (ACPI_FAILURE(status))
+		goto err_rmgroup;
+
 	dock_station_count++;
 	list_add(&dock_station->sibling, &dock_stations);
 	return 0;
@@ -1065,7 +1047,6 @@ int __init acpi_dock_init(void)
 		return 0;
 	}
 
-	register_acpi_bus_notifier(&dock_acpi_notifier);
 	pr_info(PREFIX "%s: %d docks/bays found\n",
 		ACPI_DOCK_DRIVER_DESCRIPTION, dock_station_count);
 	return 0;

