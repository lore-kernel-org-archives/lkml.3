Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643Ab3JYKxg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 06:53:36 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:26713 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461Ab3JYKxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 06:53:09 -0400
X-IronPort-AV: E=Sophos;i="4.93,569,1378857600"; 
   d="scan'208";a="64684019"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <konrad.wilk@oracle.com>, <Stefano.Stabellini@eu.citrix.com>,
        <Ian.Campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v9 10/18] xen: introduce xen_alloc/free_coherent_pages
Date: Fri, 25 Oct 2013 11:51:45 +0100
Message-ID: <1382698313-13161-10-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1310251144020.26077@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1310251144020.26077@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xen_swiotlb_alloc_coherent needs to allocate a coherent buffer for cpu
and devices. On native x86 is sufficient to call __get_free_pages in
order to get a coherent buffer, while on ARM (and potentially ARM64) we
need to call the native dma_ops->alloc implementation.

Introduce xen_alloc_coherent_pages to abstract the arch specific buffer
allocation.

Similarly introduce xen_free_coherent_pages to free a coherent buffer:
on x86 is simply a call to free_pages while on ARM and ARM64 is
arm_dma_ops.free.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>


Changes in v7:
- rename __get_dma_ops to __generic_dma_ops;
- call __generic_dma_ops(hwdev)->alloc/free on arm64 too.

Changes in v6:
- call __get_dma_ops to get the native dma_ops pointer on arm.
---
 arch/arm/include/asm/xen/page-coherent.h   |   22 ++++++++++++++++++++++
 arch/arm64/include/asm/xen/page-coherent.h |   22 ++++++++++++++++++++++
 arch/ia64/include/asm/xen/page-coherent.h  |   24 ++++++++++++++++++++++++
 arch/x86/include/asm/xen/page-coherent.h   |   24 ++++++++++++++++++++++++
 4 files changed, 92 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/include/asm/xen/page-coherent.h
 create mode 100644 arch/arm64/include/asm/xen/page-coherent.h
 create mode 100644 arch/ia64/include/asm/xen/page-coherent.h
 create mode 100644 arch/x86/include/asm/xen/page-coherent.h

diff --git a/arch/arm/include/asm/xen/page-coherent.h b/arch/arm/include/asm/xen/page-coherent.h
new file mode 100644
index 0000000..c4d843c
--- /dev/null
+++ b/arch/arm/include/asm/xen/page-coherent.h
@@ -0,0 +1,22 @@
+#ifndef _ASM_ARM_XEN_PAGE_COHERENT_H
+#define _ASM_ARM_XEN_PAGE_COHERENT_H
+
+#include <asm/page.h>
+#include <linux/dma-attrs.h>
+#include <linux/dma-mapping.h>
+
+static inline void *xen_alloc_coherent_pages(struct device *hwdev, size_t size,
+		dma_addr_t *dma_handle, gfp_t flags,
+		struct dma_attrs *attrs)
+{
+	return __generic_dma_ops(hwdev)->alloc(hwdev, size, dma_handle, flags, attrs);
+}
+
+static inline void xen_free_coherent_pages(struct device *hwdev, size_t size,
+		void *cpu_addr, dma_addr_t dma_handle,
+		struct dma_attrs *attrs)
+{
+	__generic_dma_ops(hwdev)->free(hwdev, size, cpu_addr, dma_handle, attrs);
+}
+
+#endif /* _ASM_ARM_XEN_PAGE_COHERENT_H */
diff --git a/arch/arm64/include/asm/xen/page-coherent.h b/arch/arm64/include/asm/xen/page-coherent.h
new file mode 100644
index 0000000..3b4f029
--- /dev/null
+++ b/arch/arm64/include/asm/xen/page-coherent.h
@@ -0,0 +1,22 @@
+#ifndef _ASM_ARM64_XEN_PAGE_COHERENT_H
+#define _ASM_ARM64_XEN_PAGE_COHERENT_H
+
+#include <asm/page.h>
+#include <linux/dma-attrs.h>
+#include <linux/dma-mapping.h>
+
+static inline void *xen_alloc_coherent_pages(struct device *hwdev, size_t size,
+		dma_addr_t *dma_handle, gfp_t flags,
+		struct dma_attrs *attrs)
+{
+	return __generic_dma_ops(hwdev)->alloc(hwdev, size, dma_handle, flags, attrs);
+}
+
+static inline void xen_free_coherent_pages(struct device *hwdev, size_t size,
+		void *cpu_addr, dma_addr_t dma_handle,
+		struct dma_attrs *attrs)
+{
+	__generic_dma_ops(hwdev)->free(hwdev, size, cpu_addr, dma_handle, attrs);
+}
+
+#endif /* _ASM_ARM64_XEN_PAGE_COHERENT_H */
diff --git a/arch/ia64/include/asm/xen/page-coherent.h b/arch/ia64/include/asm/xen/page-coherent.h
new file mode 100644
index 0000000..37b929c
--- /dev/null
+++ b/arch/ia64/include/asm/xen/page-coherent.h
@@ -0,0 +1,24 @@
+#ifndef _ASM_IA64_XEN_PAGE_COHERENT_H
+#define _ASM_IA64_XEN_PAGE_COHERENT_H
+
+#include <asm/page.h>
+#include <linux/dma-attrs.h>
+#include <linux/dma-mapping.h>
+
+static inline void *xen_alloc_coherent_pages(struct device *hwdev, size_t size,
+		dma_addr_t *dma_handle, gfp_t flags,
+		struct dma_attrs *attrs)
+{
+	void *vstart = (void*)__get_free_pages(flags, get_order(size));
+	*dma_handle = virt_to_phys(vstart);
+	return vstart;
+}
+
+static inline void xen_free_coherent_pages(struct device *hwdev, size_t size,
+		void *cpu_addr, dma_addr_t dma_handle,
+		struct dma_attrs *attrs)
+{
+	free_pages((unsigned long) cpu_addr, get_order(size));
+}
+
+#endif /* _ASM_IA64_XEN_PAGE_COHERENT_H */
diff --git a/arch/x86/include/asm/xen/page-coherent.h b/arch/x86/include/asm/xen/page-coherent.h
new file mode 100644
index 0000000..31de2e0
--- /dev/null
+++ b/arch/x86/include/asm/xen/page-coherent.h
@@ -0,0 +1,24 @@
+#ifndef _ASM_X86_XEN_PAGE_COHERENT_H
+#define _ASM_X86_XEN_PAGE_COHERENT_H
+
+#include <asm/page.h>
+#include <linux/dma-attrs.h>
+#include <linux/dma-mapping.h>
+
+static inline void *xen_alloc_coherent_pages(struct device *hwdev, size_t size,
+		dma_addr_t *dma_handle, gfp_t flags,
+		struct dma_attrs *attrs)
+{
+	void *vstart = (void*)__get_free_pages(flags, get_order(size));
+	*dma_handle = virt_to_phys(vstart);
+	return vstart;
+}
+
+static inline void xen_free_coherent_pages(struct device *hwdev, size_t size,
+		void *cpu_addr, dma_addr_t dma_handle,
+		struct dma_attrs *attrs)
+{
+	free_pages((unsigned long) cpu_addr, get_order(size));
+}
+
+#endif /* _ASM_X86_XEN_PAGE_COHERENT_H */
-- 
1.7.2.5

