Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781Ab3B0WAI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 17:00:08 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:46832 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973Ab3B0WAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 17:00:06 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-usb@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org,
        Jeff Garzik <jgarzik@pobox.com>, Yinghai Lu <yinghai@kernel.org>
Subject: [Resend][PATCH] ACPI / glue: Drop .find_bridge() callback from struct acpi_bus_type
Date: Wed, 27 Feb 2013 23:06:52 +0100
Message-ID: <2612891.I2roH54cPk@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

After PCI has stopped using the .find_bridge() callback in
struct acpi_bus_type, the only remaining users of it are SATA and
USB.  However, SATA only pretends to be a user, because it points
that callback to a stub always returning -ENODEV, and USB uses it
incorrectly, because as a result of the way it is used by USB every
device in the system that doesn't have a bus type or parent is
passed to usb_acpi_find_device() for inspection.

What USB actually needs, though, is to call usb_acpi_find_device()
for USB ports that don't have a bus type defined, but have
usb_port_device_type as their device type.

To fix that add a device type field to struct acpi_bus_type and
make acpi_get_bus_type() compare it with the device type fields of
the device objects it inspects in addition to checking their bus
types.  Next, make USB set the new type field in usb_acpi_bus to
point to usb_port_device_type and stop abusing the .find_bridge()
callback.

In addition to that drop the SATA's dummy .find_bridge() callback,
and remove .find_bridge(), which is not used any more, from struct
acpi_bus_type entirely.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

I send this as an RFC before the merge window, but since it depends on changes
in both PM and PCI trees, it couldn't be applied before.  Now that they both
have been merged, here it goes again.

Please let me know if there are any objections.

Thanks,
Rafael

---
 drivers/acpi/glue.c         |   39 ++++++---------------------------------
 drivers/ata/libata-acpi.c   |    6 ------
 drivers/usb/core/usb-acpi.c |    2 +-
 include/acpi/acpi_bus.h     |    4 +---
 4 files changed, 8 insertions(+), 43 deletions(-)

Index: linux-pm/drivers/acpi/glue.c
===================================================================
--- linux-pm.orig/drivers/acpi/glue.c
+++ linux-pm/drivers/acpi/glue.c
@@ -64,16 +64,17 @@ int unregister_acpi_bus_type(struct acpi
 }
 EXPORT_SYMBOL_GPL(unregister_acpi_bus_type);
 
-static struct acpi_bus_type *acpi_get_bus_type(struct bus_type *type)
+static struct acpi_bus_type *acpi_get_bus_type(struct device *dev)
 {
 	struct acpi_bus_type *tmp, *ret = NULL;
 
-	if (!type)
+	if (!dev->bus && !dev->type)
 		return NULL;
 
 	down_read(&bus_type_sem);
 	list_for_each_entry(tmp, &bus_type_list, list) {
-		if (tmp->bus == type) {
+		if ((tmp->bus && tmp->bus == dev->bus)
+		    || (tmp->type && tmp->type == dev->type)) {
 			ret = tmp;
 			break;
 		}
@@ -82,22 +83,6 @@ static struct acpi_bus_type *acpi_get_bu
 	return ret;
 }
 
-static int acpi_find_bridge_device(struct device *dev, acpi_handle * handle)
-{
-	struct acpi_bus_type *tmp;
-	int ret = -ENODEV;
-
-	down_read(&bus_type_sem);
-	list_for_each_entry(tmp, &bus_type_list, list) {
-		if (tmp->find_bridge && !tmp->find_bridge(dev, handle)) {
-			ret = 0;
-			break;
-		}
-	}
-	up_read(&bus_type_sem);
-	return ret;
-}
-
 static acpi_status do_acpi_find_child(acpi_handle handle, u32 lvl_not_used,
 				      void *addr_p, void **ret_p)
 {
@@ -261,22 +246,11 @@ err:
 
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
 		if (!type || !type->find_device) {
 			DBG("No ACPI bus support for %s\n", dev_name(dev));
@@ -293,7 +267,6 @@ static int acpi_platform_notify(struct d
 		if (ret)
 			goto out;
 	}
-
 	if (type && type->setup)
 		type->setup(dev);
 
@@ -316,7 +289,7 @@ static int acpi_platform_notify_remove(s
 {
 	struct acpi_bus_type *type;
 
-	type = acpi_get_bus_type(dev->bus);
+	type = acpi_get_bus_type(dev);
 	if (type && type->cleanup)
 		type->cleanup(dev);
 
Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -438,10 +438,8 @@ void acpi_remove_dir(struct acpi_device
 struct acpi_bus_type {
 	struct list_head list;
 	struct bus_type *bus;
-	/* For general devices under the bus */
+	struct device_type *type;
 	int (*find_device) (struct device *, acpi_handle *);
-	/* For bridges, such as PCI root bridge, IDE controller */
-	int (*find_bridge) (struct device *, acpi_handle *);
 	void (*setup)(struct device *);
 	void (*cleanup)(struct device *);
 };
Index: linux-pm/drivers/ata/libata-acpi.c
===================================================================
--- linux-pm.orig/drivers/ata/libata-acpi.c
+++ linux-pm/drivers/ata/libata-acpi.c
@@ -1144,13 +1144,7 @@ static int ata_acpi_find_device(struct d
 		return -ENODEV;
 }
 
-static int ata_acpi_find_dummy(struct device *dev, acpi_handle *handle)
-{
-	return -ENODEV;
-}
-
 static struct acpi_bus_type ata_acpi_bus = {
-	.find_bridge = ata_acpi_find_dummy,
 	.find_device = ata_acpi_find_device,
 };
 
Index: linux-pm/drivers/usb/core/usb-acpi.c
===================================================================
--- linux-pm.orig/drivers/usb/core/usb-acpi.c
+++ linux-pm/drivers/usb/core/usb-acpi.c
@@ -212,7 +212,7 @@ static int usb_acpi_find_device(struct d
 
 static struct acpi_bus_type usb_acpi_bus = {
 	.bus = &usb_bus_type,
-	.find_bridge = usb_acpi_find_device,
+	.type = &usb_port_device_type,
 	.find_device = usb_acpi_find_device,
 };
 

