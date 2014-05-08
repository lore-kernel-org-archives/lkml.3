Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546AbaEHTNz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 15:13:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40680 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755019AbaEHTNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 15:13:53 -0400
Subject: [RFC PATCH 3/2] iommu/amd: Add sysfs support
From: Alex Williamson <alex.williamson@redhat.com>
To: iommu@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Date: Thu, 08 May 2014 12:20:05 -0600
Message-ID: <20140508181900.31415.35795.stgit@bling.home>
In-Reply-To: <20140507230308.3124.90856.stgit@bling.home>
References: <20140507230308.3124.90856.stgit@bling.home>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No proof of concept is complete with only a single user, so here's an
example for AMD IOMMU.  This IOMMU is neatly associated with a device,
so we don't need to leave the IOMMU device dangling in virtual space.
This just has a couple fields from struct amd_iommu cherry picked to
expose and looks something like this (pruned):

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
/sys/devices/pci0000:00/0000:00:00.2/iommu/ivhd0/amd-iommu/is_iommu_v2
/sys/devices/pci0000:00/0000:00:00.2/iommu/ivhd0/amd-iommu/features
/sys/devices/pci0000:00/0000:00:00.2/iommu/ivhd0/uevent
/sys/class/iommu/ivhd0

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/iommu/amd_iommu.c      |    4 +++
 drivers/iommu/amd_iommu_init.c |   53 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 57 insertions(+)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 4621692..4849580 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -346,6 +346,8 @@ static int iommu_init_device(struct device *dev)
 
 	dev->archdata.iommu = dev_data;
 
+	iommu_device_link(amd_iommu_rlookup_table[dev_data->devid], dev);
+
 	return 0;
 }
 
@@ -370,6 +372,8 @@ static void iommu_uninit_device(struct device *dev)
 	if (!dev_data)
 		return;
 
+	iommu_device_unlink(amd_iommu_rlookup_table[dev_data->devid], dev);
+
 	iommu_group_remove_device(dev);
 
 	/* Unlink from alias, it may change if another device is re-plugged */
diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index b76c58d..68f7c08 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -26,6 +26,8 @@
 #include <linux/msi.h>
 #include <linux/amd-iommu.h>
 #include <linux/export.h>
+#include <linux/iommu.h>
+#include <linux/device.h>
 #include <asm/pci-direct.h>
 #include <asm/iommu.h>
 #include <asm/gart.h>
@@ -1197,11 +1199,55 @@ static void init_iommu_perf_ctr(struct amd_iommu *iommu)
 	iommu->max_counters = (u8) ((val >> 7) & 0xf);
 }
 
+static ssize_t amd_iommu_show_cap(struct device *dev,
+				  struct device_attribute *attr,
+				  char *buf)
+{
+	struct amd_iommu *iommu = dev->platform_data;
+	return sprintf(buf, "%x\n", iommu->cap);
+}
+static DEVICE_ATTR(cap, S_IRUGO, amd_iommu_show_cap, NULL);
+
+static ssize_t amd_iommu_show_features(struct device *dev,
+				       struct device_attribute *attr,
+				       char *buf)
+{
+	struct amd_iommu *iommu = dev->platform_data;
+	return sprintf(buf, "%llx\n", iommu->features);
+}
+static DEVICE_ATTR(features, S_IRUGO, amd_iommu_show_features, NULL);
+
+static ssize_t amd_iommu_show_v2(struct device *dev,
+				 struct device_attribute *attr,
+				 char *buf)
+{
+	struct amd_iommu *iommu = dev->platform_data;
+	return sprintf(buf, "%c\n", iommu->is_iommu_v2 ? 'Y' : 'N');
+}
+static DEVICE_ATTR(is_iommu_v2, S_IRUGO, amd_iommu_show_v2, NULL);
+
+static struct attribute *amd_iommu_attrs[] = {
+	&dev_attr_cap.attr,
+	&dev_attr_features.attr,
+	&dev_attr_is_iommu_v2.attr,
+	NULL,
+};
+
+static struct attribute_group amd_iommu_group = {
+	.name = "amd-iommu",
+	.attrs = amd_iommu_attrs,
+};
+
+const struct attribute_group *amd_iommu_groups[] = {
+	&amd_iommu_group,
+	NULL,
+};
 
 static int iommu_init_pci(struct amd_iommu *iommu)
 {
 	int cap_ptr = iommu->cap_ptr;
 	u32 range, misc, low, high;
+	char *name;
 
 	iommu->dev = pci_get_bus_and_slot(PCI_BUS_NUM(iommu->devid),
 					  iommu->devid & 0xff);
@@ -1297,6 +1343,13 @@ static int iommu_init_pci(struct amd_iommu *iommu)
 
 	amd_iommu_erratum_746_workaround(iommu);
 
+	name = kasprintf(GFP_KERNEL, "ivhd%d", iommu->index);
+	if (name) {
+		iommu_register_device(&iommu->dev->dev, name,
+				      amd_iommu_groups, iommu);
+		kfree(name);
+	}
+
 	return pci_enable_device(iommu->dev);
 }
 

