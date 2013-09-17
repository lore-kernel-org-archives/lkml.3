Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918Ab3IQMoA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 08:44:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48751 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872Ab3IQMn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 08:43:56 -0400
From: Russ Dill <Russ.Dill@ti.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        mans@mansr.com, Shawn Guo <shawn.guo@linaro.org>,
        Dave Martin <Dave.Martin@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [RFC PATCH 02/11] lib: devres: Add exec versions of devm_ioremap_resource and friends
Date: Tue, 17 Sep 2013 05:43:28 -0700
Message-Id: <1379421817-15759-3-git-send-email-Russ.Dill@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1379421817-15759-1-git-send-email-Russ.Dill@ti.com>
References: <1379421817-15759-1-git-send-email-Russ.Dill@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that there is an _exec version of ioremap, add devm support for it.

Signed-off-by: Russ Dill <Russ.Dill@ti.com>
---
 include/linux/device.h | 17 ++++++++-
 include/linux/io.h     |  4 +++
 lib/devres.c           | 97 ++++++++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 114 insertions(+), 4 deletions(-)

diff --git a/include/linux/device.h b/include/linux/device.h
index 22b546a..204180a 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -596,10 +596,25 @@ extern int devres_release_group(struct device *dev, void *id);
 extern void *devm_kzalloc(struct device *dev, size_t size, gfp_t gfp);
 extern void devm_kfree(struct device *dev, void *p);
 
-void __iomem *devm_ioremap_resource(struct device *dev, struct resource *res);
+void __iomem *__devm_ioremap_resource(struct device *dev, struct resource *res,
+				     bool exec);
+static inline void __iomem *devm_ioremap_resource(struct device *dev,
+						  struct resource *res)
+{
+	return __devm_ioremap_resource(dev, res, false);
+}
 void __iomem *devm_request_and_ioremap(struct device *dev,
 			struct resource *res);
 
+static inline void __iomem *devm_ioremap_exec_resource(struct device *dev,
+						       struct resource *res)
+{
+	return __devm_ioremap_resource(dev, res, true);
+}
+
+void __iomem *devm_request_and_ioremap_exec(struct device *dev,
+			struct resource *res);
+
 /* allows to add/remove a custom action to devres stack */
 int devm_add_action(struct device *dev, void (*action)(void *), void *data);
 void devm_remove_action(struct device *dev, void (*action)(void *), void *data);
diff --git a/include/linux/io.h b/include/linux/io.h
index f4f42fa..582b207 100644
--- a/include/linux/io.h
+++ b/include/linux/io.h
@@ -62,6 +62,10 @@ void __iomem *devm_ioremap(struct device *dev, resource_size_t offset,
 			    unsigned long size);
 void __iomem *devm_ioremap_nocache(struct device *dev, resource_size_t offset,
 				    unsigned long size);
+void __iomem *devm_ioremap_exec(struct device *dev, resource_size_t offset,
+			    unsigned long size);
+void __iomem *devm_ioremap_exec_nocache(struct device *dev, resource_size_t offset,
+				    unsigned long size);
 void devm_iounmap(struct device *dev, void __iomem *addr);
 int check_signature(const volatile void __iomem *io_addr,
 			const unsigned char *signature, int length);
