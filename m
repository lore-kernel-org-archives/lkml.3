Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667AbaETOxg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 10:53:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890AbaETOxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 10:53:34 -0400
Subject: [PATCH v3] PCI: Introduce new device binding path using
 pci_dev.driver_override
From: Alex Williamson <alex.williamson@redhat.com>
To: bhelgaas@google.com, linux-pci@vger.kernel.org
Cc: kvm@vger.kernel.org, konrad.wilk@oracle.com, kim.phillips@linaro.org,
        gregkh@linuxfoundation.org, stuart.yoder@freescale.com, agraf@suse.de,
        libvir-list@redhat.com, iommu@lists.linux-foundation.org,
        christoffer.dall@linaro.org, tech@virtualopensystems.com,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
Date: Tue, 20 May 2014 08:53:21 -0600
Message-ID: <20140520145136.28232.90707.stgit@bling.home>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver_override field allows us to specify the driver for a device
rather than relying on the driver to provide a positive match of the
device.  This shortcuts the existing process of looking up the vendor
and device ID, adding them to the driver new_id, binding the device,
then removing the ID, but it also provides a couple advantages.

First, the above existing process allows the driver to bind to any
device matching the new_id for the window where it's enabled.  This is
often not desired, such as the case of trying to bind a single device
to a meta driver like pci-stub or vfio-pci.  Using driver_override we
can do this deterministically using:

echo pci-stub > /sys/bus/pci/devices/0000:03:00.0/driver_override
echo 0000:03:00.0 > /sys/bus/pci/devices/0000:03:00.0/driver/unbind
echo 0000:03:00.0 > /sys/bus/pci/drivers_probe

Previously we could not invoke drivers_probe after adding a device
to new_id for a driver as we get non-deterministic behavior whether
the driver we intend or the standard driver will claim the device.
Now it becomes a deterministic process, only the driver matching
driver_override will probe the device.

To return the device to the standard driver, we simply clear the
driver_override and reprobe the device:

echo > /sys/bus/pci/devices/0000:03:00.0/driver_override
echo 0000:03:00.0 > /sys/bus/pci/devices/0000:03:00.0/driver/unbind
echo 0000:03:00.0 > /sys/bus/pci/drivers_probe

Another advantage to this approach is that we can specify a driver
override to force a specific binding or prevent any binding.  For
instance when an IOMMU group is exposed to userspace through VFIO
we require that all devices within that group are owned by VFIO.
However, devices can be hot-added into an IOMMU group, in which case
we want to prevent the device from binding to any driver (override
driver = "none") or perhaps have it automatically bind to vfio-pci.
With driver_override it's a simple matter for this field to be set
internally when the device is first discovered to prevent driver
matches.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

v3: kfree() override buffer on device release, noted by Alex Graf

v2: Use strchr() as suggested by Guenter Roeck and adopted by the
    platform driver version of this same interface.

 Documentation/ABI/testing/sysfs-bus-pci |   21 ++++++++++++++++
 drivers/pci/pci-driver.c                |   25 +++++++++++++++++--
 drivers/pci/pci-sysfs.c                 |   40 +++++++++++++++++++++++++++++++
 drivers/pci/probe.c                     |    1 +
 include/linux/pci.h                     |    1 +
 5 files changed, 85 insertions(+), 3 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
index a3c5a66..898ddc4 100644
--- a/Documentation/ABI/testing/sysfs-bus-pci
+++ b/Documentation/ABI/testing/sysfs-bus-pci
@@ -250,3 +250,24 @@ Description:
 		valid.  For example, writing a 2 to this file when sriov_numvfs
 		is not 0 and not 2 already will return an error. Writing a 10
 		when the value of sriov_totalvfs is 8 will return an error.
+
+What:		/sys/bus/pci/devices/.../driver_override
+Date:		April 2014
+Contact:	Alex Williamson <alex.williamson@redhat.com>
+Description:
+		This file allows the driver for a device to be specified which
+		will override standard static and dynamic ID matching.  When
+		specified, only a driver with a name matching the value written
+		to driver_override will have an opportunity to bind to the
+		device.  The override is specified by writing a string to the
+		driver_override file (echo pci-stub > driver_override) and
+		may be cleared with an empty string (echo > driver_override).
+		This returns the device to standard matching rules binding.
+		Writing to driver_override does not automatically unbind the
+		device from its current driver or make any attempt to
+		automatically load the specified driver.  If no driver with a
+		matching name is currently loaded in the kernel, the device
+		will not bind to any driver.  This also allows devices to
+		opt-out of driver binding using a driver_override name such as
+		"none".  Only a single driver may be specified in the override,
+		there is no support for parsing delimiters.
diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index d911e0c..4393c12 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -216,6 +216,13 @@ const struct pci_device_id *pci_match_id(const struct pci_device_id *ids,
 	return NULL;
 }
 
