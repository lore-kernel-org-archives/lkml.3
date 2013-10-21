Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025Ab3JUVsZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 17:48:25 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:48773 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964Ab3JUVsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 17:48:22 -0400
Date: Mon, 21 Oct 2013 14:48:17 -0700
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
Subject: [PATCHv2 10/13] mm, thp, tmpfs: huge page support in shmem_fallocate
Message-ID: <20131021214817.GK29870@hippobay.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Try to allocate huge page if the range fits, otherwise,
fall back to small pages.

Signed-off-by: Ning Qu <quning@gmail.com>
---
 mm/shmem.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 1764a29..48b1d84 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2156,8 +2156,11 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
 	inode->i_private = &shmem_falloc;
 	spin_unlock(&inode->i_lock);
 
-	for (index = start; index < end; index++) {
+	i_split_down_read(inode);
+	index = start;
+	while (index < end) {
 		struct page *page;
+		int nr = 1;
 
 		/*
 		 * Good, the fallocate(2) manpage permits EINTR: we may have
@@ -2169,8 +2172,15 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
 			error = -ENOMEM;
 		else {
 			gfp_t gfp = mapping_gfp_mask(inode->i_mapping);
+			int flags = 0;
+
+			if (mapping_can_have_hugepages(inode->i_mapping) &&
+			    ((index == (index & ~HPAGE_CACHE_INDEX_MASK)) &&
+			     (index != (end & ~HPAGE_CACHE_INDEX_MASK))))
+				flags |= AOP_FLAG_TRANSHUGE;
+
 			error = shmem_getpage(inode, index, &page, SGP_FALLOC,
-					      gfp, 0, NULL);
+					      gfp, flags, NULL);
 		}
 		if (error) {
 			/* Remove the !PageUptodate pages we added */
@@ -2180,13 +2190,16 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
 			goto undone;
 		}
 
+		nr = hpagecache_nr_pages(page);
+		if (PageTransHugeCache(page))
+			index &= ~HPAGE_CACHE_INDEX_MASK;
 		/*
 		 * Inform shmem_writepage() how far we have reached.
 		 * No need for lock or barrier: we have the page lock.
 		 */
-		shmem_falloc.next++;
+		shmem_falloc.next += nr;
 		if (!PageUptodate(page))
-			shmem_falloc.nr_falloced++;
+			shmem_falloc.nr_falloced += nr;
 
 		/*
 		 * If !PageUptodate, leave it that way so that freeable pages
@@ -2199,6 +2212,7 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
 		unlock_page(page);
 		page_cache_release(page);
 		cond_resched();
+		index += nr;
 	}
 
 	if (!(mode & FALLOC_FL_KEEP_SIZE) && offset + len > inode->i_size)
@@ -2209,7 +2223,9 @@ undone:
 	inode->i_private = NULL;
 	spin_unlock(&inode->i_lock);
 out:
+	i_split_up_read(inode);
 	mutex_unlock(&inode->i_mutex);
+
 	return error;
 }
 
-- 
1.8.4

