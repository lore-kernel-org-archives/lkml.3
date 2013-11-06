Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023Ab3KFBaA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 20:30:00 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:59846 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755807Ab3KFB35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 20:29:57 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Toshi Kani <toshi.kani@hp.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: [Update][PATCH 1/3] ACPI / hotplug: Carry out PCI root eject directly
Date: Wed, 06 Nov 2013 02:42:15 +0100
Message-ID: <1621020.2qB4Krltq7@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <2420016.uapGc1R1go@vostro.rjw.lan>
References: <5839747.7HXXGHmMBd@vostro.rjw.lan> <18462848.9zsetEL1Yy@vostro.rjw.lan> <2420016.uapGc1R1go@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Subject: ACPI / hotplug: Carry out PCI root eject directly

Since _handle_hotplug_event_root() is run from the ACPI hotplug
workqueue, it doesn't need to queue up a work item to eject a PCI
host bridge on the same workqueue.  Instead, it can just carry out
the eject by calling acpi_bus_device_eject() directly, so make that
happen.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

It looks like I sent this too early. :-/

Obviously, acpi_bus_device_eject() cannot be called under acpi_scan_lock,
so that lock has to be dropped before calling that function.

Patch [3/3] doesn't apply any more after this modification, so I'll send
an update of it too.

Thanks,
Rafael

---
 drivers/acpi/internal.h |    2 +-
 drivers/acpi/pci_root.c |   24 ++++++++++--------------
 drivers/acpi/scan.c     |    4 ++--
 3 files changed, 13 insertions(+), 17 deletions(-)

Index: linux-pm/drivers/acpi/internal.h
===================================================================
--- linux-pm.orig/drivers/acpi/internal.h
+++ linux-pm/drivers/acpi/internal.h
@@ -92,7 +92,7 @@ void acpi_device_add_finalize(struct acp
 void acpi_free_pnp_ids(struct acpi_device_pnp *pnp);
 int acpi_bind_one(struct device *dev, acpi_handle handle);
 int acpi_unbind_one(struct device *dev);
-void acpi_bus_hot_remove_device(void *context);
+void acpi_bus_device_eject(struct acpi_device *device, u32 ost_src);
 
 /* --------------------------------------------------------------------------
                                   Power Resource
Index: linux-pm/drivers/acpi/pci_root.c
===================================================================
--- linux-pm.orig/drivers/acpi/pci_root.c
+++ linux-pm/drivers/acpi/pci_root.c
@@ -592,16 +592,6 @@ static void handle_root_bridge_insertion
 		acpi_handle_err(handle, "cannot add bridge to acpi list\n");
 }
 
-static void handle_root_bridge_removal(struct acpi_device *device)
-{
-	acpi_status status;
-
-	get_device(&device->dev);
-	status = acpi_os_hotplug_execute(acpi_bus_hot_remove_device, device);
-	if (ACPI_FAILURE(status))
-		put_device(&device->dev);
-}
-
 static void _handle_hotplug_event_root(struct work_struct *work)
 {
 	struct acpi_pci_root *root;
@@ -612,6 +602,7 @@ static void _handle_hotplug_event_root(s
 	hp_work = container_of(work, struct acpi_hp_work, work);
 	handle = hp_work->handle;
 	type = hp_work->type;
+	kfree(hp_work); /* allocated in handle_hotplug_event_bridge */
 
 	acpi_scan_lock_acquire();
 
@@ -641,9 +632,15 @@ static void _handle_hotplug_event_root(s
 		/* request device eject */
 		acpi_handle_printk(KERN_DEBUG, handle,
 				   "Device eject notify on %s\n", __func__);
-		if (root)
-			handle_root_bridge_removal(root->device);
-		break;
+		if (!root)
+			break;
+
+		get_device(&root->device->dev);
+
+		acpi_scan_lock_release();
+
+		acpi_bus_device_eject(root->device, ACPI_NOTIFY_EJECT_REQUEST);
+		return;
 	default:
 		acpi_handle_warn(handle,
 				 "notify_handler: unknown event type 0x%x\n",
@@ -652,7 +649,6 @@ static void _handle_hotplug_event_root(s
 	}
 
 	acpi_scan_lock_release();
-	kfree(hp_work); /* allocated in handle_hotplug_event_bridge */
 }
 
 static void handle_hotplug_event_root(acpi_handle handle, u32 type,
Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -285,7 +285,7 @@ static int acpi_scan_hot_remove(struct a
 	return 0;
 }
 
-static void acpi_bus_device_eject(struct acpi_device *device, u32 ost_src)
+void acpi_bus_device_eject(struct acpi_device *device, u32 ost_src)
 {
 	acpi_handle handle = device->handle;
 	struct acpi_scan_handler *handler;
@@ -409,7 +409,7 @@ static void acpi_hotplug_unsupported(acp
  * acpi_bus_hot_remove_device: Hot-remove a device and its children.
  * @context: Address of the ACPI device object to hot-remove.
  */
-void acpi_bus_hot_remove_device(void *context)
+static void acpi_bus_hot_remove_device(void *context)
 {
 	acpi_bus_device_eject(context, ACPI_NOTIFY_EJECT_REQUEST);
 }

