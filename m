Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616AbaLEOJL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 09:09:11 -0500
Received: from smtp.citrix.com ([66.165.176.89]:49772 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860AbaLEOIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 09:08:17 -0500
X-IronPort-AV: E=Sophos;i="5.07,522,1413244800"; 
   d="scan'208";a="200351489"
From: David Vrabel <david.vrabel@citrix.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: David Vrabel <david.vrabel@citrix.com>, <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        <xen-devel@lists.xenproject.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH 1/4] dma: add dma_get_required_mask_from_max_pfn()
Date: Fri, 5 Dec 2014 14:08:00 +0000
Message-ID: <1417788483-662-2-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1417788483-662-1-git-send-email-david.vrabel@citrix.com>
References: <1417788483-662-1-git-send-email-david.vrabel@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A generic dma_get_required_mask() is useful even for architectures (such
as ia64) that define ARCH_HAS_GET_REQUIRED_MASK.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Reviewed-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 drivers/base/platform.c     |   10 ++++++++--
 include/linux/dma-mapping.h |    1 +
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index b2afc29..f9f3930 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -1009,8 +1009,7 @@ int __init platform_bus_init(void)
 	return error;
 }
 
-#ifndef ARCH_HAS_DMA_GET_REQUIRED_MASK
-u64 dma_get_required_mask(struct device *dev)
+u64 dma_get_required_mask_from_max_pfn(struct device *dev)
 {
 	u32 low_totalram = ((max_pfn - 1) << PAGE_SHIFT);
 	u32 high_totalram = ((max_pfn - 1) >> (32 - PAGE_SHIFT));
@@ -1028,6 +1027,13 @@ u64 dma_get_required_mask(struct device *dev)
 	}
 	return mask;
 }
+EXPORT_SYMBOL_GPL(dma_get_required_mask_from_max_pfn);
+
+#ifndef ARCH_HAS_DMA_GET_REQUIRED_MASK
+u64 dma_get_required_mask(struct device *dev)
+{
+	return dma_get_required_mask_from_max_pfn(dev);
+}
 EXPORT_SYMBOL_GPL(dma_get_required_mask);
 #endif
 
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index d5d3881..6e2fdfc 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -127,6 +127,7 @@ static inline int dma_coerce_mask_and_coherent(struct device *dev, u64 mask)
 	return dma_set_mask_and_coherent(dev, mask);
 }
 
+extern u64 dma_get_required_mask_from_max_pfn(struct device *dev);
 extern u64 dma_get_required_mask(struct device *dev);
 
 #ifndef set_arch_dma_coherent_ops
-- 
1.7.10.4

