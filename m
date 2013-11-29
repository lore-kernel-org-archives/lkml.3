Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134Ab3K2A1a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 19:27:30 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:58154 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752404Ab3K2A0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 19:26:47 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Linux PCI <linux-pci@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Aaron Lu <aaron.lu@intel.com>, Toshi Kani <toshi.kani@hp.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-ide@vger.kernel.org,
        linux-usb@vger.kernel.org, Lan Tianyu <tianyu.lan@intel.com>
Subject: [PATCH 1/3] ACPI / bind: Rework struct acpi_bus_type
Date: Fri, 29 Nov 2013 01:37:40 +0100
Message-ID: <2273591.1tQV675JFy@vostro.rjw.lan>
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

Replace the .find_device function pointer in struct acpi_bus_type
with a new one, .find_copmanion, that is supposed to point to a
function returning struct acpi_device pointer (instead of an int)
and takes one argument (instead of two).  This way the role of
this callback is more clear and the implementation of it can
be more straightforward.

Update all of the users of struct acpi_bus_type (PCI, PNP/ACPI and
USB) to reflect the structure change.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/glue.c         |   12 +++++++-----
 drivers/pci/pci-acpi.c      |   12 +++---------
 drivers/pnp/pnpacpi/core.c  |   19 +++++--------------
 drivers/usb/core/usb-acpi.c |   40 ++++++++++++++++++++--------------------
 include/acpi/acpi_bus.h     |    2 +-
 5 files changed, 36 insertions(+), 49 deletions(-)

Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -414,7 +414,7 @@ struct acpi_bus_type {
 	struct list_head list;
 	const char *name;
 	bool (*match)(struct device *dev);
-	int (*find_device) (struct device *, acpi_handle *);
+	struct acpi_device * (*find_companion)(struct device *);
 	void (*setup)(struct device *);
 	void (*cleanup)(struct device *);
 };
