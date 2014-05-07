Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbaEGXRx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 19:17:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39565 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470AbaEGXRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 19:17:50 -0400
Subject: [RFC PATCH 1/2] iommu: Add sysfs support for IOMMUs
From: Alex Williamson <alex.williamson@redhat.com>
To: iommu@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Date: Wed, 07 May 2014 17:17:48 -0600
Message-ID: <20140507231747.3124.34770.stgit@bling.home>
In-Reply-To: <20140507230308.3124.90856.stgit@bling.home>
References: <20140507230308.3124.90856.stgit@bling.home>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IOMMUs currently have no common representation to userspace, most
seem to have no representation at all aside from a few printks
on bootup.  There are, however, features of IOMMUs that are useful
to know about.  For instance, the IOMMU might support superpages,
making use of processor large/huge pages more important in a device
assignment scenario.  It's also useful to create cross links between
devices and IOMMU hardware units, so that users might be able to
load balance their devices to avoid thrashing a single hardware unit.

This patch adds a registration and de-registration interface as well
as device linking, making it very lightweight for an IOMMU driver to
add basic support.  IOMMU drivers can provide additional attributes
automatically by using an attribute_group.

The attributes exposed are expected to be relatively device specific,
the means to retrieve them certainly are.  So there are currently
no common attributes for the new iommu_class created here.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/iommu/Makefile      |    1 
 drivers/iommu/iommu-sysfs.c |  147 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/iommu.h       |   28 ++++++++
 3 files changed, 176 insertions(+)
 create mode 100644 drivers/iommu/iommu-sysfs.c

diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
index 5d58bf1..437c231 100644
--- a/drivers/iommu/Makefile
+++ b/drivers/iommu/Makefile
@@ -1,5 +1,6 @@
 obj-$(CONFIG_IOMMU_API) += iommu.o
 obj-$(CONFIG_IOMMU_API) += iommu-traces.o
+obj-$(CONFIG_IOMMU_API) += iommu-sysfs.o
 obj-$(CONFIG_OF_IOMMU)	+= of_iommu.o
 obj-$(CONFIG_MSM_IOMMU) += msm_iommu.o msm_iommu_dev.o
 obj-$(CONFIG_AMD_IOMMU) += amd_iommu.o amd_iommu_init.o
