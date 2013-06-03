Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759821Ab3FCUCw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 16:02:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:33840 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757359Ab3FCUCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 16:02:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,794,1363158000"; 
   d="scan'208";a="323681449"
Subject: [v5][PATCH 4/6] mm: vmscan: break out mapping "freepage" code
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mgorman@suse.de,
        tim.c.chen@linux.intel.com, minchan@kernel.org,
        Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Mon, 03 Jun 2013 13:02:07 -0700
References: <20130603200202.7F5FDE07@viggo.jf.intel.com>
In-Reply-To: <20130603200202.7F5FDE07@viggo.jf.intel.com>
Message-Id: <20130603200207.7402753F@viggo.jf.intel.com>
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
Acked-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Minchan Kim <minchan@kernel.org>
---

 linux.git-davehans/mm/vmscan.c |   27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff -puN mm/vmscan.c~free_mapping_page mm/vmscan.c
--- linux.git/mm/vmscan.c~free_mapping_page	2013-06-03 12:41:31.155740124 -0700
+++ linux.git-davehans/mm/vmscan.c	2013-06-03 12:41:31.159740301 -0700
@@ -496,6 +496,23 @@ static int __remove_mapping(struct addre
 	return 1;
 }
 
+/*
+ * Release any resources the mapping had tied up in the page.
+ */
+static void mapping_release_page(struct address_space *mapping,
+				 struct page *page)
+{
+	if (PageSwapCache(page)) {
+		swapcache_free_page_entry(page);
+	} else {
+		void (*freepage)(struct page *);
+		freepage = mapping->a_ops->freepage;
+		mem_cgroup_uncharge_cache_page(page);
+		if (freepage != NULL)
+			freepage(page);
+	}
+}
+
 static int lock_remove_mapping(struct address_space *mapping, struct page *page)
 {
 	int ret;
@@ -509,15 +526,7 @@ static int lock_remove_mapping(struct ad
 	if (!ret)
 		return 0;
 
-	if (PageSwapCache(page)) {
-		swapcache_free_page_entry(page);
-	} else {
-		void (*freepage)(struct page *);
-		freepage = mapping->a_ops->freepage;
-		mem_cgroup_uncharge_cache_page(page);
-		if (freepage != NULL)
-			freepage(page);
-	}
+	mapping_release_page(mapping, page);
 	return ret;
 }
 
_
