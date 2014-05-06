Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947AbaEFWs0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 18:48:26 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:49892 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754806AbaEFWsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 18:48:17 -0400
Subject: [PATCH v2 2/5] DMA-API: Change dma_declare_coherent_memory() CPU
 address to phys_addr_t
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-doc@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>, Randy Dunlap <rdunlap@infradead.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>, linux-kernel@vger.kernel.org,
        James Bottomley <jbottomley@parallels.com>, linux-pci@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>
Date: Tue, 06 May 2014 16:48:26 -0600
Message-ID: <20140506224826.17968.59068.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140506223250.17968.27054.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140506223250.17968.27054.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dma_declare_coherent_memory() takes two addresses for a region of memory: a
"bus_addr" and a "device_addr".  I think the intent is that "bus_addr" is
the physical address a *CPU* would use to access the region, and
"device_addr" is the bus address the *device* would use to address the
region.

Rename "bus_addr" to "phys_addr" and change its type to phys_addr_t.
Most callers already supply a phys_addr_t for this argument.  The others
supply a 32-bit integer (a constant, unsigned int, or __u32) and need no
change.

Use "unsigned long", not phys_addr_t, to hold PFNs.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 Documentation/DMA-API.txt          |    9 ++++-----
 drivers/base/dma-coherent.c        |   10 +++++-----
 drivers/base/dma-mapping.c         |    6 +++---
 include/asm-generic/dma-coherent.h |   13 +++++--------
 include/linux/dma-mapping.h        |    7 ++++---
 5 files changed, 21 insertions(+), 24 deletions(-)

diff --git a/Documentation/DMA-API.txt b/Documentation/DMA-API.txt
index 1699e26c6284..de4671f81395 100644
--- a/Documentation/DMA-API.txt
+++ b/Documentation/DMA-API.txt
@@ -498,19 +498,18 @@ continuing on for size.  Again, you *must* observe the cache line
 boundaries when doing this.
 
 int
-dma_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
+dma_declare_coherent_memory(struct device *dev, phys_addr_t phys_addr,
 			    dma_addr_t device_addr, size_t size, int
 			    flags)
 
 Declare region of memory to be handed out by dma_alloc_coherent() when
 it's asked for coherent memory for this device.
 
-bus_addr is the physical address to which the memory is currently
-assigned in the bus responding region (this will be used by the
-platform to perform the mapping).
+phys_addr is the cpu physical address to which the memory is currently
+assigned (this will be ioremapped so the cpu can access the region).
 
 device_addr is the bus address the device needs to be programmed
