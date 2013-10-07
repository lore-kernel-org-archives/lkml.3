Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273Ab3JGGzs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 02:55:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54889 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044Ab3JGGzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 02:55:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>, <linux-pci@vger.kernel.org>
Subject: [PATCH 01/11] pci: convert bus code to use dev_groups
Date: Sun,  6 Oct 2013 23:55:40 -0700
Message-Id: <1381128950-28125-2-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <1381128950-28125-1-git-send-email-gregkh@linuxfoundation.org>
References: <1381128950-28125-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dev_attrs field of struct bus_type is going away soon, dev_groups
should be used instead.  This converts the PCI bus code to use the
correct field.

Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: <linux-pci@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

Bjorn, I can take this through my driver-core tree if you like, just let
me know what would be the easiest for you.

 drivers/pci/pci-driver.c |  2 +-
 drivers/pci/pci-sysfs.c  | 73 ++++++++++++++++++++++++++++++------------------
 drivers/pci/pci.h        |  2 +-
 3 files changed, 48 insertions(+), 29 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 38f3c01..9f85960 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -1319,7 +1319,7 @@ struct bus_type pci_bus_type = {
 	.probe		= pci_device_probe,
 	.remove		= pci_device_remove,
 	.shutdown	= pci_device_shutdown,
-	.dev_attrs	= pci_dev_attrs,
+	.dev_groups	= pci_dev_groups,
 	.bus_groups	= pci_bus_groups,
 	.drv_groups	= pci_drv_groups,
 	.pm		= PCI_PM_OPS_PTR,
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index d8eb880..618c060 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -42,7 +42,8 @@ field##_show(struct device *dev, struct device_attribute *attr, char *buf)				\
 									\
 	pdev = to_pci_dev (dev);					\
 	return sprintf (buf, format_string, pdev->field);		\
-}
+}									\
+static DEVICE_ATTR_RO(field)
 
 pci_config_attr(vendor, "0x%04x\n");
 pci_config_attr(device, "0x%04x\n");
@@ -73,6 +74,7 @@ static ssize_t broken_parity_status_store(struct device *dev,
 
 	return count;
 }
+static DEVICE_ATTR_RW(broken_parity_status);
 
 static ssize_t local_cpus_show(struct device *dev,
 			struct device_attribute *attr, char *buf)
@@ -91,7 +93,7 @@ static ssize_t local_cpus_show(struct device *dev,
 	buf[len] = '\0';
 	return len;
 }
-
+static DEVICE_ATTR_RO(local_cpus);
 
 static ssize_t local_cpulist_show(struct device *dev,
 			struct device_attribute *attr, char *buf)
@@ -110,6 +112,7 @@ static ssize_t local_cpulist_show(struct device *dev,
 	buf[len] = '\0';
 	return len;
 }
+static DEVICE_ATTR_RO(local_cpulist);
 
 /*
  * PCI Bus Class Devices
@@ -170,6 +173,7 @@ resource_show(struct device * dev, struct device_attribute *attr, char * buf)
 	}
 	return (str - buf);
 }
+static DEVICE_ATTR_RO(resource);
 
 static ssize_t modalias_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
@@ -181,10 +185,11 @@ static ssize_t modalias_show(struct device *dev, struct device_attribute *attr,
 		       (u8)(pci_dev->class >> 16), (u8)(pci_dev->class >> 8),
 		       (u8)(pci_dev->class));
 }
+static DEVICE_ATTR_RO(modalias);
 
-static ssize_t is_enabled_store(struct device *dev,
-				struct device_attribute *attr, const char *buf,
-				size_t count)
+static ssize_t enabled_store(struct device *dev,
+			     struct device_attribute *attr, const char *buf,
+			     size_t count)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 	unsigned long val;
@@ -208,14 +213,15 @@ static ssize_t is_enabled_store(struct device *dev,
 	return result < 0 ? result : count;
 }
 
-static ssize_t is_enabled_show(struct device *dev,
-			       struct device_attribute *attr, char *buf)
+static ssize_t enabled_show(struct device *dev,
+			    struct device_attribute *attr, char *buf)
 {
 	struct pci_dev *pdev;
 
 	pdev = to_pci_dev (dev);
 	return sprintf (buf, "%u\n", atomic_read(&pdev->enable_cnt));
 }
+static DEVICE_ATTR_RW(enabled);
 
 #ifdef CONFIG_NUMA
 static ssize_t
@@ -223,6 +229,7 @@ numa_node_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	return sprintf (buf, "%d\n", dev->numa_node);
 }
+static DEVICE_ATTR_RO(numa_node);
 #endif
 
 static ssize_t
@@ -232,6 +239,7 @@ dma_mask_bits_show(struct device *dev, struct device_attribute *attr, char *buf)
 
 	return sprintf (buf, "%d\n", fls64(pdev->dma_mask));
 }
+static DEVICE_ATTR_RO(dma_mask_bits);
 
 static ssize_t
 consistent_dma_mask_bits_show(struct device *dev, struct device_attribute *attr,
@@ -239,6 +247,7 @@ consistent_dma_mask_bits_show(struct device *dev, struct device_attribute *attr,
 {
 	return sprintf (buf, "%d\n", fls64(dev->coherent_dma_mask));
 }
+static DEVICE_ATTR_RO(consistent_dma_mask_bits);
 
 static ssize_t
 msi_bus_show(struct device *dev, struct device_attribute *attr, char *buf)
@@ -283,6 +292,7 @@ msi_bus_store(struct device *dev, struct device_attribute *attr,
 
 	return count;
 }
+static DEVICE_ATTR_RW(msi_bus);
 
 static DEFINE_MUTEX(pci_remove_rescan_mutex);
 static ssize_t bus_rescan_store(struct bus_type *bus, const char *buf,
@@ -414,6 +424,7 @@ static ssize_t d3cold_allowed_show(struct device *dev,
 	struct pci_dev *pdev = to_pci_dev(dev);
 	return sprintf (buf, "%u\n", pdev->d3cold_allowed);
 }
+static DEVICE_ATTR_RW(d3cold_allowed);
 #endif
 
 #ifdef CONFIG_PCI_IOV
@@ -499,30 +510,38 @@ static struct device_attribute sriov_numvfs_attr =
 		       sriov_numvfs_show, sriov_numvfs_store);
 #endif /* CONFIG_PCI_IOV */
 
