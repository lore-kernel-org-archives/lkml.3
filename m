Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab3LCIzA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 03:55:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49428 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904Ab3LCIwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 03:52:09 -0500
From: Mel Gorman <mgorman@suse.de>
To: Alex Thorlton <athorlton@sgi.com>
Cc: Rik van Riel <riel@redhat.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 07/15] mm: numa: Do not clear PMD during PTE update scan
Date: Tue,  3 Dec 2013 08:51:54 +0000
Message-Id: <1386060721-3794-8-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1386060721-3794-1-git-send-email-mgorman@suse.de>
References: <1386060721-3794-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the PMD is flushed then a parallel fault in handle_mm_fault() will
enter the pmd_none and do_huge_pmd_anonymous_page() path where it'll
attempt to insert a huge zero page. This is wasteful so the patch
avoids clearing the PMD when setting pmd_numa.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/huge_memory.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 203b5bc..d6c3bf4 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1474,20 +1474,24 @@ int change_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 
 	if (__pmd_trans_huge_lock(pmd, vma) == 1) {
 		pmd_t entry;
-		entry = pmdp_get_and_clear(mm, addr, pmd);
+
 		if (!prot_numa) {
+			entry = pmdp_get_and_clear(mm, addr, pmd);
 			entry = pmd_modify(entry, newprot);
 			BUG_ON(pmd_write(entry));
+			set_pmd_at(mm, addr, pmd, entry);
 		} else {
 			struct page *page = pmd_page(*pmd);
+			entry = *pmd;
 
 			/* only check non-shared pages */
 			if (page_mapcount(page) == 1 &&
 			    !pmd_numa(*pmd)) {
 				entry = pmd_mknuma(entry);
+				set_pmd_at(mm, addr, pmd, entry);
 			}
 		}
-		set_pmd_at(mm, addr, pmd, entry);
+
 		spin_unlock(&vma->vm_mm->page_table_lock);
 		ret = 1;
 	}
-- 
1.8.4

