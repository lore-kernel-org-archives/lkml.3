Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062AbaJJLyZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 07:54:25 -0400
Received: from smtp.citrix.com ([66.165.176.89]:22994 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607AbaJJLyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 07:54:16 -0400
X-IronPort-AV: E=Sophos;i="5.04,691,1406592000"; 
   d="scan'208";a="180114192"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <konrad.wilk@oracle.com>, <Ian.Campbell@citrix.com>,
        <david.vrabel@citrix.com>, <linux-kernel@vger.kernel.org>,
        <Stefano.Stabellini@eu.citrix.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v4 7/7] xen/arm: introduce GNTTABOP_cache_flush
Date: Fri, 10 Oct 2014 12:51:48 +0100
Message-ID: <1412941908-5850-7-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1410101244090.17038@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1410101244090.17038@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce support for new hypercall GNTTABOP_cache_flush.
Use it to perform cache flashing on pages used for dma when necessary.

If GNTTABOP_cache_flush is supported by the hypervisor, we don't need to
bounce dma map operations that involve foreign grants and non-coherent
devices.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

---

Changes in v4:
- add comment;
- avoid bouncing dma map operations that involve foreign grants and
non-coherent devices if GNTTABOP_cache_flush is provided by Xen.

Changes in v3:
- fix the cache maintenance op call to match what Linux does natively;
- update the hypercall interface to match Xen.

Changes in v2:
- update the hypercall interface to match Xen;
- call the interface on a single page at a time.
---
 arch/arm/xen/mm.c                   |   41 ++++++++++++++++++++++++++++++-----
 include/xen/interface/grant_table.h |   19 ++++++++++++++++
 2 files changed, 54 insertions(+), 6 deletions(-)

diff --git a/arch/arm/xen/mm.c b/arch/arm/xen/mm.c
index 0c2a75a..21db123 100644
--- a/arch/arm/xen/mm.c
+++ b/arch/arm/xen/mm.c
@@ -11,6 +11,7 @@
 #include <linux/swiotlb.h>
 
 #include <xen/xen.h>
+#include <xen/interface/grant_table.h>
 #include <xen/interface/memory.h>
 #include <xen/swiotlb-xen.h>
 
@@ -44,6 +45,8 @@ static inline void *kmap_high_get(struct page *page)
 static inline void kunmap_high(struct page *page) {}
 #endif
 
+static bool hypercall_flush = false;
+
 
 /* functions called by SWIOTLB */
 
@@ -60,17 +63,35 @@ static void dma_cache_maint(dma_addr_t handle, unsigned long offset,
 	do {
 		size_t len = left;
 		void *vaddr;
+
+		/* buffers in highmem or foreign pages cannot cross page
+		 * boundaries */
+		if (len + offset > PAGE_SIZE)
+			len = PAGE_SIZE - offset;
 	
 		if (!pfn_valid(pfn))
 		{
-			/* TODO: cache flush */
+			struct gnttab_cache_flush cflush;
+
+			cflush.op = 0;
+			cflush.a.dev_bus_addr = pfn << PAGE_SHIFT;
+			cflush.offset = offset;
+			cflush.length = len;
+
+			if (op == dmac_unmap_area && dir != DMA_TO_DEVICE)
+				cflush.op = GNTTAB_CACHE_INVAL;
+			if (op == dmac_map_area) {
+				if (dir == DMA_FROM_DEVICE)
+					cflush.op = GNTTAB_CACHE_INVAL;
+				else
+					cflush.op = GNTTAB_CACHE_CLEAN;
+			}
+			if (cflush.op)
+				HYPERVISOR_grant_table_op(GNTTABOP_cache_flush, &cflush, 1);
 		} else {
 			struct page *page = pfn_to_page(pfn);
 
 			if (PageHighMem(page)) {
-				if (len + offset > PAGE_SIZE)
-					len = PAGE_SIZE - offset;
-
 				if (cache_is_vipt_nonaliasing()) {
 					vaddr = kmap_atomic(page);
 					op(vaddr + offset, len, dir);
@@ -143,7 +164,7 @@ bool xen_arch_need_swiotlb(struct device *dev,
 						   unsigned long pfn,
 						   unsigned long mfn)
 {
-	return ((pfn != mfn) && !is_dma_coherent(dev));
+	return (!hypercall_flush && (pfn != mfn) && !is_dma_coherent(dev));
 }
 
 int xen_create_contiguous_region(phys_addr_t pstart, unsigned int order,
@@ -186,10 +207,18 @@ static struct dma_map_ops xen_swiotlb_dma_ops = {
 
 int __init xen_mm_init(void)
 {
+	struct gnttab_cache_flush cflush;
 	if (!xen_initial_domain())
 		return 0;
 	xen_swiotlb_init(1, false);
 	xen_dma_ops = &xen_swiotlb_dma_ops;
+
+	cflush.op = 0;
+	cflush.a.dev_bus_addr = 0;
+	cflush.offset = 0;
+	cflush.length = 0;
+	if (HYPERVISOR_grant_table_op(GNTTABOP_cache_flush, &cflush, 1) != -ENOSYS)
+		hypercall_flush = true;
 	return 0;
 }
-arch_initcall(xen_mm_init);
+arch_initcall(xen_mm_init)
diff --git a/include/xen/interface/grant_table.h b/include/xen/interface/grant_table.h
index e40fae9..bcce564 100644
--- a/include/xen/interface/grant_table.h
+++ b/include/xen/interface/grant_table.h
@@ -479,6 +479,25 @@ struct gnttab_get_version {
 DEFINE_GUEST_HANDLE_STRUCT(gnttab_get_version);
 
 /*
+ * Issue one or more cache maintenance operations on a portion of a
+ * page granted to the calling domain by a foreign domain.
+ */
+#define GNTTABOP_cache_flush          12
+struct gnttab_cache_flush {
+    union {
+        uint64_t dev_bus_addr;
+        grant_ref_t ref;
+    } a;
+    uint16_t offset;   /* offset from start of grant */
+    uint16_t length;   /* size within the grant */
+#define GNTTAB_CACHE_CLEAN          (1<<0)
+#define GNTTAB_CACHE_INVAL          (1<<1)
+#define GNTTAB_CACHE_SOURCE_GREF    (1<<31)
+    uint32_t op;
+};
+DEFINE_GUEST_HANDLE_STRUCT(gnttab_cache_flush);
+
+/*
  * Bitfield values for update_pin_status.flags.
  */
  /* Map the grant entry for access by I/O devices. */
-- 
1.7.10.4

