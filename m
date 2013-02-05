Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201Ab3BEWan (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:30:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47921 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757161Ab3BEWJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:09:01 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 22/93] ARM: DMA: Fix struct page iterator in dma_cache_maint() to work with sparsemem
Date: Tue,  5 Feb 2013 20:06:11 -0200
Message-Id: <1360102042-10732-23-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
References: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.5 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/arm/mm/dma-mapping.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 655878b..b9eaf1c 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -789,25 +789,27 @@ static void dma_cache_maint_page(struct page *page, unsigned long offset,
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
@@ -824,7 +826,7 @@ static void dma_cache_maint_page(struct page *page, unsigned long offset,
 			op(vaddr, len, dir);
 		}
 		offset = 0;
-		page++;
+		pfn++;
 		left -= len;
 	} while (left);
 }
-- 
1.7.9.5

