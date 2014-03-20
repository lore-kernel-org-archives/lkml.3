Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030AbaCTGjs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 02:39:48 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:56997 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbaCTGjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 02:39:44 -0400
X-AuditID: 9c93017d-b7ceaae000000e36-dd-532a8d2cd85d
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave.hansen@intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Jason Evans <je@fb.com>, Minchan Kim <minchan@kernel.org>
Subject: [RFC v2 3/3] mm: deactivate lazyfree pages
Date: Thu, 20 Mar 2014 15:38:58 +0900
Message-Id: <1395297538-10491-4-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1395297538-10491-1-git-send-email-minchan@kernel.org>
References: <1395297538-10491-1-git-send-email-minchan@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MADV_FREEed pages should be discarded before working set pages
are reclaimed because most of users(ex, tcmalloc and jemalloc)
have used it instead of MADV_DONTNEED which zap pages instantly.

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 mm/memory.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/memory.c b/mm/memory.c
index 6f221225f62b..76b683e7d087 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1298,6 +1298,7 @@ static unsigned long lazyfree_pte_range(struct mmu_gather *tlb,
 		ptent = pte_mkclean(ptent);
 		set_pte_at(mm, addr, pte, ptent);
 		tlb_remove_tlb_entry(tlb, pte, addr);
+		deactivate_page(page);
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 	arch_leave_lazy_mmu_mode();
 	pte_unmap_unlock(start_pte, ptl);
-- 
1.9.0

