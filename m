Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352AbaJWRfI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 13:35:08 -0400
Received: from smtp.citrix.com ([66.165.176.89]:28822 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752690AbaJWRfC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 13:35:02 -0400
X-IronPort-AV: E=Sophos;i="5.04,776,1406592000"; 
   d="scan'208";a="184362046"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <konrad.wilk@oracle.com>, <Ian.Campbell@citrix.com>,
        <david.vrabel@citrix.com>, <linux-kernel@vger.kernel.org>,
        <Stefano.Stabellini@eu.citrix.com>,
        <linux-arm-kernel@lists.infradead.org>, <will.deacon@arm.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v5 3/6] xen/arm: introduce xen_is_dma_coherent
Date: Thu, 23 Oct 2014 18:27:23 +0100
Message-ID: <1414085246-16160-3-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1410231821520.876@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1410231821520.876@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a utility function to check whether a device is dma coherent.
The current implementation is suboptimal. Let's rework it later in
common arch/arm code.

Use it to figure out whether we need to issue cache maintenance
operations instead of checking on the existence of a particular dma_ops
function for the device.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

---

Changes in v5:
- introduce xen_is_dma_coherent as a xen specific function;
- call xen_is_dma_coherent instead of is_dma_coherent.
---
 arch/arm/include/asm/xen/page-coherent.h |    5 +++++
 arch/arm/xen/mm32.c                      |    6 +++---
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/arm/include/asm/xen/page-coherent.h b/arch/arm/include/asm/xen/page-coherent.h
index e8275ea..6f0f882 100644
--- a/arch/arm/include/asm/xen/page-coherent.h
+++ b/arch/arm/include/asm/xen/page-coherent.h
@@ -5,6 +5,11 @@
 #include <linux/dma-attrs.h>
 #include <linux/dma-mapping.h>
 
+static inline bool xen_is_dma_coherent(struct device *dev)
+{
+    return (__generic_dma_ops(dev) == &arm_coherent_dma_ops);
+}
+ 
 static inline void *xen_alloc_coherent_pages(struct device *hwdev, size_t size,
 		dma_addr_t *dma_handle, gfp_t flags,
 		struct dma_attrs *attrs)
diff --git a/arch/arm/xen/mm32.c b/arch/arm/xen/mm32.c
index 6153d61..6c0224e 100644
--- a/arch/arm/xen/mm32.c
+++ b/arch/arm/xen/mm32.c
@@ -76,7 +76,7 @@ void xen_dma_unmap_page(struct device *hwdev, dma_addr_t handle,
 		struct dma_attrs *attrs)
 
 {
-	if (!__generic_dma_ops(hwdev)->unmap_page)
+	if (xen_is_dma_coherent(hwdev))
 		return;
 	if (dma_get_attr(DMA_ATTR_SKIP_CPU_SYNC, attrs))
 		return;
@@ -87,7 +87,7 @@ void xen_dma_unmap_page(struct device *hwdev, dma_addr_t handle,
 void xen_dma_sync_single_for_cpu(struct device *hwdev,
 		dma_addr_t handle, size_t size, enum dma_data_direction dir)
 {
-	if (!__generic_dma_ops(hwdev)->sync_single_for_cpu)
+	if (xen_is_dma_coherent(hwdev))
 		return;
 	__xen_dma_page_dev_to_cpu(hwdev, handle, size, dir);
 }
@@ -95,7 +95,7 @@ void xen_dma_sync_single_for_cpu(struct device *hwdev,
 void xen_dma_sync_single_for_device(struct device *hwdev,
 		dma_addr_t handle, size_t size, enum dma_data_direction dir)
 {
-	if (!__generic_dma_ops(hwdev)->sync_single_for_device)
+	if (xen_is_dma_coherent(hwdev))
 		return;
 	__xen_dma_page_cpu_to_dev(hwdev, handle, size, dir);
 }
-- 
1.7.10.4

