Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab3JYLFh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 07:05:37 -0400
Received: from smtp.citrix.com ([66.165.176.89]:37752 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752770Ab3JYLFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 07:05:35 -0400
X-IronPort-AV: E=Sophos;i="4.93,569,1378857600"; 
   d="scan'208";a="67327290"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <konrad.wilk@oracle.com>, <Stefano.Stabellini@eu.citrix.com>,
        <Ian.Campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v9 12/18] xen: introduce xen_dma_map/unmap_page and xen_dma_sync_single_for_cpu/device
Date: Fri, 25 Oct 2013 11:51:47 +0100
Message-ID: <1382698313-13161-12-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1310251144020.26077@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1310251144020.26077@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce xen_dma_map_page, xen_dma_unmap_page,
xen_dma_sync_single_for_cpu and xen_dma_sync_single_for_device.
They have empty implementations on x86 and ia64 but they call the
corresponding platform dma_ops function on arm and arm64.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Changes in v9:
- xen_dma_map_page return void, avoid page_to_phys.
---
 arch/arm/include/asm/xen/page-coherent.h   |   28 ++++++++++++++++++++++++++++
 arch/arm64/include/asm/xen/page-coherent.h |   25 +++++++++++++++++++++++++
 arch/ia64/include/asm/xen/page-coherent.h  |   14 ++++++++++++++
 arch/x86/include/asm/xen/page-coherent.h   |   14 ++++++++++++++
 4 files changed, 81 insertions(+), 0 deletions(-)

diff --git a/arch/arm/include/asm/xen/page-coherent.h b/arch/arm/include/asm/xen/page-coherent.h
index c4d843c..1109017 100644
--- a/arch/arm/include/asm/xen/page-coherent.h
+++ b/arch/arm/include/asm/xen/page-coherent.h
@@ -19,4 +19,32 @@ static inline void xen_free_coherent_pages(struct device *hwdev, size_t size,
 	__generic_dma_ops(hwdev)->free(hwdev, size, cpu_addr, dma_handle, attrs);
 }
 
+static inline void xen_dma_map_page(struct device *hwdev, struct page *page,
+	     unsigned long offset, size_t size, enum dma_data_direction dir,
+	     struct dma_attrs *attrs)
+{
+	__generic_dma_ops(hwdev)->map_page(hwdev, page, offset, size, dir, attrs);
+}
+
+static inline void xen_dma_unmap_page(struct device *hwdev, dma_addr_t handle,
+		size_t size, enum dma_data_direction dir,
+		struct dma_attrs *attrs)
+{
+	if (__generic_dma_ops(hwdev)->unmap_page)
+		__generic_dma_ops(hwdev)->unmap_page(hwdev, handle, size, dir, attrs);
+}
+
+static inline void xen_dma_sync_single_for_cpu(struct device *hwdev,
+		dma_addr_t handle, size_t size, enum dma_data_direction dir)
+{
+	if (__generic_dma_ops(hwdev)->sync_single_for_cpu)
+		__generic_dma_ops(hwdev)->sync_single_for_cpu(hwdev, handle, size, dir);
+}
+
+static inline void xen_dma_sync_single_for_device(struct device *hwdev,
+		dma_addr_t handle, size_t size, enum dma_data_direction dir)
+{
+	if (__generic_dma_ops(hwdev)->sync_single_for_device)
+		__generic_dma_ops(hwdev)->sync_single_for_device(hwdev, handle, size, dir);
+}
 #endif /* _ASM_ARM_XEN_PAGE_COHERENT_H */
diff --git a/arch/arm64/include/asm/xen/page-coherent.h b/arch/arm64/include/asm/xen/page-coherent.h
index 3b4f029..2820f1a 100644
--- a/arch/arm64/include/asm/xen/page-coherent.h
+++ b/arch/arm64/include/asm/xen/page-coherent.h
@@ -19,4 +19,29 @@ static inline void xen_free_coherent_pages(struct device *hwdev, size_t size,
 	__generic_dma_ops(hwdev)->free(hwdev, size, cpu_addr, dma_handle, attrs);
 }
 
