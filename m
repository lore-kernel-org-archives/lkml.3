Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053Ab3JOANA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 20:13:00 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:56722 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757614Ab3JOAM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 20:12:58 -0400
Date: Mon, 14 Oct 2013 17:12:53 -0700
From: Ning Qu <quning@google.com>
To: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Hugh Dickins <hughd@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Hillf Danton <dhillf@gmail.com>, Dave Hansen <dave@sr71.net>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ning Qu <quning@google.com>
Subject: [PATCH 06/12] mm, thp, tmpfs: initial support for huge page in
 write_begin/write_end in tmpfs
Message-ID: <20131015001253.GG3432@hippobay.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For now we try to grab a huge cache page if the minimum requirements have been
satisfied.

Signed-off-by: Ning Qu <quning@gmail.com>
---
 mm/shmem.c | 31 ++++++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 2fc450d..0a423a9 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1640,8 +1640,21 @@ shmem_write_begin(struct file *file, struct address_space *mapping,
 	struct inode *inode = mapping->host;
 	pgoff_t index = pos >> PAGE_CACHE_SHIFT;
 	gfp_t gfp = mapping_gfp_mask(inode->i_mapping);
+	int ret = 0;
+	int getpage_flags = 0;
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE_PAGECACHE
+	/*
+	 * Do not allocate a huge page in the first huge page range in page
+	 * cache. This way we can avoid most small files overhead.
+	 */
+	if (pos >= HPAGE_PMD_SIZE)
+		getpage_flags |= AOP_FLAG_TRANSHUGE;
+#endif
+	ret = shmem_getpage(inode, index, pagep, SGP_WRITE, gfp,
+				getpage_flags, NULL);
 
-	return shmem_getpage(inode, index, pagep, SGP_WRITE, gfp, 0, NULL);
+	return ret;
 }
 
 static int
@@ -1655,10 +1668,18 @@ shmem_write_end(struct file *file, struct address_space *mapping,
 		i_size_write(inode, pos + copied);
 
 	if (!PageUptodate(page)) {
-		if (copied < PAGE_CACHE_SIZE) {
-			unsigned from = pos & (PAGE_CACHE_SIZE - 1);
-			zero_user_segments(page, 0, from,
-					from + copied, PAGE_CACHE_SIZE);
+		if (copied < len) {
+			unsigned from;
+			if (PageTransHugeCache(page)) {
+				from = pos & ~HPAGE_PMD_MASK;
+				zero_huge_user(page, 0, from);
+				zero_huge_user(page, from + copied,
+					       HPAGE_PMD_SIZE);
+			} else {
+				from = pos & ~PAGE_CACHE_MASK;
+				zero_user_segments(page, 0, from,
+						from + copied, PAGE_CACHE_SIZE);
+			}
 		}
 		SetPageUptodate(page);
 	}
-- 
1.8.4


