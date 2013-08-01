Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076Ab3HAWWn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 18:22:43 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39851 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572Ab3HAWWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 18:22:41 -0400
In-Reply-To: <20130801213420.GL23006@n2100.arm.linux.org.uk>
References: <20130801213420.GL23006@n2100.arm.linux.org.uk>
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH RFC 48/51] ARM: 7795/1: mm: dma-mapping: Add dma_max_pfn(dev)
 helper function
Message-Id: <E1V51GA-0006uY-KR@rmk-PC.arm.linux.org.uk>
Date: Thu, 01 Aug 2013 23:22:14 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the kernel assumes that PFN0 is the start of the physical
memory (RAM). This assumptions is not true on most of the ARM SOCs
and hence and if one try to update the ARM port to follow the assumptions,
we end of breaking the dma bounce limit for few block layer drivers.
One such example is trying to unify the meaning of max*_pfn on ARM
as the bootmem layer expects, breaks few block layer driver dma
bounce limit.

To fix this problem, we introduce dma_max_pfn(dev) generic helper with
a possibility of override from the architecture code. The helper converts
a DMA bitmask of bits to a block PFN number. In all the generic cases,
it is just  "dev->dma_mask >> PAGE_SHIFT" and hence default behavior
is maintained as is.

Subsequent patches will make use of the helper. No functional change.

Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 include/linux/dma-mapping.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 48ef6f5..4ce089e 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -153,6 +153,13 @@ static inline int dma_set_seg_boundary(struct device *dev, unsigned long mask)
 		return -EIO;
 }
 
+#ifndef dma_max_pfn
+static inline unsigned long dma_max_pfn(struct device *dev)
+{
+	return *dev->dma_mask >> PAGE_SHIFT;
+}
+#endif
+
 static inline void *dma_zalloc_coherent(struct device *dev, size_t size,
 					dma_addr_t *dma_handle, gfp_t flag)
 {
-- 
1.7.4.4

