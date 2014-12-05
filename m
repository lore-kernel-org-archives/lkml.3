Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502AbaLEOIV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 09:08:21 -0500
Received: from smtp.citrix.com ([66.165.176.89]:49772 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160AbaLEOIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 09:08:17 -0500
X-IronPort-AV: E=Sophos;i="5.07,522,1413244800"; 
   d="scan'208";a="200351492"
From: David Vrabel <david.vrabel@citrix.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: David Vrabel <david.vrabel@citrix.com>, <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        <xen-devel@lists.xenproject.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH 3/4] x86: allow dma_get_required_mask() to be overridden
Date: Fri, 5 Dec 2014 14:08:02 +0000
Message-ID: <1417788483-662-4-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1417788483-662-1-git-send-email-david.vrabel@citrix.com>
References: <1417788483-662-1-git-send-email-david.vrabel@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use dma_ops->get_required_mask() if provided, defaulting to
dma_get_requried_mask_from_max_pfn().

This is needed on systems (such as Xen PV guests) where the DMA
address and the physical address are not equal.

ARCH_HAS_DMA_GET_REQUIRED_MASK is defined in asm/device.h instead of
asm/dma-mapping.h because linux/dma-mapping.h uses the define before
including asm/dma-mapping.h

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Reviewed-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/x86/include/asm/device.h |    2 ++
 arch/x86/kernel/pci-dma.c     |    8 ++++++++
 2 files changed, 10 insertions(+)

diff --git a/arch/x86/include/asm/device.h b/arch/x86/include/asm/device.h
index 03dd729..10bc628 100644
--- a/arch/x86/include/asm/device.h
+++ b/arch/x86/include/asm/device.h
@@ -13,4 +13,6 @@ struct dev_archdata {
 struct pdev_archdata {
 };
 
+#define ARCH_HAS_DMA_GET_REQUIRED_MASK
+
 #endif /* _ASM_X86_DEVICE_H */
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index a25e202..5154400 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -140,6 +140,14 @@ void dma_generic_free_coherent(struct device *dev, size_t size, void *vaddr,
 		free_pages((unsigned long)vaddr, get_order(size));
 }
 
+u64 dma_get_required_mask(struct device *dev)
+{
+	if (dma_ops->get_required_mask)
+		return dma_ops->get_required_mask(dev);
+	return dma_get_required_mask_from_max_pfn(dev);
+}
+EXPORT_SYMBOL_GPL(dma_get_required_mask);
+
 /*
  * See <Documentation/x86/x86_64/boot-options.txt> for the iommu kernel
  * parameter documentation.
-- 
1.7.10.4

