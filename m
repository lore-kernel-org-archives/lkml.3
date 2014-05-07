Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbaEGXSA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 19:18:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6377 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470AbaEGXR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 19:17:56 -0400
Subject: [RFC PATCH 2/2] iommu/intel: Make use of IOMMU sysfs support
From: Alex Williamson <alex.williamson@redhat.com>
To: iommu@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Date: Wed, 07 May 2014 17:17:54 -0600
Message-ID: <20140507231753.3124.52784.stgit@bling.home>
In-Reply-To: <20140507230308.3124.90856.stgit@bling.home>
References: <20140507230308.3124.90856.stgit@bling.home>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register our DRHD IOMMUs, cross link devices, and provide a base set
of attributes for the IOMMU.  Note that IRQ remapping support parses
the DMAR table very early in boot, well before the iommu_class can
reasonably be setup, so our registration is split between
intel_iommu_init(), which occurs later, and alloc_iommu(), which
typically occurs much earlier, but may happen at any time later
with IOMMU hot-add support.

On a typical desktop system, this provides the following (pruned):

$ find /sys | grep dmar
/sys/devices/virtual/iommu/dmar0
/sys/devices/virtual/iommu/dmar0/devices
/sys/devices/virtual/iommu/dmar0/devices/0000:00:02.0
/sys/devices/virtual/iommu/dmar0/intel-iommu
/sys/devices/virtual/iommu/dmar0/intel-iommu/cap
/sys/devices/virtual/iommu/dmar0/intel-iommu/ecap
/sys/devices/virtual/iommu/dmar0/intel-iommu/address
/sys/devices/virtual/iommu/dmar0/intel-iommu/version
/sys/devices/virtual/iommu/dmar1
/sys/devices/virtual/iommu/dmar1/devices
/sys/devices/virtual/iommu/dmar1/devices/0000:00:00.0
/sys/devices/virtual/iommu/dmar1/devices/0000:00:01.0
/sys/devices/virtual/iommu/dmar1/devices/0000:00:16.0
/sys/devices/virtual/iommu/dmar1/devices/0000:00:1a.0
/sys/devices/virtual/iommu/dmar1/devices/0000:00:1b.0
/sys/devices/virtual/iommu/dmar1/devices/0000:00:1c.0
...
/sys/devices/virtual/iommu/dmar1/intel-iommu
/sys/devices/virtual/iommu/dmar1/intel-iommu/cap
/sys/devices/virtual/iommu/dmar1/intel-iommu/ecap
/sys/devices/virtual/iommu/dmar1/intel-iommu/address
/sys/devices/virtual/iommu/dmar1/intel-iommu/version
/sys/class/iommu/dmar0
/sys/class/iommu/dmar1

(devices also link back to the dmar units)

Putting these under the "virtual" directory may not be correct since
these are physical devices, maybe under /sys/devices/system?  Virtual
is simply the default for NULL parent.

This makes address, version, capabilities, and extended capabilities
available, just like printed on boot.  Nearly everything we might
want can be parsed from cap/ecap, but I expect we'll want to make
some human friendly entries for things that we care about.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/iommu/dmar.c        |    8 +++++
 drivers/iommu/intel-iommu.c |   75 ++++++++++++++++++++++++++++++++++++++++++-
 include/linux/intel-iommu.h |    2 +
 3 files changed, 84 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index 39f8b71..68b3d07 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -38,6 +38,7 @@
 #include <linux/tboot.h>
 #include <linux/dmi.h>
 #include <linux/slab.h>
+#include <linux/iommu.h>
 #include <asm/irq_remapping.h>
 #include <asm/iommu_table.h>
 
@@ -980,6 +981,11 @@ static int alloc_iommu(struct dmar_drhd_unit *drhd)
 	raw_spin_lock_init(&iommu->register_lock);
 
 	drhd->iommu = iommu;
+
+	if (intel_iommu_enabled)
+		iommu_register_device(NULL, iommu->name,
+				      intel_iommu_groups, iommu);
+
 	return 0;
 
  err_unmap:
