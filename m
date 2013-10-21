Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab3JUVra (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 17:47:30 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:55935 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572Ab3JUVr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 17:47:27 -0400
Date: Mon, 21 Oct 2013 14:47:22 -0700
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
        Ning Qu <quning@google.com>, Ning Qu <quning@gmail.com>
Subject: [PATCHv2 07/13] mm, thp, tmpfs: initial support for huge page in
 write_begin/write_end in tmpfs
Message-ID: <20131021214722.GH29870@hippobay.mtv.corp.google.com>
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
 mm/shmem.c | 30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 0dd6689..af56731 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1635,8 +1635,20 @@ shmem_write_begin(struct file *file, struct address_space *mapping,
 	struct inode *inode = mapping->host;
 	pgoff_t index = pos >> PAGE_CACHE_SHIFT;
 	gfp_t gfp = mapping_gfp_mask(inode->i_mapping);
+	int ret = 0;
+	int getpage_flags = 0;
+
+	/*
+	 * Do not allocate a huge page in the first huge page range in page
+	 * cache. This way we can avoid most small files overhead.
+	 */
+	if (pos >= HPAGE_PMD_SIZE)
+		getpage_flags |= AOP_FLAG_TRANSHUGE;
 
-	return shmem_getpage(inode, index, pagep, SGP_WRITE, gfp, 0, NULL);
+	ret = shmem_getpage(inode, index, pagep, SGP_WRITE, gfp,
+				getpage_flags, NULL);
+
+	return ret;
 }
 
 static int
@@ -1650,10 +1662,18 @@ shmem_write_end(struct file *file, struct address_space *mapping,
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

