Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbaH1S5V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:57:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32866 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752979AbaH1Sgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:36:38 -0400
From: Mel Gorman <mgorman@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux-Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 49/97] callers of iov_copy_from_user_atomic() don't need pagecache_disable()
Date: Thu, 28 Aug 2014 19:34:57 +0100
Message-Id: <1409250945-30874-50-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409250945-30874-1-git-send-email-mgorman@suse.de>
References: <1409250945-30874-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

commit 9e8c2af96e0d2d5fe298dd796fb6bc16e888a48d upstream.

... it does that itself (via kmap_atomic())

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 fs/btrfs/file.c | 5 -----
 fs/fuse/file.c  | 2 --
 mm/filemap.c    | 3 ---
 3 files changed, 10 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 72da4df..9952a2a 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -426,13 +426,8 @@ static noinline int btrfs_copy_from_user(loff_t pos, int num_pages,
 		struct page *page = prepared_pages[pg];
 		/*
 		 * Copy data from userspace to the current page
-		 *
-		 * Disable pagefault to avoid recursive lock since
-		 * the pages are already locked
 		 */
-		pagefault_disable();
 		copied = iov_iter_copy_from_user_atomic(page, i, offset, count);
-		pagefault_enable();
 
 		/* Flush processor's dcache for this page */
 		flush_dcache_page(page);
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 4598345..bf9a755 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -985,9 +985,7 @@ static ssize_t fuse_fill_write_pages(struct fuse_req *req,
 		if (mapping_writably_mapped(mapping))
 			flush_dcache_page(page);
 
-		pagefault_disable();
 		tmp = iov_iter_copy_from_user_atomic(page, ii, offset, bytes);
-		pagefault_enable();
 		flush_dcache_page(page);
 
 		mark_page_accessed(page);
diff --git a/mm/filemap.c b/mm/filemap.c
index d0f765f..8144c27 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2190,7 +2190,6 @@ size_t iov_iter_copy_from_user_atomic(struct page *page,
 	char *kaddr;
 	size_t copied;
 
-	BUG_ON(!in_atomic());
 	kaddr = kmap_atomic(page);
 	if (likely(i->nr_segs == 1)) {
 		int left;
@@ -2564,9 +2563,7 @@ again:
 		if (mapping_writably_mapped(mapping))
 			flush_dcache_page(page);
 
-		pagefault_disable();
 		copied = iov_iter_copy_from_user_atomic(page, i, offset, bytes);
-		pagefault_enable();
 		flush_dcache_page(page);
 
 		mark_page_accessed(page);
-- 
1.8.4.5

