Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137AbbAIVW3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 16:22:29 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:56227 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbbAIVW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 16:22:26 -0500
From: Suman Anna <s-anna@ti.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: Dave Gerlach <d-gerlach@ti.com>, Robert Tivy <rtivy@ti.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Suman Anna <s-anna@ti.com>
Subject: [PATCH v3 2/2] remoteproc: add support to handle internal memories
Date: Fri, 9 Jan 2015 15:21:59 -0600
Message-ID: <1420838519-15669-3-git-send-email-s-anna@ti.com>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1420838519-15669-1-git-send-email-s-anna@ti.com>
References: <1420838519-15669-1-git-send-email-s-anna@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A remote processor may need to load certain firmware sections into
internal memories (eg: RAM at L1 or L2 levels) for performance or
other reasons. Introduce a new resource type (RSC_INTMEM) and add
an associated handler function to handle such memories. The handler
creates a kernel mapping for the resource's 'pa' (physical address).

Note that no iommu mapping is performed for this resource, as the
resource is primarily used to represent physical internal memories.
If the internal memory region can only be accessed through an iommu,
a devmem resource entry should be used instead.

Signed-off-by: Robert Tivy <rtivy@ti.com>
Signed-off-by: Suman Anna <s-anna@ti.com>
---
v3:
- leverage memcpy_toio and memset_io for loading into internal memory
- rproc_da_to_va takes an additional argument to allow this distinction

 drivers/remoteproc/remoteproc_core.c       | 89 +++++++++++++++++++++++++++++-
 drivers/remoteproc/remoteproc_elf_loader.c | 23 ++++++--
 drivers/remoteproc/remoteproc_internal.h   |  6 +-
 include/linux/remoteproc.h                 | 43 ++++++++++++++-
 4 files changed, 150 insertions(+), 11 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 11cdb119e4f3..e0ecc0f802c1 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -153,7 +153,7 @@ static void rproc_disable_iommu(struct rproc *rproc)
  * but only on kernel direct mapped RAM memory. Instead, we're just using
  * here the output of the DMA API, which should be more correct.
  */
-void *rproc_da_to_va(struct rproc *rproc, u64 da, int len)
+void *rproc_da_to_va(struct rproc *rproc, u64 da, int len, u32 *flags)
 {
 	struct rproc_mem_entry *carveout;
 	void *ptr = NULL;
@@ -170,6 +170,8 @@ void *rproc_da_to_va(struct rproc *rproc, u64 da, int len)
 			continue;
 
 		ptr = carveout->va + offset;
+		if (flags && carveout->priv)
+			*flags = RPROC_INTMEM;
 
 		break;
 	}
@@ -404,7 +406,7 @@ static int rproc_handle_trace(struct rproc *rproc, struct fw_rsc_trace *rsc,
 	}
 
 	/* what's the kernel address of this resource ? */
-	ptr = rproc_da_to_va(rproc, rsc->da, rsc->len);
+	ptr = rproc_da_to_va(rproc, rsc->da, rsc->len, NULL);
 	if (!ptr) {
 		dev_err(dev, "erroneous trace resource entry\n");
 		return -EINVAL;
@@ -664,6 +666,82 @@ free_carv:
 	return ret;
 }
 
