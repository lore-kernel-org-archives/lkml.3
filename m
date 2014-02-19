Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbaBSBUk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 20:20:40 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:56100 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751675AbaBSBSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 20:18:33 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Linux PCI <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Tejun Heo <tj@kernel.org>,
        Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH 5/9] ACPI / dock: Add .uevent() callback to struct acpi_hotplug_context
Date: Wed, 19 Feb 2014 02:30:02 +0100
Message-ID: <1634069.8i1LGae7Tj@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <3011875.q18rCmXyYX@vostro.rjw.lan>
References: <3011875.q18rCmXyYX@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

In order to avoid the need to register special ACPI dock
operations for SATA devices add a .uevent() callback pointer to
struct acpi_hotplug_context and make dock_hotplug_event() use that
callback if available.  Also rename the existing .event() callback
in struct acpi_hotplug_context to .notify() to avoid possible
confusion in the future.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/dock.c                |   11 ++++++++++-
 drivers/acpi/scan.c                |    8 ++++----
 drivers/pci/hotplug/acpiphp_glue.c |    8 ++++----
 include/acpi/acpi_bus.h            |    9 ++++++---
 4 files changed, 24 insertions(+), 12 deletions(-)

Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -145,7 +145,8 @@ struct acpi_scan_handler {
 
 struct acpi_hotplug_context {
 	struct acpi_device *self;
-	int (*event)(struct acpi_device *, u32);
+	int (*notify)(struct acpi_device *, u32);
+	void (*uevent)(struct acpi_device *, u32);
 	void (*fixup)(struct acpi_device *);
 };
 
@@ -369,11 +370,13 @@ static inline void acpi_set_device_statu
 
 static inline void acpi_set_hp_context(struct acpi_device *adev,
 				       struct acpi_hotplug_context *hp,
-				       int (*event)(struct acpi_device *, u32),
+				       int (*notify)(struct acpi_device *, u32),
+				       void (*uevent)(struct acpi_device *, u32),
 				       void (*fixup)(struct acpi_device *))
 {
 	hp->self = adev;
-	hp->event = event;
+	hp->notify = notify;
+	hp->uevent = uevent;
 	hp->fixup = fixup;
 	adev->hp = hp;
 }
Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -496,17 +496,17 @@ void acpi_device_hotplug(void *data, u32
 			goto err_out;
 		}
 	} else {
-		int (*event)(struct acpi_device *, u32);
+		int (*notify)(struct acpi_device *, u32);
 
 		acpi_lock_hp_context();
-		event = adev->hp ? adev->hp->event : NULL;
+		notify = adev->hp ? adev->hp->notify : NULL;
 		acpi_unlock_hp_context();
 		/*
 		 * There may be additional notify handlers for device objects
 		 * without the .event() callback, so ignore them here.
 		 */
-		if (event)
-			error = event(adev, src);
+		if (notify)
+			error = notify(adev, src);
 		else
 			goto out;
 	}
Index: linux-pm/drivers/acpi/dock.c
===================================================================
--- linux-pm.orig/drivers/acpi/dock.c
+++ linux-pm/drivers/acpi/dock.c
@@ -203,10 +203,19 @@ static void dock_hotplug_event(struct do
 			fixup(adev);
 			return;
 		}
+	} else if (cb_type == DOCK_CALL_UEVENT) {
+		void (*uevent)(struct acpi_device *, u32);
+
+		uevent = adev->hp->uevent;
+		if (uevent) {
+			acpi_unlock_hp_context();
+			uevent(adev, event);
+			return;
+		}
 	} else {
 		int (*notify)(struct acpi_device *, u32);
 
-		notify = adev->hp->event;
+		notify = adev->hp->notify;
 		if (notify) {
 			acpi_unlock_hp_context();
 			notify(adev, event);
Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -59,7 +59,7 @@
 static LIST_HEAD(bridge_list);
 static DEFINE_MUTEX(bridge_mutex);
 
-static int acpiphp_hotplug_event(struct acpi_device *adev, u32 type);
+static int acpiphp_hotplug_notify(struct acpi_device *adev, u32 type);
 static void acpiphp_post_dock_fixup(struct acpi_device *adev);
 static void acpiphp_sanitize_bus(struct pci_bus *bus);
 static void acpiphp_set_hpp_values(struct pci_bus *bus);
@@ -81,7 +81,7 @@ static struct acpiphp_context *acpiphp_i
 		return NULL;
 
 	context->refcount = 1;
-	acpi_set_hp_context(adev, &context->hp, acpiphp_hotplug_event,
+	acpi_set_hp_context(adev, &context->hp, acpiphp_hotplug_notify, NULL,
 			    acpiphp_post_dock_fixup);
 	return context;
 }
@@ -400,7 +400,7 @@ static void cleanup_bridge(struct acpiph
 			struct acpi_device *adev = func_to_acpi_device(func);
 
 			acpi_lock_hp_context();
-			adev->hp->event = NULL;
+			adev->hp->notify = NULL;
 			adev->hp->fixup = NULL;
 			acpi_unlock_hp_context();
 		}
@@ -833,7 +833,7 @@ static void hotplug_event(u32 type, stru
 		put_bridge(bridge);
 }
 
-static int acpiphp_hotplug_event(struct acpi_device *adev, u32 type)
+static int acpiphp_hotplug_notify(struct acpi_device *adev, u32 type)
 {
 	struct acpiphp_context *context;
 

