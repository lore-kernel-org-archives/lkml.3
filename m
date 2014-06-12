Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbaFLWND (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 18:13:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49794 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056AbaFLWM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 18:12:59 -0400
Subject: [PATCH 3/3] iommu/amd: Add sysfs support
From: Alex Williamson <alex.williamson@redhat.com>
To: iommu@lists.linux-foundation.org
Cc: joro@8bytes.org, dwmw2@infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 12 Jun 2014 16:12:37 -0600
Message-ID: <20140612221236.2754.76120.stgit@bling.home>
In-Reply-To: <20140612215954.2754.30263.stgit@bling.home>
References: <20140612215954.2754.30263.stgit@bling.home>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AMD-Vi support for IOMMU sysfs.  This allows us to associate devices
with a specific IOMMU device and examine the capabilities and features
of that IOMMU.  The AMD IOMMU is hosted on and actual PCI device, so
we make that device the parent for the IOMMU class device.  This
initial implementaiton exposes only the capability header and extended
features register for the IOMMU.

# find /sys | grep ivhd
/sys/devices/pci0000:00/0000:00:00.2/iommu/ivhd0
/sys/devices/pci0000:00/0000:00:00.2/iommu/ivhd0/devices
/sys/devices/pci0000:00/0000:00:00.2/iommu/ivhd0/devices/0000:00:00.0
/sys/devices/pci0000:00/0000:00:00.2/iommu/ivhd0/devices/0000:00:02.0
/sys/devices/pci0000:00/0000:00:00.2/iommu/ivhd0/devices/0000:00:04.0
/sys/devices/pci0000:00/0000:00:00.2/iommu/ivhd0/devices/0000:00:09.0
/sys/devices/pci0000:00/0000:00:00.2/iommu/ivhd0/devices/0000:00:11.0
/sys/devices/pci0000:00/0000:00:00.2/iommu/ivhd0/devices/0000:00:12.0
/sys/devices/pci0000:00/0000:00:00.2/iommu/ivhd0/devices/0000:00:12.2
/sys/devices/pci0000:00/0000:00:00.2/iommu/ivhd0/devices/0000:00:13.0
...
/sys/devices/pci0000:00/0000:00:00.2/iommu/ivhd0/power
/sys/devices/pci0000:00/0000:00:00.2/iommu/ivhd0/power/control
...
/sys/devices/pci0000:00/0000:00:00.2/iommu/ivhd0/device
/sys/devices/pci0000:00/0000:00:00.2/iommu/ivhd0/subsystem
/sys/devices/pci0000:00/0000:00:00.2/iommu/ivhd0/amd-iommu
/sys/devices/pci0000:00/0000:00:00.2/iommu/ivhd0/amd-iommu/cap
/sys/devices/pci0000:00/0000:00:00.2/iommu/ivhd0/amd-iommu/features
/sys/devices/pci0000:00/0000:00:00.2/iommu/ivhd0/uevent
/sys/class/iommu/ivhd0

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 .../ABI/testing/sysfs-class-iommu-amd-iommu        |   14 +++++++
 drivers/iommu/amd_iommu.c                          |    6 +++
 drivers/iommu/amd_iommu_init.c                     |   38 ++++++++++++++++++++
 drivers/iommu/amd_iommu_types.h                    |    3 ++
 4 files changed, 61 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-class-iommu-amd-iommu

diff --git a/Documentation/ABI/testing/sysfs-class-iommu-amd-iommu b/Documentation/ABI/testing/sysfs-class-iommu-amd-iommu
new file mode 100644
index 0000000..d6ba8e8
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-class-iommu-amd-iommu
@@ -0,0 +1,14 @@
+What:		/sys/class/iommu/<iommu>/amd-iommu/cap
+Date:		June 2014
+KernelVersion:	3.17
+Contact:	Alex Williamson <alex.williamson@redhat.com>
+Description:
+		IOMMU capability header as documented in the AMD IOMMU
+		specification.  Format: %x
+
+What:		/sys/class/iommu/<iommu>/amd-iommu/features
+Date:		June 2014
+KernelVersion:	3.17
+Contact:	Alex Williamson <alex.williamson@redhat.com>
+Description:
+		Extended features of the IOMMU.  Format: %llx
diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index ca85615..83a43b2 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -379,6 +379,9 @@ static int iommu_init_device(struct device *dev)
 
 	dev->archdata.iommu = dev_data;
 
+	iommu_device_link(amd_iommu_rlookup_table[dev_data->devid]->iommu_dev,
+			  dev);
+
 	return 0;
 }
 