+/**
+ * rproc_handle_intmem() - handle internal memory resource entry
+ * @rproc: rproc handle
+ * @rsc: the intmem resource entry
+ * @offset: offset of the resource data in resource table
+ * @avail: size of available data (for image validation)
+ *
+ * This function will handle firmware requests for mapping a memory region
+ * internal to a remote processor into kernel. It neither allocates any
+ * physical pages, nor performs any iommu mapping, as this resource entry
+ * is primarily used for representing physical internal memories. If the
+ * internal memory region can only be accessed through an iommu, please
+ * use a devmem resource entry.
+ *
+ * These resource entries should be grouped near the carveout entries in
+ * the firmware's resource table, as other firmware entries might request
+ * placing other data objects inside these memory regions (e.g. data/code
+ * segments, trace resource entries, ...).
+ */
+static int rproc_handle_intmem(struct rproc *rproc, struct fw_rsc_intmem *rsc,
+			       int offset, int avail)
+{
+	struct rproc_mem_entry *intmem;
+	struct device *dev = &rproc->dev;
+	void *va;
+	int ret;
+
+	if (sizeof(*rsc) > avail) {
+		dev_err(dev, "intmem rsc is truncated\n");
+		return -EINVAL;
+	}
+
+	if (rsc->version != 1) {
+		dev_err(dev, "intmem rsc version %d is not supported\n",
+			rsc->version);
+		return -EINVAL;
+	}
+
+	if (rsc->reserved) {
+		dev_err(dev, "intmem rsc has non zero reserved bytes\n");
+		return -EINVAL;
+	}
+
+	dev_dbg(dev, "intmem rsc: da 0x%x, pa 0x%x, len 0x%x\n",
+		rsc->da, rsc->pa, rsc->len);
+
+	intmem = kzalloc(sizeof(*intmem), GFP_KERNEL);
+	if (!intmem)
+		return -ENOMEM;
+
+	va = (__force void *)ioremap_nocache(rsc->pa, rsc->len);
+	if (!va) {
+		dev_err(dev, "ioremap_nocache err: %d\n", rsc->len);
+		ret = -ENOMEM;
+		goto free_intmem;
+	}
+
+	dev_dbg(dev, "intmem mapped pa 0x%x of len 0x%x into kernel va %p\n",
+		rsc->pa, rsc->len, va);
+
+	intmem->va = va;
+	intmem->len = rsc->len;
+	intmem->dma = rsc->pa;
+	intmem->da = rsc->da;
+	intmem->priv = (void *)RPROC_INTMEM;    /* prevents freeing */
+
+	/* reuse the rproc->carveouts list, so that loading is automatic */
+	list_add_tail(&intmem->node, &rproc->carveouts);
+
+	return 0;
+
+free_intmem:
+	kfree(intmem);
+	return ret;
+}
+
 static int rproc_count_vrings(struct rproc *rproc, struct fw_rsc_vdev *rsc,
 			      int offset, int avail)
 {
@@ -681,6 +759,7 @@ static rproc_handle_resource_t rproc_loading_handlers[RSC_LAST] = {
 	[RSC_CARVEOUT] = (rproc_handle_resource_t)rproc_handle_carveout,
 	[RSC_DEVMEM] = (rproc_handle_resource_t)rproc_handle_devmem,
 	[RSC_TRACE] = (rproc_handle_resource_t)rproc_handle_trace,
+	[RSC_INTMEM] = (rproc_handle_resource_t)rproc_handle_intmem,
 	[RSC_VDEV] = NULL, /* VDEVs were handled upon registrarion */
 };
 
@@ -768,7 +847,11 @@ static void rproc_resource_cleanup(struct rproc *rproc)
 
 	/* clean up carveout allocations */
 	list_for_each_entry_safe(entry, tmp, &rproc->carveouts, node) {
-		dma_free_coherent(dev->parent, entry->len, entry->va, entry->dma);
+		if (!entry->priv)
+			dma_free_coherent(dev->parent, entry->len, entry->va,
+					  entry->dma);
+		else
+			iounmap((__force void __iomem *)entry->va);
 		list_del(&entry->node);
 		kfree(entry);
 	}
diff --git a/drivers/remoteproc/remoteproc_elf_loader.c b/drivers/remoteproc/remoteproc_elf_loader.c
index ce283a5b42a1..cdd7b622cee3 100644
--- a/drivers/remoteproc/remoteproc_elf_loader.c
+++ b/drivers/remoteproc/remoteproc_elf_loader.c
@@ -150,6 +150,7 @@ rproc_elf_load_segments(struct rproc *rproc, const struct firmware *fw)
 	struct elf32_phdr *phdr;
 	int i, ret = 0;
 	const u8 *elf_data = fw->data;
+	u32 flags = 0;
 
 	ehdr = (struct elf32_hdr *)elf_data;
 	phdr = (struct elf32_phdr *)(elf_data + ehdr->e_phoff);
@@ -183,7 +184,7 @@ rproc_elf_load_segments(struct rproc *rproc, const struct firmware *fw)
 		}
 
 		/* grab the kernel address for this device address */
-		ptr = rproc_da_to_va(rproc, da, memsz);
+		ptr = rproc_da_to_va(rproc, da, memsz, &flags);
 		if (!ptr) {
 			dev_err(dev, "bad phdr da 0x%x mem 0x%x\n", da, memsz);
 			ret = -EINVAL;
@@ -191,8 +192,13 @@ rproc_elf_load_segments(struct rproc *rproc, const struct firmware *fw)
 		}
 
 		/* put the segment where the remote processor expects it */
-		if (phdr->p_filesz)
-			memcpy(ptr, elf_data + phdr->p_offset, filesz);
+		if (phdr->p_filesz) {
+			if (flags & RPROC_INTMEM)
+				memcpy_toio((void __iomem *)ptr,
+					    elf_data + phdr->p_offset, filesz);
+			else
+				memcpy(ptr, elf_data + phdr->p_offset, filesz);
+		}
 
 		/*
 		 * Zero out remaining memory for this segment.
@@ -201,8 +207,13 @@ rproc_elf_load_segments(struct rproc *rproc, const struct firmware *fw)
 		 * did this for us. albeit harmless, we may consider removing
 		 * this.
 		 */
