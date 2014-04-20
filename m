Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415AbaDTMk7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 08:40:59 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:60460 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755364AbaDTMkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 08:40:01 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Woodhouse <dwmw2@infradead.org>, Don Dutile <ddutile@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        x86@kernel.org, iommu@lists.linux-foundation.org
Subject: [PATCH -mm 1/2] x86: fix dma_generic_alloc_coherent() when CONFIG_DMA_CMA is enabled
Date: Sun, 20 Apr 2014 21:39:46 +0900
Message-Id: <1397997587-11021-2-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397997587-11021-1-git-send-email-akinobu.mita@gmail.com>
References: <1397997587-11021-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dma_generic_alloc_coherent() firstly attempts to allocate by
dma_alloc_from_contiguous() if CONFIG_DMA_CMA is enabled. But the memory
region allocated by it may not fit within the device's DMA mask.
This change makes it fall back to usual alloc_pages_node() allocation
for such cases.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Don Dutile <ddutile@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: x86@kernel.org
Cc: iommu@lists.linux-foundation.org
---
 arch/x86/kernel/pci-dma.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index a0ffe44..f15bf8d 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -100,8 +100,13 @@ void *dma_generic_alloc_coherent(struct device *dev, size_t size,
 again:
 	page = NULL;
 	/* CMA can be used only in the context which permits sleeping */
-	if (flag & __GFP_WAIT)
+	if (flag & __GFP_WAIT) {
 		page = dma_alloc_from_contiguous(dev, count, get_order(size));
+		if (page && page_to_phys(page) + size > dma_mask) {
+			dma_release_from_contiguous(dev, page, count);
+			page = NULL;
+		}
+	}
 	/* fallback */
 	if (!page)
 		page = alloc_pages_node(dev_to_node(dev), flag, get_order(size));
-- 
1.8.3.2

