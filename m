Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933AbaGWKyc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 06:54:32 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:60568 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932428AbaGWKyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 06:54:24 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 12/25] of: Provide a function to request and map memory
Date: Wed, 23 Jul 2014 12:53:54 +0200
Message-Id: <1406112847-26275-12-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406112847-26275-1-git-send-email-daniel.lezcano@linaro.org>
References: <53CF93B2.6040903@linaro.org>
 <1406112847-26275-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthias Brugger <matthias.bgg@gmail.com>

A call to of_iomap does not request the memory region. This patch adds the
function of_io_request_and_map which requests the memory region before
mapping it.

Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Suggested-by: Rob Herring <robh@kernel.org>
Acked-by: Rob Herring <robh@kernel.org>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/of/address.c       |   36 ++++++++++++++++++++++++++++++++++++
 include/linux/io.h         |    2 ++
 include/linux/of_address.h |   11 +++++++++++
 lib/devres.c               |    2 --
 4 files changed, 49 insertions(+), 2 deletions(-)

diff --git a/drivers/of/address.c b/drivers/of/address.c
index 5edfcb0..e371825 100644
--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -702,6 +702,42 @@ void __iomem *of_iomap(struct device_node *np, int index)
 }
 EXPORT_SYMBOL(of_iomap);
 
+/*
+ * of_io_request_and_map - Requests a resource and maps the memory mapped IO
+ *			   for a given device_node
+ * @device:	the device whose io range will be mapped
+ * @index:	index of the io range
+ * @name:	name of the resource
+ *
+ * Returns a pointer to the requested and mapped memory or an ERR_PTR() encoded
+ * error code on failure. Usage example:
+ *
+ *	base = of_io_request_and_map(node, 0, "foo");
+ *	if (IS_ERR(base))
+ *		return PTR_ERR(base);
+ */
+void __iomem *of_io_request_and_map(struct device_node *np, int index,
+					char *name)
+{
+	struct resource res;
+	void __iomem *mem;
+
+	if (of_address_to_resource(np, index, &res))
+		return IOMEM_ERR_PTR(-EINVAL);
+
+	if (!request_mem_region(res.start, resource_size(&res), name))
+		return IOMEM_ERR_PTR(-EBUSY);
+
+	mem = ioremap(res.start, resource_size(&res));
+	if (!mem) {
+		release_mem_region(res.start, resource_size(&res));
+		return IOMEM_ERR_PTR(-ENOMEM);
+	}
+
+	return mem;
+}
+EXPORT_SYMBOL(of_io_request_and_map);
+
 /**
  * of_dma_get_range - Get DMA range info
  * @np:		device node to get DMA range info
diff --git a/include/linux/io.h b/include/linux/io.h
index b76e6e5..d5fc9b8 100644
--- a/include/linux/io.h
+++ b/include/linux/io.h
@@ -58,6 +58,8 @@ static inline void devm_ioport_unmap(struct device *dev, void __iomem *addr)
 }
 #endif
 
+#define IOMEM_ERR_PTR(err) (__force void __iomem *)ERR_PTR(err)
+
 void __iomem *devm_ioremap(struct device *dev, resource_size_t offset,
 			    unsigned long size);
 void __iomem *devm_ioremap_nocache(struct device *dev, resource_size_t offset,
diff --git a/include/linux/of_address.h b/include/linux/of_address.h
index c13b878..fb7b722 100644
--- a/include/linux/of_address.h
+++ b/include/linux/of_address.h
@@ -109,7 +109,12 @@ static inline bool of_dma_is_coherent(struct device_node *np)
 extern int of_address_to_resource(struct device_node *dev, int index,
 				  struct resource *r);
 void __iomem *of_iomap(struct device_node *node, int index);
+void __iomem *of_io_request_and_map(struct device_node *device,
+					int index, char *name);
 #else
+
+#include <linux/io.h>
+
 static inline int of_address_to_resource(struct device_node *dev, int index,
 					 struct resource *r)
 {
@@ -120,6 +125,12 @@ static inline void __iomem *of_iomap(struct device_node *device, int index)
 {
 	return NULL;
 }
+
+static inline void __iomem *of_io_request_and_map(struct device_node *device,
+					int index, char *name)
+{
+	return IOMEM_ERR_PTR(-EINVAL);
+}
 #endif
 
 #if defined(CONFIG_OF_ADDRESS) && defined(CONFIG_PCI)
diff --git a/lib/devres.c b/lib/devres.c
index f562bf6..bb63248 100644
--- a/lib/devres.c
+++ b/lib/devres.c
@@ -86,8 +86,6 @@ void devm_iounmap(struct device *dev, void __iomem *addr)
 }
 EXPORT_SYMBOL(devm_iounmap);
 
-#define IOMEM_ERR_PTR(err) (__force void __iomem *)ERR_PTR(err)
-
 /**
  * devm_ioremap_resource() - check, request region, and ioremap resource
  * @dev: generic device to handle the resource for
-- 
1.7.9.5