@@ -991,6 +997,8 @@ static int alloc_iommu(struct dmar_drhd_unit *drhd)
 
 static void free_iommu(struct intel_iommu *iommu)
 {
+	iommu_unregister_device(iommu);
+
 	if (iommu->irq) {
 		free_irq(iommu->irq, iommu);
 		irq_set_handler_data(iommu->irq, NULL);
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index d87b3c9..f8d779c 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -3930,6 +3930,63 @@ static struct notifier_block intel_iommu_memory_nb = {
 	.priority = 0
 };
 
+
+static ssize_t intel_iommu_show_version(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	struct intel_iommu *iommu = dev->platform_data;
+	u32 ver = readl(iommu->reg + DMAR_VER_REG);
+	return sprintf(buf, "%d:%d\n",
+		       DMAR_VER_MAJOR(ver), DMAR_VER_MINOR(ver));
+}
+static DEVICE_ATTR(version, S_IRUGO, intel_iommu_show_version, NULL);
+
+static ssize_t intel_iommu_show_address(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	struct intel_iommu *iommu = dev->platform_data;
+	return sprintf(buf, "%llx\n", iommu->reg_phys);
+}
+static DEVICE_ATTR(address, S_IRUGO, intel_iommu_show_address, NULL);
+
+static ssize_t intel_iommu_show_cap(struct device *dev,
+				    struct device_attribute *attr,
+				    char *buf)
+{
+	struct intel_iommu *iommu = dev->platform_data;
+	return sprintf(buf, "%llx\n", iommu->cap);
+}
+static DEVICE_ATTR(cap, S_IRUGO, intel_iommu_show_cap, NULL);
+
+static ssize_t intel_iommu_show_ecap(struct device *dev,
+				    struct device_attribute *attr,
+				    char *buf)
+{
+	struct intel_iommu *iommu = dev->platform_data;
+	return sprintf(buf, "%llx\n", iommu->ecap);
+}
+static DEVICE_ATTR(ecap, S_IRUGO, intel_iommu_show_ecap, NULL);
+
+static struct attribute *intel_iommu_attrs[] = {
+	&dev_attr_version.attr,
+	&dev_attr_address.attr,
+	&dev_attr_cap.attr,
+	&dev_attr_ecap.attr,
+	NULL,
+};
+
+static struct attribute_group intel_iommu_group = {
+	.name = "intel-iommu",
+	.attrs = intel_iommu_attrs,
+};
+
+const struct attribute_group *intel_iommu_groups[] = {
+	&intel_iommu_group,
+	NULL,
+};
+
 int __init intel_iommu_init(void)
 {
 	int ret = -ENODEV;
@@ -4001,6 +4058,10 @@ int __init intel_iommu_init(void)
 
 	init_iommu_pm_ops();
 
+	for_each_iommu(iommu, drhd)
+		iommu_register_device(NULL, iommu->name,
+				      intel_iommu_groups, iommu);
+
 	bus_set_iommu(&pci_bus_type, &intel_iommu_ops);
 	bus_register_notifier(&pci_bus_type, &device_nb);
 	if (si_domain && !hw_pass_through)
@@ -4338,14 +4399,18 @@ static int intel_iommu_domain_has_cap(struct iommu_domain *domain,
 
 static int intel_iommu_add_device(struct device *dev)
 {
+	struct intel_iommu *iommu;
 	struct pci_dev *pdev;
 	struct iommu_group *group;
 	int ret;
 	u8 bus, devfn;
 
-	if (!device_to_iommu(dev, &bus, &devfn))
+	iommu = device_to_iommu(dev, &bus, &devfn);
+	if (!iommu)
 		return -ENODEV;
 
+	iommu_device_link(iommu, dev);
+
 	group = iommu_group_get(dev);
 	if (group) {
 		iommu_group_put(group);
@@ -4371,7 +4436,15 @@ static int intel_iommu_add_device(struct device *dev)
 
 static void intel_iommu_remove_device(struct device *dev)
 {
+	struct intel_iommu *iommu;
+	u8 bus, devfn;
+
+	iommu = device_to_iommu(dev, &bus, &devfn);
+	if (!iommu)
+		return;
+
 	iommu_group_remove_device(dev);
+	iommu_device_unlink(iommu, dev);
 }
 
 static struct iommu_ops intel_iommu_ops = {
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index 0a2da51..aa6905e 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -365,4 +365,6 @@ extern int qi_submit_sync(struct qi_desc *desc, struct intel_iommu *iommu);
 
 extern int dmar_ir_support(void);
 
+extern const struct attribute_group *intel_iommu_groups[];
+
 #endif

