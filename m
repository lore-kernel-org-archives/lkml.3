Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945AbaKLLlf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 06:41:35 -0500
Received: from smtp.citrix.com ([66.165.176.89]:15000 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893AbaKLLlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 06:41:32 -0500
X-IronPort-AV: E=Sophos;i="5.07,368,1413244800"; 
   d="scan'208";a="190474975"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <konrad.wilk@oracle.com>, <Ian.Campbell@citrix.com>,
        <david.vrabel@citrix.com>, <linux-kernel@vger.kernel.org>,
        <Stefano.Stabellini@eu.citrix.com>,
        <linux-arm-kernel@lists.infradead.org>, <catalin.marinas@arm.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v9 08/13] xen/arm: use hypercall to flush caches in map_page
Date: Wed, 12 Nov 2014 11:40:49 +0000
Message-ID: <1415792454-23161-8-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1411121130020.26318@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1411121130020.26318@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In xen_dma_map_page, if the page is a local page, call the native
map_page dma_ops. If the page is foreign, call __xen_dma_map_page that
issues any required cache maintenane operations via hypercall.

The reason for doing this is that the native dma_ops map_page could
allocate buffers than need to be freed. If the page is foreign we don't
call the native unmap_page dma_ops function, resulting in a memory leak.

Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

---

Changes in v9:
- map_page is always present;
- use bool local for clarity;
- add a comment.
---
 arch/arm/include/asm/xen/page-coherent.h |   13 ++++++++++++-
 arch/arm/xen/mm32.c                      |   12 ++++++++++++
 2 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/xen/page-coherent.h b/arch/arm/include/asm/xen/page-coherent.h
index a309f42..efd5624 100644
--- a/arch/arm/include/asm/xen/page-coherent.h
+++ b/arch/arm/include/asm/xen/page-coherent.h
@@ -5,6 +5,9 @@
 #include <linux/dma-attrs.h>
 #include <linux/dma-mapping.h>
 
+void __xen_dma_map_page(struct device *hwdev, struct page *page,
+	     dma_addr_t dev_addr, unsigned long offset, size_t size,
+	     enum dma_data_direction dir, struct dma_attrs *attrs);
 void __xen_dma_unmap_page(struct device *hwdev, dma_addr_t handle,
 		size_t size, enum dma_data_direction dir,
 		struct dma_attrs *attrs);
@@ -32,7 +35,15 @@ static inline void xen_dma_map_page(struct device *hwdev, struct page *page,
 	     dma_addr_t dev_addr, unsigned long offset, size_t size,
 	     enum dma_data_direction dir, struct dma_attrs *attrs)
 {
-	__generic_dma_ops(hwdev)->map_page(hwdev, page, offset, size, dir, attrs);
+	bool local = PFN_DOWN(dev_addr) == page_to_pfn(page);
+	/* Dom0 is mapped 1:1, so if pfn == mfn the page is local otherwise
+	 * is a foreign page grant-mapped in dom0. If the page is local we
+	 * can safely call the native dma_ops function, otherwise we call
+	 * the xen specific function. */
+	if (local)
+		__generic_dma_ops(hwdev)->map_page(hwdev, page, offset, size, dir, attrs);
+	else
+		__xen_dma_map_page(hwdev, page, dev_addr, offset, size, dir, attrs);
 }
 
 static inline void xen_dma_unmap_page(struct device *hwdev, dma_addr_t handle,
diff --git a/arch/arm/xen/mm32.c b/arch/arm/xen/mm32.c
index 3ce9dc1..c86919b 100644
--- a/arch/arm/xen/mm32.c
+++ b/arch/arm/xen/mm32.c
@@ -43,6 +43,18 @@ static void __xen_dma_page_cpu_to_dev(struct device *hwdev, dma_addr_t handle,
 	dma_cache_maint(handle & PAGE_MASK, handle & ~PAGE_MASK, size, dir, DMA_MAP);
 }
 
+void __xen_dma_map_page(struct device *hwdev, struct page *page,
+	     dma_addr_t dev_addr, unsigned long offset, size_t size,
+	     enum dma_data_direction dir, struct dma_attrs *attrs)
+{
+	if (is_device_dma_coherent(hwdev))
+		return;
+	if (dma_get_attr(DMA_ATTR_SKIP_CPU_SYNC, attrs))
+		return;
+
+	__xen_dma_page_cpu_to_dev(hwdev, dev_addr, size, dir);
+}
+
 void __xen_dma_unmap_page(struct device *hwdev, dma_addr_t handle,
 		size_t size, enum dma_data_direction dir,
 		struct dma_attrs *attrs)
-- 
1.7.10.4

