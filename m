Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216AbaFBVgz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 17:36:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:47039 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751933AbaFBVgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 17:36:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,959,1392192000"; 
   d="scan'208";a="550474674"
Subject: [PATCH 06/10] mm: mincore: clean up hugetlbfs handler (part 2)
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, kirill.shutemov@linux.intel.com,
        Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Mon, 02 Jun 2014 14:36:52 -0700
References: <20140602213644.925A26D0@viggo.jf.intel.com>
In-Reply-To: <20140602213644.925A26D0@viggo.jf.intel.com>
Message-Id: <20140602213652.ABA2E299@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

The walk_page_range() code calls in to the ->hugetlbfs_entry
handler once for each huge page table entry.  This means that
addr and end are always within the same huge page.  (Well, end is
not technically _within_ it, because it is exclusive.)

The outer while() loop in mincore_hugetlb_page_range() appears to
be designed to work if we crossed a huge page boundary to a new
huge pte and 'present' changed.  However, that is impossible for
two reasons:

	1. The above-mentioned walk_page_range() restriction
	2. We never move ptep

So the outer while() along with the check for crossing the end of
the huge page boundary (which is impossible) make no sense.  Once
we peel it off, it's clear that we can just make the 'return' in
to the loop condition.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 b/mm/mincore.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff -puN mm/mincore.c~cleanup-hugetlbfs-mincore-2 mm/mincore.c
--- a/mm/mincore.c~cleanup-hugetlbfs-mincore-2	2014-06-02 14:20:20.426858178 -0700
+++ b/mm/mincore.c	2014-06-02 14:20:20.430858359 -0700
@@ -24,23 +24,17 @@ static int mincore_hugetlb_page_range(pt
 					struct mm_walk *walk)
 {
 	unsigned char *vec = walk->private;
+	int present;
 
 	/* This is as good as an explicit ifdef */
 	if (!is_vm_hugetlb_page(walk->vma))
 		return 0;
 
-	while (1) {
-		int present = !huge_pte_none(huge_ptep_get(ptep));
-		while (1) {
-			*vec = present;
-			vec++;
-			addr += PAGE_SIZE;
-			if (addr == end)
-				return 0;
-			/* check hugepage border */
-			if (!(addr & hmask))
-				break;
-		}
+	present = !huge_pte_none(huge_ptep_get(ptep));
+	while (addr < end) {
+		*vec = present;
+		vec++;
+		addr += PAGE_SIZE;
 	}
 	return 0;
 }
_
