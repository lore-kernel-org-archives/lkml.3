Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab3K2A0u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 19:26:50 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:62147 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751072Ab3K2A0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 19:26:46 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Linux PCI <linux-pci@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Aaron Lu <aaron.lu@intel.com>, Toshi Kani <toshi.kani@hp.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-ide@vger.kernel.org,
        linux-usb@vger.kernel.org, Lan Tianyu <tianyu.lan@intel.com>
Subject: [PATCH 3/3] ACPI / bind: Move acpi_get_child() to drivers/ide/ide-acpi.c
Date: Fri, 29 Nov 2013 01:39:06 +0100
Message-ID: <2277225.7ruX4XHWxe@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <4501334.ovACrGogrl@vostro.rjw.lan>
References: <4501334.ovACrGogrl@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Since drivers/ide/ide-acpi.c is the only remaining user of
acpi_get_child(), move that function into that file as a static
routine.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/glue.c     |   12 ------------
 drivers/ide/ide-acpi.c  |   11 +++++++++++
 include/acpi/acpi_bus.h |    1 -
 3 files changed, 11 insertions(+), 13 deletions(-)

Index: linux-pm/drivers/acpi/glue.c
===================================================================
--- linux-pm.orig/drivers/acpi/glue.c
+++ linux-pm/drivers/acpi/glue.c
@@ -151,18 +151,6 @@ struct acpi_device *acpi_find_child_devi
 }
 EXPORT_SYMBOL_GPL(acpi_find_child_device);
 
-acpi_handle acpi_get_child(acpi_handle handle, u64 addr)
-{
-	struct acpi_device *adev;
-
-	if (!handle || acpi_bus_get_device(handle, &adev))
-		return NULL;
-
-	adev = acpi_find_child_device(adev, addr, false);
-	return adev ? adev->handle : NULL;
-}
-EXPORT_SYMBOL_GPL(acpi_get_child);
-
 static void acpi_physnode_link_name(char *buf, unsigned int node_id)
 {
 	if (node_id > 0)
Index: linux-pm/drivers/ide/ide-acpi.c
===================================================================
--- linux-pm.orig/drivers/ide/ide-acpi.c
+++ linux-pm/drivers/ide/ide-acpi.c
@@ -98,6 +98,17 @@ bool ide_port_acpi(ide_hwif_t *hwif)
 	return ide_noacpi == 0 && hwif->acpidata;
 }
 
+static acpi_handle acpi_get_child(acpi_handle handle, u64 addr)
+{
+	struct acpi_device *adev;
+
+	if (!handle || acpi_bus_get_device(handle, &adev))
+		return NULL;
+
+	adev = acpi_find_child_device(adev, addr, false);
+	return adev ? adev->handle : NULL;
+}
+
 /**
  * ide_get_dev_handle - finds acpi_handle and PCI device.function
  * @dev: device to locate
Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -436,7 +436,6 @@ struct acpi_pci_root {
 
 struct acpi_device *acpi_find_child_device(struct acpi_device *parent,
 					   u64 address, bool check_children);
-acpi_handle acpi_get_child(acpi_handle handle, u64 addr);
 int acpi_is_root_bridge(acpi_handle);
 struct acpi_pci_root *acpi_pci_find_root(acpi_handle handle);
 