diff --git a/lib/devres.c b/lib/devres.c
index 8235331..06cafe5 100644
--- a/lib/devres.c
+++ b/lib/devres.c
@@ -72,6 +72,64 @@ void __iomem *devm_ioremap_nocache(struct device *dev, resource_size_t offset,
 EXPORT_SYMBOL(devm_ioremap_nocache);
 
 /**
+ * devm_ioremap_exec - Managed ioremap_exec()
+ * @dev: Generic device to remap IO address for
+ * @offset: BUS offset to map
+ * @size: Size of map
+ *
+ * Managed ioremap_exec().  Map is automatically unmapped on driver detach.
+ */
+void __iomem *devm_ioremap_exec(struct device *dev, resource_size_t offset,
+				unsigned long size)
+{
+	void __iomem **ptr, *addr;
+
+	ptr = devres_alloc(devm_ioremap_release, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return NULL;
+
+	addr = ioremap_exec(offset, size);
+	if (addr) {
+		*ptr = addr;
+		devres_add(dev, ptr);
+	} else
+		devres_free(ptr);
+
+	return addr;
+}
+EXPORT_SYMBOL(devm_ioremap_exec);
+
+/**
+ * devm_ioremap_exec_nocache - Managed ioremap_exec_nocache()
+ * @dev: Generic device to remap IO address for
+ * @offset: BUS offset to map
+ * @size: Size of map
+ *
+ * Managed ioremap_exec_nocache().  Map is automatically unmapped on driver
+ * detach.
+ */
+void __iomem *devm_ioremap_exec_nocache(struct device *dev,
+					resource_size_t offset,
+					unsigned long size)
+{
+	void __iomem **ptr, *addr;
+
+	ptr = devres_alloc(devm_ioremap_release, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return NULL;
+
+	addr = ioremap_exec_nocache(offset, size);
+	if (addr) {
+		*ptr = addr;
+		devres_add(dev, ptr);
+	} else
+		devres_free(ptr);
+
+	return addr;
+}
+EXPORT_SYMBOL(devm_ioremap_exec_nocache);
+
+/**
  * devm_iounmap - Managed iounmap()
  * @dev: Generic device to unmap for
  * @addr: Address to unmap
@@ -104,7 +162,8 @@ EXPORT_SYMBOL(devm_iounmap);
  *	if (IS_ERR(base))
  *		return PTR_ERR(base);
  */
-void __iomem *devm_ioremap_resource(struct device *dev, struct resource *res)
+void __iomem *__devm_ioremap_resource(struct device *dev, struct resource *res,
+				      bool exec)
 {
 	resource_size_t size;
 	const char *name;
@@ -125,7 +184,11 @@ void __iomem *devm_ioremap_resource(struct device *dev, struct resource *res)
 		return ERR_PTR(-EBUSY);
 	}
 
-	if (res->flags & IORESOURCE_CACHEABLE)
+	if (exec && res->flags & IORESOURCE_CACHEABLE)
+		dest_ptr = devm_ioremap_exec(dev, res->start, size);
+	else if (exec)
+		dest_ptr = devm_ioremap_exec_nocache(dev, res->start, size);
+	else if (res->flags & IORESOURCE_CACHEABLE)
 		dest_ptr = devm_ioremap(dev, res->start, size);
 	else
 		dest_ptr = devm_ioremap_nocache(dev, res->start, size);
@@ -138,7 +201,7 @@ void __iomem *devm_ioremap_resource(struct device *dev, struct resource *res)
 
 	return dest_ptr;
 }
-EXPORT_SYMBOL(devm_ioremap_resource);
+EXPORT_SYMBOL(__devm_ioremap_resource);
 
 /**
  * devm_request_and_ioremap() - Check, request region, and ioremap resource
@@ -168,6 +231,34 @@ void __iomem *devm_request_and_ioremap(struct device *device,
 }
 EXPORT_SYMBOL(devm_request_and_ioremap);
 
+/**
+ * devm_request_and_ioremap_exec() - Check, request region, and ioremap resource
+ * @dev: Generic device to handle the resource for
+ * @res: resource to be handled
+ *
+ * Takes all necessary steps to ioremap a mem resource. Uses managed device, so
+ * everything is undone on driver detach. Checks arguments, so you can feed
+ * it the result from e.g. platform_get_resource() directly. Returns the
+ * remapped pointer or NULL on error. Usage example:
+ *
+ *	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+ *	base = devm_request_and_ioremap_exec(&pdev->dev, res);
+ *	if (!base)
+ *		return -EADDRNOTAVAIL;
+ */
+void __iomem *devm_request_and_ioremap_exec(struct device *device,
+					    struct resource *res)
+{
+	void __iomem *dest_ptr;
+
+	dest_ptr = devm_ioremap_exec_resource(device, res);
+	if (IS_ERR(dest_ptr))
+		return NULL;
+
+	return dest_ptr;
+}
+EXPORT_SYMBOL(devm_request_and_ioremap_exec);
+
 #ifdef CONFIG_HAS_IOPORT
 /*
  * Generic iomap devres
-- 
1.8.3.2

