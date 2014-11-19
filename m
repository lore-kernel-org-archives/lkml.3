Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648AbaKSVLj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:11:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57070 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756481AbaKSVLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:11:33 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 3.14 105/122] callers of iov_copy_from_user_atomic() dont need pagecache_disable()
Date: Wed, 19 Nov 2014 12:52:35 -0800
Message-Id: <20141119205212.319231651@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205208.812884198@linuxfoundation.org>
References: <20141119205208.812884198@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 9e8c2af96e0d2d5fe298dd796fb6bc16e888a48d upstream.

... it does that itself (via kmap_atomic())

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/file.c |    5 -----
 fs/fuse/file.c  |    2 --
 mm/filemap.c    |    3 ---
 3 files changed, 10 deletions(-)

--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -425,13 +425,8 @@ static noinline int btrfs_copy_from_user
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
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1003,9 +1003,7 @@ static ssize_t fuse_fill_write_pages(str
 		if (mapping_writably_mapped(mapping))
 			flush_dcache_page(page);
 
-		pagefault_disable();
 		tmp = iov_iter_copy_from_user_atomic(page, ii, offset, bytes);
-		pagefault_enable();
 		flush_dcache_page(page);
 
 		mark_page_accessed(page);
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2188,7 +2188,6 @@ size_t iov_iter_copy_from_user_atomic(st
 	char *kaddr;
 	size_t copied;
 
-	BUG_ON(!in_atomic());
 	kaddr = kmap_atomic(page);
 	if (likely(i->nr_segs == 1)) {
 		int left;
@@ -2562,9 +2561,7 @@ again:
 		if (mapping_writably_mapped(mapping))
 			flush_dcache_page(page);
 
-		pagefault_disable();
 		copied = iov_iter_copy_from_user_atomic(page, i, offset, bytes);
-		pagefault_enable();
 		flush_dcache_page(page);
 
 		mark_page_accessed(page);


