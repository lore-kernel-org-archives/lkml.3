Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab3A1Mzy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 07:55:54 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:57763 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751773Ab3A1Mzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 07:55:47 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Yinghai Lu <yinghai@kernel.org>, Jiang Liu <liuj97@gmail.com>,
        Toshi Kani <toshi.kani@hp.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] ACPI / PCI: Make PCI IRQ link driver use struct acpi_scan_handler
Date: Mon, 28 Jan 2013 14:00:41 +0100
Message-ID: <8349556.8rsLRecQbM@vostro.rjw.lan>
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

Make the ACPI PCI IRQ link driver use struct acpi_scan_handler
for representing the object used to set up ACPI interrupt links and
to remove data structures used for this purpose before unregistering
the corresponding ACPI device nodes.

This simplifies the code slightly and reduces the kernel's memory
footprint by avoiding the registration of a struct device_driver
object with the driver core and creation of its sysfs directory
which is unnecessary.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/internal.h |    1 +
 drivers/acpi/pci_link.c |   47 ++++++++++++++---------------------------------
 drivers/acpi/scan.c     |    1 +
 3 files changed, 16 insertions(+), 33 deletions(-)

Index: test/drivers/acpi/pci_link.c
===================================================================
--- test.orig/drivers/acpi/pci_link.c
+++ test/drivers/acpi/pci_link.c
@@ -53,23 +53,19 @@ ACPI_MODULE_NAME("pci_link");
 #define ACPI_PCI_LINK_FILE_STATUS	"state"
 #define ACPI_PCI_LINK_MAX_POSSIBLE	16
 
-static int acpi_pci_link_add(struct acpi_device *device);
-static int acpi_pci_link_remove(struct acpi_device *device);
+static int acpi_pci_link_add(struct acpi_device *device,
+			     const struct acpi_device_id *not_used);
+static void acpi_pci_link_remove(struct acpi_device *device);
 
 static const struct acpi_device_id link_device_ids[] = {
 	{"PNP0C0F", 0},
 	{"", 0},
 };
-MODULE_DEVICE_TABLE(acpi, link_device_ids);
 
-static struct acpi_driver acpi_pci_link_driver = {
-	.name = "pci_link",
-	.class = ACPI_PCI_LINK_CLASS,
+static struct acpi_scan_handler pci_link_handler = {
 	.ids = link_device_ids,
-	.ops = {
-		.add = acpi_pci_link_add,
-		.remove = acpi_pci_link_remove,
-	},
+	.attach = acpi_pci_link_add,
+	.detach = acpi_pci_link_remove,
 };
 
 /*
@@ -692,7 +688,8 @@ int acpi_pci_link_free_irq(acpi_handle h
                                  Driver Interface
    -------------------------------------------------------------------------- */
 
-static int acpi_pci_link_add(struct acpi_device *device)
+static int acpi_pci_link_add(struct acpi_device *device,
+			     const struct acpi_device_id *not_used)
 {
 	int result;
 	struct acpi_pci_link *link;
@@ -746,7 +743,7 @@ static int acpi_pci_link_add(struct acpi
 	if (result)
 		kfree(link);
 
-	return result;
+	return result < 0 ? result : 1;
 }
 
 static int acpi_pci_link_resume(struct acpi_pci_link *link)
@@ -766,7 +763,7 @@ static void irqrouter_resume(void)
 	}
 }
 
-static int acpi_pci_link_remove(struct acpi_device *device)
+static void acpi_pci_link_remove(struct acpi_device *device)
 {
 	struct acpi_pci_link *link;
 
@@ -777,7 +774,6 @@ static int acpi_pci_link_remove(struct a
 	mutex_unlock(&acpi_link_lock);
 
 	kfree(link);
-	return 0;
 }
 
 /*
@@ -874,20 +870,10 @@ static struct syscore_ops irqrouter_sysc
 	.resume = irqrouter_resume,
 };
 
-static int __init irqrouter_init_ops(void)
-{
-	if (!acpi_disabled && !acpi_noirq)
-		register_syscore_ops(&irqrouter_syscore_ops);
-
-	return 0;
-}
-
-device_initcall(irqrouter_init_ops);
-
-static int __init acpi_pci_link_init(void)
+void __init acpi_pci_link_init(void)
 {
 	if (acpi_noirq)
-		return 0;
+		return;
 
 	if (acpi_irq_balance == -1) {
 		/* no command line switch: enable balancing in IOAPIC mode */
@@ -896,11 +882,6 @@ static int __init acpi_pci_link_init(voi
 		else
 			acpi_irq_balance = 0;
 	}
-
-	if (acpi_bus_register_driver(&acpi_pci_link_driver) < 0)
-		return -ENODEV;
-
-	return 0;
+	register_syscore_ops(&irqrouter_syscore_ops);
+	acpi_scan_add_handler(&pci_link_handler);
 }
-
-subsys_initcall(acpi_pci_link_init);
Index: test/drivers/acpi/internal.h
===================================================================
--- test.orig/drivers/acpi/internal.h
+++ test/drivers/acpi/internal.h
@@ -26,6 +26,7 @@
 int init_acpi_device_notify(void);
 int acpi_scan_init(void);
 void acpi_pci_root_init(void);
+void acpi_pci_link_init(void);
 int acpi_sysfs_init(void);
 void acpi_csrt_init(void);
 
Index: test/drivers/acpi/scan.c
===================================================================
--- test.orig/drivers/acpi/scan.c
+++ test/drivers/acpi/scan.c
@@ -1774,6 +1774,7 @@ int __init acpi_scan_init(void)
 	}
 
 	acpi_pci_root_init();
+	acpi_pci_link_init();
 	acpi_csrt_init();
 
 	/*