+static inline void xen_dma_map_page(struct device *hwdev, struct page *page,
+	     unsigned long offset, size_t size, enum dma_data_direction dir,
+	     struct dma_attrs *attrs)
+{
+	__generic_dma_ops(hwdev)->map_page(hwdev, page, offset, size, dir, attrs);
+}
+
+static inline void xen_dma_unmap_page(struct device *hwdev, dma_addr_t handle,
+		size_t size, enum dma_data_direction dir,
+		struct dma_attrs *attrs)
+{
+	__generic_dma_ops(hwdev)->unmap_page(hwdev, handle, size, dir, attrs);
+}
+
+static inline void xen_dma_sync_single_for_cpu(struct device *hwdev,
+		dma_addr_t handle, size_t size, enum dma_data_direction dir)
+{
+	__generic_dma_ops(hwdev)->sync_single_for_cpu(hwdev, handle, size, dir);
+}
+
+static inline void xen_dma_sync_single_for_device(struct device *hwdev,
+		dma_addr_t handle, size_t size, enum dma_data_direction dir)
+{
+	__generic_dma_ops(hwdev)->sync_single_for_device(hwdev, handle, size, dir);
+}
 #endif /* _ASM_ARM64_XEN_PAGE_COHERENT_H */
diff --git a/arch/ia64/include/asm/xen/page-coherent.h b/arch/ia64/include/asm/xen/page-coherent.h
index 37b929c..96e42f9 100644
--- a/arch/ia64/include/asm/xen/page-coherent.h
+++ b/arch/ia64/include/asm/xen/page-coherent.h
@@ -21,4 +21,18 @@ static inline void xen_free_coherent_pages(struct device *hwdev, size_t size,
 	free_pages((unsigned long) cpu_addr, get_order(size));
 }
 
+static inline void xen_dma_map_page(struct device *hwdev, struct page *page,
+	     unsigned long offset, size_t size, enum dma_data_direction dir,
+	     struct dma_attrs *attrs) { }
+
+static inline void xen_dma_unmap_page(struct device *hwdev, dma_addr_t handle,
+		size_t size, enum dma_data_direction dir,
+		struct dma_attrs *attrs) { }
+
+static inline void xen_dma_sync_single_for_cpu(struct device *hwdev,
+		dma_addr_t handle, size_t size, enum dma_data_direction dir) { }
+
+static inline void xen_dma_sync_single_for_device(struct device *hwdev,
+		dma_addr_t handle, size_t size, enum dma_data_direction dir) { }
+
 #endif /* _ASM_IA64_XEN_PAGE_COHERENT_H */
diff --git a/arch/x86/include/asm/xen/page-coherent.h b/arch/x86/include/asm/xen/page-coherent.h
index 31de2e0..7f02fe4 100644
--- a/arch/x86/include/asm/xen/page-coherent.h
+++ b/arch/x86/include/asm/xen/page-coherent.h
@@ -21,4 +21,18 @@ static inline void xen_free_coherent_pages(struct device *hwdev, size_t size,
 	free_pages((unsigned long) cpu_addr, get_order(size));
 }
 
+static inline void xen_dma_map_page(struct device *hwdev, struct page *page,
+	     unsigned long offset, size_t size, enum dma_data_direction dir,
+	     struct dma_attrs *attrs) { }
+
+static inline void xen_dma_unmap_page(struct device *hwdev, dma_addr_t handle,
+		size_t size, enum dma_data_direction dir,
+		struct dma_attrs *attrs) { }
+
+static inline void xen_dma_sync_single_for_cpu(struct device *hwdev,
+		dma_addr_t handle, size_t size, enum dma_data_direction dir) { }
+
+static inline void xen_dma_sync_single_for_device(struct device *hwdev,
+		dma_addr_t handle, size_t size, enum dma_data_direction dir) { }
+
 #endif /* _ASM_X86_XEN_PAGE_COHERENT_H */
-- 
1.7.2.5

