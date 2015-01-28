Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964963AbbA1EXb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:23:31 -0500
Received: from mail.kernel.org ([198.145.29.136]:40336 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934460AbbA1EX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:23:27 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 111/177] zap_pte_range: update addr when forcing flush after TLB batching faiure
Date: Wed, 28 Jan 2015 12:09:29 +0800
Message-Id: <1422418236-12852-202-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


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
[lizf: Backported to 3.4: adjust context]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 mm/memory.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index ffd74f3..c34e60a 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1164,8 +1164,10 @@ again:
 			if (unlikely(page_mapcount(page) < 0))
 				print_bad_pte(vma, addr, ptent, page);
 			force_flush = !__tlb_remove_page(tlb, page);
-			if (force_flush)
+			if (force_flush) {
+				addr += PAGE_SIZE;
 				break;
+			}
 			continue;
 		}
 		/*
-- 
1.9.1

