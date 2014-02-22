Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818AbaBVAAV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 19:00:21 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:51116 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753502AbaBVAAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 19:00:18 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Linux PCI <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Tejun Heo <tj@kernel.org>,
        Aaron Lu <aaron.lu@intel.com>
Subject: [Update 2x][PATCH 6/9] ACPI / ATA: Add hotplug contexts to ACPI companions of SATA devices
Date: Sat, 22 Feb 2014 01:15:12 +0100
Message-ID: <2102320.A16RufA7nI@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5317534.79aoyQFAO7@vostro.rjw.lan>
References: <3011875.q18rCmXyYX@vostro.rjw.lan> <1707532.0BItEHDuFB@vostro.rjw.lan> <5317534.79aoyQFAO7@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Modify the SATA subsystem to add hotplug contexts to ACPI companions
of SATA devices and ports instead of registering special ACPI dock
operations using register_hotplug_dock_device().

That change will allow the entire code handling those special ACPI
dock operations to be dropped in the next commit.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Aaron Lu <aaron.lu@intel.com>
Acked-by: Tejun Heo <tj@kernel.org>
---

The previous version caused modular builds of libata-acpi.c to fail because
of the ACPI hotplug context locking wrappers that aren't exported to modules.
I (hopefully) fixed that by introducing a wrapper around acpi_set_hp_context()
that does the locking and is exported.

I retained the Reviewed-by and ACK above, because the change was only cosmetic,
so please let me know if that's not appropriate.

Rafael

---
 drivers/acpi/scan.c       |   11 +++++++
 drivers/ata/libata-acpi.c |   72 ++++++++++++++++++++++++++++------------------
 include/acpi/acpi_bus.h   |    5 +++
 3 files changed, 61 insertions(+), 27 deletions(-)

Index: linux-pm/drivers/ata/libata-acpi.c
===================================================================
--- linux-pm.orig/drivers/ata/libata-acpi.c
+++ linux-pm/drivers/ata/libata-acpi.c
@@ -38,6 +38,16 @@ static void ata_acpi_clear_gtf(struct at
 	dev->gtf_cache = NULL;
 }
 
