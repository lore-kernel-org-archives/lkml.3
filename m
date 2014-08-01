Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948AbaHAMPV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 08:15:21 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:63921 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbaHAMPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 08:15:18 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Tejun Heo <tj@kernel.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>, linux-pci@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] resource: Add device-managed request/release_resource()
Date: Fri,  1 Aug 2014 14:15:10 +0200
Message-Id: <1406895311-18869-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

Provide device-managed implementations of the request_resource() and
release_resource() functions. Upon failure to request a resource, the
new devm_request_resource() function will output an error message for
consistent error reporting.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
Changes in v2:
- use more natural flow for error handling
- don't needlessly check for NULL pointers

 Documentation/driver-model/devres.txt |  2 +
 include/linux/ioport.h                |  5 +++
 kernel/resource.c                     | 70 +++++++++++++++++++++++++++++++++++
 3 files changed, 77 insertions(+)

diff --git a/Documentation/driver-model/devres.txt b/Documentation/driver-model/devres.txt
index d14710b04439..befc3fe12ba6 100644
--- a/Documentation/driver-model/devres.txt
+++ b/Documentation/driver-model/devres.txt
@@ -264,8 +264,10 @@ IIO
 IO region
   devm_release_mem_region()
   devm_release_region()
+  devm_release_resource()
   devm_request_mem_region()
   devm_request_region()
+  devm_request_resource()
 
 IOMAP
   devm_ioport_map()
diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index 142ec544167c..2c5250222278 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -215,6 +215,11 @@ static inline int __deprecated check_region(resource_size_t s,
 
 /* Wrappers for managed devices */
 struct device;
+
+extern int devm_request_resource(struct device *dev, struct resource *root,
+				 struct resource *new);
+extern void devm_release_resource(struct device *dev, struct resource *new);
+
 #define devm_request_region(dev,start,n,name) \
 	__devm_request_region(dev, &ioport_resource, (start), (n), (name))
 #define devm_request_mem_region(dev,start,n,name) \
diff --git a/kernel/resource.c b/kernel/resource.c
index da14b8d09296..ca24f19f9d18 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -1248,6 +1248,76 @@ int release_mem_region_adjustable(struct resource *parent,
 /*
  * Managed region resource
  */
+static void devm_resource_release(struct device *dev, void *ptr)
+{
+	struct resource **r = ptr;
+
+	release_resource(*r);
+}
+
+/**
+ * devm_request_resource() - request and reserve an I/O or memory resource
+ * @dev: device for which to request the resource
+ * @root: root of the resource tree from which to request the resource
+ * @new: descriptor of the resource to request
+ *
+ * This is a device-managed version of request_resource(). There is usually
+ * no need to release resources requested by this function explicitly since
+ * that will be taken care of when the device is unbound from its driver.
+ * If for some reason the resource needs to be released explicitly, because
+ * of ordering issues for example, drivers must call devm_release_resource()
+ * rather than the regular release_resource().
+ *
+ * When a conflict is detected between any existing resources and the newly
+ * requested resource, an error message will be printed.
+ *
+ * Returns 0 on success or a negative error code on failure.
+ */
+int devm_request_resource(struct device *dev, struct resource *root,
+			  struct resource *new)
+{
+	struct resource *conflict, **ptr;
+
+	ptr = devres_alloc(devm_resource_release, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return -ENOMEM;
+
+	*ptr = new;
+
+	conflict = request_resource_conflict(root, new);
+	if (conflict) {
+		dev_err(dev, "resource collision: %pR conflicts with %s %pR\n",
+			new, conflict->name, conflict);
+		devres_free(ptr);
+		return -EBUSY;
+	}
+
+	devres_add(dev, ptr);
+	return 0;
+}
+EXPORT_SYMBOL(devm_request_resource);
+
+static int devm_resource_match(struct device *dev, void *res, void *data)
+{
+	struct resource **ptr = res;
+
+	return *ptr == data;
+}
+
+/**
+ * devm_release_resource() - release a previously requested resource
+ * @dev: device for which to release the resource
+ * @new: descriptor of the resource to release
+ *
+ * Releases a resource previously requested using devm_request_resource().
+ */
+void devm_release_resource(struct device *dev, struct resource *new)
+{
+	WARN_ON(devres_release(dev, devm_resource_release, devm_resource_match,
+			       new));
+}
+EXPORT_SYMBOL(devm_release_resource);
+
 struct region_devres {
 	struct resource *parent;
 	resource_size_t start;
-- 
2.0.3

