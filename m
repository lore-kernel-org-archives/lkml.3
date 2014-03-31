Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375AbaCaE2M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 00:28:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36543 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752729AbaCaE2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 00:28:11 -0400
From: Bandan Das <bsd@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] PCI: rework new_id interface for known vendor/device values
Date: Mon, 31 Mar 2014 00:28:07 -0400
Message-ID: <jpgsipz3sbs.fsf@nelium.bos.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


While using the new_id interface, the user can unintentionally feed
incorrect values if the driver static table has a matching entry.
This is possible since only the device and vendor fields are
mandatory and the rest are optional. As a result, store_new_id
will fill in default values that are then passed on to the driver
and can have unintended consequences.

As an example, consider the ixgbe driver and the 82599EB network card :
echo "8086 10fb" > /sys/bus/pci/drivers/ixgbe/new_id

This will pass a driver_data value of 0 to the driver whereas
the index 0 in ixgbe actually points to a different set of card
operations.

This change automatically selects the matching static entry if there
is one for the newly created dynid. However, if the user intentionally
wants a different set of values, she must provide all the 7 fields
and the static entry will be ignored.

In most cases, this use case seems unnecessary, however, this
is a common libvirt/KVM/device assignment scenario where the
user might want to bind a device back to the host driver.

Signed-off-by: Bandan Das <bsd@redhat.com>
---
 drivers/pci/pci-driver.c | 42 ++++++++++++++++++++++++++++++++++++++----
 1 file changed, 38 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 25f0bc6..187e572 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -90,6 +90,24 @@ static void pci_free_dynids(struct pci_driver *drv)
 	spin_unlock(&drv->dynids.lock);
 }
 
+static const struct
+pci_device_id *match_id_table_entry(struct device_driver *driver,
+				    __u32 vendor, __u32 device)
+{
+	struct pci_driver *pdrv = to_pci_driver(driver);
+	const struct pci_device_id *ids = pdrv->id_table;
+
+	if (ids) {
+		while (ids->vendor || ids->subvendor || ids->class_mask) {
+			if ((ids->vendor == vendor) && (ids->device == device))
+				return ids;
+			ids++;
+		}
+	}
+
+	return NULL;
+}
+
 /**
  * store_new_id - sysfs frontend to pci_add_dynid()
  * @driver: target device driver
@@ -102,7 +120,8 @@ static ssize_t
 store_new_id(struct device_driver *driver, const char *buf, size_t count)
 {
 	struct pci_driver *pdrv = to_pci_driver(driver);
-	const struct pci_device_id *ids = pdrv->id_table;
+	const struct pci_device_id *ids = pdrv->id_table,
+		*tids = NULL;
 	__u32 vendor, device, subvendor=PCI_ANY_ID,
 		subdevice=PCI_ANY_ID, class=0, class_mask=0;
 	unsigned long driver_data=0;
@@ -115,9 +134,24 @@ store_new_id(struct device_driver *driver, const char *buf, size_t count)
 	if (fields < 2)
 		return -EINVAL;
 
-	/* Only accept driver_data values that match an existing id_table
-	   entry */
-	if (ids) {
+	tids = match_id_table_entry(driver, vendor, device);
+
+	if (tids && (fields != 7)) {
+
+		subvendor = tids->subvendor;
+		subdevice = tids->subdevice;
+		class = tids->class;
+		class_mask = tids->class_mask;
+		driver_data = tids->driver_data;
+
+		pr_warn("pci: Using driver (%s) static DeviceID table entry for vendor 0x%04x and device 0x%04x",
+			driver->name, vendor, device);
+
+	} else if (ids) {
+
+		/* Only accept driver_data values that match an existing
+		   id_table entry */
+
 		retval = -EINVAL;
 		while (ids->vendor || ids->subvendor || ids->class_mask) {
 			if (driver_data == ids->driver_data) {
-- 
1.8.3.1

