Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbbABTqO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 14:46:14 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:42741 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569AbbABTqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 14:46:13 -0500
From: Dave Gerlach <d-gerlach@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
CC: Ohad Ben-Cohen <ohad@wizery.com>, Suman Anna <s-anna@ti.com>,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        Dave Gerlach <d-gerlach@ti.com>
Subject: [PATCH] remoteproc: Introduce rproc_get_by_phandle API
Date: Fri, 2 Jan 2015 13:45:21 -0600
Message-ID: <1420227921-40853-1-git-send-email-d-gerlach@ti.com>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow users of remoteproc the ability to get a handle to an rproc by
passing a phandle supplied in the user's device tree node. This is
useful in situations that require manual booting of the rproc.

This patch uses the code removed by commit 40e575b1d0b3 ("remoteproc:
remove the get_by_name/put API") for the ref counting a rproc klist
code but has rproc_get_by_name replaced with an rproc_get_by_phandle API.

Signed-off-by: Dave Gerlach <d-gerlach@ti.com>
---
 Documentation/remoteproc.txt         |  6 +++
 drivers/remoteproc/remoteproc_core.c | 85 ++++++++++++++++++++++++++++++++++++
 include/linux/remoteproc.h           |  1 +
 3 files changed, 92 insertions(+)

diff --git a/Documentation/remoteproc.txt b/Documentation/remoteproc.txt
index e6469fd..81b5240 100644
--- a/Documentation/remoteproc.txt
+++ b/Documentation/remoteproc.txt
@@ -51,6 +51,12 @@ cost.
         rproc_shutdown() returns, and users can still use it with a subsequent
         rproc_boot(), if needed.
 
+  struct rproc *rproc_get_by_phandle(const char *name)
+    - Find an rproc handle using a device tree phandle. Returns the rproc
+      handle on success, and NULL on failure. This function increments
+      the remote processor's refcount, so always use rproc_put() to
+      decrement it back once rproc isn't needed anymore.
+
 3. Typical usage
 
 #include <linux/remoteproc.h>
diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index e2bd869..6b78ba4 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -27,6 +27,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/device.h>
+#include <linux/of.h>
 #include <linux/slab.h>
 #include <linux/mutex.h>
 #include <linux/dma-mapping.h>
@@ -36,6 +37,7 @@
 #include <linux/remoteproc.h>
 #include <linux/iommu.h>
 #include <linux/idr.h>
+#include <linux/klist.h>
 #include <linux/elf.h>
 #include <linux/crc32.h>
 #include <linux/virtio_ids.h>
@@ -44,6 +46,17 @@
 
 #include "remoteproc_internal.h"
 
+static void klist_rproc_get(struct klist_node *n);
+static void klist_rproc_put(struct klist_node *n);
+
+/*
+ * klist of the available remote processors.
+ *
+ * We need this in order to support rproc lookups (needed by the
+ * rproc_get_by_phandle()).
+ */
+static DEFINE_KLIST(rprocs, klist_rproc_get, klist_rproc_put);
+
 typedef int (*rproc_handle_resources_t)(struct rproc *rproc,
 				struct resource_table *table, int len);
 typedef int (*rproc_handle_resource_t)(struct rproc *rproc,
@@ -1234,6 +1247,72 @@ out:
 }
 EXPORT_SYMBOL(rproc_shutdown);
 
+/* will be called when an rproc is added to the rprocs klist */
+static void klist_rproc_get(struct klist_node *n)
+{
+	struct rproc *rproc = container_of(n, struct rproc, node);
+
+	get_device(&rproc->dev);
+}
+
+/* will be called when an rproc is removed from the rprocs klist */
+static void klist_rproc_put(struct klist_node *n)
+{
+	struct rproc *rproc = container_of(n, struct rproc, node);
+
+	put_device(&rproc->dev);
+}
+
+static struct rproc *next_rproc(struct klist_iter *i)
+{
+	struct klist_node *n;
+
+	n = klist_next(i);
+	if (!n)
+		return NULL;
+
+	return container_of(n, struct rproc, node);
+}
+
+/**
+ * rproc_get_by_phandle() - find a remote processor by phandle and boot it
+ * @phandle: phandle to the rproc
+ *
+ * Finds an rproc handle using the remote processor's phandle, and then
+ * boot it. If it's already powered on, then just immediately return
+ * (successfully).
+ *
+ * Returns the rproc handle on success, and NULL on failure.
+ *
+ * This function increments the remote processor's refcount, so always
+ * use rproc_put() to decrement it back once rproc isn't needed anymore.
+ *
+ * Note: currently this function (and its counterpart rproc_put()) are not
+ * being used. We need to scrutinize the use cases
+ * that still need them, and see if we can migrate them to use the non
+ * name-based boot/shutdown interface.
+ */
+struct rproc *rproc_get_by_phandle(uint32_t phandle)
+{
+	struct rproc *rproc;
+	struct klist_iter i;
+	struct device_node *np;
+
+	np = of_find_node_by_phandle(phandle);
+
+	/* find the remote processor, and upref its refcount */
+	klist_iter_init(&rprocs, &i);
+	while ((rproc = next_rproc(&i)) != NULL)
+		if (rproc->dev.parent && rproc->dev.parent->of_node == np) {
+			get_device(&rproc->dev);
+			break;
+		}
+	klist_iter_exit(&i);
+
+	return rproc;
+}
+EXPORT_SYMBOL(rproc_get_by_phandle);
+
 /**
  * rproc_add() - register a remote processor
  * @rproc: the remote processor handle to register
@@ -1263,6 +1342,9 @@ int rproc_add(struct rproc *rproc)
 	if (ret < 0)
 		return ret;
 
+	/* expose to rproc_get_by_phandle users */
+	klist_add_tail(&rproc->node, &rprocs);
+
 	dev_info(dev, "%s is available\n", rproc->name);
 
 	dev_info(dev, "Note: remoteproc is still under development and considered experimental.\n");
@@ -1452,6 +1534,9 @@ int rproc_del(struct rproc *rproc)
 	/* Free the copy of the resource table */
 	kfree(rproc->cached_table);
 
+	/* the rproc is downref'ed as soon as it's removed from the klist */
+	klist_del(&rproc->node);
+
 	device_del(&rproc->dev);
 
 	return 0;
diff --git a/include/linux/remoteproc.h b/include/linux/remoteproc.h
index 2a25ee8..9bf7b52 100644
--- a/include/linux/remoteproc.h
+++ b/include/linux/remoteproc.h
@@ -522,6 +522,7 @@ struct rproc_vdev {
 	u32 rsc_offset;
 };
 
+struct rproc *rproc_get_by_phandle(uint32_t phandle);
 struct rproc *rproc_alloc(struct device *dev, const char *name,
 				const struct rproc_ops *ops,
 				const char *firmware, int len);
-- 
2.1.0

