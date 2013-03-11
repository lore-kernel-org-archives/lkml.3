Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673Ab3CKFFU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 01:05:20 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:46521 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046Ab3CKFFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 01:05:19 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] PCI, ACPI: hold acpi_scan_lock during root bus hotplug
Date: Sun, 10 Mar 2013 22:05:16 -0700
Message-Id: <1362978316-23553-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1673357.1IdxNNvGWX@vostro.rjw.lan>
References: <1673357.1IdxNNvGWX@vostro.rjw.lan>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During merging pci tree with pm/acpi tree, Linus noticed that
we don't have same lock using patten about acpi pci root as
acpiphp.

Here apply same lock patten, and we need to change
acpi_bus_hot_remove_device executing via acpi_os_hotplug_execute()
as it also hold the lock in acpi_bus_hot_remove_device.

That will make acpi_bus_hot_remove_device calling the same as other
callers.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>

---
 drivers/acpi/pci_root.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/acpi/pci_root.c
===================================================================
--- linux-2.6.orig/drivers/acpi/pci_root.c
+++ linux-2.6/drivers/acpi/pci_root.c
@@ -646,6 +646,7 @@ static void handle_root_bridge_insertion
 
 static void handle_root_bridge_removal(struct acpi_device *device)
 {
+	acpi_status status;
 	struct acpi_eject_event *ej_event;
 
 	ej_event = kmalloc(sizeof(*ej_event), GFP_KERNEL);
@@ -661,7 +662,9 @@ static void handle_root_bridge_removal(s
 	ej_event->device = device;
 	ej_event->event = ACPI_NOTIFY_EJECT_REQUEST;
 
-	acpi_bus_hot_remove_device(ej_event);
+	status = acpi_os_hotplug_execute(acpi_bus_hot_remove_device, ej_event);
+	if (ACPI_FAILURE(status))
+		kfree(ej_event);
 }
 
 static void _handle_hotplug_event_root(struct work_struct *work)
@@ -676,8 +679,9 @@ static void _handle_hotplug_event_root(s
 	handle = hp_work->handle;
 	type = hp_work->type;
 
-	root = acpi_pci_find_root(handle);
+	acpi_scan_lock_acquire();
 
+	root = acpi_pci_find_root(handle);
 	acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
 
 	switch (type) {
@@ -711,6 +715,7 @@ static void _handle_hotplug_event_root(s
 		break;
 	}
 
+	acpi_scan_lock_release();
 	kfree(hp_work); /* allocated in handle_hotplug_event_bridge */
 	kfree(buffer.pointer);
 }
