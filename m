Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532AbaFJTyf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 15:54:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35635 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945AbaFJTya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:54:30 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org, lwoodman@redhat.com,
        dave.hansen@intel.com, Ingo Molnar <mingo@kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 046/160] mm/numa: Remove BUG_ON() in __handle_mm_fault()
Date: Tue, 10 Jun 2014 12:44:46 -0700
Message-Id: <1402429600-20477-47-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rik van Riel <riel@redhat.com>

commit 107437febd495a50e2cd09c81bbaa84d30e57b07 upstream.

Changing PTEs and PMDs to pte_numa & pmd_numa is done with the
mmap_sem held for reading, which means a pmd can be instantiated
and turned into a numa one while __handle_mm_fault() is examining
the value of old_pmd.

If that happens, __handle_mm_fault() should just return and let
the page fault retry, instead of throwing an oops. This is
handled by the test for pmd_trans_huge(*pmd) below.

Signed-off-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reported-by: Sunil Pandey <sunil.k.pandey@intel.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: linux-mm@kvack.org
Cc: lwoodman@redhat.com
Cc: dave.hansen@intel.com
Link: http://lkml.kernel.org/r/20140429153615.2d72098e@annuminas.surriel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 mm/memory.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index dda27b9..95257f5 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3747,9 +3747,6 @@ static int __handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 		}
 	}
 
-	/* THP should already have been handled */
-	BUG_ON(pmd_numa(*pmd));
-
 	/*
 	 * Use __pte_alloc instead of pte_alloc_map, because we can't
 	 * run pte_offset_map on the pmd, if an huge pmd could
-- 
1.9.1

