Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933805AbbA1Bpn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 20:45:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41730 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933363AbbA1Bih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:38:37 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>,
        Michal Hocko <mhocko@suse.cz>, Dave Hansen <dave.hansen@intel.com>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.14 64/77] shmem: fix init_page_accessed use to stop !PageLRU bug
Date: Tue, 27 Jan 2015 17:27:42 -0800
Message-Id: <20150128012747.890024874@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012745.971137091@linuxfoundation.org>
References: <20150128012745.971137091@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/shmem.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1035,6 +1035,9 @@ repeat:
 		goto failed;
 	}
 
+	if (page && sgp == SGP_WRITE)
+		mark_page_accessed(page);
+
 	/* fallocated page? */
 	if (page && !PageUptodate(page)) {
 		if (sgp != SGP_READ)
@@ -1116,6 +1119,9 @@ repeat:
 		shmem_recalc_inode(inode);
 		spin_unlock(&info->lock);
 
+		if (sgp == SGP_WRITE)
+			mark_page_accessed(page);
+
 		delete_from_swap_cache(page);
 		set_page_dirty(page);
 		swap_free(swap);
@@ -1142,6 +1148,9 @@ repeat:
 
 		__SetPageSwapBacked(page);
 		__set_page_locked(page);
+		if (sgp == SGP_WRITE)
+			init_page_accessed(page);
+
 		error = mem_cgroup_cache_charge(page, current->mm,
 						gfp & GFP_RECLAIM_MASK);
 		if (error)
@@ -1438,13 +1447,9 @@ shmem_write_begin(struct file *file, str
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


