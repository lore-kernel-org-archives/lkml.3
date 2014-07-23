Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758600AbaGWXoj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 19:44:39 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:47955 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758541AbaGWXof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 19:44:35 -0400
From: Grant Likely <grant.likely@linaro.org>
To: linux-kernel@vger.kernel.org, Nathan Fontenot <nfont@austin.ibm.com>,
        Tyrel Datwyler <turtle.in.the.kernel@gmail.com>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>
Subject: [PATCH 01/10] of/platform: Fix of_platform_device_destroy iteration of devices
Date: Wed, 23 Jul 2014 17:44:15 -0600
Message-Id: <1406159064-21366-2-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406159064-21366-1-git-send-email-grant.likely@linaro.org>
References: <1406159064-21366-1-git-send-email-grant.likely@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_platform_destroy does not work properly, since the tree
population test was iterating on all devices having as its parent
the given platform device.

The check was intended to check whether any other platform or amba
devices created by of_platform_populate were still populated, but
instead checked for every kind of device. This is wrong, since platform
devices typically create a subsystem regular device and set themselves
as parents.

Instead, go ahead and call the unregister functions for any devices
created with of_platform_populate. The driver core will take care of
unbinding drivers, and drivers are responsible for getting rid of any
child devices that weren't created by of_platform_populate.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
---
 drivers/of/platform.c       | 32 +++++++++-----------------------
 include/linux/of.h          |  1 +
 include/linux/of_platform.h |  7 ++-----
 3 files changed, 12 insertions(+), 28 deletions(-)

diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 500436f9be7f..0197725e033a 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -422,6 +422,7 @@ static int of_platform_bus_create(struct device_node *bus,
 			break;
 		}
 	}
+	of_node_set_flag(bus, OF_POPULATED_BUS);
 	return rc;
 }
 
@@ -508,19 +509,13 @@ EXPORT_SYMBOL_GPL(of_platform_populate);
 
 static int of_platform_device_destroy(struct device *dev, void *data)
 {
-	bool *children_left = data;
-
 	/* Do not touch devices not populated from the device tree */
-	if (!dev->of_node || !of_node_check_flag(dev->of_node, OF_POPULATED)) {
-		*children_left = true;
+	if (!dev->of_node || !of_node_check_flag(dev->of_node, OF_POPULATED))
 		return 0;
-	}
 
-	/* Recurse, but don't touch this device if it has any children left */
-	if (of_platform_depopulate(dev) != 0) {
-		*children_left = true;
-		return 0;
-	}
+	/* Recurse for any nodes that were treated as busses */
+	if (of_node_check_flag(dev->of_node, OF_POPULATED_BUS))
+		device_for_each_child(dev, NULL, of_platform_device_destroy);
 
 	if (dev->bus == &platform_bus_type)
 		platform_device_unregister(to_platform_device(dev));
@@ -528,19 +523,15 @@ static int of_platform_device_destroy(struct device *dev, void *data)
 	else if (dev->bus == &amba_bustype)
 		amba_device_unregister(to_amba_device(dev));
 #endif
-	else {
-		*children_left = true;
-		return 0;
-	}
 
 	of_node_clear_flag(dev->of_node, OF_POPULATED);
-
+	of_node_clear_flag(dev->of_node, OF_POPULATED_BUS);
 	return 0;
 }
 
 /**
  * of_platform_depopulate() - Remove devices populated from device tree
- * @parent: device which childred will be removed
+ * @parent: device which children will be removed
  *
  * Complementary to of_platform_populate(), this function removes children
  * of the given device (and, recurrently, their children) that have been
@@ -550,14 +541,9 @@ static int of_platform_device_destroy(struct device *dev, void *data)
  * Returns 0 when all children devices have been removed or
  * -EBUSY when some children remained.
  */
-int of_platform_depopulate(struct device *parent)
+void of_platform_depopulate(struct device *parent)
 {
-	bool children_left = false;
-
-	device_for_each_child(parent, &children_left,
-			      of_platform_device_destroy);
-
-	return children_left ? -EBUSY : 0;
+	device_for_each_child(parent, NULL, of_platform_device_destroy);
 }
 EXPORT_SYMBOL_GPL(of_platform_depopulate);
 
diff --git a/include/linux/of.h b/include/linux/of.h
index 196b34c1ef4e..abf829a1f150 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -204,6 +204,7 @@ static inline unsigned long of_read_ulong(const __be32 *cell, int size)
 #define OF_DYNAMIC	1 /* node and properties were allocated via kmalloc */
 #define OF_DETACHED	2 /* node has been detached from the device tree */
 #define OF_POPULATED	3 /* device already created for the node */
+#define OF_POPULATED_BUS	4 /* of_platform_populate recursed to children of this node */
 
 #define OF_IS_DYNAMIC(x) test_bit(OF_DYNAMIC, &x->_flags)
 #define OF_MARK_DYNAMIC(x) set_bit(OF_DYNAMIC, &x->_flags)
diff --git a/include/linux/of_platform.h b/include/linux/of_platform.h
index d96e1badbee0..c2b0627a2317 100644
--- a/include/linux/of_platform.h
+++ b/include/linux/of_platform.h
@@ -72,7 +72,7 @@ extern int of_platform_populate(struct device_node *root,
 				const struct of_device_id *matches,
 				const struct of_dev_auxdata *lookup,
 				struct device *parent);
-extern int of_platform_depopulate(struct device *parent);
+extern void of_platform_depopulate(struct device *parent);
 #else
 static inline int of_platform_populate(struct device_node *root,
 					const struct of_device_id *matches,
@@ -81,10 +81,7 @@ static inline int of_platform_populate(struct device_node *root,
 {
 	return -ENODEV;
 }
-static inline int of_platform_depopulate(struct device *parent)
-{
-	return -ENODEV;
-}
+static inline void of_platform_depopulate(struct device *parent) { }
 #endif
 
 #endif	/* _LINUX_OF_PLATFORM_H */
-- 
1.9.1

