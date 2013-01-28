Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728Ab3A1M4s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 07:56:48 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:57771 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754091Ab3A1Mzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 07:55:48 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Yinghai Lu <yinghai@kernel.org>, Jiang Liu <liuj97@gmail.com>,
        Toshi Kani <toshi.kani@hp.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] ACPI / PCI: Make PCI root driver use struct acpi_scan_handler
Date: Mon, 28 Jan 2013 14:00:07 +0100
Message-ID: <1997208.3XsulxNKty@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc5; KDE/4.9.5; x86_64; ; )
In-Reply-To: <4311642.nDd2RCVeDc@vostro.rjw.lan>
References: <1873429.MS5RQDxTye@vostro.rjw.lan> <4311642.nDd2RCVeDc@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Make the ACPI PCI root bridge driver use struct acpi_scan_handler
for representing the object used to enumerate the PCI busses under
PCI host bridges found in the ACPI namespace (and to tear down data
structures representing the bus and devices on it before
unregistering the host bridges' ACPI device nodes).

This simplifies the code slightly and reduces the kernel's memory
footprint by avoiding the registration of a struct device_driver
object with the driver core and creation of its sysfs directory
which is unnecessary.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/internal.h |    2 +-
 drivers/acpi/pci_root.c |   38 +++++++++++++++-----------------------
 2 files changed, 16 insertions(+), 24 deletions(-)

Index: test/drivers/acpi/pci_root.c
===================================================================
--- test.orig/drivers/acpi/pci_root.c
+++ test/drivers/acpi/pci_root.c
@@ -45,8 +45,9 @@
 ACPI_MODULE_NAME("pci_root");
 #define ACPI_PCI_ROOT_CLASS		"pci_bridge"
 #define ACPI_PCI_ROOT_DEVICE_NAME	"PCI Root Bridge"
-static int acpi_pci_root_add(struct acpi_device *device);
-static int acpi_pci_root_remove(struct acpi_device *device);
+static int acpi_pci_root_add(struct acpi_device *device,
+			     const struct acpi_device_id *not_used);
+static void acpi_pci_root_remove(struct acpi_device *device);
 
 #define ACPI_PCIE_REQ_SUPPORT (OSC_EXT_PCI_CONFIG_SUPPORT \
 				| OSC_ACTIVE_STATE_PWR_SUPPORT \
@@ -57,16 +58,11 @@ static const struct acpi_device_id root_
 	{"PNP0A03", 0},
 	{"", 0},
 };
-MODULE_DEVICE_TABLE(acpi, root_device_ids);
 
-static struct acpi_driver acpi_pci_root_driver = {
-	.name = "pci_root",
-	.class = ACPI_PCI_ROOT_CLASS,
+static struct acpi_scan_handler pci_root_handler = {
 	.ids = root_device_ids,
-	.ops = {
-		.add = acpi_pci_root_add,
-		.remove = acpi_pci_root_remove,
-		},
+	.attach = acpi_pci_root_add,
+	.detach = acpi_pci_root_remove,
 };
 
 /* Lock to protect both acpi_pci_roots and acpi_pci_drivers lists */
@@ -428,7 +424,8 @@ out:
 }
 EXPORT_SYMBOL(acpi_pci_osc_control_set);
 
-static int acpi_pci_root_add(struct acpi_device *device)
+static int acpi_pci_root_add(struct acpi_device *device,
+			     const struct acpi_device_id *not_used)
 {
 	unsigned long long segment, bus;
 	acpi_status status;
@@ -614,7 +611,7 @@ static int acpi_pci_root_add(struct acpi
 		pci_enable_bridges(root->bus);
 
 	pci_bus_add_devices(root->bus);
-	return 0;
+	return 1;
 
 out_del_root:
 	mutex_lock(&acpi_pci_root_lock);
@@ -627,7 +624,7 @@ end:
 	return result;
 }
 
-static int acpi_pci_root_remove(struct acpi_device *device)
+static void acpi_pci_root_remove(struct acpi_device *device)
 {
 	acpi_status status;
 	acpi_handle handle;
@@ -655,19 +652,14 @@ static int acpi_pci_root_remove(struct a
 	list_del(&root->node);
 	mutex_unlock(&acpi_pci_root_lock);
 	kfree(root);
-	return 0;
 }
 
-int __init acpi_pci_root_init(void)
+void __init acpi_pci_root_init(void)
 {
 	acpi_hest_init();
 
-	if (acpi_pci_disabled)
-		return 0;
-
-	pci_acpi_crs_quirks();
-	if (acpi_bus_register_driver(&acpi_pci_root_driver) < 0)
-		return -ENODEV;
-
-	return 0;
+	if (!acpi_pci_disabled) {
+		pci_acpi_crs_quirks();
+		acpi_scan_add_handler(&pci_root_handler);
+	}
 }
Index: test/drivers/acpi/internal.h
===================================================================
--- test.orig/drivers/acpi/internal.h
+++ test/drivers/acpi/internal.h
@@ -25,6 +25,7 @@
 
 int init_acpi_device_notify(void);
 int acpi_scan_init(void);
+void acpi_pci_root_init(void);
 int acpi_sysfs_init(void);
 void acpi_csrt_init(void);
 
@@ -86,7 +87,6 @@ struct acpi_ec {
 
 extern struct acpi_ec *first_ec;
 
-int acpi_pci_root_init(void);
 int acpi_ec_init(void);
 int acpi_ec_ecdt_probe(void);
 int acpi_boot_ec_enable(void);

