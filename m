Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797AbaF3VJm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 17:09:42 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:63446 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465AbaF3VJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 17:09:41 -0400
Date: Mon, 30 Jun 2014 14:08:11 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Mel Gorman <mgorman@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] shmem: fix init_page_accessed use to stop !PageLRU bug
Message-ID: <alpine.LSU.2.11.1406301405230.1096@eggly.anvils>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---

 mm/shmem.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- 3.16-rc3/mm/shmem.c	2014-06-29 15:22:10.592003936 -0700
+++ linux/mm/shmem.c	2014-06-30 12:15:52.204093217 -0700
@@ -1029,6 +1029,9 @@ repeat:
 		goto failed;
 	}
 
+	if (page && sgp == SGP_WRITE)
+		mark_page_accessed(page);
+
 	/* fallocated page? */
 	if (page && !PageUptodate(page)) {
 		if (sgp != SGP_READ)
@@ -1110,6 +1113,9 @@ repeat:
 		shmem_recalc_inode(inode);
 		spin_unlock(&info->lock);
 
+		if (sgp == SGP_WRITE)
+			mark_page_accessed(page);
+
 		delete_from_swap_cache(page);
 		set_page_dirty(page);
 		swap_free(swap);
@@ -1136,6 +1142,9 @@ repeat:
 
 		__SetPageSwapBacked(page);
 		__set_page_locked(page);
+		if (sgp == SGP_WRITE)
+			init_page_accessed(page);
+
 		error = mem_cgroup_charge_file(page, current->mm,
 						gfp & GFP_RECLAIM_MASK);
 		if (error)
@@ -1412,13 +1421,9 @@ shmem_write_begin(struct file *file, str
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
