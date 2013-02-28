Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760697Ab3B1VrV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 16:47:21 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:47927 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754827Ab3B1Vqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 16:46:54 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-usb@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org,
        Jeff Garzik <jgarzik@pobox.com>, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 1/2] ACPI / glue: Add .match() callback to struct acpi_bus_type
Date: Thu, 28 Feb 2013 22:53:21 +0100
Message-ID: <194591401.DiJi7SfL1g@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1504144.f1SBuDyFqp@vostro.rjw.lan>
References: <2612891.I2roH54cPk@vostro.rjw.lan> <20130228023313.GC4042@kroah.com> <1504144.f1SBuDyFqp@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

USB uses the .find_bridge() callback from struct acpi_bus_type
incorrectly, because as a result of the way it is used by USB every
device in the system that doesn't have a bus type or parent is
passed to usb_acpi_find_device() for inspection.

What USB actually needs, though, is to call usb_acpi_find_device()
for USB ports that don't have a bus type defined, but have
usb_port_device_type as their device type, as well as for USB
devices.

To fix that replace the struct bus_type pointer in struct
acpi_bus_type used for matching devices to specific subsystems
with a .match() callback to be used for this purpose and update
the users of struct acpi_bus_type, including USB, accordingly.
Define the .match() callback routine for USB, usb_acpi_bus_match(),
in such a way that it will cover both USB devices and USB ports
and remove the now redundant .find_bridge() callback pointer from
usb_acpi_bus.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/glue.c         |   39 +++++++++++++--------------------------
 drivers/ata/libata-acpi.c   |    1 +
 drivers/pci/pci-acpi.c      |    8 +++++++-
 drivers/pnp/pnpacpi/core.c  |    8 +++++++-
 drivers/scsi/scsi_lib.c     |    7 ++++++-
 drivers/usb/core/usb-acpi.c |    9 +++++++--
 include/acpi/acpi_bus.h     |    3 ++-
 7 files changed, 43 insertions(+), 32 deletions(-)

Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -437,7 +437,8 @@ void acpi_remove_dir(struct acpi_device
  */
 struct acpi_bus_type {
 	struct list_head list;
-	struct bus_type *bus;
+	const char *name;
+	bool (*match)(struct device *dev);
 	/* For general devices under the bus */
 	int (*find_device) (struct device *, acpi_handle *);
 	/* For bridges, such as PCI root bridge, IDE controller */
Index: linux-pm/drivers/acpi/glue.c
===================================================================
--- linux-pm.orig/drivers/acpi/glue.c
+++ linux-pm/drivers/acpi/glue.c
@@ -36,12 +36,11 @@ int register_acpi_bus_type(struct acpi_b
 {
 	if (acpi_disabled)
 		return -ENODEV;
-	if (type && type->bus && type->find_device) {
+	if (type && type->match && type->find_device) {
 		down_write(&bus_type_sem);
 		list_add_tail(&type->list, &bus_type_list);
 		up_write(&bus_type_sem);
-		printk(KERN_INFO PREFIX "bus type %s registered\n",
-		       type->bus->name);
+		printk(KERN_INFO PREFIX "bus type %s registered\n", type->name);
 		return 0;
 	}
 	return -ENODEV;
@@ -56,24 +55,21 @@ int unregister_acpi_bus_type(struct acpi
 		down_write(&bus_type_sem);
 		list_del_init(&type->list);
 		up_write(&bus_type_sem);
-		printk(KERN_INFO PREFIX "ACPI bus type %s unregistered\n",
-		       type->bus->name);
+		printk(KERN_INFO PREFIX "bus type %s unregistered\n",
+		       type->name);
 		return 0;
 	}
 	return -ENODEV;
 }
 EXPORT_SYMBOL_GPL(unregister_acpi_bus_type);
 
-static struct acpi_bus_type *acpi_get_bus_type(struct bus_type *type)
+static struct acpi_bus_type *acpi_get_bus_type(struct device *dev)
 {
 	struct acpi_bus_type *tmp, *ret = NULL;
 
-	if (!type)
-		return NULL;
-
 	down_read(&bus_type_sem);
 	list_for_each_entry(tmp, &bus_type_list, list) {
-		if (tmp->bus == type) {
+		if (tmp->match(dev)) {
 			ret = tmp;
 			break;
 		}
@@ -261,26 +257,17 @@ err:
 
 static int acpi_platform_notify(struct device *dev)
 {
-	struct acpi_bus_type *type;
+	struct acpi_bus_type *type = acpi_get_bus_type(dev);
 	acpi_handle handle;
 	int ret;
 
 	ret = acpi_bind_one(dev, NULL);
-	if (ret && (!dev->bus || !dev->parent)) {
-		/* bridge devices genernally haven't bus or parent */
-		ret = acpi_find_bridge_device(dev, &handle);
-		if (!ret) {
-			ret = acpi_bind_one(dev, handle);
-			if (ret)
-				goto out;
-		}
-	}
-
-	type = acpi_get_bus_type(dev->bus);
 	if (ret) {
-		if (!type || !type->find_device) {
-			DBG("No ACPI bus support for %s\n", dev_name(dev));
-			ret = -EINVAL;
+		if (!type) {
+			ret = acpi_find_bridge_device(dev, &handle);
+			if (!ret)
+				ret = acpi_bind_one(dev, handle);
+
 			goto out;
 		}
 
@@ -316,7 +303,7 @@ static int acpi_platform_notify_remove(s
 {
 	struct acpi_bus_type *type;
 
-	type = acpi_get_bus_type(dev->bus);
+	type = acpi_get_bus_type(dev);
 	if (type && type->cleanup)
 		type->cleanup(dev);
 
Index: linux-pm/drivers/scsi/scsi_lib.c
===================================================================
--- linux-pm.orig/drivers/scsi/scsi_lib.c
+++ linux-pm/drivers/scsi/scsi_lib.c
@@ -71,9 +71,14 @@ struct kmem_cache *scsi_sdb_cache;
 #ifdef CONFIG_ACPI
 #include <acpi/acpi_bus.h>
 
+static bool acpi_scsi_bus_match(struct device *dev)
+{
+	return dev->bus == &scsi_bus_type;
+}
+
 int scsi_register_acpi_bus_type(struct acpi_bus_type *bus)
 {
-        bus->bus = &scsi_bus_type;
+        bus->match = acpi_scsi_bus_match;
         return register_acpi_bus_type(bus);
 }
 EXPORT_SYMBOL_GPL(scsi_register_acpi_bus_type);
Index: linux-pm/drivers/pci/pci-acpi.c
===================================================================
--- linux-pm.orig/drivers/pci/pci-acpi.c
+++ linux-pm/drivers/pci/pci-acpi.c
@@ -331,8 +331,14 @@ static void pci_acpi_cleanup(struct devi
 	}
 }
 
+static bool pci_acpi_bus_match(struct device *dev)
+{
+	return dev->bus == &pci_bus_type;
+}
+
 static struct acpi_bus_type acpi_pci_bus = {
-	.bus = &pci_bus_type,
+	.name = "PCI",
+	.match = pci_acpi_bus_match,
 	.find_device = acpi_pci_find_device,
 	.setup = pci_acpi_setup,
 	.cleanup = pci_acpi_cleanup,
Index: linux-pm/drivers/pnp/pnpacpi/core.c
===================================================================
--- linux-pm.orig/drivers/pnp/pnpacpi/core.c
+++ linux-pm/drivers/pnp/pnpacpi/core.c
@@ -353,8 +353,14 @@ static int __init acpi_pnp_find_device(s
 /* complete initialization of a PNPACPI device includes having
  * pnpdev->dev.archdata.acpi_handle point to its ACPI sibling.
  */
+static bool acpi_pnp_bus_match(struct device *dev)
+{
+	return dev->bus == &pnp_bus_type;
+}
+
 static struct acpi_bus_type __initdata acpi_pnp_bus = {
-	.bus	     = &pnp_bus_type,
+	.name	     = "PNP",
+	.match	     = acpi_pnp_bus_match,
 	.find_device = acpi_pnp_find_device,
 };
 
Index: linux-pm/drivers/usb/core/usb-acpi.c
===================================================================
--- linux-pm.orig/drivers/usb/core/usb-acpi.c
+++ linux-pm/drivers/usb/core/usb-acpi.c
@@ -210,9 +210,14 @@ static int usb_acpi_find_device(struct d
 	return 0;
 }
 
+static bool usb_acpi_bus_match(struct device *dev)
+{
+	return is_usb_device(dev) || is_usb_port(dev);
+}
+
 static struct acpi_bus_type usb_acpi_bus = {
-	.bus = &usb_bus_type,
-	.find_bridge = usb_acpi_find_device,
+	.name = "USB",
+	.match = usb_acpi_bus_match,
 	.find_device = usb_acpi_find_device,
 };
 
Index: linux-pm/drivers/ata/libata-acpi.c
===================================================================
--- linux-pm.orig/drivers/ata/libata-acpi.c
+++ linux-pm/drivers/ata/libata-acpi.c
@@ -1150,6 +1150,7 @@ static int ata_acpi_find_dummy(struct de
 }
 
 static struct acpi_bus_type ata_acpi_bus = {
+	.name = "ATA",
 	.find_bridge = ata_acpi_find_dummy,
 	.find_device = ata_acpi_find_device,
 };
