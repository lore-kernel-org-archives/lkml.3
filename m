Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137Ab3IWMKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 08:10:40 -0400
Received: from mga14.intel.com ([143.182.124.37]:43998 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753970Ab3IWMGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 08:06:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,962,1371106800"; 
   d="scan'208";a="298196481"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, Dave Hansen <dave@sr71.net>,
        Ning Qu <quning@google.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCHv6 17/22] thp, libfs: initial thp support
Date: Mon, 23 Sep 2013 15:05:45 +0300
Message-Id: <1379937950-8411-18-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1379937950-8411-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1379937950-8411-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

simple_readpage() and simple_write_end() are modified to handle huge
pages.

simple_thp_write_begin() is introduced to allocate huge pages on write.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 fs/libfs.c              | 58 +++++++++++++++++++++++++++++++++++++++++++++----
 include/linux/fs.h      |  7 ++++++
 include/linux/pagemap.h |  8 +++++++
 3 files changed, 69 insertions(+), 4 deletions(-)

diff --git a/fs/libfs.c b/fs/libfs.c
index 3a3a9b53bf..807f66098e 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -364,7 +364,7 @@ EXPORT_SYMBOL(simple_setattr);
 
 int simple_readpage(struct file *file, struct page *page)
 {
-	clear_highpage(page);
+	clear_pagecache_page(page);
 	flush_dcache_page(page);
 	SetPageUptodate(page);
 	unlock_page(page);
@@ -424,9 +424,14 @@ int simple_write_end(struct file *file, struct address_space *mapping,
 
 	/* zero the stale part of the page if we did a short copy */
 	if (copied < len) {
-		unsigned from = pos & (PAGE_CACHE_SIZE - 1);
-
-		zero_user(page, from + copied, len - copied);
+		unsigned from;
+		if (PageTransHugeCache(page)) {
+			from = pos & ~HPAGE_PMD_MASK;
+			zero_huge_user(page, from + copied, len - copied);
+		} else {
+			from = pos & ~PAGE_CACHE_MASK;
+			zero_user(page, from + copied, len - copied);
+		}
 	}
 
 	if (!PageUptodate(page))
@@ -445,6 +450,51 @@ int simple_write_end(struct file *file, struct address_space *mapping,
 	return copied;
 }
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE_PAGECACHE
+int simple_thp_write_begin(struct file *file, struct address_space *mapping,
+		loff_t pos, unsigned len, unsigned flags,
+		struct page **pagep, void **fsdata)
+{
+	struct page *page = NULL;
+	pgoff_t index;
+
+	index = pos >> PAGE_CACHE_SHIFT;
+
+	/*
+	 * Do not allocate a huge page in the first huge page range in page
+	 * cache. This way we can avoid most small files overhead.
+	 */
+	if (mapping_can_have_hugepages(mapping) &&
+			 pos >= HPAGE_PMD_SIZE) {
+		page = grab_cache_page_write_begin(mapping,
+				index & ~HPAGE_CACHE_INDEX_MASK,
+				flags | AOP_FLAG_TRANSHUGE);
+		/* fallback to small page */
+		if (!page) {
+			unsigned long offset;
+			offset = pos & ~PAGE_CACHE_MASK;
+			/* adjust the len to not cross small page boundary */
+			len = min_t(unsigned long,
+					len, PAGE_CACHE_SIZE - offset);
+		}
+		BUG_ON(page && !PageTransHuge(page));
+	}
+	if (!page)
+		return simple_write_begin(file, mapping, pos, len, flags,
+				pagep, fsdata);
+
+	*pagep = page;
+
+	if (!PageUptodate(page) && len != HPAGE_PMD_SIZE) {
+		unsigned from = pos & ~HPAGE_PMD_MASK;
+
+		zero_huge_user_segment(page, 0, from);
+		zero_huge_user_segment(page, from + len, HPAGE_PMD_SIZE);
+	}
+	return 0;
+}
+#endif
+
 /*
  * the inodes created here are not hashed. If you use iunique to generate
  * unique inode values later for this filesystem, then you must take care
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 42ccdeddd9..71a5ce4472 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2566,6 +2566,13 @@ extern int simple_write_begin(struct file *file, struct address_space *mapping,
 extern int simple_write_end(struct file *file, struct address_space *mapping,
 			loff_t pos, unsigned len, unsigned copied,
 			struct page *page, void *fsdata);
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE_PAGECACHE
+extern int simple_thp_write_begin(struct file *file,
+		struct address_space *mapping, loff_t pos, unsigned len,
+		unsigned flags,	struct page **pagep, void **fsdata);
+#else
+#define simple_thp_write_begin simple_write_begin
+#endif
 
 extern struct dentry *simple_lookup(struct inode *, struct dentry *, unsigned int flags);
 extern ssize_t generic_read_dir(struct file *, char __user *, size_t, loff_t *);
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index ad60dcc50e..967aadbc5e 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -572,4 +572,12 @@ static inline int add_to_page_cache(struct page *page,
 	return error;
 }
 
+static inline void clear_pagecache_page(struct page *page)
+{
+	if (PageTransHuge(page))
+		zero_huge_user(page, 0, HPAGE_PMD_SIZE);
+	else
+		clear_highpage(page);
+}
+
 #endif /* _LINUX_PAGEMAP_H */
-- 
1.8.4.rc3

