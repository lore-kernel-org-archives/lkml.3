Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759776Ab3EGVVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 17:21:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:55589 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759513Ab3EGVUB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 17:20:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,629,1363158000"; 
   d="scan'208";a="333403573"
Subject: [RFC][PATCH 4/7] break out mapping "freepage" code
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mgorman@suse.de,
        tim.c.chen@linux.intel.com, Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Tue, 07 May 2013 14:20:00 -0700
References: <20130507211954.9815F9D1@viggo.jf.intel.com>
In-Reply-To: <20130507211954.9815F9D1@viggo.jf.intel.com>
Message-Id: <20130507212000.59652B69@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

__remove_mapping() only deals with pages with mappings, meaning
page cache and swap cache.

At this point, the page has been removed from the mapping's radix
tree, and we need to ensure that any fs-specific (or swap-
specific) resources are freed up.

We will be using this function from a second location in a
following patch.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 linux.git-davehans/mm/vmscan.c |   33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff -puN mm/vmscan.c~free_mapping_page mm/vmscan.c
--- linux.git/mm/vmscan.c~free_mapping_page	2013-05-07 13:48:14.520080867 -0700
+++ linux.git-davehans/mm/vmscan.c	2013-05-07 13:48:14.524081045 -0700
@@ -497,6 +497,27 @@ static int __remove_mapping_nolock(struc
 	return 1;
 }
 
+/*
+ * maybe this isnt named the best... it just releases
+ * the mapping's reference to the page.  It frees the
+ * page from *the* *mapping* but not necessarily back
+ * in to the allocator
+ */
+static void free_mapping_page(struct address_space *mapping, struct page *page)
+{
+	if (PageSwapCache(page)) {
+		swapcache_free_page_entry(page);
+		set_page_private(page, 0);
+		ClearPageSwapCache(page);
+	} else {
+		void (*freepage)(struct page *);
+		freepage = mapping->a_ops->freepage;
+		mem_cgroup_uncharge_cache_page(page);
+		if (freepage != NULL)
+			freepage(page);
+	}
+}
+
 static int __remove_mapping(struct address_space *mapping, struct page *page)
 {
 	int ret;
@@ -510,17 +531,7 @@ static int __remove_mapping(struct addre
 	if (!ret)
 		return 0;
 
-	if (PageSwapCache(page)) {
-		swapcache_free_page_entry(page);
-		set_page_private(page, 0);
-		ClearPageSwapCache(page);
-	} else {
-		void (*freepage)(struct page *);
-		freepage = mapping->a_ops->freepage;
-		mem_cgroup_uncharge_cache_page(page);
-		if (freepage != NULL)
-			freepage(page);
-	}
+	free_mapping_page(mapping, page);
 	return ret;
 }
 
_
