Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759490Ab3EGVT7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 17:19:59 -0400
Received: from mga11.intel.com ([192.55.52.93]:41225 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758922Ab3EGVT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 17:19:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,629,1363158000"; 
   d="scan'208";a="334092148"
Subject: [RFC][PATCH 1/7] defer clearing of page_private() for swap cache pages
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mgorman@suse.de,
        tim.c.chen@linux.intel.com, Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Tue, 07 May 2013 14:19:55 -0700
References: <20130507211954.9815F9D1@viggo.jf.intel.com>
In-Reply-To: <20130507211954.9815F9D1@viggo.jf.intel.com>
Message-Id: <20130507211955.7DF88A4F@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

There are only two callers of swapcache_free() which actually
pass in a non-NULL 'struct page'.  Both of them
(__remove_mapping and delete_from_swap_cache())  create a
temporary on-stack 'swp_entry_t' and set entry.val to
page_private().

They need to do this since __delete_from_swap_cache() does
set_page_private(page, 0) and destroys the information.

However, I'd like to batch a few of these operations on several
pages together in a new version of __remove_mapping(), and I
would prefer not to have to allocate temporary storage for
each page.  The code is pretty ugly, and it's a bit silly
to create these on-stack 'swp_entry_t's when it is so easy to
just keep the information around in 'struct page'.

There should not be any danger in doing this since we are
absolutely on the path of freeing these page.  There is no
turning back, and no other rerferences can be obtained
after it comes out of the radix tree.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 linux.git-davehans/mm/swap_state.c |    4 ++--
 linux.git-davehans/mm/vmscan.c     |    2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/swap_state.c~__delete_from_swap_cache-dont-clear-page-private mm/swap_state.c
--- linux.git/mm/swap_state.c~__delete_from_swap_cache-dont-clear-page-private	2013-05-07 13:48:13.698044473 -0700
+++ linux.git-davehans/mm/swap_state.c	2013-05-07 13:48:13.703044693 -0700
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
--- linux.git/mm/vmscan.c~__delete_from_swap_cache-dont-clear-page-private	2013-05-07 13:48:13.700044561 -0700
+++ linux.git-davehans/mm/vmscan.c	2013-05-07 13:48:13.705044783 -0700
@@ -494,6 +494,8 @@ static int __remove_mapping(struct addre
 		__delete_from_swap_cache(page);
 		spin_unlock_irq(&mapping->tree_lock);
 		swapcache_free(swap, page);
+		set_page_private(page, 0);
+		ClearPageSwapCache(page);
 	} else {
 		void (*freepage)(struct page *);
 
_
