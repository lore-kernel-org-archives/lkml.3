Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210AbaKJQRq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 11:17:46 -0500
Received: from smtp.citrix.com ([66.165.176.89]:36052 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139AbaKJQPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 11:15:10 -0500
X-IronPort-AV: E=Sophos;i="5.07,353,1413244800"; 
   d="scan'208";a="189798977"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <konrad.wilk@oracle.com>, <Ian.Campbell@citrix.com>,
        <david.vrabel@citrix.com>, <linux-kernel@vger.kernel.org>,
        <Stefano.Stabellini@eu.citrix.com>,
        <linux-arm-kernel@lists.infradead.org>, <catalin.marinas@arm.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <will.deacon@arm.com>
Subject: [PATCH v8 04/13] arm64: introduce is_device_dma_coherent
Date: Mon, 10 Nov 2014 16:13:56 +0000
Message-ID: <1415636045-24669-4-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1411101607130.22875@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1411101607130.22875@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a boolean flag and an accessor function to check whether a
device is dma_coherent. Set the flag from set_arch_dma_coherent_ops.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
CC: will.deacon@arm.com
---
 arch/arm64/include/asm/device.h      |    1 +
 arch/arm64/include/asm/dma-mapping.h |    6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/arch/arm64/include/asm/device.h b/arch/arm64/include/asm/device.h
index cf98b36..243ef25 100644
--- a/arch/arm64/include/asm/device.h
+++ b/arch/arm64/include/asm/device.h
@@ -21,6 +21,7 @@ struct dev_archdata {
 #ifdef CONFIG_IOMMU_API
 	void *iommu;			/* private IOMMU data */
 #endif
+	bool dma_coherent;
 };
 
 struct pdev_archdata {
diff --git a/arch/arm64/include/asm/dma-mapping.h b/arch/arm64/include/asm/dma-mapping.h
index adeae3f..e213dc4 100644
--- a/arch/arm64/include/asm/dma-mapping.h
+++ b/arch/arm64/include/asm/dma-mapping.h
@@ -54,11 +54,17 @@ static inline void set_dma_ops(struct device *dev, struct dma_map_ops *ops)
 
 static inline int set_arch_dma_coherent_ops(struct device *dev)
 {
+	dev->archdata.dma_coherent = true;
 	set_dma_ops(dev, &coherent_swiotlb_dma_ops);
 	return 0;
 }
 #define set_arch_dma_coherent_ops	set_arch_dma_coherent_ops
 
+static inline bool is_device_dma_coherent(struct device *dev)
+{
+	return dev->archdata.dma_coherent;
+}
+
 #include <asm-generic/dma-mapping-common.h>
 
 static inline dma_addr_t phys_to_dma(struct device *dev, phys_addr_t paddr)
-- 
1.7.10.4

