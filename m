Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964796AbaEQMWx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 08:22:53 -0400
Received: from si-002-i53.relay.mailchannels.net ([184.154.112.227]:25992 "EHLO
	relay.mailchannels.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932361AbaEQMWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 08:22:52 -0400
X-Sender-Id: totalchoicehosting|x-authuser|billaue
X-Sender-Id: totalchoicehosting|x-authuser|billaue
X-MC-Relay: Neutral
X-MailChannels-SenderId: totalchoicehosting%7Cx-authuser%7Cbillaue
X-MailChannels-Auth-Id: totalchoicehosting
From: Eli Billauer <eli.billauer@gmail.com>
To: tj@kernel.org
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        bhelgaas@google.com, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Eli Billauer <eli.billauer@gmail.com>
Subject: [PATCH 1/3] dma-mapping: Add devm_ interface for dma_map_single()
Date: Sat, 17 May 2014 15:22:23 +0300
Message-Id: <1400329345-15556-1-git-send-email-eli.billauer@gmail.com>
X-Mailer: git-send-email 1.7.2.3
X-AuthUser: billaue
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dmam_map_single() and dmam_unmap_single() are the managed counterparts
for the respective dma_* functions.

Note that dmam_map_single() returns zero on failure, and not a value to
be handled by dma_mapping_error(): The error check is done by
dmam_map_single() to avoid the registration of a mapping that failed.

Signed-off-by: Eli Billauer <eli.billauer@gmail.com>
---
 Documentation/driver-model/devres.txt |    2 +
 drivers/base/dma-mapping.c            |   80 +++++++++++++++++++++++++++++++++
 include/linux/dma-mapping.h           |    5 ++-
 3 files changed, 86 insertions(+), 1 deletions(-)

diff --git a/Documentation/driver-model/devres.txt b/Documentation/driver-model/devres.txt
index e1a2707..13b8be0 100644
--- a/Documentation/driver-model/devres.txt
+++ b/Documentation/driver-model/devres.txt
@@ -266,6 +266,8 @@ DMA
   dmam_declare_coherent_memory()
   dmam_pool_create()
   dmam_pool_destroy()
+  dmam_map_single()
+  dmam_unmap_single()
 
 PCI
   pcim_enable_device()	: after success, all PCI ops become managed
diff --git a/drivers/base/dma-mapping.c b/drivers/base/dma-mapping.c
index 0ce39a3..db1c496 100644
--- a/drivers/base/dma-mapping.c
+++ b/drivers/base/dma-mapping.c
@@ -19,6 +19,7 @@ struct dma_devres {
 	size_t		size;
 	void		*vaddr;
 	dma_addr_t	dma_handle;
+	enum dma_data_direction direction;
 };
 
 static void dmam_coherent_release(struct device *dev, void *res)
@@ -267,3 +268,82 @@ int dma_common_mmap(struct device *dev, struct vm_area_struct *vma,
 	return ret;
 }
 EXPORT_SYMBOL(dma_common_mmap);
+
+static int dmam_map_match(struct device *dev, void *res, void *match_data)
+{
+	struct dma_devres *this = res, *match = match_data;
+
+	if (this->dma_handle == match->dma_handle) {
+		WARN_ON(this->size != match->size ||
+			this->direction != match->direction);
+		return 1;
+	}
+	return 0;
+}
+
+static void dmam_map_single_release(struct device *dev, void *res)
+{
+	struct dma_devres *this = res;
+
+	dma_unmap_single(dev, this->dma_handle, this->size, this->direction);
+}
+
+/**
+ * dmam_map_single - Managed dma_map_single()
+ * @dev: Device to map DMA region for
+ * @ptr: Pointer to region
+ * @size: Size to map
+ * @direction: The mapping's direction
+ *
+ * Managed dma_map_single().  The region mapped using this
+ * function will be automatically unmapped on driver detach.
+ *
+ * RETURNS:
+ * The DMA handle of the mapped region upon success, 0 otherwise.
+ */
+dma_addr_t dmam_map_single(struct device *dev, void *ptr, size_t size,
+			   enum dma_data_direction direction)
+
+{
+	struct dma_devres *dr;
+	dma_addr_t dma_handle;
+
+	dr = devres_alloc(dmam_map_single_release, sizeof(*dr), GFP_KERNEL);
+	if (!dr)
+		return 0;
+
+	dma_handle = dma_map_single(dev, ptr, size, direction);
+	if (dma_mapping_error(dev, dma_handle)) {
+		devres_free(dr);
+		return 0;
+	}
+
+	dr->vaddr = ptr;
+	dr->dma_handle = dma_handle;
+	dr->size = size;
+	dr->direction = direction;
+
+	devres_add(dev, dr);
+
+	return dma_handle;
+}
+EXPORT_SYMBOL(dmam_map_single);
+
+/**
+ * dmam_unmap_single - Managed dma_unmap_single()
+ * @dev: Device to map DMA region for
+ * @dma_handle: DMA handle of the region to unmap
+ * @size: Size to unmap
+ * @direction: The mapping's direction
+ *
+ * Managed dma_unmap_single().
+ */
+void dmam_unmap_single(struct device *dev, dma_addr_t dma_handle,
+		       size_t size, enum dma_data_direction direction)
+{
+	struct dma_devres match_data = { size, NULL, dma_handle, direction };
+
+	WARN_ON(devres_release(dev, dmam_map_single_release, dmam_map_match,
+			       &match_data));
+}
+EXPORT_SYMBOL(dmam_unmap_single);
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index fd4aee2..cdb14a8 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -233,7 +233,10 @@ static inline void dmam_release_declared_memory(struct device *dev)
 {
 }
 #endif /* ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY */
-
+dma_addr_t dmam_map_single(struct device *dev, void *ptr, size_t size,
+			   enum dma_data_direction direction);
+void dmam_unmap_single(struct device *dev, dma_addr_t dma_handle,
+		       size_t size, enum dma_data_direction direction);
 #ifndef CONFIG_HAVE_DMA_ATTRS
 struct dma_attrs;
 
-- 
1.7.2.3

