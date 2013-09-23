Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380Ab3IWMLs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 08:11:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:23103 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753968Ab3IWMGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 08:06:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,962,1371106800"; 
   d="scan'208";a="405796251"
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
Subject: [PATCHv6 15/22] thp, mm: naive support of thp in generic_perform_write
Date: Mon, 23 Sep 2013 15:05:43 +0300
Message-Id: <1379937950-8411-16-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1379937950-8411-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1379937950-8411-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For now we still write/read at most PAGE_CACHE_SIZE bytes a time.

This implementation doesn't cover address spaces with backing storage.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 mm/filemap.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 410879a801..38d6856737 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2384,12 +2384,14 @@ static ssize_t generic_perform_write(struct file *file,
 	if (segment_eq(get_fs(), KERNEL_DS))
 		flags |= AOP_FLAG_UNINTERRUPTIBLE;
 
+	i_split_down_read(mapping->host);
 	do {
 		struct page *page;
 		unsigned long offset;	/* Offset into pagecache page */
 		unsigned long bytes;	/* Bytes to write to page */
 		size_t copied;		/* Bytes copied from user */
 		void *fsdata;
+		int subpage_nr = 0;
 
 		offset = (pos & (PAGE_CACHE_SIZE - 1));
 		bytes = min_t(unsigned long, PAGE_CACHE_SIZE - offset,
@@ -2419,8 +2421,14 @@ again:
 		if (mapping_writably_mapped(mapping))
 			flush_dcache_page(page);
 
+		if (PageTransHuge(page)) {
+			off_t huge_offset = pos & ~HPAGE_PMD_MASK;
+			subpage_nr = huge_offset >> PAGE_CACHE_SHIFT;
+		}
+
 		pagefault_disable();
-		copied = iov_iter_copy_from_user_atomic(page, i, offset, bytes);
+		copied = iov_iter_copy_from_user_atomic(page + subpage_nr, i,
+				offset, bytes);
 		pagefault_enable();
 		flush_dcache_page(page);
 
@@ -2457,6 +2465,7 @@ again:
 		}
 	} while (iov_iter_count(i));
 
+	i_split_up_read(mapping->host);
 	return written ? written : status;
 }
 
-- 
1.8.4.rc3

