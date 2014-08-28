Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799AbaH1S5r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:57:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32867 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752962AbaH1Sgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:36:36 -0400
From: Mel Gorman <mgorman@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux-Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 47/97] mm: madvise: fix MADV_WILLNEED on shmem swapouts
Date: Thu, 28 Aug 2014 19:34:55 +0100
Message-Id: <1409250945-30874-48-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409250945-30874-1-git-send-email-mgorman@suse.de>
References: <1409250945-30874-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Weiner <hannes@cmpxchg.org>

commit 55231e5c898c5c03c14194001e349f40f59bd300 upstream.

MADV_WILLNEED currently does not read swapped out shmem pages back in.

Commit 0cd6144aadd2 ("mm + fs: prepare for non-page entries in page
cache radix trees") made find_get_page() filter exceptional radix tree
entries but failed to convert all find_get_page() callers that WANT
exceptional entries over to find_get_entry().  One of them is shmem swap
readahead in madvise, which now skips over any swap-out records.

Convert it to find_get_entry().

Fixes: 0cd6144aadd2 ("mm + fs: prepare for non-page entries in page cache radix trees")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/madvise.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 539eeb9..a402f8f 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -195,7 +195,7 @@ static void force_shm_swapin_readahead(struct vm_area_struct *vma,
 	for (; start < end; start += PAGE_SIZE) {
 		index = ((start - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
 
-		page = find_get_page(mapping, index);
+		page = find_get_entry(mapping, index);
 		if (!radix_tree_exceptional_entry(page)) {
 			if (page)
 				page_cache_release(page);
-- 
1.8.4.5

