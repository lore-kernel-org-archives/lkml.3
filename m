Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242Ab3JIUtg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 16:49:36 -0400
Received: from smtp.citrix.com ([66.165.176.89]:28260 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019Ab3JIUta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 16:49:30 -0400
X-IronPort-AV: E=Sophos;i="4.90,1066,1371081600"; 
   d="scan'208";a="62111338"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <konrad.wilk@oracle.com>, <Stefano.Stabellini@eu.citrix.com>,
        <Ian.Campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <will.deacon@arm.com>, <linux@arm.linux.org.uk>
Subject: [PATCH v8 08/17] arm/xen: get_dma_ops: return xen_dma_ops if we are running as xen_initial_domain
Date: Wed, 9 Oct 2013 21:48:21 +0100
Message-ID: <1381351710-1876-8-git-send-email-stefano.stabellini@eu.citrix.com>
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
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
CC: will.deacon@arm.com
CC: linux@arm.linux.org.uk

Changes in v7:
- return xen_dma_ops only if we are the initial domain;
- rename __get_dma_ops to __generic_dma_ops.
---
 arch/arm/include/asm/dma-mapping.h |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dma-mapping.h
index 9aa5384..d03519a 100644
--- a/arch/arm/include/asm/dma-mapping.h
+++ b/arch/arm/include/asm/dma-mapping.h
@@ -12,17 +12,28 @@
 #include <asm/memory.h>
 #include <asm/cacheflush.h>
 
+#include <xen/xen.h>
+#include <asm/xen/hypervisor.h>
+
 #define DMA_ERROR_CODE	(~0)
 extern struct dma_map_ops arm_dma_ops;
 extern struct dma_map_ops arm_coherent_dma_ops;
 
-static inline struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline struct dma_map_ops *__generic_dma_ops(struct device *dev)
 {
 	if (dev && dev->archdata.dma_ops)
 		return dev->archdata.dma_ops;
 	return &arm_dma_ops;
 }
 
+static inline struct dma_map_ops *get_dma_ops(struct device *dev)
+{
+	if (xen_initial_domain())
+		return xen_dma_ops;
+	else
+		return __generic_dma_ops(dev);
+}
+
 static inline void set_dma_ops(struct device *dev, struct dma_map_ops *ops)
 {
 	BUG_ON(!dev);
-- 
1.7.2.5

