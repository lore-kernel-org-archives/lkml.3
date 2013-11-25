Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212Ab3KYABs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 19:01:48 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:50927 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751884Ab3KYABo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 19:01:44 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH 4/4] ACPI / bind: Redefine acpi_preset_companion()
Date: Mon, 25 Nov 2013 01:14:25 +0100
Message-ID: <34649673.I4bbAeHm4N@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <2610478.KxPMyuOMok@vostro.rjw.lan>
References: <2610478.KxPMyuOMok@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Modify acpi_preset_companion() to take a struct acpi_device pointer
instead of an ACPI handle as its second argument and redefine it as
a static inline wrapper around ACPI_COMPANION_SET() passing the
return value of acpi_find_child_device() directly as the second
argument to it.  Update its users to pass struct acpi_device
pointers instead of ACPI handles to it.

This allows some unnecessary acpi_bus_get_device() calls to be
avoided.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/glue.c         |   10 +---------
 drivers/ata/libata-acpi.c   |   26 +++++++++++++-------------
 drivers/mmc/core/sdio_bus.c |    2 +-
 include/acpi/acpi_bus.h     |    1 -
 include/linux/acpi.h        |    6 ++++++
 5 files changed, 21 insertions(+), 24 deletions(-)

Index: linux-pm/drivers/ata/libata-acpi.c
===================================================================
--- linux-pm.orig/drivers/ata/libata-acpi.c
+++ linux-pm/drivers/ata/libata-acpi.c
@@ -180,12 +180,12 @@ static const struct acpi_dock_ops ata_ac
 /* bind acpi handle to pata port */
 void ata_acpi_bind_port(struct ata_port *ap)
 {
-	acpi_handle host_handle = ACPI_HANDLE(ap->host->dev);
+	struct acpi_device *host_companion = ACPI_COMPANION(ap->host->dev);
 
-	if (libata_noacpi || ap->flags & ATA_FLAG_ACPI_SATA || !host_handle)
+	if (libata_noacpi || ap->flags & ATA_FLAG_ACPI_SATA || !host_companion)
 		return;
 
-	acpi_preset_companion(&ap->tdev, host_handle, ap->port_no);
+	acpi_preset_companion(&ap->tdev, host_companion, ap->port_no);
 
 	if (ata_acpi_gtm(ap, &ap->__acpi_init_gtm) == 0)
 		ap->pflags |= ATA_PFLAG_INIT_GTM_VALID;
@@ -198,17 +198,17 @@ void ata_acpi_bind_port(struct ata_port
 void ata_acpi_bind_dev(struct ata_device *dev)
 {
 	struct ata_port *ap = dev->link->ap;
-	acpi_handle port_handle = ACPI_HANDLE(&ap->tdev);
-	acpi_handle host_handle = ACPI_HANDLE(ap->host->dev);
-	acpi_handle parent_handle;
+	struct acpi_device *port_companion = ACPI_COMPANION(&ap->tdev);
+	struct acpi_device *host_companion = ACPI_COMPANION(ap->host->dev);
+	struct acpi_device *parent;
 	u64 adr;
 
 	/*
-	 * For both sata/pata devices, host handle is required.
-	 * For pata device, port handle is also required.
+	 * For both sata/pata devices, host companion device is required.
+	 * For pata device, port companion device is also required.
 	 */
-	if (libata_noacpi || !host_handle ||
-			(!(ap->flags & ATA_FLAG_ACPI_SATA) && !port_handle))
+	if (libata_noacpi || !host_companion ||
+			(!(ap->flags & ATA_FLAG_ACPI_SATA) && !port_companion))
 		return;
 
 	if (ap->flags & ATA_FLAG_ACPI_SATA) {
@@ -216,13 +216,13 @@ void ata_acpi_bind_dev(struct ata_device
 			adr = SATA_ADR(ap->port_no, NO_PORT_MULT);
 		else
 			adr = SATA_ADR(ap->port_no, dev->link->pmp);
-		parent_handle = host_handle;
+		parent = host_companion;
 	} else {
 		adr = dev->devno;
-		parent_handle = port_handle;
+		parent = port_companion;
 	}
 
-	acpi_preset_companion(&dev->tdev, parent_handle, adr);
+	acpi_preset_companion(&dev->tdev, parent, adr);
 
 	register_hotplug_dock_device(ata_dev_acpi_handle(dev),
 				     &ata_acpi_dev_dock_ops, dev, NULL, NULL);
Index: linux-pm/drivers/mmc/core/sdio_bus.c
===================================================================
--- linux-pm.orig/drivers/mmc/core/sdio_bus.c
+++ linux-pm/drivers/mmc/core/sdio_bus.c
@@ -308,7 +308,7 @@ static void sdio_acpi_set_handle(struct
 	struct mmc_host *host = func->card->host;
 	u64 addr = (host->slotno << 16) | func->num;
 
-	acpi_preset_companion(&func->dev, ACPI_HANDLE(host->parent), addr);
+	acpi_preset_companion(&func->dev, ACPI_COMPANION(host->parent), addr);
 }
 #else
 static inline void sdio_acpi_set_handle(struct sdio_func *func) {}
Index: linux-pm/drivers/acpi/glue.c
===================================================================
--- linux-pm.orig/drivers/acpi/glue.c
+++ linux-pm/drivers/acpi/glue.c
@@ -146,6 +146,7 @@ struct acpi_device *acpi_find_child_devi
 	}
 	return ret;
 }
+EXPORT_SYMBOL_GPL(acpi_find_child_device);
 
 acpi_handle acpi_get_child(acpi_handle handle, u64 addr)
 {
@@ -294,15 +295,6 @@ int acpi_unbind_one(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(acpi_unbind_one);
 
-void acpi_preset_companion(struct device *dev, acpi_handle parent, u64 addr)
-{
-	struct acpi_device *adev;
-
-	if (!acpi_bus_get_device(acpi_get_child(parent, addr), &adev))
-		ACPI_COMPANION_SET(dev, adev);
-}
-EXPORT_SYMBOL_GPL(acpi_preset_companion);
-
 static int acpi_platform_notify(struct device *dev)
 {
 	struct acpi_bus_type *type = acpi_get_bus_type(dev);
Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -437,7 +437,6 @@ struct acpi_pci_root {
 struct acpi_device *acpi_find_child_device(struct acpi_device *parent,
 					   u64 address, bool check_children);
 acpi_handle acpi_get_child(acpi_handle handle, u64 addr);
-void acpi_preset_companion(struct device *dev, acpi_handle parent, u64 addr);
 int acpi_is_root_bridge(acpi_handle);
 struct acpi_pci_root *acpi_pci_find_root(acpi_handle handle);
 
Index: linux-pm/include/linux/acpi.h
===================================================================
--- linux-pm.orig/include/linux/acpi.h
+++ linux-pm/include/linux/acpi.h
@@ -53,6 +53,12 @@ static inline acpi_handle acpi_device_ha
 #define ACPI_COMPANION_SET(dev, adev)	ACPI_COMPANION(dev) = (adev)
 #define ACPI_HANDLE(dev)		acpi_device_handle(ACPI_COMPANION(dev))
 
+static inline void acpi_preset_companion(struct device *dev,
+					 struct acpi_device *parent, u64 addr)
+{
+	ACPI_COMPANION_SET(dev, acpi_find_child_device(parent, addr, NULL));
+}
+
 static inline const char *acpi_dev_name(struct acpi_device *adev)
 {
 	return dev_name(&adev->dev);

