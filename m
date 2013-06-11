Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab3FKLyz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 07:54:55 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:54347 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307Ab3FKLyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 07:54:53 -0400
From: Jiang Liu <liuj97@gmail.com>
To: "Alexander E . Patrakov" <patrakov@gmail.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Yinghai Lu <yinghai@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ACPIPHP: fix device destroying order issue in handling dock notification
Date: Tue, 11 Jun 2013 19:52:23 +0800
Message-Id: <1370951543-15841-1-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current ACPI glue logic expects that physical devices are destroyed
before destroying companion ACPI devices, otherwise it will break the
ACPI unbind logic and cause following warning messages:
[  185.026073] usb usb5: Oops, 'acpi_handle' corrupt
[  185.035150] pci 0000:1b:00.0: Oops, 'acpi_handle' corrupt
[  185.035515] pci 0000:18:02.0: Oops, 'acpi_handle' corrupt
[  180.013656]  port1: Oops, 'acpi_handle' corrupt
Please refer to https://bugzilla.kernel.org/attachment.cgi?id=104321
for full log message.

Above warning messages are caused by following scenario:
1) acpi_dock_notifier_call() queues a task (T1) onto kacpi_hotplug_wq
2) kacpi_hotplug_wq handles T1, which invokes acpi_dock_deferred_cb()
   ->dock_notify()-> handle_eject_request()->hotplug_dock_devices()
3) hotplug_dock_devices() first invokes registered hotplug callbacks to
   destroy physical devices, then destroys all affected ACPI devices.
   Everything seems perfect until now. But the acpiphp dock notification
   handler will queue another task (T2) onto kacpi_hotplug_wq to really
   destroy affected physical devices.
4) kacpi_hotplug_wq finishes T1, and all affected ACPI devices have
   been destroyed.
5) kacpi_hotplug_wq handles T2, which destroys all affected physical
   devices.

So it breaks the ACPI glue expection because ACPI devices are destroyed
in step 3 and physical devices are destroyed in step 5.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
Hi all,
   We are trying to solve bug https://bugzilla.kernel.org/show_bug.cgi?id=59501
And seems there are multiple bugs behind bug 59501. This draft patch tries to
fix one of those issues. I will send out form patchset once all issue have been
resolved.

Regards!
Gerry
---
 drivers/pci/hotplug/acpiphp_glue.c | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index 716aa93..b132aca 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -61,7 +61,10 @@ static DEFINE_MUTEX(bridge_mutex);
 static void handle_hotplug_event_bridge (acpi_handle, u32, void *);
 static void acpiphp_sanitize_bus(struct pci_bus *bus);
 static void acpiphp_set_hpp_values(struct pci_bus *bus);
-static void handle_hotplug_event_func(acpi_handle handle, u32 type, void *context);
+static void __handle_hotplug_event_func(acpi_handle handle, u32 type,
+					void *context);
+static void handle_hotplug_event_func(acpi_handle handle, u32 type,
+				      void *context);
 static void free_bridge(struct kref *kref);
 
 /* callback routine to check for the existence of a pci dock device */
@@ -147,7 +150,7 @@ static int post_dock_fixups(struct notifier_block *nb, unsigned long val,
 
 
 static const struct acpi_dock_ops acpiphp_dock_ops = {
-	.handler = handle_hotplug_event_func,
+	.handler = __handle_hotplug_event_func,
 };
 
 /* Check whether the PCI device is managed by native PCIe hotplug driver */
@@ -1065,20 +1068,13 @@ static void handle_hotplug_event_bridge(acpi_handle handle, u32 type,
 	alloc_acpi_hp_work(handle, type, context, _handle_hotplug_event_bridge);
 }
 
-static void _handle_hotplug_event_func(struct work_struct *work)
+static void __handle_hotplug_event_func(acpi_handle handle, u32 type,
+					void *context)
 {
-	struct acpiphp_func *func;
+	struct acpiphp_func *func = context;
 	char objname[64];
 	struct acpi_buffer buffer = { .length = sizeof(objname),
 				      .pointer = objname };
-	struct acpi_hp_work *hp_work;
-	acpi_handle handle;
-	u32 type;
-
-	hp_work = container_of(work, struct acpi_hp_work, work);
-	handle = hp_work->handle;
-	type = hp_work->type;
-	func = (struct acpiphp_func *)hp_work->context;
 
 	acpi_scan_lock_acquire();
 
@@ -1115,6 +1111,17 @@ static void _handle_hotplug_event_func(struct work_struct *work)
 	}
 
 	acpi_scan_lock_release();
+}
+
+static void _handle_hotplug_event_func(struct work_struct *work)
+{
+	struct acpiphp_func *func;
+	struct acpi_hp_work *hp_work;
+
+	hp_work = container_of(work, struct acpi_hp_work, work);
+	func = (struct acpiphp_func *)hp_work->context;
+	__handle_hotplug_event_func(hp_work->handle, hp_work->type,
+				    hp_work->context);
 	kfree(hp_work); /* allocated in handle_hotplug_event_func */
 	put_bridge(func->slot->bridge);
 }
-- 
1.8.1.2

