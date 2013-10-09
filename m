Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990Ab3JIUtb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 16:49:31 -0400
Received: from smtp.citrix.com ([66.165.176.89]:19220 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755595Ab3JIUt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 16:49:29 -0400
X-IronPort-AV: E=Sophos;i="4.90,1066,1371081600"; 
   d="scan'208";a="62111337"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <konrad.wilk@oracle.com>, <Stefano.Stabellini@eu.citrix.com>,
        <Ian.Campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <will.deacon@arm.com>
Subject: [PATCH v8 09/17] arm64/xen: get_dma_ops: return xen_dma_ops if we are running as xen_initial_domain
Date: Wed, 9 Oct 2013 21:48:22 +0100
Message-ID: <1381351710-1876-9-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1310092109190.26077@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1310092109190.26077@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can't simply override arm_dma_ops with xen_dma_ops because devices
are allowed to have their own dma_ops and they take precedence over
arm_dma_ops. When running on Xen as initial domain, we always want
xen_dma_ops to be the one in use.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
CC: will.deacon@arm.com

Changes in v7:
- return xen_dma_ops only if we are the initial domain;
- rename __get_dma_ops to __generic_dma_ops.
---
 arch/arm64/include/asm/dma-mapping.h |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/arch/arm64/include/asm/dma-mapping.h b/arch/arm64/include/asm/dma-mapping.h
index c2cb8a0..6763c29 100644
--- a/arch/arm64/include/asm/dma-mapping.h
+++ b/arch/arm64/include/asm/dma-mapping.h
@@ -23,12 +23,15 @@
 
 #include <asm-generic/dma-coherent.h>
 
+#include <xen/xen.h>
+#include <asm/xen/hypervisor.h>
+
 #define ARCH_HAS_DMA_GET_REQUIRED_MASK
 
 #define DMA_ERROR_CODE	(~0)
 extern struct dma_map_ops *dma_ops;
 
-static inline struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline struct dma_map_ops *__generic_dma_ops(struct device *dev)
 {
 	if (unlikely(!dev) || !dev->archdata.dma_ops)
 		return dma_ops;
@@ -36,6 +39,14 @@ static inline struct dma_map_ops *get_dma_ops(struct device *dev)
 		return dev->archdata.dma_ops;
 }
 
+static inline struct dma_map_ops *get_dma_ops(struct device *dev)
+{
+	if (xen_initial_domain())
+		return xen_dma_ops;
+	else
+		return __generic_dma_ops(dev);
+}
+
 #include <asm-generic/dma-mapping-common.h>
 
 static inline dma_addr_t phys_to_dma(struct device *dev, phys_addr_t paddr)
-- 
1.7.2.5

