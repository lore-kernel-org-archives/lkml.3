Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933130Ab3ICQ3L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 12:29:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46665 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933097Ab3ICQ3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 12:29:08 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Vineet Gupta <vgupta@synopsys.com>, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 24/58] mm: fix the TLB range flushed when __tlb_remove_page() runs out of slots
Date: Tue,  3 Sep 2013 09:23:28 -0700
Message-Id: <1378225442-20654-25-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378225442-20654-1-git-send-email-kamal@canonical.com>
References: <1378225442-20654-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vineet Gupta <Vineet.Gupta1@synopsys.com>

commit e6c495a96ce02574e765d5140039a64c8d4e8c9e upstream.

zap_pte_range loops from @addr to @end.  In the middle, if it runs out of
batching slots, TLB entries needs to be flushed for @start to @interim,
NOT @interim to @end.

Since ARC port doesn't use page free batching I can't test it myself but
this seems like the right thing to do.

Observed this when working on a fix for the issue at thread:
http://www.spinics.net/lists/linux-arch/msg21736.html

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[ kamal: 3.8.y-stable prereq for:
  2b04725 Fix TLB gather virtual address range invalidation corner cases ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 mm/memory.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 32a495a..b81825a 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1106,6 +1106,7 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
 	spinlock_t *ptl;
 	pte_t *start_pte;
 	pte_t *pte;
+	unsigned long range_start = addr;
 
 again:
 	init_rss_vec(rss);
@@ -1211,12 +1212,14 @@ again:
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
1.8.1.2

