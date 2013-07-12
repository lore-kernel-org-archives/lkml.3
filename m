Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965506Ab3GLVt3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 17:49:29 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:59148 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757437Ab3GLVtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 17:49:24 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Russell King <rmk@arm.linux.org.uk>, Jens Axboe <axboe@kernel.dk>
Subject: [RFC/RFT PATCH 2/5] mm: dma-mapping: Add dma_max_pfn(dev) helper function
Date: Fri, 12 Jul 2013 17:48:11 -0400
Message-ID: <1373665694-7580-3-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373665694-7580-1-git-send-email-santosh.shilimkar@ti.com>
References: <1373665694-7580-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
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

Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Jens Axboe <axboe@kernel.dk>

Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 include/linux/dma-mapping.h |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 94af418..68a7863 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -129,6 +129,13 @@ static inline int dma_set_seg_boundary(struct device *dev, unsigned long mask)
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
1.7.9.5