+struct ata_acpi_hotplug_context {
+	struct acpi_hotplug_context hp;
+	union {
+		struct ata_port *ap;
+		struct ata_device *dev;
+	} data;
+};
+
+#define ata_hotplug_data(context) (container_of((context), struct ata_acpi_hotplug_context, hp)->data)
+
 /**
  * ata_dev_acpi_handle - provide the acpi_handle for an ata_device
  * @dev: the acpi_handle returned will correspond to this device
@@ -121,18 +131,17 @@ static void ata_acpi_handle_hotplug(stru
 		ata_port_wait_eh(ap);
 }
 
-static void ata_acpi_dev_notify_dock(acpi_handle handle, u32 event, void *data)
+static int ata_acpi_dev_notify_dock(struct acpi_device *adev, u32 event)
 {
-	struct ata_device *dev = data;
-
+	struct ata_device *dev = ata_hotplug_data(adev->hp).dev;
 	ata_acpi_handle_hotplug(dev->link->ap, dev, event);
+	return 0;
 }
 
-static void ata_acpi_ap_notify_dock(acpi_handle handle, u32 event, void *data)
+static int ata_acpi_ap_notify_dock(struct acpi_device *adev, u32 event)
 {
-	struct ata_port *ap = data;
-
-	ata_acpi_handle_hotplug(ap, NULL, event);
+	ata_acpi_handle_hotplug(ata_hotplug_data(adev->hp).ap, NULL, event);
+	return 0;
 }
 
 static void ata_acpi_uevent(struct ata_port *ap, struct ata_device *dev,
@@ -154,31 +163,23 @@ static void ata_acpi_uevent(struct ata_p
 	}
 }
 
-static void ata_acpi_ap_uevent(acpi_handle handle, u32 event, void *data)
+static void ata_acpi_ap_uevent(struct acpi_device *adev, u32 event)
 {
-	ata_acpi_uevent(data, NULL, event);
+	ata_acpi_uevent(ata_hotplug_data(adev->hp).ap, NULL, event);
 }
 
-static void ata_acpi_dev_uevent(acpi_handle handle, u32 event, void *data)
+static void ata_acpi_dev_uevent(struct acpi_device *adev, u32 event)
 {
-	struct ata_device *dev = data;
+	struct ata_device *dev = ata_hotplug_data(adev->hp).dev;
 	ata_acpi_uevent(dev->link->ap, dev, event);
 }
 
-static const struct acpi_dock_ops ata_acpi_dev_dock_ops = {
-	.handler = ata_acpi_dev_notify_dock,
-	.uevent = ata_acpi_dev_uevent,
-};
-
-static const struct acpi_dock_ops ata_acpi_ap_dock_ops = {
-	.handler = ata_acpi_ap_notify_dock,
-	.uevent = ata_acpi_ap_uevent,
-};
-
 /* bind acpi handle to pata port */
 void ata_acpi_bind_port(struct ata_port *ap)
 {
 	struct acpi_device *host_companion = ACPI_COMPANION(ap->host->dev);
+	struct acpi_device *adev;
+	struct ata_acpi_hotplug_context *context;
 
 	if (libata_noacpi || ap->flags & ATA_FLAG_ACPI_SATA || !host_companion)
 		return;
@@ -188,9 +189,17 @@ void ata_acpi_bind_port(struct ata_port
 	if (ata_acpi_gtm(ap, &ap->__acpi_init_gtm) == 0)
 		ap->pflags |= ATA_PFLAG_INIT_GTM_VALID;
 
-	/* we might be on a docking station */
-	register_hotplug_dock_device(ACPI_HANDLE(&ap->tdev),
-				     &ata_acpi_ap_dock_ops, ap, NULL, NULL);
+	adev = ACPI_COMPANION(&ap->tdev);
+	if (!adev || adev->hp)
+		return;
+
+	context = kzalloc(sizeof(*context), GFP_KERNEL);
+	if (!context)
+		return;
+
+	context->data.ap = ap;
+	acpi_initialize_hp_context(adev, &context->hp, ata_acpi_ap_notify_dock,
+				   ata_acpi_ap_uevent);
 }
 
 void ata_acpi_bind_dev(struct ata_device *dev)
@@ -198,7 +207,8 @@ void ata_acpi_bind_dev(struct ata_device
 	struct ata_port *ap = dev->link->ap;
 	struct acpi_device *port_companion = ACPI_COMPANION(&ap->tdev);
 	struct acpi_device *host_companion = ACPI_COMPANION(ap->host->dev);
-	struct acpi_device *parent;
+	struct acpi_device *parent, *adev;
+	struct ata_acpi_hotplug_context *context;
 	u64 adr;
 
 	/*
@@ -221,9 +231,17 @@ void ata_acpi_bind_dev(struct ata_device
 	}
 
 	acpi_preset_companion(&dev->tdev, parent, adr);
+	adev = ACPI_COMPANION(&dev->tdev);
+	if (!adev || adev->hp)
+		return;
+
+	context = kzalloc(sizeof(*context), GFP_KERNEL);
+	if (!context)
+		return;
 
-	register_hotplug_dock_device(ata_dev_acpi_handle(dev),
-				     &ata_acpi_dev_dock_ops, dev, NULL, NULL);
+	context->data.dev = dev;
+	acpi_initialize_hp_context(adev, &context->hp, ata_acpi_dev_notify_dock,
+				   ata_acpi_dev_uevent);
 }
 
 /**
Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -71,6 +71,17 @@ void acpi_unlock_hp_context(void)
 	mutex_unlock(&acpi_hp_context_lock);
 }
 
+void acpi_initialize_hp_context(struct acpi_device *adev,
+				struct acpi_hotplug_context *hp,
+				int (*notify)(struct acpi_device *, u32),
+				void (*uevent)(struct acpi_device *, u32))
+{
+	acpi_lock_hp_context();
+	acpi_set_hp_context(adev, hp, notify, uevent, NULL);
+	acpi_unlock_hp_context();
+}
+EXPORT_SYMBOL_GPL(acpi_initialize_hp_context);
+
 int acpi_scan_add_handler(struct acpi_scan_handler *handler)
 {
 	if (!handler || !handler->attach)
Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -381,6 +381,11 @@ static inline void acpi_set_hp_context(s
 	adev->hp = hp;
 }
 
+void acpi_initialize_hp_context(struct acpi_device *adev,
+				struct acpi_hotplug_context *hp,
+				int (*notify)(struct acpi_device *, u32),
+				void (*uevent)(struct acpi_device *, u32));
+
 /* acpi_device.dev.bus == &acpi_bus_type */
 extern struct bus_type acpi_bus_type;
 

