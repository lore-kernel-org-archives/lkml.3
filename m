Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbaJ1LpQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:45:16 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:33025 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752129AbaJ1LpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:45:12 -0400
From: Will Deacon <will.deacon@arm.com>
To: torvalds@linux-foundation.org, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        benh@kernel.crashing.org, Will Deacon <will.deacon@arm.com>
Subject: [RFC PATCH 2/2] zap_pte_range: fix partial TLB flushing in response to a dirty pte
Date: Tue, 28 Oct 2014 11:44:22 +0000
Message-Id: <1414496662-25202-3-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414496662-25202-1-git-send-email-will.deacon@arm.com>
References: <1414496662-25202-1-git-send-email-will.deacon@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we encounter a dirty page during unmap, we force a TLB invalidation
to avoid a race with pte_mkclean and stale, dirty TLB entries in the
CPU.

This uses the same force_flush logic as the batch failure code, but
since we don't break out of the loop when finding a dirty pte, tlb->end
can be < addr as we only batch for present ptes. This can result in a
negative range being passed to subsequent TLB invalidation calls,
potentially leading to massive over-invalidation of the TLB (observed
in practice running firefox on arm64).

This patch fixes the issue by restricting the use of addr in the TLB
range calculations. The first range then ends up covering tlb->start to
min(tlb->end, addr), which corresponds to the currently batched range.
The second range then covers anything remaining, which may still lead to
a (much reduced) over-invalidation of the TLB.

Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 mm/memory.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 3e503831e042..ea41508d41f3 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1194,11 +1194,10 @@ again:
 		 * then update the range to be the remaining
 		 * TLB range.
 		 */
-		old_end = tlb->end;
-		tlb->end = addr;
+		tlb->end = old_end = min(tlb->end, addr);
 		tlb_flush_mmu_tlbonly(tlb);
-		tlb->start = addr;
-		tlb->end = old_end;
+		tlb->start = old_end;
+		tlb->end = end;
 	}
 	pte_unmap_unlock(start_pte, ptl);
 
-- 
2.1.1

