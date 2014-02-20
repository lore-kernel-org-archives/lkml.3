Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819AbaBTBc3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 20:32:29 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:60887 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752181AbaBTBc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 20:32:27 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Linux PCI <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Tejun Heo <tj@kernel.org>,
        Aaron Lu <aaron.lu@intel.com>
Subject: [Update][PATCH 6/9] ACPI / ATA: Add hotplug contexts to ACPI companions of SATA devices
Date: Thu, 20 Feb 2014 02:47:19 +0100
Message-ID: <5317534.79aoyQFAO7@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1707532.0BItEHDuFB@vostro.rjw.lan>
References: <3011875.q18rCmXyYX@vostro.rjw.lan> <1707532.0BItEHDuFB@vostro.rjw.lan>
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
---

As noted by Aaron, the hotplug contexts are not freed during ATA device
unregistration, but that is not necessary, because the struct acpi_device
things they are attached to never go away.  However, they obviously should
not be created more than once per struct acpi_device, so I've modified the
patch to skip the creation of hotplug contexts for devices that already
have them.

Thanks,
Rafael

---
 drivers/ata/libata-acpi.c |   76 +++++++++++++++++++++++++++++-----------------
 1 file changed, 49 insertions(+), 27 deletions(-)

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
@@ -188,9 +189,19 @@ void ata_acpi_bind_port(struct ata_port
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
+	acpi_lock_hp_context();
+	acpi_set_hp_context(adev, &context->hp, ata_acpi_ap_notify_dock,
+			    ata_acpi_ap_uevent, NULL);
+	acpi_unlock_hp_context();
 }
 
 void ata_acpi_bind_dev(struct ata_device *dev)
@@ -198,7 +209,8 @@ void ata_acpi_bind_dev(struct ata_device
 	struct ata_port *ap = dev->link->ap;
 	struct acpi_device *port_companion = ACPI_COMPANION(&ap->tdev);
 	struct acpi_device *host_companion = ACPI_COMPANION(ap->host->dev);
-	struct acpi_device *parent;
+	struct acpi_device *parent, *adev;
+	struct ata_acpi_hotplug_context *context;
 	u64 adr;
 
 	/*
@@ -221,9 +233,19 @@ void ata_acpi_bind_dev(struct ata_device
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
+	acpi_lock_hp_context();
+	acpi_set_hp_context(adev, &context->hp, ata_acpi_dev_notify_dock,
+			    ata_acpi_dev_uevent, NULL);
+	acpi_unlock_hp_context();
 }
 
 /**

