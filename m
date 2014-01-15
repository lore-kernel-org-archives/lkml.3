Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524AbaAOWJZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:09:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41361 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283AbaAOWAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 17:00:02 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mel Gorman <mgorman@suse.de>, Alex Thorlton <athorlton@sgi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 086/166] mm: numa: do not clear PMD during PTE update scan
Date: Wed, 15 Jan 2014 13:51:40 -0800
Message-Id: <1389822780-4729-87-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mel Gorman <mgorman@suse.de>

commit 5a6dac3ec5f583cc8ee7bc53b5500a207c4ca433 upstream.

If the PMD is flushed then a parallel fault in handle_mm_fault() will
enter the pmd_none and do_huge_pmd_anonymous_page() path where it'll
attempt to insert a huge zero page.  This is wasteful so the patch
avoids clearing the PMD when setting pmd_numa.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Alex Thorlton <athorlton@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 mm/huge_memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index a72d5ca..5d7dc7c 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1506,7 +1506,7 @@ int change_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 			/* only check non-shared pages */
 			if (page_mapcount(page) == 1 &&
 			    !pmd_numa(*pmd)) {
-				entry = pmdp_get_and_clear(mm, addr, pmd);
+				entry = *pmd;
 				entry = pmd_mknuma(entry);
 				ret = HPAGE_PMD_NR;
 			}
-- 
1.8.3.2

