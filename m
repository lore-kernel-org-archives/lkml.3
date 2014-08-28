Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444AbaH1ShV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:37:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32891 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753358AbaH1ShQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:37:16 -0400
From: Mel Gorman <mgorman@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux-Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 86/97] shmem: fix init_page_accessed use to stop !PageLRU bug
Date: Thu, 28 Aug 2014 19:35:34 +0100
Message-Id: <1409250945-30874-87-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409250945-30874-1-git-send-email-mgorman@suse.de>
References: <1409250945-30874-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hugh Dickins <hughd@google.com>

commit 66d2f4d28cd030220e7ea2a628993fcabcb956d1 upstream.

Under shmem swapping load, I sometimes hit the VM_BUG_ON_PAGE(!PageLRU)
in isolate_lru_pages() at mm/vmscan.c:1281!

Commit 2457aec63745 ("mm: non-atomically mark page accessed during page
cache allocation where possible") looks like interrupted work-in-progress.

mm/filemap.c's call to init_page_accessed() is fine, but not mm/shmem.c's
- shmem_write_begin() is clearly wrong to use it after shmem_getpage(),
when the page is always visible in radix_tree, and often already on LRU.

Revert change to shmem_write_begin(), and use init_page_accessed() or
mark_page_accessed() appropriately for SGP_WRITE in shmem_getpage_gfp().

SGP_WRITE also covers shmem_symlink(), which did not mark_page_accessed()
before; but since many other filesystems use [__]page_symlink(), which did
and does mark the page accessed, consider this as rectifying an oversight.

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/shmem.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index d4b7358..ab05681 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1037,6 +1037,9 @@ repeat:
 		goto failed;
 	}
 
+	if (page && sgp == SGP_WRITE)
+		mark_page_accessed(page);
+
 	/* fallocated page? */
 	if (page && !PageUptodate(page)) {
 		if (sgp != SGP_READ)
@@ -1118,6 +1121,9 @@ repeat:
 		shmem_recalc_inode(inode);
 		spin_unlock(&info->lock);
 
+		if (sgp == SGP_WRITE)
+			mark_page_accessed(page);
+
 		delete_from_swap_cache(page);
 		set_page_dirty(page);
 		swap_free(swap);
@@ -1144,6 +1150,9 @@ repeat:
 
 		__SetPageSwapBacked(page);
 		__set_page_locked(page);
+		if (sgp == SGP_WRITE)
+			init_page_accessed(page);
+
 		error = mem_cgroup_cache_charge(page, current->mm,
 						gfp & GFP_RECLAIM_MASK);
 		if (error)
@@ -1440,13 +1449,9 @@ shmem_write_begin(struct file *file, struct address_space *mapping,
 			loff_t pos, unsigned len, unsigned flags,
 			struct page **pagep, void **fsdata)
 {
-	int ret;
 	struct inode *inode = mapping->host;
 	pgoff_t index = pos >> PAGE_CACHE_SHIFT;
-	ret = shmem_getpage(inode, index, pagep, SGP_WRITE, NULL);
-	if (ret == 0 && *pagep)
-		init_page_accessed(*pagep);
-	return ret;
+	return shmem_getpage(inode, index, pagep, SGP_WRITE, NULL);
 }
 
 static int
-- 
1.8.4.5

