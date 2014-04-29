Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758303AbaD2Tgs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 15:36:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11364 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751878AbaD2Tgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 15:36:47 -0400
Date: Tue, 29 Apr 2014 15:36:15 -0400
From: Rik van Riel <riel@redhat.com>
To: n-horiguchi@ah.jp.nec.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, lwoodman@redhat.com,
        peterz@infradead.org, mgorman@suse.de, dave.hansen@intel.com,
        sunil.k.pandey@intel.com
Subject: [PATCH -v2] mm,numa: remove BUG_ON in __handle_mm_fault
Message-ID: <20140429153615.2d72098e@annuminas.surriel.com>
In-Reply-To: <1398799576-9pfzypnu@n-horiguchi@ah.jp.nec.com>
References: <20140425144147.679a7608@annuminas.surriel.com>
	<1398799576-9pfzypnu@n-horiguchi@ah.jp.nec.com>
Organization: Red Hat, Inc.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter pointed out we can do this slightly simpler, since we already
have a test for pmd_trans_huge(*pmd) below...

---8<---

Changing PTEs and PMDs to pte_numa & pmd_numa is done with the
mmap_sem held for reading, which means a pmd can be instantiated
and turned into a numa one while __handle_mm_fault is examining
the value of old_pmd.

If that happens, __handle_mm_fault should just return and let
the page fault retry, instead of throwing an oops. This is
handled by the test for pmd_trans_huge(*pmd) below.

Signed-off-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reported-by: Sunil Pandey <sunil.k.pandey@intel.com>
Cc: stable@kernel.org
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
