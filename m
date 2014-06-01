Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbaFAHKt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 03:10:49 -0400
Received: from si-002-i45.relay.mailchannels.net ([184.154.112.210]:16859 "EHLO
	relay.mailchannels.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751107AbaFAHKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 03:10:47 -0400
X-Sender-Id: totalchoicehosting|x-authuser|billaue
X-Sender-Id: totalchoicehosting|x-authuser|billaue
X-MC-Relay: Neutral
X-MailChannels-SenderId: totalchoicehosting%7Cx-authuser%7Cbillaue
X-MailChannels-Auth-Id: totalchoicehosting
From: Eli Billauer <eli.billauer@gmail.com>
To: tj@kernel.org
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        bhelgaas@google.com, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, shuah.kh@samsung.com,
        iommu@lists.linux-foundation.org, discuss@x86-64.org,
        Eli Billauer <eli.billauer@gmail.com>
Subject: [PATCH v2 1/4] dma-mapping: Add devm_ interface for dma_map_single()
Date: Sun,  1 Jun 2014 10:01:14 +0300
Message-Id: <1401606077-1739-2-git-send-email-eli.billauer@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1401606077-1739-1-git-send-email-eli.billauer@gmail.com>
References: <1401606077-1739-1-git-send-email-eli.billauer@gmail.com>
X-AuthUser: billaue
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dmam_map_single() and dmam_unmap_single() are the managed counterparts
for the respective dma_* functions.

Note that dmam_map_single() returns a status value rather than the DMA handle.
The DMA handle is passed to the caller through a pointer in the arguments.

The reason for this API change is that dmam_map_single() allocates memory,
which may fail even if the DMA mapping is successful. On the other hand,
it seems like there's no platform-independent value for dma_handle that can
be used to indicate an error.

This leaves dmam_map_single() with no safe way to tell its caller that the
memory allocation has failed, except for returning a status as an int. Trying
to keep close to the non-devres API could also tempt programmers into using
dma_mapping_error() on the dmam_* functions. This would work incorrectly on
platforms, for which dma_mapping_error() ignores its argument, and always
returns success.

Thanks to Tejun Heo for suggesting this API.

Signed-off-by: Eli Billauer <eli.billauer@gmail.com>
---
 Documentation/driver-model/devres.txt |    2 +
 drivers/base/dma-mapping.c            |   86 +++++++++++++++++++++++++++++++++
 include/linux/dma-mapping.h           |    6 ++-
 3 files changed, 93 insertions(+), 1 deletions(-)

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
index 0ce39a3..f76ea0f 100644
--- a/drivers/base/dma-mapping.c
+++ b/drivers/base/dma-mapping.c
@@ -19,6 +19,7 @@ struct dma_devres {
 	size_t		size;
 	void		*vaddr;
 	dma_addr_t	dma_handle;
+	enum dma_data_direction direction;
 };
 
 static void dmam_coherent_release(struct device *dev, void *res)
@@ -267,3 +268,88 @@ int dma_common_mmap(struct device *dev, struct vm_area_struct *vma,
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
+ * @ret_dma_handle: Pointer to return the value of the DMA handle
+ *
+ * Managed dma_map_single().  The region mapped using this
+ * function will be automatically unmapped on driver detach.
+ *
+ * RETURNED VALUE:
+ * 0 is returned on success
+ * -EIO if the DMA mapping failed
+ * -ENOMEM on failure to allocate memory for internal data structure
+ */
+int dmam_map_single(struct device *dev, void *ptr, size_t size,
+		    enum dma_data_direction direction,
+		    dma_addr_t *ret_dma_handle)
+
+{
+	struct dma_devres *dr;
+	dma_addr_t dma_handle;
+
+	dr = devres_alloc(dmam_map_single_release, sizeof(*dr), GFP_KERNEL);
+	if (!dr)
+		return -ENOMEM;
+
+	dma_handle = dma_map_single(dev, ptr, size, direction);
+	if (dma_mapping_error(dev, dma_handle)) {
+		devres_free(dr);
+		return -EIO;
+	}
+
+	*ret_dma_handle = dma_handle;
+
+	dr->vaddr = ptr;
+	dr->dma_handle = dma_handle;
+	dr->size = size;
+	dr->direction = direction;
+
+	devres_add(dev, dr);
+
+	return 0; /* Success */
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
index fd4aee2..cad63de 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -233,7 +233,11 @@ static inline void dmam_release_declared_memory(struct device *dev)
 {
 }
 #endif /* ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY */
-
+int dmam_map_single(struct device *dev, void *ptr, size_t size,
+		    enum dma_data_direction direction,
+		    dma_addr_t *ret_dma_handle);
+void dmam_unmap_single(struct device *dev, dma_addr_t dma_handle,
+		       size_t size, enum dma_data_direction direction);
 #ifndef CONFIG_HAVE_DMA_ATTRS
 struct dma_attrs;
 
-- 
1.7.2.3

