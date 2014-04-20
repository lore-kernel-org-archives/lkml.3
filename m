Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430AbaDTMlM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 08:41:12 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:39492 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755396AbaDTMkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 08:40:06 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Woodhouse <dwmw2@infradead.org>, Don Dutile <ddutile@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        x86@kernel.org, iommu@lists.linux-foundation.org
Subject: [PATCH -mm 2/2] x86: avoid duplicated memset in dma_generic_alloc_coherent()
Date: Sun, 20 Apr 2014 21:39:47 +0900
Message-Id: <1397997587-11021-3-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397997587-11021-1-git-send-email-akinobu.mita@gmail.com>
References: <1397997587-11021-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes duplicated memset that is introduced by the patch
x86-make-dma_alloc_coherent-return-zeroed-memory-if-cma-is-enabled.patch
in -mm tree, and this change should be folded into it.

If dma_generic_alloc_coherent() is called with __GFP_ZERO, it does a
duplicated memset to the memory area allocated by alloc_pages_node()
with __GFP_ZERO.  This change fixes that inefficiency by clearing
__GFP_ZERO bit in gfp flages before calling alloc_pages_node().  Note
that dma_generic_alloc_coherent() always returns zeroed memory.

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
 arch/x86/kernel/pci-dma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index f15bf8d..a25e202 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -97,6 +97,7 @@ void *dma_generic_alloc_coherent(struct device *dev, size_t size,
 
 	dma_mask = dma_alloc_coherent_mask(dev, flag);
 
+	flag &= ~__GFP_ZERO;
 again:
 	page = NULL;
 	/* CMA can be used only in the context which permits sleeping */
-- 
1.8.3.2

