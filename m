Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760690AbaLLGdY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:33:24 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51972 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759332AbaLLGQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:58 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Will Deacon" <will.deacon@arm.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.969256740@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 091/164] zap_pte_range: update addr when forcing flush
 after TLB batching faiure
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context; add braces]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1178,8 +1178,10 @@ again:
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

