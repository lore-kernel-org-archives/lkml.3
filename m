Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546Ab3BCO4u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 09:56:50 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34374 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754311Ab3BCO4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:56:41 -0500
Message-Id: <20130203144650.343359756@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:47:55 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Russell King <rmk+kernel@arm.linux.org.uk>,
        James Bottomley <JBottomley@Parallels.com>,
        Subhash Jadavani <subhashj@codeaurora.org>
Subject: [ 071/128] ARM: DMA: Fix struct page iterator in dma_cache_maint() to work with
 sparsemem
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit 15653371c67c3fbe359ae37b720639dd4c7b42c5 upstream.

Subhash Jadavani reported this partial backtrace:
  Now consider this call stack from MMC block driver (this is on the ARMv7
  based board):

  [<c001b50c>] (v7_dma_inv_range+0x30/0x48) from [<c0017b8c>] (dma_cache_maint_page+0x1c4/0x24c)
  [<c0017b8c>] (dma_cache_maint_page+0x1c4/0x24c) from [<c0017c28>] (___dma_page_cpu_to_dev+0x14/0x1c)
  [<c0017c28>] (___dma_page_cpu_to_dev+0x14/0x1c) from [<c0017ff8>] (dma_map_sg+0x3c/0x114)

This is caused by incrementing the struct page pointer, and running off
the end of the sparsemem page array.  Fix this by incrementing by pfn
instead, and convert the pfn to a struct page.

Suggested-by: James Bottomley <JBottomley@Parallels.com>
Tested-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/mm/dma-mapping.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 6b2fb87..076c26d 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -774,25 +774,27 @@ static void dma_cache_maint_page(struct page *page, unsigned long offset,
 	size_t size, enum dma_data_direction dir,
 	void (*op)(const void *, size_t, int))
 {
+	unsigned long pfn;
+	size_t left = size;
+
+	pfn = page_to_pfn(page) + offset / PAGE_SIZE;
+	offset %= PAGE_SIZE;
+
 	/*
 	 * A single sg entry may refer to multiple physically contiguous
 	 * pages.  But we still need to process highmem pages individually.
 	 * If highmem is not configured then the bulk of this loop gets
 	 * optimized out.
 	 */
-	size_t left = size;
 	do {
 		size_t len = left;
 		void *vaddr;
 
+		page = pfn_to_page(pfn);
+
 		if (PageHighMem(page)) {
-			if (len + offset > PAGE_SIZE) {
-				if (offset >= PAGE_SIZE) {
-					page += offset / PAGE_SIZE;
-					offset %= PAGE_SIZE;
-				}
+			if (len + offset > PAGE_SIZE)
 				len = PAGE_SIZE - offset;
-			}
 			vaddr = kmap_high_get(page);
 			if (vaddr) {
 				vaddr += offset;
@@ -809,7 +811,7 @@ static void dma_cache_maint_page(struct page *page, unsigned long offset,
 			op(vaddr, len, dir);
 		}
 		offset = 0;
-		page++;
+		pfn++;
 		left -= len;
 	} while (left);
 }


