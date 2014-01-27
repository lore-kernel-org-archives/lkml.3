Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410AbaA0AcV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 19:32:21 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:52162 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753257AbaA0AcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 19:32:19 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 11/11] ACPI / hotplug: Do not pass ACPI handles to ACPI dock operations
Date: Mon, 27 Jan 2014 01:46:21 +0100
Message-ID: <2348078.1nGWUoSCvJ@vostro.rjw.lan>
User-Agent: KMail/4.11.4 (Linux/3.13.0+; KDE/4.11.4; x86_64; ; )
In-Reply-To: <2217793.001RY6hKlo@vostro.rjw.lan>
References: <2217793.001RY6hKlo@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

None of the existing users of struct acpi_dock_ops actually needs the
first argument of its member functions, so redefine those functions
to take only two arguments, the event type and data pointer, and
update the users of struct acpi_dock_ops accordingly.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/dock.c                |    4 ++--
 drivers/ata/libata-acpi.c          |    8 ++++----
 drivers/pci/hotplug/acpiphp_glue.c |   13 +++++++------
 include/acpi/acpi_drivers.h        |    6 +++---
 4 files changed, 16 insertions(+), 15 deletions(-)

Index: linux-pm/include/acpi/acpi_drivers.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_drivers.h
+++ linux-pm/include/acpi/acpi_drivers.h
@@ -110,9 +110,9 @@ void pci_acpi_crs_quirks(void);
                                   Dock Station
   -------------------------------------------------------------------------- */
 struct acpi_dock_ops {
-	acpi_notify_handler fixup;
-	acpi_notify_handler handler;
-	acpi_notify_handler uevent;
+	void (*handler)(u32 event_type, void *data);
+	void (*fixup)(u32 event_type, void *data);
+	void (*uevent)(u32 event_type, void *data);
 };
 
 #ifdef CONFIG_ACPI_DOCK
Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -63,7 +63,7 @@ static DEFINE_MUTEX(acpiphp_context_lock
 static void handle_hotplug_event(acpi_handle handle, u32 type, void *data);
 static void acpiphp_sanitize_bus(struct pci_bus *bus);
 static void acpiphp_set_hpp_values(struct pci_bus *bus);
-static void hotplug_event(acpi_handle handle, u32 type, void *data);
+static void hotplug_event(u32 type, void *data);
 static void free_bridge(struct kref *kref);
 
 static void acpiphp_context_handler(acpi_handle handle, void *context)
@@ -185,7 +185,7 @@ static void free_bridge(struct kref *kre
  * TBD - figure out a way to only call fixups for
  * systems that require them.
  */
-static void post_dock_fixups(acpi_handle not_used, u32 event, void *data)
+static void post_dock_fixups(u32 event, void *data)
 {
 	struct acpiphp_context *context = data;
 	struct pci_bus *bus = context->func.slot->bus;
@@ -788,11 +788,12 @@ void acpiphp_check_host_bridge(acpi_hand
 
 static int acpiphp_disable_and_eject_slot(struct acpiphp_slot *slot);
 
-static void hotplug_event(acpi_handle handle, u32 type, void *data)
+static void hotplug_event(u32 type, void *data)
 {
 	struct acpiphp_context *context = data;
 	struct acpiphp_func *func = &context->func;
 	struct acpiphp_slot *slot = func->slot;
+	acpi_handle handle = context->adev->handle;
 	struct acpiphp_bridge *bridge;
 
 	mutex_lock(&acpiphp_context_lock);
@@ -842,16 +843,16 @@ static void hotplug_event(acpi_handle ha
 static void hotplug_event_work(void *data, u32 type)
 {
 	struct acpiphp_context *context = data;
-	acpi_handle handle = context->adev->handle;
 
 	acpi_scan_lock_acquire();
 	pci_lock_rescan_remove();
 
-	hotplug_event(handle, type, context);
+	hotplug_event(type, context);
 
 	pci_unlock_rescan_remove();
 	acpi_scan_lock_release();
-	acpi_evaluate_hotplug_ost(handle, type, ACPI_OST_SC_SUCCESS, NULL);
+	acpi_evaluate_hotplug_ost(context->adev->handle, type,
+				  ACPI_OST_SC_SUCCESS, NULL);
 	put_bridge(context->func.parent);
 }
 
Index: linux-pm/drivers/acpi/dock.c
===================================================================
--- linux-pm.orig/drivers/acpi/dock.c
+++ linux-pm/drivers/acpi/dock.c
@@ -185,7 +185,7 @@ static void dock_release_hotplug(struct
 static void dock_hotplug_event(struct dock_dependent_device *dd, u32 event,
 			       enum dock_callback_type cb_type)
 {
-	acpi_notify_handler cb = NULL;
+	void (*cb)(u32, void *) = NULL;
 	bool run = false;
 
 	mutex_lock(&hotplug_lock);
@@ -213,7 +213,7 @@ static void dock_hotplug_event(struct do
 		return;
 
 	if (cb)
-		cb(dd->handle, event, dd->hp_context);
+		cb(event, dd->hp_context);
 
 	dock_release_hotplug(dd);
 }
Index: linux-pm/drivers/ata/libata-acpi.c
===================================================================
--- linux-pm.orig/drivers/ata/libata-acpi.c
+++ linux-pm/drivers/ata/libata-acpi.c
@@ -121,14 +121,14 @@ static void ata_acpi_handle_hotplug(stru
 		ata_port_wait_eh(ap);
 }
 
-static void ata_acpi_dev_notify_dock(acpi_handle handle, u32 event, void *data)
+static void ata_acpi_dev_notify_dock(u32 event, void *data)
 {
 	struct ata_device *dev = data;
 
 	ata_acpi_handle_hotplug(dev->link->ap, dev, event);
 }
 
-static void ata_acpi_ap_notify_dock(acpi_handle handle, u32 event, void *data)
+static void ata_acpi_ap_notify_dock(u32 event, void *data)
 {
 	struct ata_port *ap = data;
 
@@ -154,12 +154,12 @@ static void ata_acpi_uevent(struct ata_p
 	}
 }
 
-static void ata_acpi_ap_uevent(acpi_handle handle, u32 event, void *data)
+static void ata_acpi_ap_uevent(u32 event, void *data)
 {
 	ata_acpi_uevent(data, NULL, event);
 }
 
-static void ata_acpi_dev_uevent(acpi_handle handle, u32 event, void *data)
+static void ata_acpi_dev_uevent(u32 event, void *data)
 {
 	struct ata_device *dev = data;
 	ata_acpi_uevent(dev->link->ap, dev, event);

