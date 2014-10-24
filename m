Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076AbaJXIdv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 04:33:51 -0400
Received: from mail-by2on0058.outbound.protection.outlook.com ([207.46.100.58]:41040
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755756AbaJXIZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 04:25:42 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, Ley Foon Tan <lftan@altera.com>,
        <lftan.linux@gmail.com>, <cltang@codesourcery.com>
Subject: [PATCH v5 14/29] nios2: DMA mapping API
Date: Fri, 24 Oct 2014 16:24:16 +0800
Message-ID: <1414139071-3818-15-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1414139071-3818-1-git-send-email-lftan@altera.com>
References: <1414139071-3818-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(199003)(189002)(22564002)(87936001)(21056001)(106466001)(19580405001)(76176999)(44976005)(2201001)(107046002)(92566001)(62966002)(6806004)(86362001)(76482002)(93916002)(229853001)(120916001)(92726001)(105596002)(99396003)(87286001)(68736004)(95666004)(19580395003)(85306004)(102836001)(84676001)(104166001)(85852003)(31966008)(20776003)(47776003)(64706001)(48376002)(50226001)(42186005)(46102003)(36756003)(89996001)(97736003)(88136002)(77096002)(4396001)(50986999)(50466002)(80022003)(33646002)(77156001);DIR:OUT;SFP:1101;SCL:1;SRVR:CO2PR03MB1017;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO2PR03MB1017;
X-Forefront-PRVS: 0374433C81
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=lftan@altera.com; 
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the DMA mapping API.

Signed-off-by: Ley Foon Tan <lftan@altera.com>
---
 arch/nios2/include/asm/dma-mapping.h | 130 ++++++++++++++++++++++++
 arch/nios2/mm/dma-mapping.c          | 185 +++++++++++++++++++++++++++++++++++
 2 files changed, 315 insertions(+)
 create mode 100644 arch/nios2/include/asm/dma-mapping.h
 create mode 100644 arch/nios2/mm/dma-mapping.c

diff --git a/arch/nios2/include/asm/dma-mapping.h b/arch/nios2/include/asm/dma-mapping.h
new file mode 100644
index 0000000..8c3bf4b
--- /dev/null
+++ b/arch/nios2/include/asm/dma-mapping.h
@@ -0,0 +1,130 @@
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
+static inline void __dma_sync_for_device(void *vaddr, size_t size,
+			      enum dma_data_direction direction)
+{
+	switch (direction) {
+	case DMA_FROM_DEVICE:
+		invalidate_dcache_range((unsigned long)vaddr,
+			(unsigned long)(vaddr + size));
+		break;
+	case DMA_TO_DEVICE:
+		/*
+		 * We just need to flush the caches here , but Nios2 flush
+		 * instruction will do both writeback and invalidate.
+		 */
+	case DMA_BIDIRECTIONAL: /* flush and invalidate */
+		flush_dcache_range((unsigned long)vaddr,
+			(unsigned long)(vaddr + size));
+		break;
+	default:
+		BUG();
+	}
+}
+
+static inline void __dma_sync_for_cpu(void *vaddr, size_t size,
+			      enum dma_data_direction direction)
+{
+	switch (direction) {
+	case DMA_BIDIRECTIONAL:
+	case DMA_FROM_DEVICE:
+		invalidate_dcache_range((unsigned long)vaddr,
+			(unsigned long)(vaddr + size));
+		break;
+	case DMA_TO_DEVICE:
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
+	BUG_ON(!valid_dma_direction(direction));
+	__dma_sync_for_device(ptr, size, direction);
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
+/*
+* dma_alloc_noncoherent() returns non-cacheable memory, so there's no need to
+* do any flushing here.
+*/
+static inline void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
+				  enum dma_data_direction direction)
+{
+}
+
+#endif /* _ASM_NIOS2_DMA_MAPPING_H */
diff --git a/arch/nios2/mm/dma-mapping.c b/arch/nios2/mm/dma-mapping.c
new file mode 100644
index 0000000..2f00713
--- /dev/null
+++ b/arch/nios2/mm/dma-mapping.c
@@ -0,0 +1,185 @@
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
+			__dma_sync_for_device(addr, sg->length, direction);
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
+	__dma_sync_for_device(addr, size, direction);
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
+	__dma_sync_for_cpu(phys_to_virt(dma_address), size, direction);
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
+			__dma_sync_for_cpu(addr, sg->length, direction);
+	}
+}
+EXPORT_SYMBOL(dma_unmap_sg);
+
+void dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle,
+			     size_t size, enum dma_data_direction direction)
+{
+	BUG_ON(!valid_dma_direction(direction));
+
+	__dma_sync_for_cpu(phys_to_virt(dma_handle), size, direction);
+}
+EXPORT_SYMBOL(dma_sync_single_for_cpu);
+
+void dma_sync_single_for_device(struct device *dev, dma_addr_t dma_handle,
+				size_t size, enum dma_data_direction direction)
+{
+	BUG_ON(!valid_dma_direction(direction));
+
+	__dma_sync_for_device(phys_to_virt(dma_handle), size, direction);
+}
+EXPORT_SYMBOL(dma_sync_single_for_device);
+
+void dma_sync_single_range_for_cpu(struct device *dev, dma_addr_t dma_handle,
+					unsigned long offset, size_t size,
+					enum dma_data_direction direction)
+{
+	BUG_ON(!valid_dma_direction(direction));
+
+	__dma_sync_for_cpu(phys_to_virt(dma_handle), size, direction);
+}
+EXPORT_SYMBOL(dma_sync_single_range_for_cpu);
+
+void dma_sync_single_range_for_device(struct device *dev, dma_addr_t dma_handle,
+					unsigned long offset, size_t size,
+					enum dma_data_direction direction)
+{
+	BUG_ON(!valid_dma_direction(direction));
+
+	__dma_sync_for_device(phys_to_virt(dma_handle), size, direction);
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
+		__dma_sync_for_cpu(sg_virt(sg), sg->length, direction);
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
+		__dma_sync_for_device(sg_virt(sg), sg->length, direction);
+
+}
+EXPORT_SYMBOL(dma_sync_sg_for_device);
-- 
1.8.2.1