@@ -403,6 +406,9 @@ static void iommu_uninit_device(struct device *dev)
 	if (!dev_data)
 		return;
 
+	iommu_device_unlink(amd_iommu_rlookup_table[dev_data->devid]->iommu_dev,
+			    dev);
+
 	iommu_group_remove_device(dev);
 
 	/* Unlink from alias, it may change if another device is re-plugged */
diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 0e08545..3783e0b 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -26,6 +26,7 @@
 #include <linux/msi.h>
 #include <linux/amd-iommu.h>
 #include <linux/export.h>
+#include <linux/iommu.h>
 #include <asm/pci-direct.h>
 #include <asm/iommu.h>
 #include <asm/gart.h>
@@ -1197,6 +1198,39 @@ static void init_iommu_perf_ctr(struct amd_iommu *iommu)
 	iommu->max_counters = (u8) ((val >> 7) & 0xf);
 }
 
+static ssize_t amd_iommu_show_cap(struct device *dev,
+				  struct device_attribute *attr,
+				  char *buf)
+{
+	struct amd_iommu *iommu = dev_get_drvdata(dev);
+	return sprintf(buf, "%x\n", iommu->cap);
+}
+static DEVICE_ATTR(cap, S_IRUGO, amd_iommu_show_cap, NULL);
+
+static ssize_t amd_iommu_show_features(struct device *dev,
+				       struct device_attribute *attr,
+				       char *buf)
+{
+	struct amd_iommu *iommu = dev_get_drvdata(dev);
+	return sprintf(buf, "%llx\n", iommu->features);
+}
+static DEVICE_ATTR(features, S_IRUGO, amd_iommu_show_features, NULL);
+
+static struct attribute *amd_iommu_attrs[] = {
+	&dev_attr_cap.attr,
+	&dev_attr_features.attr,
+	NULL,
+};
+
+static struct attribute_group amd_iommu_group = {
+	.name = "amd-iommu",
+	.attrs = amd_iommu_attrs,
+};
+
+static const struct attribute_group *amd_iommu_groups[] = {
+	&amd_iommu_group,
+	NULL,
+};
 
 static int iommu_init_pci(struct amd_iommu *iommu)
 {
@@ -1297,6 +1331,10 @@ static int iommu_init_pci(struct amd_iommu *iommu)
 
 	amd_iommu_erratum_746_workaround(iommu);
 
+	iommu->iommu_dev = iommu_device_create(&iommu->dev->dev, iommu,
+					       amd_iommu_groups, "ivhd%d",
+					       iommu->index);
+
 	return pci_enable_device(iommu->dev);
 }
 
diff --git a/drivers/iommu/amd_iommu_types.h b/drivers/iommu/amd_iommu_types.h
index 7277a20..557a20e 100644
--- a/drivers/iommu/amd_iommu_types.h
+++ b/drivers/iommu/amd_iommu_types.h
@@ -577,6 +577,9 @@ struct amd_iommu {
 	/* default dma_ops domain for that IOMMU */
 	struct dma_ops_domain *default_dom;
 
+	/* IOMMU sysfs device */
+	struct device *iommu_dev;
+
 	/*
 	 * We can't rely on the BIOS to restore all values on reinit, so we
 	 * need to stash them

