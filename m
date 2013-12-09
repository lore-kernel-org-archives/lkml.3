Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760705Ab3LIHJz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 02:09:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40135 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760600Ab3LIHJS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 02:09:18 -0500
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alex Thorlton <athorlton@sgi.com>, Rik van Riel <riel@redhat.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 04/18] mm: numa: Do not clear PMD during PTE update scan
Date: Mon,  9 Dec 2013 07:08:58 +0000
Message-Id: <1386572952-1191-5-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1386572952-1191-1-git-send-email-mgorman@suse.de>
References: <1386572952-1191-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the PMD is flushed then a parallel fault in handle_mm_fault() will enter
the pmd_none and do_huge_pmd_anonymous_page() path where it'll attempt
to insert a huge zero page. This is wasteful so the patch avoids clearing
the PMD when setting pmd_numa.

Cc: stable@vger.kernel.org
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/huge_memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index deae592..5a5da50 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1529,7 +1529,7 @@ int change_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 			 */
 			if (!is_huge_zero_page(page) &&
 			    !pmd_numa(*pmd)) {
-				entry = pmdp_get_and_clear(mm, addr, pmd);
+				entry = *pmd;
 				entry = pmd_mknuma(entry);
 				ret = HPAGE_PMD_NR;
 			}
-- 
1.8.4

