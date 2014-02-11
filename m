Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392AbaBKQxu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 11:53:50 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:20716 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752216AbaBKQxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 11:53:46 -0500
From: Pawel Moll <pawel.moll@arm.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, lm-sensors@lm-sensors.org, arm@kernel.org
Cc: Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mike Turquette <mturquette@linaro.org>,
        Jean Delvare <jdelvare@suse.de>, Guenter Roeck <linux@roeck-us.net>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>
Subject: [PATCH 1/3] driver core & of: Mark of_nodes of added device as populated
Date: Tue, 11 Feb 2014 16:53:28 +0000
Message-Id: <1392137610-27842-2-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392137610-27842-1-git-send-email-pawel.moll@arm.com>
References: <1392137610-27842-1-git-send-email-pawel.moll@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In "Device Tree powered" systems, platform devices are usually
massively populated with of_platform_populate() call, executed
at some level of initcalls, either by generic architecture
or by platform-specific code.

There are situations though where certain devices must be
created (and bound with drivers) before all the others.
This presents small challenge in DT-driven systems, as
devices explicitly created in early code would be created
again by of_platform_populate().

This patch tries to solve that issue in a generic way,
adding a "populated" flag which is set in the device_node
structure when a device is being created in the core.
Later, of_platform_populate() skips such nodes (and
its children) in a similar way to the non-available ones.

Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---
 drivers/base/core.c       |  4 ++++
 drivers/of/device.c       | 16 ++++++++++++++++
 drivers/of/platform.c     |  6 ++++--
 include/linux/of.h        |  6 ++++++
 include/linux/of_device.h | 11 +++++++++++
 5 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 2b56717..588c9a6 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1088,6 +1088,8 @@ int device_add(struct device *dev)
 				class_intf->add_dev(dev, class_intf);
 		mutex_unlock(&dev->class->p->mutex);
 	}
+
+	of_device_populate(dev);
 done:
 	put_device(dev);
 	return error;
@@ -1190,6 +1192,8 @@ void device_del(struct device *dev)
 	struct device *parent = dev->parent;
 	struct class_interface *class_intf;
 
+	of_device_depopulate(dev);
+
 	/* Notify clients of device removal.  This call must come
 	 * before dpm_sysfs_remove().
 	 */
diff --git a/drivers/of/device.c b/drivers/of/device.c
index dafb973..3b31144 100644
--- a/drivers/of/device.c
+++ b/drivers/of/device.c
@@ -190,3 +190,19 @@ int of_device_uevent_modalias(struct device *dev, struct kobj_uevent_env *env)
 
 	return 0;
 }
+
+void of_device_populate(struct device *dev)
+{
+	if ((!dev) || (!dev->of_node))
+		return;
+
+	of_node_set_flag(dev->of_node, OF_POPULATED);
+}
+
+void of_device_depopulate(struct device *dev)
+{
+	if ((!dev) || (!dev->of_node))
+		return;
+
+	of_node_clear_flag(dev->of_node, OF_POPULATED);
+}
diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 404d1da..ad43ee0 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -204,7 +204,8 @@ static struct platform_device *of_platform_device_create_pdata(
 {
 	struct platform_device *dev;
 
-	if (!of_device_is_available(np))
+	if (!of_device_is_available(np) ||
+			of_node_check_flag(np, OF_POPULATED))
 		return NULL;
 
 	dev = of_device_alloc(np, bus_id, parent);
@@ -262,7 +263,8 @@ static struct amba_device *of_amba_device_create(struct device_node *node,
 
 	pr_debug("Creating amba device %s\n", node->full_name);
 
-	if (!of_device_is_available(node))
+	if (!of_device_is_available(node) ||
+			of_node_check_flag(node, OF_POPULATED))
 		return NULL;
 
 	dev = amba_device_alloc(NULL, 0, 0);
diff --git a/include/linux/of.h b/include/linux/of.h
index 70c64ba..caf7b8a 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -114,6 +114,11 @@ static inline void of_node_set_flag(struct device_node *n, unsigned long flag)
 	set_bit(flag, &n->_flags);
 }
 
+static inline void of_node_clear_flag(struct device_node *n, unsigned long flag)
+{
+	clear_bit(flag, &n->_flags);
+}
+
 extern struct device_node *of_find_all_nodes(struct device_node *prev);
 
 /*
@@ -156,6 +161,7 @@ static inline unsigned long of_read_ulong(const __be32 *cell, int size)
 /* flag descriptions */
 #define OF_DYNAMIC	1 /* node and properties were allocated via kmalloc */
 #define OF_DETACHED	2 /* node has been detached from the device tree */
+#define OF_POPULATED	3 /* device already created for the node */
 
 #define OF_IS_DYNAMIC(x) test_bit(OF_DYNAMIC, &x->_flags)
 #define OF_MARK_DYNAMIC(x) set_bit(OF_DYNAMIC, &x->_flags)
diff --git a/include/linux/of_device.h b/include/linux/of_device.h
index 8d7dd67..513e598 100644
--- a/include/linux/of_device.h
+++ b/include/linux/of_device.h
@@ -44,6 +44,9 @@ static inline void of_device_node_put(struct device *dev)
 	of_node_put(dev->of_node);
 }
 
+extern void of_device_populate(struct device *dev);
+extern void of_device_depopulate(struct device *dev);
+
 static inline struct device_node *of_cpu_device_node_get(int cpu)
 {
 	struct device *cpu_dev;
@@ -84,6 +87,14 @@ static inline const struct of_device_id *of_match_device(
 	return NULL;
 }
 
+static inline void of_device_populate(struct device *dev)
+{
+}
+
+static inline void of_device_depopulate(struct device *dev)
+{
+}
+
 static inline struct device_node *of_cpu_device_node_get(int cpu)
 {
 	return NULL;
-- 
1.8.3.2

