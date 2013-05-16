Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022Ab3EPUff (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 16:35:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:61512 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921Ab3EPUe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 16:34:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,686,1363158000"; 
   d="scan'208";a="338517492"
Subject: [RFCv2][PATCH 1/5] defer clearing of page_private() for swap cache pages
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mgorman@suse.de,
        tim.c.chen@linux.intel.com, Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Thu, 16 May 2013 13:34:28 -0700
References: <20130516203427.E3386936@viggo.jf.intel.com>
In-Reply-To: <20130516203427.E3386936@viggo.jf.intel.com>
Message-Id: <20130516203428.EEB32399@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

This patch defers the destruction of swapcache-specific data in
'struct page'.  This simplifies the code because we do not have
to keep extra copies of the data during the removal of a page
from the swap cache.

There are only two callers of swapcache_free() which actually
pass in a non-NULL 'struct page'.  Both of them (__remove_mapping
and delete_from_swap_cache())  create a temporary on-stack
'swp_entry_t' and set entry.val to page_private().

They need to do this since __delete_from_swap_cache() does
set_page_private(page, 0) and destroys the information.

However, I'd like to batch a few of these operations on several
pages together in a new version of __remove_mapping(), and I
would prefer not to have to allocate temporary storage for each
page.  The code is pretty ugly, and it's a bit silly to create
these on-stack 'swp_entry_t's when it is so easy to just keep the
information around in 'struct page'.

There should not be any danger in doing this since we are
absolutely on the path of freeing these page.  There is no
turning back, and no other rerferences can be obtained after it
comes out of the radix tree.

Note: This patch is separate from the next one since it
introduces the behavior change.  I've seen issues with this patch
by itself in various forms and I think having it separate like
this aids bisection.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Mel Gorman <mgorman@suse.de>
---

 linux.git-davehans/mm/swap_state.c |    4 ++--
 linux.git-davehans/mm/vmscan.c     |    2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/swap_state.c~__delete_from_swap_cache-dont-clear-page-private mm/swap_state.c
--- linux.git/mm/swap_state.c~__delete_from_swap_cache-dont-clear-page-private	2013-05-16 13:27:24.686137407 -0700
+++ linux.git-davehans/mm/swap_state.c	2013-05-16 13:27:24.691137629 -0700
@@ -146,8 +146,6 @@ void __delete_from_swap_cache(struct pag
 	entry.val = page_private(page);
 	address_space = swap_address_space(entry);
 	radix_tree_delete(&address_space->page_tree, page_private(page));
-	set_page_private(page, 0);
-	ClearPageSwapCache(page);
 	address_space->nrpages--;
 	__dec_zone_page_state(page, NR_FILE_PAGES);
 	INC_CACHE_INFO(del_total);
@@ -224,6 +222,8 @@ void delete_from_swap_cache(struct page
 	spin_unlock_irq(&address_space->tree_lock);
 
 	swapcache_free(entry, page);
+	set_page_private(page, 0);
+	ClearPageSwapCache(page);
 	page_cache_release(page);
 }
 
diff -puN mm/vmscan.c~__delete_from_swap_cache-dont-clear-page-private mm/vmscan.c
--- linux.git/mm/vmscan.c~__delete_from_swap_cache-dont-clear-page-private	2013-05-16 13:27:24.687137451 -0700
+++ linux.git-davehans/mm/vmscan.c	2013-05-16 13:27:24.692137673 -0700
@@ -494,6 +494,8 @@ static int __remove_mapping(struct addre
 		__delete_from_swap_cache(page);
 		spin_unlock_irq(&mapping->tree_lock);
 		swapcache_free(swap, page);
+		set_page_private(page, 0);
+		ClearPageSwapCache(page);
 	} else {
 		void (*freepage)(struct page *);
 
_
