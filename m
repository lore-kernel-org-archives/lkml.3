Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab3IEWVv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 18:21:51 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:38246 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184Ab3IEWVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 18:21:48 -0400
Date: Thu, 5 Sep 2013 18:21:42 -0400
From: Milosz Tanski <milosz@adfin.com>
To: ceph-devel@vger.kernel.org
Cc: sage@inktank.com, zheng.z.yan@intel.com, dhowells@redhat.com,
        jiayisuse@gmail.com, linux-cachefs@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/8] fscache: Netfs function for cleanup post readpages
Message-ID: <eeaa636af87369b47066f973ca266bd50a4fc481.1378418255.git.milosz@adfin.com>
References: <cover.1378418255.git.milosz@adfin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1378418255.git.milosz@adfin.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the fscache code expect the netfs to call fscache_readpages_or_alloc
inside the aops readpages callback.  It marks all the pages in the list
provided by readahead with PG_private_2.  In the cases that the netfs fails to
read all the pages (which is legal) it ends up returning to the readahead and
triggering a BUG.  This happens because the page list still contains marked
pages.

This patch implements a simple fscache_readpages_cancel function that the netfs
should call before returning from readpages.  It will revoke the pages from the
underlying cache backend and unmark them.

The problem was originally worked out in the Ceph devel tree, but it also
occurs in CIFS.  It appears that NFS, AFS and 9P are okay as read_cache_pages()
will clean up the unprocessed pages in the case of an error.

This can be used to address the following oops:

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
Signed-off-by: David Howells <dhowells@redhat.com>
---
 Documentation/filesystems/caching/netfs-api.txt |   18 +++++++++++++++++-
 fs/fscache/page.c                               |   16 ++++++++++++++++
 include/linux/fscache.h                         |   22 ++++++++++++++++++++++
 3 files changed, 55 insertions(+), 1 deletion(-)

diff --git a/Documentation/filesystems/caching/netfs-api.txt b/Documentation/filesystems/caching/netfs-api.txt
index 12b3442..0c2329d 100644
--- a/Documentation/filesystems/caching/netfs-api.txt
+++ b/Documentation/filesystems/caching/netfs-api.txt
@@ -499,7 +499,7 @@ Else if there's a copy of the page resident in the cache:
      (*) An argument that's 0 on success or negative for an error code.
 
      If an error occurs, it should be assumed that the page contains no usable
-     data.
+     data.  fscache_readpages_cancel() may need to be called.
 
      end_io_func() will be called in process context if the read is results in
      an error, but it might be called in interrupt context if the read is
@@ -623,6 +623,22 @@ some of the pages being read and some being allocated.  Those pages will have
 been marked appropriately and will need uncaching.
 
 
+CANCELLATION OF UNREAD PAGES
+----------------------------
+
+If one or more pages are passed to fscache_read_or_alloc_pages() but not then
+read from the cache and also not read from the underlying filesystem then
+those pages will need to have any marks and reservations removed.  This can be
+done by calling:
+
+	void fscache_readpages_cancel(struct fscache_cookie *cookie,
+				      struct list_head *pages);
+
+prior to returning to the caller.  The cookie argument should be as passed to
+fscache_read_or_alloc_pages().  Every page in the pages list will be examined
+and any that have PG_fscache set will be uncached.
+
+
 ==============
 PAGE UNCACHING
 ==============
diff --git a/fs/fscache/page.c b/fs/fscache/page.c
index 793e3d5..8702b73 100644
--- a/fs/fscache/page.c
+++ b/fs/fscache/page.c
@@ -701,6 +701,22 @@ nobufs:
 EXPORT_SYMBOL(__fscache_alloc_page);
 
 /*
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
+
+/*
  * release a write op reference
  */
 static void fscache_release_write_op(struct fscache_operation *_op)
diff --git a/include/linux/fscache.h b/include/linux/fscache.h
index d984aff..19b4645 100644
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
@@ -590,6 +592,26 @@ int fscache_alloc_page(struct fscache_cookie *cookie,
 }
 
 /**
+ * fscache_readpages_cancel - Cancel read/alloc on pages
+ * @cookie: The cookie representing the inode's cache object.
+ * @pages: The netfs pages that we canceled write on in readpages()
+ *
+ * Uncache/unreserve the pages reserved earlier in readpages() via
+ * fscache_readpages_or_alloc() and similar.  In most successful caches in
+ * readpages() this doesn't do anything.  In cases when the underlying netfs's
+ * readahead failed we need to clean up the pagelist (unmark and uncache).
+ *
+ * This function may sleep as it may have to clean up disk state.
+ */
+static inline
+void fscache_readpages_cancel(struct fscache_cookie *cookie,
+			      struct list_head *pages)
+{
+	if (fscache_cookie_valid(cookie))
+		__fscache_readpages_cancel(cookie, pages);
+}
+
+/**
  * fscache_write_page - Request storage of a page in the cache
  * @cookie: The cookie representing the cache object
  * @page: The netfs page to store
-- 
1.7.9.5

