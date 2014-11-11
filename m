Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879AbaKKMLz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 07:11:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57155 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbaKKLJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:09:15 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 016/170] vfs: fix data corruption when blocksize < pagesize for mmaped data
Date: Tue, 11 Nov 2014 11:06:15 +0000
Message-Id: <1415704129-12709-17-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 90a8020278c1598fafd071736a0846b38510309c upstream.

->page_mkwrite() is used by filesystems to allocate blocks under a page
which is becoming writeably mmapped in some process' address space. This
allows a filesystem to return a page fault if there is not enough space
available, user exceeds quota or similar problem happens, rather than
silently discarding data later when writepage is called.

However VFS fails to call ->page_mkwrite() in all the cases where
filesystems need it when blocksize < pagesize. For example when
blocksize = 1024, pagesize = 4096 the following is problematic:
  ftruncate(fd, 0);
  pwrite(fd, buf, 1024, 0);
  map = mmap(NULL, 1024, PROT_WRITE, MAP_SHARED, fd, 0);
  map[0] = 'a';       ----> page_mkwrite() for index 0 is called
  ftruncate(fd, 10000); /* or even pwrite(fd, buf, 1, 10000) */
  mremap(map, 1024, 10000, 0);
  map[4095] = 'a';    ----> no page_mkwrite() called

At the moment ->page_mkwrite() is called, filesystem can allocate only
one block for the page because i_size == 1024. Otherwise it would create
blocks beyond i_size which is generally undesirable. But later at
->writepage() time, we also need to store data at offset 4095 but we
don't have block allocated for it.

This patch introduces a helper function filesystems can use to have
->page_mkwrite() called at all the necessary moments.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/buffer.c        |  3 +++
 include/linux/mm.h |  1 +
 mm/truncate.c      | 57 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 61 insertions(+)

diff --git a/fs/buffer.c b/fs/buffer.c
index 36fdceb82635..19a78d074e0d 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2089,6 +2089,7 @@ int generic_write_end(struct file *file, struct address_space *mapping,
 			struct page *page, void *fsdata)
 {
 	struct inode *inode = mapping->host;
+	loff_t old_size = inode->i_size;
 	int i_size_changed = 0;
 
 	copied = block_write_end(file, mapping, pos, len, copied, page, fsdata);
@@ -2108,6 +2109,8 @@ int generic_write_end(struct file *file, struct address_space *mapping,
 	unlock_page(page);
 	page_cache_release(page);
 
+	if (old_size < pos)
+		pagecache_isize_extended(inode, old_size, pos);
 	/*
 	 * Don't mark the inode dirty under page lock. First, it unnecessarily
 	 * makes the holding time of page lock longer. Second, it forces lock
diff --git a/include/linux/mm.h b/include/linux/mm.h
index e03dd29145a0..f988e4b189e1 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1155,6 +1155,7 @@ static inline void unmap_shared_mapping_range(struct address_space *mapping,
 
 extern void truncate_pagecache(struct inode *inode, loff_t new);
 extern void truncate_setsize(struct inode *inode, loff_t newsize);
+void pagecache_isize_extended(struct inode *inode, loff_t from, loff_t to);
 void truncate_pagecache_range(struct inode *inode, loff_t offset, loff_t end);
 int truncate_inode_page(struct address_space *mapping, struct page *page);
 int generic_error_remove_page(struct address_space *mapping, struct page *page);
diff --git a/mm/truncate.c b/mm/truncate.c
index eda247307164..ed6e91a695e0 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -20,6 +20,7 @@
 #include <linux/buffer_head.h>	/* grr. try_to_release_page,
 				   do_invalidatepage */
 #include <linux/cleancache.h>
+#include <linux/rmap.h>
 #include "internal.h"
 
 static void clear_exceptional_entry(struct address_space *mapping,
@@ -728,12 +729,68 @@ EXPORT_SYMBOL(truncate_pagecache);
  */
 void truncate_setsize(struct inode *inode, loff_t newsize)
 {
+	loff_t oldsize = inode->i_size;
+
 	i_size_write(inode, newsize);
+	if (newsize > oldsize)
+		pagecache_isize_extended(inode, oldsize, newsize);
 	truncate_pagecache(inode, newsize);
 }
 EXPORT_SYMBOL(truncate_setsize);
 
 /**
+ * pagecache_isize_extended - update pagecache after extension of i_size
+ * @inode:	inode for which i_size was extended
+ * @from:	original inode size
+ * @to:		new inode size
+ *
+ * Handle extension of inode size either caused by extending truncate or by
+ * write starting after current i_size. We mark the page straddling current
+ * i_size RO so that page_mkwrite() is called on the nearest write access to
+ * the page.  This way filesystem can be sure that page_mkwrite() is called on
+ * the page before user writes to the page via mmap after the i_size has been
+ * changed.
+ *
+ * The function must be called after i_size is updated so that page fault
+ * coming after we unlock the page will already see the new i_size.
+ * The function must be called while we still hold i_mutex - this not only
+ * makes sure i_size is stable but also that userspace cannot observe new
+ * i_size value before we are prepared to store mmap writes at new inode size.
+ */
+void pagecache_isize_extended(struct inode *inode, loff_t from, loff_t to)
+{
+	int bsize = 1 << inode->i_blkbits;
+	loff_t rounded_from;
+	struct page *page;
+	pgoff_t index;
+
+	WARN_ON(!mutex_is_locked(&inode->i_mutex));
+	WARN_ON(to > inode->i_size);
+
+	if (from >= to || bsize == PAGE_CACHE_SIZE)
+		return;
+	/* Page straddling @from will not have any hole block created? */
+	rounded_from = round_up(from, bsize);
+	if (to <= rounded_from || !(rounded_from & (PAGE_CACHE_SIZE - 1)))
+		return;
+
+	index = from >> PAGE_CACHE_SHIFT;
+	page = find_lock_page(inode->i_mapping, index);
+	/* Page not cached? Nothing to do */
+	if (!page)
+		return;
+	/*
+	 * See clear_page_dirty_for_io() for details why set_page_dirty()
+	 * is needed.
+	 */
+	if (page_mkclean(page))
+		set_page_dirty(page);
+	unlock_page(page);
+	page_cache_release(page);
+}
+EXPORT_SYMBOL(pagecache_isize_extended);
+
+/**
  * truncate_pagecache_range - unmap and remove pagecache that is hole-punched
  * @inode: inode
  * @lstart: offset of beginning of hole
-- 
2.1.0

