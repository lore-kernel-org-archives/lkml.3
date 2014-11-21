Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035AbaKUSY3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 13:24:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54316 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514AbaKUSYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 13:24:25 -0500
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 3/4] PCI: Allow device quirks to exclude bus reset
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>
Date: Fri, 21 Nov 2014 11:24:21 -0700
Message-ID: <20141121182421.26669.85408.stgit@gimli.home>
In-Reply-To: <20141121180322.26669.65689.stgit@gimli.home>
References: <20141121180322.26669.65689.stgit@gimli.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable a mechanism for devices to quirk that they do not behave when
doing a PCI bus reset.  We require a modest level of spec compliant
behavior in order to do a reset, for instance the device should come
out of reset without throwing errors and PCI config space should be
accessible after reset.  This is too much to ask for some devices.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 drivers/pci/pci.c   |   40 ++++++++++++++++++++++++++++++++++++----
 include/linux/pci.h |    2 ++
 2 files changed, 38 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index ba54a5a..7d6f87e 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3280,7 +3280,8 @@ static int pci_parent_bus_reset(struct pci_dev *dev, int probe)
 {
 	struct pci_dev *pdev;
 
-	if (pci_is_root_bus(dev->bus) || dev->subordinate || !dev->bus->self)
+	if (pci_is_root_bus(dev->bus) || dev->subordinate ||
+	    !dev->bus->self || dev->dev_flags & PCI_DEV_FLAGS_NO_BUS_RESET)
 		return -ENOTTY;
 
 	list_for_each_entry(pdev, &dev->bus->devices, bus_list)
@@ -3314,7 +3315,8 @@ static int pci_dev_reset_slot_function(struct pci_dev *dev, int probe)
 {
 	struct pci_dev *pdev;
 
-	if (dev->subordinate || !dev->slot)
+	if (dev->subordinate || !dev->slot ||
+	    dev->dev_flags & PCI_DEV_FLAGS_NO_BUS_RESET)
 		return -ENOTTY;
 
 	list_for_each_entry(pdev, &dev->bus->devices, bus_list)
@@ -3566,6 +3568,20 @@ int pci_try_reset_function(struct pci_dev *dev)
 }
 EXPORT_SYMBOL_GPL(pci_try_reset_function);
 
+/* Do any devices on or below this bus prevent a bus reset */
+static bool pci_bus_resetable(struct pci_bus *bus)
+{
+	struct pci_dev *dev;
+
+	list_for_each_entry(dev, &bus->devices, bus_list) {
+		if (dev->dev_flags & PCI_DEV_FLAGS_NO_BUS_RESET ||
+		    (dev->subordinate && !pci_bus_resetable(dev->subordinate)))
+			return false;
+	}
+
+	return true;
+}
+
 /* Lock devices from the top of the tree down */
 static void pci_bus_lock(struct pci_bus *bus)
 {
@@ -3616,6 +3632,22 @@ unlock:
 	return 0;
 }
 
+/* Do any devices on or below this slot prevent a bus reset */
+static bool pci_slot_resetable(struct pci_slot *slot)
+{
+	struct pci_dev *dev;
+
+	list_for_each_entry(dev, &slot->bus->devices, bus_list) {
+		if (!dev->slot || dev->slot != slot)
+			continue;
+		if (dev->dev_flags & PCI_DEV_FLAGS_NO_BUS_RESET ||
+		    (dev->subordinate && !pci_bus_resetable(dev->subordinate)))
+			return false;
+	}
+
+	return true;
+}
+
 /* Lock devices from the top of the tree down */
 static void pci_slot_lock(struct pci_slot *slot)
 {
@@ -3737,7 +3769,7 @@ static int pci_slot_reset(struct pci_slot *slot, int probe)
 {
 	int rc;
 
-	if (!slot)
+	if (!slot || !pci_slot_resetable(slot))
 		return -ENOTTY;
 
 	if (!probe)
@@ -3829,7 +3861,7 @@ EXPORT_SYMBOL_GPL(pci_try_reset_slot);
 
 static int pci_bus_reset(struct pci_bus *bus, int probe)
 {
-	if (!bus->self)
+	if (!bus->self || !pci_bus_resetable(bus))
 		return -ENOTTY;
 
 	if (probe)
diff --git a/include/linux/pci.h b/include/linux/pci.h
index aea347d..c9a8904 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -177,6 +177,8 @@ enum pci_dev_flags {
 	PCI_DEV_FLAG_PCIE_BRIDGE_ALIAS = (__force pci_dev_flags_t) (1 << 5),
 	/* Do not use PM reset even if device advertises NoSoftRst- */
 	PCI_DEV_FLAGS_NO_PM_RESET = (__force pci_dev_flags_t) (1 << 6),
+	/* Do not use bus resets for device */
+	PCI_DEV_FLAGS_NO_BUS_RESET = (__force pci_dev_flags_t) (1 << 7),
 };
 
 enum pci_irq_reroute_variant {

