Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab3I0QNd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 12:13:33 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:32635 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565Ab3I0QKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 12:10:54 -0400
X-IronPort-AV: E=Sophos;i="4.90,994,1371081600"; 
   d="scan'208";a="55582482"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <konrad.wilk@oracle.com>, <Stefano.Stabellini@eu.citrix.com>,
        <Ian.Campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <catalin.marinas@arm.com>, <will.deacon@arm.com>
Subject: [PATCH v6 09/19] arm64/xen: get_dma_ops: return xen_dma_ops if we are running on Xen
Date: Fri, 27 Sep 2013 17:09:57 +0100
Message-ID: <1380298207-29151-9-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1309271653420.5498@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1309271653420.5498@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
CC: catalin.marinas@arm.com
CC: will.deacon@arm.com
---
 arch/arm64/include/asm/dma-mapping.h |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/arch/arm64/include/asm/dma-mapping.h b/arch/arm64/include/asm/dma-mapping.h
index c2cb8a0..1dbd1d5 100644
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
+static inline struct dma_map_ops *__get_dma_ops(struct device *dev)
 {
 	if (unlikely(!dev) || !dev->archdata.dma_ops)
 		return dma_ops;
@@ -36,6 +39,14 @@ static inline struct dma_map_ops *get_dma_ops(struct device *dev)
 		return dev->archdata.dma_ops;
 }
 
+static inline struct dma_map_ops *get_dma_ops(struct device *dev)
+{
+	if (xen_domain())
+		return xen_dma_ops;
+	else
+		return __get_dma_ops(dev);
+}
+
 #include <asm-generic/dma-mapping-common.h>
 
 static inline dma_addr_t phys_to_dma(struct device *dev, phys_addr_t paddr)
-- 
1.7.2.5

