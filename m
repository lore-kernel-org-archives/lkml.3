Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970AbaJBKJQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 06:09:16 -0400
Received: from smtp.citrix.com ([66.165.176.89]:19603 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797AbaJBKJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 06:09:13 -0400
X-IronPort-AV: E=Sophos;i="5.04,638,1406592000"; 
   d="scan'208";a="177413608"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <konrad.wilk@oracle.com>, <Ian.Campbell@citrix.com>,
        <david.vrabel@citrix.com>, <linux-kernel@vger.kernel.org>,
        <Stefano.Stabellini@eu.citrix.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 2/2] xen/arm: introduce XENMEM_cache_flush
Date: Thu, 2 Oct 2014 11:06:57 +0100
Message-ID: <1412244417-12251-2-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1410021102480.17038@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1410021102480.17038@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce support for new hypercall XENMEM_cache_flush.
Use it to perform cache flashing on pages used for dma when necessary.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/arm/xen/mm32.c            |   19 ++++++++++++++++++-
 include/xen/interface/memory.h |   16 ++++++++++++++++
 2 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/arch/arm/xen/mm32.c b/arch/arm/xen/mm32.c
index a5a93fc..aa45332 100644
--- a/arch/arm/xen/mm32.c
+++ b/arch/arm/xen/mm32.c
@@ -4,6 +4,9 @@
 #include <linux/highmem.h>
 
 #include <xen/features.h>
+#include <xen/interface/memory.h>
+
+#include <asm/xen/hypercall.h>
 
 
 /* functions called by SWIOTLB */
@@ -24,7 +27,21 @@ static void dma_cache_maint(dma_addr_t handle, unsigned long offset,
 	
 		if (!pfn_valid(pfn))
 		{
-			/* TODO: cache flush */
+			struct xen_cache_flush cflush;
+
+			cflush.op = 0;
+			cflush.addr = handle + offset;
+			cflush.size = size;
+
+			if (op == dmac_unmap_area && dir != DMA_TO_DEVICE)
+				cflush.op = XENMEM_CACHE_INVAL;
+			if (op == dmac_map_area) {
+				cflush.op = XENMEM_CACHE_CLEAN;
+				if (dir == DMA_FROM_DEVICE)
+					cflush.op |= XENMEM_CACHE_INVAL;
+			}
+			if (cflush.op)
+				HYPERVISOR_memory_op(XENMEM_cache_flush, &cflush);
 		} else {
 			struct page *page = pfn_to_page(pfn);
 
diff --git a/include/xen/interface/memory.h b/include/xen/interface/memory.h
index 2ecfe4f..7d7e039 100644
--- a/include/xen/interface/memory.h
+++ b/include/xen/interface/memory.h
@@ -263,4 +263,20 @@ struct xen_remove_from_physmap {
 };
 DEFINE_GUEST_HANDLE_STRUCT(xen_remove_from_physmap);
 
+/*
+ * Issue one or more cache maintenance operations on a memory range
+ * owned by the calling domain or granted to the calling domain by a
+ * foreign domain.
+ */
+#define XENMEM_cache_flush                 27
+struct xen_cache_flush {
+/* addr is the machine address at the start of the memory range */
+uint64_t addr;
+uint64_t size;
+#define XENMEM_CACHE_CLEAN      (1<<0)
+#define XENMEM_CACHE_INVAL      (1<<1)
+uint32_t op;
+};
+DEFINE_GUEST_HANDLE_STRUCT(xen_cache_flush);
+
 #endif /* __XEN_PUBLIC_MEMORY_H__ */
-- 
1.7.10.4

