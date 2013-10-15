Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757923Ab3JOAMi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 20:12:38 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:63369 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756343Ab3JOAMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 20:12:33 -0400
Date: Mon, 14 Oct 2013 17:12:28 -0700
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
Subject: [PATCH 04/12] mm, thp, tmpfs: split huge page when moving from page
 cache to swap
Message-ID: <20131015001228.GE3432@hippobay.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

in shmem_writepage, we have to split the huge page when moving pages
from page cache to swap because we don't support huge page in swap
yet.

Signed-off-by: Ning Qu <quning@gmail.com>
---
 mm/shmem.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 8fe17dd..68a0e1d 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -898,6 +898,13 @@ static int shmem_writepage(struct page *page, struct writeback_control *wbc)
 	swp_entry_t swap;
 	pgoff_t index;
 
+	/* TODO: we have to break the huge page at this point,
+	 * since we have no idea how to recover a huge page from
+	 * swap.
+	 */
+	if (PageTransCompound(page))
+		split_huge_page(compound_trans_head(page));
+
 	BUG_ON(!PageLocked(page));
 	mapping = page->mapping;
 	index = page->index;
@@ -946,7 +953,7 @@ static int shmem_writepage(struct page *page, struct writeback_control *wbc)
 			if (shmem_falloc)
 				goto redirty;
 		}
-		clear_highpage(page);
+		clear_pagecache_page(page);
 		flush_dcache_page(page);
 		SetPageUptodate(page);
 	}
-- 
1.8.4


