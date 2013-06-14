Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060Ab3FNTgt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 15:36:49 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:35032 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab3FNTgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 15:36:47 -0400
From: Jiang Liu <jiang.liu@huawei.com>
To: "Rafael J . Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bhelgaas@google.com>,
        Yinghai Lu <yinghai@kernel.org>,
        "Alexander E . Patrakov" <patrakov@gmail.com>
Cc: Jiang Liu <jiang.liu@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yijing Wang <wangyijing@huawei.com>, linux-acpi@vger.kernel.org,
        Jiang Liu <liuj97@gmail.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [BUGFIX v2 3/4] PCI, ACPI: fix device destroying order issue when handling dock notification
Date: Sat, 15 Jun 2013 03:28:00 +0800
Message-Id: <1371238081-32260-4-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371238081-32260-1-git-send-email-jiang.liu@huawei.com>
References: <1371238081-32260-1-git-send-email-jiang.liu@huawei.com>
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

So it breaks ACPI glue logic's expection because ACPI devices are destroyed
in step 3 and physical devices are destroyed in step 5.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Reported-by: Alexander E. Patrakov <patrakov@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org # 3.8+
---
 drivers/pci/hotplug/acpiphp_glue.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index 5d696f5..a65203b 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -61,6 +61,8 @@ static DEFINE_MUTEX(bridge_mutex);
 static void handle_hotplug_event_bridge (acpi_handle, u32, void *);
 static void acpiphp_sanitize_bus(struct pci_bus *bus);
 static void acpiphp_set_hpp_values(struct pci_bus *bus);
+static void _handle_hotplug_event_func(acpi_handle handle, u32 type,
+				       void *context);
 static void handle_hotplug_event_func(acpi_handle handle, u32 type, void *context);
 static void free_bridge(struct kref *kref);
 
@@ -160,7 +162,7 @@ static void acpiphp_dock_put(void *data)
 }
 
 static const struct acpi_dock_ops acpiphp_dock_ops = {
-	.handler = handle_hotplug_event_func,
+	.handler = _handle_hotplug_event_func,
 	.get = acpiphp_dock_get,
 	.put = acpiphp_dock_put,
 };
@@ -1080,22 +1082,13 @@ static void handle_hotplug_event_bridge(acpi_handle handle, u32 type,
 	alloc_acpi_hp_work(handle, type, context, _handle_hotplug_event_bridge);
 }
 
-static void _handle_hotplug_event_func(struct work_struct *work)
+static void _handle_hotplug_event_func(acpi_handle handle, u32 type,
+				       void *context)
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
-
-	acpi_scan_lock_acquire();
 
 	acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
 
@@ -1128,7 +1121,18 @@ static void _handle_hotplug_event_func(struct work_struct *work)
 		warn("notify_handler: unknown event type 0x%x for %s\n", type, objname);
 		break;
 	}
+}
+
+static void _handle_hotplug_event_cb(struct work_struct *work)
+{
+	struct acpiphp_func *func;
+	struct acpi_hp_work *hp_work;
 
+	hp_work = container_of(work, struct acpi_hp_work, work);
+	func = (struct acpiphp_func *)hp_work->context;
+	acpi_scan_lock_acquire();
+	_handle_hotplug_event_func(hp_work->handle, hp_work->type,
+				    hp_work->context);
 	acpi_scan_lock_release();
 	kfree(hp_work); /* allocated in handle_hotplug_event_func */
 	put_bridge(func->slot->bridge);
@@ -1156,7 +1160,7 @@ static void handle_hotplug_event_func(acpi_handle handle, u32 type,
 	 * don't deadlock on hotplug actions.
 	 */
 	get_bridge(func->slot->bridge);
-	alloc_acpi_hp_work(handle, type, context, _handle_hotplug_event_func);
+	alloc_acpi_hp_work(handle, type, context, _handle_hotplug_event_cb);
 }
 
 /*
-- 
1.8.1.2

