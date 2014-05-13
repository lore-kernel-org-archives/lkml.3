Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760468AbaEMNCi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 09:02:38 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:60873 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754490AbaEMNCh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 09:02:37 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [patch] mm: madvise: fix MADV_WILLNEED on shmem swapouts
Date: Tue, 13 May 2014 08:56:51 -0400
Message-Id: <1399985811-12183-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MADV_WILLNEED currently does not read swapped out shmem pages back in.

0cd6144aadd2 ("mm + fs: prepare for non-page entries in page cache
radix trees") made find_get_page() filter exceptional radix tree
entries but failed to convert all find_get_page() callers that WANT
exceptional entries over to find_get_entry().  One of them is shmem
swap readahead in madvise, which now skips over any swap-out records.

Convert it to find_get_entry().

Fixes: 0cd6144aadd2 ("mm + fs: prepare for non-page entries in page cache radix trees")
Reported-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/madvise.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 539eeb96b323..a402f8fdc68e 100644
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
1.9.2

