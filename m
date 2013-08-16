Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab3HPWWB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:22:01 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:41304 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239Ab3HPWV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:21:59 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC 2/4] driver core: Allow early registration of devices
Date: Fri, 16 Aug 2013 22:39:21 +0200
Message-Id: <1376685563-1053-3-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1376685563-1053-1-git-send-email-treding@nvidia.com>
References: <1376685563-1053-1-git-send-email-treding@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Systems that boot from the devicetree currently have to rely on hacks or
workarounds to setup devices such as interrupt controllers early because
no (platform) device is available yet. This introduces inconsistencies
in the way that these drivers have to be written and precludes them from
using APIs (such as regmap or device logging functions) that rely on a
struct device being available.

This patch is an attempt at rectifying this by allowing devices to be
registered early. Early in this case means sometime after kmalloc() can
be used but before sysfs has been setup. The latter is important because
a large part of the device registration is hooking the device up with
sysfs. Since sysfs becomes available rather late in the boot process,
devices added early will be temporarily added to a list and not hooked
up to sysfs.

Once sysfs is up (or more precisely within driver_init()), the list of
early devices is processed to fully register the devices

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/base/base.h |   3 ++
 drivers/base/core.c | 107 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/base/init.c |   2 +
 3 files changed, 112 insertions(+)

diff --git a/drivers/base/base.h b/drivers/base/base.h
index 77e0722..bf33d2e 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -76,6 +76,7 @@ struct device_private {
 	struct klist_node knode_driver;
 	struct klist_node knode_bus;
 	struct list_head deferred_probe;
+	struct list_head early;
 	void *driver_data;
 	struct device *device;
 };
@@ -98,6 +99,8 @@ extern int hypervisor_init(void);
 #else
 static inline int hypervisor_init(void) { return 0; }
 #endif
+extern int device_early_init(void);
+extern int device_early_done(void);
 extern int platform_bus_init(void);
 #ifdef CONFIG_SOC_BUS
 extern int soc_bus_init(void);
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 09a99d6..cb240a7 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -20,6 +20,7 @@
 #include <linux/notifier.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
+#include <linux/of_irq.h>
 #include <linux/genhd.h>
 #include <linux/kallsyms.h>
 #include <linux/mutex.h>
@@ -1020,6 +1021,102 @@ int device_private_init(struct device *dev)
 	klist_init(&dev->p->klist_children, klist_children_get,
 		   klist_children_put);
 	INIT_LIST_HEAD(&dev->p->deferred_probe);
+	INIT_LIST_HEAD(&dev->p->early);
+	return 0;
+}
+
+/*
+ * Early device registration support
+ *
+ * Some devices such as interrupt controllers need to be available very
+ * early in the boot process. One of the bigger issues is that a lot of
+ * the device registration code relies on sysfs having been initialized
+ * in order to construct proper entries. However that has not completed
+ * yet this early, so we initialize only the very minimal fields of the
+ * device early and defer full initialization (including creating sysfs
+ * directories and links) until later.
+ */
+static DEFINE_MUTEX(device_early_mutex);
+static LIST_HEAD(device_early_list);
+static bool device_is_early = true;
+
+/*
+ * Keep a list of early registered devices so that they can be fully
+ * registered at a later point in time.
+ */
+static void device_early_add(struct device *dev)
+{
+	mutex_lock(&device_early_mutex);
+	list_add_tail(&dev->p->early, &device_early_list);
+	mutex_unlock(&device_early_mutex);
+}
+
+/*
+ * Mark the early device registration phase as completed.
+ */
+int __init device_early_init(void)
+{
+	device_is_early = false;
+
+	return 0;
+}
+
+/*
+ * Fixup platform devices instantiated from device tree. The problem is
+ * that since early registration happens before interrupt controllers
+ * have been setup, the OF core code won't know how to map interrupts.
+ */
+int __init platform_device_early_fixup(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	unsigned int num_reg, num_irq, num;
+	struct resource *res;
+	int err;
+
+	num_reg = pdev->num_resources;
+	num_irq = of_irq_count(np);
+	num = num_reg + num_irq;
+
+	res = krealloc(pdev->resource, sizeof(*res) * num, GFP_KERNEL);
+	if (!res)
+		return -ENOMEM;
+
+	err = of_irq_to_resource_table(np, res + num_reg, num_irq);
+	if (err != num_irq)
+		return -EINVAL;
+
+	pdev->num_resources = num_reg + num_irq;
+	pdev->resource = res;
+
+	return 0;
+}
+
+/*
+ * Fully register early devices.
+ */
+int __init device_early_done(void)
+{
+	struct device_private *private;
+
+	list_for_each_entry(private, &device_early_list, early) {
+		struct device *dev = private->device;
+		int err;
+
+		if (dev->bus == &platform_bus_type) {
+			struct platform_device *pdev = to_platform_device(dev);
+
+			err = platform_device_early_fixup(pdev);
+			if (err < 0)
+				dev_err(&pdev->dev,
+					"failed to fixup device %s: %d\n",
+					dev_name(&pdev->dev), err);
+		}
+
+		err = device_add(dev);
+		if (err < 0)
+			pr_err("failed to add device %s\n", dev_name(dev));
+	}
+
 	return 0;
 }
 
@@ -1063,6 +1160,16 @@ int device_add(struct device *dev)
 	}
 
 	/*
+	 * If the device is registered early, defer everything below to a
+	 * later point in time where sysfs has been properly initialized.
+	 */
+	if (device_is_early) {
+		device_early_add(dev);
+		put_device(dev);
+		return 0;
+	}
+
+	/*
 	 * for statically allocated devices, which should all be converted
 	 * some day, we need to initialize the name. We prevent reading back
 	 * the name, and force the use of dev_name()
diff --git a/drivers/base/init.c b/drivers/base/init.c
index a4c4090..caa1c43 100644
--- a/drivers/base/init.c
+++ b/drivers/base/init.c
@@ -30,8 +30,10 @@ void __init driver_init(void)
 	/* These are also core pieces, but must come after the
 	 * core core pieces.
 	 */
+	device_early_init();
 	platform_bus_init();
 	soc_bus_init();
+	device_early_done();
 	cpu_dev_init();
 	memory_dev_init();
 }
-- 
1.8.3.4