+static const struct pci_device_id pci_device_id_any = {
+	.vendor = PCI_ANY_ID,
+	.device = PCI_ANY_ID,
+	.subvendor = PCI_ANY_ID,
+	.subdevice = PCI_ANY_ID,
+};
+
 /**
  * pci_match_device - Tell if a PCI device structure has a matching PCI device id structure
  * @drv: the PCI driver to match against
@@ -229,18 +236,30 @@ static const struct pci_device_id *pci_match_device(struct pci_driver *drv,
 						    struct pci_dev *dev)
 {
 	struct pci_dynid *dynid;
+	const struct pci_device_id *found_id = NULL;
+
+	/* When driver_override is set, only bind to the matching driver */
+	if (dev->driver_override && strcmp(dev->driver_override, drv->name))
+		return NULL;
 
 	/* Look at the dynamic ids first, before the static ones */
 	spin_lock(&drv->dynids.lock);
 	list_for_each_entry(dynid, &drv->dynids.list, node) {
 		if (pci_match_one_device(&dynid->id, dev)) {
-			spin_unlock(&drv->dynids.lock);
-			return &dynid->id;
+			found_id = &dynid->id;
+			break;
 		}
 	}
 	spin_unlock(&drv->dynids.lock);
 
-	return pci_match_id(drv->id_table, dev);
+	if (!found_id)
+		found_id = pci_match_id(drv->id_table, dev);
+
+	/* driver_override will always match, send a dummy id */
+	if (!found_id && dev->driver_override)
+		found_id = &pci_device_id_any;
+
+	return found_id;
 }
 
 struct drv_dev_and_id {
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 4e0acef..faa4ab5 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -499,6 +499,45 @@ static struct device_attribute sriov_numvfs_attr =
 		       sriov_numvfs_show, sriov_numvfs_store);
 #endif /* CONFIG_PCI_IOV */
 
+static ssize_t driver_override_store(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t count)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	char *driver_override, *old = pdev->driver_override, *cp;
+
+	if (count > PATH_MAX)
+		return -EINVAL;
+
+	driver_override = kstrndup(buf, count, GFP_KERNEL);
+	if (!driver_override)
+		return -ENOMEM;
+
+	cp = strchr(driver_override, '\n');
+	if (cp)
+		*cp = '\0';
+
+	if (strlen(driver_override)) {
+		pdev->driver_override = driver_override;
+	} else {
+		kfree(driver_override);
+		pdev->driver_override = NULL;
+	}
+
+	kfree(old);
+
+	return count;
+}
+
+static ssize_t driver_override_show(struct device *dev,
+				    struct device_attribute *attr, char *buf)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	return sprintf(buf, "%s\n", pdev->driver_override);
+}
+static DEVICE_ATTR_RW(driver_override);
+
 static struct attribute *pci_dev_attrs[] = {
 	&dev_attr_resource.attr,
 	&dev_attr_vendor.attr,
@@ -521,6 +560,7 @@ static struct attribute *pci_dev_attrs[] = {
 #if defined(CONFIG_PM_RUNTIME) && defined(CONFIG_ACPI)
 	&dev_attr_d3cold_allowed.attr,
 #endif
+	&dev_attr_driver_override.attr,
 	NULL,
 };
 
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index ef09f5f..54268de 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1215,6 +1215,7 @@ static void pci_release_dev(struct device *dev)
 	pci_release_of_node(pci_dev);
 	pcibios_release_device(pci_dev);
 	pci_bus_put(pci_dev->bus);
+	kfree(pci_dev->driver_override);
 	kfree(pci_dev);
 }
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index aab57b4..b72af27 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -365,6 +365,7 @@ struct pci_dev {
 #endif
 	phys_addr_t rom; /* Physical address of ROM if it's not from the BAR */
 	size_t romlen; /* Length of ROM if it's not from the BAR */
+	char *driver_override; /* Driver name to force a match */
 };
 
 static inline struct pci_dev *pci_physfn(struct pci_dev *dev)

