Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965926Ab3E2M4l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 08:56:41 -0400
Received: from us01smtp3.synopsys.com ([198.182.44.81]:37023 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965690Ab3E2M4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 08:56:39 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
CC: Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        Rik van Riel <riel@redhat.com>, David Rientjes <rientjes@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH] mm: Fix the TLB range flushed when __tlb_remove_page() runs out of slots
Date: Wed, 29 May 2013 18:26:13 +0530
Message-ID: <1369832173-15088-1-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.232]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zap_pte_range loops from @addr to @end. In the middle, if it runs out of
batching slots, TLB entries needs to be flushed for @start to @interim,
NOT @interim to @end.

Since ARC port doesn't use page free batching I can't test it myself but
this seems like the right thing to do.
Observed this when working on a fix for the issue at thread:
	http://www.spinics.net/lists/linux-arch/msg21736.html

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: linux-mm@kvack.org
Cc: linux-arch@vger.kernel.org <linux-arch@vger.kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
---
 mm/memory.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 6dc1882..d9d5fd9 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1110,6 +1110,7 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
 	spinlock_t *ptl;
 	pte_t *start_pte;
 	pte_t *pte;
+	unsigned long range_start = addr;
 
 again:
 	init_rss_vec(rss);
@@ -1215,12 +1216,14 @@ again:
 		force_flush = 0;
 
 #ifdef HAVE_GENERIC_MMU_GATHER
-		tlb->start = addr;
-		tlb->end = end;
+		tlb->start = range_start;
+		tlb->end = addr;
 #endif
 		tlb_flush_mmu(tlb);
-		if (addr != end)
+		if (addr != end) {
+			range_start = addr;
 			goto again;
+		}
 	}
 
 	return addr;
-- 
1.7.10.4

