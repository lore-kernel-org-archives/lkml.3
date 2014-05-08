Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429AbaEHKoy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 06:44:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33258 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488AbaEHKov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 06:44:51 -0400
Date: Thu, 8 May 2014 03:43:19 -0700
From: tip-bot for Rik van Riel <tipbot@zytor.com>
Message-ID: <tip-107437febd495a50e2cd09c81bbaa84d30e57b07@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, kirill.shutemov@linux.intel.com,
        peterz@infradead.org, hannes@cmpxchg.org, n-horiguchi@ah.jp.nec.com,
        riel@redhat.com, akpm@linux-foundation.org, mgorman@suse.de,
        sunil.k.pandey@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        kirill.shutemov@linux.intel.com, torvalds@linux-foundation.org,
        peterz@infradead.org, hannes@cmpxchg.org, n-horiguchi@ah.jp.nec.com,
        riel@redhat.com, akpm@linux-foundation.org, sunil.k.pandey@intel.com,
        mgorman@suse.de, tglx@linutronix.de
In-Reply-To: <20140429153615.2d72098e@annuminas.surriel.com>
References: <20140429153615.2d72098e@annuminas.surriel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] mm/numa: Remove BUG_ON() in __handle_mm_fault()
Git-Commit-ID: 107437febd495a50e2cd09c81bbaa84d30e57b07
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  107437febd495a50e2cd09c81bbaa84d30e57b07
Gitweb:     http://git.kernel.org/tip/107437febd495a50e2cd09c81bbaa84d30e57b07
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Tue, 29 Apr 2014 15:36:15 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 7 May 2014 13:33:48 +0200

mm/numa: Remove BUG_ON() in __handle_mm_fault()

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
---
 mm/memory.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index d0f0bef..9c2dc65 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3900,9 +3900,6 @@ static int __handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 		}
 	}
 
-	/* THP should already have been handled */
-	BUG_ON(pmd_numa(*pmd));
-
 	/*
 	 * Use __pte_alloc instead of pte_alloc_map, because we can't
 	 * run pte_offset_map on the pmd, if an huge pmd could
