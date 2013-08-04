Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab3HDCPb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 22:15:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:56722 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753530Ab3HDCOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 22:14:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,810,1367996400"; 
   d="scan'208";a="357029435"
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
        Ning Qu <quning@google.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH 14/23] thp, mm: naive support of thp in generic_perform_write
Date: Sun,  4 Aug 2013 05:17:16 +0300
Message-Id: <1375582645-29274-15-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375582645-29274-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1375582645-29274-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

For now we still write/read at most PAGE_CACHE_SIZE bytes a time.

This implementation doesn't cover address spaces with backing storage.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 mm/filemap.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index b17ebb9..066bbff 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2382,6 +2382,7 @@ static ssize_t generic_perform_write(struct file *file,
 		unsigned long bytes;	/* Bytes to write to page */
 		size_t copied;		/* Bytes copied from user */
 		void *fsdata;
+		int subpage_nr = 0;
 
 		offset = (pos & (PAGE_CACHE_SIZE - 1));
 		bytes = min_t(unsigned long, PAGE_CACHE_SIZE - offset,
@@ -2411,8 +2412,14 @@ again:
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
 
-- 
1.8.3.2

