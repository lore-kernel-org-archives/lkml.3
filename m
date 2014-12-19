Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbaLSOUK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 09:20:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46442 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbaLSOUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 09:20:07 -0500
Date: Fri, 19 Dec 2014 06:02:10 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-5db66334a7e83cda70fb6193dcaa2590da3a1b7d@git.kernel.org>
Cc: rdunlap@infradead.org, joro@8bytes.org, bhelgaas@google.com,
        tony.luck@intel.com, yinghai@kernel.org, gregkh@linuxfoundation.org,
        rjw@rjwysocki.net, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org, konrad.wilk@oracle.com, bp@alien8.de,
        jiang.liu@linux.intel.com, tglx@linutronix.de, mingo@kernel.org,
        hpa@zytor.com
Reply-To: joro@8bytes.org, rdunlap@infradead.org, bhelgaas@google.com,
        yinghai@kernel.org, gregkh@linuxfoundation.org, tony.luck@intel.com,
        rjw@rjwysocki.net, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org, konrad.wilk@oracle.com, hpa@zytor.com,
        bp@alien8.de, mingo@kernel.org, tglx@linutronix.de,
        jiang.liu@linux.intel.com
In-Reply-To: <1414387308-27148-9-git-send-email-jiang.liu@linux.intel.com>
References: <1414387308-27148-9-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] PCI: Remove PCI ioapic driver
Git-Commit-ID: 5db66334a7e83cda70fb6193dcaa2590da3a1b7d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5db66334a7e83cda70fb6193dcaa2590da3a1b7d
Gitweb:     http://git.kernel.org/tip/5db66334a7e83cda70fb6193dcaa2590da3a1b7d
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 27 Oct 2014 13:21:38 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 16 Dec 2014 14:08:14 +0100

PCI: Remove PCI ioapic driver

To support IOAPIC hotplug on x86 and IA64 platforms, OS needs to figure
out global interrupt source number(GSI) and IOAPIC enumeration ID
through ACPI interfaces. So BIOS must implement an ACPI IOAPIC device
with _GSB/_UID or _MAT method to support IOAPIC hotplug. OS also needs
to figure out base physical address to access IOAPIC registers. OS may
get the base physical address through PCI BARs if IOAPIC device is
visible in PCI domain, otherwise OS may get the address by ACPI _CRS
method if IOAPIC device is hidden from PCI domain by BIOS.

When adding a PCI subtree, we need to add IOAPIC devices before enabling
all other PCI devices because other PCI devices may use the IOAPIC to
allocate PCI interrupts.

So we plan to reimplement IOAPIC driver as an ACPI instead of PCI driver
due to:
1) hot-pluggable IOAPIC devices are always visible in ACPI domain,
   but may or may not be visible in PCI domain.
2) we could explicitly control the order between IOAPIC and other PCI
   devices.

We also have another choice to use a PCI driver to manage IOAPIC device
if it's visible in PCI domain and use an ACPI driver if it's only
visible in ACPI domain. But this solution is a little complex.

It shouldn't cause serious backward compatibility issues because:
1) IOAPIC hotplug is never supported on x86 yet because it hasn't
   implemented the required acpi_register_ioapic() and
   acpi_unregister_ioapic().
2) Currently only ACPI based IOAPIC hotplug is possible on x86 and
   IA64, we don't know other specifications and interfaces to support
   IOAPIC hotplug yet.
3) We will reimplement an ACPI IOAPIC driver to support IOAPIC hotplug.

This change also helps to get rid of the false alarm on all current
Linux distributions:
[    6.952497] ioapic: probe of 0000:00:05.4 failed with error -22
[    6.959542] ioapic: probe of 0000:80:05.4 failed with error -22

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Link: http://lkml.kernel.org/r/1414387308-27148-9-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 drivers/pci/Kconfig  |   7 ---
 drivers/pci/Makefile |   2 -
 drivers/pci/ioapic.c | 121 ---------------------------------------------------
 3 files changed, 130 deletions(-)

diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index cced842..91a64d3 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -110,13 +110,6 @@ config PCI_PASID
 
 	  If unsure, say N.
 
-config PCI_IOAPIC
-	bool "PCI IO-APIC hotplug support" if X86
-	depends on PCI
-	depends on ACPI
-	depends on X86_IO_APIC
-	default !X86
-
 config PCI_LABEL
 	def_bool y if (DMI || ACPI)
 	select NLS
diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
index e04fe2d..73e4af4 100644
--- a/drivers/pci/Makefile
+++ b/drivers/pci/Makefile
@@ -13,8 +13,6 @@ obj-$(CONFIG_PCI_QUIRKS) += quirks.o
 # Build PCI Express stuff if needed
 obj-$(CONFIG_PCIEPORTBUS) += pcie/
 
