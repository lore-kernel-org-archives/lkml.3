Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbaDRSWc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 14:22:32 -0400
Received: from [207.46.100.104] ([207.46.100.104]:64221 "EHLO
	na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753913AbaDRSVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 14:21:39 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC: Ley Foon Tan <lftan@altera.com>, <lftan.linux@gmail.com>,
        <cltang@codesourcery.com>
Subject: [PATCH 14/28] nios2: DMA mapping API
Date: Sat, 19 Apr 2014 02:19:09 +0800
Message-ID: <1397845149-3141-4-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397845149-3141-1-git-send-email-lftan@altera.com>
References: <1397824031-4892-1-git-send-email-lftan@altera.com>
 <1397845149-3141-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.232;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(458001)(22564002)(189002)(199002)(80022001)(2201001)(92726001)(92566001)(93916002)(86362001)(80976001)(62966002)(4396001)(50226001)(81542001)(84676001)(33646001)(89996001)(85852003)(83072002)(99396002)(87936001)(81342001)(88136002)(50986999)(97736001)(50466002)(48376002)(87286001)(2009001)(76176999)(74502001)(31966008)(16796002)(74662001)(20776003)(47776003)(79102001)(19580395003)(42186004)(83322001)(19580405001)(76482001)(44976005)(6806004)(77156001)(46102001)(77982001)(36756003);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2FFO11HUB052;H:SJ-ITEXEDGE02.altera.priv.altera.com;FPR:881A74D6.82DF8DD1.62D563B7.2DDC379.20490;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-OriginatorOrg: altera.onmicrosoft.com
X-Forefront-PRVS: 018577E36E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the DMA mapping API.

Signed-off-by: Ley Foon Tan <lftan@altera.com>
---
 arch/nios2/include/asm/dma-mapping.h | 113 +++++++++++++++++++++
 arch/nios2/mm/dma-mapping.c          | 186 +++++++++++++++++++++++++++++++++++
 2 files changed, 299 insertions(+)
 create mode 100644 arch/nios2/include/asm/dma-mapping.h
 create mode 100644 arch/nios2/mm/dma-mapping.c

diff --git a/arch/nios2/include/asm/dma-mapping.h b/arch/nios2/include/asm/dma-mapping.h
new file mode 100644
index 0000000..28db1171247453e8c40f439e6752bf2a51937387
--- /dev/null
+++ b/arch/nios2/include/asm/dma-mapping.h
@@ -0,0 +1,113 @@
+/*
+ * Copyright (C) 2011 Tobias Klauser <tklauser@distanz.ch>
+ * Copyright (C) 2009 Wind River Systems Inc
+ *
+ * This file is subject to the terms and conditions of the GNU General
+ * Public License.  See the file COPYING in the main directory of this
+ * archive for more details.
+ */
+
+#ifndef _ASM_NIOS2_DMA_MAPPING_H
+#define _ASM_NIOS2_DMA_MAPPING_H
+
+#include <linux/scatterlist.h>
+#include <linux/cache.h>
+#include <asm/cacheflush.h>
+
+static inline void __dma_sync(void *vaddr, size_t size,
+			      enum dma_data_direction direction)
+{
+	switch (direction) {
+	case DMA_FROM_DEVICE:	/* invalidate cache */
+		invalidate_dcache_range((unsigned long)vaddr,
+			(unsigned long)(vaddr + size));
+		break;
+	case DMA_TO_DEVICE:	/* flush and invalidate cache */
+	case DMA_BIDIRECTIONAL:
+		flush_dcache_range((unsigned long)vaddr,
+			(unsigned long)(vaddr + size));
+		break;
+	default:
+		BUG();
+	}
+}
+
+#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
+#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
+
+void *dma_alloc_coherent(struct device *dev, size_t size,
+			   dma_addr_t *dma_handle, gfp_t flag);
+
+void dma_free_coherent(struct device *dev, size_t size,
+			 void *vaddr, dma_addr_t dma_handle);
+
+static inline dma_addr_t dma_map_single(struct device *dev, void *ptr,
+					size_t size,
+					enum dma_data_direction direction)
+{
+	__dma_sync(ptr, size, direction);
+	return virt_to_phys(ptr);
+}
+
+static inline void dma_unmap_single(struct device *dev, dma_addr_t dma_addr,
+				size_t size, enum dma_data_direction direction)
+{
+}
+
+extern int dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
+	enum dma_data_direction direction);
+extern dma_addr_t dma_map_page(struct device *dev, struct page *page,
+	unsigned long offset, size_t size, enum dma_data_direction direction);
+extern void dma_unmap_page(struct device *dev, dma_addr_t dma_address,
+	size_t size, enum dma_data_direction direction);
+extern void dma_unmap_sg(struct device *dev, struct scatterlist *sg,
+	int nhwentries, enum dma_data_direction direction);
+extern void dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle,
+	size_t size, enum dma_data_direction direction);
+extern void dma_sync_single_for_device(struct device *dev,
+	dma_addr_t dma_handle, size_t size, enum dma_data_direction direction);
+extern void dma_sync_single_range_for_cpu(struct device *dev,
+	dma_addr_t dma_handle, unsigned long offset, size_t size,
+	enum dma_data_direction direction);
+extern void dma_sync_single_range_for_device(struct device *dev,
+	dma_addr_t dma_handle, unsigned long offset, size_t size,
+	enum dma_data_direction direction);
+extern void dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
+	int nelems, enum dma_data_direction direction);
+extern void dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
+	int nelems, enum dma_data_direction direction);
+
+static inline int dma_supported(struct device *dev, u64 mask)
+{
+	/* we fall back to GFP_DMA when the mask isn't all 1s,
+	 * so we can't guarantee allocations that must be
+	 * within a tighter range than GFP_DMA.
+	 */
+	if (mask < 0x00ffffff)
+		return 0;
+
+	return 1;
+}
+
+static inline int dma_set_mask(struct device *dev, u64 mask)
+{
+	if (!dev->dma_mask || !dma_supported(dev, mask))
+		return -EIO;
+
+	*dev->dma_mask = mask;
+
+	return 0;
+}
+
+static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
+{
+	return 0;
+}
+
+static inline void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
+				  enum dma_data_direction direction)
+{
+	__dma_sync(vaddr, size, direction);
+}
+
+#endif /* _ASM_NIOS2_DMA_MAPPING_H */
diff --git a/arch/nios2/mm/dma-mapping.c b/arch/nios2/mm/dma-mapping.c
new file mode 100644
index 0000000..a9bafe9f5b5c65442e5fafa9b043e529cf6b6e54
--- /dev/null
+++ b/arch/nios2/mm/dma-mapping.c
@@ -0,0 +1,186 @@
+/*
+ * Copyright (C) 2011 Tobias Klauser <tklauser@distanz.ch>
+ * Copyright (C) 2009 Wind River Systems Inc
+ *  Implemented by fredrik.markstrom@gmail.com and ivarholmqvist@gmail.com
+ *
+ * Based on DMA code from MIPS.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#include <linux/types.h>
+#include <linux/mm.h>
+#include <linux/export.h>
+#include <linux/string.h>
+#include <linux/scatterlist.h>
+#include <linux/dma-mapping.h>
+#include <linux/io.h>
+#include <linux/cache.h>
+#include <asm/cacheflush.h>
+
+
+void *dma_alloc_coherent(struct device *dev, size_t size,
+			    dma_addr_t *dma_handle, gfp_t gfp)
+{
+	void *ret;
+
+	/* ignore region specifiers */
+	gfp &= ~(__GFP_DMA | __GFP_HIGHMEM);
+
+	/* optimized page clearing */
+	gfp |= __GFP_ZERO;
+
+	if (dev == NULL || (dev->coherent_dma_mask < 0xffffffff))
+		gfp |= GFP_DMA;
+
+	ret = (void *) __get_free_pages(gfp, get_order(size));
+	if (ret != NULL) {
+		*dma_handle = virt_to_phys(ret);
+		flush_dcache_range((unsigned long) ret,
+			(unsigned long) ret + size);
+		ret = UNCAC_ADDR(ret);
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(dma_alloc_coherent);
+
+void dma_free_coherent(struct device *dev, size_t size, void *vaddr,
+			dma_addr_t dma_handle)
+{
+	unsigned long addr = (unsigned long) CAC_ADDR((unsigned long) vaddr);
+	free_pages(addr, get_order(size));
+}
+EXPORT_SYMBOL(dma_free_coherent);
+
+int dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
+		enum dma_data_direction direction)
+{
+	int i;
+
+	BUG_ON(!valid_dma_direction(direction));
+
+	for_each_sg(sg, sg, nents, i) {
+		void *addr;
+
+		addr = sg_virt(sg);
+		if (addr) {
+			__dma_sync(addr, sg->length, direction);
+			sg->dma_address = sg_phys(sg);
+		}
+	}
+
+	return nents;
+}
+EXPORT_SYMBOL(dma_map_sg);
+
+dma_addr_t dma_map_page(struct device *dev, struct page *page,
+			unsigned long offset, size_t size,
+			enum dma_data_direction direction)
+{
+	void *addr;
+
+	BUG_ON(!valid_dma_direction(direction));
+
+	addr = page_address(page) + offset;
+	__dma_sync(addr, size, direction);
+
+	return page_to_phys(page) + offset;
+}
+EXPORT_SYMBOL(dma_map_page);
+
+void dma_unmap_page(struct device *dev, dma_addr_t dma_address, size_t size,
+		    enum dma_data_direction direction)
+{
+	BUG_ON(!valid_dma_direction(direction));
+
+	if (direction != DMA_TO_DEVICE)
+		__dma_sync(phys_to_virt(dma_address), size, direction);
+}
+EXPORT_SYMBOL(dma_unmap_page);
+
+void dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nhwentries,
+		  enum dma_data_direction direction)
+{
+	void *addr;
+	int i;
+
+	BUG_ON(!valid_dma_direction(direction));
+
+	if (direction == DMA_TO_DEVICE)
+		return;
+
+	for_each_sg(sg, sg, nhwentries, i) {
+		addr = sg_virt(sg);
+		if (addr)
+			__dma_sync(addr, sg->length, direction);
+	}
+}
+EXPORT_SYMBOL(dma_unmap_sg);
+
+void dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle,
+			     size_t size, enum dma_data_direction direction)
+{
+	BUG_ON(!valid_dma_direction(direction));
+
+	__dma_sync(phys_to_virt(dma_handle), size, direction);
+}
+EXPORT_SYMBOL(dma_sync_single_for_cpu);
+
+void dma_sync_single_for_device(struct device *dev, dma_addr_t dma_handle,
+				size_t size, enum dma_data_direction direction)
+{
+	BUG_ON(!valid_dma_direction(direction));
+
+	__dma_sync(phys_to_virt(dma_handle), size, direction);
+}
+EXPORT_SYMBOL(dma_sync_single_for_device);
+
+void dma_sync_single_range_for_cpu(struct device *dev, dma_addr_t dma_handle,
+					unsigned long offset, size_t size,
+					enum dma_data_direction direction)
+{
+	BUG_ON(!valid_dma_direction(direction));
+
+	__dma_sync(phys_to_virt(dma_handle), size, direction);
+}
+EXPORT_SYMBOL(dma_sync_single_range_for_cpu);
+
+void dma_sync_single_range_for_device(struct device *dev, dma_addr_t dma_handle,
+					unsigned long offset, size_t size,
+					enum dma_data_direction direction)
+{
+	BUG_ON(!valid_dma_direction(direction));
+
+	__dma_sync(phys_to_virt(dma_handle), size, direction);
+}
+EXPORT_SYMBOL(dma_sync_single_range_for_device);
+
+void dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg, int nelems,
+			 enum dma_data_direction direction)
+{
+	int i;
+
+	BUG_ON(!valid_dma_direction(direction));
+
+	/* Make sure that gcc doesn't leave the empty loop body.  */
+	for_each_sg(sg, sg, nelems, i)
+		__dma_sync(sg_virt(sg), sg->length, direction);
+}
+EXPORT_SYMBOL(dma_sync_sg_for_cpu);
+
+void dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
+				int nelems, enum dma_data_direction direction)
+{
+	int i;
+
+	BUG_ON(!valid_dma_direction(direction));
+
+	/* Make sure that gcc doesn't leave the empty loop body.  */
+	for_each_sg(sg, sg, nelems, i)
+		__dma_sync(sg_virt(sg), sg->length, direction);
+
+}
+EXPORT_SYMBOL(dma_sync_sg_for_device);
-- 
1.8.3.2

