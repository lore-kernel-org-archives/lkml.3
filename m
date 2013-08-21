Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133Ab3HUVaL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 17:30:11 -0400
Received: from mail-qe0-f54.google.com ([209.85.128.54]:34090 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab3HUVaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 17:30:08 -0400
Date: Wed, 21 Aug 2013 17:30:11 -0400
From: Milosz Tanski <milosz@adfin.com>
To: ceph-devel@vger.kernel.org
Cc: sage@inktank.com, zheng.z.yan@intel.com, dhowells@redhat.com,
        linux-cachefs@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] fscache: netfs function for cleanup post readpages
Message-ID: <b5506ec6c293011dc880ae70cc1f0111e1512ff6.1375999914.git.milosz@adfin.com>
References: <cover.1375999914.git.milosz@adfin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1375999914.git.milosz@adfin.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the fscache code expect the netfs to call fscache_readpages_or_alloc
inside the aops readpages callback. It marks all the pages in the list provided
by readahead with PgPrivate2. In the cases that the netfs fails to read all the
pages (which is legal) it ends up returning to the readahead and triggering a
BUG. This happens because the page list still contains marked pages.

This patch implements a simple fscache_readpages_cancel function that the netfs
should call before returning from readpages. It will revoke the pages from the
underlying cache backend and unmark them.

This addresses this BUG being triggered by netfs code:

[12410647.597278] BUG: Bad page state in process petabucket  pfn:3d504e
[12410647.597292] page:ffffea000f541380 count:0 mapcount:0 mapping:
	(null) index:0x0
[12410647.597298] page flags: 0x200000000001000(private_2)

...

[12410647.597334] Call Trace:
[12410647.597345]  [<ffffffff815523f2>] dump_stack+0x19/0x1b
[12410647.597356]  [<ffffffff8111def7>] bad_page+0xc7/0x120
[12410647.597359]  [<ffffffff8111e49e>] free_pages_prepare+0x10e/0x120
[12410647.597361]  [<ffffffff8111fc80>] free_hot_cold_page+0x40/0x170
[12410647.597363]  [<ffffffff81123507>] __put_single_page+0x27/0x30
[12410647.597365]  [<ffffffff81123df5>] put_page+0x25/0x40
[12410647.597376]  [<ffffffffa02bdcf9>] ceph_readpages+0x2e9/0x6e0 [ceph]
[12410647.597379]  [<ffffffff81122a8f>] __do_page_cache_readahead+0x1af/0x260
[12410647.597382]  [<ffffffff81122ea1>] ra_submit+0x21/0x30
[12410647.597384]  [<ffffffff81118f64>] filemap_fault+0x254/0x490
[12410647.597387]  [<ffffffff8113a74f>] __do_fault+0x6f/0x4e0
[12410647.597391]  [<ffffffff810125bd>] ? __switch_to+0x16d/0x4a0
[12410647.597395]  [<ffffffff810865ba>] ? finish_task_switch+0x5a/0xc0
[12410647.597398]  [<ffffffff8113d856>] handle_pte_fault+0xf6/0x930
[12410647.597401]  [<ffffffff81008c33>] ? pte_mfn_to_pfn+0x93/0x110
[12410647.597403]  [<ffffffff81008cce>] ? xen_pmd_val+0xe/0x10
[12410647.597405]  [<ffffffff81005469>] ? __raw_callee_save_xen_pmd_val+0x11/0x1e
[12410647.597407]  [<ffffffff8113f361>] handle_mm_fault+0x251/0x370
[12410647.597411]  [<ffffffff812b0ac4>] ? call_rwsem_down_read_failed+0x14/0x30
[12410647.597414]  [<ffffffff8155bffa>] __do_page_fault+0x1aa/0x550
[12410647.597418]  [<ffffffff8108011d>] ? up_write+0x1d/0x20
[12410647.597422]  [<ffffffff8113141c>] ? vm_mmap_pgoff+0xbc/0xe0
[12410647.597425]  [<ffffffff81143bb8>] ? SyS_mmap_pgoff+0xd8/0x240
[12410647.597427]  [<ffffffff8155c3ae>] do_page_fault+0xe/0x10
[12410647.597431]  [<ffffffff81558818>] page_fault+0x28/0x30

Signed-off-by: Milosz Tanski <milosz@adfin.com>
---
 fs/fscache/page.c       | 16 ++++++++++++++++
 include/linux/fscache.h | 22 ++++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/fs/fscache/page.c b/fs/fscache/page.c
index d479ab3..0cc3153 100644
--- a/fs/fscache/page.c
+++ b/fs/fscache/page.c
@@ -1132,3 +1132,19 @@ void __fscache_uncache_all_inode_pages(struct fscache_cookie *cookie,
 	_leave("");
 }
 EXPORT_SYMBOL(__fscache_uncache_all_inode_pages);
+
+/**
+ * Unmark pages allocate in the readahead code path (via:
+ * fscache_readpages_or_alloc) after delegating to the base filesystem
+ */
+void __fscache_readpages_cancel(struct fscache_cookie *cookie,
+				struct list_head *pages)
+{
+	struct page *page;
+
+	list_for_each_entry(page, pages, lru) {
+		if (PageFsCache(page))
+			__fscache_uncache_page(cookie, page);
+	}
+}
+EXPORT_SYMBOL(__fscache_readpages_cancel);
diff --git a/include/linux/fscache.h b/include/linux/fscache.h
index 7a49e8f..c324177 100644
--- a/include/linux/fscache.h
+++ b/include/linux/fscache.h
@@ -209,6 +209,8 @@ extern bool __fscache_maybe_release_page(struct fscache_cookie *, struct page *,
 					 gfp_t);
 extern void __fscache_uncache_all_inode_pages(struct fscache_cookie *,
 					      struct inode *);
+extern void __fscache_readpages_cancel(struct fscache_cookie *cookie,
+				       struct list_head *pages);
 
 /**
  * fscache_register_netfs - Register a filesystem as desiring caching services
@@ -719,4 +721,24 @@ void fscache_uncache_all_inode_pages(struct fscache_cookie *cookie,
 		__fscache_uncache_all_inode_pages(cookie, inode);
 }
 
+/**
+ * fscache_readpages_cancel
+ * @cookie: The cookie representing the inode's cache object.
+ * @pages: The netfs pages that we canceled write on in readpages()
+ *
+ * Uncache/unreserve the pages reserved earlier in readpages() via
+ * fscache_readpages_or_alloc(). In most successful caches in readpages() this
+ * doesn't do anything. In cases when the underlying netfs's readahead failed
+ * we need to cleanup the pagelist (unmark and uncache).
+ *
+ * This function may sleep (if it's calling to the cache backend).
+ */
+static inline
+void fscache_readpages_cancel(struct fscache_cookie *cookie,
+			      struct list_head *pages)
+{
+	if (fscache_cookie_valid(cookie))
+		__fscache_readpages_cancel(cookie, pages);
+}
+
 #endif /* _LINUX_FSCACHE_H */
-- 
1.8.1.2

