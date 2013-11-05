Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930Ab3KEXgE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 18:36:04 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:59238 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755888Ab3KEXf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 18:35:57 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Toshi Kani <toshi.kani@hp.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 1/3] ACPI / hotplug: Carry out PCI root eject directly
Date: Wed, 06 Nov 2013 00:34:28 +0100
Message-ID: <2420016.uapGc1R1go@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <18462848.9zsetEL1Yy@vostro.rjw.lan>
References: <5839747.7HXXGHmMBd@vostro.rjw.lan> <2970389.SeMGM45Qln@vostro.rjw.lan> <18462848.9zsetEL1Yy@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Since _handle_hotplug_event_root() is run from the ACPI hotplug
workqueue, it doesn't need to queue up a work item to eject a PCI
host bridge on the same workqueue.  Instead, it can just carry out
the eject by calling acpi_bus_device_eject() directly, so make that
happen.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/internal.h |    2 +-
 drivers/acpi/pci_root.c |    6 +-----
 drivers/acpi/scan.c     |    4 ++--
 3 files changed, 4 insertions(+), 8 deletions(-)

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
@@ -594,12 +594,8 @@ static void handle_root_bridge_insertion
 
 static void handle_root_bridge_removal(struct acpi_device *device)
 {
-	acpi_status status;
-
 	get_device(&device->dev);
-	status = acpi_os_hotplug_execute(acpi_bus_hot_remove_device, device);
-	if (ACPI_FAILURE(status))
-		put_device(&device->dev);
+	acpi_bus_device_eject(device, ACPI_NOTIFY_EJECT_REQUEST);
 }
 
 static void _handle_hotplug_event_root(struct work_struct *work)
Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -286,7 +286,7 @@ static int acpi_scan_hot_remove(struct a
 	return 0;
 }
 
-static void acpi_bus_device_eject(struct acpi_device *device, u32 ost_src)
+void acpi_bus_device_eject(struct acpi_device *device, u32 ost_src)
 {
 	acpi_handle handle = device->handle;
 	struct acpi_scan_handler *handler;
@@ -410,7 +410,7 @@ static void acpi_hotplug_unsupported(acp
  * acpi_bus_hot_remove_device: Hot-remove a device and its children.
  * @context: Address of the ACPI device object to hot-remove.
  */
-void acpi_bus_hot_remove_device(void *context)
+static void acpi_bus_hot_remove_device(void *context)
 {
 	acpi_bus_device_eject(context, ACPI_NOTIFY_EJECT_REQUEST);
 }

