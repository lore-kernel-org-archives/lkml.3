Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934490AbaHZMQR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 08:16:17 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:30501 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754687AbaHZMNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 08:13:54 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-7f-53fc79ffca9d
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Michal Nazarewicz <mina86@mina86.com>,
        Grant Likely <grant.likely@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>, Laura Abbott <lauraa@codeaurora.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 2/7] drivers: of: add support for named memory regions
Date: Tue, 26 Aug 2014 14:09:43 +0200
Message-id: <1409054988-32758-3-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1409054988-32758-1-git-send-email-m.szyprowski@samsung.com>
References: <1409054988-32758-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNLMWRmVeSWpSXmKPExsVy+t/xa7r/K/8EGyx8IWDxd9IxdosDf3Yw
	Wqzsbmaz2LnuHaPF2aY37BbbO2ewW3y58pDJYtPja6wWl3fNYbPo2bCV1WLG+X1MFmuP3GW3
	WHC8hdVi/YzXLA58Hr9/TWL0uNzXy+TR9fYKk8eda3vYPDYvqfe4/e8xs8e6P6+YPPq2rGL0
	+LxJLoAzissmJTUnsyy1SN8ugStj0qke1oLT6hUL3rxkb2Dcr9DFyMkhIWAicXf7RyYIW0zi
	wr31bF2MXBxCAksZJY4uf8oC4fQxSSzffIcdpIpNwFCi620XG4gtIpAt8ePbZBYQm1lgKbPE
	vFlSILawgJvE72ldYPUsAqoSb5bvB6vhFfCQuHf8DxvENjmJ/y9XAG3m4OAU8JQ4N6UaJCwE
	VLJx+nuWCYy8CxgZVjGKppYmFxQnpeca6hUn5haX5qXrJefnbmKEBPCXHYyLj1kdYhTgYFTi
	4f1Q8jtYiDWxrLgy9xCjBAezkgjvj6Q/wUK8KYmVValF+fFFpTmpxYcYmTg4pRoYBXNf5bxY
	xFpxLedWp+ADz5ZNMSu/XfhwypP/6tlXxWeylv5kPi9v+fcF94v/EdlTjDdWCIccWVpT/SiA
	/6VV+XoZ6zk7zfs5zVZecpzkbKB5zemlUfxcsf5zRlJpJ5KX6zhMFw4/t/eU5uZrajqGS46w
	t9z7flahZ2FdV3i9lVHhiqtCHhVSSizFGYmGWsxFxYkAAa4p+D4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a code to initialize memory regions also for child devices
if parent device has "memory-region" and "memory-region-names" device tree
properties and given device's name matches "<parent_name>:<region_name>"
template.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 .../bindings/reserved-memory/reserved-memory.txt   |   6 +-
 drivers/of/of_reserved_mem.c                       | 101 ++++++++++++++-------
 2 files changed, 74 insertions(+), 33 deletions(-)

diff --git a/Documentation/devicetree/bindings/reserved-memory/reserved-memory.txt b/Documentation/devicetree/bindings/reserved-memory/reserved-memory.txt
index 3da0ebdba8d9..69d28288ed37 100644
--- a/Documentation/devicetree/bindings/reserved-memory/reserved-memory.txt
+++ b/Documentation/devicetree/bindings/reserved-memory/reserved-memory.txt
@@ -73,7 +73,11 @@ Device node references to reserved memory
 Regions in the /reserved-memory node may be referenced by other device
 nodes by adding a memory-region property to the device node.
 
-memory-region (optional) - phandle, specifier pairs to children of /reserved-memory
+memory-region (optional) - arrays of phandles, specifier pairs to children
+      of /reserved-memory, first phandle is used as a default memory
+      region
+memory-region-names (optional) - array of strings with names of memory
+      regions, used when more than one region has been defined
 
 Example
 -------
diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index 7e7de03585f9..3ab9446ffa43 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -237,32 +237,82 @@ static inline struct reserved_mem *__find_rmem(struct device_node *node)
 	return NULL;
 }
 
-/**
- * of_reserved_mem_device_init() - assign reserved memory region to given device
- *
- * This function assign memory region pointed by "memory-region" device tree
- * property to the given device.
- */
-int of_reserved_mem_device_init(struct device *dev)
+static int __rmem_dev_init(struct device *dev, struct device_node *np)
 {
-	struct reserved_mem *rmem;
-	struct device_node *np;
-
-	np = of_parse_phandle(dev->of_node, "memory-region", 0);
-	if (!np)
-		return;
-
-	rmem = __find_rmem(np);
-	of_node_put(np);
-
+	struct reserved_mem *rmem = __find_rmem(np);
 	if (!rmem || !rmem->ops || !rmem->ops->device_init)
-		return;
+		return -EINVAL;
 
 	rmem->ops->device_init(rmem, dev);
 	dev_info(dev, "assigned reserved memory node %s\n", rmem->name);
 	return 0;
 }
 
+static int __rmem_dev_release(struct device *dev, struct device_node *np)
+{
+	struct reserved_mem *rmem = __find_rmem(np);
+	if (!rmem || !rmem->ops)
+		return -EINVAL;
+
+	if (rmem->ops->device_release)
+		rmem->ops->device_release(rmem, dev);
+	return 0;
+}
+
+static int __rmem_dev_call(struct device *dev,
+			int (*func)(struct device *dev, struct device_node *np))
+{
+	int ret = -ENODEV;
+	if (of_get_property(dev->of_node, "memory-region", NULL)) {
+		struct device_node *np;
+		np = of_parse_phandle(dev->of_node, "memory-region", 0);
+		if (!np)
+			return -ENODEV;
+		ret = func(dev, np);
+		of_node_put(np);
+	} else if (dev->parent &&
+		   of_get_property(dev->parent->of_node, "memory-region",
+				   NULL)) {
+		struct device *parent = dev->parent;
+		struct device_node *np;
+		char *name;
+		int idx;
+
+		name = strrchr(dev_name(dev), ':');
+		if (!name)
+			return -ENODEV;
+		name++;
+
+		idx = of_property_match_string(parent->of_node,
+					       "memory-region-names", name);
+		if (idx < 0)
+			return -ENODEV;
+
+		np = of_parse_phandle(parent->of_node, "memory-region", idx);
+		if (!np)
+			return -ENODEV;
+
+		ret = func(dev, np);
+		of_node_put(np);
+	}
+	return ret;
+}
+
+/**
+ * of_reserved_mem_device_init() - assign reserved memory region to given device
+ *
+ * This function assigns default memory region pointed by first entry of
+ * "memory-region" device tree property (if available) to the given device or
+ * checks if the given device can be used to give access to named memory region
+ * if parent device has "memory-region" and "memory-region-names" device tree
+ * properties and given device's name matches "<parent_name>:<region_name>"
+ * template.
+ */
+int of_reserved_mem_device_init(struct device *dev)
+{
+	return __rmem_dev_call(dev, __rmem_dev_init);
+}
+
 /**
  * of_reserved_mem_device_release() - release reserved memory device structures
  *
@@ -271,18 +321,5 @@ int of_reserved_mem_device_init(struct device *dev)
  */
 void of_reserved_mem_device_release(struct device *dev)
 {
-	struct reserved_mem *rmem;
-	struct device_node *np;
-
-	np = of_parse_phandle(dev->of_node, "memory-region", 0);
-	if (!np)
-		return;
-
-	rmem = __find_rmem(np);
-	of_node_put(np);
-
-	if (!rmem || !rmem->ops || !rmem->ops->device_release)
-		return;
-
-	rmem->ops->device_release(rmem, dev);
+	__rmem_dev_call(dev, __rmem_dev_release);
 }
-- 
1.9.2

