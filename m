Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217AbaENVfO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 17:35:14 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:56547 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbaENVfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 17:35:11 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biederman <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        lxc-devel@lists.linuxcontainers.org,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [RFC PATCH 01/11] driver core: Assign owning user namespace to devices
Date: Wed, 14 May 2014 16:34:49 -0500
Message-Id: <1400103299-144589-2-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400103299-144589-1-git-send-email-seth.forshee@canonical.com>
References: <1400103299-144589-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds a member to struct device named ns to indicate the user
namespace which "owns" a device, which would generally indicate
that root in that namespace is priveleged toward the device. It
will also be used for future devtmpfs to determine which
namespace's mount the device will appear in. This defaults to
init_user_ns. An ns_global flag is also added to struct device,
which indicates the device should appear in all devtmpfs mounts.

Also adds a helper interface, dev_set_ns(), for changing the
namespace which a device has been assigned to.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/base/core.c    |  3 +++
 include/linux/device.h | 13 +++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 20da3ad1696b..1da05f1319fa 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -26,6 +26,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/netdevice.h>
 #include <linux/sysfs.h>
+#include <linux/user_namespace.h>
 
 #include "base.h"
 #include "power/power.h"
@@ -661,6 +662,7 @@ void device_initialize(struct device *dev)
 	INIT_LIST_HEAD(&dev->devres_head);
 	device_pm_init(dev);
 	set_dev_node(dev, -1);
+	dev->ns = get_user_ns(&init_user_ns);
 }
 EXPORT_SYMBOL_GPL(device_initialize);
 
@@ -1211,6 +1213,7 @@ void device_del(struct device *dev)
 	 */
 	if (platform_notify_remove)
 		platform_notify_remove(dev);
+	put_user_ns(dev->ns);
 	kobject_uevent(&dev->kobj, KOBJ_REMOVE);
 	cleanup_device_parent(dev);
 	kobject_del(&dev->kobj);
diff --git a/include/linux/device.h b/include/linux/device.h
index d1d1c055b48e..41a4ba33b13b 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -27,6 +27,7 @@
 #include <linux/ratelimit.h>
 #include <linux/uidgid.h>
 #include <linux/gfp.h>
+#include <linux/user_namespace.h>
 #include <asm/device.h>
 
 struct device;
@@ -704,9 +705,12 @@ struct acpi_dev_node {
  * 		gone away. This should be set by the allocator of the
  * 		device (i.e. the bus driver that discovered the device).
  * @iommu_group: IOMMU group the device belongs to.
+ * @ns:		User namespace which "owns" this device.
  *
  * @offline_disabled: If set, the device is permanently online.
  * @offline:	Set after successful invocation of bus type's .offline().
+ * @ns_global:	Set to make device appear in devtmpfs for all user
+ *		namespaces.
  *
  * At the lowest level, every device in a Linux system is represented by an
  * instance of struct device. The device structure contains the information
@@ -780,8 +784,11 @@ struct device {
 	void	(*release)(struct device *dev);
 	struct iommu_group	*iommu_group;
 
+	struct user_namespace	*ns;
+
 	bool			offline_disabled:1;
 	bool			offline:1;
+	bool			ns_global:1;
 };
 
 static inline struct device *kobj_to_dev(struct kobject *kobj)
@@ -804,6 +811,12 @@ static inline const char *dev_name(const struct device *dev)
 extern __printf(2, 3)
 int dev_set_name(struct device *dev, const char *name, ...);
 
+static inline void dev_set_ns(struct device *dev, struct user_namespace *ns)
+{
+	put_user_ns(dev->ns);
+	dev->ns = get_user_ns(ns);
+}
+
 #ifdef CONFIG_NUMA
 static inline int dev_to_node(struct device *dev)
 {
-- 
1.9.1