-struct device_attribute pci_dev_attrs[] = {
-	__ATTR_RO(resource),
-	__ATTR_RO(vendor),
-	__ATTR_RO(device),
-	__ATTR_RO(subsystem_vendor),
-	__ATTR_RO(subsystem_device),
-	__ATTR_RO(class),
-	__ATTR_RO(irq),
-	__ATTR_RO(local_cpus),
-	__ATTR_RO(local_cpulist),
-	__ATTR_RO(modalias),
+struct attribute *pci_dev_attrs[] = {
+	&dev_attr_resource.attr,
+	&dev_attr_vendor.attr,
+	&dev_attr_device.attr,
+	&dev_attr_subsystem_vendor.attr,
+	&dev_attr_subsystem_device.attr,
+	&dev_attr_class.attr,
+	&dev_attr_irq.attr,
+	&dev_attr_local_cpus.attr,
+	&dev_attr_local_cpulist.attr,
+	&dev_attr_modalias.attr,
 #ifdef CONFIG_NUMA
-	__ATTR_RO(numa_node),
+	&dev_attr_numa_node.attr,
 #endif
-	__ATTR_RO(dma_mask_bits),
-	__ATTR_RO(consistent_dma_mask_bits),
-	__ATTR(enable, 0600, is_enabled_show, is_enabled_store),
-	__ATTR(broken_parity_status,(S_IRUGO|S_IWUSR),
-		broken_parity_status_show,broken_parity_status_store),
-	__ATTR(msi_bus, 0644, msi_bus_show, msi_bus_store),
+	&dev_attr_dma_mask_bits.attr,
+	&dev_attr_consistent_dma_mask_bits.attr,
+	&dev_attr_enabled.attr,
+	&dev_attr_broken_parity_status.attr,
+	&dev_attr_msi_bus.attr,
 #if defined(CONFIG_PM_RUNTIME) && defined(CONFIG_ACPI)
-	__ATTR(d3cold_allowed, 0644, d3cold_allowed_show, d3cold_allowed_store),
+	&dev_attr_d3cold_allowed.attr,
 #endif
-	__ATTR_NULL,
+	NULL,
+};
+
+static const struct attribute_group pci_dev_group = {
+	.attrs = pci_dev_attrs,
+};
+
+const struct attribute_group *pci_dev_groups[] = {
+	&pci_dev_group,
+	NULL,
 };
 
 static struct attribute *pcibus_attrs[] = {
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 607be58..9c91ecc 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -153,7 +153,7 @@ static inline int pci_no_d1d2(struct pci_dev *dev)
 	return (dev->no_d1d2 || parent_dstates);
 
 }
-extern struct device_attribute pci_dev_attrs[];
+extern const struct attribute_group *pci_dev_groups[];
 extern const struct attribute_group *pcibus_groups[];
 extern struct device_type pci_dev_type;
 extern const struct attribute_group *pci_bus_groups[];
-- 
1.8.4.6.g82e253f.dirty

