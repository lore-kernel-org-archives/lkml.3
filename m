Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321Ab3HDCQN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 22:16:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:54847 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753550Ab3HDCOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 22:14:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,810,1367996400"; 
   d="scan'208";a="357029461"
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
Subject: [PATCH 16/23] thp, mm: handle transhuge pages in do_generic_file_read()
Date: Sun,  4 Aug 2013 05:17:18 +0300
Message-Id: <1375582645-29274-17-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375582645-29274-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1375582645-29274-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

If a transhuge page is already in page cache (up to date and not
readahead) we go usual path: read from relevant subpage (head or tail).

If page is not cached (sparse file in ramfs case) and the mapping can
have hugepage we try allocate a new one and read it.

If a page is not up to date or in readahead, we have to move 'page' to
head page of the compound page, since it represents state of whole
transhuge page. We will switch back to relevant subpage when page is
ready to be read ('page_ok' label).

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 mm/filemap.c | 57 +++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 55 insertions(+), 2 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index c31d296..ed65af5 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1175,8 +1175,28 @@ find_page:
 					ra, filp,
 					index, last_index - index);
 			page = find_get_page(mapping, index);
-			if (unlikely(page == NULL))
-				goto no_cached_page;
+			if (unlikely(page == NULL)) {
+				if (mapping_can_have_hugepages(mapping))
+					goto no_cached_page_thp;
+				else
+					goto no_cached_page;
+			}
+		}
+		if (PageTransCompound(page)) {
+			struct page *head = compound_trans_head(page);
+
+			if (!PageReadahead(head) && PageUptodate(page))
+				goto page_ok;
+
+			/*
+			 * Switch 'page' to head page. That's needed to handle
+			 * readahead or make page uptodate.
+			 * It will be switched back to the right tail page at
+			 * the begining 'page_ok'.
+			 */
+			page_cache_get(head);
+			page_cache_release(page);
+			page = head;
 		}
 		if (PageReadahead(page)) {
 			page_cache_async_readahead(mapping,
@@ -1198,6 +1218,18 @@ find_page:
 			unlock_page(page);
 		}
 page_ok:
+		/* Switch back to relevant tail page, if needed */
+		if (PageTransCompoundCache(page) && !PageTransTail(page)) {
+			int off = index & HPAGE_CACHE_INDEX_MASK;
+			if (off){
+				page_cache_get(page + off);
+				page_cache_release(page);
+				page += off;
+			}
+		}
+
+		VM_BUG_ON(page->index != index);
+
 		/*
 		 * i_size must be checked after we know the page is Uptodate.
 		 *
@@ -1329,6 +1361,27 @@ readpage_error:
 		page_cache_release(page);
 		goto out;
 
+no_cached_page_thp:
+		page = alloc_pages(mapping_gfp_mask(mapping) | __GFP_COLD,
+				HPAGE_PMD_ORDER);
+		if (!page) {
+			count_vm_event(THP_READ_ALLOC_FAILED);
+			goto no_cached_page;
+		}
+		count_vm_event(THP_READ_ALLOC);
+
+		error = add_to_page_cache_lru(page, mapping,
+				index & ~HPAGE_CACHE_INDEX_MASK, GFP_KERNEL);
+		if (!error)
+			goto readpage;
+
+		page_cache_release(page);
+		if (error != -EEXIST && error != -ENOSPC) {
+			desc->error = error;
+			goto out;
+		}
+
+		/* Fallback to small page */
 no_cached_page:
 		/*
 		 * Ok, it wasn't cached, so we need to create a new
-- 
1.8.3.2

