Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383AbaDAQ3b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:29:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9789 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753370AbaDAQ3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:29:24 -0400
Subject: [RFC PATCH] PCI: Introduce new device binding path using
 pci_dev.driver_override
From: Alex Williamson <alex.williamson@redhat.com>
To: gregkh@linuxfoundation.org, stuart.yoder@freescale.com
Cc: kvm@vger.kernel.org, jan.kiszka@siemens.com, will.deacon@arm.com,
        linux-kernel@vger.kernel.org, mhocko@suse.cz, bhelgaas@google.com,
        Varun.Sethi@freescale.com, kvmarm@lists.cs.columbia.edu,
        rafael.j.wysocki@intel.com, agraf@suse.de, linux-pci@vger.kernel.org,
        linux@roeck-us.net, konrad.wilk@oracle.com, d.kasatkin@samsung.com,
        tj@kernel.org, scottwood@freescale.com,
        a.motakis@virtualopensystems.com, tech@virtualopensystems.com,
        Bharat.Bhushan@freescale.com, toshi.kani@hp.com,
        kim.phillips@linaro.org, a.rigo@virtualopensystems.com,
        iommu@lists.linux-foundation.org, joe@perches.com,
        christoffer.dall@linaro.org
Date: Tue, 01 Apr 2014 10:28:54 -0600
Message-ID: <20140401161851.18815.31108.stgit@bling.home>
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

First, the above process allows the driver to bind to any device
matching the new_id for the window where it's enabled.  This is often
not desired, such as the case of trying to bind a single device to a
meta driver like pci-stub or vfio-pci.  Using driver_override we can
do this deterministically using:

echo pci-stub > /sys/bus/pci/devices/0000:03:00.0/driver_override
echo 0000:03:00.0 > /sys/bus/pci/devices/0000:03:00.0/driver/unbind
echo 0000:03:00.0 > /sys/bus/pci/drivers_probe

Previously we could not invoke drivers_probe after adding a device
to new_id for a driver as we get non-deterministic behavior whether
the driver we intend or the standard driver will claim the device.
Now it becomes a deterministic process, only the driver matching
driver_override will probe the device.

To return the device to the standard driver, we simply clear the
driver_override and reprobe the device, ex:

echo > /sys/bus/pci/devices/0000:03:00.0/preferred_driver
echo 0000:03:00.0 > /sys/bus/pci/devices/0000:03:00.0/driver/unbind
echo 0000:03:00.0 > /sys/bus/pci/drivers_probe

Another advantage to this approach is that we can specify a driver
override to force a specific binding or prevent any binding.  For
instance when an IOMMU group is exposed to userspace through VFIO
we require that all devices within that group are owned by VFIO.
However, devices can be hot-added into an IOMMU group, in which case
we want to prevent the device from binding to any driver (preferred
driver = "none") or perhaps have it automatically bind to vfio-pci.
With driver_override it's a simple matter for this field to be set
internally when the device is first discovered to prevent driver
matches.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

Apologies for the exceptionally long cc list, this is a follow-up to
Stuart's "Subject: mechanism to allow a driver to bind to any device"
thread.  This is effectively a v2 of the proof-of-concept patch I
posted in that thread.  This version changes to use a dummy id struct
to return on an "override" match, which removes the collateral damage
and greatly simplifies the patch.  This feels fairly well baked for
PCI and I would expect that platform drivers could do a similar
implementation.  From there perhaps we can discuss whether there's
any advantage to placing driver_override on struct device.  The logic
for incorporating it into the match still needs to happen per bus
driver, so it might only contribute to consistency of the show/store
sysfs attributes to move it up to struct device.  Please comment.
Thanks,

Alex

 drivers/pci/pci-driver.c |   25 ++++++++++++++++++++++---
 drivers/pci/pci-sysfs.c  |   40 ++++++++++++++++++++++++++++++++++++++++
 include/linux/pci.h      |    1 +
 3 files changed, 63 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 25f0bc6..f780eb8 100644
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
index 276ef9c..70cb39d 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -510,6 +510,45 @@ static struct device_attribute sriov_numvfs_attr =
 		       sriov_numvfs_show, sriov_numvfs_store);
 #endif /* CONFIG_PCI_IOV */
 
+static ssize_t driver_override_store(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t count)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	char *driver_override, *old = pdev->driver_override;
+
+	if (count > PATH_MAX)
+		return -EINVAL;
+
+	driver_override = kstrndup(buf, count, GFP_KERNEL);
+	if (!driver_override)
+		return -ENOMEM;
+
+	while (strlen(driver_override) &&
+	       driver_override[strlen(driver_override) - 1] == '\n')
+		driver_override[strlen(driver_override) - 1] = '\0';
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
@@ -532,6 +571,7 @@ static struct attribute *pci_dev_attrs[] = {
 #if defined(CONFIG_PM_RUNTIME) && defined(CONFIG_ACPI)
 	&dev_attr_d3cold_allowed.attr,
 #endif
+	&dev_attr_driver_override.attr,
 	NULL,
 };
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 33aa2ca..6b666af 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -364,6 +364,7 @@ struct pci_dev {
 #endif
 	phys_addr_t rom; /* Physical address of ROM if it's not from the BAR */
 	size_t romlen; /* Length of ROM if it's not from the BAR */
+	char *driver_override; /* Driver name to force a match */
 };
 
 static inline struct pci_dev *pci_physfn(struct pci_dev *dev)

