Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091Ab3L0WQS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 17:16:18 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:51038 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755054Ab3L0WQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 17:16:14 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Toshi Kani <toshi.kani@hp.com>,
        Yinghai Lu <yinghai@kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH 1/2] ACPI / hotplug: Add demand_offline hotplug profile flag
Date: Fri, 27 Dec 2013 23:23:42 +0100
Message-ID: <2072876.4FiiQkgF4K@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <63118574.0bgUpLnDbK@vostro.rjw.lan>
References: <1421028.Rsfpmhnym3@vostro.rjw.lan> <2686210.6vSP0yehxh@vostro.rjw.lan> <63118574.0bgUpLnDbK@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Add a new ACPI hotplug profile flag, demand_offline, such that if
set for the given ACPI device object's scan handler, it will cause
acpi_scan_hot_remove() to check if that device object's physical
companions are offline upfront and fail the hot removal if that
is not the case.

That flag will be useful to overcome a problem with containers on
some system where they can only be hot-removed after some cleanup
operations carried out by user space, which needs to be notified
of the container hot-removal before the kernel attempts to offline
devices in the container.  In those cases the current implementation
of acpi_scan_hot_remove() is not sufficient, because it first tries
to offline the devices in the container and only if that is
suffcessful it tries to offline the container itself.  As a result,
the container hot-removal notification is not delivered to user space
at the right time.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/scan.c     |   41 +++++++++++++++++++++++++++++++++++++----
 include/acpi/acpi_bus.h |    3 ++-
 2 files changed, 39 insertions(+), 5 deletions(-)

Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -126,6 +126,24 @@ acpi_device_modalias_show(struct device
 }
 static DEVICE_ATTR(modalias, 0444, acpi_device_modalias_show, NULL);
 
+static bool acpi_scan_is_offline(struct acpi_device *adev)
+{
+	struct acpi_device_physical_node *pn;
+	bool offline = true;
+
+	mutex_lock(&adev->physical_node_lock);
+
+	list_for_each_entry(pn, &adev->physical_node_list, node)
+		if (device_supports_offline(pn->dev) && !pn->dev->offline) {
+			kobject_uevent(&pn->dev->kobj, KOBJ_CHANGE);
+			offline = false;
+			break;
+		}
+
+	mutex_unlock(&adev->physical_node_lock);
+	return offline;
+}
+
 static acpi_status acpi_bus_offline(acpi_handle handle, u32 lvl, void *data,
 				    void **ret_p)
 {
@@ -196,12 +214,11 @@ static acpi_status acpi_bus_online(acpi_
 	return AE_OK;
 }
 
-static int acpi_scan_hot_remove(struct acpi_device *device)
+static int acpi_scan_try_to_offline(struct acpi_device *device)
 {
 	acpi_handle handle = device->handle;
-	struct device *errdev;
+	struct device *errdev = NULL;
 	acpi_status status;
-	unsigned long long sta;
 
 	/*
 	 * Carry out two passes here and ignore errors in the first pass,
@@ -212,7 +229,6 @@ static int acpi_scan_hot_remove(struct a
 	 *
 	 * If the first pass is successful, the second one isn't needed, though.
 	 */
-	errdev = NULL;
 	status = acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
 				     NULL, acpi_bus_offline, (void *)false,
 				     (void **)&errdev);
@@ -241,6 +257,23 @@ static int acpi_scan_hot_remove(struct a
 			return -EBUSY;
 		}
 	}
+	return 0;
+}
+
+static int acpi_scan_hot_remove(struct acpi_device *device)
+{
+	acpi_handle handle = device->handle;
+	unsigned long long sta;
+	acpi_status status;
+
+	if (device->handler->hotplug.demand_offline && !acpi_force_hot_remove) {
+		if (!acpi_scan_is_offline(device))
+			return -EBUSY;
+	} else {
+		int error = acpi_scan_try_to_offline(device);
+		if (error)
+			return error;
+	}
 
 	ACPI_DEBUG_PRINT((ACPI_DB_INFO,
 		"Hot-removing device %s...\n", dev_name(&device->dev)));
Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -91,8 +91,9 @@ struct acpi_device;
 
 struct acpi_hotplug_profile {
 	struct kobject kobj;
-	bool enabled:1;
 	int (*scan_dependent)(struct acpi_device *adev);
+	bool enabled:1;
+	bool demand_offline:1;
 };
 
 static inline struct acpi_hotplug_profile *to_acpi_hotplug_profile(

