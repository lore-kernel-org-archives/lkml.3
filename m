Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477AbaKKLLX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:11:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57832 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456AbaKKLLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:11:21 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Will Deacon <will.deacon@arm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 146/170] zap_pte_range: update addr when forcing flush after TLB batching faiure
Date: Tue, 11 Nov 2014 11:08:25 +0000
Message-Id: <1415704129-12709-147-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit ce9ec37bddb633404a0c23e1acb181a264e7f7f2 upstream.

When unmapping a range of pages in zap_pte_range, the page being
unmapped is added to an mmu_gather_batch structure for asynchronous
freeing. If we run out of space in the batch structure before the range
has been completely unmapped, then we break out of the loop, force a
TLB flush and free the pages that we have batched so far. If there are
further pages to unmap, then we resume the loop where we left off.

Unfortunately, we forget to update addr when we break out of the loop,
which causes us to truncate the range being invalidated as the end
address is exclusive. When we re-enter the loop at the same address, the
page has already been freed and the pte_present test will fail, meaning
that we do not reconsider the address for invalidation.

This patch fixes the problem by incrementing addr by the PAGE_SIZE
before breaking out of the loop on batch failure.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 mm/memory.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/memory.c b/mm/memory.c
index 533023da2faa..7e9f0918559b 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1145,6 +1145,7 @@ again:
 				print_bad_pte(vma, addr, ptent, page);
 			if (unlikely(!__tlb_remove_page(tlb, page))) {
 				force_flush = 1;
+				addr += PAGE_SIZE;
 				break;
 			}
 			continue;
-- 
2.1.0