diff --git a/drivers/iommu/iommu-sysfs.c b/drivers/iommu/iommu-sysfs.c
new file mode 100644
index 0000000..123f20c
--- /dev/null
+++ b/drivers/iommu/iommu-sysfs.c
@@ -0,0 +1,147 @@
+#include <linux/device.h>
+#include <linux/iommu.h>
+#include <linux/module.h>
+
+struct iommu_device {
+	struct device dev;
+	struct kobject *devices;
+};
+
+#define to_iommu_device(dev) container_of(dev, struct iommu_device, dev)
+
+static void iommu_release_device(struct device *dev)
+{
+	struct iommu_device *iommu = to_iommu_device(dev);
+	kobject_put(iommu->devices);
+	kfree(iommu);
+}
+
+static struct class iommu_class = {
+	.name = "iommu",
+	.dev_release = iommu_release_device,
+};
+
+static int __init iommu_dev_init(void)
+{
+	return class_register(&iommu_class);
+}
+postcore_initcall(iommu_dev_init);
+
+static int __match_platform_data(struct device *dev, const void *platform_data)
+{
+	return dev->platform_data == platform_data;
+}
+
+int iommu_register_device(struct device *parent, const char *name,
+			  const struct attribute_group **groups,
+			  void *platform_data)
+{
+	struct device *dev;
+	struct iommu_device *iommu;
+	int ret;
+
+	dev = class_find_device(&iommu_class, NULL,
+				platform_data, __match_platform_data);
+	if (dev) {
+		put_device(dev);
+		return -EEXIST;
+	}
+
+	iommu = kzalloc(sizeof(*iommu), GFP_KERNEL);
+	if (!iommu)
+		return -ENOMEM;
+
+	device_initialize(&iommu->dev);
+
+	iommu->dev.class = &iommu_class;
+	iommu->dev.parent = parent;
+	dev_set_name(&iommu->dev, "%s", name);
+	iommu->dev.groups = groups;
+	iommu->dev.platform_data = platform_data;
+
+	ret = device_add(&iommu->dev);
+	if (ret)
+		goto error;
+
+	iommu->devices = kobject_create_and_add("devices", &iommu->dev.kobj);
+	if (!iommu->devices) {
+		ret = -ENOMEM;
+		goto error;
+	}
+
+	/* devices holds ref */
+	put_device(&iommu->dev);
+
+	return 0;
+
+error:
+	pr_warn("Unable to register iommu device %s\n", name);
+	put_device(&iommu->dev);
+
+	return ret;
+}
+
+void iommu_unregister_device(void *platform_data)
+{
+	struct device *dev;
+	struct iommu_device *iommu;
+
+	dev = class_find_device(&iommu_class, NULL,
+				platform_data, __match_platform_data);
+	if (!dev)
+		return;
+
+	iommu = to_iommu_device(dev);
+	/* class_find_device gives us a new ref to put in device_unregister */
+	device_unregister(&iommu->dev);
+	kobject_put(iommu->devices);
+}
+
+int iommu_device_link(const void *platform_data, struct device *link)
+{
+	struct device *dev;
+	struct iommu_device *iommu;
+	int ret;
+
+	dev = class_find_device(&iommu_class, NULL,
+				platform_data, __match_platform_data);
+	if (!dev)
+		return -ENODEV;
+
+	iommu = to_iommu_device(dev);
+
+	ret = sysfs_create_link(&link->kobj, &dev->kobj, "iommu");
+	if (ret)
+		goto error;
+
+	ret = sysfs_create_link_nowarn(iommu->devices,
+				       &link->kobj, dev_name(link));
+	if (ret) {
+		sysfs_remove_link(&link->kobj, "iommu");
+		goto error;
+	}
+
+	kobject_get(iommu->devices);
+error:
+	put_device(dev);
+	return ret;
+}
+
+void iommu_device_unlink(const void *platform_data, struct device *link)
+{
+	struct device *dev;
+	struct iommu_device *iommu;
+
+	dev = class_find_device(&iommu_class, NULL,
+				platform_data, __match_platform_data);
+	if (!dev)
+		return;
+
+	iommu = to_iommu_device(dev);
+
+	sysfs_remove_link(iommu->devices, dev_name(link));
+	sysfs_remove_link(&link->kobj, "iommu");
+
+	kobject_put(iommu->devices);
+	put_device(dev);
+}
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index b96a5b2..e9bd3a0 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -186,6 +186,12 @@ extern int iommu_domain_get_attr(struct iommu_domain *domain, enum iommu_attr,
 				 void *data);
 extern int iommu_domain_set_attr(struct iommu_domain *domain, enum iommu_attr,
 				 void *data);
+extern int iommu_register_device(struct device *parent, const char *name,
+				 const struct attribute_group **groups,
+				 void *platform_data);
+extern void iommu_unregister_device(void *platform_data);
+extern int iommu_device_link(const void *platform_data, struct device *link);
+extern void iommu_device_unlink(const void *platform_data, struct device *link);
 
 /* Window handling function prototypes */
 extern int iommu_domain_window_enable(struct iommu_domain *domain, u32 wnd_nr,
@@ -396,6 +402,28 @@ static inline int iommu_domain_set_attr(struct iommu_domain *domain,
 	return -EINVAL;
 }
 
+static inline int iommu_register_device(struct device *parent, const char *name,
+					const struct attribute_group **groups,
+					void *platform_data)
+{
+	return 0;
+}
+
+static inline void iommu_unregister_device(void *platform_data)
+{
+}
+
+static inline int iommu_device_link(const void *platform_data,
+				    struct device *link)
+{
+	return 0;
+}
+
+static inline void iommu_device_unlink(const void *platform_data,
+				       struct device *link)
+{
+}
+
 #endif /* CONFIG_IOMMU_API */
 
 #endif /* __LINUX_IOMMU_H */

