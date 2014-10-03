Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384AbaJCOz7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 10:55:59 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:45946 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbaJCOzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 10:55:46 -0400
X-IronPort-AV: E=Sophos;i="5.04,647,1406592000"; 
   d="scan'208";a="178979922"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <konrad.wilk@oracle.com>, <Ian.Campbell@citrix.com>,
        <david.vrabel@citrix.com>, <linux-kernel@vger.kernel.org>,
        <Stefano.Stabellini@eu.citrix.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v2 2/2] xen/arm: introduce GNTTABOP_cache_flush
Date: Fri, 3 Oct 2014 15:53:26 +0100
Message-ID: <1412348006-27884-2-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1410031549150.17038@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1410031549150.17038@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce support for new hypercall GNTTABOP_cache_flush.
Use it to perform cache flashing on pages used for dma when necessary.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

---
Changes in v2:
- update the hypercall interface to match Xen;
- call the interface on a single page at a time.
---
 arch/arm/xen/mm32.c                 |   26 ++++++++++++++++++++++----
 include/xen/interface/grant_table.h |   18 ++++++++++++++++++
 2 files changed, 40 insertions(+), 4 deletions(-)

diff --git a/arch/arm/xen/mm32.c b/arch/arm/xen/mm32.c
index a5a93fc..6ca09c2 100644
--- a/arch/arm/xen/mm32.c
+++ b/arch/arm/xen/mm32.c
@@ -4,6 +4,9 @@
 #include <linux/highmem.h>
 
 #include <xen/features.h>
+#include <xen/interface/grant_table.h>
+
+#include <asm/xen/hypercall.h>
 
 
 /* functions called by SWIOTLB */
@@ -22,16 +25,31 @@ static void dma_cache_maint(dma_addr_t handle, unsigned long offset,
 		size_t len = left;
 		void *vaddr;
 	
+		if (len + offset > PAGE_SIZE)
+			len = PAGE_SIZE - offset;
+
 		if (!pfn_valid(pfn))
 		{
-			/* TODO: cache flush */
+			struct gnttab_cache_flush cflush;
+
+			cflush.op = 0;
+			cflush.a.dev_bus_addr = pfn << PAGE_SHIFT;
+			cflush.offset = offset;
+			cflush.size = len;
+
+			if (op == dmac_unmap_area && dir != DMA_TO_DEVICE)
+				cflush.op = GNTTAB_CACHE_INVAL;
+			if (op == dmac_map_area) {
+				cflush.op = GNTTAB_CACHE_CLEAN;
+				if (dir == DMA_FROM_DEVICE)
+					cflush.op |= GNTTAB_CACHE_INVAL;
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
diff --git a/include/xen/interface/grant_table.h b/include/xen/interface/grant_table.h
index e40fae9..28ff207 100644
--- a/include/xen/interface/grant_table.h
+++ b/include/xen/interface/grant_table.h
@@ -479,6 +479,24 @@ struct gnttab_get_version {
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
+    uint32_t offset; /* offset from start of grant */
+    uint32_t size;   /* size within the grant */
+#define GNTTAB_CACHE_CLEAN      (1<<0)
+#define GNTTAB_CACHE_INVAL      (1<<1)
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

