Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932572AbaEQMWz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 08:22:55 -0400
Received: from ar-005-i190.relay.mailchannels.net ([162.253.144.72]:31087 "EHLO
	relay.mailchannels.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932389AbaEQMWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 08:22:53 -0400
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
Subject: [PATCH 2/3] dma-mapping: Add devm_ interface for dma_map_single_attrs()
Date: Sat, 17 May 2014 15:22:24 +0300
Message-Id: <1400329345-15556-2-git-send-email-eli.billauer@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1400329345-15556-1-git-send-email-eli.billauer@gmail.com>
References: <1400329345-15556-1-git-send-email-eli.billauer@gmail.com>
X-AuthUser: billaue
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dmam_map_single_attrs() and dmam_unmap_single_attrs() replace the non-*_attrs
functions, which are implemented as defines instead.

The case of a non-NULL @attrs parameter has not been tested.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Eli Billauer <eli.billauer@gmail.com>
---
 Documentation/driver-model/devres.txt    |    2 +
 drivers/base/dma-mapping.c               |   43 +++++++++++++++++++++--------
 include/asm-generic/dma-mapping-common.h |    2 +
 include/linux/dma-mapping.h              |   10 ++++---
 4 files changed, 41 insertions(+), 16 deletions(-)

diff --git a/Documentation/driver-model/devres.txt b/Documentation/driver-model/devres.txt
index 13b8be0..2112a00 100644
--- a/Documentation/driver-model/devres.txt
+++ b/Documentation/driver-model/devres.txt
@@ -268,6 +268,8 @@ DMA
   dmam_pool_destroy()
   dmam_map_single()
   dmam_unmap_single()
+  dmam_map_single_attrs()
+  dmam_unmap_single_attrs()
 
 PCI
   pcim_enable_device()	: after success, all PCI ops become managed
diff --git a/drivers/base/dma-mapping.c b/drivers/base/dma-mapping.c
index db1c496..4e80db1 100644
--- a/drivers/base/dma-mapping.c
+++ b/drivers/base/dma-mapping.c
@@ -11,6 +11,7 @@
 #include <linux/export.h>
 #include <linux/gfp.h>
 #include <asm-generic/dma-coherent.h>
+#include <linux/slab.h>
 
 /*
  * Managed DMA API
@@ -20,6 +21,7 @@ struct dma_devres {
 	void		*vaddr;
 	dma_addr_t	dma_handle;
 	enum dma_data_direction direction;
+	struct dma_attrs *attrs;
 };
 
 static void dmam_coherent_release(struct device *dev, void *res)
@@ -285,24 +287,29 @@ static void dmam_map_single_release(struct device *dev, void *res)
 {
 	struct dma_devres *this = res;
 
-	dma_unmap_single(dev, this->dma_handle, this->size, this->direction);
+	dma_unmap_single_attrs(dev, this->dma_handle, this->size,
+			       this->direction, this->attrs);
+
+	kfree(this->attrs);
 }
 
 /**
- * dmam_map_single - Managed dma_map_single()
+ * dmam_map_single_attrs - Managed dma_map_single_attrs()
  * @dev: Device to map DMA region for
  * @ptr: Pointer to region
  * @size: Size to map
  * @direction: The mapping's direction
+ * @attrs: Attributes associated with the DMA mapping
  *
- * Managed dma_map_single().  The region mapped using this
+ * Managed dma_map_single_attrs().  The region mapped using this
  * function will be automatically unmapped on driver detach.
  *
  * RETURNS:
  * The DMA handle of the mapped region upon success, 0 otherwise.
  */
-dma_addr_t dmam_map_single(struct device *dev, void *ptr, size_t size,
-			   enum dma_data_direction direction)
+dma_addr_t dmam_map_single_attrs(struct device *dev, void *ptr, size_t size,
+				 enum dma_data_direction direction,
+				 struct dma_attrs *attrs)
 
 {
 	struct dma_devres *dr;
@@ -312,8 +319,18 @@ dma_addr_t dmam_map_single(struct device *dev, void *ptr, size_t size,
 	if (!dr)
 		return 0;
 
-	dma_handle = dma_map_single(dev, ptr, size, direction);
+	if (attrs) {
+		dr->attrs = kmemdup(attrs, sizeof(*attrs), GFP_KERNEL);
+		if (!dr->attrs) {
+			devres_free(dr);
+			return 0;
+		}
+	} else
+		dr->attrs = NULL;
+
+	dma_handle = dma_map_single_attrs(dev, ptr, size, direction, attrs);
 	if (dma_mapping_error(dev, dma_handle)) {
+		kfree(dr->attrs);
 		devres_free(dr);
 		return 0;
 	}
@@ -327,23 +344,25 @@ dma_addr_t dmam_map_single(struct device *dev, void *ptr, size_t size,
 
 	return dma_handle;
 }
-EXPORT_SYMBOL(dmam_map_single);
+EXPORT_SYMBOL(dmam_map_single_attrs);
 
 /**
- * dmam_unmap_single - Managed dma_unmap_single()
+ * dmam_unmap_single_attrs - Managed dma_unmap_single_attrs()
  * @dev: Device to map DMA region for
  * @dma_handle: DMA handle of the region to unmap
  * @size: Size to unmap
  * @direction: The mapping's direction
+ * @attrs: Attributes associated with the DMA mapping.
  *
- * Managed dma_unmap_single().
+ * Managed dma_unmap_single_attrs().
  */
-void dmam_unmap_single(struct device *dev, dma_addr_t dma_handle,
-		       size_t size, enum dma_data_direction direction)
+void dmam_unmap_single_attrs(struct device *dev, dma_addr_t dma_handle,
+			     size_t size, enum dma_data_direction direction,
+			     struct dma_attrs *attrs)
 {
 	struct dma_devres match_data = { size, NULL, dma_handle, direction };
 
 	WARN_ON(devres_release(dev, dmam_map_single_release, dmam_map_match,
 			       &match_data));
 }
-EXPORT_SYMBOL(dmam_unmap_single);
+EXPORT_SYMBOL(dmam_unmap_single_attrs);
diff --git a/include/asm-generic/dma-mapping-common.h b/include/asm-generic/dma-mapping-common.h
index de8bf89..aaa7c68 100644
--- a/include/asm-generic/dma-mapping-common.h
+++ b/include/asm-generic/dma-mapping-common.h
@@ -175,6 +175,8 @@ dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
 #define dma_unmap_single(d, a, s, r) dma_unmap_single_attrs(d, a, s, r, NULL)
 #define dma_map_sg(d, s, n, r) dma_map_sg_attrs(d, s, n, r, NULL)
 #define dma_unmap_sg(d, s, n, r) dma_unmap_sg_attrs(d, s, n, r, NULL)
+#define dmam_map_single(d, a, s, r) dmam_map_single_attrs(d, a, s, r, NULL)
+#define dmam_unmap_single(d, a, s, r) dmam_unmap_single_attrs(d, a, s, r, NULL)
 
 extern int dma_common_mmap(struct device *dev, struct vm_area_struct *vma,
 			   void *cpu_addr, dma_addr_t dma_addr, size_t size);
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index cdb14a8..ba2a403 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -233,10 +233,12 @@ static inline void dmam_release_declared_memory(struct device *dev)
 {
 }
 #endif /* ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY */
-dma_addr_t dmam_map_single(struct device *dev, void *ptr, size_t size,
-			   enum dma_data_direction direction);
-void dmam_unmap_single(struct device *dev, dma_addr_t dma_handle,
-		       size_t size, enum dma_data_direction direction);
+dma_addr_t dmam_map_single_attrs(struct device *dev, void *ptr, size_t size,
+				 enum dma_data_direction direction,
+				 struct dma_attrs *attrs);
+void dmam_unmap_single_attrs(struct device *dev, dma_addr_t dma_handle,
+			     size_t size, enum dma_data_direction direction,
+			     struct dma_attrs *attrs);
 #ifndef CONFIG_HAVE_DMA_ATTRS
 struct dma_attrs;
 
-- 
1.7.2.3