Index: linux-pm/drivers/acpi/glue.c
===================================================================
--- linux-pm.orig/drivers/acpi/glue.c
+++ linux-pm/drivers/acpi/glue.c
@@ -37,7 +37,7 @@ int register_acpi_bus_type(struct acpi_b
 {
 	if (acpi_disabled)
 		return -ENODEV;
-	if (type && type->match && type->find_device) {
+	if (type && type->match && type->find_companion) {
 		down_write(&bus_type_sem);
 		list_add_tail(&type->list, &bus_type_list);
 		up_write(&bus_type_sem);
@@ -302,17 +302,19 @@ EXPORT_SYMBOL_GPL(acpi_unbind_one);
 static int acpi_platform_notify(struct device *dev)
 {
 	struct acpi_bus_type *type = acpi_get_bus_type(dev);
-	acpi_handle handle;
 	int ret;
 
 	ret = acpi_bind_one(dev, NULL);
 	if (ret && type) {
-		ret = type->find_device(dev, &handle);
-		if (ret) {
+		struct acpi_device *adev;
+
+		adev = type->find_companion(dev);
+		if (!adev) {
 			DBG("Unable to get handle for %s\n", dev_name(dev));
+			ret = -ENODEV;
 			goto out;
 		}
-		ret = acpi_bind_one(dev, handle);
+		ret = acpi_bind_one(dev, adev->handle);
 		if (ret)
 			goto out;
 	}
Index: linux-pm/drivers/pci/pci-acpi.c
===================================================================
--- linux-pm.orig/drivers/pci/pci-acpi.c
+++ linux-pm/drivers/pci/pci-acpi.c
@@ -306,10 +306,9 @@ void acpi_pci_remove_bus(struct pci_bus
 }
 
 /* ACPI bus type */
-static int acpi_pci_find_device(struct device *dev, acpi_handle *handle)
+static struct acpi_device *acpi_pci_find_companion(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
-	struct acpi_device *adev;
 	bool check_children;
 	u64 addr;
 
@@ -322,13 +321,8 @@ static int acpi_pci_find_device(struct d
 			|| pci_dev->hdr_type == PCI_HEADER_TYPE_CARDBUS;
 	/* Please ref to ACPI spec for the syntax of _ADR */
 	addr = (PCI_SLOT(pci_dev->devfn) << 16) | PCI_FUNC(pci_dev->devfn);
-	adev = acpi_find_child_device(ACPI_COMPANION(dev->parent), addr,
+	return acpi_find_child_device(ACPI_COMPANION(dev->parent), addr,
 				      check_children);
-	if (adev) {
-		*handle = adev->handle;
-		return 0;
-	}
-	return -ENODEV;
 }
 
 static void pci_acpi_setup(struct device *dev)
@@ -368,7 +362,7 @@ static bool pci_acpi_bus_match(struct de
 static struct acpi_bus_type acpi_pci_bus = {
 	.name = "PCI",
 	.match = pci_acpi_bus_match,
-	.find_device = acpi_pci_find_device,
+	.find_companion = acpi_pci_find_companion,
 	.setup = pci_acpi_setup,
 	.cleanup = pci_acpi_cleanup,
 };
Index: linux-pm/drivers/pnp/pnpacpi/core.c
===================================================================
--- linux-pm.orig/drivers/pnp/pnpacpi/core.c
+++ linux-pm/drivers/pnp/pnpacpi/core.c
@@ -329,20 +329,11 @@ static int __init acpi_pnp_match(struct
 	    && compare_pnp_id(pnp->id, acpi_device_hid(acpi));
 }
 
-static int __init acpi_pnp_find_device(struct device *dev, acpi_handle * handle)
+static struct acpi_device * __init acpi_pnp_find_companion(struct device *dev)
 {
-	struct device *adev;
-	struct acpi_device *acpi;
-
-	adev = bus_find_device(&acpi_bus_type, NULL,
-			       to_pnp_dev(dev), acpi_pnp_match);
-	if (!adev)
-		return -ENODEV;
-
-	acpi = to_acpi_device(adev);
-	*handle = acpi->handle;
-	put_device(adev);
-	return 0;
+	dev = bus_find_device(&acpi_bus_type, NULL, to_pnp_dev(dev),
+			      acpi_pnp_match);
+	return dev ? to_acpi_device(dev) : NULL;
 }
 
 /* complete initialization of a PNPACPI device includes having
@@ -356,7 +347,7 @@ static bool acpi_pnp_bus_match(struct de
 static struct acpi_bus_type __initdata acpi_pnp_bus = {
 	.name	     = "PNP",
 	.match	     = acpi_pnp_bus_match,
-	.find_device = acpi_pnp_find_device,
+	.find_companion = acpi_pnp_find_companion,
 };
 
 int pnpacpi_disabled __initdata;
Index: linux-pm/drivers/usb/core/usb-acpi.c
===================================================================
--- linux-pm.orig/drivers/usb/core/usb-acpi.c
+++ linux-pm/drivers/usb/core/usb-acpi.c
@@ -127,7 +127,7 @@ out:
 	return ret;
 }
 
-static int usb_acpi_find_device(struct device *dev, acpi_handle *handle)
+static struct acpi_device *usb_acpi_find_companion(struct device *dev)
 {
 	struct usb_device *udev;
 	acpi_handle *parent_handle;
@@ -169,16 +169,15 @@ static int usb_acpi_find_device(struct d
 				break;
 			}
 
-			return -ENODEV;
+			return NULL;
 		}
 
 		/* root hub's parent is the usb hcd. */
-		parent_handle = ACPI_HANDLE(dev->parent);
-		*handle = acpi_get_child(parent_handle, udev->portnum);
-		if (!*handle)
-			return -ENODEV;
-		return 0;
+		return acpi_find_child_device(ACPI_COMPANION(dev->parent),
+					      udev->portnum, false);
 	} else if (is_usb_port(dev)) {
+		struct acpi_device *adev = NULL;
+
 		sscanf(dev_name(dev), "port%d", &port_num);
 		/* Get the struct usb_device point of port's hub */
 		udev = to_usb_device(dev->parent->parent);
@@ -194,26 +193,27 @@ static int usb_acpi_find_device(struct d
 
 			raw_port_num = usb_hcd_find_raw_port_number(hcd,
 				port_num);
-			*handle = acpi_get_child(ACPI_HANDLE(&udev->dev),
-				raw_port_num);
-			if (!*handle)
-				return -ENODEV;
+			adev = acpi_find_child_device(ACPI_COMPANION(&udev->dev),
+						      raw_port_num, false);
+			if (!adev)
+				return NULL;
 		} else {
 			parent_handle =
 				usb_get_hub_port_acpi_handle(udev->parent,
 				udev->portnum);
 			if (!parent_handle)
-				return -ENODEV;
+				return NULL;
 
-			*handle = acpi_get_child(parent_handle,	port_num);
-			if (!*handle)
-				return -ENODEV;
+			acpi_bus_get_device(parent_handle, &adev);
+			adev = acpi_find_child_device(adev, port_num, false);
+			if (!adev)
+				return NULL;
 		}
-		usb_acpi_check_port_connect_type(udev, *handle, port_num);
-	} else
-		return -ENODEV;
+		usb_acpi_check_port_connect_type(udev, adev->handle, port_num);
+		return adev;
+	}
 
-	return 0;
+	return NULL;
 }
 
 static bool usb_acpi_bus_match(struct device *dev)
@@ -224,7 +224,7 @@ static bool usb_acpi_bus_match(struct de
 static struct acpi_bus_type usb_acpi_bus = {
 	.name = "USB",
 	.match = usb_acpi_bus_match,
-	.find_device = usb_acpi_find_device,
+	.find_companion = usb_acpi_find_companion,
 };
 
 int usb_acpi_register(void)

