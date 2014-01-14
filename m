Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855AbaANOOX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 09:14:23 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:65244 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbaANOOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 09:14:17 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Woodhouse <dwmw2@infradead.org>, Don Dutile <ddutile@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        x86@kernel.org, iommu@lists.linux-foundation.org
Subject: [PATCH v2 1/5] x86: make dma_alloc_coherent() return zeroed memory if CMA is enabled
Date: Tue, 14 Jan 2014 23:13:46 +0900
Message-Id: <1389708830-5841-2-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389708830-5841-1-git-send-email-akinobu.mita@gmail.com>
References: <1389708830-5841-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calling dma_alloc_coherent() with __GFP_ZERO must return zeroed memory.

But when the contiguous memory allocator (CMA) is enabled on x86 and
the memory region is allocated by dma_alloc_from_contiguous(), it
doesn't return zeroed memory.  Because dma_generic_alloc_coherent()
forgot to fill the memory region with zero if it was allocated by
dma_alloc_from_contiguous()

Most implementations of dma_alloc_coherent() return zeroed memory
regardless of whether __GFP_ZERO is specified.  So this fixes it by
unconditionally zeroing the allocated memory region.

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
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
New patch from this version

 arch/x86/kernel/pci-dma.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 872079a..9644405 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -97,7 +97,6 @@ void *dma_generic_alloc_coherent(struct device *dev, size_t size,
 
 	dma_mask = dma_alloc_coherent_mask(dev, flag);
 
-	flag |= __GFP_ZERO;
 again:
 	page = NULL;
 	if (!(flag & GFP_ATOMIC))
@@ -118,7 +117,7 @@ again:
 
 		return NULL;
 	}
-
+	memset(page_address(page), 0, size);
 	*dma_addr = addr;
 	return page_address(page);
 }
-- 
1.8.3.2