-obj-$(CONFIG_PCI_IOAPIC) += ioapic.o
-
 # Build the PCI Hotplug drivers if we were asked to
 obj-$(CONFIG_HOTPLUG_PCI) += hotplug/
 ifdef CONFIG_HOTPLUG_PCI
diff --git a/drivers/pci/ioapic.c b/drivers/pci/ioapic.c
deleted file mode 100644
index f6219d3..0000000
--- a/drivers/pci/ioapic.c
+++ /dev/null
@@ -1,121 +0,0 @@
-/*
- * IOAPIC/IOxAPIC/IOSAPIC driver
- *
- * Copyright (C) 2009 Fujitsu Limited.
- * (c) Copyright 2009 Hewlett-Packard Development Company, L.P.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-/*
- * This driver manages PCI I/O APICs added by hotplug after boot.  We try to
- * claim all I/O APIC PCI devices, but those present at boot were registered
- * when we parsed the ACPI MADT, so we'll fail when we try to re-register
- * them.
- */
-
-#include <linux/pci.h>
-#include <linux/module.h>
-#include <linux/acpi.h>
-#include <linux/slab.h>
-
-struct ioapic {
-	acpi_handle	handle;
-	u32		gsi_base;
-};
-
-static int ioapic_probe(struct pci_dev *dev, const struct pci_device_id *ent)
-{
-	acpi_handle handle;
-	acpi_status status;
-	unsigned long long gsb;
-	struct ioapic *ioapic;
-	int ret;
-	char *type;
-	struct resource *res;
-
-	handle = ACPI_HANDLE(&dev->dev);
-	if (!handle)
-		return -EINVAL;
-
-	status = acpi_evaluate_integer(handle, "_GSB", NULL, &gsb);
-	if (ACPI_FAILURE(status))
-		return -EINVAL;
-
-	/*
-	 * The previous code in acpiphp evaluated _MAT if _GSB failed, but
-	 * ACPI spec 4.0 sec 6.2.2 requires _GSB for hot-pluggable I/O APICs.
-	 */
-
-	ioapic = kzalloc(sizeof(*ioapic), GFP_KERNEL);
-	if (!ioapic)
-		return -ENOMEM;
-
-	ioapic->handle = handle;
-	ioapic->gsi_base = (u32) gsb;
-
-	if (dev->class == PCI_CLASS_SYSTEM_PIC_IOAPIC)
-		type = "IOAPIC";
-	else
-		type = "IOxAPIC";
-
-	ret = pci_enable_device(dev);
-	if (ret < 0)
-		goto exit_free;
-
-	pci_set_master(dev);
-
-	if (pci_request_region(dev, 0, type))
-		goto exit_disable;
-
-	res = &dev->resource[0];
-	if (acpi_register_ioapic(ioapic->handle, res->start, ioapic->gsi_base))
-		goto exit_release;
-
-	pci_set_drvdata(dev, ioapic);
-	dev_info(&dev->dev, "%s at %pR, GSI %u\n", type, res, ioapic->gsi_base);
-	return 0;
-
-exit_release:
-	pci_release_region(dev, 0);
-exit_disable:
-	pci_disable_device(dev);
-exit_free:
-	kfree(ioapic);
-	return -ENODEV;
-}
-
-static void ioapic_remove(struct pci_dev *dev)
-{
-	struct ioapic *ioapic = pci_get_drvdata(dev);
-
-	acpi_unregister_ioapic(ioapic->handle, ioapic->gsi_base);
-	pci_release_region(dev, 0);
-	pci_disable_device(dev);
-	kfree(ioapic);
-}
-
-
-static const struct pci_device_id ioapic_devices[] = {
-	{ PCI_DEVICE_CLASS(PCI_CLASS_SYSTEM_PIC_IOAPIC, ~0) },
-	{ PCI_DEVICE_CLASS(PCI_CLASS_SYSTEM_PIC_IOXAPIC, ~0) },
-	{ }
-};
-MODULE_DEVICE_TABLE(pci, ioapic_devices);
-
-static struct pci_driver ioapic_driver = {
-	.name		= "ioapic",
-	.id_table	= ioapic_devices,
-	.probe		= ioapic_probe,
-	.remove		= ioapic_remove,
-};
-
-static int __init ioapic_init(void)
-{
-	return pci_register_driver(&ioapic_driver);
-}
-module_init(ioapic_init);
-
-MODULE_LICENSE("GPL");
