Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930AbaJ1LpK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:45:10 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:33023 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750900AbaJ1LpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:45:08 -0400
From: Will Deacon <will.deacon@arm.com>
To: torvalds@linux-foundation.org, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        benh@kernel.crashing.org, Will Deacon <will.deacon@arm.com>
Subject: [RFC PATCH 1/2] zap_pte_range: update addr when forcing flush after TLB batching faiure
Date: Tue, 28 Oct 2014 11:44:21 +0000
Message-Id: <1414496662-25202-2-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414496662-25202-1-git-send-email-will.deacon@arm.com>
References: <1414496662-25202-1-git-send-email-will.deacon@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 mm/memory.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/memory.c b/mm/memory.c
index 1cc6bfbd872e..3e503831e042 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1147,6 +1147,7 @@ again:
 				print_bad_pte(vma, addr, ptent, page);
 			if (unlikely(!__tlb_remove_page(tlb, page))) {
 				force_flush = 1;
+				addr += PAGE_SIZE;
 				break;
 			}
 			continue;
-- 
2.1.1

