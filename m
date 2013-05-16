Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748Ab3EPUeh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 16:34:37 -0400
Received: from mga11.intel.com ([192.55.52.93]:21559 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752323Ab3EPUee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 16:34:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,686,1363158000"; 
   d="scan'208";a="335308182"
Subject: [RFCv2][PATCH 4/5] break out mapping "freepage" code
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mgorman@suse.de,
        tim.c.chen@linux.intel.com, Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Thu, 16 May 2013 13:34:33 -0700
References: <20130516203427.E3386936@viggo.jf.intel.com>
In-Reply-To: <20130516203427.E3386936@viggo.jf.intel.com>
Message-Id: <20130516203433.CC770268@viggo.jf.intel.com>
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
---

 linux.git-davehans/mm/vmscan.c |   28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff -puN mm/vmscan.c~free_mapping_page mm/vmscan.c
--- linux.git/mm/vmscan.c~free_mapping_page	2013-05-16 13:27:25.520174273 -0700
+++ linux.git-davehans/mm/vmscan.c	2013-05-16 13:27:25.525174493 -0700
@@ -497,6 +497,24 @@ static int __remove_mapping(struct addre
 	return 1;
 }
 
+/*
+ * Release any resources the mapping had tied up in
+ * the page.
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
@@ -510,15 +528,7 @@ static int lock_remove_mapping(struct ad
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