-		if (memsz > filesz)
-			memset(ptr + filesz, 0, memsz - filesz);
+		if (memsz > filesz) {
+			if (flags & RPROC_INTMEM)
+				memset_io((void __iomem *)ptr + filesz,
+					  0, memsz - filesz);
+			else
+				memset(ptr + filesz, 0, memsz - filesz);
+		}
 	}
 
 	return ret;
@@ -325,7 +336,7 @@ rproc_elf_find_loaded_rsc_table(struct rproc *rproc, const struct firmware *fw)
 	if (!shdr)
 		return NULL;
 
-	return rproc_da_to_va(rproc, shdr->sh_addr, shdr->sh_size);
+	return rproc_da_to_va(rproc, shdr->sh_addr, shdr->sh_size, NULL);
 }
 
 const struct rproc_fw_ops rproc_elf_fw_ops = {
diff --git a/drivers/remoteproc/remoteproc_internal.h b/drivers/remoteproc/remoteproc_internal.h
index 70701a50ddfa..8af4a8188488 100644
--- a/drivers/remoteproc/remoteproc_internal.h
+++ b/drivers/remoteproc/remoteproc_internal.h
@@ -23,6 +23,10 @@
 #include <linux/irqreturn.h>
 #include <linux/firmware.h>
 
+enum rproc_mem_type {
+	RPROC_INTMEM = 1,
+};
+
 struct rproc;
 
 /**
@@ -65,7 +69,7 @@ void rproc_exit_debugfs(void);
 void rproc_free_vring(struct rproc_vring *rvring);
 int rproc_alloc_vring(struct rproc_vdev *rvdev, int i);
 
-void *rproc_da_to_va(struct rproc *rproc, u64 da, int len);
+void *rproc_da_to_va(struct rproc *rproc, u64 da, int len, u32 *flags);
 int rproc_trigger_recovery(struct rproc *rproc);
 
 static inline
diff --git a/include/linux/remoteproc.h b/include/linux/remoteproc.h
index 78b8a9b9d40a..2a25ee8a34dd 100644
--- a/include/linux/remoteproc.h
+++ b/include/linux/remoteproc.h
@@ -100,6 +100,7 @@ struct fw_rsc_hdr {
  *		    the remote processor will be writing logs.
  * @RSC_VDEV:       declare support for a virtio device, and serve as its
  *		    virtio header.
+ * @RSC_INTMEM:     request to map into kernel an internal memory region.
  * @RSC_LAST:       just keep this one at the end
  *
  * For more details regarding a specific resource type, please see its
@@ -115,7 +116,8 @@ enum fw_resource_type {
 	RSC_DEVMEM	= 1,
 	RSC_TRACE	= 2,
 	RSC_VDEV	= 3,
-	RSC_LAST	= 4,
+	RSC_INTMEM	= 4,
+	RSC_LAST	= 5,
 };
 
 #define FW_RSC_ADDR_ANY (0xFFFFFFFFFFFFFFFF)
@@ -306,6 +308,45 @@ struct fw_rsc_vdev {
 } __packed;
 
 /**
+ * struct fw_rsc_intmem - internal memory publishing request
+ * @version: version for this resource type (must be one)
+ * @da: device address
+ * @pa: physical address
+ * @len: length (in bytes)
+ * @reserved: reserved (must be zero)
+ * @name: human-readable name of the region being published
+ *
+ * This resource entry allows a remote processor to publish an internal
+ * memory region to the host. This resource type allows a remote processor
+ * to publish the whole or just a portion of certain internal memories,
+ * while it owns and manages any unpublished portion (eg: a shared L1
+ * memory that can be split configured as RAM and/or cache). This is
+ * primarily provided to allow a host to load code/data into internal
+ * memories, the memory for which is neither allocated nor required to
+ * be mapped into an iommu.
+ *
+ * @da should specify the required address as accessible by the device
+ * without going through an iommu, @pa should specify the physical address
+ * for the region as seen on the bus, @len should specify the size of the
+ * memory region. As always, @name may (optionally) contain a human readable
+ * name of this mapping (mainly for debugging purposes). The @version field
+ * is added for future scalability, and should be 1 for now.
+ *
+ * Note: at this point we just "trust" these intmem entries to contain valid
+ * physical bus addresses. these are not currently intended to be managed
+ * as host-controlled heaps, as it is much better to do that from the remote
+ * processor side.
+ */
+struct fw_rsc_intmem {
+	u32 version;
+	u32 da;
+	u32 pa;
+	u32 len;
+	u32 reserved;
+	u8 name[32];
+} __packed;
+
+/**
  * struct rproc_mem_entry - memory entry descriptor
  * @va:	virtual address
  * @dma: dma address
-- 
2.2.1

