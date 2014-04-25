Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566AbaDYSmT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 14:42:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42360 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346AbaDYSmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 14:42:16 -0400
Date: Fri, 25 Apr 2014 14:41:47 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, lwoodman@redhat.com, peterz@infradead.org,
        mgorman@suse.de, dave.hansen@intel.com, sunil.k.pandey@intel.com
Subject: [PATCH] mm,numa: remove BUG_ON in __handle_mm_fault
Message-ID: <20140425144147.679a7608@annuminas.surriel.com>
Organization: Red Hat, Inc.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changing PTEs and PMDs to pte_numa & pmd_numa is done with the
mmap_sem held for reading, which means a pmd can be instantiated
and/or turned into a numa one while __handle_mm_fault is examining
the value of orig_pmd.

If that happens, __handle_mm_fault should just return and let
the page fault retry, instead of throwing an oops.

Signed-off-by: Rik van Riel <riel@redhat.com>
Reported-by: Sunil Pandey <sunil.k.pandey@intel.com>
---
 mm/memory.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index d0f0bef..9edccb2 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3900,8 +3900,9 @@ static int __handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 		}
 	}
 
-	/* THP should already have been handled */
-	BUG_ON(pmd_numa(*pmd));
+	/* The PMD became NUMA while we examined orig_pmd. Return & retry */
+	if (pmd_numa(*pmd))
+		return 0;
 
 	/*
 	 * Use __pte_alloc instead of pte_alloc_map, because we can't