-with actually to address this memory (this will be handed out as the
+with to actually address this memory (this will be handed out as the
 dma_addr_t in dma_alloc_coherent()).
 
 size is the size of the area (must be multiples of PAGE_SIZE).
diff --git a/drivers/base/dma-coherent.c b/drivers/base/dma-coherent.c
index bc256b641027..7d6e84a51424 100644
--- a/drivers/base/dma-coherent.c
+++ b/drivers/base/dma-coherent.c
@@ -10,13 +10,13 @@
 struct dma_coherent_mem {
 	void		*virt_base;
 	dma_addr_t	device_base;
-	phys_addr_t	pfn_base;
+	unsigned long	pfn_base;
 	int		size;
 	int		flags;
 	unsigned long	*bitmap;
 };
 
-int dma_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
+int dma_declare_coherent_memory(struct device *dev, phys_addr_t phys_addr,
 				dma_addr_t device_addr, size_t size, int flags)
 {
 	void __iomem *mem_base = NULL;
@@ -32,7 +32,7 @@ int dma_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
 
 	/* FIXME: this routine just ignores DMA_MEMORY_INCLUDES_CHILDREN */
 
-	mem_base = ioremap(bus_addr, size);
+	mem_base = ioremap(phys_addr, size);
 	if (!mem_base)
 		goto out;
 
@@ -45,7 +45,7 @@ int dma_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
 
 	dev->dma_mem->virt_base = mem_base;
 	dev->dma_mem->device_base = device_addr;
-	dev->dma_mem->pfn_base = PFN_DOWN(bus_addr);
+	dev->dma_mem->pfn_base = PFN_DOWN(phys_addr);
 	dev->dma_mem->size = pages;
 	dev->dma_mem->flags = flags;
 
@@ -208,7 +208,7 @@ int dma_mmap_from_coherent(struct device *dev, struct vm_area_struct *vma,
 
 		*ret = -ENXIO;
 		if (off < count && user_count <= count - off) {
-			unsigned pfn = mem->pfn_base + start + off;
+			unsigned long pfn = mem->pfn_base + start + off;
 			*ret = remap_pfn_range(vma, vma->vm_start, pfn,
 					       user_count << PAGE_SHIFT,
 					       vma->vm_page_prot);
diff --git a/drivers/base/dma-mapping.c b/drivers/base/dma-mapping.c
index 0ce39a33b3c2..6cd08e145bfa 100644
--- a/drivers/base/dma-mapping.c
+++ b/drivers/base/dma-mapping.c
@@ -175,7 +175,7 @@ static void dmam_coherent_decl_release(struct device *dev, void *res)
 /**
  * dmam_declare_coherent_memory - Managed dma_declare_coherent_memory()
  * @dev: Device to declare coherent memory for
- * @bus_addr: Bus address of coherent memory to be declared
+ * @phys_addr: Physical address of coherent memory to be declared
  * @device_addr: Device address of coherent memory to be declared
  * @size: Size of coherent memory to be declared
  * @flags: Flags
@@ -185,7 +185,7 @@ static void dmam_coherent_decl_release(struct device *dev, void *res)
  * RETURNS:
  * 0 on success, -errno on failure.
  */
-int dmam_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
+int dmam_declare_coherent_memory(struct device *dev, phys_addr_t phys_addr,
 				 dma_addr_t device_addr, size_t size, int flags)
 {
 	void *res;
@@ -195,7 +195,7 @@ int dmam_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
 	if (!res)
 		return -ENOMEM;
 
-	rc = dma_declare_coherent_memory(dev, bus_addr, device_addr, size,
+	rc = dma_declare_coherent_memory(dev, phys_addr, device_addr, size,
 					 flags);
 	if (rc == 0)
 		devres_add(dev, res);
diff --git a/include/asm-generic/dma-coherent.h b/include/asm-generic/dma-coherent.h
index 2be8a2dbc868..0297e5875798 100644
--- a/include/asm-generic/dma-coherent.h
+++ b/include/asm-generic/dma-coherent.h
@@ -16,16 +16,13 @@ int dma_mmap_from_coherent(struct device *dev, struct vm_area_struct *vma,
  * Standard interface
  */
 #define ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY
-extern int
-dma_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
-			    dma_addr_t device_addr, size_t size, int flags);
+int dma_declare_coherent_memory(struct device *dev, phys_addr_t phys_addr,
+				dma_addr_t device_addr, size_t size, int flags);
 
-extern void
-dma_release_declared_memory(struct device *dev);
+void dma_release_declared_memory(struct device *dev);
 
-extern void *
-dma_mark_declared_memory_occupied(struct device *dev,
-				  dma_addr_t device_addr, size_t size);
+void *dma_mark_declared_memory_occupied(struct device *dev,
+					dma_addr_t device_addr, size_t size);
 #else
 #define dma_alloc_from_coherent(dev, size, handle, ret) (0)
 #define dma_release_from_coherent(dev, order, vaddr) (0)
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 0808d3e7e218..3ec7c831e16a 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -193,7 +193,7 @@ static inline int dma_get_cache_alignment(void)
 
 #ifndef ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY
 static inline int
-dma_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
+dma_declare_coherent_memory(struct device *dev, phys_addr_t phys_addr,
 			    dma_addr_t device_addr, size_t size, int flags)
 {
 	return 0;
@@ -224,13 +224,14 @@ extern void *dmam_alloc_noncoherent(struct device *dev, size_t size,
 extern void dmam_free_noncoherent(struct device *dev, size_t size, void *vaddr,
 				  dma_addr_t dma_handle);
 #ifdef ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY
-extern int dmam_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
+extern int dmam_declare_coherent_memory(struct device *dev,
+					phys_addr_t phys_addr,
 					dma_addr_t device_addr, size_t size,
 					int flags);
 extern void dmam_release_declared_memory(struct device *dev);
 #else /* ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY */
 static inline int dmam_declare_coherent_memory(struct device *dev,
-				dma_addr_t bus_addr, dma_addr_t device_addr,
+				phys_addr_t phys_addr, dma_addr_t device_addr,
 				size_t size, gfp_t gfp)
 {
 	return 0;

