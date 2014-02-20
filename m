Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbaBTQVa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 11:21:30 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:50713 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132AbaBTQV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 11:21:29 -0500
From: Julien Grall <julien.grall@linaro.org>
To: linux-kernel@vger.kernel.org, stefano.stabellini@eu.citrix.com
Cc: linux-arm-kernel@lists.infradead.org, ian.campbell@citrix.com,
        xen-devel@lists.xenproject.org, Julien Grall <julien.grall@linaro.org>,
        Russell King <linux@arm.linux.org.co.uk>
Subject: [PATCH 1/2] arm/xen: Introduce need_xen_dma_ops and use it in get_dma_ops
Date: Thu, 20 Feb 2014 16:21:21 +0000
Message-Id: <1392913281-25483-1-git-send-email-julien.grall@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If Xen programs the IOMMU to protect a device, it can safely use it's own DMA
ops. Some devices may use DMA but are not protected by an IOMMU. A such device
still need to use xen-swiotlb.

This patch introduces need_xen_dma_ops which will check if a device needs to
use xen DMA ops. For now, it's only check if Linux is running as DOM0.

Signed-off-by: Julien Grall <julien.grall@linaro.org>
Cc: Russell King <linux@arm.linux.org.co.uk>
---
 arch/arm/include/asm/dma-mapping.h     |    5 ++---
 arch/arm/include/asm/xen/dma-mapping.h |   13 +++++++++++++
 arch/arm/include/asm/xen/hypervisor.h  |    2 --
 3 files changed, 15 insertions(+), 5 deletions(-)
 create mode 100644 arch/arm/include/asm/xen/dma-mapping.h

diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dma-mapping.h
index e701a4d..a40d077 100644
--- a/arch/arm/include/asm/dma-mapping.h
+++ b/arch/arm/include/asm/dma-mapping.h
@@ -11,8 +11,7 @@
 #include <asm-generic/dma-coherent.h>
 #include <asm/memory.h>
 
-#include <xen/xen.h>
-#include <asm/xen/hypervisor.h>
+#include <asm/xen/dma-mapping.h>
 
 #define DMA_ERROR_CODE	(~0)
 extern struct dma_map_ops arm_dma_ops;
@@ -27,7 +26,7 @@ static inline struct dma_map_ops *__generic_dma_ops(struct device *dev)
 
 static inline struct dma_map_ops *get_dma_ops(struct device *dev)
 {
-	if (xen_initial_domain())
+	if (need_xen_dma_ops(dev))
 		return xen_dma_ops;
 	else
 		return __generic_dma_ops(dev);
diff --git a/arch/arm/include/asm/xen/dma-mapping.h b/arch/arm/include/asm/xen/dma-mapping.h
new file mode 100644
index 0000000..002fc57
--- /dev/null
+++ b/arch/arm/include/asm/xen/dma-mapping.h
@@ -0,0 +1,13 @@
+#ifndef _ASM_ARM_XEN_DMA_MAPPING_H
+#define _ASM_ARM_XEN_DMA_MAPPING_H
+
+#include <xen/xen.h>
+
+extern struct dma_map_ops *xen_dma_ops;
+
+static inline bool need_xen_dma_ops(struct device *dev)
+{
+	return xen_initial_domain();
+}
+
+#endif /* _ASM_ARM_XEN_DMA_MAPPING_H */
diff --git a/arch/arm/include/asm/xen/hypervisor.h b/arch/arm/include/asm/xen/hypervisor.h
index 1317ee4..d7ab99a 100644
--- a/arch/arm/include/asm/xen/hypervisor.h
+++ b/arch/arm/include/asm/xen/hypervisor.h
@@ -16,6 +16,4 @@ static inline enum paravirt_lazy_mode paravirt_get_lazy_mode(void)
 	return PARAVIRT_LAZY_NONE;
 }
 
-extern struct dma_map_ops *xen_dma_ops;
-
 #endif /* _ASM_ARM_XEN_HYPERVISOR_H */
-- 
1.7.10.4

