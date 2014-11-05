Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280AbaKEOxP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 09:53:15 -0500
Received: from mga01.intel.com ([192.55.52.88]:62488 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755103AbaKEOuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 09:50:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,320,1413270000"; 
   d="scan'208";a="617582802"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@gentwo.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Steve Capper <steve.capper@linaro.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH 08/19] mm: prepare migration code for new THP refcounting
Date: Wed,  5 Nov 2014 16:49:43 +0200
Message-Id: <1415198994-15252-9-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1415198994-15252-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1415198994-15252-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With new refcounting VMAs can start or end in the middle of huge page.
We need to modify code to call split_huge_page() properly.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 mm/migrate.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index f1a12ced2531..4dc941100388 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1235,7 +1235,7 @@ static int do_move_page_to_node_array(struct mm_struct *mm,
 		vma = find_vma(mm, pp->addr);
 		if (!vma || pp->addr < vma->vm_start || !vma_migratable(vma))
 			goto set_status;
-
+retry:
 		page = follow_page(vma, pp->addr, FOLL_GET);
 
 		err = PTR_ERR(page);
@@ -1246,9 +1246,27 @@ static int do_move_page_to_node_array(struct mm_struct *mm,
 		if (!page)
 			goto set_status;
 
-		if (PageTransHuge(page) && split_huge_page(page)) {
-			err = -EBUSY;
-			goto set_status;
+		if (PageTransCompound(page)) {
+			struct page *head_page = compound_head(page);
+
+			/*
+			 * split_huge_page() wants pin to be only on head page
+			 */
+			if (page != head_page) {
+				get_page(head_page);
+				put_page(page);
+			}
+
+			err = split_huge_page(head_page);
+			if (err) {
+				put_page(head_page);
+				goto set_status;
+			}
+
+			if (page != head_page) {
+				put_page(head_page);
+				goto retry;
+			}
 		}
 
 		/* Use PageReserved to check for zero page */
-- 
2.1.1

