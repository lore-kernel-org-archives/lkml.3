Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329AbaCAUmb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 15:42:31 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:57896 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753201AbaCAUma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 15:42:30 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH] ACPI / hotplug: Rework deferred execution of acpi_device_hotplug()
Date: Sat, 01 Mar 2014 21:57:34 +0100
Message-ID: <1573287.V189PcUPxA@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Since the only function executed by acpi_hotplug_execute() is
acpi_device_hotplug() and it only is called by the ACPI core,
simplify its definition so that it only takes two arguments, the
ACPI device object pointer and event code, rename it to
acpi_hotplug_schedule() and move its header from acpi_bus.h to
the ACPI core's internal header file internal.h.  Modify the
definition of acpi_device_hotplug() so that its first argument is
an ACPI device object pointer and modify the definition of
struct acpi_hp_work accordingly.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

On top of current linux-next, 3.15 material.

Thanks!

---
 drivers/acpi/bus.c      |    2 +-
 drivers/acpi/internal.h |    3 ++-
 drivers/acpi/osl.c      |   14 ++++++--------
 drivers/acpi/scan.c     |    6 ++----
 include/acpi/acpi_bus.h |    4 ----
 5 files changed, 11 insertions(+), 18 deletions(-)

Index: linux-pm/drivers/acpi/internal.h
===================================================================
--- linux-pm.orig/drivers/acpi/internal.h
+++ linux-pm/drivers/acpi/internal.h
@@ -78,8 +78,9 @@ void acpi_lpss_init(void);
 static inline void acpi_lpss_init(void) {}
 #endif
 
+acpi_status acpi_hotplug_schedule(struct acpi_device *adev, u32 src);
 bool acpi_queue_hotplug_work(struct work_struct *work);
-void acpi_device_hotplug(void *data, u32 src);
+void acpi_device_hotplug(struct acpi_device *adev, u32 src);
 bool acpi_scan_is_offline(struct acpi_device *adev, bool uevent);
 
 /* --------------------------------------------------------------------------
Index: linux-pm/drivers/acpi/osl.c
===================================================================
--- linux-pm.orig/drivers/acpi/osl.c
+++ linux-pm/drivers/acpi/osl.c
@@ -1168,8 +1168,7 @@ void acpi_os_wait_events_complete(void)
 
 struct acpi_hp_work {
 	struct work_struct work;
-	acpi_hp_callback func;
-	void *data;
+	struct acpi_device *adev;
 	u32 src;
 };
 
@@ -1178,25 +1177,24 @@ static void acpi_hotplug_work_fn(struct
 	struct acpi_hp_work *hpw = container_of(work, struct acpi_hp_work, work);
 
 	acpi_os_wait_events_complete();
-	hpw->func(hpw->data, hpw->src);
+	acpi_device_hotplug(hpw->adev, hpw->src);
 	kfree(hpw);
 }
 
-acpi_status acpi_hotplug_execute(acpi_hp_callback func, void *data, u32 src)
+acpi_status acpi_hotplug_schedule(struct acpi_device *adev, u32 src)
 {
 	struct acpi_hp_work *hpw;
 
 	ACPI_DEBUG_PRINT((ACPI_DB_EXEC,
-		  "Scheduling function [%p(%p, %u)] for deferred execution.\n",
-		  func, data, src));
+		  "Scheduling hotplug event (%p, %u) for deferred execution.\n",
+		  adev, src));
 
 	hpw = kmalloc(sizeof(*hpw), GFP_KERNEL);
 	if (!hpw)
 		return AE_NO_MEMORY;
 
 	INIT_WORK(&hpw->work, acpi_hotplug_work_fn);
-	hpw->func = func;
-	hpw->data = data;
+	hpw->adev = adev;
 	hpw->src = src;
 	/*
 	 * We can't run hotplug code in kacpid_wq/kacpid_notify_wq etc., because
Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -457,10 +457,6 @@ static inline bool acpi_device_enumerate
 	return adev && adev->flags.initialized && adev->flags.visited;
 }
 
-typedef void (*acpi_hp_callback)(void *data, u32 src);
-
-acpi_status acpi_hotplug_execute(acpi_hp_callback func, void *data, u32 src);
-
 /**
  * module_acpi_driver(acpi_driver) - Helper macro for registering an ACPI driver
  * @__acpi_driver: acpi_driver struct
Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -481,10 +481,9 @@ static int acpi_generic_hotplug_event(st
 	return -EINVAL;
 }
 
-void acpi_device_hotplug(void *data, u32 src)
+void acpi_device_hotplug(struct acpi_device *adev, u32 src)
 {
 	u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE;
-	struct acpi_device *adev = data;
 	int error = -ENODEV;
 
 	lock_device_hotplug();
@@ -579,8 +578,7 @@ acpi_eject_store(struct device *d, struc
 		return -ENODEV;
 
 	get_device(&acpi_device->dev);
-	status = acpi_hotplug_execute(acpi_device_hotplug, acpi_device,
-				      ACPI_OST_EC_OSPM_EJECT);
+	status = acpi_hotplug_schedule(acpi_device, ACPI_OST_EC_OSPM_EJECT);
 	if (ACPI_SUCCESS(status))
 		return count;
 
Index: linux-pm/drivers/acpi/bus.c
===================================================================
--- linux-pm.orig/drivers/acpi/bus.c
+++ linux-pm/drivers/acpi/bus.c
@@ -398,7 +398,7 @@ static void acpi_bus_notify(acpi_handle
 	case ACPI_NOTIFY_BUS_CHECK:
 	case ACPI_NOTIFY_DEVICE_CHECK:
 	case ACPI_NOTIFY_EJECT_REQUEST:
-		status = acpi_hotplug_execute(acpi_device_hotplug, adev, type);
+		status = acpi_hotplug_schedule(adev, type);
 		if (ACPI_SUCCESS(status))
 			return;
 	default:

